from __future__ import annotations

import json
from pathlib import Path
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import project


def sample_ines() -> bytes:
    header = b"NES\x1a" + bytes((8, 4, 0x21, 0x40)) + bytes(8)
    return header + bytes(131_072) + bytes([0xFF]) * 32_768


def sample_manifest(image: bytes) -> dict[str, object]:
    parsed, facts = project.image_facts(image)
    return {
        "schema_version": 1,
        "reference_rom": {
            "file_size": len(image),
            "file_sha1": facts["file_sha1"],
            "file_crc32": facts["file_crc32"],
            "payload_crc32": facts["payload_crc32"],
            "prg_size": len(parsed["prg"]),
            "prg_crc32": facts["prg_crc32"],
            "chr_size": len(parsed["chr"]),
            "chr_crc32": facts["chr_crc32"],
            "trainer_size": 0,
            "mapper": 66,
            "mirroring": "vertical",
        },
    }


class InesTests(unittest.TestCase):
    def test_parse_doraemon_shape(self) -> None:
        parsed = project.parse_ines(sample_ines())
        self.assertEqual(parsed["mapper"], 66)
        self.assertEqual(parsed["mirroring"], "vertical")
        self.assertEqual(len(parsed["prg"]), 131_072)
        self.assertEqual(len(parsed["chr"]), 32_768)

    def test_rejects_trailing_data(self) -> None:
        with self.assertRaisesRegex(project.ProjectError, "expected exactly"):
            project.parse_ines(sample_ines() + b"trailing")

    def test_manifest_detects_changed_chr(self) -> None:
        image = sample_ines()
        changed = image[:-1] + b"\x00"
        with self.assertRaisesRegex(project.ProjectError, "mismatch"):
            project.validate_image(changed, sample_manifest(image))


class AssetTests(unittest.TestCase):
    def test_safe_asset_path(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            self.assertEqual(project.safe_asset_path(root, "chr/doraemon.chr"), root / "chr" / "doraemon.chr")

    def test_rejects_parent_asset_path(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            with self.assertRaisesRegex(project.ProjectError, "unsafe"):
                project.safe_asset_path(Path(directory), "../game.chr")

    def test_load_manifest_rejects_unknown_schema(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "manifest.json"
            path.write_text(json.dumps({"schema_version": 2}), encoding="utf-8")
            with self.assertRaisesRegex(project.ProjectError, "schema"):
                project.load_manifest(path)


class PrgDataRangeTests(unittest.TestCase):
    def test_loads_bank_qualified_ranges(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "ranges.txt"
            path.write_text(
                "table 0 8000 800F FirstTable\nmap 1 9000 90FF OtherBankMap\n",
                encoding="utf-8",
            )
            self.assertEqual(
                project.load_prg_data_ranges(path),
                [
                    ("table", 0, 0x8000, 0x800F, "FirstTable"),
                    ("map", 1, 0x9000, 0x90FF, "OtherBankMap"),
                ],
            )

    def test_allows_same_cpu_range_in_different_banks(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "ranges.txt"
            path.write_text(
                "table 0 9000 90FF Bank0Table\ntable 1 9000 90FF Bank1Table\n",
                encoding="utf-8",
            )
            self.assertEqual(len(project.load_prg_data_ranges(path)), 2)

    def test_rejects_overlap_within_one_bank(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "ranges.txt"
            path.write_text(
                "table 2 8000 8010 First\ndata 2 8010 8020 Second\n",
                encoding="utf-8",
            )
            with self.assertRaisesRegex(project.ProjectError, "overlap"):
                project.load_prg_data_ranges(path)


if __name__ == "__main__":
    unittest.main()
