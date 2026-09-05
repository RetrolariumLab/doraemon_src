#!/usr/bin/env python3
"""Validate and losslessly edit World 3 metasprites and palette sets."""

from __future__ import annotations

import argparse
from collections import Counter
import json
from pathlib import Path
from typing import Any
import zlib


BANK_SIZE = 0x8000
CPU_BASE = 0x8000
FLIP_MODES = {
    0: "none",
    1: "horizontal",
    2: "vertical",
    3: "horizontal_vertical",
}
FLIP_VALUES = {name: value for value, name in FLIP_MODES.items()}

# FCEUX-compatible NTSC palette used only by the optional research renderer.
NES_RGB = (
    (116, 116, 116), (36, 24, 140), (0, 0, 168), (68, 0, 156),
    (140, 0, 116), (168, 0, 16), (164, 0, 0), (124, 8, 0),
    (64, 44, 0), (0, 68, 0), (0, 80, 0), (0, 60, 20),
    (24, 60, 92), (0, 0, 0), (0, 0, 0), (0, 0, 0),
    (188, 188, 188), (0, 112, 236), (32, 56, 236), (128, 0, 240),
    (188, 0, 188), (228, 0, 88), (216, 40, 0), (200, 76, 12),
    (136, 112, 0), (0, 148, 0), (0, 168, 0), (0, 144, 56),
    (0, 128, 136), (0, 0, 0), (0, 0, 0), (0, 0, 0),
    (252, 252, 252), (60, 188, 252), (92, 148, 252), (204, 136, 252),
    (244, 120, 252), (252, 116, 180), (252, 116, 96), (252, 152, 56),
    (240, 188, 60), (128, 208, 16), (76, 220, 72), (88, 248, 152),
    (0, 232, 216), (120, 120, 120), (0, 0, 0), (0, 0, 0),
    (252, 252, 252), (168, 228, 252), (184, 184, 248), (216, 184, 248),
    (248, 184, 248), (248, 164, 192), (240, 208, 176), (252, 224, 168),
    (248, 216, 120), (216, 248, 120), (184, 248, 184), (184, 248, 216),
    (0, 252, 252), (248, 216, 248), (0, 0, 0), (0, 0, 0),
)


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
        raise ValueError("World 3 metasprite range is outside PRG")
    return prg[offset:offset + size]


def load_json(path: Path, description: str) -> dict[str, Any]:
    document = json.loads(path.read_text(encoding="utf-8"))
    if document.get("schema_version") != 1:
        raise ValueError(f"unsupported {description} schema")
    return document


def indexed_records(
    records: Any,
    count: int,
    key: str,
    description: str,
) -> list[dict[str, Any]]:
    if not isinstance(records, list) or len(records) != count:
        raise ValueError(f"{description} must contain {count} records")
    if [int(record.get(key, -1)) for record in records] != list(range(count)):
        raise ValueError(f"{description} {key}s are not contiguous")
    return records


def raw_layout(manifest: dict[str, Any]) -> dict[str, tuple[int, int]]:
    index = manifest["index_table"]
    metasprites = manifest["metasprites"]
    palettes = manifest["palettes"]
    selectors = manifest["room_palette_selectors"]
    index_address = number(index["address"])
    index_size = int(index["count"]) * 2
    metasprite_address = number(metasprites["address"])
    metasprite_end = number(metasprites["end_address"])
    palette_address = number(palettes["address"])
    palette_size = int(palettes["count"]) * int(palettes["bytes_per_palette"])
    selector_address = number(selectors["address"])
    selector_size = int(selectors["count"])
    if index_address + index_size != metasprite_address:
        raise ValueError("World 3 metasprite index does not end at record data")
    if metasprite_end != palette_address:
        raise ValueError("World 3 metasprite records do not end at palettes")
    if palette_address + palette_size != number(manifest["next_region_address"]):
        raise ValueError("World 3 palettes do not end at the next region")
    return {
        "room_palette_selectors": (selector_address, selector_size),
        "index_table": (index_address, index_size),
        "metasprites": (metasprite_address, metasprite_end - metasprite_address),
        "palettes": (palette_address, palette_size),
    }


def parse_index_table(data: bytes) -> list[dict[str, int | str]]:
    if len(data) % 2:
        raise ValueError("World 3 metasprite index has odd byte length")
    entries: list[dict[str, int | str]] = []
    for index in range(len(data) // 2):
        low = data[index * 2]
        high = data[index * 2 + 1]
        if high < 4:
            entries.append({
                "id": index,
                "kind": "alias",
                "source_index": low,
                "flip": FLIP_MODES[high],
            })
        else:
            entries.append({
                "id": index,
                "kind": "direct",
                "metasprite_address": low | (high << 8),
            })
    return entries


def parse_metasprites(data: bytes, address: int) -> list[dict[str, Any]]:
    records: list[dict[str, Any]] = []
    offset = 0
    while offset < len(data):
        if len(data) - offset < 3:
            raise ValueError("World 3 metasprite header is truncated")
        sprite_count = data[offset]
        size = 3 + sprite_count * 3
        if sprite_count == 0 or offset + size > len(data):
            raise ValueError("World 3 metasprite record is truncated")
        pieces = []
        for piece_id in range(sprite_count):
            piece_offset = offset + 3 + piece_id * 3
            pieces.append({
                "id": piece_id,
                "y_offset": data[piece_offset],
                "x_offset": data[piece_offset + 1],
                "tile": data[piece_offset + 2],
            })
        records.append({
            "id": len(records),
            "address": address + offset,
            "sprite_count": sprite_count,
            "x_mirror_extent": data[offset + 1],
            "y_mirror_extent": data[offset + 2],
            "pieces": pieces,
        })
        offset += size
    return records


def manifest_data(
    prg: bytes,
    manifest: dict[str, Any],
) -> tuple[dict[str, bytes], list[dict[str, Any]], list[dict[str, Any]]]:
    bank = int(manifest["bank"])
    ranges = raw_layout(manifest)
    data = {
        name: bank_slice(prg, bank, address, size)
        for name, (address, size) in ranges.items()
    }
    entries = parse_index_table(data["index_table"])
    metasprites = parse_metasprites(
        data["metasprites"], ranges["metasprites"][0]
    )
    return data, entries, metasprites


def validate_manifest_data(
    prg: bytes,
    manifest: dict[str, Any],
    entity_types: dict[str, Any],
) -> tuple[list[str], dict[str, Any]]:
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    errors: list[str] = []
    try:
        data, entries, metasprites = manifest_data(prg, manifest)
        ranges = raw_layout(manifest)
    except (KeyError, TypeError, ValueError) as exc:
        return [str(exc)], {}

    if int(manifest["index_table"]["entry_size"]) != 2:
        errors.append("World 3 metasprite index entry width differs")
    if int(manifest["index_table"]["direct_pointer_high_minimum"]) != 4:
        errors.append("World 3 metasprite direct-pointer discriminator differs")
    if manifest["metasprites"]["header_fields"] != [
        "sprite_count",
        "x_mirror_extent",
        "y_mirror_extent",
    ]:
        errors.append("World 3 metasprite header field order differs")
    if manifest["metasprites"]["piece_fields"] != [
        "y_offset",
        "x_offset",
        "tile",
    ]:
        errors.append("World 3 metasprite piece field order differs")

    specs = {
        "room_palette_selectors": manifest["room_palette_selectors"],
        "index_table": manifest["index_table"],
        "metasprites": manifest["metasprites"],
        "palettes": manifest["palettes"],
    }
    for name, spec in specs.items():
        if crc32(data[name]) != str(spec["crc32"]).lower():
            errors.append(f"World 3 {name} CRC32 differs")

    addresses = {int(record["address"]) for record in metasprites}
    direct = [entry for entry in entries if entry["kind"] == "direct"]
    aliases = [entry for entry in entries if entry["kind"] == "alias"]
    invalid_targets = sorted({
        int(entry["metasprite_address"])
        for entry in direct
        if int(entry["metasprite_address"]) not in addresses
    })
    if invalid_targets:
        errors.append(
            "World 3 metasprite pointers miss record starts: "
            + ", ".join(f"${address:04X}" for address in invalid_targets)
        )
    invalid_aliases = [
        int(entry["id"])
        for entry in aliases
        if int(entry["source_index"]) >= len(entries)
    ]
    if invalid_aliases:
        errors.append("World 3 metasprite aliases leave the index domain")
    nested_aliases = [
        int(entry["id"])
        for entry in aliases
        if int(entry["source_index"]) < len(entries)
        and entries[int(entry["source_index"])]["kind"] != "direct"
    ]

    metrics = manifest["expected_metrics"]
    expected_count_histogram = {
        int(key): int(value)
        for key, value in metrics["sprite_count_histogram"].items()
    }
    actual_count_histogram = dict(Counter(
        int(record["sprite_count"]) for record in metasprites
    ))
    direct_targets = {int(entry["metasprite_address"]) for entry in direct}
    unreferenced = sorted(addresses - direct_targets)
    tiles = {
        int(piece["tile"])
        for record in metasprites
        for piece in record["pieces"]
    }
    comparisons = [
        (len(entries), int(manifest["index_table"]["count"]), "index count"),
        (len(direct), int(metrics["direct_index_entries"]), "direct count"),
        (len(aliases), int(metrics["alias_index_entries"]), "alias count"),
        (len(direct_targets), int(metrics["unique_direct_targets"]), "unique target count"),
        (len(metasprites), int(manifest["metasprites"]["count"]), "record count"),
        (len(tiles), int(metrics["unique_tile_count"]), "unique tile count"),
    ]
    for actual, expected, description in comparisons:
        if actual != expected:
            errors.append(f"World 3 metasprite {description} differs")
    if nested_aliases != [number(value) for value in metrics["nested_alias_ids"]]:
        errors.append("World 3 nested metasprite aliases differ")
    if unreferenced != [number(value) for value in metrics["unreferenced_records"]]:
        errors.append("World 3 unreferenced metasprite records differ")
    if actual_count_histogram != expected_count_histogram:
        errors.append("World 3 metasprite sprite-count histogram differs")

    palette_spec = manifest["palettes"]
    palette_count = int(palette_spec["count"])
    palette_width = int(palette_spec["bytes_per_palette"])
    if palette_width != 32:
        errors.append("World 3 palette width differs")
    if any(color >= 0x40 for color in data["palettes"]):
        errors.append("World 3 palette color is outside the NES palette")
    selectors = data["room_palette_selectors"]
    if any(selector >= palette_count for selector in selectors):
        errors.append("World 3 room palette selector is outside the palette catalog")
    histogram = [selectors.count(index) for index in range(palette_count)]
    if histogram != [int(value) for value in metrics["room_palette_histogram"]]:
        errors.append("World 3 room palette histogram differs")

    type_properties = {
        str(table["name"]): table
        for table in entity_types.get("property_tables", [])
    }
    bases = type_properties.get("metasprite_base", {}).get("values", [])
    if len(bases) != int(entity_types.get("type_count", -1)):
        errors.append("World 3 entity metasprite-base catalog is incomplete")
    else:
        invalid_bases = []
        for value in bases:
            index = number(value)
            if index >= len(entries) or entries[index]["kind"] != "direct":
                invalid_bases.append(index)
        if invalid_bases:
            errors.append("World 3 entity base indexes do not resolve directly")

    for signature in manifest["signatures"]:
        raw = bytes.fromhex(str(signature["bytes"]))
        actual = bank_slice(
            prg,
            int(manifest["bank"]),
            number(signature["address"]),
            len(raw),
        )
        if actual != raw:
            errors.append(
                "World 3 metasprite signature differs at "
                f"${number(signature['address']):04X}"
            )

    combined = b"".join(
        data[name]
        for name, _range in sorted(ranges.items(), key=lambda item: item[1][0])
    )
    if len(combined) != int(manifest["covered_byte_count"]):
        errors.append("World 3 metasprite covered-byte count differs")
    if crc32(combined) != str(manifest["covered_crc32"]).lower():
        errors.append("World 3 metasprite covered CRC32 differs")

    return errors, {
        "index_count": len(entries),
        "direct_count": len(direct),
        "alias_count": len(aliases),
        "metasprite_count": len(metasprites),
        "palette_count": palette_count,
        "covered_byte_count": len(combined),
    }


def put_byte(encoded: dict[int, int], address: int, value: int) -> None:
    if address in encoded:
        raise ValueError(f"World 3 metasprite byte overlaps at ${address:04X}")
    encoded[address] = value


def encode_authoring(document: dict[str, Any]) -> dict[int, int]:
    if document.get("schema_version") != 1 or document.get("format") != (
        "doraemon-world3-metasprites"
    ):
        raise ValueError("unsupported World 3 metasprite authoring schema")
    layout = document["layout"]
    index_address = number(layout["index_address"])
    metasprite_address = number(layout["metasprite_address"])
    metasprite_end = number(layout["metasprite_end_address"])
    palette_address = number(layout["palette_address"])
    room_selector_address = number(layout["room_palette_selector_address"])
    index_count = int(document["index_count"])
    palette_count = int(document["palette_count"])
    entries = indexed_records(
        document["index_entries"], index_count, "id", "metasprite index"
    )
    records = indexed_records(
        document["metasprites"],
        int(document["metasprite_count"]),
        "id",
        "metasprite",
    )
    palettes = indexed_records(
        document["palettes"], palette_count, "id", "palette"
    )
    rooms = indexed_records(
        document["room_palettes"], 64, "room", "room palette"
    )
    if index_address + index_count * 2 != metasprite_address:
        raise ValueError("World 3 authoring index layout differs")
    if metasprite_end != palette_address:
        raise ValueError("World 3 authoring metasprite end differs")

    encoded: dict[int, int] = {}
    for entry in entries:
        entry_id = int(entry["id"])
        kind = str(entry["kind"])
        if kind == "direct":
            value = number(entry["metasprite_address"])
            if not 0x0400 <= value <= 0xFFFF:
                raise ValueError("direct metasprite pointer is outside its domain")
        elif kind == "alias":
            source = byte_value(entry["source_index"], "metasprite alias source")
            if source >= index_count:
                raise ValueError("metasprite alias source leaves the index domain")
            flip_name = str(entry["flip"])
            if flip_name not in FLIP_VALUES:
                raise ValueError("unknown World 3 metasprite flip mode")
            value = source | (FLIP_VALUES[flip_name] << 8)
        else:
            raise ValueError("unknown World 3 metasprite index kind")
        put_byte(encoded, index_address + entry_id * 2, value & 0xFF)
        put_byte(encoded, index_address + entry_id * 2 + 1, value >> 8)

    next_address = metasprite_address
    record_addresses: set[int] = set()
    for record in records:
        address = number(record["address"])
        if address != next_address:
            raise ValueError("World 3 metasprite records are not contiguous")
        record_addresses.add(address)
        pieces = indexed_records(
            record["pieces"], int(record["sprite_count"]), "id", "sprite piece"
        )
        put_byte(encoded, address, len(pieces))
        put_byte(
            encoded,
            address + 1,
            byte_value(record["x_mirror_extent"], "x mirror extent"),
        )
        put_byte(
            encoded,
            address + 2,
            byte_value(record["y_mirror_extent"], "y mirror extent"),
        )
        for piece in pieces:
            piece_address = address + 3 + int(piece["id"]) * 3
            put_byte(
                encoded,
                piece_address,
                byte_value(piece["y_offset"], "sprite y offset"),
            )
            put_byte(
                encoded,
                piece_address + 1,
                byte_value(piece["x_offset"], "sprite x offset"),
            )
            put_byte(
                encoded,
                piece_address + 2,
                byte_value(piece["tile"], "sprite tile"),
            )
        next_address = address + 3 + len(pieces) * 3
    if next_address != metasprite_end:
        raise ValueError("World 3 metasprite records do not fill their range")
    for entry in entries:
        if entry["kind"] == "direct" and number(
            entry["metasprite_address"]
        ) not in record_addresses:
            raise ValueError("direct metasprite pointer misses a record start")

    for palette in palettes:
        colors = palette.get("colors")
        if not isinstance(colors, list) or len(colors) != 32:
            raise ValueError("World 3 palette must contain 32 colors")
        for color_index, color in enumerate(colors):
            value = byte_value(color, "palette color")
            if value >= 0x40:
                raise ValueError("palette color is outside the NES palette")
            put_byte(
                encoded,
                palette_address + int(palette["id"]) * 32 + color_index,
                value,
            )
    for room in rooms:
        selector = byte_value(room["palette"], "room palette selector")
        if selector >= palette_count:
            raise ValueError("room palette selector is outside the palette catalog")
        put_byte(encoded, room_selector_address + int(room["room"]), selector)
    return encoded


def decode_authoring(
    prg: bytes,
    manifest: dict[str, Any],
    entity_types: dict[str, Any],
) -> dict[str, Any]:
    errors, report = validate_manifest_data(prg, manifest, entity_types)
    if errors:
        raise ValueError("; ".join(errors))
    data, entries, metasprites = manifest_data(prg, manifest)
    ranges = raw_layout(manifest)
    palette_count = int(manifest["palettes"]["count"])
    palettes = data["palettes"]
    result: dict[str, Any] = {
        "schema_version": 1,
        "format": "doraemon-world3-metasprites",
        "bank": int(manifest["bank"]),
        "layout": {
            "index_address": f"0x{ranges['index_table'][0]:04X}",
            "metasprite_address": f"0x{ranges['metasprites'][0]:04X}",
            "metasprite_end_address": (
                f"0x{ranges['metasprites'][0] + ranges['metasprites'][1]:04X}"
            ),
            "palette_address": f"0x{ranges['palettes'][0]:04X}",
            "room_palette_selector_address": (
                f"0x{ranges['room_palette_selectors'][0]:04X}"
            ),
        },
        "index_count": report["index_count"],
        "index_entries": [
            {
                key: (f"0x{value:04X}" if key == "metasprite_address" else value)
                for key, value in entry.items()
            }
            for entry in entries
        ],
        "metasprite_count": report["metasprite_count"],
        "metasprites": [
            {
                "id": int(record["id"]),
                "address": f"0x{int(record['address']):04X}",
                "sprite_count": int(record["sprite_count"]),
                "x_mirror_extent": f"0x{int(record['x_mirror_extent']):02X}",
                "y_mirror_extent": f"0x{int(record['y_mirror_extent']):02X}",
                "pieces": [
                    {
                        "id": int(piece["id"]),
                        "y_offset": f"0x{int(piece['y_offset']):02X}",
                        "x_offset": f"0x{int(piece['x_offset']):02X}",
                        "tile": f"0x{int(piece['tile']):02X}",
                    }
                    for piece in record["pieces"]
                ],
            }
            for record in metasprites
        ],
        "palette_count": palette_count,
        "palettes": [
            {
                "id": palette_id,
                "colors": [
                    f"0x{color:02X}"
                    for color in palettes[palette_id * 32:(palette_id + 1) * 32]
                ],
            }
            for palette_id in range(palette_count)
        ],
        "room_palettes": [
            {"room": room, "palette": selector}
            for room, selector in enumerate(data["room_palette_selectors"])
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
    entity_types: dict[str, Any],
    path: Path,
) -> list[str]:
    document = json.loads(path.read_text(encoding="utf-8"))
    encoded = encode_authoring(document)
    canonical = encode_authoring(
        decode_authoring(prg, manifest, entity_types)
    )
    payload = bytes(encoded[address] for address in sorted(encoded))
    errors: list[str] = []
    if int(document["bank"]) != int(manifest["bank"]):
        errors.append("World 3 metasprite authoring targets the wrong bank")
    if len(encoded) != int(document["covered_byte_count"]):
        errors.append("World 3 metasprite authoring byte count differs")
    if crc32(payload) != str(document["covered_crc32"]).lower():
        errors.append("World 3 metasprite authoring CRC32 differs")
    if encoded != canonical:
        errors.append("World 3 metasprite authoring roundtrip differs from PRG")
    return errors


def apply_authoring(prg: bytes, document: dict[str, Any]) -> bytes:
    if len(prg) != 4 * BANK_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    bank = int(document["bank"])
    result = bytearray(prg)
    for address, value in encode_authoring(document).items():
        offset = bank * BANK_SIZE + address - CPU_BASE
        if not 0 <= offset < len(result):
            raise ValueError("World 3 metasprite authoring address is outside PRG")
        result[offset] = value
    return bytes(result)


def chr_tile_pixels(chr_data: bytes, bank: int, tile: int) -> list[list[int]]:
    """Decode one 8x8 sprite tile from the first pattern table of a CHR bank."""
    start = bank * 0x2000 + tile * 16
    if not 0 <= start <= len(chr_data) - 16:
        raise ValueError("World 3 metasprite tile is outside CHR")
    low = chr_data[start:start + 8]
    high = chr_data[start + 8:start + 16]
    return [
        [
            ((low[y] >> (7 - x)) & 1) | (((high[y] >> (7 - x)) & 1) << 1)
            for x in range(8)
        ]
        for y in range(8)
    ]


def resolved_metasprite(
    entries: list[dict[str, Any]],
    records: list[dict[str, Any]],
    index: int,
) -> tuple[dict[str, Any], int]:
    """Resolve the single alias level implemented by World3_ComposeMetasprite."""
    if not 0 <= index < len(entries):
        raise ValueError(f"metasprite index ${index:02X} is outside its domain")
    entry = entries[index]
    flip = 0
    if entry["kind"] == "alias":
        flip = FLIP_VALUES[str(entry["flip"])]
        entry = entries[int(entry["source_index"])]
    if entry["kind"] != "direct":
        raise ValueError(f"metasprite index ${index:02X} has a nested alias")
    address = int(entry["metasprite_address"])
    by_address = {int(record["address"]): record for record in records}
    if address not in by_address:
        raise ValueError(f"metasprite index ${index:02X} misses a record")
    return by_address[address], flip


def render_entity_types(
    prg: bytes,
    chr_data: bytes,
    manifest: dict[str, Any],
    entity_types: dict[str, Any],
    output: Path,
    palette_id: int,
) -> None:
    """Render four animation indexes for every World 3 entity type."""
    try:
        from PIL import Image, ImageDraw
    except ImportError as exc:
        raise ValueError("Pillow is required for the metasprite renderer") from exc
    data, entries, records = manifest_data(prg, manifest)
    palette_count = int(manifest["palettes"]["count"])
    if not 0 <= palette_id < palette_count:
        raise ValueError("World 3 render palette is outside the catalog")
    tables = {
        str(table["name"]): table["values"]
        for table in entity_types["property_tables"]
    }
    bases = [number(value) for value in tables["metasprite_base"]]
    flags = [number(value) for value in tables["render_flags"]]
    palettes = data["palettes"]
    palette = palettes[palette_id * 32:(palette_id + 1) * 32]

    columns = 4
    rows = (len(bases) + columns - 1) // columns
    cell_width, cell_height = 300, 116
    sheet = Image.new(
        "RGB", (columns * cell_width, rows * cell_height), (24, 24, 30)
    )
    draw = ImageDraw.Draw(sheet)
    for type_id, base in enumerate(bases):
        cell_x = (type_id % columns) * cell_width
        cell_y = (type_id // columns) * cell_height
        draw.rectangle(
            (cell_x, cell_y, cell_x + cell_width - 1, cell_y + cell_height - 1),
            outline=(64, 64, 72),
        )
        draw.text(
            (cell_x + 6, cell_y + 5),
            f"type ${type_id:02X}  base ${base:02X}  pal {flags[type_id] & 3}",
            fill=(235, 235, 235),
        )
        sprite_palette = flags[type_id] & 3
        colors = [
            NES_RGB[palette[16 + sprite_palette * 4 + color] & 0x3F]
            for color in range(4)
        ]
        for variant in range(4):
            index = base + variant
            record, alias_flip = resolved_metasprite(entries, records, index)
            origin_x = cell_x + 34 + variant * 68
            origin_y = cell_y + 47
            draw.text(
                (origin_x - 5, cell_y + 25),
                f"{index:02X}",
                fill=(150, 150, 160),
            )
            for piece in record["pieces"]:
                raw_y = int(piece["y_offset"])
                raw_x = int(piece["x_offset"])
                offset_y = raw_y & 0x7F
                offset_x = raw_x & 0x7F
                flip_y = bool(raw_y & 0x80)
                flip_x = bool(raw_x & 0x80)
                if alias_flip & 2:
                    offset_y = int(record["y_mirror_extent"]) - offset_y
                    flip_y = not flip_y
                if alias_flip & 1:
                    offset_x = int(record["x_mirror_extent"]) - offset_x
                    flip_x = not flip_x
                pixels = chr_tile_pixels(
                    chr_data, int(manifest["bank"]), int(piece["tile"])
                )
                for y in range(8):
                    for x in range(8):
                        source_y = 7 - y if flip_y else y
                        source_x = 7 - x if flip_x else x
                        color = pixels[source_y][source_x]
                        if color:
                            px = origin_x + (offset_x + x) * 2
                            py = origin_y + (offset_y + y) * 2
                            draw.rectangle(
                                (px, py, px + 1, py + 1), fill=colors[color]
                            )
    output.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(output)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    for name in ("validate", "decode", "render-types"):
        command = subparsers.add_parser(name)
        command.add_argument("--prg", required=True, type=Path)
        command.add_argument("--manifest", required=True, type=Path)
        command.add_argument("--entity-types", required=True, type=Path)
        if name == "validate":
            command.add_argument("--authoring", required=True, type=Path)
        elif name == "decode":
            command.add_argument("--output", required=True, type=Path)
        else:
            command.add_argument("--chr", required=True, type=Path)
            command.add_argument("--output", required=True, type=Path)
            command.add_argument("--palette", type=int, default=0)
    encode_parser = subparsers.add_parser("encode")
    encode_parser.add_argument("--input", required=True, type=Path)
    encode_parser.add_argument("--base-prg", required=True, type=Path)
    encode_parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    try:
        if args.command == "encode":
            document = load_json(args.input, "World 3 metasprite authoring")
            output = apply_authoring(args.base_prg.read_bytes(), document)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_bytes(output)
            print(
                f"[OK] wrote PRG with {len(encode_authoring(document))} "
                "World 3 metasprite bytes"
            )
            return 0
        prg = args.prg.read_bytes()
        manifest = load_json(args.manifest, "World 3 metasprite")
        entity_types = load_json(args.entity_types, "World 3 entity type")
        if args.command == "render-types":
            render_entity_types(
                prg,
                args.chr.read_bytes(),
                manifest,
                entity_types,
                args.output,
                args.palette,
            )
            print(f"[OK] wrote World 3 entity contact sheet to {args.output}")
            return 0
        if args.command == "decode":
            document = decode_authoring(prg, manifest, entity_types)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_text(
                json.dumps(document, indent=2) + "\n",
                encoding="utf-8",
                newline="\n",
            )
            print(f"[OK] wrote World 3 metasprites to {args.output}")
            return 0
        errors, report = validate_manifest_data(prg, manifest, entity_types)
        errors.extend(
            validate_authoring(
                prg,
                manifest,
                entity_types,
                args.authoring,
            )
        )
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 3 metasprite audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] World 3 metasprites: {report['index_count']} indexes "
        f"({report['direct_count']} direct, {report['alias_count']} aliases), "
        f"{report['metasprite_count']} records, "
        f"{report['palette_count']} palettes; "
        f"{report['covered_byte_count']} lossless authoring bytes"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
