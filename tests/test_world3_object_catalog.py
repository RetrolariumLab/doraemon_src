from __future__ import annotations

import copy
import json
from pathlib import Path
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import world3_object_catalog


class World3ObjectCatalogTests(unittest.TestCase):
    def fixture(
        self,
    ) -> tuple[bytes, dict[str, object], dict[str, object]]:
        prg = bytearray(4 * world3_object_catalog.BANK_SIZE)
        bank_offset = 2 * world3_object_catalog.BANK_SIZE
        registry_fields = {
            "room": bytes((1, 2)),
            "type": bytes((3, 4)),
            "x": bytes((0x20, 0x30)),
            "y": bytes((0x40, 0x50)),
            "state": bytes((0, 0)),
        }
        registry_data = b"".join(registry_fields.values())
        registry_offset = bank_offset + 0x1000
        prg[registry_offset:registry_offset + len(registry_data)] = registry_data
        object_data: dict[str, object] = {
            "schema_version": 1,
            "bank": 2,
            "initial_registry": {
                "address": "0x9000",
                "capacity": 2,
                "layout": "structure-of-arrays",
                "crc32": world3_object_catalog.crc32(registry_data),
                "fields": [
                    {"name": name, "values": list(values)}
                    for name, values in registry_fields.items()
                ],
            },
        }

        property_values = {
            "hit_points": bytes((1, 2, 3)),
            "metasprite_base": bytes((0x10, 0x20, 0x30)),
            "render_flags": bytes((0, 1, 2)),
            "contact_damage": bytes((2, 4, 6)),
            "score_reward_code": bytes((0x31, 0x41, 0x51)),
        }
        property_tables = []
        address = 0x9100
        for name, values in property_values.items():
            offset = bank_offset + address - world3_object_catalog.CPU_BASE
            prg[offset:offset + len(values)] = values
            property_tables.append({
                "name": name,
                "address": f"0x{address:04X}",
                "crc32": world3_object_catalog.crc32(values),
                "values": list(values),
            })
            address += len(values)
        entity_types: dict[str, object] = {
            "schema_version": 1,
            "bank": 2,
            "type_count": 3,
            "property_tables": property_tables,
        }
        return bytes(prg), object_data, entity_types

    def test_accepts_valid_manifest_data(self) -> None:
        prg, object_data, entity_types = self.fixture()
        errors, report = world3_object_catalog.validate_manifest_data(
            prg, object_data, entity_types
        )
        self.assertEqual(errors, [])
        self.assertEqual(report["covered_byte_count"], 25)

    def test_lossless_authoring_roundtrip(self) -> None:
        prg, object_data, entity_types = self.fixture()
        decoded = world3_object_catalog.decode_authoring(
            prg, object_data, entity_types
        )
        self.assertEqual(world3_object_catalog.apply_authoring(prg, decoded), prg)
        self.assertEqual(decoded["covered_byte_count"], 25)

    def test_authoring_encoder_transposes_registry_edit(self) -> None:
        prg, object_data, entity_types = self.fixture()
        decoded = world3_object_catalog.decode_authoring(
            prg, object_data, entity_types
        )
        changed = copy.deepcopy(decoded)
        changed["persistent_registry"]["records"][1]["type"] = "0x09"
        encoded = world3_object_catalog.apply_authoring(prg, changed)
        offset = 2 * world3_object_catalog.BANK_SIZE + 0x1000 + 3
        self.assertEqual(encoded[offset], 9)

    def test_authoring_encoder_allows_property_edit(self) -> None:
        prg, object_data, entity_types = self.fixture()
        decoded = world3_object_catalog.decode_authoring(
            prg, object_data, entity_types
        )
        changed = copy.deepcopy(decoded)
        changed["entity_types"]["records"][2]["hit_points"] = "0x0F"
        encoded = world3_object_catalog.apply_authoring(prg, changed)
        offset = 2 * world3_object_catalog.BANK_SIZE + 0x1102
        self.assertEqual(encoded[offset], 0x0F)

    def test_rejects_noncontiguous_type_ids(self) -> None:
        prg, object_data, entity_types = self.fixture()
        decoded = world3_object_catalog.decode_authoring(
            prg, object_data, entity_types
        )
        changed = copy.deepcopy(decoded)
        changed["entity_types"]["records"][1]["id"] = 7
        with self.assertRaisesRegex(ValueError, "ids are not contiguous"):
            world3_object_catalog.encode_authoring(changed)

    def test_authoring_validation_rejects_changed_crc(self) -> None:
        prg, object_data, entity_types = self.fixture()
        decoded = world3_object_catalog.decode_authoring(
            prg, object_data, entity_types
        )
        decoded["covered_crc32"] = "00000000"
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "catalog.json"
            path.write_text(json.dumps(decoded), encoding="utf-8")
            errors = world3_object_catalog.validate_authoring(
                prg, object_data, entity_types, path
            )
        self.assertTrue(any("CRC32 differs" in error for error in errors))

    def test_rejects_changed_manifest_property_byte(self) -> None:
        prg, object_data, entity_types = self.fixture()
        changed = bytearray(prg)
        offset = 2 * world3_object_catalog.BANK_SIZE + 0x1100
        changed[offset] ^= 1
        errors, _report = world3_object_catalog.validate_manifest_data(
            bytes(changed), object_data, entity_types
        )
        self.assertTrue(any("hit_points differs" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
