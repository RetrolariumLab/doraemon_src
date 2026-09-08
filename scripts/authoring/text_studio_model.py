#!/usr/bin/env python3
"""Atomic fixed-width document model for Doraemon shell text."""

from __future__ import annotations

import copy
from dataclasses import dataclass
import json
from pathlib import Path
import sys
from typing import Any, Callable


SCRIPTS = Path(__file__).resolve().parent.parent
if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))

from scripts.validation.reconstruction import shell_text
from scripts.authoring.graphics_studio_model import PROFILE_MANIFEST, atomic_write


CANONICAL_PATH = Path("data/shell/text.json")
MANIFEST_PATH = Path("config/authoring/text/shell_text.json")


def load_json(path: Path) -> dict[str, Any]:
    value = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(value, dict):
        raise ValueError(f"JSON document is not an object: {path}")
    return value


@dataclass(frozen=True)
class TextField:
    label: str
    kind: str
    path: tuple[str | int, ...]
    width: int


def value_at(document: object, path: tuple[str | int, ...]) -> object:
    current = document
    for part in path:
        current = current[part]  # type: ignore[index]
    return current


def set_value(document: object, path: tuple[str | int, ...], value: object) -> None:
    parent = value_at(document, path[:-1])
    parent[path[-1]] = value  # type: ignore[index]


def text_fields(document: dict[str, Any]) -> tuple[TextField, ...]:
    fields = [TextField("Game over", "game_over", ("game_over",), len(document["game_over"]))]
    for index, record in enumerate(document["title_records"]):
        if "text" in record:
            fields.append(
                TextField(
                    f"Title / {record['id']}",
                    "title",
                    ("title_records", index, "text"),
                    len(record["text"]),
                )
            )
    for screen_index, screen in enumerate(document["chapter_help_screens"]):
        for segment_index, segment in enumerate(screen["segments"]):
            if "text" in segment:
                fields.append(
                    TextField(
                        f"Help {screen['id']} / {segment['id']}",
                        "help",
                        (
                            "chapter_help_screens",
                            screen_index,
                            "segments",
                            segment_index,
                            "text",
                        ),
                        len(segment["text"]),
                    )
                )
    for index, row in enumerate(document["ending_credit_rows"]):
        fields.append(
            TextField(
                f"Credits row {index:03d}",
                "credits",
                ("ending_credit_rows", index),
                len(row),
            )
        )
    return tuple(fields)


def edit_fixed_text(data: dict[str, Any], field: TextField, text: str) -> None:
    try:
        raw = text.encode("ascii")
    except UnicodeEncodeError as exc:
        raise ValueError("Doraemon text fields require ASCII bytes") from exc
    if len(raw) != field.width:
        raise ValueError(f"text must remain exactly {field.width} characters")
    set_value(data, field.path, text)


def edit_hex_row(data: dict[str, Any], collection: str, index: int, text: str) -> None:
    rows = data[collection]
    if not 0 <= index < len(rows):
        raise ValueError("hex row index is outside its collection")
    old = bytes.fromhex(rows[index])
    replacement = bytes.fromhex(text)
    if len(replacement) != len(old):
        raise ValueError(f"hex row must remain exactly {len(old)} bytes")
    rows[index] = replacement.hex(" ")


def glyph_tiles(text: str, kind: str, remap: dict[str, str]) -> tuple[int, ...]:
    if kind == "game_over":
        return tuple(0 if character == " " else ord(character) for character in text)
    if kind == "title":
        return tuple(
            0 if character == " " else 0x5B if character == "." else ord(character)
            for character in text
        )
    if kind == "credits":
        mapping = {int(key, 0): int(value, 0) for key, value in remap.items()}
        return tuple(mapping.get(ord(character), ord(character)) for character in text)
    return tuple(ord(character) for character in text)


class TextDocument:
    def __init__(
        self,
        document: dict[str, Any],
        path: Path,
        manifest: dict[str, Any],
    ) -> None:
        self.document = copy.deepcopy(document)
        self.path = path
        self.manifest = manifest
        self.undo_stack: list[dict[str, Any]] = []
        self.redo_stack: list[dict[str, Any]] = []
        self.validate()
        self.original = copy.deepcopy(self.document)
        self.saved = copy.deepcopy(self.document)

    @classmethod
    def load(cls, path: Path, manifest_path: Path) -> "TextDocument":
        return cls(load_json(path), path, load_json(manifest_path))

    @property
    def dirty(self) -> bool:
        return self.document != self.saved

    def validate(self) -> dict[str, bytes]:
        return shell_text.encode_authoring(self.document, self.manifest)

    @property
    def encoded_size(self) -> int:
        return sum(len(payload) for payload in self.validate().values())

    def change(self, action: Callable[[dict[str, Any]], None]) -> bool:
        before = copy.deepcopy(self.document)
        action(self.document)
        try:
            self.validate()
        except (KeyError, TypeError, ValueError, UnicodeError):
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


class TextWorkspace:
    def __init__(self, project_root: Path, workspace_root: Path, profile: str) -> None:
        self.project_root = project_root.resolve()
        self.workspace_root = workspace_root.resolve()
        profiles = load_json(self.project_root / PROFILE_MANIFEST)
        entries = {entry["id"]: entry for entry in profiles["profiles"]}
        if profile not in entries:
            raise ValueError(f"unsupported content profile: {profile}")
        if entries[profile]["studios"].get("text") not in {"partial", "supported"}:
            raise ValueError(f"text authoring is unavailable for {profile}")
        self.profile = profile
        self.path = self.workspace_root / profile / "text" / "shell_text.json"

    @property
    def manifest_path(self) -> Path:
        return self.project_root / MANIFEST_PATH

    def initialize(self) -> Path | None:
        if self.path.exists():
            return None
        document = self.load_canonical()
        atomic_write(
            self.path,
            (json.dumps(document.document, indent=2) + "\n").encode("utf-8"),
        )
        return self.path

    def load(self) -> TextDocument:
        return TextDocument.load(self.path, self.manifest_path)

    def load_canonical(self) -> TextDocument:
        return TextDocument.load(
            self.project_root / CANONICAL_PATH,
            self.manifest_path,
        )

    def validate(self) -> int:
        return self.load().encoded_size
