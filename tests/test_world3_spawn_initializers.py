from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import world3_spawn_initializers


class World3SpawnInitializerTests(unittest.TestCase):
    def fixture(
        self,
    ) -> tuple[bytes, dict[str, object], dict[str, object], dict[str, object]]:
        bank = 2
        prg = bytearray(4 * world3_spawn_initializers.BANK_SIZE)
        flags = bytes(index & 1 for index in range(64))
        formation = bytes((1, 2, 0x20, 0xD0))
        regions = [
            {
                "name": "type03_room_variants",
                "address": "0x9000",
                "count": 64,
                "fields": ["alternate_metasprite"],
                "crc32": world3_spawn_initializers.crc32(flags),
            },
            {
                "name": "formation",
                "address": "0x9100",
                "count": 2,
                "fields": ["state", "x"],
                "crc32": world3_spawn_initializers.crc32(formation),
            },
        ]
        base = bank * world3_spawn_initializers.BANK_SIZE
        prg[base + 0x1000:base + 0x1040] = flags
        prg[base + 0x1100:base + 0x1104] = formation
        signature = bytes((0xA5, 0xC4, 0x0A, 0xA8))
        prg[base + 0x1400:base + 0x1404] = signature
        targets = [0xA000 + index for index in range(16)]
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": bank,
            "initializer_count": 16,
            "dispatch_name": "fixture_initializers",
            "initializers": [
                {
                    "type": index,
                    "target": hex(targets[index]),
                    "mode": "no_op",
                    "schedule_records": 1,
                    "spawn_budget": index + 1,
                }
                for index in range(16)
            ],
            "data_regions": regions,
            "covered_byte_count": len(flags + formation),
            "covered_crc32": world3_spawn_initializers.crc32(flags + formation),
            "signatures": [
                {"address": "0x9400", "bytes": signature.hex(" ")}
            ],
        }
        dispatch: dict[str, object] = {
            "tables": [
                {
                    "name": "fixture_initializers",
                    "bank": bank,
                    "slot_count": 16,
                    "targets": [hex(target) for target in targets],
                }
            ]
        }
        transient: dict[str, object] = {
            "rooms": [
                {
                    "channels": [
                        {"type": hex(index), "count": index + 1}
                    ]
                }
                for index in range(16)
            ]
        }
        return bytes(prg), manifest, dispatch, transient

    def test_accepts_initializer_contract(self) -> None:
        prg, manifest, dispatch, transient = self.fixture()
        errors, report = world3_spawn_initializers.validate_manifest(
            prg, manifest, dispatch, transient
        )
        self.assertEqual(errors, [])
        self.assertEqual(report["scheduled_type_count"], 16)

    def test_lossless_authoring_roundtrip(self) -> None:
        prg, manifest, dispatch, transient = self.fixture()
        decoded = world3_spawn_initializers.decode_authoring(
            prg, manifest, dispatch, transient
        )
        rebuilt = world3_spawn_initializers.apply_authoring(
            prg, decoded, manifest
        )
        self.assertEqual(rebuilt, prg)
        self.assertEqual(decoded["covered_byte_count"], 68)

    def test_allows_formation_edit(self) -> None:
        prg, manifest, dispatch, transient = self.fixture()
        decoded = world3_spawn_initializers.decode_authoring(
            prg, manifest, dispatch, transient
        )
        changed = copy.deepcopy(decoded)
        changed["regions"][1]["records"][0]["x"] = "0x44"
        rebuilt = world3_spawn_initializers.apply_authoring(
            prg, changed, manifest
        )
        base = 2 * world3_spawn_initializers.BANK_SIZE
        self.assertEqual(rebuilt[base + 0x1102], 0x44)

    def test_rejects_dispatch_target_change(self) -> None:
        prg, manifest, dispatch, transient = self.fixture()
        dispatch["tables"][0]["targets"][0] = "0xB000"
        errors, _report = world3_spawn_initializers.validate_manifest(
            prg, manifest, dispatch, transient
        )
        self.assertTrue(any("dispatch contract differs" in error for error in errors))

    def test_rejects_schedule_budget_change(self) -> None:
        prg, manifest, dispatch, transient = self.fixture()
        transient["rooms"][0]["channels"][0]["count"] = 2
        errors, _report = world3_spawn_initializers.validate_manifest(
            prg, manifest, dispatch, transient
        )
        self.assertTrue(any("spawn budgets differ" in error for error in errors))

    def test_rejects_changed_signature(self) -> None:
        prg, manifest, dispatch, transient = self.fixture()
        changed = bytearray(prg)
        changed[2 * world3_spawn_initializers.BANK_SIZE + 0x1400] ^= 1
        errors, _report = world3_spawn_initializers.validate_manifest(
            bytes(changed), manifest, dispatch, transient
        )
        self.assertTrue(any("signature differs" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
