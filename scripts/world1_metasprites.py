#!/usr/bin/env python3
"""Validate, losslessly edit, and render the World 1 metasprite catalog."""

from __future__ import annotations

import argparse
from collections import Counter
import json
from pathlib import Path
from typing import Any
import zlib

from world3_metasprites import NES_RGB


BANK_SIZE = 0x8000
CPU_BASE = 0x8000
CHR_BANK_SIZE = 0x2000
FLIP_MODES = {
    0: "none",
    1: "horizontal",
    2: "vertical",
    3: "horizontal_vertical",
}
FLIP_VALUES = {name: value for value, name in FLIP_MODES.items()}
RENDERER_RAM_FIELDS = [
    ("World1OamY", 0x0041, 1),
    ("World1OamTile", 0x0042, 1),
    ("World1OamAttributes", 0x0043, 1),
    ("World1OamX", 0x0044, 1),
    ("World1MetaspriteOriginX", 0x0045, 1),
    ("World1MetaspriteOriginXHigh", 0x0046, 1),
    ("World1MetaspriteOriginY", 0x0047, 1),
    ("World1MetaspriteOriginYHigh", 0x0048, 1),
    ("World1MetaspriteIndex", 0x0049, 1),
    ("World1MetaspriteRenderFlags", 0x004A, 1),
    ("World1MetaspriteDataPointer", 0x004B, 2),
    ("World1MetaspriteXMirrorExtent", 0x004D, 1),
    ("World1MetaspriteYMirrorExtent", 0x004E, 1),
    ("World1MetaspritePiecesRemaining", 0x004F, 1),
    ("World1OamWriteIndex", 0x0050, 1),
]
RENDERER_EMITTER = ("World1_EmitOamEntry", 0x9B35)


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def byte_value(value: str | int, description: str) -> int:
    result = number(value)
    if not 0 <= result <= 0xFF:
        raise ValueError(f"{description} is outside byte range")
    return result


def crc32(data: bytes) -> str:
    return f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"


def load_json(path: Path, description: str) -> dict[str, Any]:
    document = json.loads(path.read_text(encoding="utf-8"))
    if document.get("schema_version") != 1:
        raise ValueError(f"unsupported {description} schema")
    return document


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("World 1 metasprite range is outside PRG")
    return prg[offset:offset + size]


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
    index = manifest["index_table"]
    records = manifest["metasprites"]
    index_address = number(index["address"])
    record_address = number(records["address"])
    record_end = number(records["end_address"])
    index_size = int(index["count"]) * int(index["entry_size"])
    if index_address + index_size != record_address:
        raise ValueError("World 1 metasprite index does not end at records")
    return {
        "index_table": bank_slice(prg, bank, index_address, index_size),
        "metasprites": bank_slice(
            prg, bank, record_address, record_end - record_address
        ),
    }


def parse_index_table(data: bytes) -> list[dict[str, Any]]:
    if len(data) % 2:
        raise ValueError("World 1 metasprite index has odd byte length")
    entries: list[dict[str, Any]] = []
    for index in range(len(data) // 2):
        low, high = data[index * 2:index * 2 + 2]
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
                "metasprite_address": low | high << 8,
            })
    return entries


def parse_metasprites(data: bytes, address: int) -> list[dict[str, Any]]:
    records: list[dict[str, Any]] = []
    offset = 0
    while offset < len(data):
        if len(data) - offset < 3:
            raise ValueError("World 1 metasprite header is truncated")
        sprite_count = data[offset]
        size = 3 + sprite_count * 3
        if sprite_count == 0 or offset + size > len(data):
            raise ValueError("World 1 metasprite record is truncated")
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
    prg: bytes, manifest: dict[str, Any]
) -> tuple[dict[str, bytes], list[dict[str, Any]], list[dict[str, Any]]]:
    data = raw_data(prg, manifest)
    entries = parse_index_table(data["index_table"])
    records = parse_metasprites(
        data["metasprites"], number(manifest["metasprites"]["address"])
    )
    return data, entries, records


def descriptor_bases(objects: dict[str, Any]) -> list[int]:
    records = objects["world1_descriptor_objects"]["records"]
    return [number(record[1]) for record in records]


def registry_symbol_matches(
    registry: dict[str, Any],
    section: str,
    name: str,
    address: int,
    size: int,
    bank: int,
) -> bool:
    matches = [
        entry for entry in registry.get(section, [])
        if entry.get("name") == name
    ]
    if len(matches) != 1:
        return False
    actual = matches[0]
    if number(actual["address"]) != address:
        return False
    if section == "memory_symbols":
        return (
            int(actual.get("size", 1)) == size
            and actual.get("banks") == [bank]
        )
    return int(actual.get("bank", -1)) == bank


def validate_renderer_workspace(
    manifest: dict[str, Any], registry: dict[str, Any]
) -> list[str]:
    workspace = manifest["renderer_workspace"]
    bank = int(manifest["bank"])
    errors: list[str] = []
    if (
        number(workspace["start_address"]) != 0x0041
        or number(workspace["end_address"]) != 0x0051
    ):
        errors.append("World 1 renderer workspace range differs")
    fields = [
        (str(field["name"]), number(field["address"]), int(field["size"]))
        for field in workspace["fields"]
    ]
    if fields != RENDERER_RAM_FIELDS:
        errors.append("World 1 renderer workspace field layout differs")
    for name, address, size in RENDERER_RAM_FIELDS:
        if not registry_symbol_matches(
            registry, "memory_symbols", name, address, size, bank
        ):
            errors.append(f"World 1 renderer RAM symbol differs: {name}")
    emitter = workspace["emitter"]
    emitter_name, emitter_address = RENDERER_EMITTER
    if (
        str(emitter["name"]) != emitter_name
        or number(emitter["address"]) != emitter_address
        or not registry_symbol_matches(
            registry, "symbols", emitter_name, emitter_address, 1, bank
        )
    ):
        errors.append("World 1 OAM emitter symbol differs")
    return errors


def validate_manifest_data(
    prg: bytes,
    chr_data: bytes,
    manifest: dict[str, Any],
    objects: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    if len(chr_data) != 4 * CHR_BANK_SIZE:
        return [f"CHR size differs: {len(chr_data)}"], {}
    errors: list[str] = []
    try:
        data, entries, records = manifest_data(prg, manifest)
    except (KeyError, TypeError, ValueError) as exc:
        return [str(exc)], {}

    if int(manifest["bank"]) != 0 or int(manifest["chr_bank"]) != 0:
        errors.append("World 1 metasprites must use PRG and CHR bank 0")
    chr_bank = int(manifest["chr_bank"])
    chr_bytes = chr_data[chr_bank * CHR_BANK_SIZE:(chr_bank + 1) * CHR_BANK_SIZE]
    if crc32(chr_bytes) != str(manifest["chr_bank_crc32"]).lower():
        errors.append("World 1 metasprite CHR bank CRC32 differs")
    if number(manifest["sprite_pattern_table"]) != 0:
        errors.append("World 1 sprites must use pattern table zero")
    if int(manifest["index_table"]["entry_size"]) != 2:
        errors.append("World 1 metasprite index entry width differs")
    if int(manifest["index_table"]["direct_pointer_high_minimum"]) != 4:
        errors.append("World 1 direct-pointer discriminator differs")
    if manifest["metasprites"]["header_fields"] != [
        "sprite_count", "x_mirror_extent", "y_mirror_extent"
    ]:
        errors.append("World 1 metasprite header field order differs")
    if manifest["metasprites"]["piece_fields"] != [
        "y_offset", "x_offset", "tile"
    ]:
        errors.append("World 1 metasprite piece field order differs")
    for name in ("index_table", "metasprites"):
        if crc32(data[name]) != str(manifest[name]["crc32"]).lower():
            errors.append(f"World 1 {name} CRC32 differs")

    direct = [entry for entry in entries if entry["kind"] == "direct"]
    aliases = [entry for entry in entries if entry["kind"] == "alias"]
    addresses = {int(record["address"]) for record in records}
    targets = {int(entry["metasprite_address"]) for entry in direct}
    missed = sorted(targets - addresses)
    if missed:
        errors.append("World 1 direct pointers miss record starts")
    invalid_aliases = [
        int(entry["id"]) for entry in aliases
        if int(entry["source_index"]) >= len(entries)
    ]
    if invalid_aliases:
        errors.append("World 1 aliases leave the index domain")
    nested = [
        int(entry["id"]) for entry in aliases
        if int(entry["source_index"]) < len(entries)
        and entries[int(entry["source_index"])]["kind"] != "direct"
    ]
    metrics = manifest["expected_metrics"]
    histogram = dict(Counter(int(record["sprite_count"]) for record in records))
    expected_histogram = {
        int(key): int(value)
        for key, value in metrics["sprite_count_histogram"].items()
    }
    tiles = {
        int(piece["tile"])
        for record in records
        for piece in record["pieces"]
    }
    comparisons = [
        (len(entries), int(manifest["index_table"]["count"]), "index count"),
        (len(direct), int(metrics["direct_index_entries"]), "direct count"),
        (len(aliases), int(metrics["alias_index_entries"]), "alias count"),
        (len(targets), int(metrics["unique_direct_targets"]), "target count"),
        (len(records), int(manifest["metasprites"]["count"]), "record count"),
        (len(tiles), int(metrics["unique_tile_count"]), "unique tile count"),
    ]
    for actual, expected, description in comparisons:
        if actual != expected:
            errors.append(f"World 1 metasprite {description} differs")
    if nested != [number(value) for value in metrics["nested_alias_ids"]]:
        errors.append("World 1 nested aliases differ")
    if sorted(addresses - targets) != [
        number(value) for value in metrics["unreferenced_records"]
    ]:
        errors.append("World 1 unreferenced records differ")
    if histogram != expected_histogram:
        errors.append("World 1 sprite-count histogram differs")
    invalid_bases = [
        base for base in descriptor_bases(objects)
        if base >= len(entries) or entries[base]["kind"] != "direct"
    ]
    if invalid_bases:
        errors.append("World 1 descriptor bases do not resolve directly")

    for signature in manifest["signatures"]:
        raw = bytes.fromhex(str(signature["bytes"]))
        if bank_slice(
            prg, int(manifest["bank"]), number(signature["address"]), len(raw)
        ) != raw:
            errors.append(
                f"World 1 renderer signature differs at "
                f"${number(signature['address']):04X}"
            )
    covered = data["index_table"] + data["metasprites"]
    if len(covered) != int(manifest["covered_byte_count"]):
        errors.append("World 1 metasprite covered-byte count differs")
    if crc32(covered) != str(manifest["covered_crc32"]).lower():
        errors.append("World 1 metasprite covered CRC32 differs")
    return errors, {
        "index_count": len(entries),
        "direct_count": len(direct),
        "alias_count": len(aliases),
        "metasprite_count": len(records),
        "covered_byte_count": len(covered),
    }


def put_byte(encoded: dict[int, int], address: int, value: int) -> None:
    if address in encoded:
        raise ValueError(f"World 1 metasprite byte overlaps at ${address:04X}")
    encoded[address] = value


def encode_authoring(document: dict[str, Any]) -> dict[int, int]:
    if document.get("schema_version") != 1 or document.get("format") != (
        "doraemon-world1-metasprites"
    ):
        raise ValueError("unsupported World 1 metasprite authoring schema")
    layout = document["layout"]
    index_address = number(layout["index_address"])
    record_address = number(layout["metasprite_address"])
    record_end = number(layout["metasprite_end_address"])
    index_count = int(document["index_count"])
    entries = indexed_records(
        document["index_entries"], index_count, "id", "metasprite index"
    )
    records = indexed_records(
        document["metasprites"],
        int(document["metasprite_count"]),
        "id",
        "metasprite",
    )
    if index_address + index_count * 2 != record_address:
        raise ValueError("World 1 authoring index layout differs")
    encoded: dict[int, int] = {}
    for entry in entries:
        entry_id = int(entry["id"])
        if entry["kind"] == "direct":
            value = number(entry["metasprite_address"])
            if not 0x0400 <= value <= 0xFFFF:
                raise ValueError("direct metasprite pointer is outside its domain")
        elif entry["kind"] == "alias":
            source = byte_value(entry["source_index"], "metasprite alias source")
            if source >= index_count:
                raise ValueError("metasprite alias source leaves the index domain")
            flip = str(entry["flip"])
            if flip not in FLIP_VALUES:
                raise ValueError("unknown World 1 metasprite flip mode")
            value = source | FLIP_VALUES[flip] << 8
        else:
            raise ValueError("unknown World 1 metasprite index kind")
        put_byte(encoded, index_address + entry_id * 2, value & 0xFF)
        put_byte(encoded, index_address + entry_id * 2 + 1, value >> 8)

    next_address = record_address
    record_addresses: set[int] = set()
    for record in records:
        address = number(record["address"])
        if address != next_address:
            raise ValueError("World 1 metasprite records are not contiguous")
        record_addresses.add(address)
        pieces = indexed_records(
            record["pieces"], int(record["sprite_count"]), "id", "sprite piece"
        )
        put_byte(encoded, address, len(pieces))
        put_byte(encoded, address + 1, byte_value(
            record["x_mirror_extent"], "x mirror extent"
        ))
        put_byte(encoded, address + 2, byte_value(
            record["y_mirror_extent"], "y mirror extent"
        ))
        for piece in pieces:
            piece_address = address + 3 + int(piece["id"]) * 3
            for offset, field in enumerate(("y_offset", "x_offset", "tile")):
                put_byte(encoded, piece_address + offset, byte_value(
                    piece[field], f"sprite {field}"
                ))
        next_address = address + 3 + len(pieces) * 3
    if next_address != record_end:
        raise ValueError("World 1 metasprite records do not fill their range")
    for entry in entries:
        if entry["kind"] == "direct" and number(
            entry["metasprite_address"]
        ) not in record_addresses:
            raise ValueError("direct metasprite pointer misses a record start")
    return encoded


def decode_authoring(
    prg: bytes,
    chr_data: bytes,
    manifest: dict[str, Any],
    objects: dict[str, Any],
) -> dict[str, Any]:
    errors, report = validate_manifest_data(prg, chr_data, manifest, objects)
    if errors:
        raise ValueError("; ".join(errors))
    _data, entries, records = manifest_data(prg, manifest)
    result: dict[str, Any] = {
        "schema_version": 1,
        "format": "doraemon-world1-metasprites",
        "bank": int(manifest["bank"]),
        "layout": {
            "index_address": manifest["index_table"]["address"],
            "metasprite_address": manifest["metasprites"]["address"],
            "metasprite_end_address": manifest["metasprites"]["end_address"],
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
            for record in records
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
    chr_data: bytes,
    manifest: dict[str, Any],
    objects: dict[str, Any],
    path: Path,
) -> list[str]:
    document = json.loads(path.read_text(encoding="utf-8"))
    encoded = encode_authoring(document)
    canonical = encode_authoring(
        decode_authoring(prg, chr_data, manifest, objects)
    )
    payload = bytes(encoded[address] for address in sorted(encoded))
    errors: list[str] = []
    if int(document["bank"]) != int(manifest["bank"]):
        errors.append("World 1 metasprite authoring targets the wrong bank")
    if len(encoded) != int(document["covered_byte_count"]):
        errors.append("World 1 metasprite authoring byte count differs")
    if crc32(payload) != str(document["covered_crc32"]).lower():
        errors.append("World 1 metasprite authoring CRC32 differs")
    if encoded != canonical:
        errors.append("World 1 metasprite authoring roundtrip differs from PRG")
    return errors


def apply_authoring(prg: bytes, document: dict[str, Any]) -> bytes:
    if len(prg) != 4 * BANK_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    result = bytearray(prg)
    bank = int(document["bank"])
    for address, value in encode_authoring(document).items():
        offset = bank * BANK_SIZE + address - CPU_BASE
        if not 0 <= offset < len(result):
            raise ValueError("World 1 authoring address is outside PRG")
        result[offset] = value
    return bytes(result)


def chr_tile_pixels(chr_data: bytes, bank: int, tile: int) -> list[list[int]]:
    start = bank * CHR_BANK_SIZE + tile * 16
    if not 0 <= start <= len(chr_data) - 16:
        raise ValueError("World 1 metasprite tile is outside CHR")
    low = chr_data[start:start + 8]
    high = chr_data[start + 8:start + 16]
    return [[
        ((low[y] >> (7 - x)) & 1) | (((high[y] >> (7 - x)) & 1) << 1)
        for x in range(8)
    ] for y in range(8)]


def resolved_metasprite(
    entries: list[dict[str, Any]],
    records: list[dict[str, Any]],
    index: int,
) -> tuple[dict[str, Any], int]:
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


def render_catalog(
    prg: bytes,
    chr_data: bytes,
    manifest: dict[str, Any],
    objects: dict[str, Any],
    output: Path,
) -> None:
    try:
        from PIL import Image, ImageDraw
    except ImportError as exc:
        raise ValueError("Pillow is required for the metasprite renderer") from exc
    _data, entries, records = manifest_data(prg, manifest)
    bases = set(descriptor_bases(objects))
    columns = 8
    rows = (len(entries) + columns - 1) // columns
    cell_width, cell_height = 112, 104
    sheet = Image.new("RGB", (columns * cell_width, rows * cell_height), (24, 24, 30))
    draw = ImageDraw.Draw(sheet)
    colors = [NES_RGB[index] for index in (0x0F, 0x20, 0x16, 0x30)]
    for index in range(len(entries)):
        cell_x = index % columns * cell_width
        cell_y = index // columns * cell_height
        outline = (230, 180, 60) if index in bases else (64, 64, 72)
        draw.rectangle(
            (cell_x, cell_y, cell_x + cell_width - 1, cell_y + cell_height - 1),
            outline=outline,
        )
        entry = entries[index]
        suffix = "" if entry["kind"] == "direct" else f"->{int(entry['source_index']):02X}"
        draw.text((cell_x + 4, cell_y + 3), f"${index:02X}{suffix}", fill=(235, 235, 235))
        record, alias_flip = resolved_metasprite(entries, records, index)
        origin_x = cell_x + 24
        origin_y = cell_y + 30
        for piece in record["pieces"]:
            raw_y = int(piece["y_offset"])
            raw_x = int(piece["x_offset"])
            offset_y, offset_x = raw_y & 0x7F, raw_x & 0x7F
            flip_y, flip_x = bool(raw_y & 0x80), bool(raw_x & 0x80)
            if alias_flip & 2:
                offset_y = int(record["y_mirror_extent"]) - offset_y
                flip_y = not flip_y
            if alias_flip & 1:
                offset_x = int(record["x_mirror_extent"]) - offset_x
                flip_x = not flip_x
            pixels = chr_tile_pixels(chr_data, int(manifest["chr_bank"]), int(piece["tile"]))
            for y in range(8):
                for x in range(8):
                    source_y = 7 - y if flip_y else y
                    source_x = 7 - x if flip_x else x
                    color = pixels[source_y][source_x]
                    if color:
                        px = origin_x + (offset_x + x) * 2
                        py = origin_y + (offset_y + y) * 2
                        draw.rectangle((px, py, px + 1, py + 1), fill=colors[color])
    output.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(output)


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser(description=__doc__)
    subparsers = result.add_subparsers(dest="command", required=True)
    for command in ("validate", "decode", "apply", "render"):
        child = subparsers.add_parser(command)
        child.add_argument("--prg", type=Path, required=True)
        child.add_argument("--manifest", type=Path, required=True)
        child.add_argument("--objects", type=Path, required=True)
        if command != "apply":
            child.add_argument("--chr", type=Path, required=True)
        if command in ("validate", "apply"):
            child.add_argument("--authoring", type=Path, required=True)
        if command == "validate":
            child.add_argument("--symbols", type=Path, required=True)
        if command in ("decode", "apply", "render"):
            child.add_argument("--output", type=Path, required=True)
    return result


def main() -> int:
    args = parser().parse_args()
    try:
        prg = args.prg.read_bytes()
        manifest = load_json(args.manifest, "World 1 metasprite manifest")
        objects = load_json(args.objects, "object-placement manifest")
        if args.command == "apply":
            document = load_json(args.authoring, "World 1 metasprite authoring")
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_bytes(apply_authoring(prg, document))
            print(f"[OK] wrote {args.output}")
            return 0
        chr_data = args.chr.read_bytes()
        if args.command == "decode":
            document = decode_authoring(prg, chr_data, manifest, objects)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_text(json.dumps(document, indent=2) + "\n", encoding="utf-8")
            print(f"[OK] wrote {args.output}")
            return 0
        if args.command == "render":
            render_catalog(prg, chr_data, manifest, objects, args.output)
            print(f"[OK] wrote {args.output}")
            return 0
        errors, report = validate_manifest_data(prg, chr_data, manifest, objects)
        registry = load_json(args.symbols, "symbol registry")
        errors.extend(validate_renderer_workspace(manifest, registry))
        errors.extend(validate_authoring(
            prg, chr_data, manifest, objects, args.authoring
        ))
    except (KeyError, OSError, TypeError, ValueError) as exc:
        print(f"[ERROR] World 1 metasprite validation failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] World 1 metasprites: {report['index_count']} indexes "
        f"({report['direct_count']} direct, {report['alias_count']} aliases), "
        f"{report['metasprite_count']} records; "
        f"{len(RENDERER_RAM_FIELDS)} renderer RAM fields; "
        f"{report['covered_byte_count']} lossless authoring bytes"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
