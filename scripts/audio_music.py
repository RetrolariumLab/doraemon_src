#!/usr/bin/env python3
"""Validate the shared four-channel music ABI and command grammar."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any
import zlib


BANK_SIZE = 0x8000
CPU_BASE = 0x8000
EXPECTED_COMMANDS = [
    (0xFF, 0, "EndChannel"),
    (0xFE, 0, "RestoreStreamPosition"),
    (0xFD, 1, "BeginCountedLoop"),
    (0xFC, 0, "RepeatCountedLoop"),
    (0xFB, 1, "SelectLoopExit"),
    (0xFA, 1, "EnableFixedPitch"),
    (0xF9, 0, "DisableFixedPitch"),
    (0xF8, 1, "SetDutyCycle"),
    (0xF7, 0, "SaveStreamPosition"),
    (0xF6, 2, "CallStream"),
    (0xF5, 1, "SetGlobalPitchOffset"),
    (0xF4, 1, "SetChannelPitchOffset"),
    (0xF3, 0, "ReturnFromStream"),
    (0xF2, 0, "ResetLengthBits"),
    (0xF1, 0, "SelectTrackChannelStream"),
    (0xF0, 1, "LoadExtendedNote"),
    (0xEF, 1, "SetEnvelopeVolume"),
]
EXPECTED_DRIVERS = {
    0: ("world1-audio", "World1_", 9, 0xE9FD),
    1: ("world2-audio", "World2_", 7, 0xACE4),
    2: ("world3-audio", "World3_", 9, 0xC4F5),
    3: ("shell-audio", "", 5, 0x9ED8),
}
EXPECTED_OVERLAY = [
    (
        0x0046,
        3,
        "global-tonal-channel-pitch-offsets",
        "reused-by-chapter-rendering-and-streaming-outside-audio-update",
    )
]


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def crc32(data: bytes) -> str:
    return f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    if len(prg) != 4 * BANK_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError(f"audio range is outside bank {bank}: ${address:04X}")
    return prg[offset:offset + size]


def command_rows(document: dict[str, Any]) -> list[tuple[int, int, str]]:
    return [
        (number(item["opcode"]), int(item["operand_bytes"]), str(item["name"]))
        for item in document["commands"]
    ]


def memory_symbol_matches(
    registry: dict[str, Any], address: int, size: int, name: str
) -> bool:
    matches = [
        item
        for item in registry.get("memory_symbols", [])
        if item.get("name") == name
    ]
    return (
        len(matches) == 1
        and number(matches[0]["address"]) == address
        and int(matches[0].get("size", 1)) == size
        and matches[0].get("banks") is None
    )


def prg_symbol_matches(
    registry: dict[str, Any], bank: int, address: int, name: str
) -> bool:
    matches = [
        item
        for item in registry.get("symbols", [])
        if item.get("name") == name
    ]
    return (
        len(matches) == 1
        and int(matches[0]["bank"]) == bank
        and number(matches[0]["address"]) == address
        and matches[0].get("operand_symbol", False) is False
    )


def dispatch_by_bank(document: dict[str, Any]) -> dict[int, dict[str, Any]]:
    drivers = [
        {key: value for key, value in document.items() if key != "additional_drivers"},
        *document.get("additional_drivers", []),
    ]
    return {int(driver["bank"]): driver for driver in drivers}


def validate_manifest(
    prg: bytes,
    document: dict[str, Any],
    dispatch: dict[str, Any],
    registry: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    errors: list[str] = []
    if document.get("schema_version") != 1:
        return ["unsupported audio music schema"], {}
    if document.get("channel_count") != 4:
        errors.append("audio channel count differs")
    try:
        commands = command_rows(document)
        drivers = document["drivers"]
        ram = document["shared_ram"]
        overlays = [
            (
                number(item["address"]),
                int(item["size"]),
                str(item["role"]),
                str(item["reason"]),
            )
            for item in document["overlaid_ram"]
        ]
        dispatches = dispatch_by_bank(dispatch)
    except (KeyError, TypeError, ValueError) as exc:
        return [str(exc)], {}
    if commands != EXPECTED_COMMANDS:
        errors.append("audio command grammar differs")
    if overlays != EXPECTED_OVERLAY:
        errors.append("audio RAM overlay contract differs")

    ram_bytes = 0
    previous_end = -1
    for item in ram:
        address = number(item["address"])
        size = int(item["size"])
        name = str(item["symbol"])
        if address <= previous_end or size <= 0:
            errors.append(f"audio RAM fields overlap or are unordered: {name}")
        previous_end = address + size - 1
        ram_bytes += size
        if not memory_symbol_matches(registry, address, size, name):
            errors.append(f"audio RAM symbol differs: {name}")

    routine_bytes = 0
    command_targets = 0
    if [int(driver.get("bank", -1)) for driver in drivers] != list(range(4)):
        errors.append("audio drivers are not ordered by bank")
    for driver in drivers:
        bank = int(driver["bank"])
        identity = (
            str(driver["name"]),
            str(driver["symbol_prefix"]),
            int(driver["track_count"]),
            number(driver["music_update"]),
        )
        if EXPECTED_DRIVERS.get(bank) != identity:
            errors.append(f"audio driver identity differs for bank {bank}")
            continue
        _driver_name, prefix, track_count, music_update = identity
        if bank_slice(prg, bank, music_update + 0x12, 2) != bytes(
            (0xC9, track_count)
        ):
            errors.append(f"audio track limit differs for bank {bank}")
        dispatch_driver = dispatches.get(bank)
        if dispatch_driver is None:
            errors.append(f"audio dispatch is missing bank {bank}")
            continue
        table = dispatch_driver["music_command_table"]
        targets = [number(target) for target in table["targets"]]
        if (
            number(table["first_command"]) != 0xFF
            or number(table["last_command"]) != 0xEF
            or int(table["slot_count"]) != len(EXPECTED_COMMANDS)
            or len(targets) != len(EXPECTED_COMMANDS)
        ):
            errors.append(f"audio command dispatch geometry differs for bank {bank}")
            continue
        for target, (_opcode, _operands, role) in zip(
            targets, EXPECTED_COMMANDS, strict=True
        ):
            name = f"{prefix}MusicCommand_{role}"
            if not prg_symbol_matches(registry, bank, target, name):
                errors.append(f"audio command symbol differs: bank {bank} {name}")
            command_targets += 1
        for routine in driver["routines"]:
            address = number(routine["address"])
            size = int(routine["size"])
            name = str(routine["symbol"])
            raw = bank_slice(prg, bank, address, size)
            if crc32(raw) != str(routine["crc32"]).lower():
                errors.append(f"audio routine CRC32 differs: bank {bank} {name}")
            if not prg_symbol_matches(registry, bank, address, name):
                errors.append(f"audio routine symbol differs: bank {bank} {name}")
            routine_bytes += size
    return errors, {
        "driver_count": len(drivers),
        "command_count": len(commands),
        "command_target_count": command_targets,
        "ram_symbol_count": len(ram),
        "ram_byte_count": ram_bytes,
        "routine_byte_count": routine_bytes,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prg", required=True, type=Path)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--dispatch", required=True, type=Path)
    parser.add_argument("--symbols", required=True, type=Path)
    args = parser.parse_args()
    try:
        errors, report = validate_manifest(
            args.prg.read_bytes(),
            load_json(args.manifest),
            load_json(args.dispatch),
            load_json(args.symbols),
        )
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] audio music audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] audio music ABI: {report['driver_count']} drivers, "
        f"{report['command_count']} commands / "
        f"{report['command_target_count']} bank-local targets, "
        f"{report['ram_symbol_count']} RAM fields ({report['ram_byte_count']} bytes), "
        f"{report['routine_byte_count']} routine bytes"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
