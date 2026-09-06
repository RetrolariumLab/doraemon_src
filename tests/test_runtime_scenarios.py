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
RUN_SPEC = importlib.util.spec_from_file_location(
    "run_runtime_scenarios",
    ROOT / "scripts" / "runtime" / "run_runtime_scenarios.py",
)
assert RUN_SPEC is not None and RUN_SPEC.loader is not None
RUNNER = importlib.util.module_from_spec(RUN_SPEC)
RUN_SPEC.loader.exec_module(RUNNER)


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
    def test_encodes_valid_wram_patch(self) -> None:
        encoded = RUNNER.encode_memory_patches(
            [
                {
                    "frame": 400,
                    "address": "0x004F",
                    "value": "0x01",
                    "name": "completion_countdown",
                }
            ]
        )
        self.assertEqual(encoded, "400:004F:01:completion_countdown")

    def test_rejects_runtime_patch_outside_wram(self) -> None:
        with self.assertRaisesRegex(ValueError, "memory patch"):
            RUNNER.encode_memory_patches(
                [
                    {
                        "frame": 1,
                        "address": "0x8000",
                        "value": "0x01",
                        "name": "rom_write",
                    }
                ]
            )

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

    def test_requires_declared_probe_order(self) -> None:
        scenario = {"expected_probes": ["manhole_entered", "sideview_init"]}
        ordered = [
            row("probe", detail="manhole_entered"),
            row("probe", detail="sideview_init"),
        ]
        self.assertTrue(RUNTIME.probe_sequence(scenario, ordered))
        self.assertFalse(RUNTIME.probe_sequence(scenario, list(reversed(ordered))))

    def test_probe_sequence_can_require_active_bank(self) -> None:
        scenario = {
            "expected_probes": [
                {"name": "main_entry", "bank": 2},
                {"name": "frame_loop", "bank": 2},
            ]
        }
        correct = [
            row("probe", detail="main_entry", bank="2"),
            row("probe", detail="frame_loop", bank="2"),
        ]
        wrong_bank = [
            row("probe", detail="main_entry", bank="1"),
            row("probe", detail="frame_loop", bank="2"),
        ]
        self.assertTrue(RUNTIME.probe_sequence(scenario, correct))
        self.assertFalse(RUNTIME.probe_sequence(scenario, wrong_bank))

    def test_accepts_one_frame_loop_hit_per_consecutive_frame(self) -> None:
        scenario = {
            "recurring_frame_loops": [
                {
                    "name": "world1_city_frame_loop",
                    "bank": 0,
                    "minimum_frames": 3,
                    "maximum_frame_gap": 1,
                }
            ]
        }
        rows = [
            row("probe", detail="world1_city_frame_loop", bank="0", frame=str(frame))
            for frame in range(100, 103)
        ]
        self.assertTrue(RUNTIME.recurring_frame_loops(scenario, rows))

    def test_rejects_duplicate_or_gapped_frame_loop_hits(self) -> None:
        scenario = {
            "recurring_frame_loops": [
                {
                    "name": "world2_frame_loop",
                    "bank": 1,
                    "minimum_frames": 3,
                    "maximum_frame_gap": 1,
                }
            ]
        }
        duplicate = [
            row("probe", detail="world2_frame_loop", bank="1", frame=frame)
            for frame in ("10", "10", "11")
        ]
        gapped = [
            row("probe", detail="world2_frame_loop", bank="1", frame=frame)
            for frame in ("10", "11", "13")
        ]
        self.assertFalse(RUNTIME.recurring_frame_loops(scenario, duplicate))
        self.assertFalse(RUNTIME.recurring_frame_loops(scenario, gapped))

    def test_requires_declared_memory_patch(self) -> None:
        scenario = {
            "memory_patches": [
                {
                    "frame": 400,
                    "address": "0x004F",
                    "value": "0x01",
                    "name": "completion_countdown",
                }
            ]
        }
        observed = [
            row(
                "memory_patch",
                frame="400",
                detail="completion_countdown",
                address="004F",
                rom_value="01",
            )
        ]
        self.assertTrue(RUNTIME.observed_memory_patches(scenario, observed))
        self.assertFalse(
            RUNTIME.observed_memory_patches(
                scenario, [row("memory_patch", frame="400", address="004F")]
            )
        )

    def test_accepts_stopped_world2_terminal_screen_without_token_reads(self) -> None:
        rows = [
            row(
                "world2_terminal_select",
                detail="id=7F;ptr=00FC;scroll=00",
                bank="1",
            )
        ]
        self.assertTrue(RUNTIME.world2_terminal_screen(rows))
        self.assertFalse(
            RUNTIME.world2_terminal_screen(
                rows + [row("world2_terminal_token_read", bank="1")]
            )
        )

    def test_rejects_terminal_screen_selected_while_scrolling(self) -> None:
        rows = [
            row(
                "world2_terminal_select",
                detail="id=7F;ptr=00FC;scroll=01",
                bank="1",
            )
        ]
        self.assertFalse(RUNTIME.world2_terminal_screen(rows))


if __name__ == "__main__":
    unittest.main()
