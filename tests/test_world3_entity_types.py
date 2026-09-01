from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import world3_entity_types


class World3EntityTypeTests(unittest.TestCase):
    def fixture(
        self,
    ) -> tuple[bytes, dict[str, object], dict[str, object], dict[str, object]]:
        prg = bytearray(4 * world3_entity_types.BANK_SIZE)
        bank_offset = 2 * world3_entity_types.BANK_SIZE

        def write(address: int, data: bytes) -> None:
            offset = bank_offset + address - world3_entity_types.CPU_BASE
            prg[offset:offset + len(data)] = data

        properties = bytes((1, 2, 3, 4))
        initializers = bytes((0x00, 0xA0, 0x10, 0xA0))
        behaviors = bytes((0x00, 0xB0, 0x10, 0xB0))
        updates = bytes((0x00, 0xC0, 0x10, 0xC0, 0x20, 0xC0, 0x20, 0xC0))
        signature = bytes((0x18, 0x69, 0x02))
        write(0x9000, properties)
        write(0x9010, initializers)
        write(0x9020, updates)
        write(0x9030, behaviors)
        write(0x9040, signature)
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": 2,
            "type_count": 4,
            "property_tables": [
                {
                    "name": "property",
                    "address": "0x9000",
                    "crc32": world3_entity_types.crc32(properties),
                    "values": [1, 2, 3, 4],
                }
            ],
            "dispatch_contracts": [
                {
                    "name": "world3_spawn_initializers",
                    "address": "0x9010",
                    "slot_count": 2,
                    "crc32": world3_entity_types.crc32(initializers),
                    "expected_unique_target_count": 2,
                },
                {
                    "name": "world3_entity_update_handlers",
                    "address": "0x9020",
                    "slot_count": 4,
                    "crc32": world3_entity_types.crc32(updates),
                    "expected_unique_target_count": 3,
                },
                {
                    "name": "behavior_pointer_table",
                    "address": "0x9030",
                    "slot_count": 2,
                    "crc32": world3_entity_types.crc32(behaviors),
                    "expected_unique_target_count": 2,
                },
            ],
            "domains": [
                {"name": "scripted_spawn_types", "types": [0, 1]},
                {"name": "initial_persistent_types", "types": [2]},
                {"name": "derived_persistent_types", "types": [3]},
            ],
            "initial_persistent_type_multiset": [2],
            "code_relationships": [
                {
                    "name": "fixture_conversion",
                    "address": "0x9040",
                    "bytes": "18 69 02",
                    "source_types": [0],
                    "result_types": [2],
                }
            ],
        }
        dispatch: dict[str, object] = {
            "tables": [
                {
                    "name": "world3_spawn_initializers",
                    "bank": 2,
                    "address": "0x9010",
                    "slot_count": 2,
                    "targets": ["0xA000", "0xA010"],
                },
                {
                    "name": "world3_entity_update_handlers",
                    "bank": 2,
                    "address": "0x9020",
                    "slot_count": 4,
                    "targets": ["0xC000", "0xC010", "0xC020", "0xC020"],
                },
            ]
        }
        object_data: dict[str, object] = {
            "bank": 2,
            "initial_registry": {
                "fields": [{"name": "type", "values": [2]}]
            },
            "behavior_pointer_table": {
                "name": "behavior_pointer_table",
                "address": "0x9030",
                "slot_count": 2,
                "targets": ["0xB000", "0xB010"],
            },
        }
        return bytes(prg), manifest, dispatch, object_data

    def test_accepts_complete_catalog(self) -> None:
        prg, manifest, dispatch, object_data = self.fixture()
        errors, report = world3_entity_types.validate(
            prg, manifest, dispatch, object_data
        )
        self.assertEqual(errors, [])
        self.assertEqual(report["type_count"], 4)
        self.assertEqual(report["property_table_count"], 1)

    def test_rejects_changed_property_byte(self) -> None:
        prg, manifest, dispatch, object_data = self.fixture()
        changed = bytearray(prg)
        changed[2 * world3_entity_types.BANK_SIZE + 0x1000] ^= 1
        errors, _report = world3_entity_types.validate(
            bytes(changed), manifest, dispatch, object_data
        )
        self.assertTrue(any("property table differs" in error for error in errors))

    def test_rejects_domain_gap(self) -> None:
        prg, manifest, dispatch, object_data = self.fixture()
        changed = copy.deepcopy(manifest)
        changed["domains"][2]["types"] = []
        errors, _report = world3_entity_types.validate(
            prg, changed, dispatch, object_data
        )
        self.assertTrue(any("do not partition" in error for error in errors))

    def test_rejects_registry_type_mismatch(self) -> None:
        prg, manifest, dispatch, object_data = self.fixture()
        changed = copy.deepcopy(object_data)
        changed["initial_registry"]["fields"][0]["values"] = [3]
        errors, _report = world3_entity_types.validate(
            prg, manifest, dispatch, changed
        )
        self.assertTrue(any("multiset differs" in error for error in errors))

    def test_rejects_changed_relationship_signature(self) -> None:
        prg, manifest, dispatch, object_data = self.fixture()
        changed = bytearray(prg)
        changed[2 * world3_entity_types.BANK_SIZE + 0x1040] ^= 1
        errors, _report = world3_entity_types.validate(
            bytes(changed), manifest, dispatch, object_data
        )
        self.assertTrue(any("code signature differs" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
