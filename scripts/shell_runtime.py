#!/usr/bin/env python3
"""Validate Bank 3 shell routines, direct callers, and private RAM state."""

from __future__ import annotations

import argparse
import csv
import json
from pathlib import Path
from typing import Any
import zlib


BANK_SIZE = 0x8000
CPU_BASE = 0x8000
CALL_OPCODES = {"JSR": 0x20, "JMP": 0x4C}


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def load_json(path: Path, description: str) -> dict[str, Any]:
    document = json.loads(path.read_text(encoding="utf-8"))
    if document.get("schema_version") != 1:
        raise ValueError(f"unsupported {description} schema")
    return document


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("shell runtime range is outside PRG")
    return prg[offset:offset + size]


def crc32(data: bytes) -> str:
    return f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"


def load_facts(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as stream:
        rows = list(csv.DictReader(stream, delimiter="\t"))
    if not rows or "flows" not in rows[0]:
        raise ValueError("shell runtime Ghidra facts are incomplete")
    return rows


def direct_callers(
    facts: list[dict[str, str]], target: int
) -> set[tuple[int, str]]:
    suffix = f"::{target:04x}"
    return {
        (int(row["address"], 16), row["mnemonic"])
        for row in facts
        if row["mnemonic"] in CALL_OPCODES
        and row["flows"].lower().endswith(suffix)
    }


def symbol_indexes(
    symbols: dict[str, Any]
) -> tuple[dict[tuple[int, int], dict[str, Any]], dict[str, dict[str, Any]]]:
    prg = {
        (int(item["bank"]), number(item["address"])): item
        for item in symbols["symbols"]
        if not item.get("operand_symbol", False)
    }
    memory = {str(item["name"]): item for item in symbols["memory_symbols"]}
    return prg, memory


def validate(
    prg: bytes,
    manifest: dict[str, Any],
    symbols: dict[str, Any],
    facts: list[dict[str, str]],
) -> tuple[list[str], dict[str, int]]:
    errors: list[str] = []
    bank = int(manifest["bank"])
    prg_symbols, memory_symbols = symbol_indexes(symbols)
    previous_end = CPU_BASE - 1
    routine_bytes = 0
    caller_count = 0
    for routine in sorted(manifest["routines"], key=lambda item: number(item["address"])):
        address = number(routine["address"])
        end = number(routine["end_address"])
        size = int(routine["size"])
        name = str(routine["name"])
        if address <= previous_end or end - address + 1 != size:
            errors.append(f"shell routine range differs: {name}")
            continue
        previous_end = end
        routine_bytes += size
        raw = bank_slice(prg, bank, address, size)
        if crc32(raw) != str(routine["crc32"]).lower():
            errors.append(f"shell routine bytes differ: {name}")
        symbol = prg_symbols.get((bank, address))
        if symbol is None or symbol.get("name") != name:
            errors.append(f"shell routine symbol differs: {name}")
        expected_callers = {
            (number(item["address"]), str(item["mnemonic"]))
            for item in routine["callers"]
        }
        observed_callers = direct_callers(facts, address)
        if observed_callers != expected_callers:
            errors.append(f"shell routine callers differ: {name}")
        caller_count += len(expected_callers)
        for caller, mnemonic in expected_callers:
            call = bank_slice(prg, bank, caller, 3)
            if call != bytes((CALL_OPCODES[mnemonic], address & 0xFF, address >> 8)):
                errors.append(f"shell callsite bytes differ: {name} at ${caller:04X}")

    ram_bytes = 0
    for expected in manifest["memory_symbols"]:
        name = str(expected["name"])
        actual = memory_symbols.get(name)
        size = int(expected.get("size", 1))
        ram_bytes += size
        if actual is None or (
            number(actual["address"]) != number(expected["address"])
            or int(actual.get("size", 1)) != size
            or actual.get("banks") != [bank]
        ):
            errors.append(f"shell RAM symbol differs: {name}")

    report = {
        "routine_count": len(manifest["routines"]),
        "routine_bytes": routine_bytes,
        "direct_callers": caller_count,
        "memory_symbols": len(manifest["memory_symbols"]),
        "memory_bytes": ram_bytes,
    }
    return errors, report


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prg", required=True, type=Path)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--symbols", required=True, type=Path)
    parser.add_argument("--facts", required=True, type=Path)
    args = parser.parse_args()
    try:
        errors, report = validate(
            args.prg.read_bytes(),
            load_json(args.manifest, "shell-runtime"),
            load_json(args.symbols, "symbol"),
            load_facts(args.facts),
        )
        if errors:
            for error in errors:
                print(f"[ERROR] {error}")
            return 1
        print(
            f"[OK] Bank 3 shell runtime: {report['routine_count']} routines / "
            f"{report['routine_bytes']} bytes, {report['direct_callers']} direct "
            f"callers, {report['memory_symbols']} RAM symbols / "
            f"{report['memory_bytes']} bytes"
        )
        return 0
    except (OSError, KeyError, TypeError, ValueError, json.JSONDecodeError) as exc:
        print(f"[ERROR] shell runtime validation failed: {exc}")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
