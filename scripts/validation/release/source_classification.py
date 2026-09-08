#!/usr/bin/env python3
"""Audit byte-level code/data classification in the canonical ca65 source."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Any


PRG_BANK_COUNT = 4
PRG_BANK_SIZE = 0x8000
CPU_BASE = 0x8000
DATA_DIRECTIVES = {
    ".addr",
    ".byte",
    ".dword",
    ".faraddr",
    ".incbin",
    ".res",
    ".word",
}
SUPPLEMENTAL_KINDS = {
    "typed-data",
    "encoded-code",
    "padding",
    "registered-unknown",
}
BYTE_TOKEN_RE = re.compile(r"(?:[0-9A-F]{2}|rr)")
SEGMENT_RE = re.compile(r'\.segment "PRG([0-3])"')
UNKNOWN_HEADING_RE = re.compile(r"^## ([A-Z0-9-]+)\b", re.MULTILINE)


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def safe_project_path(project_root: Path, relative: str) -> Path | None:
    if not relative or Path(relative).is_absolute():
        return None
    root = project_root.resolve()
    resolved = (project_root / relative).resolve()
    if resolved != root and root not in resolved.parents:
        return None
    return resolved


def expand_range(bank: int, start: int, end: int) -> set[tuple[int, int]]:
    return {(bank, address) for address in range(start, end + 1)}


def parse_range(item: dict[str, Any]) -> tuple[int, int, int]:
    bank = item.get("bank")
    start = int(str(item.get("start", "")), 16)
    end = int(str(item.get("end", "")), 16)
    if (
        not isinstance(bank, int)
        or not 0 <= bank < PRG_BANK_COUNT
        or not CPU_BASE <= start <= end <= 0xFFFF
    ):
        raise ValueError(f"invalid PRG classification range: {item}")
    return bank, start, end


def parse_base_ranges(path: Path) -> set[tuple[int, int]]:
    result: set[tuple[int, int]] = set()
    for line_number, raw in enumerate(
        path.read_text(encoding="utf-8").splitlines(), 1
    ):
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        fields = line.split()
        if len(fields) != 5:
            raise ValueError(f"invalid typed range at {path}:{line_number}")
        bank = int(fields[1], 10)
        start = int(fields[2], 16)
        end = int(fields[3], 16)
        current = expand_range(bank, start, end)
        if result & current:
            raise ValueError(f"overlapping typed range at {path}:{line_number}")
        result |= current
    return result


def parse_listing(path: Path) -> dict[str, set[tuple[int, int]]]:
    """Recover statement extents despite ca65 eliding long byte continuations."""

    statements: dict[int, list[tuple[int, str, int]]] = {
        bank: [] for bank in range(PRG_BANK_COUNT)
    }
    bank: int | None = None
    for line_number, line in enumerate(
        path.read_text(encoding="utf-8").splitlines(), 1
    ):
        segment = SEGMENT_RE.search(line)
        if segment:
            bank = int(segment.group(1))
            continue
        if '.segment "CHR"' in line:
            bank = None
            continue
        if bank is None or len(line) < 29 or line[6:7] != "r":
            continue
        tokens = line[11:23].split()
        source = line[28:].strip()
        if (
            not source
            or not tokens
            or not all(BYTE_TOKEN_RE.fullmatch(token) for token in tokens)
        ):
            continue
        address = CPU_BASE + int(line[:6], 16)
        first = source.split()[0]
        kind = "directive" if first in DATA_DIRECTIVES else "instruction"
        statements[bank].append((address, kind, line_number))

    result = {"instruction": set(), "directive": set()}
    for current_bank, entries in statements.items():
        if not entries or entries[0][0] != CPU_BASE:
            raise ValueError(f"bank {current_bank} listing does not start at 0x8000")
        for index, (start, kind, line_number) in enumerate(entries):
            end = entries[index + 1][0] - 1 if index + 1 < len(entries) else 0xFFFF
            if end < start:
                raise ValueError(
                    f"bank {current_bank} listing order fails at line {line_number}"
                )
            size = end - start + 1
            if kind == "instruction" and size > 3:
                raise ValueError(
                    f"instruction-sized listing gap at line {line_number}: {size}"
                )
            result[kind] |= expand_range(current_bank, start, end)
        bank_bytes = {
            (current_bank, address) for address in range(CPU_BASE, 0x10000)
        }
        classified = {
            item
            for values in result.values()
            for item in values
            if item[0] == current_bank
        }
        if classified != bank_bytes:
            raise ValueError(f"bank {current_bank} listing coverage is incomplete")
    if result["instruction"] & result["directive"]:
        raise ValueError("listing classifies bytes as both instruction and directive")
    return result


def unknown_sections(text: str) -> set[str]:
    headings = list(UNKNOWN_HEADING_RE.finditer(text))
    identifiers: set[str] = set()
    for index, heading in enumerate(headings):
        end = headings[index + 1].start() if index + 1 < len(headings) else len(text)
        if re.search(r"^- Unknown:", text[heading.end() : end], re.MULTILINE):
            identifiers.add(heading.group(1))
    return identifiers


def build_metrics(
    listing: dict[str, set[tuple[int, int]]],
    classified: dict[str, set[tuple[int, int]]],
) -> dict[str, Any]:
    by_bank: dict[str, dict[str, int]] = {}
    for bank in range(PRG_BANK_COUNT):
        values = {
            "instruction_bytes": sum(
                item[0] == bank for item in listing["instruction"]
            ),
            "directive_bytes": sum(item[0] == bank for item in listing["directive"]),
        }
        for kind, addresses in classified.items():
            values[kind] = sum(item[0] == bank for item in addresses)
        by_bank[str(bank)] = values
    return {
        "prg_bytes": sum(len(values) for values in listing.values()),
        "instruction_bytes": len(listing["instruction"]),
        "directive_bytes": len(listing["directive"]),
        "classification_bytes": {
            kind: len(addresses) for kind, addresses in classified.items()
        },
        "by_bank": by_bank,
    }


def validate(
    project_root: Path,
    document: dict[str, Any],
    listing_path: Path,
    base_ranges_path: Path,
) -> tuple[list[str], dict[str, Any]]:
    errors: list[str] = []
    if document.get("schema_version") != 1:
        errors.append("source classification manifest is not schema 1")
    if document.get("status") != "complete":
        errors.append("source classification manifest is not complete")
    groups = document.get("classifications")
    if not isinstance(groups, list) or not groups:
        return [*errors, "source classification groups are missing"], {}

    try:
        listing = parse_listing(listing_path)
        base_typed = parse_base_ranges(base_ranges_path)
    except (OSError, ValueError) as exc:
        return [*errors, str(exc)], {}

    classified = {"base-typed": base_typed}
    for kind in SUPPLEMENTAL_KINDS:
        classified[kind] = set()
    identifiers: set[str] = set()
    docs_path = project_root / "docs" / "unknowns.md"
    registered_unknowns = (
        unknown_sections(docs_path.read_text(encoding="utf-8"))
        if docs_path.is_file()
        else set()
    )
    fill_ranges: list[tuple[int, int, int, int]] = []
    for group in groups:
        identifier = str(group.get("id", ""))
        kind = group.get("kind")
        if not identifier or identifier in identifiers:
            errors.append(f"duplicate or empty classification id: {identifier}")
        identifiers.add(identifier)
        if kind not in SUPPLEMENTAL_KINDS:
            errors.append(f"invalid classification kind for {identifier}: {kind}")
            continue
        if kind == "registered-unknown":
            unknown_id = group.get("unknown_id")
            if unknown_id not in registered_unknowns:
                errors.append(
                    f"unregistered unknown id for {identifier}: {unknown_id}"
                )
        evidence = group.get("evidence")
        if not isinstance(evidence, list) or not evidence:
            errors.append(f"classification evidence is missing: {identifier}")
        else:
            for relative in evidence:
                path = safe_project_path(project_root, str(relative))
                if path is None or not path.is_file():
                    errors.append(
                        f"missing classification evidence for {identifier}: {relative}"
                    )
        ranges = group.get("ranges")
        if not isinstance(ranges, list) or not ranges:
            errors.append(f"classification ranges are missing: {identifier}")
            continue
        for item in ranges:
            try:
                bank, start, end = parse_range(item)
            except (TypeError, ValueError) as exc:
                errors.append(str(exc))
                continue
            addresses = expand_range(bank, start, end)
            if classified[kind] & addresses:
                errors.append(f"overlapping {kind} range in {identifier}")
            classified[kind] |= addresses
            if kind == "padding":
                fill_byte = int(str(group.get("fill_byte", "")), 16)
                fill_ranges.append((bank, start, end, fill_byte))

    owners: dict[tuple[int, int], str] = {}
    for kind, addresses in classified.items():
        for address in addresses:
            previous = owners.get(address)
            if previous is not None:
                errors.append(
                    f"classification overlap at bank {address[0]} "
                    f"0x{address[1]:04X}: {previous}/{kind}"
                )
            owners[address] = kind
    directive_bytes = listing["directive"]
    classified_bytes = set(owners)
    missing = directive_bytes - classified_bytes
    extra = classified_bytes - directive_bytes
    if missing:
        first = min(missing)
        errors.append(
            f"{len(missing)} directive bytes are unclassified; "
            f"first is bank {first[0]} 0x{first[1]:04X}"
        )
    if extra:
        first = min(extra)
        errors.append(
            f"{len(extra)} classifications cover instruction bytes; "
            f"first is bank {first[0]} 0x{first[1]:04X}"
        )

    prg_relative = document.get("prg_asset", "")
    prg_path = safe_project_path(project_root, str(prg_relative))
    if prg_path is None or not prg_path.is_file():
        errors.append(f"missing classification PRG asset: {prg_relative}")
    else:
        prg = prg_path.read_bytes()
        if len(prg) != PRG_BANK_COUNT * PRG_BANK_SIZE:
            errors.append(f"classification PRG asset has invalid size: {len(prg)}")
        else:
            for bank, start, end, fill_byte in fill_ranges:
                offset = bank * PRG_BANK_SIZE + start - CPU_BASE
                actual = prg[offset : offset + end - start + 1]
                if actual != bytes([fill_byte]) * len(actual):
                    errors.append(
                        f"padding differs in bank {bank} 0x{start:04X}-0x{end:04X}"
                    )

    metrics = build_metrics(listing, classified)
    if metrics != document.get("expected_metrics"):
        errors.append("source classification metrics differ from pinned snapshot")
    return errors, metrics


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--manifest", required=True)
    parser.add_argument("--listing")
    parser.add_argument("--base-ranges")
    args = parser.parse_args()
    project_root = Path(__file__).resolve().parents[3]
    manifest_path = Path(args.manifest)
    if not manifest_path.is_absolute():
        manifest_path = project_root / manifest_path
    document = load_json(manifest_path)
    listing_relative = args.listing or document.get("listing", "")
    base_relative = args.base_ranges or document.get("base_typed_ranges", "")
    listing_path = safe_project_path(project_root, str(listing_relative))
    base_path = safe_project_path(project_root, str(base_relative))
    if listing_path is None or base_path is None:
        print("source classification: FAIL")
        print("- unsafe listing or base-range path")
        return 1
    errors, metrics = validate(project_root, document, listing_path, base_path)
    if errors:
        print("source classification: FAIL")
        for error in errors:
            print(f"- {error}")
        return 1
    kinds = metrics["classification_bytes"]
    print(
        "source classification: "
        f"{metrics['prg_bytes']} PRG bytes; "
        f"{metrics['instruction_bytes']} instruction; "
        f"{metrics['directive_bytes']} directive"
    )
    print(
        "directive ownership: "
        + ", ".join(f"{kind}={count}" for kind, count in kinds.items())
    )
    print("source classification: OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
