from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import world2_stage_branches


class World2StageBranchTests(unittest.TestCase):
    def fixture(self) -> tuple[bytes, dict[str, object]]:
        prg = bytearray(4 * world2_stage_branches.BANK_SIZE)
        bank_offset = world2_stage_branches.BANK_SIZE
        tables = {
            "trigger_screens": bytes((1, 2, 3, 4)),
            "destination_offsets": bytes((5, 6, 7, 8)),
            "condition_codes": bytes((0, 1, 2, 3)),
            "return_overrides": bytes((0, 9, 0, 10)),
        }
        addresses = {
            "trigger_screens": 0x9000,
            "destination_offsets": 0x9004,
            "condition_codes": 0x9008,
            "return_overrides": 0x900C,
        }
        for name, data in tables.items():
            offset = bank_offset + addresses[name] - 0x8000
            prg[offset:offset + len(data)] = data
        signature = bytes((0xA5, 0xAE, 0xD0, 0x15))
        prg[bank_offset + 0x1100:bank_offset + 0x1104] = signature
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": 1,
            "branch_count": 4,
            "trigger_row": 13,
            "sequence_size": 16,
            "cooldown_frames": 255,
            "tables": {
                name: {
                    "address": hex(addresses[name]),
                    "crc32": world2_stage_branches.crc32(data),
                }
                for name, data in tables.items()
            },
            "conditions": [
                {"code": 0, "name": "always"},
                {"code": 1, "name": "player_y_below_0x50"},
                {"code": 2, "name": "player_x_at_least_0xA0"},
                {"code": 3, "name": "player_y_at_least_0xA0"},
            ],
            "expected_condition_counts": {
                "always": 1,
                "player_y_below_0x50": 1,
                "player_x_at_least_0xA0": 1,
                "player_y_at_least_0xA0": 1,
            },
            "expected_return_override_count": 2,
            "routine_signature": {
                "address": "0x9100",
                "bytes": signature.hex(" "),
            },
        }
        return bytes(prg), manifest

    def test_lossless_authoring_roundtrip(self) -> None:
        prg, manifest = self.fixture()
        decoded = world2_stage_branches.decode_authoring(prg, manifest)
        rebuilt = world2_stage_branches.apply_authoring(prg, decoded, manifest)
        self.assertEqual(rebuilt, prg)
        self.assertEqual(decoded["covered_byte_count"], 16)

    def test_decodes_zero_return_as_dynamic_current_offset(self) -> None:
        prg, manifest = self.fixture()
        decoded = world2_stage_branches.decode_authoring(prg, manifest)
        self.assertIsNone(decoded["branches"][0]["return_offset_override"])
        self.assertEqual(decoded["branches"][1]["return_offset_override"], "0x09")

    def test_allows_lossless_destination_edit(self) -> None:
        prg, manifest = self.fixture()
        decoded = world2_stage_branches.decode_authoring(prg, manifest)
        changed = copy.deepcopy(decoded)
        changed["branches"][0]["destination_offset"] = "0x0F"
        rebuilt = world2_stage_branches.apply_authoring(prg, changed, manifest)
        self.assertEqual(rebuilt[world2_stage_branches.BANK_SIZE + 0x1004], 15)

    def test_rejects_non_screen_trigger(self) -> None:
        prg, manifest = self.fixture()
        decoded = world2_stage_branches.decode_authoring(prg, manifest)
        decoded["branches"][0]["trigger_screen_id"] = "0x7F"
        with self.assertRaisesRegex(ValueError, "not a real"):
            world2_stage_branches.encode_authoring(decoded, manifest)

    def test_rejects_unknown_condition(self) -> None:
        prg, manifest = self.fixture()
        decoded = world2_stage_branches.decode_authoring(prg, manifest)
        decoded["branches"][0]["condition"] = "unknown"
        with self.assertRaisesRegex(ValueError, "unknown"):
            world2_stage_branches.encode_authoring(decoded, manifest)

    def test_rejects_changed_routine_signature(self) -> None:
        prg, manifest = self.fixture()
        changed = bytearray(prg)
        changed[world2_stage_branches.BANK_SIZE + 0x1100] ^= 1
        errors, _report = world2_stage_branches.validate_manifest(
            bytes(changed), manifest
        )
        self.assertTrue(any("routine signature" in error for error in errors))

    def test_rejects_trigger_absent_from_stage_sequence(self) -> None:
        prg, manifest = self.fixture()
        stage = {
            "format": "doraemon-world2-stage-sequence",
            "bank": 1,
            "entries": [
                {
                    "offset": offset,
                    "command": "select_screen",
                    "screen_id": "0x00",
                }
                for offset in range(16)
            ],
        }
        errors = world2_stage_branches.validate_stage_authoring(
            prg, stage, manifest
        )
        self.assertTrue(any("absent from stage sequence" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
