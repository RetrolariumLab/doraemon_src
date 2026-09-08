#!/usr/bin/env python3
"""Exercise one native preview request in every Doraemon audio bank."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import subprocess
import tempfile

from scripts.authoring.sound_preview import preview_command, preview_environment, selected_track


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--fceux", required=True, type=Path)
    parser.add_argument("--rom", required=True, type=Path)
    parser.add_argument("--lua", required=True, type=Path)
    parser.add_argument("--music", required=True, type=Path)
    parser.add_argument("--timeout-seconds", default=30.0, type=float)
    args = parser.parse_args()
    try:
        document = json.loads(args.music.read_text(encoding="utf-8"))
        command = preview_command(args.fceux, args.lua, args.rom)
        with tempfile.TemporaryDirectory(prefix="doraemon-sound-preview-") as root:
            directory = Path(root)
            for driver_index, _driver in enumerate(document["drivers"]):
                track = selected_track(document, driver_index, 0)
                result_path = directory / f"bank-{track.bank}.txt"
                environment = preview_environment(track)
                environment["DORAEMON_SOUND_PREVIEW_MAX_FRAMES"] = "1100"
                environment["DORAEMON_SOUND_PREVIEW_RESULT"] = str(
                    result_path.resolve()
                ).replace("\\", "/")
                print(f"[RUN] Native preview for {track.description}", flush=True)
                subprocess.run(
                    [
                        *command[:-1],
                        "-max-frames",
                        "1102",
                        "-turbo",
                        "1",
                        "-nothrottle",
                        "1",
                        command[-1],
                    ],
                    check=True,
                    cwd=args.rom.resolve().parent,
                    env=environment,
                    stdout=subprocess.DEVNULL,
                    stderr=subprocess.DEVNULL,
                    timeout=args.timeout_seconds,
                )
                expected = f"bank={track.bank},track={track.track_id},"
                if not result_path.is_file() or not result_path.read_text(
                    encoding="utf-8"
                ).startswith(expected):
                    raise ValueError(
                        f"native preview did not inject {track.description}"
                    )
                print(f"[OK] Native preview reached {track.description}")
    except (
        OSError,
        ValueError,
        KeyError,
        TypeError,
        json.JSONDecodeError,
        subprocess.SubprocessError,
    ) as exc:
        print(f"[ERROR] sound preview validation failed: {exc}")
        return 1
    print("[OK] All four native audio-bank previews reached their selected track")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
