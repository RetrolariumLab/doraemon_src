#!/usr/bin/env python3
"""Validate World 2 enemy token, runtime-state, and property contracts."""

from __future__ import annotations

import argparse
from collections import Counter
import json
from pathlib import Path
from typing import Any
import zlib


BANK_SIZE = 0x8000
CPU_BASE = 0x8000


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def crc32(data: bytes) -> str:
    return f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("World 2 enemy-state range is outside PRG")
    return prg[offset:offset + size]


def named_entry(entries: Any, name: str, description: str) -> dict[str, Any]:
    matches = [entry for entry in entries if entry.get("name") == name]
    if len(matches) != 1:
        raise ValueError(f"expected one {description} named {name!r}")
    return matches[0]


def rts_minus_one_bytes(targets: list[str | int]) -> bytes:
    return b"".join(
        (number(target) - 1).to_bytes(2, "little") for target in targets
    )


def authoring_spawn_counts(
    authoring: dict[str, Any],
) -> tuple[Counter[int], int]:
    result: Counter[int] = Counter()
    spawn_offsets: set[int] = set()
    for token in authoring["tokens"]:
        parts = str(token).split(":")
        if len(parts) >= 3 and parts[1] == "S":
            result[int(parts[2], 16)] += 1
            spawn_offsets.add(int(parts[0], 16))
    selector_total = 0
    for selector in authoring["selectors"]:
        for row in selector["rows"]:
            extent = str(row).split(":", 1)[0]
            start_text, end_text = extent.split("-", 1)
            start = int(start_text, 16)
            end = int(end_text, 16)
            selector_total += sum(start <= offset < end for offset in spawn_offsets)
    return result, selector_total


def indexed_entries(
    entries: Any,
    count: int,
    description: str,
) -> list[dict[str, Any]]:
    if not isinstance(entries, list) or len(entries) != count:
        raise ValueError(f"{description} must contain {count} entries")
    if [int(entry.get("id", -1)) for entry in entries] != list(range(count)):
        raise ValueError(f"{description} ids are not contiguous")
    return entries


def add_region(
    result: dict[int, int],
    address: int,
    data: bytes,
    description: str,
) -> None:
    for offset, value in enumerate(data):
        byte_address = address + offset
        previous = result.get(byte_address)
        if previous is not None and previous != value:
            raise ValueError(
                f"{description} conflicts with another property at "
                f"${byte_address:04X}"
            )
        result[byte_address] = value


def encode_authoring(document: dict[str, Any]) -> dict[int, int]:
    if document.get("schema_version") != 1 or document.get("format") != (
        "doraemon-world2-enemy-states"
    ):
        raise ValueError("unsupported World 2 enemy-state authoring schema")
    if int(document["bank"]) != 1:
        raise ValueError("World 2 enemy-state authoring must target PRG bank 1")
    state_count = int(document["state_count"])
    records = indexed_entries(
        document["records"], state_count + 1, "enemy state records"
    )
    property_names = [str(name) for name in document["properties"]]
    if not property_names or len(property_names) != len(set(property_names)):
        raise ValueError("enemy-state property names must be non-empty and unique")
    addresses = document["property_addresses"]
    if list(addresses) != property_names:
        raise ValueError("enemy-state property address order differs")
    result: dict[int, int] = {}
    for name in property_names:
        values = []
        for record in records:
            value = number(record[name])
            if not 0 <= value <= 0xFF:
                raise ValueError(f"enemy-state {name} value is outside byte range")
            values.append(value)
        add_region(result, number(addresses[name]), bytes(values), name)
    return result


def decode_authoring(
    prg: bytes,
    manifest: dict[str, Any],
    object_dispatch: dict[str, Any],
    screen_authoring: dict[str, Any],
) -> dict[str, Any]:
    errors, _report = validate(
        prg, manifest, object_dispatch, screen_authoring
    )
    if errors:
        raise ValueError("; ".join(errors))
    bank = int(manifest["bank"])
    state_count = int(manifest["runtime_states"]["state_count"])
    tables = manifest["property_tables"]
    property_names = [str(table["name"]) for table in tables]
    table_data = {
        str(table["name"]): bank_slice(
            prg, bank, number(table["address"]), state_count + 1
        )
        for table in tables
    }
    result: dict[str, Any] = {
        "schema_version": 1,
        "format": "doraemon-world2-enemy-states",
        "bank": bank,
        "state_count": state_count,
        "properties": property_names,
        "property_addresses": {
            str(table["name"]): table["address"] for table in tables
        },
        "records": [
            {
                "id": state,
                **{
                    name: f"0x{table_data[name][state]:02X}"
                    for name in property_names
                },
            }
            for state in range(state_count + 1)
        ],
        "covered_byte_count": 0,
        "covered_crc32": "00000000",
    }
    encoded = encode_authoring(result)
    result["covered_byte_count"] = len(encoded)
    result["covered_crc32"] = crc32(
        bytes(encoded[address] for address in sorted(encoded))
    )
    if any(
        bank_slice(prg, bank, address, 1)[0] != value
        for address, value in encoded.items()
    ):
        raise ValueError("World 2 enemy-state authoring differs after decode")
    return result


def validate_authoring(
    prg: bytes,
    manifest: dict[str, Any],
    object_dispatch: dict[str, Any],
    screen_authoring: dict[str, Any],
    path: Path,
) -> list[str]:
    document = json.loads(path.read_text(encoding="utf-8"))
    encoded = encode_authoring(document)
    canonical = encode_authoring(
        decode_authoring(prg, manifest, object_dispatch, screen_authoring)
    )
    errors: list[str] = []
    if len(encoded) != int(document["covered_byte_count"]):
        errors.append("World 2 enemy-state covered-byte count differs")
    encoded_crc = crc32(bytes(encoded[address] for address in sorted(encoded)))
    if encoded_crc != str(document["covered_crc32"]).lower():
        errors.append("World 2 enemy-state covered-byte CRC32 differs")
    if set(encoded) != set(canonical):
        errors.append("World 2 enemy-state authoring coverage differs")
    elif encoded != canonical:
        errors.append("World 2 enemy-state authoring roundtrip differs from PRG")
    return errors


def apply_authoring(prg: bytes, document: dict[str, Any]) -> bytes:
    if len(prg) != 4 * BANK_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    bank = int(document["bank"])
    result = bytearray(prg)
    for address, value in encode_authoring(document).items():
        offset = bank * BANK_SIZE + address - CPU_BASE
        if not 0 <= offset < len(result):
            raise ValueError("World 2 enemy-state authoring address is outside PRG")
        result[offset] = value
    return bytes(result)


def validate(
    prg: bytes,
    manifest: dict[str, Any],
    object_dispatch: dict[str, Any],
    screen_authoring: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if manifest.get("schema_version") != 1:
        return ["unsupported World 2 enemy-state schema"], {}
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    errors: list[str] = []
    bank = int(manifest["bank"])

    encoding = manifest["spawn_encoding"]
    token_min = number(encoding["token_min"])
    token_max = number(encoding["token_max"])
    state_min = number(encoding["state_min"])
    state_max = number(encoding["state_max"])
    expected_tokens = list(range(token_min, token_max + 1))
    mapped_states = [((token & 0x1F) ^ 0x10) + 1 for token in expected_tokens]
    if mapped_states != list(range(state_min, state_max + 1)):
        errors.append("World 2 spawn-token normalization range differs")
    if encoding.get("state_formula") != "((token & 0x1F) ^ 0x10) + 1":
        errors.append("World 2 spawn-token formula differs from runtime")
    signature = encoding["normalization_signature"]
    signature_data = bytes.fromhex(str(signature["bytes"]))
    if bank_slice(
        prg, bank, number(signature["address"]), len(signature_data)
    ) != signature_data:
        errors.append("World 2 spawn-token normalization signature differs")

    actual_counts, selector_spawn_total = authoring_spawn_counts(screen_authoring)
    expected_counts = Counter({
        number(token): int(count)
        for token, count in encoding["token_counts"].items()
    })
    if actual_counts != expected_counts:
        errors.append("World 2 spawn-token frequency table differs")
    if sum(actual_counts.values()) != int(encoding["expected_physical_total"]):
        errors.append("World 2 physical spawn-token total differs")
    if selector_spawn_total != int(encoding["expected_selector_total"]):
        errors.append("World 2 selector-view spawn total differs")
    if sorted(actual_counts) != expected_tokens:
        errors.append("World 2 observed spawn-token domain differs")

    states = manifest["runtime_states"]
    state_count = int(states["state_count"])
    direct_states = [number(value) for value in states["direct_spawn_states"]]
    internal_states = [number(value) for value in states["internal_states"]]
    if direct_states != mapped_states:
        errors.append("World 2 direct-spawn state list differs from token mapping")
    if sorted(direct_states + internal_states) != list(range(1, state_count + 1)):
        errors.append("World 2 runtime states do not partition states 1-20")

    region_bounds: dict[str, tuple[int, int]] = {}
    property_names: set[str] = set()
    for table in manifest["property_tables"]:
        name = str(table["name"])
        if not name or name in property_names:
            errors.append(f"duplicate or empty enemy property table: {name!r}")
            continue
        property_names.add(name)
        slot_count = int(table["slot_count"])
        if slot_count != state_count + 1:
            errors.append(f"{name}: slot count differs from state domain")
        values = [number(value) for value in table["values"]]
        if len(values) != slot_count or any(
            not 0 <= value <= 0xFF for value in values
        ):
            errors.append(f"{name}: property values differ from byte layout")
            continue
        expected = bytes(values)
        address = number(table["address"])
        if bank_slice(prg, bank, address, len(expected)) != expected:
            errors.append(f"{name}: property table differs from PRG")
        if crc32(expected) != str(table["crc32"]).lower():
            errors.append(f"{name}: property-table CRC32 differs")
        region_bounds[name] = (address, address + len(expected) - 1)

    dispatch_tables = object_dispatch["tables"]
    dispatch_target_count = 0
    for contract in manifest["dispatch_contracts"]:
        name = str(contract["name"])
        table = named_entry(dispatch_tables, name, "object dispatch table")
        slot_count = int(contract["slot_count"])
        span = number(contract["state_max"]) - number(contract["state_min"]) + 1
        if slot_count != span or int(table["slot_count"]) != slot_count:
            errors.append(f"{name}: dispatch state span differs")
        if table.get("encoding") != "rts-minus-one":
            errors.append(f"{name}: dispatch encoding differs")
        encoded = rts_minus_one_bytes(table["targets"])
        address = number(table["address"])
        if bank_slice(prg, bank, address, len(encoded)) != encoded:
            errors.append(f"{name}: dispatch table differs from PRG")
        region_bounds[name] = (address, address + len(encoded) - 1)
        dispatch_target_count += len(set(map(number, table["targets"])))

    for boundary in manifest["shared_boundaries"]:
        left = str(boundary["left"])
        right = str(boundary["right"])
        if left not in region_bounds or right not in region_bounds:
            errors.append("World 2 shared boundary names an unknown region")
            continue
        left_last = number(boundary["left_last_byte"])
        right_first = number(boundary["right_first_byte"])
        if (
            region_bounds[left][1] != left_last
            or region_bounds[right][0] != right_first
            or left_last != right_first
        ):
            errors.append(f"World 2 {left}/{right} shared boundary differs")

    for overlap in manifest["shared_overlaps"]:
        left = str(overlap["left"])
        right = str(overlap["right"])
        overlap_address = number(overlap["overlap_address"])
        overlap_size = int(overlap["overlap_size"])
        expected_left_end = overlap_address + overlap_size - 1
        if (
            left not in region_bounds
            or right not in region_bounds
            or region_bounds[left][1] != expected_left_end
            or region_bounds[right][0] != overlap_address
        ):
            errors.append(f"World 2 {left}/{right} shared overlap differs")

    return errors, {
        "spawn_token_count": sum(actual_counts.values()),
        "selector_spawn_count": selector_spawn_total,
        "spawn_token_type_count": len(actual_counts),
        "direct_state_count": len(direct_states),
        "internal_state_count": len(internal_states),
        "property_table_count": len(property_names),
        "dispatch_target_count": dispatch_target_count,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    for name in ("validate", "decode"):
        command = subparsers.add_parser(name)
        command.add_argument("--prg", required=True, type=Path)
        command.add_argument("--manifest", required=True, type=Path)
        command.add_argument("--object-dispatch", required=True, type=Path)
        command.add_argument("--screen-authoring", required=True, type=Path)
        if name == "validate":
            command.add_argument("--authoring", required=True, type=Path)
        else:
            command.add_argument("--output", required=True, type=Path)
    encode_parser = subparsers.add_parser("encode")
    encode_parser.add_argument("--input", required=True, type=Path)
    encode_parser.add_argument("--base-prg", required=True, type=Path)
    encode_parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    try:
        if args.command == "encode":
            document = json.loads(args.input.read_text(encoding="utf-8"))
            encoded = apply_authoring(args.base_prg.read_bytes(), document)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_bytes(encoded)
            print(
                f"[OK] wrote PRG with {document['covered_byte_count']} "
                "World 2 enemy-state bytes"
            )
            return 0
        prg = args.prg.read_bytes()
        manifest = json.loads(args.manifest.read_text(encoding="utf-8"))
        object_dispatch = json.loads(
            args.object_dispatch.read_text(encoding="utf-8")
        )
        screen_authoring = json.loads(
            args.screen_authoring.read_text(encoding="utf-8")
        )
        if args.command == "decode":
            decoded = decode_authoring(
                prg, manifest, object_dispatch, screen_authoring
            )
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_text(
                json.dumps(decoded, indent=2) + "\n",
                encoding="utf-8",
                newline="\n",
            )
            print(f"[OK] wrote World 2 enemy states to {args.output}")
            return 0
        errors, report = validate(
            prg, manifest, object_dispatch, screen_authoring
        )
        errors.extend(
            validate_authoring(
                prg,
                manifest,
                object_dispatch,
                screen_authoring,
                args.authoring,
            )
        )
        authoring_document = json.loads(
            args.authoring.read_text(encoding="utf-8")
        )
        report["authoring_covered_byte_count"] = len(
            encode_authoring(authoring_document)
        )
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 2 enemy-state audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] World 2 enemy states: {report['spawn_token_count']} physical / "
        f"{report['selector_spawn_count']} selector-view spawns, "
        f"{report['spawn_token_type_count']} token types, "
        f"{report['direct_state_count']} direct states, "
        f"{report['internal_state_count']} internal states; "
        f"{report['property_table_count']} property tables, "
        f"{report['dispatch_target_count']} unique dispatch targets; "
        f"{report['authoring_covered_byte_count']} "
        "lossless authoring bytes"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
