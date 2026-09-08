#!/usr/bin/env python3
"""Validate the World 1 directional camera-scrolling contract."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any


BANK_SIZE = 0x8000
CPU_BASE = 0x8000
EXPECTED_GEOMETRY = (8, 0xE0, 0xE2, 0xF0, 1, 2)
EXPECTED_UNDERGROUND_TRACKING = (0x6E, 0x82, 2, 0x6E, 0x92, 6, 0x07)
EXPECTED_STATE_FIELDS = [
    ("PpuScrollXShadow", 0x001B, 1, None),
    ("PpuScrollYShadow", 0x001C, 1, None),
    ("World1NametableX", 0x0058, 1, [0]),
    ("World1CameraTileX", 0x005B, 1, [0]),
    ("World1CameraTileY", 0x005C, 1, [0]),
    ("World1ScreenDeltaX", 0x0061, 1, [0]),
    ("World1ScreenDeltaY", 0x0062, 1, [0]),
    ("World1EdgeUpdateQueue", 0x025F, 1, [0]),
    ("World1UndergroundAxisScrollLimit", 0x0088, 1, [0]),
    ("World1UndergroundAxisScrollCoarse", 0x0089, 1, [0]),
    ("World1UndergroundAxisScrollFine", 0x008A, 1, [0]),
    ("World1UndergroundAxisScrollBudget", 0x008C, 1, [0]),
]
EXPECTED_ROUTINES = [
    (
        "World1_TryScrollCameraRight",
        0xA381,
        96,
        "right",
        [0x871F, 0x8722, 0xCF68],
    ),
    (
        "World1_TryScrollCameraLeft",
        0xA3E1,
        78,
        "left",
        [0x8712, 0x8715, 0xCF39],
    ),
    (
        "World1_TryScrollCameraDown",
        0xA42F,
        85,
        "down",
        [0x8738, 0x873B, 0xA859, 0xA86B, 0xD4DC],
    ),
    (
        "World1_TryScrollCameraUp",
        0xA484,
        66,
        "up",
        [0x872B, 0x872E, 0xA80D, 0xA81F, 0xD4AD],
    ),
    (
        "World1_TrackUndergroundHorizontalCamera",
        0xCF08,
        114,
        "track-horizontal",
        [0xCE6A],
    ),
    (
        "World1_TrackUndergroundVerticalCamera",
        0xD47C,
        114,
        "track-vertical",
        [0xD43E],
    ),
]


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def bank_bytes(prg: bytes, bank: int) -> bytes:
    if len(prg) != 4 * BANK_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    if not 0 <= bank < 4:
        raise ValueError("World 1 camera bank is outside PRG")
    start = bank * BANK_SIZE
    return prg[start:start + BANK_SIZE]


def routine_bytes(prg_bank: bytes, address: int, size: int) -> bytes:
    offset = address - CPU_BASE
    if not 0 <= offset <= len(prg_bank) - size:
        raise ValueError("World 1 camera routine is outside its bank")
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
    banks: list[int] | None,
) -> bool:
    matches = [
        entry for entry in registry.get("memory_symbols", [])
        if entry.get("name") == name
    ]
    return (
        len(matches) == 1
        and number(matches[0]["address"]) == address
        and int(matches[0].get("size", 1)) == size
        and matches[0].get("banks") == banks
    )


def validate_manifest(
    prg: bytes,
    manifest: dict[str, Any],
    registry: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if manifest.get("schema_version") != 1:
        return ["unsupported World 1 camera schema"], {}
    bank = int(manifest["bank"])
    if bank != 0:
        return ["World 1 camera must belong to PRG bank 0"], {}
    try:
        image = bank_bytes(prg, bank)
        geometry = manifest["geometry"]
        actual_geometry = (
            int(geometry["tile_pixels"]),
            number(geometry["max_tile_x"]),
            number(geometry["max_tile_y"]),
            number(geometry["vertical_scroll_wrap"]),
            int(geometry["column_queue_code"]),
            int(geometry["row_queue_code"]),
        )
        underground = manifest["underground_tracking"]
        horizontal_band = underground["horizontal_player_band"]
        vertical_band = underground["vertical_player_band"]
        actual_underground = (
            number(horizontal_band[0]),
            number(horizontal_band[1]),
            int(underground["horizontal_max_pixels_per_update"]),
            number(vertical_band[0]),
            number(vertical_band[1]),
            int(underground["vertical_max_pixels_per_update"]),
            number(underground["axis_fine_mask"]),
        )
        state_fields = manifest["state_fields"]
        actual_state = [
            (
                str(field["name"]),
                number(field["address"]),
                int(field["size"]),
                field["banks"],
            )
            for field in state_fields
        ]
        routines = manifest["routines"]
        actual_routines = [
            (
                str(routine["name"]),
                number(routine["address"]),
                int(routine["size"]),
                str(routine["direction"]),
                [number(site) for site in routine["callsites"]],
            )
            for routine in routines
        ]
    except (KeyError, TypeError, ValueError) as exc:
        return [str(exc)], {}
    errors: list[str] = []
    if actual_geometry != EXPECTED_GEOMETRY:
        errors.append("World 1 camera geometry differs")
    if actual_underground != EXPECTED_UNDERGROUND_TRACKING:
        errors.append("World 1 underground camera tracking differs")
    if actual_state != EXPECTED_STATE_FIELDS:
        errors.append("World 1 camera state layout differs")
    if actual_routines != EXPECTED_ROUTINES:
        errors.append("World 1 camera routine graph differs")
    for name, address, size, banks in actual_state:
        if not matching_memory_symbol(
            registry, name, address, size, banks
        ):
            errors.append(f"World 1 camera RAM symbol differs: {name}")
    for routine, actual in zip(routines, actual_routines):
        name, address, size, _direction, expected_calls = actual
        if not matching_prg_symbol(registry, name, address, bank):
            errors.append(f"World 1 camera routine symbol differs: {name}")
        signature = bytes.fromhex(str(routine["bytes"]))
        if len(signature) != size:
            errors.append(f"World 1 camera routine size differs: {name}")
        elif routine_bytes(image, address, size) != signature:
            errors.append(f"World 1 camera routine differs at ${address:04X}")
        if expected_calls != sorted(set(expected_calls)):
            errors.append(f"World 1 camera callsites are not canonical: {name}")
        if direct_jsr_callsites(image, address) != expected_calls:
            errors.append(f"World 1 camera direct callsites differ: {name}")
    return errors, {
        "state_byte_count": sum(
            size for _name, _address, size, _banks in actual_state
        ),
        "routine_count": len(routines),
        "routine_byte_count": sum(
            size for _name, _address, size, _direction, _calls in actual_routines
        ),
        "callsite_count": sum(
            len(calls)
            for _name, _address, _size, _direction, calls in actual_routines
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
        print(f"[ERROR] World 1 camera audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] World 1 camera: {report['state_byte_count']} state bytes, "
        f"{report['routine_count']} routines, "
        f"{report['routine_byte_count']} routine bytes, "
        f"{report['callsite_count']} direct callsites"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
