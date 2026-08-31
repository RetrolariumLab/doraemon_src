from __future__ import annotations

import importlib.util
import json
from pathlib import Path
import tempfile
import unittest


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

    def test_accepts_completed_prefix_and_one_active_milestone(self) -> None:
        states = ["complete", "complete", "in-progress"] + ["planned"] * 9
        self.assertEqual(AUDIT.validate_milestones(self.milestones(states), "development"), [])

    def test_rejects_completion_after_open_milestone(self) -> None:
        states = ["complete", "in-progress", "complete"] + ["planned"] * 9
        self.assertTrue(AUDIT.validate_milestones(self.milestones(states), "development"))

    def test_tag_ready_requires_every_milestone(self) -> None:
        states = ["complete"] * 11 + ["in-progress"]
        self.assertTrue(AUDIT.validate_milestones(self.milestones(states), "tag-ready"))


class ContractHelpersTests(unittest.TestCase):
    def test_extracts_real_targets_but_not_variables(self) -> None:
        text = "verify: build\nVALUE := no\nsource-audit: verify\n"
        self.assertEqual(AUDIT.make_targets(text), {"verify", "source-audit"})

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
