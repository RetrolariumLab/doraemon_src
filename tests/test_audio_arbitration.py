from __future__ import annotations

import copy
import importlib.util
from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
SPEC = importlib.util.spec_from_file_location(
    "audio_arbitration", ROOT / "scripts" / "audio_arbitration.py"
)
assert SPEC is not None and SPEC.loader is not None
AUDIO = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(AUDIO)


class AudioArbitrationTests(unittest.TestCase):
    def fixture(self) -> tuple[bytearray, dict[str, object], dict[str, object]]:
        prg = bytearray(4 * AUDIO.BANK_SIZE)
        start = 3 * AUDIO.BANK_SIZE
        prg[start:start + 6] = bytes.fromhex("20 00 90 4C 00 A0")
        prg[start + 0x1000:start + 0x1000 + len(AUDIO.TIMER_TICK)] = AUDIO.TIMER_TICK
        prg[start + 0x2000:start + 0x2000 + len(AUDIO.RESET_PREFIX)] = AUDIO.RESET_PREFIX
        prg[start + 0x3000:start + 0x3004] = bytes.fromhex("BC A3 02 D0")
        prg[start + 0x3010:start + 0x3014] = bytes.fromhex("AD A6 02 D0")
        document = {
            "schema_version": 1,
            "channels": [
                {"timer_index": 0, "name": "pulse-1", "apu_base": "0x4000"},
                {"timer_index": 1, "name": "pulse-2", "apu_base": "0x4004"},
                {"timer_index": 2, "name": "triangle", "apu_base": "0x4008"},
                {"timer_index": 3, "name": "noise", "apu_base": "0x400C"},
            ],
            "shared_ram": [
                {"address": "0x02A3", "name": "AudioEffectTimers"}
            ],
            "drivers": [{
                "name": "shell",
                "bank": 3,
                "frame_update": {"address": "0x8000", "symbol": "Audio_UpdateFrame", "tail": "jmp"},
                "effect_update": {"address": "0x9000", "symbol": "Audio_UpdateEffects"},
                "music_update": {"address": "0xA000", "symbol": "Audio_UpdateMusic"},
                "track_start_reset": {"address": "0xA000", "symbol": "Audio_ResetChannels", "timer_guarded": False},
                "music_write_guards": [
                    {"path": "tonal", "address": "0xB000", "timer_index": 0, "indexed": True},
                    {"path": "noise", "address": "0xB010", "timer_index": 3, "indexed": False},
                ],
            }],
        }
        symbols = {
            "schema_version": 1,
            "symbols": [
                {"bank": 3, "address": "0x8000", "name": "Audio_UpdateFrame"},
                {"bank": 3, "address": "0x9000", "name": "Audio_UpdateEffects"},
                {"bank": 3, "address": "0xA000", "name": "Audio_UpdateMusic"},
                {"bank": 3, "address": "0xA000", "name": "Audio_ResetChannels"},
            ],
            "memory_symbols": [
                {"address": "0x02A3", "name": "AudioEffectTimers"}
            ],
        }
        return prg, document, symbols

    def test_accepts_effect_first_and_guarded_music_paths(self) -> None:
        prg, document, symbols = self.fixture()
        errors, report = AUDIO.validate(bytes(prg), document, symbols)
        self.assertEqual(errors, [])
        self.assertEqual(report["guard_count"], 2)

    def test_rejects_music_first_frame_path(self) -> None:
        prg, document, symbols = self.fixture()
        prg[3 * AUDIO.BANK_SIZE] = 0x4C
        errors, _report = AUDIO.validate(bytes(prg), document, symbols)
        self.assertTrue(any("effect-before-music" in error for error in errors))

    def test_rejects_missing_guard(self) -> None:
        prg, document, symbols = self.fixture()
        prg[3 * AUDIO.BANK_SIZE + 0x3000] = 0xEA
        errors, _report = AUDIO.validate(bytes(prg), document, symbols)
        self.assertTrue(any("timer guard differs" in error for error in errors))

    def test_requires_unguarded_track_start_exception(self) -> None:
        prg, document, symbols = self.fixture()
        changed = copy.deepcopy(document)
        changed["drivers"][0]["track_start_reset"]["timer_guarded"] = True
        errors, _report = AUDIO.validate(bytes(prg), changed, symbols)
        self.assertTrue(any("unguarded exception" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
