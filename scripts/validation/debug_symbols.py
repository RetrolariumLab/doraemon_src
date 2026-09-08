#!/usr/bin/env python3
"""Validate ld65 debug data and export bank-aware FCEUX name lists."""

from __future__ import annotations

import argparse
from dataclasses import dataclass
import hashlib
import json
from pathlib import Path
import re
from typing import Any


FIELD_RE = re.compile(r'(\w+)=("(?:[^"\\]|\\.)*"|[^,]*)')
PRG_SEGMENT_RE = re.compile(r"PRG([0-3])")
NEUTRAL_RE = re.compile(r"Bank\d+_(?:Func|Label)_[0-9A-F]{4}$")


@dataclass(frozen=True)
class Segment:
    identifier: int
    name: str
    start: int
    size: int
    output_offset: int | None


@dataclass(frozen=True)
class Symbol:
    name: str
    value: int
    kind: str
    segment: int | None


@dataclass(frozen=True)
class DebugData:
    segments: dict[int, Segment]
    symbols: list[Symbol]
    files: list[str]


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def load_json(path: Path, description: str) -> dict[str, Any]:
    document = json.loads(path.read_text(encoding="utf-8"))
    if document.get("schema_version") != 1:
        raise ValueError(f"unsupported {description} schema")
    return document


def fields(payload: str) -> dict[str, str | int]:
    result: dict[str, str | int] = {}
    for match in FIELD_RE.finditer(payload):
        key, raw = match.groups()
        if raw.startswith('"'):
            result[key] = json.loads(raw)
        elif raw.startswith("0x"):
            result[key] = int(raw, 16)
        elif raw.isdigit():
            result[key] = int(raw)
        else:
            result[key] = raw
    return result


def parse_debug_text(text: str) -> DebugData:
    segments: dict[int, Segment] = {}
    symbols: list[Symbol] = []
    files: list[str] = []
    version_seen = False
    for raw_line in text.splitlines():
        if "\t" not in raw_line:
            continue
        record_type, payload = raw_line.split("\t", 1)
        values = fields(payload)
        if record_type == "version":
            version_seen = values.get("major") == 2
        elif record_type == "file":
            files.append(str(values["name"]))
        elif record_type == "seg":
            identifier = int(values["id"])
            segments[identifier] = Segment(
                identifier=identifier,
                name=str(values["name"]),
                start=int(values["start"]),
                size=int(values["size"]),
                output_offset=(
                    int(values["ooffs"]) if "ooffs" in values else None
                ),
            )
        elif record_type == "sym":
            symbols.append(Symbol(
                name=str(values["name"]),
                value=int(values["val"]),
                kind=str(values["type"]),
                segment=int(values["seg"]) if "seg" in values else None,
            ))
    if not version_seen:
        raise ValueError("ld65 debug data is not version 2")
    if not segments or not symbols or not files:
        raise ValueError("ld65 debug data is incomplete")
    return DebugData(segments=segments, symbols=symbols, files=files)


def parse_debug(path: Path) -> DebugData:
    return parse_debug_text(path.read_text(encoding="utf-8"))


def prg_segments(debug: DebugData) -> dict[int, Segment]:
    result: dict[int, Segment] = {}
    for segment in debug.segments.values():
        match = PRG_SEGMENT_RE.fullmatch(segment.name)
        if match:
            result[int(match.group(1))] = segment
    return result


def symbol_index(debug: DebugData) -> dict[str, Symbol]:
    result: dict[str, Symbol] = {}
    for symbol in debug.symbols:
        if symbol.name in result:
            raise ValueError(f"duplicate linker symbol name: {symbol.name}")
        result[symbol.name] = symbol
    return result


def validate_sources(project_root: Path, debug: DebugData) -> list[str]:
    errors: list[str] = []
    resolved_root = project_root.resolve()
    for source in debug.files:
        path = (project_root / source).resolve()
        if resolved_root not in path.parents or not path.is_file():
            errors.append(f"linker debug source is missing or unsafe: {source}")
    return errors


def validate_segment_layout(
    debug: DebugData, contract: dict[str, Any]
) -> list[str]:
    errors: list[str] = []
    actual = prg_segments(debug)
    if sorted(actual) != list(range(4)):
        return ["ld65 debug data does not contain PRG0 through PRG3"]
    expected = contract["mesen"]["prg_segments"]
    if len(expected) != 4:
        return ["debug-symbol contract must declare four PRG segments"]
    for item in expected:
        bank = int(item["bank"])
        segment = actual.get(bank)
        if segment is None:
            continue
        checks = (
            (segment.name, item["name"], "name"),
            (segment.start, number(item["start"]), "start"),
            (segment.size, number(item["size"]), "size"),
            (segment.output_offset, number(item["output_offset"]), "output offset"),
        )
        for observed, wanted, description in checks:
            if observed != wanted:
                errors.append(f"PRG{bank} linker segment {description} differs")
    return errors


def validate_registry(
    debug: DebugData,
    registry: dict[str, Any],
    contract: dict[str, Any],
) -> list[str]:
    errors: list[str] = []
    linker_symbols = symbol_index(debug)
    segments = prg_segments(debug)
    for item in registry["symbols"]:
        name = str(item["name"])
        symbol = linker_symbols.get(name)
        bank = int(item["bank"])
        if symbol is None:
            errors.append(f"linker debug data lacks PRG symbol: {name}")
        elif (
            symbol.kind not in {"lab", "equ"}
            or symbol.segment != segments[bank].identifier
            or symbol.value != number(item["address"])
        ):
            errors.append(f"linker PRG symbol differs: {name}")
    for item in registry["memory_symbols"]:
        name = str(item["name"])
        symbol = linker_symbols.get(name)
        if symbol is None:
            errors.append(f"linker debug data lacks memory symbol: {name}")
        elif symbol.kind != "equ" or symbol.value != number(item["address"]):
            errors.append(f"linker memory symbol differs: {name}")
    for probe in contract["required_program_symbols"]:
        name = str(probe["name"])
        symbol = linker_symbols.get(name)
        bank = int(probe["bank"])
        if symbol is None or (
            symbol.segment != segments[bank].identifier
            or symbol.value != number(probe["address"])
        ):
            errors.append(f"required program probe differs: {name}")
    for probe in contract["required_ram_symbols"]:
        name = str(probe["name"])
        symbol = linker_symbols.get(name)
        if symbol is None or symbol.value != number(probe["address"]):
            errors.append(f"required RAM probe differs: {name}")
    return errors


def registry_prg_names(registry: dict[str, Any]) -> dict[tuple[int, int], str]:
    return {
        (int(item["bank"]), number(item["address"])): str(item["name"])
        for item in registry["symbols"]
    }


def preferred_label(names: list[str], configured: str | None) -> str:
    if configured in names:
        return str(configured)
    semantic = [name for name in names if not NEUTRAL_RE.fullmatch(name)]
    return sorted(semantic or names, key=lambda name: (len(name), name))[0]


def fceux_prg_labels(
    debug: DebugData, registry: dict[str, Any]
) -> dict[int, list[tuple[int, str]]]:
    configured = registry_prg_names(registry)
    segments = prg_segments(debug)
    segment_banks = {segment.identifier: bank for bank, segment in segments.items()}
    grouped: dict[tuple[int, int], list[str]] = {}
    for symbol in debug.symbols:
        if symbol.kind not in {"lab", "equ"} or symbol.segment not in segment_banks:
            continue
        bank = segment_banks[symbol.segment]
        grouped.setdefault((bank, symbol.value), []).append(symbol.name)
    result: dict[int, list[tuple[int, str]]] = {bank: [] for bank in range(8)}
    for (bank, address), names in grouped.items():
        if not 0x8000 <= address <= 0xFFFF:
            continue
        physical_bank = bank * 2 + int(address >= 0xC000)
        name = preferred_label(names, configured.get((bank, address)))
        result[physical_bank].append((address, name))
    for labels in result.values():
        labels.sort()
    return result


def shared_ram_labels(registry: dict[str, Any]) -> list[dict[str, Any]]:
    labels = [item for item in registry["memory_symbols"] if "banks" not in item]
    return sorted(labels, key=lambda item: number(item["address"]))


def fceux_bank_text(labels: list[tuple[int, str]]) -> str:
    return "".join(f"${address:04X}#{name}#\n" for address, name in labels)


def fceux_ram_text(labels: list[dict[str, Any]]) -> str:
    lines: list[str] = []
    for item in labels:
        address = number(item["address"])
        size = int(item.get("size", 1))
        array = f"/{size:X}" if size > 1 else ""
        lines.append(
            f"${address:04X}{array}#{item['name']}#{item['evidence']}\n"
        )
    return "".join(lines)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def expected_outputs(
    debug_path: Path,
    rom_path: Path,
    debug: DebugData,
    registry: dict[str, Any],
    contract: dict[str, Any],
) -> tuple[dict[str, str], dict[str, Any]]:
    fceux = contract["fceux"]
    labels = fceux_prg_labels(debug, registry)
    ram_labels = shared_ram_labels(registry)
    rom_name = str(fceux["rom_filename"])
    outputs = {
        f"{rom_name}.{bank:X}.nl": fceux_bank_text(labels[bank])
        for bank in range(int(fceux["prg_bank_count"]))
    }
    outputs[f"{rom_name}.ram.nl"] = fceux_ram_text(ram_labels)
    linker = symbol_index(debug)
    summary = {
        "schema_version": 1,
        "rom_sha256": sha256(rom_path),
        "linker_debug_sha256": sha256(debug_path),
        "mesen": {
            "format": "cc65-dbg-v2",
            "source_file_count": len(debug.files),
            "linker_symbol_count": len(debug.symbols),
            "configured_prg_symbol_count": len(registry["symbols"]),
            "configured_memory_symbol_count": len(registry["memory_symbols"]),
        },
        "fceux": {
            "format": "banked-nl",
            "prg_bank_count": len(labels),
            "prg_label_count": sum(len(items) for items in labels.values()),
            "labels_by_bank": [len(labels[index]) for index in range(len(labels))],
            "shared_ram_label_count": len(ram_labels),
        },
        "required_program_probes": [
            {
                "name": item["name"],
                "bank": int(item["bank"]),
                "address": item["address"],
                "linker_symbol_id_present": item["name"] in linker,
            }
            for item in contract["required_program_symbols"]
        ],
        "required_ram_probes": [
            {
                "name": item["name"],
                "address": item["address"],
                "linker_symbol_id_present": item["name"] in linker,
            }
            for item in contract["required_ram_symbols"]
        ],
    }
    outputs["doraemon.symbols.json"] = json.dumps(summary, indent=2) + "\n"
    return outputs, summary


def validate_debugger_configs(
    registry: dict[str, Any],
    breakpoints: dict[str, Any],
    watches: dict[str, Any],
) -> list[str]:
    errors: list[str] = []
    prg = {
        (int(item["bank"]), str(item["name"])): number(item["address"])
        for item in registry["symbols"]
    }
    memory = {str(item["name"]): item for item in registry["memory_symbols"]}
    for item in breakpoints.get("breakpoints", []):
        key = (int(item["bank"]), str(item["symbol"]))
        if prg.get(key) != number(item["address"]):
            errors.append(f"debugger breakpoint is stale: {item.get('symbol')}")
    for item in watches.get("watches", []):
        symbol = memory.get(str(item["name"]))
        if symbol is None or (
            number(symbol["address"]) != number(item["address"])
            or int(symbol.get("size", 1)) != int(item["size"])
            or "banks" in symbol
        ):
            errors.append(f"debugger watch is stale or bank-scoped: {item.get('name')}")
    return errors


def validate_all(
    project_root: Path,
    debug_path: Path,
    rom_path: Path,
    registry: dict[str, Any],
    contract: dict[str, Any],
    breakpoints: dict[str, Any],
    watches: dict[str, Any],
    output_dir: Path | None = None,
) -> tuple[list[str], dict[str, Any], dict[str, str]]:
    debug = parse_debug(debug_path)
    errors = validate_segment_layout(debug, contract)
    errors.extend(validate_sources(project_root, debug))
    errors.extend(validate_registry(debug, registry, contract))
    errors.extend(validate_debugger_configs(registry, breakpoints, watches))
    outputs, summary = expected_outputs(
        debug_path, rom_path, debug, registry, contract
    )
    expected_metrics = contract["expected_metrics"]
    metrics = {
        "source_file_count": summary["mesen"]["source_file_count"],
        "linker_symbol_count": summary["mesen"]["linker_symbol_count"],
        "configured_prg_symbol_count": summary["mesen"]["configured_prg_symbol_count"],
        "configured_memory_symbol_count": summary["mesen"]["configured_memory_symbol_count"],
        "fceux_prg_label_count": summary["fceux"]["prg_label_count"],
        "fceux_labels_by_bank": summary["fceux"]["labels_by_bank"],
        "fceux_shared_ram_label_count": summary["fceux"]["shared_ram_label_count"],
    }
    if metrics != expected_metrics:
        errors.append("debug-symbol metrics differ from the pinned inventory")
    if summary["rom_sha256"] != str(contract["rom_sha256"]).lower():
        errors.append("debug-symbol ROM SHA256 differs")
    if output_dir is not None:
        for name, expected in outputs.items():
            path = output_dir / name
            if not path.is_file() or path.read_text(encoding="utf-8") != expected:
                errors.append(f"generated debugger symbols are stale: {name}")
    return errors, summary, outputs


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    for command in ("generate", "validate"):
        child = subparsers.add_parser(command)
        child.add_argument("--dbg", required=True, type=Path)
        child.add_argument("--rom", required=True, type=Path)
        child.add_argument("--symbols", required=True, type=Path)
        child.add_argument("--contract", required=True, type=Path)
        child.add_argument("--breakpoints", required=True, type=Path)
        child.add_argument("--watches", required=True, type=Path)
        child.add_argument("--output-dir", required=True, type=Path)
    args = parser.parse_args()
    project_root = Path(__file__).resolve().parents[2]
    try:
        registry = load_json(args.symbols, "symbol registry")
        contract = load_json(args.contract, "debug-symbol contract")
        breakpoints = load_json(args.breakpoints, "debugger breakpoints")
        watches = load_json(args.watches, "debugger watches")
        errors, summary, outputs = validate_all(
            project_root,
            args.dbg,
            args.rom,
            registry,
            contract,
            breakpoints,
            watches,
            args.output_dir if args.command == "validate" else None,
        )
        if errors:
            for error in errors:
                print(f"[ERROR] {error}")
            return 1
        if args.command == "generate":
            args.output_dir.mkdir(parents=True, exist_ok=True)
            for name, content in outputs.items():
                (args.output_dir / name).write_text(
                    content, encoding="utf-8", newline="\n"
                )
        print(
            f"[OK] debugger symbols: {summary['mesen']['linker_symbol_count']} "
            f"ld65 symbols / {summary['mesen']['source_file_count']} sources; "
            f"{summary['fceux']['prg_label_count']} FCEUX PRG labels / "
            f"{summary['fceux']['shared_ram_label_count']} RAM labels"
        )
        return 0
    except (OSError, KeyError, TypeError, ValueError, json.JSONDecodeError) as exc:
        print(f"[ERROR] debug-symbol operation failed: {exc}")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
