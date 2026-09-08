#!/usr/bin/env python3
"""Merge any Doraemon content workspaces into one source-built revision ROM."""

from __future__ import annotations

import argparse
from pathlib import Path
import sys
import zlib


SCRIPTS = Path(__file__).resolve().parent.parent
if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))

from scripts.authoring.graphics_artifacts import PrgGraphicsWorkspace
from scripts.authoring.graphics_content_rom import apply_graphics_payload
from scripts.authoring.graphics_studio_model import GraphicsWorkspace, atomic_write
from scripts.authoring.level_content_rom import (
    apply_level_payloads,
    load_canonical_payloads,
    load_workspace_payloads,
)
from scripts.authoring.level_studio_model import (
    CANONICAL_WORLDS,
    HierarchicalWorldDocument,
    LevelWorkspace,
)
from scripts.authoring.object_artifacts import ObjectWorkspace
from scripts.authoring.object_content_rom import apply_object_payload
from scripts.authoring.sound_content_rom import apply_sound_payload
from scripts.authoring.sound_studio_model import SoundWorkspace
from scripts.authoring.text_content_rom import apply_text_payload
from scripts.authoring.text_studio_model import TextWorkspace
from scripts.authoring.world2_level_model import (
    CANONICAL_PATH as WORLD2_CANONICAL_PATH,
    World2ScreenDocument,
    workspace_path as world2_workspace_path,
)


PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent
STUDIO_IDS = ("level", "graphics", "objects", "text", "sound")


def parse_studios(value: str) -> tuple[str, ...]:
    if value == "all":
        return STUDIO_IDS
    requested = tuple(part.strip() for part in value.split(",") if part.strip())
    if not requested or len(set(requested)) != len(requested):
        raise ValueError("studio list is empty or contains duplicates")
    unknown = set(requested) - set(STUDIO_IDS)
    if unknown:
        raise ValueError(f"unknown content studios: {', '.join(sorted(unknown))}")
    return requested


def merge_studio_images(
    base: bytes,
    images: dict[str, bytes],
) -> tuple[bytes, dict[str, int]]:
    owners: dict[int, tuple[str, int]] = {}
    counts: dict[str, int] = {}
    for studio, image in images.items():
        if len(image) != len(base):
            raise ValueError(f"{studio} image size differs from the base ROM")
        count = 0
        for offset, (before, after) in enumerate(zip(base, image)):
            if before == after:
                continue
            count += 1
            previous = owners.get(offset)
            if previous is not None and previous[1] != after:
                raise ValueError(
                    f"content conflict at ROM offset 0x{offset:05X}: "
                    f"{previous[0]} writes 0x{previous[1]:02X}, "
                    f"{studio} writes 0x{after:02X}"
                )
            owners[offset] = (studio, after)
        counts[studio] = count
    result = bytearray(base)
    for offset, (_studio, value) in owners.items():
        result[offset] = value
    return bytes(result), counts


def level_image(
    base: bytes,
    project_root: Path,
    workspace_root: Path,
    profile: str,
    canonical: bool,
) -> bytes:
    payloads = (
        load_canonical_payloads(project_root)
        if canonical
        else load_workspace_payloads(project_root, workspace_root, profile)
    )
    return apply_level_payloads(base, payloads)


def graphics_image(
    base: bytes,
    project_root: Path,
    workspace_root: Path,
    profile: str,
    canonical: bool,
) -> bytes:
    graphics = GraphicsWorkspace(project_root, workspace_root, profile)
    artifacts = PrgGraphicsWorkspace(project_root, workspace_root, profile)
    levels = LevelWorkspace(project_root, workspace_root, profile)
    chr_data = (
        graphics.canonical_chr()[0].read_bytes()
        if canonical
        else graphics.load().encode()
    )
    documents = artifacts.load_canonical() if canonical else artifacts.load()
    hierarchies = (
        {
            world_id: HierarchicalWorldDocument.load(project_root / relative)
            for world_id, relative in CANONICAL_WORLDS.items()
        }
        if canonical
        else {world_id: levels.load(world_id) for world_id in CANONICAL_WORLDS}
    )
    return apply_graphics_payload(base, chr_data, documents, hierarchies)


def object_image(
    base: bytes,
    project_root: Path,
    workspace_root: Path,
    profile: str,
    canonical: bool,
) -> bytes:
    workspace = ObjectWorkspace(project_root, workspace_root, profile)
    documents = workspace.load_canonical() if canonical else workspace.load()
    world2 = World2ScreenDocument.load(
        project_root / WORLD2_CANONICAL_PATH
        if canonical
        else world2_workspace_path(workspace_root, profile)
    )
    return apply_object_payload(base, documents, world2)


def text_image(
    base: bytes,
    project_root: Path,
    workspace_root: Path,
    profile: str,
    canonical: bool,
) -> bytes:
    workspace = TextWorkspace(project_root, workspace_root, profile)
    document = workspace.load_canonical() if canonical else workspace.load()
    return apply_text_payload(base, document)


def sound_image(
    base: bytes,
    project_root: Path,
    workspace_root: Path,
    profile: str,
    canonical: bool,
) -> bytes:
    workspace = SoundWorkspace(project_root, workspace_root, profile)
    music = workspace.load_canonical() if canonical else workspace.load()
    priorities = (
        workspace.load_canonical_priorities()
        if canonical
        else workspace.load_priorities()
    )
    return apply_sound_payload(base, music, priorities)


def compose_content(
    base: bytes,
    project_root: Path,
    workspace_root: Path,
    profile: str,
    studios: tuple[str, ...],
    canonical: bool,
) -> tuple[bytes, dict[str, int]]:
    composers = {
        "level": level_image,
        "graphics": graphics_image,
        "objects": object_image,
        "text": text_image,
        "sound": sound_image,
    }
    images = {
        studio: composers[studio](
            base,
            project_root,
            workspace_root,
            profile,
            canonical,
        )
        for studio in studios
    }
    return merge_studio_images(base, images)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project-root", type=Path, default=PROJECT_ROOT)
    parser.add_argument("--base-rom", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--workspace", type=Path, default=Path("content/workspace"))
    parser.add_argument("--profile", choices=("original", "rev_a"), required=True)
    parser.add_argument("--studios", default="all")
    parser.add_argument("--canonical", action="store_true")
    parser.add_argument("--require-identical", action="store_true")
    args = parser.parse_args()
    project_root = args.project_root.resolve()
    workspace_root = args.workspace if args.workspace.is_absolute() else project_root / args.workspace
    base_path = args.base_rom if args.base_rom.is_absolute() else project_root / args.base_rom
    output = args.output if args.output.is_absolute() else project_root / args.output
    try:
        studios = parse_studios(args.studios)
        base = base_path.read_bytes()
        built, counts = compose_content(
            base,
            project_root,
            workspace_root,
            args.profile,
            studios,
            args.canonical,
        )
        differing = sum(left != right for left, right in zip(base, built))
        if args.require_identical and built != base:
            raise ValueError(f"canonical content roundtrip changed {differing} ROM bytes")
        atomic_write(output, built)
    except (OSError, ValueError, KeyError, TypeError) as exc:
        print(f"[ERROR] content composition failed: {exc}")
        return 1
    details = ", ".join(f"{name}={counts[name]}" for name in studios)
    checksum = zlib.crc32(built) & 0xFFFFFFFF
    print(
        f"[OK] wrote {len(built)}-byte {args.profile} content ROM to {output} "
        f"(CRC32 {checksum:08X}, {differing} merged changes; {details})"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
