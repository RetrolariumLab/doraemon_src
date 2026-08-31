# Local reverse-engineering tools

`disassembly.lock.json` pins the Ghidra and GhidraNes versions used to generate
the canonical listing. Run `make ghidra-bootstrap` to install them under the
ignored `tools/ghidra/` directory.

The tracked Java scripts inspect NES memory blocks, clear evidence-backed data
ranges, and export instruction facts. Doraemon's four PRG banks are analyzed as
temporary fixed-bank inputs created under `build/ghidra/`; those inputs and the
downloaded toolchain are never committed.

Java 21 is required by the pinned Ghidra release.
