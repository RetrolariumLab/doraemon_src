"""Runtime-backed palette ownership for Level Studio's composite maps."""

from __future__ import annotations

from typing import Any


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def world1_area_palette(
    map_id: str,
    cell_x: int,
    cell_y: int,
    underground_document: dict[str, Any],
) -> int:
    """Return the palette used by the area occupying one World 1 map cell."""

    if map_id == "city":
        # The cross-marked northern area ends before big-block row 22.
        return 1 if cell_y < 22 else 0
    if map_id != "underground":
        raise ValueError(f"World 1 has no palette layout for map {map_id!r}")

    anchors: dict[int, dict[int, int]] = {8: {0: 2}}
    for room in underground_document["rooms"]:
        room_id = int(room["room_id"])
        camera_x = number(room["camera_tile_x"])
        camera_y = number(room["camera_tile_y"])
        scroll_start = number(room["axis_scroll_start"])
        band = camera_y >> 2
        origin = ((camera_x - scroll_start) & 0xFF) >> 2
        # Duplicate entrances 5/6 and 7/8 address the same physical rooms and
        # use byte-identical palette records. Keep the lower room ID as owner.
        anchors.setdefault(band, {}).setdefault(origin, room_id + 3)

    bands = sorted(anchors)
    band = max((value for value in bands if value <= cell_y), default=bands[0])
    regions = anchors[band]
    starts = sorted(regions)
    start = max((value for value in starts if value <= cell_x), default=starts[0])
    return regions[start]


def world2_sprite_palette_record(
    route_name: str,
    palette_document: dict[str, Any],
) -> int:
    """Resolve a route view to its chapter-wide sprite palette record."""

    if route_name == "Part 1":
        chapter_id = 0
    elif route_name in ("Part 2", "Part 2A", "Part 2B"):
        chapter_id = 1
    elif route_name == "Part 3":
        chapter_id = 2
    else:
        raise ValueError(f"World 2 has no sprite palette for {route_name}")
    chapters = palette_document.get("chapters", [])
    if len(chapters) != 3:
        raise ValueError("World 2 chapter palette table is incomplete")
    return int(chapters[chapter_id]["sprite_palette_record"])
