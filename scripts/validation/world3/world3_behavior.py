#!/usr/bin/env python3
"""Validate and summarize the packed World 3 entity behavior bytecode."""

from __future__ import annotations

import argparse
from collections import Counter
from dataclasses import dataclass
import json
from pathlib import Path
from typing import Any
import zlib


BANK_SIZE = 0x8000
CPU_BASE = 0x8000

OPCODE_CLASSES: tuple[tuple[str, int | str], ...] = (
    ("move_x_forward", 1),
    ("move_x_reverse", 1),
    ("move_y_forward", 1),
    ("move_y_reverse", 1),
    ("jump", 2),
    ("wait", 2),
    ("set_rate", 1),
    ("set_direction", 1),
    ("loop", "1-or-2"),
    ("move_relative", 3),
    ("set_position", 3),
    ("set_metasprite_variant", 1),
    ("conditional_branch", "2-or-3"),
    ("set_follow_anchor", 2),
    ("toggle_metasprite_variant", 1),
    ("stop", 1),
)


@dataclass(frozen=True)
class Instruction:
    offset: int
    opcode: int
    size: int
    successors: tuple[int, ...]


def instruction_shape(data: bytes, offset: int) -> tuple[int, tuple[int, ...]]:
    opcode = data[offset]
    command = opcode >> 4
    parameter = opcode & 0x0F
    if command <= 3:
        return 1, (offset + 1,)
    if command == 4:
        return 2, (data[offset + 1],)
    if command == 5:
        return 2, (offset + 2,)
    if command in (6, 7):
        return 1, (offset + 1,)
    if command == 8:
        return (2, (offset + 2,)) if parameter == 0 else (1, (offset + 1,))
    if command in (9, 10):
        return 3, (offset + 3,)
    if command == 11:
        return 1, (offset + 1,)
    if command == 12:
        if parameter in (1, 2):
            return 2, (offset + 2, data[offset + 1])
        return 3, (offset + 3, data[offset + 2])
    if command == 13:
        return 2, (offset + 2,)
    if command == 14:
        return 1, (offset + 1,)
    return 1, ()


def decode_stream(data: bytes) -> tuple[list[str], list[Instruction], set[int]]:
    errors: list[str] = []
    instructions: dict[int, Instruction] = {}
    byte_roles: dict[int, str] = {}
    worklist = [0]
    while worklist:
        offset = worklist.pop()
        if offset in instructions:
            continue
        if not 0 <= offset < len(data):
            errors.append(f"control-flow target ${offset:02X} is outside stream")
            continue
        if byte_roles.get(offset) == "operand":
            errors.append(f"control-flow target ${offset:02X} lands in an operand")
            continue
        try:
            size, successors = instruction_shape(data, offset)
        except IndexError:
            errors.append(f"truncated opcode ${data[offset]:02X} at ${offset:02X}")
            continue
        if offset + size > len(data):
            errors.append(f"truncated opcode ${data[offset]:02X} at ${offset:02X}")
            continue
        conflict = next(
            (
                byte_offset
                for byte_offset in range(offset, offset + size)
                if byte_offset in byte_roles
                and byte_roles[byte_offset] != (
                    "opcode" if byte_offset == offset else "operand"
                )
            ),
            None,
        )
        if conflict is not None:
            errors.append(f"overlapping instruction at ${conflict:02X}")
            continue
        byte_roles[offset] = "opcode"
        for operand_offset in range(offset + 1, offset + size):
            byte_roles[operand_offset] = "operand"
        instruction = Instruction(offset, data[offset], size, successors)
        instructions[offset] = instruction
        for successor in successors:
            if successor not in instructions:
                worklist.append(successor)
    return errors, [instructions[key] for key in sorted(instructions)], set(byte_roles)


def opcode_histogram(instructions: list[Instruction]) -> Counter[int]:
    return Counter(instruction.opcode >> 4 for instruction in instructions)


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def crc32(data: bytes) -> str:
    return f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"


def load_manifest(path: Path) -> dict[str, Any]:
    document = json.loads(path.read_text(encoding="utf-8"))
    if document.get("schema_version") != 1:
        raise ValueError("unsupported World 3 behavior schema")
    return document


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("World 3 behavior range is outside PRG")
    return prg[offset:offset + size]


def validate(
    prg: bytes,
    document: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    errors: list[str] = []
    bank = int(document["bank"])
    streams = document.get("streams")
    if not isinstance(streams, list) or not streams:
        return ["World 3 behavior streams must be a non-empty list"], {}

    declared_classes = [
        (
            number(entry["high_nibble"]),
            str(entry["name"]),
            entry["size"],
        )
        for entry in document.get("opcode_classes", [])
    ]
    expected_classes = [
        (high_nibble, name, size)
        for high_nibble, (name, size) in enumerate(OPCODE_CLASSES)
    ]
    if declared_classes != expected_classes:
        errors.append("World 3 behavior opcode-class contract differs")

    region = document["region"]
    region_address = number(region["address"])
    region_end = number(region["end_address"])
    region_data = bank_slice(
        prg,
        bank,
        region_address,
        region_end - region_address + 1,
    )
    if crc32(region_data) != str(region["crc32"]).lower():
        errors.append("World 3 behavior region CRC32 differs")

    pointer_spec = document["pointer_table"]
    slot_count = int(pointer_spec["slot_count"])
    if len(streams) != slot_count:
        errors.append(
            f"World 3 stream count {len(streams)} differs from {slot_count} pointers"
        )
    pointer_data = bank_slice(
        prg,
        bank,
        number(pointer_spec["address"]),
        slot_count * 2,
    )
    if crc32(pointer_data) != str(pointer_spec["crc32"]).lower():
        errors.append("World 3 behavior pointer-table CRC32 differs")
    pointer_targets = [
        int.from_bytes(pointer_data[index:index + 2], "little")
        for index in range(0, len(pointer_data), 2)
    ]
    stream_addresses = [number(stream["address"]) for stream in streams]
    if pointer_targets != stream_addresses:
        errors.append("World 3 behavior pointers differ from stream addresses")

    aggregate_histogram: Counter[int] = Counter()
    instruction_count = 0
    branch_count = 0
    terminator_count = 0
    covered_bytes = 0
    expected_next_address = region_address
    seen_ids: set[int] = set()
    for stream in streams:
        stream_id = int(stream["id"])
        address = number(stream["address"])
        size = int(stream["size"])
        if stream_id in seen_ids:
            errors.append(f"duplicate World 3 behavior stream id {stream_id}")
        seen_ids.add(stream_id)
        if address != expected_next_address:
            errors.append(
                f"stream {stream_id}: address ${address:04X} is not contiguous"
            )
        expected_next_address = address + size
        data = bank_slice(prg, bank, address, size)
        if crc32(data) != str(stream["crc32"]).lower():
            errors.append(f"stream {stream_id}: CRC32 differs")
        decode_errors, instructions, used_bytes = decode_stream(data)
        errors.extend(
            f"stream {stream_id}: {error}" for error in decode_errors
        )
        missing_bytes = sorted(set(range(size)) - used_bytes)
        if missing_bytes:
            errors.append(
                f"stream {stream_id}: {len(missing_bytes)} bytes are not decoded"
            )
        actual_branches = sum(
            1 for instruction in instructions if len(instruction.successors) > 1
        )
        actual_terminators = sum(
            1 for instruction in instructions if instruction.opcode >> 4 == 0xF
        )
        expected_metrics = {
            "instruction_count": len(instructions),
            "branch_count": actual_branches,
            "terminator_count": actual_terminators,
        }
        for metric, actual in expected_metrics.items():
            expected = int(stream[metric])
            if actual != expected:
                errors.append(
                    f"stream {stream_id}: {metric} {actual} differs from {expected}"
                )
        aggregate_histogram.update(opcode_histogram(instructions))
        instruction_count += len(instructions)
        branch_count += actual_branches
        terminator_count += actual_terminators
        covered_bytes += len(used_bytes)
    if expected_next_address != region_end + 1:
        errors.append("World 3 behavior stream list does not cover the region")

    expected_histogram = {
        number(high_nibble): int(count)
        for high_nibble, count in document["expected_opcode_histogram"].items()
    }
    actual_histogram = {
        high_nibble: aggregate_histogram[high_nibble]
        for high_nibble in range(16)
    }
    if actual_histogram != expected_histogram:
        errors.append("World 3 behavior opcode histogram differs")
    aggregate_metrics = {
        "instruction_count": instruction_count,
        "branch_count": branch_count,
        "terminator_count": terminator_count,
        "covered_bytes": covered_bytes,
    }
    for metric, actual in aggregate_metrics.items():
        expected = int(document[f"expected_{metric}"])
        if actual != expected:
            errors.append(
                f"World 3 {metric} {actual} differs from manifest {expected}"
            )

    return errors, {
        "stream_count": len(streams),
        **aggregate_metrics,
        "opcode_class_count": sum(
            1 for count in aggregate_histogram.values() if count
        ),
    }


def decode_authoring(
    prg: bytes,
    document: dict[str, Any],
) -> dict[str, Any]:
    errors, _report = validate(prg, document)
    if errors:
        raise ValueError("; ".join(errors))
    bank = int(document["bank"])
    decoded_streams: list[dict[str, Any]] = []
    for stream in document["streams"]:
        address = number(stream["address"])
        data = bank_slice(prg, bank, address, int(stream["size"]))
        decode_errors, instructions, _used = decode_stream(data)
        if decode_errors:
            raise ValueError("; ".join(decode_errors))
        decoded_streams.append({
            "id": int(stream["id"]),
            "address": f"0x{address:04X}",
            "size": len(data),
            "instructions": [
                {
                    "offset": f"0x{instruction.offset:02X}",
                    "opcode": f"0x{instruction.opcode:02X}",
                    "command": OPCODE_CLASSES[instruction.opcode >> 4][0],
                    "operands": [
                        f"0x{value:02X}"
                        for value in data[
                            instruction.offset + 1:
                            instruction.offset + instruction.size
                        ]
                    ],
                }
                for instruction in instructions
            ],
        })
    return {
        "schema_version": 1,
        "format": "world3-behavior-bytecode",
        "streams": decoded_streams,
    }


def encode_authoring(document: dict[str, Any]) -> bytes:
    if document.get("schema_version") != 1 or document.get("format") != (
        "world3-behavior-bytecode"
    ):
        raise ValueError("unsupported World 3 behavior authoring schema")
    output = bytearray()
    expected_address: int | None = None
    for stream in sorted(document["streams"], key=lambda entry: int(entry["id"])):
        address = number(stream["address"])
        size = int(stream["size"])
        if expected_address is not None and address != expected_address:
            raise ValueError("World 3 authoring streams are not contiguous")
        expected_address = address + size
        data: list[int | None] = [None] * size
        declared_offsets: set[int] = set()
        for entry in stream["instructions"]:
            offset = number(entry["offset"])
            opcode = number(entry["opcode"])
            operands = [number(value) for value in entry.get("operands", [])]
            raw = [opcode, *operands]
            if any(not 0 <= value <= 0xFF for value in raw):
                raise ValueError("World 3 authoring instruction contains non-byte data")
            expected_command = OPCODE_CLASSES[opcode >> 4][0]
            if entry.get("command") != expected_command:
                raise ValueError(
                    f"instruction at ${offset:02X} command differs from opcode"
                )
            try:
                expected_size, _successors = instruction_shape(bytes(raw), 0)
            except IndexError as exc:
                raise ValueError("truncated World 3 authoring instruction") from exc
            if expected_size != len(raw):
                raise ValueError(
                    f"instruction at ${offset:02X} has wrong operand count"
                )
            if offset < 0 or offset + len(raw) > size:
                raise ValueError(f"instruction at ${offset:02X} is outside stream")
            for byte_offset, value in enumerate(raw, start=offset):
                if data[byte_offset] is not None:
                    raise ValueError(f"overlap at stream offset ${byte_offset:02X}")
                data[byte_offset] = value
            declared_offsets.add(offset)
        if any(value is None for value in data):
            raise ValueError("World 3 authoring stream has uncovered bytes")
        encoded = bytes(value for value in data if value is not None)
        decode_errors, instructions, used = decode_stream(encoded)
        if decode_errors or len(used) != size:
            raise ValueError("encoded World 3 behavior control flow is invalid")
        if {instruction.offset for instruction in instructions} != declared_offsets:
            raise ValueError("encoded instruction boundaries differ from authoring data")
        output.extend(encoded)
    return bytes(output)


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
    encode_parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    try:
        if args.command == "validate":
            prg = args.prg.read_bytes()
            manifest = load_manifest(args.manifest)
            errors, report = validate(
                prg,
                manifest,
            )
            if args.authoring is not None:
                encoded = encode_authoring(
                    json.loads(args.authoring.read_text(encoding="utf-8"))
                )
                region = manifest["region"]
                original = bank_slice(
                    prg,
                    int(manifest["bank"]),
                    number(region["address"]),
                    number(region["end_address"]) - number(region["address"]) + 1,
                )
                if encoded != original:
                    errors.append(
                        "World 3 behavior authoring roundtrip differs from PRG"
                    )
            if errors:
                for error in errors:
                    print(f"[ERROR] {error}")
                return 1
            print(
                f"[OK] {report['stream_count']} World 3 behavior streams: "
                f"{report['instruction_count']} instructions, "
                f"{report['covered_bytes']} covered bytes, "
                f"{report['branch_count']} conditional branches, "
                f"{report['terminator_count']} terminators"
            )
            return 0
        if args.command == "decode":
            decoded = decode_authoring(
                args.prg.read_bytes(),
                load_manifest(args.manifest),
            )
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_text(
                json.dumps(decoded, indent=2) + "\n",
                encoding="utf-8",
            )
            print(f"[OK] wrote World 3 behavior authoring data to {args.output}")
            return 0
        encoded = encode_authoring(
            json.loads(args.input.read_text(encoding="utf-8"))
        )
        args.output.write_bytes(encoded)
        print(f"[OK] wrote {len(encoded)} World 3 behavior bytes to {args.output}")
        return 0
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 3 behavior operation failed: {exc}")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
