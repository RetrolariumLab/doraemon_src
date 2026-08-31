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
  -> clear bank-qualified typed data ranges
  -> export instruction facts
  -> propagate byte-identical common prefix facts through $8270
  -> emit src/banks/bank_0.asm ... bank_3.asm
  -> assemble and compare every byte
```

Temporary NROM files exist only under ignored `build/ghidra/`. They do not
change the cartridge model used by the source or linker; they provide an
unambiguous static-analysis entry point for each GNROM bank.

Facts include address, bytes, mnemonic, operands, control flows, symbols, and
function entries. The generator validates every fact against the corresponding
bank bytes. Unclassified spans are emitted as `.byte`, and every internal direct
control-flow target receives a bank-qualified label.

Use `make disassemble` to update the canonical listing and
`make disassembly-check` to reproduce it without accepting changes.
