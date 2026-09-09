"""Shared process boundary for Studio ROM build actions."""

from __future__ import annotations

from pathlib import Path
import subprocess
from typing import Protocol


class BuildLauncher(Protocol):
    """Launch one profile-aware content build for a Studio workspace."""

    def __call__(
        self,
        project_root: Path,
        target: str,
        profile: str,
        workspace_root: Path,
    ) -> object: ...


def launch_content_build(
    project_root: Path,
    target: str,
    profile: str,
    workspace_root: Path,
) -> subprocess.Popen[bytes]:
    """Start a Studio build without losing a custom workspace selection."""

    return subprocess.Popen(
        [
            "make",
            target,
            f"PROFILE={profile}",
            f"CONTENT_WORKSPACE={workspace_root.as_posix()}",
        ],
        cwd=project_root,
    )
