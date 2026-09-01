# Disassembly pipeline

GhidraNes correctly imports mapper 66 as four overlay blocks, but the native
loader seeds interrupt entry points only in the last PRG overlay. The canonical
pipeline avoids making the other banks depend on that loader detail:

```text
exact mapper-66 reference
  -> validate manifest
  -> split four 32 KiB PRG banks
  -> wrap each bank in a temporary fixed 32 KiB NROM image
  -> run pinned Ghidra/GhidraNes independently
  -> seed recursive analysis at evidence-backed code entries
  -> clear bank-qualified typed data ranges after analysis
  -> export instruction facts
  -> propagate byte-identical common prefix facts through $8270
  -> apply config/source_modules.json address ranges
  -> emit bank include maps and semantic source modules
  -> assemble and compare every byte
```

Temporary NROM files exist only under ignored `build/ghidra/`. They do not
change the cartridge model used by the source or linker; they provide an
unambiguous static-analysis entry point for each GNROM bank.

Facts include address, bytes, mnemonic, operands, control flows, symbols, and
function entries. The generator validates every fact against the corresponding
bank bytes. Unclassified spans are emitted as `.byte`, and every internal direct
control-flow target receives a bank-qualified label.

`config/prg_code_entries.txt` records entry points that the NROM loader cannot
discover by ordinary control flow. In bank 2, the embedded build string ends at
`$82AC`; the dispatch table proves executable entries at `$82AD` and `$82F6`,
and the World 3 runtime scenario directly executes `$82F6`.
The tracked seeds make that code/data boundary reproducible in a fresh analysis.
The same registry seeds bank 3's four secondary dispatch jumps and the otherwise
unreachable `$8A17` game-over and `$8A88` ending services.

Bank 0 also needs explicit seeds for World 1's indirect entity update graph. Its
16 target-minus-one entries begin at `$88FB`; slot zero overlaps the preceding
`JMP` operand, while active slots `$01-$0F` lead into `$DBDA-$E315`. Registering
the thirteen unique active targets lets recursive analysis recover their shared
helpers at `$9065-$95CA` without treating the behavior engine as opaque data.

Use `make disassemble` to update the canonical listing and
`make disassembly-check` to reproduce it without accepting changes.
