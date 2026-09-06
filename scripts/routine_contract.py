#!/usr/bin/env python3
"""CLI for the shared bank-local routine/caller/RAM contract validator."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import shell_runtime


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prg", required=True, type=Path)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--symbols", required=True, type=Path)
    parser.add_argument("--facts", required=True, type=Path)
    args = parser.parse_args()
    try:
        manifest = shell_runtime.load_json(args.manifest, "routine-contract")
        errors, report = shell_runtime.validate(
            args.prg.read_bytes(),
            manifest,
            shell_runtime.load_json(args.symbols, "symbol"),
            shell_runtime.load_facts(args.facts),
        )
        if errors:
            for error in errors:
                print(f"[ERROR] {error}")
            return 1
        print(
            f"[OK] Bank {manifest['bank']} routine contract: "
            f"{report['routine_count']} routines / {report['routine_bytes']} "
            f"bytes, {report['direct_callers']} direct callers, "
            f"{report['memory_symbols']} RAM symbols / "
            f"{report['memory_bytes']} bytes"
        )
        return 0
    except (OSError, KeyError, TypeError, ValueError, json.JSONDecodeError) as exc:
        print(f"[ERROR] routine contract validation failed: {exc}")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
