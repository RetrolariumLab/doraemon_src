#!/usr/bin/env python3
"""Visual fixed-capacity object editor for all Doraemon chapters."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys
import tkinter as tk
from tkinter import messagebox, simpledialog, ttk
from typing import Any


SCRIPTS = Path(__file__).resolve().parent.parent
if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))

from scripts.authoring.object_artifacts import ARTIFACTS, ObjectArtifactDocument, ObjectWorkspace
from scripts.authoring.world2_level_model import (
    World2ScreenDocument,
    initialize_workspace as initialize_world2_workspace,
    workspace_path as world2_workspace_path,
)
from scripts.authoring.studio_process import BuildLauncher, launch_content_build


PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent
LOCKED_KEYS = {
    "schema_version",
    "format",
    "bank",
    "covered_byte_count",
    "covered_crc32",
    "payload_crc32",
    "id",
    "room_id",
    "channel",
    "index",
    "level",
    "record_count",
    "type_count",
    "state_count",
    "capacity",
    "size",
    "offset",
    "name",
    "command",
    "kind",
    "fields",
}


def path_key(path: tuple[str | int, ...]) -> str | None:
    return next((part for part in reversed(path) if isinstance(part, str)), None)


def editable_path(path: tuple[str | int, ...]) -> bool:
    key = path_key(path)
    if key is None or key in LOCKED_KEYS or "address" in key:
        return False
    return not any(part in {"layout", "property_addresses"} for part in path)


def parse_scalar(text: str, original: object) -> object:
    stripped = text.strip()
    if isinstance(original, bool):
        lowered = stripped.lower()
        if lowered not in {"true", "false", "1", "0"}:
            raise ValueError("boolean value must be true/false or 1/0")
        return lowered in {"true", "1"}
    if isinstance(original, int):
        return int(stripped, 0)
    if original is None:
        return None if stripped.lower() in {"", "none", "null"} else int(stripped, 0)
    if isinstance(original, str) and original.lower().startswith("0x"):
        value = int(stripped, 0)
        if value < 0:
            raise ValueError("hexadecimal fields cannot be negative")
        width = max(2, len(original) - 2)
        return f"0x{value:0{width}X}"
    if isinstance(original, str):
        return stripped
    raise ValueError("selected value is not an editable scalar")


def value_at(root: object, path: tuple[str | int, ...]) -> object:
    current = root
    for part in path:
        current = current[part]  # type: ignore[index]
    return current


def set_scalar(root: object, path: tuple[str | int, ...], value: object) -> None:
    if not path:
        raise ValueError("root document cannot be replaced")
    parent = value_at(root, path[:-1])
    parent[path[-1]] = value  # type: ignore[index]


def display_value(value: object) -> str:
    if value is None:
        return "null"
    if isinstance(value, bool):
        return "true" if value else "false"
    return str(value)


class ArtifactBrowser(ttk.Frame):
    def __init__(
        self,
        parent: ttk.Notebook,
        documents: dict[str, ObjectArtifactDocument],
        on_change,
    ) -> None:
        super().__init__(parent, padding=8)
        self.documents = documents
        self.on_change = on_change
        self.artifact_id = tk.StringVar(value=ARTIFACTS[0].id)
        self.status = tk.StringVar()
        self.paths: dict[str, tuple[str | int, ...]] = {}
        self.build_ui()
        self.load_artifact()

    @property
    def document(self) -> ObjectArtifactDocument:
        return self.documents[self.artifact_id.get()]

    def build_ui(self) -> None:
        controls = ttk.Frame(self)
        controls.pack(fill="x")
        ttk.Label(controls, text="Artifact:").pack(side="left")
        artifact_box = ttk.Combobox(
            controls,
            state="readonly",
            width=36,
            textvariable=self.artifact_id,
            values=[artifact.id for artifact in ARTIFACTS],
        )
        artifact_box.pack(side="left", padx=6)
        artifact_box.bind("<<ComboboxSelected>>", lambda _event: self.load_artifact())
        ttk.Button(controls, text="Undo", command=self.undo).pack(side="left", padx=3)
        ttk.Button(controls, text="Redo", command=self.redo).pack(side="left", padx=3)

        body = ttk.Panedwindow(self, orient="horizontal")
        body.pack(fill="both", expand=True, pady=(8, 0))
        tree_frame = ttk.Frame(body)
        preview_frame = ttk.LabelFrame(body, text="Overview", padding=8)
        body.add(tree_frame, weight=3)
        body.add(preview_frame, weight=2)
        self.tree = ttk.Treeview(
            tree_frame,
            columns=("value", "access"),
            show="tree headings",
            selectmode="browse",
        )
        self.tree.heading("#0", text="Field")
        self.tree.heading("value", text="Value")
        self.tree.heading("access", text="Access")
        self.tree.column("#0", width=270)
        self.tree.column("value", width=150)
        self.tree.column("access", width=70, anchor="center")
        scrollbar = ttk.Scrollbar(tree_frame, orient="vertical", command=self.tree.yview)
        self.tree.configure(yscrollcommand=scrollbar.set)
        self.tree.pack(side="left", fill="both", expand=True)
        scrollbar.pack(side="right", fill="y")
        self.tree.tag_configure("editable", foreground="#006020")
        self.tree.tag_configure("locked", foreground="#777777")
        self.tree.bind("<Double-1>", self.edit_selected)
        self.preview = tk.Canvas(
            preview_frame, width=480, height=360, bg="#101418", highlightthickness=0
        )
        self.preview.pack(fill="both", expand=True)
        ttk.Label(self, textvariable=self.status).pack(anchor="w", pady=(6, 0))

    def add_node(
        self,
        parent: str,
        label: str,
        value: object,
        path: tuple[str | int, ...],
    ) -> None:
        if isinstance(value, dict):
            node = self.tree.insert(parent, "end", text=label, open=not parent)
            for key, child in value.items():
                self.add_node(node, str(key), child, (*path, key))
            return
        if isinstance(value, list):
            node = self.tree.insert(
                parent, "end", text=f"{label} [{len(value)}]", open=False
            )
            for index, child in enumerate(value):
                self.add_node(node, f"[{index}]", child, (*path, index))
            return
        access = "edit" if editable_path(path) else "locked"
        node = self.tree.insert(
            parent,
            "end",
            text=label,
            values=(display_value(value), access),
            tags=("editable" if access == "edit" else "locked",),
        )
        self.paths[node] = path

    def load_artifact(self) -> None:
        self.tree.delete(*self.tree.get_children())
        self.paths.clear()
        self.add_node("", self.artifact_id.get(), self.document.document, ())
        self.status.set(
            f"{self.artifact_id.get()}: {len(self.document.validate())} encoded bytes; "
            "double-click a green scalar to edit"
        )
        self.draw_overview()

    def edit_selected(self, _event: object = None) -> None:
        selection = self.tree.selection()
        if not selection or selection[0] not in self.paths:
            return
        path = self.paths[selection[0]]
        if not editable_path(path):
            self.status.set("That field defines layout or identity and is read-only")
            return
        original = value_at(self.document.document, path)
        text = simpledialog.askstring(
            "Object Studio",
            f"New value for {'.'.join(map(str, path))}:",
            initialvalue=display_value(original),
            parent=self,
        )
        if text is None:
            return
        try:
            replacement = parse_scalar(text, original)
            changed = self.document.change(
                lambda data: set_scalar(data, path, replacement)
            )
            if changed:
                self.load_artifact()
                self.on_change()
        except (KeyError, TypeError, ValueError) as exc:
            messagebox.showerror("Object Studio", str(exc), parent=self)

    def undo(self) -> None:
        if self.document.undo():
            self.load_artifact()
            self.on_change()

    def redo(self) -> None:
        if self.document.redo():
            self.load_artifact()
            self.on_change()

    def draw_overview(self) -> None:
        self.preview.delete("all")
        data = self.document.document
        artifact = self.artifact_id.get()
        if artifact == "world1_object_placements":
            colors = ("#43b8ff", "#ffb84d")
            for list_index, placement_list in enumerate(data["placement_lists"]):
                for record in placement_list["records"]:
                    x = 18 + int(record["x_cell"]) * 1.7
                    y = 18 + int(record["y_cell"]) * 1.2
                    self.preview.create_oval(
                        x - 2, y - 2, x + 2, y + 2, fill=colors[list_index], outline=""
                    )
            self.preview.create_text(
                12, 340, anchor="w", fill="white", text="blue underground / orange city"
            )
            return
        if artifact in {"world3_object_catalog", "world3_transient_spawns"}:
            counts = [0] * 64
            if artifact == "world3_object_catalog":
                for record in data["persistent_registry"]["records"]:
                    counts[int(record["room"], 0)] += 1
            else:
                for room in data["rooms"]:
                    counts[int(room["room_id"], 0)] = sum(
                        int(channel["count"], 0)
                        if isinstance(channel["count"], str)
                        else int(channel["count"])
                        for channel in room["channels"]
                    )
            maximum = max(counts) or 1
            for room, count in enumerate(counts):
                x, y = 15 + (room % 8) * 52, 15 + (room // 8) * 40
                shade = min(255, 45 + int(count / maximum * 210))
                color = f"#{shade:02x}7040"
                self.preview.create_rectangle(x, y, x + 46, y + 34, fill=color, outline="#222")
                self.preview.create_text(x + 23, y + 17, text=f"{room:02X}:{count}", fill="white")
            return
        self.preview.create_text(
            240,
            170,
            width=400,
            fill="white",
            text=(
                f"{artifact}\n\n{len(self.document.validate())} encoded bytes\n"
                "Select and double-click a green value in the typed tree."
            ),
            justify="center",
        )


class World2SpawnPanel(ttk.Frame):
    CELL = 28

    def __init__(self, parent: ttk.Notebook, document: World2ScreenDocument, on_change) -> None:
        super().__init__(parent, padding=8)
        self.document = document
        self.on_change = on_change
        self.selector_id = tk.IntVar(value=0)
        self.state = tk.IntVar(value=0)
        self.selected: tuple[int, int] | None = None
        self.status = tk.StringVar()
        self.build_ui()
        self.draw_screen()

    def build_ui(self) -> None:
        controls = ttk.Frame(self)
        controls.pack(fill="x")
        ttk.Label(controls, text="Screen selector:").pack(side="left")
        box = ttk.Combobox(
            controls,
            state="readonly",
            width=12,
            values=[f"{index:03d}" for index in range(self.document.selector_count)],
        )
        box.current(0)
        box.pack(side="left", padx=5)
        box.bind(
            "<<ComboboxSelected>>",
            lambda _event: (self.selector_id.set(box.current()), self.clear_selection()),
        )
        ttk.Label(controls, text="Enemy state:").pack(side="left", padx=(15, 3))
        ttk.Spinbox(controls, from_=0, to=14, width=6, textvariable=self.state).pack(side="left")
        ttk.Button(controls, text="Apply spawn", command=self.apply).pack(side="left", padx=6)
        ttk.Button(controls, text="Undo", command=self.undo).pack(side="left", padx=2)
        ttk.Button(controls, text="Redo", command=self.redo).pack(side="left", padx=2)
        self.canvas = tk.Canvas(self, width=640, height=500, bg="#0e1116")
        self.canvas.pack(fill="both", expand=True, pady=8)
        self.canvas.bind("<Button-1>", self.select_cell)
        ttk.Label(self, textvariable=self.status).pack(anchor="w")

    def clear_selection(self) -> None:
        self.selected = None
        self.draw_screen()

    def draw_screen(self) -> None:
        self.canvas.delete("all")
        rows = self.document.screen(self.selector_id.get())
        spawn_count = 0
        for y, row in enumerate(rows):
            for x, cell in enumerate(row):
                x0, y0 = x * self.CELL, y * self.CELL
                if cell.token_kind == "spawn":
                    color, text = "#a52f3b", f"E{cell.enemy_state:X}"
                    spawn_count += 1
                elif cell.token_kind == "padding":
                    color, text = "#191919", ""
                else:
                    shade = 32 + (cell.metatile % 12) * 8
                    color, text = f"#{shade:02x}{shade:02x}{shade:02x}", f"{cell.metatile:02X}"
                self.canvas.create_rectangle(
                    x0, y0, x0 + self.CELL, y0 + self.CELL, fill=color, outline="#4a4a4a"
                )
                self.canvas.create_text(
                    x0 + self.CELL // 2,
                    y0 + self.CELL // 2,
                    text=text,
                    fill="white",
                    font=("TkFixedFont", 8),
                )
        if self.selected is not None:
            x, y = self.selected
            self.canvas.create_rectangle(
                x * self.CELL + 1,
                y * self.CELL + 1,
                (x + 1) * self.CELL - 1,
                (y + 1) * self.CELL - 1,
                outline="#ffff40",
                width=3,
            )
        selector = self.document.selector(self.selector_id.get())
        alias = selector.get("alias_of")
        suffix = "" if alias is None else f"; alias of {alias}"
        self.status.set(
            f"Selector {self.selector_id.get():03d}: {spawn_count} visible spawns{suffix}"
        )

    def select_cell(self, event: tk.Event) -> None:
        x, y = event.x // self.CELL, event.y // self.CELL
        try:
            cell = self.document.cell(self.selector_id.get(), x, y)
        except IndexError:
            return
        if cell.token_kind != "spawn":
            self.status.set(f"Cell ({x}, {y}) is {cell.token_kind}, not a spawn")
            return
        self.selected = (x, y)
        self.state.set(int(cell.enemy_state))
        self.draw_screen()

    def apply(self) -> None:
        if self.selected is None:
            self.status.set("Select a red spawn cell first")
            return
        try:
            affected = self.document.edit_spawn(
                self.selector_id.get(), *self.selected, int(self.state.get())
            )
            self.draw_screen()
            self.status.set(
                f"Updated spawn in {affected} identical selector view(s); save with Ctrl+S"
            )
            self.on_change()
        except (KeyError, TypeError, ValueError) as exc:
            messagebox.showerror("Object Studio", str(exc), parent=self)

    def undo(self) -> None:
        if self.document.undo():
            self.draw_screen()
            self.on_change()

    def redo(self) -> None:
        if self.document.redo():
            self.draw_screen()
            self.on_change()


class ObjectStudio(tk.Tk):
    def __init__(
        self,
        documents: dict[str, ObjectArtifactDocument],
        world2: World2ScreenDocument,
        project_root: Path,
        workspace_root: Path,
        profile: str,
        build_launcher: BuildLauncher = launch_content_build,
    ) -> None:
        super().__init__()
        self.documents = documents
        self.world2 = world2
        self.project_root = project_root
        self.workspace_root = workspace_root
        self.profile = profile
        self.build_launcher = build_launcher
        self.geometry("1160x760")
        self.minsize(900, 620)
        self.protocol("WM_DELETE_WINDOW", self.close)
        self.bind("<Control-s>", lambda _event: self.save())
        notebook = ttk.Notebook(self)
        notebook.pack(fill="both", expand=True)
        self.browser = ArtifactBrowser(notebook, documents, self.refresh_title)
        self.spawn_panel = World2SpawnPanel(notebook, world2, self.refresh_title)
        notebook.add(self.browser, text="Typed object data")
        notebook.add(self.spawn_panel, text="World 2 embedded spawns")
        buttons = ttk.Frame(self, padding=6)
        buttons.pack(fill="x")
        ttk.Button(buttons, text="Save all", command=self.save).pack(side="left")
        ttk.Button(buttons, text="Build ROM", command=self.build_rom).pack(side="left", padx=6)
        self.refresh_title()

    def dirty(self) -> bool:
        return self.world2.dirty or any(document.dirty for document in self.documents.values())

    def refresh_title(self) -> None:
        marker = " *" if self.dirty() else ""
        self.title(f"Doraemon Object Studio [{self.profile}]{marker}")

    def save(self) -> None:
        try:
            for document in self.documents.values():
                if document.dirty:
                    document.save()
            if self.world2.dirty:
                self.world2.save()
            self.refresh_title()
        except (OSError, ValueError, KeyError, TypeError) as exc:
            messagebox.showerror("Object Studio", str(exc), parent=self)

    def build_rom(self) -> None:
        self.save()
        if self.dirty():
            return
        self.build_launcher(
            self.project_root,
            "object-content-rom",
            self.profile,
            self.workspace_root,
        )

    def close(self) -> None:
        if self.dirty() and not messagebox.askyesno(
            "Object Studio", "Discard unsaved object edits?", parent=self
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
        args.workspace if args.workspace.is_absolute() else project_root / args.workspace
    )
    workspace = ObjectWorkspace(project_root, workspace_root, args.profile)
    try:
        workspace.initialize()
        initialize_world2_workspace(project_root, workspace_root, args.profile)
        documents = workspace.load()
        sizes = workspace.validate()
        world2 = World2ScreenDocument.load(
            world2_workspace_path(workspace_root, args.profile)
        )
        if args.check:
            spawns = sum(
                cell.token_kind == "spawn"
                for selector in range(world2.selector_count)
                for row in world2.screen(selector)
                for cell in row
            )
            print(
                f"[OK] Object Studio [{args.profile}]: {len(sizes)} artifacts, "
                f"{sum(sizes.values())} fixed bytes, {world2.selector_count} "
                f"World 2 selectors, {spawns} selector-view spawns"
            )
            return 0
        app = ObjectStudio(
            documents,
            world2,
            project_root,
            workspace_root,
            args.profile,
        )
        app.mainloop()
        return 0
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] Object Studio failed: {exc}")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
