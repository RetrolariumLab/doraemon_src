from __future__ import annotations

from pathlib import Path
import unittest

from scripts.authoring.graphics_artifacts import PrgGraphicsWorkspace
from scripts.authoring.graphics_studio import preview_palettes, workspace_palettes


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT


class GraphicsStudioTests(unittest.TestCase):
    def test_preview_catalogs_cover_all_four_chr_banks(self) -> None:
        catalogs = [preview_palettes(ROOT, bank) for bank in range(4)]
        self.assertEqual([len(catalog) for catalog in catalogs], [12, 9, 11, 1])
        self.assertTrue(
            all(
                len(palette) == 32
                for catalog in catalogs
                for palette in catalog
            )
        )

    def test_shell_bank_uses_an_explicit_neutral_preview(self) -> None:
        palette = preview_palettes(ROOT, 3)[0]
        self.assertEqual(palette[:4], (0x0F, 0x00, 0x10, 0x30))
        rows = {palette[index:index + 4] for index in range(0, 32, 4)}
        self.assertEqual(len(rows), 1)

    def test_workspace_palette_preview_reflects_unsaved_edits(self) -> None:
        workspace = PrgGraphicsWorkspace(ROOT, ROOT / "unused", "original")
        artifacts = workspace.load_canonical()
        before = workspace_palettes(artifacts, 1)[0][1]
        replacement = 2 if before != 2 else 3
        artifacts["world2_palettes"].change(
            lambda data: data["palettes"][0]["colors"].__setitem__(
                1, f"0x{replacement:02X}"
            )
        )
        self.assertEqual(workspace_palettes(artifacts, 1)[0][1], replacement)


if __name__ == "__main__":
    unittest.main()
