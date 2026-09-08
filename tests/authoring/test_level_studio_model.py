from __future__ import annotations

from copy import deepcopy
import json
from pathlib import Path
import sys
import tempfile
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))

from scripts.authoring.level_studio_model import (
    HierarchicalWorldDocument,
    LevelWorkspace,
)


class LevelStudioModelTests(unittest.TestCase):
    def fixture(self) -> dict[str, object]:
        document: dict[str, object] = {
            "schema_version": 1,
            "format": "doraemon-hierarchical-world",
            "id": "world1",
            "bank": 0,
            "address": "0x9000",
            "end_address": "0x9013",
            "payload_crc32": "unused-by-editor",
            "attributes": {
                "address": "0x9000",
                "count": 2,
                "entries": [
                    {"id": 0, "palette": 1, "properties": "0x02"},
                    {"id": 1, "palette": 3, "properties": "0x04"},
                ],
            },
            "small_blocks": {
                "address": "0x9002",
                "count": 2,
                "width": 2,
                "height": 2,
                "entries": [
                    {"id": 0, "tiles": ["0x00", "0x01", "0x02", "0x03"]},
                    {"id": 1, "tiles": ["0x04", "0x05", "0x06", "0x07"]},
                ],
            },
            "big_blocks": {
                "address": "0x900A",
                "count": 2,
                "width": 2,
                "height": 2,
                "entries": [
                    {"id": 0, "small_blocks": ["0x00"] * 4},
                    {
                        "id": 1,
                        "small_blocks": ["0x00", "0x01", "0x01", "0x00"],
                    },
                ],
            },
            "maps": [
                {
                    "id": "fixture",
                    "address": "0x9012",
                    "width": 2,
                    "height": 1,
                    "rows": ["00 01"],
                }
            ],
        }
        return document

    def test_paint_undo_redo_and_dirty_state(self) -> None:
        model = HierarchicalWorldDocument(self.fixture())
        self.assertFalse(model.dirty)
        self.assertTrue(model.paint("fixture", 0, 0, 1))
        self.assertEqual(model.cell("fixture", 0, 0), 1)
        self.assertTrue(model.dirty)
        self.assertTrue(model.undo())
        self.assertEqual(model.cell("fixture", 0, 0), 0)
        self.assertFalse(model.dirty)
        self.assertTrue(model.redo())
        self.assertEqual(model.cell("fixture", 0, 0), 1)

    def test_brush_stroke_is_one_undo_transaction(self) -> None:
        document = self.fixture()
        document["maps"][0]["rows"] = ["00 00"]
        model = HierarchicalWorldDocument(document)
        model.paint_many("fixture", ((0, 0, 1), (1, 0, 1)))
        self.assertEqual(model.map_rows("fixture"), ((1, 1),))
        model.undo()
        self.assertEqual(model.map_rows("fixture"), ((0, 0),))

    def test_rejects_invalid_coordinates_without_partial_edit(self) -> None:
        model = HierarchicalWorldDocument(self.fixture())
        before = model.encode()
        with self.assertRaisesRegex(IndexError, "outside 2x1"):
            model.paint_many("fixture", ((0, 0, 1), (2, 0, 1)))
        self.assertEqual(model.encode(), before)

    def test_expands_big_block_with_small_block_attributes(self) -> None:
        model = HierarchicalWorldDocument(self.fixture())
        grid = model.expanded_big_block(1)
        self.assertEqual(tuple(len(row) for row in grid), (4, 4, 4, 4))
        self.assertEqual([cell.tile for cell in grid[0]], [0, 1, 4, 5])
        self.assertEqual([cell.tile for cell in grid[2]], [4, 5, 0, 1])
        self.assertEqual([cell.palette for cell in grid[0]], [1, 1, 3, 3])
        self.assertEqual(grid[0][2].properties, 4)

    def test_atomic_save_updates_saved_baseline(self) -> None:
        model = HierarchicalWorldDocument(self.fixture())
        model.paint("fixture", 0, 0, 1)
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "world.json"
            model.save(path)
            self.assertFalse(model.dirty)
            loaded = HierarchicalWorldDocument.load(path)
            self.assertEqual(loaded.cell("fixture", 0, 0), 1)

    def test_workspace_initialization_preserves_existing_edits(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            project = Path(directory) / "project"
            canonical = project / "data/world1/hierarchical_world.json"
            canonical.parent.mkdir(parents=True)
            canonical.write_text(json.dumps(self.fixture()), encoding="utf-8")
            world3 = deepcopy(self.fixture())
            world3["id"] = "world3"
            world3_path = project / "data/world3/hierarchical_world.json"
            world3_path.parent.mkdir(parents=True)
            world3_path.write_text(json.dumps(world3), encoding="utf-8")
            workspace = LevelWorkspace(project, Path(directory) / "content", "rev_a")
            self.assertEqual(len(workspace.initialize()), 2)
            model = workspace.load("world1")
            model.paint("fixture", 0, 0, 1)
            model.save()
            self.assertEqual(workspace.initialize(), ())
            self.assertEqual(workspace.load("world1").cell("fixture", 0, 0), 1)
            self.assertEqual(workspace.validate(), {"world1": 20, "world3": 20})

    def test_hierarchy_edits_have_an_independent_undo_history(self) -> None:
        document = HierarchicalWorldDocument.load(
            ROOT / "data/world1/hierarchical_world.json"
        )
        old_small = document.small_block(0)
        old_big = document.big_block(0)
        replacement_tile = (old_small[0][0] + 1) & 0xFF
        self.assertTrue(
            document.edit_small_block(
                0,
                (replacement_tile, *old_small[0][1:]),
                old_small[1],
                old_small[2],
            )
        )
        self.assertTrue(document.edit_big_block(0, (1, *old_big[1:])))
        self.assertTrue(document.undo_hierarchy())
        self.assertEqual(document.big_block(0), old_big)
        self.assertTrue(document.undo_hierarchy())
        self.assertEqual(document.small_block(0), old_small)
        self.assertFalse(document.can_undo)
        self.assertTrue(document.redo_hierarchy())
        self.assertEqual(document.small_block(0)[0][0], replacement_tile)

    def test_hierarchy_edit_rejects_invalid_domains_without_mutation(self) -> None:
        document = HierarchicalWorldDocument.load(
            ROOT / "data/world3/hierarchical_world.json"
        )
        before = document.encode()
        with self.assertRaisesRegex(ValueError, "four byte-sized"):
            document.edit_small_block(0, (1, 2, 3), 0, 0)
        with self.assertRaisesRegex(ValueError, "palette"):
            document.edit_small_block(0, (1, 2, 3, 4), 4, 0)
        with self.assertRaisesRegex(ValueError, "upper six bits"):
            document.edit_small_block(0, (1, 2, 3, 4), 0, 0x40)
        self.assertEqual(document.encode(), before)

    def test_checked_in_worlds_have_expected_editable_dimensions(self) -> None:
        world1 = HierarchicalWorldDocument.load(
            ROOT / "data/world1/hierarchical_world.json"
        )
        world3 = HierarchicalWorldDocument.load(
            ROOT / "data/world3/hierarchical_world.json"
        )
        self.assertEqual(world1.map_size("city"), (64, 64))
        self.assertEqual(world1.map_size("underground"), (64, 25))
        self.assertEqual(world3.map_size("underwater"), (64, 64))
        self.assertEqual(len(world1.encode()), 8000)
        self.assertEqual(len(world3.encode()), 6400)


if __name__ == "__main__":
    unittest.main()
