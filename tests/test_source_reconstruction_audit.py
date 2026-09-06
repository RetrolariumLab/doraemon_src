from __future__ import annotations

import importlib.util
import json
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest import mock


ROOT = Path(__file__).resolve().parent.parent
SPEC = importlib.util.spec_from_file_location(
    "source_reconstruction_audit",
    ROOT / "scripts" / "source_reconstruction_audit.py",
)
assert SPEC is not None and SPEC.loader is not None
AUDIT = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(AUDIT)


class MilestoneTests(unittest.TestCase):
    def milestones(self, states: list[str]) -> list[dict[str, object]]:
        return [
            {"id": identifier, "status": state, "evidence": []}
            for identifier, state in zip(AUDIT.EXPECTED_MILESTONES, states, strict=True)
        ]

    def test_accepts_independent_partial_milestones(self) -> None:
        states = ["complete", "partial", "complete"] + ["planned"] * 9
        self.assertEqual(AUDIT.validate_milestones(self.milestones(states), "development"), [])

    def test_accepts_complete_technical_milestones_during_contract_work(self) -> None:
        states = ["complete"] * len(AUDIT.EXPECTED_MILESTONES)
        self.assertEqual(
            AUDIT.validate_milestones(self.milestones(states), "development"), []
        )

    def test_tag_ready_requires_every_milestone(self) -> None:
        states = ["complete"] * (len(AUDIT.EXPECTED_MILESTONES) - 1) + [
            "partial"
        ]
        self.assertTrue(AUDIT.validate_milestones(self.milestones(states), "tag-ready"))


class ContractHelpersTests(unittest.TestCase):
    def contract_shape(self) -> dict[str, object]:
        return {
            "target_rom": {
                "title": "Doraemon (Japan, original revision)",
                "profile": "PRG0",
                "payload_crc32": "BDE3AE9B",
                "prg_crc32": "B00ABE1C",
                "chr_crc32": "761F994E",
                "multiple_revisions_required": False,
                "regional_profiles_required": False,
            },
            "source_contract": {
                "module_manifest": "config/source_modules.json",
                "runtime_state_coverage_manifest": (
                    "config/runtime_state_coverage.json"
                ),
                "classification_manifest": "config/source_classification.json",
                "maximum_module_lines": 700,
                "executable_incbin": False,
                "physical_bank_names_are_boundaries_not_semantics": True,
                "required_semantic_areas": [
                    "common",
                    "world1",
                    "world2",
                    "world3",
                    "audio",
                    "data",
                ],
            },
            "runtime_contract": {
                "required_scenarios": [
                    "boot-title",
                    "world1-city",
                    "world1-underground",
                    "world2-cave",
                    "world2-terminal-screen",
                    "world3-underwater",
                    "chapter-transition",
                    "ending-credits",
                ],
            },
            "authoring_contract": {
                "coverage_manifest": "config/authoring_coverage.json",
                "lossless_roundtrip_required_for_primary_formats": True,
                "required_primary_families": [
                    "world-maps-and-metatiles",
                    "gameplay-objects-and-collisions",
                    "chapter-metasprites-and-palettes",
                    "title-hud-and-dialogue",
                    "audio-command-streams",
                ],
                "secondary_fixed_tables_policy": (
                    "typed-source-or-registered-unknown"
                ),
                "exhaustive_visual_editors_required": False,
            },
            "deferred_to_source_2_0": [
                "relocation-build",
                "revision-a",
                "translations-and-regional-profiles",
                "exhaustive-secondary-graphics-and-text-editors",
            ],
        }

    def test_accepts_original_prg0_only_scope(self) -> None:
        self.assertEqual(
            AUDIT.validate_contract_shape(self.contract_shape()), []
        )

    def test_rejects_multirevision_scope_drift(self) -> None:
        contract = self.contract_shape()
        contract["target_rom"]["multiple_revisions_required"] = True
        errors = AUDIT.validate_contract_shape(contract)
        self.assertTrue(any("target ROM scope differs" in error for error in errors))

    def test_extracts_real_targets_but_not_variables(self) -> None:
        text = (
            "verify validate-verify: build\n"
            "VALUE := no\n"
            "source-audit: verify\n"
        )
        self.assertEqual(
            AUDIT.make_targets(text),
            {"verify", "validate-verify", "source-audit"},
        )

    def test_rejects_path_outside_project(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            self.assertIsNone(AUDIT.safe_project_path(root, "../outside.txt"))

    def test_accepts_path_inside_project(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            expected = (root / "docs" / "status.md").resolve()
            self.assertEqual(
                AUDIT.safe_project_path(root, "docs/status.md"), expected
            )

    def test_accepts_clean_release_worktree(self) -> None:
        with mock.patch.object(AUDIT, "git_output", return_value=""):
            self.assertEqual(AUDIT.validate_clean_worktree(ROOT), [])

    def test_rejects_changed_release_worktree(self) -> None:
        with mock.patch.object(
            AUDIT,
            "git_output",
            return_value=" M README.md\n?? release-note.txt",
        ):
            self.assertEqual(
                AUDIT.validate_clean_worktree(ROOT),
                ["release worktree is not clean (2 changed paths)"],
            )

    def test_accepts_preservation_commit_behind_promoted_main(self) -> None:
        commit = "4" * 40
        with mock.patch.object(
            AUDIT, "git_output", side_effect=[commit, ""]
        ) as git_output:
            self.assertEqual(
                AUDIT.validate_preservation_baseline(
                    ROOT,
                    {
                        "commit": commit,
                        "reachability": "ancestor-of-release",
                    },
                ),
                [],
            )
        self.assertEqual(
            git_output.call_args_list[1].args[1:],
            ("merge-base", "--is-ancestor", commit, "HEAD"),
        )

    def test_rejects_detached_preservation_history(self) -> None:
        commit = "4" * 40
        with mock.patch.object(
            AUDIT,
            "git_output",
            side_effect=[commit, subprocess.CalledProcessError(1, ["git"])],
        ):
            errors = AUDIT.validate_preservation_baseline(
                ROOT,
                {
                    "commit": commit,
                    "reachability": "ancestor-of-release",
                },
            )
        self.assertEqual(
            errors,
            ["preservation baseline is not an ancestor of the release"],
        )

    def test_rejects_semantic_module_over_line_limit(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "config").mkdir()
            (root / "src" / "audio").mkdir(parents=True)
            (root / "src" / "audio" / "large.asm").write_text(
                "line\n" * 4, encoding="utf-8"
            )
            (root / "config" / "modules.json").write_text(
                json.dumps(
                    {
                        "schema_version": 1,
                        "modules": [{"path": "audio/large.asm"}],
                    }
                ),
                encoding="utf-8",
            )
            errors = AUDIT.validate_semantic_modules(
                root,
                {
                    "source_root": "src",
                    "module_manifest": "config/modules.json",
                    "maximum_module_lines": 3,
                },
            )
        self.assertTrue(any("exceeds 3 lines" in error for error in errors))

    def test_accepts_development_runtime_prefix(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            path = root / "runtime.json"
            path.write_text(
                json.dumps(
                    {
                        "schema_version": 1,
                        "status": "development",
                        "scenarios": [{"id": "boot-title"}],
                    }
                ),
                encoding="utf-8",
            )
            contract = {
                "scenario_manifest": "runtime.json",
                "required_scenarios": ["boot-title", "world1-city"],
            }
            self.assertEqual(
                AUDIT.validate_runtime_manifest(root, contract, "development"), []
            )

    def test_accepts_independently_completed_runtime_scenario(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "runtime.json").write_text(
                json.dumps(
                    {
                        "schema_version": 1,
                        "status": "development",
                        "scenarios": [{"id": "world1-city"}],
                    }
                ),
                encoding="utf-8",
            )
            contract = {
                "scenario_manifest": "runtime.json",
                "required_scenarios": ["boot-title", "world1-city"],
            }
            self.assertEqual(
                AUDIT.validate_runtime_manifest(root, contract, "development"), []
            )

    def test_rejects_runtime_scenario_outside_contract(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "runtime.json").write_text(
                json.dumps(
                    {
                        "schema_version": 1,
                        "status": "development",
                        "scenarios": [{"id": "unknown"}],
                    }
                ),
                encoding="utf-8",
            )
            contract = {
                "scenario_manifest": "runtime.json",
                "required_scenarios": ["boot-title", "world1-city"],
            }
            self.assertTrue(
                AUDIT.validate_runtime_manifest(root, contract, "development")
            )


if __name__ == "__main__":
    unittest.main()
