from __future__ import annotations

import hashlib
import json
from pathlib import Path
import tempfile
import unittest

from scripts.authoring.graphics_studio_model import (
    CHR_SIZE,
    ChrDocument,
    GraphicsWorkspace,
    decode_chr,
    encode_chr,
    global_tile_index,
)


def sample_chr() -> bytes:
    return bytes((index * 37 + index // 251) & 0xFF for index in range(CHR_SIZE))


class GraphicsStudioModelTests(unittest.TestCase):
    def test_four_bank_chr_roundtrip_is_exact(self) -> None:
        data = sample_chr()
        tiles = decode_chr(data)
        self.assertEqual(len(tiles), 2048)
        self.assertEqual(encode_chr(tiles), data)

    def test_global_tile_index_separates_banks_and_pattern_tables(self) -> None:
        self.assertEqual(global_tile_index(0, 0, 0), 0)
        self.assertEqual(global_tile_index(0, 1, 0), 256)
        self.assertEqual(global_tile_index(1, 0, 0), 512)
        self.assertEqual(global_tile_index(3, 1, 255), 2047)
        with self.assertRaisesRegex(ValueError, "CHR bank"):
            global_tile_index(4, 0, 0)

    def test_paint_stroke_is_one_undoable_transaction(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            path = Path(temporary) / "chr.bin"
            document = ChrDocument(sample_chr(), path)
            tile = global_tile_index(2, 1, 17)
            before = [row[:] for row in document.tiles[tile]]
            document.begin_stroke(tile)
            document.paint(tile, 0, 0, (before[0][0] + 1) & 3)
            document.paint(tile, 0, 1, (before[0][1] + 2) & 3)
            self.assertTrue(document.end_stroke())
            after = [row[:] for row in document.tiles[tile]]
            self.assertNotEqual(after, before)
            self.assertTrue(document.undo())
            self.assertEqual(document.tiles[tile], before)
            self.assertTrue(document.redo())
            self.assertEqual(document.tiles[tile], after)

    def test_atomic_save_updates_saved_baseline(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            path = Path(temporary) / "graphics" / "chr.bin"
            document = ChrDocument(sample_chr(), path)
            document.paint(0, 0, 0, (document.tiles[0][0][0] + 1) & 3)
            self.assertTrue(document.dirty)
            document.save()
            self.assertFalse(document.dirty)
            self.assertEqual(path.read_bytes(), document.encode())

    def test_workspace_initialization_is_profile_aware_and_non_destructive(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / "config/authoring").mkdir(parents=True)
            (root / "assets/generated/chr").mkdir(parents=True)
            data = sample_chr()
            (root / "assets/generated/chr/doraemon.chr").write_bytes(data)
            (root / "config/authoring/content_authoring_profiles.json").write_text(
                json.dumps(
                    {
                        "profiles": [
                            {
                                "id": "rev_a",
                                "studios": {"graphics": "partial"},
                            }
                        ]
                    }
                ),
                encoding="utf-8",
            )
            (root / "assets/manifest.json").write_text(
                json.dumps(
                    {
                        "extracted_assets": [
                            {
                                "region": "chr",
                                "path": "chr/doraemon.chr",
                                "sha256": hashlib.sha256(data).hexdigest(),
                            }
                        ]
                    }
                ),
                encoding="utf-8",
            )
            workspace = GraphicsWorkspace(root, root / "workspace", "rev_a")
            created = workspace.initialize()
            self.assertEqual(created, root / "workspace/rev_a/graphics/chr.bin")
            self.assertEqual(workspace.validate(), CHR_SIZE)
            workspace.chr_path.write_bytes(bytes(CHR_SIZE))
            self.assertIsNone(workspace.initialize())
            self.assertEqual(workspace.chr_path.read_bytes(), bytes(CHR_SIZE))


if __name__ == "__main__":
    unittest.main()
