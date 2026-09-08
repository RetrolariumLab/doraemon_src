#!/usr/bin/env python3
"""Validate World 1 map-streaming PPU packets and their producer graph."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any


BANK_SIZE = 0x8000
CPU_BASE = 0x8000
EXPECTED_RAM_FIELDS = [
    ("World1ColumnUpdateFlags", 0x0230, 1),
    ("World1ColumnTilePpuAddress", 0x0231, 2),
    ("World1ColumnTileData", 0x0233, 30),
    ("World1ColumnAttributePpuAddress", 0x0253, 2),
    ("World1ColumnAttributeData", 0x0255, 8),
    ("World1ColumnAddressScratch", 0x025E, 1),
    ("World1EdgeUpdateQueue", 0x025F, 1),
    ("World1RowUpdateFlags", 0x0260, 1),
    ("World1RowTilePpuAddress", 0x0261, 2),
    ("World1RowTileData", 0x0263, 33),
    ("World1RowAttributePpuAddress", 0x0284, 2),
    ("World1RowAttributeData", 0x0286, 9),
]
EXPECTED_PACKETS = [
    (
        "column",
        1,
        0x0230,
        1,
        0x0231,
        0x0233,
        30,
        32,
        2,
        0x0253,
        0x0255,
        8,
    ),
    (
        "row",
        2,
        0x0260,
        1,
        0x0261,
        0x0263,
        33,
        1,
        2,
        0x0284,
        0x0286,
        9,
    ),
]
EXPECTED_QUEUE = (0x025F, 4, 2)
EXPECTED_ROUTINES = [
    ("World1_BuildColumnTileUpdate", 0xA4C6, 68, [0xA3BA, 0xA416]),
    (
        "World1_BuildColumnAttributeUpdate",
        0xA50A,
        197,
        [0xA3D1, 0xA429],
    ),
    ("World1_BuildRowTileUpdate", 0xA5CF, 60, [0xA45D, 0xA4AE]),
    (
        "World1_BuildRowAttributeUpdate",
        0xA60B,
        156,
        [0xA473, 0xA4C0],
    ),
    (
        "World1_PrefillMapViewport",
        0xA7DB,
        163,
        [0x82B8, 0xCD72, 0xCE49, 0xCEDC, 0xCEFF, 0xD359, 0xD41A],
    ),
    (
        "World1_DrainMapPpuUpdates",
        0xA87E,
        369,
        [0x84E8, 0xA810, 0xA822, 0xA85C, 0xA86E],
    ),
]


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def bank_bytes(prg: bytes, bank: int) -> bytes:
    if len(prg) != 4 * BANK_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    if not 0 <= bank < 4:
        raise ValueError("World 1 PPU-streaming bank is outside PRG")
    start = bank * BANK_SIZE
    return prg[start:start + BANK_SIZE]


def routine_bytes(prg_bank: bytes, address: int, size: int) -> bytes:
    offset = address - CPU_BASE
    if not 0 <= offset <= len(prg_bank) - size:
        raise ValueError("World 1 PPU-streaming routine is outside its bank")
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


def packet_layout(packet: dict[str, Any]) -> tuple[object, ...]:
    return (
        str(packet["axis"]),
        int(packet["queue_code"]),
        number(packet["flags_address"]),
        int(packet["tile_flag"]),
        number(packet["tile_address"]),
        number(packet["tile_data"]),
        int(packet["tile_count"]),
        int(packet["tile_ppu_increment"]),
        int(packet["attribute_flag"]),
        number(packet["attribute_address"]),
        number(packet["attribute_data"]),
        int(packet["attribute_count"]),
    )


def validate_manifest(
    prg: bytes,
    manifest: dict[str, Any],
    registry: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if manifest.get("schema_version") != 1:
        return ["unsupported World 1 PPU-streaming schema"], {}
    bank = int(manifest["bank"])
    if bank != 0:
        return ["World 1 PPU streaming must belong to PRG bank 0"], {}
    try:
        image = bank_bytes(prg, bank)
        ram_fields = manifest["ram_fields"]
        packets = manifest["packets"]
        queue = manifest["queue"]
        routines = manifest["routines"]
        actual_ram = [
            (
                str(field["name"]),
                number(field["address"]),
                int(field["size"]),
            )
            for field in ram_fields
        ]
        actual_packets = [packet_layout(packet) for packet in packets]
        actual_queue = (
            number(queue["address"]),
            int(queue["entry_bits"]),
            int(queue["capacity"]),
        )
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
    if actual_ram != EXPECTED_RAM_FIELDS:
        errors.append("World 1 PPU-streaming RAM layout differs")
    if actual_packets != EXPECTED_PACKETS:
        errors.append("World 1 PPU packet geometry differs")
    if actual_queue != EXPECTED_QUEUE:
        errors.append("World 1 edge-update queue geometry differs")
    if actual_routines != EXPECTED_ROUTINES:
        errors.append("World 1 PPU-streaming routine graph differs")
    for name, address, size in actual_ram:
        if not matching_memory_symbol(
            registry, name, address, size, bank
        ):
            errors.append(f"World 1 PPU-streaming RAM symbol differs: {name}")
    for routine, actual in zip(routines, actual_routines):
        name, address, size, expected_calls = actual
        if not matching_prg_symbol(registry, name, address, bank):
            errors.append(f"World 1 PPU-streaming routine symbol differs: {name}")
        signature = bytes.fromhex(str(routine["bytes"]))
        if len(signature) != size:
            errors.append(f"World 1 PPU-streaming routine size differs: {name}")
        elif routine_bytes(image, address, size) != signature:
            errors.append(f"World 1 PPU-streaming routine differs at ${address:04X}")
        if expected_calls != sorted(set(expected_calls)):
            errors.append(f"World 1 PPU-streaming callsites are not canonical: {name}")
        if direct_jsr_callsites(image, address) != expected_calls:
            errors.append(f"World 1 PPU-streaming direct callsites differ: {name}")
    return errors, {
        "packet_count": len(packets),
        "ram_byte_count": sum(size for _name, _address, size in actual_ram),
        "routine_count": len(routines),
        "callsite_count": sum(
            len(calls) for _name, _address, _size, calls in actual_routines
        ),
        "tile_byte_count": sum(int(packet["tile_count"]) for packet in packets),
        "attribute_byte_count": sum(
            int(packet["attribute_count"]) for packet in packets
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
        print(f"[ERROR] World 1 PPU-streaming audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] World 1 PPU streaming: {report['packet_count']} packets, "
        f"{report['tile_byte_count']} tile bytes, "
        f"{report['attribute_byte_count']} attribute bytes, "
        f"{report['ram_byte_count']} RAM bytes, "
        f"{report['routine_count']} routines, "
        f"{report['callsite_count']} direct callsites"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
