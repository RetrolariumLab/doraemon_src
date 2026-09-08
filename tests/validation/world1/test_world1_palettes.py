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

from scripts.validation.world1 import world1_palettes


class World1PaletteTests(unittest.TestCase):
    def fixture(self) -> tuple[bytes, dict[str, object]]:
        prg = bytearray(4 * world1_palettes.BANK_SIZE)
        address = 0x9000
        palettes = b"".join(
            bytes([0x0F, palette_id, 2, 3] * 8) for palette_id in range(12)
        )
        signature = bytes((0xA9, 0x00, 0x85, 0x00))
        prg[address - world1_palettes.CPU_BASE:address - 0x8000 + len(palettes)] = palettes
        prg[0x9200 - 0x8000:0x9204 - 0x8000] = signature
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": 0,
            "palettes": {
                "address": "0x9000",
                "count": 12,
                "colors_per_palette": 32,
                "universal_background_color": "0x0F",
                "expected_unique_count": 12,
                "crc32": world1_palettes.crc32(palettes),
            },
            "loader_signature": {
                "address": "0x9200",
                "bytes": signature.hex(" "),
            },
        }
        return bytes(prg), manifest

    def test_accepts_exact_palette_catalog(self) -> None:
        prg, manifest = self.fixture()
        errors, report = world1_palettes.validate_manifest_data(prg, manifest)
        self.assertEqual(errors, [])
        self.assertEqual(report["palette_count"], 12)

    def test_lossless_authoring_roundtrip(self) -> None:
        prg, manifest = self.fixture()
        decoded = world1_palettes.decode_authoring(prg, manifest)
        self.assertEqual(world1_palettes.apply_authoring(prg, decoded), prg)
        self.assertEqual(decoded["covered_byte_count"], 384)

    def test_authoring_allows_color_edit(self) -> None:
        prg, manifest = self.fixture()
        decoded = world1_palettes.decode_authoring(prg, manifest)
        changed = copy.deepcopy(decoded)
        colors = bytearray.fromhex(changed["palettes"][1]["colors"])
        colors[2] = 0x2A
        changed["palettes"][1]["colors"] = colors.hex(" ")
        encoded = world1_palettes.apply_authoring(prg, changed)
        self.assertEqual(encoded[0x9000 - 0x8000 + 34], 0x2A)

    def test_rejects_color_outside_nes_palette(self) -> None:
        prg, manifest = self.fixture()
        decoded = world1_palettes.decode_authoring(prg, manifest)
        colors = bytearray.fromhex(decoded["palettes"][0]["colors"])
        colors[1] = 0x40
        decoded["palettes"][0]["colors"] = colors.hex(" ")
        with self.assertRaisesRegex(ValueError, "NES palette range"):
            world1_palettes.encode_authoring(decoded)

    def test_rejects_changed_loader_signature(self) -> None:
        prg, manifest = self.fixture()
        changed = bytearray(prg)
        changed[0x9200 - 0x8000] ^= 1
        errors, _ = world1_palettes.validate_manifest_data(bytes(changed), manifest)
        self.assertTrue(any("loader signature" in error for error in errors))

    def test_rejects_stale_authoring_crc(self) -> None:
        prg, manifest = self.fixture()
        decoded = world1_palettes.decode_authoring(prg, manifest)
        decoded["covered_crc32"] = "00000000"
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "palettes.json"
            path.write_text(json.dumps(decoded), encoding="utf-8")
            errors = world1_palettes.validate_authoring(prg, manifest, path)
        self.assertTrue(any("CRC32 differs" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
