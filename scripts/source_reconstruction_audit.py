#!/usr/bin/env python3
"""Audit the active Doraemon Source Reconstruction 1.0 contract."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path
from typing import Any

sys.path.insert(0, str(Path(__file__).resolve().parent))
import release_contract


EXPECTED_MILESTONES = [
    "preservation_baseline",
    "reconstruction_contract",
    "runtime_architecture",
    "chapter_execution_evidence",
    "semantic_source_layout",
    "semantic_naming",
    "ram_and_object_systems",
    "world_data_formats",
    "rendering_graphics_text",
    "audio",
    "authoring_roundtrips",
    "source_reconstruction_1_0",
]
VALID_STATES = {"planned", "partial", "complete"}


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
    if status in {"tag-ready", "tagged"}:
        if any(state != "complete" for state in states):
            return ["tag-ready reconstruction has incomplete milestones"]
        return []

    return []


def make_targets(text: str) -> set[str]:
    targets: set[str] = set()
    for match in re.finditer(r"^([^\s:#=][^:#=]*)\s*:(?![=])", text, re.MULTILINE):
        for target in match.group(1).split():
            if re.fullmatch(r"[A-Za-z0-9_.-]+", target):
                targets.add(target)
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


def validate_preservation_baseline(
    project_root: Path, baseline: dict[str, Any]
) -> list[str]:
    commit = str(baseline.get("commit", ""))
    if baseline.get("reachability") != "ancestor-of-release":
        return ["preservation baseline reachability policy differs"]
    if not re.fullmatch(r"[0-9a-f]{40}", commit):
        return ["preservation baseline commit is not a full object ID"]

    try:
        resolved = git_output(
            project_root, "rev-parse", "--verify", f"{commit}^{{commit}}"
        )
    except (subprocess.CalledProcessError, OSError):
        return ["preservation baseline commit cannot be resolved"]
    if resolved != commit:
        return ["preservation baseline commit resolves to another object"]

    try:
        git_output(project_root, "merge-base", "--is-ancestor", commit, "HEAD")
    except (subprocess.CalledProcessError, OSError):
        return ["preservation baseline is not an ancestor of the release"]
    return []


def validate_contract_shape(document: dict[str, Any]) -> list[str]:
    errors: list[str] = []
    target = document.get("target_rom", {})
    if target != {
        "title": "Doraemon (Japan, original revision)",
        "profile": "PRG0",
        "payload_crc32": "BDE3AE9B",
        "prg_crc32": "B00ABE1C",
        "chr_crc32": "761F994E",
        "multiple_revisions_required": False,
        "regional_profiles_required": False,
    }:
        errors.append("Source Reconstruction 1.0 target ROM scope differs")

    source = document.get("source_contract", {})
    if source.get("module_manifest") != "config/source_modules.json":
        errors.append("semantic module manifest path differs")
    if source.get("runtime_state_coverage_manifest") != (
        "config/runtime_state_coverage.json"
    ):
        errors.append("runtime-state coverage manifest path differs")
    if source.get("classification_manifest") != (
        "config/source_classification.json"
    ):
        errors.append("source classification manifest path differs")
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
        "world2-terminal-screen",
        "world3-underwater",
        "chapter-transition",
        "ending-credits",
    ]:
        errors.append("required runtime scenarios differ")

    authoring = document.get("authoring_contract", {})
    if authoring.get("coverage_manifest") != "config/authoring_coverage.json":
        errors.append("authoring coverage manifest path differs")
    if authoring.get("lossless_roundtrip_required_for_primary_formats") is not True:
        errors.append("primary authoring formats must require lossless round trips")
    if authoring.get("required_primary_families") != [
        "world-maps-and-metatiles",
        "gameplay-objects-and-collisions",
        "chapter-metasprites-and-palettes",
        "title-hud-and-dialogue",
        "audio-command-streams",
    ]:
        errors.append("required primary authoring families differ")
    if authoring.get("secondary_fixed_tables_policy") != (
        "typed-source-or-registered-unknown"
    ):
        errors.append("secondary fixed-table policy differs")
    if authoring.get("exhaustive_visual_editors_required") is not False:
        errors.append("exhaustive visual editors must remain outside 1.0")

    if document.get("deferred_to_source_2_0") != [
        "relocation-build",
        "revision-a",
        "translations-and-regional-profiles",
        "exhaustive-secondary-graphics-and-text-editors",
    ]:
        errors.append("Source 2.0 deferred scope differs")
    return errors


def validate_semantic_modules(
    project_root: Path, source_contract: dict[str, Any]
) -> list[str]:
    relative = source_contract.get("module_manifest", "")
    manifest = safe_project_path(project_root, relative)
    if manifest is None or not manifest.is_file():
        return [f"missing semantic module manifest: {relative}"]
    document = load_json(manifest)
    if document.get("schema_version") != 1:
        return ["semantic module manifest is not schema 1"]
    modules = document.get("modules")
    if not isinstance(modules, list) or not modules:
        return ["semantic module manifest has no modules"]
    errors: list[str] = []
    paths: list[str] = []
    seen: set[str] = set()
    maximum = int(source_contract["maximum_module_lines"])
    source_root = str(source_contract["source_root"])
    for module in modules:
        if not isinstance(module, dict):
            errors.append("semantic module entry is not an object")
            continue
        relative_path = str(module.get("path", ""))
        if relative_path in seen:
            errors.append(f"duplicate semantic module path: {relative_path}")
        seen.add(relative_path)
        source_path = str(Path(source_root) / relative_path)
        paths.append(source_path)
        path = safe_project_path(project_root, source_path)
        if path is not None and path.is_file():
            line_count = len(path.read_text(encoding="utf-8").splitlines())
            if line_count > maximum:
                errors.append(
                    f"semantic module exceeds {maximum} lines: "
                    f"{source_path} ({line_count})"
                )
    errors.extend(validate_paths(project_root, paths, "semantic module"))
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


def validate_clean_worktree(project_root: Path) -> list[str]:
    try:
        status = git_output(
            project_root, "status", "--porcelain", "--untracked-files=all"
        )
    except (subprocess.CalledProcessError, OSError):
        return ["release worktree cleanliness cannot be inspected"]
    if status:
        path_count = len(status.splitlines())
        return [f"release worktree is not clean ({path_count} changed paths)"]
    return []


def validate_reconstruction(
    project_root: Path,
    manifest_path: Path,
    require_ready: bool = False,
    require_clean: bool = False,
) -> list[str]:
    document = load_json(manifest_path)
    errors: list[str] = []
    status = document.get("status")
    if document.get("schema_version") != 2:
        errors.append("reconstruction manifest is not schema 2")
    if document.get("release") != {
        "name": "Source Reconstruction 1.0",
        "version": "1.0",
    }:
        errors.append("reconstruction release identity differs")
    if status not in {"development", "tag-ready", "tagged"}:
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
    errors.extend(validate_semantic_modules(project_root, document["source_contract"]))
    errors.extend(
        validate_runtime_manifest(project_root, document["runtime_contract"], status)
    )

    baseline = document.get("preservation_baseline", {})
    errors.extend(validate_preservation_baseline(project_root, baseline))
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
    errors.extend(
        release_contract.validate_release_contract(
            project_root,
            document,
            available_targets,
            phase="development",
        )
    )
    if require_clean:
        errors.extend(validate_clean_worktree(project_root))
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--manifest",
        type=Path,
        default=Path("config/source_reconstruction.json"),
    )
    parser.add_argument("--require-ready", action="store_true")
    parser.add_argument("--require-clean", action="store_true")
    parser.add_argument(
        "--phase",
        choices=("development", "pre-tag", "post-tag"),
        default="development",
    )
    parser.add_argument("--check-remote", action="store_true")
    args = parser.parse_args()
    project_root = Path(__file__).resolve().parent.parent
    manifest_path = args.manifest
    if not manifest_path.is_absolute():
        manifest_path = project_root / manifest_path
    try:
        errors = validate_reconstruction(
            project_root,
            manifest_path,
            require_ready=args.require_ready,
            require_clean=args.require_clean,
        )
        if args.phase != "development":
            document = load_json(manifest_path)
            makefile = (project_root / "Makefile").read_text(encoding="utf-8")
            errors.extend(
                release_contract.validate_release_contract(
                    project_root,
                    document,
                    make_targets(makefile),
                    phase=args.phase,
                    check_remote=args.check_remote,
                )
            )
    except (OSError, json.JSONDecodeError, subprocess.SubprocessError) as exc:
        print(f"[ERROR] reconstruction audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    readiness = args.phase if args.phase != "development" else (
        "tag-ready" if args.require_ready else "development"
    )
    print(f"[OK] Source Reconstruction 1.0 {readiness} contract is consistent")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
