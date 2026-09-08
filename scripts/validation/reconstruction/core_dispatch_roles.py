#!/usr/bin/env python3
"""Validate semantic roles for core non-audio indirect dispatch targets."""

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


def table_by_name(document: dict[str, Any], name: str) -> dict[str, Any]:
    for table in document["tables"]:
        if table["name"] == name:
            return table
    raise ValueError(f"dispatch table not found: {name}")


def validate(
    roles: dict[str, Any],
    streaming: dict[str, Any],
    object_dispatch: dict[str, Any],
    symbols: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    errors: list[str] = []
    declared_symbols = {
        (int(entry["bank"]), number(entry["address"]), str(entry["name"]))
        for entry in symbols["symbols"]
    }
    domains = roles["domains"]
    target_count = 0
    for domain in domains:
        name = str(domain["name"])
        bank = int(domain["bank"])
        role_entries = domain["targets"]
        role_addresses = [number(entry["address"]) for entry in role_entries]
        if len(role_addresses) != len(set(role_addresses)):
            errors.append(f"{name}: role target addresses are not unique")

        if domain["source"] == "world2_streaming":
            table_names = set(domain["tables"])
            selected = [
                table for table in streaming["dispatch_tables"]
                if table["name"] in table_names
            ]
            if {table["name"] for table in selected} != table_names:
                errors.append(f"{name}: a streaming dispatch table is missing")
            actual = {
                number(target)
                for table in selected
                for target in table["targets"]
            }
        elif domain["source"] == "object_dispatch":
            table = table_by_name(object_dispatch, str(domain["table"]))
            if int(table["bank"]) != bank:
                errors.append(f"{name}: object dispatch bank differs")
            actual = {number(target) for target in table["targets"]}
        else:
            raise ValueError(f"unsupported role source: {domain['source']}")

        if actual != set(role_addresses):
            errors.append(f"{name}: semantic role targets differ from dispatch tables")
        for entry, address in zip(role_entries, role_addresses):
            symbol = str(entry["symbol"])
            if not str(entry.get("role", "")).strip():
                errors.append(f"{name}: ${address:04X} has no semantic role")
            if (bank, address, symbol) not in declared_symbols:
                errors.append(f"{name}: symbol missing: {symbol} at ${address:04X}")
        target_count += len(role_entries)

    return errors, {"domain_count": len(domains), "target_count": target_count}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--roles", required=True, type=Path)
    parser.add_argument("--streaming", required=True, type=Path)
    parser.add_argument("--object-dispatch", required=True, type=Path)
    parser.add_argument("--symbols", required=True, type=Path)
    args = parser.parse_args()
    try:
        errors, report = validate(
            load_json(args.roles),
            load_json(args.streaming),
            load_json(args.object_dispatch),
            load_json(args.symbols),
        )
    except (OSError, ValueError, KeyError, json.JSONDecodeError) as exc:
        print(f"[ERROR] core dispatch role audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] {report['target_count']} semantic core dispatch targets "
        f"across {report['domain_count']} domains"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
