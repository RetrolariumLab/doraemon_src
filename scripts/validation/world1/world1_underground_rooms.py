#!/usr/bin/env python3
"""Validate and round-trip World 1 underground room profiles."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any
import zlib


BANK_SIZE = 0x8000
CPU_BASE = 0x8000
EXPECTED_ROOM_COUNT = 9
EXPECTED_RECORD_SIZE = 4
EXPECTED_CAMERA = (
    "World1_UndergroundRoomCameraProfiles",
    0xD1EF,
    ["camera_tile_x", "camera_tile_y", "axis_scroll_limit", "axis_scroll_start"],
    "de13ee13",
)
EXPECTED_ENTRY = (
    "World1_UndergroundRoomEntryProfiles",
    0xD213,
    [
        "player_x",
        "player_y",
        "negative_axis_city_return_id",
        "positive_axis_city_return_id",
    ],
    0xFF,
    "989a5bec",
)
EXPECTED_CITY_RETURN = (
    "World1_CityReturnProfiles",
    0xD37E,
    ["camera_tile_x", "camera_tile_y", "manhole_x", "manhole_y"],
    "f02b2689",
)
EXPECTED_RETURN_ROUTINE = (
    "World1_ReturnFromUndergroundToCity",
    0xD2C3,
    187,
    [0xCEBF, 0xD3C8],
    (
        "48 A9 00 8D AA 02 8D AB 02 85 82 85 83 85 B2 20 5F C9 20 6A C9 "
        "20 3E C9 20 49 C9 20 54 C9 68 0A 0A AA BD 7E D3 85 5B BD 7F D3 "
        "85 5C BD 80 D3 8D E6 04 18 69 04 85 75 BD 81 D3 8D 16 05 38 E9 "
        "14 85 76 A9 00 85 79 A9 00 85 77 A9 00 85 7F A9 00 85 78 A9 00 "
        "85 7A 20 14 96 A9 EF 85 66 A9 B2 85 67 A9 89 85 68 A9 D9 85 69 "
        "A9 00 85 29 A5 5C C9 40 B0 04 A9 01 85 29 A2 00 BD 80 06 9D A0 "
        "06 BD 90 06 9D 80 06 E8 E0 10 D0 EF 20 5F C9 20 6A C9 20 BD 83 "
        "20 35 95 20 DB A7 20 3B 84 20 ED 95 A2 00 20 F1 94 8A 4A 4A A8 "
        "B9 A2 D3 18 65 76 85 76 E8 E0 1C D0 EC A2 7F 9A 4C C1 82"
    ),
)
EXPECTED_SIGNATURES = [
    (
        0xCDE3,
        "A5 85 0A 0A A8 A9 01 85 51 A9 00 85 79 B9 13 D2 85 75 "
        "B9 14 D2 85 76 B9 15 D2 85 86 B9 16 D2 85 87 B9 EF D1 "
        "85 5B B9 F0 D1 85 5C B9 F1 D1 85 88 B9 F2 D1 85 89",
    ),
    (
        0xCEAB,
        "A5 8B D0 36 A5 86 85 00 A5 89 F0 04 A5 87 85 00 A5 00 "
        "30 96 4C C3 D2",
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
        raise ValueError("World 1 underground room range is outside PRG")
    return prg[offset:offset + size]


def table_layout(spec: dict[str, Any], entry: bool) -> tuple[object, ...]:
    values: list[object] = [
        str(spec["symbol"]),
        number(spec["address"]),
        [str(field) for field in spec["fields"]],
    ]
    if entry:
        values.append(number(spec["no_city_return_sentinel"]))
    values.append(str(spec["crc32"]).lower())
    return tuple(values)


def direct_jump_callsites(prg_bank: bytes, target: int) -> list[int]:
    pattern = bytes((0x4C, target & 0xFF, target >> 8))
    return [
        CPU_BASE + offset
        for offset in range(len(prg_bank) - 2)
        if prg_bank[offset:offset + 3] == pattern
    ]


def matching_symbol(
    registry: dict[str, Any],
    name: str,
    address: int,
    bank: int,
    operand: bool = True,
) -> bool:
    matches = [
        item for item in registry.get("symbols", [])
        if item.get("name") == name
    ]
    return (
        len(matches) == 1
        and number(matches[0]["address"]) == address
        and int(matches[0].get("bank", -1)) == bank
        and matches[0].get("operand_symbol", False) is operand
    )


def validate_manifest(
    prg: bytes,
    manifest: dict[str, Any],
    registry: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if manifest.get("schema_version") != 1:
        return ["unsupported World 1 underground room schema"], {}
    try:
        bank = int(manifest["bank"])
        room_count = int(manifest["room_count"])
        record_size = int(manifest["record_size"])
        camera = table_layout(manifest["camera_profiles"], False)
        entry = table_layout(manifest["entry_profiles"], True)
        city_return = table_layout(manifest["city_return_profiles"], False)
        return_spec = manifest["return_routine"]
        return_routine = (
            str(return_spec["name"]),
            number(return_spec["address"]),
            int(return_spec["size"]),
            [number(site) for site in return_spec["jump_callsites"]],
            str(return_spec["bytes"]).upper(),
        )
        signatures = [
            (number(item["address"]), str(item["bytes"]).upper())
            for item in manifest["signatures"]
        ]
        table_size = room_count * record_size
        camera_data = bank_slice(prg, bank, camera[1], table_size)
        entry_data = bank_slice(prg, bank, entry[1], table_size)
        city_return_data = bank_slice(prg, bank, city_return[1], table_size)
        bank_data = bank_slice(prg, bank, CPU_BASE, BANK_SIZE)
    except (KeyError, TypeError, ValueError) as exc:
        return [str(exc)], {}
    errors: list[str] = []
    if bank != 0:
        errors.append("World 1 underground rooms must belong to PRG bank 0")
    if room_count != EXPECTED_ROOM_COUNT or record_size != EXPECTED_RECORD_SIZE:
        errors.append("World 1 underground room geometry differs")
    if camera != EXPECTED_CAMERA:
        errors.append("World 1 underground camera-profile contract differs")
    if entry != EXPECTED_ENTRY:
        errors.append("World 1 underground entry-profile contract differs")
    if city_return != EXPECTED_CITY_RETURN:
        errors.append("World 1 city-return profile contract differs")
    if return_routine != EXPECTED_RETURN_ROUTINE:
        errors.append("World 1 city-return routine contract differs")
    if signatures != EXPECTED_SIGNATURES:
        errors.append("World 1 underground room signatures differ")
    if camera[1] + table_size != entry[1]:
        errors.append("World 1 underground room tables are not contiguous")
    if crc32(camera_data) != camera[3]:
        errors.append("World 1 underground camera-profile CRC32 differs")
    if crc32(entry_data) != entry[4]:
        errors.append("World 1 underground entry-profile CRC32 differs")
    if crc32(city_return_data) != city_return[3]:
        errors.append("World 1 city-return profile CRC32 differs")
    for table in (camera, entry, city_return):
        if not matching_symbol(registry, table[0], table[1], bank):
            errors.append(f"World 1 underground room symbol differs: {table[0]}")
    (
        routine_name,
        routine_address,
        routine_size,
        expected_jumps,
        encoded_routine,
    ) = return_routine
    if not matching_symbol(
        registry, routine_name, routine_address, bank, operand=False
    ):
        errors.append("World 1 city-return routine symbol differs")
    routine_bytes = bytes.fromhex(encoded_routine)
    if len(routine_bytes) != routine_size:
        errors.append("World 1 city-return routine size differs")
    elif bank_slice(prg, bank, routine_address, routine_size) != routine_bytes:
        errors.append("World 1 city-return routine bytes differ")
    if expected_jumps != sorted(set(expected_jumps)):
        errors.append("World 1 city-return jump callsites are not canonical")
    if direct_jump_callsites(bank_data, routine_address) != expected_jumps:
        errors.append("World 1 city-return jump callsites differ")
    for address, encoded in signatures:
        raw = bytes.fromhex(encoded)
        if bank_slice(prg, bank, address, len(raw)) != raw:
            errors.append(
                f"World 1 underground room signature differs at ${address:04X}"
            )
    return errors, {
        "room_count": room_count,
        "covered_byte_count": (
            len(camera_data) + len(entry_data) + len(city_return_data)
        ),
        "signature_count": len(signatures),
        "return_jump_count": len(expected_jumps),
    }


def encode_city_return(value: object, return_count: int, sentinel: int) -> int:
    if value is None:
        return sentinel
    destination = number(value)
    if not 0 <= destination < return_count:
        raise ValueError("World 1 underground city return is outside return domain")
    return destination


def encode_authoring(
    document: dict[str, Any], manifest: dict[str, Any]
) -> bytes:
    if document.get("schema_version") != 1 or document.get("format") != (
        "doraemon-world1-underground-rooms"
    ):
        raise ValueError("unsupported World 1 underground room authoring schema")
    if int(document["bank"]) != int(manifest["bank"]):
        raise ValueError("World 1 underground room authoring bank differs")
    room_count = int(manifest["room_count"])
    rooms = document.get("rooms")
    if not isinstance(rooms, list) or len(rooms) != room_count:
        raise ValueError(f"World 1 underground authoring requires {room_count} rooms")
    if [int(room.get("room_id", -1)) for room in rooms] != list(range(room_count)):
        raise ValueError("World 1 underground room IDs are not contiguous")
    city_returns = document.get("city_returns")
    if not isinstance(city_returns, list) or len(city_returns) != room_count:
        raise ValueError(
            f"World 1 underground authoring requires {room_count} city returns"
        )
    if [int(item.get("return_id", -1)) for item in city_returns] != list(
        range(room_count)
    ):
        raise ValueError("World 1 city return IDs are not contiguous")
    camera_fields = [str(x) for x in manifest["camera_profiles"]["fields"]]
    entry_fields = [str(x) for x in manifest["entry_profiles"]["fields"]]
    return_fields = [
        str(x) for x in manifest["city_return_profiles"]["fields"]
    ]
    sentinel = number(manifest["entry_profiles"]["no_city_return_sentinel"])
    camera: list[int] = []
    entry: list[int] = []
    return_data: list[int] = []
    for room in rooms:
        camera.extend(number(room[field]) for field in camera_fields)
        entry.extend(number(room[field]) for field in entry_fields[:2])
        entry.extend(
            encode_city_return(room[field], room_count, sentinel)
            for field in entry_fields[2:]
        )
    for city_return in city_returns:
        return_data.extend(number(city_return[field]) for field in return_fields)
    values = camera + entry + return_data
    if any(not 0 <= value <= 0xFF for value in values):
        raise ValueError("World 1 underground room byte is outside range")
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
    room_count = int(manifest["room_count"])
    record_size = int(manifest["record_size"])
    camera_spec = manifest["camera_profiles"]
    entry_spec = manifest["entry_profiles"]
    return_spec = manifest["city_return_profiles"]
    table_size = room_count * record_size
    camera = bank_slice(prg, bank, number(camera_spec["address"]), table_size)
    entry = bank_slice(prg, bank, number(entry_spec["address"]), table_size)
    return_data = bank_slice(
        prg, bank, number(return_spec["address"]), table_size
    )
    camera_fields = [str(x) for x in camera_spec["fields"]]
    entry_fields = [str(x) for x in entry_spec["fields"]]
    return_fields = [str(x) for x in return_spec["fields"]]
    sentinel = number(entry_spec["no_city_return_sentinel"])
    rooms = []
    for room_id in range(room_count):
        start = room_id * record_size
        camera_row = camera[start:start + record_size]
        entry_row = entry[start:start + record_size]
        room: dict[str, Any] = {"room_id": room_id}
        room.update({
            field: f"0x{value:02X}"
            for field, value in zip(camera_fields, camera_row)
        })
        room.update({
            field: f"0x{value:02X}"
            for field, value in zip(entry_fields[:2], entry_row[:2])
        })
        room.update({
            field: None if value == sentinel else value
            for field, value in zip(entry_fields[2:], entry_row[2:])
        })
        rooms.append(room)
    city_returns = []
    for return_id in range(room_count):
        start = return_id * record_size
        row = return_data[start:start + record_size]
        city_returns.append({
            "return_id": return_id,
            **{
                field: f"0x{value:02X}"
                for field, value in zip(return_fields, row)
            },
        })
    encoded = camera + entry + return_data
    return {
        "schema_version": 1,
        "format": "doraemon-world1-underground-rooms",
        "bank": bank,
        "address": camera_spec["address"],
        "rooms": rooms,
        "city_returns": city_returns,
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
    canonical = encode_authoring(decode_authoring(prg, manifest, registry), manifest)
    errors: list[str] = []
    if len(encoded) != int(document["covered_byte_count"]):
        errors.append("World 1 underground covered-byte count differs")
    if crc32(encoded) != str(document["covered_crc32"]).lower():
        errors.append("World 1 underground covered-byte CRC32 differs")
    if encoded != canonical:
        errors.append("World 1 underground room authoring differs from PRG")
    return errors


def apply_authoring(
    prg: bytes, document: dict[str, Any], manifest: dict[str, Any]
) -> bytes:
    if len(prg) != 4 * BANK_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    result = bytearray(prg)
    encoded = encode_authoring(document, manifest)
    bank = int(manifest["bank"])
    table_size = int(manifest["room_count"]) * int(manifest["record_size"])
    room_address = number(manifest["camera_profiles"]["address"])
    room_offset = bank * BANK_SIZE + room_address - CPU_BASE
    room_size = 2 * table_size
    result[room_offset:room_offset + room_size] = encoded[:room_size]
    return_address = number(manifest["city_return_profiles"]["address"])
    return_offset = bank * BANK_SIZE + return_address - CPU_BASE
    result[return_offset:return_offset + table_size] = encoded[room_size:]
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
            output = apply_authoring(args.base_prg.read_bytes(), document, manifest)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_bytes(output)
            print(
                "[OK] wrote PRG with "
                f"{len(encode_authoring(document, manifest))} underground-profile bytes"
            )
            return 0
        prg = args.prg.read_bytes()
        registry = json.loads(args.symbols.read_text(encoding="utf-8"))
        if args.command == "decode":
            document = decode_authoring(prg, manifest, registry)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_text(
                json.dumps(document, indent=2) + "\n", encoding="utf-8", newline="\n"
            )
            print(f"[OK] wrote World 1 underground rooms to {args.output}")
            return 0
        errors, report = validate_manifest(prg, manifest, registry)
        errors.extend(validate_authoring(prg, manifest, registry, args.authoring))
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 1 underground room audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] World 1 underground rooms: {report['room_count']} profiles, "
        f"{report['covered_byte_count']} lossless bytes, "
        f"{report['signature_count']} code signatures, "
        f"{report['return_jump_count']} city-return jumps"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
