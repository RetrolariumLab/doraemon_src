#!/usr/bin/env python3
"""Validate World 2 enemy state handlers and structural roles."""

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
        raise ValueError("World 2 enemy-handler range is outside PRG")
    return prg[offset:offset + size]


def named(entries: list[dict[str, Any]], name: str, description: str) -> dict[str, Any]:
    matches = [entry for entry in entries if entry.get("name") == name]
    if len(matches) != 1:
        raise ValueError(f"expected one {description} named {name!r}")
    return matches[0]


def rts_minus_one(targets: list[int]) -> bytes:
    return b"".join((target - 1).to_bytes(2, "little") for target in targets)


def registry_matches(
    registry: dict[str, Any], name: str, address: int, bank: int
) -> bool:
    matches = [
        entry
        for entry in registry.get("symbols", [])
        if entry.get("name") == name
    ]
    return len(matches) == 1 and (
        int(matches[0].get("bank", -1)) == bank
        and number(matches[0]["address"]) == address
    )


def validate(
    prg: bytes,
    manifest: dict[str, Any],
    dispatch: dict[str, Any],
    enemy_states: dict[str, Any],
    registry: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if manifest.get("schema_version") != 1:
        return ["unsupported World 2 enemy-handler schema"], {}
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    bank = int(manifest["bank"])
    if bank != 1:
        return ["World 2 enemy handlers must belong to PRG bank 1"], {}
    errors: list[str] = []
    states = manifest["states"]
    if [int(entry["state"]) for entry in states] != list(range(1, 21)):
        errors.append("World 2 enemy handler states are not contiguous 01-14")
    if int(enemy_states["runtime_states"].get("state_count", -1)) != len(states):
        errors.append("World 2 enemy handler state count differs")
    direct = {number(value) for value in enemy_states["runtime_states"]["direct_spawn_states"]}
    internal = {number(value) for value in enemy_states["runtime_states"]["internal_states"]}
    expected_domains = {
        state: "direct_spawn" if state in direct else "internal"
        for state in direct | internal
    }
    if expected_domains != {
        int(entry["state"]): str(entry["domain"]) for entry in states
    }:
        errors.append("World 2 enemy handler lifecycle domains differ")
    for field in (
        "identity_symbol",
        "update_role",
        "render_role",
        "update_symbol",
        "render_symbol",
    ):
        if any(not str(entry.get(field, "")) for entry in states):
            errors.append(f"World 2 enemy handler {field} is empty")
    tables = dispatch.get("tables", [])
    update = named(tables, "world2_enemy_update_handlers", "dispatch table")
    render = named(tables, "world2_enemy_render_handlers", "dispatch table")
    update_targets = [number(manifest["inactive_update_target"])] + [
        number(entry["update_target"]) for entry in states
    ]
    render_targets = [number(entry["render_target"]) for entry in states]
    for table, targets in ((update, update_targets), (render, render_targets)):
        if (
            int(table.get("bank", -1)) != bank
            or table.get("encoding") != "rts-minus-one"
            or int(table.get("slot_count", -1)) != len(targets)
            or [number(value) for value in table.get("targets", [])] != targets
        ):
            errors.append(f"World 2 enemy handler mapping differs: {table['name']}")
            continue
        encoded = rts_minus_one(targets)
        if bank_slice(prg, bank, number(table["address"]), len(encoded)) != encoded:
            errors.append(f"World 2 enemy handler bytes differ: {table['name']}")
    pairs = [
        (str(entry["update_symbol"]), number(entry["update_target"]))
        for entry in states
    ] + [
        (str(entry["render_symbol"]), number(entry["render_target"]))
        for entry in states
    ]
    for name, address in sorted(set(pairs)):
        if not registry_matches(registry, name, address, bank):
            errors.append(f"World 2 enemy handler symbol differs: {name}")
    return errors, {
        "state_count": len(states),
        "direct_state_count": len(direct),
        "internal_state_count": len(internal),
        "update_target_count": len(set(update_targets[1:])),
        "render_target_count": len(set(render_targets)),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prg", required=True, type=Path)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--object-dispatch", required=True, type=Path)
    parser.add_argument("--enemy-states", required=True, type=Path)
    parser.add_argument("--symbols", required=True, type=Path)
    args = parser.parse_args()
    try:
        errors, report = validate(
            args.prg.read_bytes(),
            json.loads(args.manifest.read_text(encoding="utf-8")),
            json.loads(args.object_dispatch.read_text(encoding="utf-8")),
            json.loads(args.enemy_states.read_text(encoding="utf-8")),
            json.loads(args.symbols.read_text(encoding="utf-8")),
        )
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 2 enemy-handler audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] World 2 enemy handlers: {report['state_count']} states "
        f"({report['direct_state_count']} direct, {report['internal_state_count']} internal), "
        f"{report['update_target_count']} update targets, "
        f"{report['render_target_count']} render targets"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
