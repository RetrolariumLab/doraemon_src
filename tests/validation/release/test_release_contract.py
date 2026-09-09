from __future__ import annotations

import importlib.util
from pathlib import Path
import subprocess
import tempfile
from unittest import mock
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
SPEC = importlib.util.spec_from_file_location(
    "release_contract", ROOT / "scripts" / "validation" / "release" / "release_contract.py"
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
    def test_uses_the_requested_release_history_endpoint(self) -> None:
        with mock.patch.object(CONTRACT, "git_output", return_value="") as output:
            CONTRACT.commit_message_issues(ROOT, "base", "release-commit")
        self.assertEqual(
            output.call_args.args[-1],
            "base..release-commit",
        )

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


class CommitIntegrityTests(unittest.TestCase):
    def git(self, root: Path, *arguments: str) -> str:
        return subprocess.run(
            ["git", *arguments],
            cwd=root,
            check=True,
            capture_output=True,
            text=True,
            encoding="utf-8",
        ).stdout.strip()

    def initialize_repository(self, root: Path) -> str:
        self.git(root, "init", "--quiet")
        self.git(root, "config", "user.name", "Release Owner")
        self.git(root, "config", "user.email", "owner@example.com")
        self.git(root, "config", "core.autocrlf", "false")
        (root / "fixture.txt").write_text("base\n", encoding="utf-8")
        self.git(root, "add", "fixture.txt")
        self.git(root, "commit", "--quiet", "-m", "Create fixture base")
        return self.git(root, "rev-parse", "HEAD")

    def test_rejects_an_empty_release_commit(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            base = self.initialize_repository(root)
            self.git(
                root, "commit", "--quiet", "--allow-empty", "-m", "Empty marker"
            )
            issues = CONTRACT.commit_integrity_issues(
                root,
                base,
                allowed_identities={"Release Owner <owner@example.com>"},
            )
        self.assertTrue(any("empty commit" in issue for issue in issues))

    def test_returns_a_blob_removed_later_in_the_range(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            base = self.initialize_repository(root)
            (root / "temporary.md").write_text(
                "temporary evidence\n", encoding="utf-8"
            )
            expected_content = (root / "temporary.md").read_bytes()
            self.git(root, "add", "temporary.md")
            self.git(root, "commit", "--quiet", "-m", "Add temporary evidence")
            expected = self.git(root, "rev-parse", "HEAD:temporary.md")
            self.git(root, "rm", "--quiet", "temporary.md")
            self.git(root, "commit", "--quiet", "-m", "Remove temporary evidence")
            blobs = CONTRACT.introduced_blobs(root, base)
        self.assertIn((expected, "temporary.md", expected_content), blobs)


class TagStateTests(unittest.TestCase):
    def test_pre_tag_rejects_existing_local_tag(self) -> None:
        with mock.patch.object(CONTRACT, "git_output", return_value="release"):
            errors = CONTRACT.validate_tag_state(
                ROOT, "source-reconstruction-1.0", "pre-tag", False
            )
        self.assertTrue(any("already exists" in error for error in errors))
if __name__ == "__main__":
    unittest.main()
