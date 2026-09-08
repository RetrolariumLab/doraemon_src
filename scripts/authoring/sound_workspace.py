#!/usr/bin/env python3
"""Initialize, validate, or export a Doraemon sound workspace."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys


SCRIPTS = Path(__file__).resolve().parent.parent
if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))

from scripts.authoring.graphics_studio_model import atomic_write
from scripts.authoring.sound_studio_model import SoundWorkspace


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
    workspace = SoundWorkspace(
        project_root,
        resolved_path(project_root, args.workspace),
        args.profile,
    )
    try:
        if args.command == "init":
            created = workspace.initialize()
            detail = f"created {created}" if created is not None else "already initialized"
            print(f"[OK] {args.profile} sound workspace {detail}")
            return 0
        size = workspace.validate()
        if args.command == "validate":
            print(f"[OK] {args.profile} sound workspace: {size} fixed audio bytes")
            return 0
        destination = (
            resolved_path(project_root, args.output)
            / args.profile
            / "sound"
        )
        destination.mkdir(parents=True, exist_ok=True)
        documents = {
            "music_streams.json": workspace.load().document,
            "effect_priorities.json": workspace.load_priorities().document,
        }
        for name, document in documents.items():
            atomic_write(
                destination / name,
                (json.dumps(document, indent=2) + "\n").encode("utf-8"),
            )
        print(f"[OK] exported {size} music bytes to {destination}")
        return 0
    except (OSError, ValueError, KeyError, TypeError) as exc:
        print(f"[ERROR] sound workspace failed: {exc}")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
