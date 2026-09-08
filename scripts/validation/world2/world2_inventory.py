#!/usr/bin/env python3
"""Validate World 2 inventory state arrays and editable spawn-screen data."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any
import zlib


BANK_SIZE = 0x8000
CPU_BASE = 0x8000
EXPECTED_STATES = {
    0: "absent",
    1: "entering",
    2: "homing_to_player",
    3: "active",
    4: "knocked_loose",
}


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def crc32(data: bytes) -> str:
    return f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("World 2 inventory range is outside PRG")
    return prg[offset:offset + size]


def state_contract(manifest: dict[str, Any]) -> dict[int, str]:
    states = {
        int(entry["value"]): str(entry["name"])
        for entry in manifest["states"]
    }
    if states != EXPECTED_STATES:
        raise ValueError("World 2 inventory state contract differs")
    return states


def screen_bytes(prg: bytes, manifest: dict[str, Any]) -> bytes:
    spec = manifest["eligible_screen_table"]
    return bank_slice(
        prg,
        int(manifest["bank"]),
        number(spec["address"]),
        int(spec["count"]),
    )


def validate_pool(
    manifest: dict[str, Any], pools: dict[str, Any]
) -> list[str]:
    matches = [
        pool
        for pool in pools.get("pools", [])
        if pool.get("id") == manifest["pool_id"]
    ]
    if len(matches) != 1:
        return ["World 2 inventory pool is missing or duplicated"]
    pool = matches[0]
    expected_fields = [
        manifest["fields"][name] for name in ("state", "x", "y")
    ]
    actual_fields = [field.get("symbol") for field in pool.get("fields", [])]
    errors: list[str] = []
    if int(pool.get("bank", -1)) != int(manifest["bank"]):
        errors.append("World 2 inventory pool bank differs")
    if int(pool.get("capacity", 0)) != int(manifest["capacity"]):
        errors.append("World 2 inventory pool capacity differs")
    if actual_fields != expected_fields:
        errors.append("World 2 inventory pool fields differ")
    layout = pool.get("layout", {})
    if (
        number(layout.get("start", -1)) != 0x007C
        or int(layout.get("field_stride", 0)) != 7
        or int(layout.get("field_count", 0)) != 3
    ):
        errors.append("World 2 inventory pool layout differs")
    return errors


def validate_manifest(
    prg: bytes,
    manifest: dict[str, Any],
    pools: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if manifest.get("schema_version") != 1:
        return ["unsupported World 2 inventory schema"], {}
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    errors: list[str] = []
    try:
        state_contract(manifest)
    except ValueError as exc:
        errors.append(str(exc))
    capacity = int(manifest["capacity"])
    data = screen_bytes(prg, manifest)
    spec = manifest["eligible_screen_table"]
    if len(data) != capacity or int(spec["count"]) != capacity:
        errors.append("World 2 inventory screen-table count differs")
    if crc32(data) != str(spec["crc32"]).lower():
        errors.append("World 2 inventory screen-table CRC32 differs")
    if len(set(data)) != len(data) or any(value > 0x76 for value in data):
        errors.append("World 2 inventory eligible screens are invalid")
    bank = int(manifest["bank"])
    for signature in manifest["signatures"]:
        raw = bytes.fromhex(str(signature["bytes"]))
        if bank_slice(
            prg, bank, number(signature["address"]), len(raw)
        ) != raw:
            errors.append(
                f"World 2 inventory signature differs at "
                f"${number(signature['address']):04X}"
            )
    errors.extend(validate_pool(manifest, pools))
    return errors, {
        "capacity": capacity,
        "state_count": len(EXPECTED_STATES),
        "eligible_screen_count": len(data),
        "signature_count": len(manifest["signatures"]),
    }


def encode_authoring(
    document: dict[str, Any], manifest: dict[str, Any]
) -> bytes:
    if document.get("schema_version") != 1 or document.get("format") != (
        "doraemon-world2-inventory-spawn-screens"
    ):
        raise ValueError("unsupported World 2 inventory authoring schema")
    if int(document["bank"]) != int(manifest["bank"]):
        raise ValueError("World 2 inventory authoring bank differs")
    count = int(manifest["eligible_screen_table"]["count"])
    entries = document.get("eligible_screens")
    if not isinstance(entries, list) or len(entries) != count:
        raise ValueError(f"World 2 inventory authoring requires {count} screens")
    if [int(entry.get("index", -1)) for entry in entries] != list(range(count)):
        raise ValueError("World 2 inventory screen indexes are not contiguous")
    values = bytes(number(entry["screen_id"]) for entry in entries)
    if len(set(values)) != len(values) or any(value > 0x76 for value in values):
        raise ValueError("World 2 inventory authoring screens are invalid")
    return values


def decode_authoring(
    prg: bytes, manifest: dict[str, Any], pools: dict[str, Any]
) -> dict[str, Any]:
    errors, _report = validate_manifest(prg, manifest, pools)
    if errors:
        raise ValueError("; ".join(errors))
    data = screen_bytes(prg, manifest)
    return {
        "schema_version": 1,
        "format": "doraemon-world2-inventory-spawn-screens",
        "bank": int(manifest["bank"]),
        "address": manifest["eligible_screen_table"]["address"],
        "eligible_screens": [
            {"index": index, "screen_id": f"0x{value:02X}"}
            for index, value in enumerate(data)
        ],
        "covered_byte_count": len(data),
        "covered_crc32": crc32(data),
    }


def validate_authoring(
    prg: bytes,
    manifest: dict[str, Any],
    pools: dict[str, Any],
    path: Path,
) -> list[str]:
    document = json.loads(path.read_text(encoding="utf-8"))
    encoded = encode_authoring(document, manifest)
    canonical = encode_authoring(
        decode_authoring(prg, manifest, pools), manifest
    )
    errors: list[str] = []
    if len(encoded) != int(document["covered_byte_count"]):
        errors.append("World 2 inventory covered-byte count differs")
    if crc32(encoded) != str(document["covered_crc32"]).lower():
        errors.append("World 2 inventory covered-byte CRC32 differs")
    if encoded != canonical:
        errors.append("World 2 inventory authoring roundtrip differs from PRG")
    return errors


def apply_authoring(
    prg: bytes, document: dict[str, Any], manifest: dict[str, Any]
) -> bytes:
    if len(prg) != 4 * BANK_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    result = bytearray(prg)
    data = encode_authoring(document, manifest)
    bank = int(manifest["bank"])
    address = number(manifest["eligible_screen_table"]["address"])
    offset = bank * BANK_SIZE + address - CPU_BASE
    result[offset:offset + len(data)] = data
    return bytes(result)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    validate_parser = subparsers.add_parser("validate")
    validate_parser.add_argument("--prg", required=True, type=Path)
    validate_parser.add_argument("--manifest", required=True, type=Path)
    validate_parser.add_argument("--object-pools", required=True, type=Path)
    validate_parser.add_argument("--authoring", required=True, type=Path)
    decode_parser = subparsers.add_parser("decode")
    decode_parser.add_argument("--prg", required=True, type=Path)
    decode_parser.add_argument("--manifest", required=True, type=Path)
    decode_parser.add_argument("--object-pools", required=True, type=Path)
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
            result = apply_authoring(args.base_prg.read_bytes(), document, manifest)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_bytes(result)
            print(f"[OK] wrote PRG with {len(encode_authoring(document, manifest))} inventory bytes")
            return 0
        prg = args.prg.read_bytes()
        pools = json.loads(args.object_pools.read_text(encoding="utf-8"))
        if args.command == "decode":
            document = decode_authoring(prg, manifest, pools)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_text(
                json.dumps(document, indent=2) + "\n",
                encoding="utf-8",
                newline="\n",
            )
            print(f"[OK] wrote World 2 inventory screens to {args.output}")
            return 0
        errors, report = validate_manifest(prg, manifest, pools)
        errors.extend(validate_authoring(prg, manifest, pools, args.authoring))
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 2 inventory audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] World 2 inventory: {report['capacity']} slots, "
        f"{report['state_count']} states, "
        f"{report['eligible_screen_count']} eligible screens, "
        f"{report['signature_count']} code signatures"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
