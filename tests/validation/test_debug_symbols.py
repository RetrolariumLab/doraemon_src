from __future__ import annotations

from pathlib import Path
import sys
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))

from scripts.validation import debug_symbols


class DebugSymbolTests(unittest.TestCase):
    def fixture(self) -> tuple[debug_symbols.DebugData, dict[str, object]]:
        text = "\n".join([
            "version\tmajor=2,minor=0",
            'file\tid=0,name="src/main.asm",size=1,mtime=0x0,mod=0',
            'seg\tid=7,name="PRG0",start=0x008000,size=0x8000,addrsize=absolute,type=ro,oname="out.nes",ooffs=16',
            'seg\tid=8,name="PRG1",start=0x008000,size=0x8000,addrsize=absolute,type=ro,oname="out.nes",ooffs=32784',
            'seg\tid=9,name="PRG2",start=0x008000,size=0x8000,addrsize=absolute,type=ro,oname="out.nes",ooffs=65552',
            'seg\tid=10,name="PRG3",start=0x008000,size=0x8000,addrsize=absolute,type=ro,oname="out.nes",ooffs=98320',
            'sym\tid=0,name="Semantic",addrsize=absolute,scope=0,val=0x8123,seg=7,type=lab',
            'sym\tid=1,name="Bank0_Label_8123",addrsize=absolute,scope=0,val=0x8123,seg=7,type=lab',
            'sym\tid=2,name="Upper",addrsize=absolute,scope=0,val=0xC100,seg=7,type=lab',
            'sym\tid=3,name="SharedRam",addrsize=zeropage,scope=0,val=0x20,type=equ',
            'sym\tid=4,name="OverlappingDataAlias",addrsize=absolute,scope=0,val=0xC123,seg=7,type=equ',
        ])
        registry: dict[str, object] = {
            "schema_version": 1,
            "symbols": [
                {"bank": 0, "address": "0x8123", "name": "Semantic"},
                {"bank": 0, "address": "0xC100", "name": "Upper"},
            ],
            "memory_symbols": [
                {"address": "0x0020", "name": "SharedRam", "size": 2, "evidence": "fixture"}
            ],
        }
        return debug_symbols.parse_debug_text(text), registry

    def test_parses_segments_and_symbols(self) -> None:
        debug, _registry = self.fixture()
        self.assertEqual(debug_symbols.prg_segments(debug)[0].output_offset, 16)
        self.assertEqual(debug_symbols.symbol_index(debug)["SharedRam"].value, 0x20)

    def test_fceux_mapping_uses_16k_physical_banks(self) -> None:
        debug, registry = self.fixture()
        labels = debug_symbols.fceux_prg_labels(debug, registry)
        self.assertEqual(labels[0], [(0x8123, "Semantic")])
        self.assertEqual(
            labels[1], [(0xC100, "Upper"), (0xC123, "OverlappingDataAlias")]
        )

    def test_fceux_ram_arrays_use_nl_size_syntax(self) -> None:
        _debug, registry = self.fixture()
        text = debug_symbols.fceux_ram_text(
            debug_symbols.shared_ram_labels(registry)
        )
        self.assertEqual(text, "$0020/2#SharedRam#fixture\n")

    def test_rejects_non_v2_debug_data(self) -> None:
        with self.assertRaisesRegex(ValueError, "version 2"):
            debug_symbols.parse_debug_text("version\tmajor=1,minor=0")

    def test_stale_debugger_watch_is_rejected(self) -> None:
        _debug, registry = self.fixture()
        errors = debug_symbols.validate_debugger_configs(
            registry,
            {"breakpoints": []},
            {"watches": [{"address": "0x0021", "size": 2, "name": "SharedRam"}]},
        )
        self.assertTrue(any("stale" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
