from __future__ import annotations

from pathlib import Path
import unittest

from scripts.authoring.object_artifacts import ObjectWorkspace
from scripts.authoring.object_studio import (
    editable_path,
    parse_scalar,
    set_scalar,
    value_at,
)


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT


class ObjectStudioTests(unittest.TestCase):
    def test_layout_and_identity_fields_are_locked(self) -> None:
        self.assertFalse(editable_path(("schema_version",)))
        self.assertFalse(editable_path(("records", 0, "id")))
        self.assertFalse(editable_path(("layout", "stream_address")))
        self.assertFalse(editable_path(("records", 0, "address")))
        self.assertTrue(editable_path(("records", 0, "type")))
        self.assertTrue(editable_path(("rooms", 0, "channels", 0, "count")))

    def test_scalar_parser_preserves_numeric_representation(self) -> None:
        self.assertEqual(parse_scalar("0x0a", "0x00"), "0x0A")
        self.assertEqual(parse_scalar("17", 0), 17)
        self.assertTrue(parse_scalar("true", False))
        self.assertIsNone(parse_scalar("null", None))
        self.assertEqual(parse_scalar("3", None), 3)

    def test_typed_path_edit_passes_native_artifact_encoder(self) -> None:
        document = ObjectWorkspace(
            ROOT, ROOT / "content/workspace", "original"
        ).load_canonical()["world1_weapons"]
        path = ("levels", 0, "directions", 0, "x_offset")
        original = value_at(document.document, path)
        replacement = "0x05" if original != "0x05" else "0x06"
        self.assertTrue(
            document.change(lambda data: set_scalar(data, path, replacement))
        )
        self.assertEqual(value_at(document.document, path), replacement)
        self.assertTrue(document.undo())
        self.assertEqual(value_at(document.document, path), original)


if __name__ == "__main__":
    unittest.main()
