from __future__ import annotations

import copy
from pathlib import Path
import tempfile
import unittest

from scripts.authoring.object_artifacts import ARTIFACTS, ObjectWorkspace


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
EXPECTED_SIZES = {
    "world1_object_placements": 559,
    "world1_underground_rooms": 108,
    "world1_weapons": 51,
    "world2_enemy_states": 62,
    "world2_inventory_spawns": 7,
    "world3_object_catalog": 225,
    "world3_behavior_streams": 1062,
    "world3_transient_spawns": 768,
    "world3_spawn_initializer_data": 152,
    "world3_update_handler_data": 136,
}


class ObjectArtifactTests(unittest.TestCase):
    def test_canonical_object_artifacts_are_disjoint_and_fixed_size(self) -> None:
        workspace = ObjectWorkspace(ROOT, ROOT / "content/workspace", "original")
        documents = workspace.load_canonical()
        self.assertEqual(
            {key: len(value.validate()) for key, value in documents.items()},
            EXPECTED_SIZES,
        )

    def test_inventory_edit_updates_crc_and_is_undoable(self) -> None:
        workspace = ObjectWorkspace(ROOT, ROOT / "content/workspace", "original")
        document = workspace.load_canonical()["world2_inventory_spawns"]
        before = copy.deepcopy(document.document)

        def swap(data: dict) -> None:
            first = data["eligible_screens"][0]["screen_id"]
            data["eligible_screens"][0]["screen_id"] = (
                data["eligible_screens"][1]["screen_id"]
            )
            data["eligible_screens"][1]["screen_id"] = first

        self.assertTrue(document.change(swap))
        self.assertNotEqual(document.document["covered_crc32"], before["covered_crc32"])
        self.assertTrue(document.undo())
        self.assertEqual(document.document, before)

    def test_workspace_initialization_does_not_overwrite_documents(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            workspace = ObjectWorkspace(ROOT, Path(temporary), "rev_a")
            self.assertEqual(len(workspace.initialize()), len(ARTIFACTS))
            marker = workspace.path(ARTIFACTS[0])
            marker.write_text('{"local": true}\n', encoding="utf-8")
            self.assertEqual(workspace.initialize(), ())
            self.assertEqual(marker.read_text(encoding="utf-8"), '{"local": true}\n')


if __name__ == "__main__":
    unittest.main()
