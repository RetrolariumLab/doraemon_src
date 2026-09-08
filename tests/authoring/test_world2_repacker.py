from __future__ import annotations

from dataclasses import dataclass
import json
from pathlib import Path
import sys
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))

from scripts.validation.world2 import world2_streaming
from scripts.authoring.world2_level_model import World2ScreenDocument
from scripts.authoring.world2_repacker import (
    EncodedScreen,
    encode_row,
    pack_screens,
    repack_document,
)


@dataclass(frozen=True)
class Cell:
    metatile: int
    token_kind: str = "literal"
    enemy_state: int | None = None


class World2RepackerTests(unittest.TestCase):
    def test_row_encoder_splits_an_existing_run(self) -> None:
        row = [Cell(2), Cell(3), Cell(5), Cell(3)]
        encoded = encode_row(row, 4)
        errors, decoded = world2_streaming.decode_screen(encoded.data, 0, 1, 4)
        self.assertEqual(errors, [])
        values = []
        for token in decoded.rows[0].tokens:
            if token.kind == "literal":
                values.append(token.value)
            elif token.kind == "rle":
                values.extend([token.repeated_literal] * ((token.value & 15) + 1))
        self.assertEqual(values, [2, 3, 5, 3])

    def test_row_encoder_preserves_enemy_and_padding(self) -> None:
        row = [Cell(0, "spawn", 4)] + [Cell(0, "padding")] * 15
        self.assertEqual(encode_row(row, 4), EncodedScreen(b"\xD4\xEF", "TT"))

    def test_packer_reuses_only_role_compatible_overlaps(self) -> None:
        packed, roles, pointers = pack_screens((
            EncodedScreen(b"\x01\xF1\x02", "TTO"),
            EncodedScreen(b"\xF1\x02\x03", "TTT"),
            EncodedScreen(b"\x01\xF1\x02", "TTO"),
        ))
        self.assertEqual(packed, b"\x01\xF1\x02\xF1\x02\x03")
        self.assertEqual(roles, "TTOTTT")
        self.assertEqual(pointers[0], pointers[2])
        self.assertNotEqual(pointers[0], pointers[1])

    def test_canonical_screens_repack_within_the_original_region(self) -> None:
        source = json.loads(
            (ROOT / "data/world2/compressed_screens.json").read_text(
                encoding="utf-8"
            )
        )
        model = World2ScreenDocument(source)
        logical = [model.screen(index) for index in range(model.selector_count)]
        result = repack_document(source, logical)
        encoded = world2_streaming.encode_authoring(result)
        self.assertEqual(len(encoded), 16669)
        self.assertEqual(len(result["selectors"]), 119)
        self.assertEqual(encoded[-1], world2_streaming.encode_authoring(source)[-1])

    def test_repacker_rejects_content_over_capacity(self) -> None:
        source = {
            "schema_version": 1,
            "format": "world2-compressed-screens",
            "pointer_table_address": "0x9000",
            "region_address": "0x9100",
            "region_size": 4,
            "rows_per_screen": 1,
            "minimum_cells_per_row": 4,
            "payload_crc32": "unused",
            "selectors": [
                {"id": 0, "address": "0x9100", "alias_of": None, "rows": ["0000-0004:4"]}
            ],
            "tokens": ["0000:L:01", "0001:L:02", "0002:L:03", "0003:L:04"],
        }
        logical = [[(Cell(1), Cell(2), Cell(3), Cell(4))]]
        with self.assertRaisesRegex(ValueError, "capacity"):
            repack_document(source, logical)


if __name__ == "__main__":
    unittest.main()
