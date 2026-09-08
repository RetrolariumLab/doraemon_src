#!/usr/bin/env python3
"""Validate and round-trip World 1 weapon sound and spawn profiles."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any
import zlib


BANK_SIZE = 0x8000
CPU_BASE = 0x8000
EXPECTED_DIRECTIONS = [
    (0, "down"),
    (1, "up"),
    (2, "left"),
    (3, "right"),
]
EXPECTED_SOUND = (
    "World1_WeaponSoundByLevelMinusOne",
    0x9C82,
    0x9C83,
    1,
    3,
    "2c878094",
)
EXPECTED_PROFILES = (
    "World1_ProjectileSpawnProfiles",
    0x9C86,
    3,
    4,
    4,
    ["x_offset", "y_offset", "metasprite", "render_flags"],
    "0ada9be4",
)
EXPECTED_SIGNATURES = [
    (
        0x9C26,
        "A4 7B B9 82 9C 20 98 E3",
    ),
    (
        0x9C2E,
        "A5 7B 38 E9 01 0A 0A 0A 0A 85 00 A5 7F 0A 0A 29 0C 05 00 A8",
    ),
    (
        0x9C42,
        "B9 86 9C C8 18 65 75 9D DE 04 B9 86 9C C8 18 65 76 9D 0E 05 "
        "B9 86 9C C8 9D 4E 04 B9 86 9C C8 9D 7E 04",
    ),
]


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def crc32(data: bytes) -> str:
    return f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    if len(prg) != 4 * BANK_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("World 1 weapon range is outside PRG")
    return prg[offset:offset + size]


def sound_layout(spec: dict[str, Any]) -> tuple[object, ...]:
    return (
        str(spec["operand_symbol"]),
        number(spec["operand_address"]),
        number(spec["data_address"]),
        int(spec["level_first"]),
        int(spec["count"]),
        str(spec["crc32"]).lower(),
    )


def profile_layout(spec: dict[str, Any]) -> tuple[object, ...]:
    return (
        str(spec["symbol"]),
        number(spec["address"]),
        int(spec["level_count"]),
        int(spec["direction_count"]),
        int(spec["record_size"]),
        [str(field) for field in spec["fields"]],
        str(spec["crc32"]).lower(),
    )


def matching_symbol(
    registry: dict[str, Any],
    name: str,
    address: int,
    bank: int,
) -> bool:
    matches = [
        entry for entry in registry.get("symbols", [])
        if entry.get("name") == name
    ]
    return (
        len(matches) == 1
        and number(matches[0]["address"]) == address
        and int(matches[0].get("bank", -1)) == bank
        and matches[0].get("operand_symbol") is True
    )


def validate_manifest(
    prg: bytes,
    manifest: dict[str, Any],
    registry: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if manifest.get("schema_version") != 1:
        return ["unsupported World 1 weapon schema"], {}
    try:
        bank = int(manifest["bank"])
        directions = [
            (int(entry["value"]), str(entry["name"]))
            for entry in manifest["directions"]
        ]
        sound = sound_layout(manifest["sound_effects"])
        profiles = profile_layout(manifest["projectile_profiles"])
        signatures = [
            (number(entry["address"]), str(entry["bytes"]).upper())
            for entry in manifest["signatures"]
        ]
        sound_data = bank_slice(prg, bank, sound[2], sound[4])
        profile_size = profiles[2] * profiles[3] * profiles[4]
        profile_data = bank_slice(prg, bank, profiles[1], profile_size)
    except (KeyError, TypeError, ValueError) as exc:
        return [str(exc)], {}
    errors: list[str] = []
    if bank != 0:
        errors.append("World 1 weapons must belong to PRG bank 0")
    if directions != EXPECTED_DIRECTIONS:
        errors.append("World 1 weapon direction domain differs")
    if sound != EXPECTED_SOUND:
        errors.append("World 1 weapon sound-table contract differs")
    if profiles != EXPECTED_PROFILES:
        errors.append("World 1 projectile-profile contract differs")
    if signatures != EXPECTED_SIGNATURES:
        errors.append("World 1 weapon code-signature contract differs")
    if sound[2] + sound[4] != profiles[1]:
        errors.append("World 1 weapon tables are not contiguous")
    if crc32(sound_data) != sound[5]:
        errors.append("World 1 weapon sound-table CRC32 differs")
    if crc32(profile_data) != profiles[6]:
        errors.append("World 1 projectile-profile CRC32 differs")
    for address, signature in signatures:
        raw = bytes.fromhex(signature)
        if bank_slice(prg, bank, address, len(raw)) != raw:
            errors.append(f"World 1 weapon signature differs at ${address:04X}")
    if not matching_symbol(registry, sound[0], sound[1], bank):
        errors.append("World 1 weapon sound operand symbol differs")
    if not matching_symbol(registry, profiles[0], profiles[1], bank):
        errors.append("World 1 projectile-profile symbol differs")
    return errors, {
        "level_count": sound[4],
        "profile_count": profiles[2] * profiles[3],
        "covered_byte_count": len(sound_data) + len(profile_data),
        "signature_count": len(signatures),
    }


def encode_authoring(
    document: dict[str, Any], manifest: dict[str, Any]
) -> bytes:
    if document.get("schema_version") != 1 or document.get("format") != (
        "doraemon-world1-weapons"
    ):
        raise ValueError("unsupported World 1 weapon authoring schema")
    if int(document["bank"]) != int(manifest["bank"]):
        raise ValueError("World 1 weapon authoring bank differs")
    levels = document.get("levels")
    level_count = int(manifest["sound_effects"]["count"])
    if not isinstance(levels, list) or len(levels) != level_count:
        raise ValueError(f"World 1 weapon authoring requires {level_count} levels")
    if [int(level.get("level", -1)) for level in levels] != list(
        range(1, level_count + 1)
    ):
        raise ValueError("World 1 weapon levels are not contiguous")
    direction_contract = [
        (int(entry["value"]), str(entry["name"]))
        for entry in manifest["directions"]
    ]
    sounds: list[int] = []
    profiles: list[int] = []
    fields = [str(field) for field in manifest["projectile_profiles"]["fields"]]
    for level in levels:
        sounds.append(number(level["sound_effect"]))
        directions = level.get("directions")
        if not isinstance(directions, list) or [
            (int(entry.get("value", -1)), str(entry.get("name", "")))
            for entry in directions
        ] != direction_contract:
            raise ValueError("World 1 weapon directions differ")
        for direction in directions:
            profiles.extend(number(direction[field]) for field in fields)
    values = sounds + profiles
    if any(not 0 <= value <= 0xFF for value in values):
        raise ValueError("World 1 weapon authoring byte is outside range")
    return bytes(values)


def decode_authoring(
    prg: bytes,
    manifest: dict[str, Any],
    registry: dict[str, Any],
) -> dict[str, Any]:
    errors, _report = validate_manifest(prg, manifest, registry)
    if errors:
        raise ValueError("; ".join(errors))
    bank = int(manifest["bank"])
    sound = manifest["sound_effects"]
    profiles = manifest["projectile_profiles"]
    sounds = bank_slice(
        prg, bank, number(sound["data_address"]), int(sound["count"])
    )
    record_size = int(profiles["record_size"])
    direction_count = int(profiles["direction_count"])
    profile_data = bank_slice(
        prg,
        bank,
        number(profiles["address"]),
        len(sounds) * direction_count * record_size,
    )
    fields = [str(field) for field in profiles["fields"]]
    direction_contract = manifest["directions"]
    levels = []
    cursor = 0
    for level_index, sound_effect in enumerate(sounds, start=1):
        directions = []
        for direction in direction_contract:
            raw = profile_data[cursor:cursor + record_size]
            cursor += record_size
            directions.append({
                "value": int(direction["value"]),
                "name": str(direction["name"]),
                **{
                    field: f"0x{value:02X}"
                    for field, value in zip(fields, raw)
                },
            })
        levels.append({
            "level": level_index,
            "sound_effect": f"0x{sound_effect:02X}",
            "directions": directions,
        })
    encoded = sounds + profile_data
    return {
        "schema_version": 1,
        "format": "doraemon-world1-weapons",
        "bank": bank,
        "address": sound["data_address"],
        "levels": levels,
        "covered_byte_count": len(encoded),
        "covered_crc32": crc32(encoded),
    }


def validate_authoring(
    prg: bytes,
    manifest: dict[str, Any],
    registry: dict[str, Any],
    path: Path,
) -> list[str]:
    document = json.loads(path.read_text(encoding="utf-8"))
    encoded = encode_authoring(document, manifest)
    canonical = encode_authoring(
        decode_authoring(prg, manifest, registry), manifest
    )
    errors: list[str] = []
    if len(encoded) != int(document["covered_byte_count"]):
        errors.append("World 1 weapon covered-byte count differs")
    if crc32(encoded) != str(document["covered_crc32"]).lower():
        errors.append("World 1 weapon covered-byte CRC32 differs")
    if encoded != canonical:
        errors.append("World 1 weapon authoring roundtrip differs from PRG")
    return errors


def apply_authoring(
    prg: bytes,
    document: dict[str, Any],
    manifest: dict[str, Any],
) -> bytes:
    if len(prg) != 4 * BANK_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    result = bytearray(prg)
    data = encode_authoring(document, manifest)
    bank = int(manifest["bank"])
    address = number(manifest["sound_effects"]["data_address"])
    offset = bank * BANK_SIZE + address - CPU_BASE
    result[offset:offset + len(data)] = data
    return bytes(result)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    validate_parser = subparsers.add_parser("validate")
    validate_parser.add_argument("--prg", required=True, type=Path)
    validate_parser.add_argument("--manifest", required=True, type=Path)
    validate_parser.add_argument("--symbols", required=True, type=Path)
    validate_parser.add_argument("--authoring", required=True, type=Path)
    decode_parser = subparsers.add_parser("decode")
    decode_parser.add_argument("--prg", required=True, type=Path)
    decode_parser.add_argument("--manifest", required=True, type=Path)
    decode_parser.add_argument("--symbols", required=True, type=Path)
    decode_parser.add_argument("--output", required=True, type=Path)
    encode_parser = subparsers.add_parser("encode")
    encode_parser.add_argument("--input", required=True, type=Path)
    encode_parser.add_argument("--manifest", required=True, type=Path)
    encode_parser.add_argument("--base-prg", required=True, type=Path)
    encode_parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    try:
        manifest = json.loads(args.manifest.read_text(encoding="utf-8"))
        if args.command == "encode":
            document = json.loads(args.input.read_text(encoding="utf-8"))
            result = apply_authoring(args.base_prg.read_bytes(), document, manifest)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_bytes(result)
            print(
                f"[OK] wrote PRG with "
                f"{len(encode_authoring(document, manifest))} weapon bytes"
            )
            return 0
        prg = args.prg.read_bytes()
        registry = json.loads(args.symbols.read_text(encoding="utf-8"))
        if args.command == "decode":
            document = decode_authoring(prg, manifest, registry)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_text(
                json.dumps(document, indent=2) + "\n",
                encoding="utf-8",
                newline="\n",
            )
            print(f"[OK] wrote World 1 weapons to {args.output}")
            return 0
        errors, report = validate_manifest(prg, manifest, registry)
        errors.extend(
            validate_authoring(
                prg, manifest, registry, args.authoring
            )
        )
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 1 weapon audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] World 1 weapons: {report['level_count']} levels, "
        f"{report['profile_count']} directional profiles, "
        f"{report['covered_byte_count']} lossless bytes, "
        f"{report['signature_count']} code signatures"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
