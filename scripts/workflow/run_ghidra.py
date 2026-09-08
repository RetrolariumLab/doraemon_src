#!/usr/bin/env python3
"""Run pinned Ghidra analysis for the four switchable Doraemon PRG banks."""

from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile

from scripts.build import project


ROOT = Path(__file__).resolve().parents[2]
RECONSTRUCTION_CONFIG = ROOT / "config" / "reconstruction"
DEFAULT_HEADLESS = ROOT / "tools" / "ghidra" / "support" / "analyzeHeadless.bat"
HEADLESS = Path(os.environ.get("GHIDRA_HEADLESS", DEFAULT_HEADLESS))
SCRIPT_DIR = ROOT / "tools" / "ghidra_scripts"
WORK_DIR = ROOT / "build" / "ghidra"
PRG_BANK_SIZE = 0x8000
PRG_BANK_COUNT = 4


class PipelineError(ValueError):
    pass


def validated_prg(image: Path) -> bytes:
    if not image.is_file():
        raise PipelineError(f"reference ROM not found: {image}")
    manifest = project.load_manifest(ROOT / "assets" / "manifest.json")
    parsed = project.validate_image(image.read_bytes(), manifest)
    prg = parsed["prg"]
    if len(prg) != PRG_BANK_SIZE * PRG_BANK_COUNT:
        raise PipelineError("expected four 32 KiB PRG banks")
    return prg


def run_headless(
    project_name: str, image: Path, scripts: list[tuple[str, list[str]]], log: Path
) -> None:
    if not HEADLESS.is_file():
        raise PipelineError(
            "local Ghidra is missing; run make ghidra-bootstrap or set GHIDRA_HEADLESS"
        )
    WORK_DIR.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix=f"{project_name}_", dir=WORK_DIR) as projects:
        command = [
            str(HEADLESS), projects, project_name,
            "-import", str(image.resolve()), "-overwrite",
            "-analysisTimeoutPerFile", "600",
            "-scriptPath", str(SCRIPT_DIR.resolve()),
        ]
        for script, arguments in scripts:
            command.extend(("-postScript", script, *arguments))
        command.append("-deleteProject")
        result = subprocess.run(
            command, cwd=ROOT, capture_output=True, text=True, errors="replace"
        )
    log.parent.mkdir(parents=True, exist_ok=True)
    log.write_text(result.stdout + result.stderr, encoding="utf-8", newline="\n")
    for line in (result.stdout + result.stderr).splitlines():
        if "[OK]" in line:
            print(line.strip())
    if result.returncode:
        tail = (result.stdout + result.stderr).splitlines()[-80:]
        print("\n".join(tail))
        raise PipelineError(f"Ghidra headless analysis failed with {result.returncode}")


def stage_bank_inputs(image: Path) -> list[Path]:
    prg = validated_prg(image)
    input_dir = WORK_DIR / "input"
    input_dir.mkdir(parents=True, exist_ok=True)
    nrom_header = b"NES\x1a" + bytes((2, 0, 0, 0)) + bytes(8)
    paths: list[Path] = []
    for bank in range(PRG_BANK_COUNT):
        path = input_dir / f"bank_{bank}.nes"
        payload = prg[bank * PRG_BANK_SIZE:(bank + 1) * PRG_BANK_SIZE]
        project.write_if_changed(path, nrom_header + payload)
        paths.append(path)
    return paths


def stage_data_ranges() -> list[Path]:
    ranges = project.load_prg_data_ranges(RECONSTRUCTION_CONFIG / "prg_data_ranges.txt")
    range_dir = WORK_DIR / "ranges"
    range_dir.mkdir(parents=True, exist_ok=True)
    paths: list[Path] = []
    for bank in range(PRG_BANK_COUNT):
        lines = ["# kind start end name"]
        for kind, item_bank, start, end, name in ranges:
            if item_bank == bank:
                lines.append(f"{kind} {start:04X} {end:04X} {name}")
        path = range_dir / f"bank_{bank}.txt"
        path.write_text("\n".join(lines) + "\n", encoding="utf-8", newline="\n")
        paths.append(path)
    return paths


def stage_code_entries() -> list[Path]:
    entries = project.load_prg_code_entries(
        RECONSTRUCTION_CONFIG / "prg_code_entries.txt"
    )
    entry_dir = WORK_DIR / "entries"
    entry_dir.mkdir(parents=True, exist_ok=True)
    paths: list[Path] = []
    for bank in range(PRG_BANK_COUNT):
        lines = ["# address name"]
        for item_bank, address, name in entries:
            if item_bank == bank:
                lines.append(f"{address:04X} {name}")
        path = entry_dir / f"bank_{bank}.txt"
        path.write_text("\n".join(lines) + "\n", encoding="utf-8", newline="\n")
        paths.append(path)
    return paths


def command_inspect(args: argparse.Namespace) -> None:
    image = Path(args.image)
    validated_prg(image)
    input_dir = WORK_DIR / "input"
    input_dir.mkdir(parents=True, exist_ok=True)
    staged = input_dir / "doraemon.nes"
    project.write_if_changed(staged, image.read_bytes())
    output = Path(args.output).resolve()
    run_headless(
        "doraemon_inspect", staged,
        [("InspectNesProgram.java", [str(output)])],
        WORK_DIR / "inspect.log",
    )
    try:
        report = json.loads(output.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise PipelineError(f"cannot read Ghidra report {output}: {exc}") from exc
    print(
        f"[OK] {report['language']}: {report['instruction_count']} instructions, "
        f"{len(report['functions'])} functions, {len(report['blocks'])} memory blocks"
    )


def command_export_facts(args: argparse.Namespace) -> None:
    images = stage_bank_inputs(Path(args.image))
    ranges = stage_data_ranges()
    entries = stage_code_entries()
    output_dir = Path(args.output_dir).resolve()
    output_dir.mkdir(parents=True, exist_ok=True)
    for bank in range(PRG_BANK_COUNT):
        output = output_dir / f"bank_{bank}.tsv"
        run_headless(
            f"doraemon_bank_{bank}", images[bank],
            [
                ("ApplyKnownCode.java", [str(entries[bank].resolve())]),
                ("ClearKnownData.java", [str(ranges[bank].resolve())]),
                ("ExportInstructionFacts.java", [str(output)]),
            ],
            WORK_DIR / f"bank_{bank}.log",
        )
        if not output.is_file():
            raise PipelineError(f"Ghidra facts file was not created: {output}")
        count = max(0, len(output.read_text(encoding="utf-8").splitlines()) - 1)
        print(f"[OK] bank {bank}: exported {count} analyzed instructions")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    inspect = subparsers.add_parser("inspect")
    inspect.add_argument("--image", required=True)
    inspect.add_argument("--output", default="build/ghidra/program.json")
    inspect.set_defaults(handler=command_inspect)
    facts = subparsers.add_parser("export-facts")
    facts.add_argument("--image", required=True)
    facts.add_argument("--output-dir", default="build/ghidra/facts")
    facts.set_defaults(handler=command_export_facts)
    args = parser.parse_args()
    try:
        args.handler(args)
    except (OSError, PipelineError, project.ProjectError) as exc:
        print(f"[ERROR] {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
