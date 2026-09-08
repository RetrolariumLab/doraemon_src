from __future__ import annotations

import json
from pathlib import Path
import sys
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))

from scripts.authoring.level_object_sprites import (
    SpriteSpec,
    placeholder_bitmap,
    render_fixed_metasprite,
    render_variable_metasprite,
    world1_sprite_spec,
    world2_sprite_spec,
    world3_sprite_spec,
)


def load(path: str) -> dict:
    return json.loads((ROOT / path).read_text(encoding="utf-8"))


OPAQUE_TILE = tuple(tuple(1 for _x in range(8)) for _y in range(8))
ASYMMETRIC_TILE = tuple(
    tuple(1 if x < 2 else 0 for x in range(8)) for _y in range(8)
)
PALETTE = tuple(range(32))


class LevelObjectSpriteTests(unittest.TestCase):
    def test_world1_specs_cover_enemy_descriptor_and_hidden_variants(self) -> None:
        objects = load("data/world1/object_data.json")
        handlers = load(
            "config/reconstruction/world1/world1_enemy_handlers.json"
        )
        enemy = world1_sprite_spec(0x00, objects, handlers)
        item = world1_sprite_spec(0x85, objects, handlers)
        hidden = world1_sprite_spec(0xC5, objects, handlers)
        self.assertEqual((enemy.metasprite_index, enemy.palette_row), (0x64, 1))
        self.assertEqual(item.metasprite_index, 0x2A)
        self.assertFalse(item.hidden)
        self.assertTrue(hidden.hidden)

    def test_world2_physical_states_select_the_first_runtime_frame(self) -> None:
        identities = load("config/authoring/world2/world2_enemy_identities.json")
        self.assertEqual(world2_sprite_spec(0, identities).metasprite_index, 0)
        self.assertIsNone(world2_sprite_spec(8, identities).metasprite_index)

    def test_world3_type_uses_catalog_base_and_palette_row(self) -> None:
        catalog = load("data/world3/object_catalog.json")
        self.assertEqual(world3_sprite_spec(0, catalog), SpriteSpec(0x10, 2))
        self.assertEqual(world3_sprite_spec(4, catalog), SpriteSpec(0x20, 0))

    def test_variable_renderer_resolves_alias_flip_and_transparency(self) -> None:
        document = {
            "index_entries": [
                {"id": 0, "kind": "direct", "metasprite_address": "0x9000"},
                {"id": 1, "kind": "alias", "source_index": 0, "flip": "horizontal"},
            ],
            "metasprites": [{
                "id": 0,
                "address": "0x9000",
                "x_mirror_extent": "0x08",
                "y_mirror_extent": "0x00",
                "pieces": [
                    {"id": 0, "y_offset": "0x00", "x_offset": "0x00", "tile": "0x00"}
                ],
            }],
        }
        bitmap = render_variable_metasprite(
            document, (ASYMMETRIC_TILE,), PALETTE, SpriteSpec(1, 0)
        )
        self.assertIsNotNone(bitmap)
        assert bitmap is not None
        self.assertEqual((bitmap.offset_x, bitmap.width, bitmap.height), (8, 8, 8))
        self.assertIsNone(bitmap.pixels[0][0])
        self.assertIsNotNone(bitmap.pixels[0][6])

    def test_fixed_renderer_honors_zero_tiles_and_oam_flip(self) -> None:
        document = {
            "metasprites": [{
                "id": 0,
                "tiles": ["0x01", "0x00", "0x00", "0x00"],
                "palette": 0,
                "attribute_base": "0x00",
            }],
            "oam_attributes": [
                {"id": 0, "value": "0x40"},
                {"id": 1, "value": "0x00"},
                {"id": 2, "value": "0x00"},
                {"id": 3, "value": "0x00"},
            ],
        }
        bitmap = render_fixed_metasprite(
            document,
            (OPAQUE_TILE, ASYMMETRIC_TILE),
            tuple(range(16)),
            SpriteSpec(0, 0),
        )
        self.assertIsNotNone(bitmap)
        assert bitmap is not None
        self.assertIsNone(bitmap.pixels[0][0])
        self.assertIsNotNone(bitmap.pixels[0][6])
        self.assertTrue(all(pixel is None for row in bitmap.pixels[8:] for pixel in row))

    def test_hidden_bitmaps_are_dithered_but_remain_visible(self) -> None:
        visible = placeholder_bitmap()
        hidden = placeholder_bitmap(hidden=True)
        visible_count = sum(pixel is not None for row in visible.pixels for pixel in row)
        hidden_count = sum(pixel is not None for row in hidden.pixels for pixel in row)
        self.assertGreater(hidden_count, 0)
        self.assertLess(hidden_count, visible_count)

    def test_canonical_catalogs_render_every_placed_sprite_family(self) -> None:
        tiles = (OPAQUE_TILE,) * 256
        world1_metasprites = load("data/world1/metasprites.json")
        world1_objects = load("data/world1/object_data.json")
        world1_handlers = load(
            "config/reconstruction/world1/world1_enemy_handlers.json"
        )
        for type_id in (*range(12), *range(0x80, 0x8D), *range(0xC0, 0xCD)):
            spec = world1_sprite_spec(type_id, world1_objects, world1_handlers)
            self.assertIsNotNone(
                render_variable_metasprite(
                    world1_metasprites, tiles, PALETTE, spec
                ),
                f"World 1 type ${type_id:02X}",
            )

        world2_metasprites = load("data/world2/metasprites.json")
        world2_identities = load(
            "config/authoring/world2/world2_enemy_identities.json"
        )
        for physical_state in range(15):
            spec = world2_sprite_spec(physical_state, world2_identities)
            bitmap = render_fixed_metasprite(
                world2_metasprites, tiles, tuple(range(16)), spec
            )
            if physical_state == 8:
                self.assertIsNone(bitmap)  # Buran is drawn in the background layer.
            else:
                self.assertIsNotNone(bitmap, f"World 2 state {physical_state + 1}")

        world3_metasprites = load("data/world3/metasprites.json")
        world3_objects = load("data/world3/object_catalog.json")
        for type_id in range(32):
            self.assertIsNotNone(
                render_variable_metasprite(
                    world3_metasprites,
                    tiles,
                    PALETTE,
                    world3_sprite_spec(type_id, world3_objects),
                ),
                f"World 3 type ${type_id:02X}",
            )


if __name__ == "__main__":
    unittest.main()
