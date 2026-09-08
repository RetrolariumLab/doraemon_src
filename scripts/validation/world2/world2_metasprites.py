#!/usr/bin/env python3
"""Validate, edit, and render the fixed World 2 metasprite catalog."""

from __future__ import annotations

import argparse
from collections import Counter
import json
from pathlib import Path
from typing import Any
import zlib

from scripts.validation.world3.world3_metasprites import NES_RGB


BANK_SIZE = 0x8000
CPU_BASE = 0x8000
CHR_BANK_SIZE = 0x2000


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
        raise ValueError("World 2 metasprite range is outside PRG")
    return prg[offset:offset + size]


def load_json(path: Path, description: str) -> dict[str, Any]:
    document = json.loads(path.read_text(encoding="utf-8"))
    if document.get("schema_version") != 1:
        raise ValueError(f"unsupported {description} schema")
    return document


def indexed_records(
    records: Any, count: int, key: str, description: str
) -> list[dict[str, Any]]:
    if not isinstance(records, list) or len(records) != count:
        raise ValueError(f"{description} must contain {count} records")
    if [int(record.get(key, -1)) for record in records] != list(range(count)):
        raise ValueError(f"{description} {key}s are not contiguous")
    return records


def raw_data(prg: bytes, manifest: dict[str, Any]) -> dict[str, bytes]:
    bank = int(manifest["bank"])
    metasprites = manifest["metasprites"]
    count = int(metasprites["count"])
    attributes = manifest["oam_attribute_lookup"]
    return {
        "tile_quads": bank_slice(
            prg, bank, number(metasprites["tile_quad_address"]), count * 4
        ),
        "descriptors": bank_slice(
            prg, bank, number(metasprites["descriptor_address"]), count
        ),
        "oam_attributes": bank_slice(
            prg,
            bank,
            number(attributes["address"]),
            int(attributes["count"]),
        ),
    }


def parse_records(
    tiles: bytes, descriptors: bytes
) -> list[dict[str, Any]]:
    return [
        {
            "id": record_id,
            "tiles": list(tiles[record_id * 4:record_id * 4 + 4]),
            "palette": descriptors[record_id] & 0x03,
            "attribute_base": descriptors[record_id] & 0x3C,
        }
        for record_id in range(len(descriptors))
    ]


def named(entries: list[dict[str, Any]], name: str) -> dict[str, Any]:
    matches = [entry for entry in entries if entry.get("name") == name]
    if len(matches) != 1:
        raise ValueError(f"expected one table named {name!r}")
    return matches[0]


def validate_manifest_data(
    prg: bytes,
    chr_data: bytes,
    manifest: dict[str, Any],
    enemy_states: dict[str, Any],
    enemy_handlers: dict[str, Any],
    dispatch: dict[str, Any],
    palettes: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    if len(chr_data) != 4 * CHR_BANK_SIZE:
        return [f"CHR size differs: {len(chr_data)}"], {}
    errors: list[str] = []
    try:
        data = raw_data(prg, manifest)
        spec = manifest["metasprites"]
        records = parse_records(data["tile_quads"], data["descriptors"])
        attribute_spec = manifest["oam_attribute_lookup"]
        count = int(spec["count"])
    except (KeyError, TypeError, ValueError) as exc:
        return [str(exc)], {}

    if int(manifest["bank"]) != 1 or int(manifest["chr_bank"]) != 1:
        errors.append("World 2 metasprites must use PRG and CHR bank 1")
    chr_bank = int(manifest["chr_bank"])
    chr_bytes = chr_data[chr_bank * CHR_BANK_SIZE:(chr_bank + 1) * CHR_BANK_SIZE]
    if crc32(chr_bytes) != str(manifest["chr_bank_crc32"]).lower():
        errors.append("World 2 metasprite CHR bank CRC32 differs")
    if number(manifest["sprite_pattern_table"]) != 0:
        errors.append("World 2 sprites must use pattern table zero")
    if spec["tile_order"] != [
        "top_left", "top_right", "bottom_left", "bottom_right"
    ]:
        errors.append("World 2 metasprite tile order differs")
    if spec["descriptor_fields"] != [
        "palette_low_2_bits", "oam_attribute_base_bits_2_to_5"
    ]:
        errors.append("World 2 metasprite descriptor fields differ")

    checksums = {
        "tile_quads": spec["tile_quad_crc32"],
        "descriptors": spec["descriptor_crc32"],
        "oam_attributes": attribute_spec["crc32"],
    }
    for name, expected in checksums.items():
        if crc32(data[name]) != str(expected).lower():
            errors.append(f"World 2 metasprite {name} CRC32 differs")

    attribute_count = int(attribute_spec["count"])
    allowed_mask = number(attribute_spec["allowed_mask"])
    if any(value & ~allowed_mask for value in data["oam_attributes"]):
        errors.append("World 2 OAM attribute lookup contains unsupported bits")
    descriptors = data["descriptors"]
    if any(value & 0xC0 for value in descriptors):
        errors.append("World 2 metasprite descriptor uses reserved bits")
    bases = [int(record["attribute_base"]) for record in records]
    if any(base % 4 or base + 3 >= attribute_count for base in bases):
        errors.append("World 2 metasprite attribute base leaves the lookup")

    metrics = manifest["expected_metrics"]
    palette_histogram = [
        sum(int(record["palette"]) == palette for record in records)
        for palette in range(4)
    ]
    base_histogram = Counter(bases)
    expected_bases = {
        number(key): int(value)
        for key, value in metrics["attribute_base_histogram"].items()
    }
    comparisons = [
        (len(records), count, "record count"),
        (len(set(data["tile_quads"])), int(metrics["unique_tile_count"]), "unique tile count"),
        (data["tile_quads"].count(0), int(metrics["zero_tile_piece_count"]), "zero tile count"),
    ]
    for actual, expected, description in comparisons:
        if actual != expected:
            errors.append(f"World 2 metasprite {description} differs")
    if palette_histogram != [int(value) for value in metrics["palette_histogram"]]:
        errors.append("World 2 metasprite palette histogram differs")
    if dict(base_histogram) != expected_bases:
        errors.append("World 2 metasprite attribute-base histogram differs")

    state_indexes = manifest["enemy_state_render_indexes"]
    if (
        not isinstance(state_indexes, list)
        or [int(entry.get("state", -1)) for entry in state_indexes]
        != list(range(1, 21))
    ):
        errors.append("World 2 enemy render map states are not contiguous")
        state_indexes = []
    handler_states = enemy_handlers.get("states", [])
    if [int(entry.get("state", -1)) for entry in handler_states] != list(range(1, 21)):
        errors.append("World 2 enemy handler domain differs")
    referenced: set[int] = set()
    for entry in state_indexes:
        indexes = [int(value) for value in entry["indexes"]]
        if len(indexes) != len(set(indexes)) or any(
            not 0 <= index < count for index in indexes
        ):
            errors.append("World 2 enemy render index leaves the catalog")
        referenced.update(indexes)
        state = int(entry["state"])
        if not indexes and "no-op" not in str(handler_states[state - 1]["render_role"]):
            errors.append("World 2 visible enemy state lacks render indexes")
    unreferenced = sorted(set(range(count)) - referenced)
    if len(referenced) != int(metrics["enemy_referenced_index_count"]):
        errors.append("World 2 enemy-referenced metasprite count differs")
    if unreferenced != [int(value) for value in metrics["enemy_unreferenced_indexes"]]:
        errors.append("World 2 enemy-unreferenced metasprite indexes differ")

    shared = manifest["shared_storage"]
    attack = named(enemy_states.get("property_tables", []), "attack_period_by_state")
    last_descriptor = shared["descriptor_last_byte"]
    descriptor_end = number(spec["descriptor_address"]) + count - 1
    if (
        descriptor_end != number(last_descriptor["address"])
        or descriptor_end != number(attack["address"])
        or int(last_descriptor["enemy_property_index"]) != 0
    ):
        errors.append("World 2 descriptor/property overlap differs")
    render = named(dispatch.get("tables", []), "world2_enemy_render_handlers")
    attribute_overlap = shared["attribute_last_two_bytes"]
    attribute_end = number(attribute_spec["address"]) + attribute_count
    if (
        attribute_end - 2 != number(attribute_overlap["address"])
        or attribute_end != number(render["address"])
        or data["oam_attributes"][-2:] != b"\x40\x40"
    ):
        errors.append("World 2 attribute/render-prefix overlap differs")

    palette_records = [int(value) for value in manifest["sprite_palette_records"]]
    if palette_records != [
        int(value) for value in palettes["initial_sprite_offsets"]["palette_records"]
    ]:
        errors.append("World 2 metasprite palette records differ")
    for signature in manifest["signatures"]:
        raw = bytes.fromhex(str(signature["bytes"]))
        if bank_slice(
            prg, int(manifest["bank"]), number(signature["address"]), len(raw)
        ) != raw:
            errors.append(
                f"World 2 metasprite signature differs at "
                f"${number(signature['address']):04X}"
            )

    combined = b"".join(data.values())
    if len(combined) != int(manifest["covered_byte_count"]):
        errors.append("World 2 metasprite covered-byte count differs")
    if crc32(combined) != str(manifest["covered_crc32"]).lower():
        errors.append("World 2 metasprite covered CRC32 differs")
    return errors, {
        "record_count": len(records),
        "unique_tile_count": len(set(data["tile_quads"])),
        "attribute_count": attribute_count,
        "enemy_referenced_count": len(referenced),
        "covered_byte_count": len(combined),
    }


def decode_authoring(prg: bytes, manifest: dict[str, Any]) -> dict[str, Any]:
    data = raw_data(prg, manifest)
    spec = manifest["metasprites"]
    records = parse_records(data["tile_quads"], data["descriptors"])
    result: dict[str, Any] = {
        "schema_version": 1,
        "format": "doraemon-world2-metasprites",
        "bank": int(manifest["bank"]),
        "layout": {
            "tile_quad_address": spec["tile_quad_address"],
            "descriptor_address": spec["descriptor_address"],
            "oam_attribute_address": manifest["oam_attribute_lookup"]["address"],
        },
        "metasprite_count": len(records),
        "metasprites": [
            {
                "id": int(record["id"]),
                "tiles": [f"0x{tile:02X}" for tile in record["tiles"]],
                "palette": int(record["palette"]),
                "attribute_base": f"0x{int(record['attribute_base']):02X}",
            }
            for record in records
        ],
        "oam_attributes": [
            {"id": index, "value": f"0x{value:02X}"}
            for index, value in enumerate(data["oam_attributes"])
        ],
        "covered_byte_count": int(manifest["covered_byte_count"]),
        "covered_crc32": "00000000",
    }
    encoded = encode_authoring(result)
    result["covered_crc32"] = crc32(
        bytes(encoded[address] for address in sorted(encoded))
    )
    return result


def encode_authoring(document: dict[str, Any]) -> dict[int, int]:
    if document.get("schema_version") != 1 or document.get("format") != (
        "doraemon-world2-metasprites"
    ):
        raise ValueError("unsupported World 2 metasprite authoring schema")
    layout = document["layout"]
    count = int(document["metasprite_count"])
    records = indexed_records(document["metasprites"], count, "id", "metasprite")
    attributes = indexed_records(
        document["oam_attributes"], 36, "id", "OAM attribute"
    )
    tile_address = number(layout["tile_quad_address"])
    descriptor_address = number(layout["descriptor_address"])
    attribute_address = number(layout["oam_attribute_address"])
    encoded: dict[int, int] = {}
    for record in records:
        record_id = int(record["id"])
        tiles = record.get("tiles")
        if not isinstance(tiles, list) or len(tiles) != 4:
            raise ValueError("World 2 metasprite must contain four tiles")
        for offset, tile in enumerate(tiles):
            encoded[tile_address + record_id * 4 + offset] = byte_value(
                tile, "metasprite tile"
            )
        palette = byte_value(record["palette"], "metasprite palette")
        base = byte_value(record["attribute_base"], "attribute base")
        if palette >= 4 or base % 4 or base + 3 >= len(attributes):
            raise ValueError("World 2 metasprite descriptor is outside its domain")
        encoded[descriptor_address + record_id] = palette | base
    for entry in attributes:
        value = byte_value(entry["value"], "OAM attribute")
        if value & ~0xE0:
            raise ValueError("World 2 OAM attribute uses unsupported bits")
        encoded[attribute_address + int(entry["id"])] = value
    return encoded


def validate_authoring(
    prg: bytes, manifest: dict[str, Any], path: Path
) -> list[str]:
    document = json.loads(path.read_text(encoding="utf-8"))
    encoded = encode_authoring(document)
    canonical = encode_authoring(decode_authoring(prg, manifest))
    payload = bytes(encoded[address] for address in sorted(encoded))
    errors: list[str] = []
    if int(document["bank"]) != int(manifest["bank"]):
        errors.append("World 2 metasprite authoring targets the wrong bank")
    if len(encoded) != int(document["covered_byte_count"]):
        errors.append("World 2 metasprite authoring byte count differs")
    if crc32(payload) != str(document["covered_crc32"]).lower():
        errors.append("World 2 metasprite authoring CRC32 differs")
    if encoded != canonical:
        errors.append("World 2 metasprite authoring roundtrip differs from PRG")
    return errors


def apply_authoring(prg: bytes, document: dict[str, Any]) -> bytes:
    if len(prg) != 4 * BANK_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    result = bytearray(prg)
    bank = int(document["bank"])
    for address, value in encode_authoring(document).items():
        offset = bank * BANK_SIZE + address - CPU_BASE
        if not 0 <= offset < len(result):
            raise ValueError("World 2 metasprite authoring address is outside PRG")
        result[offset] = value
    return bytes(result)


def chr_tile_pixels(chr_data: bytes, bank: int, tile: int) -> list[list[int]]:
    start = bank * CHR_BANK_SIZE + tile * 16
    if not 0 <= start <= len(chr_data) - 16:
        raise ValueError("World 2 metasprite tile is outside CHR")
    low = chr_data[start:start + 8]
    high = chr_data[start + 8:start + 16]
    return [
        [
            ((low[y] >> (7 - x)) & 1) | (((high[y] >> (7 - x)) & 1) << 1)
            for x in range(8)
        ]
        for y in range(8)
    ]


def render_catalog(
    prg: bytes,
    chr_data: bytes,
    manifest: dict[str, Any],
    palettes: dict[str, Any],
    output: Path,
    palette_record: int,
) -> None:
    try:
        from PIL import Image, ImageDraw
    except ImportError as exc:
        raise ValueError("Pillow is required for the metasprite renderer") from exc
    if palette_record not in [int(value) for value in manifest["sprite_palette_records"]]:
        raise ValueError("render palette is not a World 2 sprite palette record")
    data = raw_data(prg, manifest)
    records = parse_records(data["tile_quads"], data["descriptors"])
    palette = [
        number(value)
        for value in palettes["palettes"][palette_record]["colors"]
    ]
    columns = 8
    rows = (len(records) + columns - 1) // columns
    cell_width, cell_height = 88, 76
    sheet = Image.new("RGB", (columns * cell_width, rows * cell_height), (24, 24, 30))
    draw = ImageDraw.Draw(sheet)
    attributes = data["oam_attributes"]
    for record in records:
        record_id = int(record["id"])
        cell_x = (record_id % columns) * cell_width
        cell_y = (record_id // columns) * cell_height
        draw.rectangle(
            (cell_x, cell_y, cell_x + cell_width - 1, cell_y + cell_height - 1),
            outline=(64, 64, 72),
        )
        draw.text(
            (cell_x + 5, cell_y + 4),
            f"${record_id:02X} p{record['palette']}",
            fill=(235, 235, 235),
        )
        colors = [
            NES_RGB[palette[int(record["palette"]) * 4 + color] & 0x3F]
            for color in range(4)
        ]
        for piece, tile in enumerate(record["tiles"]):
            if tile == 0:
                continue
            flags = attributes[int(record["attribute_base"]) + piece]
            pixels = chr_tile_pixels(chr_data, int(manifest["chr_bank"]), int(tile))
            base_x = cell_x + 20 + (piece & 1) * 24
            base_y = cell_y + 25 + (piece >> 1) * 24
            for y in range(8):
                for x in range(8):
                    source_x = 7 - x if flags & 0x40 else x
                    source_y = 7 - y if flags & 0x80 else y
                    color = pixels[source_y][source_x]
                    if color:
                        px = base_x + x * 3
                        py = base_y + y * 3
                        draw.rectangle((px, py, px + 2, py + 2), fill=colors[color])
    output.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(output)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    for name in ("validate", "decode", "render"):
        command = subparsers.add_parser(name)
        command.add_argument("--prg", required=True, type=Path)
        command.add_argument("--manifest", required=True, type=Path)
        if name == "validate":
            command.add_argument("--chr", required=True, type=Path)
            command.add_argument("--enemy-states", required=True, type=Path)
            command.add_argument("--enemy-handlers", required=True, type=Path)
            command.add_argument("--object-dispatch", required=True, type=Path)
            command.add_argument("--palette-manifest", required=True, type=Path)
            command.add_argument("--authoring", required=True, type=Path)
        elif name == "decode":
            command.add_argument("--output", required=True, type=Path)
        else:
            command.add_argument("--chr", required=True, type=Path)
            command.add_argument("--palette-authoring", required=True, type=Path)
            command.add_argument("--output", required=True, type=Path)
            command.add_argument("--palette-record", type=int, default=7)
    encode_parser = subparsers.add_parser("encode")
    encode_parser.add_argument("--input", required=True, type=Path)
    encode_parser.add_argument("--base-prg", required=True, type=Path)
    encode_parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    try:
        if args.command == "encode":
            document = load_json(args.input, "World 2 metasprite authoring")
            output = apply_authoring(args.base_prg.read_bytes(), document)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_bytes(output)
            print(
                f"[OK] wrote PRG with {len(encode_authoring(document))} "
                "World 2 metasprite bytes"
            )
            return 0
        prg = args.prg.read_bytes()
        manifest = load_json(args.manifest, "World 2 metasprite")
        if args.command == "decode":
            document = decode_authoring(prg, manifest)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_text(
                json.dumps(document, indent=2) + "\n",
                encoding="utf-8",
                newline="\n",
            )
            print(f"[OK] wrote World 2 metasprites to {args.output}")
            return 0
        if args.command == "render":
            palettes = load_json(
                args.palette_authoring, "World 2 palette authoring"
            )
            render_catalog(
                prg,
                args.chr.read_bytes(),
                manifest,
                palettes,
                args.output,
                args.palette_record,
            )
            print(f"[OK] wrote World 2 metasprite contact sheet to {args.output}")
            return 0
        errors, report = validate_manifest_data(
            prg,
            args.chr.read_bytes(),
            manifest,
            load_json(args.enemy_states, "World 2 enemy state"),
            load_json(args.enemy_handlers, "World 2 enemy handler"),
            load_json(args.object_dispatch, "object dispatch"),
            load_json(args.palette_manifest, "World 2 palette"),
        )
        errors.extend(validate_authoring(prg, manifest, args.authoring))
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 2 metasprite audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] World 2 metasprites: {report['record_count']} fixed 2x2 records, "
        f"{report['unique_tile_count']} unique tiles, "
        f"{report['attribute_count']} OAM attributes, "
        f"{report['enemy_referenced_count']} enemy-referenced indexes; "
        f"{report['covered_byte_count']} lossless authoring bytes"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
