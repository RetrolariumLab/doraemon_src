#!/usr/bin/env python3
"""Validate chapter object-handler dispatch tables and indirect code entries."""

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
        raise ValueError("unsupported object dispatch schema")
    return document


def encode_target(target: int, encoding: str) -> bytes:
    if encoding == "rts-minus-one":
        target -= 1
    elif encoding != "pointer":
        raise ValueError(f"unsupported object dispatch encoding: {encoding}")
    return target.to_bytes(2, "little")


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("object dispatch range is outside PRG")
    return prg[offset:offset + size]


def validate(
    prg: bytes,
    document: dict[str, Any],
    code_entries: list[tuple[int, int, str]],
) -> tuple[list[str], dict[str, int]]:
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    tables = document.get("tables")
    if not isinstance(tables, list) or not tables:
        return ["object dispatch tables must be a non-empty list"], {}

    errors: list[str] = []
    table_names: set[str] = set()
    unique_targets: set[tuple[int, int]] = set()
    continuations: set[tuple[int, int]] = set()
    slot_count = 0
    declared = {(bank, address) for bank, address, _name in code_entries}
    for table in tables:
        name = str(table.get("name", ""))
        bank = int(table["bank"])
        address = number(table["address"])
        encoding = str(table["encoding"])
        targets = [number(value) for value in table.get("targets", [])]
        table_continuations = [
            number(value) for value in table.get("continuations", [])
        ]
        expected_slots = int(table["slot_count"])
        if not name or name in table_names:
            errors.append(f"duplicate or empty object dispatch name: {name!r}")
        table_names.add(name)
        if len(targets) != expected_slots:
            errors.append(
                f"{name}: target count {len(targets)} differs from "
                f"slot count {expected_slots}"
            )
        targets_in_range = all(CPU_BASE <= target <= 0xFFFF for target in targets)
        if not targets_in_range:
            errors.append(f"{name}: target is outside the active PRG window")
        else:
            encoded = b"".join(
                encode_target(target, encoding) for target in targets
            )
            if bank_slice(prg, bank, address, len(encoded)) != encoded:
                errors.append(f"{name}: encoded dispatch table differs from PRG")
        missing = sorted(
            target
            for target in set(targets + table_continuations)
            if (bank, target) not in declared
        )
        if missing:
            errors.append(
                f"{name}: indirect targets missing from code entry registry: "
                + ", ".join(f"${target:04X}" for target in missing)
            )
        unique_targets.update((bank, target) for target in targets)
        continuations.update((bank, target) for target in table_continuations)
        slot_count += expected_slots

    return errors, {
        "table_count": len(tables),
        "slot_count": slot_count,
        "unique_target_count": len(unique_targets),
        "continuation_count": len(continuations),
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
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] object dispatch audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    table_label = "table" if report["table_count"] == 1 else "tables"
    print(
        f"[OK] {report['table_count']} object dispatch {table_label}: "
        f"{report['slot_count']} slots, {report['unique_target_count']} unique handlers, "
        f"{report['continuation_count']} continuations"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
