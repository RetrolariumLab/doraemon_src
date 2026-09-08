from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))

from scripts.validation.world1 import world1_underground_rooms


class World1UndergroundRoomTests(unittest.TestCase):
    def fixture(
        self,
    ) -> tuple[bytes, dict[str, object], dict[str, object]]:
        camera = bytes.fromhex(
            "40 22 20 00 80 22 20 00 CA 22 20 0A 00 42 20 00 "
            "40 42 40 00 20 02 C0 00 E0 02 C0 C0 A0 42 40 40 "
            "60 42 40 00"
        )
        entry = bytes.fromhex(
            "18 10 00 FF 38 10 01 FF 78 10 02 02 38 10 03 FF "
            "18 10 04 FF 18 10 05 06 B8 10 05 06 D8 10 08 07 "
            "18 10 08 07"
        )
        city_returns = bytes.fromhex(
            "E0 E0 70 90 B0 D0 70 90 92 66 70 90 3E 68 70 90 "
            "3A 9A 70 90 00 5C 30 70 DE 00 70 70 64 34 70 90 "
            "10 26 70 90"
        )
        return_routine = bytes.fromhex(
            world1_underground_rooms.EXPECTED_RETURN_ROUTINE[4]
        )
        prg = bytearray(4 * world1_underground_rooms.BANK_SIZE)
        camera_offset = 0xD1EF - world1_underground_rooms.CPU_BASE
        entry_offset = 0xD213 - world1_underground_rooms.CPU_BASE
        prg[camera_offset:camera_offset + len(camera)] = camera
        prg[entry_offset:entry_offset + len(entry)] = entry
        return_offset = 0xD37E - world1_underground_rooms.CPU_BASE
        routine_offset = 0xD2C3 - world1_underground_rooms.CPU_BASE
        prg[return_offset:return_offset + len(city_returns)] = city_returns
        prg[routine_offset:routine_offset + len(return_routine)] = return_routine
        for callsite in world1_underground_rooms.EXPECTED_RETURN_ROUTINE[3]:
            offset = callsite - world1_underground_rooms.CPU_BASE
            prg[offset:offset + 3] = bytes((0x4C, 0xC3, 0xD2))
        signatures = []
        for address, encoded in world1_underground_rooms.EXPECTED_SIGNATURES:
            raw = bytes.fromhex(encoded)
            offset = address - world1_underground_rooms.CPU_BASE
            prg[offset:offset + len(raw)] = raw
            signatures.append({
                "address": f"0x{address:04X}",
                "purpose": "fixture",
                "bytes": raw.hex(" "),
            })
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": 0,
            "room_count": 9,
            "record_size": 4,
            "camera_profiles": {
                "symbol": world1_underground_rooms.EXPECTED_CAMERA[0],
                "address": "0xD1EF",
                "fields": copy.deepcopy(
                    world1_underground_rooms.EXPECTED_CAMERA[2]
                ),
                "crc32": world1_underground_rooms.crc32(camera),
            },
            "entry_profiles": {
                "symbol": world1_underground_rooms.EXPECTED_ENTRY[0],
                "address": "0xD213",
                "fields": copy.deepcopy(
                    world1_underground_rooms.EXPECTED_ENTRY[2]
                ),
                "no_city_return_sentinel": "0xFF",
                "crc32": world1_underground_rooms.crc32(entry),
            },
            "city_return_profiles": {
                "symbol": world1_underground_rooms.EXPECTED_CITY_RETURN[0],
                "address": "0xD37E",
                "fields": copy.deepcopy(
                    world1_underground_rooms.EXPECTED_CITY_RETURN[2]
                ),
                "crc32": world1_underground_rooms.crc32(city_returns),
            },
            "return_routine": {
                "name": world1_underground_rooms.EXPECTED_RETURN_ROUTINE[0],
                "address": "0xD2C3",
                "size": len(return_routine),
                "jump_callsites": [
                    f"0x{site:04X}"
                    for site in world1_underground_rooms.EXPECTED_RETURN_ROUTINE[3]
                ],
                "bytes": return_routine.hex(" "),
            },
            "signatures": signatures,
        }
        registry: dict[str, object] = {
            "schema_version": 1,
            "symbols": [
                {
                    "bank": 0,
                    "address": f"0x{address:04X}",
                    "name": name,
                    "operand_symbol": True,
                }
                for name, address in (
                    (
                        world1_underground_rooms.EXPECTED_CAMERA[0],
                        world1_underground_rooms.EXPECTED_CAMERA[1],
                    ),
                    (
                        world1_underground_rooms.EXPECTED_ENTRY[0],
                        world1_underground_rooms.EXPECTED_ENTRY[1],
                    ),
                    (
                        world1_underground_rooms.EXPECTED_CITY_RETURN[0],
                        world1_underground_rooms.EXPECTED_CITY_RETURN[1],
                    ),
                )
            ] + [{
                "bank": 0,
                "address": "0xD2C3",
                "name": world1_underground_rooms.EXPECTED_RETURN_ROUTINE[0],
                "operand_symbol": False,
            }],
        }
        return bytes(prg), manifest, registry

    def test_accepts_exact_room_profiles(self) -> None:
        prg, manifest, registry = self.fixture()
        errors, report = world1_underground_rooms.validate_manifest(
            prg, manifest, registry
        )
        self.assertEqual(errors, [])
        self.assertEqual(report["room_count"], 9)
        self.assertEqual(report["covered_byte_count"], 108)
        self.assertEqual(report["return_jump_count"], 2)

    def test_lossless_authoring_roundtrip(self) -> None:
        prg, manifest, registry = self.fixture()
        decoded = world1_underground_rooms.decode_authoring(
            prg, manifest, registry
        )
        rebuilt = world1_underground_rooms.apply_authoring(
            prg, decoded, manifest
        )
        self.assertEqual(rebuilt, prg)
        self.assertEqual(decoded["covered_crc32"], "a95c7f84")
        self.assertIsNone(decoded["rooms"][0]["positive_axis_city_return_id"])

    def test_allows_camera_return_id_and_city_return_edits(self) -> None:
        prg, manifest, registry = self.fixture()
        decoded = world1_underground_rooms.decode_authoring(
            prg, manifest, registry
        )
        decoded["rooms"][3]["camera_tile_x"] = "0x08"
        decoded["rooms"][3]["positive_axis_city_return_id"] = 4
        decoded["city_returns"][4]["manhole_x"] = "0x74"
        rebuilt = world1_underground_rooms.apply_authoring(
            prg, decoded, manifest
        )
        self.assertEqual(rebuilt[0xD1EF - 0x8000 + 12], 0x08)
        self.assertEqual(rebuilt[0xD213 - 0x8000 + 15], 4)
        self.assertEqual(rebuilt[0xD37E - 0x8000 + 18], 0x74)

    def test_rejects_noncontiguous_room_ids(self) -> None:
        prg, manifest, registry = self.fixture()
        decoded = world1_underground_rooms.decode_authoring(
            prg, manifest, registry
        )
        decoded["rooms"][4]["room_id"] = 3
        with self.assertRaisesRegex(ValueError, "not contiguous"):
            world1_underground_rooms.encode_authoring(decoded, manifest)

    def test_rejects_city_return_outside_return_domain(self) -> None:
        prg, manifest, registry = self.fixture()
        decoded = world1_underground_rooms.decode_authoring(
            prg, manifest, registry
        )
        decoded["rooms"][0]["negative_axis_city_return_id"] = 9
        with self.assertRaisesRegex(ValueError, "outside return domain"):
            world1_underground_rooms.encode_authoring(decoded, manifest)

    def test_rejects_changed_table_byte(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = bytearray(prg)
        changed[0xD1EF - 0x8000] ^= 1
        errors, _report = world1_underground_rooms.validate_manifest(
            bytes(changed), manifest, registry
        )
        self.assertTrue(any("camera-profile CRC32 differs" in x for x in errors))

    def test_rejects_changed_consumer_signature(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = bytearray(prg)
        changed[0xCDE3 - 0x8000] ^= 1
        errors, _report = world1_underground_rooms.validate_manifest(
            bytes(changed), manifest, registry
        )
        self.assertTrue(any("signature differs" in x for x in errors))

    def test_rejects_changed_city_return_routine(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = bytearray(prg)
        changed[0xD2C3 - 0x8000] ^= 1
        errors, _report = world1_underground_rooms.validate_manifest(
            bytes(changed), manifest, registry
        )
        self.assertTrue(any("routine bytes differ" in x for x in errors))

    def test_rejects_changed_city_return_jump(self) -> None:
        prg, manifest, registry = self.fixture()
        changed = bytearray(prg)
        changed[0xCEBF - 0x8000] = 0x60
        errors, _report = world1_underground_rooms.validate_manifest(
            bytes(changed), manifest, registry
        )
        self.assertTrue(any("jump callsites differ" in x for x in errors))

    def test_rejects_nonoperand_table_symbol(self) -> None:
        prg, manifest, registry = self.fixture()
        registry["symbols"][0]["operand_symbol"] = False
        errors, _report = world1_underground_rooms.validate_manifest(
            prg, manifest, registry
        )
        self.assertTrue(any("symbol differs" in x for x in errors))


if __name__ == "__main__":
    unittest.main()
