from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import world1_map_decoder


class World1MapDecoderTests(unittest.TestCase):
    def fixture(
        self,
    ) -> tuple[
        bytes,
        dict[str, object],
        dict[str, object],
        dict[str, object],
    ]:
        prg = bytearray(4 * world1_map_decoder.BANK_SIZE)
        ram_fields = [
            {
                "name": name,
                "address": f"0x{address:04X}",
                "size": size,
            }
            for name, address, size in world1_map_decoder.EXPECTED_RAM_FIELDS
        ]
        memory_symbols = [
            {**field, "banks": [0]}
            for field in copy.deepcopy(ram_fields)
        ]
        routines = []
        symbols = []
        for index, (name, address, callsites) in enumerate(
            world1_map_decoder.EXPECTED_ROUTINES
        ):
            signature = bytes((0xEA, index, 0x60))
            offset = address - world1_map_decoder.CPU_BASE
            prg[offset:offset + len(signature)] = signature
            for callsite in callsites:
                call_offset = callsite - world1_map_decoder.CPU_BASE
                prg[call_offset:call_offset + 3] = bytes((
                    0x20,
                    address & 0xFF,
                    address >> 8,
                ))
            routines.append({
                "name": name,
                "address": f"0x{address:04X}",
                "callsites": [f"0x{site:04X}" for site in callsites],
                "bytes": signature.hex(" "),
            })
            symbols.append({
                "name": name,
                "address": f"0x{address:04X}",
                "bank": 0,
            })
        map_loads = []
        for name, address, sites in world1_map_decoder.EXPECTED_MAP_LOADS:
            pattern = world1_map_decoder.map_pointer_load_pattern(address)
            for site in sites:
                offset = site - world1_map_decoder.CPU_BASE
                prg[offset:offset + len(pattern)] = pattern
            map_loads.append({
                "name": name,
                "address": f"0x{address:04X}",
                "sites": [f"0x{site:04X}" for site in sites],
            })
        for name, address in world1_map_decoder.EXPECTED_DATA_SYMBOLS:
            symbols.append({
                "name": name,
                "address": f"0x{address:04X}",
                "bank": 0,
            })
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": 0,
            "ram_fields": ram_fields,
            "routines": routines,
            "map_pointer_loads": map_loads,
        }
        registry: dict[str, object] = {
            "schema_version": 1,
            "symbols": symbols,
            "memory_symbols": memory_symbols,
        }
        world_data: dict[str, object] = {
            "schema_version": 1,
            "worlds": [{
                "id": "world1",
                "bank": 0,
                "attributes": {"address": "0xA9EF", "count": 256},
                "small_blocks": {
                    "address": "0xAAEF",
                    "count": 256,
                    "width": 2,
                    "height": 2,
                },
                "big_blocks": {
                    "address": "0xAEEF",
                    "count": 256,
                    "width": 2,
                    "height": 2,
                },
                "maps": [
                    {
                        "id": "city",
                        "address": "0xB2EF",
                        "width": 64,
                        "height": 64,
                    },
                    {
                        "id": "underground",
                        "address": "0xC2EF",
                        "width": 64,
                        "height": 25,
                    },
                ],
            }],
        }
        return bytes(prg), manifest, registry, world_data

    def validate(
        self,
        prg: bytes,
        manifest: dict[str, object],
        registry: dict[str, object],
        world_data: dict[str, object],
    ) -> tuple[list[str], dict[str, int]]:
        return world1_map_decoder.validate_manifest(
            prg, manifest, registry, world_data
        )

    def test_accepts_exact_contract(self) -> None:
        prg, manifest, registry, world_data = self.fixture()
        errors, report = self.validate(prg, manifest, registry, world_data)
        self.assertEqual(errors, [])
        self.assertEqual(report["routine_count"], 8)
        self.assertEqual(report["ram_byte_count"], 11)
        self.assertEqual(report["callsite_count"], 34)
        self.assertEqual(report["map_selection_count"], 4)

    def test_rejects_changed_routine_bytes(self) -> None:
        prg, manifest, registry, world_data = self.fixture()
        changed = bytearray(prg)
        changed[0x26A7] ^= 0x01
        errors, _report = self.validate(
            bytes(changed), manifest, registry, world_data
        )
        self.assertTrue(any("routine differs" in error for error in errors))

    def test_rejects_unlisted_direct_callsite(self) -> None:
        prg, manifest, registry, world_data = self.fixture()
        changed = bytearray(prg)
        changed[0x100:0x103] = bytes((0x20, 0xA7, 0xA6))
        errors, _report = self.validate(
            bytes(changed), manifest, registry, world_data
        )
        self.assertTrue(any("callsites differ" in error for error in errors))

    def test_rejects_changed_ram_layout(self) -> None:
        prg, manifest, registry, world_data = self.fixture()
        changed = copy.deepcopy(manifest)
        changed["ram_fields"][0]["size"] = 1
        errors, _report = self.validate(prg, changed, registry, world_data)
        self.assertTrue(any("RAM layout differs" in error for error in errors))

    def test_rejects_changed_map_pointer_load(self) -> None:
        prg, manifest, registry, world_data = self.fixture()
        changed = bytearray(prg)
        changed[0x352] ^= 0x01
        errors, _report = self.validate(
            bytes(changed), manifest, registry, world_data
        )
        self.assertTrue(any("map-pointer loads differ" in error for error in errors))

    def test_rejects_changed_hierarchy_layout(self) -> None:
        prg, manifest, registry, world_data = self.fixture()
        changed = copy.deepcopy(world_data)
        changed["worlds"][0]["small_blocks"]["width"] = 4
        errors, _report = self.validate(prg, manifest, registry, changed)
        self.assertTrue(any("data layout differs" in error for error in errors))

    def test_rejects_changed_symbol_ownership(self) -> None:
        prg, manifest, registry, world_data = self.fixture()
        changed = copy.deepcopy(registry)
        changed["memory_symbols"][0]["banks"] = [1]
        errors, _report = self.validate(prg, manifest, changed, world_data)
        self.assertTrue(any("RAM symbol differs" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
