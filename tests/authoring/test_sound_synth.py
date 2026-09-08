from __future__ import annotations

import copy
import json
from pathlib import Path
import sys
import tempfile
import unittest
import wave


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))

from scripts.validation.audio import audio_streams
from scripts.authoring.sound_synth import (
    CHANNEL_NAMES,
    SynthError,
    decode_track,
    render_pcm,
    write_preview,
)


class SoundSynthTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.document = json.loads(
            (ROOT / "data/audio/music_streams.json").read_text(encoding="utf-8")
        )
        cls.prg = (ROOT / "assets/generated/prg/doraemon.prg").read_bytes()

    def test_every_native_track_decodes_into_four_lanes(self) -> None:
        count = 0
        for driver_index, driver in enumerate(self.document["drivers"]):
            for header_index, _header in enumerate(driver["headers"]):
                decoded = decode_track(
                    self.document,
                    self.prg,
                    driver_index,
                    header_index,
                    max_frames=240,
                )
                self.assertEqual(tuple(lane.name for lane in decoded.lanes), CHANNEL_NAMES)
                self.assertTrue(any(lane.events for lane in decoded.lanes))
                self.assertLessEqual(len(decoded.frames), 240)
                count += 1
        self.assertEqual(count, 26)

    def test_unsaved_note_edit_changes_the_preview_frequency(self) -> None:
        original = decode_track(
            self.document, self.prg, 0, 0, max_frames=120
        )
        event = next(
            item for item in original.lanes[0].events if item.frequency > 0
        )
        edited = copy.deepcopy(self.document)
        changed = False
        for segment in edited["drivers"][0]["segments"]:
            cursor = audio_streams.number(segment["address"])
            for index, text in enumerate(segment["events"]):
                token = audio_streams.parse_event(str(text), cursor)
                if cursor == event.source_address:
                    self.assertEqual(token.kind, "event")
                    replacement = min(0x7F, token.opcode + 1)
                    segment["events"][index] = f"event ${replacement:02X}"
                    changed = True
                    break
                cursor += len(token.raw)
            if changed:
                break
        self.assertTrue(changed)
        preview = decode_track(edited, self.prg, 0, 0, max_frames=120)
        changed_event = next(
            item
            for item in preview.lanes[0].events
            if item.source_address == event.source_address
        )
        self.assertNotEqual(changed_event.frequency, event.frequency)

    def test_pcm_and_wave_are_mono_sixteen_bit_audio(self) -> None:
        decoded = decode_track(
            self.document, self.prg, 3, 0, max_frames=30
        )
        pcm = render_pcm(decoded, sample_rate=8_000)
        self.assertEqual(len(pcm) % 2, 0)
        self.assertGreater(len(pcm), 7_000)
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "preview.wav"
            write_preview(
                self.document,
                self.prg,
                3,
                0,
                path,
                max_frames=30,
                sample_rate=8_000,
            )
            with wave.open(str(path), "rb") as source:
                self.assertEqual(source.getnchannels(), 1)
                self.assertEqual(source.getsampwidth(), 2)
                self.assertEqual(source.getframerate(), 8_000)

    def test_pulse_hardware_envelope_fades_a_sustained_note(self) -> None:
        decoded = decode_track(
            self.document, self.prg, 1, 0, max_frames=180
        )
        event = next(
            item
            for item in decoded.lanes[0].events
            if item.frequency > 0 and item.duration_frames >= 24
        )
        start = decoded.frames[event.start_frame][0].volume
        tail = decoded.frames[event.start_frame + event.duration_frames - 1][0].volume
        self.assertEqual(start, 15)
        self.assertLess(tail, start)

    def test_noise_table_and_hardware_envelope_produce_audible_bursts(self) -> None:
        frequencies = []
        for driver_index, header_index in ((0, 0), (1, 4), (2, 0), (3, 0)):
            decoded = decode_track(
                self.document,
                self.prg,
                driver_index,
                header_index,
                max_frames=200,
            )
            event = next(
                item for item in decoded.lanes[3].events if item.frequency > 0
            )
            self.assertGreater(event.volume, 0)
            self.assertGreater(decoded.frames[event.start_frame][3].volume, 0)
            if driver_index < 3:
                frequencies.append(event.frequency)
        self.assertAlmostEqual(max(frequencies), min(frequencies), places=6)
        burst = decode_track(
            self.document, self.prg, 0, 0, max_frames=30
        )
        event = next(item for item in burst.lanes[3].events if item.frequency > 0)
        self.assertGreater(
            burst.frames[event.start_frame][3].volume,
            burst.frames[event.start_frame + 4][3].volume,
        )

    def test_title_noise_zero_index_holds_the_silent_envelope_tail(self) -> None:
        decoded = decode_track(
            self.document, self.prg, 3, 0, max_frames=60
        )
        noise_events = decoded.lanes[3].events
        hold = next(
            item for item in noise_events if item.source_address == 0xA7A2
        )
        previous = noise_events[2]
        self.assertEqual(hold.note, "noise hold")
        self.assertEqual(hold.frequency, previous.frequency)
        self.assertEqual(hold.duration_frames, 12)
        self.assertTrue(
            all(
                decoded.frames[frame][3].volume == 0
                for frame in range(
                    hold.start_frame,
                    hold.start_frame + hold.duration_frames,
                )
            )
        )

    def test_invalid_inputs_are_rejected(self) -> None:
        with self.assertRaisesRegex(SynthError, "128 KiB"):
            decode_track(self.document, b"", 0, 0)
        with self.assertRaisesRegex(SynthError, "positive"):
            decode_track(self.document, self.prg, 0, 0, max_frames=0)


if __name__ == "__main__":
    unittest.main()
