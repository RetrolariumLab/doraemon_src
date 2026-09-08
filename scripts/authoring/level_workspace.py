#!/usr/bin/env python3
"""Initialize, validate, or export Doraemon Level Studio workspaces."""

from __future__ import annotations

import argparse
from pathlib import Path
import sys


SCRIPTS = Path(__file__).resolve().parent.parent
if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))

from scripts.authoring.level_studio_model import CANONICAL_WORLDS, LevelWorkspace
from scripts.authoring.world2_level_model import (
    World2ScreenDocument,
    initialize_workspace as initialize_world2_workspace,
    workspace_path as world2_workspace_path,
)


PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent


def resolved_path(project_root: Path, path: Path) -> Path:
    return path if path.is_absolute() else project_root / path


def export_workspace(workspace: LevelWorkspace, output: Path) -> dict[str, Path]:
    sizes = workspace.validate()
    world2 = World2ScreenDocument.load(
        world2_workspace_path(workspace.root, workspace.profile)
    )
    sizes["world2"] = len(world2.encode())
    output.mkdir(parents=True, exist_ok=True)
    written: dict[str, Path] = {}
    for world_id in CANONICAL_WORLDS:
        destination = output / f"{world_id}.bin"
        payload = workspace.load(world_id).encode()
        if len(payload) != sizes[world_id]:
            raise ValueError(f"{world_id} changed during export")
        destination.write_bytes(payload)
        written[world_id] = destination
    destination = output / "world2.bin"
    destination.write_bytes(world2.encode())
    written["world2"] = destination
    return written


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("init", "validate", "export"))
    parser.add_argument("--project-root", type=Path, default=PROJECT_ROOT)
    parser.add_argument("--workspace", type=Path, default=Path("content/workspace"))
    parser.add_argument("--profile", choices=("original", "rev_a"), default="original")
    parser.add_argument("--output", type=Path, default=Path("build/content"))
    args = parser.parse_args()

    project_root = args.project_root.resolve()
    workspace = LevelWorkspace(
        project_root,
        resolved_path(project_root, args.workspace),
        args.profile,
    )
    try:
        if args.command == "init":
            created = list(workspace.initialize())
            world2_created = initialize_world2_workspace(
                project_root, workspace.root, args.profile
            )
            if world2_created is not None:
                created.append(world2_created)
            detail = f"created {len(created)} files" if created else "already initialized"
            print(f"[OK] {args.profile} level workspace {detail}: {workspace.directory}")
            return 0
        if args.command == "validate":
            sizes = workspace.validate()
            world2 = World2ScreenDocument.load(
                world2_workspace_path(workspace.root, args.profile)
            )
            sizes["world2"] = len(world2.encode())
            summary = ", ".join(
                f"{world_id} {size} bytes" for world_id, size in sizes.items()
            )
            print(f"[OK] {args.profile} level workspace is valid: {summary}")
            return 0
        destination = resolved_path(project_root, args.output) / args.profile / "levels"
        written = export_workspace(workspace, destination)
        summary = ", ".join(
            f"{world_id} -> {path}" for world_id, path in written.items()
        )
        print(f"[OK] exported level payloads: {summary}")
        return 0
    except (OSError, ValueError, KeyError, TypeError) as exc:
        print(f"[ERROR] Level Studio workspace failed: {exc}")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
