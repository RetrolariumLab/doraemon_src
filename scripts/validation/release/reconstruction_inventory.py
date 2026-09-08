#!/usr/bin/env python3
"""Measure semantic reconstruction without treating module layout as naming."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Any


LABEL_RE = re.compile(r"^([A-Za-z_][A-Za-z0-9_]*):", re.MULTILINE)
NEUTRAL_ROUTINE_RE = re.compile(r"^Bank([0-3])_Func_[0-9A-F]{4}$")
NEUTRAL_LOCAL_RE = re.compile(r"^Bank([0-3])_Label_[0-9A-F]{4}$")
ENTRY_RE = re.compile(
    r"^entry\s+([0-3])\s+([0-9A-Fa-f]{4})\s+([A-Za-z0-9_]+)$"
)
DATA_RE = re.compile(
    r"^(\w+)\s+([0-3])\s+([0-9A-Fa-f]{4})\s+"
    r"([0-9A-Fa-f]{4})\s+([A-Za-z0-9_]+)$"
)
UNKNOWN_HEADING_RE = re.compile(r"^## ([A-Z0-9-]+) - .+$", re.MULTILINE)


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def empty_bank_counts() -> dict[str, dict[str, int]]:
    return {
        str(bank): {
            "global_labels": 0,
            "semantic_labels": 0,
            "neutral_routine_labels": 0,
            "neutral_local_labels": 0,
        }
        for bank in range(4)
    }


def source_label_metrics(
    project_root: Path, modules: dict[str, Any]
) -> dict[str, Any]:
    by_bank = empty_bank_counts()
    paths: set[str] = set()
    labels_by_bank: dict[str, set[str]] = {
        str(bank): set() for bank in range(4)
    }
    for module in modules["modules"]:
        bank = str(int(module["bank"]))
        relative = str(module["path"])
        if relative in paths:
            raise ValueError(f"duplicate source module path: {relative}")
        paths.add(relative)
        source = project_root / "src" / relative
        labels_by_bank[bank].update(
            LABEL_RE.findall(source.read_text(encoding="utf-8"))
        )
    for bank, labels in labels_by_bank.items():
        for label in sorted(labels):
            by_bank[bank]["global_labels"] += 1
            routine = NEUTRAL_ROUTINE_RE.fullmatch(label)
            local = NEUTRAL_LOCAL_RE.fullmatch(label)
            if routine:
                if routine.group(1) != bank:
                    raise ValueError(f"neutral routine bank differs: {label}")
                by_bank[bank]["neutral_routine_labels"] += 1
            elif local:
                if local.group(1) != bank:
                    raise ValueError(f"neutral local bank differs: {label}")
                by_bank[bank]["neutral_local_labels"] += 1
            else:
                by_bank[bank]["semantic_labels"] += 1
    totals = {
        key: sum(values[key] for values in by_bank.values())
        for key in next(iter(by_bank.values()))
    }
    return {"module_count": len(paths), "total": totals, "by_bank": by_bank}


def prg_symbol_metrics(registry: dict[str, Any]) -> dict[str, Any]:
    by_bank = {
        str(bank): {"semantic_code_symbols": 0, "operand_symbols": 0}
        for bank in range(4)
    }
    symbol_index: dict[tuple[int, int], str] = {}
    for item in registry["symbols"]:
        bank = int(item["bank"])
        address = number(item["address"])
        if item.get("operand_symbol", False):
            by_bank[str(bank)]["operand_symbols"] += 1
        else:
            by_bank[str(bank)]["semantic_code_symbols"] += 1
            symbol_index[(bank, address)] = str(item["name"])
    totals = {
        key: sum(values[key] for values in by_bank.values())
        for key in next(iter(by_bank.values()))
    }
    return {"total": totals, "by_bank": by_bank, "index": symbol_index}


def code_entry_metrics(text: str, symbols: dict[tuple[int, int], str]) -> dict[str, Any]:
    by_bank = {
        str(bank): {"entries": 0, "semantic_symbols": 0}
        for bank in range(4)
    }
    seen: set[tuple[int, int]] = set()
    for raw in text.splitlines():
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        match = ENTRY_RE.fullmatch(line)
        if not match:
            raise ValueError(f"invalid PRG code entry: {raw}")
        bank = int(match.group(1))
        address = int(match.group(2), 16)
        key = (bank, address)
        if key in seen:
            raise ValueError(f"duplicate PRG code entry: {bank}:${address:04X}")
        seen.add(key)
        by_bank[str(bank)]["entries"] += 1
        symbol = symbols.get(key)
        if symbol and not (
            NEUTRAL_ROUTINE_RE.fullmatch(symbol)
            or NEUTRAL_LOCAL_RE.fullmatch(symbol)
        ):
            by_bank[str(bank)]["semantic_symbols"] += 1
    totals = {
        key: sum(values[key] for values in by_bank.values())
        for key in next(iter(by_bank.values()))
    }
    return {"total": totals, "by_bank": by_bank}


def ram_metrics(registry: dict[str, Any]) -> dict[str, Any]:
    shared_symbols = 0
    shared_bytes = 0
    scoped = {
        str(bank): {"symbols": 0, "bytes": 0} for bank in range(4)
    }
    effective = {
        str(bank): {"symbols": 0, "bytes": 0} for bank in range(4)
    }
    for item in registry["memory_symbols"]:
        size = int(item.get("size", 1))
        banks = item.get("banks")
        if banks is None:
            shared_symbols += 1
            shared_bytes += size
            owners = range(4)
        else:
            owners = [int(bank) for bank in banks]
            for bank in owners:
                scoped[str(bank)]["symbols"] += 1
                scoped[str(bank)]["bytes"] += size
        for bank in owners:
            effective[str(bank)]["symbols"] += 1
            effective[str(bank)]["bytes"] += size
    return {
        "unique_symbols": len(registry["memory_symbols"]),
        "shared": {"symbols": shared_symbols, "bytes": shared_bytes},
        "bank_scoped": scoped,
        "effective_by_bank": effective,
    }


def merged_size(ranges: list[tuple[int, int]]) -> int:
    total = 0
    previous_end = -1
    for start, end in sorted(ranges):
        if start <= previous_end:
            raise ValueError("typed PRG data ranges overlap within a bank")
        total += end - start + 1
        previous_end = end
    return total


def typed_data_metrics(text: str) -> dict[str, Any]:
    ranges: dict[str, list[tuple[int, int]]] = {str(bank): [] for bank in range(4)}
    kinds: dict[str, dict[str, int]] = {str(bank): {} for bank in range(4)}
    for raw in text.splitlines():
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        match = DATA_RE.fullmatch(line)
        if not match:
            raise ValueError(f"invalid typed PRG data range: {raw}")
        kind, bank, start_text, end_text, _name = match.groups()
        start = int(start_text, 16)
        end = int(end_text, 16)
        if end < start:
            raise ValueError(f"reversed typed PRG data range: {raw}")
        ranges[bank].append((start, end))
        kinds[bank][kind] = kinds[bank].get(kind, 0) + end - start + 1
    by_bank = {
        bank: {
            "range_count": len(ranges[bank]),
            "typed_bytes": merged_size(ranges[bank]),
            "bytes_by_kind": dict(sorted(kinds[bank].items())),
        }
        for bank in ranges
    }
    return {
        "total": {
            "range_count": sum(item["range_count"] for item in by_bank.values()),
            "typed_bytes": sum(item["typed_bytes"] for item in by_bank.values()),
        },
        "by_bank": by_bank,
    }


def unknown_metrics(text: str) -> dict[str, Any]:
    headings = list(UNKNOWN_HEADING_RE.finditer(text))
    identifiers: list[str] = []
    claim_count = 0
    for index, heading in enumerate(headings):
        end = headings[index + 1].start() if index + 1 < len(headings) else len(text)
        body = text[heading.end():end]
        claims = len(re.findall(r"^- Unknown:", body, re.MULTILINE))
        if claims:
            identifiers.append(heading.group(1))
            claim_count += claims
    return {
        "section_count": len(identifiers),
        "claim_count": claim_count,
        "section_ids": identifiers,
    }


def calculate(project_root: Path) -> dict[str, Any]:
    reconstruction = project_root / "config" / "reconstruction"
    modules = load_json(reconstruction / "source_modules.json")
    registry = load_json(reconstruction / "symbols.json")
    labels = source_label_metrics(project_root, modules)
    prg_symbols = prg_symbol_metrics(registry)
    code_entries = code_entry_metrics(
        (reconstruction / "prg_code_entries.txt").read_text(encoding="utf-8"),
        prg_symbols.pop("index"),
    )
    return {
        "source_labels": labels,
        "evidence_backed_prg_symbols": prg_symbols,
        "indirect_code_entries": code_entries,
        "ram_aliases": ram_metrics(registry),
        "typed_prg_data": typed_data_metrics(
            (reconstruction / "prg_data_ranges.txt").read_text(encoding="utf-8")
        ),
        "open_unknowns": unknown_metrics(
            (project_root / "docs" / "unknowns.md").read_text(encoding="utf-8")
        ),
    }


def validate(actual: dict[str, Any], manifest: dict[str, Any]) -> list[str]:
    if manifest.get("schema_version") != 1:
        return ["reconstruction inventory schema differs"]
    if manifest.get("snapshot") != actual:
        return ["reconstruction inventory snapshot is stale"]
    return []


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--manifest",
        type=Path,
        default=Path("config/reconstruction/reconstruction_inventory.json"),
    )
    parser.add_argument("--print", action="store_true", dest="print_snapshot")
    args = parser.parse_args()
    project_root = Path(__file__).resolve().parents[3]
    try:
        actual = calculate(project_root)
        if args.print_snapshot:
            print(json.dumps(actual, indent=2))
            return 0
        manifest = load_json(project_root / args.manifest)
        errors = validate(actual, manifest)
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] reconstruction inventory failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    totals = actual["source_labels"]["total"]
    entries = actual["indirect_code_entries"]["total"]
    print(
        "[OK] reconstruction inventory: "
        f"{totals['semantic_labels']} semantic labels, "
        f"{totals['neutral_routine_labels']} neutral routines, "
        f"{totals['neutral_local_labels']} neutral locals; "
        f"{entries['semantic_symbols']}/{entries['entries']} "
        "indirect entries semantic"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
