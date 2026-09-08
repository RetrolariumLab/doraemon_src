from __future__ import annotations

from pathlib import Path
import sys
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))

from scripts.authoring.level_content_rom import LEVEL_RANGES, apply_level_payloads


class LevelContentRomTests(unittest.TestCase):
    def rom(self) -> bytes:
        header = bytes((0x4E, 0x45, 0x53, 0x1A, 8, 4, 0x21, 0x40, 0, 0, 0, 0, 0, 0, 0, 0))
        return header + bytes(4 * 0x8000) + bytes(4 * 0x2000)

    def payloads(self) -> dict[str, bytes]:
        return {
            world_id: bytes((index + 1,)) * size
            for index, (world_id, (_bank, _address, size)) in enumerate(
                LEVEL_RANGES.items()
            )
        }

    def test_patches_only_the_three_exact_prg_ranges(self) -> None:
        base = self.rom()
        payloads = self.payloads()
        built = apply_level_payloads(base, payloads)
        expected_changed = sum(len(payload) for payload in payloads.values())
        self.assertEqual(
            sum(left != right for left, right in zip(base, built)),
            expected_changed,
        )
        for world_id, (bank, address, size) in LEVEL_RANGES.items():
            offset = 16 + bank * 0x8000 + address - 0x8000
            self.assertEqual(built[offset:offset + size], payloads[world_id])
        self.assertEqual(built[:16], base[:16])
        self.assertEqual(built[-0x8000:], base[-0x8000:])

    def test_rejects_missing_world(self) -> None:
        payloads = self.payloads()
        del payloads["world2"]
        with self.assertRaisesRegex(ValueError, "must contain"):
            apply_level_payloads(self.rom(), payloads)

    def test_rejects_payload_size_change(self) -> None:
        payloads = self.payloads()
        payloads["world3"] += b"\x00"
        with self.assertRaisesRegex(ValueError, "expected 6400"):
            apply_level_payloads(self.rom(), payloads)

    def test_rejects_non_doraemon_mapper_shape(self) -> None:
        changed = bytearray(self.rom())
        changed[6] = 0
        with self.assertRaisesRegex(ValueError, "GNROM"):
            apply_level_payloads(bytes(changed), self.payloads())


if __name__ == "__main__":
    unittest.main()
