#!/usr/bin/env python3
"""Initialize, validate, or export a Doraemon graphics workspace."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys


SCRIPTS = Path(__file__).resolve().parent.parent
if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))

from scripts.authoring.graphics_studio_model import GraphicsWorkspace, atomic_write
from scripts.authoring.graphics_artifacts import PrgGraphicsWorkspace
from scripts.authoring.level_studio_model import CANONICAL_WORLDS, LevelWorkspace


PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent


def resolved_path(project_root: Path, path: Path) -> Path:
    return path if path.is_absolute() else project_root / path


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("init", "validate", "export"))
    parser.add_argument("--project-root", type=Path, default=PROJECT_ROOT)
    parser.add_argument("--workspace", type=Path, default=Path("content/workspace"))
    parser.add_argument("--profile", choices=("original", "rev_a"), default="original")
    parser.add_argument("--output", type=Path, default=Path("build/content"))
    args = parser.parse_args()

    project_root = args.project_root.resolve()
    workspace = GraphicsWorkspace(
        project_root,
        resolved_path(project_root, args.workspace),
        args.profile,
    )
    prg_workspace = PrgGraphicsWorkspace(
        project_root,
        resolved_path(project_root, args.workspace),
        args.profile,
    )
    hierarchy_workspace = LevelWorkspace(
        project_root,
        resolved_path(project_root, args.workspace),
        args.profile,
    )
    try:
        if args.command == "init":
            created = workspace.initialize()
            prg_created = prg_workspace.initialize()
            hierarchy_created = hierarchy_workspace.initialize()
            created_count = (
                int(created is not None) + len(prg_created) + len(hierarchy_created)
            )
            detail = (
                f"created {created_count} files"
                if created_count
                else "already initialized"
            )
            print(f"[OK] {args.profile} graphics workspace {detail}")
            return 0
        size = workspace.validate()
        artifact_sizes = prg_workspace.validate()
        hierarchy_sizes = hierarchy_workspace.validate()
        if args.command == "validate":
            print(
                f"[OK] {args.profile} graphics workspace: {size} CHR bytes, "
                f"{sum(artifact_sizes.values())} PRG bytes in "
                f"{len(artifact_sizes)} typed artifacts, "
                f"{sum(hierarchy_sizes.values())} shared hierarchy bytes"
            )
            return 0
        output_directory = (
            resolved_path(project_root, args.output)
            / args.profile
            / "graphics"
        )
        chr_destination = output_directory / "chr.bin"
        atomic_write(chr_destination, workspace.load().encode())
        for artifact_id, document in prg_workspace.load().items():
            destination = output_directory / f"{artifact_id}.json"
            atomic_write(
                destination,
                (json.dumps(document.document, indent=2) + "\n").encode("utf-8"),
            )
        for world_id in CANONICAL_WORLDS:
            document = hierarchy_workspace.load(world_id)
            destination = output_directory / "hierarchies" / f"{world_id}.json"
            atomic_write(
                destination,
                (json.dumps(document.document, indent=2) + "\n").encode("utf-8"),
            )
        print(
            f"[OK] exported {size} CHR bytes and {len(artifact_sizes)} "
            f"PRG graphics artifacts plus {len(hierarchy_sizes)} shared "
            f"hierarchies to {output_directory}"
        )
        return 0
    except (OSError, ValueError, KeyError, TypeError) as exc:
        print(f"[ERROR] graphics workspace failed: {exc}")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
