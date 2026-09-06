from __future__ import annotations

import importlib.util
from pathlib import Path
from unittest import mock
import unittest


ROOT = Path(__file__).resolve().parent.parent
SPEC = importlib.util.spec_from_file_location(
    "release_contract", ROOT / "scripts" / "release_contract.py"
)
assert SPEC is not None and SPEC.loader is not None
CONTRACT = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(CONTRACT)


class EvidenceTests(unittest.TestCase):
    def test_accepts_existing_concrete_evidence(self) -> None:
        errors = CONTRACT.validate_evidence(
            ROOT,
            {
                "targets": ["verify"],
                "files": ["README.md"],
                "scenarios": ["boot-title"],
                "artifacts": ["rom"],
            },
            {"verify"},
            {"boot-title"},
            {"rom"},
            "fixture",
        )
        self.assertEqual(errors, [])

    def test_rejects_abstract_evidence(self) -> None:
        self.assertTrue(
            CONTRACT.validate_evidence(ROOT, {}, set(), set(), set(), "fixture")
        )


class CommitMessageTests(unittest.TestCase):
    def test_accepts_two_paragraph_message_and_trailer(self) -> None:
        body = (
            "Describe the concrete change.\n\n"
            "Explain the evidence and completed checks.\n\n"
            f"{CONTRACT.CODEX_TRAILER}\n"
        )
        record = f"{'a' * 40}\x00{'b' * 40}\x00Pin release tools\x00{body}\x1e"
        with mock.patch.object(CONTRACT, "git_output", return_value=record):
            self.assertEqual(CONTRACT.commit_message_issues(ROOT, "base"), [])

    def test_rejects_one_line_message(self) -> None:
        record = f"{'a' * 40}\x00{'b' * 40}\x00Old message\x00\x1e"
        with mock.patch.object(CONTRACT, "git_output", return_value=record):
            issues = CONTRACT.commit_message_issues(ROOT, "base")
        self.assertEqual(len(issues), 2)


class TagStateTests(unittest.TestCase):
    def test_pre_tag_rejects_existing_local_tag(self) -> None:
        with mock.patch.object(CONTRACT, "git_output", return_value="release"):
            errors = CONTRACT.validate_tag_state(
                ROOT, "source-reconstruction-1.0", "pre-tag", False
            )
        self.assertTrue(any("already exists" in error for error in errors))
if __name__ == "__main__":
    unittest.main()
