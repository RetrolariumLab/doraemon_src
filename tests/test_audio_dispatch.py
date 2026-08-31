from __future__ import annotations

import copy
import importlib.util
from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))
SPEC = importlib.util.spec_from_file_location(
    "audio_dispatch", ROOT / "scripts" / "audio_dispatch.py"
)
assert SPEC is not None and SPEC.loader is not None
AUDIO = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(AUDIO)


class AudioDispatchTests(unittest.TestCase):
    def fixture(self) -> tuple[bytearray, dict[str, object]]:
        prg = bytearray(4 * AUDIO.BANK_SIZE)
        document = {
            "bank": 3,
            "request_count": 2,
            "priority_table": {
                "address": "0x8000",
                "values": ["0x00", "0x02"],
            },
            "dispatch_table": {
                "address": "0x8010",
                "slot_count": 2,
                "targets": ["0x9000", "0x9010"],
            },
            "music_command_table": {
                "address": "0x8020",
                "first_command": "0xFF",
                "last_command": "0xFF",
                "slot_count": 1,
                "targets": ["0x9020"],
            },
        }
        start = 3 * AUDIO.BANK_SIZE
        prg[start:start + 2] = b"\x00\x02"
        prg[start + 0x10:start + 0x14] = b"\xFF\x8F\x0F\x90"
        prg[start + 0x20:start + 0x22] = b"\x1F\x90"
        return prg, document

    def test_accepts_encoded_targets_registered_as_code(self) -> None:
        prg, document = self.fixture()
        errors, report = AUDIO.validate(
            bytes(prg),
            document,
            [(3, 0x9000, "one"), (3, 0x9010, "two"), (3, 0x9020, "three")],
        )
        self.assertEqual(errors, [])
        self.assertEqual(report["unique_target_count"], 2)

    def test_rejects_unregistered_indirect_target(self) -> None:
        prg, document = self.fixture()
        errors, _report = AUDIO.validate(
            bytes(prg), document, [(3, 0x9000, "one")]
        )
        self.assertTrue(any("$9010" in error for error in errors))

    def test_validates_additional_bank_local_driver(self) -> None:
        prg, document = self.fixture()
        extra = copy.deepcopy(document)
        extra["name"] = "second"
        extra["bank"] = 2
        document["additional_drivers"] = [extra]
        bank2 = 2 * AUDIO.BANK_SIZE
        prg[bank2:bank2 + 2] = b"\x00\x02"
        prg[bank2 + 0x10:bank2 + 0x14] = b"\xFF\x8F\x0F\x90"
        prg[bank2 + 0x20:bank2 + 0x22] = b"\x1F\x90"
        entries = [
            (bank, address, "entry")
            for bank in (2, 3)
            for address in (0x9000, 0x9010, 0x9020)
        ]
        errors, report = AUDIO.validate(bytes(prg), document, entries)
        self.assertEqual(errors, [])
        self.assertEqual(report["driver_count"], 2)


if __name__ == "__main__":
    unittest.main()
