#!/usr/bin/env python3
"""Validate and losslessly edit the exact World 2 metatile catalog."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any
import zlib


BANK_SIZE = 0x8000
CPU_BASE = 0x8000
TILE_FIELDS = ("top_left", "top_right", "bottom_left", "bottom_right")


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
        raise ValueError("World 2 metatile range is outside PRG")
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


def parse_screen_references(document: dict[str, Any]) -> set[int]:
    if document.get("schema_version") != 1 or document.get("format") != (
        "world2-compressed-screens"
    ):
        raise ValueError("unsupported World 2 screen authoring schema")
    tokens = document.get("tokens")
    if not isinstance(tokens, list):
        raise ValueError("World 2 screen tokens must be a list")
    references: set[int] = set()
    for token in tokens:
        parts = str(token).split(":")
        if len(parts) < 2:
            raise ValueError(f"invalid World 2 screen token: {token!r}")
        kind = parts[1]
        try:
            if kind == "L" and len(parts) == 3:
                references.add(int(parts[2], 16))
            elif kind == "R" and len(parts) == 4:
                references.add(int(parts[3], 16))
            elif kind == "S" and len(parts) == 3:
                references.add(0)
            elif kind == "E" and len(parts) == 2:
                continue
            else:
                raise ValueError
        except ValueError as exc:
            raise ValueError(
                f"invalid World 2 screen token: {token!r}"
            ) from exc
    return references


def layout(document: dict[str, Any]) -> tuple[int, int, int, int, int]:
    bank = int(document["bank"])
    count = int(document["metatile_count"])
    prefix = document["unindexed_prefix"]
    palettes = document["palette_selectors"]
    tiles = document["tile_quads"]
    prefix_address = number(prefix["address"])
    palette_address = number(palettes["address"])
    tile_address = number(tiles["address"])
    runtime_range = [number(value) for value in document["runtime_id_range"]]
    if runtime_range != [0, count - 1]:
        raise ValueError("World 2 runtime metatile id range differs")
    if int(prefix["size"]) != 1:
        raise ValueError("World 2 unindexed prefix must contain one byte")
    if int(palettes["count"]) != count:
        raise ValueError("World 2 palette-selector count differs")
    if int(tiles["count"]) != count:
        raise ValueError("World 2 tile-quad count differs")
    if int(tiles["bytes_per_metatile"]) != len(TILE_FIELDS):
        raise ValueError("World 2 metatile width differs")
    if tuple(tiles["order"]) != TILE_FIELDS:
        raise ValueError("World 2 metatile tile order differs")
    if palette_address != prefix_address + 1:
        raise ValueError("World 2 palette selectors do not follow prefix")
    if tile_address != palette_address + count:
        raise ValueError("World 2 tile quads do not follow palette selectors")
    if number(document["next_region_address"]) != (
        tile_address + count * len(TILE_FIELDS)
    ):
        raise ValueError("World 2 metatile data does not end at next region")
    return bank, count, prefix_address, palette_address, tile_address


def validate_manifest_data(
    prg: bytes,
    document: dict[str, Any],
    screen_authoring: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    errors: list[str] = []
    try:
        bank, count, prefix_address, palette_address, tile_address = layout(
            document
        )
        prefix_spec = document["unindexed_prefix"]
        palette_spec = document["palette_selectors"]
        tile_spec = document["tile_quads"]
        collision_spec = document["collision_bits"]
        prefix = bank_slice(prg, bank, prefix_address, 1)
        palettes = bank_slice(prg, bank, palette_address, count)
        tiles = bank_slice(prg, bank, tile_address, count * len(TILE_FIELDS))
        collision_address = number(collision_spec["address"])
        collision_size = int(collision_spec["size"])
        collision = bank_slice(prg, bank, collision_address, collision_size)
        renderer = document["renderer"]
        signature = bytes.fromhex(str(renderer["signature"]))
        actual_signature = bank_slice(
            prg,
            bank,
            number(renderer["address"]),
            len(signature),
        )
        collision_lookup = document["collision_lookup"]
        collision_signature = bytes.fromhex(str(collision_lookup["signature"]))
        actual_collision_signature = bank_slice(
            prg,
            bank,
            number(collision_lookup["address"]),
            len(collision_signature),
        )
        references = parse_screen_references(screen_authoring)
    except (KeyError, TypeError, ValueError) as exc:
        return [str(exc)], {}

    if crc32(prefix) != str(prefix_spec["crc32"]).lower():
        errors.append("World 2 unindexed-prefix CRC32 differs")
    if prefix[0] != byte_value(prefix_spec["value"], "unindexed prefix"):
        errors.append("World 2 unindexed-prefix value differs")
    if crc32(palettes) != str(palette_spec["crc32"]).lower():
        errors.append("World 2 palette-selector CRC32 differs")
    if crc32(tiles) != str(tile_spec["crc32"]).lower():
        errors.append("World 2 tile-quad CRC32 differs")
    if collision_size != (count + 7) // 8:
        errors.append("World 2 collision bitmap size differs from metatile count")
    if str(collision_spec["bit_order"]) != "msb-first":
        errors.append("World 2 collision bitmap bit order differs")
    if crc32(collision) != str(collision_spec["crc32"]).lower():
        errors.append("World 2 collision-bitmap CRC32 differs")
    if count % 8 and collision[-1] & ((1 << (8 - count % 8)) - 1):
        errors.append("World 2 collision bitmap has set padding bits")
    solid_count = sum(
        bool(collision[metatile_id >> 3] & (0x80 >> (metatile_id & 7)))
        for metatile_id in range(count)
    )
    if solid_count != int(collision_spec["solid_metatile_count"]):
        errors.append("World 2 solid-metatile count differs")
    if actual_signature != signature:
        errors.append("World 2 metatile renderer signature differs")
    if actual_collision_signature != collision_signature:
        errors.append("World 2 metatile collision lookup signature differs")
    if number(renderer["palette_address"]) != palette_address:
        errors.append("World 2 renderer palette address differs")
    expected_bases = [tile_address + index * 0x100 for index in range(4)]
    if [number(value) for value in renderer["tile_table_bases"]] != (
        expected_bases
    ):
        errors.append("World 2 renderer tile-table bases differ")
    if number(collision_lookup["screen_buffer_address"]) != 0x0400:
        errors.append("World 2 collision screen-buffer address differs")
    if number(collision_lookup["bit_mask_address"]) != 0x93AF:
        errors.append("World 2 collision bit-mask address differs")
    if number(collision_lookup["collision_bits_address"]) != collision_address:
        errors.append("World 2 collision bitmap address differs from lookup")

    palette_limit = int(palette_spec["value_limit"])
    if any(value >= palette_limit for value in palettes):
        errors.append("World 2 palette selector is outside runtime domain")
    histogram = [palettes.count(value) for value in range(palette_limit)]
    if histogram != [int(value) for value in palette_spec["histogram"]]:
        errors.append("World 2 palette-selector histogram differs")

    reference_spec = document["standard_stream_references"]
    invalid_references = sorted(value for value in references if value >= count)
    if invalid_references:
        errors.append(
            "World 2 standard screens reference metatiles outside catalog: "
            + ", ".join(f"${value:02X}" for value in invalid_references)
        )
    missing = sorted(set(range(count)) - references)
    if len(references) != int(reference_spec["expected_unique_count"]):
        errors.append("World 2 referenced-metatile count differs")
    if missing != [number(value) for value in reference_spec["unreferenced_ids"]]:
        errors.append("World 2 unreferenced-metatile ids differ")

    return errors, {
        "metatile_count": count,
        "referenced_metatile_count": len(references),
        "unreferenced_metatile_count": len(missing),
        "palette_count": len(palettes),
        "tile_byte_count": len(tiles),
        "collision_byte_count": len(collision),
        "solid_metatile_count": solid_count,
        "covered_byte_count": 1 + len(palettes) + len(tiles) + len(collision),
    }


def encode_authoring(document: dict[str, Any]) -> dict[int, int]:
    if document.get("schema_version") != 1 or document.get("format") != (
        "doraemon-world2-metatiles"
    ):
        raise ValueError("unsupported World 2 metatile authoring schema")
    count = int(document["metatile_count"])
    if tuple(document["tile_order"]) != TILE_FIELDS:
        raise ValueError("World 2 authoring tile order differs")
    records = indexed_records(document["records"], count, "metatile")
    prefix_address = number(document["unindexed_prefix"]["address"])
    palette_address = number(document["palette_address"])
    tile_address = number(document["tile_address"])
    collision_address = number(document["collision_address"])
    if palette_address != prefix_address + 1:
        raise ValueError("World 2 authoring palette address differs")
    if tile_address != palette_address + count:
        raise ValueError("World 2 authoring tile address differs")

    encoded: dict[int, int] = {
        prefix_address: byte_value(
            document["unindexed_prefix"]["value"],
            "unindexed prefix",
        )
    }
    for record in records:
        metatile_id = int(record["id"])
        palette = byte_value(record["palette"], "metatile palette")
        if palette >= 4:
            raise ValueError("metatile palette is outside selector domain")
        referenced = record.get("referenced_by_standard_stream")
        if not isinstance(referenced, bool):
            raise ValueError("metatile reference flag must be boolean")
        solid = record.get("solid")
        if not isinstance(solid, bool):
            raise ValueError("metatile solid flag must be boolean")
        encoded[palette_address + metatile_id] = palette
        for field_index, field in enumerate(TILE_FIELDS):
            encoded[tile_address + metatile_id * 4 + field_index] = byte_value(
                record[field], f"metatile {field}"
            )
    collision = bytearray((count + 7) // 8)
    for record in records:
        if record["solid"]:
            metatile_id = int(record["id"])
            collision[metatile_id >> 3] |= 0x80 >> (metatile_id & 7)
    for offset, value in enumerate(collision):
        encoded[collision_address + offset] = value
    return encoded


def decode_authoring(
    prg: bytes,
    manifest: dict[str, Any],
    screen_authoring: dict[str, Any],
) -> dict[str, Any]:
    errors, report = validate_manifest_data(prg, manifest, screen_authoring)
    if errors:
        raise ValueError("; ".join(errors))
    bank, count, prefix_address, palette_address, tile_address = layout(manifest)
    prefix = bank_slice(prg, bank, prefix_address, 1)[0]
    palettes = bank_slice(prg, bank, palette_address, count)
    tiles = bank_slice(prg, bank, tile_address, count * 4)
    collision_address = number(manifest["collision_bits"]["address"])
    collision = bank_slice(prg, bank, collision_address, (count + 7) // 8)
    references = parse_screen_references(screen_authoring)
    result: dict[str, Any] = {
        "schema_version": 1,
        "format": "doraemon-world2-metatiles",
        "bank": bank,
        "unindexed_prefix": {
            "address": f"0x{prefix_address:04X}",
            "value": f"0x{prefix:02X}",
        },
        "palette_address": f"0x{palette_address:04X}",
        "tile_address": f"0x{tile_address:04X}",
        "collision_address": f"0x{collision_address:04X}",
        "metatile_count": count,
        "tile_order": list(TILE_FIELDS),
        "records": [
            {
                "id": metatile_id,
                "palette": palettes[metatile_id],
                **{
                    field: f"0x{tiles[metatile_id * 4 + field_index]:02X}"
                    for field_index, field in enumerate(TILE_FIELDS)
                },
                "referenced_by_standard_stream": metatile_id in references,
                "solid": bool(
                    collision[metatile_id >> 3] & (0x80 >> (metatile_id & 7))
                ),
            }
            for metatile_id in range(count)
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
    screen_authoring: dict[str, Any],
    path: Path,
) -> list[str]:
    document = json.loads(path.read_text(encoding="utf-8"))
    encoded = encode_authoring(document)
    canonical_document = decode_authoring(prg, manifest, screen_authoring)
    canonical = encode_authoring(canonical_document)
    errors: list[str] = []
    if len(encoded) != int(document["covered_byte_count"]):
        errors.append("World 2 metatile authoring covered-byte count differs")
    encoded_crc = crc32(bytes(encoded[address] for address in sorted(encoded)))
    if encoded_crc != str(document["covered_crc32"]).lower():
        errors.append("World 2 metatile authoring covered-byte CRC32 differs")
    if set(encoded) != set(canonical):
        errors.append("World 2 metatile authoring coverage differs")
    elif encoded != canonical:
        errors.append("World 2 metatile authoring roundtrip differs from PRG")
    expected_flags = [
        record["referenced_by_standard_stream"]
        for record in canonical_document["records"]
    ]
    actual_flags = [
        record["referenced_by_standard_stream"]
        for record in document["records"]
    ]
    if actual_flags != expected_flags:
        errors.append("World 2 metatile reference flags differ")
    return errors


def apply_authoring(prg: bytes, document: dict[str, Any]) -> bytes:
    if len(prg) != 4 * BANK_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    bank = int(document["bank"])
    result = bytearray(prg)
    for address, value in encode_authoring(document).items():
        offset = bank * BANK_SIZE + address - CPU_BASE
        if not 0 <= offset < len(result):
            raise ValueError("World 2 metatile authoring address is outside PRG")
        result[offset] = value
    return bytes(result)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    for name in ("validate", "decode"):
        command = subparsers.add_parser(name)
        command.add_argument("--prg", required=True, type=Path)
        command.add_argument("--manifest", required=True, type=Path)
        command.add_argument("--screen-authoring", required=True, type=Path)
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
            document = load_json(args.input, "World 2 metatile authoring")
            encoded = apply_authoring(args.base_prg.read_bytes(), document)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_bytes(encoded)
            print(
                f"[OK] wrote PRG with {document['covered_byte_count']} "
                "World 2 metatile bytes"
            )
            return 0
        prg = args.prg.read_bytes()
        manifest = load_json(args.manifest, "World 2 metatile")
        screen_authoring = load_json(
            args.screen_authoring, "World 2 screen authoring"
        )
        if args.command == "decode":
            decoded = decode_authoring(prg, manifest, screen_authoring)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_text(
                json.dumps(decoded, indent=2) + "\n",
                encoding="utf-8",
                newline="\n",
            )
            print(f"[OK] wrote World 2 metatiles to {args.output}")
            return 0
        errors, report = validate_manifest_data(
            prg, manifest, screen_authoring
        )
        errors.extend(
            validate_authoring(
                prg,
                manifest,
                screen_authoring,
                args.authoring,
            )
        )
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 2 metatile audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] World 2 metatiles: {report['metatile_count']} records, "
        f"{report['referenced_metatile_count']} referenced by standard streams, "
        f"{report['unreferenced_metatile_count']} unreferenced; "
        f"{report['solid_metatile_count']} solid; "
        f"{report['covered_byte_count']} lossless authoring bytes"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
