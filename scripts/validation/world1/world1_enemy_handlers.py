#!/usr/bin/env python3
"""Validate the World 1 normal-enemy lifecycle and handler graph."""

from __future__ import annotations

import argparse
from collections import Counter
import json
from pathlib import Path
from typing import Any
import zlib


BANK_SIZE = 0x8000
CPU_BASE = 0x8000


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def crc32(data: bytes) -> str:
    return f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("World 1 enemy-handler range is outside PRG")
    return prg[offset:offset + size]


def named(entries: Any, name: str, description: str) -> dict[str, Any]:
    matches = [entry for entry in entries if entry.get("name") == name]
    if len(matches) != 1:
        raise ValueError(f"expected one {description} named {name!r}")
    return matches[0]


def decode_rts_minus_one(data: bytes) -> list[int]:
    if len(data) % 2:
        raise ValueError("RTS-minus-one table has odd byte length")
    return [
        (data[index] | data[index + 1] << 8) + 1
        for index in range(0, len(data), 2)
    ]


def placement_counts(authoring: dict[str, Any]) -> Counter[int]:
    counts: Counter[int] = Counter()
    for placement_list in authoring.get("placement_lists", []):
        for record in placement_list.get("records", []):
            placement_type = number(record["type"])
            if placement_type < 0x80:
                counts[placement_type] += 1
    return counts


def direct_metasprite_indexes(metasprites: dict[str, Any]) -> set[int]:
    return {
        int(entry["id"])
        for entry in metasprites.get("index_entries", [])
        if entry.get("kind") == "direct"
    }


def validate(
    prg: bytes,
    manifest: dict[str, Any],
    dispatch: dict[str, Any],
    placements: dict[str, Any],
    metasprites: dict[str, Any],
    symbols: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if manifest.get("schema_version") != 1:
        return ["unsupported World 1 enemy-handler schema"], {}
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    errors: list[str] = []
    bank = int(manifest["bank"])
    state_count = int(manifest["state_count"])
    if bank != 0 or state_count != 15:
        errors.append("World 1 enemy-handler domain must be bank 0 states 01-0F")
    states = manifest.get("states")
    if not isinstance(states, list) or len(states) != state_count:
        return [f"World 1 handler catalog must contain {state_count} states"], {}
    if [int(entry.get("state", -1)) for entry in states] != list(
        range(1, state_count + 1)
    ):
        errors.append("World 1 handler states are not contiguous")
    if any(not str(entry.get("identity_symbol", "")) for entry in states):
        errors.append("World 1 enemy handler identity_symbol is empty")

    dispatch_table = named(
        dispatch.get("tables", []),
        "world1_entity_update_handlers",
        "dispatch table",
    )
    if int(dispatch_table["bank"]) != bank or int(
        dispatch_table["slot_count"]
    ) != state_count + 1:
        errors.append("World 1 update dispatch domain differs")
    dispatch_address = number(dispatch_table["address"])
    raw_dispatch = bank_slice(prg, bank, dispatch_address, (state_count + 1) * 2)
    targets = decode_rts_minus_one(raw_dispatch)
    declared_targets = [number(value) for value in dispatch_table["targets"]]
    if targets != declared_targets:
        errors.append("World 1 update dispatch bytes differ")
    if [number(entry["update_address"]) for entry in states] != targets[1:]:
        errors.append("World 1 state-to-handler mapping differs")

    symbol_map = {
        (int(entry["bank"]), number(entry["address"])): str(entry["name"])
        for entry in symbols.get("symbols", [])
    }
    for entry in states:
        address = number(entry["update_address"])
        if symbol_map.get((bank, address)) != entry.get("update_symbol"):
            errors.append(f"state {int(entry['state']):02X}: update symbol differs")

    table_values: dict[str, list[int]] = {}
    for table in manifest.get("property_tables", []):
        name = str(table["name"])
        values = [number(value) for value in table["values"]]
        address = number(table["address"])
        if len(values) != 16:
            errors.append(f"{name}: property table must contain 16 bytes")
            continue
        raw = bank_slice(prg, bank, address, len(values))
        if raw != bytes(values):
            errors.append(f"{name}: property bytes differ")
        if crc32(raw) != str(table["crc32"]).lower():
            errors.append(f"{name}: property CRC32 differs")
        table_values[name] = values
    expected_tables = {
        "initial_metasprite_by_placement_type",
        "initial_render_flags_by_placement_type",
        "initial_health_by_placement_type",
        "score_reward_code_by_runtime_state",
    }
    if set(table_values) != expected_tables:
        errors.append("World 1 enemy property-table set differs")

    counts = placement_counts(placements)
    direct_indexes = direct_metasprite_indexes(metasprites)
    lifecycle_counts: Counter[str] = Counter()
    for state, entry in enumerate(states, start=1):
        lifecycle = str(entry.get("lifecycle"))
        lifecycle_counts[lifecycle] += 1
        if lifecycle == "direct_placement":
            placement_type = state - 1
            if int(entry["placement_type"]) != placement_type:
                errors.append(f"state {state:02X}: placement type differs")
            if int(entry["placement_count"]) != counts[placement_type]:
                errors.append(f"state {state:02X}: placement count differs")
            if number(entry["initial_metasprite"]) != table_values.get(
                "initial_metasprite_by_placement_type", [0] * 16
            )[placement_type]:
                errors.append(f"state {state:02X}: initial metasprite differs")
            if number(entry["initial_render_flags"]) != table_values.get(
                "initial_render_flags_by_placement_type", [0] * 16
            )[placement_type]:
                errors.append(f"state {state:02X}: render flags differ")
            if number(entry["initial_health"]) != table_values.get(
                "initial_health_by_placement_type", [0] * 16
            )[placement_type]:
                errors.append(f"state {state:02X}: initial health differs")
            if number(entry["initial_metasprite"]) not in direct_indexes:
                errors.append(f"state {state:02X}: metasprite base is not direct")
        elif lifecycle == "dormant_dispatch_state":
            if state != 13 or int(entry["placement_count"]) != 0:
                errors.append("World 1 dormant state contract differs")
        elif lifecycle == "scripted_boss_state":
            if state not in (14, 15) or int(entry["placement_count"]) != 0:
                errors.append(f"state {state:02X}: scripted boss lifecycle differs")
        else:
            errors.append(f"state {state:02X}: unknown lifecycle")
        rewards = table_values.get("score_reward_code_by_runtime_state", [0] * 16)
        if number(entry["score_reward_code"]) != rewards[state]:
            errors.append(f"state {state:02X}: score reward differs")

    expected_counts = {
        number(key): int(value)
        for key, value in manifest["placement_counts"].items()
    }
    if dict(sorted(counts.items())) != expected_counts:
        errors.append("World 1 placement-type histogram differs")
    if lifecycle_counts != Counter({
        "direct_placement": 12,
        "dormant_dispatch_state": 1,
        "scripted_boss_state": 2,
    }):
        errors.append("World 1 lifecycle partition differs")

    for signature in manifest.get("signatures", []):
        raw = bytes.fromhex(str(signature["bytes"]))
        if bank_slice(prg, bank, number(signature["address"]), len(raw)) != raw:
            errors.append(f"{signature['name']}: code signature differs")
    return errors, {
        "state_count": state_count,
        "direct_state_count": lifecycle_counts["direct_placement"],
        "placement_count": sum(counts.values()),
        "unique_handler_count": len(set(targets[1:])),
        "scripted_boss_state_count": lifecycle_counts["scripted_boss_state"],
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prg", required=True, type=Path)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--object-dispatch", required=True, type=Path)
    parser.add_argument("--placements", required=True, type=Path)
    parser.add_argument("--metasprites", required=True, type=Path)
    parser.add_argument("--symbols", required=True, type=Path)
    args = parser.parse_args()
    try:
        documents = [
            json.loads(path.read_text(encoding="utf-8"))
            for path in (
                args.manifest,
                args.object_dispatch,
                args.placements,
                args.metasprites,
                args.symbols,
            )
        ]
        errors, report = validate(args.prg.read_bytes(), *documents)
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 1 enemy-handler audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] World 1 enemy handlers: {report['state_count']} states, "
        f"{report['direct_state_count']} direct-placement states from "
        f"{report['placement_count']} placements, "
        f"{report['unique_handler_count']} unique handlers, "
        f"{report['scripted_boss_state_count']} scripted boss states"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
