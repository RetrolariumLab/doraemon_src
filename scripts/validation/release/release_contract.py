#!/usr/bin/env python3
"""Validate shared reconstruction release-contract fields and Git state."""

from __future__ import annotations

import json
import re
import subprocess
from pathlib import Path
from typing import Any


VALID_REQUIREMENT_STATES = {
    "satisfied",
    "not_applicable",
    "partial",
    "unsupported",
    "planned",
}
READY_REQUIREMENT_STATES = {"satisfied", "not_applicable"}
CODEX_TRAILER = "Co-Authored-By: Codex <noreply@openai.com>"


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


def safe_project_file(project_root: Path, relative: object) -> Path | None:
    if not isinstance(relative, str) or not relative or Path(relative).is_absolute():
        return None
    root = project_root.resolve()
    path = (project_root / relative).resolve()
    if root not in path.parents or not path.is_file():
        return None
    return path


def validate_evidence(
    project_root: Path,
    evidence: object,
    available_targets: set[str],
    scenario_ids: set[str],
    artifact_ids: set[str],
    owner: str,
) -> list[str]:
    if not isinstance(evidence, dict):
        return [f"{owner} evidence is not an object"]
    errors: list[str] = []
    kinds = ("targets", "files", "scenarios", "artifacts")
    if not any(evidence.get(kind) for kind in kinds):
        errors.append(f"{owner} has no concrete evidence")
    for relative in evidence.get("files", []):
        if safe_project_file(project_root, relative) is None:
            errors.append(f"{owner} references missing evidence file: {relative}")
    for target in evidence.get("targets", []):
        if target not in available_targets:
            errors.append(f"{owner} references missing Make target: {target}")
    for scenario in evidence.get("scenarios", []):
        if scenario not in scenario_ids:
            errors.append(f"{owner} references unknown scenario: {scenario}")
    for artifact in evidence.get("artifacts", []):
        if artifact not in artifact_ids:
            errors.append(f"{owner} references unknown artifact: {artifact}")
    return errors


def commit_message_issues(
    project_root: Path, base: str, endpoint: str = "HEAD"
) -> list[str]:
    records = git_output(
        project_root,
        "log",
        "--reverse",
        "--format=%H%x00%P%x00%s%x00%b%x1e",
        f"{base}..{endpoint}",
    )
    issues: list[str] = []
    for record in records.split("\x1e"):
        fields = record.strip().split("\x00", 3)
        if len(fields) != 4:
            continue
        commit, parents, title, body = fields
        if len(parents.split()) > 1:
            continue
        short = commit[:9]
        if not title or title.endswith(".") or not re.search(r"[A-Za-z]", title):
            issues.append(f"{short} has an invalid English result title")
        stripped = body.strip()
        paragraphs = [
            paragraph.strip()
            for paragraph in re.split(r"\n\s*\n", stripped)
            if paragraph.strip() and paragraph.strip() != CODEX_TRAILER
        ]
        if not 2 <= len(paragraphs) <= 3:
            issues.append(f"{short} must have two or three body paragraphs")
        if CODEX_TRAILER not in stripped.splitlines():
            issues.append(f"{short} lacks the Codex co-author trailer")
    return issues


def validate_toolchain(project_root: Path, contract: object) -> list[str]:
    if not isinstance(contract, dict):
        return ["toolchain contract is not an object"]
    path = safe_project_file(project_root, contract.get("manifest"))
    if path is None:
        return ["toolchain manifest is missing"]
    document = json.loads(path.read_text(encoding="utf-8"))
    components = document.get("components", [])
    hosts = document.get("hosts", [])
    errors: list[str] = []
    component_ids = {item.get("id") for item in components if isinstance(item, dict)}
    host_ids = {item.get("id") for item in hosts if isinstance(item, dict)}
    if set(contract.get("components", [])) != component_ids:
        errors.append("release toolchain component inventory differs from its manifest")
    if set(contract.get("hosts", [])) != host_ids:
        errors.append("release host inventory differs from its manifest")
    for component in components:
        if not isinstance(component, dict):
            errors.append("toolchain component is not an object")
            continue
        owner = f"toolchain component {component.get('id')}"
        for field in ("id", "role", "version", "source", "provenance"):
            if component.get(field) in (None, ""):
                errors.append(f"{owner} lacks {field}")
        if component.get("role") in {"assembler", "linker", "runtime_emulator"}:
            for field in ("source_commit", "path", "size", "binary_sha256"):
                if component.get(field) in (None, ""):
                    errors.append(f"{owner} lacks {field}")
            if not re.fullmatch(r"[0-9a-f]{64}", str(component.get("binary_sha256", ""))):
                errors.append(f"{owner} has an invalid binary SHA-256")
    if not any(host.get("supported_status") == "supported" for host in hosts):
        errors.append("toolchain manifest has no supported host")
    return errors


def validate_tag_state(
    project_root: Path, tag: str, phase: str, check_remote: bool
) -> list[str]:
    errors: list[str] = []
    local_exists = bool(git_output(project_root, "tag", "--list", tag))
    if phase == "pre-tag":
        if local_exists:
            errors.append(f"future release tag already exists locally: {tag}")
        if check_remote:
            remote = git_output(
                project_root, "ls-remote", "--tags", "origin", f"refs/tags/{tag}"
            )
            if remote:
                errors.append(f"future release tag already exists on origin: {tag}")
    elif phase == "post-tag":
        if not local_exists:
            return [f"release tag is missing locally: {tag}"]
        if git_output(project_root, "cat-file", "-t", tag) != "tag":
            errors.append(f"release tag is not annotated: {tag}")
        if git_output(project_root, "rev-parse", f"{tag}^{{}}") != git_output(
            project_root, "rev-parse", "HEAD"
        ):
            errors.append("release tag peeled target does not match HEAD")
        tag_object = git_output(project_root, "cat-file", "-p", tag)
        message = tag_object.split("\n\n", 1)[1].strip() if "\n\n" in tag_object else ""
        if not message:
            errors.append("annotated release tag has no summary")
        if check_remote:
            remote = git_output(
                project_root,
                "ls-remote",
                "--tags",
                "origin",
                f"refs/tags/{tag}^{{}}",
            )
            expected = git_output(project_root, "rev-parse", f"{tag}^{{}}")
            if not remote or remote.split()[0] != expected:
                errors.append("published tag peeled target differs from the local tag")
    return errors


def validate_release_contract(
    project_root: Path,
    document: dict[str, Any],
    available_targets: set[str],
    phase: str = "development",
    check_remote: bool = False,
) -> list[str]:
    errors: list[str] = []
    if document.get("schema_version") != 2 or document.get("release_line") != "1.0":
        errors.append("Source 1.0 project manifest identity differs")
    if "contract" in document:
        errors.append("Source 1.0 manifest contains obsolete nested metadata")
    if document.get("release") != {
        "name": "Source Reconstruction 1.0",
        "version": "1.0",
    }:
        errors.append("release name or version differs")
    if document.get("release_kind") != "preservation":
        errors.append("Source 1.0 release kind must be preservation")
    tag = str(document.get("tag", ""))
    if tag != "source-reconstruction-1.0":
        errors.append("Source 1.0 tag identity differs")
    status = document.get("status")
    valid_statuses = {"development", "tag-ready", "tagged"}
    if status not in valid_statuses:
        errors.append("release status is invalid")
        return errors
    if phase == "pre-tag" and status != "tag-ready":
        errors.append("pre-tag manifest is not tag-ready")
    if phase == "post-tag" and status not in {"tag-ready", "tagged"}:
        errors.append("post-tag manifest is not release-ready")

    scenario_document = json.loads(
        (project_root / document["runtime_contract"]["scenario_manifest"]).read_text(
            encoding="utf-8"
        )
    )
    scenario_ids = {item["id"] for item in scenario_document["scenarios"]}
    artifacts = document.get("artifacts", [])
    artifact_ids = {item.get("id") for item in artifacts if isinstance(item, dict)}
    requirements = document.get("requirements")
    if not isinstance(requirements, dict) or not requirements:
        return errors + ["release manifest has no requirements"]
    excluded_ids = {
        item.get("id")
        for item in document.get("excluded_scope", [])
        if isinstance(item, dict)
    }
    for identifier, requirement in requirements.items():
        if not re.fullmatch(r"source-1\.[a-z0-9.-]+", identifier):
            errors.append(f"invalid stable requirement ID: {identifier}")
        if not isinstance(requirement, dict):
            errors.append(f"requirement is not an object: {identifier}")
            continue
        requirement_status = requirement.get("status")
        if requirement_status not in VALID_REQUIREMENT_STATES:
            errors.append(f"invalid requirement status: {identifier}")
        if requirement_status == "not_applicable":
            if (
                not requirement.get("reason")
                or requirement.get("excluded_scope") not in excluded_ids
            ):
                errors.append(f"not-applicable requirement lacks excluded scope: {identifier}")
        errors.extend(
            validate_evidence(
                project_root,
                requirement.get("evidence"),
                available_targets,
                scenario_ids,
                artifact_ids,
                identifier,
            )
        )
    decisions = document.get("condition_decisions", [])
    condition_ids = [item.get("condition_id") for item in decisions]
    if len(condition_ids) != len(set(condition_ids)):
        errors.append("conditional decision IDs are not unique")
    for decision in decisions:
        condition_id = decision.get("condition_id")
        requirement_id = decision.get("requirement_id")
        if not condition_id or requirement_id not in requirements:
            errors.append(f"conditional decision is incomplete: {condition_id}")
            continue
        requirement = requirements[requirement_id]
        if requirement.get("condition_id") != condition_id:
            errors.append(f"conditional requirement link differs: {requirement_id}")
        if decision.get("applies") is False:
            if requirement.get("status") != "not_applicable":
                errors.append(f"false condition is not marked not-applicable: {condition_id}")
            if decision.get("excluded_scope") not in excluded_ids or not decision.get("reason"):
                errors.append(f"false condition lacks excluded scope: {condition_id}")
    if phase in {"pre-tag", "post-tag"}:
        incomplete = [
            identifier
            for identifier, requirement in requirements.items()
            if requirement.get("status") not in READY_REQUIREMENT_STATES
        ]
        if incomplete:
            errors.append(f"release has incomplete requirements: {', '.join(incomplete)}")

    included = document.get("included_scope", [])
    if not included or any(item.get("status") != "satisfied" for item in included):
        errors.append("included scope is empty or not satisfied")
    for item in document.get("excluded_scope", []):
        if item.get("status") not in {"planned", "partial", "unsupported"} or not item.get("reason"):
            errors.append(f"excluded scope entry is incomplete: {item.get('id')}")
    for item in document.get("delta", []):
        if not item.get("id") or not item.get("kind") or not item.get("summary"):
            errors.append("release delta entry is incomplete")
        for relative in item.get("evidence", []):
            if safe_project_file(project_root, relative) is None:
                errors.append(f"release delta references missing evidence: {relative}")

    coverage = {
        item.get("profile_id"): item for item in document.get("runtime_coverage", [])
    }
    for profile in document.get("profiles", []):
        if profile.get("status") == "supported":
            if profile.get("identity") != "byte-identical":
                errors.append(f"supported profile lacks byte identity: {profile.get('id')}")
            if profile.get("artifact") not in artifact_ids:
                errors.append(f"supported profile lacks an artifact: {profile.get('id')}")
            runtime = coverage.get(profile.get("id"))
            if not runtime or runtime.get("mode") != "direct":
                errors.append(f"supported profile lacks direct runtime coverage: {profile.get('id')}")
            elif set(runtime.get("scenarios", [])) != scenario_ids:
                errors.append(f"profile runtime scenario set differs: {profile.get('id')}")
    for artifact in artifacts:
        owner = f"artifact {artifact.get('id')}"
        if artifact.get("build_target") not in available_targets:
            errors.append(f"{owner} has no build target")
        if not isinstance(artifact.get("size"), int) or artifact["size"] <= 0:
            errors.append(f"{owner} has an invalid size")
        if not re.fullmatch(r"[0-9a-f]{64}", str(artifact.get("sha256", ""))):
            errors.append(f"{owner} has an invalid SHA-256")

    errors.extend(validate_toolchain(project_root, document.get("toolchain")))
    if not document.get("layout_deviations"):
        errors.append("layout deviations are not declared")
    for deviation in document.get("layout_deviations", []):
        if not all(
            deviation.get(field)
            for field in ("rule_id", "actual_path", "reason", "equivalent_control")
        ):
            errors.append("layout deviation is incomplete")
    licensing = document.get("licensing", [])
    categories = {item.get("category") for item in licensing}
    required_categories = {
        "project_authored",
        "reconstructed_game_source",
        "bundled_external_tools",
        "external_tools",
        "private_user_supplied_inputs",
    }
    if not required_categories <= categories:
        errors.append("licensing inventory lacks a required component category")
    if document.get("provenance", {}).get("private_inputs_tracked") is not False:
        errors.append("private inputs must be declared untracked")

    base = str(document.get("predecessor", {}).get("commit", ""))
    history_endpoint = "HEAD"
    try:
        if tag and git_output(project_root, "tag", "--list", tag):
            tagged_commit = git_output(
                project_root, "rev-parse", f"{tag}^{{commit}}"
            )
            git_output(
                project_root,
                "merge-base",
                "--is-ancestor",
                tagged_commit,
                "HEAD",
            )
            history_endpoint = tagged_commit
    except (OSError, subprocess.CalledProcessError):
        pass
    history_issues = (
        commit_message_issues(project_root, base, history_endpoint)
        if base
        else ["missing base"]
    )
    history_status = requirements.get("source-1.commit-history", {}).get("status")
    if history_issues and history_status != "partial":
        errors.append("commit-history status must be partial while message issues remain")
    if not history_issues and history_status != "satisfied":
        errors.append("commit-history status must be satisfied when history is compliant")
    if phase in {"pre-tag", "post-tag"} and history_issues:
        sample = "; ".join(history_issues[:5])
        errors.append(f"commit history has {len(history_issues)} message issues: {sample}")
    if phase in {"pre-tag", "post-tag"}:
        errors.extend(validate_tag_state(project_root, tag, phase, check_remote))
    return errors
