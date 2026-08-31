from __future__ import annotations

import csv
import importlib.util
from pathlib import Path
import tempfile
import unittest


ROOT = Path(__file__).resolve().parent.parent
SPEC = importlib.util.spec_from_file_location(
    "validate_runtime_scenarios",
    ROOT / "scripts" / "runtime" / "validate_runtime_scenarios.py",
)
assert SPEC is not None and SPEC.loader is not None
RUNTIME = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(RUNTIME)


def row(event: str, **changes: str) -> dict[str, str]:
    result = {
        "frame": "0",
        "event": event,
        "detail": "",
        "bank": "3",
        "selector": "03",
        "target_prg": "3",
        "target_chr": "0",
        "address": "8264",
        "rom_value": "30",
        "nmi_busy": "00",
        "ppu_ctrl": "10",
        "ppu_mask": "06",
        "controller1": "00",
    }
    result.update(changes)
    return result


class RuntimeValidationTests(unittest.TestCase):
    def test_accepts_bus_conflict_safe_mapper_row(self) -> None:
        self.assertTrue(RUNTIME.mapper_rows_are_safe([row("mapper_write")]))

    def test_rejects_wrong_mapper_rom_value(self) -> None:
        self.assertFalse(
            RUNTIME.mapper_rows_are_safe([row("mapper_write", rom_value="31")])
        )

    def test_requires_nmi_after_committed_shell_switch(self) -> None:
        rows = [row("mapper_commit"), row("nmi")]
        self.assertTrue(RUNTIME.post_switch_nmi(rows))
        self.assertFalse(RUNTIME.post_switch_nmi(list(reversed(rows))))

    def test_load_trace_requires_clean_boundaries(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "trace.csv"
            with path.open("w", encoding="utf-8", newline="") as stream:
                writer = csv.DictWriter(stream, fieldnames=list(row("x")))
                writer.writeheader()
                writer.writerows([row("trace_start"), row("trace_end")])
            self.assertEqual(len(RUNTIME.load_trace(path)), 2)

    def test_accepts_ordered_chapter_entry(self) -> None:
        scenario = {
            "chapter_entry": {
                "source_prg": 3,
                "target_prg": 1,
                "target_chr": 3,
                "dispatch": "8271",
                "steady_selector": "05",
            }
        }
        rows = [
            row("mapper_write", bank="3", target_prg="1", target_chr="3"),
            row("mapper_commit", bank="1"),
            row("dispatch", bank="1", detail="8271"),
            row("nmi", bank="1"),
        ]
        self.assertTrue(RUNTIME.chapter_bank_entry(scenario, rows))

    def test_rejects_dispatch_in_wrong_bank(self) -> None:
        scenario = {
            "chapter_entry": {
                "source_prg": 3,
                "target_prg": 1,
                "target_chr": 3,
                "dispatch": "8271",
                "steady_selector": "05",
            }
        }
        rows = [
            row("mapper_write", bank="3", target_prg="1", target_chr="3"),
            row("mapper_commit", bank="1"),
            row("dispatch", bank="3", detail="8271"),
            row("nmi", bank="1"),
        ]
        self.assertFalse(RUNTIME.chapter_bank_entry(scenario, rows))

    def test_observed_inputs_allow_fceux_poll_delay(self) -> None:
        scenario = {
            "inputs": [
                {"first_frame": 10, "last_frame": 12, "buttons": ["A", "B"]}
            ]
        }
        rows = [row("nmi", frame="13", controller1="C0")]
        self.assertTrue(RUNTIME.observed_inputs(scenario, rows))


if __name__ == "__main__":
    unittest.main()
