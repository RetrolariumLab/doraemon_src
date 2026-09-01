from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest
import zlib


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import object_placements


class ObjectPlacementTests(unittest.TestCase):
    def fixture(self) -> tuple[bytes, dict[str, object]]:
        prg = bytearray(4 * object_placements.BANK_SIZE)
        data = bytes((5, 7, 1, 10, 8, 0x82, 20, 9, 0xC3, 0))
        prg[:len(data)] = data
        document = {
            "schema_version": 1,
            "formats": {
                "placements": {
                    "record_size": 3,
                    "fields": ["x_cell", "y_cell", "type"],
                    "terminator_field": "x_cell",
                    "terminator_value": 0,
                    "always_scanned_prefix": 1,
                    "normal_type_max": 11,
                    "descriptor_count": 16,
                }
            },
            "lists": [
                {
                    "id": "objects",
                    "format": "placements",
                    "bank": 0,
                    "address": "0x8000",
                    "record_count": 3,
                    "terminator_address": "0x8009",
                    "crc32_with_terminator": f"{zlib.crc32(data) & 0xFFFFFFFF:08x}",
                }
            ],
        }
        return bytes(prg), document

    def test_accepts_valid_placement_list(self) -> None:
        prg, document = self.fixture()
        errors, report = object_placements.validate(prg, document)
        self.assertEqual(errors, [])
        self.assertEqual(report["record_count"], 3)
        self.assertEqual(report["descriptor_count"], 2)

    def test_rejects_early_x_terminator(self) -> None:
        prg, document = self.fixture()
        changed = bytearray(prg)
        changed[3] = 0
        errors, _report = object_placements.validate(bytes(changed), document)
        self.assertTrue(any("terminator appears" in error for error in errors))

    def test_rejects_wrong_record_boundary(self) -> None:
        prg, document = self.fixture()
        changed = copy.deepcopy(document)
        changed["lists"][0]["terminator_address"] = "0x8008"
        errors, _report = object_placements.validate(prg, changed)
        self.assertTrue(any("record boundary" in error for error in errors))

    def test_rejects_unsorted_tail(self) -> None:
        prg, document = self.fixture()
        changed = bytearray(prg)
        changed[3], changed[6] = changed[6], changed[3]
        changed_document = copy.deepcopy(document)
        data = bytes(changed[:10])
        changed_document["lists"][0]["crc32_with_terminator"] = (
            f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"
        )
        errors, _report = object_placements.validate(bytes(changed), changed_document)
        self.assertTrue(any("not sorted" in error for error in errors))

    def test_rejects_invalid_descriptor_type(self) -> None:
        prg, document = self.fixture()
        changed = bytearray(prg)
        changed[5] = 0x92
        changed_document = copy.deepcopy(document)
        data = bytes(changed[:10])
        changed_document["lists"][0]["crc32_with_terminator"] = (
            f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"
        )
        errors, _report = object_placements.validate(bytes(changed), changed_document)
        self.assertTrue(any("invalid descriptor" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
