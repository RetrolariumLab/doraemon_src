from __future__ import annotations

from pathlib import Path
import unittest

from scripts.authoring.sound_content_rom import CHR_SIZE, apply_sound_payload
from scripts.authoring.sound_studio_model import PRG_SIZE, SoundWorkspace


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT


def ines_image(mapper: int = 66) -> bytes:
    header = bytearray(b"NES\x1a")
    header.extend((8, 4, (mapper & 0x0F) << 4, mapper & 0xF0))
    header.extend(bytes(8))
    return bytes(header) + bytes(PRG_SIZE) + bytes(CHR_SIZE)


class SoundContentRomTests(unittest.TestCase):
    def document(self):
        return SoundWorkspace(ROOT, ROOT / "content/workspace", "original").load_canonical()

    def test_composer_preserves_chr_and_writes_music_regions(self) -> None:
        base = ines_image()
        priorities = SoundWorkspace(
            ROOT, ROOT / "content/workspace", "original"
        ).load_canonical_priorities()
        result = apply_sound_payload(base, self.document(), priorities)
        self.assertEqual(result[-CHR_SIZE:], base[-CHR_SIZE:])
        self.assertNotEqual(result, base)

    def test_rejects_non_doraemon_mapper(self) -> None:
        with self.assertRaisesRegex(ValueError, "GNROM"):
            apply_sound_payload(ines_image(mapper=0), self.document())


if __name__ == "__main__":
    unittest.main()
