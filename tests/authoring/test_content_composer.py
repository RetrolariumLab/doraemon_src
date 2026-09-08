from __future__ import annotations

import unittest

from scripts.authoring.content_composer import merge_studio_images, parse_studios


class ContentComposerTests(unittest.TestCase):
    def test_studio_selection_accepts_all_or_a_unique_subset(self) -> None:
        self.assertEqual(
            parse_studios("all"),
            ("level", "graphics", "objects", "text", "sound"),
        )
        self.assertEqual(parse_studios("level,sound"), ("level", "sound"))
        with self.assertRaisesRegex(ValueError, "unknown"):
            parse_studios("level,unknown")

    def test_disjoint_changes_merge(self) -> None:
        base = bytes(4)
        built, counts = merge_studio_images(
            base,
            {"level": b"\x01\x00\x00\x00", "text": b"\x00\x00\x02\x00"},
        )
        self.assertEqual(built, b"\x01\x00\x02\x00")
        self.assertEqual(counts, {"level": 1, "text": 1})

    def test_shared_equal_change_is_allowed(self) -> None:
        built, _counts = merge_studio_images(
            bytes(2),
            {"level": b"\x01\x00", "graphics": b"\x01\x00"},
        )
        self.assertEqual(built, b"\x01\x00")

    def test_conflicting_change_reports_both_studios(self) -> None:
        with self.assertRaisesRegex(ValueError, "level.*graphics"):
            merge_studio_images(
                bytes(2),
                {"level": b"\x01\x00", "graphics": b"\x02\x00"},
            )


if __name__ == "__main__":
    unittest.main()
