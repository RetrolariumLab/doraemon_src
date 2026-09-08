from __future__ import annotations

import json
from pathlib import Path
import sys
import tempfile
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))

from scripts.authoring.sound_preview import (
    preview_command,
    preview_environment,
    preview_rom,
    selected_track,
)


class SoundPreviewTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.document = json.loads(
            (ROOT / "data/audio/music_streams.json").read_text(encoding="utf-8")
        )

    def test_every_header_selects_its_native_bank_and_track(self) -> None:
        for driver_index, driver in enumerate(self.document["drivers"]):
            for header_index, header in enumerate(driver["headers"]):
                track = selected_track(
                    self.document, driver_index, header_index
                )
                self.assertEqual(track.bank, int(driver["bank"]))
                self.assertEqual(track.track_id, int(header["track_id"]))
                environment = preview_environment(track)
                self.assertEqual(
                    environment["DORAEMON_SOUND_PREVIEW_BANK"], str(track.bank)
                )
                self.assertEqual(
                    environment["DORAEMON_SOUND_PREVIEW_TRACK"],
                    str(track.track_id),
                )

    def test_preview_uses_profile_scoped_composed_rom(self) -> None:
        self.assertEqual(
            preview_rom(ROOT, "rev_a"),
            ROOT / "build/content/rev_a/doraemon-sound-preview.nes",
        )
        with self.assertRaisesRegex(ValueError, "unsupported"):
            preview_rom(ROOT, "translation",)

    def test_make_preview_uses_the_selected_revision_as_its_base(self) -> None:
        makefile = (ROOT / "mk/authoring.mk").read_text(encoding="utf-8")
        self.assertIn('$(MAKE) build-revision PROFILE="$(PROFILE)"', makefile)
        self.assertIn('--base-rom "$(REVISION_ROM)"', makefile)
        start = makefile.index("sound-preview-rom:")
        end = makefile.index("\ncheck-sound-preview:", start)
        preview_rule = makefile[start:end]
        self.assertNotIn("build/revisions/original/doraemon.nes", preview_rule)

    def test_command_requires_emulator_lua_and_built_rom(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            fceux, lua, rom = (
                root / "fceux.exe",
                root / "preview.lua",
                root / "preview.nes",
            )
            for path in (fceux, lua, rom):
                path.write_bytes(b"fixture")
            self.assertEqual(
                preview_command(fceux, lua, rom),
                [
                    str(fceux.resolve()),
                    "-lua",
                    str(lua.resolve()),
                    str(rom.resolve()),
                ],
            )
            rom.unlink()
            with self.assertRaisesRegex(ValueError, "missing"):
                preview_command(fceux, lua, rom)


if __name__ == "__main__":
    unittest.main()
