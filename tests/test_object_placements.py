from __future__ import annotations

import copy
import json
from pathlib import Path
import sys
import tempfile
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
        descriptors = bytes((
            1, 0x10, 1, 1,
            2, 0x11, 1, 1,
            3, 0x12, 1, 1,
            4, 0x13, 1, 2,
        ))
        collision_tables = [
            (0x810F, bytes((2, 4, 4, 4, 4)), "runtime_type"),
            (0x8113, bytes((4, 5, 5, 5, 5)), "runtime_type"),
            (0x8130, bytes((6, 6, 6, 6)), "runtime_type_minus_one"),
        ]
        transient = bytes((0, 3))
        prg[0x100:0x100 + len(descriptors)] = descriptors
        for address, values, _indexing in collision_tables:
            offset = address - object_placements.CPU_BASE
            prg[offset:offset + len(values)] = values
        prg[0x140:0x140 + len(transient)] = transient
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
                    "descriptor_count": 4,
                }
            },
            "world1_descriptor_objects": {
                "bank": 0,
                "address": "0x8100",
                "record_size": 4,
                "record_count": 4,
                "crc32": f"{zlib.crc32(descriptors) & 0xFFFFFFFF:08x}",
                "fields": [
                    "runtime_type",
                    "metasprite_base",
                    "render_flags",
                    "primary_behavior",
                ],
                "records": [
                    [1, 0x10, 1, 1],
                    [2, 0x11, 1, 1],
                    [3, 0x12, 1, 1],
                    [4, 0x13, 1, 2],
                ],
                "placement_encoding": {
                    "descriptor_flag": "0x80",
                    "runtime_high_flag": "0x40",
                    "selector_mask": "0x0F",
                    "forbidden_mask": "0x30",
                    "expected_record_count": 2,
                    "expected_runtime_high_flag_count": 1,
                    "expected_index_counts": {"2": 1, "3": 1},
                },
                "transient_selector_table": {
                    "address": "0x8140",
                    "values": [0, 3],
                    "crc32": f"{zlib.crc32(transient) & 0xFFFFFFFF:08x}",
                },
                "collision_tables": [
                    {
                        "name": f"collision_{index}",
                        "address": f"0x{address:04X}",
                        "indexing": indexing,
                        "values": list(values),
                        "crc32": f"{zlib.crc32(values) & 0xFFFFFFFF:08x}",
                    }
                    for index, (address, values, indexing) in enumerate(
                        collision_tables
                    )
                ],
                "shared_boundaries": [
                    {
                        "left": "descriptor_table",
                        "left_last_byte": "0x810F",
                        "right": "collision_0",
                        "right_first_byte": "0x810F",
                    },
                    {
                        "left": "collision_0",
                        "left_last_byte": "0x8113",
                        "right": "collision_1",
                        "right_first_byte": "0x8113",
                    },
                ],
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
        self.assertEqual(report["descriptor_definition_count"], 4)

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

    def test_rejects_descriptor_index_past_exact_table(self) -> None:
        prg, document = self.fixture()
        changed = bytearray(prg)
        changed[5] = 0x84
        changed_document = copy.deepcopy(document)
        data = bytes(changed[:10])
        changed_document["lists"][0]["crc32_with_terminator"] = (
            f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"
        )
        changed_document["world1_descriptor_objects"]["placement_encoding"][
            "expected_index_counts"
        ] = {"3": 1, "4": 1}
        errors, _report = object_placements.validate(bytes(changed), changed_document)
        self.assertTrue(any("invalid descriptor" in error for error in errors))

    def test_rejects_changed_descriptor_table(self) -> None:
        prg, document = self.fixture()
        changed = bytearray(prg)
        changed[0x100] ^= 1
        errors, _report = object_placements.validate(bytes(changed), document)
        self.assertTrue(any("descriptor table differs" in error for error in errors))

    def test_rejects_changed_descriptor_collision_table(self) -> None:
        prg, document = self.fixture()
        changed = bytearray(prg)
        changed[0x114] ^= 1
        errors, _report = object_placements.validate(bytes(changed), document)
        self.assertTrue(any("collision table differs" in error for error in errors))

    def test_rejects_changed_descriptor_usage_signature(self) -> None:
        prg, document = self.fixture()
        changed = bytearray(prg)
        changed[5] = 0x83
        changed_document = copy.deepcopy(document)
        data = bytes(changed[:10])
        changed_document["lists"][0]["crc32_with_terminator"] = (
            f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"
        )
        errors, _report = object_placements.validate(bytes(changed), changed_document)
        self.assertTrue(any("index counts differ" in error for error in errors))

    def test_rejects_changed_shared_boundary(self) -> None:
        prg, document = self.fixture()
        changed = copy.deepcopy(document)
        changed["world1_descriptor_objects"]["shared_boundaries"][1][
            "right_first_byte"
        ] = "0x8114"
        errors, _report = object_placements.validate(prg, changed)
        self.assertTrue(any("shared boundary differs" in error for error in errors))

    def test_lossless_authoring_roundtrip(self) -> None:
        prg, document = self.fixture()
        decoded = object_placements.decode_authoring(prg, document)
        self.assertEqual(object_placements.apply_authoring(prg, decoded), prg)
        self.assertEqual(decoded["covered_byte_count"], 40)

    def test_authoring_encoder_allows_placement_edits(self) -> None:
        prg, document = self.fixture()
        decoded = object_placements.decode_authoring(prg, document)
        changed = copy.deepcopy(decoded)
        changed["placement_lists"][0]["records"][0]["x_cell"] = 6
        encoded = object_placements.apply_authoring(prg, changed)
        self.assertEqual(encoded[0], 6)

    def test_authoring_encoder_rejects_conflicting_shared_byte(self) -> None:
        prg, document = self.fixture()
        decoded = object_placements.decode_authoring(prg, document)
        changed = copy.deepcopy(decoded)
        changed["descriptor_objects"]["records"][3]["primary_behavior"] = "0x03"
        with self.assertRaisesRegex(ValueError, "conflicts with another region"):
            object_placements.encode_authoring(changed)

    def test_authoring_validation_rejects_changed_crc(self) -> None:
        prg, document = self.fixture()
        decoded = object_placements.decode_authoring(prg, document)
        decoded["covered_crc32"] = "00000000"
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "objects.json"
            path.write_text(json.dumps(decoded), encoding="utf-8")
            errors = object_placements.validate_authoring(prg, document, path)
        self.assertTrue(any("CRC32 differs" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
