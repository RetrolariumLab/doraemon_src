from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import world1_weapons


class World1WeaponTests(unittest.TestCase):
    def fixture(
        self,
    ) -> tuple[bytes, dict[str, object], dict[str, object]]:
        prg = bytearray(4 * world1_weapons.BANK_SIZE)
        sounds = bytes((0x01, 0x0C, 0x0D))
        profiles = bytes((
            0x04, 0x10, 0x24, 0x00,
            0x04, 0x08, 0x24, 0x00,
            0x04, 0x0C, 0x24, 0x00,
            0x04, 0x0C, 0x24, 0x00,
            0x00, 0x10, 0x18, 0x00,
            0x00, 0x0C, 0x19, 0x00,
            0x00, 0x08, 0x1A, 0x00,
            0x00, 0x08, 0x1B, 0x00,
            0x00, 0x10, 0x1C, 0x82,
            0x00, 0x0C, 0x1D, 0x82,
            0x00, 0x08, 0x1E, 0x82,
            0x00, 0x08, 0x1F, 0x82,
        ))
        sound_offset = 0x9C83 - world1_weapons.CPU_BASE
        profile_offset = 0x9C86 - world1_weapons.CPU_BASE
        prg[sound_offset:sound_offset + len(sounds)] = sounds
        prg[profile_offset:profile_offset + len(profiles)] = profiles
        signatures = []
        for address, encoded in world1_weapons.EXPECTED_SIGNATURES:
            raw = bytes.fromhex(encoded)
            offset = address - world1_weapons.CPU_BASE
            prg[offset:offset + len(raw)] = raw
            signatures.append({
                "address": f"0x{address:04X}",
                "purpose": "fixture",
                "bytes": raw.hex(" "),
            })
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": 0,
            "directions": [
                {"value": value, "name": name}
                for value, name in world1_weapons.EXPECTED_DIRECTIONS
            ],
            "sound_effects": {
                "operand_symbol": world1_weapons.EXPECTED_SOUND[0],
                "operand_address": "0x9C82",
                "data_address": "0x9C83",
                "level_first": 1,
                "count": 3,
                "crc32": world1_weapons.crc32(sounds),
            },
            "projectile_profiles": {
                "symbol": world1_weapons.EXPECTED_PROFILES[0],
                "address": "0x9C86",
                "level_count": 3,
                "direction_count": 4,
                "record_size": 4,
                "fields": copy.deepcopy(world1_weapons.EXPECTED_PROFILES[5]),
                "crc32": world1_weapons.crc32(profiles),
            },
            "signatures": signatures,
        }
        registry: dict[str, object] = {
            "schema_version": 1,
            "symbols": [
                {
                    "bank": 0,
                    "address": "0x9C82",
                    "name": world1_weapons.EXPECTED_SOUND[0],
                    "operand_symbol": True,
                },
                {
                    "bank": 0,
                    "address": "0x9C86",
                    "name": world1_weapons.EXPECTED_PROFILES[0],
                    "operand_symbol": True,
                },
            ],
        }
        return bytes(prg), manifest, registry

    def test_accepts_exact_catalog(self) -> None:
        prg, manifest, registry = self.fixture()
        errors, report = world1_weapons.validate_manifest(
            prg, manifest, registry
        )
        self.assertEqual(errors, [])
        self.assertEqual(report["level_count"], 3)
        self.assertEqual(report["profile_count"], 12)
        self.assertEqual(report["covered_byte_count"], 51)

    def test_lossless_authoring_roundtrip(self) -> None:
        prg, manifest, registry = self.fixture()
        decoded = world1_weapons.decode_authoring(prg, manifest, registry)
        rebuilt = world1_weapons.apply_authoring(prg, decoded, manifest)
        self.assertEqual(rebuilt, prg)
        self.assertEqual(decoded["covered_crc32"], "e3cbcdfb")

    def test_allows_profile_edit(self) -> None:
        prg, manifest, registry = self.fixture()
        decoded = world1_weapons.decode_authoring(prg, manifest, registry)
        decoded["levels"][1]["directions"][2]["x_offset"] = "0x07"
        rebuilt = world1_weapons.apply_authoring(prg, decoded, manifest)
        offset = 0x9C86 - world1_weapons.CPU_BASE + 16 + 8
        self.assertEqual(rebuilt[offset], 7)

    def test_rejects_direction_reordering(self) -> None:
        prg, manifest, registry = self.fixture()
        decoded = world1_weapons.decode_authoring(prg, manifest, registry)
        decoded["levels"][0]["directions"].reverse()
        with self.assertRaisesRegex(ValueError, "directions differ"):
            world1_weapons.encode_authoring(decoded, manifest)

    def test_rejects_byte_outside_range(self) -> None:
        prg, manifest, registry = self.fixture()
        decoded = world1_weapons.decode_authoring(prg, manifest, registry)
        decoded["levels"][0]["sound_effect"] = "0x100"
        with self.assertRaisesRegex(ValueError, "outside range"):
            world1_weapons.encode_authoring(decoded, manifest)

    def test_rejects_changed_table_byte(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = bytearray(prg)
        changed[0x1C83] ^= 1
        errors, _report = world1_weapons.validate_manifest(
            bytes(changed), manifest, registry
        )
        self.assertTrue(any("sound-table CRC32 differs" in error for error in errors))

    def test_rejects_changed_signature(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = bytearray(prg)
        changed[0x1C26] ^= 1
        errors, _report = world1_weapons.validate_manifest(
            bytes(changed), manifest, registry
        )
        self.assertTrue(any("signature differs" in error for error in errors))

    def test_rejects_nonoperand_symbol(self) -> None:
        prg, manifest, registry = self.fixture()
        registry["symbols"][0]["operand_symbol"] = False
        errors, _report = world1_weapons.validate_manifest(
            prg, manifest, registry
        )
        self.assertTrue(any("operand symbol differs" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
