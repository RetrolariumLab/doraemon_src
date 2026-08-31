# Contributing

Keep every change evidence-backed and preserve the matching build.

1. Do not commit ROMs, extracted PRG/CHR files, emulator state, or build output.
2. Run `make quality-check` for documentation or tooling changes.
3. Run `make check` for source, symbol, or data-boundary changes.
4. Use bank-qualified names whenever the same CPU address can identify different
   bytes in another GNROM bank.
5. Record the evidence for semantic labels in `config/symbols.json` and update
   the relevant documentation.
6. Keep uncertain bytes as data. Do not promote them to code only because a
   linear sweep happens to decode them.
7. Preserve address order inside each `src/banks/bank_N.asm` file.

Generated bank sources are changed through `make disassemble`; change the
symbol registry, typed ranges, or analysis pipeline instead of hand-editing
machine-generated formatting.
