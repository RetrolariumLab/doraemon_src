from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))

from scripts.validation.world1 import world1_descriptor_identities


class World1DescriptorIdentityTests(unittest.TestCase):
    def fixture(self) -> list[object]:
        prg = bytearray(4 * world1_descriptor_identities.BANK_SIZE)
        symbols = [
            "manhole",
            "anywhere_door",
            "stopwatch",
            "genki_candy",
            "one_up",
            "weapon_upgrade",
            "dorayaki",
            "rapid_fire_drink",
            "flash_light",
            "programmer_face",
            "gold_bar",
            "diamond",
            "invulnerability",
        ]
        metasprites = [
            0x29,
            0x25,
            0x2E,
            0x2D,
            0x2F,
            0,
            0x30,
            0x34,
            0x16,
            0x14,
            0x28,
            0x17,
            0x35,
        ]
        handlers = [0xD237, 0xCC7F] + [0x9000 + index * 0x10 for index in range(11)]
        handler_symbols = [f"FixtureHandler{index:02X}" for index in range(13)]
        selectors = [6, 10, 11, 2, 12]
        placement_counts = [1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0]
        records = [
            [index + 1, metasprites[index], 1, 2] for index in range(13)
        ]
        identities = []
        for index in range(13):
            signature = bytes((0xA0 + index, index))
            signature_address = 0x8200 + index * 2
            offset = signature_address - world1_descriptor_identities.CPU_BASE
            prg[offset:offset + len(signature)] = signature
            entry: dict[str, object] = {
                "descriptor_index": index,
                "runtime_type": index + 1,
                "symbol": symbols[index],
                "display_name": symbols[index],
                "japanese_name": None,
                "category": "fixture",
                "confidence": "confirmed",
                "metasprite_base": metasprites[index],
                "render_flags": 1,
                "primary_behavior": 2,
                "placement_count": placement_counts[index],
                "selector_slots": [
                    slot for slot, value in enumerate(selectors) if value == index
                ],
                "handler_address": handlers[index],
                "handler_symbol": handler_symbols[index],
                "effect": "fixture effect",
                "effect_signature": {
                    "address": signature_address,
                    "bytes": signature.hex(" "),
                },
                "evidence": ["local_rom", "guide"],
            }
            if index == 5:
                entry["dynamic_metasprites"] = [0x2A, 0x2B, 0x2C]
            identities.append(entry)
        manifest = {
            "schema_version": 1,
            "bank": 0,
            "descriptor_count": 13,
            "identity_sources": [
                {"id": "local_rom", "url": None},
                {"id": "guide", "url": "https://example.com"},
            ],
            "identities": identities,
        }
        objects = {
            "world1_descriptor_objects": {
                "bank": 0,
                "records": records,
                "transient_selector_table": {"values": selectors},
            }
        }
        authoring = {
            "placement_lists": [
                {
                    "records": [
                        {"type": 0x80 | index}
                        for index, count in enumerate(placement_counts)
                        for _ in range(count)
                    ]
                }
            ]
        }
        dispatch = {
            "tables": [
                {
                    "name": "world1_city_item_handlers",
                    "bank": 0,
                    "targets": handlers[2:],
                }
            ]
        }
        metasprite_catalog = {
            "index_entries": [
                {"id": index, "kind": "direct"}
                for index in sorted(set(metasprites) - {0})
            ]
        }
        symbol_registry = {
            "symbols": [
                {
                    "bank": 0,
                    "address": handlers[index],
                    "name": handler_symbols[index],
                }
                for index in range(13)
            ]
        }
        return [
            bytes(prg),
            manifest,
            objects,
            authoring,
            dispatch,
            metasprite_catalog,
            symbol_registry,
        ]

    def test_accepts_complete_identity_catalog(self) -> None:
        errors, report = world1_descriptor_identities.validate(*self.fixture())
        self.assertEqual(errors, [])
        self.assertEqual(report["descriptor_count"], 13)
        self.assertEqual(report["selector_count"], 5)

    def test_rejects_descriptor_field_mismatch(self) -> None:
        values = self.fixture()
        values[2]["world1_descriptor_objects"]["records"][0][1] ^= 1
        errors, _report = world1_descriptor_identities.validate(*values)
        self.assertTrue(any("metasprite base differs" in error for error in errors))

    def test_rejects_placement_count_mismatch(self) -> None:
        values = self.fixture()
        values[3]["placement_lists"][0]["records"].append({"type": 0x80})
        errors, _report = world1_descriptor_identities.validate(*values)
        self.assertTrue(any("placement count differs" in error for error in errors))

    def test_rejects_selector_change(self) -> None:
        values = self.fixture()
        values[2]["world1_descriptor_objects"]["transient_selector_table"][
            "values"
        ][0] = 5
        errors, _report = world1_descriptor_identities.validate(*values)
        self.assertTrue(any("selector identities differ" in error for error in errors))

    def test_rejects_handler_mapping_change(self) -> None:
        values = self.fixture()
        values[4]["tables"][0]["targets"][0] ^= 1
        errors, _report = world1_descriptor_identities.validate(*values)
        self.assertTrue(any("handler mapping differs" in error for error in errors))

    def test_rejects_handler_symbol_change(self) -> None:
        values = self.fixture()
        values[6]["symbols"][0]["name"] = "WrongHandler"
        errors, _report = world1_descriptor_identities.validate(*values)
        self.assertTrue(any("handler symbol differs" in error for error in errors))

    def test_rejects_effect_signature_change(self) -> None:
        values = self.fixture()
        changed = bytearray(values[0])
        changed[0x200] ^= 1
        values[0] = bytes(changed)
        errors, _report = world1_descriptor_identities.validate(*values)
        self.assertTrue(any("effect signature differs" in error for error in errors))

    def test_rejects_confirmed_identity_without_external_source(self) -> None:
        values = self.fixture()
        changed = copy.deepcopy(values[1])
        changed["identities"][0]["evidence"] = ["local_rom"]
        values[1] = changed
        errors, _report = world1_descriptor_identities.validate(*values)
        self.assertTrue(any("lacks external evidence" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
