from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest
import zlib


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import world2_streaming


class World2StreamingTests(unittest.TestCase):
    def fixture(
        self,
    ) -> tuple[bytes, dict[str, object], list[tuple[int, int, str]]]:
        prg = bytearray(4 * world2_streaming.BANK_SIZE)
        bank_offset = world2_streaming.BANK_SIZE

        def write(address: int, data: bytes) -> None:
            offset = bank_offset + address - world2_streaming.CPU_BASE
            prg[offset:offset + len(data)] = data

        stage_data = bytes((0,))
        pointer_data = (0x8200).to_bytes(2, "little")
        stream_data = bytes((0x12,))
        write(0x8000, stage_data)
        write(0x8050, bytes((0,)))
        write(0x8060, world2_streaming.encode_rts_target(0x9000))
        write(0x8100, pointer_data)
        write(0x8200, stream_data)
        document: dict[str, object] = {
            "schema_version": 1,
            "bank": 1,
            "dispatch_tables": [
                {
                    "name": "services",
                    "address": "0x8060",
                    "encoding": "rts-minus-one",
                    "slot_count": 1,
                    "targets": ["0x9000"],
                }
            ],
            "stage_sequence": {
                "address": "0x8000",
                "size": 1,
                "crc32": world2_streaming.crc32(stage_data),
                "start_table_address": "0x8050",
                "start_offsets": [0],
                "dynamic_screen_ids": {},
            },
            "screen_pointer_table": {
                "address": "0x8100",
                "slot_count": 1,
                "standard_rom_slots": 1,
                "standard_crc32": world2_streaming.crc32(pointer_data),
                "full_crc32": world2_streaming.crc32(pointer_data),
                "standard_unique_pointer_count": 1,
                "first_stream_address": "0x8200",
            },
            "screen_streams": {
                "address": "0x8200",
                "last_consumed_address": "0x8200",
                "crc32": world2_streaming.crc32(stream_data),
                "rows_per_screen": 1,
                "minimum_cells_per_row": 1,
                "expected_screen_count": 1,
                "expected_spawn_tokens": 0,
                "expected_rle_tokens": 0,
                "expected_row_terminators": 0,
                "expected_max_row_width": 1,
            },
        }
        return bytes(prg), document, [(1, 0x9000, "Handler")]

    def test_accepts_valid_streaming_data(self) -> None:
        prg, document, entries = self.fixture()
        errors, report = world2_streaming.validate(prg, document, entries)
        self.assertEqual(errors, [])
        self.assertEqual(report["screen_count"], 1)
        self.assertEqual(report["dispatch_target_count"], 1)

    def test_rejects_changed_dispatch_table(self) -> None:
        prg, document, entries = self.fixture()
        changed = bytearray(prg)
        offset = world2_streaming.BANK_SIZE + 0x8060 - 0x8000
        changed[offset] ^= 1
        errors, _report = world2_streaming.validate(
            bytes(changed), document, entries
        )
        self.assertTrue(any("dispatch table differs" in error for error in errors))

    def test_rejects_missing_indirect_code_entry(self) -> None:
        prg, document, _entries = self.fixture()
        errors, _report = world2_streaming.validate(prg, document, [])
        self.assertTrue(any("missing from code entry" in error for error in errors))

    def test_rejects_illegal_stage_selector(self) -> None:
        prg, document, entries = self.fixture()
        changed = bytearray(prg)
        changed[world2_streaming.BANK_SIZE] = 2
        changed_document = copy.deepcopy(document)
        changed_document["stage_sequence"]["crc32"] = world2_streaming.crc32(
            bytes((2,))
        )
        errors, _report = world2_streaming.validate(
            bytes(changed), changed_document, entries
        )
        self.assertTrue(any("unsupported screen selectors" in error for error in errors))

    def test_rejects_reserved_f0_stream_token(self) -> None:
        prg, document, entries = self.fixture()
        changed = bytearray(prg)
        offset = world2_streaming.BANK_SIZE + 0x8200 - 0x8000
        changed[offset] = 0xF0
        changed_document = copy.deepcopy(document)
        changed_document["screen_streams"]["crc32"] = world2_streaming.crc32(
            bytes((0xF0,))
        )
        errors, _report = world2_streaming.validate(
            bytes(changed), changed_document, entries
        )
        self.assertTrue(any("invalid $F0 token" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
