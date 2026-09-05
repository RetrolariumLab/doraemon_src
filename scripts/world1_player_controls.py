#!/usr/bin/env python3
"""Validate World 1 player controls, weapon update, and map collision."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any


BANK_SIZE = 0x8000
CPU_BASE = 0x8000
EXPECTED_CONTROLS = (
    ["up", "down", "left", "right"],
    [0x08, 0x04, 0x02, 0x01],
    [1, 0, 2, 3],
    2,
    0x05,
    0xEB,
    0x28,
    0xC8,
    5,
    6,
    0x16,
    0x42,
    [3, 3, 2, 2],
    0x40,
    6,
    8,
)
EXPECTED_STATE_FIELDS = [
    ("CombinedControllerButtons", 0x0021, 1, None),
    ("World1WeaponPoseTimer", 0x0063, 1, [0]),
    ("World1PreviousButtons", 0x0064, 1, [0]),
    ("World1PressedButtons", 0x0065, 1, [0]),
    ("World1PlayerX", 0x0075, 1, [0]),
    ("World1PlayerY", 0x0076, 1, [0]),
    ("World1PlayerMetasprite", 0x0077, 1, [0]),
    ("World1PlayerRenderFlags", 0x0078, 1, [0]),
    ("World1PlayerDamageState", 0x0079, 1, [0]),
    ("World1PlayerAnimationCounter", 0x007A, 1, [0]),
    ("World1WeaponLevel", 0x007B, 1, [0]),
    ("World1PlayerDirection", 0x007F, 1, [0]),
    ("World1ProjectileMaxSlot", 0x0084, 1, [0]),
]
EXPECTED_ROUTINES = [
    ("World1_UpdateCityPlayer", 0x856C, 396, [0x82CD]),
    (
        "World1_RollbackCityPlayerOnCollision",
        0x86F8,
        14,
        [
            0x8627,
            0x862E,
            0x8635,
            0x8655,
            0x865C,
            0x8663,
            0x8683,
            0x868A,
            0x86AA,
            0x86B1,
        ],
    ),
    ("World1_UpdateWeaponAndTryFire", 0x9BFC, 135, [0x856C, 0xCF7A]),
    (
        "World1_TestPlayerMapCollisionAtOffset",
        0xD1C3,
        44,
        [
            0x86F8,
            0xD055,
            0xD05E,
            0xD067,
            0xD0A3,
            0xD0AC,
            0xD0B5,
            0xD121,
            0xD12A,
            0xD177,
            0xD180,
            0xD18A,
            0xD193,
        ],
    ),
]


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def bank_bytes(prg: bytes, bank: int) -> bytes:
    if len(prg) != 4 * BANK_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    if not 0 <= bank < 4:
        raise ValueError("World 1 player-controls bank is outside PRG")
    start = bank * BANK_SIZE
    return prg[start:start + BANK_SIZE]


def routine_bytes(prg_bank: bytes, address: int, size: int) -> bytes:
    offset = address - CPU_BASE
    if not 0 <= offset <= len(prg_bank) - size:
        raise ValueError("World 1 player-controls routine is outside its bank")
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


def controls_layout(controls: dict[str, Any]) -> tuple[object, ...]:
    return (
        [str(value) for value in controls["direction_priority"]],
        [number(value) for value in controls["direction_button_masks"]],
        [int(value) for value in controls["direction_values"]],
        int(controls["pixels_per_update"]),
        number(controls["player_x_min"]),
        number(controls["player_x_max"]),
        number(controls["player_y_min"]),
        number(controls["player_y_max"]),
        int(controls["animation_divider"]),
        int(controls["hit_recovery_control_unlock"]),
        number(controls["hit_recovery_end"]),
        number(controls["solid_metatile_first"]),
        [int(value) for value in controls["collision_probe_counts"]],
        number(controls["fire_button_mask"]),
        int(controls["weapon_pose_frames"]),
        int(controls["projectile_slot_capacity"]),
    )


def validate_manifest(
    prg: bytes,
    manifest: dict[str, Any],
    registry: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if manifest.get("schema_version") != 1:
        return ["unsupported World 1 player-controls schema"], {}
    bank = int(manifest["bank"])
    if bank != 0:
        return ["World 1 player controls must belong to PRG bank 0"], {}
    try:
        image = bank_bytes(prg, bank)
        actual_controls = controls_layout(manifest["controls"])
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
                [number(site) for site in routine["callsites"]],
            )
            for routine in routines
        ]
    except (KeyError, TypeError, ValueError) as exc:
        return [str(exc)], {}
    errors: list[str] = []
    if actual_controls != EXPECTED_CONTROLS:
        errors.append("World 1 player-controls constants differ")
    if actual_state != EXPECTED_STATE_FIELDS:
        errors.append("World 1 player-controls state layout differs")
    if actual_routines != EXPECTED_ROUTINES:
        errors.append("World 1 player-controls routine graph differs")
    for name, address, size, banks in actual_state:
        if not matching_memory_symbol(
            registry, name, address, size, banks
        ):
            errors.append(f"World 1 player-controls RAM symbol differs: {name}")
    for routine, actual in zip(routines, actual_routines):
        name, address, size, expected_calls = actual
        if not matching_prg_symbol(registry, name, address, bank):
            errors.append(f"World 1 player-controls symbol differs: {name}")
        signature = bytes.fromhex(str(routine["bytes"]))
        if len(signature) != size:
            errors.append(f"World 1 player-controls routine size differs: {name}")
        elif routine_bytes(image, address, size) != signature:
            errors.append(
                f"World 1 player-controls routine differs at ${address:04X}"
            )
        if expected_calls != sorted(set(expected_calls)):
            errors.append(
                f"World 1 player-controls callsites are not canonical: {name}"
            )
        if direct_jsr_callsites(image, address) != expected_calls:
            errors.append(f"World 1 player-controls callsites differ: {name}")
    return errors, {
        "state_byte_count": sum(
            size for _name, _address, size, _banks in actual_state
        ),
        "routine_count": len(routines),
        "routine_byte_count": sum(
            size for _name, _address, size, _calls in actual_routines
        ),
        "callsite_count": sum(
            len(calls) for _name, _address, _size, calls in actual_routines
        ),
        "collision_probe_count": sum(actual_controls[12]),
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
        print(f"[ERROR] World 1 player-controls audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] World 1 player controls: {report['state_byte_count']} state bytes, "
        f"{report['collision_probe_count']} collision probes, "
        f"{report['routine_count']} routines, "
        f"{report['routine_byte_count']} routine bytes, "
        f"{report['callsite_count']} direct callsites"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
