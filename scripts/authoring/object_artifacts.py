#!/usr/bin/env python3
"""Typed fixed-capacity object documents for all Doraemon chapters."""

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

from scripts.validation.reconstruction import object_placements
from scripts.validation.world1 import world1_underground_rooms
from scripts.validation.world1 import world1_weapons
from scripts.validation.world2 import world2_enemy_states
from scripts.validation.world2 import world2_inventory
from scripts.validation.world3 import world3_behavior
from scripts.validation.world3 import world3_object_catalog
from scripts.validation.world3 import world3_spawn_initializers
from scripts.validation.world3 import world3_transient_spawns
from scripts.validation.world3 import world3_update_handlers
from scripts.authoring.graphics_studio_model import PROFILE_MANIFEST, atomic_write


PRG_SIZE = 0x20000
PRG_BANK_SIZE = 0x8000
CPU_BASE = 0x8000
Encoder = Callable[[dict[str, Any], Path], dict[int, int]]


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def load_json(path: Path) -> dict[str, Any]:
    value = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(value, dict):
        raise ValueError(f"JSON document is not an object: {path}")
    return value


def contiguous_writes(address: int, payload: bytes) -> dict[int, int]:
    return {address + offset: value for offset, value in enumerate(payload)}


def encode_world1_objects(document: dict[str, Any], _root: Path) -> dict[int, int]:
    return object_placements.encode_authoring(document)


def encode_world1_underground(
    document: dict[str, Any], root: Path
) -> dict[int, int]:
    manifest = load_json(
        root / "config/authoring/world1/world1_underground_rooms.json"
    )
    payload = world1_underground_rooms.encode_authoring(document, manifest)
    room_count = int(manifest["room_count"])
    sections = []
    cursor = 0
    for key in ("camera_profiles", "entry_profiles", "city_return_profiles"):
        spec = manifest[key]
        size = room_count * len(spec["fields"])
        sections.append((number(spec["address"]), payload[cursor:cursor + size]))
        cursor += size
    if cursor != len(payload):
        raise ValueError("World 1 underground payload has an unexpected size")
    return {
        address + offset: value
        for address, data in sections
        for offset, value in enumerate(data)
    }


def encode_world1_weapons(
    document: dict[str, Any], root: Path
) -> dict[int, int]:
    manifest = load_json(root / "config/authoring/world1/world1_weapons.json")
    payload = world1_weapons.encode_authoring(document, manifest)
    return contiguous_writes(number(document["address"]), payload)


def encode_world2_enemies(document: dict[str, Any], _root: Path) -> dict[int, int]:
    return world2_enemy_states.encode_authoring(document)


def encode_world2_inventory(
    document: dict[str, Any], root: Path
) -> dict[int, int]:
    manifest = load_json(root / "config/authoring/world2/world2_inventory.json")
    payload = world2_inventory.encode_authoring(document, manifest)
    return contiguous_writes(number(document["address"]), payload)


def encode_world3_catalog(document: dict[str, Any], _root: Path) -> dict[int, int]:
    return world3_object_catalog.encode_authoring(document)


def encode_world3_behavior(
    document: dict[str, Any], _root: Path
) -> dict[int, int]:
    streams = sorted(document["streams"], key=lambda item: int(item["id"]))
    if not streams:
        raise ValueError("World 3 behavior document has no streams")
    payload = world3_behavior.encode_authoring(document)
    return contiguous_writes(number(streams[0]["address"]), payload)


def encode_world3_transient(
    document: dict[str, Any], root: Path
) -> dict[int, int]:
    manifest = load_json(
        root / "config/authoring/world3/world3_transient_spawns.json"
    )
    payload = world3_transient_spawns.encode_authoring(document, manifest)
    addresses = [
        number(spec["address"])
        for group in manifest["tables"].values()
        for spec in group
    ]
    return contiguous_writes(min(addresses), payload)


def encode_world3_initializers(
    document: dict[str, Any], root: Path
) -> dict[int, int]:
    manifest = load_json(
        root / "config/authoring/world3/world3_spawn_initializers.json"
    )
    return world3_spawn_initializers.encode_authoring(document, manifest)


def encode_world3_updates(
    document: dict[str, Any], root: Path
) -> dict[int, int]:
    manifest = load_json(
        root / "config/authoring/world3/world3_update_handlers.json"
    )
    return world3_update_handlers.encode_authoring(document, manifest)


@dataclass(frozen=True)
class ObjectArtifact:
    id: str
    canonical_path: Path
    bank: int
    encoder: Encoder


ARTIFACTS = (
    ObjectArtifact(
        "world1_object_placements",
        Path("data/world1/object_data.json"),
        0,
        encode_world1_objects,
    ),
    ObjectArtifact(
        "world1_underground_rooms",
        Path("data/world1/underground_rooms.json"),
        0,
        encode_world1_underground,
    ),
    ObjectArtifact(
        "world1_weapons",
        Path("data/world1/weapons.json"),
        0,
        encode_world1_weapons,
    ),
    ObjectArtifact(
        "world2_enemy_states",
        Path("data/world2/enemy_states.json"),
        1,
        encode_world2_enemies,
    ),
    ObjectArtifact(
        "world2_inventory_spawns",
        Path("data/world2/inventory_spawn_screens.json"),
        1,
        encode_world2_inventory,
    ),
    ObjectArtifact(
        "world3_object_catalog",
        Path("data/world3/object_catalog.json"),
        2,
        encode_world3_catalog,
    ),
    ObjectArtifact(
        "world3_behavior_streams",
        Path("data/world3/behavior_streams.json"),
        2,
        encode_world3_behavior,
    ),
    ObjectArtifact(
        "world3_transient_spawns",
        Path("data/world3/transient_spawns.json"),
        2,
        encode_world3_transient,
    ),
    ObjectArtifact(
        "world3_spawn_initializer_data",
        Path("data/world3/spawn_initializer_data.json"),
        2,
        encode_world3_initializers,
    ),
    ObjectArtifact(
        "world3_update_handler_data",
        Path("data/world3/update_handler_data.json"),
        2,
        encode_world3_updates,
    ),
)


def encoded_object_writes(
    artifact: ObjectArtifact,
    document: dict[str, Any],
    project_root: Path,
) -> dict[int, int]:
    declared_bank = document.get("bank")
    if declared_bank is not None and int(declared_bank) != artifact.bank:
        raise ValueError(f"{artifact.id}: document targets the wrong PRG bank")
    addressed = artifact.encoder(document, project_root)
    writes: dict[int, int] = {}
    for address, value in addressed.items():
        offset = artifact.bank * PRG_BANK_SIZE + address - CPU_BASE
        if not 0 <= offset < PRG_SIZE:
            raise ValueError(f"{artifact.id}: write ${address:04X} leaves PRG")
        if not 0 <= value <= 0xFF:
            raise ValueError(f"{artifact.id}: encoded value leaves byte range")
        if offset in writes:
            raise ValueError(f"{artifact.id}: duplicate encoded PRG write")
        writes[offset] = value
    return writes


class ObjectArtifactDocument:
    def __init__(
        self,
        artifact: ObjectArtifact,
        document: dict[str, Any],
        path: Path,
        project_root: Path,
    ) -> None:
        self.artifact = artifact
        self.document = copy.deepcopy(document)
        self.path = path
        self.project_root = project_root.resolve()
        self.undo_stack: list[dict[str, Any]] = []
        self.redo_stack: list[dict[str, Any]] = []
        self.validate()
        self.original = copy.deepcopy(self.document)
        self.saved = copy.deepcopy(self.document)

    @classmethod
    def load(
        cls,
        artifact: ObjectArtifact,
        path: Path,
        project_root: Path,
    ) -> "ObjectArtifactDocument":
        return cls(artifact, load_json(path), path, project_root)

    @property
    def dirty(self) -> bool:
        return self.document != self.saved

    def validate(self) -> dict[int, int]:
        writes = encoded_object_writes(
            self.artifact, self.document, self.project_root
        )
        payload = bytes(writes[offset] for offset in sorted(writes))
        if "covered_byte_count" in self.document:
            self.document["covered_byte_count"] = len(payload)
        if "covered_crc32" in self.document:
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
        if self.document == before:
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


def validate_artifact_set(
    documents: dict[str, ObjectArtifactDocument],
) -> dict[str, int]:
    expected = {artifact.id for artifact in ARTIFACTS}
    if set(documents) != expected:
        raise ValueError("object artifact set is incomplete")
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


def apply_object_artifacts(
    prg: bytes,
    documents: dict[str, ObjectArtifactDocument],
) -> bytes:
    if len(prg) != PRG_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    validate_artifact_set(documents)
    result = bytearray(prg)
    for artifact in ARTIFACTS:
        for offset, value in documents[artifact.id].validate().items():
            result[offset] = value
    return bytes(result)


class ObjectWorkspace:
    def __init__(self, project_root: Path, workspace_root: Path, profile: str) -> None:
        self.project_root = project_root.resolve()
        self.workspace_root = workspace_root.resolve()
        profiles = load_json(self.project_root / PROFILE_MANIFEST)
        entries = {
            entry.get("id"): entry
            for entry in profiles.get("profiles", [])
            if isinstance(entry, dict)
        }
        if profile not in entries:
            raise ValueError(f"unsupported content profile: {profile}")
        if entries[profile].get("studios", {}).get("objects") not in {
            "partial",
            "supported",
        }:
            raise ValueError(f"object authoring is unavailable for {profile}")
        self.profile = profile
        self.directory = self.workspace_root / profile / "objects"

    def path(self, artifact: ObjectArtifact) -> Path:
        return self.directory / f"{artifact.id}.json"

    def initialize(self) -> tuple[Path, ...]:
        created: list[Path] = []
        for artifact in ARTIFACTS:
            destination = self.path(artifact)
            if destination.exists():
                continue
            document = ObjectArtifactDocument.load(
                artifact,
                self.project_root / artifact.canonical_path,
                self.project_root,
            )
            atomic_write(
                destination,
                (json.dumps(document.document, indent=2) + "\n").encode("utf-8"),
            )
            created.append(destination)
        return tuple(created)

    def load(self) -> dict[str, ObjectArtifactDocument]:
        return {
            artifact.id: ObjectArtifactDocument.load(
                artifact, self.path(artifact), self.project_root
            )
            for artifact in ARTIFACTS
        }

    def load_canonical(self) -> dict[str, ObjectArtifactDocument]:
        return {
            artifact.id: ObjectArtifactDocument.load(
                artifact,
                self.project_root / artifact.canonical_path,
                self.project_root,
            )
            for artifact in ARTIFACTS
        }

    def validate(self) -> dict[str, int]:
        return validate_artifact_set(self.load())
