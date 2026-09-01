from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import world_data


class WorldDataTests(unittest.TestCase):
    def fixture(self) -> tuple[bytes, dict[str, object]]:
        prg = bytearray(4 * world_data.BANK_SIZE)
        attributes = bytes((0x01, 0x06))
        small = bytes((0, 1, 2, 3, 4, 5, 6, 7))
        big = bytes((0, 1, 1, 0, 1, 0, 0, 1))
        map_data = bytes((0, 1))
        payload = attributes + small + big + map_data
        start = 0x9000
        offset = start - world_data.CPU_BASE
        prg[offset:offset + len(payload)] = payload
        document: dict[str, object] = {
            "schema_version": 1,
            "worlds": [
                {
                    "id": "test",
                    "bank": 0,
                    "address": "0x9000",
                    "end_address": "0x9013",
                    "crc32": world_data.crc32(payload),
                    "expected_used_big_block_count": 2,
                    "attributes": {
                        "address": "0x9000",
                        "count": 2,
                        "crc32": world_data.crc32(attributes),
                        "expected_palette_counts": {"1": 1, "2": 1},
                        "expected_property_value_count": 2,
                    },
                    "small_blocks": {
                        "address": "0x9002",
                        "count": 2,
                        "width": 2,
                        "height": 2,
                        "crc32": world_data.crc32(small),
                        "expected_unique_tile_count": 8,
                    },
                    "big_blocks": {
                        "address": "0x900A",
                        "count": 2,
                        "width": 2,
                        "height": 2,
                        "crc32": world_data.crc32(big),
                        "expected_referenced_small_block_count": 2,
                    },
                    "maps": [
                        {
                            "id": "fixture",
                            "address": "0x9012",
                            "width": 2,
                            "height": 1,
                            "crc32": world_data.crc32(map_data),
                            "expected_used_big_block_count": 2,
                        }
                    ],
                }
            ],
        }
        return bytes(prg), document

    def test_accepts_valid_hierarchy(self) -> None:
        prg, document = self.fixture()
        errors, report = world_data.validate(prg, document)
        self.assertEqual(errors, [])
        self.assertEqual(report["test"]["payload_size"], 20)
        self.assertEqual(report["test"]["used_big_block_count"], 2)

    def test_lossless_authoring_roundtrip(self) -> None:
        prg, document = self.fixture()
        decoded = world_data.decode_authoring(prg, document, "test")
        expected = prg[0x1000:0x1014]
        self.assertEqual(world_data.encode_authoring(decoded), expected)
        self.assertEqual(decoded["attributes"]["entries"][1]["properties"], "0x01")

    def test_authoring_encoder_allows_tile_edits(self) -> None:
        prg, document = self.fixture()
        decoded = world_data.decode_authoring(prg, document, "test")
        changed = copy.deepcopy(decoded)
        changed["small_blocks"]["entries"][0]["tiles"][0] = "0xFE"
        encoded = world_data.encode_authoring(changed)
        self.assertEqual(encoded[2], 0xFE)

    def test_authoring_encoder_preserves_property_bits(self) -> None:
        prg, document = self.fixture()
        decoded = world_data.decode_authoring(prg, document, "test")
        changed = copy.deepcopy(decoded)
        changed["attributes"]["entries"][1]["palette"] = 3
        encoded = world_data.encode_authoring(changed)
        self.assertEqual(encoded[1], 0x07)

    def test_rejects_wrong_map_row_width(self) -> None:
        prg, document = self.fixture()
        decoded = world_data.decode_authoring(prg, document, "test")
        changed = copy.deepcopy(decoded)
        changed["maps"][0]["rows"][0] = "00"
        with self.assertRaisesRegex(ValueError, "must contain 2 cells"):
            world_data.encode_authoring(changed)

    def test_rejects_noncontiguous_entry_ids(self) -> None:
        prg, document = self.fixture()
        decoded = world_data.decode_authoring(prg, document, "test")
        changed = copy.deepcopy(decoded)
        changed["big_blocks"]["entries"][1]["id"] = 3
        with self.assertRaisesRegex(ValueError, "ids are not contiguous"):
            world_data.encode_authoring(changed)

    def test_rejects_changed_prg_data(self) -> None:
        prg, document = self.fixture()
        changed = bytearray(prg)
        changed[0x1000] ^= 1
        errors, _report = world_data.validate(bytes(changed), document)
        self.assertTrue(any("payload CRC32 differs" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
