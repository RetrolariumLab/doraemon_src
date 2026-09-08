from __future__ import annotations

import copy
import json
from pathlib import Path
import sys
import tempfile
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))

from scripts.validation.world2 import world2_enemy_states


class World2EnemyStateTests(unittest.TestCase):
    def fixture(self) -> tuple[bytes, dict[str, object], dict[str, object], dict[str, object]]:
        prg = bytearray(4 * world2_enemy_states.BANK_SIZE)
        bank_offset = world2_enemy_states.BANK_SIZE
        signature = bytes.fromhex("29 1F 49 10 18 69 01")
        prg[bank_offset + 0x1000:bank_offset + 0x1007] = signature
        properties = [
            ("attack", 0x9100, bytes((9, 8, 7, 6))),
            ("damage", 0x9103, bytes((6, 3, 2, 1))),
            ("reward", 0x9305, bytes((0x90, 1, 2, 3))),
        ]
        for _name, address, values in properties:
            offset = bank_offset + address - world2_enemy_states.CPU_BASE
            prg[offset:offset + len(values)] = values
        render_targets = [0xA000, 0xA010, 0xA020]
        update_targets = [0xA030, 0xA040, 0x9100]
        for address, targets in ((0x9200, render_targets), (0x9300, update_targets)):
            encoded = world2_enemy_states.rts_minus_one_bytes(targets)
            offset = bank_offset + address - world2_enemy_states.CPU_BASE
            prg[offset:offset + len(encoded)] = encoded
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": 1,
            "spawn_encoding": {
                "token_min": "0xD0",
                "token_max": "0xD1",
                "state_formula": "((token & 0x1F) ^ 0x10) + 1",
                "state_min": 1,
                "state_max": 2,
                "expected_physical_total": 2,
                "expected_selector_total": 3,
                "token_counts": {"0xD0": 1, "0xD1": 1},
                "normalization_signature": {
                    "address": "0x9000",
                    "bytes": signature.hex(" "),
                },
            },
            "runtime_states": {
                "state_count": 3,
                "direct_spawn_states": [1, 2],
                "internal_states": [3],
            },
            "property_tables": [
                {
                    "name": name,
                    "address": f"0x{address:04X}",
                    "slot_count": 4,
                    "crc32": world2_enemy_states.crc32(values),
                    "values": list(values),
                }
                for name, address, values in properties
            ],
            "dispatch_contracts": [
                {
                    "name": "render",
                    "state_min": 1,
                    "state_max": 3,
                    "slot_count": 3,
                },
                {
                    "name": "update",
                    "state_min": 0,
                    "state_max": 2,
                    "slot_count": 3,
                },
            ],
            "shared_boundaries": [
                {
                    "left": "attack",
                    "left_last_byte": "0x9103",
                    "right": "damage",
                    "right_first_byte": "0x9103",
                },
                {
                    "left": "update",
                    "left_last_byte": "0x9305",
                    "right": "reward",
                    "right_first_byte": "0x9305",
                },
            ],
            "shared_overlaps": [],
        }
        dispatch = {
            "tables": [
                {
                    "name": "render",
                    "address": "0x9200",
                    "encoding": "rts-minus-one",
                    "slot_count": 3,
                    "targets": render_targets,
                },
                {
                    "name": "update",
                    "address": "0x9300",
                    "encoding": "rts-minus-one",
                    "slot_count": 3,
                    "targets": update_targets,
                },
            ]
        }
        authoring = {
            "tokens": ["0000:S:D0", "0001:S:D1"],
            "selectors": [
                {"rows": ["0000-0002:2"]},
                {"rows": ["0000-0001:1"]},
            ],
        }
        return bytes(prg), manifest, dispatch, authoring

    def test_accepts_complete_state_catalog(self) -> None:
        prg, manifest, dispatch, authoring = self.fixture()
        errors, report = world2_enemy_states.validate(
            prg, manifest, dispatch, authoring
        )
        self.assertEqual(errors, [])
        self.assertEqual(report["selector_spawn_count"], 3)

    def test_rejects_changed_spawn_frequency(self) -> None:
        prg, manifest, dispatch, authoring = self.fixture()
        changed = copy.deepcopy(authoring)
        changed["tokens"][1] = "0001:S:D0"
        errors, _report = world2_enemy_states.validate(
            prg, manifest, dispatch, changed
        )
        self.assertTrue(any("frequency table differs" in error for error in errors))

    def test_rejects_changed_property_byte(self) -> None:
        prg, manifest, dispatch, authoring = self.fixture()
        changed = bytearray(prg)
        changed[world2_enemy_states.BANK_SIZE + 0x1101] ^= 1
        errors, _report = world2_enemy_states.validate(
            bytes(changed), manifest, dispatch, authoring
        )
        self.assertTrue(any("property table differs" in error for error in errors))

    def test_rejects_changed_shared_boundary(self) -> None:
        prg, manifest, dispatch, authoring = self.fixture()
        changed = copy.deepcopy(manifest)
        changed["shared_boundaries"][0]["left_last_byte"] = "0x9102"
        errors, _report = world2_enemy_states.validate(
            prg, changed, dispatch, authoring
        )
        self.assertTrue(any("shared boundary differs" in error for error in errors))

    def test_lossless_authoring_roundtrip(self) -> None:
        prg, manifest, dispatch, screen_authoring = self.fixture()
        decoded = world2_enemy_states.decode_authoring(
            prg, manifest, dispatch, screen_authoring
        )
        self.assertEqual(world2_enemy_states.apply_authoring(prg, decoded), prg)
        self.assertEqual(decoded["covered_byte_count"], 11)

    def test_authoring_encoder_allows_property_edit(self) -> None:
        prg, manifest, dispatch, screen_authoring = self.fixture()
        decoded = world2_enemy_states.decode_authoring(
            prg, manifest, dispatch, screen_authoring
        )
        changed = copy.deepcopy(decoded)
        changed["records"][1]["attack"] = "0x44"
        encoded = world2_enemy_states.apply_authoring(prg, changed)
        self.assertEqual(
            encoded[world2_enemy_states.BANK_SIZE + 0x1101], 0x44
        )

    def test_authoring_encoder_rejects_conflicting_shared_byte(self) -> None:
        prg, manifest, dispatch, screen_authoring = self.fixture()
        decoded = world2_enemy_states.decode_authoring(
            prg, manifest, dispatch, screen_authoring
        )
        changed = copy.deepcopy(decoded)
        changed["records"][0]["damage"] = "0x05"
        with self.assertRaisesRegex(ValueError, "conflicts with another property"):
            world2_enemy_states.encode_authoring(changed)

    def test_authoring_validation_rejects_changed_crc(self) -> None:
        prg, manifest, dispatch, screen_authoring = self.fixture()
        decoded = world2_enemy_states.decode_authoring(
            prg, manifest, dispatch, screen_authoring
        )
        decoded["covered_crc32"] = "00000000"
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "enemy_states.json"
            path.write_text(json.dumps(decoded), encoding="utf-8")
            errors = world2_enemy_states.validate_authoring(
                prg, manifest, dispatch, screen_authoring, path
            )
        self.assertTrue(any("CRC32 differs" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
