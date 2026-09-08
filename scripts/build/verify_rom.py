#!/usr/bin/env python3
"""Compare built Doraemon images and private assets with the original."""

from __future__ import annotations

import argparse
from pathlib import Path
import sys

from scripts.build import project


REGIONS = ("header", "prg", "chr", "payload", "rom")
PRG_BANK_SIZE = 0x8000
CHR_BANK_SIZE = 0x2000


class VerificationError(ValueError):
    pass


def split_regions(path: Path, manifest: dict[str, object]) -> dict[str, bytes]:
    data = path.read_bytes()
    parsed = project.validate_image(data, manifest)
    return {
        "header": parsed["header"],
        "prg": parsed["prg"],
        "chr": parsed["chr"],
        "payload": parsed["payload"],
        "rom": data,
    }


def first_difference(left: bytes, right: bytes) -> int | None:
    for offset, (a, b) in enumerate(zip(left, right)):
        if a != b:
            return offset
    if len(left) != len(right):
        return min(len(left), len(right))
    return None


def describe_offset(region: str, offset: int, header_size: int, prg_size: int) -> str:
    if region == "prg":
        bank, bank_offset = divmod(offset, PRG_BANK_SIZE)
        return f"PRG bank {bank} + ${bank_offset:04X}, CPU ${0x8000 + bank_offset:04X}"
    if region == "chr":
        bank, bank_offset = divmod(offset, CHR_BANK_SIZE)
        return f"CHR bank {bank} + ${bank_offset:04X}"
    if region == "payload":
        if offset < prg_size:
            return describe_offset("prg", offset, header_size, prg_size)
        return describe_offset("chr", offset - prg_size, header_size, prg_size)
    if region == "rom":
        if offset < header_size:
            return f"header + ${offset:02X}"
        if offset < header_size + prg_size:
            return describe_offset("prg", offset - header_size, header_size, prg_size)
        return describe_offset("chr", offset - header_size - prg_size, header_size, prg_size)
    return f"header + ${offset:02X}"


def command_compare(args: argparse.Namespace) -> None:
    manifest = project.load_manifest(Path(args.manifest))
    built = split_regions(Path(args.built), manifest)
    reference = split_regions(Path(args.reference), manifest)
    region = args.region
    offset = first_difference(built[region], reference[region])
    if offset is not None:
        ref = manifest["reference_rom"]
        detail = describe_offset(region, offset, int(ref["header_size"]), int(ref["prg_size"]))
        actual = built[region][offset] if offset < len(built[region]) else None
        expected = reference[region][offset] if offset < len(reference[region]) else None
        raise VerificationError(
            f"{region} differs at {detail}: built={actual!r}, reference={expected!r}"
        )
    print(f"[OK] {region}: {len(built[region])} byte-identical bytes")


def command_asset(args: argparse.Namespace) -> None:
    manifest = project.load_manifest(Path(args.manifest))
    reference = split_regions(Path(args.reference), manifest)
    payload = Path(args.asset).read_bytes()
    offset = first_difference(payload, reference[args.region])
    if offset is not None:
        raise VerificationError(f"asset differs from reference {args.region} at offset ${offset:X}")
    print(f"[OK] asset matches {args.region}: {args.asset}")


def command_report(args: argparse.Namespace) -> None:
    path = Path(args.image)
    manifest = project.load_manifest(Path(args.manifest))
    parsed, facts = project.image_facts(path.read_bytes())
    project.validate_image(path.read_bytes(), manifest)
    print(
        f"{path}: mapper={parsed['mapper']} mirroring={parsed['mirroring']} "
        f"PRG={parsed['prg_size']} CHR={parsed['chr_size']} payload_crc32={facts['payload_crc32']}"
    )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    compare = subparsers.add_parser("compare")
    compare.add_argument("--built", required=True)
    compare.add_argument("--reference", required=True)
    compare.add_argument("--manifest", required=True)
    compare.add_argument("--region", choices=REGIONS, required=True)
    compare.set_defaults(handler=command_compare)
    asset = subparsers.add_parser("asset")
    asset.add_argument("--asset", required=True)
    asset.add_argument("--reference", required=True)
    asset.add_argument("--manifest", required=True)
    asset.add_argument("--region", choices=("header", "prg", "chr"), required=True)
    asset.set_defaults(handler=command_asset)
    report = subparsers.add_parser("report")
    report.add_argument("--image", required=True)
    report.add_argument("--manifest", required=True)
    report.set_defaults(handler=command_report)
    args = parser.parse_args()
    try:
        args.handler(args)
    except (OSError, VerificationError, project.ProjectError) as exc:
        print(f"[ERROR] {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
