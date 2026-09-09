#!/usr/bin/env python3
"""Exercise every supported Studio through real Windows GUI windows."""

from __future__ import annotations

import argparse
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import tkinter as tk
from types import SimpleNamespace
from unittest import mock

from scripts.authoring import (
    graphics_studio,
    level_studio,
    object_studio,
    sound_studio,
    text_studio,
)
from scripts.authoring.graphics_artifacts import PrgGraphicsWorkspace
from scripts.authoring.graphics_studio_model import ChrDocument, GraphicsWorkspace
from scripts.authoring.level_studio_model import LevelWorkspace
from scripts.authoring.object_artifacts import ObjectWorkspace
from scripts.authoring.object_studio import set_scalar, value_at
from scripts.authoring.sound_studio_model import SoundWorkspace, load_json
from scripts.authoring.text_studio_model import TextWorkspace
from scripts.authoring.world2_level_model import (
    World2ScreenDocument,
    initialize_workspace as initialize_world2_workspace,
    workspace_path as world2_workspace_path,
)


PROJECT_ROOT = Path(__file__).resolve().parents[2]
STUDIO_IDS = ("level", "graphics", "objects", "text", "sound")
BUILD_OUTPUTS = {
    "graphics-content-rom": "doraemon-graphics.nes",
    "object-content-rom": "doraemon-objects.nes",
    "text-content-rom": "doraemon-text.nes",
    "sound-content-rom": "doraemon-sound.nes",
}


class WorkstationSmokeError(RuntimeError):
    """A real-window Studio interaction did not meet its contract."""


class SynchronousBuildLauncher:
    """Run GUI build actions to completion in an isolated output root."""

    def __init__(
        self,
        workspace_root: Path,
        output_root: Path,
        make_executable: str,
    ) -> None:
        self.workspace_root = workspace_root.resolve()
        self.output_root = output_root.resolve()
        self.make_executable = make_executable
        self.targets: list[str] = []

    def __call__(
        self,
        project_root: Path,
        target: str,
        profile: str,
        workspace_root: Path,
    ) -> subprocess.CompletedProcess[str]:
        if target not in BUILD_OUTPUTS:
            raise WorkstationSmokeError(f"unexpected Studio build target: {target}")
        if workspace_root.resolve() != self.workspace_root:
            raise WorkstationSmokeError("Studio build escaped the disposable workspace")
        output = self.output_root.as_posix()
        command = [
            self.make_executable,
            target,
            f"PROFILE={profile}",
            f"CONTENT_WORKSPACE={self.workspace_root.as_posix()}",
            f"GRAPHICS_CONTENT_OUTPUT={output}",
            f"OBJECT_CONTENT_OUTPUT={output}",
            f"TEXT_CONTENT_OUTPUT={output}",
            f"SOUND_CONTENT_OUTPUT={output}",
        ]
        result = subprocess.run(
            command,
            cwd=project_root,
            check=False,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
        )
        if result.returncode:
            detail = (result.stdout + result.stderr).strip()
            raise WorkstationSmokeError(
                f"Studio action '{target}' failed with exit "
                f"{result.returncode}:\n{detail}"
            )
        expected = self.output_root / profile / BUILD_OUTPUTS[target]
        if not expected.is_file():
            raise WorkstationSmokeError(
                f"Studio action '{target}' did not create {expected}"
            )
        self.targets.append(target)
        return result


def _exists(window: tk.Misc) -> bool:
    try:
        return bool(window.winfo_exists())
    except tk.TclError:
        return False


def _show_window(window: tk.Misc, studio_id: str, preview_items: int) -> None:
    window.update_idletasks()
    window.update()
    if not window.winfo_viewable():
        raise WorkstationSmokeError(f"{studio_id} Studio window was not mapped")
    if preview_items <= 0:
        raise WorkstationSmokeError(f"{studio_id} Studio rendered no preview")


def _close_with_unsaved_choice(
    window: tk.Misc,
    close_action,
    prompt_owner: object,
    prompt_name: str,
    *,
    cancel_choice: object,
    discard_choice: object,
) -> None:
    with mock.patch.object(
        prompt_owner, prompt_name, side_effect=(cancel_choice, discard_choice)
    ):
        close_action()
        if not _exists(window):
            raise WorkstationSmokeError("cancelled unsaved close destroyed a Studio")
        close_action()
        if _exists(window):
            raise WorkstationSmokeError("discarded unsaved close kept a Studio open")


def _alternate_hex(value: object) -> str:
    number = int(str(value), 0)
    return f"0x{(number + 1) & 0xFF:02X}"


def exercise_level(
    project_root: Path,
    workspace_root: Path,
    profile: str,
    chr_path: Path,
) -> None:
    workspace = LevelWorkspace(project_root, workspace_root, profile)
    root = tk.Tk()
    app = None
    try:
        app = level_studio.LevelStudioApp(root, project_root, workspace, chr_path)
        _show_window(root, "level", len(app.map_canvas.find_all()))
        model = app.models["world1"]
        original = model.cell("city", 0, 0)
        model.paint("city", 0, 0, (original + 1) & 0xFF)
        app._draw_map()
        app._save()
        if model.dirty:
            raise WorkstationSmokeError("Level Studio Save all left edits dirty")
        with mock.patch.object(level_studio.messagebox, "showinfo") as shown:
            app._validate()
        if shown.call_count != 1:
            raise WorkstationSmokeError("Level Studio validation did not report success")
        model.paint("city", 0, 0, (original + 2) & 0xFF)
        _close_with_unsaved_choice(
            root,
            app._close,
            level_studio.messagebox,
            "askyesnocancel",
            cancel_choice=None,
            discard_choice=False,
        )
    finally:
        if _exists(root):
            root.destroy()


def exercise_graphics(
    project_root: Path,
    workspace_root: Path,
    profile: str,
    launcher: SynchronousBuildLauncher,
) -> None:
    workspace = GraphicsWorkspace(project_root, workspace_root, profile)
    artifacts_workspace = PrgGraphicsWorkspace(project_root, workspace_root, profile)
    hierarchy_workspace = LevelWorkspace(project_root, workspace_root, profile)
    workspace.initialize()
    artifacts_workspace.initialize()
    hierarchy_workspace.initialize()
    document = workspace.load()
    app = graphics_studio.GraphicsStudio(
        document,
        artifacts_workspace.load(),
        {
            world: hierarchy_workspace.load(world)
            for world in ("world1", "world3")
        },
        project_root,
        workspace_root,
        profile,
        launcher,
    )
    try:
        _show_window(app, "graphics", len(app.pixel_editor.find_all()))
        event = SimpleNamespace(x=1, y=1)
        app.ink.set((document.tiles[app.tile_index][0][0] + 1) % 4)
        app.start_paint(event)
        app.end_paint()
        app.save()
        if document.dirty:
            raise WorkstationSmokeError("Graphics Studio Save all left edits dirty")
        app.build_rom()
        app.ink.set((document.tiles[app.tile_index][0][0] + 1) % 4)
        app.start_paint(event)
        app.end_paint()
        _close_with_unsaved_choice(
            app,
            app.close,
            graphics_studio.messagebox,
            "askyesno",
            cancel_choice=False,
            discard_choice=True,
        )
    finally:
        if _exists(app):
            app.destroy()


def exercise_objects(
    project_root: Path,
    workspace_root: Path,
    profile: str,
    launcher: SynchronousBuildLauncher,
) -> None:
    workspace = ObjectWorkspace(project_root, workspace_root, profile)
    workspace.initialize()
    initialize_world2_workspace(project_root, workspace_root, profile)
    documents = workspace.load()
    world2 = World2ScreenDocument.load(world2_workspace_path(workspace_root, profile))
    app = object_studio.ObjectStudio(
        documents,
        world2,
        project_root,
        workspace_root,
        profile,
        launcher,
    )
    document = documents["world1_weapons"]
    path = ("levels", 0, "directions", 0, "x_offset")
    try:
        _show_window(app, "objects", len(app.browser.preview.find_all()))
        document.change(
            lambda data: set_scalar(
                data, path, _alternate_hex(value_at(data, path))
            )
        )
        app.save()
        if app.dirty():
            raise WorkstationSmokeError("Object Studio Save all left edits dirty")
        app.build_rom()
        document.change(
            lambda data: set_scalar(
                data, path, _alternate_hex(value_at(data, path))
            )
        )
        _close_with_unsaved_choice(
            app,
            app.close,
            object_studio.messagebox,
            "askyesno",
            cancel_choice=False,
            discard_choice=True,
        )
    finally:
        if _exists(app):
            app.destroy()


def _edit_text_row(app: text_studio.TextStudio) -> None:
    values = bytearray.fromhex(app.raw_value.get())
    values[0] = (values[0] + 1) & 0xFF
    app.raw_value.set(values.hex(" "))
    app.apply_raw()


def exercise_text(
    project_root: Path,
    workspace_root: Path,
    profile: str,
    chr_path: Path,
    launcher: SynchronousBuildLauncher,
) -> None:
    workspace = TextWorkspace(project_root, workspace_root, profile)
    workspace.initialize()
    document = workspace.load()
    app = text_studio.TextStudio(
        document,
        ChrDocument.load(chr_path),
        project_root,
        workspace_root,
        profile,
        launcher,
    )
    try:
        _show_window(app, "text", len(app.line_canvas.find_all()))
        _edit_text_row(app)
        app.save()
        if document.dirty:
            raise WorkstationSmokeError("Text Studio Save left edits dirty")
        app.build_rom()
        _edit_text_row(app)
        _close_with_unsaved_choice(
            app,
            app.close,
            text_studio.messagebox,
            "askyesno",
            cancel_choice=False,
            discard_choice=True,
        )
    finally:
        if _exists(app):
            app.destroy()


def exercise_sound(
    project_root: Path,
    workspace_root: Path,
    profile: str,
    prg_path: Path,
    launcher: SynchronousBuildLauncher,
) -> None:
    workspace = SoundWorkspace(project_root, workspace_root, profile)
    workspace.initialize()
    music = workspace.load()
    priorities = workspace.load_priorities()
    app = sound_studio.SoundStudio(
        music,
        priorities,
        load_json(project_root / sound_studio.EFFECTS_PATH),
        project_root,
        workspace_root,
        profile,
        prg_path.read_bytes(),
        launcher,
    )
    try:
        _show_window(app, "sound", len(app.piano_roll.find_all()))
        app.effect_target_box.current(1)
        app.swap_effect()
        app.play_selected_track()
        if app.decoded_preview is None or not app.preview_path.is_file():
            raise WorkstationSmokeError("Sound Studio Play created no preview")
        app.stop_embedded_preview()
        app.save()
        if music.dirty or priorities.dirty:
            raise WorkstationSmokeError("Sound Studio Save left edits dirty")
        app.build_rom()
        app.effect_target_box.current(1)
        app.swap_effect()
        _close_with_unsaved_choice(
            app,
            app.close,
            sound_studio.messagebox,
            "askyesno",
            cancel_choice=False,
            discard_choice=True,
        )
    finally:
        if _exists(app):
            app.stop_embedded_preview(update_status=False)
            app.destroy()


def run_workstation_smoke(
    project_root: Path,
    profile: str,
    *,
    make_executable: str | None = None,
) -> tuple[str, ...]:
    if sys.platform != "win32":
        raise WorkstationSmokeError("Studio interaction smoke requires Windows")
    make = make_executable or shutil.which("make")
    if not make:
        raise WorkstationSmokeError("make executable not found")
    build_root = project_root / "build"
    build_root.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(
        prefix="studio-interactions-", dir=build_root
    ) as directory:
        root = Path(directory)
        workspace = root / "workspace"
        launcher = SynchronousBuildLauncher(workspace, root / "output", make)
        chr_path = project_root / "assets/generated/chr/doraemon.chr"
        prg_path = project_root / "assets/generated/prg/doraemon.prg"
        exercise_level(project_root, workspace, profile, chr_path)
        exercise_graphics(project_root, workspace, profile, launcher)
        exercise_objects(project_root, workspace, profile, launcher)
        exercise_text(project_root, workspace, profile, chr_path, launcher)
        exercise_sound(project_root, workspace, profile, prg_path, launcher)
        expected = tuple(BUILD_OUTPUTS)
        if tuple(launcher.targets) != expected:
            raise WorkstationSmokeError(
                f"Studio build actions differ: {tuple(launcher.targets)}"
            )
    return STUDIO_IDS


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project-root", type=Path, default=PROJECT_ROOT)
    parser.add_argument("--profile", choices=("original", "rev_a"), default="original")
    parser.add_argument("--make", dest="make_executable")
    args = parser.parse_args()
    try:
        studios = run_workstation_smoke(
            args.project_root.resolve(),
            args.profile,
            make_executable=args.make_executable,
        )
    except (OSError, subprocess.SubprocessError, tk.TclError, WorkstationSmokeError) as exc:
        print(f"[ERROR] Studio workstation interaction smoke failed: {exc}")
        return 1
    print(
        f"[OK] {len(studios)} real Studio windows passed save, build, "
        f"preview/play, and unsaved-close interactions for {args.profile}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
