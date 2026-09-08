#!/usr/bin/env python3
"""Deterministically repack independently editable World 2 screen views."""

from __future__ import annotations

from dataclasses import dataclass
from functools import lru_cache
import heapq
from typing import Any, Sequence

import sys
from pathlib import Path


SCRIPTS = Path(__file__).resolve().parent.parent
if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))

from scripts.validation.world2 import world2_streaming


@dataclass(frozen=True)
class EncodedScreen:
    data: bytes
    roles: str


@dataclass
class Chunk:
    data: bytes
    roles: str
    members: dict[int, int]


def _normal(cell: Any) -> bool:
    return cell.token_kind in ("literal", "rle")


def encode_row(row: Sequence[Any], minimum_cells: int) -> EncodedScreen:
    """Find the smallest legal tokenization that preserves one decoded row."""

    width = len(row)
    if width < minimum_cells:
        raise ValueError(
            f"World 2 row has {width} cells, below minimum {minimum_cells}"
        )

    @lru_cache(maxsize=None)
    def solve(index: int) -> tuple[bytes, str] | None:
        if index == width:
            return b"", ""
        if index >= minimum_cells:
            return None
        cell = row[index]
        candidates: list[tuple[bytes, str]] = []

        def append(raw: bytes, roles: str, next_index: int) -> None:
            if next_index >= minimum_cells and next_index != width:
                return
            suffix = solve(next_index)
            if suffix is not None:
                candidates.append((raw + suffix[0], roles + suffix[1]))

        if cell.token_kind == "padding":
            if width != 16 or any(
                other.token_kind != "padding" for other in row[index:]
            ):
                raise ValueError("World 2 row-end padding must be one suffix to width 16")
            append(bytes((0xEF,)), "T", width)
        elif cell.token_kind == "spawn":
            state = cell.enemy_state
            if state is None or not 0 <= state < 0x1F:
                raise ValueError("World 2 enemy state is outside $00-$1E")
            append(bytes((0xD0 + state,)), "T", index + 1)
        elif _normal(cell):
            value = int(cell.metatile)
            if not 0 <= value < 0xD0:
                raise ValueError("World 2 metatile is outside $00-$CF")
            append(bytes((value,)), "T", index + 1)
            run = 1
            while (
                run < 16
                and index + run < width
                and _normal(row[index + run])
                and int(row[index + run].metatile) == value
            ):
                run += 1
                if run >= 2:
                    append(bytes((0xF0 + run - 1, value)), "TO", index + run)
        else:
            raise ValueError(f"unsupported World 2 logical cell: {cell.token_kind}")

        if not candidates:
            return None
        return min(candidates, key=lambda candidate: (len(candidate[0]), candidate[0]))

    encoded = solve(0)
    if encoded is None:
        raise ValueError(
            "World 2 row cannot preserve its overrun width after this edit"
        )
    return EncodedScreen(*encoded)


def encode_screen(
    rows: Sequence[Sequence[Any]],
    rows_per_screen: int,
    minimum_cells: int,
) -> EncodedScreen:
    if len(rows) != rows_per_screen:
        raise ValueError(
            f"World 2 screen has {len(rows)} rows, expected {rows_per_screen}"
        )
    encoded_rows = [encode_row(row, minimum_cells) for row in rows]
    return EncodedScreen(
        b"".join(row.data for row in encoded_rows),
        "".join(row.roles for row in encoded_rows),
    )


def _placement(left: Chunk, right: Chunk) -> tuple[int, int]:
    """Return reusable byte count and right member placement in left."""

    start = 0
    while True:
        position = left.data.find(right.data, start)
        if position < 0:
            break
        if left.roles[position:position + len(right.roles)] == right.roles:
            return len(right.data), position
        start = position + 1
    limit = min(len(left.data), len(right.data))
    for overlap in range(limit, 0, -1):
        if (
            left.data[-overlap:] == right.data[:overlap]
            and left.roles[-overlap:] == right.roles[:overlap]
        ):
            return overlap, len(left.data) - overlap
    return 0, len(left.data)


def pack_screens(screens: Sequence[EncodedScreen]) -> tuple[bytes, str, list[int]]:
    """Greedy shortest-superstring packing with token-boundary compatibility."""

    active: dict[int, Chunk] = {}
    for selector_id, screen in enumerate(screens):
        if len(screen.data) != len(screen.roles) or set(screen.roles) - {"T", "O"}:
            raise ValueError("World 2 encoded screen has invalid byte roles")
        active[selector_id] = Chunk(screen.data, screen.roles, {selector_id: 0})
    next_id = len(active)
    queue: list[tuple[int, int, int, int]] = []

    def queue_pair(left_id: int, right_id: int) -> None:
        overlap, _position = _placement(active[left_id], active[right_id])
        if overlap:
            heapq.heappush(queue, (-overlap, left_id, right_id, next_id))

    ids = list(active)
    for left_id in ids:
        for right_id in ids:
            if left_id != right_id:
                queue_pair(left_id, right_id)

    while queue:
        negative_overlap, left_id, right_id, _generation = heapq.heappop(queue)
        if left_id not in active or right_id not in active:
            continue
        left, right = active[left_id], active[right_id]
        overlap, position = _placement(left, right)
        if overlap != -negative_overlap:
            continue
        data = left.data if overlap == len(right.data) else left.data + right.data[overlap:]
        roles = left.roles if overlap == len(right.data) else left.roles + right.roles[overlap:]
        members = dict(left.members)
        for selector_id, offset in right.members.items():
            members[selector_id] = position + offset
        del active[left_id]
        del active[right_id]
        merged_id = next_id
        next_id += 1
        active[merged_id] = Chunk(data, roles, members)
        for other_id in tuple(active):
            if other_id != merged_id:
                queue_pair(merged_id, other_id)
                queue_pair(other_id, merged_id)

    pointers = [0] * len(screens)
    output = bytearray()
    roles = ""
    for chunk in sorted(active.values(), key=lambda item: min(item.members)):
        base = len(output)
        output.extend(chunk.data)
        roles += chunk.roles
        for selector_id, offset in chunk.members.items():
            pointers[selector_id] = base + offset
    return bytes(output), roles, pointers


def token_records(region: bytes, roles: str) -> list[str]:
    if len(region) != len(roles):
        raise ValueError("World 2 packed region and byte roles differ in size")
    records: list[str] = []
    offset = 0
    while offset < len(region):
        if roles[offset] != "T":
            raise ValueError(f"World 2 orphan RLE operand at ${offset:04X}")
        value = region[offset]
        if value < 0xD0:
            records.append(f"{offset:04X}:L:{value:02X}")
            offset += 1
        elif value < 0xEF:
            records.append(f"{offset:04X}:S:{value:02X}")
            offset += 1
        elif value == 0xEF:
            records.append(f"{offset:04X}:E")
            offset += 1
        elif value == 0xF0:
            raise ValueError("World 2 repacker produced reserved $F0 token")
        else:
            if offset + 1 >= len(region) or roles[offset + 1] != "O":
                raise ValueError(f"World 2 RLE token at ${offset:04X} has no operand")
            operand = region[offset + 1]
            if operand >= 0xD0:
                raise ValueError("World 2 repacker produced invalid RLE operand")
            records.append(f"{offset:04X}:R:{value:02X}:{operand:02X}")
            offset += 2
    return records


def repack_document(
    source: dict[str, Any],
    logical_screens: Sequence[Sequence[Sequence[Any]]],
) -> dict[str, Any]:
    rows_per_screen = int(source["rows_per_screen"])
    minimum_cells = int(source["minimum_cells_per_row"])
    region_size = int(source["region_size"])
    selector_count = len(source["selectors"])
    if len(logical_screens) != selector_count:
        raise ValueError("World 2 logical selector count differs from source")
    encoded = [
        encode_screen(rows, rows_per_screen, minimum_cells)
        for rows in logical_screens
    ]
    packed, roles, pointer_offsets = pack_screens(encoded)
    original = world2_streaming.encode_authoring(source)
    original_region = original[selector_count * 2:]
    vector_low = original_region[-1]
    if vector_low >= 0xD0:
        raise ValueError("World 2 vector-overlap byte cannot be safe filler")
    if len(packed) > region_size - 1:
        raise ValueError(
            f"World 2 repack needs {len(packed) + 1} bytes, capacity is {region_size}"
        )
    filler_size = region_size - 1 - len(packed)
    region = packed + bytes(filler_size) + bytes((vector_low,))
    roles += "T" * (filler_size + 1)
    region_address = world2_streaming.number(source["region_address"])
    pointers = [region_address + offset for offset in pointer_offsets]
    selectors: list[dict[str, Any]] = []
    first_selector: dict[int, int] = {}
    for selector_id, pointer in enumerate(pointers):
        errors, screen = world2_streaming.decode_screen(
            region,
            pointer - region_address,
            rows_per_screen,
            minimum_cells,
        )
        if errors:
            raise ValueError(
                f"repacked selector {selector_id}: " + "; ".join(errors)
            )
        first = first_selector.setdefault(pointer, selector_id)
        selectors.append({
            "id": selector_id,
            "address": f"0x{pointer:04X}",
            "alias_of": None if first == selector_id else first,
            "rows": [world2_streaming.row_text(row) for row in screen.rows],
        })
    pointer_data = b"".join(pointer.to_bytes(2, "little") for pointer in pointers)
    result = {
        "schema_version": 1,
        "format": "world2-compressed-screens",
        "pointer_table_address": source["pointer_table_address"],
        "region_address": source["region_address"],
        "region_size": region_size,
        "rows_per_screen": rows_per_screen,
        "minimum_cells_per_row": minimum_cells,
        "payload_crc32": world2_streaming.crc32(pointer_data + region),
        "selectors": selectors,
        "tokens": token_records(region, roles),
    }
    if world2_streaming.encode_authoring(result) != pointer_data + region:
        raise ValueError("World 2 repacked authoring document is not lossless")
    return result
