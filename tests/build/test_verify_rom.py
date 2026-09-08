from __future__ import annotations

from pathlib import Path
import sys
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))

from scripts.build import verify_rom


class DifferenceTests(unittest.TestCase):
    def test_equal_data_has_no_difference(self) -> None:
        self.assertIsNone(verify_rom.first_difference(b"abc", b"abc"))

    def test_finds_changed_byte(self) -> None:
        self.assertEqual(verify_rom.first_difference(b"axc", b"abc"), 1)

    def test_finds_truncation(self) -> None:
        self.assertEqual(verify_rom.first_difference(b"ab", b"abc"), 2)

    def test_prg_offset_reports_bank_and_cpu_address(self) -> None:
        detail = verify_rom.describe_offset("prg", 0x8000 + 0x123, 16, 0x20000)
        self.assertIn("bank 1", detail)
        self.assertIn("CPU $8123", detail)

    def test_payload_chr_offset_reports_chr_bank(self) -> None:
        detail = verify_rom.describe_offset("payload", 0x20000 + 0x2001, 16, 0x20000)
        self.assertIn("CHR bank 1", detail)


if __name__ == "__main__":
    unittest.main()
