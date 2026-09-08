from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))

from scripts.validation.world3 import world3_object_data


class World3ObjectDataTests(unittest.TestCase):
    def fixture(self) -> tuple[bytes, dict[str, object]]:
        prg = bytearray(4 * world3_object_data.BANK_SIZE)
        bank_offset = 2 * world3_object_data.BANK_SIZE

        def write(address: int, data: bytes) -> None:
            offset = bank_offset + address - world3_object_data.CPU_BASE
            prg[offset:offset + len(data)] = data

        field_values = {
            "room": [1, 2],
            "type": [0x18, 0x19],
            "x": [0x40, 0x80],
            "y": [0x50, 0x90],
            "state": [0, 0],
        }
        registry_data = bytes(
            value for values in field_values.values() for value in values
        )
        pointer_data = bytes((0x20, 0x82, 0x21, 0x82))
        stream_data = bytes((0xF0, 0xF1))
        write(0x8100, registry_data)
        write(0x8110, pointer_data)
        write(0x8220, stream_data)
        document: dict[str, object] = {
            "schema_version": 1,
            "bank": 2,
            "initial_registry": {
                "address": "0x8100",
                "capacity": 2,
                "layout": "structure-of-arrays",
                "crc32": world3_object_data.crc32(registry_data),
                "fields": [
                    {"name": name, "values": values}
                    for name, values in field_values.items()
                ],
                "type_shuffle_groups": [
                    {"start": 0, "count": 2, "multiset": [0x18, 0x19]}
                ],
                "fixed_type_slots": {},
            },
            "behavior_pointer_table": {
                "address": "0x8110",
                "slot_count": 2,
                "crc32": world3_object_data.crc32(pointer_data),
                "targets": ["0x8220", "0x8221"],
            },
            "behavior_streams": {
                "address": "0x8220",
                "end_address": "0x8221",
                "crc32": world3_object_data.crc32(stream_data),
            },
        }
        return bytes(prg), document

    def test_accepts_valid_world3_object_data(self) -> None:
        prg, document = self.fixture()
        errors, report = world3_object_data.validate(prg, document)
        self.assertEqual(errors, [])
        self.assertEqual(report["object_count"], 2)
        self.assertEqual(report["behavior_pointer_count"], 2)

    def test_rejects_changed_registry_byte(self) -> None:
        prg, document = self.fixture()
        changed = bytearray(prg)
        offset = 2 * world3_object_data.BANK_SIZE + 0x100
        changed[offset] ^= 1
        errors, _report = world3_object_data.validate(bytes(changed), document)
        self.assertTrue(any("registry differs" in error for error in errors))

    def test_rejects_wrong_field_order(self) -> None:
        prg, document = self.fixture()
        changed = copy.deepcopy(document)
        fields = changed["initial_registry"]["fields"]
        fields[0], fields[1] = fields[1], fields[0]
        errors, _report = world3_object_data.validate(prg, changed)
        self.assertTrue(any("field order differs" in error for error in errors))

    def test_rejects_changed_shuffle_multiset(self) -> None:
        prg, document = self.fixture()
        changed = copy.deepcopy(document)
        changed["initial_registry"]["type_shuffle_groups"][0]["multiset"] = [
            0x18,
            0x18,
        ]
        errors, _report = world3_object_data.validate(prg, changed)
        self.assertTrue(any("shuffle group" in error for error in errors))

    def test_rejects_behavior_pointer_outside_streams(self) -> None:
        prg, document = self.fixture()
        changed = copy.deepcopy(document)
        changed["behavior_pointer_table"]["targets"][1] = "0x8300"
        errors, _report = world3_object_data.validate(prg, changed)
        self.assertTrue(any("outside declared streams" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
