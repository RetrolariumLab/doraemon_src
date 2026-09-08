"""Optional raster rendering helpers for World 3 metasprite evidence."""

from __future__ import annotations

from pathlib import Path
from typing import Any


FLIP_VALUES = {
    "none": 0,
    "horizontal": 1,
    "vertical": 2,
    "horizontal_vertical": 3,
}

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


def render_entity_type_sheet(
    chr_data: bytes,
    manifest: dict[str, Any],
    entity_types: dict[str, Any],
    data: dict[str, bytes],
    entries: list[dict[str, Any]],
    records: list[dict[str, Any]],
    output: Path,
    palette_id: int,
) -> None:
    """Render four animation indexes for every decoded World 3 entity type."""
    try:
        from PIL import Image, ImageDraw
    except ImportError as exc:
        raise ValueError("Pillow is required for the metasprite renderer") from exc
    palette_count = int(manifest["palettes"]["count"])
    if not 0 <= palette_id < palette_count:
        raise ValueError("World 3 render palette is outside the catalog")
    tables = {
        str(table["name"]): table["values"]
        for table in entity_types["property_tables"]
    }
    bases = [int(value, 0) if isinstance(value, str) else value for value in tables["metasprite_base"]]
    flags = [int(value, 0) if isinstance(value, str) else value for value in tables["render_flags"]]
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
