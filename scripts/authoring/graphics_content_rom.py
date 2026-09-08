#!/usr/bin/env python3
"""Compose Doraemon CHR workspace edits into a source-built revision ROM."""

from __future__ import annotations

import argparse
from pathlib import Path
import sys
import zlib


SCRIPTS = Path(__file__).resolve().parent.parent
if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))

from scripts.build import project
from scripts.authoring.graphics_artifacts import (
    GraphicsArtifactDocument,
    PrgGraphicsWorkspace,
    apply_graphics_artifacts,
)
from scripts.authoring.graphics_studio_model import CHR_SIZE, GraphicsWorkspace, atomic_write
from scripts.authoring.level_studio_model import (
    CANONICAL_WORLDS,
    HierarchicalWorldDocument,
    LevelWorkspace,
)


PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent
HEADER_SIZE = 16
PRG_SIZE = 0x20000
HIERARCHY_RANGES = {
    "world1": (0, 0xA9EF, 8000),
    "world3": (2, 0xDDF2, 6400),
}


def apply_hierarchy_payloads(
    rom: bytes,
    documents: dict[str, HierarchicalWorldDocument],
) -> bytes:
    if set(documents) != set(HIERARCHY_RANGES):
        raise ValueError("hierarchy payload set must contain World 1 and World 3")
    result = bytearray(rom)
    for world_id, (bank, address, size) in HIERARCHY_RANGES.items():
        payload = documents[world_id].encode()
        if len(payload) != size:
            raise ValueError(
                f"{world_id} hierarchy has {len(payload)} bytes, expected {size}"
            )
        offset = HEADER_SIZE + bank * 0x8000 + address - 0x8000
        result[offset:offset + size] = payload
    return bytes(result)


def apply_graphics_payload(
    rom: bytes,
    chr_data: bytes,
    documents: dict[str, GraphicsArtifactDocument] | None = None,
    hierarchies: dict[str, HierarchicalWorldDocument] | None = None,
) -> bytes:
    parsed = project.parse_ines(rom)
    if (
        parsed["mapper"] != 66
        or parsed["trainer_size"] != 0
        or parsed["prg_size"] != PRG_SIZE
        or parsed["chr_size"] != CHR_SIZE
    ):
        raise ValueError("base ROM is not the expected Doraemon GNROM image")
    if len(chr_data) != CHR_SIZE:
        raise ValueError(f"graphics payload has {len(chr_data)} bytes, expected {CHR_SIZE}")
    result = bytearray(rom)
    if documents is not None:
        prg_start = HEADER_SIZE
        prg = apply_graphics_artifacts(
            bytes(result[prg_start:prg_start + PRG_SIZE]),
            documents,
        )
        result[prg_start:prg_start + PRG_SIZE] = prg
    start = HEADER_SIZE + PRG_SIZE
    result[start:start + CHR_SIZE] = chr_data
    built = bytes(result)
    return (
        apply_hierarchy_payloads(built, hierarchies)
        if hierarchies is not None
        else built
    )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project-root", type=Path, default=PROJECT_ROOT)
    parser.add_argument("--base-rom", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--workspace", type=Path, default=Path("content/workspace"))
    parser.add_argument("--profile", choices=("original", "rev_a"), required=True)
    parser.add_argument("--canonical", action="store_true")
    parser.add_argument("--require-identical", action="store_true")
    args = parser.parse_args()

    project_root = args.project_root.resolve()
    workspace_root = (
        args.workspace
        if args.workspace.is_absolute()
        else project_root / args.workspace
    )
    base_path = (
        args.base_rom
        if args.base_rom.is_absolute()
        else project_root / args.base_rom
    )
    output = args.output if args.output.is_absolute() else project_root / args.output
    try:
        workspace = GraphicsWorkspace(project_root, workspace_root, args.profile)
        prg_workspace = PrgGraphicsWorkspace(
            project_root, workspace_root, args.profile
        )
        hierarchy_workspace = LevelWorkspace(
            project_root, workspace_root, args.profile
        )
        chr_data = (
            workspace.canonical_chr()[0].read_bytes()
            if args.canonical
            else workspace.load().encode()
        )
        documents = (
            prg_workspace.load_canonical()
            if args.canonical
            else prg_workspace.load()
        )
        hierarchies = (
            {
                world_id: HierarchicalWorldDocument.load(
                    project_root / relative
                )
                for world_id, relative in CANONICAL_WORLDS.items()
            }
            if args.canonical
            else {
                world_id: hierarchy_workspace.load(world_id)
                for world_id in CANONICAL_WORLDS
            }
        )
        base = base_path.read_bytes()
        built = apply_graphics_payload(base, chr_data, documents, hierarchies)
        differing = sum(left != right for left, right in zip(base, built))
        if args.require_identical and built != base:
            raise ValueError(
                f"canonical graphics roundtrip changed {differing} ROM bytes"
            )
        atomic_write(output, built)
    except (OSError, ValueError, KeyError, TypeError) as exc:
        print(f"[ERROR] graphics content build failed: {exc}")
        return 1
    crc32 = zlib.crc32(built) & 0xFFFFFFFF
    print(
        f"[OK] wrote {len(built)}-byte {args.profile} graphics ROM to {output} "
        f"(CRC32 {crc32:08X}, {differing} changed bytes)"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
