#!/usr/bin/env python3
"""Safe in-place editing model for World 2 compressed screen views."""

from __future__ import annotations

from copy import deepcopy
from dataclasses import dataclass
import json
from pathlib import Path
from typing import Any

import sys


SCRIPTS = Path(__file__).resolve().parent.parent
if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))

from scripts.validation.world2 import world2_streaming
from scripts.authoring.level_studio_model import _write_json_atomic
from scripts.authoring.world2_repacker import repack_document

from scripts.authoring.world2_route_model import (
    DIRECTION_STEPS,
    ROUTE_SCREEN_HEIGHT,
    ROUTE_SCREEN_WIDTH,
    WORLD2_ROUTE_NAMES,
    World2RouteAnnotation,
    World2RouteGeometry,
    World2RoutePlacement,
    build_world2_routes,
)

CANONICAL_PATH = Path("data/world2/compressed_screens.json")
DEFAULT_ATLAS_COLUMNS = 8


@dataclass(frozen=True)
class World2Cell:
    metatile: int
    token_offset: int | None
    token_kind: str
    enemy_state: int | None = None
    token_cell_index: int = 0

    @property
    def editable(self) -> bool:
        return self.token_kind in ("literal", "rle")


@dataclass(frozen=True)
class ScreenCellEdit:
    selector_ids: tuple[int, ...]
    x: int
    y: int
    before: World2Cell
    after: World2Cell


@dataclass(frozen=True)
class World2AtlasGeometry:
    """Logical metatile geometry for the scrollable all-screen atlas."""

    selector_count: int
    columns: int
    rows: int
    screen_width: int
    screen_height: int
    gutter: int = 1
    header: int = 1

    @property
    def slot_width(self) -> int:
        return self.screen_width + self.gutter

    @property
    def slot_height(self) -> int:
        return self.header + self.screen_height + self.gutter

    @property
    def width(self) -> int:
        return self.columns * self.slot_width - self.gutter

    @property
    def height(self) -> int:
        return self.rows * self.slot_height - self.gutter

    def origin(self, selector_id: int) -> tuple[int, int]:
        if not 0 <= selector_id < self.selector_count:
            raise IndexError("World 2 atlas selector is outside the layout")
        return (
            (selector_id % self.columns) * self.slot_width,
            (selector_id // self.columns) * self.slot_height + self.header,
        )

    def locate(self, x: int, y: int) -> tuple[int, int, int] | None:
        """Map an atlas metatile coordinate to selector and local cell."""

        if x < 0 or y < 0:
            return None
        column, local_x = divmod(x, self.slot_width)
        row, slot_y = divmod(y, self.slot_height)
        local_y = slot_y - self.header
        if (
            column >= self.columns
            or row >= self.rows
            or local_x >= self.screen_width
            or not 0 <= local_y < self.screen_height
        ):
            return None
        selector_id = row * self.columns + column
        if selector_id >= self.selector_count:
            return None
        return selector_id, local_x, local_y


class World2ScreenDocument:
    """One global token pool exposed through its 119 overlapping selectors."""

    def __init__(self, document: dict[str, Any], path: Path | None = None) -> None:
        self.document = deepcopy(document)
        self.path = path
        self._undo: list[tuple[ScreenCellEdit, ...]] = []
        self._redo: list[tuple[ScreenCellEdit, ...]] = []
        self._saved_payload = self.encode()
        self._saved_document = deepcopy(self.document)
        self._region_cache: bytes | None = self._saved_payload[
            self.selector_count * 2:
        ]
        self._screens: dict[int, tuple[tuple[World2Cell, ...], ...]] = {}
        self._oriented_screens: dict[
            tuple[int, int], tuple[tuple[World2Cell, ...], ...]
        ] = {}
        self._route_coordinates: dict[
            tuple[int, int], dict[tuple[int, int], tuple[int, int]]
        ] = {}
        self._logical_screens: list[list[list[World2Cell]]] | None = None
        self._reindex_tokens()

    @classmethod
    def load(cls, path: Path) -> "World2ScreenDocument":
        try:
            document = json.loads(path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as exc:
            raise ValueError(f"cannot load World 2 screen document {path}: {exc}") from exc
        return cls(document, path)

    @property
    def selector_count(self) -> int:
        return len(self.document["selectors"])

    @property
    def dirty(self) -> bool:
        return self.encode() != self._saved_payload

    @property
    def can_undo(self) -> bool:
        return bool(self._undo)

    @property
    def can_redo(self) -> bool:
        return bool(self._redo)

    def _reindex_tokens(self) -> None:
        self._token_indexes: dict[int, int] = {}
        for index, text in enumerate(self.document["tokens"]):
            offset, _raw = world2_streaming.parse_token_text(str(text))
            if offset in self._token_indexes:
                raise ValueError(f"duplicate World 2 token offset ${offset:04X}")
            self._token_indexes[offset] = index

    def encode(self) -> bytes:
        return world2_streaming.encode_authoring(self.document)

    def selector(self, selector_id: int) -> dict[str, Any]:
        selectors = self.document["selectors"]
        if not 0 <= selector_id < len(selectors):
            raise IndexError(
                f"World 2 selector {selector_id} is outside 0-{len(selectors) - 1}"
            )
        selector = selectors[selector_id]
        if int(selector["id"]) != selector_id:
            raise ValueError("World 2 selector ids are not contiguous")
        return selector

    def _region(self) -> bytes:
        if self._region_cache is None:
            payload = self.encode()
            pointer_size = self.selector_count * 2
            self._region_cache = payload[pointer_size:]
        return self._region_cache

    def _decode_cells(
        self,
        selector_id: int,
        group_count: int,
        minimum_cells: int,
    ) -> tuple[tuple[World2Cell, ...], ...]:
        selector = self.selector(selector_id)
        region_address = world2_streaming.number(self.document["region_address"])
        start = world2_streaming.number(selector["address"]) - region_address
        errors, decoded = world2_streaming.decode_screen(
            self._region(),
            start,
            group_count,
            minimum_cells,
        )
        if errors:
            raise ValueError(
                f"selector {selector_id}: " + "; ".join(errors)
            )
        rows: list[tuple[World2Cell, ...]] = []
        for row in decoded.rows:
            cells: list[World2Cell] = []
            for token in row.tokens:
                if token.kind == "literal":
                    cells.append(
                        World2Cell(token.value, token.offset, "literal")
                    )
                elif token.kind == "spawn":
                    cells.append(
                        World2Cell(0, token.offset, "spawn", token.value - 0xD0)
                    )
                elif token.kind == "row_end":
                    cells.extend(
                        World2Cell(0, None, "padding", token_cell_index=index)
                        for index in range(max(0, 16 - len(cells)))
                    )
                elif token.kind == "rle" and token.repeated_literal is not None:
                    cells.extend(
                        World2Cell(
                            token.repeated_literal,
                            token.offset,
                            "rle",
                            token_cell_index=index,
                        )
                        for index in range((token.value & 0x0F) + 1)
                    )
                else:
                    raise ValueError(
                        f"selector {selector_id} contains unsupported {token.kind} token"
                    )
            rows.append(tuple(cells))
        return tuple(rows)

    def screen(self, selector_id: int) -> tuple[tuple[World2Cell, ...], ...]:
        if self._logical_screens is not None:
            self.selector(selector_id)
            return tuple(
                tuple(row) for row in self._logical_screens[selector_id]
            )
        cached = self._screens.get(selector_id)
        if cached is not None:
            return cached
        result = self._decode_cells(
            selector_id,
            int(self.document["rows_per_screen"]),
            int(self.document["minimum_cells_per_row"]),
        )
        self._screens[selector_id] = result
        return result

    def oriented_screen(
        self, selector_id: int, direction: int
    ) -> tuple[tuple[World2Cell, ...], ...]:
        """Decode one selector in the same orientation used by the runtime."""

        if direction not in DIRECTION_STEPS:
            raise ValueError("World 2 route direction is outside 0-3")
        key = (selector_id, direction)
        cached = self._oriented_screens.get(key)
        if cached is not None:
            return cached
        if direction in (0, 3):
            columns = self._decode_cells(
                selector_id,
                ROUTE_SCREEN_WIDTH,
                ROUTE_SCREEN_HEIGHT,
            )
            columns = tuple(column[:ROUTE_SCREEN_HEIGHT] for column in columns)
            if direction == 3:
                columns = tuple(reversed(columns))
            result = tuple(
                tuple(columns[x][y] for x in range(ROUTE_SCREEN_WIDTH))
                for y in range(ROUTE_SCREEN_HEIGHT)
            )
        else:
            rows = self._decode_cells(
                selector_id,
                ROUTE_SCREEN_HEIGHT,
                ROUTE_SCREEN_WIDTH,
            )
            result = tuple(row[:ROUTE_SCREEN_WIDTH] for row in rows)
            if direction == 1:
                result = tuple(reversed(result))
        self._oriented_screens[key] = result
        return result

    def raw_coordinate(
        self,
        selector_id: int,
        direction: int,
        x: int,
        y: int,
    ) -> tuple[int, int]:
        """Map a route-view cell back to the canonical editable screen view."""

        key = (selector_id, direction)
        rows = self.oriented_screen(selector_id, direction)
        if not 0 <= y < len(rows) or not 0 <= x < len(rows[y]):
            raise IndexError(f"World 2 cell ({x}, {y}) is outside route view")
        target = rows[y][x]
        if target.token_offset is None:
            raise ValueError("World 2 padding cells cannot be edited")
        coordinates = self._route_coordinates.get(key)
        if coordinates is None:
            canonical = self._decode_cells(
                selector_id,
                int(self.document["rows_per_screen"]),
                int(self.document["minimum_cells_per_row"]),
            )
            canonical_by_token = {
                (cell.token_offset, cell.token_cell_index, cell.token_kind): (
                    raw_x,
                    raw_y,
                )
                for raw_y, row in enumerate(canonical)
                for raw_x, cell in enumerate(row)
                if cell.token_offset is not None
            }
            coordinates = {
                (route_x, route_y): canonical_by_token[
                    (cell.token_offset, cell.token_cell_index, cell.token_kind)
                ]
                for route_y, row in enumerate(rows)
                for route_x, cell in enumerate(row)
                if cell.token_offset is not None
                and (
                    cell.token_offset,
                    cell.token_cell_index,
                    cell.token_kind,
                )
                in canonical_by_token
            }
            self._route_coordinates[key] = coordinates
        coordinate = coordinates.get((x, y))
        if coordinate is not None:
            return coordinate
        raise ValueError("World 2 route cell has no canonical editable coordinate")

    def screen_size(self, selector_id: int) -> tuple[int, int]:
        rows = self.screen(selector_id)
        return max((len(row) for row in rows), default=0), len(rows)

    def atlas_geometry(
        self, columns: int = DEFAULT_ATLAS_COLUMNS
    ) -> World2AtlasGeometry:
        if columns <= 0:
            raise ValueError("World 2 atlas requires at least one column")
        sizes = tuple(
            self.screen_size(selector_id)
            for selector_id in range(self.selector_count)
        )
        return World2AtlasGeometry(
            selector_count=self.selector_count,
            columns=columns,
            rows=(self.selector_count + columns - 1) // columns,
            screen_width=max(width for width, _height in sizes),
            screen_height=max(height for _width, height in sizes),
        )

    def cell(self, selector_id: int, x: int, y: int) -> World2Cell:
        rows = self.screen(selector_id)
        if not 0 <= y < len(rows) or not 0 <= x < len(rows[y]):
            raise IndexError(f"World 2 cell ({x}, {y}) is outside selector view")
        return rows[y][x]

    def paint(self, selector_id: int, x: int, y: int, metatile: int) -> int:
        """Edit one logical cell and repack all overlapping screen views."""

        if not 0 <= metatile < 0xD0:
            raise ValueError("World 2 metatile is outside $00-$CF")
        cell = self.cell(selector_id, x, y)
        if not cell.editable:
            raise ValueError(
                f"World 2 {cell.token_kind} cells are not background metatiles"
            )
        if cell.metatile == metatile:
            return 0
        self._ensure_logical_screens()
        if self._logical_screens is None:
            raise ValueError("World 2 logical screen initialization failed")
        after = World2Cell(metatile, None, "literal")
        target = self._logical_screens[selector_id]
        selector_ids = tuple(
            index
            for index, screen in enumerate(self._logical_screens)
            if screen == target
        )
        edit = ScreenCellEdit(selector_ids, x, y, cell, after)
        for index in selector_ids:
            self._logical_screens[index][y][x] = after
        try:
            self._repack()
        except (ValueError, KeyError, TypeError):
            for index in selector_ids:
                self._logical_screens[index][y][x] = cell
            raise
        self._undo.append((edit,))
        self._redo.clear()
        return len(selector_ids)

    def edit_spawn(self, selector_id: int, x: int, y: int, state: int) -> int:
        """Change one embedded spawn while preserving its screen-cell role."""

        if not 0 <= state <= 0x0E:
            raise ValueError("World 2 physical enemy state is outside $00-$0E")
        cell = self.cell(selector_id, x, y)
        if cell.token_kind != "spawn":
            raise ValueError("World 2 spawn edits require an existing spawn cell")
        if cell.enemy_state == state:
            return 0
        self._ensure_logical_screens()
        if self._logical_screens is None:
            raise ValueError("World 2 logical screen initialization failed")
        after = World2Cell(0, None, "spawn", state)
        target = self._logical_screens[selector_id]
        selector_ids = tuple(
            index
            for index, screen in enumerate(self._logical_screens)
            if screen == target
        )
        edit = ScreenCellEdit(selector_ids, x, y, cell, after)
        for index in selector_ids:
            self._logical_screens[index][y][x] = after
        try:
            self._repack()
        except (ValueError, KeyError, TypeError):
            for index in selector_ids:
                self._logical_screens[index][y][x] = cell
            raise
        self._undo.append((edit,))
        self._redo.clear()
        return len(selector_ids)

    def move_spawn(
        self,
        source_selector: int,
        source_x: int,
        source_y: int,
        target_selector: int,
        target_x: int,
        target_y: int,
    ) -> int:
        """Move one embedded spawn onto an editable empty-background cell."""

        source = self.cell(source_selector, source_x, source_y)
        if source.token_kind != "spawn":
            raise ValueError("World 2 spawn movement requires an existing spawn")
        target = self.cell(target_selector, target_x, target_y)
        if not target.editable:
            raise ValueError("World 2 spawn target must be a background cell")
        self._ensure_logical_screens()
        if self._logical_screens is None:
            raise ValueError("World 2 logical screen initialization failed")
        source_view = self._logical_screens[source_selector]
        target_view = self._logical_screens[target_selector]
        source_ids = tuple(
            index
            for index, screen in enumerate(self._logical_screens)
            if screen == source_view
        )
        target_ids = tuple(
            index
            for index, screen in enumerate(self._logical_screens)
            if screen == target_view
        )
        edits = (
            ScreenCellEdit(
                source_ids,
                source_x,
                source_y,
                source,
                World2Cell(0, None, "literal"),
            ),
            ScreenCellEdit(
                target_ids,
                target_x,
                target_y,
                target,
                World2Cell(0, None, "spawn", source.enemy_state),
            ),
        )
        for edit in edits:
            self._apply_edit(edit, True)
        try:
            self._repack()
        except (ValueError, KeyError, TypeError):
            for edit in reversed(edits):
                self._apply_edit(edit, False)
            raise
        self._undo.append(edits)
        self._redo.clear()
        return len(set(source_ids) | set(target_ids))

    def _ensure_logical_screens(self) -> None:
        if self._logical_screens is not None:
            return
        self._logical_screens = [
            [list(row) for row in self.screen(selector_id)]
            for selector_id in range(self.selector_count)
        ]

    def _repack(self) -> None:
        if self._logical_screens is None:
            raise ValueError("World 2 logical screens are not initialized")
        self.document = repack_document(self.document, self._logical_screens)
        self._reindex_tokens()
        self._region_cache = None
        self._screens.clear()
        self._oriented_screens.clear()
        self._route_coordinates.clear()

    def _apply_edit(self, edit: ScreenCellEdit, use_after: bool) -> None:
        self._ensure_logical_screens()
        if self._logical_screens is None:
            raise ValueError("World 2 logical screens are not initialized")
        for selector_id in edit.selector_ids:
            self._logical_screens[selector_id][edit.y][edit.x] = (
                edit.after if use_after else edit.before
            )

    def undo(self) -> bool:
        if not self._undo:
            return False
        edits = self._undo.pop()
        for edit in reversed(edits):
            self._apply_edit(edit, False)
        self._redo.append(edits)
        if not self._undo:
            self.document = deepcopy(self._saved_document)
            self._logical_screens = None
            self._reindex_tokens()
            self._region_cache = self._saved_payload[self.selector_count * 2:]
            self._screens.clear()
            self._oriented_screens.clear()
            self._route_coordinates.clear()
        else:
            self._repack()
        return True

    def redo(self) -> bool:
        if not self._redo:
            return False
        edits = self._redo.pop()
        for edit in edits:
            self._apply_edit(edit, True)
        self._undo.append(edits)
        self._repack()
        return True

    def save(self, path: Path | None = None) -> Path:
        destination = path or self.path
        if destination is None:
            raise ValueError("World 2 screen document has no save path")
        payload = self.encode()
        _write_json_atomic(destination, self.document)
        self.path = destination
        self._saved_payload = payload
        self._saved_document = deepcopy(self.document)
        self._undo.clear()
        self._redo.clear()
        return destination


def workspace_path(root: Path, profile: str) -> Path:
    return root / profile / "levels" / "world2.json"


def initialize_workspace(
    project_root: Path,
    root: Path,
    profile: str,
) -> Path | None:
    destination = workspace_path(root, profile)
    if destination.exists():
        return None
    try:
        document = json.loads(
            (project_root / CANONICAL_PATH).read_text(encoding="utf-8")
        )
    except (OSError, json.JSONDecodeError) as exc:
        raise ValueError(f"cannot initialize World 2 workspace: {exc}") from exc
    World2ScreenDocument(document).save(destination)
    return destination
