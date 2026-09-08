#!/usr/bin/env python3
"""Validate identities and effects for all World 1 descriptor objects."""

from __future__ import annotations

import argparse
from collections import Counter
import json
from pathlib import Path
from typing import Any


BANK_SIZE = 0x8000
CPU_BASE = 0x8000


def number(value: str | int) -> int:
    return value if isinstance(value, int) else int(value, 0)


def bank_slice(prg: bytes, bank: int, address: int, size: int) -> bytes:
    offset = bank * BANK_SIZE + address - CPU_BASE
    if not 0 <= bank < 4 or not 0 <= offset <= len(prg) - size:
        raise ValueError("World 1 descriptor-identity range is outside PRG")
    return prg[offset:offset + size]


def named(entries: Any, name: str) -> dict[str, Any]:
    matches = [entry for entry in entries if entry.get("name") == name]
    if len(matches) != 1:
        raise ValueError(f"expected one entry named {name!r}")
    return matches[0]


def placement_counts(authoring: dict[str, Any]) -> Counter[int]:
    counts: Counter[int] = Counter()
    for placement_list in authoring.get("placement_lists", []):
        for record in placement_list.get("records", []):
            value = number(record["type"])
            if value & 0x80:
                counts[value & 0x0F] += 1
    return counts


def validate_sources(
    manifest: dict[str, Any], identities: list[dict[str, Any]]
) -> tuple[list[str], int]:
    errors: list[str] = []
    sources = manifest.get("identity_sources", [])
    source_ids = [str(source.get("id", "")) for source in sources]
    if not source_ids or any(not value for value in source_ids) or len(
        source_ids
    ) != len(set(source_ids)):
        return ["World 1 descriptor identity sources must be unique"], 0
    source_set = set(source_ids)
    external = source_set - {"local_rom"}
    for identity in identities:
        index = int(identity["descriptor_index"])
        evidence = {str(value) for value in identity.get("evidence", [])}
        if not evidence or not evidence <= source_set:
            errors.append(f"descriptor {index:02X}: identity evidence differs")
        if "local_rom" not in evidence:
            errors.append(f"descriptor {index:02X}: local-ROM evidence is absent")
        if identity.get("confidence") == "confirmed" and not evidence & external:
            errors.append(
                f"descriptor {index:02X}: confirmed identity lacks external evidence"
            )
    return errors, len(sources)


def validate(
    prg: bytes,
    manifest: dict[str, Any],
    objects: dict[str, Any],
    authoring: dict[str, Any],
    dispatch: dict[str, Any],
    metasprites: dict[str, Any],
    symbols: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if manifest.get("schema_version") != 1:
        return ["unsupported World 1 descriptor-identity schema"], {}
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    errors: list[str] = []
    bank = int(manifest["bank"])
    identities = manifest.get("identities", [])
    descriptor_count = int(manifest["descriptor_count"])
    if bank != 0 or len(identities) != descriptor_count:
        return ["World 1 descriptor identities must be 13 bank-0 entries"], {}
    if [int(entry.get("descriptor_index", -1)) for entry in identities] != list(
        range(descriptor_count)
    ):
        return ["World 1 descriptor identity indexes are not contiguous"], {}

    source_errors, source_count = validate_sources(manifest, identities)
    errors.extend(source_errors)
    descriptor_spec = objects["world1_descriptor_objects"]
    records = descriptor_spec["records"]
    if int(descriptor_spec["bank"]) != bank or len(records) != descriptor_count:
        errors.append("World 1 descriptor structural catalog differs")
        records = []
    counts = placement_counts(authoring)
    direct_indexes = {
        int(entry["id"])
        for entry in metasprites.get("index_entries", [])
        if entry.get("kind") == "direct"
    }
    transient_values = [
        number(value)
        for value in descriptor_spec["transient_selector_table"]["values"]
    ]
    if transient_values != [6, 10, 11, 2, 12]:
        errors.append("World 1 descriptor selector identities differ")

    item_dispatch = named(dispatch.get("tables", []), "world1_city_item_handlers")
    handler_targets = [number(value) for value in item_dispatch["targets"]]
    if int(item_dispatch["bank"]) != bank or len(handler_targets) != 11:
        errors.append("World 1 descriptor handler domain differs")
    expected_symbols = [
        "manhole",
        "anywhere_door",
        "stopwatch",
        "genki_candy",
        "one_up",
        "weapon_upgrade",
        "dorayaki",
        "rapid_fire_drink",
        "flash_light",
        "programmer_face",
        "gold_bar",
        "diamond",
        "invulnerability",
    ]
    if [entry.get("symbol") for entry in identities] != expected_symbols:
        errors.append("World 1 descriptor identity roster differs")
    symbol_map = {
        (int(entry["bank"]), number(entry["address"])): str(entry["name"])
        for entry in symbols.get("symbols", [])
    }

    confirmed = 0
    for index, identity in enumerate(identities):
        if identity.get("confidence") not in {"confirmed", "structural"}:
            errors.append(f"descriptor {index:02X}: unknown confidence")
        confirmed += identity.get("confidence") == "confirmed"
        if records:
            record = records[index]
            comparisons = (
                (number(identity["runtime_type"]), number(record[0]), "runtime type"),
                (
                    number(identity["metasprite_base"]),
                    number(record[1]),
                    "metasprite base",
                ),
                (number(identity["render_flags"]), number(record[2]), "render flags"),
                (
                    number(identity["primary_behavior"]),
                    number(record[3]),
                    "primary behavior",
                ),
            )
            for actual, expected, field in comparisons:
                if actual != expected:
                    errors.append(f"descriptor {index:02X}: {field} differs")
        if int(identity["placement_count"]) != counts[index]:
            errors.append(f"descriptor {index:02X}: placement count differs")
        selector_slots = [
            slot for slot, descriptor_index in enumerate(transient_values)
            if descriptor_index == index
        ]
        if [number(value) for value in identity["selector_slots"]] != selector_slots:
            errors.append(f"descriptor {index:02X}: selector slots differ")
        metasprite = number(identity["metasprite_base"])
        if metasprite:
            if metasprite not in direct_indexes:
                errors.append(f"descriptor {index:02X}: metasprite is not direct")
        elif [number(value) for value in identity["dynamic_metasprites"]] != [
            0x2A,
            0x2B,
            0x2C,
        ]:
            errors.append("World 1 weapon-upgrade metasprite sequence differs")
        handler = number(identity["handler_address"])
        if index >= 2 and handler != handler_targets[index - 2]:
            errors.append(f"descriptor {index:02X}: handler mapping differs")
        if symbol_map.get((bank, handler)) != identity.get("handler_symbol"):
            errors.append(f"descriptor {index:02X}: handler symbol differs")
        signature = bytes.fromhex(str(identity["effect_signature"]["bytes"]))
        signature_address = number(identity["effect_signature"]["address"])
        if bank_slice(prg, bank, signature_address, len(signature)) != signature:
            errors.append(f"descriptor {index:02X}: effect signature differs")

    return errors, {
        "descriptor_count": descriptor_count,
        "confirmed_count": confirmed,
        "persistent_identity_count": sum(bool(counts[index]) for index in range(13)),
        "selector_count": len(transient_values),
        "source_count": source_count,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prg", type=Path, required=True)
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--objects", type=Path, required=True)
    parser.add_argument("--authoring", type=Path, required=True)
    parser.add_argument("--dispatch", type=Path, required=True)
    parser.add_argument("--metasprites", type=Path, required=True)
    parser.add_argument("--symbols", type=Path, required=True)
    args = parser.parse_args()
    try:
        documents = [
            json.loads(path.read_text(encoding="utf-8"))
            for path in (
                args.manifest,
                args.objects,
                args.authoring,
                args.dispatch,
                args.metasprites,
                args.symbols,
            )
        ]
        errors, report = validate(args.prg.read_bytes(), *documents)
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 1 descriptor-identity audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] {report['descriptor_count']} World 1 descriptor identities: "
        f"{report['persistent_identity_count']} persistent, "
        f"{report['selector_count']} selector slots, "
        f"{report['confirmed_count']} confirmed"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
