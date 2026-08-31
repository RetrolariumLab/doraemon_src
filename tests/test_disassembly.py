from __future__ import annotations

from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import format_project
import generate_disassembly as disasm


class FormattingTests(unittest.TestCase):
    def test_normalizes_line_endings_and_trailing_space(self) -> None:
        self.assertEqual(format_project.normalize_text("one  \r\ntwo\t \r\n"), "one\ntwo\n")


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


if __name__ == "__main__":
    unittest.main()
