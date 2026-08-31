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

All four banks are generated address-order include maps over semantic modules.
Every extracted boundary is recorded in `config/source_modules.json`, must fall
between instructions, and must retain byte-identical output. The source audit
limits each declared module to 700 lines.
