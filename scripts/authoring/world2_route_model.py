"""Tutorial-route geometry derived from native World 2 stage bytecode."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Any

WORLD2_ROUTE_NAMES = ("Part 1", "Part 2", "Part 2A", "Part 2B", "Part 3")
ROUTE_SCREEN_WIDTH = 16
ROUTE_SCREEN_HEIGHT = 15
DIRECTION_STEPS = {
    0: (1, 0),
    1: (0, -1),
    2: (0, 1),
    3: (-1, 0),
}

@dataclass(frozen=True)
class World2RoutePlacement:
    sequence_offset: int
    selector_id: int
    direction: int
    screen_x: int
    screen_y: int
    palette_index: int


@dataclass(frozen=True)
class World2RouteAnnotation:
    screen_x: int
    screen_y: int
    text: str


@dataclass(frozen=True)
class World2RouteGeometry:
    """One tutorial-style World 2 route assembled from stage bytecode."""

    name: str
    placements: tuple[World2RoutePlacement, ...]
    annotations: tuple[World2RouteAnnotation, ...] = ()

    @property
    def min_x(self) -> int:
        return min(placement.screen_x for placement in self.placements)

    @property
    def min_y(self) -> int:
        return min(placement.screen_y for placement in self.placements)

    @property
    def max_x(self) -> int:
        return max(placement.screen_x for placement in self.placements)

    @property
    def max_y(self) -> int:
        return max(placement.screen_y for placement in self.placements)

    @property
    def width(self) -> int:
        return (self.max_x - self.min_x + 1) * ROUTE_SCREEN_WIDTH

    @property
    def height(self) -> int:
        return (self.max_y - self.min_y + 1) * ROUTE_SCREEN_HEIGHT

    def origin(self, placement: World2RoutePlacement) -> tuple[int, int]:
        return (
            (placement.screen_x - self.min_x) * ROUTE_SCREEN_WIDTH,
            (placement.screen_y - self.min_y) * ROUTE_SCREEN_HEIGHT,
        )

    def visible_placements(self) -> tuple[World2RoutePlacement, ...]:
        """Return one editable face for each physical screen coordinate."""

        occupied: set[tuple[int, int]] = set()
        result = []
        for placement in self.placements:
            coordinate = (placement.screen_x, placement.screen_y)
            if coordinate in occupied:
                continue
            occupied.add(coordinate)
            result.append(placement)
        return tuple(result)

    def placements_at(
        self, placement: World2RoutePlacement
    ) -> tuple[World2RoutePlacement, ...]:
        return tuple(
            item
            for item in self.placements
            if (item.screen_x, item.screen_y)
            == (placement.screen_x, placement.screen_y)
        )

    def locate(
        self, x: int, y: int
    ) -> tuple[World2RoutePlacement, int, int] | None:
        if not 0 <= x < self.width or not 0 <= y < self.height:
            return None
        screen_x = x // ROUTE_SCREEN_WIDTH + self.min_x
        screen_y = y // ROUTE_SCREEN_HEIGHT + self.min_y
        placement = next(
            (
                item
                for item in self.visible_placements()
                if (item.screen_x, item.screen_y) == (screen_x, screen_y)
            ),
            None,
        )
        if placement is None:
            return None
        return (
            placement,
            x % ROUTE_SCREEN_WIDTH,
            y % ROUTE_SCREEN_HEIGHT,
        )


def _route_number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def _walk_route(
    entries: list[dict[str, Any]],
    start: int,
    end: int,
    palette_index: int,
) -> tuple[World2RoutePlacement, ...]:
    x = y = 0
    direction = 0
    result = []
    for entry in entries[start:end + 1]:
        command = entry["command"]
        if command == "set_pending_direction":
            direction = int(entry["direction"])
            if direction not in DIRECTION_STEPS:
                raise ValueError("World 2 route direction is outside 0-3")
            if result:
                dx, dy = DIRECTION_STEPS[direction]
                x = result[-1].screen_x + dx
                y = result[-1].screen_y + dy
        elif command == "set_background_palette":
            palette_id = int(entry["palette_id"])
            palette_index = max(0, palette_id - 1)
        elif command == "select_screen":
            selector_id = _route_number(entry["screen_id"])
            if selector_id <= 0x76:
                result.append(
                    World2RoutePlacement(
                        int(entry["offset"]),
                        selector_id,
                        direction,
                        x,
                        y,
                        palette_index,
                    )
                )
            dx, dy = DIRECTION_STEPS[direction]
            x += dx
            y += dy
    return tuple(result)


def _translate_route(
    placements: tuple[World2RoutePlacement, ...],
    x: int,
    y: int,
) -> tuple[World2RoutePlacement, ...]:
    if not placements:
        return ()
    origin = placements[0]
    return tuple(
        World2RoutePlacement(
            item.sequence_offset,
            item.selector_id,
            item.direction,
            item.screen_x - origin.screen_x + x,
            item.screen_y - origin.screen_y + y,
            item.palette_index,
        )
        for item in placements
    )


def _placement_for_selector(
    placements: tuple[World2RoutePlacement, ...], selector_id: int
) -> World2RoutePlacement:
    try:
        return next(
            item for item in placements if item.selector_id == selector_id
        )
    except StopIteration as exc:
        raise ValueError(
            f"World 2 route has no selector ${selector_id:02X}"
        ) from exc


def _attach_branch(
    main: tuple[World2RoutePlacement, ...],
    branch: tuple[World2RoutePlacement, ...],
    trigger_selector: int,
) -> tuple[World2RoutePlacement, ...]:
    if not branch:
        return main
    trigger = _placement_for_selector(main, trigger_selector)
    dx, dy = DIRECTION_STEPS[branch[0].direction]
    return (
        *main,
        *_translate_route(
            branch,
            trigger.screen_x + dx,
            trigger.screen_y + dy,
        ),
    )


def build_world2_routes(
    stage_document: dict[str, Any],
    branch_document: dict[str, Any],
    palette_document: dict[str, Any],
) -> dict[str, World2RouteGeometry]:
    """Build the five tutorial-style views from native route control data."""

    entries = stage_document.get("entries")
    starts = [int(value) for value in stage_document.get("start_offsets", [])]
    branches = branch_document.get("branches")
    chapters = palette_document.get("chapters")
    if not isinstance(entries, list) or not isinstance(branches, list):
        raise ValueError("World 2 route documents are incomplete")
    if starts != [0, 37, 92] or not isinstance(chapters, list) or len(chapters) != 3:
        raise ValueError("World 2 route start or palette tables differ")
    initial_palettes = [
        int(chapter["background_palette_id"]) - 1 for chapter in chapters
    ]
    destinations = sorted(
        {
            _route_number(branch["destination_offset"])
            for branch in branches
            if _route_number(branch["destination_offset"]) >= 134
        }
    )
    if destinations != [134, 144, 154, 162, 180, 192, 202, 212, 215, 223]:
        raise ValueError("World 2 branch route boundaries differ")
    span_ends = {
        start: (
            destinations[index + 1] - 1
            if index + 1 < len(destinations)
            else len(entries) - 1
        )
        for index, start in enumerate(destinations)
    }

    part1_main = _walk_route(
        entries, starts[0], starts[1] - 1, initial_palettes[0]
    )
    part2_main = _walk_route(
        entries, starts[1], starts[2] - 1, initial_palettes[1]
    )
    part3_main = _walk_route(
        entries, starts[2], destinations[0] - 1, initial_palettes[2]
    )

    by_destination = {
        _route_number(branch["destination_offset"]): branch for branch in branches
    }
    part1 = part1_main
    for destination in (134, 144, 154):
        trigger = _route_number(by_destination[destination]["trigger_screen_id"])
        trigger_placement = _placement_for_selector(part1_main, trigger)
        branch = _walk_route(
            entries,
            destination,
            span_ends[destination],
            trigger_placement.palette_index,
        )
        part1 = _attach_branch(part1, branch, trigger)

    part3 = part3_main
    for destination in (215, 223):
        trigger = _route_number(by_destination[destination]["trigger_screen_id"])
        trigger_placement = _placement_for_selector(part3_main, trigger)
        branch = _walk_route(
            entries,
            destination,
            span_ends[destination],
            trigger_placement.palette_index,
        )
        part3 = _attach_branch(part3, branch, trigger)

    part2a = _walk_route(entries, 162, span_ends[162], initial_palettes[1])
    part2b_routes = tuple(
        _walk_route(
            entries,
            destination,
            span_ends[destination],
            initial_palettes[1],
        )
        for destination in (180, 192, 202, 212)
    )
    part2b = tuple(item for route in part2b_routes for item in route)

    main_annotations: list[World2RouteAnnotation] = []
    for branch in branches:
        destination = _route_number(branch["destination_offset"])
        subpart = (
            "Part 2A"
            if destination == 162
            else (
                "Part 2B"
                if destination in (180, 192, 202, 212)
                else None
            )
        )
        if subpart is None:
            continue
        trigger_id = _route_number(branch["trigger_screen_id"])
        trigger = _placement_for_selector(part2_main, trigger_id)
        main_annotations.append(
            World2RouteAnnotation(
                trigger.screen_x,
                trigger.screen_y,
                f"{subpart} entrance",
            )
        )
        return_value = branch.get("return_offset_override")
        return_offset = (
            trigger.sequence_offset
            if return_value is None
            else _route_number(return_value)
        )
        exit_placement = next(
            (item for item in part2_main if item.sequence_offset > return_offset),
            part2_main[-1],
        )
        main_annotations.append(
            World2RouteAnnotation(
                exit_placement.screen_x,
                exit_placement.screen_y,
                f"{subpart} exit",
            )
        )

    def endpoint_annotations(
        name: str, placements: tuple[World2RoutePlacement, ...]
    ) -> tuple[World2RouteAnnotation, ...]:
        return (
            World2RouteAnnotation(
                placements[0].screen_x, placements[0].screen_y, f"{name} entrance"
            ),
            World2RouteAnnotation(
                placements[-1].screen_x, placements[-1].screen_y, f"{name} exit"
            ),
        )

    return {
        "Part 1": World2RouteGeometry("Part 1", part1),
        "Part 2": World2RouteGeometry("Part 2", part2_main, tuple(main_annotations)),
        "Part 2A": World2RouteGeometry(
            "Part 2A", part2a, endpoint_annotations("Part 2A", part2a)
        ),
        "Part 2B": World2RouteGeometry(
            "Part 2B", part2b, endpoint_annotations("Part 2B", part2b_routes[0])
        ),
        "Part 3": World2RouteGeometry("Part 3", part3),
    }
