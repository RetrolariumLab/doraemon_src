#!/usr/bin/env python3
"""Validate and losslessly edit World 2 conditional stage branches."""

from __future__ import annotations

import argparse
from collections import Counter
import json
from pathlib import Path
from typing import Any
import zlib


BANK_SIZE = 0x8000
CPU_BASE = 0x8000
TABLE_NAMES = (
    "trigger_screens",
    "destination_offsets",
    "condition_codes",
    "return_overrides",
)


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def crc32(data: bytes) -> str:
    return f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("World 2 stage-branch range is outside PRG")
    return prg[offset:offset + size]


def condition_maps(manifest: dict[str, Any]) -> tuple[dict[int, str], dict[str, int]]:
    by_code = {
        int(entry["code"]): str(entry["name"])
        for entry in manifest["conditions"]
    }
    if by_code != {
        0: "always",
        1: "player_y_below_0x50",
        2: "player_x_at_least_0xA0",
        3: "player_y_at_least_0xA0",
    }:
        raise ValueError("World 2 stage-branch condition contract differs")
    return by_code, {name: code for code, name in by_code.items()}


def table_data(
    prg: bytes, manifest: dict[str, Any]
) -> dict[str, bytes]:
    bank = int(manifest["bank"])
    count = int(manifest["branch_count"])
    return {
        name: bank_slice(
            prg,
            bank,
            number(manifest["tables"][name]["address"]),
            count,
        )
        for name in TABLE_NAMES
    }


def add_region(result: dict[int, int], address: int, data: bytes) -> None:
    for offset, value in enumerate(data):
        byte_address = address + offset
        if byte_address in result:
            raise ValueError("World 2 stage-branch authoring regions overlap")
        result[byte_address] = value


def encode_authoring(
    document: dict[str, Any], manifest: dict[str, Any]
) -> dict[int, int]:
    if document.get("schema_version") != 1 or document.get("format") != (
        "doraemon-world2-stage-branches"
    ):
        raise ValueError("unsupported World 2 stage-branch authoring schema")
    if int(document["bank"]) != int(manifest["bank"]):
        raise ValueError("World 2 stage branches target the wrong PRG bank")
    count = int(manifest["branch_count"])
    entries = document.get("branches")
    if not isinstance(entries, list) or len(entries) != count:
        raise ValueError(f"World 2 stage branches must contain {count} entries")
    if [int(entry.get("index", -1)) for entry in entries] != list(range(count)):
        raise ValueError("World 2 stage-branch indexes are not contiguous")
    _by_code, by_name = condition_maps(manifest)
    sequence_size = int(manifest["sequence_size"])
    columns: dict[str, list[int]] = {name: [] for name in TABLE_NAMES}
    for entry in entries:
        trigger = number(entry["trigger_screen_id"])
        destination = number(entry["destination_offset"])
        condition = str(entry["condition"])
        return_value = entry["return_offset_override"]
        if not 0 <= trigger <= 0x76:
            raise ValueError("stage-branch trigger is not a real World 2 screen")
        if not 0 <= destination < sequence_size:
            raise ValueError("stage-branch destination is outside stage sequence")
        if condition not in by_name:
            raise ValueError("unknown World 2 stage-branch condition")
        return_offset = 0 if return_value is None else number(return_value)
        if return_value is not None and not 0 < return_offset < sequence_size:
            raise ValueError("stage-branch return override is outside stage sequence")
        columns["trigger_screens"].append(trigger)
        columns["destination_offsets"].append(destination)
        columns["condition_codes"].append(by_name[condition])
        columns["return_overrides"].append(return_offset)
    result: dict[int, int] = {}
    for name in TABLE_NAMES:
        add_region(
            result,
            number(manifest["tables"][name]["address"]),
            bytes(columns[name]),
        )
    return result


def decode_authoring(
    prg: bytes, manifest: dict[str, Any]
) -> dict[str, Any]:
    errors, _report = validate_manifest(prg, manifest)
    if errors:
        raise ValueError("; ".join(errors))
    tables = table_data(prg, manifest)
    by_code, _by_name = condition_maps(manifest)
    count = int(manifest["branch_count"])
    branches = []
    for index in range(count):
        return_offset = tables["return_overrides"][index]
        branches.append(
            {
                "index": index,
                "trigger_screen_id": f"0x{tables['trigger_screens'][index]:02X}",
                "destination_offset": f"0x{tables['destination_offsets'][index]:02X}",
                "condition": by_code[tables["condition_codes"][index]],
                "return_offset_override": (
                    None if return_offset == 0 else f"0x{return_offset:02X}"
                ),
            }
        )
    result: dict[str, Any] = {
        "schema_version": 1,
        "format": "doraemon-world2-stage-branches",
        "bank": int(manifest["bank"]),
        "trigger_row": int(manifest["trigger_row"]),
        "branches": branches,
        "covered_byte_count": count * len(TABLE_NAMES),
        "covered_crc32": "00000000",
    }
    encoded = encode_authoring(result, manifest)
    result["covered_crc32"] = crc32(
        bytes(encoded[address] for address in sorted(encoded))
    )
    return result


def validate_manifest(
    prg: bytes, manifest: dict[str, Any]
) -> tuple[list[str], dict[str, int]]:
    if manifest.get("schema_version") != 1:
        return ["unsupported World 2 stage-branch schema"], {}
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    errors: list[str] = []
    count = int(manifest["branch_count"])
    if count <= 0 or int(manifest["trigger_row"]) != 13:
        errors.append("World 2 stage-branch geometry differs")
    if int(manifest["cooldown_frames"]) != 255:
        errors.append("World 2 stage-branch cooldown differs")
    try:
        by_code, _by_name = condition_maps(manifest)
    except ValueError as exc:
        errors.append(str(exc))
        by_code = {}
    tables = table_data(prg, manifest)
    for name, data in tables.items():
        if crc32(data) != str(manifest["tables"][name]["crc32"]).lower():
            errors.append(f"World 2 {name.replace('_', ' ')} CRC32 differs")
    sequence_size = int(manifest["sequence_size"])
    if any(screen > 0x76 for screen in tables["trigger_screens"]):
        errors.append("World 2 branch trigger references a non-screen selector")
    if any(offset >= sequence_size for offset in tables["destination_offsets"]):
        errors.append("World 2 branch destination is outside stage sequence")
    if any(code not in by_code for code in tables["condition_codes"]):
        errors.append("World 2 branch condition code is unknown")
    if any(
        offset >= sequence_size for offset in tables["return_overrides"]
    ):
        errors.append("World 2 branch return override is outside stage sequence")
    counts = Counter(by_code.get(code, "unknown") for code in tables["condition_codes"])
    expected_counts = {
        str(name): int(value)
        for name, value in manifest["expected_condition_counts"].items()
    }
    if counts != expected_counts:
        errors.append("World 2 stage-branch condition counts differ")
    override_count = sum(value != 0 for value in tables["return_overrides"])
    if override_count != int(manifest["expected_return_override_count"]):
        errors.append("World 2 stage-branch return-override count differs")
    signature = manifest["routine_signature"]
    raw_signature = bytes.fromhex(str(signature["bytes"]))
    if bank_slice(
        prg,
        int(manifest["bank"]),
        number(signature["address"]),
        len(raw_signature),
    ) != raw_signature:
        errors.append("World 2 stage-branch routine signature differs from PRG")
    return errors, {
        "branch_count": count,
        "conditional_count": count - counts.get("always", 0),
        "return_override_count": override_count,
    }


def validate_stage_authoring(
    prg: bytes, document: dict[str, Any], manifest: dict[str, Any]
) -> list[str]:
    errors: list[str] = []
    if document.get("format") != "doraemon-world2-stage-sequence":
        errors.append("World 2 branch audit requires stage-sequence authoring")
    if int(document.get("bank", -1)) != int(manifest["bank"]):
        errors.append("World 2 branch and stage authoring banks differ")
    entries = document.get("entries")
    sequence_size = int(manifest["sequence_size"])
    if not isinstance(entries, list) or len(entries) != sequence_size:
        errors.append("World 2 branch audit stage-sequence size differs")
        return errors
    if [int(entry.get("offset", -1)) for entry in entries] != list(
        range(sequence_size)
    ):
        errors.append("World 2 branch audit stage offsets are not contiguous")
        return errors
    screen_ids = {
        number(entry["screen_id"])
        for entry in entries
        if entry.get("command") == "select_screen"
    }
    triggers = set(table_data(prg, manifest)["trigger_screens"])
    if not triggers <= screen_ids:
        errors.append("World 2 branch trigger is absent from stage sequence")
    return errors


def validate_authoring(
    prg: bytes,
    manifest: dict[str, Any],
    authoring_path: Path,
) -> list[str]:
    document = json.loads(authoring_path.read_text(encoding="utf-8"))
    encoded = encode_authoring(document, manifest)
    canonical = encode_authoring(decode_authoring(prg, manifest), manifest)
    errors: list[str] = []
    if len(encoded) != int(document["covered_byte_count"]):
        errors.append("World 2 stage-branch covered-byte count differs")
    encoded_crc = crc32(bytes(encoded[address] for address in sorted(encoded)))
    if encoded_crc != str(document["covered_crc32"]).lower():
        errors.append("World 2 stage-branch covered-byte CRC32 differs")
    if encoded != canonical:
        errors.append("World 2 stage-branch authoring roundtrip differs from PRG")
    return errors


def apply_authoring(
    prg: bytes, document: dict[str, Any], manifest: dict[str, Any]
) -> bytes:
    if len(prg) != 4 * BANK_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    bank = int(manifest["bank"])
    result = bytearray(prg)
    for address, value in encode_authoring(document, manifest).items():
        result[bank * BANK_SIZE + address - CPU_BASE] = value
    return bytes(result)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    validate_parser = subparsers.add_parser("validate")
    validate_parser.add_argument("--prg", required=True, type=Path)
    validate_parser.add_argument("--manifest", required=True, type=Path)
    validate_parser.add_argument("--stage-authoring", required=True, type=Path)
    validate_parser.add_argument("--authoring", required=True, type=Path)
    decode_parser = subparsers.add_parser("decode")
    decode_parser.add_argument("--prg", required=True, type=Path)
    decode_parser.add_argument("--manifest", required=True, type=Path)
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
            output = apply_authoring(
                args.base_prg.read_bytes(), document, manifest
            )
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_bytes(output)
            print(f"[OK] wrote PRG with {len(encode_authoring(document, manifest))} branch bytes")
            return 0
        prg = args.prg.read_bytes()
        if args.command == "decode":
            document = decode_authoring(prg, manifest)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_text(
                json.dumps(document, indent=2) + "\n",
                encoding="utf-8",
                newline="\n",
            )
            print(f"[OK] wrote World 2 stage branches to {args.output}")
            return 0
        errors, report = validate_manifest(prg, manifest)
        stage = json.loads(args.stage_authoring.read_text(encoding="utf-8"))
        errors.extend(validate_stage_authoring(prg, stage, manifest))
        errors.extend(validate_authoring(prg, manifest, args.authoring))
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 2 stage-branch audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] World 2 stage branches: {report['branch_count']} entries, "
        f"{report['conditional_count']} conditional, "
        f"{report['return_override_count']} fixed return overrides"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
