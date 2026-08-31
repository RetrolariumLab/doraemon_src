#!/usr/bin/env python3
"""Run deterministic Doraemon runtime scenarios in the FCEUX automation fork."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import subprocess
from pathlib import Path
from typing import Any


def sha1(path: Path) -> str:
    digest = hashlib.sha1()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def encode_inputs(inputs: list[dict[str, Any]]) -> str:
    encoded: list[str] = []
    for action in inputs:
        first = int(action["first_frame"])
        last = int(action["last_frame"])
        buttons = "+".join(str(button) for button in action["buttons"])
        if first < 0 or last < first or not buttons:
            raise ValueError(f"invalid runtime input action: {action}")
        encoded.append(f"{first}-{last}:{buttons}")
    return ";".join(encoded)


def encode_memory_patches(patches: list[dict[str, Any]]) -> str:
    encoded: list[str] = []
    for patch in patches:
        frame = int(patch["frame"])
        address = int(str(patch["address"]), 0)
        value = int(str(patch["value"]), 0)
        name = str(patch["name"])
        if frame < 0 or not 0 <= address <= 0x07FF or not 0 <= value <= 0xFF:
            raise ValueError(f"invalid runtime memory patch: {patch}")
        if not name or ";" in name or ":" in name:
            raise ValueError(f"invalid runtime memory patch name: {patch}")
        encoded.append(f"{frame}:{address:04X}:{value:02X}:{name}")
    return ";".join(encoded)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--fceux", required=True, type=Path)
    parser.add_argument("--rom", required=True, type=Path)
    parser.add_argument("--lua", required=True, type=Path)
    parser.add_argument("--scenarios", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    parser.add_argument("--screenshot-dir", type=Path)
    parser.add_argument("--scenario", action="append", dest="selected")
    args = parser.parse_args()

    required = (args.fceux, args.rom, args.lua, args.scenarios)
    missing = [str(path) for path in required if not path.is_file()]
    if missing:
        raise SystemExit(f"[FAIL] Missing runtime input: {', '.join(missing)}")
    document = json.loads(args.scenarios.read_text(encoding="utf-8"))
    actual_sha1 = sha1(args.rom)
    if actual_sha1 != document["rom_sha1"]:
        raise SystemExit(
            f"[FAIL] ROM SHA-1 mismatch: expected={document['rom_sha1']}, "
            f"actual={actual_sha1}"
        )

    configured = {scenario["id"] for scenario in document["scenarios"]}
    selected = set(args.selected or configured)
    unknown = selected - configured
    if unknown:
        raise SystemExit(f"[FAIL] Unknown runtime scenario: {', '.join(sorted(unknown))}")
    args.output_dir.mkdir(parents=True, exist_ok=True)
    if args.screenshot_dir is not None:
        args.screenshot_dir.mkdir(parents=True, exist_ok=True)

    for scenario in document["scenarios"]:
        scenario_id = scenario["id"]
        if scenario_id not in selected:
            continue
        output = args.output_dir / f"{scenario_id}.csv"
        output.unlink(missing_ok=True)
        environment = os.environ.copy()
        environment.update(
            DORAEMON_RUNTIME_TRACE=str(output.resolve()).replace("\\", "/"),
            DORAEMON_RUNTIME_SCENARIO=scenario_id,
            DORAEMON_RUNTIME_MAX_FRAMES=str(scenario["max_frames"]),
            DORAEMON_RUNTIME_INPUTS=encode_inputs(scenario.get("inputs", [])),
            DORAEMON_RUNTIME_MEMORY_PATCHES=encode_memory_patches(
                scenario.get("memory_patches", [])
            ),
        )
        if args.screenshot_dir is not None:
            screenshot = args.screenshot_dir / f"{scenario_id}.png"
            screenshot.unlink(missing_ok=True)
            environment["DORAEMON_RUNTIME_SCREENSHOT"] = str(
                screenshot.resolve()
            ).replace("\\", "/")
        command = [
            str(args.fceux.resolve()),
            "-lua",
            str(args.lua.resolve()),
            "-max-frames",
            str(int(scenario["max_frames"]) + 2),
            "-turbo",
            "1",
            "-nothrottle",
            "1",
            str(args.rom.resolve()),
        ]
        print(f"[RUN] {scenario_id}: {scenario['method']}", flush=True)
        subprocess.run(command, check=True, env=environment)
        if not output.is_file() or output.stat().st_size == 0:
            raise SystemExit(f"[FAIL] Runtime trace was not created: {output}")
        print(f"[OK] Runtime trace: {output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
