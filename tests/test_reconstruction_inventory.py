from __future__ import annotations

import importlib.util
from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parent.parent
SPEC = importlib.util.spec_from_file_location(
    "reconstruction_inventory",
    ROOT / "scripts" / "reconstruction_inventory.py",
)
assert SPEC is not None and SPEC.loader is not None
INVENTORY = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(INVENTORY)


class ReconstructionInventoryTests(unittest.TestCase):
    def test_counts_typed_ranges_by_bank_and_kind(self) -> None:
        actual = INVENTORY.typed_data_metrics(
            "table 0 8000 8001 First\nmap 0 8002 8004 Second\n"
            "vectors 1 FFFA FFFF Vectors\n"
        )
        self.assertEqual(actual["total"], {"range_count": 3, "typed_bytes": 11})
        self.assertEqual(actual["by_bank"]["0"]["typed_bytes"], 5)
        self.assertEqual(
            actual["by_bank"]["0"]["bytes_by_kind"], {"map": 3, "table": 2}
        )

    def test_rejects_overlapping_typed_ranges(self) -> None:
        with self.assertRaisesRegex(ValueError, "overlap"):
            INVENTORY.typed_data_metrics(
                "table 0 8000 8002 First\ntable 0 8002 8003 Second\n"
            )

    def test_counts_only_explicit_unknown_claims(self) -> None:
        text = (
            "## BANK-001 - one\n\n- Known: fact.\n- Unknown: question.\n"
            "## DATA-001 - two\n\n- Known: resolved.\n"
            "## AUDIO-001 - three\n\n- Unknown: first.\n- Unknown: second.\n"
        )
        self.assertEqual(
            INVENTORY.unknown_metrics(text),
            {
                "section_count": 2,
                "claim_count": 3,
                "section_ids": ["BANK-001", "AUDIO-001"],
            },
        )

    def test_counts_semantic_indirect_entry_symbols(self) -> None:
        text = (
            "entry 0 8000 Bank0_Generic\n"
            "entry 0 8010 Bank0_Other\n"
            "entry 1 8000 Bank1_Generic\n"
        )
        symbols = {
            (0, 0x8000): "World1_Main",
            (0, 0x8010): "Bank0_Func_8010",
        }
        actual = INVENTORY.code_entry_metrics(text, symbols)
        self.assertEqual(
            actual["total"], {"entries": 3, "semantic_symbols": 1}
        )
        self.assertEqual(actual["by_bank"]["0"]["semantic_symbols"], 1)

    def test_snapshot_must_match_exactly(self) -> None:
        snapshot = {"source_labels": {"total": 1}}
        self.assertEqual(
            INVENTORY.validate(snapshot, {"schema_version": 1, "snapshot": snapshot}),
            [],
        )
        self.assertTrue(
            INVENTORY.validate(snapshot, {"schema_version": 1, "snapshot": {}})
        )


if __name__ == "__main__":
    unittest.main()
