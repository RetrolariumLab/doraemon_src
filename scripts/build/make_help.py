#!/usr/bin/env python3
"""Render the curated public Make interface."""

from __future__ import annotations


TARGET_GROUPS = (
    (
        "Getting started",
        (
            ("help", "show this command guide"),
            ("inspect", "inspect the original Japanese reference ROM"),
            ("split", "extract ignored private PRG and CHR assets"),
            ("build", "assemble the default reconstruction"),
            ("verify", "prove complete byte identity"),
            ("bank-info", "report the four GNROM banks and vectors"),
            ("clean", "remove generated build output"),
        ),
    ),
    (
        "Quality",
        (
            ("format", "normalize authored source and metadata"),
            ("lint", "check style, layout, and repository policy"),
            ("scaffold-check", "run the ROM-less repository gate"),
            ("quality-check", "run lint and the complete unit suite"),
            ("public-command-smoke", "run lint in a disposable tracked-only clone"),
            ("check", "run the complete static reconstruction gate"),
        ),
    ),
    (
        "Revision profiles",
        (
            ("audit-revisions", "classify every official revision difference"),
            ("build-revision", "assemble one selected revision"),
            ("verify-revision", "prove one selected revision"),
            ("verify-revisions", "prove both official Japanese revisions"),
            ("runtime-revision-matrix", "trace all scenarios on both revisions"),
        ),
    ),
    (
        "Retrolarium",
        (
            ("studio-check", "open and rebuild every doraemon.rlj revision with the kit"),
            ("source-3-audit", "studio-check plus the Source 3.0 manifest against the kit"),
            ("source-3-check", "the Source 2.0 gate, then source-3-audit"),
        ),
    ),
    (
        "Reconstruction workflow",
        (
            ("ghidra-status", "inspect the pinned Ghidra installation"),
            ("ghidra-analyze", "regenerate four-bank instruction facts"),
            ("disassemble", "regenerate address-ordered ca65 source"),
            ("disassembly-check", "verify deterministic source regeneration"),
            ("debug-symbols", "export bank-aware debugger symbols"),
            ("validate-runtime-debug-symbols", "validate symbols in live traces"),
            ("runtime-architecture", "capture reset, mapper, and chapter evidence"),
        ),
    ),
    (
        "Source Reconstruction release",
        (
            ("source-1-check", "rerun the accepted Source 1.0 contract"),
            ("source-2-audit", "reconcile the 2.0 manifest and evidence"),
            ("source-2-check", "run the complete two-profile development gate"),
            ("source-2-pre-tag-check", "add clean-tree and tag-readiness checks"),
            ("source-2-tag-check", "validate the checked-out annotated tag"),
        ),
    ),
)


def documented_targets() -> set[str]:
    return {target for _heading, entries in TARGET_GROUPS for target, _ in entries}


def render_help() -> str:
    lines = ["Doraemon source reconstruction", ""]
    for heading, entries in TARGET_GROUPS:
        lines.append(f"{heading}:")
        lines.extend(
            f"  {target:<31} {description}" for target, description in entries
        )
        lines.append("")
    lines.extend(
        (
            "Common selectors:",
            "  PROFILE=original|rev_a",
            "  STUDIOS=all|level,graphics,objects,text,sound",
            "  CONTENT_WORKSPACE=content/workspace",
            "",
            "Run 'python scripts/run.py --list' for the lower-level tool catalog.",
        )
    )
    return "\n".join(lines)


def main() -> int:
    print(render_help())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
