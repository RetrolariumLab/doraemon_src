"""Map-space views and safe edits for Doraemon's object authoring records."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Any


WORLD1_LISTS = {
    "city": "world1_city_objects",
    "underground": "world1_underground_objects",
}
WORLD1_SORTED_TAIL = 45
WORLD3_ROOM_PIXELS = 256
WORLD3_ROOM_COLUMNS = 8


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def hex_byte(value: int) -> str:
    if not 0 <= value <= 0xFF:
        raise ValueError("object value is outside byte range")
    return f"0x{value:02X}"


@dataclass(frozen=True)
class MapObject:
    kind: str
    index: int
    type_id: int
    native_x: int
    native_y: int
    map_id: str
    room: int | None = None
    channel: int | None = None
    selector: int | None = None
    cell_x: int | None = None
    cell_y: int | None = None
    palette_index: int | None = None
    count: int = 1
    movable: bool = True
    hidden: bool = False

    @property
    def key(
        self,
    ) -> tuple[str, int, int | None, int | None, int | None, int | None]:
        return (
            self.kind,
            self.index,
            self.channel,
            self.selector,
            self.cell_x,
            self.cell_y,
        )


def _world1_list(document: dict[str, Any], map_id: str) -> dict[str, Any]:
    expected = WORLD1_LISTS.get(map_id)
    if expected is None:
        raise ValueError(f"World 1 has no object list for map {map_id!r}")
    matches = [
        item for item in document["placement_lists"] if item["id"] == expected
    ]
    if len(matches) != 1:
        raise ValueError(f"World 1 object list {expected!r} is missing or duplicated")
    return matches[0]


def world1_objects(document: dict[str, Any], map_id: str) -> tuple[MapObject, ...]:
    placement = _world1_list(document, map_id)
    return tuple(
        MapObject(
            kind="world1-placement",
            index=int(record["id"]),
            type_id=number(record["type"]),
            native_x=int(record["x_cell"]) * 8,
            native_y=int(record["y_cell"]) * 8,
            map_id=map_id,
            hidden=bool(number(record["type"]) & 0x40),
        )
        for record in placement["records"]
    )


def move_world1_object(
    document: dict[str, Any],
    map_id: str,
    index: int,
    native_x: int,
    native_y: int,
    map_width: int,
    map_height: int,
) -> None:
    placement = _world1_list(document, map_id)
    records = placement["records"]
    if not 0 <= index < len(records):
        raise IndexError("World 1 object index is outside its placement list")
    max_x = min(0xFF, (map_width - 1) // 8)
    max_y = min(0xFF, (map_height - 1) // 8)
    x_cell = max(1, min(max_x, (native_x + 4) // 8))
    y_cell = max(0, min(max_y, (native_y + 4) // 8))
    if map_id == "city" and index >= WORLD1_SORTED_TAIL:
        lower = int(records[index - 1]["x_cell"])
        upper = (
            int(records[index + 1]["x_cell"])
            if index + 1 < len(records)
            else max_x
        )
        x_cell = max(lower, min(upper, x_cell))
    records[index]["x_cell"] = x_cell
    records[index]["y_cell"] = y_cell


def change_world1_type(
    document: dict[str, Any], map_id: str, index: int, type_id: int
) -> None:
    records = _world1_list(document, map_id)["records"]
    if not 0 <= index < len(records):
        raise IndexError("World 1 object index is outside its placement list")
    records[index]["type"] = hex_byte(type_id)


def world3_persistent_objects(document: dict[str, Any]) -> tuple[MapObject, ...]:
    records = document["persistent_registry"]["records"]
    result: list[MapObject] = []
    for record in records:
        room = number(record["room"])
        result.append(
            MapObject(
                kind="world3-persistent",
                index=int(record["id"]),
                type_id=number(record["type"]),
                native_x=(room & 7) * WORLD3_ROOM_PIXELS + number(record["x"]),
                native_y=(room >> 3) * WORLD3_ROOM_PIXELS + number(record["y"]),
                map_id="underwater",
                room=room,
            )
        )
    return tuple(result)


def move_world3_persistent_object(
    document: dict[str, Any], index: int, native_x: int, native_y: int
) -> None:
    records = document["persistent_registry"]["records"]
    if not 0 <= index < len(records):
        raise IndexError("World 3 persistent object index is outside the registry")
    map_limit = WORLD3_ROOM_PIXELS * WORLD3_ROOM_COLUMNS - 1
    x = max(0, min(map_limit, native_x))
    y = max(0, min(map_limit, native_y))
    room = (y // WORLD3_ROOM_PIXELS) * WORLD3_ROOM_COLUMNS + (
        x // WORLD3_ROOM_PIXELS
    )
    record = records[index]
    record["room"] = hex_byte(room)
    record["x"] = hex_byte(x % WORLD3_ROOM_PIXELS)
    record["y"] = hex_byte(y % WORLD3_ROOM_PIXELS)


def change_world3_persistent_type(
    document: dict[str, Any], index: int, type_id: int
) -> None:
    if not 0 <= type_id < int(document["entity_types"]["type_count"]):
        raise ValueError("World 3 persistent type is outside $00-$1F")
    records = document["persistent_registry"]["records"]
    if not 0 <= index < len(records):
        raise IndexError("World 3 persistent object index is outside the registry")
    records[index]["type"] = hex_byte(type_id)


def world3_transient_objects(document: dict[str, Any]) -> tuple[MapObject, ...]:
    result: list[MapObject] = []
    for room_entry in document["rooms"]:
        room = number(room_entry["room_id"])
        for channel in room_entry["channels"]:
            count = int(channel["count"])
            if count == 0:
                continue
            channel_id = int(channel["channel"])
            result.append(
                MapObject(
                    kind="world3-transient",
                    index=room,
                    channel=channel_id,
                    type_id=number(channel["type"]),
                    native_x=(room & 7) * WORLD3_ROOM_PIXELS + 12 + channel_id * 42,
                    native_y=(room >> 3) * WORLD3_ROOM_PIXELS + 28,
                    map_id="underwater",
                    room=room,
                    count=count,
                    movable=False,
                )
            )
    return tuple(result)


def change_world3_transient_type(
    document: dict[str, Any], room: int, channel: int, type_id: int
) -> None:
    if not 0 <= type_id <= 0x0F:
        raise ValueError("World 3 transient type is outside $00-$0F")
    rooms = document["rooms"]
    if not 0 <= room < len(rooms) or number(rooms[room]["room_id"]) != room:
        raise IndexError("World 3 transient room is outside the schedule")
    channels = rooms[room]["channels"]
    if not 0 <= channel < len(channels) or int(channels[channel]["channel"]) != channel:
        raise IndexError("World 3 transient channel is outside the schedule")
    channels[channel]["type"] = hex_byte(type_id)


def world2_inventory_selectors(document: dict[str, Any]) -> frozenset[int]:
    return frozenset(
        number(entry["screen_id"]) for entry in document["eligible_screens"]
    )
