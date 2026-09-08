#!/usr/bin/env python3
"""Audit, split, and verify official Doraemon revision profiles."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import sys
from typing import Any

from scripts.build import project


REGIONS = ("header", "prg", "chr")


class RevisionError(ValueError):
    """A revision-profile validation failure."""


def parse_number(value: object, field: str) -> int:
    if isinstance(value, int):
        return value
    if isinstance(value, str):
        try:
            return int(value, 0)
        except ValueError:
            pass
    raise RevisionError(f"invalid integer for {field}: {value!r}")


def load_manifest(path: Path) -> dict[str, Any]:
    try:
        document = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise RevisionError(f"cannot read revision manifest {path}: {exc}") from exc
    if document.get("schema_version") != 1:
        raise RevisionError("unsupported revision profile schema")
    profiles = document.get("profiles")
    if not isinstance(profiles, list) or not profiles:
        raise RevisionError("revision manifest has no profiles")
    ids = [profile.get("id") for profile in profiles if isinstance(profile, dict)]
    if len(ids) != len(profiles) or len(set(ids)) != len(ids):
        raise RevisionError("revision profile IDs are invalid or duplicated")
    if document.get("default_profile") not in ids:
        raise RevisionError("default revision profile is not declared")
    return document


def profile_by_id(document: dict[str, Any], profile_id: str) -> dict[str, Any]:
    matches = [profile for profile in document["profiles"] if profile["id"] == profile_id]
    if len(matches) != 1:
        raise RevisionError(f"revision profile not found: {profile_id}")
    return matches[0]


def validate_profile_image(data: bytes, profile: dict[str, Any]) -> dict[str, bytes]:
    parsed, facts = project.image_facts(data)
    checks = (
        "file_size",
        "file_sha1",
        "file_sha256",
        "file_crc32",
        "header_size",
        "header_sha1",
        "prg_size",
        "prg_sha1",
        "prg_crc32",
        "chr_size",
        "chr_sha1",
        "chr_crc32",
        "payload_sha1",
        "payload_crc32",
    )
    for field in checks:
        expected = profile.get(field)
        if expected is None:
            raise RevisionError(f"profile {profile['id']} is missing {field}")
        actual = facts[field]
        if isinstance(actual, int):
            expected = parse_number(expected, field)
        elif isinstance(expected, str):
            expected = expected.lower()
        if actual != expected:
            raise RevisionError(
                f"profile {profile['id']} {field} mismatch: "
                f"got {actual!r}, expected {expected!r}"
            )
    if parsed["mapper"] != 66 or parsed["mirroring"] != "vertical":
        raise RevisionError(f"profile {profile['id']} is not vertical GNROM")
    return {region: parsed[region] for region in REGIONS}


def difference_offsets(left: bytes, right: bytes) -> list[int]:
    if len(left) != len(right):
        raise RevisionError("cannot compare regions with different sizes")
    return [offset for offset, pair in enumerate(zip(left, right)) if pair[0] != pair[1]]


def validate_window(
    descriptor: dict[str, Any], base_prg: bytes, candidate_prg: bytes
) -> range:
    bank = parse_number(descriptor.get("bank"), "window.bank")
    start = parse_number(descriptor.get("start"), "window.start")
    end = parse_number(descriptor.get("end"), "window.end")
    offset = parse_number(descriptor.get("prg_offset"), "window.prg_offset")
    size = parse_number(descriptor.get("size"), "window.size")
    expected_offset = bank * 0x8000 + start - 0x8000
    if not 0 <= bank < 4 or not 0x8000 <= start <= end <= 0xFFFF:
        raise RevisionError("revision window lies outside a GNROM PRG bank")
    if offset != expected_offset or size != end - start + 1:
        raise RevisionError("revision window address, offset, and size disagree")
    if descriptor.get("classification") not in ("code", "data"):
        raise RevisionError("revision window must be classified as code or data")
    base = base_prg[offset:offset + size]
    candidate = candidate_prg[offset:offset + size]
    if len(base) != size or len(candidate) != size:
        raise RevisionError("revision window exceeds PRG data")
    for role, payload in (("base", base), ("candidate", candidate)):
        actual = hashlib.sha1(payload).hexdigest()
        if actual != descriptor.get(f"{role}_sha1"):
            raise RevisionError(f"revision window {role} SHA-1 mismatch at ${start:04X}")
    return range(offset, offset + size)


def audit_comparison(
    document: dict[str, Any], base_data: bytes, candidate_data: bytes
) -> None:
    comparison = document.get("comparison")
    if not isinstance(comparison, dict):
        raise RevisionError("revision manifest has no comparison contract")
    base_profile = profile_by_id(document, str(comparison.get("base_profile")))
    candidate_profile = profile_by_id(document, str(comparison.get("candidate_profile")))
    base = validate_profile_image(base_data, base_profile)
    candidate = validate_profile_image(candidate_data, candidate_profile)
    common = comparison.get("common_regions")
    differing = comparison.get("differing_regions")
    if sorted(common or []) != ["chr", "header"] or differing != ["prg"]:
        raise RevisionError("Doraemon revision region contract is incomplete")
    for region in common:
        if base[region] != candidate[region]:
            raise RevisionError(f"declared common region differs: {region}")
    differences = difference_offsets(base["prg"], candidate["prg"])
    expected_count = parse_number(
        comparison.get("prg_difference_bytes"), "comparison.prg_difference_bytes"
    )
    if len(differences) != expected_count:
        raise RevisionError(
            f"PRG difference count mismatch: got {len(differences)}, "
            f"expected {expected_count}"
        )
    windows = comparison.get("windows")
    if not isinstance(windows, list) or not windows:
        raise RevisionError("revision comparison has no classified windows")
    coverage: set[int] = set()
    previous_end = -1
    for descriptor in windows:
        if not isinstance(descriptor, dict):
            raise RevisionError("invalid revision window descriptor")
        covered = validate_window(descriptor, base["prg"], candidate["prg"])
        if covered.start <= previous_end:
            raise RevisionError("revision windows overlap or are unsorted")
        previous_end = covered.stop - 1
        coverage.update(covered)
    outside = [offset for offset in differences if offset not in coverage]
    if outside:
        raise RevisionError(f"PRG differences escape classified windows at ${outside[0]:05X}")
    print(
        f"[OK] {base_profile['id']} -> {candidate_profile['id']}: "
        f"{len(differences)} PRG bytes in {len(windows)} classified code windows; "
        "header and CHR are identical"
    )


def split_source_assets(
    profile: dict[str, Any], regions: dict[str, bytes], output_dir: Path
) -> None:
    assets = profile.get("source_assets")
    if not isinstance(assets, list):
        raise RevisionError(f"profile {profile['id']} has no source_assets list")
    if not assets:
        print(
            f"[OK] {profile['id']}: no revision-specific data assets; "
            "differences remain source-level code"
        )
        return
    for descriptor in assets:
        region_name = descriptor.get("region")
        if region_name not in REGIONS:
            raise RevisionError(f"unsupported source asset region: {region_name!r}")
        offset = parse_number(descriptor.get("offset"), "source_asset.offset")
        size = parse_number(descriptor.get("size"), "source_asset.size")
        payload = regions[region_name][offset:offset + size]
        project.validate_asset(payload, descriptor)
        destination = project.safe_asset_path(output_dir, str(descriptor.get("path", "")))
        action = project.write_if_changed(destination, payload)
        print(f"[{action}] {destination} ({len(payload)} bytes)")


def command_audit(args: argparse.Namespace) -> None:
    document = load_manifest(args.manifest)
    audit_comparison(document, args.base_rom.read_bytes(), args.candidate_rom.read_bytes())


def command_split(args: argparse.Namespace) -> None:
    document = load_manifest(args.manifest)
    profile = profile_by_id(document, args.profile)
    regions = validate_profile_image(args.reference_rom.read_bytes(), profile)
    split_source_assets(profile, regions, args.output_dir / args.profile)


def command_verify(args: argparse.Namespace) -> None:
    document = load_manifest(args.manifest)
    profile = profile_by_id(document, args.profile)
    reference = args.reference_rom.read_bytes()
    built = args.built_rom.read_bytes()
    validate_profile_image(reference, profile)
    validate_profile_image(built, profile)
    if built != reference:
        raise RevisionError(f"built {args.profile} image differs from its reference")
    print(f"[OK] {args.profile}: {len(built)} byte-identical ROM bytes")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", type=Path, default=Path("config/revision_profiles.json"))
    subparsers = parser.add_subparsers(dest="command", required=True)
    audit = subparsers.add_parser("audit")
    audit.add_argument("--base-rom", required=True, type=Path)
    audit.add_argument("--candidate-rom", required=True, type=Path)
    audit.set_defaults(handler=command_audit)
    split = subparsers.add_parser("split")
    split.add_argument("--profile", required=True)
    split.add_argument("--reference-rom", required=True, type=Path)
    split.add_argument("--output-dir", required=True, type=Path)
    split.set_defaults(handler=command_split)
    verify = subparsers.add_parser("verify")
    verify.add_argument("--profile", required=True)
    verify.add_argument("--reference-rom", required=True, type=Path)
    verify.add_argument("--built-rom", required=True, type=Path)
    verify.set_defaults(handler=command_verify)
    return parser


def main() -> int:
    args = build_parser().parse_args()
    try:
        args.handler(args)
    except (OSError, RevisionError, project.ProjectError) as exc:
        print(f"[ERROR] {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
