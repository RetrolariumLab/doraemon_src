#!/usr/bin/env python3
"""NES graphics and palette rendering helpers for Doraemon Level Studio."""

from __future__ import annotations

from dataclasses import dataclass
import json
from pathlib import Path
from typing import Any, Sequence

from scripts.authoring.level_studio_model import HierarchicalWorldDocument


NES_RGB = (
    "#626262", "#001fb2", "#2404c8", "#5200b2", "#730076", "#800024",
    "#730b00", "#522800", "#244400", "#005700", "#005c00", "#005324",
    "#003c76", "#000000", "#000000", "#000000", "#ababab", "#0d57ff",
    "#4b30ff", "#8a13ff", "#bc08d6", "#d21269", "#c72e00", "#9d5400",
    "#607b00", "#209800", "#00a300", "#009942", "#007db4", "#000000",
    "#000000", "#000000", "#ffffff", "#53aeff", "#9085ff", "#d365ff",
    "#ff57ff", "#ff5dcf", "#ff7757", "#fa9e00", "#bdc700", "#7ae700",
    "#43f611", "#26ef7e", "#2cd5f6", "#4e4e4e", "#000000", "#000000",
    "#ffffff", "#b6e1ff", "#ced1ff", "#e9c3ff", "#ffbcff", "#ffbdf4",
    "#ffc6c3", "#ffd59a", "#e9e681", "#cef481", "#b6fb9a", "#a9fac3",
    "#a9f0f4", "#b8b8b8", "#000000", "#000000",
)

CHR_BANK_SIZE = 0x2000
PATTERN_TABLE_SIZE = 0x1000
TILE_SIZE = 16


@dataclass(frozen=True)
class World2Metatile:
    id: int
    palette: int
    tiles: tuple[int, int, int, int]
    solid: bool


def _number(value: str | int) -> int:
    if isinstance(value, int):
        return value
    return int(value, 0) if value.lower().startswith("0x") else int(value, 16)


def decode_chr_tile(data: bytes) -> tuple[tuple[int, ...], ...]:
    if len(data) != TILE_SIZE:
        raise ValueError("one NES CHR tile must contain exactly 16 bytes")
    rows: list[tuple[int, ...]] = []
    for y in range(8):
        low, high = data[y], data[y + 8]
        rows.append(
            tuple(
                ((low >> (7 - x)) & 1) | (((high >> (7 - x)) & 1) << 1)
                for x in range(8)
            )
        )
    return tuple(rows)


def decode_background_tiles(
    chr_data: bytes,
    chr_bank: int,
) -> tuple[tuple[tuple[int, ...], ...], ...]:
    """Decode the $1000 background pattern table from one 8 KiB GNROM bank."""

    if len(chr_data) % CHR_BANK_SIZE != 0:
        raise ValueError("CHR data size is not a whole number of 8 KiB banks")
    bank_count = len(chr_data) // CHR_BANK_SIZE
    if not 0 <= chr_bank < bank_count:
        raise ValueError(f"CHR bank {chr_bank} is outside 0-{bank_count - 1}")
    start = chr_bank * CHR_BANK_SIZE + PATTERN_TABLE_SIZE
    table = chr_data[start:start + PATTERN_TABLE_SIZE]
    return tuple(
        decode_chr_tile(table[offset:offset + TILE_SIZE])
        for offset in range(0, len(table), TILE_SIZE)
    )


def decode_sprite_tiles(
    chr_data: bytes,
    chr_bank: int,
) -> tuple[tuple[tuple[int, ...], ...], ...]:
    """Decode the $0000 sprite pattern table from one 8 KiB GNROM bank."""

    if len(chr_data) % CHR_BANK_SIZE != 0:
        raise ValueError("CHR data size is not a whole number of 8 KiB banks")
    bank_count = len(chr_data) // CHR_BANK_SIZE
    if not 0 <= chr_bank < bank_count:
        raise ValueError(f"CHR bank {chr_bank} is outside 0-{bank_count - 1}")
    start = chr_bank * CHR_BANK_SIZE
    table = chr_data[start:start + PATTERN_TABLE_SIZE]
    return tuple(
        decode_chr_tile(table[offset:offset + TILE_SIZE])
        for offset in range(0, len(table), TILE_SIZE)
    )


def parse_palette_catalog(document: dict[str, Any]) -> tuple[tuple[int, ...], ...]:
    palettes = document.get("palettes")
    if not isinstance(palettes, list) or not palettes:
        raise ValueError("palette catalog must contain at least one palette")
    if [entry.get("id") for entry in palettes] != list(range(len(palettes))):
        raise ValueError("palette ids must be contiguous")
    result: list[tuple[int, ...]] = []
    for entry in palettes:
        raw = entry.get("colors")
        values = raw.split() if isinstance(raw, str) else raw
        if not isinstance(values, list) or len(values) != 32:
            raise ValueError("each full PPU palette must contain 32 colors")
        colors = tuple(_number(value) for value in values)
        if any(not 0 <= color <= 0x3F for color in colors):
            raise ValueError("PPU palette color is outside $00-$3F")
        result.append(colors)
    declared = document.get("palette_count")
    if declared is not None and int(declared) != len(result):
        raise ValueError("declared palette count differs from palette entries")
    return tuple(result)


def load_world_palettes(
    project_root: Path,
    world_id: str,
) -> tuple[tuple[int, ...], ...]:
    relative_paths = {
        "world1": Path("data/world1/palettes.json"),
        "world3": Path("data/world3/metasprites.json"),
    }
    try:
        path = project_root / relative_paths[world_id]
    except KeyError as exc:
        raise ValueError(f"no palette catalog for {world_id}") from exc
    try:
        document = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ValueError(f"cannot load palette catalog {path}: {exc}") from exc
    return parse_palette_catalog(document)


def load_world2_metatiles(project_root: Path) -> tuple[World2Metatile, ...]:
    path = project_root / "data/world2/metatiles.json"
    try:
        document = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ValueError(f"cannot load World 2 metatiles {path}: {exc}") from exc
    records = document.get("records")
    if not isinstance(records, list) or [entry.get("id") for entry in records] != list(
        range(len(records))
    ):
        raise ValueError("World 2 metatile ids must be contiguous")
    result: list[World2Metatile] = []
    for entry in records:
        palette = int(entry["palette"])
        tiles = tuple(
            _number(entry[key])
            for key in ("top_left", "top_right", "bottom_left", "bottom_right")
        )
        if not 0 <= palette <= 3 or len(tiles) != 4 or any(
            not 0 <= tile <= 0xFF for tile in tiles
        ):
            raise ValueError(f"invalid World 2 metatile {entry['id']}")
        if not isinstance(entry.get("solid"), bool):
            raise ValueError(f"World 2 metatile {entry['id']} has invalid solidity")
        result.append(
            World2Metatile(int(entry["id"]), palette, tiles, entry["solid"])
        )
    if len(result) != 208:
        raise ValueError("World 2 metatile catalog must contain 208 records")
    return tuple(result)


def load_world2_palettes(project_root: Path) -> tuple[tuple[int, ...], ...]:
    path = project_root / "data/world2/palettes.json"
    try:
        document = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ValueError(f"cannot load World 2 palettes {path}: {exc}") from exc

    return parse_world2_palette_catalog(document)


def parse_world2_palette_catalog(
    document: dict[str, Any],
) -> tuple[tuple[int, ...], ...]:
    """Parse World 2's background-only 16-color palette sets."""

    entries = document.get("palettes")
    if not isinstance(entries, list) or [entry.get("id") for entry in entries] != list(
        range(len(entries))
    ):
        raise ValueError("World 2 palette ids must be contiguous")
    result: list[tuple[int, ...]] = []
    for entry in entries:
        raw = entry.get("colors")
        values = raw.split() if isinstance(raw, str) else raw
        if not isinstance(values, list):
            raise ValueError("World 2 background palette colors must be a list")
        colors = tuple(_number(value) for value in values)
        if len(colors) != 16 or any(not 0 <= color <= 0x3F for color in colors):
            raise ValueError("World 2 background palette must contain 16 colors")
        result.append(colors)
    if int(document.get("palette_count", -1)) != len(result):
        raise ValueError("World 2 palette count differs from entries")
    declared_size = document.get("colors_per_set")
    if declared_size is not None and int(declared_size) != 16:
        raise ValueError("World 2 colors-per-set declaration must be 16")
    return tuple(result)


def background_palette_row(
    palette: Sequence[int],
    selector: int,
) -> tuple[int, int, int, int]:
    if len(palette) != 32:
        raise ValueError("full PPU palette must contain 32 colors")
    if not 0 <= selector <= 3:
        raise ValueError("background palette selector is outside 0-3")
    start = selector * 4
    return tuple(palette[start:start + 4])  # type: ignore[return-value]


def render_big_block(
    model: HierarchicalWorldDocument,
    block: int,
    tiles: Sequence[Sequence[Sequence[int]]],
    palette: Sequence[int],
) -> tuple[tuple[str, ...], ...]:
    """Render a hierarchical big block as a 32-by-32 RGB pixel matrix."""

    if len(tiles) != 256:
        raise ValueError("background pattern table must contain 256 tiles")
    output = [["#000000"] * 32 for _ in range(32)]
    for tile_y, row in enumerate(model.expanded_big_block(block)):
        for tile_x, cell in enumerate(row):
            if not 0 <= cell.tile < len(tiles):
                raise ValueError(f"CHR tile {cell.tile:02X} is outside the table")
            colors = background_palette_row(palette, cell.palette)
            pixels = tiles[cell.tile]
            if len(pixels) != 8 or any(len(pixel_row) != 8 for pixel_row in pixels):
                raise ValueError("decoded CHR tile is not 8x8")
            for pixel_y, pixel_row in enumerate(pixels):
                for pixel_x, value in enumerate(pixel_row):
                    if not 0 <= value <= 3:
                        raise ValueError("decoded CHR pixel is outside 0-3")
                    output[tile_y * 8 + pixel_y][tile_x * 8 + pixel_x] = (
                        NES_RGB[colors[value] & 0x3F]
                    )
    return tuple(tuple(row) for row in output)


def render_world2_metatile(
    metatile: World2Metatile,
    tiles: Sequence[Sequence[Sequence[int]]],
    palette: Sequence[int],
) -> tuple[tuple[str, ...], ...]:
    """Render one World 2 2x2 CHR metatile as a 16-by-16 pixel matrix."""

    if len(tiles) != 256:
        raise ValueError("background pattern table must contain 256 tiles")
    if len(palette) != 16:
        raise ValueError("World 2 background palette must contain 16 colors")
    colors = background_palette_row(tuple(palette) * 2, metatile.palette)
    output = [["#000000"] * 16 for _ in range(16)]
    for quadrant, tile in enumerate(metatile.tiles):
        pixels = tiles[tile]
        if len(pixels) != 8 or any(len(row) != 8 for row in pixels):
            raise ValueError("decoded CHR tile is not 8x8")
        origin_x, origin_y = (quadrant & 1) * 8, (quadrant >> 1) * 8
        for y, row in enumerate(pixels):
            for x, value in enumerate(row):
                if not 0 <= value <= 3:
                    raise ValueError("decoded CHR pixel is outside 0-3")
                output[origin_y + y][origin_x + x] = NES_RGB[colors[value] & 0x3F]
    return tuple(tuple(row) for row in output)
