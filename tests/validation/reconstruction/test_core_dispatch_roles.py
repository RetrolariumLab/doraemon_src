from __future__ import annotations

import copy
import importlib.util
from pathlib import Path
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
SPEC = importlib.util.spec_from_file_location(
    "core_dispatch_roles", ROOT / "scripts" / "validation" / "reconstruction" / "core_dispatch_roles.py"
)
assert SPEC is not None and SPEC.loader is not None
ROLES = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(ROLES)


class CoreDispatchRoleTests(unittest.TestCase):
    def fixture(self) -> tuple[dict[str, object], ...]:
        roles = {
            "schema_version": 1,
            "domains": [{
                "name": "streaming",
                "bank": 1,
                "source": "world2_streaming",
                "tables": ["services"],
                "targets": [{
                    "address": "0x9000",
                    "symbol": "World2_Service",
                    "role": "test service",
                }],
            }],
        }
        streaming = {
            "schema_version": 1,
            "dispatch_tables": [{"name": "services", "targets": ["0x9000"]}],
        }
        objects = {"schema_version": 1, "tables": []}
        symbols = {
            "schema_version": 1,
            "symbols": [{"bank": 1, "address": "0x9000", "name": "World2_Service"}],
        }
        return roles, streaming, objects, symbols

    def test_accepts_complete_semantic_domain(self) -> None:
        errors, report = ROLES.validate(*self.fixture())
        self.assertEqual(errors, [])
        self.assertEqual(report["target_count"], 1)

    def test_rejects_dispatch_target_without_role(self) -> None:
        roles, streaming, objects, symbols = self.fixture()
        changed = copy.deepcopy(streaming)
        changed["dispatch_tables"][0]["targets"].append("0x9010")
        errors, _report = ROLES.validate(roles, changed, objects, symbols)
        self.assertTrue(any("differ from dispatch" in error for error in errors))

    def test_rejects_missing_semantic_symbol(self) -> None:
        roles, streaming, objects, symbols = self.fixture()
        symbols["symbols"] = []
        errors, _report = ROLES.validate(roles, streaming, objects, symbols)
        self.assertTrue(any("symbol missing" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
