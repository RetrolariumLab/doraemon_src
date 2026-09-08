from __future__ import annotations

import copy
import importlib.util
from pathlib import Path
import tempfile
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
SPEC = importlib.util.spec_from_file_location(
    "authoring_coverage",
    ROOT / "scripts" / "validation" / "release" / "authoring_coverage.py",
)
assert SPEC is not None and SPEC.loader is not None
AUDIT = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(AUDIT)


class AuthoringCoverageTests(unittest.TestCase):
    def component(self, identifier: str) -> dict[str, object]:
        return {
            "id": identifier,
            "status": "complete",
            "lossless_roundtrip": True,
            "authoring_files": AUDIT.EXPECTED_AUTHORING_FILES[identifier],
            "contract_files": ["config/example.json"],
            "documentation_files": ["docs/example.md"],
            "test_files": ["tests/test_example.py"],
            "validation_targets": AUDIT.EXPECTED_VALIDATION_TARGETS[identifier],
        }

    def document(self) -> dict[str, object]:
        return {
            "schema_version": 1,
            "status": "complete",
            "secondary_fixed_tables_policy": "typed-source-or-registered-unknown",
            "families": [
                {
                    "id": family,
                    "status": "complete",
                    "components": [
                        self.component(component)
                        for component in components
                    ],
                }
                for family, components in AUDIT.EXPECTED_COMPONENTS.items()
            ],
        }

    def test_accepts_exact_complete_primary_inventory(self) -> None:
        document = self.document()
        errors = AUDIT.validate_shape(
            document,
            list(AUDIT.EXPECTED_COMPONENTS),
            "typed-source-or-registered-unknown",
        )
        self.assertEqual(errors, [])

    def test_rejects_missing_chapter_component(self) -> None:
        document = self.document()
        document["families"][0]["components"].pop()
        errors = AUDIT.validate_shape(
            document,
            list(AUDIT.EXPECTED_COMPONENTS),
            "typed-source-or-registered-unknown",
        )
        self.assertTrue(any("component inventory differs" in error for error in errors))

    def test_rejects_incomplete_component(self) -> None:
        document = self.document()
        document["families"][1]["components"][0]["status"] = "partial"
        errors = AUDIT.validate_shape(
            document,
            list(AUDIT.EXPECTED_COMPONENTS),
            "typed-source-or-registered-unknown",
        )
        self.assertTrue(any("component is incomplete" in error for error in errors))

    def test_rejects_non_lossless_component(self) -> None:
        document = self.document()
        document["families"][2]["components"][0]["lossless_roundtrip"] = False
        errors = AUDIT.validate_shape(
            document,
            list(AUDIT.EXPECTED_COMPONENTS),
            "typed-source-or-registered-unknown",
        )
        self.assertTrue(any("lacks lossless round trip" in error for error in errors))

    def test_rejects_substituted_authoring_or_validator(self) -> None:
        document = self.document()
        component = document["families"][0]["components"][0]
        component["authoring_files"] = ["data/unrelated.json"]
        component["validation_targets"] = ["validate-unrelated"]
        errors = AUDIT.validate_shape(
            document,
            list(AUDIT.EXPECTED_COMPONENTS),
            "typed-source-or-registered-unknown",
        )
        self.assertTrue(any("authoring inventory differs" in error for error in errors))
        self.assertTrue(any("validator inventory differs" in error for error in errors))

    def test_extracts_multiple_make_targets_and_continued_dependencies(self) -> None:
        makefile = (
            "example validate-example: input\n"
            "release-check: first \\\n"
            "\tvalidate-example second\n"
            "VALUE := ignored\n"
        )
        self.assertEqual(
            AUDIT.make_targets(makefile),
            {"example", "validate-example", "release-check"},
        )
        self.assertEqual(
            AUDIT.make_rule_dependencies(makefile, "release-check"),
            {"first", "validate-example", "second"},
        )

    def test_reads_literal_makefile_fragments(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            fragments = root / "mk"
            fragments.mkdir()
            (root / "Makefile").write_text(
                "include mk/validation.mk\nroot-target:\n", encoding="utf-8"
            )
            (fragments / "validation.mk").write_text(
                "fragment-target:\n", encoding="utf-8"
            )
            text = AUDIT.read_make_interface(root / "Makefile")
            self.assertEqual(
                AUDIT.make_targets(text), {"root-target", "fragment-target"}
            )

    def test_evidence_must_exist_and_validator_must_be_release_gated(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for relative in (
                "data/example.json",
                "config/example.json",
                "docs/example.md",
                "tests/test_example.py",
            ):
                path = root / relative
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text("evidence\n", encoding="utf-8")
            evidence_component = {
                "id": "example",
                "status": "complete",
                "lossless_roundtrip": True,
                "authoring_files": ["data/example.json"],
                "contract_files": ["config/example.json"],
                "documentation_files": ["docs/example.md"],
                "test_files": ["tests/test_example.py"],
                "validation_targets": ["validate-example"],
            }
            document = {
                "families": [
                    {
                        "components": [evidence_component],
                    }
                ]
            }
            makefile = "example validate-example:\nrelease-check: validate-example\n"
            self.assertEqual(
                AUDIT.validate_evidence(root, document, makefile), []
            )
            changed = copy.deepcopy(document)
            changed["families"][0]["components"][0]["validation_targets"] = [
                "validate-unreleased"
            ]
            errors = AUDIT.validate_evidence(
                root,
                changed,
                "validate-unreleased:\nrelease-check: validate-example\n",
            )
        self.assertTrue(any("outside release-check" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
