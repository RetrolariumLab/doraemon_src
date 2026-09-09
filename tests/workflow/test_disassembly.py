from __future__ import annotations

import json
from pathlib import Path
import sys
import tempfile
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))

from scripts.workflow import generate_disassembly as disasm


class RevisionOverlayTests(unittest.TestCase):
    def test_projects_the_original_branch_for_regeneration(self) -> None:
        source = (
            "Before:\n"
            f"{disasm.ORIGINAL_PROFILE_IF}\n"
            "    LDA #$01\n"
            ".else\n"
            "    .byte $FF, $01\n"
            ".endif\n"
            "After:\n"
        )
        projected, blocks = disasm.original_profile_projection(source)
        self.assertEqual(projected, "Before:\n    LDA #$01\nAfter:\n")
        self.assertEqual(blocks, 1)

    def test_rejects_an_unterminated_revision_overlay(self) -> None:
        source = f"{disasm.ORIGINAL_PROFILE_IF}\n    RTS\n"
        with self.assertRaisesRegex(disasm.DisassemblyError, "unterminated"):
            disasm.original_profile_projection(source)


class InstructionFormattingTests(unittest.TestCase):
    def fact(
        self, address: int, raw: bytes, mnemonic: str, operands: str = "",
        flows: tuple[int, ...] = (), function: str = "",
    ) -> disasm.InstructionFact:
        return disasm.InstructionFact(
            address, len(raw), raw, mnemonic, operands, flows, "", "", function
        )

    def test_direct_control_transfer_uses_bank_label(self) -> None:
        fact = self.fact(0x8000, b"\x20\x23\x81", "JSR", "0x8123", (0x8123,))
        line = disasm.format_instruction(fact, {0x8123: "Bank2_Func_8123"})
        self.assertIn("JSR Bank2_Func_8123", line)

    def test_absolute_low_address_is_forced(self) -> None:
        fact = self.fact(0x8000, b"\xAD\x16\x40", "LDA", "0x4016")
        self.assertIn("LDA a:$4016", disasm.format_instruction(fact, {}))

    def test_indirect_jump_keeps_pointer_operand(self) -> None:
        fact = self.fact(0x8000, b"\x6C\x31\x00", "JMP", "(0x31)")
        self.assertIn("JMP ($0031)", disasm.format_instruction(fact, {}))

    def test_zero_page_memory_operand_uses_symbol(self) -> None:
        fact = self.fact(0x8000, b"\xA5\x16", "LDA", "0x16")
        line = disasm.format_instruction(fact, {}, {0x16: "FrameCounter"})
        self.assertIn("LDA FrameCounter", line)

    def test_absolute_memory_symbol_preserves_size_force(self) -> None:
        fact = self.fact(0x8000, b"\xAD\x14\x00", "LDA", "0x0014")
        line = disasm.format_instruction(fact, {}, {0x14: "NmiOamDmaRequest"})
        self.assertIn("LDA a:NmiOamDmaRequest", line)

    def test_indexed_memory_operand_uses_array_symbol(self) -> None:
        fact = self.fact(0x8000, b"\xBD\xA3\x02", "LDA", "0x02a3,X")
        line = disasm.format_instruction(fact, {}, {0x02A3: "AudioEffectTimers"})
        self.assertIn("LDA a:AudioEffectTimers,X", line)

    def test_immediate_value_is_not_replaced_by_memory_symbol(self) -> None:
        fact = self.fact(0x8000, b"\xA9\x16", "LDA", "#0x16")
        line = disasm.format_instruction(fact, {}, {0x16: "FrameCounter"})
        self.assertIn("LDA #$16", line)

    def test_default_labels_include_bank(self) -> None:
        fact = self.fact(0x8000, b"\x60", "RTS", function="FUN_8000")
        labels = disasm.make_labels(3, {0x8000: fact}, {})
        self.assertEqual(labels[0x8000], "Bank3_Func_8000")

    def test_common_fact_propagates_only_when_bytes_match(self) -> None:
        fact = self.fact(0x8098, b"\x60", "RTS")
        banks = [bytes([0x00]) * 0x98 + b"\x60" + bytes(0x8000 - 0x99),
                 bytes([0x00]) * 0x98 + b"\x60" + bytes(0x8000 - 0x99)]
        facts = [{0x8098: fact}, {}]
        disasm.propagate_identical_common_code(banks, facts)
        self.assertIn(0x8098, facts[1])


class SymbolRegistryTests(unittest.TestCase):
    def write_registry(
        self, directory: str, memory_symbols: list[dict[str, object]]
    ) -> Path:
        path = Path(directory) / "symbols.json"
        path.write_text(
            json.dumps(
                {
                    "schema_version": 1,
                    "symbols": [],
                    "memory_symbols": memory_symbols,
                }
            ),
            encoding="utf-8",
        )
        return path

    def test_memory_symbol_is_limited_to_declared_banks(self) -> None:
        item = {
            "address": "0x0042",
            "name": "ChapterState",
            "banks": [1, 3],
            "evidence": "test fixture",
        }
        with tempfile.TemporaryDirectory() as directory:
            memory = disasm.load_memory_symbols(self.write_registry(directory, [item]))
        self.assertEqual(memory, {(1, 0x42): "ChapterState", (3, 0x42): "ChapterState"})

    def test_prg_operand_symbol_is_limited_to_its_bank(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "symbols.json"
            path.write_text(
                json.dumps({
                    "schema_version": 1,
                    "symbols": [{
                        "bank": 2,
                        "address": "0x8ED5",
                        "name": "EntityMetasprites",
                        "operand_symbol": True,
                    }],
                    "memory_symbols": [],
                }),
                encoding="utf-8",
            )
            operands = disasm.load_operand_symbols(path)
        self.assertEqual(operands, {(2, 0x8ED5): "EntityMetasprites"})

    def test_memory_array_expands_to_symbolic_offsets(self) -> None:
        item = {
            "address": "0x0400",
            "name": "EntityType",
            "size": 3,
            "banks": [0],
            "evidence": "test fixture",
        }
        with tempfile.TemporaryDirectory() as directory:
            memory = disasm.load_memory_symbols(self.write_registry(directory, [item]))
        self.assertEqual(
            memory,
            {
                (0, 0x0400): "EntityType",
                (0, 0x0401): "EntityType+$01",
                (0, 0x0402): "EntityType+$02",
            },
        )

    def test_rejects_overlapping_memory_symbols_in_one_bank(self) -> None:
        items = [
            {
                "address": "0x0042",
                "name": "World1State",
                "size": 2,
                "banks": [0],
                "evidence": "test fixture",
            },
            {
                "address": "0x0043",
                "name": "World2State",
                "banks": [0, 1],
                "evidence": "test fixture",
            },
        ]
        with tempfile.TemporaryDirectory() as directory:
            with self.assertRaisesRegex(disasm.DisassemblyError, "duplicate memory"):
                disasm.load_memory_symbols(self.write_registry(directory, items))


class SourceModuleTests(unittest.TestCase):
    def write_layout(self, directory: str, modules: list[dict[str, object]]) -> Path:
        path = Path(directory) / "modules.json"
        path.write_text(
            json.dumps({"schema_version": 1, "modules": modules}),
            encoding="utf-8",
        )
        return path

    def test_accepts_complete_bank_layout(self) -> None:
        modules = [
            {
                "bank": 3,
                "start": "0x8000",
                "end": "0x8FFF",
                "path": "shell/first.asm",
                "responsibility": "first",
            },
            {
                "bank": 3,
                "start": "0x9000",
                "end": "0xFFFF",
                "path": "data/second.asm",
                "responsibility": "second",
            },
        ]
        with tempfile.TemporaryDirectory() as directory:
            layout = disasm.load_source_modules(self.write_layout(directory, modules))
        self.assertEqual([module.start for module in layout[3]], [0x8000, 0x9000])

    def test_rejects_gap_between_modules(self) -> None:
        modules = [
            {
                "bank": 3,
                "start": "0x8000",
                "end": "0x8FFE",
                "path": "shell/first.asm",
                "responsibility": "first",
            },
            {
                "bank": 3,
                "start": "0x9000",
                "end": "0xFFFF",
                "path": "data/second.asm",
                "responsibility": "second",
            },
        ]
        with tempfile.TemporaryDirectory() as directory:
            with self.assertRaisesRegex(disasm.DisassemblyError, "gap or overlap"):
                disasm.load_source_modules(self.write_layout(directory, modules))


if __name__ == "__main__":
    unittest.main()
