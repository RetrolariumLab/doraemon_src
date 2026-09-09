from __future__ import annotations

import unittest

from scripts.validation import public_command_smoke
from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT


class PublicCommandSmokeTests(unittest.TestCase):
    def test_real_lint_target_passes_in_disposable_clone(self) -> None:
        output = public_command_smoke.run_disposable_make(ROOT, "lint")
        self.assertIn(
            "project structure, GNROM source contract, and binary policy",
            output,
        )

    def test_rejects_internal_target_before_cloning(self) -> None:
        with self.assertRaisesRegex(
            public_command_smoke.PublicCommandSmokeError,
            "not public",
        ):
            public_command_smoke.run_disposable_make(ROOT, "internal-fixture")

    def test_source_2_command_runs_the_predecessor_first(self) -> None:
        result = public_command_smoke.run_controlled_source_2_check(ROOT)
        self.assertEqual(result.returncode, 0, result.output)
        self.assertEqual(
            result.calls,
            public_command_smoke.SOURCE_2_CHECK_SEQUENCE,
        )

    def test_source_2_command_propagates_subgate_failure(self) -> None:
        result = public_command_smoke.run_controlled_source_2_check(
            ROOT,
            fail_target="audit-revisions",
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(result.calls, ("source-1-check", "audit-revisions"))


if __name__ == "__main__":
    unittest.main()
