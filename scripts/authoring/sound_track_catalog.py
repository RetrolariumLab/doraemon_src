"""Evidence-backed names for every physical Doraemon music header."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Any


@dataclass(frozen=True)
class TrackIdentity:
    driver_name: str
    track_id: int
    title: str
    usage: str


TRACK_IDENTITIES = (
    TrackIdentity("world1-audio", 1, "City - Starting Area", "area 0"),
    TrackIdentity("world1-audio", 2, "Underground - Main", "areas 3-7 and 10-11"),
    TrackIdentity("world1-audio", 3, "Underground - Deep Rooms", "areas 8-9"),
    TrackIdentity("world1-audio", 4, "City - Cross Area", "area 1"),
    TrackIdentity("world1-audio", 5, "Underground Finale", "area 2"),
    TrackIdentity("world1-audio", 6, "Bull Robo Boss", "finale boss request"),
    TrackIdentity("world1-audio", 7, "Player Defeat", "death sequence"),
    TrackIdentity("world1-audio", 8, "Chapter Clear", "World 1 completion"),
    TrackIdentity("world2-audio", 1, "Cave - Part 1", "stage 0"),
    TrackIdentity("world2-audio", 2, "Cave - Part 2", "stage 1"),
    TrackIdentity("world2-audio", 3, "Cave - Part 3", "stage 2"),
    TrackIdentity("world2-audio", 4, "Stage Boss", "boss encounter"),
    TrackIdentity("world2-audio", 5, "Boss Defeated", "stage completion"),
    TrackIdentity("world2-audio", 6, "Player Defeat", "death sequence"),
    TrackIdentity("world3-audio", 1, "Underwater - Upper Rooms", "room class 0"),
    TrackIdentity("world3-audio", 2, "Underwater - Middle Rooms", "room class 1"),
    TrackIdentity("world3-audio", 3, "Mid-Boss Formation", "octopus and dragon encounters"),
    TrackIdentity(
        "world3-audio",
        4,
        "Mid-Boss Alternate Mix",
        "physical header; no direct request is proven",
    ),
    TrackIdentity("world3-audio", 5, "Underwater - Lower Rooms", "room class 2"),
    TrackIdentity("world3-audio", 6, "Underwater - Final Room", "room class 3"),
    TrackIdentity("world3-audio", 7, "Chapter Clear", "World 3 completion"),
    TrackIdentity("world3-audio", 8, "Player Defeat", "death sequence"),
    TrackIdentity("shell-audio", 1, "Title Screen", "title and attract presentation"),
    TrackIdentity("shell-audio", 2, "Ending - Opening", "ending opening"),
    TrackIdentity("shell-audio", 3, "Ending - Credits", "ending credits"),
    TrackIdentity("shell-audio", 4, "Game Over", "game-over screen"),
)


_BY_KEY = {
    (identity.driver_name, identity.track_id): identity
    for identity in TRACK_IDENTITIES
}


def track_identity(driver_name: str, track_id: int) -> TrackIdentity:
    try:
        return _BY_KEY[(driver_name, track_id)]
    except KeyError as exc:
        raise ValueError(
            f"music catalog has no identity for {driver_name} track {track_id}"
        ) from exc


def validate_track_catalog(document: dict[str, Any]) -> tuple[TrackIdentity, ...]:
    """Require the UI catalog to cover the document once, with no stale rows."""

    document_keys = [
        (str(driver["name"]), int(header["track_id"]))
        for driver in document.get("drivers", [])
        for header in driver.get("headers", [])
    ]
    if len(document_keys) != len(set(document_keys)):
        raise ValueError("music document contains duplicate driver/track headers")
    catalog_keys = [(item.driver_name, item.track_id) for item in TRACK_IDENTITIES]
    if len(catalog_keys) != len(set(catalog_keys)):
        raise ValueError("music identity catalog contains duplicate rows")
    missing = sorted(set(document_keys) - set(catalog_keys))
    stale = sorted(set(catalog_keys) - set(document_keys))
    if missing or stale:
        raise ValueError(
            f"music identity coverage mismatch: missing={missing}, stale={stale}"
        )
    return tuple(_BY_KEY[key] for key in document_keys)
