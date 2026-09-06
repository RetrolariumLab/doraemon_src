#!/usr/bin/env python3
"""Decode and validate header-reachable music streams in all PRG banks."""

from __future__ import annotations

import argparse
from collections import Counter
from dataclasses import dataclass, replace
import json
from pathlib import Path
from typing import Any

from audio_music import EXPECTED_COMMANDS


BANK_SIZE = 0x8000
CPU_BASE = 0x8000
CHANNEL_COUNT = 4
MAX_STATES_PER_CHANNEL = 1_000_000


@dataclass(frozen=True)
class StreamState:
    pc: int
    saved: int
    call_return: int | None = None
    loop_start: int | None = None
    loop_exit: int | None = None
    loop_limit: int | None = None
    loop_iteration: int | None = None


@dataclass(frozen=True)
class Token:
    address: int
    opcode: int
    kind: str
    name: str
    operands: tuple[int, ...]

    @property
    def raw(self) -> bytes:
        return bytes((self.opcode, *self.operands))


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def bank_offset(bank: int, address: int) -> int:
    if not 0 <= bank < 4 or not CPU_BASE <= address <= 0xFFFF:
        raise ValueError(f"bank {bank} address is outside PRG: ${address:04X}")
    return bank * BANK_SIZE + address - CPU_BASE


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    if len(prg) != 4 * BANK_SIZE:
        raise ValueError(f"PRG size differs: {len(prg)}")
    offset = bank_offset(bank, address)
    if size < 0 or offset + size > (bank + 1) * BANK_SIZE:
        raise ValueError(f"bank {bank} range is outside PRG: ${address:04X}+{size}")
    return prg[offset:offset + size]


def command_grammar(music: dict[str, Any]) -> dict[int, tuple[str, int]]:
    grammar = {
        number(item["opcode"]): (str(item["name"]), int(item["operand_bytes"]))
        for item in music["commands"]
    }
    if set(grammar) != set(range(0xEF, 0x100)):
        raise ValueError("music command grammar does not cover $EF-$FF")
    expected = {
        opcode: (name, operand_count)
        for opcode, operand_count, name in EXPECTED_COMMANDS
    }
    if grammar != expected:
        raise ValueError("music command grammar differs from the interpreter ABI")
    return grammar


def decode_token(
    prg: bytes,
    bank: int,
    address: int,
    grammar: dict[int, tuple[str, int]],
) -> Token:
    opcode = bank_slice(prg, bank, address, 1)[0]
    if opcode < 0x80:
        return Token(address, opcode, "event", "Event", ())
    if opcode < 0xEF:
        return Token(address, opcode, "duration", "Duration", ())
    name, operand_count = grammar[opcode]
    operands = tuple(bank_slice(prg, bank, address + 1, operand_count))
    return Token(address, opcode, "command", name, operands)


def next_state(
    state: StreamState,
    token: Token,
    track_header: tuple[int, ...],
    channel: int,
) -> StreamState | None:
    following = token.address + len(token.raw)
    name = token.name
    if name == "EndChannel":
        return None
    if name == "RestoreStreamPosition":
        return replace(state, pc=state.saved)
    if name == "BeginCountedLoop":
        return replace(
            state,
            pc=following,
            loop_start=following,
            loop_limit=token.operands[0],
            loop_iteration=1,
        )
    if name == "RepeatCountedLoop":
        if (
            state.loop_start is None
            or state.loop_limit is None
            or state.loop_iteration is None
        ):
            raise ValueError(f"counted-loop repeat lacks a start at ${token.address:04X}")
        if state.loop_iteration < state.loop_limit:
            return replace(
                state,
                pc=state.loop_start,
                loop_exit=following,
                loop_iteration=state.loop_iteration + 1,
            )
        return replace(state, pc=following)
    if name == "SelectLoopExit":
        if state.loop_iteration is None:
            raise ValueError(f"loop-exit test lacks a counter at ${token.address:04X}")
        if token.operands[0] < state.loop_iteration:
            if state.loop_exit is None:
                raise ValueError(f"loop-exit target is unset at ${token.address:04X}")
            return replace(state, pc=state.loop_exit)
        return replace(state, pc=following)
    if name == "SaveStreamPosition":
        return replace(state, pc=following, saved=following)
    if name == "CallStream":
        target = token.operands[0] | token.operands[1] << 8
        return replace(state, pc=target, call_return=following)
    if name == "ReturnFromStream":
        if state.call_return is None:
            raise ValueError(f"stream return lacks a caller at ${token.address:04X}")
        return replace(state, pc=state.call_return)
    if name == "SelectTrackChannelStream":
        return replace(state, pc=track_header[channel])
    return replace(state, pc=following)


def register_token(
    token: Token,
    tokens: dict[int, Token],
    byte_owners: dict[int, int],
) -> None:
    previous = tokens.get(token.address)
    if previous is not None and previous != token:
        raise ValueError(f"conflicting token at ${token.address:04X}")
    for address in range(token.address, token.address + len(token.raw)):
        owner = byte_owners.get(address)
        if owner is not None and owner != token.address:
            raise ValueError(
                f"token at ${token.address:04X} overlaps token at ${owner:04X}"
            )
        byte_owners[address] = token.address
    tokens[token.address] = token


def trace_channel(
    prg: bytes,
    bank: int,
    track_id: int,
    channel: int,
    header: tuple[int, ...],
    grammar: dict[int, tuple[str, int]],
    tokens: dict[int, Token],
    byte_owners: dict[int, int],
) -> dict[str, Any]:
    initial = StreamState(pc=header[channel], saved=header[channel])
    state = initial
    visited: set[StreamState] = set()
    while state not in visited:
        if len(visited) >= MAX_STATES_PER_CHANNEL:
            raise ValueError(
                f"bank {bank} track {track_id} channel {channel} exceeds state limit"
            )
        visited.add(state)
        token = decode_token(prg, bank, state.pc, grammar)
        register_token(token, tokens, byte_owners)
        state = next_state(state, token, header, channel)
        if state is None:
            return {
                "track_id": track_id,
                "channel": channel,
                "entry": f"0x{initial.pc:04X}",
                "state_count": len(visited),
                "termination": "end-channel",
            }
    return {
        "track_id": track_id,
        "channel": channel,
        "entry": f"0x{initial.pc:04X}",
        "state_count": len(visited),
        "termination": "cycle",
        "cycle_address": f"0x{state.pc:04X}",
    }


def contiguous_segments(addresses: set[int]) -> list[tuple[int, int]]:
    if not addresses:
        return []
    result: list[tuple[int, int]] = []
    start = previous = min(addresses)
    for address in sorted(addresses)[1:]:
        if address != previous + 1:
            result.append((start, previous))
            start = address
        previous = address
    result.append((start, previous))
    return result


def event_text(token: Token) -> str:
    operands = "".join(f" ${value:02X}" for value in token.operands)
    if token.kind in ("event", "duration"):
        return f"{token.kind} ${token.opcode:02X}"
    return f"{token.name}{operands}"


def parse_event(text: str, address: int) -> Token:
    fields = text.split()
    if not fields:
        raise ValueError(f"empty music event at ${address:04X}")
    if fields[0] in ("event", "duration"):
        if len(fields) != 2 or not fields[1].startswith("$"):
            raise ValueError(f"invalid {fields[0]} event at ${address:04X}")
        opcode = int(fields[1][1:], 16)
        expected_kind = "event" if opcode < 0x80 else "duration"
        if fields[0] != expected_kind or not 0 <= opcode < 0xEF:
            raise ValueError(f"music event class differs at ${address:04X}")
        return Token(address, opcode, expected_kind, expected_kind.title(), ())
    commands = {
        name: (opcode, operand_count)
        for opcode, operand_count, name in EXPECTED_COMMANDS
    }
    if fields[0] not in commands:
        raise ValueError(f"unknown music command {fields[0]} at ${address:04X}")
    opcode, operand_count = commands[fields[0]]
    if len(fields) != operand_count + 1 or any(
        not field.startswith("$") for field in fields[1:]
    ):
        raise ValueError(f"wrong operand count for {fields[0]} at ${address:04X}")
    operands = tuple(int(field[1:], 16) for field in fields[1:])
    if any(not 0 <= value <= 0xFF for value in operands):
        raise ValueError(f"non-byte music operand at ${address:04X}")
    return Token(address, opcode, "command", fields[0], operands)


def scan_driver(
    prg: bytes,
    driver: dict[str, Any],
    grammar: dict[int, tuple[str, int]],
) -> dict[str, Any]:
    bank = int(driver["bank"])
    first_track = int(driver["track_id_min"])
    track_limit = int(driver["track_id_limit"])
    track_count = int(driver["track_count"])
    if first_track != 1 or track_count != track_limit - first_track:
        raise ValueError(f"bank {bank} track-ID geometry differs")
    header_address = number(driver["track_header_table"])
    header_raw = bank_slice(prg, bank, header_address, track_count * 8)
    headers: list[tuple[int, ...]] = []
    for offset in range(0, len(header_raw), 8):
        header = tuple(
            int.from_bytes(header_raw[index:index + 2], "little")
            for index in range(offset, offset + 8, 2)
        )
        if any(not CPU_BASE <= pointer <= 0xFFFF for pointer in header):
            raise ValueError(f"bank {bank} header contains a non-PRG pointer")
        headers.append(header)

    tokens: dict[int, Token] = {}
    byte_owners: dict[int, int] = {}
    paths: list[dict[str, Any]] = []
    for track_id, header in enumerate(headers, first_track):
        for channel in range(CHANNEL_COUNT):
            paths.append(
                trace_channel(
                    prg,
                    bank,
                    track_id,
                    channel,
                    header,
                    grammar,
                    tokens,
                    byte_owners,
                )
            )

    used_addresses = set(byte_owners)
    segments = contiguous_segments(used_addresses)
    command_counts = Counter(
        token.name for token in tokens.values() if token.kind == "command"
    )
    segment_documents = []
    for start, end in segments:
        segment_tokens = [
            token
            for token in sorted(tokens.values(), key=lambda item: item.address)
            if start <= token.address <= end
        ]
        cursor = start
        for token in segment_tokens:
            if token.address != cursor:
                raise ValueError(f"music token gap at ${cursor:04X}")
            cursor += len(token.raw)
        if cursor != end + 1:
            raise ValueError(f"music segment does not end at ${end:04X}")
        segment_documents.append({
            "address": f"0x{start:04X}",
            "end_address": f"0x{end:04X}",
            "size": end - start + 1,
            "events": [event_text(token) for token in segment_tokens],
        })
    return {
        "bank": bank,
        "name": str(driver["name"]),
        "track_id_min": first_track,
        "track_id_limit": track_limit,
        "track_count": track_count,
        "header_address": f"0x{header_address:04X}",
        "headers": [
            {
                "track_id": track_id,
                "channels": [f"0x{pointer:04X}" for pointer in header],
            }
            for track_id, header in enumerate(headers, first_track)
        ],
        "paths": paths,
        "segments": segment_documents,
        "metrics": {
            "header_bytes": len(header_raw),
            "reachable_bytes": len(used_addresses),
            "token_count": len(tokens),
            "command_count": sum(command_counts.values()),
            "command_histogram": dict(sorted(command_counts.items())),
            "cycle_paths": sum(path["termination"] == "cycle" for path in paths),
            "ended_paths": sum(
                path["termination"] == "end-channel" for path in paths
            ),
        },
    }


def decode_authoring(prg: bytes, music: dict[str, Any]) -> dict[str, Any]:
    grammar = command_grammar(music)
    return {
        "schema_version": 1,
        "format": "doraemon-music-streams",
        "drivers": [scan_driver(prg, driver, grammar) for driver in music["drivers"]],
    }


def encode_driver(driver: dict[str, Any]) -> bytes:
    output = bytearray()
    expected_track = int(driver["track_id_min"])
    for header in driver["headers"]:
        if int(header["track_id"]) != expected_track:
            raise ValueError("music headers have noncontiguous track IDs")
        expected_track += 1
        channels = [number(value) for value in header["channels"]]
        if len(channels) != CHANNEL_COUNT:
            raise ValueError("music header does not contain four channels")
        for pointer in channels:
            if not CPU_BASE <= pointer <= 0xFFFF:
                raise ValueError("music header pointer is outside PRG")
            output.extend(pointer.to_bytes(2, "little"))
    if expected_track != int(driver["track_id_limit"]):
        raise ValueError("music header count differs from track-ID limit")

    previous_end = CPU_BASE - 1
    for segment in driver["segments"]:
        start = number(segment["address"])
        end = number(segment["end_address"])
        size = int(segment["size"])
        if start <= previous_end or size != end - start + 1:
            raise ValueError("music authoring segments overlap or have wrong size")
        previous_end = end
        cursor = start
        segment_raw = bytearray()
        for event in segment["events"]:
            token = parse_event(str(event), cursor)
            segment_raw.extend(token.raw)
            cursor += len(token.raw)
        if cursor != end + 1:
            raise ValueError(f"music events do not cover segment at ${start:04X}")
        output.extend(segment_raw)
    return bytes(output)


def encode_authoring(document: dict[str, Any]) -> bytes:
    if document.get("schema_version") != 1 or document.get("format") != (
        "doraemon-music-streams"
    ):
        raise ValueError("unsupported music-stream authoring schema")
    drivers = document.get("drivers", [])
    if [int(driver["bank"]) for driver in drivers] != list(range(4)):
        raise ValueError("music-stream drivers are not ordered by bank")
    return b"".join(encode_driver(driver) for driver in drivers)


def original_payload(prg: bytes, document: dict[str, Any]) -> bytes:
    output = bytearray()
    for driver in document["drivers"]:
        bank = int(driver["bank"])
        output.extend(
            bank_slice(
                prg,
                bank,
                number(driver["header_address"]),
                int(driver["metrics"]["header_bytes"]),
            )
        )
        for segment in driver["segments"]:
            output.extend(
                bank_slice(
                    prg,
                    bank,
                    number(segment["address"]),
                    int(segment["size"]),
                )
            )
    return bytes(output)


def validate_authoring(
    prg: bytes,
    music: dict[str, Any],
    authoring: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    errors: list[str] = []
    expected = decode_authoring(prg, music)
    if authoring != expected:
        errors.append("music-stream authoring document differs from decoded PRG")
    try:
        encoded = encode_authoring(authoring)
        original = original_payload(prg, expected)
        if encoded != original:
            errors.append("music-stream authoring roundtrip differs from PRG")
    except (KeyError, TypeError, ValueError) as exc:
        errors.append(str(exc))
    return errors, {
        "driver_count": len(expected["drivers"]),
        "track_count": sum(
            int(driver["track_count"]) for driver in expected["drivers"]
        ),
        "header_bytes": sum(
            int(driver["metrics"]["header_bytes"])
            for driver in expected["drivers"]
        ),
        "reachable_bytes": sum(
            int(driver["metrics"]["reachable_bytes"])
            for driver in expected["drivers"]
        ),
        "token_count": sum(
            int(driver["metrics"]["token_count"])
            for driver in expected["drivers"]
        ),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    decode_parser = subparsers.add_parser("decode")
    decode_parser.add_argument("--prg", required=True, type=Path)
    decode_parser.add_argument("--music", required=True, type=Path)
    decode_parser.add_argument("--output", required=True, type=Path)
    validate_parser = subparsers.add_parser("validate")
    validate_parser.add_argument("--prg", required=True, type=Path)
    validate_parser.add_argument("--music", required=True, type=Path)
    validate_parser.add_argument("--authoring", required=True, type=Path)
    encode_parser = subparsers.add_parser("encode")
    encode_parser.add_argument("--input", required=True, type=Path)
    encode_parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    try:
        if args.command == "decode":
            decoded = decode_authoring(
                args.prg.read_bytes(),
                load_json(args.music),
            )
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_text(
                json.dumps(decoded, indent=2) + "\n",
                encoding="utf-8",
            )
            print(f"[OK] wrote music-stream authoring data to {args.output}")
            return 0
        if args.command == "encode":
            encoded = encode_authoring(load_json(args.input))
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_bytes(encoded)
            print(f"[OK] wrote {len(encoded)} music header/stream bytes")
            return 0
        errors, report = validate_authoring(
            args.prg.read_bytes(),
            load_json(args.music),
            load_json(args.authoring),
        )
        if errors:
            for error in errors:
                print(f"[ERROR] {error}")
            return 1
        print(
            f"[OK] {report['driver_count']} music drivers: "
            f"{report['track_count']} tracks, {report['header_bytes']} header bytes, "
            f"{report['token_count']} reachable tokens / "
            f"{report['reachable_bytes']} stream bytes"
        )
        return 0
    except (OSError, KeyError, TypeError, ValueError, json.JSONDecodeError) as exc:
        print(f"[ERROR] music-stream operation failed: {exc}")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
