from __future__ import annotations

from pathlib import Path
import unittest

from scripts.authoring.sound_studio import effect_rows, envelope_locations, event_rows
from scripts.authoring.sound_studio_model import SoundWorkspace, load_json
from scripts.authoring.sound_track_catalog import (
    track_identity,
    validate_track_catalog,
)



from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT


class SoundStudioTests(unittest.TestCase):
    def setUp(self) -> None:
        self.workspace = SoundWorkspace(ROOT, ROOT / "content/workspace", "original")

    def test_event_rows_cover_each_segment_exactly(self) -> None:
        music = self.workspace.load_canonical()
        for driver_index, driver in enumerate(music.document["drivers"]):
            for segment_index, segment in enumerate(driver["segments"]):
                rows = event_rows(music.document, driver_index, segment_index)
                self.assertEqual(rows[0].address, int(segment["address"], 0))
                self.assertEqual(len(rows), len(segment["events"]))

    def test_envelope_browser_exposes_every_command(self) -> None:
        music = self.workspace.load_canonical()
        self.assertEqual(len(envelope_locations(music.document)), 202)

    def test_named_catalog_exposes_every_physical_track_header(self) -> None:
        music = self.workspace.load_canonical()
        identities = validate_track_catalog(music.document)
        self.assertEqual(len(identities), 26)
        self.assertEqual(
            track_identity("world1-audio", 2).title,
            "Underground - Main",
        )
        self.assertEqual(track_identity("world1-audio", 6).title, "Bull Robo Boss")
        self.assertEqual(track_identity("world2-audio", 4).title, "Stage Boss")
        self.assertEqual(
            track_identity("world3-audio", 3).title,
            "Mid-Boss Formation",
        )

    def test_effect_rows_follow_slot_permutation(self) -> None:
        priorities = self.workspace.load_canonical_priorities()
        effects = load_json(ROOT / "config/authoring/audio/audio_effects.json")
        rows = effect_rows(
            priorities.document,
            priorities.canonical,
            effects,
            0,
        )
        self.assertEqual(len(rows), 26)
        self.assertEqual(rows[0].routed_role, "reset")
        self.assertEqual(rows[1].routed_role, "pulse2_fixed_tone_c")


if __name__ == "__main__":
    unittest.main()
