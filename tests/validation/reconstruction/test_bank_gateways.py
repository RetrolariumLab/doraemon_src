from __future__ import annotations

from collections import Counter
import importlib.util
from pathlib import Path
import tempfile
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
SPEC = importlib.util.spec_from_file_location(
    "bank_gateways", ROOT / "scripts" / "validation" / "reconstruction" / "bank_gateways.py"
)
assert SPEC is not None and SPEC.loader is not None
GATEWAYS = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(GATEWAYS)


class GatewayTests(unittest.TestCase):
    def test_collects_only_declared_gateway_calls(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "bank_2.asm").write_text(
                "    JSR Bank2_Func_8053\n    JMP Bank2_Func_9000\n",
                encoding="utf-8",
            )
            self.assertEqual(
                GATEWAYS.source_calls(root, {0x8053}),
                Counter({(2, 0x8053, "JSR"): 1}),
            )

    def test_collects_calls_from_semantic_subdirectories(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "audio").mkdir()
            (root / "audio" / "engine.asm").write_text(
                "    JSR Bank3_Func_8053\n", encoding="utf-8"
            )
            self.assertEqual(
                GATEWAYS.source_calls(root, {0x8053}),
                Counter({(3, 0x8053, "JSR"): 1}),
            )

    def test_collects_semantically_named_gateway_call(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "engine.asm").write_text(
                "    JMP Bank2_EnterShell\n", encoding="utf-8"
            )
            self.assertEqual(
                GATEWAYS.source_calls(root, {0x8048}, {"EnterShell": 0x8048}),
                Counter({(2, 0x8048, "JMP"): 1}),
            )

    def test_rejects_mismatched_bank_qualified_call(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "bank_0.asm").write_text(
                "    JMP Bank1_Func_8048\n", encoding="utf-8"
            )
            with self.assertRaisesRegex(ValueError, "differs from source file"):
                GATEWAYS.source_calls(root, {0x8048})

    def test_call_restore_adds_return_edge(self) -> None:
        calls = Counter({(0, 0x8053, "JSR"): 1})
        gateways = {
            0x8053: {"kind": "switch-call-restore", "target_prg": 3}
        }
        self.assertEqual(GATEWAYS.possible_edges(calls, gateways), ["0->3", "3->0"])


if __name__ == "__main__":
    unittest.main()
