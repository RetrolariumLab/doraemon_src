from __future__ import annotations

import copy
import hashlib
import importlib.util
from pathlib import Path
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
SPEC = importlib.util.spec_from_file_location(
    "common_runtime", ROOT / "scripts" / "validation" / "reconstruction" / "common_runtime.py"
)
assert SPEC is not None and SPEC.loader is not None
RUNTIME = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(RUNTIME)


class CommonRuntimeTests(unittest.TestCase):
    def fixture(self) -> tuple[bytes, dict[str, object], dict[str, object]]:
        bank = bytearray(RUNTIME.BANK_SIZE)
        bank[0x100:0x103] = b"\xEA\xEA\x60"
        bank[0x200:0x203] = b"\x4C\x00\x90"
        prg = bytes(bank) * 4
        manifest = {
            "schema_version": 1,
            "shared_range": {
                "address": "0x8100",
                "size": 3,
                "sha1": hashlib.sha1(b"\xEA\xEA\x60").hexdigest(),
            },
            "shared_services": [{
                "address": "0x8100",
                "size": 3,
                "sha1": hashlib.sha1(b"\xEA\xEA\x60").hexdigest(),
                "suffix": "Service",
            }],
            "bank_dispatches": [{
                "bank": 0,
                "entries": [{
                    "address": "0x8200",
                    "target": "0x9000",
                    "symbol": "World_Dispatch",
                    "target_symbol": "World_Service",
                }],
            }],
        }
        symbols = {
            "schema_version": 1,
            "symbols": [
                *[
                    {"bank": index, "address": "0x8100", "name": f"Bank{index}_Service"}
                    for index in range(4)
                ],
                {"bank": 0, "address": "0x8200", "name": "World_Dispatch"},
                {"bank": 0, "address": "0x9000", "name": "World_Service"},
            ],
        }
        return prg, manifest, symbols

    def test_accepts_copied_services_and_dispatch(self) -> None:
        errors, report = RUNTIME.validate(*self.fixture())
        self.assertEqual(errors, [])
        self.assertEqual(report["service_count"], 4)

    def test_rejects_changed_bank_copy(self) -> None:
        prg, manifest, symbols = self.fixture()
        changed = bytearray(prg)
        changed[RUNTIME.BANK_SIZE + 0x100] = 0x00
        errors, _report = RUNTIME.validate(bytes(changed), manifest, symbols)
        self.assertTrue(any("not identical" in error for error in errors))

    def test_rejects_missing_semantic_symbol(self) -> None:
        prg, manifest, symbols = self.fixture()
        changed = copy.deepcopy(symbols)
        changed["symbols"] = [
            entry
            for entry in changed["symbols"]
            if entry.get("name") != "World_Dispatch"
        ]
        errors, _report = RUNTIME.validate(prg, manifest, changed)
        self.assertTrue(any("dispatch symbol missing" in error for error in errors))

    def test_rejects_missing_dispatch_target_symbol(self) -> None:
        prg, manifest, symbols = self.fixture()
        changed = copy.deepcopy(symbols)
        changed["symbols"] = [
            entry
            for entry in changed["symbols"]
            if entry.get("name") != "World_Service"
        ]
        errors, _report = RUNTIME.validate(prg, manifest, changed)
        self.assertTrue(any("dispatch target symbol missing" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
