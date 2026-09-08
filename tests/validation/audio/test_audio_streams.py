from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))

from scripts.validation.audio import audio_music
from scripts.validation.audio import audio_streams


class AudioStreamTests(unittest.TestCase):
    def fixture(self) -> tuple[bytes, dict[str, object], dict[str, object]]:
        prg = bytearray(4 * audio_streams.BANK_SIZE)
        header = b"".join(
            pointer.to_bytes(2, "little")
            for pointer in (0x8200, 0x8210, 0x8220, 0x8230)
        )
        prg[0x100:0x108] = header
        prg[0x200:0x204] = bytes((0xF6, 0x00, 0x83, 0xFF))
        prg[0x210:0x216] = bytes((0xFD, 0x02, 0x81, 0x01, 0xFC, 0xFF))
        prg[0x220:0x224] = bytes((0xF7, 0x82, 0x01, 0xFE))
        prg[0x230] = 0xF1
        prg[0x300:0x303] = bytes((0x80, 0x01, 0xF3))
        driver: dict[str, object] = {
            "bank": 0,
            "name": "fixture",
            "track_id_min": 1,
            "track_id_limit": 2,
            "track_count": 1,
            "track_header_table": "0x8100",
        }
        music: dict[str, object] = {
            "commands": [
                {
                    "opcode": hex(opcode),
                    "operand_bytes": operand_count,
                    "name": name,
                }
                for opcode, operand_count, name in audio_music.EXPECTED_COMMANDS
            ],
            "drivers": [driver],
        }
        return bytes(prg), music, driver

    def test_traces_calls_loops_saved_positions_and_track_restarts(self) -> None:
        prg, music, driver = self.fixture()
        decoded = audio_streams.scan_driver(
            prg,
            driver,
            audio_streams.command_grammar(music),
        )
        self.assertEqual(decoded["metrics"]["reachable_bytes"], 18)
        self.assertEqual(decoded["metrics"]["token_count"], 15)
        self.assertEqual(decoded["metrics"]["ended_paths"], 2)
        self.assertEqual(decoded["metrics"]["cycle_paths"], 2)
        self.assertEqual(len(decoded["segments"]), 5)

    def test_lossless_driver_roundtrip(self) -> None:
        prg, music, driver = self.fixture()
        decoded = audio_streams.scan_driver(
            prg,
            driver,
            audio_streams.command_grammar(music),
        )
        expected = bytearray(prg[0x100:0x108])
        for segment in decoded["segments"]:
            start = audio_streams.number(segment["address"]) - 0x8000
            expected.extend(prg[start:start + int(segment["size"])])
        self.assertEqual(audio_streams.encode_driver(decoded), bytes(expected))

    def test_authoring_encoder_allows_same_size_edits(self) -> None:
        prg, music, driver = self.fixture()
        decoded = audio_streams.scan_driver(
            prg,
            driver,
            audio_streams.command_grammar(music),
        )
        changed = copy.deepcopy(decoded)
        events = changed["segments"][0]["events"]
        events[0] = "CallStream $01 $83"
        self.assertNotEqual(
            audio_streams.encode_driver(changed),
            audio_streams.encode_driver(decoded),
        )

    def test_rejects_wrong_command_operand_count(self) -> None:
        prg, music, driver = self.fixture()
        decoded = audio_streams.scan_driver(
            prg,
            driver,
            audio_streams.command_grammar(music),
        )
        changed = copy.deepcopy(decoded)
        changed["segments"][0]["events"][0] = "CallStream $00"
        with self.assertRaisesRegex(ValueError, "wrong operand count"):
            audio_streams.encode_driver(changed)

    def test_rejects_event_class_mismatch(self) -> None:
        with self.assertRaisesRegex(ValueError, "event class differs"):
            audio_streams.parse_event("event $80", 0x9000)

    def test_rejects_track_count_that_includes_zero_state(self) -> None:
        prg, music, driver = self.fixture()
        changed = copy.deepcopy(driver)
        changed["track_count"] = 2
        with self.assertRaisesRegex(ValueError, "track-ID geometry differs"):
            audio_streams.scan_driver(
                prg,
                changed,
                audio_streams.command_grammar(music),
            )


if __name__ == "__main__":
    unittest.main()
