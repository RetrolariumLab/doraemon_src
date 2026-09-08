#!/usr/bin/env python3
"""Visual editor for Doraemon music streams, envelopes, and effect routing."""

from __future__ import annotations

import argparse
from dataclasses import dataclass
import json
from pathlib import Path
import subprocess
import sys
import tkinter as tk
from tkinter import messagebox, ttk
from typing import Any


SCRIPTS = Path(__file__).resolve().parent.parent
if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))

from scripts.validation.audio import audio_streams
from scripts.authoring.sound_studio_model import (
    EffectPriorityDocument,
    SoundDocument,
    SoundWorkspace,
    edit_event,
    load_json,
    swap_request_slots,
)
from scripts.authoring.sound_preview import selected_track
from scripts.authoring.sound_studio_playback import SoundStudioPlaybackMixin
from scripts.authoring.sound_synth import decode_track
from scripts.authoring.sound_track_catalog import track_identity, validate_track_catalog


PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent
EFFECTS_PATH = Path("config/authoring/audio/audio_effects.json")
CHANNEL_NAMES = ("pulse 1", "pulse 2", "triangle", "noise")


@dataclass(frozen=True)
class EventRow:
    index: int
    address: int
    kind: str
    text: str


@dataclass(frozen=True)
class EffectRow:
    request: int
    slot: int
    source_request: int
    canonical_role: str
    routed_role: str


def event_rows(
    document: dict[str, Any], driver_index: int, segment_index: int
) -> tuple[EventRow, ...]:
    segment = document["drivers"][driver_index]["segments"][segment_index]
    cursor = audio_streams.number(segment["address"])
    rows: list[EventRow] = []
    for index, text in enumerate(segment["events"]):
        token = audio_streams.parse_event(str(text), cursor)
        rows.append(EventRow(index, cursor, token.kind, str(text)))
        cursor += len(token.raw)
    return tuple(rows)


def envelope_locations(document: dict[str, Any]) -> tuple[tuple[int, int, int], ...]:
    result: list[tuple[int, int, int]] = []
    for driver_index, driver in enumerate(document["drivers"]):
        for segment_index, segment in enumerate(driver["segments"]):
            for event_index, text in enumerate(segment["events"]):
                if str(text).startswith("SetEnvelopeVolume "):
                    result.append((driver_index, segment_index, event_index))
    return tuple(result)


def effect_rows(
    document: dict[str, Any],
    canonical: dict[str, Any],
    effects: dict[str, Any],
    driver_index: int,
) -> tuple[EffectRow, ...]:
    driver = document["drivers"][driver_index]
    base = canonical["drivers"][driver_index]
    role_driver = next(
        item for item in effects["drivers"] if item["name"] == driver["name"]
    )
    roles = role_driver["request_roles"]
    slot_owners = {int(slot): index for index, slot in enumerate(base["slots"])}
    return tuple(
        EffectRow(
            request=index,
            slot=int(slot),
            source_request=slot_owners[int(slot)],
            canonical_role=str(roles[index]),
            routed_role=str(roles[slot_owners[int(slot)]]),
        )
        for index, slot in enumerate(driver["slots"])
    )


class SoundStudio(SoundStudioPlaybackMixin, tk.Tk):
    def __init__(
        self,
        music: SoundDocument,
        priorities: EffectPriorityDocument,
        effects: dict[str, Any],
        project_root: Path,
        profile: str,
        prg: bytes,
    ) -> None:
        super().__init__()
        self.music = music
        self.priorities = priorities
        self.effects = effects
        self.project_root = project_root
        self.profile = profile
        self.driver_index = tk.IntVar(value=0)
        self.segment_index = tk.IntVar(value=0)
        self.header_index = 0
        self.event_value = tk.StringVar()
        self.effect_driver_index = tk.IntVar(value=0)
        self.effect_target = tk.IntVar(value=0)
        self.status = tk.StringVar()
        self.initialize_playback(project_root, profile, prg)
        self.geometry("1180x760")
        self.minsize(900, 620)
        self.protocol("WM_DELETE_WINDOW", self.close)
        self.bind("<Control-s>", lambda _event: self.save())
        self.build_ui()
        self.reload_music()
        self.reload_effects()

    def build_ui(self) -> None:
        notebook = ttk.Notebook(self)
        notebook.pack(fill="both", expand=True, padx=8, pady=8)
        music = ttk.Frame(notebook, padding=8)
        envelopes = ttk.Frame(notebook, padding=8)
        effects = ttk.Frame(notebook, padding=8)
        notebook.add(music, text="Music streams")
        notebook.add(envelopes, text="Envelope commands")
        notebook.add(effects, text="Effect requests")
        self.build_music_tab(music)
        self.build_envelope_tab(envelopes)
        self.build_effect_tab(effects)

        footer = ttk.Frame(self, padding=(8, 0, 8, 8))
        footer.pack(fill="x")
        ttk.Button(footer, text="Undo music", command=self.undo_music).pack(side="left")
        ttk.Button(footer, text="Redo music", command=self.redo_music).pack(side="left", padx=4)
        ttk.Button(footer, text="Undo effects", command=self.undo_effects).pack(side="left", padx=(14, 4))
        ttk.Button(footer, text="Redo effects", command=self.redo_effects).pack(side="left")
        ttk.Button(footer, text="Save", command=self.save).pack(side="left", padx=(14, 4))
        ttk.Button(footer, text="Build ROM", command=self.build_rom).pack(side="left")
        ttk.Label(footer, textvariable=self.status).pack(side="left", padx=15)

    def driver_names(self) -> tuple[str, ...]:
        return tuple(driver["name"] for driver in self.music.document["drivers"])

    def build_music_tab(self, parent: ttk.Frame) -> None:
        controls = ttk.Frame(parent)
        controls.pack(fill="x")
        ttk.Label(controls, text="Driver:").pack(side="left")
        self.driver_box = ttk.Combobox(controls, state="readonly", width=20)
        self.driver_box.pack(side="left", padx=5)
        self.driver_box.bind("<<ComboboxSelected>>", lambda _event: self.select_driver())
        ttk.Label(controls, text="Reachable segment:").pack(side="left", padx=(16, 3))
        self.segment_box = ttk.Combobox(controls, state="readonly", width=28)
        self.segment_box.pack(side="left")
        self.segment_box.bind("<<ComboboxSelected>>", lambda _event: self.select_segment())
        music_panes = ttk.Panedwindow(parent, orient="vertical")
        music_panes.pack(fill="both", expand=True, pady=8)
        panes = ttk.Panedwindow(music_panes, orient="horizontal")
        music_panes.add(panes, weight=2)
        headers = ttk.Frame(panes)
        events = ttk.Frame(panes)
        panes.add(headers, weight=2)
        panes.add(events, weight=3)
        self.header_tree = ttk.Treeview(
            headers,
            columns=("track", "title", *CHANNEL_NAMES),
            show="headings",
            height=12,
        )
        for channel in ("track", "title", *CHANNEL_NAMES):
            self.header_tree.heading(channel, text=channel)
            self.header_tree.column(
                channel,
                width=(
                    210
                    if channel == "title"
                    else (58 if channel == "track" else 82)
                ),
                anchor="w" if channel == "title" else "center",
            )
        self.header_tree.pack(fill="both", expand=True)
        self.header_tree.bind(
            "<<TreeviewSelect>>", lambda _event: self.select_track_header()
        )
        self.event_list = tk.Listbox(events, font="TkFixedFont", exportselection=False)
        self.event_list.pack(fill="both", expand=True)
        self.event_list.bind("<<ListboxSelect>>", lambda _event: self.select_event())
        ttk.Entry(events, textvariable=self.event_value, font="TkFixedFont").pack(fill="x", pady=6)
        ttk.Button(events, text="Apply fixed-width event", command=self.apply_event).pack(anchor="w")
        playback = ttk.Frame(music_panes)
        music_panes.add(playback, weight=2)
        self.build_playback_panel(playback)

    def build_envelope_tab(self, parent: ttk.Frame) -> None:
        ttk.Label(
            parent,
            text="Every $EF command sets the channel base volume and envelope mode. "
            "Select an entry to jump to the native stream event.",
            wraplength=900,
        ).pack(anchor="w")
        self.envelope_list = tk.Listbox(parent, font="TkFixedFont", exportselection=False)
        self.envelope_list.pack(fill="both", expand=True, pady=8)
        self.envelope_list.bind("<Double-Button-1>", lambda _event: self.jump_to_envelope())
        ttk.Button(parent, text="Open selected stream event", command=self.jump_to_envelope).pack(anchor="w")

    def build_effect_tab(self, parent: ttk.Frame) -> None:
        controls = ttk.Frame(parent)
        controls.pack(fill="x")
        ttk.Label(controls, text="Driver:").pack(side="left")
        self.effect_driver_box = ttk.Combobox(controls, state="readonly", width=20)
        self.effect_driver_box.pack(side="left", padx=5)
        self.effect_driver_box.bind("<<ComboboxSelected>>", lambda _event: self.select_effect_driver())
        ttk.Label(controls, text="Exchange with request:").pack(side="left", padx=(16, 3))
        self.effect_target_box = ttk.Combobox(controls, state="readonly", width=8)
        self.effect_target_box.pack(side="left")
        ttk.Button(controls, text="Swap routed effects", command=self.swap_effect).pack(side="left", padx=6)
        self.effect_list = tk.Listbox(parent, font="TkFixedFont", exportselection=False)
        self.effect_list.pack(fill="both", expand=True, pady=8)
        self.effect_list.bind("<<ListboxSelect>>", lambda _event: self.select_effect())

    def reload_music(self) -> None:
        names = self.driver_names()
        self.driver_box.configure(values=names)
        index = min(self.driver_index.get(), len(names) - 1)
        self.driver_index.set(index)
        self.driver_box.current(index)
        self.load_driver()
        self.load_envelopes()
        self.refresh_title()

    def select_driver(self) -> None:
        self.driver_index.set(self.driver_box.current())
        self.segment_index.set(0)
        self.header_index = 0
        self.load_driver()

    def load_driver(self) -> None:
        driver = self.music.document["drivers"][self.driver_index.get()]
        for item in self.header_tree.get_children():
            self.header_tree.delete(item)
        for header in driver["headers"]:
            identity = track_identity(
                str(driver["name"]), int(header["track_id"])
            )
            self.header_tree.insert(
                "",
                "end",
                values=(header["track_id"], identity.title, *header["channels"]),
            )
        children = self.header_tree.get_children()
        if children:
            self.header_index = min(self.header_index, len(children) - 1)
            self.header_tree.selection_set(children[self.header_index])
            self.header_tree.focus(children[self.header_index])
        segments = tuple(
            f"{segment['address']}-{segment['end_address']} ({segment['size']} bytes)"
            for segment in driver["segments"]
        )
        self.segment_box.configure(values=segments)
        index = min(self.segment_index.get(), len(segments) - 1)
        self.segment_index.set(index)
        self.segment_box.current(index)
        self.load_events()
        self.refresh_piano_roll()

    def select_segment(self) -> None:
        self.segment_index.set(self.segment_box.current())
        self.load_events()

    def select_track_header(self) -> None:
        selection = self.header_tree.selection()
        if not selection:
            return
        self.header_index = self.header_tree.index(selection[0])
        track = selected_track(
            self.music.document,
            self.driver_index.get(),
            self.header_index,
        )
        identity = track_identity(track.driver_name, track.track_id)
        self.status.set(f"Selected {identity.title} ({identity.usage})")
        self.refresh_piano_roll()

    def load_events(self) -> None:
        self.event_list.delete(0, tk.END)
        for row in event_rows(
            self.music.document,
            self.driver_index.get(),
            self.segment_index.get(),
        ):
            self.event_list.insert(
                tk.END,
                f"${row.address:04X}  {row.kind:8}  {row.text}",
            )
        if self.event_list.size():
            self.event_list.selection_set(0)
            self.select_event()

    def select_event(self) -> None:
        selection = self.event_list.curselection()
        if not selection:
            return
        row = event_rows(
            self.music.document,
            self.driver_index.get(),
            self.segment_index.get(),
        )[selection[0]]
        self.event_value.set(row.text)

    def apply_event(self) -> None:
        selection = self.event_list.curselection()
        if not selection:
            return
        try:
            changed = self.music.change(
                lambda data: edit_event(
                    data,
                    self.driver_index.get(),
                    self.segment_index.get(),
                    selection[0],
                    self.event_value.get(),
                )
            )
            if changed:
                self.status.set("Updated music event; save with Ctrl+S")
                self.reload_music()
        except (KeyError, TypeError, ValueError) as exc:
            messagebox.showerror("Sound Studio", str(exc), parent=self)

    def load_envelopes(self) -> None:
        self.envelope_list.delete(0, tk.END)
        for driver, segment, event in envelope_locations(self.music.document):
            row = event_rows(self.music.document, driver, segment)[event]
            name = self.music.document["drivers"][driver]["name"]
            self.envelope_list.insert(
                tk.END,
                f"{name:14} ${row.address:04X}  {row.text}",
            )

    def jump_to_envelope(self) -> None:
        selection = self.envelope_list.curselection()
        if not selection:
            return
        driver, segment, event = envelope_locations(self.music.document)[selection[0]]
        self.driver_index.set(driver)
        self.driver_box.current(driver)
        self.segment_index.set(segment)
        self.load_driver()
        self.segment_box.current(segment)
        self.load_events()
        self.event_list.selection_clear(0, tk.END)
        self.event_list.selection_set(event)
        self.event_list.see(event)
        self.select_event()

    def reload_effects(self) -> None:
        names = tuple(driver["name"] for driver in self.priorities.document["drivers"])
        self.effect_driver_box.configure(values=names)
        index = min(self.effect_driver_index.get(), len(names) - 1)
        self.effect_driver_index.set(index)
        self.effect_driver_box.current(index)
        self.load_effect_rows()
        self.refresh_title()

    def select_effect_driver(self) -> None:
        self.effect_driver_index.set(self.effect_driver_box.current())
        self.load_effect_rows()

    def load_effect_rows(self) -> None:
        rows = effect_rows(
            self.priorities.document,
            self.priorities.canonical,
            self.effects,
            self.effect_driver_index.get(),
        )
        self.effect_list.delete(0, tk.END)
        for row in rows:
            self.effect_list.insert(
                tk.END,
                f"request ${row.request:02X} -> slot ${row.slot:02X} "
                f"(request ${row.source_request:02X})  {row.routed_role}",
            )
        self.effect_target_box.configure(values=tuple(f"${row.request:02X}" for row in rows))
        self.effect_target_box.current(0)
        if rows:
            self.effect_list.selection_set(0)
            self.select_effect()

    def select_effect(self) -> None:
        selection = self.effect_list.curselection()
        if selection:
            self.effect_target.set(selection[0])
            self.effect_target_box.current(selection[0])

    def swap_effect(self) -> None:
        selection = self.effect_list.curselection()
        if not selection:
            return
        target = self.effect_target_box.current()
        try:
            changed = self.priorities.change(
                lambda data: swap_request_slots(
                    data,
                    self.effect_driver_index.get(),
                    selection[0],
                    target,
                )
            )
            if changed:
                self.status.set("Exchanged two effect request slots")
                self.reload_effects()
        except (KeyError, TypeError, ValueError) as exc:
            messagebox.showerror("Sound Studio", str(exc), parent=self)

    def undo_music(self) -> None:
        if self.music.undo():
            self.reload_music()

    def redo_music(self) -> None:
        if self.music.redo():
            self.reload_music()

    def undo_effects(self) -> None:
        if self.priorities.undo():
            self.reload_effects()

    def redo_effects(self) -> None:
        if self.priorities.redo():
            self.reload_effects()

    def refresh_title(self) -> None:
        marker = " *" if self.music.dirty or self.priorities.dirty else ""
        self.title(f"Doraemon Sound Studio [{self.profile}]{marker}")

    def save(self) -> None:
        try:
            self.music.save()
            self.priorities.save()
            self.status.set("Saved sound workspace")
            self.refresh_title()
        except (OSError, ValueError, KeyError, TypeError) as exc:
            messagebox.showerror("Sound Studio", str(exc), parent=self)

    def build_rom(self) -> None:
        self.save()
        if self.music.dirty or self.priorities.dirty:
            return
        subprocess.Popen(
            ["make", "sound-content-rom", f"PROFILE={self.profile}"],
            cwd=self.project_root,
        )

    def close(self) -> None:
        if (self.music.dirty or self.priorities.dirty) and not messagebox.askyesno(
            "Sound Studio", "Discard unsaved sound edits?", parent=self
        ):
            return
        self.stop_embedded_preview(update_status=False)
        self.destroy()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project-root", type=Path, default=PROJECT_ROOT)
    parser.add_argument("--workspace", type=Path, default=Path("content/workspace"))
    parser.add_argument("--profile", choices=("original", "rev_a"), default="original")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    project_root = args.project_root.resolve()
    workspace_root = args.workspace if args.workspace.is_absolute() else project_root / args.workspace
    workspace = SoundWorkspace(project_root, workspace_root, args.profile)
    try:
        workspace.initialize()
        music = workspace.load()
        catalog = validate_track_catalog(music.document)
        priorities = workspace.load_priorities()
        effects = load_json(project_root / EFFECTS_PATH)
        prg = (project_root / "assets/generated/prg/doraemon.prg").read_bytes()
        envelopes = envelope_locations(music.document)
        if args.check:
            synthesized = 0
            for driver_index, driver in enumerate(music.document["drivers"]):
                for header_index, _header in enumerate(driver["headers"]):
                    decode_track(
                        music.document,
                        prg,
                        driver_index,
                        header_index,
                    )
                    synthesized += 1
            print(
                f"[OK] Sound Studio [{args.profile}]: "
                f"{music.encoded_size} music bytes, "
                f"{synthesized} synthesized and {len(catalog)} named tracks, "
                f"{len(envelopes)} envelope commands, "
                f"{priorities.encoded_size} effect requests"
            )
            return 0
        app = SoundStudio(
            music, priorities, effects, project_root, args.profile, prg
        )
        app.mainloop()
        return 0
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] Sound Studio failed: {exc}")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
