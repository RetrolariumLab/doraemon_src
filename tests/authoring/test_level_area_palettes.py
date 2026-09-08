from __future__ import annotations

import json
from pathlib import Path
import sys
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))

from scripts.authoring.level_area_palettes import (
    world1_area_palette,
    world2_sprite_palette_record,
)


def load(path: str) -> dict:
    return json.loads((ROOT / path).read_text(encoding="utf-8"))


class LevelAreaPaletteTests(unittest.TestCase):
    def test_city_atlas_uses_the_two_runtime_area_palettes(self) -> None:
        rooms = load("data/world1/underground_rooms.json")
        self.assertEqual(world1_area_palette("city", 0, 0, rooms), 1)
        self.assertEqual(world1_area_palette("city", 63, 21, rooms), 1)
        self.assertEqual(world1_area_palette("city", 0, 22, rooms), 0)
        self.assertEqual(world1_area_palette("city", 63, 63, rooms), 0)

    def test_underground_physical_regions_follow_room_area_ids(self) -> None:
        rooms = load("data/world1/underground_rooms.json")
        expected = {
            (8, 0): 8,
            (0, 8): 2,
            (16, 8): 3,
            (32, 8): 4,
            (48, 8): 5,
            (0, 16): 6,
            (16, 16): 7,
            (24, 16): 10,
        }
        for coordinate, palette in expected.items():
            self.assertEqual(
                world1_area_palette("underground", *coordinate, rooms),
                palette,
                coordinate,
            )

    def test_world2_route_parts_select_chapter_sprite_palettes(self) -> None:
        palettes = load("data/world2/palettes.json")
        self.assertEqual(world2_sprite_palette_record("Part 1", palettes), 6)
        for name in ("Part 2", "Part 2A", "Part 2B"):
            self.assertEqual(world2_sprite_palette_record(name, palettes), 7)
        self.assertEqual(world2_sprite_palette_record("Part 3", palettes), 8)


if __name__ == "__main__":
    unittest.main()
