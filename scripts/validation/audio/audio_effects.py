#!/usr/bin/env python3
"""Validate audio-effect request roles and synchronize their source symbols."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def load_json(path: Path) -> dict[str, Any]:
    document = json.loads(path.read_text(encoding="utf-8"))
    if document.get("schema_version") != 1:
        raise ValueError(f"unsupported schema: {path}")
    return document


def dispatch_drivers(document: dict[str, Any]) -> dict[str, dict[str, Any]]:
    drivers = [document, *document.get("additional_drivers", [])]
    result = {str(driver["name"]): driver for driver in drivers}
    if len(result) != len(drivers):
        raise ValueError("audio dispatch driver names are duplicated")
    return result


def role_contracts(document: dict[str, Any]) -> dict[str, dict[str, Any]]:
    roles = document.get("roles", [])
    result = {str(role["id"]): role for role in roles}
    if len(result) != len(roles):
        raise ValueError("audio effect role IDs are duplicated")
    return result


def handler_symbol(driver: dict[str, Any], token: str) -> str:
    system = driver.get("system_symbols", {})
    if token in system:
        return str(system[token])
    return f"{driver['symbol_prefix']}AudioEffect_{token}"


def expected_symbols(
    catalog: dict[str, Any], dispatch: dict[str, Any]
) -> tuple[list[str], dict[tuple[int, int], str], dict[str, int]]:
    errors: list[str] = []
    channels = [str(channel) for channel in catalog.get("channels", [])]
    if channels != ["pulse-1", "pulse-2", "triangle", "noise"]:
        errors.append("audio effect channel ABI differs")
    valid_channels = set(channels)
    roles = role_contracts(catalog)
    for role_id, role in roles.items():
        for field in ("init_handler", "update_handler", "description"):
            if not str(role.get(field, "")).strip():
                errors.append(f"role {role_id}: {field} is empty")
        for field in ("timer_leases", "apu_channels"):
            values = role.get(field)
            if not isinstance(values, list) or len(values) != len(set(values)):
                errors.append(f"role {role_id}: {field} is not a unique list")
                continue
            unknown = set(map(str, values)) - valid_channels
            if unknown:
                errors.append(f"role {role_id}: unknown {field}: {sorted(unknown)}")

    available = dispatch_drivers(dispatch)
    catalog_drivers = catalog.get("drivers", [])
    catalog_names = [str(driver["name"]) for driver in catalog_drivers]
    if len(catalog_names) != len(set(catalog_names)):
        errors.append("audio effect catalog driver names are duplicated")
    if set(catalog_names) != set(available):
        errors.append("audio effect catalog driver set differs from audio dispatch")

    expected: dict[tuple[int, int], str] = {}
    request_count = 0
    for driver in catalog_drivers:
        name = str(driver["name"])
        source = available.get(name)
        if source is None:
            continue
        bank = int(driver["bank"])
        if bank != int(source["bank"]):
            errors.append(f"{name}: bank differs from audio dispatch")
        request_roles = [str(role) for role in driver.get("request_roles", [])]
        count = int(source["request_count"])
        if len(request_roles) != count:
            errors.append(f"{name}: request role count differs")
            continue
        unknown_roles = sorted(set(request_roles) - set(roles))
        if unknown_roles:
            errors.append(f"{name}: unknown request roles: {unknown_roles}")
            continue

        priorities = [number(value) for value in source["priority_table"]["values"]]
        targets = [number(value) for value in source["dispatch_table"]["targets"]]
        if len(priorities) != count or len(targets) != count * 2:
            errors.append(f"{name}: priority or handler-pair table length differs")
            continue
        expected_priorities = set(range(0, count * 4, 4))
        if set(priorities) != expected_priorities:
            errors.append(f"{name}: priorities are not a complete pair permutation")
            continue

        target_tokens: dict[int, set[str]] = {}
        for request_id, role_id in enumerate(request_roles):
            pair = priorities[request_id] // 4
            role = roles[role_id]
            for phase, target in zip(
                ("init_handler", "update_handler"),
                targets[pair * 2:pair * 2 + 2],
            ):
                target_tokens.setdefault(target, set()).add(str(role[phase]))

        if set(target_tokens) != set(targets):
            errors.append(f"{name}: request roles do not cover every effect target")
        for address, tokens in target_tokens.items():
            if len(tokens) != 1:
                errors.append(
                    f"{name}: ${address:04X} has conflicting handler roles: "
                    + ", ".join(sorted(tokens))
                )
                continue
            symbol = handler_symbol(driver, next(iter(tokens)))
            key = (bank, address)
            if key in expected and expected[key] != symbol:
                errors.append(f"{name}: conflicting symbol at ${address:04X}")
            expected[key] = symbol
        helpers = driver.get("helpers", {})
        if not isinstance(helpers, dict) or not helpers:
            errors.append(f"{name}: audio effect helpers are missing")
            helpers = {}
        for token, raw_address in helpers.items():
            address = number(raw_address)
            key = (bank, address)
            symbol = handler_symbol(driver, str(token))
            if key in expected and expected[key] != symbol:
                errors.append(f"{name}: conflicting helper symbol at ${address:04X}")
            expected[key] = symbol
        request_count += count

    return errors, expected, {
        "driver_count": len(catalog_drivers),
        "request_count": request_count,
        "role_count": len(roles),
        "dispatch_handler_count": sum(
            len(set(number(value) for value in driver["dispatch_table"]["targets"]))
            for driver in available.values()
        ),
        "helper_count": sum(
            len(driver.get("helpers", {})) for driver in catalog_drivers
        ),
    }


def validate(
    catalog: dict[str, Any],
    dispatch: dict[str, Any],
    symbols: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    errors, expected, report = expected_symbols(catalog, dispatch)
    declared = {
        (int(entry["bank"]), number(entry["address"])): str(entry["name"])
        for entry in symbols.get("symbols", [])
    }
    for (bank, address), symbol in expected.items():
        if declared.get((bank, address)) != symbol:
            errors.append(
                f"bank {bank} ${address:04X}: expected semantic symbol {symbol}"
            )
    return errors, report


def synchronize_symbols(
    symbols: dict[str, Any], expected: dict[tuple[int, int], str]
) -> tuple[dict[str, Any], int]:
    entries = list(symbols.get("symbols", []))
    by_address = {
        (int(entry["bank"]), number(entry["address"])): entry for entry in entries
    }
    added = 0
    for (bank, address), name in expected.items():
        entry = by_address.get((bank, address))
        if entry is not None:
            if str(entry["name"]) != name:
                raise ValueError(
                    f"refusing to replace {entry['name']} at bank {bank} ${address:04X}"
                )
            continue
        entries.append({
            "bank": bank,
            "address": f"0x{address:04X}",
            "name": name,
            "evidence": "audio-effect-request-role-and-observed-channel-contract",
        })
        added += 1
    result = dict(symbols)
    result["symbols"] = entries
    return result, added


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    validate_parser = subparsers.add_parser("validate")
    sync_parser = subparsers.add_parser("sync-symbols")
    for child in (validate_parser, sync_parser):
        child.add_argument("--catalog", required=True, type=Path)
        child.add_argument("--dispatch", required=True, type=Path)
        child.add_argument("--symbols", required=True, type=Path)
    sync_parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    try:
        catalog = load_json(args.catalog)
        dispatch = load_json(args.dispatch)
        symbols = load_json(args.symbols)
        errors, expected, report = expected_symbols(catalog, dispatch)
        if errors:
            for error in errors:
                print(f"[ERROR] {error}")
            return 1
        if args.command == "sync-symbols":
            result, added = synchronize_symbols(symbols, expected)
            output = args.output or args.symbols
            output.write_text(
                json.dumps(result, ensure_ascii=False, indent=2) + "\n",
                encoding="utf-8",
                newline="\n",
            )
            print(f"[OK] added {added} audio-effect symbols")
            return 0
        errors, report = validate(catalog, dispatch, symbols)
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] audio effect audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] {report['driver_count']} audio-effect drivers: "
        f"{report['request_count']} requests, {report['role_count']} roles, "
        f"{report['dispatch_handler_count']} dispatch handlers, "
        f"{report['helper_count']} helpers"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
