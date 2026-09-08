from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))

from scripts.validation.world1 import world1_camera_entities


class World1CameraEntityTests(unittest.TestCase):
    def fixture(
        self,
    ) -> tuple[bytes, dict[str, object], dict[str, object]]:
        prg = bytearray(4 * world1_camera_entities.BANK_SIZE)
        for _name, address, size, _callsites, _fallthrough in (
            world1_camera_entities.EXPECTED_ROUTINES
        ):
            offset = address - world1_camera_entities.CPU_BASE
            prg[offset:offset + size] = bytes((0xEA,)) * size
        for _name, address, _size, callsites, _fallthrough in (
            world1_camera_entities.EXPECTED_ROUTINES
        ):
            for callsite in callsites:
                offset = callsite - world1_camera_entities.CPU_BASE
                prg[offset:offset + 3] = bytes((
                    0x20,
                    address & 0xFF,
                    address >> 8,
                ))
        geometry = world1_camera_entities.EXPECTED_GEOMETRY
        geometry_keys = (
            "player_x_scroll_left_below",
            "player_x_scroll_right_at",
            "player_y_scroll_up_below",
            "player_y_scroll_down_at",
            "camera_pixels_per_update",
            "entity_slot_count",
            "horizontal_margin",
            "vertical_positive_margin",
            "vertical_negative_margin",
        )
        geometry_data = {
            key: value if index in (4, 5) else f"0x{value:02X}"
            for index, (key, value) in enumerate(zip(geometry_keys, geometry))
        }
        state_fields = [
            {
                "name": name,
                "address": f"0x{address:04X}",
                "size": size,
            }
            for name, address, size in (
                world1_camera_entities.EXPECTED_STATE_FIELDS
            )
        ]
        routines = []
        symbols = []
        for name, address, size, callsites, fallthrough in (
            world1_camera_entities.EXPECTED_ROUTINES
        ):
            offset = address - world1_camera_entities.CPU_BASE
            record = {
                "name": name,
                "address": f"0x{address:04X}",
                "size": size,
                "callsites": [f"0x{site:04X}" for site in callsites],
                "bytes": bytes(prg[offset:offset + size]).hex(" "),
            }
            if fallthrough is not None:
                record["falls_through_to"] = fallthrough
            routines.append(record)
            symbols.append({
                "name": name,
                "address": f"0x{address:04X}",
                "bank": 0,
            })
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": 0,
            "geometry": geometry_data,
            "state_fields": state_fields,
            "routines": routines,
        }
        registry: dict[str, object] = {
            "schema_version": 1,
            "symbols": symbols,
            "memory_symbols": [
                {**field, "banks": [0]}
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
        return world1_camera_entities.validate_manifest(
            prg, manifest, registry
        )

    def test_accepts_exact_contract(self) -> None:
        prg, manifest, registry = self.fixture()
        errors, report = self.validate(prg, manifest, registry)
        self.assertEqual(errors, [])
        self.assertEqual(report["state_byte_count"], 244)
        self.assertEqual(report["routine_count"], 3)
        self.assertEqual(report["routine_byte_count"], 326)
        self.assertEqual(report["callsite_count"], 13)

    def test_rejects_changed_routine_bytes(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = bytearray(prg)
        changed[0x0706] ^= 0x01
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
        changed[0x100:0x103] = bytes((0x20, 0x06, 0x87))
        errors, _report = self.validate(bytes(changed), manifest, registry)
        self.assertTrue(any("callsites differ" in error for error in errors))

    def test_rejects_changed_geometry(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = copy.deepcopy(manifest)
        changed["geometry"]["entity_slot_count"] = 47
        errors, _report = self.validate(prg, changed, registry)
        self.assertTrue(any("geometry differs" in error for error in errors))

    def test_rejects_changed_fallthrough(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = copy.deepcopy(manifest)
        changed["routines"][1]["size"] = 167
        errors, _report = self.validate(prg, changed, registry)
        self.assertTrue(any("fallthrough differs" in error for error in errors))

    def test_rejects_changed_state_ownership(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = copy.deepcopy(registry)
        changed["memory_symbols"][0]["banks"] = [1]
        errors, _report = self.validate(prg, manifest, changed)
        self.assertTrue(any("RAM symbol differs" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
