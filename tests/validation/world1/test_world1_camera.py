from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))

from scripts.validation.world1 import world1_camera


class World1CameraTests(unittest.TestCase):
    def fixture(
        self,
    ) -> tuple[bytes, dict[str, object], dict[str, object]]:
        prg = bytearray(4 * world1_camera.BANK_SIZE)
        for _name, address, size, _direction, _callsites in (
            world1_camera.EXPECTED_ROUTINES
        ):
            offset = address - world1_camera.CPU_BASE
            prg[offset:offset + size] = bytes((0xEA,)) * size
        for _name, address, _size, _direction, callsites in (
            world1_camera.EXPECTED_ROUTINES
        ):
            for callsite in callsites:
                offset = callsite - world1_camera.CPU_BASE
                prg[offset:offset + 3] = bytes((
                    0x20,
                    address & 0xFF,
                    address >> 8,
                ))
        geometry = world1_camera.EXPECTED_GEOMETRY
        underground = world1_camera.EXPECTED_UNDERGROUND_TRACKING
        state_fields = [
            {
                "name": name,
                "address": f"0x{address:04X}",
                "size": size,
                "banks": banks,
            }
            for name, address, size, banks in (
                world1_camera.EXPECTED_STATE_FIELDS
            )
        ]
        routines = []
        symbols = []
        for name, address, size, direction, callsites in (
            world1_camera.EXPECTED_ROUTINES
        ):
            offset = address - world1_camera.CPU_BASE
            routines.append({
                "name": name,
                "address": f"0x{address:04X}",
                "size": size,
                "direction": direction,
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
            "geometry": {
                "tile_pixels": geometry[0],
                "max_tile_x": f"0x{geometry[1]:02X}",
                "max_tile_y": f"0x{geometry[2]:02X}",
                "vertical_scroll_wrap": f"0x{geometry[3]:02X}",
                "column_queue_code": geometry[4],
                "row_queue_code": geometry[5],
            },
            "underground_tracking": {
                "horizontal_player_band": [
                    f"0x{underground[0]:02X}",
                    f"0x{underground[1]:02X}",
                ],
                "horizontal_max_pixels_per_update": underground[2],
                "vertical_player_band": [
                    f"0x{underground[3]:02X}",
                    f"0x{underground[4]:02X}",
                ],
                "vertical_max_pixels_per_update": underground[5],
                "axis_fine_mask": f"0x{underground[6]:02X}",
            },
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
        return world1_camera.validate_manifest(prg, manifest, registry)

    def test_accepts_exact_contract(self) -> None:
        prg, manifest, registry = self.fixture()
        errors, report = self.validate(prg, manifest, registry)
        self.assertEqual(errors, [])
        self.assertEqual(report["state_byte_count"], 12)
        self.assertEqual(report["routine_count"], 6)
        self.assertEqual(report["routine_byte_count"], 553)
        self.assertEqual(report["callsite_count"], 18)

    def test_rejects_changed_routine_bytes(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = bytearray(prg)
        changed[0x2381] ^= 0x01
        errors, _report = self.validate(bytes(changed), manifest, registry)
        self.assertTrue(any("routine differs" in error for error in errors))

    def test_rejects_short_routine_signature(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = copy.deepcopy(manifest)
        changed["routines"][0]["bytes"] = "EA"
        errors, _report = self.validate(prg, changed, registry)
        self.assertTrue(any("routine size differs" in error for error in errors))

    def test_rejects_unlisted_direct_callsite(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = bytearray(prg)
        changed[0x100:0x103] = bytes((0x20, 0x81, 0xA3))
        errors, _report = self.validate(bytes(changed), manifest, registry)
        self.assertTrue(any("callsites differ" in error for error in errors))

    def test_rejects_changed_geometry(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = copy.deepcopy(manifest)
        changed["geometry"]["max_tile_x"] = "0xDF"
        errors, _report = self.validate(prg, changed, registry)
        self.assertTrue(any("geometry differs" in error for error in errors))

    def test_rejects_changed_underground_tracking(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = copy.deepcopy(manifest)
        changed["underground_tracking"][
            "horizontal_max_pixels_per_update"
        ] = 1
        errors, _report = self.validate(prg, changed, registry)
        self.assertTrue(
            any("underground camera tracking differs" in error for error in errors)
        )

    def test_rejects_changed_state_ownership(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = copy.deepcopy(registry)
        changed["memory_symbols"][0]["banks"] = [0]
        errors, _report = self.validate(prg, manifest, changed)
        self.assertTrue(any("RAM symbol differs" in error for error in errors))

    def test_rejects_changed_routine_graph(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = copy.deepcopy(manifest)
        changed["routines"][0]["direction"] = "left"
        errors, _report = self.validate(prg, changed, registry)
        self.assertTrue(any("routine graph differs" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
