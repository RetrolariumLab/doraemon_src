#!/usr/bin/env python3
"""Validate the World 1 hierarchical-map decoder ABI and call graph."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any


BANK_SIZE = 0x8000
CPU_BASE = 0x8000
EXPECTED_RAM_FIELDS = [
    ("World1MapDataPointer", 0x0066, 2),
    ("World1CurrentSmallBlockPointer", 0x006A, 2),
    ("World1CurrentBigBlockPointer", 0x006C, 2),
    ("World1MapRowPointer", 0x006E, 2),
    ("World1TileQuadrantIndex", 0x0070, 1),
    ("World1SmallBlockQuadrantIndex", 0x0071, 1),
    ("World1MapColumnIndex", 0x0072, 1),
]
EXPECTED_ROUTINES = [
    (
        "World1_LookupMapTile",
        0xA6A7,
        [
            0x8B3F,
            0x905C,
            0x9BF3,
            0xA4C7,
            0xA565,
            0xA5CF,
            0xA64E,
            0xD1E9,
            0xDE86,
        ],
    ),
    (
        "World1_ReadCurrentMapTile",
        0xA6E2,
        [0x8B7A, 0x8B8E, 0x8BA9, 0x8BBD, 0xDD99],
    ),
    (
        "World1_ReadMapTileAndStepRight",
        0xA6E8,
        [0x8B6C, 0x8B73, 0x8B9B, 0x8BA2, 0xA5D4, 0xDD8B, 0xDD92],
    ),
    (
        "World1_ReadMapTileAndStepDown",
        0xA719,
        [0x8B87, 0x8BB6, 0xA4CC],
    ),
    ("World1_ReadBlockAttributeAndStepRight", 0xA74E, [0xA65B]),
    ("World1_ReadBlockAttributeAndStepDown", 0xA772, [0xA56E]),
    ("World1_SelectSmallBlock", 0xA79B, [0xA6DF, 0xA713, 0xA749]),
    (
        "World1_SelectBigBlock",
        0xA7B7,
        [0xA6D8, 0xA70C, 0xA742, 0xA76D, 0xA796],
    ),
]
EXPECTED_MAP_LOADS = [
    ("World1_CityMap", 0xB2EF, [0x8351, 0xD31C]),
    ("World1_UndergroundMap", 0xC2EF, [0xCE33, 0xD403]),
]
EXPECTED_DATA_SYMBOLS = [
    ("World1_BlockAttributes", 0xA9EF),
    ("World1_SmallBlocks", 0xAAEF),
    ("World1_BigBlocks", 0xAEEF),
    ("World1_CityMap", 0xB2EF),
    ("World1_UndergroundMap", 0xC2EF),
]
EXPECTED_WORLD_LAYOUT = (
    0,
    (0xA9EF, 256),
    (0xAAEF, 256, 2, 2),
    (0xAEEF, 256, 2, 2),
    (("city", 0xB2EF, 64, 64), ("underground", 0xC2EF, 64, 25)),
)


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def bank_bytes(prg: bytes, bank: int) -> bytes:
    if len(prg) != 4 * BANK_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    if not 0 <= bank < 4:
        raise ValueError("World 1 map-decoder bank is outside PRG")
    start = bank * BANK_SIZE
    return prg[start:start + BANK_SIZE]


def routine_bytes(prg_bank: bytes, address: int, size: int) -> bytes:
    offset = address - CPU_BASE
    if not 0 <= offset <= len(prg_bank) - size:
        raise ValueError("World 1 map-decoder routine is outside its bank")
    return prg_bank[offset:offset + size]


def pattern_sites(prg_bank: bytes, pattern: bytes) -> list[int]:
    return [
        CPU_BASE + offset
        for offset in range(len(prg_bank) - len(pattern) + 1)
        if prg_bank[offset:offset + len(pattern)] == pattern
    ]


def direct_jsr_callsites(prg_bank: bytes, target: int) -> list[int]:
    return pattern_sites(
        prg_bank,
        bytes((0x20, target & 0xFF, target >> 8)),
    )


def map_pointer_load_pattern(address: int) -> bytes:
    return bytes((
        0xA9,
        address & 0xFF,
        0x85,
        0x66,
        0xA9,
        address >> 8,
        0x85,
        0x67,
    ))


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


def world1_layout(world_data: dict[str, Any]) -> tuple[object, ...]:
    matches = [
        world for world in world_data.get("worlds", [])
        if world.get("id") == "world1"
    ]
    if len(matches) != 1:
        raise ValueError("expected one hierarchical world named 'world1'")
    world = matches[0]
    attributes = world["attributes"]
    small = world["small_blocks"]
    big = world["big_blocks"]
    maps = tuple(
        (
            str(spec["id"]),
            number(spec["address"]),
            int(spec["width"]),
            int(spec["height"]),
        )
        for spec in world["maps"]
    )
    return (
        int(world["bank"]),
        (number(attributes["address"]), int(attributes["count"])),
        (
            number(small["address"]),
            int(small["count"]),
            int(small["width"]),
            int(small["height"]),
        ),
        (
            number(big["address"]),
            int(big["count"]),
            int(big["width"]),
            int(big["height"]),
        ),
        maps,
    )


def validate_manifest(
    prg: bytes,
    manifest: dict[str, Any],
    registry: dict[str, Any],
    world_data: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if manifest.get("schema_version") != 1:
        return ["unsupported World 1 map-decoder schema"], {}
    bank = int(manifest["bank"])
    if bank != 0:
        return ["World 1 map decoder must belong to PRG bank 0"], {}
    try:
        image = bank_bytes(prg, bank)
        ram_fields = manifest["ram_fields"]
        routines = manifest["routines"]
        map_loads = manifest["map_pointer_loads"]
        actual_ram = [
            (
                str(field["name"]),
                number(field["address"]),
                int(field["size"]),
            )
            for field in ram_fields
        ]
        actual_routines = [
            (
                str(routine["name"]),
                number(routine["address"]),
                [number(site) for site in routine["callsites"]],
            )
            for routine in routines
        ]
        actual_map_loads = [
            (
                str(spec["name"]),
                number(spec["address"]),
                [number(site) for site in spec["sites"]],
            )
            for spec in map_loads
        ]
        hierarchy_layout = world1_layout(world_data)
    except (KeyError, TypeError, ValueError) as exc:
        return [str(exc)], {}
    errors: list[str] = []
    if actual_ram != EXPECTED_RAM_FIELDS:
        errors.append("World 1 map-decoder RAM layout differs")
    if actual_routines != EXPECTED_ROUTINES:
        errors.append("World 1 map-decoder routine graph differs")
    if actual_map_loads != EXPECTED_MAP_LOADS:
        errors.append("World 1 map-pointer load graph differs")
    if hierarchy_layout != EXPECTED_WORLD_LAYOUT:
        errors.append("World 1 hierarchical data layout differs")
    for name, address, size in actual_ram:
        if not matching_memory_symbol(
            registry, name, address, size, bank
        ):
            errors.append(f"World 1 map-decoder RAM symbol differs: {name}")
    for routine, actual in zip(routines, actual_routines):
        name, address, expected_calls = actual
        if not matching_prg_symbol(registry, name, address, bank):
            errors.append(f"World 1 map-decoder routine symbol differs: {name}")
        signature = bytes.fromhex(str(routine["bytes"]))
        if (
            not signature
            or routine_bytes(image, address, len(signature)) != signature
        ):
            errors.append(f"World 1 map-decoder routine differs at ${address:04X}")
        if expected_calls != sorted(set(expected_calls)):
            errors.append(f"World 1 map-decoder callsites are not canonical: {name}")
        if direct_jsr_callsites(image, address) != expected_calls:
            errors.append(f"World 1 map-decoder direct callsites differ: {name}")
    for name, address in EXPECTED_DATA_SYMBOLS:
        if not matching_prg_symbol(registry, name, address, bank):
            errors.append(f"World 1 hierarchy data symbol differs: {name}")
    for name, address, expected_sites in actual_map_loads:
        if pattern_sites(image, map_pointer_load_pattern(address)) != expected_sites:
            errors.append(f"World 1 map-pointer loads differ: {name}")
    return errors, {
        "routine_count": len(routines),
        "ram_byte_count": sum(size for _name, _address, size in actual_ram),
        "callsite_count": sum(len(calls) for _name, _address, calls in actual_routines),
        "map_selection_count": sum(
            len(sites) for _name, _address, sites in actual_map_loads
        ),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prg", required=True, type=Path)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--symbols", required=True, type=Path)
    parser.add_argument("--world-data", required=True, type=Path)
    args = parser.parse_args()
    try:
        errors, report = validate_manifest(
            args.prg.read_bytes(),
            json.loads(args.manifest.read_text(encoding="utf-8")),
            json.loads(args.symbols.read_text(encoding="utf-8")),
            json.loads(args.world_data.read_text(encoding="utf-8")),
        )
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 1 map-decoder audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] World 1 map decoder: {report['routine_count']} routines, "
        f"{report['ram_byte_count']} RAM bytes, "
        f"{report['callsite_count']} direct callsites, "
        f"{report['map_selection_count']} map selections"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
