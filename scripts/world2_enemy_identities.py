#!/usr/bin/env python3
"""Validate the evidence-backed World 2 enemy identity catalog."""

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
        raise ValueError("World 2 enemy-identity range is outside PRG")
    return prg[offset:offset + size]


def named(entries: Any, name: str, description: str) -> dict[str, Any]:
    matches = [entry for entry in entries if entry.get("name") == name]
    if len(matches) != 1:
        raise ValueError(f"expected one {description} named {name!r}")
    return matches[0]


def decode_score(code: int, digit_count: int) -> int:
    if code == 0:
        return 0
    digit_index = code >> 4
    addend = code & 0x0F
    if not 0 <= digit_index < digit_count or not 0 <= addend <= 9:
        raise ValueError(f"score reward code ${code:02X} is not decimal")
    return addend * 10 ** (digit_count - 1 - digit_index)


def property_values(enemy_states: dict[str, Any], name: str) -> list[int]:
    table = named(enemy_states.get("property_tables", []), name, "property table")
    return [number(value) for value in table["values"]]


def validate_sources(
    manifest: dict[str, Any], identities: list[dict[str, Any]]
) -> tuple[list[str], int]:
    errors: list[str] = []
    sources = manifest.get("identity_sources")
    if not isinstance(sources, list) or not sources:
        return ["World 2 identity-source list must be non-empty"], 0
    source_ids = [str(source.get("id", "")) for source in sources]
    if any(not value for value in source_ids) or len(source_ids) != len(
        set(source_ids)
    ):
        errors.append("World 2 identity-source ids must be unique and non-empty")
    source_set = set(source_ids)
    external_sources = source_set - {"local_rom"}
    for identity in identities:
        state = int(identity["state"])
        evidence = identity.get("evidence")
        if not isinstance(evidence, list) or not evidence:
            errors.append(f"state {state:02X}: identity evidence must be non-empty")
            continue
        evidence_set = {str(value) for value in evidence}
        if not evidence_set <= source_set:
            errors.append(f"state {state:02X}: identity cites an unknown source")
        if "local_rom" not in evidence_set:
            errors.append(f"state {state:02X}: identity lacks local-ROM evidence")
        if identity.get("confidence") == "confirmed" and not (
            evidence_set & external_sources
        ):
            errors.append(
                f"state {state:02X}: confirmed identity lacks external evidence"
            )
    return errors, len(sources)


def validate(
    prg: bytes,
    manifest: dict[str, Any],
    enemy_states: dict[str, Any],
    enemy_handlers: dict[str, Any],
    metasprites: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if manifest.get("schema_version") != 1:
        return ["unsupported World 2 enemy-identity schema"], {}
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    errors: list[str] = []
    bank = int(manifest["bank"])
    state_count = int(manifest["state_count"])
    if bank != 1 or int(enemy_states.get("bank", -1)) != bank:
        errors.append("World 2 enemy identities must belong to PRG bank 1")
    identities = manifest.get("identities")
    if not isinstance(identities, list) or len(identities) != state_count:
        return [f"World 2 identities must contain {state_count} records"], {}
    if [int(entry.get("state", -1)) for entry in identities] != list(
        range(1, state_count + 1)
    ):
        errors.append("World 2 identity state ids are not contiguous")

    source_errors, source_count = validate_sources(manifest, identities)
    errors.extend(source_errors)
    symbols = [str(entry.get("symbol", "")) for entry in identities]
    if any(not symbol for symbol in symbols) or len(symbols) != len(set(symbols)):
        errors.append("World 2 identity symbols must be unique and non-empty")
    allowed_confidence = {"confirmed", "structural", "unresolved"}
    allowed_categories = {
        "enemy",
        "background_enemy",
        "boss",
        "boss_helper",
        "boss_projectile",
    }
    handlers = enemy_handlers.get("states", [])
    render_entries = metasprites.get("enemy_state_render_indexes", [])
    if [int(entry.get("state", -1)) for entry in handlers] != list(
        range(1, state_count + 1)
    ):
        errors.append("World 2 handler states differ from identity catalog")
        handlers = []
    if [int(entry.get("state", -1)) for entry in render_entries] != list(
        range(1, state_count + 1)
    ):
        errors.append("World 2 render states differ from identity catalog")
        render_entries = []

    attacks = property_values(enemy_states, "attack_period_by_state")
    thresholds = property_values(enemy_states, "damage_threshold_by_state")
    rewards = property_values(enemy_states, "score_reward_code_by_state")
    if any(len(values) != state_count + 1 for values in (attacks, thresholds, rewards)):
        errors.append("World 2 property table length differs from identity catalog")
    score_spec = manifest["score_encoding"]
    digit_count = int(score_spec["digit_count"])
    if digit_count != 7 or score_spec.get("digit_index_field") != "high_nibble":
        errors.append("World 2 score encoding differs")
    if score_spec.get("digit_addend_field") != "low_nibble":
        errors.append("World 2 score addend encoding differs")
    if score_spec.get("points_formula") != "low_nibble * 10 ** (6 - high_nibble)":
        errors.append("World 2 score formula differs")
    score_signature = bytes.fromhex(str(score_spec["signature"]))
    if bank_slice(
        prg, bank, number(score_spec["routine_address"]), len(score_signature)
    ) != score_signature:
        errors.append("World 2 encoded-score routine differs from PRG")

    direct = {
        number(value)
        for value in enemy_states["runtime_states"]["direct_spawn_states"]
    }
    internal = {
        number(value) for value in enemy_states["runtime_states"]["internal_states"]
    }
    confirmed_count = 0
    for state, identity in enumerate(identities, start=1):
        confidence = str(identity.get("confidence", ""))
        category = str(identity.get("category", ""))
        if confidence not in allowed_confidence:
            errors.append(f"state {state:02X}: unknown identity confidence")
        if category not in allowed_categories:
            errors.append(f"state {state:02X}: unknown identity category")
        confirmed_count += confidence == "confirmed"
        lifecycle = "direct_spawn" if state in direct else "internal"
        if state not in direct | internal or identity.get("lifecycle") != lifecycle:
            errors.append(f"state {state:02X}: lifecycle differs")
        if handlers and handlers[state - 1].get("domain") != lifecycle:
            errors.append(f"state {state:02X}: handler lifecycle differs")
        if handlers and handlers[state - 1].get("identity_symbol") != identity.get(
            "symbol"
        ):
            errors.append(f"state {state:02X}: handler identity differs")
        comparisons = (
            (number(identity["attack_period"]), attacks[state], "attack period"),
            (
                number(identity["damage_threshold"]),
                thresholds[state],
                "damage threshold",
            ),
            (
                number(identity["score_reward_code"]),
                rewards[state],
                "score reward code",
            ),
        )
        for actual, expected, description in comparisons:
            if actual != expected:
                errors.append(f"state {state:02X}: {description} differs")
        try:
            points = decode_score(rewards[state], digit_count)
        except ValueError as exc:
            errors.append(str(exc))
        else:
            if int(identity["score_points"]) != points:
                errors.append(f"state {state:02X}: decoded score differs")
        indexes = [int(value) for value in identity["metasprite_indexes"]]
        if render_entries and indexes != [
            int(value) for value in render_entries[state - 1]["indexes"]
        ]:
            errors.append(f"state {state:02X}: metasprite indexes differ")

    direct_names = [
        str(identity["japanese_name"])
        for identity in identities[:15]
        if identity.get("japanese_name") is not None
    ]
    duplicate_names = {
        name: count for name, count in Counter(direct_names).items() if count > 1
    }
    if len(set(direct_names)) != 14 or duplicate_names != {"ガンガン": 2}:
        errors.append("World 2 direct enemy roster or Gangan variants differ")

    boss = manifest["boss_controller"]
    boss_tables = (
        ("trigger_screen_table", [0x11, 0x40, 0x67]),
        ("boss_state_table", [0x11, 0x12, 0x13]),
        ("initial_x_table", [0xDC, 0x78, 0xB4]),
        ("initial_y_table", [0x98, 0x50, 0x64]),
    )
    for table_name, expected in boss_tables:
        table = boss[table_name]
        values = [number(value) for value in table["values"]]
        if values != expected:
            errors.append(f"World 2 {table_name} values differ")
        if bank_slice(prg, bank, number(table["address"]), len(values)) != bytes(
            values
        ):
            errors.append(f"World 2 {table_name} bytes differ from PRG")
    boss_states = [number(value) for value in boss["boss_state_table"]["values"]]
    if [identities[state - 1]["category"] for state in boss_states] != [
        "boss",
        "boss",
        "boss",
    ]:
        errors.append("World 2 boss-state identities differ")
    if [identities[state - 1]["symbol"] for state in boss_states] != [
        "ororon_iwa",
        "big_robo_ship",
        "centaurus",
    ]:
        errors.append("World 2 boss identity order differs")

    relationship_count = 0
    encoded_relationships: dict[str, tuple[tuple[int, ...], tuple[int, ...]]] = {}
    for relationship in manifest["state_relationships"]:
        raw = bytes.fromhex(str(relationship["bytes"]))
        address = number(relationship["address"])
        if bank_slice(prg, bank, address, len(raw)) != raw:
            errors.append(f"{relationship['name']}: code signature differs from PRG")
        states = [
            number(value)
            for value in relationship["source_states"] + relationship["result_states"]
        ]
        if any(not 1 <= state <= state_count for state in states):
            errors.append(f"{relationship['name']}: state leaves the identity catalog")
        encoded_relationships[str(relationship["name"])] = (
            tuple(number(value) for value in relationship["source_states"]),
            tuple(number(value) for value in relationship["result_states"]),
        )
        relationship_count += 1
    if encoded_relationships != {
        "centaurus_spawns_tenkoumori": ((0x13,), (0x04,)),
        "big_robo_ship_spawns_robo_ship": ((0x12,), (0x14,)),
        "ororon_iwa_spawns_jura_projectile": ((0x11,), (0x10,)),
    }:
        errors.append("World 2 boss/helper state relationships differ")
    special_rule_count = 0
    for rule in manifest["special_rules"]:
        raw = bytes.fromhex(str(rule["bytes"]))
        if bank_slice(prg, bank, number(rule["address"]), len(raw)) != raw:
            errors.append(f"{rule['name']}: code signature differs from PRG")
        state = number(rule["state"])
        if (
            rule.get("name") != "four_consecutive_takkon_defeats_spawn_item"
            or state != 2
            or identities[state - 1].get("symbol") != "takkon"
            or int(rule["required_count"]) != 4
        ):
            errors.append(f"{rule['name']}: state/count contract differs")
        special_rule_count += 1

    return errors, {
        "state_count": state_count,
        "direct_identity_count": len(direct),
        "confirmed_identity_count": confirmed_count,
        "identity_source_count": source_count,
        "boss_count": len(boss_states),
        "relationship_count": relationship_count,
        "special_rule_count": special_rule_count,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prg", required=True, type=Path)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--enemy-states", required=True, type=Path)
    parser.add_argument("--enemy-handlers", required=True, type=Path)
    parser.add_argument("--metasprites", required=True, type=Path)
    args = parser.parse_args()
    try:
        errors, report = validate(
            args.prg.read_bytes(),
            json.loads(args.manifest.read_text(encoding="utf-8")),
            json.loads(args.enemy_states.read_text(encoding="utf-8")),
            json.loads(args.enemy_handlers.read_text(encoding="utf-8")),
            json.loads(args.metasprites.read_text(encoding="utf-8")),
        )
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 2 enemy-identity audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] {report['state_count']} World 2 identities: "
        f"{report['direct_identity_count']} direct states, "
        f"{report['boss_count']} bosses, "
        f"{report['confirmed_identity_count']} confirmed, "
        f"{report['relationship_count']} helper relationships"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
