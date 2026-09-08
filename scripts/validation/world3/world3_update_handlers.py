#!/usr/bin/env python3
"""Validate World 3 per-type update roles and editable handler-owned data."""

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


def signed(value: int) -> int:
    return value if value < 0x80 else value - 0x100


def crc32(data: bytes) -> str:
    return f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("World 3 update-handler range is outside PRG")
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
        raise ValueError("World 3 update dispatch is missing or duplicated")
    return matches[0]


def validate_manifest(
    prg: bytes,
    manifest: dict[str, Any],
    dispatch: dict[str, Any],
    entity_types: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if manifest.get("schema_version") != 1:
        return ["unsupported World 3 update-handler schema"], {}
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    errors: list[str] = []
    count = int(manifest["type_count"])
    handlers = manifest["handlers"]
    if count != 32 or int(entity_types.get("type_count", -1)) != count:
        errors.append("World 3 update-handler type count differs")
    if len(handlers) != count or [int(entry["type"]) for entry in handlers] != list(range(count)):
        errors.append("World 3 update-handler types are not contiguous")
    if any(not str(entry.get("role", "")) for entry in handlers):
        errors.append("World 3 update-handler role is empty")
    try:
        table = dispatch_table(manifest, dispatch)
    except ValueError as exc:
        errors.append(str(exc))
        table = {}
    declared_targets = [number(entry["target"]) for entry in handlers]
    actual_targets = [number(target) for target in table.get("targets", [])]
    if (
        int(table.get("bank", -1)) != int(manifest["bank"])
        or int(table.get("slot_count", -1)) != count
        or actual_targets != declared_targets
    ):
        errors.append("World 3 update dispatch contract differs")
    regions = manifest["data_regions"]
    names = [str(region["name"]) for region in regions]
    if len(names) != len(set(names)):
        errors.append("World 3 update data-region names are duplicated")
    data = region_data(prg, manifest)
    occupied: set[int] = set()
    combined = bytearray()
    for region in regions:
        name = str(region["name"])
        payload = data[name]
        address = number(region["address"])
        addresses = set(range(address, address + len(payload)))
        if occupied & addresses:
            errors.append("World 3 update data regions overlap")
        occupied |= addresses
        combined.extend(payload)
        if crc32(payload) != str(region["crc32"]).lower():
            errors.append(f"World 3 update data CRC32 differs for {name}")
    if len(combined) != int(manifest["covered_byte_count"]):
        errors.append("World 3 update covered-byte count differs")
    if crc32(bytes(combined)) != str(manifest["covered_crc32"]).lower():
        errors.append("World 3 update covered CRC32 differs")
    tracking = data.get("type04_tracking_enabled_by_room", b"")
    blocked = data.get("type05_relocation_blocked_by_room", b"")
    motion = data.get("type05_held_motion", b"")
    metrics = manifest["expected_metrics"]
    if len(tracking) != 64 or set(tracking) - {0, 1} or sum(tracking) != int(metrics["tracking_enabled_rooms"]):
        errors.append("World 3 type 04 tracking-room flags differ")
    if len(blocked) != 64 or set(blocked) - {0, 1} or sum(blocked) != int(metrics["relocation_blocked_rooms"]):
        errors.append("World 3 type 05 relocation-room flags differ")
    vectors = [
        [signed(motion[index]), signed(motion[4 + index])]
        for index in range(4)
    ] if len(motion) == 8 else []
    if vectors != metrics["held_motion_vectors"]:
        errors.append("World 3 type 05 held-motion vectors differ")
    for signature in manifest["signatures"]:
        raw = bytes.fromhex(str(signature["bytes"]))
        if bank_slice(prg, int(manifest["bank"]), number(signature["address"]), len(raw)) != raw:
            errors.append(
                f"World 3 update-handler signature differs at ${number(signature['address']):04X}"
            )
    return errors, {
        "type_count": count,
        "unique_target_count": len(set(declared_targets)),
        "unique_role_count": len({str(entry["role"]) for entry in handlers}),
        "data_byte_count": len(combined),
    }


def encode_authoring(document: dict[str, Any], manifest: dict[str, Any]) -> dict[int, int]:
    if document.get("schema_version") != 1 or document.get("format") != (
        "doraemon-world3-update-handler-data"
    ):
        raise ValueError("unsupported World 3 update-handler authoring schema")
    if int(document["bank"]) != int(manifest["bank"]):
        raise ValueError("World 3 update-handler authoring targets the wrong bank")
    authored = document.get("regions")
    if not isinstance(authored, list):
        raise ValueError("World 3 update-handler authoring regions are missing")
    by_name = {str(region.get("name")): region for region in authored}
    if len(by_name) != len(authored):
        raise ValueError("World 3 update-handler region names are duplicated")
    result: dict[int, int] = {}
    expected_names = {str(spec["name"]) for spec in manifest["data_regions"]}
    if set(by_name) != expected_names:
        raise ValueError("World 3 update-handler authoring regions differ")
    for spec in manifest["data_regions"]:
        name = str(spec["name"])
        records = by_name[name].get("records")
        count = int(spec["count"])
        fields = [str(field) for field in spec["fields"]]
        if not isinstance(records, list) or len(records) != count:
            raise ValueError(f"World 3 update-handler region {name} count differs")
        if [int(record.get("index", -1)) for record in records] != list(range(count)):
            raise ValueError(f"World 3 update-handler region {name} indexes differ")
        address = number(spec["address"])
        offset = 0
        for field in fields:
            for record in records:
                value = number(record[field])
                if not 0 <= value <= 0xFF:
                    raise ValueError("World 3 update-handler authoring byte is out of range")
                if address + offset in result:
                    raise ValueError("World 3 update-handler authoring regions overlap")
                result[address + offset] = value
                offset += 1
    return result


def decode_authoring(
    prg: bytes,
    manifest: dict[str, Any],
    dispatch: dict[str, Any],
    entity_types: dict[str, Any],
) -> dict[str, Any]:
    errors, _report = validate_manifest(prg, manifest, dispatch, entity_types)
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
        "format": "doraemon-world3-update-handler-data",
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
    entity_types: dict[str, Any],
    path: Path,
) -> list[str]:
    document = json.loads(path.read_text(encoding="utf-8"))
    encoded = encode_authoring(document, manifest)
    canonical = encode_authoring(
        decode_authoring(prg, manifest, dispatch, entity_types), manifest
    )
    payload = bytes(encoded[address] for address in sorted(encoded))
    errors: list[str] = []
    if len(encoded) != int(document["covered_byte_count"]):
        errors.append("World 3 update-handler authoring byte count differs")
    if crc32(payload) != str(document["covered_crc32"]).lower():
        errors.append("World 3 update-handler authoring CRC32 differs")
    if encoded != canonical:
        errors.append("World 3 update-handler authoring roundtrip differs from PRG")
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
    validate_parser.add_argument("--entity-types", required=True, type=Path)
    validate_parser.add_argument("--authoring", required=True, type=Path)
    decode_parser = subparsers.add_parser("decode")
    decode_parser.add_argument("--prg", required=True, type=Path)
    decode_parser.add_argument("--manifest", required=True, type=Path)
    decode_parser.add_argument("--object-dispatch", required=True, type=Path)
    decode_parser.add_argument("--entity-types", required=True, type=Path)
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
            print(f"[OK] wrote PRG with {len(encode_authoring(document, manifest))} update-data bytes")
            return 0
        prg = args.prg.read_bytes()
        dispatch = json.loads(args.object_dispatch.read_text(encoding="utf-8"))
        entity_types = json.loads(args.entity_types.read_text(encoding="utf-8"))
        if args.command == "decode":
            document = decode_authoring(prg, manifest, dispatch, entity_types)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_text(json.dumps(document, indent=2) + "\n", encoding="utf-8", newline="\n")
            print(f"[OK] wrote World 3 update-handler data to {args.output}")
            return 0
        errors, report = validate_manifest(prg, manifest, dispatch, entity_types)
        errors.extend(validate_authoring(prg, manifest, dispatch, entity_types, args.authoring))
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 3 update-handler audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] World 3 update handlers: {report['type_count']} types, "
        f"{report['unique_target_count']} unique targets, "
        f"{report['unique_role_count']} structural roles, "
        f"{report['data_byte_count']} lossless data bytes"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
