#!/usr/bin/env python3
"""Audit Source 1.0 RAM and object-system coverage."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any

import authoring_coverage
import object_pools
import reconstruction_inventory


EXPECTED_TARGETS = {
    "common-shell-audio-state": [
        "validate-common-runtime",
        "validate-shell-runtime",
        "validate-audio-music",
        "validate-audio-arbitration",
    ],
    "world1-state-and-objects": [
        "validate-object-pools",
        "validate-object-dispatch",
        "validate-object-placements",
        "validate-world1-core-routines",
        "validate-world1-frame-mechanics",
        "validate-world1-entity-helpers",
        "validate-world1-final-routines",
        "validate-world1-player-controls",
        "validate-world1-camera",
        "validate-world1-camera-entities",
        "validate-world1-map-decoder",
        "validate-world1-ppu-streaming",
        "validate-world1-random",
        "validate-world1-enemy-handlers",
        "validate-world1-descriptor-identities",
    ],
    "world2-state-and-objects": [
        "validate-object-pools",
        "validate-object-dispatch",
        "validate-world2-frame-core",
        "validate-world2-player-systems",
        "validate-world2-screen-core",
        "validate-world2-projectile-runtime",
        "validate-world2-sprite-runtime",
        "validate-world2-final-routines",
        "validate-world2-streaming",
        "validate-world2-enemy-states",
        "validate-world2-enemy-handlers",
        "validate-world2-inventory",
    ],
    "world3-state-and-objects": [
        "validate-object-pools",
        "validate-object-dispatch",
        "validate-world3-frame-core",
        "validate-world3-collision-rendering",
        "validate-world3-room-runtime",
        "validate-world3-player-runtime",
        "validate-world3-interaction-runtime",
        "validate-world3-entity-runtime",
        "validate-world3-room-rendering",
        "validate-world3-formation-runtime",
        "validate-world3-transition-runtime",
        "validate-world3-object-data",
        "validate-world3-behavior",
        "validate-world3-entity-types",
        "validate-world3-object-catalog",
        "validate-world3-spawn-initializers",
        "validate-world3-transient-spawns",
        "validate-world3-update-handlers",
        "validate-world3-ppu-queue",
    ],
}


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def actual_metrics(project_root: Path) -> tuple[list[str], dict[str, Any]]:
    pool_errors, pool_report = object_pools.validate(
        object_pools.load_document(
            project_root / "config" / "object_pools.json", "object pool"
        ),
        object_pools.load_document(
            project_root / "config" / "symbols.json", "symbol registry"
        ),
    )
    inventory = reconstruction_inventory.calculate(project_root)
    labels = inventory["source_labels"]["total"]
    indirect = inventory["indirect_code_entries"]["total"]
    ram = inventory["ram_aliases"]
    return pool_errors, {
        "object_pools": pool_report,
        "semantic_routines": {
            "neutral_routine_labels": labels["neutral_routine_labels"],
            "indirect_entries": indirect["entries"],
            "semantic_indirect_entries": indirect["semantic_symbols"],
        },
        "ram_aliases": {
            "unique_symbols": ram["unique_symbols"],
            "shared_symbols": ram["shared"]["symbols"],
            "effective_by_bank": ram["effective_by_bank"],
        },
    }


def validate_shape(document: dict[str, Any], metrics: dict[str, Any]) -> list[str]:
    errors: list[str] = []
    if document.get("schema_version") != 1:
        errors.append("runtime-state coverage manifest is not schema 1")
    if document.get("status") != "complete":
        errors.append("RAM/object coverage is not complete")
    if document.get("expected_metrics") != metrics:
        errors.append("RAM/object coverage metrics differ")
    components = document.get("components")
    if not isinstance(components, list):
        return [*errors, "runtime-state components are not a list"]
    identifiers = [component.get("id") for component in components]
    if identifiers != list(EXPECTED_TARGETS):
        errors.append("runtime-state component order or identity differs")
    for component in components:
        identifier = component.get("id")
        if component.get("status") != "complete":
            errors.append(f"runtime-state component is incomplete: {identifier}")
        if component.get("validation_targets") != EXPECTED_TARGETS.get(identifier):
            errors.append(f"runtime-state validator inventory differs: {identifier}")
        for field in ("contract_files", "documentation_files"):
            values = component.get(field)
            if not isinstance(values, list) or not values:
                errors.append(f"runtime-state component lacks {field}: {identifier}")
    return errors


def validate_evidence(
    project_root: Path,
    document: dict[str, Any],
    makefile_text: str,
) -> list[str]:
    errors: list[str] = []
    available_targets = authoring_coverage.make_targets(makefile_text)
    release_targets = authoring_coverage.make_rule_dependencies(
        makefile_text, "release-check"
    )
    for component in document.get("components", []):
        identifier = component.get("id")
        for field in ("contract_files", "documentation_files"):
            for relative in component.get(field, []):
                path = authoring_coverage.safe_project_path(
                    project_root, str(relative)
                )
                if path is None or not path.is_file():
                    errors.append(
                        f"missing {field} path for {identifier}: {relative}"
                    )
        for target in component.get("validation_targets", []):
            if target not in available_targets:
                errors.append(f"missing runtime-state validator target: {target}")
            if target not in release_targets:
                errors.append(f"runtime-state validator is outside release-check: {target}")
    return errors


def validate_coverage(
    project_root: Path,
    manifest_path: Path,
    makefile_path: Path,
) -> tuple[list[str], dict[str, int]]:
    document = load_json(manifest_path)
    metric_errors, metrics = actual_metrics(project_root)
    errors = list(metric_errors)
    errors.extend(validate_shape(document, metrics))
    errors.extend(
        validate_evidence(project_root, document, makefile_path.read_text(encoding="utf-8"))
    )
    components = document.get("components", [])
    validators = {
        target
        for component in components
        for target in component.get("validation_targets", [])
    }
    return errors, {
        "component_count": len(components),
        "validator_count": len(validators),
        "ram_symbol_count": metrics["ram_aliases"]["unique_symbols"],
        "pool_count": metrics["object_pools"]["pool_count"],
        "slot_count": metrics["object_pools"]["slot_count"],
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--manifest", type=Path, default=Path("config/runtime_state_coverage.json")
    )
    parser.add_argument("--makefile", type=Path, default=Path("Makefile"))
    args = parser.parse_args()
    project_root = Path(__file__).resolve().parent.parent

    def resolve(path: Path) -> Path:
        return path if path.is_absolute() else project_root / path

    try:
        errors, report = validate_coverage(
            project_root, resolve(args.manifest), resolve(args.makefile)
        )
    except (OSError, KeyError, TypeError, ValueError, json.JSONDecodeError) as exc:
        print(f"[ERROR] runtime-state coverage audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] RAM/object coverage: {report['component_count']} components, "
        f"{report['ram_symbol_count']} RAM symbols, "
        f"{report['pool_count']} pools / {report['slot_count']} slots, "
        f"{report['validator_count']} release validators"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
