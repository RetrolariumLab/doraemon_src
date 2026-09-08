#!/usr/bin/env python3
"""Validate World 3 transient initializer modes and editable formation data."""

from __future__ import annotations

import argparse
from collections import Counter
import json
from pathlib import Path
from typing import Any
import zlib


BANK_SIZE = 0x8000
CPU_BASE = 0x8000
ALLOWED_MODES = {
    "room_range_random_metasprite_variant",
    "room_range_random_metasprite_and_flags",
    "fixed_position_state_and_optional_sound",
    "room_table_metasprite_variant",
    "set_clone_budget",
    "no_op",
    "punishment_room_dorayaki_or_skull",
    "room_flag_gated_fixed_position",
    "room_flag_gated_type08_09_group",
    "type0a_0b_encounter_group",
    "type0c_0f_four_object_formation",
}


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def crc32(data: bytes) -> str:
    return f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("World 3 initializer range is outside PRG")
    return prg[offset:offset + size]


def region_size(region: dict[str, Any]) -> int:
    return int(region["count"]) * len(region["fields"])


def region_data(prg: bytes, manifest: dict[str, Any]) -> dict[str, bytes]:
    bank = int(manifest["bank"])
    return {
        str(region["name"]): bank_slice(
            prg, bank, number(region["address"]), region_size(region)
        )
        for region in manifest["data_regions"]
    }


def dispatch_table(manifest: dict[str, Any], dispatch: dict[str, Any]) -> dict[str, Any]:
    matches = [
        table for table in dispatch.get("tables", [])
        if table.get("name") == manifest["dispatch_name"]
    ]
    if len(matches) != 1:
        raise ValueError("World 3 initializer dispatch is missing or duplicated")
    return matches[0]


def schedule_metrics(document: dict[str, Any], initializer_count: int) -> tuple[list[int], list[int]]:
    records = Counter()
    budgets = Counter()
    for room in document.get("rooms", []):
        for channel in room.get("channels", []):
            entity_type = number(channel["type"])
            count = number(channel["count"])
            if not 0 <= entity_type < initializer_count:
                raise ValueError("World 3 scheduled type exceeds initializer domain")
            if count:
                records[entity_type] += 1
                budgets[entity_type] += count
    return (
        [records[index] for index in range(initializer_count)],
        [budgets[index] for index in range(initializer_count)],
    )


def validate_manifest(
    prg: bytes,
    manifest: dict[str, Any],
    dispatch: dict[str, Any],
    transient: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if manifest.get("schema_version") != 1:
        return ["unsupported World 3 initializer schema"], {}
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    errors: list[str] = []
    count = int(manifest["initializer_count"])
    initializers = manifest["initializers"]
    if count != 16 or len(initializers) != count:
        errors.append("World 3 initializer count differs")
    if [int(entry["type"]) for entry in initializers] != list(range(count)):
        errors.append("World 3 initializer types are not contiguous")
    if any(str(entry["mode"]) not in ALLOWED_MODES for entry in initializers):
        errors.append("World 3 initializer mode is unknown")
    try:
        table = dispatch_table(manifest, dispatch)
    except ValueError as exc:
        errors.append(str(exc))
        table = {}
    targets = [number(target) for target in table.get("targets", [])]
    declared_targets = [number(entry["target"]) for entry in initializers]
    if (
        int(table.get("bank", -1)) != int(manifest["bank"])
        or int(table.get("slot_count", -1)) != count
        or targets != declared_targets
    ):
        errors.append("World 3 initializer dispatch contract differs")
    try:
        schedule_records, spawn_budgets = schedule_metrics(transient, count)
    except (KeyError, TypeError, ValueError) as exc:
        errors.append(str(exc))
        schedule_records, spawn_budgets = [], []
    if schedule_records and schedule_records != [
        int(entry["schedule_records"]) for entry in initializers
    ]:
        errors.append("World 3 initializer schedule-record counts differ")
    if spawn_budgets and spawn_budgets != [
        int(entry["spawn_budget"]) for entry in initializers
    ]:
        errors.append("World 3 initializer spawn budgets differ")
    regions = manifest["data_regions"]
    names = [str(region["name"]) for region in regions]
    if len(names) != len(set(names)):
        errors.append("World 3 initializer data-region names are duplicated")
    data = region_data(prg, manifest)
    combined = bytearray()
    occupied: set[int] = set()
    for region in regions:
        name = str(region["name"])
        payload = data[name]
        address = number(region["address"])
        addresses = set(range(address, address + len(payload)))
        if occupied & addresses:
            errors.append("World 3 initializer data regions overlap")
        occupied |= addresses
        combined.extend(payload)
        if crc32(payload) != str(region["crc32"]).lower():
            errors.append(f"World 3 initializer data CRC32 differs for {name}")
    if len(combined) != int(manifest["covered_byte_count"]):
        errors.append("World 3 initializer covered-byte count differs")
    if crc32(bytes(combined)) != str(manifest["covered_crc32"]).lower():
        errors.append("World 3 initializer covered CRC32 differs")
    room_flags = data.get("type03_room_variants", b"")
    if len(room_flags) != 64 or set(room_flags) - {0, 1}:
        errors.append("World 3 type 03 room-variant flags are invalid")
    for signature in manifest["signatures"]:
        raw = bytes.fromhex(str(signature["bytes"]))
        if bank_slice(prg, int(manifest["bank"]), number(signature["address"]), len(raw)) != raw:
            errors.append(
                f"World 3 initializer signature differs at ${number(signature['address']):04X}"
            )
    return errors, {
        "initializer_count": count,
        "unique_target_count": len(set(declared_targets)),
        "scheduled_type_count": sum(value != 0 for value in schedule_records),
        "data_byte_count": len(combined),
    }


def encode_authoring(document: dict[str, Any], manifest: dict[str, Any]) -> dict[int, int]:
    if document.get("schema_version") != 1 or document.get("format") != (
        "doraemon-world3-spawn-initializer-data"
    ):
        raise ValueError("unsupported World 3 initializer authoring schema")
    if int(document["bank"]) != int(manifest["bank"]):
        raise ValueError("World 3 initializer authoring targets the wrong bank")
    authored = document.get("regions")
    if not isinstance(authored, list):
        raise ValueError("World 3 initializer authoring regions are missing")
    by_name = {str(region.get("name")): region for region in authored}
    if len(by_name) != len(authored):
        raise ValueError("World 3 initializer authoring region names are duplicated")
    result: dict[int, int] = {}
    for spec in manifest["data_regions"]:
        name = str(spec["name"])
        if name not in by_name:
            raise ValueError(f"World 3 initializer authoring region {name} is missing")
        records = by_name[name].get("records")
        count = int(spec["count"])
        fields = [str(field) for field in spec["fields"]]
        if not isinstance(records, list) or len(records) != count:
            raise ValueError(f"World 3 initializer authoring region {name} count differs")
        if [int(record.get("index", -1)) for record in records] != list(range(count)):
            raise ValueError(f"World 3 initializer authoring region {name} indexes differ")
        address = number(spec["address"])
        offset = 0
        for field in fields:
            for record in records:
                value = number(record[field])
                if not 0 <= value <= 0xFF:
                    raise ValueError("World 3 initializer authoring byte is out of range")
                if address + offset in result:
                    raise ValueError("World 3 initializer authoring regions overlap")
                result[address + offset] = value
                offset += 1
    if set(by_name) != {str(spec["name"]) for spec in manifest["data_regions"]}:
        raise ValueError("World 3 initializer authoring has an unknown region")
    return result


def decode_authoring(
    prg: bytes,
    manifest: dict[str, Any],
    dispatch: dict[str, Any],
    transient: dict[str, Any],
) -> dict[str, Any]:
    errors, _report = validate_manifest(prg, manifest, dispatch, transient)
    if errors:
        raise ValueError("; ".join(errors))
    data = region_data(prg, manifest)
    regions = []
    for spec in manifest["data_regions"]:
        name = str(spec["name"])
        count = int(spec["count"])
        fields = [str(field) for field in spec["fields"]]
        payload = data[name]
        regions.append({
            "name": name,
            "address": spec["address"],
            "records": [
                {
                    "index": index,
                    **{
                        field: f"0x{payload[field_index * count + index]:02X}"
                        for field_index, field in enumerate(fields)
                    },
                }
                for index in range(count)
            ],
        })
    result: dict[str, Any] = {
        "schema_version": 1,
        "format": "doraemon-world3-spawn-initializer-data",
        "bank": int(manifest["bank"]),
        "regions": regions,
        "covered_byte_count": int(manifest["covered_byte_count"]),
        "covered_crc32": "00000000",
    }
    encoded = encode_authoring(result, manifest)
    result["covered_crc32"] = crc32(bytes(encoded[address] for address in sorted(encoded)))
    return result


def validate_authoring(
    prg: bytes,
    manifest: dict[str, Any],
    dispatch: dict[str, Any],
    transient: dict[str, Any],
    path: Path,
) -> list[str]:
    document = json.loads(path.read_text(encoding="utf-8"))
    encoded = encode_authoring(document, manifest)
    canonical = encode_authoring(
        decode_authoring(prg, manifest, dispatch, transient), manifest
    )
    payload = bytes(encoded[address] for address in sorted(encoded))
    errors: list[str] = []
    if len(encoded) != int(document["covered_byte_count"]):
        errors.append("World 3 initializer authoring byte count differs")
    if crc32(payload) != str(document["covered_crc32"]).lower():
        errors.append("World 3 initializer authoring CRC32 differs")
    if encoded != canonical:
        errors.append("World 3 initializer authoring roundtrip differs from PRG")
    return errors


def apply_authoring(prg: bytes, document: dict[str, Any], manifest: dict[str, Any]) -> bytes:
    if len(prg) != 4 * BANK_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    result = bytearray(prg)
    bank = int(manifest["bank"])
    for address, value in encode_authoring(document, manifest).items():
        result[bank * BANK_SIZE + address - CPU_BASE] = value
    return bytes(result)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    validate_parser = subparsers.add_parser("validate")
    validate_parser.add_argument("--prg", required=True, type=Path)
    validate_parser.add_argument("--manifest", required=True, type=Path)
    validate_parser.add_argument("--object-dispatch", required=True, type=Path)
    validate_parser.add_argument("--transient-authoring", required=True, type=Path)
    validate_parser.add_argument("--authoring", required=True, type=Path)
    decode_parser = subparsers.add_parser("decode")
    decode_parser.add_argument("--prg", required=True, type=Path)
    decode_parser.add_argument("--manifest", required=True, type=Path)
    decode_parser.add_argument("--object-dispatch", required=True, type=Path)
    decode_parser.add_argument("--transient-authoring", required=True, type=Path)
    decode_parser.add_argument("--output", required=True, type=Path)
    encode_parser = subparsers.add_parser("encode")
    encode_parser.add_argument("--input", required=True, type=Path)
    encode_parser.add_argument("--manifest", required=True, type=Path)
    encode_parser.add_argument("--base-prg", required=True, type=Path)
    encode_parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    try:
        manifest = json.loads(args.manifest.read_text(encoding="utf-8"))
        if args.command == "encode":
            document = json.loads(args.input.read_text(encoding="utf-8"))
            output = apply_authoring(args.base_prg.read_bytes(), document, manifest)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_bytes(output)
            print(f"[OK] wrote PRG with {len(encode_authoring(document, manifest))} initializer-data bytes")
            return 0
        prg = args.prg.read_bytes()
        dispatch = json.loads(args.object_dispatch.read_text(encoding="utf-8"))
        transient = json.loads(args.transient_authoring.read_text(encoding="utf-8"))
        if args.command == "decode":
            document = decode_authoring(prg, manifest, dispatch, transient)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_text(json.dumps(document, indent=2) + "\n", encoding="utf-8", newline="\n")
            print(f"[OK] wrote World 3 initializer data to {args.output}")
            return 0
        errors, report = validate_manifest(prg, manifest, dispatch, transient)
        errors.extend(validate_authoring(prg, manifest, dispatch, transient, args.authoring))
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 3 initializer audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] World 3 spawn initializers: {report['initializer_count']} types, "
        f"{report['unique_target_count']} unique targets, "
        f"{report['scheduled_type_count']} scheduled types, "
        f"{report['data_byte_count']} lossless data bytes"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
