#!/usr/bin/env python3
"""Visual fixed-capacity metasprite editor for all three Doraemon chapters."""

from __future__ import annotations

import tkinter as tk
from tkinter import messagebox, ttk
from typing import Callable

from scripts.authoring.graphics_artifacts import GraphicsArtifactDocument
from scripts.authoring.graphics_studio_model import ChrDocument, global_tile_index
from scripts.authoring.level_studio_rendering import NES_RGB


WORLD_ARTIFACTS = {
    "world1": "world1_metasprites",
    "world2": "world2_metasprites",
    "world3": "world3_metasprites",
}
WORLD_BANKS = {"world1": 0, "world2": 1, "world3": 2}
FLIPS = ("none", "horizontal", "vertical")


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def signed(value: int) -> int:
    return value - 0x100 if value & 0x80 else value


def edit_variable_record(
    data: dict,
    record_index: int,
    piece_index: int,
    extent_x: int,
    extent_y: int,
    piece_y: int,
    piece_x: int,
    tile: int,
) -> None:
    values = (extent_x, extent_y, piece_y, piece_x, tile)
    if any(not 0 <= value <= 0xFF for value in values):
        raise ValueError("variable metasprite values must fit one byte")
    if not 0 <= record_index < len(data["metasprites"]):
        raise ValueError("variable metasprite index is outside the record table")
    record = data["metasprites"][record_index]
    if not 0 <= piece_index < len(record["pieces"]):
        raise ValueError("metasprite piece index is outside the record")
    record["x_mirror_extent"] = f"0x{extent_x:02X}"
    record["y_mirror_extent"] = f"0x{extent_y:02X}"
    piece = record["pieces"][piece_index]
    piece["y_offset"] = f"0x{piece_y:02X}"
    piece["x_offset"] = f"0x{piece_x:02X}"
    piece["tile"] = f"0x{tile:02X}"


def edit_fixed_record(
    data: dict,
    record_index: int,
    tiles: list[int],
    palette: int,
    attribute_base: int,
) -> None:
    if len(tiles) != 4 or any(not 0 <= value <= 0xFF for value in tiles):
        raise ValueError("fixed metasprite requires four byte-sized tiles")
    if not 0 <= palette < 4:
        raise ValueError("fixed metasprite palette is outside 0..3")
    if not 0 <= attribute_base <= 32 or attribute_base % 4:
        raise ValueError("fixed metasprite attribute base must be 0..32 by four")
    if not 0 <= record_index < len(data["metasprites"]):
        raise ValueError("fixed metasprite index is outside the record table")
    record = data["metasprites"][record_index]
    record["tiles"] = [f"0x{value:02X}" for value in tiles]
    record["palette"] = palette
    record["attribute_base"] = f"0x{attribute_base:02X}"


def edit_oam_attribute(data: dict, index: int, value: int) -> None:
    if not 0 <= index < len(data["oam_attributes"]) or value & ~0xE0:
        raise ValueError("OAM attribute must be one of the supported flip bits")
    data["oam_attributes"][index]["value"] = f"0x{value:02X}"


def edit_index_entry(
    data: dict,
    index: int,
    kind: str,
    target: int,
    flip: str,
) -> None:
    entries = data["index_entries"]
    records = data["metasprites"]
    if not 0 <= index < len(entries):
        raise ValueError("metasprite index entry is outside the table")
    replacement = {"id": index, "kind": kind}
    if kind == "direct":
        if not 0 <= target < len(records):
            raise ValueError("direct metasprite target is outside the record table")
        replacement["metasprite_address"] = records[target]["address"]
    elif kind == "alias":
        if not 0 <= target < len(entries) or flip not in FLIPS:
            raise ValueError("metasprite alias target or flip is invalid")
        replacement["source_index"] = target
        replacement["flip"] = flip
    else:
        raise ValueError("metasprite index kind must be direct or alias")
    entries[index].clear()
    entries[index].update(replacement)


class MetaspriteGraphicsPanel(ttk.Frame):
    def __init__(
        self,
        parent: ttk.Notebook,
        artifacts: dict[str, GraphicsArtifactDocument],
        chr_document: ChrDocument,
        on_change: Callable[[], None],
    ) -> None:
        super().__init__(parent, padding=8)
        self.artifacts = artifacts
        self.chr_document = chr_document
        self.on_change = on_change
        self.world = tk.StringVar(value="world1")
        self.record_id = tk.IntVar(value=0)
        self.piece_id = tk.IntVar(value=0)
        self.palette_set = tk.IntVar(value=0)
        self.palette_row = tk.IntVar(value=0)
        self.extent_x = tk.IntVar(value=0)
        self.extent_y = tk.IntVar(value=0)
        self.piece_y = tk.IntVar(value=0)
        self.piece_x = tk.IntVar(value=0)
        self.piece_tile = tk.IntVar(value=0)
        self.world2_tiles = [tk.IntVar(value=0) for _ in range(4)]
        self.world2_attribute_base = tk.IntVar(value=0)
        self.attribute_id = tk.IntVar(value=0)
        self.attribute_value = tk.IntVar(value=0)
        self.index_id = tk.IntVar(value=0)
        self.index_kind = tk.StringVar(value="direct")
        self.index_target = tk.IntVar(value=0)
        self.index_flip = tk.StringVar(value="none")
        self.status = tk.StringVar()
        self.build_ui()
        self.load_world()

    @property
    def document(self) -> GraphicsArtifactDocument:
        return self.artifacts[WORLD_ARTIFACTS[self.world.get()]]

    @property
    def records(self) -> list[dict]:
        return self.document.document["metasprites"]

    def build_ui(self) -> None:
        controls = ttk.Frame(self)
        controls.pack(fill="x")
        ttk.Label(controls, text="Chapter:").pack(side="left")
        world_box = ttk.Combobox(
            controls,
            state="readonly",
            width=22,
            values=("World 1", "World 2", "World 3"),
        )
        world_box.current(0)
        world_box.pack(side="left", padx=5)
        world_box.bind(
            "<<ComboboxSelected>>",
            lambda _event: self.change_world(world_box.current()),
        )
        ttk.Label(controls, text="Metasprite:").pack(side="left", padx=(15, 3))
        self.record_box = ttk.Combobox(controls, state="readonly", width=14)
        self.record_box.pack(side="left")
        self.record_box.bind(
            "<<ComboboxSelected>>",
            lambda _event: (
                self.record_id.set(self.record_box.current()),
                self.load_record(),
            ),
        )
        ttk.Label(controls, text="Palette set:").pack(side="left", padx=(15, 3))
        self.palette_box = ttk.Combobox(controls, state="readonly", width=7)
        self.palette_box.pack(side="left")
        self.palette_box.bind(
            "<<ComboboxSelected>>",
            lambda _event: (
                self.palette_set.set(self.palette_box.current()),
                self.draw_preview(),
            ),
        )
        ttk.Label(controls, text="row:").pack(side="left", padx=(8, 3))
        ttk.Spinbox(
            controls,
            from_=0,
            to=3,
            width=4,
            textvariable=self.palette_row,
            command=self.draw_preview,
        ).pack(side="left")
        ttk.Button(controls, text="Undo", command=self.undo).pack(
            side="left", padx=(15, 2)
        )
        ttk.Button(controls, text="Redo", command=self.redo).pack(
            side="left", padx=2
        )

        body = ttk.Frame(self)
        body.pack(fill="both", expand=True, pady=10)
        self.canvas = tk.Canvas(
            body, width=420, height=420, bg="#111111", highlightthickness=0
        )
        self.canvas.pack(side="left", padx=(5, 25))
        self.editor = ttk.Frame(body)
        self.editor.pack(side="left", fill="both", expand=True)
        self.variable_editor = ttk.LabelFrame(
            self.editor, text="Variable metasprite record", padding=10
        )
        self.variable_editor.pack(fill="x")
        self.build_variable_editor(self.variable_editor)
        self.fixed_editor = ttk.LabelFrame(
            self.editor, text="World 2 fixed 2x2 record", padding=10
        )
        self.build_fixed_editor(self.fixed_editor)
        self.index_editor = ttk.LabelFrame(
            self.editor, text="World 1/3 index entry", padding=10
        )
        self.index_editor.pack(fill="x", pady=(10, 0))
        self.build_index_editor(self.index_editor)
        ttk.Label(self.editor, textvariable=self.status).pack(
            anchor="w", pady=10
        )

    def build_variable_editor(self, parent: ttk.Frame) -> None:
        ttk.Label(parent, text="X mirror extent").grid(row=0, column=0)
        ttk.Label(parent, text="Y mirror extent").grid(row=0, column=1)
        ttk.Spinbox(
            parent, from_=0, to=255, width=8, textvariable=self.extent_x
        ).grid(row=1, column=0, padx=4)
        ttk.Spinbox(
            parent, from_=0, to=255, width=8, textvariable=self.extent_y
        ).grid(row=1, column=1, padx=4)
        ttk.Label(parent, text="Piece").grid(row=2, column=0, pady=(8, 0))
        self.piece_box = ttk.Combobox(parent, state="readonly", width=8)
        self.piece_box.grid(row=3, column=0)
        self.piece_box.bind(
            "<<ComboboxSelected>>",
            lambda _event: (
                self.piece_id.set(self.piece_box.current()),
                self.load_piece(),
            ),
        )
        for column, label in enumerate(("Y offset", "X offset", "Tile")):
            ttk.Label(parent, text=label).grid(row=4, column=column)
        for column, variable in enumerate(
            (self.piece_y, self.piece_x, self.piece_tile)
        ):
            ttk.Spinbox(
                parent, from_=0, to=255, width=8, textvariable=variable
            ).grid(row=5, column=column, padx=4)
        ttk.Button(
            parent, text="Apply extents and piece", command=self.apply_variable
        ).grid(row=6, column=0, columnspan=3, sticky="ew", pady=(9, 0))

    def build_fixed_editor(self, parent: ttk.Frame) -> None:
        for index, variable in enumerate(self.world2_tiles):
            ttk.Label(parent, text=("TL", "TR", "BL", "BR")[index]).grid(
                row=index // 2 * 2, column=index % 2
            )
            ttk.Spinbox(
                parent, from_=0, to=255, width=8, textvariable=variable
            ).grid(row=index // 2 * 2 + 1, column=index % 2, padx=4)
        ttk.Label(parent, text="Palette row").grid(row=4, column=0)
        ttk.Label(parent, text="Attribute base").grid(row=4, column=1)
        ttk.Spinbox(
            parent, from_=0, to=3, width=8, textvariable=self.palette_row
        ).grid(row=5, column=0)
        ttk.Spinbox(
            parent,
            from_=0,
            to=32,
            increment=4,
            width=8,
            textvariable=self.world2_attribute_base,
        ).grid(row=5, column=1)
        ttk.Button(parent, text="Apply fixed record", command=self.apply_fixed).grid(
            row=6, column=0, columnspan=2, sticky="ew", pady=(9, 0)
        )
        ttk.Separator(parent).grid(
            row=7, column=0, columnspan=2, sticky="ew", pady=9
        )
        ttk.Label(parent, text="OAM attribute slot").grid(row=8, column=0)
        ttk.Label(parent, text="Value").grid(row=8, column=1)
        attribute_box = ttk.Spinbox(
            parent,
            from_=0,
            to=35,
            width=8,
            textvariable=self.attribute_id,
            command=self.load_attribute,
        )
        attribute_box.grid(row=9, column=0)
        ttk.Spinbox(
            parent,
            from_=0,
            to=224,
            increment=32,
            width=8,
            textvariable=self.attribute_value,
        ).grid(row=9, column=1)
        ttk.Button(
            parent, text="Apply OAM attribute", command=self.apply_attribute
        ).grid(row=10, column=0, columnspan=2, sticky="ew", pady=(9, 0))

    def build_index_editor(self, parent: ttk.Frame) -> None:
        ttk.Label(parent, text="Entry").grid(row=0, column=0)
        self.index_box = ttk.Combobox(parent, state="readonly", width=8)
        self.index_box.grid(row=1, column=0, padx=3)
        self.index_box.bind(
            "<<ComboboxSelected>>",
            lambda _event: (
                self.index_id.set(self.index_box.current()),
                self.load_index(),
            ),
        )
        ttk.Label(parent, text="Kind").grid(row=0, column=1)
        ttk.Combobox(
            parent,
            state="readonly",
            width=9,
            textvariable=self.index_kind,
            values=("direct", "alias"),
        ).grid(row=1, column=1, padx=3)
        ttk.Label(parent, text="Target record/index").grid(row=0, column=2)
        ttk.Spinbox(
            parent, from_=0, to=255, width=10, textvariable=self.index_target
        ).grid(row=1, column=2, padx=3)
        ttk.Label(parent, text="Alias flip").grid(row=0, column=3)
        ttk.Combobox(
            parent,
            state="readonly",
            width=11,
            textvariable=self.index_flip,
            values=FLIPS,
        ).grid(row=1, column=3, padx=3)
        ttk.Button(parent, text="Apply index", command=self.apply_index).grid(
            row=2, column=0, columnspan=4, sticky="ew", pady=(8, 0)
        )

    def palette_catalog(self) -> tuple[tuple[int, ...], ...]:
        if self.world.get() == "world1":
            records = self.artifacts["world1_palettes"].document["palettes"]
            return tuple(tuple(bytes.fromhex(item["colors"])) for item in records)
        if self.world.get() == "world2":
            records = self.artifacts["world2_palettes"].document["palettes"]
            return tuple(
                tuple(number(value) for value in item["colors"]) for item in records
            )
        records = self.artifacts["world3_metasprites"].document["palettes"]
        return tuple(
            tuple(number(value) for value in item["colors"]) for item in records
        )

    def change_world(self, index: int) -> None:
        self.world.set(("world1", "world2", "world3")[index])
        self.record_id.set(0)
        self.piece_id.set(0)
        self.palette_set.set(6 if index == 1 else 0)
        self.load_world()

    def load_world(self) -> None:
        self.record_box.configure(
            values=[f"${index:02X} / {index}" for index in range(len(self.records))]
        )
        self.record_box.current(self.record_id.get())
        palettes = self.palette_catalog()
        self.palette_box.configure(
            values=[str(index) for index in range(len(palettes))]
        )
        self.palette_box.current(min(self.palette_set.get(), len(palettes) - 1))
        world2 = self.world.get() == "world2"
        if world2:
            self.variable_editor.pack_forget()
            self.index_editor.pack_forget()
            self.fixed_editor.pack(fill="x")
        else:
            self.fixed_editor.pack_forget()
            self.variable_editor.pack(fill="x")
            self.index_editor.pack(fill="x", pady=(10, 0))
            entries = self.document.document["index_entries"]
            self.index_box.configure(
                values=[f"${index:02X}" for index in range(len(entries))]
            )
            self.index_box.current(min(self.index_id.get(), len(entries) - 1))
            self.load_index()
        self.load_record()

    def load_record(self) -> None:
        record = self.records[self.record_id.get()]
        if self.world.get() == "world2":
            for variable, value in zip(self.world2_tiles, record["tiles"]):
                variable.set(number(value))
            self.palette_row.set(int(record["palette"]))
            self.world2_attribute_base.set(number(record["attribute_base"]))
            self.load_attribute()
        else:
            self.extent_x.set(number(record["x_mirror_extent"]))
            self.extent_y.set(number(record["y_mirror_extent"]))
            pieces = record["pieces"]
            if self.piece_id.get() >= len(pieces):
                self.piece_id.set(0)
            self.piece_box.configure(
                values=[str(index) for index in range(len(pieces))]
            )
            self.piece_box.current(self.piece_id.get())
            self.load_piece()
        self.status.set(
            f"{self.world.get()} metasprite {self.record_id.get()} "
            f"uses {record.get('sprite_count', 4)} pieces"
        )
        self.draw_preview()

    def load_piece(self) -> None:
        piece = self.records[self.record_id.get()]["pieces"][self.piece_id.get()]
        self.piece_y.set(number(piece["y_offset"]))
        self.piece_x.set(number(piece["x_offset"]))
        self.piece_tile.set(number(piece["tile"]))
        self.draw_preview()

    def load_attribute(self) -> None:
        if self.world.get() != "world2":
            return
        attributes = self.document.document["oam_attributes"]
        index = min(self.attribute_id.get(), len(attributes) - 1)
        self.attribute_id.set(index)
        self.attribute_value.set(number(attributes[index]["value"]))

    def load_index(self) -> None:
        if self.world.get() == "world2":
            return
        entry = self.document.document["index_entries"][self.index_id.get()]
        self.index_kind.set(entry["kind"])
        if entry["kind"] == "direct":
            address = number(entry["metasprite_address"])
            target = next(
                record["id"] for record in self.records
                if number(record["address"]) == address
            )
            self.index_target.set(target)
            self.index_flip.set("none")
        else:
            self.index_target.set(int(entry["source_index"]))
            self.index_flip.set(entry["flip"])

    def preview_palette(self) -> tuple[int, ...]:
        catalog = self.palette_catalog()
        palette = catalog[min(self.palette_set.get(), len(catalog) - 1)]
        row = self.palette_row.get()
        start = row * 4
        return palette[start:start + 4]

    def draw_tile(self, tile: int, x: int, y: int, scale: int) -> None:
        pixels = self.chr_document.tiles[
            global_tile_index(WORLD_BANKS[self.world.get()], 0, tile)
        ]
        palette = self.preview_palette()
        for row, values in enumerate(pixels):
            for column, value in enumerate(values):
                self.canvas.create_rectangle(
                    x + column * scale,
                    y + row * scale,
                    x + (column + 1) * scale,
                    y + (row + 1) * scale,
                    fill=NES_RGB[palette[value] & 0x3F],
                    outline="",
                )

    def draw_preview(self) -> None:
        if not hasattr(self, "canvas"):
            return
        self.canvas.delete("all")
        record = self.records[self.record_id.get()]
        if self.world.get() == "world2":
            for index, value in enumerate(record["tiles"]):
                self.draw_tile(
                    number(value),
                    130 + (index & 1) * 80,
                    130 + (index >> 1) * 80,
                    10,
                )
            return
        for piece in record["pieces"]:
            self.draw_tile(
                number(piece["tile"]),
                190 + signed(number(piece["x_offset"])) * 5,
                190 + signed(number(piece["y_offset"])) * 5,
                5,
            )

    def apply_variable(self) -> None:
        index, piece_id = self.record_id.get(), self.piece_id.get()

        def edit(data: dict) -> None:
            edit_variable_record(
                data,
                index,
                piece_id,
                int(self.extent_x.get()),
                int(self.extent_y.get()),
                int(self.piece_y.get()),
                int(self.piece_x.get()),
                int(self.piece_tile.get()),
            )

        self.change(edit)

    def apply_fixed(self) -> None:
        index = self.record_id.get()

        def edit(data: dict) -> None:
            edit_fixed_record(
                data,
                index,
                [int(variable.get()) for variable in self.world2_tiles],
                int(self.palette_row.get()),
                int(self.world2_attribute_base.get()),
            )

        self.change(edit)

    def apply_attribute(self) -> None:
        index = self.attribute_id.get()
        self.change(
            lambda data: edit_oam_attribute(
                data, index, int(self.attribute_value.get())
            )
        )

    def apply_index(self) -> None:
        index = self.index_id.get()

        def edit(data: dict) -> None:
            edit_index_entry(
                data,
                index,
                self.index_kind.get(),
                int(self.index_target.get()),
                self.index_flip.get(),
            )

        self.change(edit)

    def change(self, action: Callable[[dict], None]) -> None:
        try:
            self.document.change(action)
            self.load_world()
            self.on_change()
        except (KeyError, StopIteration, TypeError, ValueError) as exc:
            messagebox.showerror("Graphics Studio", str(exc))

    def undo(self) -> None:
        self.document.undo()
        self.load_world()
        self.on_change()

    def redo(self) -> None:
        self.document.redo()
        self.load_world()
        self.on_change()
