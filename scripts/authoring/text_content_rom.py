#!/usr/bin/env python3
"""Compose Doraemon text workspace edits into a source-built revision ROM."""

from __future__ import annotations

import argparse
from pathlib import Path
import sys
import zlib


SCRIPTS = Path(__file__).resolve().parent.parent
if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))

from scripts.build import project
from scripts.validation.reconstruction import shell_text
from scripts.authoring.graphics_studio_model import atomic_write
from scripts.authoring.text_studio_model import TextDocument, TextWorkspace


PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent
HEADER_SIZE = 16
PRG_SIZE = 0x20000
CHR_SIZE = 0x8000


def apply_text_payload(rom: bytes, document: TextDocument) -> bytes:
    parsed = project.parse_ines(rom)
    if (
        parsed["mapper"] != 66
        or parsed["trainer_size"] != 0
        or parsed["prg_size"] != PRG_SIZE
        or parsed["chr_size"] != CHR_SIZE
    ):
        raise ValueError("base ROM is not the expected Doraemon GNROM image")
    result = bytearray(rom)
    prg = shell_text.apply_authoring(
        bytes(result[HEADER_SIZE:HEADER_SIZE + PRG_SIZE]),
        document.document,
        document.manifest,
    )
    result[HEADER_SIZE:HEADER_SIZE + PRG_SIZE] = prg
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
        args.workspace if args.workspace.is_absolute() else project_root / args.workspace
    )
    base_path = args.base_rom if args.base_rom.is_absolute() else project_root / args.base_rom
    output = args.output if args.output.is_absolute() else project_root / args.output
    workspace = TextWorkspace(project_root, workspace_root, args.profile)
    try:
        document = workspace.load_canonical() if args.canonical else workspace.load()
        base = base_path.read_bytes()
        built = apply_text_payload(base, document)
        differing = sum(left != right for left, right in zip(base, built))
        if args.require_identical and built != base:
            raise ValueError(f"canonical text roundtrip changed {differing} ROM bytes")
        atomic_write(output, built)
    except (OSError, ValueError, KeyError, TypeError) as exc:
        print(f"[ERROR] text content build failed: {exc}")
        return 1
    checksum = zlib.crc32(built) & 0xFFFFFFFF
    print(
        f"[OK] wrote {len(built)}-byte {args.profile} text ROM to {output} "
        f"(CRC32 {checksum:08X}, {differing} changed bytes)"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
