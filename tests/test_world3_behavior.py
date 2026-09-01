from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import world3_behavior


class World3BehaviorTests(unittest.TestCase):
    def fixture(self) -> tuple[bytes, dict[str, object]]:
        prg = bytearray(4 * world3_behavior.BANK_SIZE)
        bank_offset = 2 * world3_behavior.BANK_SIZE
        stream_data = bytes((0x60, 0x90, 0x01, 0x02, 0xF1))
        pointer_data = (0x8200).to_bytes(2, "little")
        prg[bank_offset + 0x100:bank_offset + 0x102] = pointer_data
        prg[bank_offset + 0x200:bank_offset + 0x205] = stream_data
        histogram = {f"0x{value:X}": 0 for value in range(16)}
        histogram["0x6"] = 1
        histogram["0x9"] = 1
        histogram["0xF"] = 1
        document: dict[str, object] = {
            "schema_version": 1,
            "bank": 2,
            "pointer_table": {
                "address": "0x8100",
                "slot_count": 1,
                "crc32": world3_behavior.crc32(pointer_data),
            },
            "region": {
                "address": "0x8200",
                "end_address": "0x8204",
                "crc32": world3_behavior.crc32(stream_data),
            },
            "opcode_classes": [
                {
                    "high_nibble": f"0x{high_nibble:X}",
                    "name": name,
                    "size": size,
                }
                for high_nibble, (name, size) in enumerate(
                    world3_behavior.OPCODE_CLASSES
                )
            ],
            "expected_opcode_histogram": histogram,
            "streams": [
                {
                    "id": 0,
                    "address": "0x8200",
                    "size": 5,
                    "crc32": world3_behavior.crc32(stream_data),
                    "instruction_count": 3,
                    "branch_count": 0,
                    "terminator_count": 1,
                }
            ],
            "expected_instruction_count": 3,
            "expected_branch_count": 0,
            "expected_terminator_count": 1,
            "expected_covered_bytes": 5,
        }
        return bytes(prg), document

    def test_accepts_complete_behavior_stream(self) -> None:
        prg, document = self.fixture()
        errors, report = world3_behavior.validate(prg, document)
        self.assertEqual(errors, [])
        self.assertEqual(report["instruction_count"], 3)
        self.assertEqual(report["covered_bytes"], 5)

    def test_rejects_branch_into_operand(self) -> None:
        errors, _instructions, _used = world3_behavior.decode_stream(
            bytes((0xC1, 0x01, 0xF0))
        )
        self.assertTrue(any("lands in an operand" in error for error in errors))

    def test_reports_unreachable_bytes(self) -> None:
        errors, _instructions, used = world3_behavior.decode_stream(
            bytes((0x40, 0x03, 0x12, 0xF0))
        )
        self.assertEqual(errors, [])
        self.assertEqual(set(range(4)) - used, {2})

    def test_lossless_authoring_roundtrip(self) -> None:
        prg, document = self.fixture()
        decoded = world3_behavior.decode_authoring(prg, document)
        self.assertEqual(
            world3_behavior.encode_authoring(decoded),
            bytes((0x60, 0x90, 0x01, 0x02, 0xF1)),
        )

    def test_rejects_wrong_authoring_operand_count(self) -> None:
        prg, document = self.fixture()
        decoded = world3_behavior.decode_authoring(prg, document)
        changed = copy.deepcopy(decoded)
        changed["streams"][0]["instructions"][1]["operands"] = ["0x01"]
        with self.assertRaisesRegex(ValueError, "wrong operand count"):
            world3_behavior.encode_authoring(changed)

    def test_rejects_stale_authoring_command_name(self) -> None:
        prg, document = self.fixture()
        decoded = world3_behavior.decode_authoring(prg, document)
        changed = copy.deepcopy(decoded)
        changed["streams"][0]["instructions"][0]["command"] = "stop"
        with self.assertRaisesRegex(ValueError, "command differs from opcode"):
            world3_behavior.encode_authoring(changed)


if __name__ == "__main__":
    unittest.main()
