from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import world1_ppu_streaming


class World1PpuStreamingTests(unittest.TestCase):
    def fixture(
        self,
    ) -> tuple[bytes, dict[str, object], dict[str, object]]:
        prg = bytearray(4 * world1_ppu_streaming.BANK_SIZE)
        for _name, address, size, _callsites in (
            world1_ppu_streaming.EXPECTED_ROUTINES
        ):
            offset = address - world1_ppu_streaming.CPU_BASE
            prg[offset:offset + size] = bytes((0xEA,)) * size
        for _name, address, _size, callsites in (
            world1_ppu_streaming.EXPECTED_ROUTINES
        ):
            for callsite in callsites:
                offset = callsite - world1_ppu_streaming.CPU_BASE
                prg[offset:offset + 3] = bytes((
                    0x20,
                    address & 0xFF,
                    address >> 8,
                ))
        ram_fields = [
            {
                "name": name,
                "address": f"0x{address:04X}",
                "size": size,
            }
            for name, address, size in world1_ppu_streaming.EXPECTED_RAM_FIELDS
        ]
        packets = []
        for layout in world1_ppu_streaming.EXPECTED_PACKETS:
            (
                axis,
                queue_code,
                flags_address,
                tile_flag,
                tile_address,
                tile_data,
                tile_count,
                tile_ppu_increment,
                attribute_flag,
                attribute_address,
                attribute_data,
                attribute_count,
            ) = layout
            packets.append({
                "axis": axis,
                "queue_code": queue_code,
                "flags_address": f"0x{flags_address:04X}",
                "tile_flag": tile_flag,
                "tile_address": f"0x{tile_address:04X}",
                "tile_data": f"0x{tile_data:04X}",
                "tile_count": tile_count,
                "tile_ppu_increment": tile_ppu_increment,
                "attribute_flag": attribute_flag,
                "attribute_address": f"0x{attribute_address:04X}",
                "attribute_data": f"0x{attribute_data:04X}",
                "attribute_count": attribute_count,
            })
        routines = []
        symbols = []
        for name, address, size, callsites in (
            world1_ppu_streaming.EXPECTED_ROUTINES
        ):
            offset = address - world1_ppu_streaming.CPU_BASE
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
        queue_address, entry_bits, capacity = (
            world1_ppu_streaming.EXPECTED_QUEUE
        )
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": 0,
            "ram_fields": ram_fields,
            "packets": packets,
            "queue": {
                "address": f"0x{queue_address:04X}",
                "entry_bits": entry_bits,
                "capacity": capacity,
            },
            "routines": routines,
        }
        registry: dict[str, object] = {
            "schema_version": 1,
            "symbols": symbols,
            "memory_symbols": [
                {**field, "banks": [0]}
                for field in copy.deepcopy(ram_fields)
            ],
        }
        return bytes(prg), manifest, registry

    def validate(
        self,
        prg: bytes,
        manifest: dict[str, object],
        registry: dict[str, object],
    ) -> tuple[list[str], dict[str, int]]:
        return world1_ppu_streaming.validate_manifest(
            prg, manifest, registry
        )

    def test_accepts_exact_contract(self) -> None:
        prg, manifest, registry = self.fixture()
        errors, report = self.validate(prg, manifest, registry)
        self.assertEqual(errors, [])
        self.assertEqual(report["packet_count"], 2)
        self.assertEqual(report["tile_byte_count"], 63)
        self.assertEqual(report["attribute_byte_count"], 17)
        self.assertEqual(report["ram_byte_count"], 92)
        self.assertEqual(report["routine_count"], 6)
        self.assertEqual(report["callsite_count"], 20)

    def test_rejects_changed_routine_bytes(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = bytearray(prg)
        changed[0x24C6] ^= 0x01
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
        changed[0x100:0x103] = bytes((0x20, 0xC6, 0xA4))
        errors, _report = self.validate(bytes(changed), manifest, registry)
        self.assertTrue(any("callsites differ" in error for error in errors))

    def test_rejects_changed_packet_geometry(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = copy.deepcopy(manifest)
        changed["packets"][0]["tile_count"] = 29
        errors, _report = self.validate(prg, changed, registry)
        self.assertTrue(any("packet geometry differs" in error for error in errors))

    def test_rejects_changed_queue_geometry(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = copy.deepcopy(manifest)
        changed["queue"]["capacity"] = 3
        errors, _report = self.validate(prg, changed, registry)
        self.assertTrue(any("queue geometry differs" in error for error in errors))

    def test_rejects_changed_symbol_ownership(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = copy.deepcopy(registry)
        changed["memory_symbols"][0]["banks"] = [1]
        errors, _report = self.validate(prg, manifest, changed)
        self.assertTrue(any("RAM symbol differs" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
