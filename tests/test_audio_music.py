from __future__ import annotations

import importlib.util
from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parent.parent
SPEC = importlib.util.spec_from_file_location(
    "audio_music", ROOT / "scripts" / "audio_music.py"
)
assert SPEC is not None and SPEC.loader is not None
AUDIO = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(AUDIO)


class AudioMusicTests(unittest.TestCase):
    def test_command_grammar_covers_ff_through_ef(self) -> None:
        self.assertEqual(
            [opcode for opcode, _size, _name in AUDIO.EXPECTED_COMMANDS],
            list(range(0xFF, 0xEE, -1)),
        )
        self.assertEqual(sum(size for _opcode, size, _name in AUDIO.EXPECTED_COMMANDS), 10)

    def test_memory_symbol_requires_shared_exact_range(self) -> None:
        registry = {
            "memory_symbols": [
                {"address": "0x02C4", "size": 8, "name": "LoopPointers"}
            ]
        }
        self.assertTrue(
            AUDIO.memory_symbol_matches(registry, 0x02C4, 8, "LoopPointers")
        )
        registry["memory_symbols"][0]["banks"] = [0]
        self.assertFalse(
            AUDIO.memory_symbol_matches(registry, 0x02C4, 8, "LoopPointers")
        )

    def test_prg_symbol_rejects_operand_only_alias(self) -> None:
        registry = {
            "symbols": [
                {
                    "bank": 2,
                    "address": "0xC796",
                    "name": "World3_MusicCommand_EndChannel",
                    "operand_symbol": True,
                }
            ]
        }
        self.assertFalse(
            AUDIO.prg_symbol_matches(
                registry, 2, 0xC796, "World3_MusicCommand_EndChannel"
            )
        )

    def test_track_header_index_requires_operand_symbol(self) -> None:
        registry = {
            "symbols": [
                {
                    "bank": 1,
                    "address": "0xB2E2",
                    "name": "World2_MusicTrackHeaderIndexBase",
                    "operand_symbol": True,
                }
            ]
        }
        self.assertTrue(
            AUDIO.prg_operand_symbol_matches(
                registry, 1, 0xB2E2, "World2_MusicTrackHeaderIndexBase"
            )
        )

    def test_playable_track_counts_exclude_zero_state(self) -> None:
        self.assertEqual(
            sum(identity[4] for identity in AUDIO.EXPECTED_DRIVERS.values()),
            26,
        )

    def test_dispatches_are_indexed_by_bank(self) -> None:
        document = {
            "name": "shell",
            "bank": 3,
            "additional_drivers": [
                {"name": "world1", "bank": 0},
                {"name": "world2", "bank": 1},
            ],
        }
        actual = AUDIO.dispatch_by_bank(document)
        self.assertEqual(set(actual), {0, 1, 3})
        self.assertNotIn("additional_drivers", actual[3])

    def test_bank_slice_keeps_overlays_separate(self) -> None:
        prg = b"".join(bytes((bank,)) * AUDIO.BANK_SIZE for bank in range(4))
        self.assertEqual(AUDIO.bank_slice(prg, 2, 0x9000, 3), b"\x02" * 3)
        with self.assertRaisesRegex(ValueError, "outside bank"):
            AUDIO.bank_slice(prg, 4, 0x8000, 1)


if __name__ == "__main__":
    unittest.main()
