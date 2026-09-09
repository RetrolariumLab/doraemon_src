#!/usr/bin/env python3
"""Audit Doraemon's aggregate Source Reconstruction 2.0 contract."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import re
import subprocess
from typing import Any
import unicodedata


from scripts.validation.release import release_contract
from scripts.validation.release.source_reconstruction_audit import make_targets, validate_clean_worktree
from scripts.validation.release.makefile_interface import read_make_interface


PROJECT_ROOT = Path(__file__).resolve().parents[3]
MANIFEST_PATH = Path("config/source_reconstruction_2_0.json")
EXPECTED_PROFILES = ("original", "rev_a")
EXPECTED_STUDIOS = ("level", "graphics", "objects", "text", "sound")
EXPECTED_GATES = {
    "development": ["make source-2-check"],
    "pre_tag": ["make source-2-pre-tag-check"],
    "post_tag": ["make source-2-tag-check"],
}
PUBLIC_TEXT_SUFFIXES = {
    ".asm",
    ".cfg",
    ".inc",
    ".json",
    ".lua",
    ".md",
    ".mk",
    ".py",
    ".toml",
    ".txt",
    ".yaml",
    ".yml",
}
PUBLIC_TEXT_NAMES = {"Makefile"}
JAPANESE_PROVENANCE_PATHS = {
    "README.md",
    "config/authoring/world3/world3_entity_types.json",
    "config/authoring/world1/world1_descriptor_identities.json",
    "config/authoring/world1/world1_enemy_identities.json",
    "config/authoring/world2/world2_enemy_identities.json",
    "docs/world1_enemy_identities.md",
    "docs/world1_runtime.md",
    "docs/world2_enemy_identities.md",
    "docs/world2_runtime.md",
    "docs/world3_entity_types.md",
    "docs/world3_formats.md",
    "scripts/validation/world2/world2_enemy_identities.py",
    "tests/validation/world2/test_world2_enemy_identities.py",
}
ALLOWED_COMMIT_IDENTITIES = {
    "Daniel Oranguthang <75395800+oranguthang@users.noreply.github.com>"
}


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def validate_manifest_identity(document: object) -> list[str]:
    if not isinstance(document, dict):
        return ["Source 2.0 project manifest is not an object"]
    errors: list[str] = []
    if document.get("schema_version") != 1:
        errors.append("Source 2.0 project manifest schema differs")
    if document.get("release_line") != "2.0":
        errors.append("Source 2.0 release line differs")
    if "contract" in document:
        errors.append("Source 2.0 manifest contains obsolete nested metadata")
    return errors


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


def target_name(command: object) -> str:
    if not isinstance(command, str):
        return ""
    return command.split(maxsplit=1)[0]


def is_documented_japanese_provenance(relative: str, line: str, character: str) -> bool:
    if relative.replace("\\", "/") not in JAPANESE_PROVENANCE_PATHS:
        return False
    character_name = unicodedata.name(character, "")
    if not (
        character_name.startswith("CJK UNIFIED IDEOGRAPH")
        or "HIRAGANA" in character_name
        or "KATAKANA" in character_name
        or character_name == "IDEOGRAPHIC ITERATION MARK"
    ):
        return False
    return any(
        candidate.isalpha() and "LATIN" in unicodedata.name(candidate, "")
        for candidate in line
    )


def validate_public_english_text(project_root: Path) -> list[str]:
    errors: list[str] = []
    for relative in git_output(project_root, "ls-files").splitlines():
        path = project_root / relative
        if path.name not in PUBLIC_TEXT_NAMES and path.suffix.lower() not in PUBLIC_TEXT_SUFFIXES:
            continue
        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            errors.append(f"tracked public text is not UTF-8: {relative}")
            continue
        except OSError:
            errors.append(f"tracked public text is missing: {relative}")
            continue
        for line_number, line in enumerate(text.splitlines(), start=1):
            offending = next(
                (
                    character
                    for character in line
                    if character.isalpha()
                    and "LATIN" not in unicodedata.name(character, "")
                    and not is_documented_japanese_provenance(
                        relative, line, character
                    )
                ),
                None,
            )
            if offending is not None:
                errors.append(
                    f"non-English public text at {relative}:{line_number} "
                    f"({unicodedata.name(offending, 'unknown character')})"
                )
                break
    return errors


def validate_release_history_text(project_root: Path, base: str) -> list[str]:
    """Check every path and blob introduced after the release predecessor."""
    errors: list[str] = []
    checked_for_cyrillic: set[str] = set()
    for object_id, relative, content in release_contract.introduced_blobs(
        project_root, base
    ):
        offending_path = next(
            (
                character
                for character in relative
                if "CYRILLIC" in unicodedata.name(character, "")
            ),
            None,
        )
        if offending_path is not None:
            errors.append(f"release history has a non-English path: {relative}")
        if object_id not in checked_for_cyrillic:
            checked_for_cyrillic.add(object_id)
            decoded = content.decode("utf-8", errors="ignore")
            if any(
                "CYRILLIC" in unicodedata.name(character, "")
                for character in decoded
            ):
                errors.append(
                    f"release history blob {object_id[:9]} contains Cyrillic text"
                )
                continue
        path = Path(relative)
        if (
            path.name not in PUBLIC_TEXT_NAMES
            and path.suffix.lower() not in PUBLIC_TEXT_SUFFIXES
        ):
            continue
        try:
            text = content.decode("utf-8")
        except UnicodeDecodeError:
            errors.append(
                f"release history public-text blob is not UTF-8: {object_id[:9]} {relative}"
            )
            continue
        for line_number, line in enumerate(text.splitlines(), start=1):
            offending = next(
                (
                    character
                    for character in line
                    if character.isalpha()
                    and "LATIN" not in unicodedata.name(character, "")
                    and not is_documented_japanese_provenance(
                        relative, line, character
                    )
                ),
                None,
            )
            if offending is not None:
                errors.append(
                    f"non-English release-history text at {relative}:{line_number} "
                    f"in {object_id[:9]}"
                )
                break
    return errors


def validate_predecessor(
    project_root: Path, predecessor: object
) -> list[str]:
    if not isinstance(predecessor, dict):
        return ["Source 2.0 predecessor is not an object"]
    errors: list[str] = []
    path = release_contract.safe_project_file(
        project_root, predecessor.get("manifest")
    )
    if path is None:
        return ["Source 2.0 predecessor manifest is missing"]
    previous = load_json(path)
    if predecessor.get("tag") != previous.get("tag"):
        errors.append("predecessor tag differs from Source 1.0")
    commit = str(predecessor.get("commit", ""))
    tag = str(predecessor.get("tag", ""))
    try:
        if git_output(project_root, "rev-parse", f"{tag}^{{commit}}") != commit:
            errors.append("predecessor tag does not peel to its release commit")
        subprocess.run(
            ["git", "merge-base", "--is-ancestor", commit, "HEAD"],
            cwd=project_root,
            check=True,
            capture_output=True,
        )
    except (OSError, subprocess.SubprocessError):
        errors.append("Source Reconstruction 1.0 is not an available ancestor")
    return errors


def validate_revision_profiles(
    project_root: Path,
    document: dict[str, Any],
    artifacts: dict[str, dict[str, Any]],
) -> list[str]:
    errors: list[str] = []
    profiles = document.get("profiles", [])
    ids = [item.get("id") for item in profiles if isinstance(item, dict)]
    if ids != list(EXPECTED_PROFILES):
        errors.append("revision profile order or identity differs")
        return errors
    release_artifacts = {
        item.get("profile"): item for item in artifacts.values()
    }
    for profile in profiles:
        profile_id = profile["id"]
        if profile.get("source_assets") != []:
            errors.append(
                f"{profile_id} unexpectedly depends on revision binary assets"
            )
        entrypoint = release_contract.safe_project_file(
            project_root, profile.get("entrypoint")
        )
        if entrypoint is None:
            errors.append(f"{profile_id} revision entrypoint is missing")
        artifact = release_artifacts.get(profile_id, {})
        if artifact.get("size") != profile.get("file_size"):
            errors.append(f"{profile_id} artifact size differs from revision profile")
        if artifact.get("sha1") != profile.get("file_sha1"):
            errors.append(f"{profile_id} artifact SHA-1 differs from revision profile")
        if artifact.get("sha256") != profile.get("file_sha256"):
            errors.append(f"{profile_id} artifact SHA-256 differs from revision profile")
    comparison = document.get("comparison", {})
    if comparison.get("base_profile") != "original":
        errors.append("revision comparison base is not original")
    if comparison.get("candidate_profile") != "rev_a":
        errors.append("revision comparison candidate is not Revision A")
    if comparison.get("prg_difference_bytes") != 50:
        errors.append("Revision A PRG difference count differs")
    windows = comparison.get("windows", [])
    if not windows or any(item.get("classification") != "code" for item in windows):
        errors.append("Revision A differences are not all classified executable source")
    for window in windows:
        if release_contract.safe_project_file(
            project_root, window.get("source")
        ) is None:
            errors.append(
                f"revision code window lacks source: {window.get('source')}"
            )
    return errors


def validate_studios(
    project_root: Path,
    available_targets: set[str],
    release_artifacts: dict[str, dict[str, Any]],
) -> list[str]:
    errors: list[str] = []
    registry = load_json(project_root / "config/authoring/content_studios.json")
    workstation = registry.get("workstation_interaction", {})
    if workstation.get("target") not in available_targets:
        errors.append("Studio workstation interaction target is missing")
    if workstation.get("platform") != "windows":
        errors.append("Studio workstation interaction platform differs")
    if workstation.get("profile") != "original":
        errors.append("Studio workstation interaction profile differs")
    for relative in workstation.get("evidence", []):
        if release_contract.safe_project_file(project_root, relative) is None:
            errors.append(f"Studio workstation evidence is missing: {relative}")
    expected_actions = {
        "level": ["window", "save", "preview", "validate", "unsaved-close"],
        "graphics": ["window", "save", "build", "preview", "unsaved-close"],
        "objects": ["window", "save", "build", "preview", "unsaved-close"],
        "text": ["window", "save", "build", "preview", "unsaved-close"],
        "sound": ["window", "save", "build", "play", "unsaved-close"],
    }
    studios = registry.get("studios", [])
    ids = [item.get("id") for item in studios]
    if ids != list(EXPECTED_STUDIOS):
        errors.append("content Studio order or identity differs")
    for studio in studios:
        studio_id = studio.get("id")
        if studio.get("status") != "supported":
            errors.append(f"{studio_id} Studio is not supported")
        if not studio.get("artifacts"):
            errors.append(f"{studio_id} Studio has no artifacts")
        if studio.get("workstation_actions") != expected_actions.get(studio_id):
            errors.append(f"{studio_id} Studio workstation actions differ")
        for target in [*studio.get("headless_targets", []), studio.get("gui_target")]:
            if target not in available_targets:
                errors.append(f"{studio_id} Studio target is missing: {target}")
    authoring = load_json(
        project_root / "config/authoring/content_authoring_profiles.json"
    )
    if authoring.get("studio_ids") != list(EXPECTED_STUDIOS):
        errors.append("authoring profile Studio matrix differs")
    profiles = authoring.get("profiles", [])
    if [item.get("id") for item in profiles] != list(EXPECTED_PROFILES):
        errors.append("authoring profile order or identity differs")
    for profile in profiles:
        profile_id = profile.get("id")
        if profile.get("status") != "supported":
            errors.append(f"{profile_id} authoring profile is not supported")
        if profile.get("studios") != {
            studio: "supported" for studio in EXPECTED_STUDIOS
        }:
            errors.append(f"{profile_id} does not support every Studio")
        artifact = next(
            (
                item
                for item in release_artifacts.values()
                if item.get("profile") == profile_id
            ),
            {},
        )
        if profile.get("image_size") != artifact.get("size"):
            errors.append(f"{profile_id} authoring image size differs")
        if profile.get("image_sha256") != artifact.get("sha256"):
            errors.append(f"{profile_id} authoring image SHA-256 differs")
    coverage = load_json(project_root / "config/authoring_coverage.json")
    if coverage.get("status") != "complete" or any(
        item.get("status") != "complete" for item in coverage.get("families", [])
    ):
        errors.append("primary authoring-family coverage is incomplete")
    return errors


def validate_private_paths(project_root: Path) -> list[str]:
    tracked = git_output(project_root, "ls-files").splitlines()
    forbidden = [
        path
        for path in tracked
        if Path(path).suffix.lower() in {".nes", ".chr", ".prg", ".hdr"}
        or path.startswith(("assets/generated/", "content/workspace/", "build/"))
    ]
    return [f"private or generated path is tracked: {path}" for path in forbidden]


def _symbol_names(document: dict[str, Any]) -> dict[tuple[object, ...], str]:
    names: dict[tuple[object, ...], str] = {}
    for symbol in document.get("symbols", []):
        key = ("global", symbol.get("bank"), symbol.get("address"))
        names[key] = str(symbol.get("name", ""))
    for symbol in document.get("memory_symbols", []):
        banks = tuple(symbol.get("banks", ["all"]))
        key = ("memory", banks, symbol.get("address"))
        names[key] = str(symbol.get("name", ""))
    return names


def validate_label_renames(
    project_root: Path, predecessor: object
) -> list[str]:
    path = project_root / "config/reconstruction/label_renames.json"
    if not path.is_file():
        return ["canonical label rename registry is missing"]
    errors: list[str] = []
    competing = sorted(
        item.relative_to(project_root).as_posix()
        for item in project_root.rglob("*.json")
        if "label" in item.stem.lower() and "rename" in item.stem.lower()
    )
    if competing != ["config/reconstruction/label_renames.json"]:
        errors.append("canonical label rename registry is not unique")
    registry = load_json(path)
    if registry.get("schema_version") != 1:
        errors.append("label rename registry schema differs")
    baseline = registry.get("baseline", {})
    predecessor_commit = (
        predecessor.get("commit") if isinstance(predecessor, dict) else None
    )
    if baseline.get("commit") != predecessor_commit:
        errors.append("label rename baseline differs from the predecessor")
    if baseline.get("registry_path") != "config/symbols.json":
        errors.append("label rename predecessor registry path differs")
    if registry.get("current_registry") != "config/reconstruction/symbols.json":
        errors.append("current label registry path differs")
    try:
        previous = json.loads(
            git_output(
                project_root,
                "show",
                f"{predecessor_commit}:{baseline.get('registry_path', '')}",
            )
        )
    except (json.JSONDecodeError, OSError, subprocess.SubprocessError):
        return errors + ["label rename predecessor registry is unavailable"]
    current = load_json(project_root / str(registry.get("current_registry", "")))
    previous_names = _symbol_names(previous)
    current_names = _symbol_names(current)
    expected = sorted(
        (key, previous_names[key], current_names[key])
        for key in previous_names.keys() & current_names.keys()
        if previous_names[key] != current_names[key]
    )
    declared = registry.get("renames")
    if not isinstance(declared, list):
        errors.append("label rename mapping is not a list")
    elif expected or declared:
        errors.append("label rename mapping differs from inherited symbols")
    return errors


def validate_documentation_corpus(project_root: Path) -> list[str]:
    config_path = project_root / "config/documentation_corpus.json"
    if not config_path.is_file():
        return ["documentation corpus contract is missing"]
    document = load_json(config_path)
    errors: list[str] = []
    if document.get("schema_version") != 1:
        errors.append("documentation corpus schema differs")
    limit = document.get("ordinary_line_limit")
    if not isinstance(limit, int) or limit <= 0:
        return errors + ["documentation line limit is invalid"]
    paths = sorted((project_root / "docs").rglob("*.md"))
    relative_paths = [path.relative_to(project_root).as_posix() for path in paths]
    oversized = {
        relative
        for path, relative in zip(paths, relative_paths)
        if len(path.read_text(encoding="utf-8").splitlines()) > limit
    }
    declared_large = {
        item.get("path")
        for item in document.get("large_documents", [])
        if isinstance(item, dict) and item.get("reason")
    }
    if oversized != declared_large:
        errors.append("documentation size exceptions differ from the inventory")
    prefix_groups: dict[str, list[str]] = {}
    for relative in relative_paths:
        prefix = Path(relative).stem.split("_", maxsplit=1)[0]
        prefix_groups.setdefault(prefix, []).append(relative)
    repeated = {
        prefix: sorted(group)
        for prefix, group in prefix_groups.items()
        if len(group) >= 3
    }
    reviewed = {
        item.get("prefix"): sorted(item.get("documents", []))
        for item in document.get("retained_prefix_groups", [])
        if isinstance(item, dict) and item.get("reason")
    }
    if repeated != reviewed:
        errors.append("repeated documentation prefixes lack an exact review")
    index = (project_root / "docs/index.md").read_text(encoding="utf-8")
    indexed = {
        "docs/" + target
        for target in re.findall(r"\]\(([^)#]+\.md)\)", index)
        if not target.startswith(("http://", "https://"))
    }
    missing = set(relative_paths) - {"docs/index.md"} - indexed
    if missing:
        errors.append(
            "documentation index omits: " + ", ".join(sorted(missing))
        )
    return errors


def validate_source_2(
    project_root: Path,
    manifest_path: Path,
    phase: str = "development",
    require_ready: bool = False,
    check_remote: bool = False,
    require_clean: bool = False,
) -> list[str]:
    document = load_json(manifest_path)
    errors: list[str] = []
    errors.extend(validate_manifest_identity(document))
    errors.extend(validate_public_english_text(project_root))
    errors.extend(validate_documentation_corpus(project_root))
    errors.extend(validate_label_renames(project_root, document.get("predecessor")))
    if document.get("release") != {
        "name": "Source Reconstruction 2.0",
        "version": "2.0",
    }:
        errors.append("Source 2.0 release identity differs")
    if document.get("release_kind") != "baseline":
        errors.append("Source 2.0 release kind is not baseline")
    if document.get("tag") != "source-reconstruction-2.0":
        errors.append("Source 2.0 tag identity differs")
    status = document.get("status")
    if status not in {"development", "tag-ready", "tagged"}:
        return errors + ["Source 2.0 status is invalid"]
    if require_ready and status not in {"tag-ready", "tagged"}:
        errors.append("Source Reconstruction 2.0 manifest is not tag-ready")
    if phase == "pre-tag" and status != "tag-ready":
        errors.append("pre-tag Source 2.0 manifest is not tag-ready")
    if phase == "post-tag" and status not in {"tag-ready", "tagged"}:
        errors.append("post-tag Source 2.0 manifest is not release-ready")

    makefile = read_make_interface(project_root / "Makefile")
    available_targets = make_targets(makefile)
    scenario_document = load_json(project_root / "scenarios/runtime_scenarios.json")
    scenario_ids = {item["id"] for item in scenario_document.get("scenarios", [])}
    artifacts = {
        item.get("id"): item
        for item in document.get("artifacts", [])
        if isinstance(item, dict)
    }
    artifact_ids = set(artifacts)
    errors.extend(validate_predecessor(project_root, document.get("predecessor")))

    requirements = document.get("requirements", {})
    if not requirements:
        errors.append("Source 2.0 manifest has no requirements")
    for identifier, requirement in requirements.items():
        if not re.fullmatch(r"source-2\.[a-z0-9.-]+", identifier):
            errors.append(f"invalid Source 2.0 requirement ID: {identifier}")
        state = requirement.get("status") if isinstance(requirement, dict) else None
        if state not in release_contract.VALID_REQUIREMENT_STATES:
            errors.append(f"invalid requirement status: {identifier}")
            continue
        errors.extend(
            release_contract.validate_evidence(
                project_root,
                requirement.get("evidence"),
                available_targets,
                scenario_ids,
                artifact_ids,
                identifier,
            )
        )
    if phase in {"pre-tag", "post-tag"} or require_ready:
        incomplete = [
            identifier
            for identifier, requirement in requirements.items()
            if requirement.get("status")
            not in release_contract.READY_REQUIREMENT_STATES
        ]
        if incomplete:
            errors.append(
                "Source 2.0 has incomplete requirements: "
                + ", ".join(incomplete)
            )

    included = document.get("included_scope", [])
    if not included or any(item.get("status") != "satisfied" for item in included):
        errors.append("Source 2.0 included scope is empty or incomplete")
    excluded = document.get("excluded_scope", [])
    for item in excluded:
        if item.get("status") not in {"planned", "partial", "unsupported"}:
            errors.append(f"invalid excluded-scope status: {item.get('id')}")
        if not item.get("reason"):
            errors.append(f"excluded scope lacks a reason: {item.get('id')}")
    for item in document.get("delta", []):
        if not all(item.get(field) for field in ("id", "kind", "summary")):
            errors.append("Source 2.0 delta entry is incomplete")
        for relative in item.get("evidence", []):
            if release_contract.safe_project_file(project_root, relative) is None:
                errors.append(f"Source 2.0 delta evidence is missing: {relative}")

    required_documents = document.get("required_documents", [])
    if not required_documents:
        errors.append("Source 2.0 has no required document inventory")
    for relative in required_documents:
        if release_contract.safe_project_file(project_root, relative) is None:
            errors.append(f"required Source 2.0 document is missing: {relative}")
    required_targets = document.get("required_targets", [])
    if not required_targets:
        errors.append("Source 2.0 has no required target inventory")
    for target in required_targets:
        if target not in available_targets:
            errors.append(f"required Source 2.0 target is missing: {target}")

    profiles = document.get("profiles", [])
    if [item.get("id") for item in profiles] != list(EXPECTED_PROFILES):
        errors.append("accepted Source 2.0 profile matrix differs")
    coverage = {
        item.get("profile_id"): item
        for item in document.get("runtime_coverage", [])
    }
    for profile in profiles:
        profile_id = profile.get("id")
        if profile.get("status") != "supported":
            errors.append(f"accepted profile is not supported: {profile_id}")
        if profile.get("identity") != "byte-identical":
            errors.append(f"accepted profile lacks byte identity: {profile_id}")
        if profile.get("artifact") not in artifact_ids:
            errors.append(f"accepted profile lacks an artifact: {profile_id}")
        runtime = coverage.get(profile_id, {})
        if profile.get("runtime") != "direct" or runtime.get("mode") != "direct":
            errors.append(f"accepted profile lacks direct runtime: {profile_id}")
        if set(runtime.get("scenarios", [])) != scenario_ids:
            errors.append(f"runtime scenario set differs for {profile_id}")
        expected_sha1 = artifacts.get(profile.get("artifact"), {}).get("sha1")
        if scenario_document.get("rom_sha1_by_profile", {}).get(profile_id) != expected_sha1:
            errors.append(f"runtime image SHA-1 differs for {profile_id}")
    if set(coverage) != set(EXPECTED_PROFILES):
        errors.append("runtime coverage contains the wrong profile set")

    for artifact in artifacts.values():
        if target_name(artifact.get("build_target")) not in available_targets:
            errors.append(f"artifact build target is missing: {artifact.get('id')}")
        if not isinstance(artifact.get("size"), int) or artifact["size"] <= 0:
            errors.append(f"artifact size is invalid: {artifact.get('id')}")
        for field, length in (("sha1", 40), ("sha256", 64)):
            if not re.fullmatch(
                rf"[0-9a-f]{{{length}}}", str(artifact.get(field, ""))
            ):
                errors.append(f"artifact {field} is invalid: {artifact.get('id')}")

    revisions = load_json(project_root / "config/revision_profiles.json")
    errors.extend(validate_revision_profiles(project_root, revisions, artifacts))
    errors.extend(validate_studios(project_root, available_targets, artifacts))
    errors.extend(
        release_contract.validate_toolchain(project_root, document.get("toolchain"))
    )
    licensing_categories = {
        item.get("category") for item in document.get("licensing", [])
    }
    if not {
        "project_authored",
        "reconstructed_game_source",
        "bundled_external_tools",
        "external_tools",
        "private_user_supplied_inputs",
    } <= licensing_categories:
        errors.append("Source 2.0 licensing inventory is incomplete")
    if document.get("provenance", {}).get("private_inputs_tracked") is not False:
        errors.append("Source 2.0 private inputs are not declared untracked")
    errors.extend(validate_private_paths(project_root))
    if document.get("aggregate_gates") != EXPECTED_GATES:
        errors.append("Source 2.0 aggregate gate lifecycle differs")

    history_base = str(document.get("predecessor", {}).get("commit", ""))
    history_issues = release_contract.commit_message_issues(
        project_root, history_base
    )
    history_issues.extend(
        release_contract.commit_integrity_issues(
            project_root,
            history_base,
            allowed_identities=ALLOWED_COMMIT_IDENTITIES,
        )
    )
    history_issues.extend(validate_release_history_text(project_root, history_base))
    history_requirement = requirements.get("source-2.commit-history", {})
    expected_history = "satisfied" if not history_issues else "partial"
    if history_requirement.get("status") != expected_history:
        errors.append(
            f"Source 2.0 commit-history status must be {expected_history}"
        )
    if phase in {"pre-tag", "post-tag"} and history_issues:
        errors.append(
            f"Source 2.0 history has {len(history_issues)} message issue(s): "
            + "; ".join(history_issues[:5])
        )

    if phase in {"pre-tag", "post-tag"}:
        errors.extend(
            release_contract.validate_tag_state(
                project_root,
                str(document.get("tag", "")),
                phase,
                check_remote,
            )
        )
    if require_clean:
        errors.extend(validate_clean_worktree(project_root))
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project-root", type=Path, default=PROJECT_ROOT)
    parser.add_argument("--manifest", type=Path, default=MANIFEST_PATH)
    parser.add_argument(
        "--phase",
        choices=("development", "pre-tag", "post-tag"),
        default="development",
    )
    parser.add_argument("--require-ready", action="store_true")
    parser.add_argument("--require-clean", action="store_true")
    parser.add_argument("--check-remote", action="store_true")
    args = parser.parse_args()
    project_root = args.project_root.resolve()
    manifest_path = (
        args.manifest
        if args.manifest.is_absolute()
        else project_root / args.manifest
    )
    try:
        errors = validate_source_2(
            project_root,
            manifest_path,
            phase=args.phase,
            require_ready=args.require_ready,
            check_remote=args.check_remote,
            require_clean=args.require_clean,
        )
    except (OSError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] Source Reconstruction 2.0 audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        print(f"[FAIL] Source Reconstruction 2.0 audit found {len(errors)} error(s)")
        return 1
    print(f"[OK] Source Reconstruction 2.0 {args.phase} contract is consistent")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
