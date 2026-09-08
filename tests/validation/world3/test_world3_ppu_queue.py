from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))

from scripts.validation.world3 import world3_ppu_queue


class World3PpuQueueTests(unittest.TestCase):
    def fixture(self) -> tuple[bytes, dict[str, object], dict[str, object]]:
        bank = 2
        signature = bytes((0xA9, 0x01, 0x85, 0x6D))
        prg = bytearray(4 * world3_ppu_queue.BANK_SIZE)
        offset = bank * world3_ppu_queue.BANK_SIZE + 0x3000
        prg[offset:offset + len(signature)] = signature
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": bank,
            "queue": {
                "address": "0x0500",
                "size": 256,
                "header_size": 3,
                "address_high_offset": 0,
                "address_low_offset": 1,
                "length_offset": 2,
                "payload_offset": 3,
                "vertical_increment_flag": "0x80",
                "address_high_mask": "0x7F",
                "ppu_increment_control_bit": "0x04",
                "maximum_payload_size": 32,
                "capacity_guard": "0x24",
                "records_per_drain": 1,
                "payload_threshold": "0x30",
            },
            "memory_layout": [
                {"name": "FixtureReadIndex", "address": "0x006B", "size": 1},
                {"name": "World3PpuQueue", "address": "0x0500", "size": 256},
            ],
            "routines": [
                {"name": "FixtureDrainQueue", "address": "0xB000"},
            ],
            "signatures": [
                {
                    "name": "fixture_consumer",
                    "address": "0xB000",
                    "bytes": signature.hex(" "),
                }
            ],
        }
        registry: dict[str, object] = {
            "schema_version": 1,
            "symbols": [
                {"bank": bank, "address": "0xB000", "name": "FixtureDrainQueue"}
            ],
            "memory_symbols": [
                {
                    "address": "0x006B",
                    "name": "FixtureReadIndex",
                    "banks": [bank],
                },
                {
                    "address": "0x0500",
                    "name": "World3PpuQueue",
                    "size": 256,
                    "banks": [bank],
                },
            ],
        }
        return bytes(prg), manifest, registry

    def test_accepts_queue_contract(self) -> None:
        prg, manifest, registry = self.fixture()
        errors, report = world3_ppu_queue.validate_manifest(prg, manifest, registry)
        self.assertEqual(errors, [])
        self.assertEqual(report["maximum_record_size"], 35)

    def test_rejects_changed_signature(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = bytearray(prg)
        changed[2 * 0x8000 + 0x3000] ^= 1
        errors, _report = world3_ppu_queue.validate_manifest(
            bytes(changed), manifest, registry
        )
        self.assertTrue(any("signature differs" in error for error in errors))

    def test_rejects_ram_address_change(self) -> None:
        prg, manifest, registry = self.fixture()
        registry["memory_symbols"][0]["address"] = "0x006A"
        errors, _report = world3_ppu_queue.validate_manifest(prg, manifest, registry)
        self.assertTrue(any("RAM symbol differs" in error for error in errors))

    def test_rejects_routine_bank_change(self) -> None:
        prg, manifest, registry = self.fixture()
        registry["symbols"][0]["bank"] = 1
        errors, _report = world3_ppu_queue.validate_manifest(prg, manifest, registry)
        self.assertTrue(any("routine symbol differs" in error for error in errors))

    def test_rejects_unsafe_capacity_guard(self) -> None:
        prg, manifest, registry = self.fixture()
        manifest["queue"]["capacity_guard"] = "0x23"
        errors, _report = world3_ppu_queue.validate_manifest(prg, manifest, registry)
        self.assertTrue(any("capacity guard differs" in error for error in errors))

    def test_rejects_wrong_prg_bank(self) -> None:
        prg, manifest, registry = self.fixture()
        manifest["bank"] = 1
        errors, _report = world3_ppu_queue.validate_manifest(prg, manifest, registry)
        self.assertTrue(any("PRG bank 2" in error for error in errors))

    def test_rejects_changed_record_offsets(self) -> None:
        prg, manifest, registry = self.fixture()
        manifest["queue"]["payload_offset"] = 4
        errors, _report = world3_ppu_queue.validate_manifest(prg, manifest, registry)
        self.assertTrue(any("record offsets differ" in error for error in errors))

    def test_rejects_overlapping_address_flag(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = copy.deepcopy(manifest)
        changed["queue"]["address_high_mask"] = "0xFF"
        errors, _report = world3_ppu_queue.validate_manifest(prg, changed, registry)
        self.assertTrue(any("address flag contract differs" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
