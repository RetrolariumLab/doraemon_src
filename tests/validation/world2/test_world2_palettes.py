from __future__ import annotations

import copy
import json
from pathlib import Path
import sys
import tempfile
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))

from scripts.validation.world2 import world2_palettes


class World2PaletteTests(unittest.TestCase):
    def fixture(
        self,
    ) -> tuple[bytes, dict[str, object], dict[str, object]]:
        prg = bytearray(4 * world2_palettes.BANK_SIZE)
        bank_offset = world2_palettes.BANK_SIZE
        palette_address = 0x9000
        palettes = bytes(
            [0x0F, 1, 2, 3] * 4
            + [0x0F, 4, 5, 6] * 4
            + [0x0F, 7, 8, 9] * 4
        )
        backgrounds = bytes((1, 2))
        sprite_offsets = bytes((0x10, 0x20))
        signature = bytes((0xA5, 0x9D, 0xF0, 0x01))

        def write(address: int, data: bytes) -> None:
            offset = bank_offset + address - world2_palettes.CPU_BASE
            prg[offset:offset + len(data)] = data

        write(palette_address, palettes)
        write(0x9100, backgrounds)
        write(0x9110, sprite_offsets)
        write(0x9200, signature)
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": 1,
            "palette_sets": {
                "address": "0x9000",
                "count": 3,
                "colors_per_set": 16,
                "universal_background_color": "0x0F",
                "expected_unique_count": 3,
                "crc32": world2_palettes.crc32(palettes),
            },
            "lookup": {
                "background_index_base": "0x8FF0",
                "sprite_offset_base": "0x9000",
            },
            "initial_background_selectors": {
                "address": "0x9100",
                "count": 2,
                "values": list(backgrounds),
                "crc32": world2_palettes.crc32(backgrounds),
            },
            "initial_sprite_offsets": {
                "address": "0x9110",
                "count": 2,
                "values": list(sprite_offsets),
                "palette_records": [1, 2],
                "crc32": world2_palettes.crc32(sprite_offsets),
            },
            "stage_palette_counts": {"1": 1, "2": 2},
            "code_signatures": [
                {
                    "name": "consumer",
                    "address": "0x9200",
                    "bytes": signature.hex(" "),
                }
            ],
        }
        stage: dict[str, object] = {
            "schema_version": 1,
            "format": "doraemon-world2-stage-sequence",
            "entries": [
                {
                    "raw": "0xF9",
                    "command": "set_background_palette",
                    "palette_id": 1,
                },
                {
                    "raw": "0xFA",
                    "command": "set_background_palette",
                    "palette_id": 2,
                },
                {
                    "raw": "0xFA",
                    "command": "set_background_palette",
                    "palette_id": 2,
                },
            ],
        }
        return bytes(prg), manifest, stage

    def test_accepts_exact_palette_catalog(self) -> None:
        prg, manifest, stage = self.fixture()
        errors, report = world2_palettes.validate_manifest_data(
            prg, manifest, stage
        )
        self.assertEqual(errors, [])
        self.assertEqual(report["palette_set_count"], 3)
        self.assertEqual(report["stage_palette_command_count"], 3)

    def test_lossless_authoring_roundtrip(self) -> None:
        prg, manifest, stage = self.fixture()
        decoded = world2_palettes.decode_authoring(prg, manifest, stage)
        self.assertEqual(world2_palettes.apply_authoring(prg, decoded), prg)
        self.assertEqual(decoded["covered_byte_count"], 52)

    def test_authoring_encoder_allows_color_and_selector_edits(self) -> None:
        prg, manifest, stage = self.fixture()
        decoded = world2_palettes.decode_authoring(prg, manifest, stage)
        changed = copy.deepcopy(decoded)
        changed["palettes"][1]["colors"][2] = "0x2A"
        changed["chapters"][0]["background_palette_id"] = 3
        encoded = world2_palettes.apply_authoring(prg, changed)
        bank_offset = world2_palettes.BANK_SIZE
        self.assertEqual(encoded[bank_offset + 0x1012], 0x2A)
        self.assertEqual(encoded[bank_offset + 0x1100], 3)

    def test_rejects_color_outside_nes_palette(self) -> None:
        prg, manifest, stage = self.fixture()
        decoded = world2_palettes.decode_authoring(prg, manifest, stage)
        decoded["palettes"][0]["colors"][0] = "0x40"
        with self.assertRaisesRegex(ValueError, "NES palette range"):
            world2_palettes.encode_authoring(decoded)

    def test_rejects_sprite_record_that_differs_from_offset(self) -> None:
        prg, manifest, stage = self.fixture()
        decoded = world2_palettes.decode_authoring(prg, manifest, stage)
        decoded["chapters"][0]["sprite_palette_record"] = 2
        with self.assertRaisesRegex(ValueError, "differs from offset"):
            world2_palettes.encode_authoring(decoded)

    def test_rejects_background_selector_outside_catalog(self) -> None:
        prg, manifest, stage = self.fixture()
        decoded = world2_palettes.decode_authoring(prg, manifest, stage)
        decoded["chapters"][0]["background_palette_id"] = 4
        with self.assertRaisesRegex(ValueError, "outside catalog"):
            world2_palettes.encode_authoring(decoded)

    def test_rejects_changed_code_signature(self) -> None:
        prg, manifest, stage = self.fixture()
        changed = bytearray(prg)
        changed[world2_palettes.BANK_SIZE + 0x1200] ^= 1
        errors, _report = world2_palettes.validate_manifest_data(
            bytes(changed), manifest, stage
        )
        self.assertTrue(any("code signature" in error for error in errors))

    def test_rejects_changed_stage_palette_counts(self) -> None:
        prg, manifest, stage = self.fixture()
        stage["entries"].pop()
        errors, _report = world2_palettes.validate_manifest_data(
            prg, manifest, stage
        )
        self.assertTrue(any("command counts differ" in error for error in errors))

    def test_rejects_stale_authoring_crc(self) -> None:
        prg, manifest, stage = self.fixture()
        decoded = world2_palettes.decode_authoring(prg, manifest, stage)
        decoded["covered_crc32"] = "00000000"
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "palettes.json"
            path.write_text(json.dumps(decoded), encoding="utf-8")
            errors = world2_palettes.validate_authoring(
                prg, manifest, stage, path
            )
        self.assertTrue(any("CRC32 differs" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
