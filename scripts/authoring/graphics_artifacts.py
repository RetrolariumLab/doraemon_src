#!/usr/bin/env python3
"""Editable PRG-side graphics documents shared by Doraemon Studios."""

from __future__ import annotations

import copy
from dataclasses import dataclass
import json
from pathlib import Path
import sys
from typing import Any, Callable
import zlib


SCRIPTS = Path(__file__).resolve().parent.parent
if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))

from scripts.validation.world1 import world1_metasprites
from scripts.validation.world1 import world1_palettes
from scripts.validation.world2 import world2_metasprites
from scripts.validation.world2 import world2_metatiles
from scripts.validation.world2 import world2_palettes
from scripts.validation.world3 import world3_metasprites
from scripts.authoring.graphics_studio_model import PROFILE_MANIFEST, atomic_write


PRG_SIZE = 0x20000
PRG_BANK_SIZE = 0x8000
CPU_BASE = 0x8000
Encoder = Callable[[dict[str, Any]], bytes | dict[int, int]]


@dataclass(frozen=True)
class GraphicsArtifact:
    id: str
    canonical_path: Path
    encoder: Encoder


ARTIFACTS = (
    GraphicsArtifact(
        "world1_palettes",
        Path("data/world1/palettes.json"),
        world1_palettes.encode_authoring,
    ),
    GraphicsArtifact(
        "world1_metasprites",
        Path("data/world1/metasprites.json"),
        world1_metasprites.encode_authoring,
    ),
    GraphicsArtifact(
        "world2_metatiles",
        Path("data/world2/metatiles.json"),
        world2_metatiles.encode_authoring,
    ),
    GraphicsArtifact(
        "world2_palettes",
        Path("data/world2/palettes.json"),
        world2_palettes.encode_authoring,
    ),
    GraphicsArtifact(
        "world2_metasprites",
        Path("data/world2/metasprites.json"),
        world2_metasprites.encode_authoring,
    ),
    GraphicsArtifact(
        "world3_metasprites",
        Path("data/world3/metasprites.json"),
        world3_metasprites.encode_authoring,
    ),
)


def _number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def _payload(encoded: bytes | dict[int, int]) -> bytes:
    if isinstance(encoded, bytes):
        return encoded
    return bytes(encoded[address] for address in sorted(encoded))


def encoded_prg_writes(
    artifact: GraphicsArtifact,
    document: dict[str, Any],
) -> dict[int, int]:
    bank = int(document["bank"])
    if not 0 <= bank < 4:
        raise ValueError(f"{artifact.id}: PRG bank is outside 0..3")
    encoded = artifact.encoder(document)
    if isinstance(encoded, bytes):
        if "address" not in document:
            raise ValueError(f"{artifact.id}: contiguous data has no address")
        addressed = {
            _number(document["address"]) + offset: value
            for offset, value in enumerate(encoded)
        }
    else:
        addressed = encoded
    writes: dict[int, int] = {}
    for address, value in addressed.items():
        offset = bank * PRG_BANK_SIZE + address - CPU_BASE
        if not 0 <= offset < PRG_SIZE:
            raise ValueError(f"{artifact.id}: write ${address:04X} leaves PRG")
        if not 0 <= value <= 0xFF:
            raise ValueError(f"{artifact.id}: encoded value leaves byte range")
        if offset in writes:
            raise ValueError(f"{artifact.id}: duplicate encoded PRG write")
        writes[offset] = value
    return writes


class GraphicsArtifactDocument:
    def __init__(
        self,
        artifact: GraphicsArtifact,
        document: dict[str, Any],
        path: Path,
    ) -> None:
        self.artifact = artifact
        self.document = copy.deepcopy(document)
        self.path = path
        self.original = copy.deepcopy(document)
        self.saved = copy.deepcopy(document)
        self.undo_stack: list[dict[str, Any]] = []
        self.redo_stack: list[dict[str, Any]] = []
        self.validate()
        self.original = copy.deepcopy(self.document)
        self.saved = copy.deepcopy(self.document)

    @classmethod
    def load(
        cls,
        artifact: GraphicsArtifact,
        path: Path,
    ) -> "GraphicsArtifactDocument":
        document = json.loads(path.read_text(encoding="utf-8"))
        if not isinstance(document, dict):
            raise ValueError(f"{artifact.id}: workspace document is not an object")
        return cls(artifact, document, path)

    @property
    def dirty(self) -> bool:
        return self.document != self.saved

    def validate(self) -> dict[int, int]:
        writes = encoded_prg_writes(self.artifact, self.document)
        encoded = self.artifact.encoder(self.document)
        payload = _payload(encoded)
        self.document["covered_byte_count"] = len(payload)
        self.document["covered_crc32"] = (
            f"{zlib.crc32(payload) & 0xFFFFFFFF:08x}"
        )
        return writes

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
        data = (json.dumps(self.document, indent=2) + "\n").encode("utf-8")
        atomic_write(self.path, data)
        self.saved = copy.deepcopy(self.document)
        return self.path


def validate_artifact_set(
    documents: dict[str, GraphicsArtifactDocument],
) -> dict[str, int]:
    expected = {artifact.id for artifact in ARTIFACTS}
    if set(documents) != expected:
        raise ValueError("graphics artifact set is incomplete")
    owners: dict[int, str] = {}
    sizes: dict[str, int] = {}
    for artifact in ARTIFACTS:
        writes = documents[artifact.id].validate()
        for offset in writes:
            if offset in owners:
                raise ValueError(
                    f"{artifact.id} overlaps {owners[offset]} at PRG "
                    f"offset ${offset:05X}"
                )
            owners[offset] = artifact.id
        sizes[artifact.id] = len(writes)
    return sizes


def apply_graphics_artifacts(
    prg: bytes,
    documents: dict[str, GraphicsArtifactDocument],
) -> bytes:
    if len(prg) != PRG_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    validate_artifact_set(documents)
    result = bytearray(prg)
    for artifact in ARTIFACTS:
        for offset, value in documents[artifact.id].validate().items():
            result[offset] = value
    return bytes(result)


class PrgGraphicsWorkspace:
    def __init__(self, project_root: Path, workspace_root: Path, profile: str) -> None:
        self.project_root = project_root.resolve()
        self.workspace_root = workspace_root.resolve()
        profiles = json.loads(
            (self.project_root / PROFILE_MANIFEST).read_text(encoding="utf-8")
        )
        entries = {
            entry.get("id"): entry
            for entry in profiles.get("profiles", [])
            if isinstance(entry, dict)
        }
        if profile not in entries:
            raise ValueError(f"unsupported content profile: {profile}")
        if entries[profile].get("studios", {}).get("graphics") not in {
            "partial",
            "supported",
        }:
            raise ValueError(f"graphics authoring is unavailable for {profile}")
        self.profile = profile
        self.directory = self.workspace_root / profile / "graphics"

    def path(self, artifact: GraphicsArtifact) -> Path:
        return self.directory / f"{artifact.id}.json"

    def initialize(self) -> tuple[Path, ...]:
        created: list[Path] = []
        for artifact in ARTIFACTS:
            destination = self.path(artifact)
            if destination.exists():
                continue
            source = self.project_root / artifact.canonical_path
            document = GraphicsArtifactDocument.load(artifact, source)
            data = (json.dumps(document.document, indent=2) + "\n").encode("utf-8")
            atomic_write(destination, data)
            created.append(destination)
        return tuple(created)

    def load(self) -> dict[str, GraphicsArtifactDocument]:
        return {
            artifact.id: GraphicsArtifactDocument.load(
                artifact, self.path(artifact)
            )
            for artifact in ARTIFACTS
        }

    def load_canonical(self) -> dict[str, GraphicsArtifactDocument]:
        return {
            artifact.id: GraphicsArtifactDocument.load(
                artifact, self.project_root / artifact.canonical_path
            )
            for artifact in ARTIFACTS
        }

    def validate(self) -> dict[str, int]:
        return validate_artifact_set(self.load())
