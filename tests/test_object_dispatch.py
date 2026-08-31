from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import object_dispatch


class ObjectDispatchTests(unittest.TestCase):
    def fixture(self) -> tuple[bytes, dict[str, object]]:
        prg = bytearray(4 * object_dispatch.BANK_SIZE)
        document = {
            "schema_version": 1,
            "tables": [
                {
                    "name": "handlers",
                    "bank": 1,
                    "address": "0x8000",
                    "encoding": "rts-minus-one",
                    "slot_count": 2,
                    "continuations": ["0x9020"],
                    "targets": ["0x9000", "0x9010"],
                }
            ],
        }
        bank1 = object_dispatch.BANK_SIZE
        prg[bank1:bank1 + 4] = b"\xFF\x8F\x0F\x90"
        return bytes(prg), document

    def test_accepts_encoded_table_and_registered_targets(self) -> None:
        prg, document = self.fixture()
        errors, report = object_dispatch.validate(
            prg,
            document,
            [
                (1, 0x9000, "first"),
                (1, 0x9010, "second"),
                (1, 0x9020, "continuation"),
            ],
        )
        self.assertEqual(errors, [])
        self.assertEqual(report["unique_target_count"], 2)
        self.assertEqual(report["continuation_count"], 1)

    def test_rejects_changed_table_bytes(self) -> None:
        prg, document = self.fixture()
        changed = bytearray(prg)
        changed[object_dispatch.BANK_SIZE] ^= 1
        errors, _report = object_dispatch.validate(
            bytes(changed),
            document,
            [
                (1, 0x9000, "first"),
                (1, 0x9010, "second"),
                (1, 0x9020, "continuation"),
            ],
        )
        self.assertTrue(any("differs from PRG" in error for error in errors))

    def test_rejects_unregistered_indirect_target(self) -> None:
        prg, document = self.fixture()
        errors, _report = object_dispatch.validate(
            prg,
            document,
            [(1, 0x9000, "first"), (1, 0x9020, "continuation")],
        )
        self.assertTrue(any("$9010" in error for error in errors))

    def test_rejects_unregistered_dispatch_continuation(self) -> None:
        prg, document = self.fixture()
        errors, _report = object_dispatch.validate(
            prg,
            document,
            [(1, 0x9000, "first"), (1, 0x9010, "second")],
        )
        self.assertTrue(any("$9020" in error for error in errors))

    def test_rejects_wrong_slot_count(self) -> None:
        prg, document = self.fixture()
        changed = copy.deepcopy(document)
        changed["tables"][0]["slot_count"] = 3
        errors, _report = object_dispatch.validate(
            prg,
            changed,
            [
                (1, 0x9000, "first"),
                (1, 0x9010, "second"),
                (1, 0x9020, "continuation"),
            ],
        )
        self.assertTrue(any("differs from slot count" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
