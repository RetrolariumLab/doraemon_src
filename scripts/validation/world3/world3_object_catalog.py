#!/usr/bin/env python3
"""Validate and losslessly edit the World 3 object/type data catalog."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any
import zlib


BANK_SIZE = 0x8000
CPU_BASE = 0x8000
REGISTRY_FIELDS = ("room", "type", "x", "y", "state")
TYPE_PROPERTIES = (
    "hit_points",
    "metasprite_base",
    "render_flags",
    "contact_damage",
    "score_reward_code",
)


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def crc32(data: bytes) -> str:
    return f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"


def byte_value(value: str | int, description: str) -> int:
    result = number(value)
    if not 0 <= result <= 0xFF:
        raise ValueError(f"{description} is outside byte range")
    return result


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("World 3 object catalog range is outside PRG")
    return prg[offset:offset + size]


def load_json(path: Path, description: str) -> dict[str, Any]:
    document = json.loads(path.read_text(encoding="utf-8"))
    if document.get("schema_version") != 1:
        raise ValueError(f"unsupported {description} schema")
    return document


def named_entries(
    entries: Any,
    names: tuple[str, ...],
    description: str,
) -> dict[str, dict[str, Any]]:
    if not isinstance(entries, list):
        raise ValueError(f"{description} must be a list")
    result: dict[str, dict[str, Any]] = {}
    for entry in entries:
        name = str(entry.get("name", ""))
        if not name or name in result:
            raise ValueError(f"duplicate or empty {description} name: {name!r}")
        result[name] = entry
    if tuple(result) != names:
        raise ValueError(f"{description} order differs from runtime layout")
    return result


def indexed_entries(
    entries: Any,
    count: int,
    description: str,
) -> list[dict[str, Any]]:
    if not isinstance(entries, list) or len(entries) != count:
        raise ValueError(f"{description} must contain {count} entries")
    if [int(entry.get("id", -1)) for entry in entries] != list(range(count)):
        raise ValueError(f"{description} ids are not contiguous")
    return entries


def add_region(
    result: dict[int, int],
    address: int,
    data: bytes,
    description: str,
) -> None:
    for offset, value in enumerate(data):
        byte_address = address + offset
        if byte_address in result:
            raise ValueError(
                f"{description} overlaps another region at ${byte_address:04X}"
            )
        result[byte_address] = value


def manifest_regions(
    object_data: dict[str, Any],
    entity_types: dict[str, Any],
) -> dict[str, tuple[int, bytes, str]]:
    bank = int(object_data["bank"])
    if bank != int(entity_types["bank"]):
        raise ValueError("World 3 object/type manifest banks differ")

    registry = object_data["initial_registry"]
    capacity = int(registry["capacity"])
    if registry.get("layout") != "structure-of-arrays":
        raise ValueError("World 3 registry is not structure-of-arrays")
    fields = named_entries(
        registry["fields"], REGISTRY_FIELDS, "registry field"
    )
    registry_data = bytearray()
    for name in REGISTRY_FIELDS:
        values = fields[name]["values"]
        if len(values) != capacity:
            raise ValueError(f"registry field {name} has the wrong size")
        registry_data.extend(
            byte_value(value, f"registry {name}") for value in values
        )

    type_count = int(entity_types["type_count"])
    properties = named_entries(
        entity_types["property_tables"],
        TYPE_PROPERTIES,
        "entity property",
    )
    result = {
        "persistent_registry": (
            number(registry["address"]),
            bytes(registry_data),
            str(registry["crc32"]).lower(),
        )
    }
    for name in TYPE_PROPERTIES:
        table = properties[name]
        values = table["values"]
        if len(values) != type_count:
            raise ValueError(f"entity property {name} has the wrong size")
        result[name] = (
            number(table["address"]),
            bytes(byte_value(value, name) for value in values),
            str(table["crc32"]).lower(),
        )
    return result


def validate_manifest_data(
    prg: bytes,
    object_data: dict[str, Any],
    entity_types: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    bank = int(object_data["bank"])
    regions = manifest_regions(object_data, entity_types)
    errors: list[str] = []
    covered: set[int] = set()
    for name, (address, expected, expected_crc) in regions.items():
        actual = bank_slice(prg, bank, address, len(expected))
        if actual != expected:
            errors.append(f"World 3 {name} differs from PRG")
        if crc32(expected) != expected_crc:
            errors.append(f"World 3 {name} manifest CRC32 differs")
        addresses = set(range(address, address + len(expected)))
        if covered & addresses:
            errors.append(f"World 3 {name} overlaps another catalog region")
        covered.update(addresses)
    return errors, {
        "registry_record_count": int(
            object_data["initial_registry"]["capacity"]
        ),
        "entity_type_count": int(entity_types["type_count"]),
        "property_table_count": len(entity_types["property_tables"]),
        "covered_byte_count": len(covered),
    }


def encode_authoring(document: dict[str, Any]) -> dict[int, int]:
    if document.get("schema_version") != 1 or document.get("format") != (
        "doraemon-world3-object-catalog"
    ):
        raise ValueError("unsupported World 3 object authoring schema")
    if int(document["bank"]) != 2:
        raise ValueError("World 3 object authoring must target PRG bank 2")

    result: dict[int, int] = {}
    registry = document["persistent_registry"]
    capacity = int(registry["capacity"])
    records = indexed_entries(
        registry["records"], capacity, "persistent registry"
    )
    registry_data = bytes(
        byte_value(record[name], f"registry {name}")
        for name in REGISTRY_FIELDS
        for record in records
    )
    add_region(
        result,
        number(registry["address"]),
        registry_data,
        "persistent registry",
    )

    types = document["entity_types"]
    type_count = int(types["type_count"])
    type_records = indexed_entries(
        types["records"], type_count, "entity types"
    )
    addresses = types["property_addresses"]
    if tuple(addresses) != TYPE_PROPERTIES:
        raise ValueError("entity property address order differs from runtime")
    for name in TYPE_PROPERTIES:
        data = bytes(
            byte_value(record[name], f"entity type {name}")
            for record in type_records
        )
        add_region(result, number(addresses[name]), data, name)
    return result


def decode_authoring(
    prg: bytes,
    object_data: dict[str, Any],
    entity_types: dict[str, Any],
) -> dict[str, Any]:
    errors, report = validate_manifest_data(prg, object_data, entity_types)
    if errors:
        raise ValueError("; ".join(errors))
    bank = int(object_data["bank"])
    registry = object_data["initial_registry"]
    capacity = int(registry["capacity"])
    registry_address = number(registry["address"])
    registry_data = bank_slice(prg, bank, registry_address, capacity * 5)

    properties = named_entries(
        entity_types["property_tables"],
        TYPE_PROPERTIES,
        "entity property",
    )
    type_count = int(entity_types["type_count"])
    property_data = {
        name: bank_slice(prg, bank, number(properties[name]["address"]), type_count)
        for name in TYPE_PROPERTIES
    }
    result: dict[str, Any] = {
        "schema_version": 1,
        "format": "doraemon-world3-object-catalog",
        "bank": bank,
        "persistent_registry": {
            "address": registry["address"],
            "capacity": capacity,
            "records": [
                {
                    "id": index,
                    **{
                        name: f"0x{registry_data[field * capacity + index]:02X}"
                        for field, name in enumerate(REGISTRY_FIELDS)
                    },
                }
                for index in range(capacity)
            ],
        },
        "entity_types": {
            "type_count": type_count,
            "property_addresses": {
                name: properties[name]["address"] for name in TYPE_PROPERTIES
            },
            "records": [
                {
                    "id": index,
                    **{
                        name: f"0x{property_data[name][index]:02X}"
                        for name in TYPE_PROPERTIES
                    },
                }
                for index in range(type_count)
            ],
        },
        "covered_byte_count": report["covered_byte_count"],
        "covered_crc32": "00000000",
    }
    encoded = encode_authoring(result)
    result["covered_crc32"] = crc32(
        bytes(encoded[address] for address in sorted(encoded))
    )
    if any(
        bank_slice(prg, bank, address, 1)[0] != value
        for address, value in encoded.items()
    ):
        raise ValueError("World 3 object authoring differs after decode")
    return result


def validate_authoring(
    prg: bytes,
    object_data: dict[str, Any],
    entity_types: dict[str, Any],
    path: Path,
) -> list[str]:
    document = json.loads(path.read_text(encoding="utf-8"))
    encoded = encode_authoring(document)
    canonical = encode_authoring(
        decode_authoring(prg, object_data, entity_types)
    )
    errors: list[str] = []
    if len(encoded) != int(document["covered_byte_count"]):
        errors.append("World 3 object authoring covered-byte count differs")
    encoded_crc = crc32(bytes(encoded[address] for address in sorted(encoded)))
    if encoded_crc != str(document["covered_crc32"]).lower():
        errors.append("World 3 object authoring covered-byte CRC32 differs")
    if set(encoded) != set(canonical):
        errors.append("World 3 object authoring coverage differs from manifests")
    elif encoded != canonical:
        errors.append("World 3 object authoring roundtrip differs from PRG")
    return errors


def apply_authoring(prg: bytes, document: dict[str, Any]) -> bytes:
    if len(prg) != 4 * BANK_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    bank = int(document["bank"])
    result = bytearray(prg)
    for address, value in encode_authoring(document).items():
        offset = bank * BANK_SIZE + address - CPU_BASE
        if not 0 <= offset < len(result):
            raise ValueError("World 3 object authoring address is outside PRG")
        result[offset] = value
    return bytes(result)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    for name in ("validate", "decode"):
        command = subparsers.add_parser(name)
        command.add_argument("--prg", required=True, type=Path)
        command.add_argument("--object-data", required=True, type=Path)
        command.add_argument("--entity-types", required=True, type=Path)
        if name == "validate":
            command.add_argument("--authoring", required=True, type=Path)
        else:
            command.add_argument("--output", required=True, type=Path)
    encode_parser = subparsers.add_parser("encode")
    encode_parser.add_argument("--input", required=True, type=Path)
    encode_parser.add_argument("--base-prg", required=True, type=Path)
    encode_parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    try:
        if args.command == "encode":
            document = load_json(args.input, "World 3 object authoring")
            encoded = apply_authoring(args.base_prg.read_bytes(), document)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_bytes(encoded)
            print(
                f"[OK] wrote PRG with {document['covered_byte_count']} "
                "World 3 object-catalog bytes"
            )
            return 0
        prg = args.prg.read_bytes()
        object_data = load_json(args.object_data, "World 3 object-data")
        entity_types = load_json(args.entity_types, "World 3 entity-type")
        if args.command == "decode":
            decoded = decode_authoring(prg, object_data, entity_types)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_text(
                json.dumps(decoded, indent=2) + "\n",
                encoding="utf-8",
                newline="\n",
            )
            print(f"[OK] wrote World 3 object catalog to {args.output}")
            return 0
        errors, report = validate_manifest_data(prg, object_data, entity_types)
        errors.extend(
            validate_authoring(prg, object_data, entity_types, args.authoring)
        )
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 3 object-catalog audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] World 3 object catalog: {report['registry_record_count']} "
        f"persistent records, {report['entity_type_count']} entity types, "
        f"{report['property_table_count']} property tables; "
        f"{report['covered_byte_count']} lossless authoring bytes"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
