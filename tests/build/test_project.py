from __future__ import annotations

import json
from pathlib import Path
import sys
import tempfile
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))

from scripts.build import project


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
            "file_sha256": facts["file_sha256"],
            "file_crc32": facts["file_crc32"],
            "payload_crc32": facts["payload_crc32"],
            "payload_sha256": facts["payload_sha256"],
            "prg_size": len(parsed["prg"]),
            "prg_crc32": facts["prg_crc32"],
            "prg_sha256": facts["prg_sha256"],
            "chr_size": len(parsed["chr"]),
            "chr_crc32": facts["chr_crc32"],
            "chr_sha256": facts["chr_sha256"],
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
    def test_asset_sha256_is_checked(self) -> None:
        payload = b"private asset"
        entry = {
            "region": "fixture",
            "size": len(payload),
            "sha256": project.digest(payload, "sha256"),
        }
        project.validate_asset(payload, entry)
        entry["sha256"] = "0" * 64
        with self.assertRaisesRegex(project.ProjectError, "sha256 mismatch"):
            project.validate_asset(payload, entry)

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


if __name__ == "__main__":
    unittest.main()
