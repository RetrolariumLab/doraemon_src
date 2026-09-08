#!/usr/bin/env python3
"""Initialize, validate, or export a Doraemon object workspace."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys


SCRIPTS = Path(__file__).resolve().parent.parent
if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))

from scripts.authoring.graphics_studio_model import atomic_write
from scripts.authoring.object_artifacts import ARTIFACTS, ObjectWorkspace
from scripts.authoring.world2_level_model import (
    World2ScreenDocument,
    initialize_workspace as initialize_world2_workspace,
    workspace_path as world2_workspace_path,
)


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
    workspace_root = resolved_path(project_root, args.workspace)
    workspace = ObjectWorkspace(project_root, workspace_root, args.profile)
    try:
        if args.command == "init":
            created = list(workspace.initialize())
            world2_created = initialize_world2_workspace(
                project_root, workspace_root, args.profile
            )
            if world2_created is not None:
                created.append(world2_created)
            detail = f"created {len(created)} files" if created else "already initialized"
            print(f"[OK] {args.profile} object workspace {detail}")
            return 0

        sizes = workspace.validate()
        world2 = World2ScreenDocument.load(
            world2_workspace_path(workspace_root, args.profile)
        )
        world2_size = len(world2.encode())
        if args.command == "validate":
            print(
                f"[OK] {args.profile} object workspace: "
                f"{sum(sizes.values())} bytes in {len(sizes)} typed artifacts, "
                f"{world2_size} shared World 2 stream bytes"
            )
            return 0

        output = resolved_path(project_root, args.output) / args.profile / "objects"
        documents = workspace.load()
        for artifact in ARTIFACTS:
            destination = output / f"{artifact.id}.json"
            atomic_write(
                destination,
                (
                    json.dumps(documents[artifact.id].document, indent=2) + "\n"
                ).encode("utf-8"),
            )
        atomic_write(
            output / "world2_embedded_spawns.json",
            (json.dumps(world2.document, indent=2) + "\n").encode("utf-8"),
        )
        print(
            f"[OK] exported {len(sizes)} object artifacts and the shared "
            f"World 2 screen document to {output}"
        )
        return 0
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] object workspace failed: {exc}")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
