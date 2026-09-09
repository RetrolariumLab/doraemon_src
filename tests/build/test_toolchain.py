from __future__ import annotations

import importlib.util
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
SPEC = importlib.util.spec_from_file_location(
    "toolchain", ROOT / "scripts" / "build" / "toolchain.py"
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

    def test_make_rejects_unpinned_build_overrides_before_assembly(self) -> None:
        make = shutil.which("make")
        if make is None:
            self.skipTest("make executable not found")
        tracked = subprocess.run(
            ["git", "ls-files", "-z"],
            cwd=ROOT,
            check=True,
            capture_output=True,
        ).stdout.decode("utf-8").split("\0")
        with tempfile.TemporaryDirectory() as directory:
            checkout = Path(directory) / "repository"
            for relative in filter(None, tracked):
                source = ROOT / relative
                destination = checkout / relative
                destination.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(source, destination)
            chr_asset = checkout / "assets/generated/chr/doraemon.chr"
            chr_asset.parent.mkdir(parents=True, exist_ok=True)
            chr_asset.write_bytes(b"")
            for component in ("CA65", "LD65"):
                with self.subTest(component=component):
                    missing = checkout / f"unverified-{component.lower()}.exe"
                    result = subprocess.run(
                        [make, "build", f"{component}={missing}"],
                        cwd=checkout,
                        check=False,
                        capture_output=True,
                        text=True,
                        encoding="utf-8",
                        errors="replace",
                    )
                    output = result.stdout + result.stderr
                    self.assertNotEqual(result.returncode, 0, output)
                    self.assertIn(
                        f"{component.lower()} binary is missing: {missing}", output
                    )
                    self.assertNotIn("--debug-info", output)
                    self.assertFalse(
                        (checkout / "build/native/doraemon.o").exists()
                    )


if __name__ == "__main__":
    unittest.main()
