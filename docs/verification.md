# Verification

The build has three boundaries:

1. tracked ca65 header and four PRG source files;
2. ignored `assets/generated/chr/doraemon.chr` extracted from a legally obtained
   exact reference;
3. `build/native/doraemon.nes`, assembled by ca65/ld65.

The PRG source contains no `.incbin`. CHR remains private because it is not yet
represented by editable source structures.

`make verify` validates both complete images against `assets/manifest.json`,
then independently compares header, PRG, CHR, payload, full file, and extracted
assets. PRG mismatch diagnostics include both physical bank offset and mapped
CPU address.

The expected identity is:

| Region | Size | CRC32 |
| --- | ---: | --- |
| header | 16 | `06D1CEDD` |
| PRG | 131,072 | `B00ABE1C` |
| CHR | 32,768 | `761F994E` |
| payload | 163,840 | `BDE3AE9B` |
| complete iNES | 163,856 | `A9EB0DE9` |

`make check` also reproduces Ghidra facts, checks source formatting and policy,
runs unit tests, validates map regions, and rebuilds the matching image.

`make validate-source-classification` reads the fresh ca65 listing and proves
byte-level ownership of all 131,072 PRG bytes. In particular it prevents raw
`.byte` regions from being treated as semantically complete merely because
they assemble: each is tied to a typed contract, known encoded code, verified
padding, or an exact entry in the unknowns registry.
