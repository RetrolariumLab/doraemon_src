# Code quality

The quality gate is intentionally dependency-free apart from the pinned local
assembler and optional static-analysis toolchain.

- `scripts/asm_style.py` enforces the shared ca65 source style.
- `scripts/format_project.py` normalizes text and JSON deterministically.
- `scripts/project.py lint` enforces required files, mapper identity, four-bank
  source markers, and the no-ROM/no-PRG-binary policy.
- unit tests exercise iNES parsing, typed bank ranges, disassembly generation,
  ROM diagnostics, and CadEditor-backed data validation.
- the release gate regenerates analysis, assembles, and compares all bytes.

Generated bank files remain monolithic preservation listings at this stage.
Semantic module extraction begins only after procedure and data boundaries are
supported by static or runtime evidence.
