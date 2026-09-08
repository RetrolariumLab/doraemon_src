#!/usr/bin/env python3
"""Build-support commands for the Doraemon preservation project."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import shutil
import struct
import subprocess
import sys
import zlib


ROOT = Path(__file__).resolve().parents[2]
PRG_BANK_SIZE = 0x8000
PRG_BANK_COUNT = 4
PRG_DATA_KINDS = {"data", "map", "padding", "table", "text", "vectors"}


class ProjectError(ValueError):
    """A validation error that should be shown without a traceback."""


def load_prg_data_ranges(path: Path) -> list[tuple[str, int, int, int, str]]:
    try:
        lines = path.read_text(encoding="utf-8").splitlines()
    except OSError as exc:
        raise ProjectError(f"cannot read typed PRG ranges {path}: {exc}") from exc
    ranges: list[tuple[str, int, int, int, str]] = []
    previous_end = {bank: 0x7FFF for bank in range(PRG_BANK_COUNT)}
    previous_key = (-1, 0x7FFF)
    for line_number, raw in enumerate(lines, 1):
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        fields = line.split()
        if len(fields) != 5 or fields[0] not in PRG_DATA_KINDS:
            raise ProjectError(f"invalid typed PRG range at {path}:{line_number}")
        try:
            bank = int(fields[1], 10)
            start, end = int(fields[2], 16), int(fields[3], 16)
        except ValueError as exc:
            raise ProjectError(f"invalid typed PRG address at {path}:{line_number}") from exc
        if not 0 <= bank < PRG_BANK_COUNT or not 0x8000 <= start <= end <= 0xFFFF:
            raise ProjectError(f"typed PRG range is out of bounds at {path}:{line_number}")
        if (bank, start) <= previous_key or start <= previous_end[bank]:
            raise ProjectError(
                f"typed PRG ranges overlap or are unsorted at {path}:{line_number}"
            )
        if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", fields[4]):
            raise ProjectError(f"invalid typed PRG range name at {path}:{line_number}")
        ranges.append((fields[0], bank, start, end, fields[4]))
        previous_end[bank] = end
        previous_key = (bank, start)
    if not ranges:
        raise ProjectError(f"typed PRG range registry is empty: {path}")
    return ranges


def load_prg_code_entries(path: Path) -> list[tuple[int, int, str]]:
    try:
        lines = path.read_text(encoding="utf-8").splitlines()
    except OSError as exc:
        raise ProjectError(f"cannot read PRG code entries {path}: {exc}") from exc
    entries: list[tuple[int, int, str]] = []
    previous_key = (-1, 0x7FFF)
    names: set[str] = set()
    for line_number, raw in enumerate(lines, 1):
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        fields = line.split()
        if len(fields) != 4 or fields[0] != "entry":
            raise ProjectError(f"invalid PRG code entry at {path}:{line_number}")
        try:
            bank = int(fields[1], 10)
            address = int(fields[2], 16)
        except ValueError as exc:
            raise ProjectError(f"invalid PRG code address at {path}:{line_number}") from exc
        name = fields[3]
        if not 0 <= bank < PRG_BANK_COUNT or not 0x8000 <= address <= 0xFFFF:
            raise ProjectError(f"PRG code entry is out of bounds at {path}:{line_number}")
        if (bank, address) <= previous_key:
            raise ProjectError(f"PRG code entries are duplicate or unsorted at {path}:{line_number}")
        if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", name) or name.lower() in names:
            raise ProjectError(f"invalid or duplicate PRG code entry name at {path}:{line_number}")
        entries.append((bank, address, name))
        previous_key = (bank, address)
        names.add(name.lower())
    if not entries:
        raise ProjectError(f"PRG code entry registry is empty: {path}")
    return entries


def digest(data: bytes, algorithm: str = "sha1") -> str:
    return hashlib.new(algorithm, data).hexdigest()


def crc32(data: bytes) -> str:
    return f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"


def parse_number(value: object, field: str) -> int:
    if isinstance(value, int):
        return value
    if isinstance(value, str):
        try:
            return int(value, 0)
        except ValueError:
            pass
    raise ProjectError(f"invalid integer for {field}: {value!r}")


def load_manifest(path: Path) -> dict[str, object]:
    try:
        manifest = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ProjectError(f"cannot read manifest {path}: {exc}") from exc
    if manifest.get("schema_version") != 1:
        raise ProjectError("unsupported manifest schema")
    return manifest


def parse_ines(data: bytes) -> dict[str, object]:
    if len(data) < 16 or data[:4] != b"NES\x1a":
        raise ProjectError("image is not an iNES ROM")
    trainer_size = 512 if data[6] & 0x04 else 0
    prg_size = data[4] * 16_384
    chr_size = data[5] * 8_192
    prg_start = 16 + trainer_size
    chr_start = prg_start + prg_size
    expected_size = chr_start + chr_size
    if len(data) != expected_size:
        raise ProjectError(f"image size is {len(data)}, expected exactly {expected_size}")
    return {
        "header": data[:prg_start],
        "prg": data[prg_start:chr_start],
        "chr": data[chr_start:],
        "payload": data[prg_start:],
        "trainer_size": trainer_size,
        "prg_size": prg_size,
        "chr_size": chr_size,
        "mapper": (data[6] >> 4) | (data[7] & 0xF0),
        "mirroring": "vertical" if data[6] & 0x01 else "horizontal",
    }


def image_facts(data: bytes) -> tuple[dict[str, object], dict[str, object]]:
    parsed = parse_ines(data)
    facts: dict[str, object] = {
        "file_size": len(data),
        "file_sha1": digest(data),
        "file_sha256": digest(data, "sha256"),
        "file_md5": digest(data, "md5"),
        "file_crc32": crc32(data),
        "payload_sha1": digest(parsed["payload"]),
        "payload_sha256": digest(parsed["payload"], "sha256"),
        "payload_crc32": crc32(parsed["payload"]),
        "header_size": len(parsed["header"]),
        "header_sha1": digest(parsed["header"]),
        "header_sha256": digest(parsed["header"], "sha256"),
        "header_crc32": crc32(parsed["header"]),
        "prg_size": parsed["prg_size"],
        "prg_sha1": digest(parsed["prg"]),
        "prg_sha256": digest(parsed["prg"], "sha256"),
        "prg_crc32": crc32(parsed["prg"]),
        "chr_size": parsed["chr_size"],
        "chr_sha1": digest(parsed["chr"]),
        "chr_sha256": digest(parsed["chr"], "sha256"),
        "chr_crc32": crc32(parsed["chr"]),
        "trainer_size": parsed["trainer_size"],
        "mapper": parsed["mapper"],
        "mirroring": parsed["mirroring"],
    }
    return parsed, facts


def validate_image(data: bytes, manifest: dict[str, object]) -> dict[str, object]:
    reference = manifest.get("reference_rom")
    if not isinstance(reference, dict):
        raise ProjectError("manifest has no reference_rom object")
    parsed, facts = image_facts(data)
    for field, expected in reference.items():
        if field not in facts:
            continue
        actual = facts[field]
        if isinstance(actual, int):
            expected = parse_number(expected, field)
        elif isinstance(expected, str):
            expected = expected.lower()
        if actual != expected:
            raise ProjectError(f"{field} mismatch: got {actual!r}, expected {expected!r}")
    return parsed


def safe_asset_path(root: Path, relative: str) -> Path:
    posix = PurePosixPath(relative)
    if posix.is_absolute() or not posix.parts or ".." in posix.parts:
        raise ProjectError(f"unsafe asset path: {relative!r}")
    destination = root.joinpath(*posix.parts)
    try:
        destination.resolve().relative_to(root.resolve())
    except ValueError as exc:
        raise ProjectError(f"asset path escapes output directory: {relative!r}") from exc
    return destination


def write_if_changed(path: Path, data: bytes) -> str:
    if path.is_file() and path.read_bytes() == data:
        return "OK"
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(path.name + ".tmp")
    temporary.write_bytes(data)
    os.replace(temporary, path)
    return "WRITE"


def manifest_assets(manifest: dict[str, object]) -> list[dict[str, object]]:
    assets = manifest.get("extracted_assets")
    if not isinstance(assets, list) or not all(isinstance(item, dict) for item in assets):
        raise ProjectError("manifest has no valid extracted_assets list")
    return assets


def validate_asset(payload: bytes, entry: dict[str, object]) -> None:
    label = str(entry.get("region", entry.get("path", "asset")))
    expected_size = parse_number(entry.get("size"), f"{label}.size")
    if len(payload) != expected_size:
        raise ProjectError(f"{label} size mismatch: got {len(payload)}, expected {expected_size}")
    for algorithm in ("sha1", "sha256", "crc32"):
        expected = entry.get(algorithm)
        if expected is None:
            continue
        actual = crc32(payload) if algorithm == "crc32" else digest(payload, algorithm)
        if actual != str(expected).lower():
            raise ProjectError(f"{label} {algorithm} mismatch: got {actual}, expected {expected}")


def command_verify(args: argparse.Namespace) -> None:
    image = Path(args.image)
    if not image.is_file():
        raise ProjectError(f"image not found: {image}")
    validate_image(image.read_bytes(), load_manifest(Path(args.manifest)))
    print(f"[OK] byte-identical Doraemon image: {image}")


def command_inspect(args: argparse.Namespace) -> None:
    image = Path(args.image)
    if not image.is_file():
        raise ProjectError(f"image not found: {image}")
    _parsed, facts = image_facts(image.read_bytes())
    print(json.dumps(facts, indent=2))


def command_banks(args: argparse.Namespace) -> None:
    image = Path(args.image)
    if not image.is_file():
        raise ProjectError(f"image not found: {image}")
    parsed = validate_image(image.read_bytes(), load_manifest(Path(args.manifest)))
    prg = parsed["prg"]
    if len(prg) != PRG_BANK_SIZE * PRG_BANK_COUNT:
        raise ProjectError("baseline is not four 32 KiB PRG banks")
    for bank in range(PRG_BANK_COUNT):
        payload = prg[bank * PRG_BANK_SIZE:(bank + 1) * PRG_BANK_SIZE]
        nmi, reset, irq = struct.unpack_from("<HHH", payload, PRG_BANK_SIZE - 6)
        print(
            f"bank {bank}: crc32={crc32(payload)} "
            f"NMI=${nmi:04X} RESET=${reset:04X} IRQ=${irq:04X}"
        )


def command_split(args: argparse.Namespace) -> None:
    image = Path(args.image)
    if not image.is_file():
        raise ProjectError(f"reference ROM not found: {image}")
    manifest = load_manifest(Path(args.manifest))
    parsed = validate_image(image.read_bytes(), manifest)
    output_root = Path(args.output_dir)
    for entry in manifest_assets(manifest):
        region = str(entry.get("region", ""))
        if region not in ("header", "prg", "chr"):
            raise ProjectError(f"unsupported asset region: {region!r}")
        payload = parsed[region]
        validate_asset(payload, entry)
        destination = safe_asset_path(output_root, str(entry.get("path", "")))
        action = write_if_changed(destination, payload)
        print(f"[{action}] {destination} ({len(payload)} bytes)")


def command_mkdir(args: argparse.Namespace) -> None:
    Path(args.path).mkdir(parents=True, exist_ok=True)


def command_require(args: argparse.Namespace) -> None:
    if not Path(args.path).is_file():
        raise ProjectError(f"required generated asset not found: {args.path}; {args.hint}")


def command_clean(args: argparse.Namespace) -> None:
    target = Path(args.path).resolve()
    build_root = (ROOT / "build").resolve()
    if target != build_root and build_root not in target.parents:
        raise ProjectError(f"refusing to clean outside {build_root}: {target}")
    if target.exists():
        shutil.rmtree(target)
        print(f"[CLEAN] {target}")


def validate_tool_layout(root: Path) -> None:
    scripts_root = root / "scripts"
    expected_root_files = {"__init__.py", "run.py"}
    actual_root_files = {path.name for path in scripts_root.glob("*.py")}
    if actual_root_files != expected_root_files:
        raise ProjectError(
            "scripts root must contain only package metadata and run.py: "
            + ", ".join(sorted(actual_root_files))
        )
    package_dirs = {
        scripts_root,
        *(path.parent for path in scripts_root.rglob("*.py")),
    }
    missing_markers = sorted(
        path.relative_to(root).as_posix()
        for path in package_dirs
        if "__pycache__" not in path.parts and not (path / "__init__.py").is_file()
    )
    if missing_markers:
        raise ProjectError(
            "Python tool directories lack __init__.py: "
            + ", ".join(missing_markers)
        )


def validate_test_layout(root: Path) -> None:
    tests_root = root / "tests"
    expected_root_tests = {"test_script_runner.py"}
    actual_root_tests = {path.name for path in tests_root.glob("test_*.py")}
    if actual_root_tests != expected_root_tests:
        raise ProjectError(
            "tests root must contain only the script-runner contract: "
            + ", ".join(sorted(actual_root_tests))
        )

    package_dirs = {
        tests_root,
        *(path.parent for path in tests_root.rglob("*.py")),
    }
    missing_markers = sorted(
        path.relative_to(root).as_posix()
        for path in package_dirs
        if "__pycache__" not in path.parts and not (path / "__init__.py").is_file()
    )
    if missing_markers:
        raise ProjectError(
            "Python test directories lack __init__.py: "
            + ", ".join(missing_markers)
        )

    tools_by_stem: dict[str, list[Path]] = {}
    for tool in (root / "scripts").rglob("*.py"):
        if tool.name in {"__init__.py", "run.py"} or "__pycache__" in tool.parts:
            continue
        tools_by_stem.setdefault(tool.stem, []).append(tool.parent.relative_to(root / "scripts"))

    special_locations = {
        "test_debugger_runtime.py": Path("runtime"),
        "test_runtime_scenarios.py": Path("runtime"),
        "test_disassembly.py": Path("workflow"),
        "test_source_2_contract.py": Path("validation/release"),
    }
    mismatches: list[str] = []
    for test in tests_root.rglob("test_*.py"):
        if test.parent == tests_root:
            continue
        expected = special_locations.get(test.name)
        if expected is None:
            stem = test.stem.removeprefix("test_")
            candidates = tools_by_stem.get(stem, [])
            if len(candidates) != 1:
                mismatches.append(
                    f"{test.relative_to(root).as_posix()} has {len(candidates)} matching tools"
                )
                continue
            expected = candidates[0]
        actual = test.parent.relative_to(tests_root)
        if actual != expected:
            mismatches.append(
                f"{test.relative_to(root).as_posix()} should be under tests/{expected.as_posix()}"
            )
    if mismatches:
        raise ProjectError("test layout does not mirror scripts: " + "; ".join(mismatches))


def command_lint(_args: argparse.Namespace) -> None:
    required = (
        "README.md", "Makefile", "assets/manifest.json", "config/linker/gnrom.cfg",
        "config/reconstruction/symbols.json",
        "config/reconstruction/prg_data_ranges.txt",
        "config/reconstruction/prg_code_entries.txt",
        "config/reconstruction/source_modules.json",
        "config/reconstruction/source_classification.json",
        "docs/source_classification.md", "docs/verification.md",
        "tools/disassembly.lock.json", "src/main.asm", "scripts/run.py",
        "scripts/validation/asm_style.py", "scripts/build/verify_rom.py",
        "scripts/validation/format_project.py",
        "scripts/workflow/generate_disassembly.py",
        "scripts/workflow/run_ghidra.py", "scripts/validation/map_data.py",
        "tools/ghidra_scripts/ClearKnownData.java", "tools/ghidra_scripts/ApplyKnownCode.java",
    )
    missing = [name for name in required if not (ROOT / name).is_file()]
    if missing:
        raise ProjectError("missing project files: " + ", ".join(missing))
    validate_tool_layout(ROOT)
    validate_test_layout(ROOT)
    manifest = load_manifest(ROOT / "assets/manifest.json")
    reference = manifest.get("reference_rom")
    if not isinstance(reference, dict) or reference.get("mapper") != 66:
        raise ProjectError("manifest does not describe mapper 66")
    load_prg_data_ranges(ROOT / "config/reconstruction/prg_data_ranges.txt")
    load_prg_code_entries(ROOT / "config/reconstruction/prg_code_entries.txt")
    symbols = json.loads(
        (ROOT / "config/reconstruction/symbols.json").read_text(encoding="utf-8")
    )
    if symbols.get("schema_version") != 1 or not symbols.get("symbols"):
        raise ProjectError("invalid or empty symbol registry")
    module_document = json.loads(
        (ROOT / "config/reconstruction/source_modules.json").read_text(encoding="utf-8")
    )
    if module_document.get("schema_version") != 1:
        raise ProjectError("invalid source module registry")
    modules_by_bank: dict[int, list[Path]] = {}
    for module in module_document.get("modules", []):
        path = ROOT / "src" / str(module["path"])
        modules_by_bank.setdefault(int(module["bank"]), []).append(path)
    for bank in range(PRG_BANK_COUNT):
        relative = f"src/banks/bank_{bank}.asm"
        source = (ROOT / relative).read_text(encoding="utf-8")
        semantic_source = "\n".join(
            path.read_text(encoding="utf-8") for path in modules_by_bank.get(bank, [])
        )
        complete_source = source + "\n" + semantic_source
        for marker in (f'.segment "PRG{bank}"', f"Bank{bank}_Reset:", f"Bank{bank}_Nmi:"):
            if marker not in complete_source:
                raise ProjectError(f"{relative} is missing required marker: {marker}")
        if ".incbin" in complete_source.lower():
            raise ProjectError(f"{relative} must not contain .incbin")
    try:
        tracked = subprocess.run(
            ["git", "ls-files", "*.nes", "*.chr", "*.hdr", "*.prg", "*.o", "tools/ghidra/**"],
            cwd=ROOT, check=True, capture_output=True, text=True,
        ).stdout.splitlines()
    except (OSError, subprocess.CalledProcessError) as exc:
        raise ProjectError(f"cannot inspect tracked binary files: {exc}") from exc
    if tracked:
        raise ProjectError("ROM/build binaries must not be tracked: " + ", ".join(tracked))
    print("[OK] project structure, GNROM source contract, and binary policy")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    for name, handler in (("verify", command_verify), ("banks", command_banks)):
        command = subparsers.add_parser(name)
        command.add_argument("--image", required=True)
        command.add_argument("--manifest", required=True)
        command.set_defaults(handler=handler)
    inspect = subparsers.add_parser("inspect")
    inspect.add_argument("--image", required=True)
    inspect.set_defaults(handler=command_inspect)
    split = subparsers.add_parser("split")
    split.add_argument("--image", required=True)
    split.add_argument("--manifest", required=True)
    split.add_argument("--output-dir", required=True)
    split.set_defaults(handler=command_split)
    mkdir = subparsers.add_parser("mkdir")
    mkdir.add_argument("--path", required=True)
    mkdir.set_defaults(handler=command_mkdir)
    require = subparsers.add_parser("require")
    require.add_argument("--path", required=True)
    require.add_argument("--hint", required=True)
    require.set_defaults(handler=command_require)
    clean = subparsers.add_parser("clean")
    clean.add_argument("--path", required=True)
    clean.set_defaults(handler=command_clean)
    lint = subparsers.add_parser("lint")
    lint.set_defaults(handler=command_lint)
    return parser


def main() -> int:
    args = build_parser().parse_args()
    try:
        args.handler(args)
    except (OSError, ProjectError, json.JSONDecodeError) as exc:
        print(f"[ERROR] {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
