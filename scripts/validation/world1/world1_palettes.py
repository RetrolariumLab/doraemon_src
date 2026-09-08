#!/usr/bin/env python3
"""Validate and losslessly edit the twelve World 1 full PPU palettes."""

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


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("World 1 palette range is outside PRG")
    return prg[offset:offset + size]


def load_json(path: Path, description: str) -> dict[str, Any]:
    document = json.loads(path.read_text(encoding="utf-8"))
    if document.get("schema_version") != 1:
        raise ValueError(f"unsupported {description} schema")
    return document


def layout(manifest: dict[str, Any]) -> tuple[int, int, int, int]:
    bank = int(manifest["bank"])
    palette = manifest["palettes"]
    address = number(palette["address"])
    count = int(palette["count"])
    width = int(palette["colors_per_palette"])
    if bank != 0 or width != 32 or count != 12:
        raise ValueError("World 1 palette geometry differs")
    return bank, address, count, width


def parse_colors(value: object, width: int) -> bytes:
    if not isinstance(value, str):
        raise ValueError("World 1 palette colors must be a hex string")
    try:
        colors = bytes.fromhex(value)
    except ValueError as exc:
        raise ValueError("World 1 palette contains invalid hex") from exc
    if len(colors) != width:
        raise ValueError("World 1 palette has the wrong color count")
    if any(color > 0x3F for color in colors):
        raise ValueError("World 1 color is outside NES palette range")
    return colors


def encode_authoring(document: dict[str, Any]) -> bytes:
    if document.get("schema_version") != 1 or document.get("format") != (
        "doraemon-world1-palettes"
    ):
        raise ValueError("unsupported World 1 palette authoring schema")
    if int(document["bank"]) != 0:
        raise ValueError("World 1 palettes must target PRG bank 0")
    count = int(document["palette_count"])
    width = int(document["colors_per_palette"])
    if count != 12 or width != 32:
        raise ValueError("World 1 palette authoring geometry differs")
    records = document.get("palettes")
    if not isinstance(records, list) or len(records) != count:
        raise ValueError("World 1 palette record count differs")
    if [record.get("id") for record in records] != list(range(count)):
        raise ValueError("World 1 palette ids are not contiguous")
    return b"".join(parse_colors(record.get("colors"), width) for record in records)


def decode_authoring(prg: bytes, manifest: dict[str, Any]) -> dict[str, Any]:
    errors, _ = validate_manifest_data(prg, manifest)
    if errors:
        raise ValueError("; ".join(errors))
    bank, address, count, width = layout(manifest)
    data = bank_slice(prg, bank, address, count * width)
    return {
        "schema_version": 1,
        "format": "doraemon-world1-palettes",
        "bank": bank,
        "address": f"0x{address:04X}",
        "palette_count": count,
        "colors_per_palette": width,
        "palettes": [
            {
                "id": palette_id,
                "colors": data[
                    palette_id * width:(palette_id + 1) * width
                ].hex(" ").upper(),
            }
            for palette_id in range(count)
        ],
        "covered_byte_count": len(data),
        "covered_crc32": crc32(data),
    }


def validate_manifest_data(
    prg: bytes, manifest: dict[str, Any]
) -> tuple[list[str], dict[str, int]]:
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    try:
        bank, address, count, width = layout(manifest)
        spec = manifest["palettes"]
        data = bank_slice(prg, bank, address, count * width)
    except (KeyError, TypeError, ValueError) as exc:
        return [str(exc)], {}
    errors: list[str] = []
    if crc32(data) != str(spec["crc32"]).lower():
        errors.append("World 1 palette CRC32 differs")
    if any(color > 0x3F for color in data):
        errors.append("World 1 color is outside NES palette range")
    universal = number(spec["universal_background_color"])
    if any(data[offset] != universal for offset in range(0, len(data), 4)):
        errors.append("World 1 universal background colors differ")
    unique = len({data[offset:offset + width] for offset in range(0, len(data), width)})
    if unique != int(spec["expected_unique_count"]):
        errors.append("World 1 unique palette count differs")
    signature = manifest["loader_signature"]
    expected = bytes.fromhex(str(signature["bytes"]))
    if bank_slice(prg, bank, number(signature["address"]), len(expected)) != expected:
        errors.append("World 1 palette loader signature differs")
    return errors, {
        "palette_count": count,
        "unique_palette_count": unique,
        "covered_byte_count": len(data),
    }


def validate_authoring(
    prg: bytes, manifest: dict[str, Any], path: Path
) -> list[str]:
    document = load_json(path, "World 1 palette authoring")
    encoded = encode_authoring(document)
    canonical = encode_authoring(decode_authoring(prg, manifest))
    errors: list[str] = []
    if len(encoded) != int(document["covered_byte_count"]):
        errors.append("World 1 palette covered-byte count differs")
    if crc32(encoded) != str(document["covered_crc32"]).lower():
        errors.append("World 1 palette authoring CRC32 differs")
    if encoded != canonical:
        errors.append("World 1 palette authoring roundtrip differs from PRG")
    return errors


def apply_authoring(prg: bytes, document: dict[str, Any]) -> bytes:
    if len(prg) != 4 * BANK_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    address = number(document["address"])
    data = encode_authoring(document)
    offset = int(document["bank"]) * BANK_SIZE + address - CPU_BASE
    if not 0 <= offset <= len(prg) - len(data):
        raise ValueError("World 1 palette authoring range is outside PRG")
    result = bytearray(prg)
    result[offset:offset + len(data)] = data
    return bytes(result)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    for name in ("validate", "decode"):
        command = subparsers.add_parser(name)
        command.add_argument("--prg", required=True, type=Path)
        command.add_argument("--manifest", required=True, type=Path)
        if name == "validate":
            command.add_argument("--authoring", required=True, type=Path)
        else:
            command.add_argument("--output", required=True, type=Path)
    encode = subparsers.add_parser("encode")
    encode.add_argument("--input", required=True, type=Path)
    encode.add_argument("--base-prg", required=True, type=Path)
    encode.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    try:
        if args.command == "encode":
            document = load_json(args.input, "World 1 palette authoring")
            result = apply_authoring(args.base_prg.read_bytes(), document)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_bytes(result)
            print(f"[OK] wrote PRG with {len(encode_authoring(document))} palette bytes")
            return 0
        prg = args.prg.read_bytes()
        manifest = load_json(args.manifest, "World 1 palette")
        if args.command == "decode":
            decoded = decode_authoring(prg, manifest)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_text(
                json.dumps(decoded, indent=2) + "\n", encoding="utf-8", newline="\n"
            )
            print(f"[OK] wrote World 1 palettes to {args.output}")
            return 0
        errors, report = validate_manifest_data(prg, manifest)
        errors.extend(validate_authoring(prg, manifest, args.authoring))
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 1 palette audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] World 1 palettes: {report['palette_count']} full sets, "
        f"{report['unique_palette_count']} unique; "
        f"{report['covered_byte_count']} lossless authoring bytes"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
