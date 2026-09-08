#!/usr/bin/env python3
"""Run every Doraemon Studio headlessly in an isolated workspace."""

from __future__ import annotations

import argparse
from pathlib import Path
import subprocess
import sys
import tempfile


PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent
STUDIOS = (
    ("level", "authoring.level_studio", True),
    ("graphics", "authoring.graphics_studio", False),
    ("objects", "authoring.object_studio", False),
    ("text", "authoring.text_studio", True),
    ("sound", "authoring.sound_studio", False),
)


def command(
    project_root: Path,
    workspace: Path,
    profile: str,
    module: str,
    needs_chr: bool,
    chr_path: Path,
) -> list[str]:
    arguments = [
        sys.executable,
        str(project_root / "scripts" / "run.py"),
        module,
        "--project-root",
        str(project_root),
        "--workspace",
        str(workspace),
        "--profile",
        profile,
        "--check",
    ]
    if needs_chr:
        arguments.extend(("--chr", str(chr_path)))
    return arguments


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project-root", type=Path, default=PROJECT_ROOT)
    parser.add_argument(
        "--chr", type=Path, default=Path("assets/generated/chr/doraemon.chr")
    )
    parser.add_argument(
        "--profile",
        action="append",
        choices=("original", "rev_a"),
        dest="profiles",
    )
    args = parser.parse_args()
    project_root = args.project_root.resolve()
    chr_path = args.chr if args.chr.is_absolute() else project_root / args.chr
    profiles = args.profiles or ["original", "rev_a"]
    try:
        with tempfile.TemporaryDirectory(prefix="doraemon-studio-smoke-") as root:
            workspace = Path(root)
            for profile in profiles:
                for studio_id, module, needs_chr in STUDIOS:
                    result = subprocess.run(
                        command(
                            project_root,
                            workspace,
                            profile,
                            module,
                            needs_chr,
                            chr_path,
                        ),
                        cwd=project_root,
                        check=False,
                    )
                    if result.returncode:
                        print(
                            f"[ERROR] {studio_id} Studio smoke failed "
                            f"for {profile}"
                        )
                        return result.returncode
    except OSError as exc:
        print(f"[ERROR] cannot run Studio smoke matrix: {exc}")
        return 1
    print(
        f"[OK] {len(STUDIOS)} Studios passed isolated checks for "
        f"{len(profiles)} profile(s)"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
