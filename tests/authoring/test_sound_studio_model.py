from __future__ import annotations

import copy
from pathlib import Path
import tempfile
import unittest

from scripts.authoring.sound_studio_model import (
    SoundWorkspace,
    edit_event,
    music_writes,
    swap_request_slots,
)


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT


class SoundStudioModelTests(unittest.TestCase):
    def document(self):
        return SoundWorkspace(ROOT, ROOT / "content/workspace", "original").load_canonical()

    def test_canonical_music_geometry_is_fixed(self) -> None:
        document = self.document()
        self.assertEqual(document.encoded_size, 10224)
        self.assertEqual(len(document.document["drivers"]), 4)
        self.assertEqual(sum(driver["track_count"] for driver in document.document["drivers"]), 26)
        self.assertEqual(len(music_writes(document.document)), 9)

    def test_note_edit_is_atomic_and_undoable(self) -> None:
        document = self.document()
        before = copy.deepcopy(document.document)
        events = document.document["drivers"][0]["segments"][0]["events"]
        index = next(index for index, value in enumerate(events) if value.startswith("event "))
        self.assertTrue(document.change(lambda data: edit_event(data, 0, 0, index, "event $01")))
        self.assertTrue(document.undo())
        self.assertEqual(document.document, before)

    def test_command_width_and_control_flow_are_protected(self) -> None:
        document = self.document()
        events = document.document["drivers"][0]["segments"][0]["events"]
        call = next(index for index, value in enumerate(events) if value.startswith("CallStream"))
        with self.assertRaisesRegex(ValueError, "control-flow event is locked"):
            document.change(lambda data: edit_event(data, 0, 0, call, "CallStream $00 $80"))
        envelope = next(index for index, value in enumerate(events) if value.startswith("SetEnvelopeVolume"))
        self.assertTrue(document.change(lambda data: edit_event(data, 0, 0, envelope, "SetEnvelopeVolume $0F")))

    def test_workspace_initialization_preserves_existing_file(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            workspace = SoundWorkspace(ROOT, Path(temporary), "rev_a")
            self.assertIsNotNone(workspace.initialize())
            workspace.path.write_text('{"local": true}\n', encoding="utf-8")
            self.assertIsNone(workspace.initialize())
            self.assertEqual(workspace.path.read_text(encoding="utf-8"), '{"local": true}\n')

    def test_effect_slots_are_a_fixed_permutation(self) -> None:
        document = SoundWorkspace(
            ROOT, ROOT / "content/workspace", "original"
        ).load_canonical_priorities()
        before = copy.deepcopy(document.document)
        self.assertEqual(document.encoded_size, 93)
        self.assertTrue(
            document.change(lambda data: swap_request_slots(data, 0, 1, 2))
        )
        self.assertTrue(document.undo())
        self.assertEqual(document.document, before)
        with self.assertRaisesRegex(ValueError, "complete permutation"):
            document.change(lambda data: data["drivers"][0]["slots"].__setitem__(1, 0))


if __name__ == "__main__":
    unittest.main()
