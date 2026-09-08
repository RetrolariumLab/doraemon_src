#!/usr/bin/env python3
"""Validate and losslessly edit World 3 room transient-spawn schedules."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any
import zlib


BANK_SIZE = 0x8000
CPU_BASE = 0x8000
FIELD_NAMES = ("type", "count", "delay")


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def crc32(data: bytes) -> str:
    return f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("World 3 transient-spawn range is outside PRG")
    return prg[offset:offset + size]


def ordered_specs(manifest: dict[str, Any]) -> list[tuple[str, dict[str, Any]]]:
    channel_count = int(manifest["channel_count"])
    result: list[tuple[str, dict[str, Any]]] = []
    for field in FIELD_NAMES:
        specs = manifest["tables"][field]
        if len(specs) != channel_count:
            raise ValueError(f"World 3 transient {field} table count differs")
        if [int(spec["channel"]) for spec in specs] != list(range(channel_count)):
            raise ValueError(f"World 3 transient {field} channels are not contiguous")
        result.extend((field, spec) for spec in specs)
    return result


def table_data(prg: bytes, manifest: dict[str, Any]) -> dict[tuple[str, int], bytes]:
    room_count = int(manifest["room_count"])
    bank = int(manifest["bank"])
    return {
        (field, int(spec["channel"])): bank_slice(
            prg, bank, number(spec["address"]), room_count
        )
        for field, spec in ordered_specs(manifest)
    }


def validate_dispatch(
    manifest: dict[str, Any], dispatch: dict[str, Any]
) -> list[str]:
    contract = manifest["initializer_dispatch"]
    matches = [
        table for table in dispatch.get("tables", [])
        if table.get("name") == contract["name"]
    ]
    if len(matches) != 1:
        return ["World 3 transient initializer dispatch is missing or duplicated"]
    table = matches[0]
    errors: list[str] = []
    for key in ("bank", "slot_count"):
        expected = int(manifest["bank"] if key == "bank" else contract[key])
        if int(table.get(key, -1)) != expected:
            errors.append(f"World 3 transient initializer {key} differs")
    if number(table.get("address", -1)) != number(contract["address"]):
        errors.append("World 3 transient initializer address differs")
    if len(table.get("targets", [])) != int(contract["slot_count"]):
        errors.append("World 3 transient initializer target count differs")
    return errors


def metrics(tables: dict[tuple[str, int], bytes], room_count: int, channel_count: int) -> dict[str, Any]:
    active = [
        [tables[("count", channel)][room] != 0 for channel in range(channel_count)]
        for room in range(room_count)
    ]
    return {
        "rooms_with_active_channels": sum(any(row) for row in active),
        "active_room_channels": sum(sum(row) for row in active),
        "active_channels_by_index": [
            sum(active[room][channel] for room in range(room_count))
            for channel in range(channel_count)
        ],
        "spawn_budgets_by_index": [
            sum(tables[("count", channel)]) for channel in range(channel_count)
        ],
        "total_spawn_budget": sum(
            sum(tables[("count", channel)]) for channel in range(channel_count)
        ),
        "zero_delay_active_channels": sum(
            tables[("count", channel)][room] != 0
            and tables[("delay", channel)][room] == 0
            for room in range(room_count)
            for channel in range(channel_count)
        ),
    }


def validate_manifest(
    prg: bytes, manifest: dict[str, Any], dispatch: dict[str, Any]
) -> tuple[list[str], dict[str, Any]]:
    if manifest.get("schema_version") != 1:
        return ["unsupported World 3 transient-spawn schema"], {}
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    errors: list[str] = []
    room_count = int(manifest["room_count"])
    channel_count = int(manifest["channel_count"])
    if room_count != 64 or channel_count != 4:
        errors.append("World 3 transient-spawn geometry differs")
    try:
        specs = ordered_specs(manifest)
    except ValueError as exc:
        errors.append(str(exc))
        return errors, {}
    addresses = [number(spec["address"]) for _field, spec in specs]
    start = number(manifest["covered_range"]["start"])
    expected_addresses = [start + room_count * index for index in range(len(specs))]
    if addresses != expected_addresses:
        errors.append("World 3 transient-spawn tables are not contiguous")
    expected_end = start + room_count * len(specs) - 1
    covered = manifest["covered_range"]
    if (
        number(covered["end"]) != expected_end
        or int(covered["byte_count"]) != room_count * len(specs)
    ):
        errors.append("World 3 transient-spawn covered range differs")
    tables = table_data(prg, manifest)
    combined = bytearray()
    for field, spec in specs:
        data = tables[(field, int(spec["channel"]))]
        combined.extend(data)
        if crc32(data) != str(spec["crc32"]).lower():
            errors.append(
                f"World 3 transient {field} channel {spec['channel']} CRC32 differs"
            )
        if sorted(set(data)) != [int(value) for value in spec["expected_values"]]:
            errors.append(
                f"World 3 transient {field} channel {spec['channel']} domain differs"
            )
    if crc32(bytes(combined)) != str(covered["crc32"]).lower():
        errors.append("World 3 transient-spawn covered CRC32 differs")
    slot_count = int(manifest["initializer_dispatch"]["slot_count"])
    if any(value >= slot_count for channel in range(channel_count) for value in tables[("type", channel)]):
        errors.append("World 3 transient type exceeds initializer dispatch")
    timing = manifest["timing"]
    if (
        int(timing["nonzero_delay_frame_divisor"]) != 4
        or timing["zero_delay_attempts_every_frame"] is not True
        or timing["phase_counters_preserved_on_room_reload"] is not True
    ):
        errors.append("World 3 transient-spawn timing contract differs")
    actual_metrics = metrics(tables, room_count, channel_count)
    expected_metrics = manifest["expected_metrics"]
    for key, value in actual_metrics.items():
        expected = expected_metrics[key]
        if value != expected:
            errors.append(f"World 3 transient-spawn metric {key} differs")
    for signature in manifest["signatures"]:
        raw = bytes.fromhex(str(signature["bytes"]))
        if bank_slice(prg, int(manifest["bank"]), number(signature["address"]), len(raw)) != raw:
            errors.append(
                f"World 3 transient-spawn signature differs at ${number(signature['address']):04X}"
            )
    errors.extend(validate_dispatch(manifest, dispatch))
    return errors, actual_metrics


def encode_authoring(document: dict[str, Any], manifest: dict[str, Any]) -> bytes:
    if document.get("schema_version") != 1 or document.get("format") != (
        "doraemon-world3-transient-spawns"
    ):
        raise ValueError("unsupported World 3 transient-spawn authoring schema")
    if int(document["bank"]) != int(manifest["bank"]):
        raise ValueError("World 3 transient spawns target the wrong PRG bank")
    room_count = int(manifest["room_count"])
    channel_count = int(manifest["channel_count"])
    rooms = document.get("rooms")
    if not isinstance(rooms, list) or len(rooms) != room_count:
        raise ValueError(f"World 3 transient spawns require {room_count} rooms")
    if [number(room.get("room_id", -1)) for room in rooms] != list(range(room_count)):
        raise ValueError("World 3 transient room IDs are not contiguous")
    columns: dict[tuple[str, int], list[int]] = {
        (field, channel): []
        for field in FIELD_NAMES
        for channel in range(channel_count)
    }
    slot_count = int(manifest["initializer_dispatch"]["slot_count"])
    for room in rooms:
        channels = room.get("channels")
        if not isinstance(channels, list) or len(channels) != channel_count:
            raise ValueError("World 3 transient room channel count differs")
        if [int(channel.get("channel", -1)) for channel in channels] != list(range(channel_count)):
            raise ValueError("World 3 transient channel indexes are not contiguous")
        for channel in channels:
            index = int(channel["channel"])
            values = {field: number(channel[field]) for field in FIELD_NAMES}
            if any(not 0 <= value <= 0xFF for value in values.values()):
                raise ValueError("World 3 transient channel byte is out of range")
            if values["type"] >= slot_count:
                raise ValueError("World 3 transient type exceeds initializer dispatch")
            for field, value in values.items():
                columns[(field, index)].append(value)
    return bytes(
        value
        for field in FIELD_NAMES
        for channel in range(channel_count)
        for value in columns[(field, channel)]
    )


def decode_authoring(
    prg: bytes, manifest: dict[str, Any], dispatch: dict[str, Any]
) -> dict[str, Any]:
    errors, _report = validate_manifest(prg, manifest, dispatch)
    if errors:
        raise ValueError("; ".join(errors))
    tables = table_data(prg, manifest)
    rooms = []
    for room in range(int(manifest["room_count"])):
        rooms.append({
            "room_id": f"0x{room:02X}",
            "channels": [
                {
                    "channel": channel,
                    "type": f"0x{tables[('type', channel)][room]:02X}",
                    "count": tables[("count", channel)][room],
                    "delay": tables[("delay", channel)][room],
                }
                for channel in range(int(manifest["channel_count"]))
            ],
        })
    result: dict[str, Any] = {
        "schema_version": 1,
        "format": "doraemon-world3-transient-spawns",
        "bank": int(manifest["bank"]),
        "rooms": rooms,
        "covered_byte_count": int(manifest["covered_range"]["byte_count"]),
        "covered_crc32": "00000000",
    }
    result["covered_crc32"] = crc32(encode_authoring(result, manifest))
    return result


def validate_authoring(
    prg: bytes,
    manifest: dict[str, Any],
    dispatch: dict[str, Any],
    path: Path,
) -> list[str]:
    document = json.loads(path.read_text(encoding="utf-8"))
    encoded = encode_authoring(document, manifest)
    canonical = encode_authoring(decode_authoring(prg, manifest, dispatch), manifest)
    errors: list[str] = []
    if len(encoded) != int(document["covered_byte_count"]):
        errors.append("World 3 transient-spawn covered-byte count differs")
    if crc32(encoded) != str(document["covered_crc32"]).lower():
        errors.append("World 3 transient-spawn authoring CRC32 differs")
    if encoded != canonical:
        errors.append("World 3 transient-spawn authoring roundtrip differs from PRG")
    return errors


def apply_authoring(prg: bytes, document: dict[str, Any], manifest: dict[str, Any]) -> bytes:
    if len(prg) != 4 * BANK_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    data = encode_authoring(document, manifest)
    result = bytearray(prg)
    offset = int(manifest["bank"]) * BANK_SIZE + number(manifest["covered_range"]["start"]) - CPU_BASE
    result[offset:offset + len(data)] = data
    return bytes(result)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    validate_parser = subparsers.add_parser("validate")
    validate_parser.add_argument("--prg", required=True, type=Path)
    validate_parser.add_argument("--manifest", required=True, type=Path)
    validate_parser.add_argument("--object-dispatch", required=True, type=Path)
    validate_parser.add_argument("--authoring", required=True, type=Path)
    decode_parser = subparsers.add_parser("decode")
    decode_parser.add_argument("--prg", required=True, type=Path)
    decode_parser.add_argument("--manifest", required=True, type=Path)
    decode_parser.add_argument("--object-dispatch", required=True, type=Path)
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
            print(f"[OK] wrote PRG with {len(encode_authoring(document, manifest))} transient-spawn bytes")
            return 0
        prg = args.prg.read_bytes()
        dispatch = json.loads(args.object_dispatch.read_text(encoding="utf-8"))
        if args.command == "decode":
            document = decode_authoring(prg, manifest, dispatch)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_text(json.dumps(document, indent=2) + "\n", encoding="utf-8", newline="\n")
            print(f"[OK] wrote World 3 transient spawns to {args.output}")
            return 0
        errors, report = validate_manifest(prg, manifest, dispatch)
        errors.extend(validate_authoring(prg, manifest, dispatch, args.authoring))
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 3 transient-spawn audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] World 3 transient spawns: {report['rooms_with_active_channels']} active rooms, "
        f"{report['active_room_channels']} active channels, "
        f"{report['total_spawn_budget']} scheduled entities"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
