#!/usr/bin/env python3
"""Validate the World 1 pseudorandom generators and their RAM ownership."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any


BANK_SIZE = 0x8000
CPU_BASE = 0x8000
EXPECTED_GENERATORS = [
    ("World1_FrameRandomByte", 0x962F, "World1FrameRandomState", 0x0052, 2, True),
    ("World1_RandomByte", 0x964A, "World1RandomState", 0x0054, 4, False),
]


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def bank_bytes(prg: bytes, bank: int) -> bytes:
    if len(prg) != 4 * BANK_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    if not 0 <= bank < 4:
        raise ValueError("World 1 random-generator bank is outside PRG")
    start = bank * BANK_SIZE
    return prg[start:start + BANK_SIZE]


def routine_bytes(prg_bank: bytes, address: int, size: int) -> bytes:
    offset = address - CPU_BASE
    if not 0 <= offset <= len(prg_bank) - size:
        raise ValueError("World 1 random-generator routine is outside its bank")
    return prg_bank[offset:offset + size]


def direct_jsr_callsites(prg_bank: bytes, target: int) -> list[int]:
    low, high = target & 0xFF, target >> 8
    return [
        CPU_BASE + offset
        for offset in range(len(prg_bank) - 2)
        if prg_bank[offset:offset + 3] == bytes((0x20, low, high))
    ]


def matching_symbol(
    registry: dict[str, Any],
    section: str,
    name: str,
    address: int,
    bank: int,
    size: int = 1,
) -> bool:
    matches = [
        entry for entry in registry.get(section, [])
        if entry.get("name") == name
    ]
    if len(matches) != 1:
        return False
    actual = matches[0]
    if number(actual["address"]) != address:
        return False
    if section == "memory_symbols":
        return (
            int(actual.get("size", 1)) == size
            and actual.get("banks") == [bank]
        )
    return int(actual.get("bank", -1)) == bank


def validate_manifest(
    prg: bytes,
    manifest: dict[str, Any],
    registry: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if manifest.get("schema_version") != 1:
        return ["unsupported World 1 random-generator schema"], {}
    bank = int(manifest["bank"])
    if bank != 0:
        return ["World 1 random generators must belong to PRG bank 0"], {}
    try:
        image = bank_bytes(prg, bank)
        generators = manifest["generators"]
        actual_layout = [
            (
                str(generator["name"]),
                number(generator["address"]),
                str(generator["state"]["name"]),
                number(generator["state"]["address"]),
                int(generator["state"]["size"]),
                bool(generator["mixes_frame_counter"]),
            )
            for generator in generators
        ]
    except (KeyError, TypeError, ValueError) as exc:
        return [str(exc)], {}
    errors: list[str] = []
    if actual_layout != EXPECTED_GENERATORS:
        errors.append("World 1 random-generator layout differs")
    for generator in generators:
        name = str(generator["name"])
        address = number(generator["address"])
        state = generator["state"]
        state_name = str(state["name"])
        state_address = number(state["address"])
        state_size = int(state["size"])
        if not matching_symbol(
            registry, "symbols", name, address, bank
        ):
            errors.append(f"World 1 random routine symbol differs: {name}")
        if not matching_symbol(
            registry,
            "memory_symbols",
            state_name,
            state_address,
            bank,
            state_size,
        ):
            errors.append(f"World 1 random RAM symbol differs: {state_name}")
        signature = bytes.fromhex(str(generator["bytes"]))
        if not signature or routine_bytes(image, address, len(signature)) != signature:
            errors.append(f"World 1 random routine differs at ${address:04X}")
        expected_calls = [number(value) for value in generator["callsites"]]
        if expected_calls != sorted(set(expected_calls)):
            errors.append(f"World 1 random callsite list is not canonical: {name}")
        if direct_jsr_callsites(image, address) != expected_calls:
            errors.append(f"World 1 random direct callsites differ: {name}")
    return errors, {
        "generator_count": len(generators),
        "state_byte_count": sum(
            int(generator["state"]["size"]) for generator in generators
        ),
        "callsite_count": sum(
            len(generator["callsites"]) for generator in generators
        ),
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
        print(f"[ERROR] World 1 random-generator audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] World 1 random generators: {report['generator_count']} routines, "
        f"{report['state_byte_count']} state bytes, "
        f"{report['callsite_count']} direct callsites"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
