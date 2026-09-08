from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))

from scripts.validation.world2 import world2_enemy_handlers


class World2EnemyHandlerTests(unittest.TestCase):
    def fixture(
        self,
    ) -> tuple[
        bytes,
        dict[str, object],
        dict[str, object],
        dict[str, object],
        dict[str, object],
    ]:
        bank = 1
        inactive = 0x8FF0
        update_targets = [0x9000 + state * 0x10 for state in range(1, 21)]
        render_targets = [0xA000 + state * 0x10 for state in range(1, 21)]
        states = [
            {
                "state": state,
                "identity_symbol": f"fixture_{state:02x}",
                "domain": "direct_spawn" if state <= 15 else "internal",
                "update_target": hex(update_targets[state - 1]),
                "update_symbol": f"FixtureUpdate{state:02X}",
                "update_role": f"fixture update role {state:02X}",
                "render_target": hex(render_targets[state - 1]),
                "render_symbol": f"FixtureRender{state:02X}",
                "render_role": f"fixture render role {state:02X}",
            }
            for state in range(1, 21)
        ]
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": bank,
            "inactive_update_target": hex(inactive),
            "states": states,
        }
        update_address = 0xB000
        render_address = 0xB040
        prg = bytearray(4 * world2_enemy_handlers.BANK_SIZE)

        def write(address: int, data: bytes) -> None:
            offset = bank * world2_enemy_handlers.BANK_SIZE + address - 0x8000
            prg[offset:offset + len(data)] = data

        write(
            update_address,
            world2_enemy_handlers.rts_minus_one([inactive] + update_targets),
        )
        write(render_address, world2_enemy_handlers.rts_minus_one(render_targets))
        dispatch: dict[str, object] = {
            "tables": [
                {
                    "name": "world2_enemy_update_handlers",
                    "bank": bank,
                    "address": hex(update_address),
                    "encoding": "rts-minus-one",
                    "slot_count": 21,
                    "targets": [hex(inactive)] + [hex(value) for value in update_targets],
                },
                {
                    "name": "world2_enemy_render_handlers",
                    "bank": bank,
                    "address": hex(render_address),
                    "encoding": "rts-minus-one",
                    "slot_count": 20,
                    "targets": [hex(value) for value in render_targets],
                },
            ]
        }
        enemy_states: dict[str, object] = {
            "runtime_states": {
                "state_count": 20,
                "direct_spawn_states": [hex(state) for state in range(1, 16)],
                "internal_states": [hex(state) for state in range(16, 21)],
            }
        }
        registry: dict[str, object] = {
            "symbols": [
                {
                    "bank": bank,
                    "address": entry[target_field],
                    "name": entry[symbol_field],
                }
                for entry in states
                for target_field, symbol_field in (
                    ("update_target", "update_symbol"),
                    ("render_target", "render_symbol"),
                )
            ]
        }
        return bytes(prg), manifest, dispatch, enemy_states, registry

    def validate_fixture(self, values: tuple[object, ...]) -> list[str]:
        errors, _report = world2_enemy_handlers.validate(*values)
        return errors

    def test_accepts_complete_handler_graph(self) -> None:
        values = self.fixture()
        errors, report = world2_enemy_handlers.validate(*values)
        self.assertEqual(errors, [])
        self.assertEqual(report["state_count"], 20)

    def test_rejects_changed_dispatch_bytes(self) -> None:
        prg, manifest, dispatch, enemy_states, registry = self.fixture()
        changed = bytearray(prg)
        changed[world2_enemy_handlers.BANK_SIZE + 0x3000] ^= 1
        errors = self.validate_fixture(
            (bytes(changed), manifest, dispatch, enemy_states, registry)
        )
        self.assertTrue(any("handler bytes differ" in error for error in errors))

    def test_rejects_dispatch_mapping_change(self) -> None:
        values = list(self.fixture())
        values[2]["tables"][0]["targets"][1] = "0x9FFF"
        errors = self.validate_fixture(tuple(values))
        self.assertTrue(any("handler mapping differs" in error for error in errors))

    def test_rejects_symbol_address_change(self) -> None:
        values = list(self.fixture())
        values[4]["symbols"][0]["address"] = "0x9FFF"
        errors = self.validate_fixture(tuple(values))
        self.assertTrue(any("handler symbol differs" in error for error in errors))

    def test_rejects_lifecycle_domain_change(self) -> None:
        values = list(self.fixture())
        changed = copy.deepcopy(values[1])
        changed["states"][15]["domain"] = "direct_spawn"
        values[1] = changed
        errors = self.validate_fixture(tuple(values))
        self.assertTrue(any("lifecycle domains differ" in error for error in errors))

    def test_rejects_runtime_state_count_change(self) -> None:
        values = list(self.fixture())
        values[3]["runtime_states"]["state_count"] = 19
        errors = self.validate_fixture(tuple(values))
        self.assertTrue(any("state count differs" in error for error in errors))

    def test_rejects_empty_structural_role(self) -> None:
        values = list(self.fixture())
        values[1]["states"][0]["update_role"] = ""
        errors = self.validate_fixture(tuple(values))
        self.assertTrue(any("update_role is empty" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
