#!/usr/bin/env python3
"""Validate the shared effect/music APU arbitration contract."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any


BANK_SIZE = 0x8000
CPU_BASE = 0x8000
TIMER_TICK = bytes.fromhex("A2 03 BD A3 02 F0 03 DE A3 02 CA 10 F5")
RESET_PREFIX = bytes.fromhex(
    "A9 10 8D 00 40 8D 04 40 8D 0C 40 A9 00 8D 08 40 "
    "A9 18 8D 03 40 8D 07 40 8D 0B 40 8D 0F 40"
)


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("audio arbitration range is outside PRG")
    return prg[offset:offset + size]


def load_json(path: Path) -> dict[str, Any]:
    document = json.loads(path.read_text(encoding="utf-8"))
    if document.get("schema_version") != 1:
        raise ValueError("unsupported audio arbitration schema")
    return document


def symbol_sets(document: dict[str, Any]) -> tuple[set[tuple[int, int, str]], set[tuple[int, str]]]:
    code: set[tuple[int, int, str]] = set()
    for entry in document["symbols"]:
        address = number(entry["address"])
        name = str(entry["name"])
        code.add((int(entry["bank"]), address, name))
    ram = {
        (number(entry["address"]), str(entry["name"]))
        for entry in document["memory_symbols"]
    }
    return code, ram


def frame_bytes(effect: int, music: int, tail: str) -> bytes:
    prefix = bytes((0x20, effect & 0xFF, effect >> 8))
    if tail == "jmp":
        return prefix + bytes((0x4C, music & 0xFF, music >> 8))
    if tail == "jsr-rts":
        return prefix + bytes((0x20, music & 0xFF, music >> 8, 0x60))
    raise ValueError(f"unsupported frame tail: {tail}")


def validate(
    prg: bytes,
    document: dict[str, Any],
    symbols: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    errors: list[str] = []
    code_symbols, ram_symbols = symbol_sets(symbols)

    channels = document["channels"]
    expected_channels = [
        (0, "pulse-1", 0x4000),
        (1, "pulse-2", 0x4004),
        (2, "triangle", 0x4008),
        (3, "noise", 0x400C),
    ]
    actual_channels = [
        (int(item["timer_index"]), str(item["name"]), number(item["apu_base"]))
        for item in channels
    ]
    if actual_channels != expected_channels:
        errors.append("channel/timer/APU mapping differs from the four-channel ABI")

    for field in document["shared_ram"]:
        identity = (number(field["address"]), str(field["name"]))
        if identity not in ram_symbols:
            errors.append(f"shared RAM symbol missing: {identity[1]} at ${identity[0]:04X}")

    guard_count = 0
    for driver in document["drivers"]:
        name = str(driver["name"])
        bank = int(driver["bank"])
        frame = driver["frame_update"]
        effect = driver["effect_update"]
        music = driver["music_update"]
        reset = driver["track_start_reset"]
        frame_address = number(frame["address"])
        effect_address = number(effect["address"])
        music_address = number(music["address"])
        reset_address = number(reset["address"])

        for address, symbol in (
            (frame_address, str(frame["symbol"])),
            (effect_address, str(effect["symbol"])),
            (music_address, str(music["symbol"])),
            (reset_address, str(reset["symbol"])),
        ):
            if (bank, address, symbol) not in code_symbols:
                errors.append(f"{name}: code symbol missing: {symbol} at ${address:04X}")

        expected_frame = frame_bytes(effect_address, music_address, str(frame["tail"]))
        if bank_slice(prg, bank, frame_address, len(expected_frame)) != expected_frame:
            errors.append(f"{name}: effect-before-music frame path differs")
        if bank_slice(prg, bank, effect_address, len(TIMER_TICK)) != TIMER_TICK:
            errors.append(f"{name}: four-channel effect timer tick differs")
        if bank_slice(prg, bank, reset_address, len(RESET_PREFIX)) != RESET_PREFIX:
            errors.append(f"{name}: unguarded track-start APU reset prefix differs")
        if reset.get("timer_guarded") is not False:
            errors.append(f"{name}: track-start reset must record the unguarded exception")

        for guard in driver["music_write_guards"]:
            address = number(guard["address"])
            timer_index = int(guard["timer_index"])
            indexed = bool(guard["indexed"])
            if indexed:
                expected = bytes((0xBC, 0xA3, 0x02, 0xD0))
            else:
                expected = bytes((0xAD, 0xA3 + timer_index, 0x02, 0xD0))
            if bank_slice(prg, bank, address, 4) != expected:
                errors.append(
                    f"{name}: {guard['path']} timer guard differs at ${address:04X}"
                )
            guard_count += 1

    return errors, {
        "driver_count": len(document["drivers"]),
        "channel_count": len(channels),
        "guard_count": guard_count,
        "ram_field_count": len(document["shared_ram"]),
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
        print(f"[ERROR] audio arbitration audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] {report['driver_count']} audio frame paths: effects before music; "
        f"{report['channel_count']} effect timers, {report['guard_count']} music-write "
        f"guards, {report['ram_field_count']} shared RAM fields"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
