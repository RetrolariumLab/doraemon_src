#!/usr/bin/env python3
"""Validate the evidence-backed World 1 enemy identity catalog."""

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
        raise ValueError("World 1 enemy-identity range is outside PRG")
    return prg[offset:offset + size]


def validate_sources(
    manifest: dict[str, Any], identities: list[dict[str, Any]]
) -> tuple[list[str], int]:
    errors: list[str] = []
    sources = manifest.get("identity_sources", [])
    source_ids = [str(source.get("id", "")) for source in sources]
    if not source_ids or any(not value for value in source_ids) or len(
        source_ids
    ) != len(set(source_ids)):
        return ["World 1 identity sources must be unique and non-empty"], 0
    source_set = set(source_ids)
    external = source_set - {"local_rom"}
    for identity in identities:
        state = int(identity["state"])
        evidence = {str(value) for value in identity.get("evidence", [])}
        if not evidence or not evidence <= source_set:
            errors.append(f"state {state:02X}: identity evidence differs")
        if "local_rom" not in evidence:
            errors.append(f"state {state:02X}: local-ROM evidence is absent")
        if identity.get("confidence") == "confirmed" and not evidence & external:
            errors.append(f"state {state:02X}: confirmed identity lacks external evidence")
    return errors, len(sources)


def validate(
    prg: bytes,
    manifest: dict[str, Any],
    handlers: dict[str, Any],
    metasprites: dict[str, Any],
) -> tuple[list[str], dict[str, int]]:
    if manifest.get("schema_version") != 1:
        return ["unsupported World 1 enemy-identity schema"], {}
    if len(prg) != 4 * BANK_SIZE:
        return [f"PRG size differs: {len(prg)}"], {}
    errors: list[str] = []
    bank = int(manifest["bank"])
    identities = manifest.get("identities", [])
    state_count = int(manifest["state_count"])
    if bank != 0 or int(handlers.get("bank", -1)) != bank:
        errors.append("World 1 enemy identities must belong to PRG bank 0")
    if len(identities) != state_count or [
        int(entry.get("state", -1)) for entry in identities
    ] != list(range(1, state_count + 1)):
        return ["World 1 identity states are not contiguous"], {}
    handler_states = handlers.get("states", [])
    if len(handler_states) != state_count:
        errors.append("World 1 handler state domain differs")
        handler_states = []
    source_errors, source_count = validate_sources(manifest, identities)
    errors.extend(source_errors)
    direct_indexes = {
        int(entry["id"])
        for entry in metasprites.get("index_entries", [])
        if entry.get("kind") == "direct"
    }
    confirmed = 0
    for state, identity in enumerate(identities, start=1):
        if identity.get("confidence") not in {"confirmed", "structural"}:
            errors.append(f"state {state:02X}: unknown confidence")
        confirmed += identity.get("confidence") == "confirmed"
        if handler_states:
            handler = handler_states[state - 1]
            if handler.get("lifecycle") != identity.get("lifecycle"):
                errors.append(f"state {state:02X}: lifecycle differs")
            if handler.get("identity_symbol") != identity.get("symbol"):
                errors.append(f"state {state:02X}: handler identity differs")
            if identity.get("lifecycle") == "direct_placement" and number(
                identity["metasprite_base"]
            ) != number(handler["initial_metasprite"]):
                errors.append(f"state {state:02X}: metasprite base differs")
            if identity.get("lifecycle") == "direct_placement" and int(
                identity["initial_health"]
            ) != int(handler["initial_health"]):
                errors.append(f"state {state:02X}: initial health differs")
            if number(identity["score_reward_code"]) != number(
                handler["score_reward_code"]
            ):
                errors.append(f"state {state:02X}: score reward differs")
        if identity.get("lifecycle") == "direct_placement" and number(
            identity["metasprite_base"]
        ) not in direct_indexes:
            errors.append(f"state {state:02X}: metasprite base is not direct")

    direct_symbols = [str(entry["symbol"]) for entry in identities[:12]]
    duplicates = {
        symbol: count
        for symbol, count in Counter(direct_symbols).items()
        if count > 1
    }
    if len(set(direct_symbols)) != 10 or duplicates != {"gozura": 2, "naame": 2}:
        errors.append("World 1 direct roster or mode variants differ")
    if identities[12]["symbol"] != "dormant_state_0d":
        errors.append("World 1 dormant identity differs")
    if [entry["symbol"] for entry in identities[13:]] != [
        "bull_robo", "bull_robo"
    ]:
        errors.append("World 1 scripted boss identities differ")

    secret = manifest["secret_sequence"]
    sequence = [number(value) for value in secret["runtime_states"]]
    raw = bank_slice(prg, bank, number(secret["address"]), len(sequence))
    if raw != bytes(sequence):
        errors.append("World 1 secret sequence bytes differ")
    if [identities[state - 1]["symbol"] for state in sequence] != [
        "kobuun", "kobuun", "naame", "gozura", "yuubou", "kobuun"
    ]:
        errors.append("World 1 secret identity sequence differs")
    if number(secret["reward_selector_index"]) != 4:
        errors.append("World 1 secret reward selector index differs")
    reward_descriptor = bank_slice(
        prg, bank, number(secret["reward_selector_address"]), 1
    )[0]
    if reward_descriptor != number(secret["reward_descriptor_index"]):
        errors.append("World 1 secret reward descriptor byte differs")
    if reward_descriptor != 0x0C:
        errors.append("World 1 secret reward descriptor differs")
    for signature in manifest.get("signatures", []):
        raw = bytes.fromhex(str(signature["bytes"]))
        if bank_slice(prg, bank, number(signature["address"]), len(raw)) != raw:
            errors.append(f"{signature['name']}: code signature differs")
    return errors, {
        "state_count": state_count,
        "confirmed_count": confirmed,
        "unique_direct_identity_count": len(set(direct_symbols)),
        "source_count": source_count,
        "secret_length": len(sequence),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prg", type=Path, required=True)
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--handlers", type=Path, required=True)
    parser.add_argument("--metasprites", type=Path, required=True)
    args = parser.parse_args()
    try:
        documents = [
            json.loads(path.read_text(encoding="utf-8"))
            for path in (args.manifest, args.handlers, args.metasprites)
        ]
        errors, report = validate(args.prg.read_bytes(), *documents)
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as exc:
        print(f"[ERROR] World 1 enemy-identity audit failed: {exc}")
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}")
        return 1
    print(
        f"[OK] {report['state_count']} World 1 state identities: "
        f"{report['unique_direct_identity_count']} unique direct enemies, "
        f"{report['confirmed_count']} confirmed states, "
        f"{report['secret_length']}-defeat secret sequence"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
