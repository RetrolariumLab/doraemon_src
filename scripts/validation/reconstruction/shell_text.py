#!/usr/bin/env python3
"""Validate and edit the shell's fixed text and presentation data."""

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


def crc32(data: bytes) -> str:
    return f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"


def load_json(path: Path, description: str = "shell-text") -> dict[str, Any]:
    document = json.loads(path.read_text(encoding="utf-8"))
    if document.get("schema_version") != 1:
        raise ValueError(f"unsupported {description} schema")
    return document


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("shell-text range is outside PRG")
    return prg[offset:offset + size]


def region_bytes(prg: bytes, bank: int, spec: dict[str, Any]) -> bytes:
    address = number(spec["address"])
    if "size" in spec:
        size = int(spec["size"])
    elif "end_address" in spec:
        size = number(spec["end_address"]) - address + 1
    else:
        size = int(spec["row_width"]) * int(spec["row_count"])
    return bank_slice(prg, bank, address, size)


def decode_zero_space(data: bytes) -> str:
    return "".join(" " if value == 0 else chr(value) for value in data)


def encode_zero_space(text: str) -> bytes:
    try:
        return bytes(0 if character == " " else ord(character) for character in text)
    except ValueError as exc:
        raise ValueError("zero-space text contains a non-byte character") from exc


def decode_title_text(data: bytes) -> str:
    return "".join(
        " " if value == 0 else "." if value == 0x5B else chr(value)
        for value in data
    )


def encode_title_text(text: str) -> bytes:
    try:
        return bytes(
            0 if character == " " else 0x5B if character == "." else ord(character)
            for character in text
        )
    except ValueError as exc:
        raise ValueError("title text contains a non-byte character") from exc


def parse_title_stream(
    data: bytes, address: int, text_records: dict[int, str]
) -> list[dict[str, Any]]:
    records: list[dict[str, Any]] = []
    cursor = 0
    while cursor < len(data):
        source_address = address + cursor
        high = data[cursor]
        if high == 0:
            if cursor != len(data) - 1:
                raise ValueError("title stream terminator is not the final byte")
            return records
        if cursor + 3 > len(data):
            raise ValueError("title stream has a truncated header")
        ppu_address = high << 8 | data[cursor + 1]
        count_byte = data[cursor + 2]
        size = count_byte or 256
        end = cursor + 3 + size
        if end > len(data):
            raise ValueError("title stream has a truncated payload")
        payload = data[cursor + 3:end]
        record: dict[str, Any] = {
            "source_address": f"0x{source_address:04X}",
            "ppu_address": f"0x{ppu_address:04X}",
        }
        if ppu_address in text_records:
            record["id"] = text_records[ppu_address]
            record["text"] = decode_title_text(payload)
        else:
            record["hex"] = payload.hex(" ")
        records.append(record)
        cursor = end
    raise ValueError("title stream has no terminator")


def encode_title_stream(
    records: Any, start_address: int, expected_count: int
) -> bytes:
    if not isinstance(records, list) or len(records) != expected_count:
        raise ValueError(f"title stream must contain {expected_count} records")
    output = bytearray()
    for record in records:
        expected_address = start_address + len(output)
        if number(record["source_address"]) != expected_address:
            raise ValueError("title record source addresses are not contiguous")
        ppu_address = number(record["ppu_address"])
        if not 0x2000 <= ppu_address <= 0x3FFF:
            raise ValueError("title record PPU address is outside nametable space")
        has_text = "text" in record
        has_hex = "hex" in record
        if has_text == has_hex:
            raise ValueError("title record must contain exactly one payload kind")
        payload = (
            encode_title_text(str(record["text"]))
            if has_text
            else bytes.fromhex(str(record["hex"]))
        )
        if not 1 <= len(payload) <= 256:
            raise ValueError("title record payload size is outside 1..256")
        output.extend(ppu_address.to_bytes(2, "big"))
        output.append(len(payload) & 0xFF)
        output.extend(payload)
    output.append(0)
    return bytes(output)


def fixed_hex_rows(data: bytes, width: int) -> list[str]:
    if len(data) % width:
        raise ValueError("fixed-row data is not divisible by its row width")
    return [data[offset:offset + width].hex(" ") for offset in range(0, len(data), width)]


def encode_hex_rows(rows: Any, width: int, count: int, description: str) -> bytes:
    if not isinstance(rows, list) or len(rows) != count:
        raise ValueError(f"{description} must contain {count} rows")
    output = bytearray()
    for row in rows:
        raw = bytes.fromhex(str(row))
        if len(raw) != width:
            raise ValueError(f"{description} row width differs")
        output.extend(raw)
    return bytes(output)


def decode_help_screen(
    data: bytes, screen: dict[str, Any]
) -> dict[str, Any]:
    base = number(screen["address"])
    cursor = 0
    segments: list[dict[str, Any]] = []
    for span in screen["text_spans"]:
        start = number(span["address"]) - base
        size = int(span["size"])
        if start < cursor or start + size > len(data):
            raise ValueError("chapter-help text span is outside or overlaps its screen")
        if start > cursor:
            segments.append({
                "address": f"0x{base + cursor:04X}",
                "hex": data[cursor:start].hex(" "),
            })
        segments.append({
            "id": span["id"],
            "address": f"0x{base + start:04X}",
            "text": data[start:start + size].decode("ascii"),
        })
        cursor = start + size
    if cursor < len(data):
        segments.append({
            "address": f"0x{base + cursor:04X}",
            "hex": data[cursor:].hex(" "),
        })
    return {"id": screen["id"], "address": screen["address"], "segments": segments}


def encode_help_screen(
    screen: dict[str, Any], expected: dict[str, Any], screen_size: int
) -> bytes:
    if screen.get("id") != expected["id"]:
        raise ValueError("chapter-help screen identity differs")
    base = number(expected["address"])
    if number(screen["address"]) != base:
        raise ValueError("chapter-help screen address differs")
    expected_spans = {span["id"]: span for span in expected["text_spans"]}
    output = bytearray()
    for segment in screen.get("segments", []):
        if number(segment["address"]) != base + len(output):
            raise ValueError("chapter-help segments are not contiguous")
        has_text = "text" in segment
        has_hex = "hex" in segment
        if has_text == has_hex:
            raise ValueError("chapter-help segment must contain one payload kind")
        if has_text:
            identifier = segment.get("id")
            if identifier not in expected_spans:
                raise ValueError("chapter-help text span identity differs")
            raw = str(segment["text"]).encode("ascii")
            span = expected_spans.pop(identifier)
            if len(raw) != int(span["size"]):
                raise ValueError("chapter-help text span size differs")
        else:
            raw = bytes.fromhex(str(segment["hex"]))
        output.extend(raw)
    if expected_spans or len(output) != screen_size:
        raise ValueError("chapter-help screen coverage differs")
    return bytes(output)


def decode_authoring(prg: bytes, manifest: dict[str, Any]) -> dict[str, Any]:
    bank = int(manifest["bank"])
    title = manifest["title_stream"]
    title_text = {
        number(record["ppu_address"]): str(record["id"])
        for record in title["text_records"]
    }
    ending = manifest["ending_nametable"]
    help_spec = manifest["chapter_help_screens"]
    help_raw = region_bytes(prg, bank, help_spec)
    screen_size = int(help_spec["screen_size"])
    credits = manifest["ending_credits"]
    credit_raw = region_bytes(prg, bank, credits)
    width = int(credits["row_width"])
    return {
        "schema_version": 1,
        "format": "doraemon-shell-text",
        "bank": bank,
        "game_over": decode_zero_space(
            region_bytes(prg, bank, manifest["game_over"])
        ),
        "title_records": parse_title_stream(
            region_bytes(prg, bank, title), number(title["address"]), title_text
        ),
        "ending_nametable_rows": fixed_hex_rows(
            region_bytes(prg, bank, ending), int(ending["row_width"])
        ),
        "chapter_help_screens": [
            decode_help_screen(
                help_raw[index * screen_size:(index + 1) * screen_size], screen
            )
            for index, screen in enumerate(help_spec["screens"])
        ],
        "ending_credit_rows": [
            credit_raw[offset:offset + width].decode("ascii")
            for offset in range(0, len(credit_raw), width)
        ],
    }


def encode_authoring(
    document: dict[str, Any], manifest: dict[str, Any]
) -> dict[str, bytes]:
    if document.get("schema_version") != 1 or document.get("format") != (
        "doraemon-shell-text"
    ):
        raise ValueError("unsupported shell-text authoring schema")
    if int(document.get("bank", -1)) != int(manifest["bank"]):
        raise ValueError("shell-text authoring targets the wrong bank")
    game = manifest["game_over"]
    game_raw = encode_zero_space(str(document["game_over"]))
    if len(game_raw) != int(game["size"]):
        raise ValueError("game-over text size differs")
    title = manifest["title_stream"]
    title_raw = encode_title_stream(
        document["title_records"],
        number(title["address"]),
        int(title["record_count"]),
    )
    if len(title_raw) != number(title["end_address"]) - number(title["address"]) + 1:
        raise ValueError("title stream size differs")
    ending = manifest["ending_nametable"]
    ending_raw = encode_hex_rows(
        document["ending_nametable_rows"],
        int(ending["row_width"]),
        int(ending["row_count"]),
        "ending nametable",
    )
    help_spec = manifest["chapter_help_screens"]
    screens = document.get("chapter_help_screens")
    if not isinstance(screens, list) or len(screens) != int(help_spec["count"]):
        raise ValueError("chapter-help screen count differs")
    help_raw = b"".join(
        encode_help_screen(screen, expected, int(help_spec["screen_size"]))
        for screen, expected in zip(screens, help_spec["screens"])
    )
    credits = manifest["ending_credits"]
    rows = document.get("ending_credit_rows")
    if not isinstance(rows, list) or len(rows) != int(credits["row_count"]):
        raise ValueError("ending credits row count differs")
    try:
        credit_raw = b"".join(str(row).encode("ascii") for row in rows)
    except UnicodeEncodeError as exc:
        raise ValueError("ending credits contain non-ASCII text") from exc
    if any(len(str(row)) != int(credits["row_width"]) for row in rows):
        raise ValueError("ending credits row width differs")
    return {
        "game_over": game_raw,
        "title_stream": title_raw,
        "ending_nametable": ending_raw,
        "chapter_help_screens": help_raw,
        "ending_credits": credit_raw,
    }


def validate_manifest_data(
    prg: bytes, manifest: dict[str, Any]
) -> tuple[list[str], dict[str, int]]:
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    errors: list[str] = []
    bank = int(manifest.get("bank", -1))
    if bank != 3:
        errors.append("shell text must reside in PRG bank 3")
    region_names = [
        "game_over",
        "title_stream",
        "ending_nametable",
        "chapter_help_screens",
        "ending_credits",
        "post_credit_data",
    ]
    total = 0
    for name in region_names:
        try:
            data = region_bytes(prg, bank, manifest[name])
            total += len(data)
            if crc32(data) != str(manifest[name]["crc32"]).lower():
                errors.append(f"{name} CRC32 differs")
        except (KeyError, TypeError, ValueError) as exc:
            errors.append(str(exc))
    try:
        decoded = decode_authoring(prg, manifest)
        if len(decoded["title_records"]) != int(manifest["title_stream"]["record_count"]):
            errors.append("title record count differs")
        if len(decoded["chapter_help_screens"]) != int(manifest["chapter_help_screens"]["count"]):
            errors.append("chapter-help screen count differs")
        if len(decoded["ending_credit_rows"]) != int(manifest["ending_credits"]["row_count"]):
            errors.append("ending credits row count differs")
    except (KeyError, TypeError, ValueError, UnicodeDecodeError) as exc:
        errors.append(str(exc))
    for signature in manifest.get("signatures", []):
        try:
            raw = bytes.fromhex(str(signature["bytes"]))
            actual = bank_slice(prg, bank, number(signature["address"]), len(raw))
            if actual != raw:
                errors.append(f"shell-text signature differs at ${number(signature['address']):04X}")
        except (KeyError, TypeError, ValueError) as exc:
            errors.append(str(exc))
    return errors, {"region_count": len(region_names), "classified_bytes": total}


def validate_authoring(
    prg: bytes, manifest: dict[str, Any], authoring: dict[str, Any]
) -> tuple[list[str], dict[str, int]]:
    errors, report = validate_manifest_data(prg, manifest)
    try:
        expected = decode_authoring(prg, manifest)
        if authoring != expected:
            errors.append("shell-text authoring document differs from decoded PRG")
        encoded = encode_authoring(authoring, manifest)
        bank = int(manifest["bank"])
        for name, raw in encoded.items():
            if raw != region_bytes(prg, bank, manifest[name]):
                errors.append(f"{name} authoring roundtrip differs from PRG")
    except (KeyError, TypeError, ValueError, UnicodeError) as exc:
        errors.append(str(exc))
    report["editable_bytes"] = sum(
        len(data) for data in encode_authoring(decode_authoring(prg, manifest), manifest).values()
    )
    return errors, report


def apply_authoring(
    prg: bytes, document: dict[str, Any], manifest: dict[str, Any]
) -> bytes:
    output = bytearray(prg)
    bank = int(manifest["bank"])
    for name, raw in encode_authoring(document, manifest).items():
        address = number(manifest[name]["address"])
        offset = bank * BANK_SIZE + address - CPU_BASE
        output[offset:offset + len(raw)] = raw
    return bytes(output)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    decode_parser = subparsers.add_parser("decode")
    decode_parser.add_argument("--prg", required=True, type=Path)
    decode_parser.add_argument("--manifest", required=True, type=Path)
    decode_parser.add_argument("--output", required=True, type=Path)
    encode_parser = subparsers.add_parser("encode")
    encode_parser.add_argument("--base-prg", required=True, type=Path)
    encode_parser.add_argument("--manifest", required=True, type=Path)
    encode_parser.add_argument("--input", required=True, type=Path)
    encode_parser.add_argument("--output", required=True, type=Path)
    validate_parser = subparsers.add_parser("validate")
    validate_parser.add_argument("--prg", required=True, type=Path)
    validate_parser.add_argument("--manifest", required=True, type=Path)
    validate_parser.add_argument("--authoring", required=True, type=Path)
    args = parser.parse_args()
    try:
        manifest = load_json(args.manifest, "shell-text manifest")
        if args.command == "decode":
            document = decode_authoring(args.prg.read_bytes(), manifest)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_text(json.dumps(document, indent=2) + "\n", encoding="utf-8")
            print(f"[OK] wrote shell-text authoring data to {args.output}")
            return 0
        if args.command == "encode":
            output = apply_authoring(
                args.base_prg.read_bytes(), load_json(args.input), manifest
            )
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_bytes(output)
            print(f"[OK] wrote shell-text edits to {args.output}")
            return 0
        errors, report = validate_authoring(
            args.prg.read_bytes(), manifest, load_json(args.authoring)
        )
        if errors:
            for error in errors:
                print(f"[ERROR] {error}")
            return 1
        print(
            f"[OK] shell text: {report['region_count']} regions, "
            f"{report['editable_bytes']} editable / "
            f"{report['classified_bytes']} classified bytes"
        )
        return 0
    except (OSError, KeyError, TypeError, ValueError, UnicodeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] shell-text operation failed: {exc}")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
