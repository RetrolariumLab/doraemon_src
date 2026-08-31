from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import object_pools


class ObjectPoolTests(unittest.TestCase):
    def fixture(self) -> tuple[dict[str, object], dict[str, object]]:
        manifest = {
            "schema_version": 1,
            "pools": [
                {
                    "id": "entities",
                    "bank": 2,
                    "capacity": 2,
                    "key_field": "EntityState",
                    "fields": [
                        {"symbol": "EntityState", "role": "active state"},
                        {"symbol": "EntityX", "role": "X coordinate"},
                    ],
                    "groups": [
                        {
                            "start": 0,
                            "count": 2,
                            "clear": "ClearEntities",
                            "render": "RenderEntities",
                        }
                    ],
                    "lifecycle": ["UpdateEntities"],
                }
            ],
        }
        symbols = {
            "schema_version": 1,
            "symbols": [
                {"bank": 2, "address": "0x9000", "name": "ClearEntities"},
                {"bank": 2, "address": "0x9010", "name": "RenderEntities"},
                {"bank": 2, "address": "0x9020", "name": "UpdateEntities"},
            ],
            "memory_symbols": [
                {
                    "address": "0x0600",
                    "name": "EntityState",
                    "size": 2,
                    "banks": [2],
                },
                {
                    "address": "0x0608",
                    "name": "EntityX",
                    "size": 2,
                    "banks": [2],
                },
            ],
        }
        return manifest, symbols

    def test_accepts_matching_pool_and_symbol_registry(self) -> None:
        manifest, symbols = self.fixture()
        errors, report = object_pools.validate(manifest, symbols)
        self.assertEqual(errors, [])
        self.assertEqual(report["pool_count"], 1)
        self.assertEqual(report["slot_count"], 2)
        self.assertEqual(report["lifecycle_count"], 3)

    def test_rejects_field_size_that_differs_from_capacity(self) -> None:
        manifest, symbols = self.fixture()
        symbols["memory_symbols"][0]["size"] = 1
        errors, _report = object_pools.validate(manifest, symbols)
        self.assertTrue(any("differs from capacity" in error for error in errors))

    def test_rejects_overlapping_fields(self) -> None:
        manifest, symbols = self.fixture()
        symbols["memory_symbols"][1]["address"] = "0x0601"
        errors, _report = object_pools.validate(manifest, symbols)
        self.assertTrue(any("overlaps" in error for error in errors))

    def test_rejects_lifecycle_routine_from_another_bank(self) -> None:
        manifest, symbols = self.fixture()
        changed = copy.deepcopy(symbols)
        changed["symbols"][2]["bank"] = 1
        errors, _report = object_pools.validate(manifest, changed)
        self.assertTrue(any("another bank" in error for error in errors))

    def test_accepts_layout_with_explicit_unclassified_base(self) -> None:
        manifest, symbols = self.fixture()
        manifest["pools"][0]["layout"] = {
            "start": "0x0600",
            "field_stride": 8,
            "field_count": 3,
            "unclassified_bases": ["0x0610"],
        }
        errors, report = object_pools.validate(manifest, symbols)
        self.assertEqual(errors, [])
        self.assertEqual(report["layout_count"], 1)
        self.assertEqual(report["unclassified_field_count"], 1)

    def test_rejects_unaccounted_layout_base(self) -> None:
        manifest, symbols = self.fixture()
        manifest["pools"][0]["layout"] = {
            "start": "0x0600",
            "field_stride": 8,
            "field_count": 3,
            "unclassified_bases": [],
        }
        errors, _report = object_pools.validate(manifest, symbols)
        self.assertTrue(any("misses field bases: $0610" in error for error in errors))

    def test_rejects_classified_base_marked_unclassified(self) -> None:
        manifest, symbols = self.fixture()
        manifest["pools"][0]["layout"] = {
            "start": "0x0600",
            "field_stride": 8,
            "field_count": 2,
            "unclassified_bases": ["0x0608"],
        }
        errors, _report = object_pools.validate(manifest, symbols)
        self.assertTrue(any("also unclassified at $0608" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
