from __future__ import annotations

import copy
from pathlib import Path
import unittest

from scripts.authoring.graphics_artifacts import PrgGraphicsWorkspace
from scripts.authoring.metasprite_graphics_panel import (
    edit_fixed_record,
    edit_index_entry,
    edit_oam_attribute,
    edit_variable_record,
    signed,
)


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT


class MetaspriteGraphicsPanelTests(unittest.TestCase):
    def setUp(self) -> None:
        self.documents = PrgGraphicsWorkspace(
            ROOT, ROOT / "content" / "workspace", "original"
        ).load_canonical()

    def test_world1_variable_record_edit_is_valid_and_undoable(self) -> None:
        document = self.documents["world1_metasprites"]
        before = copy.deepcopy(document.document)
        record = document.document["metasprites"][0]
        piece = record["pieces"][0]
        replacement = (int(piece["tile"], 0) + 1) & 0xFF

        self.assertTrue(
            document.change(
                lambda data: edit_variable_record(
                    data,
                    0,
                    0,
                    int(record["x_mirror_extent"], 0),
                    int(record["y_mirror_extent"], 0),
                    int(piece["y_offset"], 0),
                    int(piece["x_offset"], 0),
                    replacement,
                )
            )
        )
        self.assertEqual(
            document.document["metasprites"][0]["pieces"][0]["tile"],
            f"0x{replacement:02X}",
        )
        self.assertTrue(document.undo())
        self.assertEqual(document.document, before)

    def test_world2_fixed_record_and_oam_attributes_validate(self) -> None:
        document = self.documents["world2_metasprites"]
        record = document.document["metasprites"][0]
        tiles = [int(value, 0) for value in record["tiles"]]
        tiles[0] ^= 1

        self.assertTrue(
            document.change(
                lambda data: edit_fixed_record(
                    data,
                    0,
                    tiles,
                    int(record["palette"]),
                    int(record["attribute_base"], 0),
                )
            )
        )
        for value in (0x00, 0x20, 0x40, 0x80, 0xE0):
            document.change(lambda data, value=value: edit_oam_attribute(data, 0, value))
            self.assertEqual(
                document.document["oam_attributes"][0]["value"],
                f"0x{value:02X}",
            )

    def test_world3_index_can_target_a_record_or_alias(self) -> None:
        document = self.documents["world3_metasprites"]
        target_record = 1
        self.assertTrue(
            document.change(
                lambda data: edit_index_entry(
                    data, 0, "direct", target_record, "none"
                )
            )
        )
        self.assertEqual(
            document.document["index_entries"][0]["metasprite_address"],
            document.document["metasprites"][target_record]["address"],
        )
        self.assertTrue(
            document.change(
                lambda data: edit_index_entry(
                    data, 0, "alias", 1, "horizontal"
                )
            )
        )
        self.assertEqual(
            document.document["index_entries"][0],
            {"id": 0, "kind": "alias", "source_index": 1, "flip": "horizontal"},
        )

    def test_invalid_domains_are_rejected_without_mutation(self) -> None:
        world1 = self.documents["world1_metasprites"].document
        before = copy.deepcopy(world1["index_entries"][0])
        with self.assertRaises(ValueError):
            edit_index_entry(world1, 0, "alias", 999, "horizontal")
        self.assertEqual(world1["index_entries"][0], before)
        with self.assertRaises(ValueError):
            edit_variable_record(world1, 0, 999, 0, 0, 0, 0, 0)

        world2 = self.documents["world2_metasprites"].document
        with self.assertRaises(ValueError):
            edit_fixed_record(world2, 0, [0, 1, 2, 3], 4, 0)
        with self.assertRaises(ValueError):
            edit_fixed_record(world2, 0, [0, 1, 2, 3], 0, 2)
        with self.assertRaises(ValueError):
            edit_oam_attribute(world2, 0, 0x01)

    def test_signed_byte_offsets(self) -> None:
        self.assertEqual(signed(0xFF), -1)
        self.assertEqual(signed(0x7F), 127)


if __name__ == "__main__":
    unittest.main()
