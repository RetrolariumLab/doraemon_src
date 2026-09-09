from __future__ import annotations

from pathlib import Path
import tempfile
import unittest

from scripts.validation import format_project


class FormattingTests(unittest.TestCase):
    def test_normalizes_line_endings_and_trailing_space(self) -> None:
        self.assertEqual(
            format_project.normalize_text("one  \r\ntwo\t \r\n"),
            "one\ntwo\n",
        )

    def test_exclusions_are_relative_to_the_repository(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory) / "build" / "checkout"
            included = (
                root / "scripts" / "build" / "project.py",
                root / "tests" / "build" / "test_project.py",
            )
            excluded = (
                root / "build" / "generated.py",
                root / "assets" / "generated" / "asset.py",
                root / "content" / "workspace" / "draft.py",
                root / "references" / "research.py",
                root / "tools" / "ghidra" / "support.py",
                root / "package" / "__pycache__" / "cached.py",
            )
            for path in (*included, *excluded):
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text("value = 1\n", encoding="utf-8")

            found = set(format_project.project_files(root))

        self.assertEqual(found, set(included))
