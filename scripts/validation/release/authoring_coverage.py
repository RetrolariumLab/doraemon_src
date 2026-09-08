#!/usr/bin/env python3
"""Audit Source 1.0 primary-format authoring coverage."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any


from scripts.validation.release.makefile_interface import (
    make_rule_dependencies,
    make_targets,
    read_make_interface,
)


EXPECTED_COMPONENTS = {
    "world-maps-and-metatiles": [
        "world1-world-data",
        "world2-world-data",
        "world3-world-data",
    ],
    "gameplay-objects-and-collisions": [
        "world1-gameplay-data-and-collisions",
        "world2-gameplay-data-and-collisions",
        "world3-gameplay-data-and-collisions",
    ],
    "chapter-metasprites-and-palettes": [
        "world1-presentation",
        "world2-presentation",
        "world3-presentation",
    ],
    "title-hud-and-dialogue": [
        "shell-title-hud-help-and-ending",
    ],
    "audio-command-streams": [
        "four-bank-audio-command-streams",
    ],
}
EXPECTED_AUTHORING_FILES = {
    "world1-world-data": ["data/world1/hierarchical_world.json"],
    "world2-world-data": [
        "data/world2/compressed_screens.json",
        "data/world2/stage_sequence.json",
        "data/world2/stage_branches.json",
        "data/world2/metatiles.json",
    ],
    "world3-world-data": ["data/world3/hierarchical_world.json"],
    "world1-gameplay-data-and-collisions": [
        "data/world1/object_data.json",
        "data/world1/hierarchical_world.json",
        "data/world1/underground_rooms.json",
        "data/world1/weapons.json",
    ],
    "world2-gameplay-data-and-collisions": [
        "data/world2/compressed_screens.json",
        "data/world2/enemy_states.json",
        "data/world2/inventory_spawn_screens.json",
        "data/world2/metatiles.json",
    ],
    "world3-gameplay-data-and-collisions": [
        "data/world3/object_catalog.json",
        "data/world3/behavior_streams.json",
        "data/world3/transient_spawns.json",
        "data/world3/spawn_initializer_data.json",
        "data/world3/update_handler_data.json",
        "data/world3/hierarchical_world.json",
    ],
    "world1-presentation": [
        "data/world1/metasprites.json",
        "data/world1/palettes.json",
    ],
    "world2-presentation": [
        "data/world2/metasprites.json",
        "data/world2/palettes.json",
    ],
    "world3-presentation": ["data/world3/metasprites.json"],
    "shell-title-hud-help-and-ending": ["data/shell/text.json"],
    "four-bank-audio-command-streams": ["data/audio/music_streams.json"],
}
EXPECTED_VALIDATION_TARGETS = {
    "world1-world-data": ["validate-world-data", "validate-world1-map-decoder"],
    "world2-world-data": [
        "validate-world2-streaming",
        "validate-world2-stage-sequence",
        "validate-world2-stage-branches",
        "validate-world2-metatiles",
    ],
    "world3-world-data": ["validate-world-data", "validate-world3-room-rendering"],
    "world1-gameplay-data-and-collisions": [
        "validate-object-placements",
        "validate-world1-player-controls",
        "validate-world1-underground-rooms",
        "validate-world1-weapons",
        "validate-world-data",
    ],
    "world2-gameplay-data-and-collisions": [
        "validate-world2-streaming",
        "validate-world2-enemy-states",
        "validate-world2-inventory",
        "validate-world2-metatiles",
    ],
    "world3-gameplay-data-and-collisions": [
        "validate-world3-object-catalog",
        "validate-world3-entity-types",
        "validate-world3-behavior",
        "validate-world3-transient-spawns",
        "validate-world3-spawn-initializers",
        "validate-world3-update-handlers",
        "validate-world3-collision-rendering",
        "validate-world-data",
    ],
    "world1-presentation": [
        "validate-world1-metasprites",
        "validate-world1-palettes",
    ],
    "world2-presentation": [
        "validate-world2-metasprites",
        "validate-world2-palettes",
    ],
    "world3-presentation": ["validate-world3-metasprites"],
    "shell-title-hud-help-and-ending": ["validate-shell-text"],
    "four-bank-audio-command-streams": [
        "validate-audio-streams",
        "validate-audio-music",
        "validate-audio-effects",
        "validate-audio-arbitration",
    ],
}
EVIDENCE_FIELDS = (
    "authoring_files",
    "contract_files",
    "documentation_files",
    "test_files",
)


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def safe_project_path(project_root: Path, relative: str) -> Path | None:
    if not relative or Path(relative).is_absolute():
        return None
    root = project_root.resolve()
    resolved = (project_root / relative).resolve()
    if resolved != root and root not in resolved.parents:
        return None
    return resolved


def validate_shape(
    document: dict[str, Any],
    required_families: list[str],
    secondary_policy: str,
) -> list[str]:
    errors: list[str] = []
    if document.get("schema_version") != 1:
        errors.append("authoring coverage manifest is not schema 1")
    if document.get("status") != "complete":
        errors.append("primary authoring coverage is not complete")
    if document.get("secondary_fixed_tables_policy") != secondary_policy:
        errors.append("secondary fixed-table policy differs")
    families = document.get("families")
    if not isinstance(families, list):
        return [*errors, "authoring families are not a list"]
    identifiers = [family.get("id") for family in families]
    if identifiers != required_families:
        errors.append("primary authoring family order or identity differs")
    all_component_ids: list[str] = []
    for family in families:
        identifier = family.get("id")
        components = family.get("components")
        if family.get("status") != "complete":
            errors.append(f"authoring family is incomplete: {identifier}")
        if not isinstance(components, list):
            errors.append(f"authoring components are not a list: {identifier}")
            continue
        component_ids = [component.get("id") for component in components]
        if component_ids != EXPECTED_COMPONENTS.get(identifier):
            errors.append(f"authoring component inventory differs: {identifier}")
        all_component_ids.extend(str(value) for value in component_ids)
        for component in components:
            component_id = component.get("id")
            if component.get("status") != "complete":
                errors.append(f"authoring component is incomplete: {component_id}")
            if component.get("lossless_roundtrip") is not True:
                errors.append(f"component lacks lossless round trip: {component_id}")
            if component.get("authoring_files") != EXPECTED_AUTHORING_FILES.get(
                component_id
            ):
                errors.append(f"component authoring inventory differs: {component_id}")
            targets = component.get("validation_targets")
            if not isinstance(targets, list) or not targets:
                errors.append(f"component lacks validation targets: {component_id}")
            elif targets != EXPECTED_VALIDATION_TARGETS.get(component_id):
                errors.append(f"component validator inventory differs: {component_id}")
            for field in EVIDENCE_FIELDS:
                values = component.get(field)
                if not isinstance(values, list) or not values:
                    errors.append(f"component lacks {field}: {component_id}")
    if len(all_component_ids) != len(set(all_component_ids)):
        errors.append("authoring component identifiers are not unique")
    return errors


def validate_evidence(
    project_root: Path,
    document: dict[str, Any],
    makefile_text: str,
) -> list[str]:
    errors: list[str] = []
    available_targets = make_targets(makefile_text)
    release_targets = make_rule_dependencies(makefile_text, "release-check")
    for family in document.get("families", []):
        for component in family.get("components", []):
            component_id = component.get("id")
            for field in EVIDENCE_FIELDS:
                for relative in component.get(field, []):
                    path = safe_project_path(project_root, str(relative))
                    if path is None:
                        errors.append(
                            f"unsafe {field} path for {component_id}: {relative}"
                        )
                    elif not path.is_file():
                        errors.append(
                            f"missing {field} path for {component_id}: {relative}"
                        )
                    elif field == "authoring_files" and not (
                        str(relative).startswith("data/")
                        and str(relative).endswith(".json")
                    ):
                        errors.append(
                            f"authoring path is not a data JSON: {relative}"
                        )
            for target in component.get("validation_targets", []):
                if target not in available_targets:
                    errors.append(f"missing authoring validator target: {target}")
                if target not in release_targets:
                    errors.append(f"validator is outside release-check: {target}")
    for relative in document.get("secondary_fixed_table_evidence", []):
        path = safe_project_path(project_root, str(relative))
        if path is None or not path.is_file():
            errors.append(f"missing secondary fixed-table evidence: {relative}")
    return errors


def validate_coverage(
    project_root: Path,
    manifest_path: Path,
    reconstruction_path: Path,
    makefile_path: Path,
) -> tuple[list[str], dict[str, int]]:
    document = load_json(manifest_path)
    reconstruction = load_json(reconstruction_path)
    authoring = reconstruction["authoring_contract"]
    errors = validate_shape(
        document,
        authoring["required_primary_families"],
        authoring["secondary_fixed_tables_policy"],
    )
    errors.extend(
        validate_evidence(project_root, document, read_make_interface(makefile_path))
    )
    families = document.get("families", [])
    components = [
        component
        for family in families
        for component in family.get("components", [])
    ]
    authoring_files = {
        path
        for component in components
        for path in component.get("authoring_files", [])
    }
    validators = {
        target
        for component in components
        for target in component.get("validation_targets", [])
    }
    return errors, {
        "family_count": len(families),
        "component_count": len(components),
        "authoring_file_count": len(authoring_files),
        "validator_count": len(validators),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--manifest", type=Path, default=Path("config/authoring_coverage.json")
    )
    parser.add_argument(
        "--reconstruction",
        type=Path,
        default=Path("config/source_reconstruction.json"),
    )
    parser.add_argument("--makefile", type=Path, default=Path("Makefile"))
    args = parser.parse_args()
    project_root = Path(__file__).resolve().parents[3]

    def resolve(path: Path) -> Path:
        return path if path.is_absolute() else project_root / path

    try:
        errors, report = validate_coverage(
            project_root,
            resolve(args.manifest),
            resolve(args.reconstruction),
            resolve(args.makefile),
        )
    except (OSError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] authoring coverage audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] primary authoring coverage: {report['family_count']} families, "
        f"{report['component_count']} components, "
        f"{report['authoring_file_count']} authoring files, "
        f"{report['validator_count']} release validators"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
