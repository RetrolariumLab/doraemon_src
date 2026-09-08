from __future__ import annotations

from pathlib import Path
import unittest

from scripts.authoring.object_artifacts import ObjectWorkspace
from scripts.authoring.object_content_rom import (
    CHR_SIZE,
    HEADER_SIZE,
    PRG_SIZE,
    WORLD2_ADDRESS,
    WORLD2_BANK,
    WORLD2_SIZE,
    apply_object_payload,
)
from scripts.authoring.world2_level_model import (
    CANONICAL_PATH,
    World2ScreenDocument,
)


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT


def ines_image(mapper: int = 66) -> bytes:
    header = bytearray(b"NES\x1a")
    header.extend((8, 4, (mapper & 0x0F) << 4, mapper & 0xF0))
    header.extend(bytes(8))
    return bytes(header) + bytes(PRG_SIZE) + bytes(CHR_SIZE)


class ObjectContentRomTests(unittest.TestCase):
    def documents(self):
        return ObjectWorkspace(
            ROOT, ROOT / "content/workspace", "original"
        ).load_canonical()

    def world2(self) -> World2ScreenDocument:
        return World2ScreenDocument.load(ROOT / CANONICAL_PATH)

    def test_composes_objects_and_shared_world2_stream_without_touching_chr(self) -> None:
        base = ines_image()
        result = apply_object_payload(base, self.documents(), self.world2())
        self.assertEqual(result[-CHR_SIZE:], base[-CHR_SIZE:])
        world2_offset = (
            HEADER_SIZE + WORLD2_BANK * 0x8000 + WORLD2_ADDRESS - 0x8000
        )
        self.assertEqual(
            result[world2_offset:world2_offset + WORLD2_SIZE],
            self.world2().encode(),
        )

    def test_rejects_non_doraemon_mapper(self) -> None:
        with self.assertRaisesRegex(ValueError, "GNROM"):
            apply_object_payload(
                ines_image(mapper=0), self.documents(), self.world2()
            )


if __name__ == "__main__":
    unittest.main()
