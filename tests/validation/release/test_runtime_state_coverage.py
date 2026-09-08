from __future__ import annotations

import copy
import importlib.util
from pathlib import Path
import sys
import tempfile
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))
SPEC = importlib.util.spec_from_file_location(
    "runtime_state_coverage",
    ROOT / "scripts" / "validation" / "release" / "runtime_state_coverage.py",
)
assert SPEC is not None and SPEC.loader is not None
AUDIT = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(AUDIT)


class RuntimeStateCoverageTests(unittest.TestCase):
    def metrics(self) -> dict[str, object]:
        return {
            "object_pools": {
                "pool_count": 1,
                "field_count": 2,
                "slot_count": 3,
                "lifecycle_count": 4,
                "layout_count": 1,
                "unclassified_field_count": 0,
            },
            "semantic_routines": {
                "neutral_routine_labels": 0,
                "indirect_entries": 5,
                "semantic_indirect_entries": 5,
            },
            "ram_aliases": {
                "unique_symbols": 6,
                "shared_symbols": 2,
                "effective_by_bank": {},
            },
        }

    def document(self) -> dict[str, object]:
        return {
            "schema_version": 1,
            "status": "complete",
            "expected_metrics": self.metrics(),
            "components": [
                {
                    "id": identifier,
                    "status": "complete",
                    "contract_files": ["config/example.json"],
                    "documentation_files": ["docs/example.md"],
                    "validation_targets": targets,
                }
                for identifier, targets in AUDIT.EXPECTED_TARGETS.items()
            ],
        }

    def test_accepts_exact_complete_runtime_state_inventory(self) -> None:
        self.assertEqual(
            AUDIT.validate_shape(self.document(), self.metrics()), []
        )

    def test_rejects_changed_metrics(self) -> None:
        document = self.document()
        document["expected_metrics"]["object_pools"]["slot_count"] = 99
        self.assertTrue(AUDIT.validate_shape(document, self.metrics()))

    def test_rejects_missing_chapter_component(self) -> None:
        document = self.document()
        document["components"].pop()
        errors = AUDIT.validate_shape(document, self.metrics())
        self.assertTrue(any("component order" in error for error in errors))

    def test_rejects_substituted_validator(self) -> None:
        document = self.document()
        document["components"][1]["validation_targets"] = ["validate-unrelated"]
        errors = AUDIT.validate_shape(document, self.metrics())
        self.assertTrue(any("validator inventory differs" in error for error in errors))

    def test_evidence_and_validator_must_be_release_gated(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for relative in ("config/example.json", "docs/example.md"):
                path = root / relative
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text("evidence\n", encoding="utf-8")
            component = {
                "id": "example",
                "contract_files": ["config/example.json"],
                "documentation_files": ["docs/example.md"],
                "validation_targets": ["validate-example"],
            }
            document = {"components": [component]}
            makefile = "validate-example:\nrelease-check: validate-example\n"
            self.assertEqual(
                AUDIT.validate_evidence(root, document, makefile), []
            )
            changed = copy.deepcopy(document)
            changed["components"][0]["contract_files"] = ["config/missing.json"]
            errors = AUDIT.validate_evidence(root, changed, makefile)
        self.assertTrue(any("missing contract_files" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
