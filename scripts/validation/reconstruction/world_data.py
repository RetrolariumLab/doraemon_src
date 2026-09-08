#!/usr/bin/env python3
"""Validate and losslessly edit World 1 and World 3 map hierarchies."""

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


def crc32(data: bytes) -> str:
    return f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"


def load_manifest(path: Path) -> dict[str, Any]:
    document = json.loads(path.read_text(encoding="utf-8"))
    if document.get("schema_version") != 1:
        raise ValueError("unsupported hierarchical world-data schema")
    return document


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("hierarchical world-data range is outside PRG")
    return prg[offset:offset + size]


def world_by_id(document: dict[str, Any], world_id: str) -> dict[str, Any]:
    matches = [world for world in document["worlds"] if world["id"] == world_id]
    if len(matches) != 1:
        raise ValueError(f"expected one manifest world named {world_id!r}")
    return matches[0]


def component_layout(world: dict[str, Any]) -> list[tuple[str, int, int]]:
    attributes = world["attributes"]
    small = world["small_blocks"]
    big = world["big_blocks"]
    result = [
        ("attributes", number(attributes["address"]), int(attributes["count"])),
        (
            "small_blocks",
            number(small["address"]),
            int(small["count"]) * int(small["width"]) * int(small["height"]),
        ),
        (
            "big_blocks",
            number(big["address"]),
            int(big["count"]) * int(big["width"]) * int(big["height"]),
        ),
    ]
    result.extend(
        (
            f"map {map_spec['id']}",
            number(map_spec["address"]),
            int(map_spec["width"]) * int(map_spec["height"]),
        )
        for map_spec in world["maps"]
    )
    return result


def validate_world(
    prg: bytes,
    world: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    errors: list[str] = []
    world_id = str(world["id"])
    bank = int(world["bank"])
    start = number(world["address"])
    end = number(world["end_address"])
    layout = component_layout(world)
    cursor = start
    for name, address, size in layout:
        if address != cursor:
            errors.append(
                f"{world_id} {name} starts at ${address:04X}, "
                f"expected contiguous address ${cursor:04X}"
            )
        cursor = address + size
    if cursor - 1 != end:
        errors.append(
            f"{world_id} final byte ${cursor - 1:04X} differs from "
            f"manifest ${end:04X}"
        )
    payload = bank_slice(prg, bank, start, end - start + 1)
    if crc32(payload) != str(world["crc32"]).lower():
        errors.append(f"{world_id} payload CRC32 differs from manifest")

    attributes = world["attributes"]
    attribute_data = bank_slice(
        prg, bank, number(attributes["address"]), int(attributes["count"])
    )
    if crc32(attribute_data) != str(attributes["crc32"]).lower():
        errors.append(f"{world_id} attribute CRC32 differs from manifest")
    palette_counts = Counter(value & 0x03 for value in attribute_data)
    expected_palette_counts = {
        int(key): int(value)
        for key, value in attributes["expected_palette_counts"].items()
    }
    if palette_counts != expected_palette_counts:
        errors.append(f"{world_id} palette-selector counts differ from manifest")
    property_value_count = len({value >> 2 for value in attribute_data})
    if property_value_count != int(attributes["expected_property_value_count"]):
        errors.append(f"{world_id} property-value count differs from manifest")

    small = world["small_blocks"]
    small_size = int(small["count"]) * int(small["width"]) * int(small["height"])
    small_data = bank_slice(prg, bank, number(small["address"]), small_size)
    if crc32(small_data) != str(small["crc32"]).lower():
        errors.append(f"{world_id} small-block CRC32 differs from manifest")
    unique_tiles = len(set(small_data))
    if unique_tiles != int(small["expected_unique_tile_count"]):
        errors.append(f"{world_id} unique CHR-tile count differs from manifest")

    big = world["big_blocks"]
    big_size = int(big["count"]) * int(big["width"]) * int(big["height"])
    big_data = bank_slice(prg, bank, number(big["address"]), big_size)
    if crc32(big_data) != str(big["crc32"]).lower():
        errors.append(f"{world_id} big-block CRC32 differs from manifest")
    referenced_small = len(set(big_data))
    if referenced_small != int(big["expected_referenced_small_block_count"]):
        errors.append(
            f"{world_id} referenced small-block count differs from manifest"
        )

    used_big: set[int] = set()
    for map_spec in world["maps"]:
        map_size = int(map_spec["width"]) * int(map_spec["height"])
        map_data = bank_slice(
            prg, bank, number(map_spec["address"]), map_size
        )
        if crc32(map_data) != str(map_spec["crc32"]).lower():
            errors.append(
                f"{world_id} {map_spec['id']} map CRC32 differs from manifest"
            )
        map_used = len(set(map_data))
        if map_used != int(map_spec["expected_used_big_block_count"]):
            errors.append(
                f"{world_id} {map_spec['id']} used-big-block count differs "
                "from manifest"
            )
        used_big.update(map_data)
    if len(used_big) != int(world["expected_used_big_block_count"]):
        errors.append(f"{world_id} used-big-block count differs from manifest")

    return errors, {
        "payload_size": len(payload),
        "attribute_count": len(attribute_data),
        "small_block_count": int(small["count"]),
        "big_block_count": int(big["count"]),
        "map_count": len(world["maps"]),
        "map_cell_count": sum(
            int(map_spec["width"]) * int(map_spec["height"])
            for map_spec in world["maps"]
        ),
        "used_big_block_count": len(used_big),
        "referenced_small_block_count": referenced_small,
        "unique_tile_count": unique_tiles,
    }


def validate(
    prg: bytes,
    document: dict[str, Any],
) -> tuple[list[str], dict[str, dict[str, int]]]:
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    worlds = document.get("worlds")
    if not isinstance(worlds, list) or not worlds:
        return ["hierarchical world list must be non-empty"], {}
    ids = [str(world.get("id", "")) for world in worlds]
    if not all(ids) or len(set(ids)) != len(ids):
        return ["hierarchical world ids must be non-empty and unique"], {}
    errors: list[str] = []
    report: dict[str, dict[str, int]] = {}
    for world in worlds:
        world_errors, world_report = validate_world(prg, world)
        errors.extend(world_errors)
        report[str(world["id"])] = world_report
    return errors, report


def byte_values(values: Any, count: int, description: str) -> bytes:
    if not isinstance(values, list) or len(values) != count:
        raise ValueError(f"{description} must contain {count} values")
    result = [number(value) for value in values]
    if any(not 0 <= value <= 0xFF for value in result):
        raise ValueError(f"{description} value is outside byte range")
    return bytes(result)


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


def encode_authoring(document: dict[str, Any]) -> bytes:
    if document.get("schema_version") != 1 or document.get("format") != (
        "doraemon-hierarchical-world"
    ):
        raise ValueError("unsupported hierarchical world authoring schema")
    components: list[tuple[str, int, bytes]] = []

    attributes = document["attributes"]
    attribute_count = int(attributes["count"])
    attribute_entries = indexed_entries(
        attributes["entries"], attribute_count, "attribute table"
    )
    attribute_data = bytearray()
    for entry in attribute_entries:
        palette = number(entry["palette"])
        properties = number(entry["properties"])
        if not 0 <= palette <= 3:
            raise ValueError("attribute palette selector is outside 0-3")
        if not 0 <= properties <= 0x3F:
            raise ValueError("attribute properties are outside six-bit range")
        attribute_data.append((properties << 2) | palette)
    components.append(
        ("attributes", number(attributes["address"]), bytes(attribute_data))
    )

    for key, value_key, description in (
        ("small_blocks", "tiles", "small-block table"),
        ("big_blocks", "small_blocks", "big-block table"),
    ):
        table = document[key]
        count = int(table["count"])
        cells = int(table["width"]) * int(table["height"])
        entries = indexed_entries(table["entries"], count, description)
        data = b"".join(
            byte_values(entry[value_key], cells, f"{description} entry")
            for entry in entries
        )
        components.append((key, number(table["address"]), data))

    maps = document["maps"]
    if not isinstance(maps, list) or not maps:
        raise ValueError("authoring map list must be non-empty")
    map_ids: set[str] = set()
    for map_spec in maps:
        map_id = str(map_spec["id"])
        if not map_id or map_id in map_ids:
            raise ValueError("authoring map ids must be non-empty and unique")
        map_ids.add(map_id)
        width = int(map_spec["width"])
        height = int(map_spec["height"])
        rows = map_spec["rows"]
        if not isinstance(rows, list) or len(rows) != height:
            raise ValueError(f"map {map_id} must contain {height} rows")
        data = bytearray()
        for row_index, row in enumerate(rows):
            if not isinstance(row, str):
                raise ValueError(f"map {map_id} row {row_index} is not text")
            cells = row.split()
            if len(cells) != width:
                raise ValueError(
                    f"map {map_id} row {row_index} must contain {width} cells"
                )
            try:
                values = [int(cell, 16) for cell in cells]
            except ValueError as exc:
                raise ValueError(
                    f"map {map_id} row {row_index} contains invalid hex"
                ) from exc
            if any(not 0 <= value <= 0xFF for value in values):
                raise ValueError(f"map {map_id} row {row_index} has non-byte cell")
            data.extend(values)
        components.append((f"map {map_id}", number(map_spec["address"]), bytes(data)))

    cursor = number(document["address"])
    payload = bytearray()
    for name, address, data in components:
        if address != cursor:
            raise ValueError(
                f"{name} starts at ${address:04X}, expected ${cursor:04X}"
            )
        payload.extend(data)
        cursor += len(data)
    if cursor - 1 != number(document["end_address"]):
        raise ValueError("authoring end address differs from encoded payload")
    return bytes(payload)


def decode_authoring(
    prg: bytes,
    document: dict[str, Any],
    world_id: str,
) -> dict[str, Any]:
    world = world_by_id(document, world_id)
    errors, _report = validate_world(prg, world)
    if errors:
        raise ValueError("; ".join(errors))
    bank = int(world["bank"])

    attributes = world["attributes"]
    attribute_data = bank_slice(
        prg, bank, number(attributes["address"]), int(attributes["count"])
    )
    attribute_output = {
        "address": attributes["address"],
        "count": int(attributes["count"]),
        "entries": [
            {
                "id": index,
                "palette": value & 0x03,
                "properties": f"0x{value >> 2:02X}",
            }
            for index, value in enumerate(attribute_data)
        ],
    }

    table_outputs: dict[str, dict[str, Any]] = {}
    for key, value_key in (
        ("small_blocks", "tiles"),
        ("big_blocks", "small_blocks"),
    ):
        table = world[key]
        cells = int(table["width"]) * int(table["height"])
        count = int(table["count"])
        data = bank_slice(
            prg, bank, number(table["address"]), count * cells
        )
        table_outputs[key] = {
            "address": table["address"],
            "count": count,
            "width": int(table["width"]),
            "height": int(table["height"]),
            "entries": [
                {
                    "id": index,
                    value_key: [
                        f"0x{value:02X}"
                        for value in data[index * cells:(index + 1) * cells]
                    ],
                }
                for index in range(count)
            ],
        }

    map_outputs: list[dict[str, Any]] = []
    for map_spec in world["maps"]:
        width = int(map_spec["width"])
        height = int(map_spec["height"])
        data = bank_slice(
            prg, bank, number(map_spec["address"]), width * height
        )
        map_outputs.append({
            "id": map_spec["id"],
            "address": map_spec["address"],
            "width": width,
            "height": height,
            "rows": [
                " ".join(f"{value:02X}" for value in data[row * width:(row + 1) * width])
                for row in range(height)
            ],
        })

    result = {
        "schema_version": 1,
        "format": "doraemon-hierarchical-world",
        "id": world_id,
        "bank": bank,
        "address": world["address"],
        "end_address": world["end_address"],
        "payload_crc32": world["crc32"],
        "attributes": attribute_output,
        "small_blocks": table_outputs["small_blocks"],
        "big_blocks": table_outputs["big_blocks"],
        "maps": map_outputs,
    }
    expected = bank_slice(
        prg,
        bank,
        number(world["address"]),
        number(world["end_address"]) - number(world["address"]) + 1,
    )
    if encode_authoring(result) != expected:
        raise ValueError(f"{world_id} authoring roundtrip differs after decode")
    return result


def validate_authoring(
    prg: bytes,
    manifest: dict[str, Any],
    path: Path,
) -> list[str]:
    document = json.loads(path.read_text(encoding="utf-8"))
    encoded = encode_authoring(document)
    world_id = str(document["id"])
    world = world_by_id(manifest, world_id)
    errors: list[str] = []
    if int(document["bank"]) != int(world["bank"]):
        errors.append(f"{world_id} authoring bank differs from manifest")
    if number(document["address"]) != number(world["address"]):
        errors.append(f"{world_id} authoring start address differs from manifest")
    if number(document["end_address"]) != number(world["end_address"]):
        errors.append(f"{world_id} authoring end address differs from manifest")
    if crc32(encoded) != str(document["payload_crc32"]).lower():
        errors.append(f"{world_id} authoring payload CRC32 differs")
    canonical = bank_slice(
        prg,
        int(world["bank"]),
        number(world["address"]),
        number(world["end_address"]) - number(world["address"]) + 1,
    )
    if encoded != canonical:
        errors.append(f"{world_id} authoring roundtrip differs from PRG")
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    validate_parser = subparsers.add_parser("validate")
    validate_parser.add_argument("--prg", required=True, type=Path)
    validate_parser.add_argument("--manifest", required=True, type=Path)
    validate_parser.add_argument("--authoring", action="append", type=Path, default=[])
    decode_parser = subparsers.add_parser("decode")
    decode_parser.add_argument("--prg", required=True, type=Path)
    decode_parser.add_argument("--manifest", required=True, type=Path)
    decode_parser.add_argument("--world", required=True)
    decode_parser.add_argument("--output", required=True, type=Path)
    encode_parser = subparsers.add_parser("encode")
    encode_parser.add_argument("--input", required=True, type=Path)
    encode_parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    try:
        if args.command == "encode":
            encoded = encode_authoring(
                json.loads(args.input.read_text(encoding="utf-8"))
            )
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_bytes(encoded)
            print(f"[OK] wrote {len(encoded)} hierarchical world-data bytes")
            return 0
        prg = args.prg.read_bytes()
        manifest = load_manifest(args.manifest)
        if args.command == "decode":
            decoded = decode_authoring(prg, manifest, args.world)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_text(
                json.dumps(decoded, indent=2) + "\n",
                encoding="utf-8",
                newline="\n",
            )
            print(f"[OK] wrote {args.world} authoring data to {args.output}")
            return 0
        errors, report = validate(prg, manifest)
        for authoring_path in args.authoring:
            errors.extend(validate_authoring(prg, manifest, authoring_path))
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] hierarchical world-data audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    summary = "; ".join(
        f"{world_id}: {metrics['payload_size']} bytes, "
        f"{metrics['map_cell_count']} map cells, "
        f"{metrics['used_big_block_count']} used big blocks"
        for world_id, metrics in report.items()
    )
    print(f"[OK] hierarchical world data validated: {summary}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
