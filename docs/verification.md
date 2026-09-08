# Verification

The build has three boundaries:

1. tracked ca65 header and four PRG source files;
2. ignored `assets/generated/chr/doraemon.chr` extracted from a legally obtained
   exact reference;
3. `build/native/doraemon.nes`, assembled by ca65/ld65.

The PRG source contains no `.incbin`. The raw CHR remains a private build input,
but Source Reconstruction 2.0 decodes all four banks into an ignored editable
workspace and composes fixed-size tile changes back into either profile.

`make verify` validates the original reference and source-built image against
`assets/manifest.json`, then independently compares header, PRG, CHR, payload,
full file, and extracted assets. `make verify-revisions` performs the complete
container identity check for both official profiles. PRG mismatch diagnostics
include both physical bank offset and mapped CPU address.

The expected identity is:

| Region | Size | CRC32 | SHA-256 |
| --- | ---: | --- | --- |
| header | 16 | `06D1CEDD` | `de078b947cbb5789d56543b4fe8e897076f2802515186feeddc2849b45da989e` |
| PRG | 131,072 | `B00ABE1C` | `f648405257878becc0f362e23cb68cf2689aa42a8c41e2f6d5dbe98356fb5f45` |
| CHR | 32,768 | `761F994E` | `297cc609a3cee675a616f61c1f2d5a68f05decd0b2c10e71865d7befe6187939` |
| payload | 163,840 | `BDE3AE9B` | `de15604ba1f819b12dd35dec557a5f20c9821210c4bc853c29c763466d0ede94` |
| complete iNES | 163,856 | `A9EB0DE9` | `6ed579c9c98a1f2db52fd3d2488a491953073e8ace1e3c1dc5884669cecca274` |

`make check` also reproduces Ghidra facts, checks source formatting and policy,
runs unit tests, validates map regions, and rebuilds the matching image.

`make validate-source-classification` reads the fresh ca65 listing and proves
byte-level ownership of all 131,072 PRG bytes. In particular it prevents raw
`.byte` regions from being treated as semantically complete merely because
they assemble: each is tied to a typed contract, known encoded code, verified
padding, or an exact entry in the unknowns registry.
