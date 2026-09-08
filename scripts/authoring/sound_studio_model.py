#!/usr/bin/env python3
"""Atomic fixed-capacity model for Doraemon's four music drivers."""

from __future__ import annotations

import copy
import json
from pathlib import Path
import sys
from typing import Any, Callable


SCRIPTS = Path(__file__).resolve().parent.parent
if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))

from scripts.validation.audio import audio_streams
from scripts.authoring.graphics_studio_model import PROFILE_MANIFEST, atomic_write


CANONICAL_PATH = Path("data/audio/music_streams.json")
PRIORITY_PATH = Path("data/audio/effect_priorities.json")
PRG_SIZE = 0x20000
STRUCTURAL_COMMANDS = frozenset({
    "EndChannel",
    "RestoreStreamPosition",
    "BeginCountedLoop",
    "RepeatCountedLoop",
    "SelectLoopExit",
    "SaveStreamPosition",
    "CallStream",
    "ReturnFromStream",
    "SelectTrackChannelStream",
})


def load_json(path: Path) -> dict[str, Any]:
    value = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(value, dict):
        raise ValueError(f"JSON document is not an object: {path}")
    return value


def _layout(document: dict[str, Any]) -> dict[str, Any]:
    result = copy.deepcopy(document)
    for driver in result.get("drivers", []):
        for segment in driver.get("segments", []):
            segment.pop("events", None)
    return result


def _event_pairs(
    document: dict[str, Any], canonical: dict[str, Any]
) -> tuple[tuple[audio_streams.Token, audio_streams.Token], ...]:
    pairs: list[tuple[audio_streams.Token, audio_streams.Token]] = []
    for driver, base_driver in zip(document["drivers"], canonical["drivers"]):
        for segment, base_segment in zip(
            driver["segments"], base_driver["segments"]
        ):
            cursor = audio_streams.number(segment["address"])
            base_cursor = audio_streams.number(base_segment["address"])
            if len(segment["events"]) != len(base_segment["events"]):
                raise ValueError("music event count differs from the canonical layout")
            for event, base_event in zip(
                segment["events"], base_segment["events"]
            ):
                token = audio_streams.parse_event(str(event), cursor)
                base = audio_streams.parse_event(str(base_event), base_cursor)
                if token.kind != base.kind or len(token.raw) != len(base.raw):
                    raise ValueError(
                        f"music event class or width changed at ${cursor:04X}"
                    )
                if token.kind == "command" and token.name != base.name:
                    raise ValueError(f"music command changed at ${cursor:04X}")
                if token.name in STRUCTURAL_COMMANDS and token != base:
                    raise ValueError(
                        f"control-flow event is locked at ${cursor:04X}"
                    )
                pairs.append((token, base))
                cursor += len(token.raw)
                base_cursor += len(base.raw)
    return tuple(pairs)


def music_writes(document: dict[str, Any]) -> tuple[tuple[int, int, bytes], ...]:
    writes: list[tuple[int, int, bytes]] = []
    for driver in document["drivers"]:
        bank = int(driver["bank"])
        header = bytearray()
        for track in driver["headers"]:
            for pointer in track["channels"]:
                header.extend(audio_streams.number(pointer).to_bytes(2, "little"))
        writes.append((bank, audio_streams.number(driver["header_address"]), bytes(header)))
        for segment in driver["segments"]:
            address = audio_streams.number(segment["address"])
            cursor = address
            payload = bytearray()
            for event in segment["events"]:
                token = audio_streams.parse_event(str(event), cursor)
                payload.extend(token.raw)
                cursor += len(token.raw)
            writes.append((bank, address, bytes(payload)))
    return tuple(writes)


def apply_music_authoring(prg: bytes, document: dict[str, Any]) -> bytes:
    if len(prg) != PRG_SIZE:
        raise ValueError(f"Doraemon PRG must be exactly {PRG_SIZE} bytes")
    result = bytearray(prg)
    occupied: set[int] = set()
    for bank, address, payload in music_writes(document):
        offset = audio_streams.bank_offset(bank, address)
        indexes = set(range(offset, offset + len(payload)))
        if occupied & indexes:
            raise ValueError("music authoring writes overlap")
        if offset + len(payload) > (bank + 1) * audio_streams.BANK_SIZE:
            raise ValueError("music authoring write crosses a PRG bank")
        occupied.update(indexes)
        result[offset:offset + len(payload)] = payload
    return bytes(result)


def priority_writes(
    document: dict[str, Any]
) -> tuple[tuple[int, int, bytes], ...]:
    return tuple(
        (
            int(driver["bank"]),
            audio_streams.number(driver["address"]),
            bytes(int(value) for value in driver["slots"]),
        )
        for driver in document["drivers"]
    )


def apply_priority_authoring(prg: bytes, document: dict[str, Any]) -> bytes:
    if len(prg) != PRG_SIZE:
        raise ValueError(f"Doraemon PRG must be exactly {PRG_SIZE} bytes")
    result = bytearray(prg)
    for bank, address, payload in priority_writes(document):
        offset = audio_streams.bank_offset(bank, address)
        result[offset:offset + len(payload)] = payload
    return bytes(result)


def swap_request_slots(data: dict[str, Any], driver: int, left: int, right: int) -> None:
    slots = data["drivers"][driver]["slots"]
    if not 0 <= left < len(slots) or not 0 <= right < len(slots):
        raise ValueError("sound request index is outside the driver")
    slots[left], slots[right] = slots[right], slots[left]


def edit_event(
    data: dict[str, Any], driver: int, segment: int, event: int, text: str
) -> None:
    data["drivers"][driver]["segments"][segment]["events"][event] = text.strip()


class SoundDocument:
    def __init__(
        self,
        document: dict[str, Any],
        path: Path,
        canonical: dict[str, Any],
    ) -> None:
        self.document = copy.deepcopy(document)
        self.path = path
        self.canonical = copy.deepcopy(canonical)
        self.undo_stack: list[dict[str, Any]] = []
        self.redo_stack: list[dict[str, Any]] = []
        self.validate()
        self.original = copy.deepcopy(self.document)
        self.saved = copy.deepcopy(self.document)

    @classmethod
    def load(cls, path: Path, canonical_path: Path) -> "SoundDocument":
        return cls(load_json(path), path, load_json(canonical_path))

    @property
    def dirty(self) -> bool:
        return self.document != self.saved

    @property
    def encoded_size(self) -> int:
        return len(audio_streams.encode_authoring(self.document))

    def validate(self) -> bytes:
        if _layout(self.document) != _layout(self.canonical):
            raise ValueError("music layout metadata differs from the canonical layout")
        _event_pairs(self.document, self.canonical)
        return audio_streams.encode_authoring(self.document)

    def change(self, action: Callable[[dict[str, Any]], None]) -> bool:
        before = copy.deepcopy(self.document)
        action(self.document)
        try:
            self.validate()
        except (KeyError, TypeError, ValueError):
            self.document = before
            raise
        if before == self.document:
            return False
        self.undo_stack.append(before)
        self.redo_stack.clear()
        return True

    def undo(self) -> bool:
        if not self.undo_stack:
            return False
        self.redo_stack.append(copy.deepcopy(self.document))
        self.document = self.undo_stack.pop()
        return True

    def redo(self) -> bool:
        if not self.redo_stack:
            return False
        self.undo_stack.append(copy.deepcopy(self.document))
        self.document = self.redo_stack.pop()
        return True

    def save(self) -> Path:
        self.validate()
        atomic_write(
            self.path,
            (json.dumps(self.document, indent=2) + "\n").encode("utf-8"),
        )
        self.saved = copy.deepcopy(self.document)
        return self.path


class SoundWorkspace:
    def __init__(self, project_root: Path, workspace_root: Path, profile: str) -> None:
        self.project_root = project_root.resolve()
        self.workspace_root = workspace_root.resolve()
        profiles = load_json(self.project_root / PROFILE_MANIFEST)
        entries = {entry["id"]: entry for entry in profiles["profiles"]}
        if profile not in entries:
            raise ValueError(f"unsupported content profile: {profile}")
        if entries[profile]["studios"].get("sound") not in {"partial", "supported"}:
            raise ValueError(f"sound authoring is unavailable for {profile}")
        self.profile = profile
        self.path = self.workspace_root / profile / "sound" / "music_streams.json"
        self.canonical_path = self.project_root / CANONICAL_PATH
        self.priority_path = self.workspace_root / profile / "sound" / "effect_priorities.json"
        self.canonical_priority_path = self.project_root / PRIORITY_PATH

    def initialize(self) -> Path | None:
        created: Path | None = None
        for path, canonical in (
            (self.path, self.canonical_path),
            (self.priority_path, self.canonical_priority_path),
        ):
            if not path.exists():
                atomic_write(path, canonical.read_bytes())
                created = path
        return created

    def load(self) -> SoundDocument:
        return SoundDocument.load(self.path, self.canonical_path)

    def load_canonical(self) -> SoundDocument:
        return SoundDocument.load(self.canonical_path, self.canonical_path)

    def load_priorities(self) -> "EffectPriorityDocument":
        return EffectPriorityDocument.load(
            self.priority_path, self.canonical_priority_path
        )

    def load_canonical_priorities(self) -> "EffectPriorityDocument":
        return EffectPriorityDocument.load(
            self.canonical_priority_path, self.canonical_priority_path
        )

    def validate(self) -> int:
        return self.load().encoded_size + self.load_priorities().encoded_size


class EffectPriorityDocument:
    def __init__(
        self,
        document: dict[str, Any],
        path: Path,
        canonical: dict[str, Any],
    ) -> None:
        self.document = copy.deepcopy(document)
        self.path = path
        self.canonical = copy.deepcopy(canonical)
        self.undo_stack: list[dict[str, Any]] = []
        self.redo_stack: list[dict[str, Any]] = []
        self.validate()
        self.original = copy.deepcopy(self.document)
        self.saved = copy.deepcopy(self.document)

    @classmethod
    def load(cls, path: Path, canonical_path: Path) -> "EffectPriorityDocument":
        return cls(load_json(path), path, load_json(canonical_path))

    @property
    def dirty(self) -> bool:
        return self.document != self.saved

    @property
    def encoded_size(self) -> int:
        return sum(len(payload) for _, _, payload in priority_writes(self.document))

    def validate(self) -> bytes:
        if self.document.get("schema_version") != 1 or self.document.get("format") != "doraemon-effect-priorities":
            raise ValueError("unsupported effect-priority schema")
        if len(self.document.get("drivers", [])) != len(self.canonical["drivers"]):
            raise ValueError("effect-priority driver count differs")
        output = bytearray()
        for driver, base in zip(self.document["drivers"], self.canonical["drivers"]):
            for field in ("bank", "name", "address"):
                if driver.get(field) != base.get(field):
                    raise ValueError(f"effect-priority {field} differs from canonical")
            slots = [int(value) for value in driver.get("slots", [])]
            base_slots = [int(value) for value in base["slots"]]
            if sorted(slots) != sorted(base_slots):
                raise ValueError("effect-priority slots must remain a complete permutation")
            output.extend(slots)
        return bytes(output)

    def change(self, action: Callable[[dict[str, Any]], None]) -> bool:
        before = copy.deepcopy(self.document)
        action(self.document)
        try:
            self.validate()
        except (KeyError, TypeError, ValueError):
            self.document = before
            raise
        if before == self.document:
            return False
        self.undo_stack.append(before)
        self.redo_stack.clear()
        return True

    def undo(self) -> bool:
        if not self.undo_stack:
            return False
        self.redo_stack.append(copy.deepcopy(self.document))
        self.document = self.undo_stack.pop()
        return True

    def redo(self) -> bool:
        if not self.redo_stack:
            return False
        self.undo_stack.append(copy.deepcopy(self.document))
        self.document = self.redo_stack.pop()
        return True

    def save(self) -> Path:
        self.validate()
        atomic_write(
            self.path,
            (json.dumps(self.document, indent=2) + "\n").encode("utf-8"),
        )
        self.saved = copy.deepcopy(self.document)
        return self.path
