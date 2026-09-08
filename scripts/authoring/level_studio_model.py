#!/usr/bin/env python3
"""Editable model for Doraemon's World 1 and World 3 map hierarchies."""

from __future__ import annotations

from copy import deepcopy
from dataclasses import dataclass
import json
import os
from pathlib import Path
import tempfile
from typing import Any, Iterable

import sys


SCRIPTS = Path(__file__).resolve().parent.parent
if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))

from scripts.validation.reconstruction import world_data


SUPPORTED_PROFILES = ("original", "rev_a")
CANONICAL_WORLDS = {
    "world1": Path("data/world1/hierarchical_world.json"),
    "world3": Path("data/world3/hierarchical_world.json"),
}


@dataclass(frozen=True)
class TileCell:
    """One rendered CHR tile and the small block that supplies its palette."""

    tile: int
    palette: int
    properties: int
    small_block: int


@dataclass(frozen=True)
class CellEdit:
    map_id: str
    x: int
    y: int
    before: int
    after: int


@dataclass(frozen=True)
class HierarchyEdit:
    kind: str
    block: int
    before: tuple[int, ...]
    after: tuple[int, ...]


def _number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def _map(document: dict[str, Any], map_id: str) -> dict[str, Any]:
    matches = [entry for entry in document["maps"] if entry["id"] == map_id]
    if len(matches) != 1:
        raise ValueError(f"expected one map named {map_id!r}")
    return matches[0]


def _row_values(map_spec: dict[str, Any], y: int) -> list[int]:
    height = int(map_spec["height"])
    if not 0 <= y < height:
        raise IndexError(f"map row {y} is outside 0-{height - 1}")
    row = map_spec["rows"][y]
    if not isinstance(row, str):
        raise ValueError(f"map row {y} is not text")
    try:
        values = [int(cell, 16) for cell in row.split()]
    except ValueError as exc:
        raise ValueError(f"map row {y} contains invalid hexadecimal data") from exc
    width = int(map_spec["width"])
    if len(values) != width or any(not 0 <= value <= 0xFF for value in values):
        raise ValueError(f"map row {y} is not a {width}-byte row")
    return values


def _write_json_atomic(path: Path, document: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    text = json.dumps(document, indent=2) + "\n"
    temporary_name: str | None = None
    try:
        with tempfile.NamedTemporaryFile(
            "w",
            encoding="utf-8",
            newline="\n",
            dir=path.parent,
            prefix=f".{path.name}.",
            suffix=".tmp",
            delete=False,
        ) as output:
            output.write(text)
            output.flush()
            os.fsync(output.fileno())
            temporary_name = output.name
        os.replace(temporary_name, path)
    finally:
        if temporary_name is not None:
            Path(temporary_name).unlink(missing_ok=True)


class HierarchicalWorldDocument:
    """Mutable, validated view of one fixed-size hierarchical world payload."""

    def __init__(
        self,
        document: dict[str, Any],
        path: Path | None = None,
    ) -> None:
        self.document = deepcopy(document)
        self.path = path
        self._undo: list[tuple[CellEdit, ...]] = []
        self._redo: list[tuple[CellEdit, ...]] = []
        self._hierarchy_undo: list[HierarchyEdit] = []
        self._hierarchy_redo: list[HierarchyEdit] = []
        self._saved_payload = self.encode()

    @classmethod
    def load(cls, path: Path) -> "HierarchicalWorldDocument":
        try:
            document = json.loads(path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as exc:
            raise ValueError(f"cannot load level document {path}: {exc}") from exc
        return cls(document, path)

    @property
    def world_id(self) -> str:
        return str(self.document["id"])

    @property
    def map_ids(self) -> tuple[str, ...]:
        return tuple(str(entry["id"]) for entry in self.document["maps"])

    @property
    def dirty(self) -> bool:
        return self.encode() != self._saved_payload

    @property
    def can_undo(self) -> bool:
        return bool(self._undo)

    @property
    def can_redo(self) -> bool:
        return bool(self._redo)

    def encode(self) -> bytes:
        return world_data.encode_authoring(self.document)

    def map_size(self, map_id: str) -> tuple[int, int]:
        map_spec = _map(self.document, map_id)
        return int(map_spec["width"]), int(map_spec["height"])

    def map_rows(self, map_id: str) -> tuple[tuple[int, ...], ...]:
        map_spec = _map(self.document, map_id)
        return tuple(
            tuple(_row_values(map_spec, y))
            for y in range(int(map_spec["height"]))
        )

    def cell(self, map_id: str, x: int, y: int) -> int:
        map_spec = _map(self.document, map_id)
        width = int(map_spec["width"])
        if not 0 <= x < width:
            raise IndexError(f"map column {x} is outside 0-{width - 1}")
        return _row_values(map_spec, y)[x]

    def _set_cell(self, edit: CellEdit, use_after: bool) -> None:
        map_spec = _map(self.document, edit.map_id)
        row = _row_values(map_spec, edit.y)
        row[edit.x] = edit.after if use_after else edit.before
        map_spec["rows"][edit.y] = " ".join(f"{value:02X}" for value in row)

    def paint(self, map_id: str, x: int, y: int, block: int) -> bool:
        return self.paint_many(map_id, ((x, y, block),))

    def paint_many(
        self,
        map_id: str,
        cells: Iterable[tuple[int, int, int]],
    ) -> bool:
        """Apply one undoable brush stroke after validating every coordinate."""

        map_spec = _map(self.document, map_id)
        width, height = int(map_spec["width"]), int(map_spec["height"])
        requested: dict[tuple[int, int], int] = {}
        for x, y, block in cells:
            if not 0 <= x < width or not 0 <= y < height:
                raise IndexError(
                    f"map coordinate ({x}, {y}) is outside {width}x{height}"
                )
            if not 0 <= block <= 0xFF:
                raise ValueError(f"big-block id {block} is outside byte range")
            requested[(x, y)] = block

        edits = tuple(
            CellEdit(map_id, x, y, self.cell(map_id, x, y), block)
            for (x, y), block in requested.items()
            if self.cell(map_id, x, y) != block
        )
        if not edits:
            return False
        for edit in edits:
            self._set_cell(edit, True)
        try:
            self.encode()
        except (ValueError, KeyError, TypeError):
            for edit in reversed(edits):
                self._set_cell(edit, False)
            raise
        self._undo.append(edits)
        self._redo.clear()
        return True

    def undo(self) -> bool:
        if not self._undo:
            return False
        edits = self._undo.pop()
        for edit in reversed(edits):
            self._set_cell(edit, False)
        self._redo.append(edits)
        return True

    def redo(self) -> bool:
        if not self._redo:
            return False
        edits = self._redo.pop()
        for edit in edits:
            self._set_cell(edit, True)
        self._undo.append(edits)
        return True

    def used_big_blocks(self, map_id: str) -> tuple[int, ...]:
        return tuple(sorted({cell for row in self.map_rows(map_id) for cell in row}))

    def small_block(self, block: int) -> tuple[tuple[int, ...], int, int]:
        small_entries = self.document["small_blocks"]["entries"]
        attributes = self.document["attributes"]["entries"]
        if not 0 <= block < len(small_entries) or block >= len(attributes):
            raise IndexError(f"small-block id {block} is outside the table")
        tiles = tuple(_number(value) for value in small_entries[block]["tiles"])
        if len(tiles) != 4:
            raise ValueError(f"small block {block:02X} is not 2x2")
        attribute = attributes[block]
        return (
            tiles,
            _number(attribute["palette"]),
            _number(attribute["properties"]),
        )

    def big_block(self, block: int) -> tuple[int, ...]:
        entries = self.document["big_blocks"]["entries"]
        if not 0 <= block < len(entries):
            raise IndexError(f"big-block id {block} is outside the table")
        values = tuple(_number(value) for value in entries[block]["small_blocks"])
        if len(values) != 4:
            raise ValueError(f"big block {block:02X} is not 2x2")
        return values

    def _set_hierarchy_edit(self, edit: HierarchyEdit, use_after: bool) -> None:
        values = edit.after if use_after else edit.before
        if edit.kind == "small":
            tiles, palette, properties = values[:4], values[4], values[5]
            self.document["small_blocks"]["entries"][edit.block]["tiles"] = [
                f"0x{value:02X}" for value in tiles
            ]
            attribute = self.document["attributes"]["entries"][edit.block]
            attribute["palette"] = palette
            attribute["properties"] = f"0x{properties:02X}"
            return
        if edit.kind == "big":
            self.document["big_blocks"]["entries"][edit.block]["small_blocks"] = [
                f"0x{value:02X}" for value in values
            ]
            return
        raise ValueError(f"unknown hierarchy edit kind: {edit.kind}")

    def edit_small_block(
        self,
        block: int,
        tiles: Iterable[int],
        palette: int,
        properties: int,
    ) -> bool:
        tile_values = tuple(tiles)
        if len(tile_values) != 4 or any(
            not 0 <= value <= 0xFF for value in tile_values
        ):
            raise ValueError("small block requires four byte-sized CHR tiles")
        if not 0 <= palette <= 3:
            raise ValueError("small-block palette must be in 0..3")
        if not 0 <= properties <= 0x3F:
            raise ValueError("small-block properties must fit the upper six bits")
        old_tiles, old_palette, old_properties = self.small_block(block)
        edit = HierarchyEdit(
            "small",
            block,
            (*old_tiles, old_palette, old_properties),
            (*tile_values, palette, properties),
        )
        if edit.before == edit.after:
            return False
        self._set_hierarchy_edit(edit, True)
        try:
            self.encode()
        except (KeyError, TypeError, ValueError):
            self._set_hierarchy_edit(edit, False)
            raise
        self._hierarchy_undo.append(edit)
        self._hierarchy_redo.clear()
        return True

    def edit_big_block(self, block: int, small_blocks: Iterable[int]) -> bool:
        values = tuple(small_blocks)
        if len(values) != 4 or any(not 0 <= value <= 0xFF for value in values):
            raise ValueError("big block requires four byte-sized small-block ids")
        edit = HierarchyEdit("big", block, self.big_block(block), values)
        if edit.before == edit.after:
            return False
        self._set_hierarchy_edit(edit, True)
        try:
            self.encode()
        except (KeyError, TypeError, ValueError):
            self._set_hierarchy_edit(edit, False)
            raise
        self._hierarchy_undo.append(edit)
        self._hierarchy_redo.clear()
        return True

    def undo_hierarchy(self) -> bool:
        if not self._hierarchy_undo:
            return False
        edit = self._hierarchy_undo.pop()
        self._set_hierarchy_edit(edit, False)
        self._hierarchy_redo.append(edit)
        return True

    def redo_hierarchy(self) -> bool:
        if not self._hierarchy_redo:
            return False
        edit = self._hierarchy_redo.pop()
        self._set_hierarchy_edit(edit, True)
        self._hierarchy_undo.append(edit)
        return True

    def expanded_big_block(self, block: int) -> tuple[tuple[TileCell, ...], ...]:
        """Expand a 2x2 big block into its 4x4 background CHR-tile grid."""

        big_entries = self.document["big_blocks"]["entries"]
        small_entries = self.document["small_blocks"]["entries"]
        attributes = self.document["attributes"]["entries"]
        if not 0 <= block < len(big_entries):
            raise IndexError(f"big-block id {block} is outside the table")
        small_ids = [_number(value) for value in big_entries[block]["small_blocks"]]
        if len(small_ids) != 4:
            raise ValueError(f"big block {block:02X} is not 2x2")

        rows: list[list[TileCell]] = [[] for _ in range(4)]
        for big_y in range(2):
            for big_x in range(2):
                small_id = small_ids[big_y * 2 + big_x]
                if not 0 <= small_id < len(small_entries):
                    raise ValueError(
                        f"big block {block:02X} references missing small block "
                        f"{small_id:02X}"
                    )
                tiles = [_number(value) for value in small_entries[small_id]["tiles"]]
                if len(tiles) != 4:
                    raise ValueError(f"small block {small_id:02X} is not 2x2")
                attribute = attributes[small_id]
                palette = _number(attribute["palette"])
                properties = _number(attribute["properties"])
                for tile_y in range(2):
                    target = rows[big_y * 2 + tile_y]
                    target.extend(
                        TileCell(
                            tile=tiles[tile_y * 2 + tile_x],
                            palette=palette,
                            properties=properties,
                            small_block=small_id,
                        )
                        for tile_x in range(2)
                    )
        return tuple(tuple(row) for row in rows)

    def save(self, path: Path | None = None) -> Path:
        destination = path or self.path
        if destination is None:
            raise ValueError("level document has no save path")
        payload = self.encode()
        _write_json_atomic(destination, self.document)
        self.path = destination
        self._saved_payload = payload
        return destination


class LevelWorkspace:
    """Profile-scoped editable copies; canonical source remains untouched."""

    def __init__(self, project_root: Path, root: Path, profile: str) -> None:
        if profile not in SUPPORTED_PROFILES:
            raise ValueError(f"unsupported revision profile: {profile}")
        self.project_root = project_root.resolve()
        self.root = root.resolve()
        self.profile = profile

    @property
    def directory(self) -> Path:
        return self.root / self.profile / "levels"

    def path_for(self, world_id: str) -> Path:
        if world_id not in CANONICAL_WORLDS:
            raise ValueError(f"unsupported hierarchical world: {world_id}")
        return self.directory / f"{world_id}.json"

    def initialize(self) -> tuple[Path, ...]:
        created: list[Path] = []
        for world_id, relative in CANONICAL_WORLDS.items():
            destination = self.path_for(world_id)
            if destination.exists():
                continue
            source = self.project_root / relative
            try:
                document = json.loads(source.read_text(encoding="utf-8"))
            except (OSError, json.JSONDecodeError) as exc:
                raise ValueError(f"cannot initialize {world_id} from {source}: {exc}") from exc
            HierarchicalWorldDocument(document).save(destination)
            created.append(destination)
        return tuple(created)

    def load(self, world_id: str) -> HierarchicalWorldDocument:
        path = self.path_for(world_id)
        if not path.exists():
            raise ValueError(
                f"workspace is not initialized: missing {path}; "
                "run the level workspace initializer"
            )
        document = HierarchicalWorldDocument.load(path)
        if document.world_id != world_id:
            raise ValueError(
                f"workspace file {path} contains {document.world_id!r}, "
                f"expected {world_id!r}"
            )
        return document

    def validate(self) -> dict[str, int]:
        return {
            world_id: len(self.load(world_id).encode())
            for world_id in CANONICAL_WORLDS
        }
