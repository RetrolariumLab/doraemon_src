"""Validated launch contract for native Doraemon track previews in FCEUX."""

from __future__ import annotations

from dataclasses import dataclass
import os
from pathlib import Path
from typing import Any


@dataclass(frozen=True)
class PreviewTrack:
    driver_index: int
    driver_name: str
    bank: int
    header_index: int
    track_id: int

    @property
    def description(self) -> str:
        return f"{self.driver_name} / track {self.track_id}"


def selected_track(
    document: dict[str, Any], driver_index: int, header_index: int
) -> PreviewTrack:
    drivers = document.get("drivers", [])
    if not 0 <= driver_index < len(drivers):
        raise IndexError("sound preview driver is outside the music catalog")
    driver = drivers[driver_index]
    headers = driver.get("headers", [])
    if not 0 <= header_index < len(headers):
        raise IndexError("select a track header before starting preview")
    bank = int(driver["bank"])
    track_id = int(headers[header_index]["track_id"])
    if not 0 <= bank < 4 or not 1 <= track_id <= len(headers):
        raise ValueError("sound preview header has an invalid bank or track ID")
    return PreviewTrack(
        driver_index=driver_index,
        driver_name=str(driver["name"]),
        bank=bank,
        header_index=header_index,
        track_id=track_id,
    )


def preview_rom(project_root: Path, profile: str) -> Path:
    if profile not in {"original", "rev_a"}:
        raise ValueError(f"unsupported sound preview profile: {profile}")
    return (
        project_root
        / "build"
        / "content"
        / profile
        / "doraemon-sound-preview.nes"
    )


def preview_command(fceux: Path, lua: Path, rom: Path) -> list[str]:
    missing = [path for path in (fceux, lua, rom) if not path.is_file()]
    if missing:
        raise ValueError(
            "sound preview input is missing: "
            + ", ".join(str(path) for path in missing)
        )
    return [str(fceux.resolve()), "-lua", str(lua.resolve()), str(rom.resolve())]


def preview_environment(track: PreviewTrack) -> dict[str, str]:
    environment = os.environ.copy()
    environment["DORAEMON_SOUND_PREVIEW_BANK"] = str(track.bank)
    environment["DORAEMON_SOUND_PREVIEW_TRACK"] = str(track.track_id)
    environment["DORAEMON_SOUND_PREVIEW_NAME"] = track.description
    return environment
