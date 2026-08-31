#!/usr/bin/env python3
"""Validate chapter object-pool layouts against the semantic symbol registry."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any


PRG_BANK_COUNT = 4


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def load_document(path: Path, description: str) -> dict[str, Any]:
    document = json.loads(path.read_text(encoding="utf-8"))
    if document.get("schema_version") != 1:
        raise ValueError(f"unsupported {description} schema")
    return document


def validate(
    manifest: dict[str, Any], symbols: dict[str, Any]
) -> tuple[list[str], dict[str, int]]:
    errors: list[str] = []
    pools = manifest.get("pools")
    if not isinstance(pools, list):
        return ["object pools must be a list"], {}

    memory_by_name = {
        str(item["name"]): item for item in symbols.get("memory_symbols", [])
    }
    code_by_name = {str(item["name"]): item for item in symbols.get("symbols", [])}
    pool_ids: set[str] = set()
    occupied: dict[tuple[int, int], tuple[str, str]] = {}
    lifecycle_names: set[str] = set()
    field_count = 0
    slot_count = 0

    for pool in pools:
        pool_id = str(pool.get("id", ""))
        bank = int(pool.get("bank", -1))
        capacity = int(pool.get("capacity", 0))
        fields = pool.get("fields")
        if not pool_id or pool_id in pool_ids:
            errors.append(f"duplicate or empty object pool id: {pool_id!r}")
        pool_ids.add(pool_id)
        if not 0 <= bank < PRG_BANK_COUNT:
            errors.append(f"{pool_id}: invalid PRG bank {bank}")
        if capacity <= 0:
            errors.append(f"{pool_id}: capacity must be positive")
        if not isinstance(fields, list) or not fields:
            errors.append(f"{pool_id}: fields must be a non-empty list")
            continue

        declared_fields = {str(field.get("symbol", "")) for field in fields}
        key_field = str(pool.get("key_field", ""))
        if key_field not in declared_fields:
            errors.append(f"{pool_id}: key field {key_field!r} is not declared")

        for field in fields:
            name = str(field.get("symbol", ""))
            role = str(field.get("role", ""))
            item = memory_by_name.get(name)
            if not role:
                errors.append(f"{pool_id}: field {name!r} has no role")
            if item is None:
                errors.append(f"{pool_id}: memory symbol {name!r} is missing")
                continue
            address = number(item["address"])
            size = number(item.get("size", 1))
            banks = item.get("banks", list(range(PRG_BANK_COUNT)))
            if bank not in banks:
                errors.append(f"{pool_id}: memory symbol {name} is not valid in bank {bank}")
            if size != capacity:
                errors.append(
                    f"{pool_id}: memory symbol {name} size {size} differs from "
                    f"capacity {capacity}"
                )
            for address_offset in range(size):
                key = (bank, address + address_offset)
                previous = occupied.get(key)
                if previous is not None:
                    errors.append(
                        f"{pool_id}: field {name} overlaps {previous[0]}/{previous[1]} "
                        f"at ${key[1]:04X}"
                    )
                else:
                    occupied[key] = (pool_id, name)
            field_count += 1

        groups = pool.get("groups", [])
        pool_lifecycle_names: set[str] = set()
        if groups:
            cursor = 0
            for group in groups:
                start = int(group.get("start", -1))
                count = int(group.get("count", 0))
                if start != cursor or count <= 0:
                    errors.append(f"{pool_id}: groups do not form a contiguous partition")
                    break
                cursor += count
                for key in ("clear", "render"):
                    if group.get(key):
                        pool_lifecycle_names.add(str(group[key]))
            if cursor != capacity:
                errors.append(
                    f"{pool_id}: group coverage {cursor} differs from capacity {capacity}"
                )

        for name in pool.get("lifecycle", []):
            pool_lifecycle_names.add(str(name))
        for name in pool_lifecycle_names:
            item = code_by_name.get(name)
            if item is not None and int(item["bank"]) != bank:
                errors.append(f"{pool_id}: lifecycle routine {name} is in another bank")
        lifecycle_names.update(pool_lifecycle_names)
        slot_count += capacity

    for name in sorted(lifecycle_names):
        if name not in code_by_name:
            errors.append(f"lifecycle routine {name!r} is missing from symbols")

    return errors, {
        "pool_count": len(pools),
        "field_count": field_count,
        "slot_count": slot_count,
        "lifecycle_count": len(lifecycle_names),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--symbols", required=True, type=Path)
    args = parser.parse_args()
    try:
        errors, report = validate(
            load_document(args.manifest, "object pool"),
            load_document(args.symbols, "symbol registry"),
        )
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] object pool audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] {report['pool_count']} object pools: {report['slot_count']} slots, "
        f"{report['field_count']} fields, {report['lifecycle_count']} lifecycle routines"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
