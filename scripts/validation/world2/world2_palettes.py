#!/usr/bin/env python3
"""Validate and losslessly edit World 2 background and sprite palettes."""

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


def byte_value(value: str | int, description: str) -> int:
    result = number(value)
    if not 0 <= result <= 0xFF:
        raise ValueError(f"{description} is outside byte range")
    return result


def crc32(data: bytes) -> str:
    return f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("World 2 palette range is outside PRG")
    return prg[offset:offset + size]


def load_json(path: Path, description: str) -> dict[str, Any]:
    document = json.loads(path.read_text(encoding="utf-8"))
    if document.get("schema_version") != 1:
        raise ValueError(f"unsupported {description} schema")
    return document


def indexed_records(
    records: Any,
    count: int,
    description: str,
) -> list[dict[str, Any]]:
    if not isinstance(records, list) or len(records) != count:
        raise ValueError(f"{description} must contain {count} records")
    if [int(record.get("id", -1)) for record in records] != list(range(count)):
        raise ValueError(f"{description} ids are not contiguous")
    return records


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


def stage_palette_counts(document: dict[str, Any]) -> Counter[int]:
    if document.get("schema_version") != 1 or document.get("format") != (
        "doraemon-world2-stage-sequence"
    ):
        raise ValueError("unsupported World 2 stage authoring schema")
    entries = document.get("entries")
    if not isinstance(entries, list):
        raise ValueError("World 2 stage entries must be a list")
    counts: Counter[int] = Counter()
    for entry in entries:
        if entry.get("command") == "set_background_palette":
            palette_id = int(entry["palette_id"])
            if number(entry["raw"]) & 0x07 != palette_id:
                raise ValueError("stage palette id differs from raw token")
            counts[palette_id] += 1
    return counts


def palette_layout(
    document: dict[str, Any],
) -> tuple[int, int, int, int, int, int, int, int]:
    bank = int(document["bank"])
    palettes = document["palette_sets"]
    count = int(palettes["count"])
    colors_per_set = int(palettes["colors_per_set"])
    palette_address = number(palettes["address"])
    lookup = document["lookup"]
    background_base = number(lookup["background_index_base"])
    sprite_base = number(lookup["sprite_offset_base"])
    background = document["initial_background_selectors"]
    sprite = document["initial_sprite_offsets"]
    chapter_count = int(background["count"])
    if colors_per_set != 16:
        raise ValueError("World 2 palette set must contain 16 colors")
    if background_base + colors_per_set != palette_address:
        raise ValueError("World 2 background lookup base differs")
    if int(sprite["count"]) != chapter_count:
        raise ValueError("World 2 chapter palette-selector counts differ")
    return (
        bank,
        count,
        colors_per_set,
        palette_address,
        background_base,
        sprite_base,
        number(background["address"]),
        number(sprite["address"]),
    )


def validate_manifest_data(
    prg: bytes,
    document: dict[str, Any],
    stage_authoring: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    errors: list[str] = []
    try:
        (
            bank,
            count,
            colors_per_set,
            palette_address,
            _background_base,
            sprite_base,
            background_address,
            sprite_address,
        ) = palette_layout(document)
        palette_spec = document["palette_sets"]
        background_spec = document["initial_background_selectors"]
        sprite_spec = document["initial_sprite_offsets"]
        palette_data = bank_slice(
            prg, bank, palette_address, count * colors_per_set
        )
        chapter_count = int(background_spec["count"])
        background_data = bank_slice(
            prg, bank, background_address, chapter_count
        )
        sprite_data = bank_slice(prg, bank, sprite_address, chapter_count)
        stage_counts = stage_palette_counts(stage_authoring)
    except (KeyError, TypeError, ValueError) as exc:
        return [str(exc)], {}

    if crc32(palette_data) != str(palette_spec["crc32"]).lower():
        errors.append("World 2 palette-set CRC32 differs")
    if any(color > 0x3F for color in palette_data):
        errors.append("World 2 palette color is outside NES palette range")
    universal = byte_value(
        palette_spec["universal_background_color"],
        "universal background color",
    )
    if any(
        palette_data[index * colors_per_set] != universal
        for index in range(count)
    ):
        errors.append("World 2 universal background colors differ")
    if len(
        {
            palette_data[index:index + colors_per_set]
            for index in range(0, len(palette_data), colors_per_set)
        }
    ) != int(palette_spec["expected_unique_count"]):
        errors.append("World 2 unique palette-set count differs")

    expected_background = bytes(
        number(value) for value in background_spec["values"]
    )
    if background_data != expected_background:
        errors.append("World 2 initial background selectors differ")
    if crc32(background_data) != str(background_spec["crc32"]).lower():
        errors.append("World 2 initial background-selector CRC32 differs")
    if any(not 1 <= value <= count for value in background_data):
        errors.append("World 2 initial background selector is outside catalog")

    expected_sprite = bytes(number(value) for value in sprite_spec["values"])
    if sprite_data != expected_sprite:
        errors.append("World 2 initial sprite offsets differ")
    if crc32(sprite_data) != str(sprite_spec["crc32"]).lower():
        errors.append("World 2 initial sprite-offset CRC32 differs")
    sprite_records: list[int] = []
    for offset in sprite_data:
        relative = sprite_base + offset - palette_address
        if relative < 0 or relative % colors_per_set:
            errors.append("World 2 sprite palette offset is not set-aligned")
            continue
        sprite_records.append(relative // colors_per_set)
    if sprite_records != [
        int(value) for value in sprite_spec["palette_records"]
    ]:
        errors.append("World 2 initial sprite palette records differ")
    if any(not 0 <= record < count for record in sprite_records):
        errors.append("World 2 initial sprite palette is outside catalog")

    expected_stage_counts = Counter({
        int(palette_id): int(value)
        for palette_id, value in document["stage_palette_counts"].items()
    })
    if stage_counts != expected_stage_counts:
        errors.append("World 2 stage palette-command counts differ")
    if any(not 1 <= palette_id <= count for palette_id in stage_counts):
        errors.append("World 2 stage palette command is outside catalog")

    for signature in document["code_signatures"]:
        expected = bytes.fromhex(str(signature["bytes"]))
        actual = bank_slice(
            prg,
            bank,
            number(signature["address"]),
            len(expected),
        )
        if actual != expected:
            errors.append(
                f"World 2 palette code signature {signature['name']} differs"
            )

    return errors, {
        "palette_set_count": count,
        "palette_byte_count": len(palette_data),
        "chapter_count": len(background_data),
        "stage_palette_command_count": sum(stage_counts.values()),
        "covered_byte_count": (
            len(palette_data) + len(background_data) + len(sprite_data)
        ),
    }


def encode_authoring(document: dict[str, Any]) -> dict[int, int]:
    if document.get("schema_version") != 1 or document.get("format") != (
        "doraemon-world2-palettes"
    ):
        raise ValueError("unsupported World 2 palette authoring schema")
    if int(document["bank"]) != 1:
        raise ValueError("World 2 palette authoring must target PRG bank 1")
    count = int(document["palette_count"])
    colors_per_set = int(document["colors_per_set"])
    if colors_per_set != 16:
        raise ValueError("World 2 authoring palette width differs")
    records = indexed_records(document["palettes"], count, "palette")
    palette_data = bytearray()
    for record in records:
        colors = record.get("colors")
        if not isinstance(colors, list) or len(colors) != colors_per_set:
            raise ValueError("World 2 palette record has wrong color count")
        encoded_colors = bytes(
            byte_value(value, "palette color") for value in colors
        )
        if any(color > 0x3F for color in encoded_colors):
            raise ValueError("palette color is outside NES palette range")
        palette_data.extend(encoded_colors)

    chapters = indexed_records(
        document["chapters"],
        int(document["chapter_count"]),
        "chapter palette",
    )
    background_data = bytes(
        byte_value(chapter["background_palette_id"], "background palette id")
        for chapter in chapters
    )
    if any(not 1 <= palette_id <= count for palette_id in background_data):
        raise ValueError("background palette id is outside catalog")
    sprite_data = bytes(
        byte_value(chapter["sprite_offset"], "sprite palette offset")
        for chapter in chapters
    )
    palette_address = number(document["palette_address"])
    sprite_base = number(document["sprite_offset_base"])
    for chapter, offset in zip(chapters, sprite_data):
        relative = sprite_base + offset - palette_address
        if relative < 0 or relative % colors_per_set:
            raise ValueError("sprite palette offset is not set-aligned")
        if int(chapter["sprite_palette_record"]) != relative // colors_per_set:
            raise ValueError("sprite palette record differs from offset")
        if not 0 <= relative // colors_per_set < count:
            raise ValueError("sprite palette record is outside catalog")
    result: dict[int, int] = {}
    add_region(result, palette_address, bytes(palette_data), "palette sets")
    add_region(
        result,
        number(document["background_selector_address"]),
        background_data,
        "background selectors",
    )
    add_region(
        result,
        number(document["sprite_offset_address"]),
        sprite_data,
        "sprite offsets",
    )
    return result


def decode_authoring(
    prg: bytes,
    manifest: dict[str, Any],
    stage_authoring: dict[str, Any],
) -> dict[str, Any]:
    errors, report = validate_manifest_data(prg, manifest, stage_authoring)
    if errors:
        raise ValueError("; ".join(errors))
    (
        bank,
        count,
        colors_per_set,
        palette_address,
        _background_base,
        sprite_base,
        background_address,
        sprite_address,
    ) = palette_layout(manifest)
    palette_data = bank_slice(
        prg, bank, palette_address, count * colors_per_set
    )
    chapter_count = int(manifest["initial_background_selectors"]["count"])
    background_data = bank_slice(
        prg, bank, background_address, chapter_count
    )
    sprite_data = bank_slice(prg, bank, sprite_address, chapter_count)
    result: dict[str, Any] = {
        "schema_version": 1,
        "format": "doraemon-world2-palettes",
        "bank": bank,
        "palette_address": f"0x{palette_address:04X}",
        "palette_count": count,
        "colors_per_set": colors_per_set,
        "palettes": [
            {
                "id": palette_id,
                "colors": [
                    f"0x{color:02X}"
                    for color in palette_data[
                        palette_id * colors_per_set:
                        (palette_id + 1) * colors_per_set
                    ]
                ],
            }
            for palette_id in range(count)
        ],
        "background_selector_address": f"0x{background_address:04X}",
        "sprite_offset_address": f"0x{sprite_address:04X}",
        "sprite_offset_base": f"0x{sprite_base:04X}",
        "chapter_count": chapter_count,
        "chapters": [
            {
                "id": chapter,
                "background_palette_id": background_data[chapter],
                "sprite_offset": f"0x{sprite_data[chapter]:02X}",
                "sprite_palette_record": (
                    sprite_base + sprite_data[chapter] - palette_address
                ) // colors_per_set,
            }
            for chapter in range(chapter_count)
        ],
        "covered_byte_count": report["covered_byte_count"],
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
    stage_authoring: dict[str, Any],
    path: Path,
) -> list[str]:
    document = json.loads(path.read_text(encoding="utf-8"))
    encoded = encode_authoring(document)
    canonical = encode_authoring(
        decode_authoring(prg, manifest, stage_authoring)
    )
    errors: list[str] = []
    if len(encoded) != int(document["covered_byte_count"]):
        errors.append("World 2 palette authoring covered-byte count differs")
    encoded_crc = crc32(bytes(encoded[address] for address in sorted(encoded)))
    if encoded_crc != str(document["covered_crc32"]).lower():
        errors.append("World 2 palette authoring covered-byte CRC32 differs")
    if encoded != canonical:
        errors.append("World 2 palette authoring roundtrip differs from PRG")
    return errors


def apply_authoring(prg: bytes, document: dict[str, Any]) -> bytes:
    if len(prg) != 4 * BANK_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    bank = int(document["bank"])
    result = bytearray(prg)
    for address, value in encode_authoring(document).items():
        offset = bank * BANK_SIZE + address - CPU_BASE
        if not 0 <= offset < len(result):
            raise ValueError("World 2 palette authoring address is outside PRG")
        result[offset] = value
    return bytes(result)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    for name in ("validate", "decode"):
        command = subparsers.add_parser(name)
        command.add_argument("--prg", required=True, type=Path)
        command.add_argument("--manifest", required=True, type=Path)
        command.add_argument("--stage-authoring", required=True, type=Path)
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
            document = load_json(args.input, "World 2 palette authoring")
            encoded = apply_authoring(args.base_prg.read_bytes(), document)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_bytes(encoded)
            print(
                f"[OK] wrote PRG with {document['covered_byte_count']} "
                "World 2 palette bytes"
            )
            return 0
        prg = args.prg.read_bytes()
        manifest = load_json(args.manifest, "World 2 palette")
        stage_authoring = load_json(
            args.stage_authoring, "World 2 stage authoring"
        )
        if args.command == "decode":
            decoded = decode_authoring(prg, manifest, stage_authoring)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_text(
                json.dumps(decoded, indent=2) + "\n",
                encoding="utf-8",
                newline="\n",
            )
            print(f"[OK] wrote World 2 palettes to {args.output}")
            return 0
        errors, report = validate_manifest_data(
            prg, manifest, stage_authoring
        )
        errors.extend(
            validate_authoring(
                prg,
                manifest,
                stage_authoring,
                args.authoring,
            )
        )
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 2 palette audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] World 2 palettes: {report['palette_set_count']} sets, "
        f"{report['chapter_count']} chapter selectors, "
        f"{report['stage_palette_command_count']} stage commands; "
        f"{report['covered_byte_count']} lossless authoring bytes"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
