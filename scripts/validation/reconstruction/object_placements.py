#!/usr/bin/env python3
"""Validate packed chapter object-placement lists in the canonical PRG."""

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


def load_manifest(path: Path) -> dict[str, Any]:
    document = json.loads(path.read_text(encoding="utf-8"))
    if document.get("schema_version") != 1:
        raise ValueError("unsupported object placement schema")
    return document


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("object placement range is outside PRG")
    return prg[offset:offset + size]


def crc32(data: bytes) -> str:
    return f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"


def byte_value(value: str | int, description: str) -> int:
    result = number(value)
    if not 0 <= result <= 0xFF:
        raise ValueError(f"{description} is outside byte range")
    return result


def indexed_entries(
    values: Any,
    count: int,
    description: str,
) -> list[dict[str, Any]]:
    if not isinstance(values, list) or len(values) != count:
        raise ValueError(f"{description} must contain {count} entries")
    if [int(entry.get("id", -1)) for entry in values] != list(range(count)):
        raise ValueError(f"{description} ids are not contiguous")
    return values


def add_region(
    result: dict[int, int],
    address: int,
    data: bytes,
    description: str,
) -> None:
    for offset, value in enumerate(data):
        byte_address = address + offset
        previous = result.get(byte_address)
        if previous is not None and previous != value:
            raise ValueError(
                f"{description} conflicts with another region at "
                f"${byte_address:04X}"
            )
        result[byte_address] = value


def encode_authoring(document: dict[str, Any]) -> dict[int, int]:
    if document.get("schema_version") != 1 or document.get("format") != (
        "doraemon-world1-object-data"
    ):
        raise ValueError("unsupported World 1 object authoring schema")
    if int(document["bank"]) != 0:
        raise ValueError("World 1 object authoring must target PRG bank 0")

    result: dict[int, int] = {}
    placement_ids: set[str] = set()
    for placement in document["placement_lists"]:
        list_id = str(placement["id"])
        if not list_id or list_id in placement_ids:
            raise ValueError("placement-list ids must be non-empty and unique")
        placement_ids.add(list_id)
        record_count = int(placement["record_count"])
        records = indexed_entries(
            placement["records"], record_count, f"{list_id} placement records"
        )
        data = bytearray()
        for record in records:
            x_cell = byte_value(record["x_cell"], f"{list_id} x_cell")
            y_cell = byte_value(record["y_cell"], f"{list_id} y_cell")
            type_value = byte_value(record["type"], f"{list_id} type")
            if x_cell == 0:
                raise ValueError(f"{list_id} contains an early X terminator")
            data.extend((x_cell, y_cell, type_value))
        data.append(0)
        address = number(placement["address"])
        if number(placement["terminator_address"]) != address + 3 * record_count:
            raise ValueError(f"{list_id} terminator address differs from records")
        add_region(result, address, bytes(data), list_id)

    descriptors = document["descriptor_objects"]
    descriptor_count = int(descriptors["record_count"])
    descriptor_records = indexed_entries(
        descriptors["records"], descriptor_count, "descriptor records"
    )
    descriptor_data = bytearray()
    for record in descriptor_records:
        descriptor_data.extend(
            byte_value(record[field], f"descriptor {field}")
            for field in (
                "runtime_type",
                "metasprite_base",
                "render_flags",
                "primary_behavior",
            )
        )
    add_region(
        result,
        number(descriptors["address"]),
        bytes(descriptor_data),
        "descriptor table",
    )

    transient = document["transient_selector_table"]
    transient_values = bytes(
        byte_value(value, "transient descriptor index")
        for value in transient["descriptor_indexes"]
    )
    if any(value >= descriptor_count for value in transient_values):
        raise ValueError("transient descriptor index is outside descriptor table")
    add_region(
        result,
        number(transient["address"]),
        transient_values,
        "transient selector table",
    )

    collision_names: set[str] = set()
    for table in document["collision_tables"]:
        name = str(table["name"])
        if not name or name in collision_names:
            raise ValueError("collision-table names must be non-empty and unique")
        collision_names.add(name)
        values = bytes(
            byte_value(value, f"{name} value") for value in table["values"]
        )
        indexing = str(table["indexing"])
        expected_count = (
            descriptor_count + 1
            if indexing == "runtime_type"
            else descriptor_count
        )
        if indexing not in ("runtime_type", "runtime_type_minus_one"):
            raise ValueError(f"{name} uses unsupported collision indexing")
        if len(values) != expected_count:
            raise ValueError(f"{name} size differs from collision indexing")
        add_region(result, number(table["address"]), values, name)

    return result


def decode_authoring(
    prg: bytes,
    manifest: dict[str, Any],
) -> dict[str, Any]:
    errors, _report = validate(prg, manifest)
    if errors:
        raise ValueError("; ".join(errors))
    descriptor_spec = manifest["world1_descriptor_objects"]
    bank = int(descriptor_spec["bank"])

    placement_outputs: list[dict[str, Any]] = []
    for placement in manifest["lists"]:
        count = int(placement["record_count"])
        address = number(placement["address"])
        data = bank_slice(prg, bank, address, count * 3 + 1)
        placement_outputs.append({
            "id": placement["id"],
            "address": placement["address"],
            "record_count": count,
            "terminator_address": placement["terminator_address"],
            "records": [
                {
                    "id": index,
                    "x_cell": data[index * 3],
                    "y_cell": data[index * 3 + 1],
                    "type": f"0x{data[index * 3 + 2]:02X}",
                }
                for index in range(count)
            ],
        })

    descriptor_count = int(descriptor_spec["record_count"])
    descriptor_address = number(descriptor_spec["address"])
    descriptor_data = bank_slice(
        prg, bank, descriptor_address, descriptor_count * 4
    )
    descriptor_output = {
        "address": descriptor_spec["address"],
        "record_count": descriptor_count,
        "records": [
            {
                "id": index,
                "runtime_type": f"0x{descriptor_data[index * 4]:02X}",
                "metasprite_base": f"0x{descriptor_data[index * 4 + 1]:02X}",
                "render_flags": f"0x{descriptor_data[index * 4 + 2]:02X}",
                "primary_behavior": f"0x{descriptor_data[index * 4 + 3]:02X}",
            }
            for index in range(descriptor_count)
        ],
    }

    transient_spec = descriptor_spec["transient_selector_table"]
    transient_count = len(transient_spec["values"])
    transient_data = bank_slice(
        prg, bank, number(transient_spec["address"]), transient_count
    )
    collision_outputs = []
    for table in descriptor_spec["collision_tables"]:
        count = len(table["values"])
        data = bank_slice(prg, bank, number(table["address"]), count)
        collision_outputs.append({
            "name": table["name"],
            "address": table["address"],
            "indexing": table["indexing"],
            "values": [f"0x{value:02X}" for value in data],
        })

    result: dict[str, Any] = {
        "schema_version": 1,
        "format": "doraemon-world1-object-data",
        "bank": bank,
        "placement_lists": placement_outputs,
        "descriptor_objects": descriptor_output,
        "transient_selector_table": {
            "address": transient_spec["address"],
            "descriptor_indexes": list(transient_data),
        },
        "collision_tables": collision_outputs,
        "covered_byte_count": 0,
        "covered_crc32": "00000000",
    }
    encoded = encode_authoring(result)
    result["covered_byte_count"] = len(encoded)
    result["covered_crc32"] = crc32(
        bytes(encoded[address] for address in sorted(encoded))
    )
    if any(
        bank_slice(prg, bank, address, 1)[0] != value
        for address, value in encoded.items()
    ):
        raise ValueError("World 1 object authoring roundtrip differs after decode")
    return result


def apply_authoring(prg: bytes, document: dict[str, Any]) -> bytes:
    if len(prg) != 4 * BANK_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    bank = int(document["bank"])
    encoded = encode_authoring(document)
    result = bytearray(prg)
    for address, value in encoded.items():
        offset = bank * BANK_SIZE + address - CPU_BASE
        if not 0 <= offset < len(result):
            raise ValueError("World 1 object authoring address is outside PRG")
        result[offset] = value
    return bytes(result)


def validate_authoring(
    prg: bytes,
    manifest: dict[str, Any],
    path: Path,
) -> list[str]:
    document = json.loads(path.read_text(encoding="utf-8"))
    encoded = encode_authoring(document)
    canonical = decode_authoring(prg, manifest)
    canonical_encoded = encode_authoring(canonical)
    errors: list[str] = []
    if len(encoded) != int(document["covered_byte_count"]):
        errors.append("World 1 object authoring covered-byte count differs")
    encoded_crc = crc32(bytes(encoded[address] for address in sorted(encoded)))
    if encoded_crc != str(document["covered_crc32"]).lower():
        errors.append("World 1 object authoring covered-byte CRC32 differs")
    if set(encoded) != set(canonical_encoded):
        errors.append("World 1 object authoring coverage differs from manifest")
    elif encoded != canonical_encoded:
        errors.append("World 1 object authoring roundtrip differs from PRG")
    return errors


def validate(
    prg: bytes,
    document: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    formats = document.get("formats")
    lists = document.get("lists")
    if not isinstance(formats, dict) or not formats:
        return ["object placement formats must be a non-empty object"], {}
    if not isinstance(lists, list) or not lists:
        return ["object placement lists must be a non-empty list"], {}

    errors: list[str] = []
    descriptor_spec = document.get("world1_descriptor_objects")
    if not isinstance(descriptor_spec, dict):
        return ["World 1 descriptor-object catalog is missing"], {}
    descriptor_bank = int(descriptor_spec["bank"])
    descriptor_address = number(descriptor_spec["address"])
    descriptor_record_size = int(descriptor_spec["record_size"])
    descriptor_definition_count = int(descriptor_spec["record_count"])
    if descriptor_record_size != 4 or descriptor_spec.get("fields") != [
        "runtime_type",
        "metasprite_base",
        "render_flags",
        "primary_behavior",
    ]:
        errors.append("World 1 descriptor record layout differs from runtime")
    descriptor_records = descriptor_spec.get("records", [])
    if len(descriptor_records) != descriptor_definition_count:
        errors.append("World 1 descriptor definition count differs from catalog")
        descriptor_data = b""
    else:
        values = [
            number(value)
            for record in descriptor_records
            for value in record
        ]
        if any(len(record) != descriptor_record_size for record in descriptor_records):
            errors.append("World 1 descriptor record has the wrong field count")
        if any(not 0 <= value <= 0xFF for value in values):
            errors.append("World 1 descriptor field is outside byte range")
        descriptor_data = bytes(values)
        actual_descriptor_data = bank_slice(
            prg,
            descriptor_bank,
            descriptor_address,
            len(descriptor_data),
        )
        if actual_descriptor_data != descriptor_data:
            errors.append("World 1 descriptor table differs from PRG")
        descriptor_crc = f"{zlib.crc32(descriptor_data) & 0xFFFFFFFF:08x}"
        if descriptor_crc != str(descriptor_spec["crc32"]).lower():
            errors.append("World 1 descriptor-table CRC32 differs")
        runtime_types = [number(record[0]) for record in descriptor_records]
        if runtime_types != list(range(1, descriptor_definition_count + 1)):
            errors.append("World 1 descriptor runtime types are not one-based")

    transient = descriptor_spec["transient_selector_table"]
    transient_values = bytes(number(value) for value in transient["values"])
    transient_address = number(transient["address"])
    if any(value >= descriptor_definition_count for value in transient_values):
        errors.append("World 1 transient selector is outside descriptor table")
    if bank_slice(
        prg, descriptor_bank, transient_address, len(transient_values)
    ) != transient_values:
        errors.append("World 1 transient descriptor selectors differ from PRG")
    transient_crc = f"{zlib.crc32(transient_values) & 0xFFFFFFFF:08x}"
    if transient_crc != str(transient["crc32"]).lower():
        errors.append("World 1 transient selector CRC32 differs")

    collision_names: set[str] = set()
    region_bounds = {
        "descriptor_table": (
            descriptor_address,
            descriptor_address + len(descriptor_data) - 1,
        )
    }
    for table in descriptor_spec["collision_tables"]:
        name = str(table.get("name", ""))
        if not name or name in collision_names:
            errors.append(f"duplicate or empty descriptor collision table: {name!r}")
        collision_names.add(name)
        indexing = str(table["indexing"])
        expected_count = (
            descriptor_definition_count + 1
            if indexing == "runtime_type"
            else descriptor_definition_count
        )
        if indexing not in ("runtime_type", "runtime_type_minus_one"):
            errors.append(f"{name}: unsupported descriptor collision indexing")
            continue
        values = bytes(number(value) for value in table["values"])
        if len(values) != expected_count:
            errors.append(f"{name}: collision-table size differs from indexing")
        address = number(table["address"])
        region_bounds[name] = (address, address + len(values) - 1)
        if bank_slice(prg, descriptor_bank, address, len(values)) != values:
            errors.append(f"{name}: collision table differs from PRG")
        actual_crc = f"{zlib.crc32(values) & 0xFFFFFFFF:08x}"
        if actual_crc != str(table["crc32"]).lower():
            errors.append(f"{name}: collision-table CRC32 differs")

    for boundary in descriptor_spec["shared_boundaries"]:
        left = str(boundary["left"])
        right = str(boundary["right"])
        if left not in region_bounds or right not in region_bounds:
            errors.append("World 1 shared boundary names an unknown region")
            continue
        left_last = number(boundary["left_last_byte"])
        right_first = number(boundary["right_first_byte"])
        if (
            region_bounds[left][1] != left_last
            or region_bounds[right][0] != right_first
            or left_last != right_first
        ):
            errors.append(
                f"World 1 {left}/{right} shared boundary differs"
            )

    list_ids: set[str] = set()
    record_total = 0
    normal_total = 0
    descriptor_total = 0
    descriptor_high_flag_total = 0
    descriptor_index_counts: Counter[int] = Counter()
    for placement in lists:
        list_id = str(placement.get("id", ""))
        if not list_id or list_id in list_ids:
            errors.append(f"duplicate or empty object placement id: {list_id!r}")
        list_ids.add(list_id)
        format_name = str(placement["format"])
        if format_name not in formats:
            errors.append(f"{list_id}: unknown format {format_name!r}")
            continue
        format_spec = formats[format_name]
        record_size = int(format_spec["record_size"])
        fields = format_spec.get("fields")
        if record_size != 3 or fields != ["x_cell", "y_cell", "type"]:
            errors.append(f"{list_id}: unsupported placement record layout")
            continue
        if (
            format_spec.get("terminator_field") != "x_cell"
            or number(format_spec["terminator_value"]) != 0
        ):
            errors.append(f"{list_id}: unsupported placement terminator")
            continue

        bank = int(placement["bank"])
        address = number(placement["address"])
        record_count = int(placement["record_count"])
        terminator_address = number(placement["terminator_address"])
        expected_terminator = address + record_count * record_size
        if terminator_address != expected_terminator:
            errors.append(
                f"{list_id}: terminator address ${terminator_address:04X} differs "
                f"from record boundary ${expected_terminator:04X}"
            )
            continue
        data = bank_slice(prg, bank, address, record_count * record_size + 1)
        records = [
            tuple(data[index:index + record_size])
            for index in range(0, record_count * record_size, record_size)
        ]
        early_terminator = next(
            (index for index, record in enumerate(records) if record[0] == 0),
            None,
        )
        if early_terminator is not None:
            errors.append(f"{list_id}: x terminator appears in record {early_terminator}")
        if data[-1] != 0:
            errors.append(f"{list_id}: missing zero x terminator")

        expected_crc = str(placement["crc32_with_terminator"]).lower()
        actual_crc = f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"
        if expected_crc != actual_crc:
            errors.append(
                f"{list_id}: CRC32 {actual_crc} differs from {expected_crc}"
            )

        prefix = int(format_spec["always_scanned_prefix"])
        sorted_tail = records[min(prefix, len(records)):]
        if any(
            sorted_tail[index][0] > sorted_tail[index + 1][0]
            for index in range(len(sorted_tail) - 1)
        ):
            errors.append(f"{list_id}: x coordinates after record {prefix} are not sorted")

        normal_type_max = number(format_spec["normal_type_max"])
        descriptor_count = int(format_spec["descriptor_count"])
        if descriptor_count != descriptor_definition_count:
            errors.append(
                f"{list_id}: descriptor count differs from descriptor table"
            )
        for index, (_x_cell, _y_cell, type_value) in enumerate(records):
            if type_value < 0x80:
                normal_total += 1
                if type_value > normal_type_max:
                    errors.append(
                        f"{list_id}: record {index} normal type ${type_value:02X} "
                        f"exceeds ${normal_type_max:02X}"
                    )
            else:
                descriptor_total += 1
                descriptor_high_flag_total += bool(type_value & 0x40)
                descriptor_index_counts[type_value & 0x0F] += 1
                if type_value & 0x30 or (type_value & 0x0F) >= descriptor_count:
                    errors.append(
                        f"{list_id}: record {index} has invalid descriptor type "
                        f"${type_value:02X}"
                    )
        record_total += record_count

    placement_encoding = descriptor_spec["placement_encoding"]
    expected_index_counts = Counter({
        int(index): int(count)
        for index, count in placement_encoding["expected_index_counts"].items()
    })
    if descriptor_total != int(placement_encoding["expected_record_count"]):
        errors.append("World 1 descriptor-backed placement count differs")
    if descriptor_high_flag_total != int(
        placement_encoding["expected_runtime_high_flag_count"]
    ):
        errors.append("World 1 descriptor runtime-high-flag count differs")
    if descriptor_index_counts != expected_index_counts:
        errors.append("World 1 placement descriptor-index counts differ")
    if (
        number(placement_encoding["descriptor_flag"]) != 0x80
        or number(placement_encoding["runtime_high_flag"]) != 0x40
        or number(placement_encoding["selector_mask"]) != 0x0F
        or number(placement_encoding["forbidden_mask"]) != 0x30
    ):
        errors.append("World 1 descriptor placement encoding differs from runtime")

    return errors, {
        "list_count": len(lists),
        "record_count": record_total,
        "normal_count": normal_total,
        "descriptor_count": descriptor_total,
        "descriptor_definition_count": descriptor_definition_count,
        "descriptor_used_index_count": len(descriptor_index_counts),
        "descriptor_high_flag_count": descriptor_high_flag_total,
        "transient_selector_count": len(transient_values),
        "collision_table_count": len(descriptor_spec["collision_tables"]),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    validate_parser = subparsers.add_parser("validate")
    validate_parser.add_argument("--prg", required=True, type=Path)
    validate_parser.add_argument("--manifest", required=True, type=Path)
    validate_parser.add_argument("--authoring", type=Path)
    decode_parser = subparsers.add_parser("decode")
    decode_parser.add_argument("--prg", required=True, type=Path)
    decode_parser.add_argument("--manifest", required=True, type=Path)
    decode_parser.add_argument("--output", required=True, type=Path)
    encode_parser = subparsers.add_parser("encode")
    encode_parser.add_argument("--input", required=True, type=Path)
    encode_parser.add_argument("--base-prg", required=True, type=Path)
    encode_parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    try:
        if args.command == "encode":
            document = json.loads(args.input.read_text(encoding="utf-8"))
            encoded = apply_authoring(args.base_prg.read_bytes(), document)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_bytes(encoded)
            print(
                f"[OK] wrote PRG with {document['covered_byte_count']} "
                "World 1 object-data bytes"
            )
            return 0
        prg = args.prg.read_bytes()
        manifest = load_manifest(args.manifest)
        if args.command == "decode":
            decoded = decode_authoring(prg, manifest)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_text(
                json.dumps(decoded, indent=2) + "\n",
                encoding="utf-8",
                newline="\n",
            )
            print(f"[OK] wrote World 1 object authoring data to {args.output}")
            return 0
        errors, report = validate(prg, manifest)
        if args.authoring is not None:
            errors.extend(validate_authoring(prg, manifest, args.authoring))
            authoring_document = json.loads(
                args.authoring.read_text(encoding="utf-8")
            )
            report["authoring_covered_byte_count"] = len(
                encode_authoring(authoring_document)
            )
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] object placement audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] {report['list_count']} object placement lists: "
        f"{report['record_count']} records, {report['normal_count']} normal, "
        f"{report['descriptor_count']} descriptor-backed; "
        f"{report['descriptor_definition_count']} descriptor definitions, "
        f"{report['collision_table_count']} collision tables"
        + (
            f"; {report['authoring_covered_byte_count']} lossless authoring bytes"
            if "authoring_covered_byte_count" in report
            else ""
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
