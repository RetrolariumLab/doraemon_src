#!/usr/bin/env python3
"""Validate World 1 camera tracking and entity projection."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any


BANK_SIZE = 0x8000
CPU_BASE = 0x8000
EXPECTED_GEOMETRY = (0x50, 0xA0, 0x48, 0x90, 2, 48, 0x40, 0x20, 0x40)
EXPECTED_STATE_FIELDS = [
    ("World1ScreenDeltaX", 0x0061, 1),
    ("World1ScreenDeltaY", 0x0062, 1),
    ("World1PlayerX", 0x0075, 1),
    ("World1PlayerY", 0x0076, 1),
    ("World1EntityType", 0x0400, 48),
    ("World1EntityPositionHigh", 0x0490, 48),
    ("World1EntityX", 0x04C0, 48),
    ("World1EntityY", 0x04F0, 48),
    ("World1EntitySourceObjectId", 0x0520, 48),
]
EXPECTED_ROUTINES = [
    (
        "World1_UpdateCameraFromPlayer",
        0x8706,
        74,
        [0x82D6, 0xCCD1, 0xD28C],
        None,
    ),
    (
        "World1_ApplyCameraDeltaToEntities",
        0x8750,
        168,
        [0x874C, 0xA816, 0xA828, 0xA862, 0xA874, 0xCF76, 0xD4EA],
        "World1_CullOffscreenEntities",
    ),
    (
        "World1_CullOffscreenEntities",
        0x87F8,
        84,
        [0xD44D, 0xD57B, 0xD5D0],
        None,
    ),
]


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def bank_bytes(prg: bytes, bank: int) -> bytes:
    if len(prg) != 4 * BANK_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    if not 0 <= bank < 4:
        raise ValueError("World 1 camera-entity bank is outside PRG")
    start = bank * BANK_SIZE
    return prg[start:start + BANK_SIZE]


def routine_bytes(prg_bank: bytes, address: int, size: int) -> bytes:
    offset = address - CPU_BASE
    if not 0 <= offset <= len(prg_bank) - size:
        raise ValueError("World 1 camera-entity routine is outside its bank")
    return prg_bank[offset:offset + size]


def direct_jsr_callsites(prg_bank: bytes, target: int) -> list[int]:
    pattern = bytes((0x20, target & 0xFF, target >> 8))
    return [
        CPU_BASE + offset
        for offset in range(len(prg_bank) - 2)
        if prg_bank[offset:offset + 3] == pattern
    ]


def matching_prg_symbol(
    registry: dict[str, Any],
    name: str,
    address: int,
    bank: int,
) -> bool:
    matches = [
        entry for entry in registry.get("symbols", [])
        if entry.get("name") == name
    ]
    return (
        len(matches) == 1
        and number(matches[0]["address"]) == address
        and int(matches[0].get("bank", -1)) == bank
    )


def matching_memory_symbol(
    registry: dict[str, Any],
    name: str,
    address: int,
    size: int,
    bank: int,
) -> bool:
    matches = [
        entry for entry in registry.get("memory_symbols", [])
        if entry.get("name") == name
    ]
    return (
        len(matches) == 1
        and number(matches[0]["address"]) == address
        and int(matches[0].get("size", 1)) == size
        and matches[0].get("banks") == [bank]
    )


def validate_manifest(
    prg: bytes,
    manifest: dict[str, Any],
    registry: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if manifest.get("schema_version") != 1:
        return ["unsupported World 1 camera-entity schema"], {}
    bank = int(manifest["bank"])
    if bank != 0:
        return ["World 1 camera entities must belong to PRG bank 0"], {}
    try:
        image = bank_bytes(prg, bank)
        geometry = manifest["geometry"]
        actual_geometry = (
            number(geometry["player_x_scroll_left_below"]),
            number(geometry["player_x_scroll_right_at"]),
            number(geometry["player_y_scroll_up_below"]),
            number(geometry["player_y_scroll_down_at"]),
            int(geometry["camera_pixels_per_update"]),
            int(geometry["entity_slot_count"]),
            number(geometry["horizontal_margin"]),
            number(geometry["vertical_positive_margin"]),
            number(geometry["vertical_negative_margin"]),
        )
        state_fields = manifest["state_fields"]
        actual_state = [
            (
                str(field["name"]),
                number(field["address"]),
                int(field["size"]),
            )
            for field in state_fields
        ]
        routines = manifest["routines"]
        actual_routines = [
            (
                str(routine["name"]),
                number(routine["address"]),
                int(routine["size"]),
                [number(site) for site in routine["callsites"]],
                routine.get("falls_through_to"),
            )
            for routine in routines
        ]
    except (KeyError, TypeError, ValueError) as exc:
        return [str(exc)], {}
    errors: list[str] = []
    if actual_geometry != EXPECTED_GEOMETRY:
        errors.append("World 1 camera-entity geometry differs")
    if actual_state != EXPECTED_STATE_FIELDS:
        errors.append("World 1 camera-entity state layout differs")
    if actual_routines != EXPECTED_ROUTINES:
        errors.append("World 1 camera-entity routine graph differs")
    addresses = {name: address for name, address, _size, _calls, _fall in actual_routines}
    for name, address, size in actual_state:
        if not matching_memory_symbol(registry, name, address, size, bank):
            errors.append(f"World 1 camera-entity RAM symbol differs: {name}")
    for routine, actual in zip(routines, actual_routines):
        name, address, size, expected_calls, fallthrough = actual
        if not matching_prg_symbol(registry, name, address, bank):
            errors.append(f"World 1 camera-entity symbol differs: {name}")
        signature = bytes.fromhex(str(routine["bytes"]))
        if len(signature) != size:
            errors.append(f"World 1 camera-entity routine size differs: {name}")
        elif routine_bytes(image, address, size) != signature:
            errors.append(
                f"World 1 camera-entity routine differs at ${address:04X}"
            )
        if expected_calls != sorted(set(expected_calls)):
            errors.append(
                f"World 1 camera-entity callsites are not canonical: {name}"
            )
        if direct_jsr_callsites(image, address) != expected_calls:
            errors.append(f"World 1 camera-entity callsites differ: {name}")
        if fallthrough is not None and addresses.get(str(fallthrough)) != address + size:
            errors.append(f"World 1 camera-entity fallthrough differs: {name}")
    return errors, {
        "state_byte_count": sum(
            size for _name, _address, size in actual_state
        ),
        "routine_count": len(routines),
        "routine_byte_count": sum(
            size for _name, _address, size, _calls, _fall in actual_routines
        ),
        "callsite_count": sum(
            len(calls)
            for _name, _address, _size, calls, _fall in actual_routines
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
        print(f"[ERROR] World 1 camera-entity audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] World 1 camera entities: {report['state_byte_count']} state bytes, "
        f"{report['routine_count']} routines, "
        f"{report['routine_byte_count']} routine bytes, "
        f"{report['callsite_count']} direct callsites"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
