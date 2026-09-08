from __future__ import annotations

import unittest

from scripts.authoring.graphics_content_rom import (
    CHR_SIZE,
    HEADER_SIZE,
    PRG_SIZE,
    apply_hierarchy_payloads,
    apply_graphics_payload,
)
from scripts.authoring.level_studio_model import HierarchicalWorldDocument
from tests import PROJECT_ROOT


def ines_image(mapper: int = 66, chr_banks: int = 4) -> bytes:
    header = bytearray(b"NES\x1a")
    header.extend((8, chr_banks, (mapper & 0x0F) << 4, mapper & 0xF0))
    header.extend(bytes(8))
    return bytes(header) + bytes(PRG_SIZE) + bytes(chr_banks * 0x2000)


class GraphicsContentRomTests(unittest.TestCase):
    def test_replaces_only_the_complete_chr_region(self) -> None:
        base = ines_image()
        replacement = bytes((index * 13) & 0xFF for index in range(CHR_SIZE))
        result = apply_graphics_payload(base, replacement)
        start = HEADER_SIZE + PRG_SIZE
        self.assertEqual(result[:start], base[:start])
        self.assertEqual(result[start:], replacement)

    def test_rejects_wrong_chr_capacity(self) -> None:
        with self.assertRaisesRegex(ValueError, "graphics payload"):
            apply_graphics_payload(ines_image(), bytes(CHR_SIZE - 1))

    def test_rejects_non_doraemon_mapper_shape(self) -> None:
        with self.assertRaisesRegex(ValueError, "GNROM"):
            apply_graphics_payload(ines_image(mapper=0), bytes(CHR_SIZE))
        with self.assertRaisesRegex(ValueError, "GNROM"):
            apply_graphics_payload(ines_image(chr_banks=2), bytes(CHR_SIZE))

    def test_shared_hierarchies_patch_their_exact_prg_ranges(self) -> None:
        root = PROJECT_ROOT
        documents = {
            "world1": HierarchicalWorldDocument.load(
                root / "data/world1/hierarchical_world.json"
            ),
            "world3": HierarchicalWorldDocument.load(
                root / "data/world3/hierarchical_world.json"
            ),
        }
        base = ines_image()
        result = apply_hierarchy_payloads(base, documents)
        changed = {
            index
            for index, (left, right) in enumerate(zip(base, result))
            if left != right
        }
        allowed = set(range(16 + 0x29EF, 16 + 0x29EF + 8000))
        allowed.update(
            range(16 + 2 * 0x8000 + 0x5DF2, 16 + 2 * 0x8000 + 0x5DF2 + 6400)
        )
        self.assertTrue(changed)
        self.assertLessEqual(changed, allowed)


if __name__ == "__main__":
    unittest.main()
