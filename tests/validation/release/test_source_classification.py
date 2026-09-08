from __future__ import annotations

import copy
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
SPEC = importlib.util.spec_from_file_location(
    "source_classification",
    ROOT / "scripts" / "validation" / "release" / "source_classification.py",
)
assert SPEC is not None and SPEC.loader is not None
AUDIT = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(AUDIT)


def listing_line(address: int, source: str, byte: str = "00") -> str:
    return f"{address:06X}r 1  {byte:<12}     {source}"


def synthetic_listing() -> str:
    lines: list[str] = []
    for bank in range(4):
        lines.append(f'000000r 1               .segment "PRG{bank}"')
        lines.append(listing_line(0x0000, ".byte $00"))
        lines.append(listing_line(0x0010, "NOP", "EA"))
        lines.append(listing_line(0x0011, ".byte $00"))
        lines.append(listing_line(0x7FFF, "NOP", "EA"))
    lines.append('008000r 1               .segment "CHR"')
    return "\n".join(lines) + "\n"


class SourceClassificationTests(unittest.TestCase):
    def test_parses_complete_four_bank_statement_extents(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "test.lst"
            path.write_text(synthetic_listing(), encoding="utf-8")
            classes = AUDIT.parse_listing(path)
        self.assertEqual(len(classes["instruction"]), 8)
        self.assertEqual(len(classes["directive"]), 131064)
        self.assertIn((2, 0x8010), classes["instruction"])
        self.assertIn((3, 0xFFFE), classes["directive"])

    def test_rejects_an_instruction_sized_listing_gap(self) -> None:
        listing = synthetic_listing().replace(
            listing_line(0x0011, ".byte $00"),
            listing_line(0x0015, ".byte $00"),
            1,
        )
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "test.lst"
            path.write_text(listing, encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "instruction-sized"):
                AUDIT.parse_listing(path)

    def test_unknown_registry_requires_an_unknown_claim(self) -> None:
        text = (
            "## FIRST - open\n\n- Unknown: role.\n\n"
            "## SECOND - resolved\n\n- Known: role.\n"
        )
        self.assertEqual(AUDIT.unknown_sections(text), {"FIRST"})

    def test_validation_rejects_an_unowned_directive_byte(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "build").mkdir()
            (root / "config").mkdir()
            (root / "assets").mkdir()
            (root / "docs").mkdir()
            (root / "evidence.txt").write_text("proof\n", encoding="utf-8")
            listing = root / "build" / "test.lst"
            listing.write_text(synthetic_listing(), encoding="utf-8")
            base = root / "config" / "ranges.txt"
            base.write_text(
                "\n".join(
                    f"data {bank} 8000 800F Prefix{bank}" for bank in range(4)
                )
                + "\n",
                encoding="utf-8",
            )
            (root / "assets" / "prg.bin").write_bytes(bytes(0x20000))
            (root / "docs" / "unknowns.md").write_text(
                "# Unknowns\n", encoding="utf-8"
            )
            groups = [
                {
                    "id": f"tail-{bank}",
                    "kind": "typed-data",
                    "ranges": [
                        {"bank": bank, "start": "0x8011", "end": "0xFFFE"}
                    ],
                    "evidence": ["evidence.txt"],
                }
                for bank in range(4)
            ]
            classified = {
                "base-typed": 64,
                "typed-data": 131000,
                "encoded-code": 0,
                "padding": 0,
                "registered-unknown": 0,
            }
            by_bank = {
                str(bank): {
                    "instruction_bytes": 2,
                    "directive_bytes": 32766,
                    "base-typed": 16,
                    "typed-data": 32750,
                    "encoded-code": 0,
                    "padding": 0,
                    "registered-unknown": 0,
                }
                for bank in range(4)
            }
            document = {
                "schema_version": 1,
                "status": "complete",
                "prg_asset": "assets/prg.bin",
                "classifications": groups,
                "expected_metrics": {
                    "prg_bytes": 131072,
                    "instruction_bytes": 8,
                    "directive_bytes": 131064,
                    "classification_bytes": classified,
                    "by_bank": by_bank,
                },
            }
            errors, _metrics = AUDIT.validate(root, document, listing, base)
            self.assertEqual(errors, [])
            changed = copy.deepcopy(document)
            changed["classifications"][0]["ranges"][0]["end"] = "0xFFFD"
            errors, _metrics = AUDIT.validate(root, changed, listing, base)
        self.assertTrue(any("directive bytes are unclassified" in e for e in errors))


if __name__ == "__main__":
    unittest.main()
