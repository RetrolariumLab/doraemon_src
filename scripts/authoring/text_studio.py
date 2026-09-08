#!/usr/bin/env python3
"""Visual fixed-width text editor with native CHR glyph previews."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import subprocess
import sys
import tkinter as tk
from tkinter import messagebox, ttk


SCRIPTS = Path(__file__).resolve().parent.parent
if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))

from scripts.authoring.graphics_studio_model import ChrDocument, global_tile_index
from scripts.authoring.text_studio_model import (
    TextDocument,
    TextField,
    TextWorkspace,
    edit_fixed_text,
    edit_hex_row,
    glyph_tiles,
    text_fields,
    value_at,
)


PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent
GLYPH_COLORS = ("#101010", "#707070", "#c0c0c0", "#ffffff")


class TextStudio(tk.Tk):
    def __init__(
        self,
        document: TextDocument,
        chr_document: ChrDocument,
        project_root: Path,
        profile: str,
    ) -> None:
        super().__init__()
        self.document = document
        self.chr_document = chr_document
        self.project_root = project_root
        self.profile = profile
        self.fields: tuple[TextField, ...] = ()
        self.line_fields: tuple[TextField, ...] = ()
        self.credit_fields: tuple[TextField, ...] = ()
        self.line_index = tk.IntVar(value=0)
        self.credit_index = tk.IntVar(value=0)
        self.text_value = tk.StringVar()
        self.credit_value = tk.StringVar()
        self.raw_collection = tk.StringVar(value="ending_nametable_rows")
        self.raw_index = tk.IntVar(value=0)
        self.raw_value = tk.StringVar()
        self.status = tk.StringVar()
        self.geometry("1100x720")
        self.minsize(860, 600)
        self.protocol("WM_DELETE_WINDOW", self.close)
        self.bind("<Control-s>", lambda _event: self.save())
        self.build_ui()
        self.reload_fields()

    def build_ui(self) -> None:
        notebook = ttk.Notebook(self)
        notebook.pack(fill="both", expand=True, padx=8, pady=8)
        lines = ttk.Frame(notebook, padding=8)
        credits = ttk.Frame(notebook, padding=8)
        raw = ttk.Frame(notebook, padding=8)
        notebook.add(lines, text="Title, HUD and help")
        notebook.add(credits, text="Ending credits")
        notebook.add(raw, text="Raw fixed rows")
        self.build_text_tab(lines, False)
        self.build_text_tab(credits, True)
        self.build_raw_tab(raw)
        footer = ttk.Frame(self, padding=(8, 0, 8, 8))
        footer.pack(fill="x")
        ttk.Button(footer, text="Undo", command=self.undo).pack(side="left")
        ttk.Button(footer, text="Redo", command=self.redo).pack(side="left", padx=4)
        ttk.Button(footer, text="Save", command=self.save).pack(side="left", padx=(14, 4))
        ttk.Button(footer, text="Build ROM", command=self.build_rom).pack(side="left")
        ttk.Label(footer, textvariable=self.status).pack(side="left", padx=15)

    def build_text_tab(self, parent: ttk.Frame, credits: bool) -> None:
        listbox = tk.Listbox(parent, width=42, exportselection=False)
        listbox.pack(side="left", fill="y")
        editor = ttk.Frame(parent, padding=(12, 0))
        editor.pack(side="left", fill="both", expand=True)
        variable = self.credit_value if credits else self.text_value
        ttk.Label(editor, text="Fixed-width source text:").pack(anchor="w")
        ttk.Entry(editor, textvariable=variable, font="TkFixedFont", width=50).pack(fill="x", pady=5)
        ttk.Button(
            editor,
            text="Apply fixed-width text",
            command=self.apply_credit if credits else self.apply_line,
        ).pack(anchor="w")
        canvas = tk.Canvas(editor, width=800, height=180, bg="#202020", highlightthickness=0)
        canvas.pack(fill="x", pady=18)
        if credits:
            self.credit_list = listbox
            self.credit_canvas = canvas
            listbox.bind("<<ListboxSelect>>", lambda _event: self.select_credit())
        else:
            self.line_list = listbox
            self.line_canvas = canvas
            listbox.bind("<<ListboxSelect>>", lambda _event: self.select_line())

    def build_raw_tab(self, parent: ttk.Frame) -> None:
        controls = ttk.Frame(parent)
        controls.pack(fill="x")
        ttk.Label(controls, text="Collection:").pack(side="left")
        box = ttk.Combobox(
            controls,
            state="readonly",
            textvariable=self.raw_collection,
            values=("ending_nametable_rows", "title_raw_records"),
            width=28,
        )
        box.pack(side="left", padx=6)
        box.bind("<<ComboboxSelected>>", lambda _event: self.load_raw())
        ttk.Label(controls, text="Row:").pack(side="left", padx=(12, 3))
        self.raw_box = ttk.Combobox(controls, state="readonly", width=8)
        self.raw_box.pack(side="left")
        self.raw_box.bind(
            "<<ComboboxSelected>>",
            lambda _event: (self.raw_index.set(self.raw_box.current()), self.load_raw_value()),
        )
        ttk.Entry(parent, textvariable=self.raw_value, font="TkFixedFont").pack(fill="x", pady=12)
        ttk.Button(parent, text="Apply exact-width bytes", command=self.apply_raw).pack(anchor="w")
        self.raw_preview = tk.Text(parent, height=20, font="TkFixedFont", state="disabled")
        self.raw_preview.pack(fill="both", expand=True, pady=12)

    def reload_fields(self) -> None:
        self.fields = text_fields(self.document.document)
        self.line_fields = tuple(field for field in self.fields if field.kind != "credits")
        self.credit_fields = tuple(field for field in self.fields if field.kind == "credits")
        self.line_list.delete(0, tk.END)
        for field in self.line_fields:
            self.line_list.insert(tk.END, f"{field.label} [{field.width}]")
        self.credit_list.delete(0, tk.END)
        for field in self.credit_fields:
            self.credit_list.insert(tk.END, field.label)
        self.line_list.selection_set(min(self.line_index.get(), len(self.line_fields) - 1))
        self.credit_list.selection_set(min(self.credit_index.get(), len(self.credit_fields) - 1))
        self.select_line()
        self.select_credit()
        self.load_raw()
        self.refresh_title()

    def selected_field(self, credits: bool) -> TextField:
        fields = self.credit_fields if credits else self.line_fields
        index = self.credit_index.get() if credits else self.line_index.get()
        return fields[index]

    def select_line(self) -> None:
        selection = self.line_list.curselection()
        if selection:
            self.line_index.set(selection[0])
        field = self.selected_field(False)
        value = str(value_at(self.document.document, field.path))
        self.text_value.set(value)
        self.draw_glyphs(self.line_canvas, value, field.kind)

    def select_credit(self) -> None:
        selection = self.credit_list.curselection()
        if selection:
            self.credit_index.set(selection[0])
        field = self.selected_field(True)
        value = str(value_at(self.document.document, field.path))
        self.credit_value.set(value)
        self.draw_glyphs(self.credit_canvas, value, field.kind)

    def draw_glyphs(self, canvas: tk.Canvas, text: str, kind: str) -> None:
        canvas.delete("all")
        remap = self.document.manifest["ending_credits"]["source_to_tile_remap"]
        for index, tile in enumerate(glyph_tiles(text, kind, remap)):
            pixels = self.chr_document.tiles[global_tile_index(3, 1, tile)]
            for y, row in enumerate(pixels):
                for x, color in enumerate(row):
                    canvas.create_rectangle(
                        index * 24 + x * 3,
                        35 + y * 3,
                        index * 24 + (x + 1) * 3,
                        35 + (y + 1) * 3,
                        fill=GLYPH_COLORS[color],
                        outline="",
                    )
        canvas.configure(scrollregion=(0, 0, max(800, len(text) * 24), 100))

    def apply_field(self, credits: bool) -> None:
        field = self.selected_field(credits)
        value = self.credit_value.get() if credits else self.text_value.get()
        try:
            if self.document.change(lambda data: edit_fixed_text(data, field, value)):
                self.status.set(f"Updated {field.label}; save with Ctrl+S")
                self.reload_fields()
        except (KeyError, TypeError, ValueError, UnicodeError) as exc:
            messagebox.showerror("Text Studio", str(exc), parent=self)

    def apply_line(self) -> None:
        self.apply_field(False)

    def apply_credit(self) -> None:
        self.apply_field(True)

    def raw_rows(self) -> list[str]:
        if self.raw_collection.get() == "ending_nametable_rows":
            return self.document.document["ending_nametable_rows"]
        return [
            record["hex"]
            for record in self.document.document["title_records"]
            if "hex" in record
        ]

    def load_raw(self) -> None:
        rows = self.raw_rows()
        self.raw_box.configure(values=[str(index) for index in range(len(rows))])
        index = min(self.raw_index.get(), len(rows) - 1)
        self.raw_index.set(index)
        self.raw_box.current(index)
        self.load_raw_value()

    def load_raw_value(self) -> None:
        rows = self.raw_rows()
        value = rows[self.raw_index.get()]
        self.raw_value.set(value)
        self.raw_preview.configure(state="normal")
        self.raw_preview.delete("1.0", tk.END)
        self.raw_preview.insert("1.0", value)
        self.raw_preview.configure(state="disabled")

    def apply_raw(self) -> None:
        collection = self.raw_collection.get()
        index = self.raw_index.get()
        try:
            if collection == "ending_nametable_rows":
                action = lambda data: edit_hex_row(data, collection, index, self.raw_value.get())
            else:
                raw_indexes = [
                    record_index
                    for record_index, record in enumerate(self.document.document["title_records"])
                    if "hex" in record
                ]
                record_index = raw_indexes[index]

                def action(data):
                    old = bytes.fromhex(data["title_records"][record_index]["hex"])
                    replacement = bytes.fromhex(self.raw_value.get())
                    if len(replacement) != len(old):
                        raise ValueError(f"title record must remain exactly {len(old)} bytes")
                    data["title_records"][record_index]["hex"] = replacement.hex(" ")

            if self.document.change(action):
                self.status.set("Updated fixed-width raw presentation row")
                self.reload_fields()
        except (KeyError, TypeError, ValueError) as exc:
            messagebox.showerror("Text Studio", str(exc), parent=self)

    def undo(self) -> None:
        if self.document.undo():
            self.reload_fields()

    def redo(self) -> None:
        if self.document.redo():
            self.reload_fields()

    def refresh_title(self) -> None:
        marker = " *" if self.document.dirty else ""
        self.title(f"Doraemon Text Studio [{self.profile}]{marker}")

    def save(self) -> None:
        try:
            self.document.save()
            self.status.set("Saved text workspace")
            self.refresh_title()
        except (OSError, ValueError, KeyError, TypeError) as exc:
            messagebox.showerror("Text Studio", str(exc), parent=self)

    def build_rom(self) -> None:
        self.save()
        if self.document.dirty:
            return
        subprocess.Popen(
            ["make", "text-content-rom", f"PROFILE={self.profile}"],
            cwd=self.project_root,
        )

    def close(self) -> None:
        if self.document.dirty and not messagebox.askyesno(
            "Text Studio", "Discard unsaved text edits?", parent=self
        ):
            return
        self.destroy()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project-root", type=Path, default=PROJECT_ROOT)
    parser.add_argument("--workspace", type=Path, default=Path("content/workspace"))
    parser.add_argument("--profile", choices=("original", "rev_a"), default="original")
    parser.add_argument("--chr", type=Path, required=True)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    project_root = args.project_root.resolve()
    workspace_root = args.workspace if args.workspace.is_absolute() else project_root / args.workspace
    chr_path = args.chr if args.chr.is_absolute() else project_root / args.chr
    workspace = TextWorkspace(project_root, workspace_root, args.profile)
    try:
        workspace.initialize()
        document = workspace.load()
        chr_document = ChrDocument.load(chr_path)
        fields = text_fields(document.document)
        if args.check:
            print(
                f"[OK] Text Studio [{args.profile}]: {document.encoded_size} bytes, "
                f"{len(fields)} fixed text fields, 32 ending rows, "
                f"{sum('hex' in record for record in document.document['title_records'])} raw title records"
            )
            return 0
        app = TextStudio(document, chr_document, project_root, args.profile)
        app.mainloop()
        return 0
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] Text Studio failed: {exc}")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
