from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import world1_metasprites


class World1MetaspriteTests(unittest.TestCase):
    def fixture(
        self,
    ) -> tuple[bytes, bytes, dict[str, object], dict[str, object]]:
        index = bytes((0x08, 0x91, 0x00, 0x01, 0x11, 0x91, 0x08, 0x91))
        records = bytes((
            2, 8, 8,
            0, 0, 1,
            8, 8, 2,
            1, 4, 4,
            2, 3, 3,
        ))
        signature = bytes((0xA6, 0x49, 0x8A, 0x0A))
        prg = bytearray(4 * world1_metasprites.BANK_SIZE)
        for address, payload in (
            (0x9100, index),
            (0x9108, records),
            (0x9200, signature),
        ):
            offset = address - world1_metasprites.CPU_BASE
            prg[offset:offset + len(payload)] = payload
        chr_data = bytearray(4 * world1_metasprites.CHR_BANK_SIZE)
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": 0,
            "chr_bank": 0,
            "chr_bank_crc32": world1_metasprites.crc32(
                bytes(chr_data[:world1_metasprites.CHR_BANK_SIZE])
            ),
            "sprite_pattern_table": "0x0000",
            "index_table": {
                "address": "0x9100",
                "count": 4,
                "entry_size": 2,
                "direct_pointer_high_minimum": 4,
                "crc32": world1_metasprites.crc32(index),
            },
            "metasprites": {
                "address": "0x9108",
                "end_address": "0x9117",
                "count": 2,
                "header_fields": [
                    "sprite_count", "x_mirror_extent", "y_mirror_extent"
                ],
                "piece_fields": ["y_offset", "x_offset", "tile"],
                "crc32": world1_metasprites.crc32(records),
            },
            "expected_metrics": {
                "direct_index_entries": 3,
                "alias_index_entries": 1,
                "unique_direct_targets": 2,
                "nested_alias_ids": [],
                "unreferenced_records": [],
                "sprite_count_histogram": {"1": 1, "2": 1},
                "unique_tile_count": 3,
            },
            "renderer_workspace": {
                "start_address": "0x0041",
                "end_address": "0x0051",
                "fields": [
                    {
                        "name": name,
                        "address": f"0x{address:04X}",
                        "size": size,
                    }
                    for name, address, size
                    in world1_metasprites.RENDERER_RAM_FIELDS
                ],
                "emitter": {
                    "name": world1_metasprites.RENDERER_EMITTER[0],
                    "address": (
                        f"0x{world1_metasprites.RENDERER_EMITTER[1]:04X}"
                    ),
                },
            },
            "signatures": [
                {"address": "0x9200", "bytes": signature.hex(" ")}
            ],
            "covered_byte_count": len(index + records),
            "covered_crc32": world1_metasprites.crc32(index + records),
        }
        objects: dict[str, object] = {
            "schema_version": 1,
            "world1_descriptor_objects": {
                "records": [[1, "0x00", 0, 0], [2, "0x02", 0, 0]]
            },
        }
        return bytes(prg), bytes(chr_data), manifest, objects

    def symbol_registry(self, manifest: dict[str, object]) -> dict[str, object]:
        workspace = manifest["renderer_workspace"]
        return {
            "schema_version": 1,
            "memory_symbols": [
                {
                    **field,
                    "banks": [0],
                }
                for field in workspace["fields"]
            ],
            "symbols": [
                {
                    **workspace["emitter"],
                    "bank": 0,
                }
            ],
        }

    def test_accepts_exact_catalog(self) -> None:
        prg, chr_data, manifest, objects = self.fixture()
        errors, report = world1_metasprites.validate_manifest_data(
            prg, chr_data, manifest, objects
        )
        self.assertEqual(errors, [])
        self.assertEqual(report["metasprite_count"], 2)
        self.assertEqual(report["alias_count"], 1)

    def test_accepts_renderer_workspace_symbols(self) -> None:
        _prg, _chr_data, manifest, _objects = self.fixture()
        self.assertEqual(
            world1_metasprites.validate_renderer_workspace(
                manifest, self.symbol_registry(manifest)
            ),
            [],
        )

    def test_rejects_changed_renderer_ram_symbol(self) -> None:
        _prg, _chr_data, manifest, _objects = self.fixture()
        registry = self.symbol_registry(manifest)
        registry["memory_symbols"][0]["address"] = "0x0040"
        errors = world1_metasprites.validate_renderer_workspace(
            manifest, registry
        )
        self.assertTrue(any("RAM symbol differs" in error for error in errors))

    def test_rejects_changed_oam_emitter_symbol(self) -> None:
        _prg, _chr_data, manifest, _objects = self.fixture()
        registry = self.symbol_registry(manifest)
        registry["symbols"][0]["address"] = "0x9B36"
        errors = world1_metasprites.validate_renderer_workspace(
            manifest, registry
        )
        self.assertTrue(any("emitter symbol differs" in error for error in errors))

    def test_lossless_authoring_roundtrip(self) -> None:
        prg, chr_data, manifest, objects = self.fixture()
        decoded = world1_metasprites.decode_authoring(
            prg, chr_data, manifest, objects
        )
        self.assertEqual(world1_metasprites.apply_authoring(prg, decoded), prg)
        self.assertEqual(decoded["covered_byte_count"], 23)

    def test_allows_piece_and_alias_edits(self) -> None:
        prg, chr_data, manifest, objects = self.fixture()
        decoded = world1_metasprites.decode_authoring(
            prg, chr_data, manifest, objects
        )
        changed = copy.deepcopy(decoded)
        changed["metasprites"][0]["pieces"][0]["tile"] = "0x04"
        changed["index_entries"][1]["flip"] = "vertical"
        rebuilt = world1_metasprites.apply_authoring(prg, changed)
        self.assertEqual(rebuilt[0x110D], 4)
        self.assertEqual(rebuilt[0x1103], 2)

    def test_rejects_pointer_between_records(self) -> None:
        prg, chr_data, manifest, objects = self.fixture()
        changed = bytearray(prg)
        changed[0x1100] = 9
        errors, _report = world1_metasprites.validate_manifest_data(
            bytes(changed), chr_data, manifest, objects
        )
        self.assertTrue(any("miss record starts" in error for error in errors))

    def test_rejects_nested_alias(self) -> None:
        prg, chr_data, manifest, objects = self.fixture()
        changed = bytearray(prg)
        changed[0x1106:0x1108] = bytes((1, 0))
        errors, _report = world1_metasprites.validate_manifest_data(
            bytes(changed), chr_data, manifest, objects
        )
        self.assertTrue(any("nested aliases" in error for error in errors))

    def test_rejects_descriptor_base_alias(self) -> None:
        prg, chr_data, manifest, objects = self.fixture()
        objects["world1_descriptor_objects"]["records"][0][1] = "0x01"
        errors, _report = world1_metasprites.validate_manifest_data(
            prg, chr_data, manifest, objects
        )
        self.assertTrue(any("descriptor bases" in error for error in errors))

    def test_decodes_chr_bitplanes(self) -> None:
        chr_data = bytearray(4 * world1_metasprites.CHR_BANK_SIZE)
        chr_data[3 * 16] = 0x80
        chr_data[3 * 16 + 8] = 0x40
        pixels = world1_metasprites.chr_tile_pixels(bytes(chr_data), 0, 3)
        self.assertEqual(pixels[0][:3], [1, 2, 0])

    def test_resolves_single_alias_and_flip(self) -> None:
        prg, _chr_data, manifest, _objects = self.fixture()
        _data, entries, records = world1_metasprites.manifest_data(prg, manifest)
        record, flip = world1_metasprites.resolved_metasprite(
            entries, records, 1
        )
        self.assertEqual(record["address"], 0x9108)
        self.assertEqual(flip, 1)


if __name__ == "__main__":
    unittest.main()
