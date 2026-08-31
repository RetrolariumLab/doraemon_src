#!/usr/bin/env python3
"""Generate deterministic four-bank ca65 source from Ghidra facts."""

from __future__ import annotations

from rom_assets import read_source_text

import argparse
import csv
from dataclasses import dataclass
import json
from pathlib import Path
import re
import struct
import sys


PRG_START = 0x8000
PRG_END = 0x10000
PRG_BANK_SIZE = 0x8000
PRG_BANK_COUNT = 4
COMMON_CODE_END = 0x8270
CONTROL_MNEMONICS = {"BCC", "BCS", "BEQ", "BMI", "BNE", "BPL", "BVC", "BVS", "JMP", "JSR"}
BRANCH_MNEMONICS = {"BCC", "BCS", "BEQ", "BMI", "BNE", "BPL", "BVC", "BVS"}
HEX_RE = re.compile(r"0x([0-9a-fA-F]+)")


class DisassemblyError(ValueError):
    pass


@dataclass(frozen=True)
class InstructionFact:
    address: int
    length: int
    raw: bytes
    mnemonic: str
    operands: str
    flows: tuple[int, ...]
    flow_type: str
    symbol: str
    function: str


def parse_flow(value: str) -> int:
    return int(value.rsplit("::", 1)[-1], 16)


def load_facts(path: Path, prg: bytes) -> dict[int, InstructionFact]:
    try:
        stream = path.open("r", encoding="utf-8", newline="")
    except OSError as exc:
        raise DisassemblyError(f"cannot read Ghidra facts {path}: {exc}") from exc
    facts: dict[int, InstructionFact] = {}
    occupied: set[int] = set()
    with stream:
        for row in csv.DictReader(stream, delimiter="\t"):
            address = int(row["address"], 16)
            raw = bytes.fromhex(row["bytes"])
            length = int(row["length"])
            if len(raw) != length:
                raise DisassemblyError(f"instruction ${address:04X} has inconsistent length")
            offset = address - PRG_START
            if not 0 <= offset <= len(prg) - length:
                raise DisassemblyError(f"instruction ${address:04X} is outside PRG bank")
            if prg[offset:offset + length] != raw:
                raise DisassemblyError(f"Ghidra bytes disagree with PRG at ${address:04X}")
            addresses = set(range(address, address + length))
            if occupied & addresses:
                raise DisassemblyError(f"overlapping instruction at ${address:04X}")
            occupied.update(addresses)
            facts[address] = InstructionFact(
                address=address,
                length=length,
                raw=raw,
                mnemonic=row["mnemonic"].upper(),
                operands=row["operands"],
                flows=tuple(parse_flow(value) for value in row["flows"].split("|") if value),
                flow_type=row["flow_type"],
                symbol=row["symbol"],
                function=row["function"],
            )
    if not facts:
        raise DisassemblyError(f"Ghidra facts contain no instructions: {path}")
    return facts


def propagate_identical_common_code(
    banks: list[bytes], fact_sets: list[dict[int, InstructionFact]]
) -> None:
    candidates: dict[int, list[InstructionFact]] = {}
    for facts in fact_sets:
        for address, fact in facts.items():
            if address + fact.length - 1 <= COMMON_CODE_END:
                candidates.setdefault(address, []).append(fact)
    for bank, facts in enumerate(fact_sets):
        occupied = {
            address
            for fact in facts.values()
            for address in range(fact.address, fact.address + fact.length)
        }
        for address in sorted(candidates):
            if address in facts:
                continue
            for fact in candidates[address]:
                offset = address - PRG_START
                span = set(range(address, address + fact.length))
                if occupied & span or banks[bank][offset:offset + fact.length] != fact.raw:
                    continue
                facts[address] = fact
                occupied.update(span)
                break


def load_known_symbols(path: Path) -> dict[tuple[int, int], str]:
    try:
        document = json.loads(read_source_text(path, encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise DisassemblyError(f"cannot read symbols {path}: {exc}") from exc
    if document.get("schema_version") != 1 or not isinstance(document.get("symbols"), list):
        raise DisassemblyError("unsupported symbols schema")
    result: dict[tuple[int, int], str] = {}
    names: set[str] = set()
    for item in document["symbols"]:
        if not isinstance(item, dict):
            raise DisassemblyError("invalid symbol entry")
        bank = int(item["bank"])
        address = int(str(item["address"]), 0)
        name = str(item["name"])
        if not 0 <= bank < PRG_BANK_COUNT or not PRG_START <= address < PRG_END:
            raise DisassemblyError(f"symbol is outside PRG banks: {item!r}")
        if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", name):
            raise DisassemblyError(f"invalid ca65 symbol name: {name!r}")
        key = (bank, address)
        if key in result or name.lower() in names:
            raise DisassemblyError(f"duplicate symbol: bank {bank} ${address:04X} {name}")
        result[key] = name
        names.add(name.lower())
    return result


def make_labels(
    bank: int, facts: dict[int, InstructionFact], known: dict[tuple[int, int], str]
) -> dict[int, str]:
    labels = {address: name for (item_bank, address), name in known.items() if item_bank == bank}
    function_entries = {fact.address for fact in facts.values() if fact.function}
    call_targets: set[int] = set()
    branch_targets: set[int] = set()
    jump_targets: set[int] = set()
    for fact in facts.values():
        for target in fact.flows:
            if not PRG_START <= target < PRG_END:
                continue
            if fact.mnemonic == "JSR":
                call_targets.add(target)
            elif fact.mnemonic in BRANCH_MNEMONICS:
                branch_targets.add(target)
            elif fact.mnemonic == "JMP" and not fact.operands.replace("PRG0::", "").startswith("("):
                jump_targets.add(target)
    for address in sorted(function_entries | call_targets):
        labels.setdefault(address, f"Bank{bank}_Func_{address:04X}")
    for address in sorted(branch_targets | jump_targets):
        labels.setdefault(address, f"Bank{bank}_Label_{address:04X}")
    return labels


def numeric_operand(fact: InstructionFact) -> str:
    operand = re.sub(r"PRG\d+::", "", fact.operands)

    def replace(match: re.Match[str]) -> str:
        value = int(match.group(1), 16)
        width = 2 if fact.length == 2 else 4
        return f"${value:0{width}X}"

    operand = HEX_RE.sub(replace, operand)
    if fact.length == 3 and fact.mnemonic not in ("JMP", "JSR"):
        if re.fullmatch(r"\$[0-9A-F]{4}(?:,[XY])?", operand):
            operand = "a:" + operand
    return operand


def format_instruction(fact: InstructionFact, labels: dict[int, str]) -> str:
    operand = numeric_operand(fact)
    internal_flows = [target for target in fact.flows if PRG_START <= target < PRG_END]
    direct_control = fact.mnemonic in CONTROL_MNEMONICS and (
        fact.mnemonic != "JMP" or not operand.startswith("(")
    )
    if direct_control and internal_flows:
        if len(internal_flows) != 1:
            raise DisassemblyError(
                f"direct control transfer ${fact.address:04X} has {len(internal_flows)} PRG targets"
            )
        target = internal_flows[0]
        if target not in labels:
            raise DisassemblyError(f"control target ${target:04X} has no label")
        operand = labels[target]
    statement = fact.mnemonic
    if operand:
        statement += " " + operand
    return "    " + statement


def data_line(payload: bytes) -> str:
    return "    .byte " + ", ".join(f"${value:02X}" for value in payload)


def generate_bank(
    bank: int, prg: bytes, facts: dict[int, InstructionFact], labels: dict[int, str]
) -> str:
    lines = [
        f"; Address-ordered Doraemon PRG bank {bank} preservation listing",
        "; Generated deterministically from pinned Ghidra/GhidraNes facts",
        "; Keep byte-identical through make verify",
        "",
        f'.segment "PRG{bank}"',
        "",
    ]
    byte_owner: dict[int, int] = {}
    for fact in facts.values():
        for owned in range(fact.address, fact.address + fact.length):
            byte_owner[owned] = fact.address
    interior_labels: dict[int, list[tuple[int, str]]] = {}
    for label_address, label_name in labels.items():
        owner = byte_owner.get(label_address)
        if owner is not None and owner != label_address:
            interior_labels.setdefault(owner, []).append((label_address, label_name))

    nmi, reset, irq = struct.unpack_from("<HHH", prg, PRG_BANK_SIZE - 6)
    address = PRG_START
    while address < PRG_END:
        aliases = interior_labels.get(address, [])
        if aliases:
            if lines[-1] != "":
                lines.append("")
            for alias_address, alias_name in sorted(aliases):
                lines.append(f"{alias_name} = * + {alias_address - address}  ; overlapping entry ${alias_address:04X}")
        label = labels.get(address)
        if label:
            if lines[-1] != "":
                lines.append("")
            lines.append(label + ":")
        if address == 0xFFFA:
            vector_targets = (nmi, reset, irq)
            for index, target in enumerate(vector_targets):
                if target not in labels:
                    raise DisassemblyError(f"bank {bank} vector target ${target:04X} has no label")
                if index:
                    lines.append("")
                lines.append(f"Bank{bank}_{('Nmi', 'Reset', 'Irq')[index]}Vector:")
                lines.append(f"    .addr {labels[target]}")
            address += 6
            continue
        fact = facts.get(address)
        if fact is not None:
            lines.append(format_instruction(fact, labels))
            address += fact.length
            continue
        start = address
        limit = min(address + 16, PRG_END)
        while address < limit:
            if address != start and (address in labels or address in facts or address == 0xFFFA):
                break
            address += 1
        if address == start:
            raise DisassemblyError(f"generator made no progress at bank {bank} ${address:04X}")
        lines.append(data_line(prg[start - PRG_START:address - PRG_START]))
    text = "\n".join(lines).rstrip() + "\n"
    for label in labels.values():
        if f"{label}:" not in text and f"{label} = " not in text:
            raise DisassemblyError(f"label {label} was not emitted")
    return text


def build_texts(args: argparse.Namespace) -> list[str]:
    prg = Path(args.prg).read_bytes()
    if len(prg) != PRG_BANK_SIZE * PRG_BANK_COUNT:
        raise DisassemblyError(f"PRG must be 131072 bytes, got {len(prg)}")
    banks = [prg[index * PRG_BANK_SIZE:(index + 1) * PRG_BANK_SIZE] for index in range(4)]
    facts_dir = Path(args.facts_dir)
    fact_sets = [load_facts(facts_dir / f"bank_{bank}.tsv", banks[bank]) for bank in range(4)]
    propagate_identical_common_code(banks, fact_sets)
    known = load_known_symbols(Path(args.symbols))
    return [
        generate_bank(bank, banks[bank], fact_sets[bank], make_labels(bank, fact_sets[bank], known))
        for bank in range(4)
    ]


def command_write(args: argparse.Namespace) -> None:
    output_dir = Path(args.output_dir)
    texts = build_texts(args)
    output_dir.mkdir(parents=True, exist_ok=True)
    for bank, source in enumerate(texts):
        output = output_dir / f"bank_{bank}.asm"
        if output.is_file() and read_source_text(output, encoding="utf-8") == source:
            print(f"[OK] unchanged {output}")
            continue
        output.write_text(source, encoding="utf-8", newline="\n")
        print(f"[WRITE] {output} ({len(source.splitlines())} lines)")


def command_check(args: argparse.Namespace) -> None:
    output_dir = Path(args.output_dir)
    for bank, expected in enumerate(build_texts(args)):
        output = output_dir / f"bank_{bank}.asm"
        if not output.is_file() or read_source_text(output, encoding="utf-8") != expected:
            raise DisassemblyError(f"generated disassembly is stale: {output}; run make disassemble")
    print("[OK] canonical four-bank disassembly and symbolic PRG control flow")


def add_common(parser: argparse.ArgumentParser) -> None:
    parser.add_argument("--prg", required=True)
    parser.add_argument("--facts-dir", required=True)
    parser.add_argument("--symbols", required=True)
    parser.add_argument("--output-dir", required=True)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    for name, handler in (("write", command_write), ("check", command_check)):
        command = subparsers.add_parser(name)
        add_common(command)
        command.set_defaults(handler=handler)
    args = parser.parse_args()
    try:
        args.handler(args)
    except (DisassemblyError, OSError) as exc:
        print(f"[ERROR] {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
