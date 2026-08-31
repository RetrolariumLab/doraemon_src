from __future__ import annotations

from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import map_data


class MapContractTests(unittest.TestCase):
    def test_all_declared_regions_have_fixed_crc(self) -> None:
        self.assertEqual(len(map_data.REGIONS), 12)
        self.assertTrue(all(len(region.crc32) == 8 for region in map_data.REGIONS))

    def test_map_dimensions_match_sizes(self) -> None:
        maps = [region for region in map_data.REGIONS if region.width and region.records is None]
        for region in maps:
            self.assertEqual(region.size, region.width * region.height)

    def test_world2_declared_block_table_overlaps_screens_by_179_bytes(self) -> None:
        self.assertEqual(0xBAAF + 1024 - 0xBDFC, 179)

    def test_crc32_is_lowercase_and_zero_padded(self) -> None:
        self.assertEqual(map_data.crc32(b""), "00000000")


if __name__ == "__main__":
    unittest.main()
