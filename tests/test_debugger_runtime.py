from __future__ import annotations

import csv
import importlib.util
from pathlib import Path
import tempfile
import unittest


ROOT = Path(__file__).resolve().parent.parent
SPEC = importlib.util.spec_from_file_location(
    "validate_debugger_runtime",
    ROOT / "scripts" / "runtime" / "validate_debugger_runtime.py",
)
assert SPEC is not None and SPEC.loader is not None
RUNTIME_SYMBOLS = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(RUNTIME_SYMBOLS)


class DebuggerRuntimeTests(unittest.TestCase):
    def fixture(self, root: Path, pc: str = "813C") -> tuple[dict, dict, dict]:
        traces = root / "traces"
        symbols = root / "symbols"
        traces.mkdir()
        symbols.mkdir()
        fields = [
            "frame",
            "event",
            "detail",
            "bank",
            "pc",
            "nmi_busy",
        ]
        rows = [
            ["0", "trace_start", "test", "3", "0000", "00"],
            ["1", "nmi", "Nmi", "3", pc, "01"],
            ["2", "trace_end", "test", "3", "0000", "00"],
        ]
        with (traces / "test.csv").open("w", encoding="utf-8", newline="") as stream:
            writer = csv.writer(stream)
            writer.writerow(fields)
            writer.writerows(rows)
        (symbols / "doraemon.nes.6.nl").write_text(
            "$813C#Bank3_Nmi#\n", encoding="utf-8"
        )
        (symbols / "doraemon.nes.ram.nl").write_text(
            "$0015#NmiBusy#guard\n", encoding="utf-8"
        )
        contract = {
            "schema_version": 1,
            "fceux_rom_filename": "doraemon.nes",
            "program_observations": [
                {
                    "kind": "nmi",
                    "scenario": "test",
                    "event": "nmi",
                    "detail": "Nmi",
                    "bank": 3,
                    "address": "0x813C",
                    "symbol": "Bank3_Nmi",
                }
            ],
            "ram_observations": [
                {
                    "scenario": "test",
                    "column": "nmi_busy",
                    "address": "0x0015",
                    "size": 1,
                    "symbol": "NmiBusy",
                    "minimum_unique_values": 2,
                }
            ],
            "expected_metrics": {
                "program_observations": 1,
                "program_banks": [3],
                "program_kinds": {"nmi": 1},
                "ram_observations": 1,
            },
        }
        breakpoints = {
            "breakpoints": [
                {
                    "bank": 3,
                    "address": "0x813C",
                    "symbol": "Bank3_Nmi",
                }
            ]
        }
        watches = {
            "watches": [
                {"address": "0x0015", "size": 1, "name": "NmiBusy"}
            ]
        }
        return contract, breakpoints, watches

    def test_maps_each_32k_bank_to_two_fceux_banks(self) -> None:
        self.assertEqual(RUNTIME_SYMBOLS.fceux_bank_index(2, 0x8000), 4)
        self.assertEqual(RUNTIME_SYMBOLS.fceux_bank_index(2, 0xC000), 5)

    def test_accepts_generated_names_and_live_observations(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            contract, breakpoints, watches = self.fixture(root)
            errors, _ = RUNTIME_SYMBOLS.validate_live_symbols(
                contract, breakpoints, watches, root / "traces", root / "symbols"
            )
        self.assertEqual(errors, [])

    def test_rejects_trace_pc_that_differs_from_symbol(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            contract, breakpoints, watches = self.fixture(root, pc="813D")
            errors, _ = RUNTIME_SYMBOLS.validate_live_symbols(
                contract, breakpoints, watches, root / "traces", root / "symbols"
            )
        self.assertTrue(any("not observed at its PC" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
