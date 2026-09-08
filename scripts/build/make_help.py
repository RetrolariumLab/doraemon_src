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
        "Content authoring",
        (
            ("level-studio", "open the three-world level editor"),
            ("graphics-studio", "open the CHR and metasprite editor"),
            ("object-studio", "open the object-data editor"),
            ("text-studio", "open the fixed-capacity text editor"),
            ("sound-studio", "open the music editor and preview player"),
            ("content-init", "initialize every profile workspace"),
            ("content-check", "validate every profile workspace"),
            ("content-rom", "compose edited content into one ROM"),
            ("content-roundtrip", "prove zero-edit identity for both profiles"),
            ("check-studios", "smoke-test all Studios and profiles headlessly"),
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
