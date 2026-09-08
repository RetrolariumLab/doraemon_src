from __future__ import annotations

from pathlib import Path
import sys
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))

from scripts.authoring.level_studio_model import HierarchicalWorldDocument
from scripts.authoring.level_studio_rendering import (
    NES_RGB,
    background_palette_row,
    decode_background_tiles,
    decode_chr_tile,
    load_world2_metatiles,
    load_world2_palettes,
    load_world_palettes,
    parse_palette_catalog,
    parse_world2_palette_catalog,
    render_big_block,
    render_world2_metatile,
)


class LevelStudioRenderingTests(unittest.TestCase):
    def fixture(self) -> HierarchicalWorldDocument:
        return HierarchicalWorldDocument({
            "schema_version": 1,
            "format": "doraemon-hierarchical-world",
            "id": "world1",
            "bank": 0,
            "address": "0x9000",
            "end_address": "0x900B",
            "payload_crc32": "unused",
            "attributes": {
                "address": "0x9000",
                "count": 1,
                "entries": [{"id": 0, "palette": 0, "properties": "0x00"}],
            },
            "small_blocks": {
                "address": "0x9001",
                "count": 1,
                "width": 2,
                "height": 2,
                "entries": [{"id": 0, "tiles": ["0x00"] * 4}],
            },
            "big_blocks": {
                "address": "0x9005",
                "count": 1,
                "width": 2,
                "height": 2,
                "entries": [{"id": 0, "small_blocks": ["0x00"] * 4}],
            },
            "maps": [{
                "id": "fixture",
                "address": "0x9009",
                "width": 3,
                "height": 1,
                "rows": ["00 00 00"],
            }],
        })

    def test_decodes_both_chr_bitplanes(self) -> None:
        data = bytes((0x80, 0, 0, 0, 0, 0, 0, 1, 0x80, 0, 0, 0, 0, 0, 0, 1))
        tile = decode_chr_tile(data)
        self.assertEqual(tile[0][0], 3)
        self.assertEqual(tile[0][1], 0)
        self.assertEqual(tile[7][7], 3)

    def test_selects_background_half_of_requested_chr_bank(self) -> None:
        chr_data = bytearray(4 * 0x2000)
        offset = 2 * 0x2000 + 0x1000
        chr_data[offset] = 0x80
        tiles = decode_background_tiles(bytes(chr_data), 2)
        self.assertEqual(len(tiles), 256)
        self.assertEqual(tiles[0][0][0], 1)
        self.assertEqual(tiles[0][0][1], 0)

    def test_palette_catalog_accepts_both_authoring_encodings(self) -> None:
        colors = list(range(32))
        catalog = parse_palette_catalog({
            "palette_count": 2,
            "palettes": [
                {"id": 0, "colors": " ".join(f"{value:02X}" for value in colors)},
                {"id": 1, "colors": [f"0x{value:02X}" for value in colors]},
            ],
        })
        self.assertEqual(catalog[0], tuple(colors))
        self.assertEqual(catalog[1], tuple(colors))
        self.assertEqual(background_palette_row(catalog[0], 2), (8, 9, 10, 11))

    def test_renders_big_block_with_selected_background_colors(self) -> None:
        blank = tuple(tuple(0 for _x in range(8)) for _y in range(8))
        marked = tuple(
            tuple(1 if x == y else 0 for x in range(8))
            for y in range(8)
        )
        tiles = [blank] * 256
        tiles[0] = marked
        palette = tuple((0x0F, 0x21, 0x31, 0x30) * 8)
        pixels = render_big_block(self.fixture(), 0, tiles, palette)
        self.assertEqual(len(pixels), 32)
        self.assertEqual(len(pixels[0]), 32)
        self.assertEqual(pixels[0][0], NES_RGB[0x21])
        self.assertEqual(pixels[0][1], NES_RGB[0x0F])

    def test_checked_in_palette_catalogs_cover_both_hierarchical_worlds(self) -> None:
        self.assertEqual(len(load_world_palettes(ROOT, "world1")), 12)
        self.assertEqual(len(load_world_palettes(ROOT, "world3")), 11)

    def test_world2_palette_parser_accepts_background_only_sets(self) -> None:
        colors = list(range(16))
        catalog = parse_world2_palette_catalog({
            "palette_count": 2,
            "colors_per_set": 16,
            "palettes": [
                {"id": 0, "colors": " ".join(f"{value:02X}" for value in colors)},
                {"id": 1, "colors": [f"0x{value:02X}" for value in colors]},
            ],
        })
        self.assertEqual(catalog, (tuple(colors), tuple(colors)))

    def test_world2_palette_parser_rejects_full_ppu_sets(self) -> None:
        with self.assertRaisesRegex(ValueError, "must contain 16 colors"):
            parse_world2_palette_catalog({
                "palette_count": 1,
                "colors_per_set": 16,
                "palettes": [{"id": 0, "colors": ["0x0F"] * 32}],
            })

    def test_world2_catalog_renders_all_208_metatiles(self) -> None:
        metatiles = load_world2_metatiles(ROOT)
        palettes = load_world2_palettes(ROOT)
        blank = tuple(tuple(0 for _x in range(8)) for _y in range(8))
        tiles = (blank,) * 256
        self.assertEqual(len(metatiles), 208)
        self.assertEqual(len(palettes), 9)
        pixels = render_world2_metatile(metatiles[0], tiles, palettes[0])
        self.assertEqual((len(pixels[0]), len(pixels)), (16, 16))
        self.assertEqual(pixels[0][0], NES_RGB[palettes[0][4]])


if __name__ == "__main__":
    unittest.main()
