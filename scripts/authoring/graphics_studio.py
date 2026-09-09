#!/usr/bin/env python3
"""Edit all four Doraemon CHR banks in a profile-aware Tkinter studio."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys
import tkinter as tk
from tkinter import messagebox, ttk
from typing import Sequence


SCRIPTS = Path(__file__).resolve().parent.parent
if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))

from scripts.authoring.graphics_studio_model import (
    ChrDocument,
    GraphicsWorkspace,
    global_tile_index,
)
from scripts.authoring.hierarchy_graphics_panel import HierarchyGraphicsPanel
from scripts.authoring.metasprite_graphics_panel import MetaspriteGraphicsPanel
from scripts.authoring.graphics_artifacts import (
    GraphicsArtifactDocument,
    PrgGraphicsWorkspace,
)
from scripts.authoring.level_studio_rendering import (
    NES_RGB,
    load_world2_palettes,
    load_world_palettes,
)
from scripts.authoring.level_studio_model import HierarchicalWorldDocument, LevelWorkspace
from scripts.authoring.studio_process import BuildLauncher, launch_content_build


PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent
NEUTRAL_PALETTE = (0x0F, 0x00, 0x10, 0x30) * 8


def preview_palettes(project_root: Path, chr_bank: int) -> tuple[tuple[int, ...], ...]:
    if chr_bank == 0:
        return load_world_palettes(project_root, "world1")
    if chr_bank == 1:
        return tuple(
            tuple(palette) + NEUTRAL_PALETTE[16:]
            for palette in load_world2_palettes(project_root)
        )
    if chr_bank == 2:
        return load_world_palettes(project_root, "world3")
    return (NEUTRAL_PALETTE,)


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def workspace_palettes(
    artifacts: dict[str, GraphicsArtifactDocument],
    chr_bank: int,
) -> tuple[tuple[int, ...], ...]:
    if chr_bank == 0:
        records = artifacts["world1_palettes"].document["palettes"]
        return tuple(tuple(bytes.fromhex(record["colors"])) for record in records)
    if chr_bank == 1:
        records = artifacts["world2_palettes"].document["palettes"]
        return tuple(
            tuple(number(value) for value in record["colors"])
            + NEUTRAL_PALETTE[16:]
            for record in records
        )
    if chr_bank == 2:
        records = artifacts["world3_metasprites"].document["palettes"]
        return tuple(
            tuple(number(value) for value in record["colors"])
            for record in records
        )
    return (NEUTRAL_PALETTE,)


def draw_tile(
    canvas: tk.Canvas,
    pixels: Sequence[Sequence[int]],
    x: int,
    y: int,
    scale: int,
    palette: Sequence[int],
) -> None:
    for row, values in enumerate(pixels):
        for column, value in enumerate(values):
            canvas.create_rectangle(
                x + column * scale,
                y + row * scale,
                x + (column + 1) * scale,
                y + (row + 1) * scale,
                fill=NES_RGB[palette[value] & 0x3F],
                outline="",
            )


class GraphicsStudio(tk.Tk):
    def __init__(
        self,
        document: ChrDocument,
        artifacts: dict[str, GraphicsArtifactDocument],
        hierarchies: dict[str, HierarchicalWorldDocument],
        project_root: Path,
        workspace_root: Path,
        profile: str,
        build_launcher: BuildLauncher = launch_content_build,
    ) -> None:
        super().__init__()
        self.document = document
        self.artifacts = artifacts
        self.hierarchies = hierarchies
        self.project_root = project_root
        self.workspace_root = workspace_root
        self.profile = profile
        self.build_launcher = build_launcher
        self.chr_bank = tk.IntVar(value=0)
        self.pattern_table = tk.IntVar(value=1)
        self.relative_tile = tk.IntVar(value=0)
        self.palette_set = tk.IntVar(value=0)
        self.palette_row = tk.IntVar(value=0)
        self.ink = tk.IntVar(value=1)
        self.palette_world = tk.IntVar(value=0)
        self.edit_palette_index = tk.IntVar(value=0)
        self.metatile_index = tk.IntVar(value=0)
        self.metatile_palette_set = tk.IntVar(value=0)
        self.metatile_palette = tk.IntVar(value=0)
        self.metatile_solid = tk.BooleanVar(value=False)
        self.metatile_tiles = [tk.IntVar(value=0) for _ in range(4)]
        self.metatile_reference = tk.StringVar()
        self.status = tk.StringVar()
        self.stroke = False
        self.title(f"Doraemon Graphics Studio [{profile}]")
        self.geometry("1120x720")
        self.minsize(930, 660)
        self.protocol("WM_DELETE_WINDOW", self.close)
        self.build_ui()
        self.load_metatile()
        self.refresh()

    @property
    def tile_index(self) -> int:
        return global_tile_index(
            self.chr_bank.get(),
            self.pattern_table.get(),
            self.relative_tile.get(),
        )

    def build_ui(self) -> None:
        toolbar = ttk.Frame(self, padding=7)
        toolbar.pack(fill="x")
        for label, command in (
            ("Undo", self.undo),
            ("Redo", self.redo),
            ("Restore tile", self.restore_tile),
            ("Save all", self.save),
            ("Build ROM", self.build_rom),
        ):
            ttk.Button(toolbar, text=label, command=command).pack(
                side="left", padx=2
            )

        notebook = ttk.Notebook(self)
        notebook.pack(fill="both", expand=True, padx=7)
        chr_tab = ttk.Frame(notebook)
        palette_tab = ttk.Frame(notebook, padding=8)
        metatile_tab = ttk.Frame(notebook, padding=8)
        hierarchy_tab = HierarchyGraphicsPanel(
            notebook,
            self.hierarchies,
            self.artifacts,
            self.document,
            self.refresh,
        )
        metasprite_tab = MetaspriteGraphicsPanel(
            notebook, self.artifacts, self.document, self.refresh
        )
        notebook.add(chr_tab, text="CHR tiles")
        notebook.add(palette_tab, text="Palettes")
        notebook.add(metatile_tab, text="World 2 metatiles")
        notebook.add(hierarchy_tab, text="World 1/3 hierarchies")
        notebook.add(metasprite_tab, text="Metasprites")
        self.hierarchy_panel = hierarchy_tab
        self.metasprite_panel = metasprite_tab

        selectors = ttk.Frame(chr_tab, padding=(7, 0, 7, 4))
        selectors.pack(fill="x")
        ttk.Label(selectors, text="CHR bank:").pack(side="left")
        for bank in range(4):
            ttk.Radiobutton(
                selectors,
                text=str(bank),
                variable=self.chr_bank,
                value=bank,
                command=self.change_bank,
            ).pack(side="left", padx=3)
        ttk.Separator(selectors, orient="vertical").pack(
            side="left", fill="y", padx=10
        )
        for label, table in (("Sprites $0000", 0), ("Background $1000", 1)):
            ttk.Radiobutton(
                selectors,
                text=label,
                variable=self.pattern_table,
                value=table,
                command=self.change_table,
            ).pack(side="left", padx=4)
        ttk.Label(selectors, text="Palette set:").pack(side="left", padx=(16, 3))
        self.palette_box = ttk.Combobox(selectors, state="readonly", width=8)
        self.palette_box.pack(side="left")
        self.palette_box.bind("<<ComboboxSelected>>", self.change_palette)
        ttk.Label(selectors, text="row:").pack(side="left", padx=(10, 3))
        for row in range(4):
            ttk.Radiobutton(
                selectors,
                text=str(row),
                variable=self.palette_row,
                value=row,
                command=self.refresh,
            ).pack(side="left")

        body = ttk.Panedwindow(chr_tab, orient="horizontal")
        body.pack(fill="both", expand=True, padx=7)
        atlas_frame = ttk.LabelFrame(body, text="256-tile pattern table", padding=5)
        editor_frame = ttk.LabelFrame(body, text="8x8 2bpp pixel editor", padding=10)
        body.add(atlas_frame, weight=3)
        body.add(editor_frame, weight=2)

        self.atlas = tk.Canvas(
            atlas_frame,
            width=512,
            height=512,
            bg="#15181c",
            highlightthickness=0,
        )
        self.atlas.pack(fill="both", expand=True)
        self.atlas.bind("<Button-1>", self.select_tile)
        self.atlas.bind("<Configure>", lambda _event: self.draw_atlas())

        self.tile_label = ttk.Label(editor_frame, font=("Segoe UI", 11, "bold"))
        self.tile_label.pack(anchor="w")
        self.pixel_editor = tk.Canvas(
            editor_frame,
            width=384,
            height=384,
            bg="#111111",
            highlightthickness=0,
        )
        self.pixel_editor.pack(pady=10)
        self.pixel_editor.bind("<ButtonPress-1>", self.start_paint)
        self.pixel_editor.bind("<B1-Motion>", self.paint)
        self.pixel_editor.bind("<ButtonRelease-1>", self.end_paint)

        colors = ttk.LabelFrame(editor_frame, text="2bpp paint value", padding=7)
        colors.pack(fill="x")
        self.ink_buttons: list[tk.Radiobutton] = []
        for value in range(4):
            button = tk.Radiobutton(
                colors,
                text=str(value),
                variable=self.ink,
                value=value,
                indicatoron=False,
                width=7,
                height=2,
            )
            button.pack(side="left", padx=3)
            self.ink_buttons.append(button)

        self.build_palette_tab(palette_tab)
        self.build_metatile_tab(metatile_tab)
        ttk.Label(self, textvariable=self.status, padding=7, anchor="w").pack(
            fill="x"
        )

    def build_palette_tab(self, parent: ttk.Frame) -> None:
        controls = ttk.Frame(parent)
        controls.pack(fill="x")
        ttk.Label(controls, text="Chapter:").pack(side="left")
        world_box = ttk.Combobox(
            controls,
            state="readonly",
            width=24,
            values=(
                "World 1 / CHR Bank 0",
                "World 2 / CHR Bank 1",
                "World 3 / CHR Bank 2",
            ),
        )
        world_box.current(0)
        world_box.pack(side="left", padx=5)
        world_box.bind(
            "<<ComboboxSelected>>",
            lambda _event: (
                self.palette_world.set(world_box.current()),
                self.edit_palette_index.set(0),
                self.refresh_palette_editor(),
            ),
        )
        ttk.Label(controls, text="Palette set:").pack(side="left", padx=(16, 3))
        self.edit_palette_box = ttk.Combobox(
            controls, state="readonly", width=8
        )
        self.edit_palette_box.pack(side="left")
        self.edit_palette_box.bind(
            "<<ComboboxSelected>>",
            lambda _event: (
                self.edit_palette_index.set(self.edit_palette_box.current()),
                self.refresh_palette_editor(),
            ),
        )
        ttk.Button(
            controls, text="Undo palette", command=self.undo_palette
        ).pack(side="left", padx=(18, 2))
        ttk.Button(
            controls, text="Redo palette", command=self.redo_palette
        ).pack(side="left", padx=2)

        self.palette_buttons_frame = ttk.LabelFrame(
            parent, text="Click a slot to choose a NES color", padding=10
        )
        self.palette_buttons_frame.pack(anchor="w", pady=14)
        self.edit_palette_buttons: list[tk.Button] = []
        for slot in range(32):
            button = tk.Button(
                self.palette_buttons_frame,
                width=8,
                height=2,
                command=lambda index=slot: self.choose_palette_color(index),
            )
            button.grid(row=slot // 8, column=slot % 8, padx=3, pady=3)
            self.edit_palette_buttons.append(button)
        ttk.Label(
            parent,
            text=(
                "World 1 and World 3 store full 32-color PPU sets. "
                "World 2 stores nine 16-color background sets."
            ),
        ).pack(anchor="w")

    def build_metatile_tab(self, parent: ttk.Frame) -> None:
        controls = ttk.Frame(parent)
        controls.pack(fill="x")
        ttk.Label(controls, text="Metatile:").pack(side="left")
        self.metatile_box = ttk.Combobox(
            controls,
            state="readonly",
            width=16,
            values=[f"${index:02X} / {index}" for index in range(208)],
        )
        self.metatile_box.current(0)
        self.metatile_box.pack(side="left", padx=5)
        self.metatile_box.bind(
            "<<ComboboxSelected>>",
            lambda _event: (
                self.metatile_index.set(self.metatile_box.current()),
                self.load_metatile(),
            ),
        )
        ttk.Label(controls, text="Preview palette set:").pack(
            side="left", padx=(16, 3)
        )
        metatile_palette_box = ttk.Combobox(
            controls,
            state="readonly",
            width=8,
            values=[str(index) for index in range(9)],
        )
        metatile_palette_box.current(0)
        metatile_palette_box.pack(side="left")
        metatile_palette_box.bind(
            "<<ComboboxSelected>>",
            lambda _event: (
                self.metatile_palette_set.set(metatile_palette_box.current()),
                self.draw_metatile(),
            ),
        )

        body = ttk.Frame(parent)
        body.pack(fill="both", expand=True, pady=12)
        self.metatile_canvas = tk.Canvas(
            body, width=384, height=384, bg="#111111", highlightthickness=0
        )
        self.metatile_canvas.pack(side="left", padx=(10, 35))
        editor = ttk.LabelFrame(body, text="16x16 record", padding=12)
        editor.pack(side="left", anchor="n")
        for index, variable in enumerate(self.metatile_tiles):
            ttk.Label(editor, text=("TL", "TR", "BL", "BR")[index]).grid(
                row=index // 2 * 2,
                column=index % 2,
                padx=5,
            )
            ttk.Spinbox(
                editor, from_=0, to=255, textvariable=variable, width=8
            ).grid(row=index // 2 * 2 + 1, column=index % 2, padx=5, pady=(0, 8))
        ttk.Label(editor, text="Palette row").grid(
            row=4, column=0, sticky="w", pady=(8, 0)
        )
        ttk.Spinbox(
            editor, from_=0, to=3, textvariable=self.metatile_palette, width=8
        ).grid(row=5, column=0, sticky="w")
        ttk.Checkbutton(
            editor, text="Solid collision", variable=self.metatile_solid
        ).grid(row=5, column=1, sticky="w")
        ttk.Label(editor, textvariable=self.metatile_reference).grid(
            row=6, column=0, columnspan=2, sticky="w", pady=10
        )
        ttk.Button(editor, text="Apply metatile", command=self.apply_metatile).grid(
            row=7, column=0, columnspan=2, sticky="ew"
        )
        ttk.Button(editor, text="Undo", command=self.undo_metatile).grid(
            row=8, column=0, sticky="ew", pady=(6, 0)
        )
        ttk.Button(editor, text="Redo", command=self.redo_metatile).grid(
            row=8, column=1, sticky="ew", pady=(6, 0)
        )

    def palette(self) -> tuple[int, int, int, int]:
        catalogs = workspace_palettes(self.artifacts, self.chr_bank.get())
        index = min(self.palette_set.get(), len(catalogs) - 1)
        palette = catalogs[index]
        start = self.palette_row.get() * 4
        if self.pattern_table.get() == 0:
            start += 16
        return tuple(palette[start:start + 4])  # type: ignore[return-value]

    def refresh_palette_choices(self) -> None:
        catalogs = workspace_palettes(self.artifacts, self.chr_bank.get())
        self.palette_box.configure(
            values=[str(index) for index in range(len(catalogs))]
        )
        if self.palette_set.get() >= len(catalogs):
            self.palette_set.set(0)
        self.palette_box.current(self.palette_set.get())

    def refresh(self) -> None:
        self.refresh_palette_choices()
        palette = self.palette()
        for value, button in enumerate(self.ink_buttons):
            button.configure(bg=NES_RGB[palette[value] & 0x3F])
        self.draw_atlas()
        self.draw_editor()
        self.refresh_palette_editor()
        self.draw_metatile()
        if hasattr(self, "hierarchy_panel"):
            self.hierarchy_panel.refresh_previews()
        if hasattr(self, "metasprite_panel"):
            self.metasprite_panel.draw_preview()
        table_name = "sprite" if self.pattern_table.get() == 0 else "background"
        dirty = self.document.dirty or any(
            document.dirty for document in self.artifacts.values()
        ) or any(document.dirty for document in self.hierarchies.values())
        changed = "unsaved edits" if dirty else "saved"
        self.status.set(
            f"CHR bank {self.chr_bank.get()} | {table_name} tile "
            f"${self.relative_tile.get():02X} | file offset "
            f"${self.tile_index * 16:04X} | {changed}"
        )
        self.title(
            f"Doraemon Graphics Studio [{self.profile}]"
            + (" *" if dirty else "")
        )

    def palette_document(self) -> GraphicsArtifactDocument:
        return self.artifacts[
            ("world1_palettes", "world2_palettes", "world3_metasprites")[
                self.palette_world.get()
            ]
        ]

    def editable_palette_values(self) -> list[int]:
        record = self.palette_document().document["palettes"][
            self.edit_palette_index.get()
        ]
        colors = record["colors"]
        if isinstance(colors, str):
            return list(bytes.fromhex(colors))
        return [number(value) for value in colors]

    def refresh_palette_editor(self) -> None:
        if not hasattr(self, "edit_palette_box"):
            return
        records = self.palette_document().document["palettes"]
        if self.edit_palette_index.get() >= len(records):
            self.edit_palette_index.set(0)
        self.edit_palette_box.configure(
            values=[str(index) for index in range(len(records))]
        )
        self.edit_palette_box.current(self.edit_palette_index.get())
        values = self.editable_palette_values()
        for slot, button in enumerate(self.edit_palette_buttons):
            if slot < len(values):
                button.grid()
                button.configure(
                    text=f"${values[slot]:02X}",
                    bg=NES_RGB[values[slot] & 0x3F],
                )
            else:
                button.grid_remove()

    def choose_palette_color(self, slot: int) -> None:
        picker = tk.Toplevel(self)
        picker.title("Choose NES color")
        for color, rgb in enumerate(NES_RGB):
            tk.Button(
                picker,
                text=f"{color:02X}",
                bg=rgb,
                width=4,
                height=2,
                command=lambda value=color: self.set_palette_color(
                    slot, value, picker
                ),
            ).grid(row=color // 8, column=color % 8)

    def set_palette_color(
        self, slot: int, color: int, picker: tk.Toplevel
    ) -> None:
        document = self.palette_document()
        palette_index = self.edit_palette_index.get()

        def edit(data: dict) -> None:
            record = data["palettes"][palette_index]
            colors = record["colors"]
            if isinstance(colors, str):
                values = list(bytes.fromhex(colors))
                values[slot] = color
                record["colors"] = bytes(values).hex(" ").upper()
            else:
                colors[slot] = f"0x{color:02X}"

        try:
            document.change(edit)
            picker.destroy()
            self.refresh()
        except (KeyError, TypeError, ValueError) as exc:
            messagebox.showerror("Graphics Studio", str(exc))

    def undo_palette(self) -> None:
        self.palette_document().undo()
        self.refresh()

    def redo_palette(self) -> None:
        self.palette_document().redo()
        self.refresh()

    def load_metatile(self) -> None:
        record = self.artifacts["world2_metatiles"].document["records"][
            self.metatile_index.get()
        ]
        for field, variable in zip(
            ("top_left", "top_right", "bottom_left", "bottom_right"),
            self.metatile_tiles,
        ):
            variable.set(number(record[field]))
        self.metatile_palette.set(int(record["palette"]))
        self.metatile_solid.set(bool(record["solid"]))
        referenced = (
            "Referenced by standard screens"
            if record["referenced_by_standard_stream"]
            else "Not referenced by standard screens"
        )
        self.metatile_reference.set(referenced)
        self.draw_metatile()

    def draw_metatile(self) -> None:
        if not hasattr(self, "metatile_canvas"):
            return
        self.metatile_canvas.delete("all")
        palettes = workspace_palettes(self.artifacts, 1)
        palette_set = min(self.metatile_palette_set.get(), len(palettes) - 1)
        start = self.metatile_palette.get() * 4
        palette = palettes[palette_set][start:start + 4]
        for quadrant, variable in enumerate(self.metatile_tiles):
            tile = global_tile_index(1, 1, int(variable.get()))
            draw_tile(
                self.metatile_canvas,
                self.document.tiles[tile],
                (quadrant & 1) * 192,
                (quadrant >> 1) * 192,
                24,
                palette,
            )

    def apply_metatile(self) -> None:
        document = self.artifacts["world2_metatiles"]
        index = self.metatile_index.get()
        tiles = [int(variable.get()) for variable in self.metatile_tiles]
        palette = int(self.metatile_palette.get())
        solid = bool(self.metatile_solid.get())

        def edit(data: dict) -> None:
            record = data["records"][index]
            for field, value in zip(
                ("top_left", "top_right", "bottom_left", "bottom_right"),
                tiles,
            ):
                record[field] = f"0x{value:02X}"
            record["palette"] = palette
            record["solid"] = solid

        try:
            document.change(edit)
            self.load_metatile()
            self.refresh()
        except (KeyError, TypeError, ValueError) as exc:
            messagebox.showerror("Graphics Studio", str(exc))

    def undo_metatile(self) -> None:
        self.artifacts["world2_metatiles"].undo()
        self.load_metatile()
        self.refresh()

    def redo_metatile(self) -> None:
        self.artifacts["world2_metatiles"].redo()
        self.load_metatile()
        self.refresh()

    def change_bank(self) -> None:
        self.palette_set.set(0)
        self.relative_tile.set(0)
        self.refresh()

    def change_table(self) -> None:
        self.relative_tile.set(0)
        self.refresh()

    def change_palette(self, _event: object = None) -> None:
        self.palette_set.set(max(0, self.palette_box.current()))
        self.refresh()

    def draw_atlas(self) -> None:
        if not hasattr(self, "atlas"):
            return
        self.atlas.delete("all")
        scale = max(
            2,
            min(self.atlas.winfo_width(), self.atlas.winfo_height()) // 128,
        )
        tile_size = scale * 8
        base = global_tile_index(
            self.chr_bank.get(), self.pattern_table.get(), 0
        )
        palette = self.palette()
        for relative in range(256):
            x = (relative % 16) * tile_size
            y = (relative // 16) * tile_size
            draw_tile(
                self.atlas,
                self.document.tiles[base + relative],
                x,
                y,
                scale,
                palette,
            )
            if relative == self.relative_tile.get():
                self.atlas.create_rectangle(
                    x,
                    y,
                    x + tile_size,
                    y + tile_size,
                    outline="#ffe066",
                    width=2,
                )
        self.atlas.configure(scrollregion=(0, 0, tile_size * 16, tile_size * 16))

    def draw_editor(self) -> None:
        self.pixel_editor.delete("all")
        palette = self.palette()
        pixels = self.document.tiles[self.tile_index]
        for row in range(8):
            for column in range(8):
                self.pixel_editor.create_rectangle(
                    column * 48,
                    row * 48,
                    (column + 1) * 48,
                    (row + 1) * 48,
                    fill=NES_RGB[palette[pixels[row][column]] & 0x3F],
                    outline="#333333",
                )
        changed = " (changed)" if self.document.changed(self.tile_index) else ""
        self.tile_label.configure(
            text=f"Bank {self.chr_bank.get()} tile "
            f"${self.relative_tile.get():02X}{changed}"
        )

    def select_tile(self, event: tk.Event) -> None:
        scale = max(
            2,
            min(self.atlas.winfo_width(), self.atlas.winfo_height()) // 128,
        )
        tile_size = scale * 8
        column, row = event.x // tile_size, event.y // tile_size
        if 0 <= column < 16 and 0 <= row < 16:
            self.relative_tile.set(row * 16 + column)
            self.refresh()

    def start_paint(self, event: tk.Event) -> None:
        self.document.begin_stroke(self.tile_index)
        self.stroke = True
        self.paint(event)

    def paint(self, event: tk.Event) -> None:
        row, column = event.y // 48, event.x // 48
        if 0 <= row < 8 and 0 <= column < 8:
            if self.document.paint(
                self.tile_index, row, column, self.ink.get()
            ):
                self.draw_editor()

    def end_paint(self, _event: object = None) -> None:
        if self.stroke:
            self.document.end_stroke()
            self.stroke = False
            self.refresh()

    def undo(self) -> None:
        try:
            self.document.undo()
            self.refresh()
        except ValueError as exc:
            messagebox.showerror("Graphics Studio", str(exc))

    def redo(self) -> None:
        try:
            self.document.redo()
            self.refresh()
        except ValueError as exc:
            messagebox.showerror("Graphics Studio", str(exc))

    def restore_tile(self) -> None:
        self.document.restore_tile(self.tile_index)
        self.refresh()

    def save(self) -> None:
        try:
            self.document.save()
            for document in self.artifacts.values():
                document.save()
            for document in self.hierarchies.values():
                document.save()
            self.refresh()
        except (OSError, ValueError) as exc:
            messagebox.showerror("Graphics Studio", str(exc))

    def build_rom(self) -> None:
        self.save()
        self.build_launcher(
            self.project_root,
            "graphics-content-rom",
            self.profile,
            self.workspace_root,
        )

    def close(self) -> None:
        dirty = self.document.dirty or any(
            document.dirty for document in self.artifacts.values()
        ) or any(document.dirty for document in self.hierarchies.values())
        if dirty and not messagebox.askyesno(
            "Graphics Studio", "Discard unsaved graphics edits?"
        ):
            return
        self.destroy()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project-root", type=Path, default=PROJECT_ROOT)
    parser.add_argument("--workspace", type=Path, default=Path("content/workspace"))
    parser.add_argument("--profile", choices=("original", "rev_a"), default="original")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    project_root = args.project_root.resolve()
    workspace_root = (
        args.workspace
        if args.workspace.is_absolute()
        else project_root / args.workspace
    )
    try:
        workspace = GraphicsWorkspace(project_root, workspace_root, args.profile)
        prg_workspace = PrgGraphicsWorkspace(
            project_root, workspace_root, args.profile
        )
        hierarchy_workspace = LevelWorkspace(
            project_root, workspace_root, args.profile
        )
        workspace.initialize()
        prg_workspace.initialize()
        hierarchy_workspace.initialize()
        document = workspace.load()
        artifacts = prg_workspace.load()
        artifact_sizes = prg_workspace.validate()
        hierarchies = {
            world_id: hierarchy_workspace.load(world_id)
            for world_id in ("world1", "world3")
        }
        hierarchy_sizes = {
            world_id: len(document.encode())
            for world_id, document in hierarchies.items()
        }
        catalogs = [preview_palettes(project_root, bank) for bank in range(4)]
        if args.check:
            print(
                f"[OK] Graphics Studio [{args.profile}]: "
                f"{len(document.tiles)} tiles, "
                f"{sum(len(entries) for entries in catalogs)} preview palettes, "
                f"{len(artifact_sizes)} PRG graphics artifacts, "
                f"{sum(hierarchy_sizes.values())} shared hierarchy bytes"
            )
            return 0
        app = GraphicsStudio(
            document,
            artifacts,
            hierarchies,
            project_root,
            workspace_root,
            args.profile,
        )
        app.mainloop()
        return 0
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] Graphics Studio failed: {exc}")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
