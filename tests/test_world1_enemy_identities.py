from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import world1_enemy_identities


class World1EnemyIdentityTests(unittest.TestCase):
    def fixture(
        self,
    ) -> tuple[bytes, dict[str, object], dict[str, object], dict[str, object]]:
        prg = bytearray(4 * world1_enemy_identities.BANK_SIZE)
        symbols = [
            "yuubou",
            "suneraa",
            "mekanosso",
            "gozura",
            "naame",
            "kobuun",
            "nezumi",
            "dobakku",
            "herimeda",
            "giraamin",
            "gozura",
            "naame",
            "dormant_state_0d",
            "bull_robo",
            "bull_robo",
        ]
        bases = [
            0x64,
            0x5C,
            0x56,
            0x60,
            0x58,
            0x4C,
            0x54,
            0x70,
            0x6C,
            0x3E,
            0x60,
            0x58,
        ]
        health = [2, 1, 2, 4, 1, 1, 2, 1, 2, 4, 4, 1]
        rewards = [
            0x42,
            0x42,
            0x45,
            0x41,
            0x42,
            0x55,
            0x48,
            0x55,
            0x31,
            0x55,
            0x55,
            0x55,
            0x21,
            0x55,
            0x55,
        ]
        lifecycles = (
            ["direct_placement"] * 12
            + ["dormant_dispatch_state"]
            + ["scripted_boss_state"] * 2
        )
        handlers: dict[str, object] = {
            "bank": 0,
            "states": [
                {
                    "state": state,
                    "identity_symbol": symbols[state - 1],
                    "lifecycle": lifecycles[state - 1],
                    "score_reward_code": hex(rewards[state - 1]),
                    **(
                        {
                            "initial_metasprite": hex(bases[state - 1]),
                            "initial_health": health[state - 1],
                        }
                        if state <= 12
                        else {}
                    ),
                }
                for state in range(1, 16)
            ],
        }
        identities = [
            {
                "state": state,
                "symbol": symbols[state - 1],
                "japanese_name": None if state == 13 else f"enemy {state}",
                "romanized_name": f"Enemy {state}",
                "category": "enemy",
                "confidence": "structural" if state == 13 else "confirmed",
                "lifecycle": lifecycles[state - 1],
                "score_reward_code": hex(rewards[state - 1]),
                "evidence": ["local_rom"] if state == 13 else ["local_rom", "guide"],
                **(
                    {
                        "metasprite_base": hex(bases[state - 1]),
                        "initial_health": health[state - 1],
                    }
                    if state <= 12
                    else {}
                ),
            }
            for state in range(1, 16)
        ]
        secret = bytes((6, 6, 5, 4, 1, 6))
        prg[0x14D9:0x14DF] = secret
        signature = bytes.fromhex("8A 48 98 48")
        prg[0x1462:0x1466] = signature
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": 0,
            "state_count": 15,
            "identity_sources": [
                {"id": "local_rom", "url": None},
                {"id": "guide", "url": "https://example.com"},
            ],
            "secret_sequence": {
                "address": "0x94D9",
                "runtime_states": list(secret),
                "reward_descriptor_index": 4,
            },
            "identities": identities,
            "signatures": [
                {
                    "name": "secret_checker",
                    "address": "0x9462",
                    "bytes": signature.hex(" "),
                }
            ],
        }
        metasprites: dict[str, object] = {
            "index_entries": [
                {"id": index, "kind": "direct"} for index in sorted(set(bases))
            ]
        }
        return bytes(prg), manifest, handlers, metasprites

    def test_accepts_complete_identity_catalog(self) -> None:
        errors, report = world1_enemy_identities.validate(*self.fixture())
        self.assertEqual(errors, [])
        self.assertEqual(report["state_count"], 15)
        self.assertEqual(report["unique_direct_identity_count"], 10)
        self.assertEqual(report["secret_length"], 6)

    def test_rejects_handler_identity_mismatch(self) -> None:
        values = list(self.fixture())
        values[2]["states"][0]["identity_symbol"] = "not_yuubou"
        errors, _report = world1_enemy_identities.validate(*values)
        self.assertTrue(any("handler identity differs" in error for error in errors))

    def test_rejects_changed_secret_byte(self) -> None:
        values = list(self.fixture())
        changed = bytearray(values[0])
        changed[0x14D9] ^= 1
        values[0] = bytes(changed)
        errors, _report = world1_enemy_identities.validate(*values)
        self.assertTrue(any("secret sequence bytes differ" in error for error in errors))

    def test_rejects_confirmed_identity_without_external_source(self) -> None:
        values = list(self.fixture())
        changed = copy.deepcopy(values[1])
        changed["identities"][0]["evidence"] = ["local_rom"]
        values[1] = changed
        errors, _report = world1_enemy_identities.validate(*values)
        self.assertTrue(any("lacks external evidence" in error for error in errors))

    def test_rejects_direct_roster_change(self) -> None:
        values = list(self.fixture())
        changed = copy.deepcopy(values[1])
        changed["identities"][10]["symbol"] = "different_enemy"
        values[1] = changed
        errors, _report = world1_enemy_identities.validate(*values)
        self.assertTrue(any("direct roster" in error for error in errors))

    def test_rejects_initial_health_mismatch(self) -> None:
        values = list(self.fixture())
        changed = copy.deepcopy(values[1])
        changed["identities"][0]["initial_health"] = 9
        values[1] = changed
        errors, _report = world1_enemy_identities.validate(*values)
        self.assertTrue(any("initial health differs" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
