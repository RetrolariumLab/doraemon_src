from __future__ import annotations

import copy
import importlib.util
from pathlib import Path
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
SPEC = importlib.util.spec_from_file_location(
    "audio_effects", ROOT / "scripts" / "validation" / "audio" / "audio_effects.py"
)
assert SPEC is not None and SPEC.loader is not None
AUDIO = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(AUDIO)


class AudioEffectTests(unittest.TestCase):
    def fixture(self) -> tuple[dict[str, object], ...]:
        catalog = {
            "schema_version": 1,
            "channels": ["pulse-1", "pulse-2", "triangle", "noise"],
            "roles": [
                {
                    "id": "one",
                    "init_handler": "InitOne",
                    "update_handler": "UpdateShared",
                    "timer_leases": ["pulse-1"],
                    "apu_channels": ["pulse-1"],
                    "description": "first test role",
                },
                {
                    "id": "two",
                    "init_handler": "InitTwo",
                    "update_handler": "UpdateShared",
                    "timer_leases": ["pulse-2"],
                    "apu_channels": ["pulse-2"],
                    "description": "second test role",
                },
            ],
            "drivers": [{
                "name": "test",
                "bank": 1,
                "symbol_prefix": "Test_",
                "system_symbols": {},
                "helpers": {"Helper": "0x9030"},
                "request_roles": ["one", "two"],
            }],
        }
        dispatch = {
            "schema_version": 1,
            "name": "test",
            "bank": 1,
            "request_count": 2,
            "priority_table": {"values": ["0x04", "0x00"]},
            "dispatch_table": {
                "targets": ["0x9000", "0x9020", "0x9010", "0x9020"]
            },
        }
        symbols = {
            "schema_version": 1,
            "symbols": [
                {"bank": 1, "address": "0x9000", "name": "Test_AudioEffect_InitTwo"},
                {"bank": 1, "address": "0x9010", "name": "Test_AudioEffect_InitOne"},
                {"bank": 1, "address": "0x9020", "name": "Test_AudioEffect_UpdateShared"},
                {"bank": 1, "address": "0x9030", "name": "Test_AudioEffect_Helper"},
            ],
        }
        return catalog, dispatch, symbols

    def test_accepts_request_permutation_and_shared_handler(self) -> None:
        errors, report = AUDIO.validate(*self.fixture())
        self.assertEqual(errors, [])
        self.assertEqual(report["request_count"], 2)
        self.assertEqual(report["dispatch_handler_count"], 3)
        self.assertEqual(report["helper_count"], 1)

    def test_rejects_conflicting_roles_for_shared_target(self) -> None:
        catalog, dispatch, symbols = self.fixture()
        changed = copy.deepcopy(catalog)
        changed["roles"][1]["update_handler"] = "UpdateOther"
        errors, _report = AUDIO.validate(changed, dispatch, symbols)
        self.assertTrue(any("conflicting handler roles" in error for error in errors))

    def test_rejects_wrong_semantic_symbol(self) -> None:
        catalog, dispatch, symbols = self.fixture()
        changed = copy.deepcopy(symbols)
        changed["symbols"][0]["name"] = "Wrong"
        errors, _report = AUDIO.validate(catalog, dispatch, changed)
        self.assertTrue(any("expected semantic symbol" in error for error in errors))

    def test_rejects_incomplete_handler_pair_table(self) -> None:
        catalog, dispatch, symbols = self.fixture()
        changed = copy.deepcopy(dispatch)
        changed["dispatch_table"]["targets"].pop()
        errors, _report = AUDIO.validate(catalog, changed, symbols)
        self.assertTrue(any("table length differs" in error for error in errors))

    def test_synchronizes_only_missing_symbols(self) -> None:
        catalog, dispatch, symbols = self.fixture()
        expected_errors, expected, _report = AUDIO.expected_symbols(catalog, dispatch)
        self.assertEqual(expected_errors, [])
        changed = copy.deepcopy(symbols)
        changed["symbols"].pop()
        result, added = AUDIO.synchronize_symbols(changed, expected)
        self.assertEqual(added, 1)
        self.assertEqual(len(result["symbols"]), 4)
        self.assertEqual(result["symbols"][0]["address"], "0x9000")
        self.assertEqual(result["symbols"][-1]["address"], "0x9030")


if __name__ == "__main__":
    unittest.main()
