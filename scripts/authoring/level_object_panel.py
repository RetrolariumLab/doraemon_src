"""Object overlay and direct-manipulation controls for Level Studio."""

from __future__ import annotations

import tkinter as tk
from tkinter import ttk

from scripts.authoring.level_area_palettes import world2_sprite_palette_record
from scripts.authoring.level_object_model import (
    MapObject,
    change_world1_type,
    change_world3_persistent_type,
    change_world3_transient_type,
    move_world1_object,
    move_world3_persistent_object,
    world1_objects,
    world2_inventory_selectors,
    world3_persistent_objects,
    world3_transient_objects,
)
from scripts.authoring.level_object_sprites import (
    SpriteBitmap,
    placeholder_bitmap,
    render_fixed_metasprite,
    render_variable_metasprite,
    world1_sprite_spec,
    world2_sprite_spec,
    world3_sprite_spec,
)


class LevelObjectPanelMixin:
    """Draw object ownership on maps and route edits to native documents."""

    def _build_object_toolbar(self) -> None:
        toolbar = ttk.Frame(self.root, padding=(6, 0, 6, 6))
        toolbar.pack(fill=tk.X)
        ttk.Label(toolbar, text="Edit mode").pack(side=tk.LEFT)
        self.edit_mode_box = ttk.Combobox(
            toolbar,
            textvariable=self.edit_mode_var,
            values=("Tiles", "Objects"),
            state="readonly",
            width=9,
        )
        self.edit_mode_box.pack(side=tk.LEFT, padx=(4, 12))
        self.edit_mode_box.bind(
            "<<ComboboxSelected>>", lambda _event: self._object_mode_changed()
        )
        ttk.Label(toolbar, textvariable=self.object_selection_var).pack(
            side=tk.LEFT, padx=(0, 10)
        )
        ttk.Label(toolbar, text="Type").pack(side=tk.LEFT)
        self.object_type_box = ttk.Combobox(
            toolbar,
            textvariable=self.object_type_var,
            state="disabled",
            width=8,
        )
        self.object_type_box.pack(side=tk.LEFT, padx=4)
        self.object_type_button = ttk.Button(
            toolbar,
            text="Apply type",
            command=lambda: self._guard(self._apply_object_type),
            state="disabled",
        )
        self.object_type_button.pack(side=tk.LEFT, padx=2)
        ttk.Label(
            toolbar,
            text=(
                "Objects: click to select, drag coordinate-bearing records; "
                "scheduled room spawns expose type only"
            ),
        ).pack(side=tk.LEFT, padx=12)

    def _object_mode_changed(self) -> None:
        self.selected_object = None
        self._sync_object_controls()
        self._draw_map()

    def _canvas_press(self, event: tk.Event[tk.Misc]) -> None:
        if self.edit_mode_var.get() == "Objects":
            self._guard(lambda: self._object_press(event))
        else:
            self._begin_stroke(event)

    def _canvas_drag(self, event: tk.Event[tk.Misc]) -> None:
        if self.edit_mode_var.get() == "Objects":
            self._object_drag(event)
        else:
            self._extend_stroke(event)

    def _canvas_release(self, event: tk.Event[tk.Misc]) -> None:
        if self.edit_mode_var.get() == "Objects":
            self._guard(lambda: self._object_release(event))
        else:
            self._finish_stroke(event)

    def _object_type_values(self, marker: MapObject) -> tuple[str, ...]:
        if marker.kind == "world1-placement":
            values = (*range(0x10), *range(0x80, 0x90), *range(0xC0, 0xD0))
        elif marker.kind == "world2-spawn":
            values = range(0x0F)
        elif marker.kind == "world3-persistent":
            values = range(0x20)
        elif marker.kind == "world3-transient":
            values = range(0x10)
        else:
            values = ()
        return tuple(f"${value:02X}" for value in values)

    def _sync_object_controls(self) -> None:
        marker = self.selected_object
        values = self._object_type_values(marker) if marker is not None else ()
        if marker is None:
            self.object_selection_var.set("No object selected")
            self.object_type_var.set("")
        else:
            location = (
                f"room ${marker.room:02X} " if marker.room is not None else ""
            )
            self.object_selection_var.set(
                f"{marker.kind} #{marker.index} {location}"
            )
            self.object_type_var.set(f"${marker.type_id:02X}")
        state = "readonly" if values else "disabled"
        self.object_type_box.configure(values=values, state=state)
        self.object_type_button.configure(
            state="normal" if values else "disabled"
        )

    def _sprite_photo(
        self,
        bitmap: SpriteBitmap,
        key: tuple[object, ...],
        scale: int,
    ) -> tk.PhotoImage:
        cache_key = (*key, scale)
        image = self.object_image_cache.get(cache_key)
        if image is not None:
            return image
        native = tk.PhotoImage(
            master=self.root,
            width=bitmap.width,
            height=bitmap.height,
        )
        for y, row in enumerate(bitmap.pixels):
            for x, color in enumerate(row):
                if color is not None:
                    native.put(color, (x, y))
        image = native if scale == 1 else native.zoom(scale, scale)
        self.object_image_cache[cache_key] = image
        return image

    def _object_bitmap(
        self, marker: MapObject
    ) -> tuple[SpriteBitmap, tuple[object, ...]]:
        if marker.kind == "world1-placement":
            objects = self.object_documents["world1_object_placements"].document
            spec = world1_sprite_spec(
                marker.type_id, objects, self.world1_enemy_handlers
            )
            palette_id = self._world1_map_palette(
                marker.map_id,
                marker.native_x // 32,
                marker.native_y // 32,
            )
            bitmap = render_variable_metasprite(
                self.graphics_documents["world1_metasprites"].document,
                self.sprite_tiles["world1"],
                self.palettes["world1"][palette_id],
                spec,
            )
            key = ("world1", marker.type_id, palette_id, spec.hidden)
        elif marker.kind == "world2-spawn":
            spec = world2_sprite_spec(marker.type_id, self.world2_enemy_identities)
            palette_id = world2_sprite_palette_record(
                marker.map_id,
                self.graphics_documents["world2_palettes"].document,
            )
            bitmap = render_fixed_metasprite(
                self.graphics_documents["world2_metasprites"].document,
                self.sprite_tiles["world2"],
                self.palettes["world2"][palette_id],
                spec,
            )
            key = ("world2", marker.type_id, palette_id)
        else:
            objects = self.object_documents["world3_object_catalog"].document
            spec = world3_sprite_spec(marker.type_id, objects)
            palette_id = self._world3_room_palette(int(marker.room))
            bitmap = render_variable_metasprite(
                self.graphics_documents["world3_metasprites"].document,
                self.sprite_tiles["world3"],
                self.palettes["world3"][palette_id],
                spec,
            )
            key = ("world3", marker.type_id, palette_id)
        return (bitmap or placeholder_bitmap(marker.hidden), key)

    def _draw_sprite_marker(
        self,
        marker: MapObject,
        canvas_x: int,
        canvas_y: int,
        scale: int,
        count: int | None = None,
    ) -> None:
        bitmap, key = self._object_bitmap(marker)
        image = self._sprite_photo(bitmap, key, scale)
        x = canvas_x + bitmap.offset_x * scale
        y = canvas_y + bitmap.offset_y * scale
        sprite = self.map_canvas.create_image(
            x,
            y,
            image=image,
            anchor=tk.NW,
            tags="object-overlay",
        )
        selected = (
            self.selected_object is not None
            and marker.key == self.selected_object.key
        )
        border = self.map_canvas.create_rectangle(
            x - 1,
            y - 1,
            x + max(1, bitmap.width * scale) + 1,
            y + max(1, bitmap.height * scale) + 1,
            fill="",
            outline="#ffffff" if selected else "#101010",
            width=3 if selected else 1,
            dash=(3, 2) if marker.hidden else (),
            tags="object-overlay",
        )
        self.object_hit_items[sprite] = marker
        self.object_hit_items[border] = marker
        if count is not None:
            label = self.map_canvas.create_text(
                x + bitmap.width * scale,
                y,
                text=f"×{count}",
                fill="#ffffff",
                anchor=tk.NE,
                font=("TkFixedFont", max(7, 7 * self.zoom), "bold"),
                tags="object-overlay",
            )
            self.object_hit_items[label] = marker

    def _draw_object_overlays(self) -> None:
        self.map_canvas.delete("object-overlay")
        previous_key = (
            self.selected_object.key if self.selected_object is not None else None
        )
        self.object_hit_items.clear()
        current: list[MapObject] = []
        if self.world_id == "world1":
            current.extend(
                world1_objects(
                    self.object_documents["world1_object_placements"].document,
                    self.map_id,
                )
            )
            for marker in current:
                self._draw_sprite_marker(
                    marker,
                    marker.native_x * self.zoom,
                    marker.native_y * self.zoom,
                    self.zoom,
                )
        elif self.world_id == "world2":
            current.extend(self._world2_spawn_markers())
            for marker in current:
                x = marker.native_x * self.block_size
                y = marker.native_y * self.block_size
                self._draw_sprite_marker(
                    marker,
                    x,
                    y,
                    self.zoom,
                )
            self._draw_world2_inventory_badges()
        elif self.world_id == "world3":
            persistent = world3_persistent_objects(
                self.object_documents["world3_object_catalog"].document
            )
            transient = world3_transient_objects(
                self.object_documents["world3_transient_spawns"].document
            )
            current.extend((*persistent, *transient))
            for marker in persistent:
                self._draw_sprite_marker(
                    marker,
                    marker.native_x * self.zoom,
                    marker.native_y * self.zoom,
                    self.zoom,
                )
            for marker in transient:
                self._draw_sprite_marker(
                    marker,
                    marker.native_x * self.zoom,
                    marker.native_y * self.zoom,
                    self.zoom,
                    count=marker.count,
                )
        self.selected_object = next(
            (marker for marker in current if marker.key == previous_key), None
        )
        self._sync_object_controls()

    def _world2_spawn_markers(self) -> tuple[MapObject, ...]:
        result: list[MapObject] = []
        geometry = self.world2_routes[self.map_id]
        for placement in geometry.visible_placements():
            selector = placement.selector_id
            origin_x, origin_y = geometry.origin(placement)
            index = 0
            cells = self.world2_model.oriented_screen(
                selector,
                placement.direction,
            )
            for y, row in enumerate(cells):
                for x, cell in enumerate(row):
                    if cell.token_kind != "spawn":
                        continue
                    raw_x, raw_y = self.world2_model.raw_coordinate(
                        selector,
                        placement.direction,
                        x,
                        y,
                    )
                    result.append(
                        MapObject(
                            kind="world2-spawn",
                            index=index,
                            type_id=int(cell.enemy_state),
                            native_x=origin_x + x,
                            native_y=origin_y + y,
                            map_id=self.map_id,
                            selector=selector,
                            cell_x=raw_x,
                            cell_y=raw_y,
                            palette_index=placement.palette_index,
                        )
                    )
                    index += 1
        return tuple(result)

    def _draw_world2_inventory_badges(self) -> None:
        selectors = world2_inventory_selectors(
            self.object_documents["world2_inventory_spawns"].document
        )
        geometry = self.world2_routes[self.map_id]
        for placement in geometry.visible_placements():
            if placement.selector_id not in selectors:
                continue
            origin_x, origin_y = geometry.origin(placement)
            bitmap = placeholder_bitmap(hidden=True)
            image = self._sprite_photo(
                bitmap,
                ("world2-secret", placement.selector_id),
                self.zoom,
            )
            self.map_canvas.create_image(
                (origin_x + 16) * self.block_size - 2,
                origin_y * self.block_size + 2,
                image=image,
                anchor=tk.NE,
                tags="object-overlay",
            )

    def _object_at(self, event: tk.Event[tk.Misc]) -> MapObject | None:
        x = self.map_canvas.canvasx(event.x)
        y = self.map_canvas.canvasy(event.y)
        for item in reversed(self.map_canvas.find_overlapping(x - 5, y - 5, x + 5, y + 5)):
            marker = self.object_hit_items.get(item)
            if marker is not None:
                return marker
        return None

    def _object_press(self, event: tk.Event[tk.Misc]) -> None:
        self.selected_object = self._object_at(event)
        self.drag_source = self.selected_object
        self._sync_object_controls()
        self._draw_object_overlays()

    def _object_drag(self, event: tk.Event[tk.Misc]) -> None:
        if self.drag_source is None or not self.drag_source.movable:
            return
        self.map_canvas.delete("object-drag-preview")
        x = self.map_canvas.canvasx(event.x)
        y = self.map_canvas.canvasy(event.y)
        radius = max(8, 8 * self.zoom)
        self.map_canvas.create_oval(
            x - radius,
            y - radius,
            x + radius,
            y + radius,
            outline="#ffdf40",
            width=2,
            dash=(3, 2),
            tags="object-drag-preview",
        )

    def _object_release(self, event: tk.Event[tk.Misc]) -> None:
        marker = self.drag_source
        self.drag_source = None
        self.map_canvas.delete("object-drag-preview")
        if marker is None or not marker.movable:
            return
        if marker.kind == "world1-placement":
            document = self.object_documents["world1_object_placements"]
            width, height = self.model.map_size(self.map_id)
            native_x = round(self.map_canvas.canvasx(event.x) / self.zoom)
            native_y = round(self.map_canvas.canvasy(event.y) / self.zoom)
            changed = document.change(
                lambda data: move_world1_object(
                    data,
                    self.map_id,
                    marker.index,
                    native_x,
                    native_y,
                    width * 32,
                    height * 32,
                )
            )
            owner = document
        elif marker.kind == "world3-persistent":
            document = self.object_documents["world3_object_catalog"]
            native_x = round(self.map_canvas.canvasx(event.x) / self.zoom)
            native_y = round(self.map_canvas.canvasy(event.y) / self.zoom)
            changed = document.change(
                lambda data: move_world3_persistent_object(
                    data, marker.index, native_x, native_y
                )
            )
            owner = document
        elif marker.kind == "world2-spawn":
            target = self._map_target(event)
            if target is None or target[0] is None:
                raise ValueError("drop the World 2 spawn on a background route cell")
            selector, x, y = target
            changed = bool(
                self.world2_model.move_spawn(
                    int(marker.selector),
                    int(marker.cell_x),
                    int(marker.cell_y),
                    selector,
                    x,
                    y,
                )
            )
            owner = self.world2_model
            self.selected_object = None
        else:
            return
        if changed:
            self.history_model = owner
            self.status_var.set("Moved object; save with Ctrl+S")
            self._draw_map()
            self._refresh_title()

    def _apply_object_type(self) -> None:
        marker = self.selected_object
        if marker is None:
            return
        type_id = int(self.object_type_var.get().removeprefix("$"), 16)
        if marker.kind == "world1-placement":
            owner = self.object_documents["world1_object_placements"]
            changed = owner.change(
                lambda data: change_world1_type(
                    data, marker.map_id, marker.index, type_id
                )
            )
        elif marker.kind == "world2-spawn":
            owner = self.world2_model
            changed = bool(
                owner.edit_spawn(
                    int(marker.selector),
                    int(marker.cell_x),
                    int(marker.cell_y),
                    type_id,
                )
            )
        elif marker.kind == "world3-persistent":
            owner = self.object_documents["world3_object_catalog"]
            changed = owner.change(
                lambda data: change_world3_persistent_type(
                    data, marker.index, type_id
                )
            )
        elif marker.kind == "world3-transient":
            owner = self.object_documents["world3_transient_spawns"]
            changed = owner.change(
                lambda data: change_world3_transient_type(
                    data, int(marker.room), int(marker.channel), type_id
                )
            )
        else:
            return
        if changed:
            self.history_model = owner
            self.status_var.set("Changed object type; save with Ctrl+S")
            self._draw_map()
            self._refresh_title()
