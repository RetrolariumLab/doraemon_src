#!/usr/bin/env python3
"""Apply Level Studio payloads to a source-built Doraemon ROM."""

from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import tempfile
import zlib

import sys


SCRIPTS = Path(__file__).resolve().parent.parent
if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))

from scripts.build import project
from scripts.authoring.level_studio_model import HierarchicalWorldDocument, LevelWorkspace
from scripts.authoring.world2_level_model import (
    CANONICAL_PATH as WORLD2_CANONICAL_PATH,
    World2ScreenDocument,
    workspace_path as world2_workspace_path,
)


PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent
HEADER_SIZE = 16
PRG_BANK_SIZE = 0x8000
LEVEL_RANGES = {
    "world1": (0, 0xA9EF, 8000),
    "world2": (1, 0xBEDE, 16669),
    "world3": (2, 0xDDF2, 6400),
}


def crc32(data: bytes) -> str:
    return f"{zlib.crc32(data) & 0xFFFFFFFF:08X}"


def _write_bytes_atomic(path: Path, data: bytes) -> None:
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


def apply_level_payloads(rom: bytes, payloads: dict[str, bytes]) -> bytes:
    parsed = project.parse_ines(rom)
    if (
        parsed["mapper"] != 66
        or parsed["trainer_size"] != 0
        or parsed["prg_size"] != 4 * PRG_BANK_SIZE
        or parsed["chr_size"] != 4 * 0x2000
    ):
        raise ValueError("base ROM is not the expected four-bank Doraemon GNROM image")
    if set(payloads) != set(LEVEL_RANGES):
        raise ValueError("level payload set must contain world1, world2, and world3")
    result = bytearray(rom)
    for world_id, (bank, address, expected_size) in LEVEL_RANGES.items():
        payload = payloads[world_id]
        if len(payload) != expected_size:
            raise ValueError(
                f"{world_id} payload has {len(payload)} bytes, expected {expected_size}"
            )
        offset = HEADER_SIZE + bank * PRG_BANK_SIZE + address - 0x8000
        result[offset:offset + len(payload)] = payload
    return bytes(result)


def load_canonical_payloads(project_root: Path) -> dict[str, bytes]:
    return {
        "world1": HierarchicalWorldDocument.load(
            project_root / "data/world1/hierarchical_world.json"
        ).encode(),
        "world2": World2ScreenDocument.load(
            project_root / WORLD2_CANONICAL_PATH
        ).encode(),
        "world3": HierarchicalWorldDocument.load(
            project_root / "data/world3/hierarchical_world.json"
        ).encode(),
    }


def load_workspace_payloads(
    project_root: Path,
    workspace_root: Path,
    profile: str,
) -> dict[str, bytes]:
    workspace = LevelWorkspace(project_root, workspace_root, profile)
    return {
        "world1": workspace.load("world1").encode(),
        "world2": World2ScreenDocument.load(
            world2_workspace_path(workspace.root, profile)
        ).encode(),
        "world3": workspace.load("world3").encode(),
    }


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
    output = args.output if args.output.is_absolute() else project_root / args.output
    base_rom_path = (
        args.base_rom
        if args.base_rom.is_absolute()
        else project_root / args.base_rom
    )
    try:
        base = base_rom_path.read_bytes()
        payloads = (
            load_canonical_payloads(project_root)
            if args.canonical
            else load_workspace_payloads(project_root, workspace_root, args.profile)
        )
        built = apply_level_payloads(base, payloads)
        differing = sum(left != right for left, right in zip(base, built))
        if args.require_identical and built != base:
            raise ValueError(
                f"canonical level roundtrip changed {differing} ROM bytes"
            )
        _write_bytes_atomic(output, built)
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] level content build failed: {exc}")
        return 1
    print(
        f"[OK] wrote {len(built)}-byte {args.profile} level-content ROM "
        f"to {output} (CRC32 {crc32(built)}, {differing} changed bytes)"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
