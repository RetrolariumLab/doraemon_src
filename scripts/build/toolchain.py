#!/usr/bin/env python3
"""Verify release tool binaries before they are used."""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]


class ToolchainError(ValueError):
    """A pinned toolchain component is absent or differs from its contract."""


def load_manifest(path: Path) -> dict[str, Any]:
    document = json.loads(path.read_text(encoding="utf-8"))
    if document.get("schema_version") != 1:
        raise ToolchainError("unsupported toolchain manifest schema")
    components = document.get("components")
    if not isinstance(components, list) or not components:
        raise ToolchainError("toolchain manifest has no components")
    identifiers = [component.get("id") for component in components]
    if len(identifiers) != len(set(identifiers)):
        raise ToolchainError("toolchain component IDs are not unique")
    return document


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def resolve_component_path(
    root: Path, component: dict[str, Any], override: Path | None = None
) -> Path:
    path = override if override is not None else Path(str(component["path"]))
    return path if path.is_absolute() else root / path


def verify_component(
    root: Path, component: dict[str, Any], override: Path | None = None
) -> Path:
    identifier = str(component["id"])
    path = resolve_component_path(root, component, override)
    if not path.is_file():
        raise ToolchainError(f"{identifier} binary is missing: {path}")
    expected_size = int(component["size"])
    if path.stat().st_size != expected_size:
        raise ToolchainError(
            f"{identifier} size mismatch: {path.stat().st_size} != {expected_size}"
        )
    actual_sha256 = sha256(path)
    expected_sha256 = str(component["binary_sha256"]).lower()
    if actual_sha256 != expected_sha256:
        raise ToolchainError(
            f"{identifier} SHA-256 mismatch: {actual_sha256} != {expected_sha256}"
        )
    arguments = component.get("version_arguments")
    expected_output = component.get("version_output_contains")
    if arguments is not None or expected_output is not None:
        if not isinstance(arguments, list) or not expected_output:
            raise ToolchainError(f"{identifier} version contract is incomplete")
        result = subprocess.run(
            [str(path), *(str(argument) for argument in arguments)],
            check=True,
            capture_output=True,
            text=True,
            encoding="utf-8",
        )
        output = result.stdout + result.stderr
        if str(expected_output) not in output:
            raise ToolchainError(f"{identifier} version output differs: {output.strip()}")
    return path


def component_map(document: dict[str, Any]) -> dict[str, dict[str, Any]]:
    return {str(component["id"]): component for component in document["components"]}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--manifest", type=Path, default=Path("config/toolchain.json")
    )
    parser.add_argument("--component", action="append", required=True)
    parser.add_argument("--fceux", type=Path)
    args = parser.parse_args()
    manifest_path = args.manifest
    if not manifest_path.is_absolute():
        manifest_path = ROOT / manifest_path
    try:
        document = load_manifest(manifest_path)
        components = component_map(document)
        for identifier in args.component:
            if identifier not in components:
                raise ToolchainError(f"unknown toolchain component: {identifier}")
            override = args.fceux if identifier == "fceux" else None
            path = verify_component(ROOT, components[identifier], override)
            print(f"[OK] {identifier}: {path}")
    except (OSError, KeyError, ValueError, subprocess.SubprocessError) as exc:
        print(f"[FAIL] toolchain verification failed: {exc}")
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
