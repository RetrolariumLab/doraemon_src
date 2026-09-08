#!/usr/bin/env python3
"""Validate and describe the map regions documented by CadEditor."""

from __future__ import annotations

import argparse
from dataclasses import dataclass
import json
from pathlib import Path
import sys
import zlib

from scripts.build import project


@dataclass(frozen=True)
class Region:
    name: str
    file_offset: int
    size: int
    crc32: str
    width: int | None = None
    height: int | None = None
    records: int | None = None


REGIONS = (
    Region("world1_block_attributes", 0x29FF, 256, "6a49bda5", records=256),
    Region("world1_small_blocks", 0x2AFF, 1024, "af4f410e", records=256),
    Region("world1_big_blocks", 0x2EFF, 1024, "aaf5256c", records=256),
    Region("world1_city_map", 0x32FF, 4096, "4e576e12", width=64, height=64),
    Region("world1_underground_map", 0x42FF, 1600, "b4ea516e", width=64, height=25),
    Region("world2_block_attributes", 0xB9DE, 256, "fd3d21af", records=256),
    Region("world2_small_blocks_cadeditor", 0xBAAF, 1024, "e0f20f28", records=256),
    Region("world2_screens", 0xBDFC, 14400, "3a888a6f", width=16, height=15, records=60),
    Region("world3_block_attributes", 0x15E02, 256, "34675935", records=256),
    Region("world3_small_blocks", 0x15F02, 1024, "bcb462ed", records=256),
    Region("world3_big_blocks", 0x16302, 1024, "03edd061", records=256),
    Region("world3_map", 0x16702, 4096, "52f49b90", width=64, height=64),
)


class MapDataError(ValueError):
    pass


def crc32(payload: bytes) -> str:
    return f"{zlib.crc32(payload) & 0xFFFFFFFF:08x}"


def inspect(image: Path) -> dict[str, object]:
    data = image.read_bytes()
    manifest = project.load_manifest(project.ROOT / "assets" / "manifest.json")
    project.validate_image(data, manifest)
    report: list[dict[str, object]] = []
    for region in REGIONS:
        end = region.file_offset + region.size
        if end > len(data):
            raise MapDataError(f"{region.name} extends beyond the image")
        payload = data[region.file_offset:end]
        actual_crc = crc32(payload)
        if actual_crc != region.crc32:
            raise MapDataError(
                f"{region.name} CRC32 is {actual_crc}, expected {region.crc32}"
            )
        item: dict[str, object] = {
            "name": region.name,
            "file_offset": f"0x{region.file_offset:X}",
            "size": region.size,
            "crc32": actual_crc,
            "distinct_values": len(set(payload)),
        }
        if region.width is not None:
            item["width"] = region.width
            item["height"] = region.height
        if region.records is not None:
            item["records"] = region.records
        report.append(item)
    overlap_start = 0xBDFC
    overlap_end = 0xBAAF + 1024
    return {
        "source": "CadEditor Doraemon settings",
        "offset_basis": "complete iNES file including 16-byte header",
        "regions": report,
        "world2_declared_overlap": {
            "start": f"0x{overlap_start:X}",
            "end_exclusive": f"0x{overlap_end:X}",
            "bytes": overlap_end - overlap_start,
            "note": "CadEditor reads 256 blocks, but the final 179 bytes overlap screen data",
        },
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--image", required=True)
    parser.add_argument("--validate", action="store_true")
    parser.add_argument("--pretty", action="store_true")
    args = parser.parse_args()
    try:
        report = inspect(Path(args.image))
        if args.validate:
            print(f"[OK] validated {len(REGIONS)} CadEditor map regions")
        else:
            print(json.dumps(report, indent=2 if args.pretty else None))
    except (OSError, MapDataError, project.ProjectError) as exc:
        print(f"[ERROR] {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
