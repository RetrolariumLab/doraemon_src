#!/usr/bin/env python3
"""Validate and report Doraemon's duplicated cross-bank gateway block."""

from __future__ import annotations

import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import re
from typing import Any


BANK_SIZE = 0x8000
CPU_BASE = 0x8000
CALL_RE = re.compile(r"^\s+(JSR|JMP) Bank([0-3])_([A-Za-z0-9_]+)", re.MULTILINE)
NEUTRAL_SUFFIX_RE = re.compile(r"(?:Func|Label)_([0-9A-F]{4})$")


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def source_calls(
    source_root: Path,
    gateway_addresses: set[int],
    gateway_symbols: dict[str, int] | None = None,
) -> Counter[tuple[int, int, str]]:
    semantic = gateway_symbols or {}
    calls: Counter[tuple[int, int, str]] = Counter()
    for path in sorted(source_root.rglob("*.asm")):
        file_match = re.fullmatch(r"bank_([0-3])", path.stem)
        file_bank = int(file_match.group(1)) if file_match else None
        matches = CALL_RE.findall(path.read_text(encoding="utf-8"))
        for instruction, symbol_bank, suffix in matches:
            neutral = NEUTRAL_SUFFIX_RE.fullmatch(suffix)
            if neutral:
                address = int(neutral.group(1), 16)
            elif suffix in semantic:
                address = semantic[suffix]
            else:
                continue
            if address not in gateway_addresses:
                continue
            source_bank = int(symbol_bank)
            if file_bank is not None and source_bank != file_bank:
                raise ValueError(f"bank-qualified call differs from source file: {path}")
            calls[(source_bank, address, instruction)] += 1
    return calls


def expected_calls(document: dict[str, Any]) -> Counter[tuple[int, int, str]]:
    return Counter(
        {
            (
                int(item["source_bank"]),
                number(item["gateway"]),
                str(item["instruction"]),
            ): int(item["count"])
            for item in document["source_calls"]
        }
    )


def possible_edges(
    calls: Counter[tuple[int, int, str]], gateways: dict[int, dict[str, Any]]
) -> list[str]:
    edges: set[tuple[int, int]] = set()
    for source, address, _instruction in calls:
        gateway = gateways[address]
        target = gateway["target_prg"]
        if target == "current":
            continue
        target_bank = int(target)
        edges.add((source, target_bank))
        if gateway["kind"] == "switch-call-restore":
            edges.add((target_bank, source))
    return [f"{source}->{target}" for source, target in sorted(edges)]


def validate(
    prg: bytes,
    document: dict[str, Any],
    source_root: Path,
    symbols: dict[str, Any] | None = None,
) -> tuple[list[str], dict[str, Any]]:
    errors: list[str] = []
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    common = document["common_range"]
    start = number(common["start"])
    end = number(common["end"])
    size = end - start + 1
    if size != int(common["size"]):
        errors.append("common gateway range size differs")
    slices = [
        prg[
            bank * BANK_SIZE + start - CPU_BASE :
            bank * BANK_SIZE + end - CPU_BASE + 1
        ]
        for bank in range(4)
    ]
    if any(chunk != slices[0] for chunk in slices[1:]):
        errors.append("gateway block is not identical in all PRG banks")
    actual_sha1 = hashlib.sha1(slices[0]).hexdigest()
    if actual_sha1 != common["sha1"]:
        errors.append("gateway block SHA-1 differs")

    gateways = {number(item["address"]): item for item in document["gateways"]}
    if len(gateways) != len(document["gateways"]):
        errors.append("gateway addresses are not unique")
    for address, gateway in gateways.items():
        expected = bytes.fromhex(gateway["bytes"])
        offset = address - start
        if slices[0][offset : offset + len(expected)] != expected:
            errors.append(f"gateway bytes differ at ${address:04X}")

    symbol_addresses = {
        str(item["symbol"]): address
        for address, item in gateways.items()
        if "symbol" in item
    }
    if symbols is not None:
        declared = {
            (int(item["bank"]), number(item["address"]), str(item["name"]))
            for item in symbols["symbols"]
        }
        for suffix, address in symbol_addresses.items():
            for bank in range(4):
                name = f"Bank{bank}_{suffix}"
                if (bank, address, name) not in declared:
                    errors.append(f"gateway symbol missing: {name} at ${address:04X}")

    actual_calls = source_calls(source_root, set(gateways), symbol_addresses)
    declared_calls = expected_calls(document)
    if actual_calls != declared_calls:
        errors.append(
            "gateway source calls differ: "
            f"expected={sorted(declared_calls.items())}, "
            f"actual={sorted(actual_calls.items())}"
        )
    edges = possible_edges(actual_calls, gateways)
    if edges != document["possible_prg_edges"]:
        errors.append(f"possible PRG edges differ: {edges}")
    report = {
        "common_sha1": actual_sha1,
        "common_size": size,
        "gateway_count": len(gateways),
        "source_call_count": sum(actual_calls.values()),
        "possible_prg_edges": edges,
    }
    return errors, report


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prg", required=True, type=Path)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--source-root", default=Path("src/banks"), type=Path)
    parser.add_argument("--symbols", type=Path)
    parser.add_argument("--pretty", action="store_true")
    args = parser.parse_args()
    try:
        errors, report = validate(
            args.prg.read_bytes(),
            load_json(args.manifest),
            args.source_root,
            load_json(args.symbols) if args.symbols else None,
        )
    except (OSError, ValueError, KeyError, json.JSONDecodeError) as exc:
        print(f"[ERROR] bank gateway audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    if args.pretty:
        print(json.dumps(report, indent=2))
    print(
        f"[OK] {report['gateway_count']} gateways, "
        f"{report['source_call_count']} direct calls, "
        f"{len(report['possible_prg_edges'])} PRG edges"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
