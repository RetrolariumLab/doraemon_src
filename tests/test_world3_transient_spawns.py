from __future__ import annotations

import copy
from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import world3_transient_spawns


class World3TransientSpawnTests(unittest.TestCase):
    def fixture(self) -> tuple[bytes, dict[str, object], dict[str, object]]:
        room_count = 64
        channel_count = 4
        columns = {
            "type": [
                bytes((room + channel) % 16 for room in range(room_count))
                for channel in range(channel_count)
            ],
            "count": [
                bytes((room + channel) % 5 for room in range(room_count))
                for channel in range(channel_count)
            ],
            "delay": [
                bytes((room + channel * 3) % 8 for room in range(room_count))
                for channel in range(channel_count)
            ],
        }
        payload = b"".join(
            columns[field][channel]
            for field in world3_transient_spawns.FIELD_NAMES
            for channel in range(channel_count)
        )
        bank = 2
        start = 0x9000
        prg = bytearray(4 * world3_transient_spawns.BANK_SIZE)
        base = bank * world3_transient_spawns.BANK_SIZE + start - 0x8000
        prg[base:base + len(payload)] = payload
        signature = bytes((0xA5, 0xAB, 0xD0, 0x54))
        prg[bank * 0x8000 + 0x1500:bank * 0x8000 + 0x1504] = signature
        tables: dict[str, list[dict[str, object]]] = {}
        offset = 0
        for field in world3_transient_spawns.FIELD_NAMES:
            tables[field] = []
            for channel in range(channel_count):
                data = columns[field][channel]
                tables[field].append({
                    "channel": channel,
                    "address": hex(start + offset),
                    "crc32": world3_transient_spawns.crc32(data),
                    "expected_values": sorted(set(data)),
                })
                offset += room_count
        transient_tables = {
            (field, channel): columns[field][channel]
            for field in world3_transient_spawns.FIELD_NAMES
            for channel in range(channel_count)
        }
        metrics = world3_transient_spawns.metrics(
            transient_tables, room_count, channel_count
        )
        manifest: dict[str, object] = {
            "schema_version": 1,
            "bank": bank,
            "room_count": room_count,
            "channel_count": channel_count,
            "covered_range": {
                "start": hex(start),
                "end": hex(start + len(payload) - 1),
                "byte_count": len(payload),
                "crc32": world3_transient_spawns.crc32(payload),
            },
            "tables": tables,
            "initializer_dispatch": {
                "name": "fixture_initializers",
                "address": "0x9200",
                "slot_count": 16,
            },
            "timing": {
                "nonzero_delay_frame_divisor": 4,
                "zero_delay_attempts_every_frame": True,
                "phase_counters_preserved_on_room_reload": True,
            },
            "expected_metrics": metrics,
            "signatures": [{"address": "0x9500", "bytes": signature.hex(" ")}],
        }
        dispatch: dict[str, object] = {
            "tables": [{
                "name": "fixture_initializers",
                "bank": bank,
                "address": "0x9200",
                "slot_count": 16,
                "targets": ["0x9300"] * 16,
            }]
        }
        return bytes(prg), manifest, dispatch

    def test_accepts_transient_spawn_contract(self) -> None:
        prg, manifest, dispatch = self.fixture()
        errors, report = world3_transient_spawns.validate_manifest(
            prg, manifest, dispatch
        )
        self.assertEqual(errors, [])
        self.assertEqual(report["active_room_channels"], 205)

    def test_lossless_authoring_roundtrip(self) -> None:
        prg, manifest, dispatch = self.fixture()
        decoded = world3_transient_spawns.decode_authoring(
            prg, manifest, dispatch
        )
        rebuilt = world3_transient_spawns.apply_authoring(prg, decoded, manifest)
        self.assertEqual(rebuilt, prg)
        self.assertEqual(decoded["covered_byte_count"], 768)

    def test_allows_schedule_edit(self) -> None:
        prg, manifest, dispatch = self.fixture()
        decoded = world3_transient_spawns.decode_authoring(
            prg, manifest, dispatch
        )
        changed = copy.deepcopy(decoded)
        changed["rooms"][0]["channels"][0]["count"] = 9
        rebuilt = world3_transient_spawns.apply_authoring(prg, changed, manifest)
        base = 2 * world3_transient_spawns.BANK_SIZE + 0x1000
        self.assertEqual(rebuilt[base + 256], 9)

    def test_rejects_type_outside_initializer_dispatch(self) -> None:
        prg, manifest, dispatch = self.fixture()
        decoded = world3_transient_spawns.decode_authoring(
            prg, manifest, dispatch
        )
        decoded["rooms"][0]["channels"][0]["type"] = "0x10"
        with self.assertRaisesRegex(ValueError, "exceeds initializer"):
            world3_transient_spawns.encode_authoring(decoded, manifest)

    def test_rejects_changed_signature(self) -> None:
        prg, manifest, dispatch = self.fixture()
        changed = bytearray(prg)
        changed[2 * world3_transient_spawns.BANK_SIZE + 0x1500] ^= 1
        errors, _report = world3_transient_spawns.validate_manifest(
            bytes(changed), manifest, dispatch
        )
        self.assertTrue(any("signature differs" in error for error in errors))

    def test_rejects_wrong_dispatch_capacity(self) -> None:
        prg, manifest, dispatch = self.fixture()
        dispatch["tables"][0]["slot_count"] = 15
        errors, _report = world3_transient_spawns.validate_manifest(
            prg, manifest, dispatch
        )
        self.assertTrue(any("slot_count differs" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
