from __future__ import annotations

import copy
import json
from pathlib import Path
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import world2_stage_sequence


class World2StageSequenceTests(unittest.TestCase):
    def fixture(self) -> tuple[bytes, dict[str, object]]:
        prg = bytearray(4 * world2_stage_sequence.BANK_SIZE)
        bank_offset = world2_stage_sequence.BANK_SIZE
        sequence = bytes((0x01, 0x81, 0xF0, 0xF4, 0xF7, 0xF8, 0xF9, 0xFF))
        starts = bytes((0, 2))
        signature = bytes((0xC9, 0xF0, 0x90, 0x28))
        prg[bank_offset + 0x1000:bank_offset + 0x1008] = sequence
        prg[bank_offset + 0x1100:bank_offset + 0x1102] = starts
        prg[bank_offset + 0x1200:bank_offset + 0x1204] = signature
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": 1,
            "sequence": {
                "address": "0x9000",
                "size": 8,
                "crc32": world2_stage_sequence.crc32(sequence),
                "expected_command_counts": {
                    "select_screen": 2,
                    "set_pending_direction": 2,
                    "restore_saved_offset": 1,
                    "stop_scroll": 1,
                    "set_event_code": 2,
                },
                "expected_high_screen_token_count": 1,
                "expected_unique_screen_id_count": 1,
            },
            "start_offsets": {
                "address": "0x9100",
                "count": 2,
                "crc32": world2_stage_sequence.crc32(starts),
                "values": list(starts),
            },
            "opcodes": [
                {"range": "0x00-0xEF", "command": "select_screen"},
                {
                    "range": "0xF0-0xF6",
                    "command": "set_pending_direction",
                },
                {"range": "0xF7", "command": "restore_saved_offset"},
                {"range": "0xF8", "command": "stop_scroll"},
                {"range": "0xF9-0xFF", "command": "set_event_code"},
            ],
            "decoder_signatures": [
                {"address": "0x9200", "bytes": signature.hex(" ")}
            ],
        }
        return bytes(prg), manifest

    def test_accepts_complete_sequence(self) -> None:
        prg, manifest = self.fixture()
        errors, report = world2_stage_sequence.validate_manifest(prg, manifest)
        self.assertEqual(errors, [])
        self.assertEqual(report["control_command_count"], 6)

    def test_lossless_authoring_roundtrip(self) -> None:
        prg, manifest = self.fixture()
        decoded = world2_stage_sequence.decode_authoring(prg, manifest)
        self.assertEqual(world2_stage_sequence.apply_authoring(prg, decoded), prg)
        self.assertEqual(decoded["covered_byte_count"], 10)

    def test_authoring_encoder_allows_screen_edit(self) -> None:
        prg, manifest = self.fixture()
        decoded = world2_stage_sequence.decode_authoring(prg, manifest)
        changed = copy.deepcopy(decoded)
        changed["entries"][0]["raw"] = "0x02"
        changed["entries"][0]["screen_id"] = "0x02"
        encoded = world2_stage_sequence.apply_authoring(prg, changed)
        self.assertEqual(encoded[world2_stage_sequence.BANK_SIZE + 0x1000], 2)

    def test_rejects_command_that_differs_from_raw_token(self) -> None:
        prg, manifest = self.fixture()
        decoded = world2_stage_sequence.decode_authoring(prg, manifest)
        changed = copy.deepcopy(decoded)
        changed["entries"][4]["command"] = "stop_scroll"
        with self.assertRaisesRegex(ValueError, "differs from raw token"):
            world2_stage_sequence.encode_authoring(changed)

    def test_rejects_noncontiguous_offsets(self) -> None:
        prg, manifest = self.fixture()
        decoded = world2_stage_sequence.decode_authoring(prg, manifest)
        changed = copy.deepcopy(decoded)
        changed["entries"][2]["offset"] = 9
        with self.assertRaisesRegex(ValueError, "offsets are not contiguous"):
            world2_stage_sequence.encode_authoring(changed)

    def test_authoring_validation_rejects_changed_crc(self) -> None:
        prg, manifest = self.fixture()
        decoded = world2_stage_sequence.decode_authoring(prg, manifest)
        decoded["covered_crc32"] = "00000000"
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "stage.json"
            path.write_text(json.dumps(decoded), encoding="utf-8")
            errors = world2_stage_sequence.validate_authoring(
                prg, manifest, path
            )
        self.assertTrue(any("CRC32 differs" in error for error in errors))

    def test_rejects_changed_decoder_signature(self) -> None:
        prg, manifest = self.fixture()
        changed = bytearray(prg)
        changed[world2_stage_sequence.BANK_SIZE + 0x1200] ^= 1
        errors, _report = world2_stage_sequence.validate_manifest(
            bytes(changed), manifest
        )
        self.assertTrue(any("decoder signature differs" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
