#!/usr/bin/env python3
"""Compose Doraemon object workspace edits into a source-built revision ROM."""

from __future__ import annotations

import argparse
from pathlib import Path
import sys
import zlib


SCRIPTS = Path(__file__).resolve().parent.parent
if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))

from scripts.build import project
from scripts.authoring.graphics_studio_model import atomic_write
from scripts.authoring.object_artifacts import (
    ObjectArtifactDocument,
    ObjectWorkspace,
    apply_object_artifacts,
)
from scripts.authoring.world2_level_model import (
    CANONICAL_PATH as WORLD2_CANONICAL_PATH,
    World2ScreenDocument,
    workspace_path as world2_workspace_path,
)


PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent
HEADER_SIZE = 16
PRG_SIZE = 0x20000
CHR_SIZE = 0x8000
WORLD2_BANK = 1
WORLD2_ADDRESS = 0xBEDE
WORLD2_SIZE = 16669


def apply_object_payload(
    rom: bytes,
    documents: dict[str, ObjectArtifactDocument],
    world2: World2ScreenDocument,
) -> bytes:
    parsed = project.parse_ines(rom)
    if (
        parsed["mapper"] != 66
        or parsed["trainer_size"] != 0
        or parsed["prg_size"] != PRG_SIZE
        or parsed["chr_size"] != CHR_SIZE
    ):
        raise ValueError("base ROM is not the expected Doraemon GNROM image")
    world2_payload = world2.encode()
    if len(world2_payload) != WORLD2_SIZE:
        raise ValueError(
            f"World 2 stream has {len(world2_payload)} bytes, expected {WORLD2_SIZE}"
        )
    result = bytearray(rom)
    prg = apply_object_artifacts(
        bytes(result[HEADER_SIZE:HEADER_SIZE + PRG_SIZE]), documents
    )
    result[HEADER_SIZE:HEADER_SIZE + PRG_SIZE] = prg
    offset = (
        HEADER_SIZE
        + WORLD2_BANK * 0x8000
        + WORLD2_ADDRESS
        - 0x8000
    )
    result[offset:offset + WORLD2_SIZE] = world2_payload
    return bytes(result)


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
    workspace = ObjectWorkspace(project_root, workspace_root, args.profile)
    try:
        documents = (
            workspace.load_canonical() if args.canonical else workspace.load()
        )
        world2 = World2ScreenDocument.load(
            project_root / WORLD2_CANONICAL_PATH
            if args.canonical
            else world2_workspace_path(workspace_root, args.profile)
        )
        base = base_path.read_bytes()
        built = apply_object_payload(base, documents, world2)
        differing = sum(left != right for left, right in zip(base, built))
        if args.require_identical and built != base:
            raise ValueError(
                f"canonical object roundtrip changed {differing} ROM bytes"
            )
        atomic_write(output, built)
    except (OSError, ValueError, KeyError, TypeError) as exc:
        print(f"[ERROR] object content build failed: {exc}")
        return 1
    checksum = zlib.crc32(built) & 0xFFFFFFFF
    print(
        f"[OK] wrote {len(built)}-byte {args.profile} object ROM to {output} "
        f"(CRC32 {checksum:08X}, {differing} changed bytes)"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
