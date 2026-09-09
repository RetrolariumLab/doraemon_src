from __future__ import annotations

import importlib.util
import json
from pathlib import Path
import tempfile
from unittest import mock
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
SPEC = importlib.util.spec_from_file_location(
    "source_2_audit", ROOT / "scripts" / "validation" / "release" / "source_2_audit.py"
)
assert SPEC is not None and SPEC.loader is not None
AUDIT = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(AUDIT)


class TargetTests(unittest.TestCase):
    def test_extracts_make_target_from_parameterized_command(self) -> None:
        self.assertEqual(
            AUDIT.target_name("build-revision PROFILE=rev_a"),
            "build-revision",
        )

    def test_rejects_non_string_command(self) -> None:
        self.assertEqual(AUDIT.target_name(None), "")


class ManifestIdentityTests(unittest.TestCase):
    def setUp(self) -> None:
        self.release = json.loads(
            (ROOT / "config/source_reconstruction_2_0.json").read_text(
                encoding="utf-8"
            )
        )

    def test_accepts_project_manifest_identity(self) -> None:
        self.assertEqual(
            AUDIT.validate_manifest_identity(self.release),
            [],
        )

    def test_rejects_a_changed_project_schema(self) -> None:
        self.release["schema_version"] = 0
        self.assertEqual(
            AUDIT.validate_manifest_identity(self.release),
            ["Source 2.0 project manifest schema differs"],
        )


class RevisionContractTests(unittest.TestCase):
    def setUp(self) -> None:
        release = json.loads(
            (ROOT / "config/source_reconstruction_2_0.json").read_text(
                encoding="utf-8"
            )
        )
        self.artifacts = {item["id"]: item for item in release["artifacts"]}
        self.revisions = json.loads(
            (ROOT / "config/revision_profiles.json").read_text(
                encoding="utf-8"
            )
        )

    def test_accepts_two_code_only_revision_profiles(self) -> None:
        self.assertEqual(
            AUDIT.validate_revision_profiles(
                ROOT, self.revisions, self.artifacts
            ),
            [],
        )

    def test_rejects_unclassified_revision_bytes(self) -> None:
        self.revisions["comparison"]["windows"][0]["classification"] = "unknown"
        errors = AUDIT.validate_revision_profiles(
            ROOT, self.revisions, self.artifacts
        )
        self.assertTrue(any("not all classified" in error for error in errors))


class RepositoryPolicyTests(unittest.TestCase):
    def test_rejects_non_english_public_text(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "README.md").write_text(
                "English heading\n"
                "\u0420\u0443\u0441\u0441\u043a\u0438\u0439 "
                "\u0442\u0435\u043a\u0441\u0442\n",
                encoding="utf-8",
            )
            with mock.patch.object(AUDIT, "git_output", return_value="README.md"):
                errors = AUDIT.validate_public_english_text(root)
        self.assertEqual(len(errors), 1)
        self.assertIn("README.md:2", errors[0])

    def test_accepts_documented_japanese_name_with_english_context(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "README.md").write_text(
                "Doraemon (\u30c9\u30e9\u3048\u3082\u3093)\n",
                encoding="utf-8",
            )
            with mock.patch.object(AUDIT, "git_output", return_value="README.md"):
                errors = AUDIT.validate_public_english_text(root)
        self.assertEqual(errors, [])

    def test_rejects_unexplained_japanese_text(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "README.md").write_text(
                "\u30c9\u30e9\u3048\u3082\u3093\n", encoding="utf-8"
            )
            with mock.patch.object(AUDIT, "git_output", return_value="README.md"):
                errors = AUDIT.validate_public_english_text(root)
        self.assertEqual(len(errors), 1)
        self.assertIn("README.md:1", errors[0])

    def test_accepts_current_private_path_policy(self) -> None:
        self.assertEqual(AUDIT.validate_private_paths(ROOT), [])

    def test_rejects_a_tracked_rom(self) -> None:
        with mock.patch.object(
            AUDIT, "git_output", return_value="README.md\nprivate/game.nes"
        ):
            errors = AUDIT.validate_private_paths(ROOT)
        self.assertEqual(
            errors,
            ["private or generated path is tracked: private/game.nes"],
        )

    def test_rejects_cyrillic_in_a_removed_history_blob(self) -> None:
        blob = (
            "a" * 40,
            "removed.md",
            "\u0427\u0435\u0440\u043d\u043e\u0432\u0438\u043a\n".encode("utf-8"),
        )
        with mock.patch.object(
            AUDIT.release_contract, "introduced_blobs", return_value=[blob]
        ):
            errors = AUDIT.validate_release_history_text(ROOT, "base")
        self.assertEqual(len(errors), 1)
        self.assertIn("contains Cyrillic text", errors[0])


if __name__ == "__main__":
    unittest.main()
