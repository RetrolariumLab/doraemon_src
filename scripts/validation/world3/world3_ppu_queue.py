#!/usr/bin/env python3
"""Validate the World 3 PPU update queue and its symbol ownership."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any


BANK_SIZE = 0x8000
CPU_BASE = 0x8000


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("World 3 PPU queue range is outside PRG")
    return prg[offset:offset + size]


def unique_names(entries: list[dict[str, Any]], description: str) -> list[str]:
    names = [str(entry["name"]) for entry in entries]
    return [] if len(names) == len(set(names)) else [f"{description} names are duplicated"]


def symbol_matches(
    registry: dict[str, Any],
    section: str,
    expected: dict[str, Any],
    bank: int,
) -> bool:
    matches = [
        entry for entry in registry.get(section, [])
        if entry.get("name") == expected["name"]
    ]
    if len(matches) != 1:
        return False
    actual = matches[0]
    if number(actual["address"]) != number(expected["address"]):
        return False
    if section == "memory_symbols":
        return (
            int(actual.get("size", 1)) == int(expected["size"])
            and actual.get("banks") == [bank]
        )
    return int(actual.get("bank", -1)) == bank


def validate_geometry(queue: dict[str, Any]) -> tuple[list[str], int]:
    errors: list[str] = []
    offsets = [
        int(queue["address_high_offset"]),
        int(queue["address_low_offset"]),
        int(queue["length_offset"]),
        int(queue["payload_offset"]),
    ]
    if int(queue["size"]) != 0x100 or number(queue["address"]) != 0x0500:
        errors.append("World 3 PPU queue ring geometry differs")
    if int(queue["header_size"]) != 3 or offsets != [0, 1, 2, 3]:
        errors.append("World 3 PPU queue record offsets differ")
    increment_flag = number(queue["vertical_increment_flag"])
    address_mask = number(queue["address_high_mask"])
    if increment_flag != 0x80 or address_mask != 0x7F or increment_flag & address_mask:
        errors.append("World 3 PPU queue address flag contract differs")
    if number(queue["ppu_increment_control_bit"]) != 0x04:
        errors.append("World 3 PPU queue PPU-control increment bit differs")
    maximum_record_size = int(queue["header_size"]) + int(queue["maximum_payload_size"])
    guard = number(queue["capacity_guard"])
    if (
        int(queue["maximum_payload_size"]) != 0x20
        or guard != 0x24
        or not maximum_record_size < guard <= int(queue["size"])
    ):
        errors.append("World 3 PPU queue capacity guard differs or is unsafe")
    if int(queue["records_per_drain"]) != 1 or number(queue["payload_threshold"]) != 0x30:
        errors.append("World 3 PPU queue drain budget differs")
    return errors, maximum_record_size


def validate_manifest(
    prg: bytes,
    manifest: dict[str, Any],
    registry: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if manifest.get("schema_version") != 1:
        return ["unsupported World 3 PPU queue schema"], {}
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    bank = int(manifest["bank"])
    if bank != 2:
        return ["World 3 PPU queue must belong to PRG bank 2"], {}
    errors, maximum_record_size = validate_geometry(manifest["queue"])
    memory_layout = manifest["memory_layout"]
    routines = manifest["routines"]
    signatures = manifest["signatures"]
    errors.extend(unique_names(memory_layout, "World 3 PPU memory-layout"))
    errors.extend(unique_names(routines, "World 3 PPU routine"))
    errors.extend(unique_names(signatures, "World 3 PPU signature"))
    for entry in memory_layout:
        if not symbol_matches(registry, "memory_symbols", entry, bank):
            errors.append(f"World 3 PPU RAM symbol differs: {entry['name']}")
    for entry in routines:
        if not symbol_matches(registry, "symbols", entry, bank):
            errors.append(f"World 3 PPU routine symbol differs: {entry['name']}")
    queue_symbols = [
        entry for entry in memory_layout if entry["name"] == "World3PpuQueue"
    ]
    if len(queue_symbols) != 1 or (
        number(queue_symbols[0]["address"]) != number(manifest["queue"]["address"])
        or int(queue_symbols[0]["size"]) != int(manifest["queue"]["size"])
    ):
        errors.append("World 3 PPU queue RAM symbol and geometry differ")
    for signature in signatures:
        raw = bytes.fromhex(str(signature["bytes"]))
        if not raw:
            errors.append(f"World 3 PPU signature is empty: {signature['name']}")
        elif bank_slice(prg, bank, number(signature["address"]), len(raw)) != raw:
            errors.append(
                f"World 3 PPU signature differs at ${number(signature['address']):04X}"
            )
    return errors, {
        "queue_size": int(manifest["queue"]["size"]),
        "maximum_record_size": maximum_record_size,
        "memory_symbol_count": len(memory_layout),
        "routine_count": len(routines),
        "signature_count": len(signatures),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prg", required=True, type=Path)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--symbols", required=True, type=Path)
    args = parser.parse_args()
    try:
        errors, report = validate_manifest(
            args.prg.read_bytes(),
            json.loads(args.manifest.read_text(encoding="utf-8")),
            json.loads(args.symbols.read_text(encoding="utf-8")),
        )
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 3 PPU queue audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] World 3 PPU queue: {report['queue_size']}-byte ring, "
        f"{report['maximum_record_size']}-byte maximum record, "
        f"{report['memory_symbol_count']} RAM symbols, "
        f"{report['routine_count']} routines, "
        f"{report['signature_count']} code signatures"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
