from __future__ import annotations

import json
from pathlib import Path
import sys
import tempfile
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))

from scripts.authoring.world2_level_model import (
    CANONICAL_PATH,
    DIRECTION_STEPS,
    WORLD2_ROUTE_NAMES,
    World2AtlasGeometry,
    World2ScreenDocument,
    build_world2_routes,
    initialize_workspace,
    workspace_path,
)


class World2LevelModelTests(unittest.TestCase):
    def canonical_routes(self):
        return build_world2_routes(
            json.loads(
                (ROOT / "data/world2/stage_sequence.json").read_text(
                    encoding="utf-8"
                )
            ),
            json.loads(
                (ROOT / "data/world2/stage_branches.json").read_text(
                    encoding="utf-8"
                )
            ),
            json.loads(
                (ROOT / "data/world2/palettes.json").read_text(
                    encoding="utf-8"
                )
            ),
        )

    def fixture(self, tokens: list[str], row: str) -> dict[str, object]:
        region_size = 8
        covered = sum(2 if ":R:" in token else 1 for token in tokens)
        tokens = list(tokens) + [
            f"{offset:04X}:L:{'A9' if offset == region_size - 1 else '00'}"
            for offset in range(covered, region_size)
        ]
        return {
            "schema_version": 1,
            "format": "world2-compressed-screens",
            "pointer_table_address": "0x9000",
            "region_address": "0x9100",
            "region_size": region_size,
            "rows_per_screen": 1,
            "minimum_cells_per_row": 4,
            "payload_crc32": "unused-by-editor",
            "selectors": [{
                "id": 0,
                "address": "0x9100",
                "alias_of": None,
                "rows": [row],
            }],
            "tokens": tokens,
        }

    def test_decodes_literal_and_rle_cells(self) -> None:
        model = World2ScreenDocument(
            self.fixture(["0000:L:02", "0001:R:F2:03"], "0000-0003:4")
        )
        row = model.screen(0)[0]
        self.assertEqual([cell.metatile for cell in row], [2, 3, 3, 3])
        self.assertEqual([cell.token_kind for cell in row], ["literal", "rle", "rle", "rle"])

    def test_literal_edit_is_lossless_and_undoable(self) -> None:
        model = World2ScreenDocument(
            self.fixture(["0000:L:02", "0001:R:F2:03"], "0000-0003:4")
        )
        self.assertEqual(model.paint(0, 0, 0, 0x44), 1)
        self.assertEqual(model.screen(0)[0][0].metatile, 0x44)
        self.assertTrue(model.dirty)
        self.assertTrue(model.undo())
        self.assertEqual(model.screen(0)[0][0].metatile, 2)
        self.assertFalse(model.dirty)
        self.assertTrue(model.redo())
        self.assertEqual(model.screen(0)[0][0].metatile, 0x44)

    def test_repacker_allows_one_cell_inside_an_existing_run(self) -> None:
        model = World2ScreenDocument(
            self.fixture(["0000:L:02", "0001:R:F2:03"], "0000-0003:4")
        )
        self.assertEqual(model.paint(0, 2, 0, 0x55), 1)
        self.assertEqual(
            [cell.metatile for cell in model.screen(0)[0]],
            [2, 3, 0x55, 3],
        )
        self.assertEqual(len(model.encode()), 10)

    def test_spawn_and_row_end_padding_are_read_only(self) -> None:
        model = World2ScreenDocument(
            self.fixture(["0000:S:D4", "0001:E"], "0000-0002:16")
        )
        row = model.screen(0)[0]
        self.assertEqual(len(row), 16)
        self.assertEqual(row[0].enemy_state, 4)
        self.assertFalse(row[0].editable)
        self.assertEqual(row[1].token_kind, "padding")
        with self.assertRaisesRegex(ValueError, "not background metatiles"):
            model.paint(0, 0, 0, 1)
        with self.assertRaisesRegex(ValueError, "not background metatiles"):
            model.paint(0, 1, 0, 1)

    def test_spawn_state_edit_is_lossless_and_undoable(self) -> None:
        document = World2ScreenDocument.load(ROOT / CANONICAL_PATH)
        location = next(
            (selector, x, y, cell)
            for selector in range(document.selector_count)
            for y, row in enumerate(document.screen(selector))
            for x, cell in enumerate(row)
            if cell.token_kind == "spawn"
        )
        selector, x, y, cell = location
        replacement = (int(cell.enemy_state) + 1) % 0x0F
        before = document.encode()
        affected = document.edit_spawn(selector, x, y, replacement)
        self.assertGreaterEqual(affected, 1)
        self.assertEqual(
            document.cell(selector, x, y).enemy_state,
            replacement,
        )
        self.assertNotEqual(document.encode(), before)
        self.assertTrue(document.undo())
        self.assertEqual(document.encode(), before)

    def test_spawn_can_move_between_atlas_cells_and_undo(self) -> None:
        document = World2ScreenDocument.load(ROOT / CANONICAL_PATH)
        source = next(
            (selector, x, y, cell)
            for selector in range(document.selector_count)
            for y, row in enumerate(document.screen(selector))
            for x, cell in enumerate(row)
            if cell.token_kind == "spawn"
        )
        source_selector, source_x, source_y, source_cell = source
        target = next(
            (x, y)
            for y, row in enumerate(document.screen(source_selector))
            for x, cell in enumerate(row)
            if cell.editable and (x, y) != (source_x, source_y)
        )
        before = document.encode()
        affected = document.move_spawn(
            source_selector,
            source_x,
            source_y,
            source_selector,
            *target,
        )
        self.assertGreaterEqual(affected, 1)
        self.assertNotEqual(document.cell(source_selector, source_x, source_y).token_kind, "spawn")
        self.assertEqual(
            document.cell(source_selector, *target).enemy_state,
            source_cell.enemy_state,
        )
        self.assertTrue(document.undo())
        self.assertEqual(document.encode(), before)
        self.assertTrue(document.redo())
        self.assertEqual(document.cell(source_selector, *target).token_kind, "spawn")

    def test_spawn_edit_rejects_background_and_internal_states(self) -> None:
        document = World2ScreenDocument.load(ROOT / CANONICAL_PATH)
        literal = next(
            (selector, x, y)
            for selector in range(document.selector_count)
            for y, row in enumerate(document.screen(selector))
            for x, cell in enumerate(row)
            if cell.token_kind in ("literal", "rle")
        )
        with self.assertRaisesRegex(ValueError, "existing spawn"):
            document.edit_spawn(*literal, 0)
        spawn = next(
            (selector, x, y)
            for selector in range(document.selector_count)
            for y, row in enumerate(document.screen(selector))
            for x, cell in enumerate(row)
            if cell.token_kind == "spawn"
        )
        with self.assertRaisesRegex(ValueError, "physical enemy"):
            document.edit_spawn(*spawn, 0x0F)

    def test_atomic_save_and_reload(self) -> None:
        model = World2ScreenDocument(
            self.fixture(["0000:L:02", "0001:R:F2:03"], "0000-0003:4")
        )
        model.paint(0, 0, 0, 9)
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "world2.json"
            model.save(path)
            self.assertFalse(model.dirty)
            self.assertEqual(World2ScreenDocument.load(path).cell(0, 0, 0).metatile, 9)

    def test_checked_in_pool_exposes_all_runtime_selectors(self) -> None:
        model = World2ScreenDocument.load(
            ROOT / "data/world2/compressed_screens.json"
        )
        self.assertEqual(model.selector_count, 119)
        self.assertEqual(len(model.encode()), 16669)
        self.assertEqual(len(model.screen(0)), 16)
        self.assertEqual(model.screen_size(4)[0], 18)

    def test_atlas_geometry_maps_cells_and_rejects_gutters(self) -> None:
        geometry = World2AtlasGeometry(
            selector_count=10,
            columns=4,
            rows=3,
            screen_width=18,
            screen_height=16,
        )
        self.assertEqual(geometry.origin(0), (0, 1))
        self.assertEqual(geometry.origin(5), (19, 19))
        self.assertEqual(geometry.locate(20, 21), (5, 1, 2))
        self.assertIsNone(geometry.locate(18, 2))
        self.assertIsNone(geometry.locate(20, 18))
        self.assertIsNone(geometry.locate(40, 38))

    def test_canonical_atlas_covers_every_selector_view(self) -> None:
        model = World2ScreenDocument.load(ROOT / CANONICAL_PATH)
        geometry = model.atlas_geometry()
        self.assertEqual(geometry.selector_count, 119)
        self.assertEqual((geometry.columns, geometry.rows), (8, 15))
        self.assertGreaterEqual(geometry.screen_width, 18)
        for selector_id in range(model.selector_count):
            origin_x, origin_y = geometry.origin(selector_id)
            self.assertEqual(
                geometry.locate(origin_x, origin_y),
                (selector_id, 0, 0),
            )

    def test_directed_routes_cover_all_selectors_in_five_views(self) -> None:
        routes = self.canonical_routes()
        self.assertEqual(tuple(routes), WORLD2_ROUTE_NAMES)
        self.assertEqual(routes["Part 1"].placements[0].sequence_offset, 0)
        self.assertEqual(routes["Part 2"].placements[0].sequence_offset, 37)
        self.assertEqual(routes["Part 3"].placements[0].sequence_offset, 92)
        self.assertEqual(
            {
                placement.selector_id
                for route in routes.values()
                for placement in route.placements
            },
            set(range(119)),
        )
        self.assertEqual(
            {annotation.text for annotation in routes["Part 2"].annotations},
            {
                "Part 2A entrance",
                "Part 2A exit",
                "Part 2B entrance",
                "Part 2B exit",
            },
        )

    def test_route_screens_use_runtime_orientation(self) -> None:
        model = World2ScreenDocument.load(ROOT / CANONICAL_PATH)
        routes = self.canonical_routes()
        for route in routes.values():
            for placement in route.visible_placements():
                rows = model.oriented_screen(
                    placement.selector_id,
                    placement.direction,
                )
                self.assertEqual(len(rows), 15)
                self.assertTrue(all(len(row) == 16 for row in rows))

        main_spans = (("Part 1", 37), ("Part 2", 92), ("Part 3", 134))
        for route_name, end in main_spans:
            placements = tuple(
                item for item in routes[route_name].placements
                if item.sequence_offset < end
            )
            for previous, current in zip(placements, placements[1:]):
                if current.direction == previous.direction:
                    continue
                self.assertEqual(
                    (
                        current.screen_x - previous.screen_x,
                        current.screen_y - previous.screen_y,
                    ),
                    DIRECTION_STEPS[current.direction],
                )

        raw = model.screen(0)
        oriented = model.oriented_screen(0, 0)
        for y in range(15):
            for x in range(16):
                self.assertEqual(oriented[y][x], raw[x][y])

    def test_route_cells_map_back_to_canonical_edit_coordinates(self) -> None:
        model = World2ScreenDocument.load(ROOT / CANONICAL_PATH)
        placements = {
            placement.direction: placement
            for route in self.canonical_routes().values()
            for placement in route.placements
        }
        for direction in range(3):
            placement = placements[direction]
            rows = model.oriented_screen(placement.selector_id, direction)
            x, y, cell = next(
                (x, y, cell)
                for y, row in enumerate(rows)
                for x, cell in enumerate(row)
                if cell.token_offset is not None
            )
            raw_x, raw_y = model.raw_coordinate(
                placement.selector_id,
                direction,
                x,
                y,
            )
            raw = model.cell(placement.selector_id, raw_x, raw_y)
            self.assertEqual(
                (raw.token_offset, raw.token_cell_index, raw.token_kind),
                (cell.token_offset, cell.token_cell_index, cell.token_kind),
            )

    def test_canonical_rle_cell_edit_preserves_exact_alias_group(self) -> None:
        model = World2ScreenDocument.load(
            ROOT / "data/world2/compressed_screens.json"
        )
        original = model.encode()
        x, y, cell = next(
            (x, y, cell)
            for y, row in enumerate(model.screen(0))
            for x, cell in enumerate(row)
            if cell.token_kind == "rle"
        )
        replacement = (cell.metatile + 1) % 0xD0
        self.assertEqual(model.paint(0, x, y, replacement), 2)
        self.assertEqual(model.cell(0, x, y).metatile, replacement)
        self.assertEqual(model.cell(50, x, y).metatile, replacement)
        self.assertEqual(len(model.encode()), len(original))
        model.undo()
        self.assertEqual(model.encode(), original)

    def test_workspace_initialization_does_not_overwrite_existing_copy(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "project/data/world2/compressed_screens.json"
            source.parent.mkdir(parents=True)
            source.write_text(
                json.dumps(
                    self.fixture(
                        ["0000:L:02", "0001:R:F2:03"], "0000-0003:4"
                    )
                ),
                encoding="utf-8",
            )
            workspace = root / "content"
            created = initialize_workspace(root / "project", workspace, "original")
            self.assertEqual(created, workspace_path(workspace, "original"))
            model = World2ScreenDocument.load(created)
            model.paint(0, 0, 0, 9)
            model.save()
            self.assertIsNone(
                initialize_workspace(root / "project", workspace, "original")
            )
            self.assertEqual(
                World2ScreenDocument.load(created).cell(0, 0, 0).metatile,
                9,
            )


if __name__ == "__main__":
    unittest.main()
