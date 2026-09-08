#!/usr/bin/env python3
"""Validate Doraemon reset, NMI, dispatcher, and mapper runtime evidence."""

from __future__ import annotations

import argparse
import copy
import csv
import json
from pathlib import Path


REQUIRED_COLUMNS = {
    "frame",
    "event",
    "detail",
    "bank",
    "selector",
    "target_prg",
    "target_chr",
    "address",
    "pc",
    "rom_value",
    "nmi_busy",
    "ppu_ctrl",
    "ppu_mask",
    "controller1",
}


def resolve_scenario(
    scenario: dict[str, object], profile: str
) -> dict[str, object]:
    resolved = copy.deepcopy(scenario)
    overrides = resolved.pop("profile_overrides", {})
    if not isinstance(overrides, dict):
        raise ValueError("runtime profile overrides must be an object")
    selected = overrides.get(profile, {})
    if not isinstance(selected, dict):
        raise ValueError(f"runtime {profile} scenario override must be an object")
    resolved.update(copy.deepcopy(selected))
    return resolved


def load_trace(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as stream:
        rows = list(csv.DictReader(stream))
    if not rows or not REQUIRED_COLUMNS.issubset(rows[0]):
        raise ValueError(f"trace is empty or uses an obsolete schema: {path}")
    if rows[0]["event"] != "trace_start" or rows[-1]["event"] != "trace_end":
        raise ValueError(f"trace did not complete cleanly: {path}")
    return rows


def mapper_rows_are_safe(rows: list[dict[str, str]]) -> bool:
    writes = [row for row in rows if row["event"] == "mapper_write"]
    if not writes:
        return False
    for row in writes:
        selector = int(row["selector"], 16)
        target_prg = selector & 0x03
        target_chr = (selector >> 2) & 0x03
        mapper_value = (target_prg << 4) | target_chr
        if int(row["target_prg"]) != target_prg:
            return False
        if int(row["target_chr"]) != target_chr:
            return False
        if int(row["address"], 16) != 0x8261 + selector:
            return False
        if int(row["rom_value"], 16) != mapper_value:
            return False
    return True


def initial_shell_switch(rows: list[dict[str, str]]) -> bool:
    writes = [row for row in rows if row["event"] == "mapper_write"]
    commits = [row for row in rows if row["event"] == "mapper_commit"]
    if not writes or not commits:
        return False
    return int(writes[0]["target_prg"]) == 3 and int(commits[0]["bank"]) == 3


def post_switch_nmi(rows: list[dict[str, str]]) -> bool:
    first_commit = next(
        (index for index, row in enumerate(rows) if row["event"] == "mapper_commit"),
        None,
    )
    if first_commit is None:
        return False
    return any(
        row["event"] == "nmi" and int(row["bank"]) == 3
        for row in rows[first_commit + 1 :]
    )


def shell_dispatch(rows: list[dict[str, str]]) -> bool:
    return any(
        row["event"] == "dispatch"
        and row["detail"] == "8271"
        and int(row["bank"]) == 3
        for row in rows
    )


def observed_inputs(scenario: dict[str, object], rows: list[dict[str, str]]) -> bool:
    button_bits = {
        "A": 0x80,
        "B": 0x40,
        "select": 0x20,
        "start": 0x10,
        "up": 0x08,
        "down": 0x04,
        "left": 0x02,
        "right": 0x01,
    }
    for action in scenario.get("inputs", []):  # type: ignore[union-attr]
        try:
            mask = sum(button_bits[button] for button in action["buttons"])
        except KeyError as exc:
            raise ValueError(f"unknown controller button: {exc.args[0]}") from exc
        first = int(action["first_frame"])
        last = int(action["last_frame"]) + 2
        if not any(
            first <= int(row["frame"]) <= last
            and int(row["controller1"], 16) & mask == mask
            for row in rows
        ):
            return False
    return True


def chapter_bank_entry(
    scenario: dict[str, object], rows: list[dict[str, str]]
) -> bool:
    expected = scenario.get("chapter_entry")
    if not isinstance(expected, dict):
        return False
    source = int(expected["source_prg"])
    target = int(expected["target_prg"])
    target_chr = int(expected["target_chr"])
    dispatch = str(expected["dispatch"])
    for index, row in enumerate(rows):
        if not (
            row["event"] == "mapper_write"
            and int(row["bank"]) == source
            and int(row["target_prg"]) == target
            and int(row["target_chr"]) == target_chr
        ):
            continue
        following = rows[index + 1 :]
        commit = next(
            (candidate for candidate in following if candidate["event"] == "mapper_commit"),
            None,
        )
        entry = next(
            (candidate for candidate in following if candidate["event"] == "dispatch"),
            None,
        )
        if (
            commit is not None
            and int(commit["bank"]) == target
            and entry is not None
            and int(entry["bank"]) == target
            and entry["detail"] == dispatch
            and any(
                candidate["event"] == "nmi" and int(candidate["bank"]) == target
                for candidate in following
            )
        ):
            return True
    return False


def chapter_steady_state(
    scenario: dict[str, object], rows: list[dict[str, str]]
) -> bool:
    expected = scenario.get("chapter_entry")
    if not isinstance(expected, dict):
        return False
    final = rows[-1]
    selector = str(expected["steady_selector"])
    return (
        final["event"] == "trace_end"
        and final["selector"] == selector
        and int(final["bank"]) == int(expected["target_prg"])
    )


def probe_sequence(scenario: dict[str, object], rows: list[dict[str, str]]) -> bool:
    expected = scenario.get("expected_probes")
    if not isinstance(expected, list) or not expected:
        return False
    position = 0
    for row in rows:
        item = expected[position]
        if isinstance(item, str):
            matched = row["detail"] == item
        elif isinstance(item, dict):
            matched = row["detail"] == str(item.get("name"))
            if "bank" in item:
                matched = matched and int(row["bank"]) == int(item["bank"])
        else:
            raise ValueError("expected_probes entries must be strings or objects")
        if row["event"] == "probe" and matched:
            position += 1
            if position == len(expected):
                return True
    return False


def recurring_frame_loops(
    scenario: dict[str, object], rows: list[dict[str, str]]
) -> bool:
    expected = scenario.get("recurring_frame_loops")
    if not isinstance(expected, list) or not expected:
        return False
    for item in expected:
        if not isinstance(item, dict):
            raise ValueError("recurring_frame_loops entries must be objects")
        name = str(item["name"])
        bank = int(item["bank"])
        minimum_frames = int(item["minimum_frames"])
        maximum_frame_gap = int(item.get("maximum_frame_gap", 1))
        frames = [
            int(row["frame"])
            for row in rows
            if row["event"] == "probe"
            and row["detail"] == name
            and int(row["bank"]) == bank
        ]
        if len(frames) < minimum_frames or len(frames) != len(set(frames)):
            return False
        if any(
            following - current < 1
            or following - current > maximum_frame_gap
            for current, following in zip(frames, frames[1:])
        ):
            return False
    return True


def observed_memory_patches(
    scenario: dict[str, object], rows: list[dict[str, str]]
) -> bool:
    expected = scenario.get("memory_patches")
    if not isinstance(expected, list) or not expected:
        return False
    for patch in expected:
        if not isinstance(patch, dict):
            raise ValueError("memory_patches entries must be objects")
        frame = int(patch["frame"])
        address = int(str(patch["address"]), 0)
        value = int(str(patch["value"]), 0)
        name = str(patch["name"])
        if not any(
            row["event"] == "memory_patch"
            and row["detail"] == name
            and int(row["frame"]) == frame
            and int(row["address"], 16) == address
            and int(row["rom_value"], 16) == value
            for row in rows
        ):
            return False
    return True


def world2_terminal_screen(rows: list[dict[str, str]]) -> bool:
    selections = [
        row
        for row in rows
        if row["event"] == "world2_terminal_select"
        and row["detail"] == "id=7F;ptr=00FC;scroll=00"
        and int(row["bank"]) == 1
    ]
    return len(selections) == 1 and not any(
        row["event"] == "world2_terminal_token_read" for row in rows
    )


def reset_after_probe(
    scenario: dict[str, object], rows: list[dict[str, str]]
) -> bool:
    expected = scenario.get("expected_reset")
    if not isinstance(expected, dict):
        return False
    probe_index = next(
        (
            index
            for index, row in enumerate(rows)
            if row["event"] == "probe"
            and row["detail"] == str(expected["after_probe"])
        ),
        None,
    )
    if probe_index is None:
        return False
    probe = rows[probe_index]
    reset = next(
        (row for row in rows[probe_index + 1 :] if row["event"] == "reset"),
        None,
    )
    if reset is None:
        return False
    frame_gap = int(reset["frame"]) - int(probe["frame"])
    return (
        int(reset["bank"]) == int(expected["bank"])
        and reset["selector"] == str(expected["selector"])
        and 0 <= frame_gap <= int(expected.get("maximum_frame_gap", 0))
    )


def post_reset_steady_state(
    scenario: dict[str, object], rows: list[dict[str, str]]
) -> bool:
    expected = scenario.get("post_reset")
    if not isinstance(expected, dict):
        return False
    reset_indexes = [index for index, row in enumerate(rows) if row["event"] == "reset"]
    if len(reset_indexes) < 2:
        return False
    final = rows[-1]
    return (
        final["event"] == "trace_end"
        and int(final["bank"]) == int(expected["bank"])
        and final["selector"] == str(expected["selector"])
    )


def validate_check(
    check_id: str, scenario: dict[str, object], rows: list[dict[str, str]]
) -> bool:
    checks = {
        "reset-observed": lambda: any(row["event"] == "reset" for row in rows),
        "emulator-power-on-bank": lambda: any(
            row["event"] == "reset" and int(row["bank"]) == 0 for row in rows
        ),
        "initial-shell-switch": lambda: initial_shell_switch(rows),
        "mapper-bus-conflict": lambda: mapper_rows_are_safe(rows),
        "post-switch-nmi": lambda: post_switch_nmi(rows),
        "shell-dispatch": lambda: shell_dispatch(rows),
        "observed-inputs": lambda: observed_inputs(scenario, rows),
        "chapter-bank-entry": lambda: chapter_bank_entry(scenario, rows),
        "chapter-steady-state": lambda: chapter_steady_state(scenario, rows),
        "probe-sequence": lambda: probe_sequence(scenario, rows),
        "recurring-frame-loops": lambda: recurring_frame_loops(scenario, rows),
        "observed-memory-patches": lambda: observed_memory_patches(scenario, rows),
        "world2-terminal-screen": lambda: world2_terminal_screen(rows),
        "reset-after-probe": lambda: reset_after_probe(scenario, rows),
        "post-reset-steady-state": lambda: post_reset_steady_state(scenario, rows),
    }
    if check_id not in checks:
        raise ValueError(f"unknown runtime check: {check_id}")
    return checks[check_id]()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--scenarios", required=True, type=Path)
    parser.add_argument("--trace-dir", required=True, type=Path)
    parser.add_argument("--profile", choices=("original", "rev_a"), default="original")
    args = parser.parse_args()
    document = json.loads(args.scenarios.read_text(encoding="utf-8"))
    failures: list[str] = []
    for base_scenario in document["scenarios"]:
        scenario = resolve_scenario(base_scenario, args.profile)
        rows = load_trace(args.trace_dir / f"{scenario['id']}.csv")
        for check_id in scenario["checks"]:
            passed = validate_check(check_id, scenario, rows)
            print(f"[{'OK' if passed else 'ERROR'}] {scenario['id']}: {check_id}")
            if not passed:
                failures.append(f"{scenario['id']}:{check_id}")
    if failures:
        print(f"[FAIL] Runtime checks failed: {', '.join(failures)}")
        return 1
    print("[OK] Deterministic runtime architecture evidence is consistent")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
