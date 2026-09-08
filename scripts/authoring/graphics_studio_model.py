#!/usr/bin/env python3
"""Headless, profile-aware model for Doraemon CHR graphics authoring."""

from __future__ import annotations

import copy
import hashlib
import json
import os
from pathlib import Path
import tempfile
from typing import Any


CHR_BANK_SIZE = 0x2000
CHR_BANK_COUNT = 4
CHR_SIZE = CHR_BANK_SIZE * CHR_BANK_COUNT
TILES_PER_PATTERN_TABLE = 256
TILES_PER_BANK = 512
TILE_SIZE = 16
TILE_WIDTH = 8
PROFILE_MANIFEST = Path("config/authoring/content_authoring_profiles.json")
ASSET_MANIFEST = Path("assets/manifest.json")


def atomic_write(path: Path, data: bytes) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary_name: str | None = None
    try:
        with tempfile.NamedTemporaryFile(
            "wb",
            dir=path.parent,
            prefix=f".{path.name}.",
            suffix=".tmp",
            delete=False,
        ) as output:
            output.write(data)
            output.flush()
            os.fsync(output.fileno())
            temporary_name = output.name
        os.replace(temporary_name, path)
    finally:
        if temporary_name is not None:
            Path(temporary_name).unlink(missing_ok=True)


def decode_chr(data: bytes) -> list[list[list[int]]]:
    if len(data) != CHR_SIZE:
        raise ValueError(f"Doraemon CHR must be exactly {CHR_SIZE} bytes")
    tiles: list[list[list[int]]] = []
    for offset in range(0, len(data), TILE_SIZE):
        raw = data[offset:offset + TILE_SIZE]
        tile: list[list[int]] = []
        for row in range(TILE_WIDTH):
            low, high = raw[row], raw[row + TILE_WIDTH]
            tile.append(
                [
                    ((low >> (7 - column)) & 1)
                    | (((high >> (7 - column)) & 1) << 1)
                    for column in range(TILE_WIDTH)
                ]
            )
        tiles.append(tile)
    return tiles


def encode_chr(tiles: list[list[list[int]]]) -> bytes:
    expected_tiles = CHR_SIZE // TILE_SIZE
    if len(tiles) != expected_tiles:
        raise ValueError(f"Doraemon CHR requires exactly {expected_tiles} tiles")
    output = bytearray()
    for tile_index, tile in enumerate(tiles):
        if len(tile) != TILE_WIDTH or any(len(row) != TILE_WIDTH for row in tile):
            raise ValueError(f"CHR tile {tile_index} must be 8x8 pixels")
        if any(pixel not in range(4) for row in tile for pixel in row):
            raise ValueError(f"CHR tile {tile_index} has a pixel outside 0..3")
        for plane in (0, 1):
            for row in tile:
                value = 0
                for pixel in row:
                    value = (value << 1) | ((pixel >> plane) & 1)
                output.append(value)
    return bytes(output)


def global_tile_index(chr_bank: int, pattern_table: int, tile: int) -> int:
    if not 0 <= chr_bank < CHR_BANK_COUNT:
        raise ValueError("CHR bank is outside 0..3")
    if pattern_table not in (0, 1):
        raise ValueError("pattern table must be 0 or 1")
    if not 0 <= tile < TILES_PER_PATTERN_TABLE:
        raise ValueError("tile is outside 0..255")
    return chr_bank * TILES_PER_BANK + pattern_table * TILES_PER_PATTERN_TABLE + tile


class ChrDocument:
    def __init__(self, data: bytes, path: Path) -> None:
        self.tiles = decode_chr(data)
        self.path = path
        self.original = copy.deepcopy(self.tiles)
        self.saved = copy.deepcopy(self.tiles)
        self.undo_stack: list[tuple[int, list[list[int]], list[list[int]]]] = []
        self.redo_stack: list[tuple[int, list[list[int]], list[list[int]]]] = []
        self._stroke_tile: int | None = None
        self._stroke_before: list[list[int]] | None = None

    @classmethod
    def load(cls, path: Path) -> "ChrDocument":
        return cls(path.read_bytes(), path)

    @property
    def dirty(self) -> bool:
        return self.tiles != self.saved

    def changed(self, tile: int) -> bool:
        self._require_tile(tile)
        return self.tiles[tile] != self.original[tile]

    def _require_tile(self, tile: int) -> None:
        if not 0 <= tile < len(self.tiles):
            raise ValueError("CHR tile is outside the four-bank image")

    def begin_stroke(self, tile: int) -> None:
        self._require_tile(tile)
        if self._stroke_tile is not None:
            raise ValueError("a CHR paint stroke is already active")
        self._stroke_tile = tile
        self._stroke_before = copy.deepcopy(self.tiles[tile])

    def paint(self, tile: int, row: int, column: int, color: int) -> bool:
        self._require_tile(tile)
        if not 0 <= row < TILE_WIDTH or not 0 <= column < TILE_WIDTH:
            raise ValueError("CHR paint coordinate is outside the tile")
        if color not in range(4):
            raise ValueError("CHR pixel color must be in 0..3")
        if self._stroke_tile is not None and self._stroke_tile != tile:
            raise ValueError("a paint stroke cannot cross tile boundaries")
        if self.tiles[tile][row][column] == color:
            return False
        if self._stroke_tile is None:
            before = copy.deepcopy(self.tiles[tile])
            self.tiles[tile][row][column] = color
            after = copy.deepcopy(self.tiles[tile])
            self.undo_stack.append((tile, before, after))
            self.redo_stack.clear()
            return True
        self.tiles[tile][row][column] = color
        return True

    def end_stroke(self) -> bool:
        if self._stroke_tile is None or self._stroke_before is None:
            return False
        tile = self._stroke_tile
        before = self._stroke_before
        after = copy.deepcopy(self.tiles[tile])
        self._stroke_tile = None
        self._stroke_before = None
        if before == after:
            return False
        self.undo_stack.append((tile, before, after))
        self.redo_stack.clear()
        return True

    def undo(self) -> bool:
        if self._stroke_tile is not None:
            raise ValueError("finish the active paint stroke before undo")
        if not self.undo_stack:
            return False
        tile, before, after = self.undo_stack.pop()
        self.tiles[tile] = copy.deepcopy(before)
        self.redo_stack.append((tile, before, after))
        return True

    def redo(self) -> bool:
        if self._stroke_tile is not None:
            raise ValueError("finish the active paint stroke before redo")
        if not self.redo_stack:
            return False
        tile, before, after = self.redo_stack.pop()
        self.tiles[tile] = copy.deepcopy(after)
        self.undo_stack.append((tile, before, after))
        return True

    def restore_tile(self, tile: int) -> bool:
        self._require_tile(tile)
        before = copy.deepcopy(self.tiles[tile])
        after = copy.deepcopy(self.original[tile])
        if before == after:
            return False
        self.tiles[tile] = after
        self.undo_stack.append((tile, before, copy.deepcopy(after)))
        self.redo_stack.clear()
        return True

    def encode(self) -> bytes:
        return encode_chr(self.tiles)

    def save(self) -> Path:
        data = self.encode()
        atomic_write(self.path, data)
        self.saved = copy.deepcopy(self.tiles)
        return self.path


def _load_json(path: Path) -> dict[str, Any]:
    try:
        document = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ValueError(f"cannot load graphics contract {path}: {exc}") from exc
    if not isinstance(document, dict):
        raise ValueError(f"graphics contract is not an object: {path}")
    return document


class GraphicsWorkspace:
    def __init__(self, project_root: Path, workspace_root: Path, profile: str) -> None:
        self.project_root = project_root.resolve()
        self.workspace_root = workspace_root.resolve()
        profiles = _load_json(self.project_root / PROFILE_MANIFEST)
        profile_entries = {
            entry.get("id"): entry
            for entry in profiles.get("profiles", [])
            if isinstance(entry, dict)
        }
        if profile not in profile_entries:
            raise ValueError(f"unsupported content profile: {profile}")
        if profile_entries[profile].get("studios", {}).get("graphics") not in {
            "partial",
            "supported",
        }:
            raise ValueError(f"graphics authoring is unavailable for {profile}")
        self.profile = profile
        self.directory = self.workspace_root / profile / "graphics"
        self.chr_path = self.directory / "chr.bin"

    def canonical_chr(self) -> tuple[Path, str]:
        assets = _load_json(self.project_root / ASSET_MANIFEST)
        matches = [
            entry
            for entry in assets.get("extracted_assets", [])
            if isinstance(entry, dict) and entry.get("region") == "chr"
        ]
        if len(matches) != 1:
            raise ValueError("asset manifest must declare one CHR region")
        entry = matches[0]
        path = self.project_root / "assets/generated" / str(entry["path"])
        return path, str(entry["sha256"])

    def initialize(self) -> Path | None:
        canonical, expected_sha256 = self.canonical_chr()
        data = canonical.read_bytes()
        if len(data) != CHR_SIZE:
            raise ValueError(f"canonical CHR has {len(data)} bytes, expected {CHR_SIZE}")
        if hashlib.sha256(data).hexdigest() != expected_sha256:
            raise ValueError("canonical CHR SHA-256 does not match the asset manifest")
        if self.chr_path.exists():
            return None
        atomic_write(self.chr_path, data)
        return self.chr_path

    def load(self) -> ChrDocument:
        if not self.chr_path.is_file():
            raise ValueError(
                f"graphics workspace is not initialized: {self.chr_path}"
            )
        return ChrDocument.load(self.chr_path)

    def validate(self) -> int:
        return len(self.load().encode())
