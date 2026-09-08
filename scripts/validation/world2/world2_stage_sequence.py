#!/usr/bin/env python3
"""Validate and losslessly edit the World 2 stage-sequence bytecode."""

from __future__ import annotations

import argparse
from collections import Counter
import json
from pathlib import Path
from typing import Any
import zlib


BANK_SIZE = 0x8000
CPU_BASE = 0x8000
COMMANDS = (
    "select_screen",
    "set_pending_direction",
    "restore_saved_offset",
    "stop_scroll",
    "set_background_palette",
)


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def crc32(data: bytes) -> str:
    return f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("World 2 stage-sequence range is outside PRG")
    return prg[offset:offset + size]


def command_for_token(token: int) -> str:
    if token < 0xF0:
        return "select_screen"
    if token < 0xF7:
        return "set_pending_direction"
    if token == 0xF7:
        return "restore_saved_offset"
    if token == 0xF8:
        return "stop_scroll"
    return "set_background_palette"


def decode_token(offset: int, token: int) -> dict[str, Any]:
    command = command_for_token(token)
    result: dict[str, Any] = {
        "offset": offset,
        "raw": f"0x{token:02X}",
        "command": command,
    }
    if command == "select_screen":
        result["screen_id"] = f"0x{token & 0x7F:02X}"
        result["high_bit"] = bool(token & 0x80)
    elif command == "set_pending_direction":
        result["direction"] = token & 0x03
    elif command == "set_background_palette":
        result["palette_id"] = token & 0x07
    return result


def encode_token(entry: dict[str, Any]) -> int:
    raw = number(entry["raw"])
    if not 0 <= raw <= 0xFF:
        raise ValueError("stage-sequence raw token is outside byte range")
    command = str(entry["command"])
    if command != command_for_token(raw):
        raise ValueError("stage-sequence command differs from raw token")
    if command == "select_screen":
        screen_id = number(entry["screen_id"])
        high_bit = entry["high_bit"]
        if not isinstance(high_bit, bool) or not 0 <= screen_id <= 0x7F:
            raise ValueError("stage-sequence screen fields are invalid")
        if raw != screen_id | (0x80 if high_bit else 0):
            raise ValueError("stage-sequence screen fields differ from raw token")
    elif command == "set_pending_direction":
        if int(entry["direction"]) != (raw & 0x03):
            raise ValueError("stage-sequence direction differs from raw token")
    elif command == "set_background_palette":
        if int(entry["palette_id"]) != (raw & 0x07):
            raise ValueError("stage-sequence palette id differs from raw token")
    return raw


def indexed_entries(entries: Any, count: int) -> list[dict[str, Any]]:
    if not isinstance(entries, list) or len(entries) != count:
        raise ValueError(f"stage sequence must contain {count} entries")
    if [int(entry.get("offset", -1)) for entry in entries] != list(range(count)):
        raise ValueError("stage-sequence offsets are not contiguous")
    return entries


def add_region(result: dict[int, int], address: int, data: bytes) -> None:
    for offset, value in enumerate(data):
        byte_address = address + offset
        if byte_address in result:
            raise ValueError("stage-sequence authoring regions overlap")
        result[byte_address] = value


def encode_authoring(document: dict[str, Any]) -> dict[int, int]:
    if document.get("schema_version") != 1 or document.get("format") != (
        "doraemon-world2-stage-sequence"
    ):
        raise ValueError("unsupported World 2 stage-sequence authoring schema")
    if int(document["bank"]) != 1:
        raise ValueError("World 2 stage sequence must target PRG bank 1")
    size = int(document["size"])
    entries = indexed_entries(document["entries"], size)
    sequence = bytes(encode_token(entry) for entry in entries)
    start_offsets = bytes(number(value) for value in document["start_offsets"])
    if any(value >= size for value in start_offsets):
        raise ValueError("stage-sequence start offset is outside sequence")
    result: dict[int, int] = {}
    add_region(result, number(document["address"]), sequence)
    add_region(result, number(document["start_table_address"]), start_offsets)
    return result


def validate_manifest(
    prg: bytes,
    manifest: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if manifest.get("schema_version") != 1:
        return ["unsupported World 2 stage-sequence schema"], {}
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    errors: list[str] = []
    bank = int(manifest["bank"])
    sequence_spec = manifest["sequence"]
    address = number(sequence_spec["address"])
    size = int(sequence_spec["size"])
    data = bank_slice(prg, bank, address, size)
    if crc32(data) != str(sequence_spec["crc32"]).lower():
        errors.append("World 2 stage-sequence CRC32 differs")

    counts = Counter(command_for_token(token) for token in data)
    expected_counts = {
        str(name): int(count)
        for name, count in sequence_spec["expected_command_counts"].items()
    }
    if tuple(expected_counts) != COMMANDS or counts != expected_counts:
        errors.append("World 2 stage-sequence command counts differ")
    high_screens = sum(0x80 <= token < 0xF0 for token in data)
    if high_screens != int(sequence_spec["expected_high_screen_token_count"]):
        errors.append("World 2 high-bit screen-token count differs")
    screen_ids = {token & 0x7F for token in data if token < 0xF0}
    if len(screen_ids) != int(sequence_spec["expected_unique_screen_id_count"]):
        errors.append("World 2 unique screen-id count differs")
    terminal = sequence_spec["terminal_screen"]
    stop_offset = int(terminal["stop_scroll_offset"])
    selector_offset = int(terminal["selector_offset"])
    terminal_screen_id = number(terminal["screen_id"])
    if not (
        0 <= stop_offset < selector_offset < len(data)
        and data[stop_offset] == 0xF8
        and data[selector_offset] == terminal_screen_id
        and terminal_screen_id not in range(119)
    ):
        errors.append("World 2 terminal screen contract differs")

    starts = manifest["start_offsets"]
    start_data = bank_slice(
        prg, bank, number(starts["address"]), int(starts["count"])
    )
    expected_starts = bytes(number(value) for value in starts["values"])
    if start_data != expected_starts:
        errors.append("World 2 stage start-offset table differs from PRG")
    if crc32(start_data) != str(starts["crc32"]).lower():
        errors.append("World 2 stage start-offset CRC32 differs")
    if any(offset >= size for offset in start_data):
        errors.append("World 2 stage start offset is outside sequence")

    expected_opcodes = [
        ("0x00-0xEF", "select_screen"),
        ("0xF0-0xF6", "set_pending_direction"),
        ("0xF7", "restore_saved_offset"),
        ("0xF8", "stop_scroll"),
        ("0xF9-0xFF", "set_background_palette"),
    ]
    actual_opcodes = [
        (str(entry["range"]), str(entry["command"]))
        for entry in manifest["opcodes"]
    ]
    if actual_opcodes != expected_opcodes:
        errors.append("World 2 stage opcode partition differs from decoder")
    for signature in manifest["decoder_signatures"]:
        raw = bytes.fromhex(str(signature["bytes"]))
        if bank_slice(prg, bank, number(signature["address"]), len(raw)) != raw:
            errors.append("World 2 stage decoder signature differs from PRG")

    return errors, {
        "sequence_byte_count": len(data),
        "start_offset_count": len(start_data),
        "screen_command_count": counts["select_screen"],
        "control_command_count": len(data) - counts["select_screen"],
        "unique_screen_id_count": len(screen_ids),
        "terminal_screen_id": terminal_screen_id,
    }


def decode_authoring(
    prg: bytes,
    manifest: dict[str, Any],
) -> dict[str, Any]:
    errors, _report = validate_manifest(prg, manifest)
    if errors:
        raise ValueError("; ".join(errors))
    bank = int(manifest["bank"])
    sequence = manifest["sequence"]
    address = number(sequence["address"])
    size = int(sequence["size"])
    data = bank_slice(prg, bank, address, size)
    starts = manifest["start_offsets"]
    start_data = bank_slice(
        prg, bank, number(starts["address"]), int(starts["count"])
    )
    result: dict[str, Any] = {
        "schema_version": 1,
        "format": "doraemon-world2-stage-sequence",
        "bank": bank,
        "address": sequence["address"],
        "size": size,
        "start_table_address": starts["address"],
        "start_offsets": list(start_data),
        "entries": [decode_token(offset, token) for offset, token in enumerate(data)],
        "covered_byte_count": size + len(start_data),
        "covered_crc32": "00000000",
    }
    encoded = encode_authoring(result)
    result["covered_crc32"] = crc32(
        bytes(encoded[address] for address in sorted(encoded))
    )
    return result


def validate_authoring(
    prg: bytes,
    manifest: dict[str, Any],
    path: Path,
) -> list[str]:
    document = json.loads(path.read_text(encoding="utf-8"))
    encoded = encode_authoring(document)
    canonical = encode_authoring(decode_authoring(prg, manifest))
    errors: list[str] = []
    if len(encoded) != int(document["covered_byte_count"]):
        errors.append("World 2 stage authoring covered-byte count differs")
    encoded_crc = crc32(bytes(encoded[address] for address in sorted(encoded)))
    if encoded_crc != str(document["covered_crc32"]).lower():
        errors.append("World 2 stage authoring covered-byte CRC32 differs")
    if encoded != canonical:
        errors.append("World 2 stage authoring roundtrip differs from PRG")
    return errors


def apply_authoring(prg: bytes, document: dict[str, Any]) -> bytes:
    if len(prg) != 4 * BANK_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    bank = int(document["bank"])
    result = bytearray(prg)
    for address, value in encode_authoring(document).items():
        result[bank * BANK_SIZE + address - CPU_BASE] = value
    return bytes(result)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    validate_parser = subparsers.add_parser("validate")
    validate_parser.add_argument("--prg", required=True, type=Path)
    validate_parser.add_argument("--manifest", required=True, type=Path)
    validate_parser.add_argument("--authoring", required=True, type=Path)
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
            output = apply_authoring(args.base_prg.read_bytes(), document)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_bytes(output)
            print(f"[OK] wrote PRG with {len(encode_authoring(document))} stage bytes")
            return 0
        prg = args.prg.read_bytes()
        manifest = json.loads(args.manifest.read_text(encoding="utf-8"))
        if args.command == "decode":
            document = decode_authoring(prg, manifest)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_text(
                json.dumps(document, indent=2) + "\n",
                encoding="utf-8",
                newline="\n",
            )
            print(f"[OK] wrote World 2 stage sequence to {args.output}")
            return 0
        errors, report = validate_manifest(prg, manifest)
        errors.extend(validate_authoring(prg, manifest, args.authoring))
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 2 stage-sequence audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] World 2 stage sequence: {report['sequence_byte_count']} bytes, "
        f"{report['screen_command_count']} screen commands, "
        f"{report['control_command_count']} control commands, "
        f"{report['unique_screen_id_count']} unique screen ids, "
        f"{report['start_offset_count']} start offsets"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
