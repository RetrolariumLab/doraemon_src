from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import world2_metasprites


class World2MetaspriteTests(unittest.TestCase):
    def fixture(self) -> tuple[bytes, bytes, dict[str, object], dict[str, object], dict[str, object], dict[str, object], dict[str, object]]:
        bank = 1
        tile_address = 0xA000
        descriptor_address = 0xA008
        attribute_address = 0xA020
        tiles = bytes(range(1, 9))
        descriptors = bytes((0x00, 0x05))
        attributes = bytes(34) + b"\x40\x40"
        prg = bytearray(4 * world2_metasprites.BANK_SIZE)

        def write(address: int, data: bytes) -> None:
            offset = bank * world2_metasprites.BANK_SIZE + address - 0x8000
            prg[offset:offset + len(data)] = data

        write(tile_address, tiles)
        write(descriptor_address, descriptors)
        write(attribute_address, attributes)
        combined = tiles + descriptors + attributes
        chr_data = bytes(4 * world2_metasprites.CHR_BANK_SIZE)
        chr_bank = chr_data[0x2000:0x4000]
        state_indexes = [
            {
                "state": state,
                "indexes": [] if state in (9, 17) else [0],
            }
            for state in range(1, 21)
        ]
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": bank,
            "chr_bank": 1,
            "chr_bank_crc32": world2_metasprites.crc32(chr_bank),
            "sprite_pattern_table": "0x0000",
            "metasprites": {
                "tile_quad_address": hex(tile_address),
                "descriptor_address": hex(descriptor_address),
                "count": 2,
                "tile_order": [
                    "top_left", "top_right", "bottom_left", "bottom_right"
                ],
                "descriptor_fields": [
                    "palette_low_2_bits",
                    "oam_attribute_base_bits_2_to_5",
                ],
                "tile_quad_crc32": world2_metasprites.crc32(tiles),
                "descriptor_crc32": world2_metasprites.crc32(descriptors),
            },
            "oam_attribute_lookup": {
                "address": hex(attribute_address),
                "count": 36,
                "allowed_mask": "0xE0",
                "crc32": world2_metasprites.crc32(attributes),
            },
            "shared_storage": {
                "descriptor_last_byte": {
                    "address": hex(descriptor_address + 1),
                    "enemy_property_table": "attack_period_by_state",
                    "enemy_property_index": 0,
                },
                "attribute_last_two_bytes": {
                    "address": hex(attribute_address + 34),
                    "object_dispatch_table": "world2_enemy_render_handlers",
                },
            },
            "enemy_state_render_indexes": state_indexes,
            "sprite_palette_records": [6, 7, 8],
            "expected_metrics": {
                "unique_tile_count": 8,
                "zero_tile_piece_count": 0,
                "palette_histogram": [1, 1, 0, 0],
                "attribute_base_histogram": {"0x00": 1, "0x04": 1},
                "enemy_referenced_index_count": 1,
                "enemy_unreferenced_indexes": [1],
            },
            "signatures": [],
            "covered_byte_count": len(combined),
            "covered_crc32": world2_metasprites.crc32(combined),
        }
        enemy_states: dict[str, object] = {
            "property_tables": [
                {
                    "name": "attack_period_by_state",
                    "address": hex(descriptor_address + 1),
                }
            ]
        }
        enemy_handlers: dict[str, object] = {
            "states": [
                {
                    "state": state,
                    "render_role": (
                        "no-op invisible render state"
                        if state in (9, 17)
                        else "visible fixture"
                    ),
                }
                for state in range(1, 21)
            ]
        }
        dispatch: dict[str, object] = {
            "tables": [
                {
                    "name": "world2_enemy_render_handlers",
                    "address": hex(attribute_address + 36),
                }
            ]
        }
        palettes: dict[str, object] = {
            "initial_sprite_offsets": {"palette_records": [6, 7, 8]}
        }
        return (
            bytes(prg), chr_data, manifest, enemy_states,
            enemy_handlers, dispatch, palettes,
        )

    def validate_fixture(self, values: tuple[object, ...]) -> list[str]:
        errors, _report = world2_metasprites.validate_manifest_data(*values)
        return errors

    def test_accepts_exact_fixed_catalog(self) -> None:
        values = self.fixture()
        errors, report = world2_metasprites.validate_manifest_data(*values)
        self.assertEqual(errors, [])
        self.assertEqual(report["record_count"], 2)

    def test_lossless_authoring_roundtrip(self) -> None:
        prg, _chr, manifest, *_rest = self.fixture()
        document = world2_metasprites.decode_authoring(prg, manifest)
        encoded = world2_metasprites.encode_authoring(document)
        canonical = world2_metasprites.raw_data(prg, manifest)
        self.assertEqual(
            bytes(encoded[address] for address in sorted(encoded)),
            b"".join(canonical.values()),
        )

    def test_authoring_encoder_allows_tile_edit(self) -> None:
        prg, _chr, manifest, *_rest = self.fixture()
        document = world2_metasprites.decode_authoring(prg, manifest)
        document["metasprites"][0]["tiles"][0] = "0x44"
        document["covered_crc32"] = world2_metasprites.crc32(
            bytes(
                value
                for _address, value in sorted(
                    world2_metasprites.encode_authoring(document).items()
                )
            )
        )
        changed = world2_metasprites.apply_authoring(prg, document)
        self.assertNotEqual(changed, prg)

    def test_rejects_changed_tile_byte(self) -> None:
        values = list(self.fixture())
        changed = bytearray(values[0])
        changed[world2_metasprites.BANK_SIZE + 0x2000] ^= 1
        values[0] = bytes(changed)
        errors = self.validate_fixture(tuple(values))
        self.assertTrue(any("tile_quads CRC32 differs" in error for error in errors))

    def test_rejects_unsupported_oam_attribute(self) -> None:
        values = list(self.fixture())
        changed = bytearray(values[0])
        changed[world2_metasprites.BANK_SIZE + 0x2020] = 1
        values[0] = bytes(changed)
        errors = self.validate_fixture(tuple(values))
        self.assertTrue(any("unsupported bits" in error for error in errors))

    def test_rejects_attribute_overlap_change(self) -> None:
        values = list(self.fixture())
        changed = copy.deepcopy(values[2])
        changed["shared_storage"]["attribute_last_two_bytes"]["address"] = "0xA041"
        values[2] = changed
        errors = self.validate_fixture(tuple(values))
        self.assertTrue(any("attribute/render-prefix overlap" in error for error in errors))

    def test_rejects_enemy_index_outside_catalog(self) -> None:
        values = list(self.fixture())
        changed = copy.deepcopy(values[2])
        changed["enemy_state_render_indexes"][0]["indexes"] = [2]
        values[2] = changed
        errors = self.validate_fixture(tuple(values))
        self.assertTrue(any("leaves the catalog" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
