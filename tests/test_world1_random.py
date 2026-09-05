from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import world1_random


class World1RandomTests(unittest.TestCase):
    def fixture(self) -> tuple[bytes, dict[str, object], dict[str, object]]:
        prg = bytearray(4 * world1_random.BANK_SIZE)
        generators = []
        memory_symbols = []
        symbols = []
        for index, layout in enumerate(world1_random.EXPECTED_GENERATORS):
            name, address, state_name, state_address, state_size, mixed = layout
            signature = bytes((0xA5, state_address, 0x60 + index))
            offset = address - world1_random.CPU_BASE
            prg[offset:offset + len(signature)] = signature
            callsite = 0x8100 + index * 0x10
            call_offset = callsite - world1_random.CPU_BASE
            prg[call_offset:call_offset + 3] = bytes((
                0x20, address & 0xFF, address >> 8
            ))
            generators.append({
                "name": name,
                "address": f"0x{address:04X}",
                "state": {
                    "name": state_name,
                    "address": f"0x{state_address:04X}",
                    "size": state_size,
                },
                "mixes_frame_counter": mixed,
                "callsites": [f"0x{callsite:04X}"],
                "bytes": signature.hex(" "),
            })
            memory_symbols.append({
                "name": state_name,
                "address": f"0x{state_address:04X}",
                "size": state_size,
                "banks": [0],
            })
            symbols.append({
                "name": name,
                "address": f"0x{address:04X}",
                "bank": 0,
            })
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": 0,
            "generators": generators,
        }
        registry: dict[str, object] = {
            "schema_version": 1,
            "symbols": symbols,
            "memory_symbols": memory_symbols,
        }
        return bytes(prg), manifest, registry

    def test_accepts_exact_contract(self) -> None:
        prg, manifest, registry = self.fixture()
        errors, report = world1_random.validate_manifest(
            prg, manifest, registry
        )
        self.assertEqual(errors, [])
        self.assertEqual(report["generator_count"], 2)
        self.assertEqual(report["state_byte_count"], 6)
        self.assertEqual(report["callsite_count"], 2)

    def test_rejects_changed_state_layout(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = copy.deepcopy(manifest)
        changed["generators"][0]["state"]["size"] = 1
        errors, _report = world1_random.validate_manifest(
            prg, changed, registry
        )
        self.assertTrue(any("layout differs" in error for error in errors))

    def test_rejects_changed_routine_bytes(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = bytearray(prg)
        changed[0x162F] ^= 0x01
        errors, _report = world1_random.validate_manifest(
            bytes(changed), manifest, registry
        )
        self.assertTrue(any("routine differs" in error for error in errors))

    def test_rejects_unlisted_direct_callsite(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = bytearray(prg)
        changed[0x1200:0x1203] = bytes((0x20, 0x2F, 0x96))
        errors, _report = world1_random.validate_manifest(
            bytes(changed), manifest, registry
        )
        self.assertTrue(any("callsites differ" in error for error in errors))

    def test_rejects_changed_symbol_ownership(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = copy.deepcopy(registry)
        changed["memory_symbols"][0]["banks"] = [1]
        errors, _report = world1_random.validate_manifest(
            prg, manifest, changed
        )
        self.assertTrue(any("RAM symbol differs" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
