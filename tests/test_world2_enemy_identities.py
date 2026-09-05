from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import world2_enemy_identities


class World2EnemyIdentityTests(unittest.TestCase):
    def fixture(
        self,
    ) -> tuple[bytes, dict[str, object], dict[str, object], dict[str, object], dict[str, object]]:
        bank = 1
        prg = bytearray(4 * world2_enemy_identities.BANK_SIZE)

        def write(address: int, data: bytes) -> None:
            offset = bank * world2_enemy_identities.BANK_SIZE + address - 0x8000
            prg[offset:offset + len(data)] = data

        attacks = [1] + [0x40] * 20
        thresholds = [4] + [1] * 20
        rewards = [0xA0] + [0x51] * 20
        rewards[16] = 0
        enemy_states: dict[str, object] = {
            "bank": bank,
            "runtime_states": {
                "direct_spawn_states": [hex(value) for value in range(1, 16)],
                "internal_states": [hex(value) for value in range(16, 21)],
            },
            "property_tables": [
                {"name": "attack_period_by_state", "values": attacks},
                {"name": "damage_threshold_by_state", "values": thresholds},
                {"name": "score_reward_code_by_state", "values": rewards},
            ],
        }
        handlers: dict[str, object] = {
            "states": [
                {
                    "state": state,
                    "domain": "direct_spawn" if state <= 15 else "internal",
                }
                for state in range(1, 21)
            ]
        }
        metasprites: dict[str, object] = {
            "enemy_state_render_indexes": [
                {"state": state, "indexes": [state]}
                for state in range(1, 21)
            ]
        }
        source_ids = ["local_rom", "guide"]
        names = [f"敵{state:02d}" for state in range(1, 21)]
        names[7] = "ガンガン"
        names[14] = "ガンガン"
        symbols = [f"enemy_{state:02x}" for state in range(1, 21)]
        symbols[1] = "takkon"
        symbols[16:19] = ["ororon_iwa", "big_robo_ship", "centaurus"]
        for state, symbol in enumerate(symbols, start=1):
            handlers["states"][state - 1]["identity_symbol"] = symbol
        categories = ["enemy"] * 20
        categories[8] = "background_enemy"
        categories[15] = "boss_projectile"
        categories[16:19] = ["boss", "boss", "boss"]
        categories[19] = "boss_helper"
        identities = [
            {
                "state": state,
                "symbol": symbols[state - 1],
                "japanese_name": names[state - 1],
                "romanized_name": f"Enemy {state:02X}",
                "category": categories[state - 1],
                "confidence": "structural" if state == 16 else "confirmed",
                "lifecycle": "direct_spawn" if state <= 15 else "internal",
                "attack_period": hex(attacks[state]),
                "damage_threshold": thresholds[state],
                "score_reward_code": hex(rewards[state]),
                "score_points": world2_enemy_identities.decode_score(
                    rewards[state], 7
                ),
                "metasprite_indexes": [state],
                "evidence": source_ids,
            }
            for state in range(1, 21)
        ]
        score_signature = bytes.fromhex("85 07 60")
        write(0x8100, score_signature)
        boss_tables = {
            "trigger_screen_table": (0x9000, [0x11, 0x40, 0x67]),
            "boss_state_table": (0x9010, [0x11, 0x12, 0x13]),
            "initial_x_table": (0x9020, [0xDC, 0x78, 0xB4]),
            "initial_y_table": (0x9030, [0x98, 0x50, 0x64]),
        }
        for address, values in boss_tables.values():
            write(address, bytes(values))
        relationships = [
            ("centaurus_spawns_tenkoumori", 0x9100, [0x13], [0x04], "A9 04"),
            ("big_robo_ship_spawns_robo_ship", 0x9110, [0x12], [0x14], "A9 14"),
            ("ororon_iwa_spawns_jura_projectile", 0x9120, [0x11], [0x10], "A9 10"),
        ]
        for _name, address, _sources, _results, raw in relationships:
            write(address, bytes.fromhex(raw))
        special_raw = "C9 02 C9 04"
        write(0x9130, bytes.fromhex(special_raw))
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": bank,
            "state_count": 20,
            "identity_sources": [
                {"id": "local_rom", "url": None},
                {"id": "guide", "url": "https://example.com"},
            ],
            "score_encoding": {
                "routine_address": "0x8100",
                "digit_count": 7,
                "digit_index_field": "high_nibble",
                "digit_addend_field": "low_nibble",
                "points_formula": "low_nibble * 10 ** (6 - high_nibble)",
                "signature": score_signature.hex(" "),
            },
            "boss_controller": {
                "routine_address": "0x8000",
                **{
                    key: {"address": hex(address), "values": values}
                    for key, (address, values) in boss_tables.items()
                },
            },
            "state_relationships": [
                {
                    "name": name,
                    "address": hex(address),
                    "bytes": raw,
                    "source_states": sources,
                    "result_states": results,
                }
                for name, address, sources, results, raw in relationships
            ],
            "special_rules": [
                {
                    "name": "four_consecutive_takkon_defeats_spawn_item",
                    "address": "0x9130",
                    "bytes": special_raw,
                    "state": 2,
                    "required_count": 4,
                }
            ],
            "identities": identities,
        }
        return bytes(prg), manifest, enemy_states, handlers, metasprites

    def test_accepts_complete_identity_catalog(self) -> None:
        errors, report = world2_enemy_identities.validate(*self.fixture())
        self.assertEqual(errors, [])
        self.assertEqual(report["state_count"], 20)
        self.assertEqual(report["boss_count"], 3)

    def test_decodes_decimal_score_codes(self) -> None:
        self.assertEqual(world2_enemy_identities.decode_score(0x51, 7), 10)
        self.assertEqual(world2_enemy_identities.decode_score(0x43, 7), 300)
        self.assertEqual(world2_enemy_identities.decode_score(0x21, 7), 10000)

    def test_rejects_property_mismatch(self) -> None:
        values = list(self.fixture())
        changed = copy.deepcopy(values[1])
        changed["identities"][0]["damage_threshold"] = 8
        values[1] = changed
        errors, _report = world2_enemy_identities.validate(*values)
        self.assertTrue(any("damage threshold differs" in error for error in errors))

    def test_rejects_metasprite_mismatch(self) -> None:
        values = list(self.fixture())
        values[4]["enemy_state_render_indexes"][0]["indexes"] = [0xFF]
        errors, _report = world2_enemy_identities.validate(*values)
        self.assertTrue(any("metasprite indexes differ" in error for error in errors))

    def test_rejects_handler_identity_mismatch(self) -> None:
        values = list(self.fixture())
        values[3]["states"][0]["identity_symbol"] = "not_ankodori"
        errors, _report = world2_enemy_identities.validate(*values)
        self.assertTrue(any("handler identity differs" in error for error in errors))

    def test_rejects_changed_boss_table_byte(self) -> None:
        values = list(self.fixture())
        changed = bytearray(values[0])
        changed[world2_enemy_identities.BANK_SIZE + 0x1000] ^= 1
        values[0] = bytes(changed)
        errors, _report = world2_enemy_identities.validate(*values)
        self.assertTrue(any("trigger_screen_table bytes differ" in error for error in errors))

    def test_rejects_changed_helper_relationship(self) -> None:
        values = list(self.fixture())
        changed = copy.deepcopy(values[1])
        changed["state_relationships"][0]["result_states"] = [5]
        values[1] = changed
        errors, _report = world2_enemy_identities.validate(*values)
        self.assertTrue(any("state relationships differ" in error for error in errors))

    def test_rejects_confirmed_identity_without_external_source(self) -> None:
        values = list(self.fixture())
        changed = copy.deepcopy(values[1])
        changed["identities"][0]["evidence"] = ["local_rom"]
        values[1] = changed
        errors, _report = world2_enemy_identities.validate(*values)
        self.assertTrue(any("lacks external evidence" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
