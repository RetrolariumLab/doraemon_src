"""Resolve and rasterize the initial object sprites shown by Level Studio."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Any, Sequence

from scripts.authoring.level_studio_rendering import NES_RGB


Pixel = str | None
Tile = tuple[tuple[int, ...], ...]


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


@dataclass(frozen=True)
class SpriteSpec:
    metasprite_index: int | None
    palette_row: int
    hidden: bool = False


@dataclass(frozen=True)
class SpriteBitmap:
    pixels: tuple[tuple[Pixel, ...], ...]
    offset_x: int = 0
    offset_y: int = 0

    @property
    def width(self) -> int:
        return len(self.pixels[0]) if self.pixels else 0

    @property
    def height(self) -> int:
        return len(self.pixels)


def world1_sprite_spec(
    placement_type: int,
    object_document: dict[str, Any],
    handler_document: dict[str, Any],
) -> SpriteSpec:
    hidden = bool(placement_type & 0x40)
    if placement_type < 0x80:
        state = next(
            (
                entry
                for entry in handler_document["states"]
                if entry.get("placement_type") == placement_type
            ),
            None,
        )
        if state is None:
            return SpriteSpec(None, 0, hidden)
        return SpriteSpec(
            number(state["initial_metasprite"]),
            number(state["initial_render_flags"]) & 3,
            hidden,
        )

    descriptor_id = placement_type & 0x0F
    records = object_document["descriptor_objects"]["records"]
    if descriptor_id >= len(records):
        return SpriteSpec(None, 0, hidden)
    descriptor = records[descriptor_id]
    metasprite = number(descriptor["metasprite_base"])
    # The weapon-upgrade descriptor substitutes the first weapon frame at runtime.
    if descriptor_id == 5 and metasprite == 0:
        metasprite = 0x2A
    return SpriteSpec(
        metasprite,
        number(descriptor["render_flags"]) & 3,
        hidden,
    )


def world2_sprite_spec(
    physical_state: int,
    identity_document: dict[str, Any],
) -> SpriteSpec:
    runtime_state = physical_state + 1
    identity = next(
        (
            entry
            for entry in identity_document["identities"]
            if int(entry["state"]) == runtime_state
        ),
        None,
    )
    indexes = identity.get("metasprite_indexes", []) if identity else []
    return SpriteSpec(int(indexes[0]) if indexes else None, 0)


def world3_sprite_spec(
    type_id: int,
    object_document: dict[str, Any],
) -> SpriteSpec:
    records = object_document["entity_types"]["records"]
    if not 0 <= type_id < len(records):
        return SpriteSpec(None, 0)
    record = records[type_id]
    return SpriteSpec(
        number(record["metasprite_base"]),
        number(record["render_flags"]) & 3,
    )


def _sprite_colors(palette: Sequence[int], palette_row: int) -> tuple[str, ...]:
    base = 16 + palette_row * 4 if len(palette) >= 32 else palette_row * 4
    if base + 4 > len(palette):
        raise ValueError("sprite palette row is outside the selected palette")
    return tuple(NES_RGB[int(palette[base + value]) & 0x3F] for value in range(4))


def _empty_pixels(width: int, height: int) -> list[list[Pixel]]:
    return [[None for _x in range(width)] for _y in range(height)]


def _blit_tile(
    pixels: list[list[Pixel]],
    tile: Tile,
    colors: Sequence[str],
    x0: int,
    y0: int,
    flip_x: bool,
    flip_y: bool,
) -> None:
    for y in range(8):
        source_y = 7 - y if flip_y else y
        for x in range(8):
            source_x = 7 - x if flip_x else x
            value = tile[source_y][source_x]
            if value and pixels[y0 + y][x0 + x] is None:
                pixels[y0 + y][x0 + x] = colors[value]


def _dither(bitmap: SpriteBitmap) -> SpriteBitmap:
    return SpriteBitmap(
        tuple(
            tuple(pixel if (x + y) % 2 == 0 else None for x, pixel in enumerate(row))
            for y, row in enumerate(bitmap.pixels)
        ),
        bitmap.offset_x,
        bitmap.offset_y,
    )


def render_variable_metasprite(
    document: dict[str, Any],
    tiles: Sequence[Tile],
    palette: Sequence[int],
    spec: SpriteSpec,
) -> SpriteBitmap | None:
    if spec.metasprite_index is None:
        return None
    entries = document["index_entries"]
    if not 0 <= spec.metasprite_index < len(entries):
        return None
    entry = entries[spec.metasprite_index]
    flip_mode = 0
    if entry["kind"] == "alias":
        flip_mode = (
            "none",
            "horizontal",
            "vertical",
            "horizontal_vertical",
        ).index(entry["flip"])
        source = int(entry["source_index"])
        if not 0 <= source < len(entries) or entries[source]["kind"] != "direct":
            return None
        entry = entries[source]
    address = number(entry["metasprite_address"])
    record = next(
        (item for item in document["metasprites"] if number(item["address"]) == address),
        None,
    )
    if record is None:
        return None

    extent_x = number(record["x_mirror_extent"])
    extent_y = number(record["y_mirror_extent"])
    resolved: list[tuple[int, int, int, bool, bool]] = []
    for piece in record["pieces"]:
        raw_x, raw_y = number(piece["x_offset"]), number(piece["y_offset"])
        x, y = raw_x & 0x7F, raw_y & 0x7F
        piece_flip_x, piece_flip_y = bool(raw_x & 0x80), bool(raw_y & 0x80)
        if flip_mode & 1:
            x, piece_flip_x = extent_x - x, not piece_flip_x
        if flip_mode & 2:
            y, piece_flip_y = extent_y - y, not piece_flip_y
        resolved.append((x, y, number(piece["tile"]), piece_flip_x, piece_flip_y))
    if not resolved:
        return None

    min_x = min(item[0] for item in resolved)
    min_y = min(item[1] for item in resolved)
    max_x = max(item[0] for item in resolved) + 8
    max_y = max(item[1] for item in resolved) + 8
    pixels = _empty_pixels(max_x - min_x, max_y - min_y)
    colors = _sprite_colors(palette, spec.palette_row)
    for x, y, tile_id, flip_x, flip_y in resolved:
        if not 0 <= tile_id < len(tiles):
            return None
        _blit_tile(
            pixels,
            tiles[tile_id],
            colors,
            x - min_x,
            y - min_y,
            flip_x,
            flip_y,
        )
    bitmap = SpriteBitmap(tuple(tuple(row) for row in pixels), min_x, min_y)
    return _dither(bitmap) if spec.hidden else bitmap


def render_fixed_metasprite(
    document: dict[str, Any],
    tiles: Sequence[Tile],
    palette: Sequence[int],
    spec: SpriteSpec,
) -> SpriteBitmap | None:
    if spec.metasprite_index is None:
        return None
    records = document["metasprites"]
    if not 0 <= spec.metasprite_index < len(records):
        return None
    record = records[spec.metasprite_index]
    attributes = document["oam_attributes"]
    base = number(record["attribute_base"])
    colors = _sprite_colors(palette, int(record["palette"]))
    pixels = _empty_pixels(16, 16)
    for piece_id, tile_value in enumerate(record["tiles"]):
        tile_id = number(tile_value)
        if tile_id == 0:
            continue
        attribute_id = base + piece_id
        if not 0 <= tile_id < len(tiles) or not 0 <= attribute_id < len(attributes):
            return None
        attribute = number(attributes[attribute_id]["value"])
        _blit_tile(
            pixels,
            tiles[tile_id],
            colors,
            (piece_id & 1) * 8,
            (piece_id >> 1) * 8,
            bool(attribute & 0x40),
            bool(attribute & 0x80),
        )
    bitmap = SpriteBitmap(tuple(tuple(row) for row in pixels))
    return _dither(bitmap) if spec.hidden else bitmap


def placeholder_bitmap(hidden: bool = False) -> SpriteBitmap:
    """Return a graphical marker for a runtime object with no OAM frame."""

    pixels = _empty_pixels(16, 16)
    color = "#ffd24a" if hidden else "#ff6b78"
    for y in range(2, 14):
        half_width = min(y - 1, 14 - y, 6)
        for x in range(8 - half_width, 9 + half_width):
            if x in (8 - half_width, 8 + half_width) or y in (2, 13):
                pixels[y][x] = color
    for x, y in ((7, 6), (8, 5), (9, 6), (8, 7), (8, 10)):
        pixels[y][x] = color
    bitmap = SpriteBitmap(tuple(tuple(row) for row in pixels))
    return _dither(bitmap) if hidden else bitmap
