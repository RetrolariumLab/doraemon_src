from __future__ import annotations

import importlib.util
import hashlib
import json
from pathlib import Path
import tempfile
import unittest


ROOT = Path(__file__).resolve().parent.parent
SPEC = importlib.util.spec_from_file_location(
    "toolchain", ROOT / "scripts" / "toolchain.py"
)
assert SPEC is not None and SPEC.loader is not None
TOOLCHAIN = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(TOOLCHAIN)


class ToolchainTests(unittest.TestCase):
    def test_verifies_a_pinned_binary(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            path = root / "tool.exe"
            payload = b"pinned tool"
            path.write_bytes(payload)
            component = {
                "id": "fixture",
                "path": "tool.exe",
                "size": len(payload),
                "binary_sha256": hashlib.sha256(payload).hexdigest(),
            }
            self.assertEqual(TOOLCHAIN.verify_component(root, component), path)

    def test_rejects_a_changed_binary(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            path = root / "tool.exe"
            path.write_bytes(b"changed")
            component = {
                "id": "fixture",
                "path": "tool.exe",
                "size": len(b"changed"),
                "binary_sha256": "0" * 64,
            }
            with self.assertRaisesRegex(TOOLCHAIN.ToolchainError, "SHA-256"):
                TOOLCHAIN.verify_component(root, component)

    def test_rejects_duplicate_component_ids(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "toolchain.json"
            path.write_text(
                json.dumps(
                    {
                        "schema_version": 1,
                        "components": [{"id": "same"}, {"id": "same"}],
                    }
                ),
                encoding="utf-8",
            )
            with self.assertRaisesRegex(TOOLCHAIN.ToolchainError, "not unique"):
                TOOLCHAIN.load_manifest(path)


if __name__ == "__main__":
    unittest.main()
