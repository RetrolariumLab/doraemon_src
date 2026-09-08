#!/usr/bin/env python3
"""Generate deterministic four-bank ca65 source from Ghidra facts."""

from __future__ import annotations

import argparse
import csv
from dataclasses import dataclass
import json
from pathlib import Path
from pathlib import PurePosixPath
import posixpath
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
CA65_NAME_RE = re.compile(r"[A-Za-z_][A-Za-z0-9_]*")
DIRECT_MEMORY_RE = re.compile(r"^(a:)?\$([0-9A-F]{2,4})(,[XY])?$")
INDIRECT_MEMORY_RE = re.compile(r"^\(\$([0-9A-F]{2,4})(,[XY])?\)(,Y)?$")
ORIGINAL_PROFILE_IF = ".if DORAEMON_REVISION = DORAEMON_REVISION_ORIGINAL"


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


@dataclass(frozen=True)
class SourceModule:
    bank: int
    start: int
    end: int
    path: PurePosixPath
    responsibility: str


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


def load_symbol_registry(
    path: Path,
) -> tuple[
    dict[tuple[int, int], str],
    dict[tuple[int, int], str],
    dict[tuple[int, int], str],
]:
    try:
        document = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise DisassemblyError(f"cannot read symbols {path}: {exc}") from exc
    if document.get("schema_version") != 1 or not isinstance(document.get("symbols"), list):
        raise DisassemblyError("unsupported symbols schema")
    result: dict[tuple[int, int], str] = {}
    operands: dict[tuple[int, int], str] = {}
    names: set[str] = set()
    for item in document["symbols"]:
        if not isinstance(item, dict):
            raise DisassemblyError("invalid symbol entry")
        bank = int(item["bank"])
        address = int(str(item["address"]), 0)
        name = str(item["name"])
        if not 0 <= bank < PRG_BANK_COUNT or not PRG_START <= address < PRG_END:
            raise DisassemblyError(f"symbol is outside PRG banks: {item!r}")
        if not CA65_NAME_RE.fullmatch(name):
            raise DisassemblyError(f"invalid ca65 symbol name: {name!r}")
        key = (bank, address)
        if key in result or name.lower() in names:
            raise DisassemblyError(f"duplicate symbol: bank {bank} ${address:04X} {name}")
        result[key] = name
        operand_symbol = item.get("operand_symbol", False)
        if not isinstance(operand_symbol, bool):
            raise DisassemblyError(f"invalid operand_symbol flag: {item!r}")
        if operand_symbol:
            operands[key] = name
        names.add(name.lower())
    memory: dict[tuple[int, int], str] = {}
    memory_names: set[str] = set()
    items = document.get("memory_symbols", [])
    if not isinstance(items, list):
        raise DisassemblyError("memory_symbols must be a list")
    for item in items:
        if not isinstance(item, dict):
            raise DisassemblyError("invalid memory symbol entry")
        address = int(str(item["address"]), 0)
        name = str(item["name"])
        size = int(str(item.get("size", 1)), 0)
        banks = item.get("banks", list(range(PRG_BANK_COUNT)))
        if not 0 <= address < PRG_START or size <= 0 or address + size > PRG_START:
            raise DisassemblyError(f"memory symbol is outside CPU memory: {item!r}")
        if not CA65_NAME_RE.fullmatch(name):
            raise DisassemblyError(f"invalid ca65 memory symbol name: {name!r}")
        if not isinstance(banks, list) or not banks or any(
            not isinstance(bank, int) or not 0 <= bank < PRG_BANK_COUNT
            for bank in banks
        ):
            raise DisassemblyError(f"invalid memory symbol banks: {item!r}")
        if len(set(banks)) != len(banks):
            raise DisassemblyError(f"duplicate memory symbol bank: {item!r}")
        if not str(item.get("evidence", "")):
            raise DisassemblyError(f"memory symbol has no evidence: {item!r}")
        lowered = name.lower()
        if lowered in names or lowered in memory_names:
            raise DisassemblyError(f"duplicate symbol name: {name}")
        memory_names.add(lowered)
        for bank in banks:
            for offset in range(size):
                item_address = address + offset
                key = (bank, item_address)
                if key in memory:
                    raise DisassemblyError(
                        f"duplicate memory symbol: bank {bank} "
                        f"${item_address:04X} {name}"
                    )
                memory[key] = name if offset == 0 else f"{name}+${offset:02X}"
    return result, memory, operands


def load_known_symbols(path: Path) -> dict[tuple[int, int], str]:
    return load_symbol_registry(path)[0]


def load_memory_symbols(path: Path) -> dict[tuple[int, int], str]:
    return load_symbol_registry(path)[1]


def load_operand_symbols(path: Path) -> dict[tuple[int, int], str]:
    return load_symbol_registry(path)[2]


def load_source_modules(path: Path) -> dict[int, list[SourceModule]]:
    try:
        document = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise DisassemblyError(f"cannot read source modules {path}: {exc}") from exc
    if document.get("schema_version") != 1 or not isinstance(document.get("modules"), list):
        raise DisassemblyError("unsupported source module schema")
    result: dict[int, list[SourceModule]] = {}
    paths: set[PurePosixPath] = set()
    for item in document["modules"]:
        try:
            module = SourceModule(
                bank=int(item["bank"]),
                start=int(str(item["start"]), 0),
                end=int(str(item["end"]), 0),
                path=PurePosixPath(str(item["path"])),
                responsibility=str(item["responsibility"]),
            )
        except (KeyError, TypeError, ValueError) as exc:
            raise DisassemblyError(f"invalid source module: {item!r}") from exc
        if not 0 <= module.bank < PRG_BANK_COUNT:
            raise DisassemblyError(f"invalid source module bank: {module.bank}")
        if not PRG_START <= module.start <= module.end < PRG_END:
            raise DisassemblyError(f"invalid source module range: {item!r}")
        if (
            module.path.is_absolute()
            or ".." in module.path.parts
            or module.path.suffix != ".asm"
        ):
            raise DisassemblyError(f"unsafe source module path: {module.path}")
        if not module.responsibility:
            raise DisassemblyError(f"empty source module responsibility: {module.path}")
        if module.path in paths:
            raise DisassemblyError(f"duplicate source module path: {module.path}")
        paths.add(module.path)
        result.setdefault(module.bank, []).append(module)
    for bank, modules in result.items():
        modules.sort(key=lambda item: item.start)
        expected = PRG_START
        for module in modules:
            if module.start != expected:
                raise DisassemblyError(
                    f"bank {bank} source modules leave a gap or overlap at ${expected:04X}"
                )
            expected = module.end + 1
        if expected != PRG_END:
            raise DisassemblyError(
                f"bank {bank} source modules end at ${expected - 1:04X}, not $FFFF"
            )
    return result


def load_revision_overlay_paths(path: Path | None) -> set[PurePosixPath]:
    if path is None:
        return set()
    try:
        document = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise DisassemblyError(
            f"cannot read revision profiles {path}: {exc}"
        ) from exc
    if document.get("schema_version") != 1:
        raise DisassemblyError("unsupported revision profile schema")
    windows = document.get("comparison", {}).get("windows", [])
    paths: set[PurePosixPath] = set()
    for window in windows:
        if window.get("classification") != "code":
            continue
        source = PurePosixPath(str(window.get("source", "")))
        if (
            source.is_absolute()
            or ".." in source.parts
            or source.suffix != ".asm"
            or not source.parts
            or source.parts[0] != "src"
        ):
            raise DisassemblyError(f"unsafe revision overlay source: {source}")
        paths.add(PurePosixPath(*source.parts[1:]))
    return paths


def original_profile_projection(source: str) -> tuple[str, int]:
    output: list[str] = []
    state = "outside"
    blocks = 0
    for line in source.splitlines(keepends=True):
        directive = line.strip()
        if directive == ORIGINAL_PROFILE_IF:
            if state != "outside":
                raise DisassemblyError("nested revision source overlay")
            state = "original"
            blocks += 1
            continue
        if directive == ".else" and state == "original":
            state = "revision"
            continue
        if directive == ".endif" and state == "revision":
            state = "outside"
            continue
        if directive in {".else", ".endif"} and state != "outside":
            raise DisassemblyError("malformed revision source overlay")
        if state in {"outside", "original"}:
            output.append(line)
    if state != "outside":
        raise DisassemblyError("unterminated revision source overlay")
    return "".join(output), blocks


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


def symbolic_memory_operand(operand: str, memory: dict[int, str]) -> str:
    direct = DIRECT_MEMORY_RE.fullmatch(operand)
    if direct:
        address = int(direct.group(2), 16)
        name = memory.get(address)
        if name is not None:
            return (direct.group(1) or "") + name + (direct.group(3) or "")
    indirect = INDIRECT_MEMORY_RE.fullmatch(operand)
    if indirect:
        address = int(indirect.group(1), 16)
        name = memory.get(address)
        if name is not None:
            return f"({name}{indirect.group(2) or ''}){indirect.group(3) or ''}"
    return operand


def numeric_operand(
    fact: InstructionFact, memory: dict[int, str] | None = None
) -> str:
    operand = re.sub(r"PRG\d+::", "", fact.operands)

    def replace(match: re.Match[str]) -> str:
        value = int(match.group(1), 16)
        width = 2 if fact.length == 2 else 4
        return f"${value:0{width}X}"

    operand = HEX_RE.sub(replace, operand)
    if fact.length == 3 and fact.mnemonic not in ("JMP", "JSR"):
        if re.fullmatch(r"\$[0-9A-F]{4}(?:,[XY])?", operand):
            operand = "a:" + operand
    return symbolic_memory_operand(operand, memory or {})


def format_instruction(
    fact: InstructionFact,
    labels: dict[int, str],
    memory: dict[int, str] | None = None,
) -> str:
    operand = numeric_operand(fact, memory)
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


def generate_range_lines(
    bank: int,
    prg: bytes,
    facts: dict[int, InstructionFact],
    labels: dict[int, str],
    memory: dict[int, str],
    start_address: int,
    end_address: int,
) -> list[str]:
    lines: list[str] = []
    byte_owner: dict[int, int] = {}
    for fact in facts.values():
        for owned in range(fact.address, fact.address + fact.length):
            byte_owner[owned] = fact.address
    for boundary in (start_address, end_address + 1):
        owner = byte_owner.get(boundary)
        if owner is not None and owner != boundary:
            raise DisassemblyError(
                f"bank {bank} module boundary ${boundary:04X} splits instruction ${owner:04X}"
            )
    interior_labels: dict[int, list[tuple[int, str]]] = {}
    for label_address, label_name in labels.items():
        owner = byte_owner.get(label_address)
        if owner is not None and owner != label_address:
            interior_labels.setdefault(owner, []).append((label_address, label_name))

    nmi, reset, irq = struct.unpack_from("<HHH", prg, PRG_BANK_SIZE - 6)
    address = start_address
    limit_address = end_address + 1
    while address < limit_address:
        aliases = interior_labels.get(address, [])
        if aliases:
            if lines and lines[-1] != "":
                lines.append("")
            for alias_address, alias_name in sorted(aliases):
                lines.append(f"{alias_name} = * + {alias_address - address}  ; overlapping entry ${alias_address:04X}")
        label = labels.get(address)
        if label:
            if lines and lines[-1] != "":
                lines.append("")
            lines.append(label + ":")
        if address == 0xFFFA:
            if limit_address < PRG_END:
                raise DisassemblyError(f"bank {bank} vector module does not include all vectors")
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
            if address + fact.length > limit_address:
                raise DisassemblyError(
                    f"bank {bank} module boundary splits instruction ${address:04X}"
                )
            lines.append(format_instruction(fact, labels, memory))
            address += fact.length
            continue
        start = address
        limit = min(address + 16, limit_address)
        while address < limit:
            if address != start and (address in labels or address in facts or address == 0xFFFA):
                break
            address += 1
        if address == start:
            raise DisassemblyError(f"generator made no progress at bank {bank} ${address:04X}")
        lines.append(data_line(prg[start - PRG_START:address - PRG_START]))
    return lines


def generate_bank(
    bank: int,
    prg: bytes,
    facts: dict[int, InstructionFact],
    labels: dict[int, str],
    memory: dict[int, str],
) -> str:
    lines = [
        f"; Address-ordered Doraemon PRG bank {bank} preservation listing",
        "; Generated deterministically from pinned Ghidra/GhidraNes facts",
        "; Keep byte-identical through make verify",
        "",
        f'.segment "PRG{bank}"',
        "",
        *generate_range_lines(
            bank, prg, facts, labels, memory, PRG_START, PRG_END - 1
        ),
    ]
    text = "\n".join(lines).rstrip() + "\n"
    for label in labels.values():
        if f"{label}:" not in text and f"{label} = " not in text:
            raise DisassemblyError(f"label {label} was not emitted")
    return text


def generate_semantic_bank(
    bank: int,
    prg: bytes,
    facts: dict[int, InstructionFact],
    labels: dict[int, str],
    memory: dict[int, str],
    modules: list[SourceModule],
) -> dict[PurePosixPath, str]:
    aggregator = PurePosixPath("banks") / f"bank_{bank}.asm"
    lines = [
        f"; Address-ordered Doraemon PRG bank {bank} semantic include map",
        "; Generated deterministically from config/reconstruction/source_modules.json",
        "; Keep byte-identical through make verify",
        "",
        f'.segment "PRG{bank}"',
        "",
    ]
    outputs: dict[PurePosixPath, str] = {}
    emitted = ""
    for module in modules:
        include = posixpath.relpath(str(module.path), str(aggregator.parent))
        lines.append(f'; ${module.start:04X}-${module.end:04X}: {module.responsibility}')
        lines.append(f'.include "{include}"')
        module_lines = [
            f"; Doraemon PRG bank {bank} ${module.start:04X}-${module.end:04X}",
            f"; {module.responsibility}",
            "; Generated deterministically from pinned Ghidra/GhidraNes facts",
            "",
            *generate_range_lines(
                bank, prg, facts, labels, memory, module.start, module.end
            ),
        ]
        source = "\n".join(module_lines).rstrip() + "\n"
        outputs[module.path] = source
        emitted += source
    for label in labels.values():
        if f"{label}:" not in emitted and f"{label} = " not in emitted:
            raise DisassemblyError(f"label {label} was not emitted")
    outputs[aggregator] = "\n".join(lines).rstrip() + "\n"
    return outputs


def build_texts(args: argparse.Namespace) -> dict[PurePosixPath, str]:
    prg = Path(args.prg).read_bytes()
    if len(prg) != PRG_BANK_SIZE * PRG_BANK_COUNT:
        raise DisassemblyError(f"PRG must be 131072 bytes, got {len(prg)}")
    banks = [prg[index * PRG_BANK_SIZE:(index + 1) * PRG_BANK_SIZE] for index in range(4)]
    facts_dir = Path(args.facts_dir)
    fact_sets = [load_facts(facts_dir / f"bank_{bank}.tsv", banks[bank]) for bank in range(4)]
    propagate_identical_common_code(banks, fact_sets)
    known, memory, operands = load_symbol_registry(Path(args.symbols))
    module_layout = load_source_modules(Path(args.modules))
    outputs: dict[PurePosixPath, str] = {}
    for bank in range(PRG_BANK_COUNT):
        labels = make_labels(bank, fact_sets[bank], known)
        memory_labels = {
            address: name
            for (item_bank, address), name in memory.items()
            if item_bank == bank
        }
        memory_labels.update({
            address: name
            for (item_bank, address), name in operands.items()
            if item_bank == bank
        })
        if bank in module_layout:
            outputs.update(
                generate_semantic_bank(
                    bank,
                    banks[bank],
                    fact_sets[bank],
                    labels,
                    memory_labels,
                    module_layout[bank],
                )
            )
        else:
            outputs[PurePosixPath("banks") / f"bank_{bank}.asm"] = generate_bank(
                bank, banks[bank], fact_sets[bank], labels, memory_labels
            )
    return outputs


def command_write(args: argparse.Namespace) -> None:
    output_dir = Path(args.output_dir)
    overlay_paths = load_revision_overlay_paths(args.revision_profiles)
    texts = build_texts(args)
    output_dir.mkdir(parents=True, exist_ok=True)
    for relative, source in sorted(texts.items(), key=lambda item: str(item[0])):
        output = output_dir / Path(relative)
        output.parent.mkdir(parents=True, exist_ok=True)
        if output.is_file():
            current = output.read_text(encoding="utf-8")
            if current == source:
                print(f"[OK] unchanged {output}")
                continue
            if relative in overlay_paths:
                projected, blocks = original_profile_projection(current)
                if blocks and projected == source:
                    print(f"[OK] preserved revision overlay {output}")
                    continue
                if blocks:
                    raise DisassemblyError(
                        f"generated original profile changed beneath revision "
                        f"overlay: {output}"
                    )
        output.write_text(source, encoding="utf-8", newline="\n")
        print(f"[WRITE] {output} ({len(source.splitlines())} lines)")


def command_check(args: argparse.Namespace) -> None:
    output_dir = Path(args.output_dir)
    overlay_paths = load_revision_overlay_paths(args.revision_profiles)
    for relative, expected in build_texts(args).items():
        output = output_dir / Path(relative)
        if not output.is_file():
            raise DisassemblyError(f"generated disassembly is stale: {output}; run make disassemble")
        current = output.read_text(encoding="utf-8")
        if current == expected:
            continue
        if relative in overlay_paths:
            projected, blocks = original_profile_projection(current)
            if blocks and projected == expected:
                continue
        raise DisassemblyError(
            f"generated disassembly is stale: {output}; run make disassemble"
        )
    print("[OK] canonical semantic disassembly and symbolic PRG control flow")


def add_common(parser: argparse.ArgumentParser) -> None:
    parser.add_argument("--prg", required=True)
    parser.add_argument("--facts-dir", required=True)
    parser.add_argument("--symbols", required=True)
    parser.add_argument("--modules", required=True)
    parser.add_argument("--output-dir", required=True)
    parser.add_argument("--revision-profiles", type=Path)


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
