from __future__ import annotations

import unittest

from scripts.build import make_help
from scripts.validation.release.makefile_interface import (
    make_targets,
    read_make_interface,
)
from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT


class MakeHelpTests(unittest.TestCase):
    def test_documents_existing_public_targets_without_duplicates(self) -> None:
        documented = make_help.documented_targets()
        entry_count = sum(len(entries) for _, entries in make_help.TARGET_GROUPS)
        available = make_targets(read_make_interface(ROOT / "Makefile"))
        self.assertEqual(len(documented), entry_count)
        self.assertLessEqual(documented, available)

    def test_includes_every_primary_public_workflow(self) -> None:
        documented = make_help.documented_targets()
        expected = {
            "help",
            "build",
            "verify",
            "level-studio",
            "graphics-studio",
            "object-studio",
            "text-studio",
            "sound-studio",
            "runtime-revision-matrix",
            "source-2-check",
            "source-2-pre-tag-check",
            "source-2-tag-check",
        }
        self.assertLessEqual(expected, documented)

    def test_rendering_exposes_categories_selectors_and_tool_catalog(self) -> None:
        rendered = make_help.render_help()
        for heading, _entries in make_help.TARGET_GROUPS:
            self.assertIn(f"{heading}:", rendered)
        self.assertIn("PROFILE=original|rev_a", rendered)
        self.assertIn("STUDIOS=all|level,graphics,objects,text,sound", rendered)
        self.assertIn("scripts/run.py --list", rendered)

    def test_retired_release_targets_do_not_reappear(self) -> None:
        rendered = make_help.render_help()
        for target in (
            "source-2-release-audit",
            "source-2-post-tag-audit",
            "source-2-post-tag-remote-audit",
        ):
            self.assertNotIn(target, rendered)


if __name__ == "__main__":
    unittest.main()
