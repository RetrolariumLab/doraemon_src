#!/usr/bin/env python3
"""Validate World 2 stage sequencing and compressed screen streams."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any
import zlib

import project


BANK_SIZE = 0x8000
CPU_BASE = 0x8000


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def load_manifest(path: Path) -> dict[str, Any]:
    document = json.loads(path.read_text(encoding="utf-8"))
    if document.get("schema_version") != 1:
        raise ValueError("unsupported World 2 streaming schema")
    return document


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("World 2 streaming range is outside PRG")
    return prg[offset:offset + size]


def crc32(data: bytes) -> str:
    return f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"


def encode_rts_target(target: int) -> bytes:
    return (target - 1).to_bytes(2, "little")


def validate(
    prg: bytes,
    document: dict[str, Any],
    code_entries: list[tuple[int, int, str]],
) -> tuple[list[str], dict[str, int]]:
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}

    errors: list[str] = []
    bank = int(document["bank"])
    declared_entries = {
        (entry_bank, address) for entry_bank, address, _name in code_entries
    }

    dispatch_tables = document.get("dispatch_tables")
    if not isinstance(dispatch_tables, list) or not dispatch_tables:
        return ["World 2 dispatch tables must be a non-empty list"], {}
    dispatch_names: set[str] = set()
    dispatch_targets: set[int] = set()
    dispatch_slot_count = 0
    for table in dispatch_tables:
        name = str(table.get("name", ""))
        if not name or name in dispatch_names:
            errors.append(f"duplicate or empty World 2 dispatch name: {name!r}")
        dispatch_names.add(name)
        if table.get("encoding") != "rts-minus-one":
            errors.append(f"{name}: unsupported dispatch encoding")
            continue
        address = number(table["address"])
        targets = [number(value) for value in table.get("targets", [])]
        slot_count = int(table["slot_count"])
        if len(targets) != slot_count:
            errors.append(
                f"{name}: target count {len(targets)} differs from "
                f"slot count {slot_count}"
            )
        elif not all(CPU_BASE <= target <= 0xFFFF for target in targets):
            errors.append(f"{name}: target is outside the active PRG window")
        else:
            encoded = b"".join(encode_rts_target(target) for target in targets)
            if bank_slice(prg, bank, address, len(encoded)) != encoded:
                errors.append(f"{name}: encoded dispatch table differs from PRG")
        missing = sorted(
            target for target in set(targets)
            if (bank, target) not in declared_entries
        )
        if missing:
            errors.append(
                f"{name}: indirect targets missing from code entry registry: "
                + ", ".join(f"${target:04X}" for target in missing)
            )
        dispatch_targets.update(targets)
        dispatch_slot_count += slot_count

    stage = document["stage_sequence"]
    stage_address = number(stage["address"])
    stage_data = bank_slice(prg, bank, stage_address, int(stage["size"]))
    if crc32(stage_data) != str(stage["crc32"]).lower():
        errors.append("World 2 stage-sequence CRC32 differs from manifest")
    start_offsets = bytes(int(value) for value in stage["start_offsets"])
    actual_starts = bank_slice(
        prg,
        bank,
        number(stage["start_table_address"]),
        len(start_offsets),
    )
    if actual_starts != start_offsets:
        errors.append("World 2 stage start-offset table differs from manifest")

    pointer_spec = document["screen_pointer_table"]
    pointer_address = number(pointer_spec["address"])
    pointer_slot_count = int(pointer_spec["slot_count"])
    standard_slot_count = int(pointer_spec["standard_rom_slots"])
    pointer_data = bank_slice(prg, bank, pointer_address, pointer_slot_count * 2)
    standard_pointer_data = pointer_data[:standard_slot_count * 2]
    if crc32(standard_pointer_data) != str(pointer_spec["standard_crc32"]).lower():
        errors.append("World 2 standard pointer-table CRC32 differs from manifest")
    if crc32(pointer_data) != str(pointer_spec["full_crc32"]).lower():
        errors.append("World 2 full pointer-table CRC32 differs from manifest")
    pointers = [
        int.from_bytes(pointer_data[index:index + 2], "little")
        for index in range(0, len(pointer_data), 2)
    ]
    standard_pointers = pointers[:standard_slot_count]
    first_stream_address = number(pointer_spec["first_stream_address"])
    if not standard_pointers or standard_pointers[0] != first_stream_address:
        errors.append("World 2 first standard stream pointer differs from manifest")
    expected_unique = int(pointer_spec["standard_unique_pointer_count"])
    if len(set(standard_pointers)) != expected_unique:
        errors.append(
            "World 2 unique standard stream count differs from manifest"
        )

    streams = document["screen_streams"]
    stream_address = number(streams["address"])
    last_consumed_address = number(streams["last_consumed_address"])
    stream_data = bank_slice(
        prg,
        bank,
        stream_address,
        last_consumed_address - stream_address + 1,
    )
    if crc32(stream_data) != str(streams["crc32"]).lower():
        errors.append("World 2 compressed-stream CRC32 differs from manifest")
    if any(
        pointer < stream_address or pointer > last_consumed_address
        for pointer in standard_pointers
    ):
        errors.append("World 2 standard stream pointer is outside ROM streams")

    dynamic_screens = {
        number(screen_id): number(pointer)
        for screen_id, pointer in stage["dynamic_screen_ids"].items()
    }
    for screen_id, expected_pointer in dynamic_screens.items():
        if screen_id >= len(pointers) or pointers[screen_id] != expected_pointer:
            errors.append(
                f"World 2 dynamic screen ${screen_id:02X} pointer differs "
                "from manifest"
            )
    allowed_screen_ids = set(range(standard_slot_count)) | set(dynamic_screens)
    illegal_selectors = sorted({
        token & 0x7F
        for token in stage_data
        if token < 0xF0 and (token & 0x7F) not in allowed_screen_ids
    })
    if illegal_selectors:
        errors.append(
            "World 2 stage sequence has unsupported screen selectors: "
            + ", ".join(f"${value:02X}" for value in illegal_selectors)
        )

    rows_per_screen = int(streams["rows_per_screen"])
    minimum_cells = int(streams["minimum_cells_per_row"])
    spawn_tokens = 0
    rle_tokens = 0
    row_terminators = 0
    max_row_width = 0
    max_read_address = stream_address - 1

    def read_byte(address: int) -> int:
        nonlocal max_read_address
        if address < stream_address or address > last_consumed_address:
            raise ValueError(
                f"compressed screen read outside declared streams at ${address:04X}"
            )
        max_read_address = max(max_read_address, address)
        return bank_slice(prg, bank, address, 1)[0]

    try:
        for screen_id, pointer in enumerate(standard_pointers):
            cursor = pointer
            for row in range(rows_per_screen):
                width = 0
                while width < minimum_cells:
                    token = read_byte(cursor)
                    cursor += 1
                    if token < 0xD0:
                        width += 1
                    elif token < 0xEF:
                        spawn_tokens += 1
                        width += 1
                    elif token == 0xEF:
                        row_terminators += 1
                        width = 16
                    elif token == 0xF0:
                        errors.append(
                            f"screen {screen_id} row {row}: invalid $F0 token"
                        )
                        width = minimum_cells
                    else:
                        rle_tokens += 1
                        repeated = read_byte(cursor)
                        cursor += 1
                        if repeated >= 0xD0:
                            errors.append(
                                f"screen {screen_id} row {row}: RLE literal "
                                f"${repeated:02X} is not a tile"
                            )
                        # The counted loop falls through to the shared literal
                        # store, so the low nibble produces one extra cell.
                        width += (token & 0x0F) + 1
                max_row_width = max(max_row_width, width)
    except ValueError as exc:
        errors.append(str(exc))

    expected_metrics = {
        "screen_count": (standard_slot_count, int(streams["expected_screen_count"])),
        "spawn_tokens": (spawn_tokens, int(streams["expected_spawn_tokens"])),
        "rle_tokens": (rle_tokens, int(streams["expected_rle_tokens"])),
        "row_terminators": (
            row_terminators,
            int(streams["expected_row_terminators"]),
        ),
        "max_row_width": (max_row_width, int(streams["expected_max_row_width"])),
    }
    for metric, (actual, expected) in expected_metrics.items():
        if actual != expected:
            errors.append(
                f"World 2 {metric} {actual} differs from manifest {expected}"
            )
    if max_read_address != last_consumed_address:
        errors.append(
            f"World 2 last consumed byte ${max_read_address:04X} differs "
            f"from manifest ${last_consumed_address:04X}"
        )

    return errors, {
        "dispatch_table_count": len(dispatch_tables),
        "dispatch_slot_count": dispatch_slot_count,
        "dispatch_target_count": len(dispatch_targets),
        "screen_count": standard_slot_count,
        "unique_stream_count": len(set(standard_pointers)),
        "spawn_token_count": spawn_tokens,
        "rle_token_count": rle_tokens,
        "row_terminator_count": row_terminators,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prg", required=True, type=Path)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--code-entries", required=True, type=Path)
    args = parser.parse_args()
    try:
        errors, report = validate(
            args.prg.read_bytes(),
            load_manifest(args.manifest),
            project.load_prg_code_entries(args.code_entries),
        )
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 2 streaming audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] {report['dispatch_table_count']} World 2 screen-service "
        f"tables: {report['dispatch_slot_count']} slots, "
        f"{report['dispatch_target_count']} unique targets; "
        f"{report['screen_count']} screen selectors, "
        f"{report['unique_stream_count']} unique streams, "
        f"{report['spawn_token_count']} enemy tokens, "
        f"{report['rle_token_count']} RLE tokens"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
