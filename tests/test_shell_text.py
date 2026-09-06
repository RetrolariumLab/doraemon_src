from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import shell_text


class ShellTextTests(unittest.TestCase):
    def fixture(self) -> tuple[bytes, dict[str, object]]:
        bank = 3
        prg = bytearray(4 * shell_text.BANK_SIZE)

        def write(address: int, data: bytes) -> None:
            offset = bank * shell_text.BANK_SIZE + address - shell_text.CPU_BASE
            prg[offset:offset + len(data)] = data

        game = b"GAME\0OVER"
        title = b"\x21\xe7\x04PUSH\x22\x48\x02HI\0"
        ending = bytes(range(32))
        help_data = b"ONE." + b"ABCD" + b"TWO!" + b"1234"
        credits = b"ALPHA   " + b"BETA    "
        post = b"????"
        write(0x8100, game)
        write(0x8200, title)
        write(0x8300, ending)
        write(0x8400, help_data)
        write(0x8500, credits)
        write(0x8600, post)
        write(0x8700, b"\xEA\xEA")
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": bank,
            "game_over": {"address": "0x8100", "size": len(game), "crc32": shell_text.crc32(game)},
            "title_stream": {
                "address": "0x8200", "end_address": hex(0x8200 + len(title) - 1),
                "record_count": 2, "crc32": shell_text.crc32(title),
                "text_records": [
                    {"id": "prompt", "ppu_address": "0x21E7"},
                    {"id": "score", "ppu_address": "0x2248"},
                ],
            },
            "ending_nametable": {"address": "0x8300", "row_width": 8, "row_count": 4, "crc32": shell_text.crc32(ending)},
            "chapter_help_screens": {
                "address": "0x8400", "size": len(help_data), "screen_size": 8,
                "count": 2, "crc32": shell_text.crc32(help_data),
                "screens": [
                    {"id": "one", "address": "0x8400", "text_spans": [{"id": "one_name", "address": "0x8400", "size": 4}]},
                    {"id": "two", "address": "0x8408", "text_spans": [{"id": "two_name", "address": "0x8408", "size": 4}]},
                ],
            },
            "ending_credits": {"address": "0x8500", "end_address": "0x850F", "row_width": 8, "row_count": 2, "crc32": shell_text.crc32(credits)},
            "post_credit_data": {"address": "0x8600", "size": 4, "crc32": shell_text.crc32(post)},
            "signatures": [{"address": "0x8700", "bytes": "EA EA"}],
        }
        return bytes(prg), manifest

    def test_lossless_authoring_roundtrip(self) -> None:
        prg, manifest = self.fixture()
        document = shell_text.decode_authoring(prg, manifest)
        self.assertEqual(shell_text.apply_authoring(prg, document, manifest), prg)
        errors, report = shell_text.validate_authoring(prg, manifest, document)
        self.assertEqual(errors, [])
        self.assertEqual(report["editable_bytes"], 86)

    def test_allows_fixed_width_text_edits(self) -> None:
        prg, manifest = self.fixture()
        document = shell_text.decode_authoring(prg, manifest)
        changed = copy.deepcopy(document)
        changed["game_over"] = "LOSE OVER"
        changed["title_records"][0]["text"] = "PLAY"
        changed["chapter_help_screens"][0]["segments"][0]["text"] = "EDIT"
        changed["ending_credit_rows"][0] = "GAMMA   "
        rebuilt = shell_text.apply_authoring(prg, changed, manifest)
        self.assertNotEqual(rebuilt, prg)

    def test_rejects_changed_credit_width(self) -> None:
        prg, manifest = self.fixture()
        document = shell_text.decode_authoring(prg, manifest)
        document["ending_credit_rows"][0] = "SHORT"
        with self.assertRaisesRegex(ValueError, "row width"):
            shell_text.encode_authoring(document, manifest)

    def test_rejects_changed_help_span_width(self) -> None:
        prg, manifest = self.fixture()
        document = shell_text.decode_authoring(prg, manifest)
        document["chapter_help_screens"][0]["segments"][0]["text"] = "LONGER"
        with self.assertRaisesRegex(ValueError, "span size"):
            shell_text.encode_authoring(document, manifest)

    def test_rejects_signature_change(self) -> None:
        prg, manifest = self.fixture()
        changed = bytearray(prg)
        changed[3 * shell_text.BANK_SIZE + 0x700] ^= 1
        errors, _report = shell_text.validate_manifest_data(bytes(changed), manifest)
        self.assertTrue(any("signature differs" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
