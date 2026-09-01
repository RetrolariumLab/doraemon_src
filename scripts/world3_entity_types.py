#!/usr/bin/env python3
"""Validate the complete World 3 entity-type catalog."""

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
        raise ValueError("World 3 entity-type range is outside PRG")
    return prg[offset:offset + size]


def named_entry(entries: Any, name: str, description: str) -> dict[str, Any]:
    matches = [entry for entry in entries if entry.get("name") == name]
    if len(matches) != 1:
        raise ValueError(f"expected one {description} named {name!r}")
    return matches[0]


def pointer_bytes(targets: list[str | int]) -> bytes:
    return b"".join(number(target).to_bytes(2, "little") for target in targets)


def validate(
    prg: bytes,
    manifest: dict[str, Any],
    object_dispatch: dict[str, Any],
    object_data: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if manifest.get("schema_version") != 1:
        return ["unsupported World 3 entity-type schema"], {}
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    errors: list[str] = []
    bank = int(manifest["bank"])
    type_count = int(manifest["type_count"])
    if int(object_data.get("bank", -1)) != bank:
        errors.append("World 3 object-data bank differs from entity catalog")

    property_tables = manifest.get("property_tables")
    if not isinstance(property_tables, list) or not property_tables:
        return ["World 3 property-table list must be non-empty"], {}
    property_names: set[str] = set()
    for table in property_tables:
        name = str(table.get("name", ""))
        if not name or name in property_names:
            errors.append(f"duplicate or empty property-table name: {name!r}")
            continue
        property_names.add(name)
        values = [number(value) for value in table.get("values", [])]
        if len(values) != type_count:
            errors.append(
                f"{name}: value count {len(values)} differs from {type_count}"
            )
            continue
        if any(not 0 <= value <= 0xFF for value in values):
            errors.append(f"{name}: value is outside byte range")
            continue
        expected = bytes(values)
        actual = bank_slice(prg, bank, number(table["address"]), type_count)
        if actual != expected:
            errors.append(f"{name}: property table differs from PRG")
        if crc32(expected) != str(table["crc32"]).lower():
            errors.append(f"{name}: property-table CRC32 differs")

    dispatch_tables = object_dispatch.get("tables", [])
    behavior_pointer = object_data["behavior_pointer_table"]
    dispatch_target_count = 0
    for contract in manifest["dispatch_contracts"]:
        name = str(contract["name"])
        if name == "behavior_pointer_table":
            table = behavior_pointer
        else:
            table = named_entry(dispatch_tables, name, "object dispatch table")
            if int(table.get("bank", -1)) != bank:
                errors.append(f"{name}: bank differs from entity catalog")
        targets = table["targets"]
        slot_count = int(contract["slot_count"])
        if int(table["slot_count"]) != slot_count or len(targets) != slot_count:
            errors.append(f"{name}: slot count differs from catalog")
            continue
        address = number(contract["address"])
        if number(table["address"]) != address:
            errors.append(f"{name}: address differs from catalog")
        encoded = pointer_bytes(targets)
        if any(
            not CPU_BASE <= number(target) <= 0xFFFF
            for target in targets
        ):
            errors.append(f"{name}: target is outside the active PRG window")
        if bank_slice(prg, bank, address, len(encoded)) != encoded:
            errors.append(f"{name}: pointer table differs from PRG")
        if crc32(encoded) != str(contract["crc32"]).lower():
            errors.append(f"{name}: pointer-table CRC32 differs")
        unique_targets = len(set(map(number, targets)))
        if unique_targets != int(contract["expected_unique_target_count"]):
            errors.append(f"{name}: unique target count differs from catalog")
        dispatch_target_count += unique_targets

    domain_types: list[int] = []
    domains: dict[str, set[int]] = {}
    for domain in manifest["domains"]:
        name = str(domain["name"])
        values = [number(value) for value in domain["types"]]
        if name in domains:
            errors.append(f"duplicate entity-type domain {name!r}")
        domains[name] = set(values)
        domain_types.extend(values)
    if sorted(domain_types) != list(range(type_count)):
        errors.append("entity-type domains do not partition all type ids")

    scripted = domains.get("scripted_spawn_types", set())
    initializer_contract = named_entry(
        manifest["dispatch_contracts"],
        "world3_spawn_initializers",
        "dispatch contract",
    )
    behavior_contract = named_entry(
        manifest["dispatch_contracts"],
        "behavior_pointer_table",
        "dispatch contract",
    )
    expected_scripted = set(range(int(initializer_contract["slot_count"])))
    if scripted != expected_scripted or len(scripted) != int(
        behavior_contract["slot_count"]
    ):
        errors.append("scripted type domain differs from initializer/behavior slots")

    registry_type_field = named_entry(
        object_data["initial_registry"]["fields"], "type", "registry field"
    )
    actual_multiset = Counter(map(number, registry_type_field["values"]))
    expected_multiset = Counter(
        number(value) for value in manifest["initial_persistent_type_multiset"]
    )
    if actual_multiset != expected_multiset:
        errors.append("initial persistent type multiset differs from object registry")
    if not set(actual_multiset) <= domains.get("initial_persistent_types", set()):
        errors.append("initial registry contains a type outside its catalog domain")

    relationship_count = 0
    for relationship in manifest["code_relationships"]:
        raw = bytes.fromhex(str(relationship["bytes"]))
        address = number(relationship["address"])
        if bank_slice(prg, bank, address, len(raw)) != raw:
            errors.append(f"{relationship['name']}: code signature differs from PRG")
        sources = [number(value) for value in relationship["source_types"]]
        results = [number(value) for value in relationship["result_types"]]
        if any(not 0 <= value < type_count for value in sources + results):
            errors.append(f"{relationship['name']}: type id is outside catalog")
        relationship_count += 1

    return errors, {
        "type_count": type_count,
        "property_table_count": len(property_tables),
        "dispatch_contract_count": len(manifest["dispatch_contracts"]),
        "dispatch_unique_target_sum": dispatch_target_count,
        "domain_count": len(domains),
        "relationship_count": relationship_count,
        "initial_registry_type_count": sum(actual_multiset.values()),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prg", required=True, type=Path)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--object-dispatch", required=True, type=Path)
    parser.add_argument("--object-data", required=True, type=Path)
    args = parser.parse_args()
    try:
        manifest = json.loads(args.manifest.read_text(encoding="utf-8"))
        object_dispatch = json.loads(
            args.object_dispatch.read_text(encoding="utf-8")
        )
        object_data = json.loads(args.object_data.read_text(encoding="utf-8"))
        errors, report = validate(
            args.prg.read_bytes(), manifest, object_dispatch, object_data
        )
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 3 entity-type audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] {report['type_count']} World 3 entity types: "
        f"{report['property_table_count']} property tables, "
        f"{report['dispatch_contract_count']} dispatch domains, "
        f"{report['domain_count']} lifecycle domains, "
        f"{report['relationship_count']} encoded type transformations"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
