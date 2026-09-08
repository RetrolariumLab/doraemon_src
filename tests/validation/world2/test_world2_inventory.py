from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


from tests import PROJECT_ROOT


ROOT = PROJECT_ROOT
sys.path.insert(0, str(ROOT / "scripts"))

from scripts.validation.world2 import world2_inventory


class World2InventoryTests(unittest.TestCase):
    def fixture(self) -> tuple[bytes, dict[str, object], dict[str, object]]:
        prg = bytearray(4 * world2_inventory.BANK_SIZE)
        bank_offset = world2_inventory.BANK_SIZE
        screens = bytes((1, 2, 3, 4, 5, 6, 7))
        prg[bank_offset + 0x1000:bank_offset + 0x1007] = screens
        signature = bytes((0xB5, 0x7C, 0xC9, 0x03))
        prg[bank_offset + 0x1100:bank_offset + 0x1104] = signature
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": 1,
            "capacity": 7,
            "pool_id": "world2_inventory",
            "fields": {
                "state": "World2InventoryState",
                "x": "World2InventoryX",
                "y": "World2InventoryY",
            },
            "states": [
                {"value": value, "name": name}
                for value, name in world2_inventory.EXPECTED_STATES.items()
            ],
            "eligible_screen_table": {
                "address": "0x9000",
                "count": 7,
                "crc32": world2_inventory.crc32(screens),
            },
            "signatures": [
                {"address": "0x9100", "bytes": signature.hex(" ")}
            ],
        }
        pools: dict[str, object] = {
            "pools": [
                {
                    "id": "world2_inventory",
                    "bank": 1,
                    "capacity": 7,
                    "fields": [
                        {"symbol": "World2InventoryState"},
                        {"symbol": "World2InventoryX"},
                        {"symbol": "World2InventoryY"},
                    ],
                    "layout": {
                        "start": "0x007C",
                        "field_stride": 7,
                        "field_count": 3,
                    },
                }
            ]
        }
        return bytes(prg), manifest, pools

    def test_accepts_inventory_contract(self) -> None:
        prg, manifest, pools = self.fixture()
        errors, report = world2_inventory.validate_manifest(prg, manifest, pools)
        self.assertEqual(errors, [])
        self.assertEqual(report["state_count"], 5)

    def test_lossless_authoring_roundtrip(self) -> None:
        prg, manifest, pools = self.fixture()
        decoded = world2_inventory.decode_authoring(prg, manifest, pools)
        rebuilt = world2_inventory.apply_authoring(prg, decoded, manifest)
        self.assertEqual(rebuilt, prg)
        self.assertEqual(decoded["covered_byte_count"], 7)

    def test_allows_screen_edit(self) -> None:
        prg, manifest, pools = self.fixture()
        decoded = world2_inventory.decode_authoring(prg, manifest, pools)
        changed = copy.deepcopy(decoded)
        changed["eligible_screens"][0]["screen_id"] = "0x08"
        rebuilt = world2_inventory.apply_authoring(prg, changed, manifest)
        self.assertEqual(rebuilt[world2_inventory.BANK_SIZE + 0x1000], 8)

    def test_rejects_duplicate_screen(self) -> None:
        prg, manifest, pools = self.fixture()
        decoded = world2_inventory.decode_authoring(prg, manifest, pools)
        decoded["eligible_screens"][1]["screen_id"] = "0x01"
        with self.assertRaisesRegex(ValueError, "screens are invalid"):
            world2_inventory.encode_authoring(decoded, manifest)

    def test_rejects_changed_signature(self) -> None:
        prg, manifest, pools = self.fixture()
        changed = bytearray(prg)
        changed[world2_inventory.BANK_SIZE + 0x1100] ^= 1
        errors, _report = world2_inventory.validate_manifest(
            bytes(changed), manifest, pools
        )
        self.assertTrue(any("signature differs" in error for error in errors))

    def test_rejects_wrong_pool_layout(self) -> None:
        prg, manifest, pools = self.fixture()
        pools["pools"][0]["layout"]["field_stride"] = 3
        errors, _report = world2_inventory.validate_manifest(prg, manifest, pools)
        self.assertTrue(any("pool layout differs" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
