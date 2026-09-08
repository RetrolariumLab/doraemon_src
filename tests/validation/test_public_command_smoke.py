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


if __name__ == "__main__":
    unittest.main()
