#!/usr/bin/env python3
"""Validate bank-local indirect audio dispatchers against the PRG."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any

from scripts.build import project


BANK_SIZE = 0x8000
CPU_BASE = 0x8000


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def load_manifest(path: Path) -> dict[str, Any]:
    document = json.loads(path.read_text(encoding="utf-8"))
    if document.get("schema_version") != 1:
        raise ValueError("unsupported audio dispatch schema")
    return document


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("audio dispatch range is outside PRG")
    return prg[offset:offset + size]


def validate_driver(
    prg: bytes,
    driver: dict[str, Any],
    code_entries: list[tuple[int, int, str]],
) -> tuple[list[str], dict[str, int]]:
    errors: list[str] = []
    name = str(driver.get("name", f"bank-{driver['bank']}"))
    bank = int(driver["bank"])
    priorities = driver["priority_table"]
    priority_values = bytes(number(value) for value in priorities["values"])
    request_count = int(driver["request_count"])
    if len(priority_values) != request_count:
        errors.append(f"{name}: priority table length differs from request count")
    actual_priorities = bank_slice(
        prg, bank, number(priorities["address"]), len(priority_values)
    )
    if actual_priorities != priority_values:
        errors.append(f"{name}: audio request priority table differs")
    if any(value & 1 for value in priority_values):
        errors.append(f"{name}: audio dispatch indexes are not all even")

    dispatch = driver["dispatch_table"]
    targets = [number(value) for value in dispatch["targets"]]
    slot_count = int(dispatch["slot_count"])
    if len(targets) != slot_count:
        errors.append(f"{name}: dispatch target count differs from slot count")
    encoded = b"".join((target - 1).to_bytes(2, "little") for target in targets)
    actual_dispatch = bank_slice(
        prg, bank, number(dispatch["address"]), len(encoded)
    )
    if actual_dispatch != encoded:
        errors.append(f"{name}: audio RTS dispatch table differs")

    command_dispatch = driver["music_command_table"]
    command_targets = [number(value) for value in command_dispatch["targets"]]
    command_slot_count = int(command_dispatch["slot_count"])
    if len(command_targets) != command_slot_count:
        errors.append(f"{name}: music command target count differs from slot count")
    command_encoded = b"".join(
        (target - 1).to_bytes(2, "little") for target in command_targets
    )
    actual_commands = bank_slice(
        prg, bank, number(command_dispatch["address"]), len(command_encoded)
    )
    if actual_commands != command_encoded:
        errors.append(f"{name}: music command RTS dispatch table differs")
    first_command = number(command_dispatch["first_command"])
    last_command = number(command_dispatch["last_command"])
    if first_command != 0xFF or first_command - command_slot_count + 1 != last_command:
        errors.append(f"{name}: music command dispatch does not cover $FF down through $EF")

    declared = {
        address
        for entry_bank, address, _name in code_entries
        if entry_bank == bank
    }
    missing = sorted((set(targets) | set(command_targets)) - declared)
    if missing:
        errors.append(
            f"{name}: audio dispatch targets missing from code entry registry: "
            + ", ".join(f"${address:04X}" for address in missing)
        )

    report = {
        "request_count": request_count,
        "dispatch_slot_count": slot_count,
        "unique_target_count": len(set(targets)),
        "music_command_count": command_slot_count,
        "unique_music_command_target_count": len(set(command_targets)),
    }
    return errors, report


def validate(
    prg: bytes,
    document: dict[str, Any],
    code_entries: list[tuple[int, int, str]],
) -> tuple[list[str], dict[str, int]]:
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    drivers = [document, *document.get("additional_drivers", [])]
    errors: list[str] = []
    reports: list[dict[str, int]] = []
    for driver in drivers:
        driver_errors, report = validate_driver(prg, driver, code_entries)
        errors.extend(driver_errors)
        reports.append(report)
    return errors, {
        "driver_count": len(drivers),
        "request_count": sum(report["request_count"] for report in reports),
        "dispatch_slot_count": sum(report["dispatch_slot_count"] for report in reports),
        "unique_target_count": sum(report["unique_target_count"] for report in reports),
        "music_command_count": sum(report["music_command_count"] for report in reports),
        "unique_music_command_target_count": sum(
            report["unique_music_command_target_count"] for report in reports
        ),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prg", required=True, type=Path)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--code-entries", required=True, type=Path)
    args = parser.parse_args()
    try:
        errors, report = validate(
            args.prg.read_bytes(),
            load_manifest(args.manifest),
            project.load_prg_code_entries(args.code_entries),
        )
    except (OSError, ValueError, KeyError, json.JSONDecodeError, project.ProjectError) as exc:
        print(f"[ERROR] audio dispatch audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] {report['driver_count']} audio drivers: "
        f"{report['request_count']} audio requests, "
        f"{report['dispatch_slot_count']} dispatch slots, "
        f"{report['unique_target_count']} unique effect handlers; "
        f"{report['music_command_count']} music commands, "
        f"{report['unique_music_command_target_count']} unique command handlers"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
