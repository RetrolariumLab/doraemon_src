from __future__ import annotations

import json
from pathlib import Path
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT


class Source2ContractTests(unittest.TestCase):
    def load(self, relative: str) -> dict[str, object]:
        return json.loads((ROOT / relative).read_text(encoding="utf-8"))

    def test_release_identity_and_predecessor_are_fixed(self) -> None:
        document = self.load("config/source_reconstruction_2_0.json")
        self.assertEqual(
            (document["schema_version"], document["release_line"]),
            (1, "2.0"),
        )
        self.assertNotIn("contract", document)
        self.assertEqual(document["release"]["version"], "2.0")
        self.assertEqual(document["tag"], "source-reconstruction-2.0")
        self.assertEqual(document["status"], "tag-ready")
        self.assertEqual(
            document["predecessor"]["commit"],
            "a992b208ec3ab03b3e4c5100bc83b932e7defcd6",
        )

    def test_profile_and_artifact_matrices_agree(self) -> None:
        release = self.load("config/source_reconstruction_2_0.json")
        revisions = self.load("config/revision_profiles.json")
        authoring = self.load("config/authoring/content_authoring_profiles.json")
        revision_profiles = {item["id"]: item for item in revisions["profiles"]}
        authoring_profiles = {item["id"]: item for item in authoring["profiles"]}
        release_profiles = {item["id"]: item for item in release["profiles"]}
        artifacts = {item["profile"]: item for item in release["artifacts"]}
        expected = {"original", "rev_a"}
        self.assertEqual(set(revision_profiles), expected)
        self.assertEqual(set(authoring_profiles), expected)
        self.assertEqual(set(release_profiles), expected)
        self.assertEqual(set(artifacts), expected)
        for profile_id in expected:
            revision = revision_profiles[profile_id]
            profile = authoring_profiles[profile_id]
            artifact = artifacts[profile_id]
            self.assertEqual(profile["revision_profile"], profile_id)
            self.assertEqual(profile["image_size"], revision["file_size"])
            self.assertEqual(profile["image_sha256"], revision["file_sha256"])
            self.assertEqual(artifact["size"], revision["file_size"])
            self.assertEqual(artifact["sha1"], revision["file_sha1"])
            self.assertEqual(artifact["sha256"], revision["file_sha256"])

    def test_studio_statuses_match_every_authoring_profile(self) -> None:
        studios = self.load("config/authoring/content_studios.json")
        profiles = self.load("config/authoring/content_authoring_profiles.json")
        studio_status = {item["id"]: item["status"] for item in studios["studios"]}
        self.assertEqual(set(profiles["studio_ids"]), set(studio_status))
        self.assertEqual(studio_status["level"], "supported")
        for profile in profiles["profiles"]:
            self.assertEqual(set(profile["studios"]), set(studio_status))
            self.assertEqual(profile["studios"], studio_status)

    def test_studios_declare_real_windows_interactions(self) -> None:
        studios = self.load("config/authoring/content_studios.json")
        interaction = studios["workstation_interaction"]
        self.assertEqual(interaction["target"], "check-studio-interactions")
        self.assertEqual(interaction["platform"], "windows")
        self.assertEqual(interaction["profile"], "original")
        actions = {
            item["id"]: item["workstation_actions"]
            for item in studios["studios"]
        }
        self.assertEqual(
            set(actions), {"level", "graphics", "objects", "text", "sound"}
        )
        for studio_id, declared in actions.items():
            self.assertIn("window", declared, studio_id)
            self.assertIn("save", declared, studio_id)
            self.assertIn("unsaved-close", declared, studio_id)
        self.assertIn("validate", actions["level"])
        self.assertIn("play", actions["sound"])
        for studio_id in ("graphics", "objects", "text", "sound"):
            self.assertIn("build", actions[studio_id])

    def test_each_release_phase_has_its_own_public_gate(self) -> None:
        document = self.load("config/source_reconstruction_2_0.json")
        self.assertEqual(
            document["aggregate_gates"],
            {
                "development": ["make source-2-check"],
                "pre_tag": ["make source-2-pre-tag-check"],
                "post_tag": ["make source-2-tag-check"],
            },
        )
        required = set(document["required_targets"])
        self.assertTrue(
            {
                "source-1-check",
                "source-2-check",
                "source-2-pre-tag-check",
                "source-2-tag-check",
            }.issubset(required)
        )
        self.assertTrue(
            {
                "source-2-release-audit",
                "source-2-post-tag-audit",
                "source-2-post-tag-remote-audit",
            }.isdisjoint(required)
        )


if __name__ == "__main__":
    unittest.main()
