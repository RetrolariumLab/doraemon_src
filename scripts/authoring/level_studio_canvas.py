"""Scrollable map-canvas behavior shared by Doraemon Level Studio."""

from __future__ import annotations

import tkinter as tk

from scripts.authoring.level_area_palettes import world1_area_palette


WORLD_NAMES = {world_id: f"World {world_id[-1]}" for world_id in ("world1", "world3")}
MAP_NAMES = {
    "city": "City",
    "underground": "Underground",
    "underwater": "Underwater",
}


class LevelStudioCanvasMixin:
    """Render the three world formats without bloating the UI controller."""

    def _world3_room_palette(self, room: int) -> int:
        entries = self.graphics_documents["world3_metasprites"].document[
            "room_palettes"
        ]
        if not 0 <= room < len(entries) or int(entries[room]["room"]) != room:
            raise ValueError("World 3 room palette table is not contiguous")
        return int(entries[room]["palette"])

    def _world1_map_palette(self, map_id: str, x: int, y: int) -> int:
        rooms = self.object_documents["world1_underground_rooms"].document
        return world1_area_palette(map_id, x, y, rooms)

    def _sync_world3_palette_selector(self) -> None:
        room = int(self.room_var.get(), 16)
        self.palette_var.set(str(self._world3_room_palette(room)))

    def _room_changed(self) -> None:
        if self.world_id != "world3":
            return
        self._sync_world3_palette_selector()
        room = int(self.room_var.get(), 16)
        column, row = room & 7, room >> 3
        width, height = self.model.map_size(self.map_id)
        self._draw_palette()
        self._draw_map()
        self.map_canvas.xview_moveto((column * 8) / width)
        self.map_canvas.yview_moveto((row * 8) / height)

    def _select_room_from_map(self, event: tk.Event[tk.Misc]) -> str | None:
        if self.world_id != "world3":
            return None
        x, y = self._map_coordinate(event)
        room = (y // 8) * 8 + x // 8
        if 0 <= room < 64:
            self.room_var.set(f"{room:02X}")
            self._room_changed()
        return "break"

    def _draw_map(self) -> None:
        def draw() -> None:
            self.map_canvas.delete("all")
            self.map_items.clear()
            if self.world_id == "world2":
                self._draw_world2_route()
                return
            rows = self.model.map_rows(self.map_id)
            size = self.block_size
            default_images = self._images(self.zoom)
            for y, row in enumerate(rows):
                for x, block in enumerate(row):
                    images = default_images
                    if self.world_id == "world1":
                        images = self._images(
                            self.zoom,
                            self._world1_map_palette(self.map_id, x, y),
                        )
                    elif self.world_id == "world3":
                        room = (y // 8) * 8 + x // 8
                        images = self._images(
                            self.zoom, self._world3_room_palette(room)
                        )
                    item = self.map_canvas.create_image(
                        x * size,
                        y * size,
                        image=images[block],
                        anchor=tk.NW,
                    )
                    self.map_items[(x, y)] = item
            width, height = self.model.map_size(self.map_id)
            name = f"{WORLD_NAMES[self.world_id]} / {MAP_NAMES[self.map_id]}"
            if self.world_id == "world3":
                selected = int(self.room_var.get(), 16)
                for room in range(64):
                    column, room_row = room & 7, room >> 3
                    x0, y0 = column * 8 * size, room_row * 8 * size
                    self.map_canvas.create_rectangle(
                        x0,
                        y0,
                        x0 + 8 * size,
                        y0 + 8 * size,
                        outline="#ffdf40" if room == selected else "#54a8ff",
                        width=3 if room == selected else 1,
                        tags="room-grid",
                    )
                    self.map_canvas.create_text(
                        x0 + 4,
                        y0 + 4,
                        text=f"R{room:02X} P{self._world3_room_palette(room):02d}",
                        fill="#ffffff",
                        anchor=tk.NW,
                        font=("TkFixedFont", 8, "bold"),
                        tags="room-grid",
                    )
            self._draw_object_overlays()
            self.map_canvas.configure(
                scrollregion=(0, 0, width * size, height * size)
            )
            self.status_var.set(
                f"{name}: {width}x{height} big blocks"
            )

        self._guard(draw)

    def _draw_world2_route(self) -> None:
        size = self.block_size
        geometry = self.world2_routes[self.map_id]
        arrows = ("→", "↑", "↓", "←")
        for placement in geometry.visible_placements():
            origin_x, origin_y = geometry.origin(placement)
            cells = self.world2_model.oriented_screen(
                placement.selector_id,
                placement.direction,
            )
            images = self._images(self.zoom, placement.palette_index)
            for y, row in enumerate(cells):
                for x, cell in enumerate(row):
                    canvas_x = (origin_x + x) * size
                    canvas_y = (origin_y + y) * size
                    self.map_canvas.create_image(
                        canvas_x,
                        canvas_y,
                        image=images[cell.metatile],
                        anchor=tk.NW,
                    )
            self.map_canvas.create_rectangle(
                origin_x * size,
                origin_y * size,
                (origin_x + 16) * size,
                (origin_y + 15) * size,
                outline="#7186a0",
                width=1,
            )
            labels = "/".join(
                f"{item.selector_id:02X}"
                for item in geometry.placements_at(placement)
            )
            self.map_canvas.create_text(
                origin_x * size + 3,
                origin_y * size + 3,
                text=f"S{labels} {arrows[placement.direction]}",
                fill="#ffffff",
                anchor=tk.NW,
                font=("TkFixedFont", max(7, 7 * self.zoom), "bold"),
                tags="route-label",
            )
        for annotation in geometry.annotations:
            canvas_x = (
                (annotation.screen_x - geometry.min_x) * 16 + 8
            ) * size
            canvas_y = (
                (annotation.screen_y - geometry.min_y) * 15 + 2
            ) * size
            item = self.map_canvas.create_text(
                canvas_x,
                canvas_y,
                text=annotation.text,
                fill="#ffe45c",
                anchor=tk.N,
                font=("TkFixedFont", max(8, 8 * self.zoom), "bold"),
                tags="route-annotation",
            )
            bounds = self.map_canvas.bbox(item)
            if bounds is not None:
                background = self.map_canvas.create_rectangle(
                    bounds[0] - 3,
                    bounds[1] - 2,
                    bounds[2] + 3,
                    bounds[3] + 2,
                    fill="#16202b",
                    outline="#ffe45c",
                    tags="route-annotation",
                )
                self.map_canvas.tag_lower(background, item)
        self.map_canvas.configure(
            scrollregion=(0, 0, geometry.width * size, geometry.height * size)
        )
        self._draw_object_overlays()
        self.status_var.set(
            f"World 2 / {geometry.name}: {len(geometry.placements)} route "
            f"occurrences, {len(geometry.visible_placements())} physical panels"
        )

    def _map_coordinate(self, event: tk.Event[tk.Misc]) -> tuple[int, int]:
        x = int(self.map_canvas.canvasx(event.x) // self.block_size)
        y = int(self.map_canvas.canvasy(event.y) // self.block_size)
        return x, y

    def _map_target(
        self, event: tk.Event[tk.Misc]
    ) -> tuple[int | None, int, int] | None:
        x, y = self._map_coordinate(event)
        if self.world_id != "world2":
            return None, x, y
        geometry = self.world2_routes[self.map_id]
        located = geometry.locate(x, y)
        if located is None:
            return None
        placement, local_x, local_y = located
        raw_x, raw_y = self.world2_model.raw_coordinate(
            placement.selector_id,
            placement.direction,
            local_x,
            local_y,
        )
        return placement.selector_id, raw_x, raw_y
