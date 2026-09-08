from __future__ import annotations

from pathlib import Path
import unittest

from scripts.authoring.text_content_rom import CHR_SIZE, PRG_SIZE, apply_text_payload
from scripts.authoring.text_studio_model import TextWorkspace


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT


def ines_image(mapper: int = 66) -> bytes:
    header = bytearray(b"NES\x1a")
    header.extend((8, 4, (mapper & 0x0F) << 4, mapper & 0xF0))
    header.extend(bytes(8))
    return bytes(header) + bytes(PRG_SIZE) + bytes(CHR_SIZE)


class TextContentRomTests(unittest.TestCase):
    def document(self):
        return TextWorkspace(
            ROOT, ROOT / "content/workspace", "original"
        ).load_canonical()

    def test_composer_preserves_chr_and_writes_text_regions(self) -> None:
        base = ines_image()
        result = apply_text_payload(base, self.document())
        self.assertEqual(result[-CHR_SIZE:], base[-CHR_SIZE:])
        self.assertNotEqual(result, base)

    def test_rejects_non_doraemon_mapper(self) -> None:
        with self.assertRaisesRegex(ValueError, "GNROM"):
            apply_text_payload(ines_image(mapper=0), self.document())


if __name__ == "__main__":
    unittest.main()
