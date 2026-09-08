"""Embedded piano-roll and host synthesizer panel for Sound Studio."""

from __future__ import annotations

import math
from pathlib import Path
import sys
import tkinter as tk
from tkinter import ttk

from scripts.authoring.sound_synth import (
    CHANNEL_NAMES,
    DEFAULT_PREVIEW_FRAMES,
    DecodedTrack,
    SynthError,
    decode_track,
    write_preview,
)
from scripts.authoring.sound_track_catalog import track_identity


LANE_COLORS = ("#56b4ff", "#ffcb55", "#79e68c", "#d78cff")


class SoundStudioPlaybackMixin:
    """UI behavior mixed into the main Tk Sound Studio window."""

    def initialize_playback(self, project_root: Path, profile: str, prg: bytes) -> None:
        self.synth_prg = prg
        self.preview_path = (
            project_root / "content" / "workspace" / profile / "sound" / "preview.wav"
        )
        self.channel_enabled = {
            name: tk.BooleanVar(value=True) for name in CHANNEL_NAMES
        }
        self.loop_preview = tk.BooleanVar(value=False)
        self.decoded_preview: DecodedTrack | None = None

    def build_playback_panel(self, parent: ttk.Frame) -> None:
        controls = ttk.Frame(parent, padding=(5, 4))
        controls.pack(fill="x")
        ttk.Button(
            controls, text="Play", command=self.play_selected_track
        ).pack(side="left")
        ttk.Button(
            controls, text="Stop", command=self.stop_embedded_preview
        ).pack(side="left", padx=4)
        ttk.Checkbutton(
            controls, text="Loop", variable=self.loop_preview
        ).pack(side="left", padx=(5, 14))
        for name in CHANNEL_NAMES:
            ttk.Checkbutton(
                controls,
                text=name,
                variable=self.channel_enabled[name],
                command=self.refresh_piano_roll,
            ).pack(side="left", padx=3)
        ttk.Label(
            controls,
            text="Native stream synthesizer · about 20 seconds",
        ).pack(side="right")

        frame = ttk.LabelFrame(parent, text="Piano roll (horizontal: NTSC frames)")
        frame.pack(fill="both", expand=True, padx=4, pady=(0, 4))
        self.piano_roll = tk.Canvas(
            frame,
            height=330,
            background="#101722",
            highlightthickness=0,
        )
        scroll = ttk.Scrollbar(
            frame, orient="horizontal", command=self.piano_roll.xview
        )
        self.piano_roll.configure(xscrollcommand=scroll.set)
        self.piano_roll.pack(fill="both", expand=True)
        scroll.pack(fill="x")
        self.piano_roll.bind("<Configure>", lambda _event: self.draw_piano_roll())

    def selected_header_index(self) -> int:
        selection = self.header_tree.selection()
        if not selection:
            raise SynthError("select a track header before starting playback")
        return self.header_tree.index(selection[0])

    def refresh_piano_roll(self) -> None:
        if not hasattr(self, "piano_roll"):
            return
        try:
            self.decoded_preview = decode_track(
                self.music.document,
                self.synth_prg,
                self.driver_index.get(),
                self.selected_header_index(),
                max_frames=DEFAULT_PREVIEW_FRAMES,
            )
            self.draw_piano_roll()
        except (IndexError, KeyError, TypeError, SynthError, ValueError):
            self.decoded_preview = None
            self.piano_roll.delete("all")

    def draw_piano_roll(self) -> None:
        if not hasattr(self, "piano_roll"):
            return
        canvas = self.piano_roll
        canvas.delete("all")
        decoded = self.decoded_preview
        if decoded is None:
            canvas.create_text(
                16, 16, anchor="nw", fill="#91a0b2", text="Select a track header"
            )
            return
        left = 88
        frame_width = 1.5
        lane_height = 82
        total_frames = max(1, len(decoded.frames))
        width = left + total_frames * frame_width + 30
        tonal_events = [
            event
            for lane in decoded.lanes[:3]
            for event in lane.events
            if event.frequency > 0
        ]
        midi_values = [
            round(69 + 12 * math.log2(event.frequency / 440.0))
            for event in tonal_events
        ]
        low = min(midi_values, default=36)
        high = max(midi_values, default=84)
        span = max(1, high - low)
        for marker in range(0, total_frames + 1, 300):
            x = left + marker * frame_width
            canvas.create_line(x, 0, x, lane_height * 4, fill="#354355")
            canvas.create_text(
                x + 3,
                3,
                anchor="nw",
                fill="#8fa0b4",
                text=f"{marker / 60.0988:.0f}s",
            )
        for lane_index, lane in enumerate(decoded.lanes):
            top = lane_index * lane_height
            enabled = self.channel_enabled[lane.name].get()
            canvas.create_rectangle(
                0,
                top,
                width,
                top + lane_height,
                fill="#111a27" if enabled else "#1d2026",
                outline="#354355",
            )
            canvas.create_text(
                8,
                top + 16,
                anchor="nw",
                fill="#eef4fa" if enabled else "#687480",
                font=("TkDefaultFont", 9, "bold"),
                text=lane.name,
            )
            canvas.create_text(
                8,
                top + 38,
                anchor="nw",
                fill="#8493a4",
                text=f"{len(lane.events)} events",
            )
            for event in lane.events:
                x0 = left + event.start_frame * frame_width
                x1 = min(width - 2, x0 + max(2, event.duration_frames * frame_width))
                if event.frequency <= 0:
                    y = top + lane_height - 15
                    fill = "#344252"
                elif lane_index == 3:
                    y = top + 35
                    fill = LANE_COLORS[lane_index] if enabled else "#4e5260"
                else:
                    midi = round(69 + 12 * math.log2(event.frequency / 440.0))
                    y = top + 59 - (midi - low) * 43 / span
                    fill = LANE_COLORS[lane_index] if enabled else "#4e5260"
                canvas.create_rectangle(
                    x0, y, x1, y + 9, fill=fill, outline=""
                )
                if event.frequency > 0 and x1 - x0 >= 28:
                    canvas.create_text(
                        x0 + 3,
                        y + 4,
                        anchor="w",
                        fill="#09111a",
                        font=("TkFixedFont", 7),
                        text=event.note,
                    )
        canvas.configure(scrollregion=(0, 0, width, lane_height * 4))

    def play_selected_track(self) -> None:
        try:
            driver = self.driver_index.get()
            header = self.selected_header_index()
            enabled = {
                name for name, variable in self.channel_enabled.items() if variable.get()
            }
            if not enabled:
                raise SynthError("enable at least one synthesizer channel")
            self.stop_embedded_preview(update_status=False)
            self.decoded_preview = write_preview(
                self.music.document,
                self.synth_prg,
                driver,
                header,
                self.preview_path,
                enabled_channels=enabled,
            )
            self.draw_piano_roll()
            if sys.platform == "win32":
                import winsound

                flags = winsound.SND_FILENAME | winsound.SND_ASYNC
                if self.loop_preview.get():
                    flags |= winsound.SND_LOOP
                winsound.PlaySound(str(self.preview_path), flags)
            track = self.music.document["drivers"][driver]["headers"][header]
            driver_name = str(self.music.document["drivers"][driver]["name"])
            identity = track_identity(driver_name, int(track["track_id"]))
            self.status.set(
                f"Playing {identity.title} in the embedded NES synthesizer"
            )
        except (IndexError, KeyError, OSError, SynthError, TypeError, ValueError) as exc:
            self.show_playback_error(str(exc))

    def stop_embedded_preview(self, update_status: bool = True) -> None:
        if sys.platform == "win32":
            import winsound

            winsound.PlaySound(None, winsound.SND_PURGE)
        if update_status:
            self.status.set("Sound preview stopped")

    def show_playback_error(self, detail: str) -> None:
        from tkinter import messagebox

        messagebox.showerror("Sound Studio", detail, parent=self)
