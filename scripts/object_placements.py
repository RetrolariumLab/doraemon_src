#!/usr/bin/env python3
"""Validate packed chapter object-placement lists in the canonical PRG."""

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
        raise ValueError("unsupported object placement schema")
    return document


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("object placement range is outside PRG")
    return prg[offset:offset + size]


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
    list_ids: set[str] = set()
    record_total = 0
    normal_total = 0
    descriptor_total = 0
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
                if type_value & 0x30 or (type_value & 0x0F) >= descriptor_count:
                    errors.append(
                        f"{list_id}: record {index} has invalid descriptor type "
                        f"${type_value:02X}"
                    )
        record_total += record_count

    return errors, {
        "list_count": len(lists),
        "record_count": record_total,
        "normal_count": normal_total,
        "descriptor_count": descriptor_total,
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
        print(f"[ERROR] object placement audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] {report['list_count']} object placement lists: "
        f"{report['record_count']} records, {report['normal_count']} normal, "
        f"{report['descriptor_count']} descriptor-backed"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
