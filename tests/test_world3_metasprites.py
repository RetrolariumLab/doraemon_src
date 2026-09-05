from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import world3_metasprites


class World3MetaspriteTests(unittest.TestCase):
    def fixture(
        self,
    ) -> tuple[bytes, dict[str, object], dict[str, object]]:
        bank = 2
        selectors = bytes([0, 1] * 32)
        index = bytes((0x00, 0x91, 0x00, 0x01, 0x09, 0x91, 0x00, 0x91))
        metasprites = bytes((
            2, 8, 8,
            0, 0, 1,
            8, 8, 2,
            1, 4, 4,
            2, 3, 3,
        ))
        palettes = bytes(range(32)) + bytes(reversed(range(32)))
        signature = bytes((0xA6, 0x79, 0x8A, 0x0A))
        prg = bytearray(4 * world3_metasprites.BANK_SIZE)
        base = bank * world3_metasprites.BANK_SIZE
        regions = [
            (0x9000, selectors),
            (0x90F8, index),
            (0x9100, metasprites),
            (0x910F, palettes),
            (0x9200, signature),
        ]
        for address, payload in regions:
            offset = base + address - world3_metasprites.CPU_BASE
            prg[offset:offset + len(payload)] = payload
        combined = selectors + index + metasprites + palettes
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": bank,
            "index_table": {
                "address": "0x90F8",
                "count": 4,
                "entry_size": 2,
                "direct_pointer_high_minimum": 4,
                "crc32": world3_metasprites.crc32(index),
            },
            "metasprites": {
                "address": "0x9100",
                "end_address": "0x910F",
                "count": 2,
                "header_fields": [
                    "sprite_count",
                    "x_mirror_extent",
                    "y_mirror_extent",
                ],
                "piece_fields": ["y_offset", "x_offset", "tile"],
                "crc32": world3_metasprites.crc32(metasprites),
            },
            "palettes": {
                "address": "0x910F",
                "count": 2,
                "bytes_per_palette": 32,
                "crc32": world3_metasprites.crc32(palettes),
            },
            "room_palette_selectors": {
                "address": "0x9000",
                "count": 64,
                "crc32": world3_metasprites.crc32(selectors),
            },
            "next_region_address": "0x914F",
            "expected_metrics": {
                "direct_index_entries": 3,
                "alias_index_entries": 1,
                "unique_direct_targets": 2,
                "nested_alias_ids": [],
                "unreferenced_records": [],
                "sprite_count_histogram": {"1": 1, "2": 1},
                "unique_tile_count": 3,
                "room_palette_histogram": [32, 32],
            },
            "signatures": [
                {"address": "0x9200", "bytes": signature.hex(" ")}
            ],
            "covered_byte_count": len(combined),
            "covered_crc32": world3_metasprites.crc32(combined),
        }
        entity_types: dict[str, object] = {
            "schema_version": 1,
            "type_count": 2,
            "property_tables": [
                {"name": "metasprite_base", "values": ["0x00", "0x02"]}
            ],
        }
        return bytes(prg), manifest, entity_types

    def test_accepts_exact_catalog(self) -> None:
        prg, manifest, entity_types = self.fixture()
        errors, report = world3_metasprites.validate_manifest_data(
            prg, manifest, entity_types
        )
        self.assertEqual(errors, [])
        self.assertEqual(report["metasprite_count"], 2)
        self.assertEqual(report["alias_count"], 1)

    def test_lossless_authoring_roundtrip(self) -> None:
        prg, manifest, entity_types = self.fixture()
        decoded = world3_metasprites.decode_authoring(
            prg, manifest, entity_types
        )
        rebuilt = world3_metasprites.apply_authoring(prg, decoded)
        self.assertEqual(rebuilt, prg)
        self.assertEqual(decoded["covered_byte_count"], 151)

    def test_allows_piece_palette_and_room_edits(self) -> None:
        prg, manifest, entity_types = self.fixture()
        decoded = world3_metasprites.decode_authoring(
            prg, manifest, entity_types
        )
        changed = copy.deepcopy(decoded)
        changed["metasprites"][0]["pieces"][0]["tile"] = "0x04"
        changed["palettes"][0]["colors"][0] = "0x0F"
        changed["room_palettes"][0]["palette"] = 1
        rebuilt = world3_metasprites.apply_authoring(prg, changed)
        base = 2 * 0x8000
        self.assertEqual(rebuilt[base + 0x1105], 4)
        self.assertEqual(rebuilt[base + 0x110F], 0x0F)
        self.assertEqual(rebuilt[base + 0x1000], 1)

    def test_allows_alias_flip_edit(self) -> None:
        prg, manifest, entity_types = self.fixture()
        decoded = world3_metasprites.decode_authoring(
            prg, manifest, entity_types
        )
        decoded["index_entries"][1]["flip"] = "vertical"
        rebuilt = world3_metasprites.apply_authoring(prg, decoded)
        self.assertEqual(rebuilt[2 * 0x8000 + 0x10FB], 2)

    def test_rejects_pointer_between_records(self) -> None:
        prg, manifest, entity_types = self.fixture()
        changed = bytearray(prg)
        changed[2 * 0x8000 + 0x10F8] = 1
        errors, _report = world3_metasprites.validate_manifest_data(
            bytes(changed), manifest, entity_types
        )
        self.assertTrue(any("miss record starts" in error for error in errors))

    def test_rejects_palette_selector_outside_catalog(self) -> None:
        prg, manifest, entity_types = self.fixture()
        changed = bytearray(prg)
        changed[2 * 0x8000 + 0x1000] = 2
        errors, _report = world3_metasprites.validate_manifest_data(
            bytes(changed), manifest, entity_types
        )
        self.assertTrue(any("outside the palette catalog" in error for error in errors))

    def test_rejects_entity_base_alias(self) -> None:
        prg, manifest, entity_types = self.fixture()
        entity_types["property_tables"][0]["values"][0] = "0x01"
        errors, _report = world3_metasprites.validate_manifest_data(
            prg, manifest, entity_types
        )
        self.assertTrue(any("base indexes" in error for error in errors))

    def test_rejects_changed_renderer_signature(self) -> None:
        prg, manifest, entity_types = self.fixture()
        changed = bytearray(prg)
        changed[2 * 0x8000 + 0x1200] ^= 1
        errors, _report = world3_metasprites.validate_manifest_data(
            bytes(changed), manifest, entity_types
        )
        self.assertTrue(any("signature differs" in error for error in errors))

    def test_decodes_chr_bitplanes(self) -> None:
        chr_data = bytearray(3 * 0x2000)
        tile = 3
        start = 2 * 0x2000 + tile * 16
        chr_data[start] = 0x80
        chr_data[start + 8] = 0x40
        pixels = world3_metasprites.chr_tile_pixels(bytes(chr_data), 2, tile)
        self.assertEqual(pixels[0][:3], [1, 2, 0])

    def test_resolves_single_alias_and_flip(self) -> None:
        prg, manifest, _entity_types = self.fixture()
        _data, entries, records = world3_metasprites.manifest_data(prg, manifest)
        record, flip = world3_metasprites.resolved_metasprite(entries, records, 1)
        self.assertEqual(record["address"], 0x9100)
        self.assertEqual(flip, 1)


if __name__ == "__main__":
    unittest.main()
