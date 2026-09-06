#!/usr/bin/env python3
"""Join generated debugger labels to live FCEUX program and RAM observations."""

from __future__ import annotations

import argparse
from collections import Counter
import csv
import json
from pathlib import Path
import re
from typing import Any


HEX_BYTE = re.compile(r"^[0-9A-Fa-f]{2}$")


def number(value: object) -> int:
    return int(str(value), 0)


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def load_trace(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as stream:
        rows = list(csv.DictReader(stream))
    if not rows or "pc" not in rows[0]:
        raise ValueError(f"runtime trace lacks the live PC column: {path}")
    if rows[0]["event"] != "trace_start" or rows[-1]["event"] != "trace_end":
        raise ValueError(f"runtime trace did not complete cleanly: {path}")
    return rows


def fceux_bank_index(bank: int, address: int) -> int:
    if not 0 <= bank <= 3 or not 0x8000 <= address <= 0xFFFF:
        raise ValueError("program observation is outside the GNROM PRG window")
    return bank * 2 + int(address >= 0xC000)


def nl_has_symbol(path: Path, address: int, name: str) -> bool:
    prefix = f"${address:04X}#{name}#"
    return any(
        line.startswith(prefix)
        for line in path.read_text(encoding="utf-8").splitlines()
    )


def validate_live_symbols(
    contract: dict[str, Any],
    breakpoints: dict[str, Any],
    watches: dict[str, Any],
    trace_dir: Path,
    symbol_dir: Path,
) -> tuple[list[str], dict[str, object]]:
    errors: list[str] = []
    if contract.get("schema_version") != 1:
        errors.append("runtime debugger-symbol contract is not schema 1")

    breakpoint_index = {
        (int(item["bank"]), number(item["address"]), str(item["symbol"]))
        for item in breakpoints.get("breakpoints", [])
    }
    watch_index = {
        (number(item["address"]), int(item["size"]), str(item["name"]))
        for item in watches.get("watches", [])
    }
    trace_cache: dict[str, list[dict[str, str]]] = {}

    def trace(scenario: str) -> list[dict[str, str]]:
        if scenario not in trace_cache:
            trace_cache[scenario] = load_trace(trace_dir / f"{scenario}.csv")
        return trace_cache[scenario]

    program = contract.get("program_observations", [])
    for item in program:
        bank = int(item["bank"])
        address = number(item["address"])
        symbol = str(item["symbol"])
        identity = (bank, address, symbol)
        if identity not in breakpoint_index:
            errors.append(f"live program symbol is not a configured breakpoint: {symbol}")
        physical_bank = fceux_bank_index(bank, address)
        nl_path = symbol_dir / (
            f"{contract['fceux_rom_filename']}.{physical_bank:X}.nl"
        )
        if not nl_path.is_file() or not nl_has_symbol(nl_path, address, symbol):
            errors.append(f"live program symbol is absent from FCEUX names: {symbol}")
        rows = trace(str(item["scenario"]))
        if not any(
            row["event"] == str(item["event"])
            and row["detail"] == str(item["detail"])
            and int(row["bank"]) == bank
            and int(row["pc"], 16) == address
            for row in rows
        ):
            errors.append(f"live program symbol was not observed at its PC: {symbol}")

    ram = contract.get("ram_observations", [])
    ram_names = symbol_dir / f"{contract['fceux_rom_filename']}.ram.nl"
    for item in ram:
        address = number(item["address"])
        size = int(item["size"])
        symbol = str(item["symbol"])
        identity = (address, size, symbol)
        if identity not in watch_index:
            errors.append(f"live RAM symbol is not a configured watch: {symbol}")
        if not ram_names.is_file() or not nl_has_symbol(ram_names, address, symbol):
            errors.append(f"live RAM symbol is absent from FCEUX names: {symbol}")
        column = str(item["column"])
        rows = trace(str(item["scenario"]))
        if rows and column not in rows[0]:
            errors.append(f"live RAM trace column is absent: {column}")
            continue
        values = {row[column].upper() for row in rows if HEX_BYTE.fullmatch(row[column])}
        if len(values) < int(item["minimum_unique_values"]):
            errors.append(f"live RAM watch lacks changing evidence: {symbol}")

    metrics: dict[str, object] = {
        "program_observations": len(program),
        "program_banks": sorted({int(item["bank"]) for item in program}),
        "program_kinds": dict(sorted(Counter(item["kind"] for item in program).items())),
        "ram_observations": len(ram),
    }
    if metrics != contract.get("expected_metrics"):
        errors.append("runtime debugger-symbol metrics differ from the contract")
    return errors, metrics


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--contract", required=True, type=Path)
    parser.add_argument("--breakpoints", required=True, type=Path)
    parser.add_argument("--watches", required=True, type=Path)
    parser.add_argument("--trace-dir", required=True, type=Path)
    parser.add_argument("--symbol-dir", required=True, type=Path)
    args = parser.parse_args()
    try:
        errors, metrics = validate_live_symbols(
            load_json(args.contract),
            load_json(args.breakpoints),
            load_json(args.watches),
            args.trace_dir,
            args.symbol_dir,
        )
    except (OSError, KeyError, TypeError, ValueError, json.JSONDecodeError) as exc:
        print(f"[ERROR] runtime debugger-symbol validation failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        "[OK] live debugger symbols: "
        f"{metrics['program_observations']} program observations across "
        f"{len(metrics['program_banks'])} banks; "
        f"{metrics['ram_observations']} changing RAM watches"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
