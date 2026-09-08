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

from scripts.validation.world2 import world2_metatiles


class World2MetatileTests(unittest.TestCase):
    def fixture(
        self,
    ) -> tuple[bytes, dict[str, object], dict[str, object]]:
        prg = bytearray(4 * world2_metatiles.BANK_SIZE)
        bank_offset = world2_metatiles.BANK_SIZE
        prefix_address = 0x9000
        palette_address = 0x9001
        tile_address = 0x9004
        prefix = bytes((0xFF,))
        palettes = bytes((0, 1, 3))
        tiles = bytes(range(12))
        signature = bytes((0xB9, 0x01, 0x90, 0x60))
        collision = bytes((0xA0,))
        collision_signature = bytes((0xB9, 0x20, 0x90, 0x60))

        def write(address: int, data: bytes) -> None:
            offset = bank_offset + address - world2_metatiles.CPU_BASE
            prg[offset:offset + len(data)] = data

        write(prefix_address, prefix + palettes + tiles)
        write(0x8000, signature)
        write(0x8010, collision_signature)
        write(0x9020, collision)
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": 1,
            "metatile_count": 3,
            "runtime_id_range": ["0x00", "0x02"],
            "unindexed_prefix": {
                "address": f"0x{prefix_address:04X}",
                "size": 1,
                "value": "0xFF",
                "crc32": world2_metatiles.crc32(prefix),
            },
            "palette_selectors": {
                "address": f"0x{palette_address:04X}",
                "count": 3,
                "value_limit": 4,
                "histogram": [1, 1, 0, 1],
                "crc32": world2_metatiles.crc32(palettes),
            },
            "tile_quads": {
                "address": f"0x{tile_address:04X}",
                "count": 3,
                "bytes_per_metatile": 4,
                "order": list(world2_metatiles.TILE_FIELDS),
                "crc32": world2_metatiles.crc32(tiles),
            },
            "collision_bits": {
                "address": "0x9020",
                "size": 1,
                "bit_order": "msb-first",
                "solid_metatile_count": 2,
                "crc32": world2_metatiles.crc32(collision),
            },
            "next_region_address": "0x9010",
            "renderer": {
                "address": "0x8000",
                "signature": signature.hex(" "),
                "palette_address": f"0x{palette_address:04X}",
                "tile_table_bases": [
                    f"0x{tile_address + index * 0x100:04X}"
                    for index in range(4)
                ],
            },
            "collision_lookup": {
                "address": "0x8010",
                "signature": collision_signature.hex(" "),
                "screen_buffer_address": "0x0400",
                "bit_mask_address": "0x93AF",
                "collision_bits_address": "0x9020",
            },
            "standard_stream_references": {
                "authoring": "fixture.json",
                "expected_unique_count": 2,
                "unreferenced_ids": ["0x01"],
            },
        }
        screens: dict[str, object] = {
            "schema_version": 1,
            "format": "world2-compressed-screens",
            "tokens": ["0000:L:00", "0001:R:F1:02", "0003:S:D0", "0004:E"],
        }
        return bytes(prg), manifest, screens

    def test_accepts_exact_catalog(self) -> None:
        prg, manifest, screens = self.fixture()
        errors, report = world2_metatiles.validate_manifest_data(
            prg, manifest, screens
        )
        self.assertEqual(errors, [])
        self.assertEqual(report["metatile_count"], 3)
        self.assertEqual(report["referenced_metatile_count"], 2)

    def test_lossless_authoring_roundtrip(self) -> None:
        prg, manifest, screens = self.fixture()
        decoded = world2_metatiles.decode_authoring(prg, manifest, screens)
        self.assertEqual(world2_metatiles.apply_authoring(prg, decoded), prg)
        self.assertEqual(decoded["covered_byte_count"], 17)

    def test_authoring_encoder_allows_tile_and_palette_edits(self) -> None:
        prg, manifest, screens = self.fixture()
        decoded = world2_metatiles.decode_authoring(prg, manifest, screens)
        changed = copy.deepcopy(decoded)
        changed["records"][1]["palette"] = 2
        changed["records"][1]["bottom_right"] = "0xFE"
        changed["records"][1]["solid"] = True
        encoded = world2_metatiles.apply_authoring(prg, changed)
        bank_offset = world2_metatiles.BANK_SIZE
        self.assertEqual(encoded[bank_offset + 0x1002], 2)
        self.assertEqual(encoded[bank_offset + 0x100B], 0xFE)
        self.assertEqual(encoded[bank_offset + 0x1020], 0xE0)

    def test_rejects_palette_outside_selector_domain(self) -> None:
        prg, manifest, screens = self.fixture()
        decoded = world2_metatiles.decode_authoring(prg, manifest, screens)
        decoded["records"][0]["palette"] = 4
        with self.assertRaisesRegex(ValueError, "selector domain"):
            world2_metatiles.encode_authoring(decoded)

    def test_rejects_nonboolean_solid_flag(self) -> None:
        prg, manifest, screens = self.fixture()
        decoded = world2_metatiles.decode_authoring(prg, manifest, screens)
        decoded["records"][0]["solid"] = 1
        with self.assertRaisesRegex(ValueError, "solid flag"):
            world2_metatiles.encode_authoring(decoded)

    def test_rejects_set_collision_padding_bits(self) -> None:
        prg, manifest, screens = self.fixture()
        changed = bytearray(prg)
        changed[world2_metatiles.BANK_SIZE + 0x1020] |= 0x01
        manifest["collision_bits"]["crc32"] = world2_metatiles.crc32(
            bytes((0xA1,))
        )
        errors, _report = world2_metatiles.validate_manifest_data(
            bytes(changed), manifest, screens
        )
        self.assertTrue(any("padding bits" in error for error in errors))

    def test_rejects_noncontiguous_ids(self) -> None:
        prg, manifest, screens = self.fixture()
        decoded = world2_metatiles.decode_authoring(prg, manifest, screens)
        decoded["records"][1]["id"] = 7
        with self.assertRaisesRegex(ValueError, "ids are not contiguous"):
            world2_metatiles.encode_authoring(decoded)

    def test_rejects_changed_renderer_signature(self) -> None:
        prg, manifest, screens = self.fixture()
        changed = bytearray(prg)
        changed[world2_metatiles.BANK_SIZE] ^= 1
        errors, _report = world2_metatiles.validate_manifest_data(
            bytes(changed), manifest, screens
        )
        self.assertTrue(any("renderer signature differs" in error for error in errors))

    def test_rejects_reference_outside_catalog(self) -> None:
        prg, manifest, screens = self.fixture()
        screens["tokens"][1] = "0001:R:F1:03"
        errors, _report = world2_metatiles.validate_manifest_data(
            prg, manifest, screens
        )
        self.assertTrue(any("outside catalog" in error for error in errors))

    def test_rejects_stale_reference_flag(self) -> None:
        prg, manifest, screens = self.fixture()
        decoded = world2_metatiles.decode_authoring(prg, manifest, screens)
        decoded["records"][1]["referenced_by_standard_stream"] = True
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "metatiles.json"
            path.write_text(json.dumps(decoded), encoding="utf-8")
            errors = world2_metatiles.validate_authoring(
                prg, manifest, screens, path
            )
        self.assertTrue(any("reference flags differ" in error for error in errors))

    def test_rejects_stale_authoring_crc(self) -> None:
        prg, manifest, screens = self.fixture()
        decoded = world2_metatiles.decode_authoring(prg, manifest, screens)
        decoded["covered_crc32"] = "00000000"
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "metatiles.json"
            path.write_text(json.dumps(decoded), encoding="utf-8")
            errors = world2_metatiles.validate_authoring(
                prg, manifest, screens, path
            )
        self.assertTrue(any("CRC32 differs" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
