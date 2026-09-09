#!/usr/bin/env python3
"""Run a real public Make command from a disposable tracked-only clone."""

from __future__ import annotations

import argparse
from dataclasses import dataclass
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

from scripts.build.make_help import documented_targets


ROOT = Path(__file__).resolve().parents[2]


class PublicCommandSmokeError(RuntimeError):
    """A disposable public command did not complete successfully."""


@dataclass(frozen=True)
class ControlledReleaseResult:
    calls: tuple[str, ...]
    returncode: int
    output: str


SOURCE_2_CHECK_SEQUENCE = (
    "source-1-check",
    "audit-revisions",
    "verify-revisions",
    "level-content-roundtrip",
    "graphics-content-roundtrip",
    "object-content-roundtrip",
    "text-content-roundtrip",
    "sound-content-roundtrip",
    "content-roundtrip",
    "check-studios",
    "check-sound-preview",
    "check-sound-preview",
    "runtime-revision-matrix",
    "source-2-audit",
)


def clone_repository(project_root: Path, clone: Path) -> None:
    clone_result = subprocess.run(
        [
            "git",
            "clone",
            "--quiet",
            "--shared",
            "--no-local",
            str(project_root.resolve()),
            str(clone),
        ],
        check=False,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
    )
    if clone_result.returncode != 0:
        raise PublicCommandSmokeError(
            f"cannot create disposable clone: {clone_result.stderr.strip()}"
        )


def run_disposable_make(
    project_root: Path,
    target: str = "lint",
    *,
    make_executable: str | None = None,
) -> str:
    if target not in documented_targets():
        raise PublicCommandSmokeError(f"target is not public: {target}")
    make = make_executable or shutil.which("make")
    if not make:
        raise PublicCommandSmokeError("make executable not found")
    with tempfile.TemporaryDirectory(prefix="doraemon-public-command-") as directory:
        clone = Path(directory) / "repository"
        clone_repository(project_root, clone)
        result = subprocess.run(
            [make, target],
            cwd=clone,
            check=False,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
        )
        if result.returncode != 0:
            details = (result.stdout + result.stderr).strip()
            raise PublicCommandSmokeError(
                f"public command 'make {target}' failed in disposable clone:\n"
                f"{details}"
            )
        status = subprocess.run(
            ["git", "status", "--porcelain"],
            cwd=clone,
            check=True,
            capture_output=True,
            text=True,
            encoding="utf-8",
        ).stdout.strip()
        if status:
            raise PublicCommandSmokeError(
                f"public command 'make {target}' changed the disposable worktree"
            )
        return result.stdout


def run_controlled_source_2_check(
    project_root: Path,
    *,
    fail_target: str | None = None,
    make_executable: str | None = None,
) -> ControlledReleaseResult:
    """Run the real Source 2.0 recipe with controlled recursive commands."""
    make = make_executable or shutil.which("make")
    if not make:
        raise PublicCommandSmokeError("make executable not found")
    with tempfile.TemporaryDirectory(prefix="doraemon-source-2-command-") as directory:
        fixture = Path(directory)
        clone = fixture / "repository"
        helper = fixture / "controlled_make.py"
        log = fixture / "calls.txt"
        clone_repository(project_root, clone)
        helper.write_text(
            "from pathlib import Path\n"
            "import os\n"
            "import sys\n"
            "target = sys.argv[1] if len(sys.argv) > 1 else ''\n"
            "with Path(os.environ['CONTROLLED_MAKE_LOG']).open(\n"
            "    'a', encoding='utf-8', newline='\\n'\n"
            ") as stream:\n"
            "    stream.write(target + '\\n')\n"
            "if target == os.environ.get('CONTROLLED_MAKE_FAILURE'):\n"
            "    raise SystemExit(23)\n",
            encoding="utf-8",
            newline="\n",
        )
        recursive_make = subprocess.list2cmdline([sys.executable, str(helper)])
        environment = os.environ.copy()
        environment["CONTROLLED_MAKE_LOG"] = str(log)
        if fail_target is not None:
            environment["CONTROLLED_MAKE_FAILURE"] = fail_target
        result = subprocess.run(
            [make, f"MAKE={recursive_make}", "source-2-check"],
            cwd=clone,
            env=environment,
            check=False,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
        )
        calls = tuple(log.read_text(encoding="utf-8").splitlines())
        return ControlledReleaseResult(
            calls=calls,
            returncode=result.returncode,
            output=result.stdout + result.stderr,
        )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project-root", type=Path, default=ROOT)
    parser.add_argument("--target", default="lint")
    args = parser.parse_args()
    try:
        output = run_disposable_make(args.project_root, args.target)
    except (OSError, subprocess.SubprocessError, PublicCommandSmokeError) as exc:
        print(f"[ERROR] {exc}")
        return 1
    summary = next(
        (line for line in reversed(output.splitlines()) if line.startswith("[OK]")),
        "completed",
    )
    print(f"[OK] disposable 'make {args.target}': {summary}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
