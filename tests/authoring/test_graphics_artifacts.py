from __future__ import annotations

import copy
from pathlib import Path
import tempfile
import unittest

from scripts.authoring.graphics_artifacts import (
    ARTIFACTS,
    PRG_BANK_SIZE,
    CPU_BASE,
    GraphicsArtifactDocument,
    PrgGraphicsWorkspace,
    apply_graphics_artifacts,
    validate_artifact_set,
)


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
EXPECTED_SIZES = {
    "world1_palettes": 384,
    "world1_metasprites": 1739,
    "world2_metatiles": 1067,
    "world2_palettes": 150,
    "world2_metasprites": 326,
    "world3_metasprites": 1911,
}


class GraphicsArtifactTests(unittest.TestCase):
    def canonical_documents(
        self, workspace: Path
    ) -> dict[str, GraphicsArtifactDocument]:
        return {
            artifact.id: GraphicsArtifactDocument.load(
                artifact, ROOT / artifact.canonical_path
            )
            for artifact in ARTIFACTS
        }

    def test_canonical_graphics_artifacts_have_disjoint_fixed_coverage(self) -> None:
        documents = self.canonical_documents(ROOT)
        self.assertEqual(validate_artifact_set(documents), EXPECTED_SIZES)

    def test_palette_edit_updates_crc_and_is_undoable(self) -> None:
        artifact = next(item for item in ARTIFACTS if item.id == "world1_palettes")
        document = GraphicsArtifactDocument.load(
            artifact, ROOT / artifact.canonical_path
        )
        before = copy.deepcopy(document.document)

        def edit(data: dict[str, object]) -> None:
            palettes = data["palettes"]
            colors = palettes[0]["colors"].split()
            colors[1] = "02" if colors[1] != "02" else "03"
            palettes[0]["colors"] = " ".join(colors)

        self.assertTrue(document.change(edit))
        self.assertNotEqual(
            document.document["covered_crc32"], before["covered_crc32"]
        )
        self.assertTrue(document.undo())
        self.assertEqual(document.document, before)
        self.assertTrue(document.redo())
        self.assertNotEqual(document.document, before)

    def test_composer_changes_only_the_edited_palette_byte(self) -> None:
        documents = self.canonical_documents(ROOT)
        baseline = apply_graphics_artifacts(bytes(4 * PRG_BANK_SIZE), documents)
        palette = documents["world1_palettes"]
        old = palette.document["palettes"][0]["colors"].split()
        replacement = "02" if old[1] != "02" else "03"
        palette.change(
            lambda data: data["palettes"][0].__setitem__(
                "colors", " ".join([old[0], replacement, *old[2:]])
            )
        )
        edited = apply_graphics_artifacts(bytes(4 * PRG_BANK_SIZE), documents)
        differences = [
            index
            for index, (left, right) in enumerate(zip(baseline, edited))
            if left != right
        ]
        expected = int(palette.document["bank"]) * PRG_BANK_SIZE
        expected += int(palette.document["address"], 0) - CPU_BASE + 1
        self.assertEqual(differences, [expected])

    def test_workspace_initialization_preserves_existing_document(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            workspace = PrgGraphicsWorkspace(ROOT, root, "rev_a")
            created = workspace.initialize()
            self.assertEqual(len(created), len(ARTIFACTS))
            marker = workspace.path(ARTIFACTS[0])
            marker.write_text('{"local": true}\n', encoding="utf-8")
            self.assertEqual(workspace.initialize(), ())
            self.assertEqual(marker.read_text(encoding="utf-8"), '{"local": true}\n')


if __name__ == "__main__":
    unittest.main()
