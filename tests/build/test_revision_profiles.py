from __future__ import annotations

import hashlib
from pathlib import Path
import sys
import tempfile
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))

from scripts.build import project
from scripts.build import revision_profiles


def sample_ines(prg: bytes | None = None) -> bytes:
    header = b"NES\x1a" + bytes((8, 4, 0x21, 0x40)) + bytes(8)
    return header + (prg if prg is not None else bytes(131_072)) + bytes(32_768)


def sample_profile(profile_id: str, image: bytes) -> dict[str, object]:
    _parsed, facts = project.image_facts(image)
    return {
        "id": profile_id,
        "file_size": facts["file_size"],
        "file_sha1": facts["file_sha1"],
        "file_sha256": facts["file_sha256"],
        "file_crc32": facts["file_crc32"],
        "header_size": facts["header_size"],
        "header_sha1": facts["header_sha1"],
        "prg_size": facts["prg_size"],
        "prg_sha1": facts["prg_sha1"],
        "prg_crc32": facts["prg_crc32"],
        "chr_size": facts["chr_size"],
        "chr_sha1": facts["chr_sha1"],
        "chr_crc32": facts["chr_crc32"],
        "payload_sha1": facts["payload_sha1"],
        "payload_crc32": facts["payload_crc32"],
        "source_assets": [],
    }


class RevisionProfileTests(unittest.TestCase):
    def make_comparison(self) -> tuple[dict[str, object], bytes, bytes]:
        base_prg = bytes(131_072)
        candidate_prg = bytearray(base_prg)
        candidate_prg[0x10010] = 0xFF
        base = sample_ines(base_prg)
        candidate = sample_ines(bytes(candidate_prg))
        document = {
            "schema_version": 1,
            "default_profile": "base",
            "profiles": [
                sample_profile("base", base),
                sample_profile("candidate", candidate),
            ],
            "comparison": {
                "base_profile": "base",
                "candidate_profile": "candidate",
                "common_regions": ["header", "chr"],
                "differing_regions": ["prg"],
                "prg_difference_bytes": 1,
                "windows": [
                    {
                        "bank": 2,
                        "start": "0x8010",
                        "end": "0x8010",
                        "prg_offset": "0x10010",
                        "size": 1,
                        "classification": "code",
                        "source": "src/example.asm",
                        "base_sha1": hashlib.sha1(b"\x00").hexdigest(),
                        "candidate_sha1": hashlib.sha1(b"\xff").hexdigest(),
                    }
                ],
            },
        }
        return document, base, candidate

    def test_accepts_classified_code_difference(self) -> None:
        document, base, candidate = self.make_comparison()
        revision_profiles.audit_comparison(document, base, candidate)

    def test_rejects_difference_outside_windows(self) -> None:
        document, base, candidate = self.make_comparison()
        document["comparison"]["windows"][0]["prg_offset"] = "0x10011"
        with self.assertRaisesRegex(revision_profiles.RevisionError, "address, offset"):
            revision_profiles.audit_comparison(document, base, candidate)

    def test_rejects_wrong_profile_hash(self) -> None:
        document, base, _candidate = self.make_comparison()
        document["profiles"][0]["prg_sha1"] = "0" * 40
        with self.assertRaisesRegex(revision_profiles.RevisionError, "prg_sha1 mismatch"):
            revision_profiles.validate_profile_image(base, document["profiles"][0])

    def test_empty_data_split_writes_nothing(self) -> None:
        document, base, _candidate = self.make_comparison()
        profile = document["profiles"][0]
        regions = revision_profiles.validate_profile_image(base, profile)
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            revision_profiles.split_source_assets(profile, regions, root)
            self.assertEqual(list(root.iterdir()), [])


if __name__ == "__main__":
    unittest.main()
