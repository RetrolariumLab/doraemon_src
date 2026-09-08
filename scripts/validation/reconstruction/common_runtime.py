#!/usr/bin/env python3
"""Validate the duplicated reset/NMI/PPU/mapper runtime and bank dispatches."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
from typing import Any


BANK_SIZE = 0x8000
CPU_BASE = 0x8000


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def load_json(path: Path) -> dict[str, Any]:
    document = json.loads(path.read_text(encoding="utf-8"))
    if document.get("schema_version") != 1:
        raise ValueError("unsupported common runtime schema")
    return document


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("common runtime range is outside PRG")
    return prg[offset:offset + size]


def code_symbols(document: dict[str, Any]) -> set[tuple[int, int, str]]:
    return {
        (int(entry["bank"]), number(entry["address"]), str(entry["name"]))
        for entry in document["symbols"]
    }


def validate(
    prg: bytes,
    document: dict[str, Any],
    symbols: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    errors: list[str] = []
    declared_symbols = code_symbols(symbols)
    shared = document["shared_range"]
    shared_address = number(shared["address"])
    shared_size = int(shared["size"])
    copies = [bank_slice(prg, bank, shared_address, shared_size) for bank in range(4)]
    if any(copy != copies[0] for copy in copies[1:]):
        errors.append("reset-through-score runtime range is not identical in all banks")
    if hashlib.sha1(copies[0]).hexdigest() != shared["sha1"]:
        errors.append("common runtime SHA-1 differs")

    for service in document["shared_services"]:
        address = number(service["address"])
        size = int(service["size"])
        actual_sha1 = hashlib.sha1(bank_slice(prg, 0, address, size)).hexdigest()
        if actual_sha1 != service["sha1"]:
            errors.append(f"{service['suffix']}: routine SHA-1 differs")
        for bank in range(4):
            symbol = f"Bank{bank}_{service['suffix']}"
            if (bank, address, symbol) not in declared_symbols:
                errors.append(f"bank {bank}: common service symbol missing: {symbol}")

    dispatch_count = 0
    for dispatch in document["bank_dispatches"]:
        bank = int(dispatch["bank"])
        for entry in dispatch["entries"]:
            address = number(entry["address"])
            target = number(entry["target"])
            expected = bytes((0x4C, target & 0xFF, target >> 8))
            if bank_slice(prg, bank, address, 3) != expected:
                errors.append(
                    f"bank {bank}: dispatch {entry['symbol']} differs at ${address:04X}"
                )
            symbol = str(entry["symbol"])
            if (bank, address, symbol) not in declared_symbols:
                errors.append(f"bank {bank}: dispatch symbol missing: {symbol}")
            target_symbol = str(entry["target_symbol"])
            if (bank, target, target_symbol) not in declared_symbols:
                errors.append(
                    f"bank {bank}: dispatch target symbol missing: {target_symbol}"
                )
            dispatch_count += 1

    return errors, {
        "shared_bytes": shared_size,
        "service_count": len(document["shared_services"]) * 4,
        "dispatch_count": dispatch_count,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prg", required=True, type=Path)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--symbols", required=True, type=Path)
    args = parser.parse_args()
    try:
        errors, report = validate(
            args.prg.read_bytes(), load_json(args.manifest), load_json(args.symbols)
        )
    except (OSError, ValueError, KeyError, json.JSONDecodeError) as exc:
        print(f"[ERROR] common runtime audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] {report['shared_bytes']} common runtime bytes, "
        f"{report['service_count']} bank-qualified service symbols, "
        f"{report['dispatch_count']} bank-local dispatch entries and targets"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
