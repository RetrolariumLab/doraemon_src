from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import world1_player_controls


class World1PlayerControlTests(unittest.TestCase):
    def fixture(
        self,
    ) -> tuple[bytes, dict[str, object], dict[str, object]]:
        prg = bytearray(4 * world1_player_controls.BANK_SIZE)
        for _name, address, size, _callsites in (
            world1_player_controls.EXPECTED_ROUTINES
        ):
            offset = address - world1_player_controls.CPU_BASE
            prg[offset:offset + size] = bytes((0xEA,)) * size
        for _name, address, _size, callsites in (
            world1_player_controls.EXPECTED_ROUTINES
        ):
            for callsite in callsites:
                offset = callsite - world1_player_controls.CPU_BASE
                prg[offset:offset + 3] = bytes((
                    0x20,
                    address & 0xFF,
                    address >> 8,
                ))
        controls = copy.deepcopy(world1_player_controls.EXPECTED_CONTROLS)
        manifest_controls = {
            "direction_priority": controls[0],
            "direction_button_masks": [
                f"0x{value:02X}" for value in controls[1]
            ],
            "direction_values": controls[2],
            "pixels_per_update": controls[3],
            "player_x_min": f"0x{controls[4]:02X}",
            "player_x_max": f"0x{controls[5]:02X}",
            "player_y_min": f"0x{controls[6]:02X}",
            "player_y_max": f"0x{controls[7]:02X}",
            "animation_divider": controls[8],
            "hit_recovery_control_unlock": controls[9],
            "hit_recovery_end": f"0x{controls[10]:02X}",
            "solid_metatile_first": f"0x{controls[11]:02X}",
            "collision_probe_counts": controls[12],
            "fire_button_mask": f"0x{controls[13]:02X}",
            "weapon_pose_frames": controls[14],
            "projectile_slot_capacity": controls[15],
        }
        state_fields = [
            {
                "name": name,
                "address": f"0x{address:04X}",
                "size": size,
                "banks": banks,
            }
            for name, address, size, banks in (
                world1_player_controls.EXPECTED_STATE_FIELDS
            )
        ]
        routines = []
        symbols = []
        for name, address, size, callsites in (
            world1_player_controls.EXPECTED_ROUTINES
        ):
            offset = address - world1_player_controls.CPU_BASE
            routines.append({
                "name": name,
                "address": f"0x{address:04X}",
                "size": size,
                "callsites": [f"0x{site:04X}" for site in callsites],
                "bytes": bytes(prg[offset:offset + size]).hex(" "),
            })
            symbols.append({
                "name": name,
                "address": f"0x{address:04X}",
                "bank": 0,
            })
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": 0,
            "controls": manifest_controls,
            "state_fields": state_fields,
            "routines": routines,
        }
        registry: dict[str, object] = {
            "schema_version": 1,
            "symbols": symbols,
            "memory_symbols": [
                {
                    "name": field["name"],
                    "address": field["address"],
                    "size": field["size"],
                    **(
                        {"banks": field["banks"]}
                        if field["banks"] is not None
                        else {}
                    ),
                }
                for field in copy.deepcopy(state_fields)
            ],
        }
        return bytes(prg), manifest, registry

    def validate(
        self,
        prg: bytes,
        manifest: dict[str, object],
        registry: dict[str, object],
    ) -> tuple[list[str], dict[str, int]]:
        return world1_player_controls.validate_manifest(
            prg, manifest, registry
        )

    def test_accepts_exact_contract(self) -> None:
        prg, manifest, registry = self.fixture()
        errors, report = self.validate(prg, manifest, registry)
        self.assertEqual(errors, [])
        self.assertEqual(report["state_byte_count"], 13)
        self.assertEqual(report["collision_probe_count"], 10)
        self.assertEqual(report["routine_count"], 4)
        self.assertEqual(report["routine_byte_count"], 589)
        self.assertEqual(report["callsite_count"], 26)

    def test_rejects_changed_routine_bytes(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = bytearray(prg)
        changed[0x056C] ^= 0x01
        errors, _report = self.validate(bytes(changed), manifest, registry)
        self.assertTrue(any("routine differs" in error for error in errors))

    def test_rejects_short_signature(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = copy.deepcopy(manifest)
        changed["routines"][0]["bytes"] = "EA"
        errors, _report = self.validate(prg, changed, registry)
        self.assertTrue(any("routine size differs" in error for error in errors))

    def test_rejects_unlisted_direct_callsite(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = bytearray(prg)
        changed[0x100:0x103] = bytes((0x20, 0x6C, 0x85))
        errors, _report = self.validate(bytes(changed), manifest, registry)
        self.assertTrue(any("callsites differ" in error for error in errors))

    def test_rejects_changed_control_constant(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = copy.deepcopy(manifest)
        changed["controls"]["pixels_per_update"] = 1
        errors, _report = self.validate(prg, changed, registry)
        self.assertTrue(any("constants differ" in error for error in errors))

    def test_rejects_changed_state_ownership(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = copy.deepcopy(registry)
        changed["memory_symbols"][0]["banks"] = [0]
        errors, _report = self.validate(prg, manifest, changed)
        self.assertTrue(any("RAM symbol differs" in error for error in errors))

    def test_rejects_changed_routine_graph(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = copy.deepcopy(manifest)
        changed["routines"][0]["callsites"] = []
        errors, _report = self.validate(prg, changed, registry)
        self.assertTrue(any("routine graph differs" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
