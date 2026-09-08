#!/usr/bin/env python3
"""Validate World 3 initial room objects and behavior-stream pointers."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any
import zlib


BANK_SIZE = 0x8000
CPU_BASE = 0x8000


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def load_manifest(path: Path) -> dict[str, Any]:
    document = json.loads(path.read_text(encoding="utf-8"))
    if document.get("schema_version") != 1:
        raise ValueError("unsupported World 3 object-data schema")
    return document


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("World 3 object-data range is outside PRG")
    return prg[offset:offset + size]


def crc32(data: bytes) -> str:
    return f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"


def validate(
    prg: bytes,
    document: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    errors: list[str] = []
    bank = int(document["bank"])

    registry = document["initial_registry"]
    capacity = int(registry["capacity"])
    if registry.get("layout") != "structure-of-arrays":
        errors.append("World 3 initial registry must use structure-of-arrays")
    fields = registry.get("fields")
    if not isinstance(fields, list) or [
        field.get("name") for field in fields
    ] != ["room", "type", "x", "y", "state"]:
        return ["World 3 initial registry field order differs"], {}

    expected_fields: dict[str, list[int]] = {}
    for field in fields:
        name = str(field["name"])
        values = [number(value) for value in field.get("values", [])]
        if len(values) != capacity:
            errors.append(
                f"World 3 {name} field has {len(values)} values, expected {capacity}"
            )
        if any(not 0 <= value <= 0xFF for value in values):
            errors.append(f"World 3 {name} field contains a non-byte value")
        expected_fields[name] = values

    expected_registry = bytes(
        value
        for field in fields
        for value in expected_fields[str(field["name"])]
    )
    registry_data = bank_slice(
        prg,
        bank,
        number(registry["address"]),
        capacity * len(fields),
    )
    if registry_data != expected_registry:
        errors.append("World 3 initial room-object registry differs from manifest")
    if crc32(registry_data) != str(registry["crc32"]).lower():
        errors.append("World 3 initial room-object registry CRC32 differs")

    types = expected_fields.get("type", [])
    for group in registry.get("type_shuffle_groups", []):
        start = int(group["start"])
        count = int(group["count"])
        expected_multiset = sorted(number(value) for value in group["multiset"])
        actual_multiset = sorted(types[start:start + count])
        if len(expected_multiset) != count or actual_multiset != expected_multiset:
            errors.append(
                f"World 3 type shuffle group {start}:{start + count} differs"
            )
    for index_text, value in registry.get("fixed_type_slots", {}).items():
        index = int(index_text)
        if index >= len(types) or types[index] != number(value):
            errors.append(f"World 3 fixed type slot {index} differs")
    if any(expected_fields.get("state", [])):
        errors.append("World 3 initial persistent states are not all zero")

    pointer_spec = document["behavior_pointer_table"]
    targets = [number(value) for value in pointer_spec.get("targets", [])]
    slot_count = int(pointer_spec["slot_count"])
    if len(targets) != slot_count:
        errors.append(
            f"World 3 behavior target count {len(targets)} differs from "
            f"slot count {slot_count}"
        )
    pointer_data = bank_slice(
        prg,
        bank,
        number(pointer_spec["address"]),
        slot_count * 2,
    )
    expected_pointer_data = b"".join(
        target.to_bytes(2, "little") for target in targets
    )
    if pointer_data != expected_pointer_data:
        errors.append("World 3 behavior pointer table differs from manifest")
    if crc32(pointer_data) != str(pointer_spec["crc32"]).lower():
        errors.append("World 3 behavior pointer-table CRC32 differs")

    streams = document["behavior_streams"]
    stream_address = number(streams["address"])
    stream_end = number(streams["end_address"])
    if any(target < stream_address or target > stream_end for target in targets):
        errors.append("World 3 behavior pointer is outside declared streams")
    if any(left >= right for left, right in zip(targets, targets[1:])):
        errors.append("World 3 behavior pointers are not strictly increasing")
    stream_data = bank_slice(
        prg,
        bank,
        stream_address,
        stream_end - stream_address + 1,
    )
    if crc32(stream_data) != str(streams["crc32"]).lower():
        errors.append("World 3 behavior-stream CRC32 differs")

    return errors, {
        "object_count": capacity,
        "field_count": len(fields),
        "shuffle_group_count": len(registry.get("type_shuffle_groups", [])),
        "behavior_pointer_count": slot_count,
        "behavior_stream_bytes": len(stream_data),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prg", required=True, type=Path)
    parser.add_argument("--manifest", required=True, type=Path)
    args = parser.parse_args()
    try:
        errors, report = validate(
            args.prg.read_bytes(),
            load_manifest(args.manifest),
        )
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 3 object-data audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] World 3 initial registry: {report['object_count']} objects, "
        f"{report['field_count']} fields, {report['shuffle_group_count']} "
        f"type-shuffle groups; {report['behavior_pointer_count']} behavior "
        f"pointers, {report['behavior_stream_bytes']} stream bytes"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
