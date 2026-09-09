from __future__ import annotations

from pathlib import Path
import subprocess
import tempfile
from unittest import mock
import unittest

from scripts.authoring import studio_process, workstation_smoke


class StudioProcessTests(unittest.TestCase):
    def test_gui_build_keeps_the_selected_workspace(self) -> None:
        project = Path("C:/project")
        workspace = Path("C:/scratch/workspace")
        with mock.patch.object(studio_process.subprocess, "Popen") as popen:
            studio_process.launch_content_build(
                project,
                "graphics-content-rom",
                "rev_a",
                workspace,
            )
        popen.assert_called_once_with(
            [
                "make",
                "graphics-content-rom",
                "PROFILE=rev_a",
                "CONTENT_WORKSPACE=C:/scratch/workspace",
            ],
            cwd=project,
        )


class WorkstationSmokeTests(unittest.TestCase):
    def test_real_window_matrix_runs_each_supported_studio(self) -> None:
        calls: list[str] = []

        def simple(studio_id: str):
            def exercise(*_args) -> None:
                calls.append(studio_id)

            return exercise

        def build(studio_id: str, target: str):
            def exercise(*args) -> None:
                calls.append(studio_id)
                args[-1].targets.append(target)

            return exercise

        with tempfile.TemporaryDirectory() as directory, mock.patch.object(
            workstation_smoke.sys, "platform", "win32"
        ), mock.patch.object(
            workstation_smoke, "exercise_level", side_effect=simple("level")
        ), mock.patch.object(
            workstation_smoke,
            "exercise_graphics",
            side_effect=build("graphics", "graphics-content-rom"),
        ), mock.patch.object(
            workstation_smoke,
            "exercise_objects",
            side_effect=build("objects", "object-content-rom"),
        ), mock.patch.object(
            workstation_smoke,
            "exercise_text",
            side_effect=build("text", "text-content-rom"),
        ), mock.patch.object(
            workstation_smoke,
            "exercise_sound",
            side_effect=build("sound", "sound-content-rom"),
        ):
            result = workstation_smoke.run_workstation_smoke(
                Path(directory), "original", make_executable="make"
            )
        self.assertEqual(tuple(calls), workstation_smoke.STUDIO_IDS)
        self.assertEqual(result, workstation_smoke.STUDIO_IDS)

    def test_synchronous_build_requires_the_expected_isolated_output(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            workspace = root / "workspace"
            output = root / "output"
            expected = output / "original" / "doraemon-text.nes"
            expected.parent.mkdir(parents=True)
            expected.write_bytes(b"fixture")
            launcher = workstation_smoke.SynchronousBuildLauncher(
                workspace, output, "make"
            )
            completed = subprocess.CompletedProcess([], 0, "built", "")
            with mock.patch.object(
                workstation_smoke.subprocess, "run", return_value=completed
            ) as run:
                launcher(
                    root,
                    "text-content-rom",
                    "original",
                    workspace,
                )
        command = run.call_args.args[0]
        self.assertIn(f"CONTENT_WORKSPACE={workspace.resolve().as_posix()}", command)
        self.assertIn(f"TEXT_CONTENT_OUTPUT={output.resolve().as_posix()}", command)
        self.assertEqual(launcher.targets, ["text-content-rom"])

    def test_workstation_gate_rejects_non_windows_hosts(self) -> None:
        with mock.patch.object(workstation_smoke.sys, "platform", "linux"):
            with self.assertRaisesRegex(
                workstation_smoke.WorkstationSmokeError, "requires Windows"
            ):
                workstation_smoke.run_workstation_smoke(
                    Path("C:/project"), "original", make_executable="make"
                )


if __name__ == "__main__":
    unittest.main()
