# Code quality

The quality gate is intentionally dependency-free apart from the pinned local
assembler and optional static-analysis toolchain.

- `scripts/validation/asm_style.py` enforces the shared ca65 source style.
- `scripts/validation/format_project.py` normalizes text and JSON deterministically.
- `scripts/build/project.py lint` enforces required files, mapper identity, four-bank
  source markers, and the no-ROM/no-PRG-binary policy.
- unit tests exercise iNES parsing, typed bank ranges, disassembly generation,
  ROM diagnostics, and CadEditor-backed data validation.
- the release gate regenerates analysis, assembles, and compares all bytes.

All four banks are generated address-order include maps over semantic modules.
Every extracted boundary is recorded in `config/reconstruction/source_modules.json`, must fall
between instructions, and must retain byte-identical output. The source audit
limits each declared module to 700 lines.

## Python responsibility boundaries

The Source 2.0 Python layout follows the project's file-category review
thresholds. In particular:

- `world2_level_model.py` owns compressed-screen editing, token aliases, undo,
  and workspace persistence in 595 lines;
- `world2_route_model.py` independently derives the five tutorial route views
  from native stage and branch bytecode in 366 lines;
- `world3_metasprites.py` owns validation and lossless encoding in 685 lines,
  while `world3_metasprite_rendering.py` contains the optional 164-line raster
  adapter.

The GUI imports these headless models and canonical codecs. It does not define
a second serializer or relax capacity checks.
