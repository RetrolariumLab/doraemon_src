from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import world3_update_handlers


class World3UpdateHandlerTests(unittest.TestCase):
    def fixture(
        self,
    ) -> tuple[bytes, dict[str, object], dict[str, object], dict[str, object]]:
        bank = 2
        tracking = bytes([1] * 8 + [0] * 56)
        motion = bytes((2, 0xFE, 2, 0xFE, 2, 2, 0xFE, 0xFE))
        blocked = bytes([1] * 23 + [0] * 41)
        specs = [
            ("type04_tracking_enabled_by_room", 0x9000, 64, ["enabled"], tracking),
            ("type05_held_motion", 0x9100, 4, ["delta_x", "delta_y"], motion),
            ("type05_relocation_blocked_by_room", 0x9200, 64, ["blocked"], blocked),
        ]
        prg = bytearray(4 * world3_update_handlers.BANK_SIZE)
        base = bank * world3_update_handlers.BANK_SIZE
        for _name, address, _count, _fields, payload in specs:
            offset = address - 0x8000
            prg[base + offset:base + offset + len(payload)] = payload
        signature = bytes((0xBD, 0x00, 0x06, 0xC9, 0x04))
        prg[base + 0x1400:base + 0x1405] = signature
        targets = [0xA000 + index for index in range(32)]
        regions = [
            {
                "name": name,
                "address": hex(address),
                "count": count,
                "fields": fields,
                "crc32": world3_update_handlers.crc32(payload),
            }
            for name, address, count, fields, payload in specs
        ]
        combined = tracking + motion + blocked
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": bank,
            "type_count": 32,
            "dispatch_name": "fixture_updates",
            "handlers": [
                {
                    "type": index,
                    "target": hex(targets[index]),
                    "role": f"fixture_role_{index}",
                }
                for index in range(32)
            ],
            "data_regions": regions,
            "covered_byte_count": len(combined),
            "covered_crc32": world3_update_handlers.crc32(combined),
            "expected_metrics": {
                "tracking_enabled_rooms": 8,
                "relocation_blocked_rooms": 23,
                "held_motion_vectors": [[2, 2], [-2, 2], [2, -2], [-2, -2]],
            },
            "signatures": [
                {"address": "0x9400", "bytes": signature.hex(" ")}
            ],
        }
        dispatch: dict[str, object] = {
            "tables": [
                {
                    "name": "fixture_updates",
                    "bank": bank,
                    "slot_count": 32,
                    "targets": [hex(target) for target in targets],
                }
            ]
        }
        entity_types: dict[str, object] = {"type_count": 32}
        return bytes(prg), manifest, dispatch, entity_types

    def test_accepts_update_contract(self) -> None:
        prg, manifest, dispatch, entity_types = self.fixture()
        errors, report = world3_update_handlers.validate_manifest(
            prg, manifest, dispatch, entity_types
        )
        self.assertEqual(errors, [])
        self.assertEqual(report["type_count"], 32)

    def test_lossless_authoring_roundtrip(self) -> None:
        prg, manifest, dispatch, entity_types = self.fixture()
        decoded = world3_update_handlers.decode_authoring(
            prg, manifest, dispatch, entity_types
        )
        rebuilt = world3_update_handlers.apply_authoring(prg, decoded, manifest)
        self.assertEqual(rebuilt, prg)
        self.assertEqual(decoded["covered_byte_count"], 136)

    def test_allows_motion_edit(self) -> None:
        prg, manifest, dispatch, entity_types = self.fixture()
        decoded = world3_update_handlers.decode_authoring(
            prg, manifest, dispatch, entity_types
        )
        changed = copy.deepcopy(decoded)
        changed["regions"][1]["records"][0]["delta_x"] = "0x03"
        rebuilt = world3_update_handlers.apply_authoring(prg, changed, manifest)
        self.assertEqual(rebuilt[2 * 0x8000 + 0x1100], 3)

    def test_rejects_dispatch_change(self) -> None:
        prg, manifest, dispatch, entity_types = self.fixture()
        dispatch["tables"][0]["targets"][0] = "0xB000"
        errors, _report = world3_update_handlers.validate_manifest(
            prg, manifest, dispatch, entity_types
        )
        self.assertTrue(any("dispatch contract differs" in error for error in errors))

    def test_rejects_room_flag_change(self) -> None:
        prg, manifest, dispatch, entity_types = self.fixture()
        changed = bytearray(prg)
        changed[2 * 0x8000 + 0x1000 + 8] = 1
        errors, _report = world3_update_handlers.validate_manifest(
            bytes(changed), manifest, dispatch, entity_types
        )
        self.assertTrue(any("tracking-room flags differ" in error for error in errors))

    def test_rejects_changed_signature(self) -> None:
        prg, manifest, dispatch, entity_types = self.fixture()
        changed = bytearray(prg)
        changed[2 * 0x8000 + 0x1400] ^= 1
        errors, _report = world3_update_handlers.validate_manifest(
            bytes(changed), manifest, dispatch, entity_types
        )
        self.assertTrue(any("signature differs" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
