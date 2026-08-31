#!/usr/bin/env python3
"""Audit the active Doraemon Source Reconstruction 1.0 contract."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
from pathlib import Path
from typing import Any


EXPECTED_MILESTONES = [
    "preservation_baseline",
    "reconstruction_contract",
    "runtime_architecture",
    "chapter_execution_evidence",
    "semantic_source_layout",
    "ram_and_object_systems",
    "world_data_formats",
    "rendering_graphics_text",
    "audio",
    "authoring_roundtrips",
    "relocation_proof",
    "source_reconstruction_1_0",
]
VALID_STATES = {"planned", "in-progress", "complete"}


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def git_output(project_root: Path, *arguments: str) -> str:
    result = subprocess.run(
        ["git", *arguments],
        cwd=project_root,
        check=True,
        capture_output=True,
        text=True,
        encoding="utf-8",
    )
    return result.stdout.strip()


def validate_milestones(
    milestones: list[dict[str, Any]], status: str
) -> list[str]:
    identifiers = [item.get("id") for item in milestones]
    if identifiers != EXPECTED_MILESTONES:
        return ["milestone order or identity differs from the reconstruction contract"]

    states = [item.get("status") for item in milestones]
    if any(state not in VALID_STATES for state in states):
        return ["milestone status is invalid"]
    if status == "tag-ready":
        if any(state != "complete" for state in states):
            return ["tag-ready reconstruction has incomplete milestones"]
        return []

    errors: list[str] = []
    active = states.count("in-progress")
    if active != 1:
        errors.append("development reconstruction requires exactly one active milestone")
    first_open = next((state for state in states if state != "complete"), None)
    if first_open != "in-progress":
        errors.append("first open milestone is not active")
    seen_open = False
    for state in states:
        if state == "complete" and seen_open:
            errors.append("completed milestone follows an open milestone")
            break
        if state != "complete":
            seen_open = True
    return errors


def make_targets(text: str) -> set[str]:
    targets: set[str] = set()
    for match in re.finditer(r"^([A-Za-z0-9_.-]+)\s*:(?![=])", text, re.MULTILINE):
        targets.add(match.group(1))
    return targets


def safe_project_path(project_root: Path, relative: str) -> Path | None:
    if not relative or Path(relative).is_absolute():
        return None
    resolved_root = project_root.resolve()
    resolved = (project_root / relative).resolve()
    if resolved != resolved_root and resolved_root not in resolved.parents:
        return None
    return resolved


def validate_paths(
    project_root: Path, paths: list[str], description: str
) -> list[str]:
    errors: list[str] = []
    for relative in paths:
        path = safe_project_path(project_root, relative)
        if path is None:
            errors.append(f"unsafe {description} path: {relative}")
        elif not path.is_file():
            errors.append(f"missing {description}: {relative}")
    return errors


def validate_contract_shape(document: dict[str, Any]) -> list[str]:
    errors: list[str] = []
    source = document.get("source_contract", {})
    if source.get("maximum_module_lines") != 700:
        errors.append("semantic module line limit must remain 700")
    if source.get("executable_incbin") is not False:
        errors.append("executable incbin must remain forbidden")
    if source.get("physical_bank_names_are_boundaries_not_semantics") is not True:
        errors.append("physical bank boundaries must not be claimed as semantics")
    if source.get("required_semantic_areas") != [
        "common",
        "world1",
        "world2",
        "world3",
        "audio",
        "data",
    ]:
        errors.append("semantic source areas differ")

    runtime = document.get("runtime_contract", {})
    if runtime.get("required_scenarios") != [
        "boot-title",
        "world1-city",
        "world1-underground",
        "world2-cave",
        "world3-underwater",
        "chapter-transition",
        "ending-credits",
    ]:
        errors.append("required runtime scenarios differ")

    authoring = document.get("authoring_contract", {})
    if authoring.get("lossless_roundtrip_required") is not True:
        errors.append("authoring formats must require lossless round trips")
    if authoring.get("required_formats") != [
        "maps",
        "metatiles",
        "objects",
        "collisions",
        "graphics",
        "palettes",
        "text",
        "audio",
    ]:
        errors.append("required authoring formats differ")
    return errors


def validate_runtime_manifest(
    project_root: Path, contract: dict[str, Any], release_status: str
) -> list[str]:
    relative = contract.get("scenario_manifest", "")
    path = safe_project_path(project_root, relative)
    if path is None or not path.is_file():
        return [f"missing runtime scenario manifest: {relative}"]
    document = load_json(path)
    if document.get("schema_version") != 1:
        return ["runtime scenario manifest is not schema 1"]
    identifiers = [scenario.get("id") for scenario in document.get("scenarios", [])]
    required = contract.get("required_scenarios", [])
    if len(identifiers) != len(set(identifiers)):
        return ["runtime scenario identifiers are not unique"]
    if any(identifier not in required for identifier in identifiers):
        return ["runtime scenario is outside the reconstruction contract"]
    if release_status == "tag-ready" and identifiers != required:
        return ["tag-ready reconstruction lacks required runtime scenarios"]
    expected_status = "complete" if identifiers == required else "development"
    if document.get("status") != expected_status:
        return [f"runtime scenario manifest status must be {expected_status}"]
    return []


def validate_reconstruction(
    project_root: Path,
    manifest_path: Path,
    require_ready: bool = False,
) -> list[str]:
    document = load_json(manifest_path)
    errors: list[str] = []
    status = document.get("status")
    if document.get("schema_version") != 1:
        errors.append("reconstruction manifest is not schema 1")
    if document.get("release") != "Source Reconstruction 1.0":
        errors.append("reconstruction release identity differs")
    if status not in {"development", "tag-ready"}:
        errors.append("reconstruction status is invalid")
        return errors
    if require_ready and status != "tag-ready":
        errors.append("reconstruction manifest is not tag-ready")
    if document.get("tag") != "source-reconstruction-1.0":
        errors.append("reconstruction tag identity differs")

    milestones = document.get("milestones", [])
    if not isinstance(milestones, list):
        errors.append("milestones are not a list")
        return errors
    errors.extend(validate_milestones(milestones, status))
    errors.extend(validate_contract_shape(document))
    errors.extend(
        validate_runtime_manifest(project_root, document["runtime_contract"], status)
    )

    baseline = document.get("preservation_baseline", {})
    commit = baseline.get("commit", "")
    try:
        actual = git_output(project_root, "rev-parse", baseline.get("branch", ""))
    except (subprocess.CalledProcessError, OSError):
        errors.append("preservation baseline branch cannot be resolved")
    else:
        if actual != commit:
            errors.append("preservation baseline branch moved from its recorded commit")
    errors.extend(
        validate_paths(
            project_root,
            [baseline.get("manifest", "")],
            "preservation evidence",
        )
    )

    declared_evidence: list[str] = []
    for milestone in milestones:
        evidence = milestone.get("evidence", [])
        if not isinstance(evidence, list):
            errors.append(f"milestone evidence is not a list: {milestone.get('id')}")
            continue
        if milestone.get("status") == "complete" and not evidence:
            errors.append(f"complete milestone has no evidence: {milestone.get('id')}")
        declared_evidence.extend(evidence)
    errors.extend(validate_paths(project_root, declared_evidence, "milestone evidence"))
    errors.extend(
        validate_paths(
            project_root,
            document.get("required_documents", []),
            "required document",
        )
    )

    makefile = (project_root / "Makefile").read_text(encoding="utf-8")
    available_targets = make_targets(makefile)
    required_targets = document.get("required_targets", [])
    verification_target = baseline.get("verification_target", "")
    for target in [verification_target, *required_targets]:
        if target not in available_targets:
            errors.append(f"missing Make target: {target}")
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--manifest",
        type=Path,
        default=Path("config/source_reconstruction.json"),
    )
    parser.add_argument("--require-ready", action="store_true")
    args = parser.parse_args()
    project_root = Path(__file__).resolve().parent.parent
    manifest_path = args.manifest
    if not manifest_path.is_absolute():
        manifest_path = project_root / manifest_path
    try:
        errors = validate_reconstruction(
            project_root, manifest_path, require_ready=args.require_ready
        )
    except (OSError, json.JSONDecodeError, subprocess.SubprocessError) as exc:
        print(f"[ERROR] reconstruction audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    readiness = "tag-ready" if args.require_ready else "development"
    print(f"[OK] Source Reconstruction 1.0 {readiness} contract is consistent")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
