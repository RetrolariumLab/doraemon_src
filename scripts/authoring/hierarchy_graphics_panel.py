#!/usr/bin/env python3
"""Tkinter panel for shared World 1 and World 3 metatile hierarchies."""

from __future__ import annotations

import tkinter as tk
from tkinter import messagebox, ttk
from typing import Callable

from scripts.authoring.graphics_artifacts import GraphicsArtifactDocument
from scripts.authoring.graphics_studio_model import ChrDocument, global_tile_index
from scripts.authoring.level_studio_model import HierarchicalWorldDocument
from scripts.authoring.level_studio_rendering import NES_RGB


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


class HierarchyGraphicsPanel(ttk.Frame):
    def __init__(
        self,
        parent: ttk.Notebook,
        hierarchies: dict[str, HierarchicalWorldDocument],
        artifacts: dict[str, GraphicsArtifactDocument],
        chr_document: ChrDocument,
        on_change: Callable[[], None],
    ) -> None:
        super().__init__(parent, padding=8)
        self.hierarchies = hierarchies
        self.artifacts = artifacts
        self.chr_document = chr_document
        self.on_change = on_change
        self.world = tk.StringVar(value="world1")
        self.palette_set = tk.IntVar(value=0)
        self.small_id = tk.IntVar(value=0)
        self.big_id = tk.IntVar(value=0)
        self.small_tiles = [tk.IntVar(value=0) for _ in range(4)]
        self.small_palette = tk.IntVar(value=0)
        self.small_properties = tk.IntVar(value=0)
        self.big_blocks = [tk.IntVar(value=0) for _ in range(4)]
        self.build_ui()
        self.load_records()

    @property
    def model(self) -> HierarchicalWorldDocument:
        return self.hierarchies[self.world.get()]

    @property
    def chr_bank(self) -> int:
        return 0 if self.world.get() == "world1" else 2

    def palette_catalog(self) -> tuple[tuple[int, ...], ...]:
        artifact_id = (
            "world1_palettes"
            if self.world.get() == "world1"
            else "world3_metasprites"
        )
        records = self.artifacts[artifact_id].document["palettes"]
        result = []
        for record in records:
            colors = record["colors"]
            result.append(
                tuple(bytes.fromhex(colors))
                if isinstance(colors, str)
                else tuple(number(value) for value in colors)
            )
        return tuple(result)

    def build_ui(self) -> None:
        controls = ttk.Frame(self)
        controls.pack(fill="x")
        ttk.Label(controls, text="Hierarchy:").pack(side="left")
        world_box = ttk.Combobox(
            controls,
            state="readonly",
            width=24,
            values=("World 1 / CHR Bank 0", "World 3 / CHR Bank 2"),
        )
        world_box.current(0)
        world_box.pack(side="left", padx=5)
        world_box.bind(
            "<<ComboboxSelected>>",
            lambda _event: self.change_world(world_box.current()),
        )
        ttk.Label(controls, text="Preview palette set:").pack(
            side="left", padx=(16, 3)
        )
        self.palette_box = ttk.Combobox(controls, state="readonly", width=8)
        self.palette_box.pack(side="left")
        self.palette_box.bind(
            "<<ComboboxSelected>>",
            lambda _event: (
                self.palette_set.set(self.palette_box.current()),
                self.refresh_previews(),
            ),
        )
        ttk.Button(controls, text="Undo hierarchy", command=self.undo).pack(
            side="left", padx=(18, 2)
        )
        ttk.Button(controls, text="Redo hierarchy", command=self.redo).pack(
            side="left", padx=2
        )

        body = ttk.Frame(self)
        body.pack(fill="both", expand=True, pady=10)
        small = ttk.LabelFrame(body, text="Small block / 16x16", padding=10)
        big = ttk.LabelFrame(body, text="Big block / 32x32", padding=10)
        small.pack(side="left", fill="both", expand=True, padx=(0, 5))
        big.pack(side="left", fill="both", expand=True, padx=(5, 0))
        self.build_small_editor(small)
        self.build_big_editor(big)

    def build_small_editor(self, parent: ttk.Frame) -> None:
        selector = ttk.Frame(parent)
        selector.pack(fill="x")
        ttk.Label(selector, text="Small block:").pack(side="left")
        self.small_box = ttk.Combobox(
            selector,
            state="readonly",
            width=14,
            values=[f"${index:02X} / {index}" for index in range(256)],
        )
        self.small_box.current(0)
        self.small_box.pack(side="left", padx=5)
        self.small_box.bind(
            "<<ComboboxSelected>>",
            lambda _event: (
                self.small_id.set(self.small_box.current()),
                self.load_small(),
            ),
        )
        self.small_canvas = tk.Canvas(
            parent, width=256, height=256, bg="#111111", highlightthickness=0
        )
        self.small_canvas.pack(pady=10)
        grid = ttk.Frame(parent)
        grid.pack()
        for index, variable in enumerate(self.small_tiles):
            ttk.Label(grid, text=("TL", "TR", "BL", "BR")[index]).grid(
                row=index // 2 * 2, column=index % 2
            )
            ttk.Spinbox(
                grid, from_=0, to=255, textvariable=variable, width=8
            ).grid(row=index // 2 * 2 + 1, column=index % 2, padx=4, pady=(0, 6))
        ttk.Label(grid, text="Palette row").grid(row=4, column=0)
        ttk.Label(grid, text="Properties").grid(row=4, column=1)
        ttk.Spinbox(
            grid, from_=0, to=3, textvariable=self.small_palette, width=8
        ).grid(row=5, column=0)
        ttk.Spinbox(
            grid, from_=0, to=63, textvariable=self.small_properties, width=8
        ).grid(row=5, column=1)
        ttk.Button(parent, text="Apply small block", command=self.apply_small).pack(
            fill="x", pady=10
        )

    def build_big_editor(self, parent: ttk.Frame) -> None:
        selector = ttk.Frame(parent)
        selector.pack(fill="x")
        ttk.Label(selector, text="Big block:").pack(side="left")
        self.big_box = ttk.Combobox(
            selector,
            state="readonly",
            width=14,
            values=[f"${index:02X} / {index}" for index in range(256)],
        )
        self.big_box.current(0)
        self.big_box.pack(side="left", padx=5)
        self.big_box.bind(
            "<<ComboboxSelected>>",
            lambda _event: (
                self.big_id.set(self.big_box.current()),
                self.load_big(),
            ),
        )
        self.big_canvas = tk.Canvas(
            parent, width=320, height=320, bg="#111111", highlightthickness=0
        )
        self.big_canvas.pack(pady=10)
        grid = ttk.Frame(parent)
        grid.pack()
        for index, variable in enumerate(self.big_blocks):
            ttk.Label(grid, text=("TL", "TR", "BL", "BR")[index]).grid(
                row=index // 2 * 2, column=index % 2
            )
            ttk.Spinbox(
                grid, from_=0, to=255, textvariable=variable, width=8
            ).grid(row=index // 2 * 2 + 1, column=index % 2, padx=4, pady=(0, 6))
        ttk.Button(parent, text="Apply big block", command=self.apply_big).pack(
            fill="x", pady=10
        )

    def change_world(self, index: int) -> None:
        self.world.set(("world1", "world3")[index])
        self.palette_set.set(0)
        self.small_id.set(0)
        self.big_id.set(0)
        self.small_box.current(0)
        self.big_box.current(0)
        self.load_records()

    def load_records(self) -> None:
        palettes = self.palette_catalog()
        self.palette_box.configure(
            values=[str(index) for index in range(len(palettes))]
        )
        self.palette_box.current(min(self.palette_set.get(), len(palettes) - 1))
        self.load_small()
        self.load_big()

    def load_small(self) -> None:
        tiles, palette, properties = self.model.small_block(self.small_id.get())
        for variable, value in zip(self.small_tiles, tiles):
            variable.set(value)
        self.small_palette.set(palette)
        self.small_properties.set(properties)
        self.draw_small()

    def load_big(self) -> None:
        for variable, value in zip(
            self.big_blocks, self.model.big_block(self.big_id.get())
        ):
            variable.set(value)
        self.draw_big()

    def palette_row(self, selector: int) -> tuple[int, ...]:
        palettes = self.palette_catalog()
        palette = palettes[min(self.palette_set.get(), len(palettes) - 1)]
        return palette[selector * 4:selector * 4 + 4]

    def draw_chr_tile(
        self,
        canvas: tk.Canvas,
        tile: int,
        x: int,
        y: int,
        scale: int,
        palette: tuple[int, ...],
    ) -> None:
        pixels = self.chr_document.tiles[
            global_tile_index(self.chr_bank, 1, tile)
        ]
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

    def draw_small(self) -> None:
        self.small_canvas.delete("all")
        palette = self.palette_row(self.small_palette.get())
        for quadrant, variable in enumerate(self.small_tiles):
            self.draw_chr_tile(
                self.small_canvas,
                int(variable.get()),
                (quadrant & 1) * 128,
                (quadrant >> 1) * 128,
                16,
                palette,
            )

    def draw_big(self) -> None:
        self.big_canvas.delete("all")
        cells = self.model.expanded_big_block(self.big_id.get())
        for y, row in enumerate(cells):
            for x, cell in enumerate(row):
                self.draw_chr_tile(
                    self.big_canvas,
                    cell.tile,
                    x * 80,
                    y * 80,
                    10,
                    self.palette_row(cell.palette),
                )

    def refresh_previews(self) -> None:
        self.draw_small()
        self.draw_big()

    def apply_small(self) -> None:
        try:
            self.model.edit_small_block(
                self.small_id.get(),
                (int(variable.get()) for variable in self.small_tiles),
                int(self.small_palette.get()),
                int(self.small_properties.get()),
            )
            self.load_records()
            self.on_change()
        except (KeyError, TypeError, ValueError) as exc:
            messagebox.showerror("Graphics Studio", str(exc))

    def apply_big(self) -> None:
        try:
            self.model.edit_big_block(
                self.big_id.get(),
                (int(variable.get()) for variable in self.big_blocks),
            )
            self.load_big()
            self.on_change()
        except (KeyError, TypeError, ValueError) as exc:
            messagebox.showerror("Graphics Studio", str(exc))

    def undo(self) -> None:
        self.model.undo_hierarchy()
        self.load_records()
        self.on_change()

    def redo(self) -> None:
        self.model.redo_hierarchy()
        self.load_records()
        self.on_change()
