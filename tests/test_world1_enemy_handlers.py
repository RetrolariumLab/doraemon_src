from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import world1_enemy_handlers


class World1EnemyHandlerTests(unittest.TestCase):
    def fixture(self) -> list[object]:
        bank = 0
        prg = bytearray(4 * world1_enemy_handlers.BANK_SIZE)

        def write(address: int, data: bytes) -> None:
            offset = address - world1_enemy_handlers.CPU_BASE
            prg[offset:offset + len(data)] = data

        targets = [0x8100] + [0x8200 + state * 0x10 for state in range(1, 16)]
        targets[13] = targets[1]
        targets[15] = targets[14]
        raw_dispatch = b"".join(
            bytes(((target - 1) & 0xFF, (target - 1) >> 8))
            for target in targets
        )
        write(0x9000, raw_dispatch)
        initial_metasprites = list(range(12)) + [0] * 4
        render_flags = [1] * 12 + [0] * 4
        health = [2] * 12 + [0] * 4
        rewards = [0x41] * 16
        property_specs = [
            ("initial_metasprite_by_placement_type", 0x9100, initial_metasprites),
            ("initial_render_flags_by_placement_type", 0x9110, render_flags),
            ("initial_health_by_placement_type", 0x9120, health),
            ("score_reward_code_by_runtime_state", 0x9130, rewards),
        ]
        for _name, address, values in property_specs:
            write(address, bytes(values))
        signature = bytes((0xA5, 0x90, 0x29, 0x7F))
        write(0x9200, signature)

        dispatch = {
            "tables": [{
                "name": "world1_entity_update_handlers",
                "bank": bank,
                "address": "0x9000",
                "slot_count": 16,
                "targets": [hex(value) for value in targets],
            }]
        }
        placements = {
            "placement_lists": [{
                "records": [
                    {"type": hex(placement_type)}
                    for placement_type in range(12)
                ]
            }]
        }
        metasprites = {
            "index_entries": [
                {"id": index, "kind": "direct"} for index in range(12)
            ]
        }
        symbols = {
            "symbols": [
                {
                    "bank": bank,
                    "address": hex(address),
                    "name": f"Handler_{address:04X}",
                }
                for address in sorted(set(targets[1:]))
            ]
        }
        states = []
        for state in range(1, 16):
            if state <= 12:
                lifecycle = "direct_placement"
                entry = {
                    "state": state,
                    "lifecycle": lifecycle,
                    "placement_type": state - 1,
                    "placement_count": 1,
                    "initial_metasprite": hex(initial_metasprites[state - 1]),
                    "initial_render_flags": render_flags[state - 1],
                    "initial_health": health[state - 1],
                }
            elif state == 13:
                entry = {
                    "state": state,
                    "lifecycle": "dormant_dispatch_state",
                    "placement_count": 0,
                }
            else:
                entry = {
                    "state": state,
                    "lifecycle": "scripted_boss_state",
                    "placement_count": 0,
                }
            entry.update({
                "identity_symbol": f"fixture_{state:02x}",
                "score_reward_code": hex(rewards[state]),
                "update_address": hex(targets[state]),
                "update_symbol": f"Handler_{targets[state]:04X}",
            })
            states.append(entry)
        manifest = {
            "schema_version": 1,
            "bank": bank,
            "state_count": 15,
            "placement_counts": {str(index): 1 for index in range(12)},
            "property_tables": [
                {
                    "name": name,
                    "address": hex(address),
                    "values": values,
                    "crc32": world1_enemy_handlers.crc32(bytes(values)),
                }
                for name, address, values in property_specs
            ],
            "states": states,
            "signatures": [{
                "name": "materialization",
                "address": "0x9200",
                "bytes": signature.hex(" "),
            }],
        }
        return [bytes(prg), manifest, dispatch, placements, metasprites, symbols]

    def test_accepts_complete_handler_graph(self) -> None:
        errors, report = world1_enemy_handlers.validate(*self.fixture())
        self.assertEqual(errors, [])
        self.assertEqual(report["state_count"], 15)
        self.assertEqual(report["placement_count"], 12)

    def test_rejects_changed_dispatch_bytes(self) -> None:
        values = self.fixture()
        changed = bytearray(values[0])
        changed[0x1002] ^= 1
        values[0] = bytes(changed)
        errors, _report = world1_enemy_handlers.validate(*values)
        self.assertTrue(any("dispatch bytes differ" in error for error in errors))

    def test_rejects_placement_histogram_change(self) -> None:
        values = self.fixture()
        values[3]["placement_lists"][0]["records"].append({"type": "0x00"})
        errors, _report = world1_enemy_handlers.validate(*values)
        self.assertTrue(any("placement count differs" in error for error in errors))

    def test_rejects_property_change(self) -> None:
        values = self.fixture()
        changed = bytearray(values[0])
        changed[0x1100] ^= 1
        values[0] = bytes(changed)
        errors, _report = world1_enemy_handlers.validate(*values)
        self.assertTrue(any("property bytes differ" in error for error in errors))

    def test_rejects_state_handler_change(self) -> None:
        values = self.fixture()
        changed = copy.deepcopy(values[1])
        changed["states"][0]["update_address"] = "0x8300"
        values[1] = changed
        errors, _report = world1_enemy_handlers.validate(*values)
        self.assertTrue(any("mapping differs" in error for error in errors))

    def test_rejects_alias_initial_metasprite(self) -> None:
        values = self.fixture()
        values[4]["index_entries"][0]["kind"] = "alias"
        errors, _report = world1_enemy_handlers.validate(*values)
        self.assertTrue(any("metasprite base is not direct" in error for error in errors))

    def test_rejects_changed_signature(self) -> None:
        values = self.fixture()
        changed = bytearray(values[0])
        changed[0x1200] ^= 1
        values[0] = bytes(changed)
        errors, _report = world1_enemy_handlers.validate(*values)
        self.assertTrue(any("signature differs" in error for error in errors))

    def test_rejects_empty_identity_symbol(self) -> None:
        values = self.fixture()
        values[1]["states"][0]["identity_symbol"] = ""
        errors, _report = world1_enemy_handlers.validate(*values)
        self.assertTrue(any("identity_symbol is empty" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
