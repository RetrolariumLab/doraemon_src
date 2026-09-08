#!/usr/bin/env python3
"""Validate World 2 stage sequencing and compressed screen streams."""

from __future__ import annotations

import argparse
from dataclasses import dataclass
import json
from pathlib import Path
from typing import Any
import zlib

from scripts.build import project


BANK_SIZE = 0x8000
CPU_BASE = 0x8000


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def load_manifest(path: Path) -> dict[str, Any]:
    document = json.loads(path.read_text(encoding="utf-8"))
    if document.get("schema_version") != 1:
        raise ValueError("unsupported World 2 streaming schema")
    return document


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("World 2 streaming range is outside PRG")
    return prg[offset:offset + size]


def crc32(data: bytes) -> str:
    return f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"


def encode_rts_target(target: int) -> bytes:
    return (target - 1).to_bytes(2, "little")


@dataclass(frozen=True)
class ScreenToken:
    offset: int
    kind: str
    value: int
    repeated_literal: int | None = None


@dataclass(frozen=True)
class ScreenRow:
    tokens: tuple[ScreenToken, ...]
    width: int


@dataclass(frozen=True)
class DecodedScreen:
    rows: tuple[ScreenRow, ...]
    end_offset: int
    spawn_tokens: int
    rle_tokens: int
    row_terminators: int
    max_row_width: int


def decode_screen(
    data: bytes,
    start_offset: int,
    rows_per_screen: int,
    minimum_cells: int,
) -> tuple[list[str], DecodedScreen]:
    errors: list[str] = []
    rows: list[ScreenRow] = []
    cursor = start_offset
    spawn_tokens = 0
    rle_tokens = 0
    row_terminators = 0
    max_row_width = 0
    for row_index in range(rows_per_screen):
        width = 0
        tokens: list[ScreenToken] = []
        while width < minimum_cells:
            if cursor >= len(data):
                errors.append(
                    f"row {row_index}: read outside compressed screen data"
                )
                return errors, DecodedScreen(
                    tuple(rows),
                    cursor,
                    spawn_tokens,
                    rle_tokens,
                    row_terminators,
                    max_row_width,
                )
            token_offset = cursor
            token = data[cursor]
            cursor += 1
            if token < 0xD0:
                tokens.append(ScreenToken(token_offset, "literal", token))
                width += 1
            elif token < 0xEF:
                tokens.append(ScreenToken(token_offset, "spawn", token))
                spawn_tokens += 1
                width += 1
            elif token == 0xEF:
                tokens.append(ScreenToken(token_offset, "row_end", token))
                row_terminators += 1
                width = 16
            elif token == 0xF0:
                tokens.append(ScreenToken(token_offset, "reserved", token))
                errors.append(f"row {row_index}: invalid $F0 token")
                width = minimum_cells
            else:
                if cursor >= len(data):
                    errors.append(f"row {row_index}: truncated RLE token")
                    return errors, DecodedScreen(
                        tuple(rows),
                        cursor,
                        spawn_tokens,
                        rle_tokens,
                        row_terminators,
                        max_row_width,
                    )
                repeated = data[cursor]
                cursor += 1
                tokens.append(ScreenToken(token_offset, "rle", token, repeated))
                rle_tokens += 1
                if repeated >= 0xD0:
                    errors.append(
                        f"row {row_index}: RLE literal ${repeated:02X} is not a tile"
                    )
                # The counted loop falls through to the shared literal store,
                # so the low nibble produces one extra cell.
                width += (token & 0x0F) + 1
        rows.append(ScreenRow(tuple(tokens), width))
        max_row_width = max(max_row_width, width)
    return errors, DecodedScreen(
        tuple(rows),
        cursor,
        spawn_tokens,
        rle_tokens,
        row_terminators,
        max_row_width,
    )


def collect_screen_layout(
    data: bytes,
    pointers: list[int],
    region_address: int,
    rows_per_screen: int,
    minimum_cells: int,
) -> tuple[
    list[str],
    list[DecodedScreen],
    dict[int, ScreenToken],
    set[int],
    int,
]:
    errors: list[str] = []
    decoded_screens: list[DecodedScreen] = []
    tokens: dict[int, ScreenToken] = {}
    byte_roles: dict[int, str] = {}
    coverage_counts = [0] * len(data)
    for screen_id, pointer in enumerate(pointers):
        start_offset = pointer - region_address
        decode_errors, decoded = decode_screen(
            data,
            start_offset,
            rows_per_screen,
            minimum_cells,
        )
        errors.extend(f"screen {screen_id}: {error}" for error in decode_errors)
        decoded_screens.append(decoded)
        for byte_offset in range(start_offset, min(decoded.end_offset, len(data))):
            coverage_counts[byte_offset] += 1
        for row in decoded.rows:
            for token in row.tokens:
                existing = tokens.get(token.offset)
                if existing is not None and existing != token:
                    errors.append(
                        f"screen {screen_id}: conflicting token at "
                        f"${token.offset:04X}"
                    )
                tokens[token.offset] = token
                role_offsets = [(token.offset, "token")]
                if token.kind == "rle":
                    role_offsets.append((token.offset + 1, "operand"))
                for byte_offset, role in role_offsets:
                    previous = byte_roles.get(byte_offset)
                    if previous is not None and previous != role:
                        errors.append(
                            f"screen {screen_id}: token/operand conflict at "
                            f"${byte_offset:04X}"
                        )
                    byte_roles[byte_offset] = role
    covered_bytes = set(byte_roles)
    max_overlap = max(coverage_counts, default=0)
    return errors, decoded_screens, tokens, covered_bytes, max_overlap


def screen_storage(
    prg: bytes,
    document: dict[str, Any],
) -> tuple[int, bytes, list[int], int, bytes]:
    bank = int(document["bank"])
    pointer_spec = document["screen_pointer_table"]
    pointer_address = number(pointer_spec["address"])
    standard_slot_count = int(pointer_spec["standard_rom_slots"])
    standard_pointer_data = bank_slice(
        prg,
        bank,
        pointer_address,
        standard_slot_count * 2,
    )
    pointers = [
        int.from_bytes(standard_pointer_data[index:index + 2], "little")
        for index in range(0, len(standard_pointer_data), 2)
    ]
    streams = document["screen_streams"]
    region_address = number(streams["address"])
    region_end = number(streams["last_consumed_address"])
    region_data = bank_slice(
        prg,
        bank,
        region_address,
        region_end - region_address + 1,
    )
    return pointer_address, standard_pointer_data, pointers, region_address, region_data


def validate(
    prg: bytes,
    document: dict[str, Any],
    code_entries: list[tuple[int, int, str]],
) -> tuple[list[str], dict[str, int]]:
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}

    errors: list[str] = []
    bank = int(document["bank"])
    declared_entries = {
        (entry_bank, address) for entry_bank, address, _name in code_entries
    }

    dispatch_tables = document.get("dispatch_tables")
    if not isinstance(dispatch_tables, list) or not dispatch_tables:
        return ["World 2 dispatch tables must be a non-empty list"], {}
    dispatch_names: set[str] = set()
    dispatch_targets: set[int] = set()
    dispatch_slot_count = 0
    for table in dispatch_tables:
        name = str(table.get("name", ""))
        if not name or name in dispatch_names:
            errors.append(f"duplicate or empty World 2 dispatch name: {name!r}")
        dispatch_names.add(name)
        if table.get("encoding") != "rts-minus-one":
            errors.append(f"{name}: unsupported dispatch encoding")
            continue
        address = number(table["address"])
        targets = [number(value) for value in table.get("targets", [])]
        slot_count = int(table["slot_count"])
        if len(targets) != slot_count:
            errors.append(
                f"{name}: target count {len(targets)} differs from "
                f"slot count {slot_count}"
            )
        elif not all(CPU_BASE <= target <= 0xFFFF for target in targets):
            errors.append(f"{name}: target is outside the active PRG window")
        else:
            encoded = b"".join(encode_rts_target(target) for target in targets)
            if bank_slice(prg, bank, address, len(encoded)) != encoded:
                errors.append(f"{name}: encoded dispatch table differs from PRG")
        missing = sorted(
            target for target in set(targets)
            if (bank, target) not in declared_entries
        )
        if missing:
            errors.append(
                f"{name}: indirect targets missing from code entry registry: "
                + ", ".join(f"${target:04X}" for target in missing)
            )
        dispatch_targets.update(targets)
        dispatch_slot_count += slot_count

    stage = document["stage_sequence"]
    stage_address = number(stage["address"])
    stage_data = bank_slice(prg, bank, stage_address, int(stage["size"]))
    if crc32(stage_data) != str(stage["crc32"]).lower():
        errors.append("World 2 stage-sequence CRC32 differs from manifest")
    start_offsets = bytes(int(value) for value in stage["start_offsets"])
    actual_starts = bank_slice(
        prg,
        bank,
        number(stage["start_table_address"]),
        len(start_offsets),
    )
    if actual_starts != start_offsets:
        errors.append("World 2 stage start-offset table differs from manifest")

    pointer_spec = document["screen_pointer_table"]
    pointer_address = number(pointer_spec["address"])
    pointer_slot_count = int(pointer_spec["slot_count"])
    standard_slot_count = int(pointer_spec["standard_rom_slots"])
    pointer_data = bank_slice(prg, bank, pointer_address, pointer_slot_count * 2)
    standard_pointer_data = pointer_data[:standard_slot_count * 2]
    if crc32(standard_pointer_data) != str(pointer_spec["standard_crc32"]).lower():
        errors.append("World 2 standard pointer-table CRC32 differs from manifest")
    if crc32(pointer_data) != str(pointer_spec["full_crc32"]).lower():
        errors.append("World 2 full pointer-table CRC32 differs from manifest")
    pointers = [
        int.from_bytes(pointer_data[index:index + 2], "little")
        for index in range(0, len(pointer_data), 2)
    ]
    standard_pointers = pointers[:standard_slot_count]
    first_stream_address = number(pointer_spec["first_stream_address"])
    if not standard_pointers or standard_pointers[0] != first_stream_address:
        errors.append("World 2 first standard stream pointer differs from manifest")
    expected_unique = int(pointer_spec["standard_unique_pointer_count"])
    if len(set(standard_pointers)) != expected_unique:
        errors.append(
            "World 2 unique standard stream count differs from manifest"
        )

    streams = document["screen_streams"]
    stream_address = number(streams["address"])
    last_consumed_address = number(streams["last_consumed_address"])
    stream_data = bank_slice(
        prg,
        bank,
        stream_address,
        last_consumed_address - stream_address + 1,
    )
    if crc32(stream_data) != str(streams["crc32"]).lower():
        errors.append("World 2 compressed-stream CRC32 differs from manifest")
    if any(
        pointer < stream_address or pointer > last_consumed_address
        for pointer in standard_pointers
    ):
        errors.append("World 2 standard stream pointer is outside ROM streams")

    terminal = stage["terminal_screen"]
    terminal_screen_id = number(terminal["screen_id"])
    terminal_sequence_offset = int(terminal["sequence_offset"])
    stop_scroll_offset = int(terminal["preceding_stop_scroll_offset"])
    expected_terminal_pointer = number(terminal["indexed_pointer"])
    if not (
        0 <= stop_scroll_offset < terminal_sequence_offset < len(stage_data)
        and stage_data[stop_scroll_offset] == 0xF8
        and stage_data[terminal_sequence_offset] == terminal_screen_id
    ):
        errors.append("World 2 terminal screen sequence differs from manifest")
    if (
        terminal_screen_id >= len(pointers)
        or pointers[terminal_screen_id] != expected_terminal_pointer
    ):
        errors.append("World 2 terminal screen indexed pointer differs from manifest")
    allowed_screen_ids = set(range(standard_slot_count)) | {terminal_screen_id}
    illegal_selectors = sorted({
        token & 0x7F
        for token in stage_data
        if token < 0xF0 and (token & 0x7F) not in allowed_screen_ids
    })
    if illegal_selectors:
        errors.append(
            "World 2 stage sequence has unsupported screen selectors: "
            + ", ".join(f"${value:02X}" for value in illegal_selectors)
        )

    rows_per_screen = int(streams["rows_per_screen"])
    minimum_cells = int(streams["minimum_cells_per_row"])
    spawn_tokens = 0
    rle_tokens = 0
    row_terminators = 0
    max_row_width = 0
    max_read_address = stream_address - 1
    (
        layout_errors,
        decoded_screens,
        unique_tokens,
        covered_bytes,
        max_stream_overlap,
    ) = collect_screen_layout(
        stream_data,
        standard_pointers,
        stream_address,
        rows_per_screen,
        minimum_cells,
    )
    errors.extend(layout_errors)
    for decoded in decoded_screens:
        spawn_tokens += decoded.spawn_tokens
        rle_tokens += decoded.rle_tokens
        row_terminators += decoded.row_terminators
        max_row_width = max(max_row_width, decoded.max_row_width)
        max_read_address = max(
            max_read_address,
            stream_address + decoded.end_offset - 1,
        )
    missing_bytes = len(stream_data) - len(covered_bytes)
    if missing_bytes:
        errors.append(
            f"World 2 global tokenization leaves {missing_bytes} uncovered bytes"
        )
    unique_token_kinds = {
        kind: sum(1 for token in unique_tokens.values() if token.kind == kind)
        for kind in ("literal", "spawn", "row_end", "rle")
    }

    expected_metrics = {
        "screen_count": (standard_slot_count, int(streams["expected_screen_count"])),
        "spawn_tokens": (spawn_tokens, int(streams["expected_spawn_tokens"])),
        "rle_tokens": (rle_tokens, int(streams["expected_rle_tokens"])),
        "row_terminators": (
            row_terminators,
            int(streams["expected_row_terminators"]),
        ),
        "max_row_width": (max_row_width, int(streams["expected_max_row_width"])),
        "unique_tokens": (
            len(unique_tokens),
            int(streams["expected_unique_tokens"]),
        ),
        "unique_literal_tokens": (
            unique_token_kinds["literal"],
            int(streams["expected_unique_literal_tokens"]),
        ),
        "unique_spawn_tokens": (
            unique_token_kinds["spawn"],
            int(streams["expected_unique_spawn_tokens"]),
        ),
        "unique_row_end_tokens": (
            unique_token_kinds["row_end"],
            int(streams["expected_unique_row_end_tokens"]),
        ),
        "unique_rle_tokens": (
            unique_token_kinds["rle"],
            int(streams["expected_unique_rle_tokens"]),
        ),
        "max_stream_overlap": (
            max_stream_overlap,
            int(streams["expected_max_stream_overlap"]),
        ),
    }
    for metric, (actual, expected) in expected_metrics.items():
        if actual != expected:
            errors.append(
                f"World 2 {metric} {actual} differs from manifest {expected}"
            )
    if max_read_address != last_consumed_address:
        errors.append(
            f"World 2 last consumed byte ${max_read_address:04X} differs "
            f"from manifest ${last_consumed_address:04X}"
        )

    return errors, {
        "dispatch_table_count": len(dispatch_tables),
        "dispatch_slot_count": dispatch_slot_count,
        "dispatch_target_count": len(dispatch_targets),
        "screen_count": standard_slot_count,
        "unique_stream_count": len(set(standard_pointers)),
        "spawn_token_count": spawn_tokens,
        "rle_token_count": rle_tokens,
        "row_terminator_count": row_terminators,
        "unique_token_count": len(unique_tokens),
        "covered_byte_count": len(covered_bytes),
        "max_stream_overlap": max_stream_overlap,
    }


def token_text(token: ScreenToken) -> str:
    if token.kind == "literal":
        return f"{token.offset:04X}:L:{token.value:02X}"
    if token.kind == "spawn":
        return f"{token.offset:04X}:S:{token.value:02X}"
    if token.kind == "row_end":
        return f"{token.offset:04X}:E"
    if token.kind == "rle" and token.repeated_literal is not None:
        return (
            f"{token.offset:04X}:R:{token.value:02X}:"
            f"{token.repeated_literal:02X}"
        )
    raise ValueError(f"unsupported screen token kind: {token.kind}")


def row_text(row: ScreenRow) -> str:
    if not row.tokens:
        raise ValueError("World 2 decoded row has no tokens")
    start = row.tokens[0].offset
    last = row.tokens[-1]
    end = last.offset + (2 if last.kind == "rle" else 1)
    return f"{start:04X}-{end:04X}:{row.width}"


def decode_authoring(
    prg: bytes,
    document: dict[str, Any],
    code_entries: list[tuple[int, int, str]],
) -> dict[str, Any]:
    errors, _report = validate(prg, document, code_entries)
    if errors:
        raise ValueError("; ".join(errors))
    (
        pointer_address,
        pointer_data,
        pointers,
        region_address,
        region_data,
    ) = screen_storage(prg, document)
    streams = document["screen_streams"]
    layout_errors, decoded, tokens, covered, _overlap = collect_screen_layout(
        region_data,
        pointers,
        region_address,
        int(streams["rows_per_screen"]),
        int(streams["minimum_cells_per_row"]),
    )
    if layout_errors or len(covered) != len(region_data):
        raise ValueError("; ".join(layout_errors) or "incomplete token coverage")
    first_selector: dict[int, int] = {}
    selectors: list[dict[str, Any]] = []
    for screen_id, (pointer, screen) in enumerate(zip(pointers, decoded)):
        alias_of = first_selector.setdefault(pointer, screen_id)
        selectors.append({
            "id": screen_id,
            "address": f"0x{pointer:04X}",
            "alias_of": None if alias_of == screen_id else alias_of,
            "rows": [row_text(row) for row in screen.rows],
        })
    authoring = {
        "schema_version": 1,
        "format": "world2-compressed-screens",
        "pointer_table_address": f"0x{pointer_address:04X}",
        "region_address": f"0x{region_address:04X}",
        "region_size": len(region_data),
        "rows_per_screen": int(streams["rows_per_screen"]),
        "minimum_cells_per_row": int(streams["minimum_cells_per_row"]),
        "payload_crc32": crc32(pointer_data + region_data),
        "selectors": selectors,
        "tokens": [token_text(tokens[offset]) for offset in sorted(tokens)],
    }
    if encode_authoring(authoring) != pointer_data + region_data:
        raise ValueError("World 2 authoring roundtrip differs after decode")
    return authoring


def parse_token_text(text: str) -> tuple[int, bytes]:
    parts = text.split(":")
    if len(parts) < 2:
        raise ValueError(f"invalid World 2 token record: {text!r}")
    offset = int(parts[0], 16)
    kind = parts[1]
    if kind == "E" and len(parts) == 2:
        return offset, bytes((0xEF,))
    if kind in ("L", "S") and len(parts) == 3:
        value = int(parts[2], 16)
        if kind == "L" and not 0 <= value < 0xD0:
            raise ValueError(f"literal token is outside $00-$CF: {text!r}")
        if kind == "S" and not 0xD0 <= value < 0xEF:
            raise ValueError(f"spawn token is outside $D0-$EE: {text!r}")
        return offset, bytes((value,))
    if kind == "R" and len(parts) == 4:
        token = int(parts[2], 16)
        repeated = int(parts[3], 16)
        if not 0xF1 <= token <= 0xFF or not 0 <= repeated < 0xD0:
            raise ValueError(f"invalid RLE token: {text!r}")
        return offset, bytes((token, repeated))
    raise ValueError(f"invalid World 2 token record: {text!r}")


def encode_authoring(document: dict[str, Any]) -> bytes:
    if document.get("schema_version") != 1 or document.get("format") != (
        "world2-compressed-screens"
    ):
        raise ValueError("unsupported World 2 screen authoring schema")
    region_address = number(document["region_address"])
    region_size = int(document["region_size"])
    rows_per_screen = int(document["rows_per_screen"])
    minimum_cells = int(document["minimum_cells_per_row"])
    region: list[int | None] = [None] * region_size
    for token_text_value in document["tokens"]:
        offset, raw = parse_token_text(str(token_text_value))
        if offset < 0 or offset + len(raw) > region_size:
            raise ValueError(f"token offset ${offset:04X} is outside region")
        for byte_offset, value in enumerate(raw, start=offset):
            if region[byte_offset] is not None:
                raise ValueError(f"token overlap at region offset ${byte_offset:04X}")
            region[byte_offset] = value
    if any(value is None for value in region):
        raise ValueError("World 2 authoring token pool has uncovered bytes")
    region_data = bytes(value for value in region if value is not None)

    selectors = sorted(document["selectors"], key=lambda entry: int(entry["id"]))
    if [int(entry["id"]) for entry in selectors] != list(range(len(selectors))):
        raise ValueError("World 2 authoring selector ids are not contiguous")
    pointers = [number(entry["address"]) for entry in selectors]
    first_selector: dict[int, int] = {}
    for screen_id, (pointer, selector) in enumerate(zip(pointers, selectors)):
        if not region_address <= pointer < region_address + region_size:
            raise ValueError(f"selector {screen_id} pointer is outside region")
        expected_alias = first_selector.setdefault(pointer, screen_id)
        declared_alias = selector.get("alias_of")
        if declared_alias != (None if expected_alias == screen_id else expected_alias):
            raise ValueError(f"selector {screen_id} alias metadata differs")
        decode_errors, screen = decode_screen(
            region_data,
            pointer - region_address,
            rows_per_screen,
            minimum_cells,
        )
        if decode_errors:
            raise ValueError(
                f"selector {screen_id}: " + "; ".join(decode_errors)
            )
        actual_rows = [row_text(row) for row in screen.rows]
        if len(selector["rows"]) != rows_per_screen or actual_rows != selector["rows"]:
            raise ValueError(f"selector {screen_id} row metadata differs")
    pointer_data = b"".join(pointer.to_bytes(2, "little") for pointer in pointers)
    return pointer_data + region_data


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    validate_parser = subparsers.add_parser("validate")
    validate_parser.add_argument("--prg", required=True, type=Path)
    validate_parser.add_argument("--manifest", required=True, type=Path)
    validate_parser.add_argument("--code-entries", required=True, type=Path)
    validate_parser.add_argument("--authoring", type=Path)
    decode_parser = subparsers.add_parser("decode")
    decode_parser.add_argument("--prg", required=True, type=Path)
    decode_parser.add_argument("--manifest", required=True, type=Path)
    decode_parser.add_argument("--code-entries", required=True, type=Path)
    decode_parser.add_argument("--output", required=True, type=Path)
    encode_parser = subparsers.add_parser("encode")
    encode_parser.add_argument("--input", required=True, type=Path)
    encode_parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    try:
        if args.command == "encode":
            encoded = encode_authoring(
                json.loads(args.input.read_text(encoding="utf-8"))
            )
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_bytes(encoded)
            print(f"[OK] wrote {len(encoded)} World 2 screen bytes to {args.output}")
            return 0
        prg = args.prg.read_bytes()
        manifest = load_manifest(args.manifest)
        code_entries = project.load_prg_code_entries(args.code_entries)
        if args.command == "decode":
            decoded = decode_authoring(prg, manifest, code_entries)
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_text(
                json.dumps(decoded, indent=2) + "\n",
                encoding="utf-8",
            )
            print(f"[OK] wrote World 2 screen authoring data to {args.output}")
            return 0
        errors, report = validate(prg, manifest, code_entries)
        if args.authoring is not None:
            authoring_document = json.loads(
                args.authoring.read_text(encoding="utf-8")
            )
            encoded = encode_authoring(
                authoring_document
            )
            if number(authoring_document["pointer_table_address"]) != number(
                manifest["screen_pointer_table"]["address"]
            ):
                errors.append("World 2 authoring pointer-table address differs")
            if number(authoring_document["region_address"]) != number(
                manifest["screen_streams"]["address"]
            ):
                errors.append("World 2 authoring region address differs")
            if crc32(encoded) != str(authoring_document["payload_crc32"]).lower():
                errors.append("World 2 screen authoring payload CRC32 differs")
            (
                _pointer_address,
                pointer_data,
                _pointers,
                _region_address,
                region_data,
            ) = screen_storage(prg, manifest)
            if encoded != pointer_data + region_data:
                errors.append("World 2 screen authoring roundtrip differs from PRG")
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 2 streaming audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] {report['dispatch_table_count']} World 2 screen-service "
        f"tables: {report['dispatch_slot_count']} slots, "
        f"{report['dispatch_target_count']} unique targets; "
        f"{report['screen_count']} screen selectors, "
        f"{report['unique_stream_count']} unique streams, "
        f"{report['spawn_token_count']} enemy tokens, "
        f"{report['rle_token_count']} RLE tokens; "
        f"{report['unique_token_count']} global tokens covering "
        f"{report['covered_byte_count']} bytes"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
