#!/usr/bin/env python3
"""Graphical editor for Doraemon's hierarchical exploration maps."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys
import tkinter as tk
from tkinter import messagebox, ttk
from typing import Callable


SCRIPTS = Path(__file__).resolve().parent.parent
if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))

from scripts.authoring.level_studio_model import (
    CANONICAL_WORLDS,
    HierarchicalWorldDocument,
    LevelWorkspace,
)
from scripts.authoring.world2_level_model import (
    WORLD2_ROUTE_NAMES,
    World2ScreenDocument,
    build_world2_routes,
    initialize_workspace as initialize_world2_workspace,
    workspace_path as world2_workspace_path,
)
from scripts.authoring.level_studio_rendering import (
    decode_background_tiles,
    decode_sprite_tiles,
    load_world2_metatiles,
    parse_palette_catalog,
    parse_world2_palette_catalog,
    render_big_block,
    render_world2_metatile,
)
from scripts.authoring.graphics_artifacts import PrgGraphicsWorkspace
from scripts.authoring.level_studio_canvas import LevelStudioCanvasMixin
from scripts.authoring.level_object_panel import LevelObjectPanelMixin
from scripts.authoring.object_artifacts import ObjectWorkspace


PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent
WORLD_IDS = ("world1", "world2", "world3")
CHR_BANKS = {"world1": 0, "world2": 1, "world3": 2}
def _resolved(project_root: Path, path: Path) -> Path:
    return path if path.is_absolute() else project_root / path


def _photo_image(
    master: tk.Misc,
    pixels: tuple[tuple[str, ...], ...],
    scale: int,
) -> tk.PhotoImage:
    width = len(pixels[0])
    height = len(pixels)
    image = tk.PhotoImage(master=master, width=width, height=height)
    image.put(" ".join("{" + " ".join(row) + "}" for row in pixels))
    return image if scale == 1 else image.zoom(scale, scale)


class LevelStudioApp(LevelStudioCanvasMixin, LevelObjectPanelMixin):
    def __init__(
        self,
        root: tk.Tk,
        project_root: Path,
        workspace: LevelWorkspace,
        chr_path: Path,
    ) -> None:
        self.root = root
        self.project_root = project_root
        self.workspace = workspace
        self.workspace.initialize()
        self.models = {
            world_id: self.workspace.load(world_id)
            for world_id in CANONICAL_WORLDS
        }
        initialize_world2_workspace(project_root, workspace.root, workspace.profile)
        self.world2_model = World2ScreenDocument.load(
            world2_workspace_path(workspace.root, workspace.profile)
        )
        self.graphics_workspace = PrgGraphicsWorkspace(
            project_root, workspace.root, workspace.profile
        )
        self.graphics_workspace.initialize()
        self.graphics_documents = self.graphics_workspace.load()
        self.world2_routes = build_world2_routes(
            self._load_json("data/world2/stage_sequence.json"),
            self._load_json("data/world2/stage_branches.json"),
            self.graphics_documents["world2_palettes"].document,
        )
        self.object_workspace = ObjectWorkspace(
            project_root, workspace.root, workspace.profile
        )
        self.object_workspace.initialize()
        self.object_documents = self.object_workspace.load()
        self.world1_enemy_handlers = self._load_json(
            "config/reconstruction/world1/world1_enemy_handlers.json"
        )
        self.world2_enemy_identities = self._load_json(
            "config/authoring/world2/world2_enemy_identities.json"
        )
        try:
            chr_data = chr_path.read_bytes()
        except OSError as exc:
            raise ValueError(
                f"cannot read CHR data {chr_path}: {exc}; run 'make split' first"
            ) from exc
        self.tiles = {
            world_id: decode_background_tiles(chr_data, bank)
            for world_id, bank in CHR_BANKS.items()
        }
        self.sprite_tiles = {
            world_id: decode_sprite_tiles(chr_data, bank)
            for world_id, bank in CHR_BANKS.items()
        }
        self.palettes = {
            "world1": parse_palette_catalog(
                self.graphics_documents["world1_palettes"].document
            ),
            "world2": parse_world2_palette_catalog(
                self.graphics_documents["world2_palettes"].document
            ),
            "world3": parse_palette_catalog(
                self.graphics_documents["world3_metasprites"].document
            ),
        }
        self.world2_metatiles = load_world2_metatiles(project_root)
        self.image_cache: dict[
            tuple[str, int, int], tuple[tk.PhotoImage, ...]
        ] = {}
        self.object_image_cache: dict[tuple[object, ...], tk.PhotoImage] = {}
        self.map_items: dict[tuple[int, int], int] = {}
        self.stroke: dict[tuple[int | None, int, int], int] = {}
        self.selected_block = 0
        self.history_model: object | None = None
        self.selected_object = None
        self.drag_source = None
        self.object_hit_items: dict[int, object] = {}

        self.world_var = tk.StringVar(value="world1")
        self.map_var = tk.StringVar(value="city")
        self.palette_var = tk.StringVar(value="0")
        self.room_var = tk.StringVar(value="00")
        self.edit_mode_var = tk.StringVar(value="Tiles")
        self.object_type_var = tk.StringVar()
        self.object_selection_var = tk.StringVar(value="No object selected")
        self.zoom_var = tk.StringVar(value="1x")
        self.selection_var = tk.StringVar(value="Big block $00")
        self.status_var = tk.StringVar(value="Ready")

        self._build_ui()
        self._bind_shortcuts()
        self._world_changed()
        self.root.protocol("WM_DELETE_WINDOW", self._close)

    def _load_json(self, relative_path: str) -> dict:
        path = self.project_root / relative_path
        try:
            return json.loads(path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as exc:
            raise ValueError(f"cannot load {path}: {exc}") from exc

    @property
    def world_id(self) -> str:
        return self.world_var.get()

    @property
    def model(self) -> HierarchicalWorldDocument:
        return self.models[self.world_id]

    @property
    def map_id(self) -> str:
        return self.map_var.get()

    @property
    def zoom(self) -> int:
        return int(self.zoom_var.get().removesuffix("x"))

    @property
    def block_size(self) -> int:
        return (16 if self.world_id == "world2" else 32) * self.zoom

    def _all_models(
        self,
    ) -> tuple[HierarchicalWorldDocument | World2ScreenDocument, ...]:
        return (*self.models.values(), self.world2_model)

    def _all_edit_documents(self) -> tuple[object, ...]:
        return (
            *self._all_models(),
            *self.graphics_documents.values(),
            *self.object_documents.values(),
        )

    def _build_ui(self) -> None:
        self.root.title("Doraemon Level Studio")
        self.root.geometry("1320x860")
        self.root.minsize(900, 600)

        toolbar = ttk.Frame(self.root, padding=6)
        toolbar.pack(fill=tk.X)
        ttk.Label(toolbar, text="World").pack(side=tk.LEFT)
        self.world_box = ttk.Combobox(
            toolbar,
            textvariable=self.world_var,
            values=WORLD_IDS,
            state="readonly",
            width=9,
        )
        self.world_box.pack(side=tk.LEFT, padx=(4, 12))
        self.world_box.bind(
            "<<ComboboxSelected>>", lambda _event: self._world_changed()
        )
        ttk.Label(toolbar, text="Map").pack(side=tk.LEFT)
        self.map_box = ttk.Combobox(
            toolbar, textvariable=self.map_var, state="readonly", width=14
        )
        self.map_box.pack(side=tk.LEFT, padx=(4, 12))
        self.map_box.bind("<<ComboboxSelected>>", lambda _event: self._draw_map())
        ttk.Label(toolbar, text="Room").pack(side=tk.LEFT)
        self.room_box = ttk.Combobox(
            toolbar,
            textvariable=self.room_var,
            values=tuple(f"{room:02X}" for room in range(64)),
            state="disabled",
            width=4,
        )
        self.room_box.pack(side=tk.LEFT, padx=(4, 12))
        self.room_box.bind(
            "<<ComboboxSelected>>", lambda _event: self._room_changed()
        )
        ttk.Label(toolbar, text="Palette set").pack(side=tk.LEFT)
        self.palette_box = ttk.Combobox(
            toolbar, textvariable=self.palette_var, state="readonly", width=5
        )
        self.palette_box.pack(side=tk.LEFT, padx=(4, 12))
        self.palette_box.bind(
            "<<ComboboxSelected>>", lambda _event: self._palette_changed()
        )
        ttk.Label(toolbar, text="Zoom").pack(side=tk.LEFT)
        zoom_box = ttk.Combobox(
            toolbar,
            textvariable=self.zoom_var,
            values=("1x", "2x"),
            state="readonly",
            width=4,
        )
        zoom_box.pack(side=tk.LEFT, padx=(4, 12))
        zoom_box.bind("<<ComboboxSelected>>", lambda _event: self._draw_map())
        ttk.Button(toolbar, text="Undo", command=self._undo).pack(
            side=tk.LEFT, padx=2
        )
        ttk.Button(toolbar, text="Redo", command=self._redo).pack(
            side=tk.LEFT, padx=2
        )
        ttk.Button(toolbar, text="Save all", command=self._save).pack(
            side=tk.LEFT, padx=2
        )
        ttk.Button(toolbar, text="Validate", command=self._validate).pack(
            side=tk.LEFT, padx=2
        )

        self._build_object_toolbar()

        body = ttk.Panedwindow(self.root, orient=tk.HORIZONTAL)
        body.pack(fill=tk.BOTH, expand=True, padx=6, pady=(0, 6))
        map_frame = ttk.Frame(body)
        palette_frame = ttk.Frame(body, width=300)
        body.add(map_frame, weight=5)
        body.add(palette_frame, weight=1)

        self.map_canvas = tk.Canvas(map_frame, background="#202020")
        map_x = ttk.Scrollbar(
            map_frame, orient=tk.HORIZONTAL, command=self.map_canvas.xview
        )
        map_y = ttk.Scrollbar(
            map_frame, orient=tk.VERTICAL, command=self.map_canvas.yview
        )
        self.map_canvas.configure(xscrollcommand=map_x.set, yscrollcommand=map_y.set)
        self.map_canvas.grid(row=0, column=0, sticky="nsew")
        map_y.grid(row=0, column=1, sticky="ns")
        map_x.grid(row=1, column=0, sticky="ew")
        map_frame.rowconfigure(0, weight=1)
        map_frame.columnconfigure(0, weight=1)
        self.map_canvas.bind("<ButtonPress-1>", self._canvas_press)
        self.map_canvas.bind("<B1-Motion>", self._canvas_drag)
        self.map_canvas.bind("<ButtonRelease-1>", self._canvas_release)
        self.map_canvas.bind("<Shift-Button-1>", self._select_room_from_map)
        self.map_canvas.bind("<Button-3>", self._pick_from_map)

        ttk.Label(palette_frame, textvariable=self.selection_var).pack(
            fill=tk.X, padx=4, pady=(0, 4)
        )
        palette_body = ttk.Frame(palette_frame)
        palette_body.pack(fill=tk.BOTH, expand=True)
        self.palette_canvas = tk.Canvas(
            palette_body, background="#181818", width=256
        )
        palette_y = ttk.Scrollbar(
            palette_body, orient=tk.VERTICAL, command=self.palette_canvas.yview
        )
        self.palette_canvas.configure(yscrollcommand=palette_y.set)
        self.palette_canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        palette_y.pack(side=tk.RIGHT, fill=tk.Y)
        self.palette_canvas.bind("<Button-1>", self._choose_block)

        status = ttk.Label(
            self.root,
            textvariable=self.status_var,
            anchor=tk.W,
            padding=(6, 3),
        )
        status.pack(fill=tk.X)

    def _bind_shortcuts(self) -> None:
        self.root.bind("<Control-s>", lambda _event: self._save())
        self.root.bind("<Control-z>", lambda _event: self._undo())
        self.root.bind("<Control-y>", lambda _event: self._redo())

    def _guard(self, action: Callable[[], None]) -> None:
        try:
            action()
        except (OSError, ValueError, KeyError, TypeError, IndexError) as exc:
            messagebox.showerror("Doraemon Level Studio", str(exc), parent=self.root)
            self.status_var.set(f"Error: {exc}")

    def _images(
        self, scale: int, palette_index: int | None = None
    ) -> tuple[tk.PhotoImage, ...]:
        if palette_index is None:
            palette_index = int(self.palette_var.get())
        key = (self.world_id, palette_index, scale)
        if key not in self.image_cache:
            palette = self.palettes[self.world_id][palette_index]
            if self.world_id == "world2":
                self.image_cache[key] = tuple(
                    _photo_image(
                        self.root,
                        render_world2_metatile(
                            metatile,
                            self.tiles["world2"],
                            palette,
                        ),
                        scale,
                    )
                    for metatile in self.world2_metatiles
                )
            else:
                self.image_cache[key] = tuple(
                    _photo_image(
                        self.root,
                        render_big_block(
                            self.model,
                            block,
                            self.tiles[self.world_id],
                            palette,
                        ),
                        scale,
                    )
                    for block in range(256)
                )
        return self.image_cache[key]

    def _world_changed(self) -> None:
        map_ids = (
            WORLD2_ROUTE_NAMES
            if self.world_id == "world2"
            else self.model.map_ids
        )
        self.map_box.configure(values=map_ids)
        if self.map_var.get() not in map_ids:
            self.map_var.set(map_ids[0])
        palette_values = tuple(
            str(index) for index in range(len(self.palettes[self.world_id]))
        )
        self.palette_box.configure(values=palette_values)
        if self.palette_var.get() not in palette_values:
            self.palette_var.set("0")
        if self.world_id == "world3":
            self.room_box.configure(state="readonly")
            self._sync_world3_palette_selector()
        else:
            self.room_box.configure(state="disabled")
        block_count = 208 if self.world_id == "world2" else 256
        if self.selected_block >= block_count:
            self.selected_block = 0
        self._draw_palette()
        self._draw_map()
        self._refresh_title()

    def _palette_changed(self) -> None:
        if self.world_id == "world3":
            room = int(self.room_var.get(), 16)
            palette = int(self.palette_var.get())
            document = self.graphics_documents["world3_metasprites"]

            def assign(data: dict) -> None:
                entry = data["room_palettes"][room]
                if int(entry["room"]) != room:
                    raise ValueError("World 3 room palette IDs are not contiguous")
                entry["palette"] = palette

            if document.change(assign):
                self.history_model = document
                self.status_var.set(
                    f"Room ${room:02X} now uses palette preset {palette}; "
                    "save with Ctrl+S"
                )
                self._refresh_title()
        self._draw_palette()
        self._draw_map()

    def _draw_palette(self) -> None:
        self.palette_canvas.delete("all")
        images = self._images(2 if self.world_id == "world2" else 1)
        columns = 8
        for block, image in enumerate(images):
            x, y = (block % columns) * 32, (block // columns) * 32
            self.palette_canvas.create_image(x, y, image=image, anchor=tk.NW)
        rows = (len(images) + columns - 1) // columns
        self.palette_canvas.configure(scrollregion=(0, 0, columns * 32, rows * 32))
        self._draw_palette_selection()

    def _draw_palette_selection(self) -> None:
        self.palette_canvas.delete("selection")
        x = (self.selected_block % 8) * 32
        y = (self.selected_block // 8) * 32
        self.palette_canvas.create_rectangle(
            x,
            y,
            x + 32,
            y + 32,
            outline="#ffdf40",
            width=2,
            tags="selection",
        )
        self.selection_var.set(f"Big block ${self.selected_block:02X}")

    def _add_stroke_coordinate(self, event: tk.Event[tk.Misc]) -> None:
        target = self._map_target(event)
        if target is None:
            return
        selector_id, x, y = target
        if self.world_id == "world2":
            valid = selector_id is not None
        else:
            width, height = self.model.map_size(self.map_id)
            valid = 0 <= x < width and 0 <= y < height
        if valid:
            self.stroke[(selector_id, x, y)] = self.selected_block
            self.status_var.set(
                f"Brush ${self.selected_block:02X}: {len(self.stroke)} cell(s)"
            )

    def _begin_stroke(self, event: tk.Event[tk.Misc]) -> None:
        self.stroke.clear()
        self._add_stroke_coordinate(event)

    def _extend_stroke(self, event: tk.Event[tk.Misc]) -> None:
        if self.world_id == "world2":
            return
        self._add_stroke_coordinate(event)

    def _finish_stroke(self, _event: tk.Event[tk.Misc]) -> None:
        def finish() -> None:
            edits = tuple(
                (selector_id, x, y, block)
                for (selector_id, x, y), block in self.stroke.items()
            )
            self.stroke.clear()
            if not edits:
                return
            if self.world_id == "world2":
                selector_id, x, y, block = edits[0]
                if selector_id is None:
                    return
                affected = self.world2_model.paint(
                    selector_id, x, y, block
                )
                if not affected:
                    return
                self._draw_map()
                self.history_model = self.world2_model
                self._refresh_title()
                self.status_var.set(
                    f"Repacked one cell in {affected} identical selector view(s); "
                    "save with Ctrl+S"
                )
                return
            map_edits = tuple((x, y, block) for _selector, x, y, block in edits)
            if not self.model.paint_many(self.map_id, map_edits):
                return
            images = self._images(self.zoom)
            for _selector, x, y, block in edits:
                item = self.map_items[(x, y)]
                self.map_canvas.itemconfigure(item, image=images[block])
            self.history_model = self.model
            self._refresh_title()
            self.status_var.set(f"Painted {len(edits)} cell(s); save with Ctrl+S")

        self._guard(finish)

    def _pick_from_map(self, event: tk.Event[tk.Misc]) -> None:
        def pick() -> None:
            target = self._map_target(event)
            if target is None:
                return
            selector_id, x, y = target
            self.selected_block = (
                self.world2_model.cell(selector_id, x, y).metatile
                if self.world_id == "world2"
                else self.model.cell(self.map_id, x, y)
            )
            self._draw_palette_selection()
            self.status_var.set(
                f"Picked ${self.selected_block:02X} from ({x}, {y})"
            )

        self._guard(pick)

    def _choose_block(self, event: tk.Event[tk.Misc]) -> None:
        x = int(self.palette_canvas.canvasx(event.x) // 32)
        y = int(self.palette_canvas.canvasy(event.y) // 32)
        block = y * 8 + x
        block_count = 208 if self.world_id == "world2" else 256
        if 0 <= x < 8 and 0 <= block < block_count:
            self.selected_block = block
            self._draw_palette_selection()

    def _undo(self) -> None:
        model = self.history_model or (
            self.world2_model if self.world_id == "world2" else self.model
        )
        if model.undo():
            if model is self.graphics_documents["world3_metasprites"]:
                self._sync_world3_palette_selector()
            self._draw_map()
            self._refresh_title()

    def _redo(self) -> None:
        model = self.history_model or (
            self.world2_model if self.world_id == "world2" else self.model
        )
        if model.redo():
            if model is self.graphics_documents["world3_metasprites"]:
                self._sync_world3_palette_selector()
            self._draw_map()
            self._refresh_title()

    def _save(self) -> None:
        def save() -> None:
            saved = 0
            for model in self._all_edit_documents():
                if model.dirty:
                    model.save()
                    saved += 1
            self._refresh_title()
            self.status_var.set(f"Saved {saved} level document(s)")

        self._guard(save)

    def _validate(self) -> None:
        def validate() -> None:
            sizes = {
                world_id: len(model.encode())
                for world_id, model in self.models.items()
            }
            sizes["world2"] = len(self.world2_model.encode())
            room_palette_bytes = len(
                self.graphics_documents["world3_metasprites"].validate()
            )
            object_bytes = sum(
                len(document.validate())
                for document in self.object_documents.values()
            )
            detail = ", ".join(
                f"{key} {value} bytes" for key, value in sizes.items()
            )
            self.status_var.set(
                f"Valid: {detail}, World 3 graphics {room_palette_bytes} writes, "
                f"objects {object_bytes} writes"
            )
            messagebox.showinfo(
                "Doraemon Level Studio",
                f"All editable payloads are valid.\n\n{detail}\n"
                f"World 3 graphics: {room_palette_bytes} addressed writes\n"
                f"Objects: {object_bytes} addressed writes",
                parent=self.root,
            )

        self._guard(validate)

    def _refresh_title(self) -> None:
        marker = (
            " *"
            if any(model.dirty for model in self._all_edit_documents())
            else ""
        )
        self.root.title(
            f"Doraemon Level Studio [{self.workspace.profile}]{marker}"
        )

    def _close(self) -> None:
        if not any(model.dirty for model in self._all_edit_documents()):
            self.root.destroy()
            return
        choice = messagebox.askyesnocancel(
            "Doraemon Level Studio",
            "Save level changes before closing?",
            parent=self.root,
        )
        if choice is None:
            return
        if choice:
            self._save()
            if any(model.dirty for model in self._all_edit_documents()):
                return
        self.root.destroy()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project-root", type=Path, default=PROJECT_ROOT)
    parser.add_argument("--workspace", type=Path, default=Path("content/workspace"))
    parser.add_argument(
        "--profile", choices=("original", "rev_a"), default="original"
    )
    parser.add_argument(
        "--chr",
        type=Path,
        default=Path("assets/generated/chr/doraemon.chr"),
    )
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    project_root = args.project_root.resolve()
    workspace = LevelWorkspace(
        project_root,
        _resolved(project_root, args.workspace),
        args.profile,
    )
    try:
        if args.check:
            workspace.initialize()
            models = {
                world_id: workspace.load(world_id)
                for world_id in CANONICAL_WORLDS
            }
            initialize_world2_workspace(
                project_root, workspace.root, workspace.profile
            )
            world2 = World2ScreenDocument.load(
                world2_workspace_path(workspace.root, workspace.profile)
            )
            graphics_workspace = PrgGraphicsWorkspace(
                project_root, workspace.root, workspace.profile
            )
            graphics_workspace.initialize()
            graphics_documents = graphics_workspace.load()
            stage_document = json.loads(
                (project_root / "data/world2/stage_sequence.json").read_text(
                    encoding="utf-8"
                )
            )
            branch_document = json.loads(
                (project_root / "data/world2/stage_branches.json").read_text(
                    encoding="utf-8"
                )
            )
            routes = build_world2_routes(
                stage_document,
                branch_document,
                graphics_documents["world2_palettes"].document,
            )
            for route in routes.values():
                for placement in route.visible_placements():
                    cells = world2.oriented_screen(
                        placement.selector_id,
                        placement.direction,
                    )
                    if len(cells) != 15 or any(len(row) != 16 for row in cells):
                        raise ValueError(
                            f"{route.name} selector ${placement.selector_id:02X} "
                            "does not render as 16x15"
                        )
            object_workspace = ObjectWorkspace(
                project_root, workspace.root, workspace.profile
            )
            object_workspace.initialize()
            object_documents = object_workspace.load()
            chr_data = _resolved(project_root, args.chr).read_bytes()
            for world_id, bank in CHR_BANKS.items():
                decode_background_tiles(chr_data, bank)
            parse_palette_catalog(
                graphics_documents["world1_palettes"].document
            )
            parse_world2_palette_catalog(
                graphics_documents["world2_palettes"].document
            )
            parse_palette_catalog(
                graphics_documents["world3_metasprites"].document
            )
            load_world2_metatiles(project_root)
            sizes = {
                world_id: len(model.encode())
                for world_id, model in models.items()
            }
            sizes["world2"] = len(world2.encode())
            sizes["room-palette-graphics"] = len(
                graphics_documents["world3_metasprites"].validate()
            )
            sizes["object-writes"] = sum(
                len(document.validate()) for document in object_documents.values()
            )
            detail = ", ".join(
                f"{world_id} {size} bytes"
                for world_id, size in sizes.items()
            )
            print(
                f"[OK] Level Studio [{args.profile}]: {detail}; "
                f"{len(routes)} World 2 route views"
            )
            return 0
        root = tk.Tk()
        LevelStudioApp(
            root,
            project_root,
            workspace,
            _resolved(project_root, args.chr),
        )
    except (OSError, ValueError, KeyError, TypeError, tk.TclError) as exc:
        print(f"[ERROR] cannot start Doraemon Level Studio: {exc}")
        return 1
    root.mainloop()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
