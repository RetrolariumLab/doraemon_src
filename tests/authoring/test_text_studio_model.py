from __future__ import annotations

import copy
from pathlib import Path
import tempfile
import unittest

from scripts.authoring.text_studio_model import (
    TextWorkspace,
    edit_fixed_text,
    edit_hex_row,
    glyph_tiles,
    text_fields,
    value_at,
)


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT


class TextStudioModelTests(unittest.TestCase):
    def document(self):
        return TextWorkspace(
            ROOT, ROOT / "content/workspace", "original"
        ).load_canonical()

    def test_catalog_exposes_all_fixed_text_fields(self) -> None:
        fields = text_fields(self.document().document)
        self.assertEqual(len(fields), 412)
        self.assertEqual(sum(field.kind == "title" for field in fields), 5)
        self.assertEqual(sum(field.kind == "help" for field in fields), 26)
        self.assertEqual(sum(field.kind == "credits" for field in fields), 380)

    def test_fixed_text_edit_validates_and_undoes(self) -> None:
        document = self.document()
        before = copy.deepcopy(document.document)
        field = text_fields(document.document)[0]
        self.assertTrue(
            document.change(lambda data: edit_fixed_text(data, field, "LOSE OVER"))
        )
        self.assertEqual(value_at(document.document, field.path), "LOSE OVER")
        self.assertTrue(document.undo())
        self.assertEqual(document.document, before)
        with self.assertRaisesRegex(ValueError, "exactly 9"):
            document.change(lambda data: edit_fixed_text(data, field, "SHORT"))

    def test_hex_rows_keep_their_physical_width(self) -> None:
        document = self.document()
        row = document.document["ending_nametable_rows"][0]
        replacement = bytes([0xEE]) + bytes.fromhex(row)[1:]
        self.assertTrue(
            document.change(
                lambda data: edit_hex_row(
                    data, "ending_nametable_rows", 0, replacement.hex(" ")
                )
            )
        )
        with self.assertRaisesRegex(ValueError, "exactly 32"):
            document.change(
                lambda data: edit_hex_row(data, "ending_nametable_rows", 0, "00")
            )

    def test_glyph_mapping_matches_each_runtime_format(self) -> None:
        remap = {"0x20": "0x7F", "0x2E": "0x5B"}
        self.assertEqual(glyph_tiles("A A", "game_over", remap), (0x41, 0, 0x41))
        self.assertEqual(glyph_tiles("A.", "title", remap), (0x41, 0x5B))
        self.assertEqual(glyph_tiles("A .", "credits", remap), (0x41, 0x7F, 0x5B))

    def test_workspace_initialization_preserves_existing_file(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            workspace = TextWorkspace(ROOT, Path(temporary), "rev_a")
            self.assertIsNotNone(workspace.initialize())
            workspace.path.write_text('{"local": true}\n', encoding="utf-8")
            self.assertIsNone(workspace.initialize())
            self.assertEqual(
                workspace.path.read_text(encoding="utf-8"), '{"local": true}\n'
            )


if __name__ == "__main__":
    unittest.main()
