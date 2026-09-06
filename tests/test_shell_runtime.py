from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import shell_runtime


class ShellRuntimeTests(unittest.TestCase):
    def fixture(self) -> tuple[bytes, dict[str, object], dict[str, object], list[dict[str, str]]]:
        prg = bytearray(4 * shell_runtime.BANK_SIZE)
        bank_offset = 3 * shell_runtime.BANK_SIZE
        prg[bank_offset:bank_offset + 7] = b"\x20\x05\x80\x60\xEA\x60\x60"
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": 3,
            "routines": [
                {
                    "address": "0x8005",
                    "end_address": "0x8006",
                    "size": 2,
                    "crc32": shell_runtime.crc32(b"\x60\x60"),
                    "name": "Shell_TestRoutine",
                    "callers": [{"address": "0x8000", "mnemonic": "JSR"}],
                }
            ],
            "memory_symbols": [
                {"address": "0x0040", "name": "Shell_TestState"}
            ],
        }
        symbols: dict[str, object] = {
            "schema_version": 1,
            "symbols": [
                {"bank": 3, "address": "0x8005", "name": "Shell_TestRoutine"}
            ],
            "memory_symbols": [
                {
                    "address": "0x0040",
                    "name": "Shell_TestState",
                    "banks": [3],
                }
            ],
        }
        facts = [
            {
                "address": "8000",
                "mnemonic": "JSR",
                "flows": "PRG0::8005",
            }
        ]
        return bytes(prg), manifest, symbols, facts

    def test_accepts_exact_routine_and_bank_scoped_ram(self) -> None:
        errors, report = shell_runtime.validate(*self.fixture())
        self.assertEqual(errors, [])
        self.assertEqual(report["direct_callers"], 1)

    def test_rejects_changed_routine_bytes(self) -> None:
        prg, manifest, symbols, facts = self.fixture()
        changed = bytearray(prg)
        changed[3 * shell_runtime.BANK_SIZE + 5] ^= 1
        errors, _report = shell_runtime.validate(
            bytes(changed), manifest, symbols, facts
        )
        self.assertTrue(any("routine bytes" in error for error in errors))

    def test_rejects_missing_direct_caller(self) -> None:
        prg, manifest, symbols, _facts = self.fixture()
        errors, _report = shell_runtime.validate(prg, manifest, symbols, [])
        self.assertTrue(any("callers differ" in error for error in errors))

    def test_rejects_shared_ram_alias(self) -> None:
        prg, manifest, symbols, facts = self.fixture()
        changed = copy.deepcopy(symbols)
        del changed["memory_symbols"][0]["banks"]
        errors, _report = shell_runtime.validate(prg, manifest, changed, facts)
        self.assertTrue(any("RAM symbol" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
