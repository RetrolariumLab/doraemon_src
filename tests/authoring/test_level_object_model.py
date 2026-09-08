from __future__ import annotations

from copy import deepcopy
import json
from pathlib import Path
import sys
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))

from scripts.authoring.level_object_model import (
    change_world1_type,
    change_world3_persistent_type,
    change_world3_transient_type,
    move_world1_object,
    move_world3_persistent_object,
    world1_objects,
    world2_inventory_selectors,
    world3_persistent_objects,
    world3_transient_objects,
)
from scripts.authoring.object_artifacts import ObjectWorkspace


def load(path: str) -> dict:
    return json.loads((ROOT / path).read_text(encoding="utf-8"))


class LevelObjectModelTests(unittest.TestCase):
    def test_world1_coordinates_cover_both_maps_in_native_pixels(self) -> None:
        document = load("data/world1/object_data.json")
        city = world1_objects(document, "city")
        underground = world1_objects(document, "underground")
        self.assertEqual((len(city), len(underground)), (112, 33))
        self.assertEqual((city[0].native_x, city[0].native_y), (1520, 1168))
        self.assertEqual(underground[0].type_id, 0x85)

    def test_world1_drag_snaps_and_preserves_the_sorted_city_tail(self) -> None:
        document = load("data/world1/object_data.json")
        records = document["placement_lists"][1]["records"]
        self.assertEqual(document["placement_lists"][1]["id"], "world1_city_objects")
        index = 60
        lower = int(records[index - 1]["x_cell"])
        upper = int(records[index + 1]["x_cell"])
        move_world1_object(document, "city", index, 0, 77, 2048, 2048)
        self.assertEqual(records[index]["x_cell"], lower)
        self.assertLessEqual(records[index]["x_cell"], upper)
        self.assertEqual(records[index]["y_cell"], 10)
        change_world1_type(document, "city", index, 0xC4)
        self.assertEqual(records[index]["type"], "0xC4")

    def test_world3_drag_crosses_room_boundaries_losslessly(self) -> None:
        document = load("data/world3/object_catalog.json")
        original = world3_persistent_objects(document)[0]
        self.assertEqual(original.room, 0x07)
        move_world3_persistent_object(document, 0, 260, 520)
        moved = world3_persistent_objects(document)[0]
        self.assertEqual(moved.room, 0x11)
        self.assertEqual((moved.native_x, moved.native_y), (260, 520))
        change_world3_persistent_type(document, 0, 0x1F)
        self.assertEqual(world3_persistent_objects(document)[0].type_id, 0x1F)

    def test_transient_badges_expose_only_active_room_channels(self) -> None:
        document = load("data/world3/transient_spawns.json")
        markers = world3_transient_objects(document)
        self.assertTrue(markers)
        self.assertTrue(all(marker.count > 0 and not marker.movable for marker in markers))
        first = markers[0]
        changed = deepcopy(document)
        change_world3_transient_type(
            changed, int(first.room), int(first.channel), 0x0F
        )
        replacement = next(
            marker
            for marker in world3_transient_objects(changed)
            if marker.key == first.key
        )
        self.assertEqual(replacement.type_id, 0x0F)

    def test_world2_inventory_badges_match_the_seven_screen_table(self) -> None:
        selectors = world2_inventory_selectors(
            load("data/world2/inventory_spawn_screens.json")
        )
        self.assertEqual(selectors, frozenset((0x14, 0x1A, 0x1F, 0x47, 0x45, 0x6D, 0x74)))

    def test_visual_edits_pass_the_native_fixed_capacity_encoders(self) -> None:
        documents = ObjectWorkspace(
            ROOT, ROOT / "content/workspace", "original"
        ).load_canonical()
        world1 = documents["world1_object_placements"]
        self.assertTrue(
            world1.change(
                lambda data: move_world1_object(
                    data, "underground", 0, 1000, 400, 2048, 800
                )
            )
        )
        world3 = documents["world3_object_catalog"]
        self.assertTrue(
            world3.change(
                lambda data: move_world3_persistent_object(data, 0, 300, 600)
            )
        )
        transient = documents["world3_transient_spawns"]
        self.assertTrue(
            transient.change(
                lambda data: change_world3_transient_type(data, 0, 0, 0x0F)
            )
        )


if __name__ == "__main__":
    unittest.main()
