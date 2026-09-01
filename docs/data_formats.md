# Data formats

CadEditor offsets are offsets in the complete `.nes` file, including its
16-byte iNES header. CPU addresses in this repository therefore subtract the
header and the physical 32 KiB bank base.

| Data | File offset | Bank/CPU | Size |
| --- | ---: | --- | ---: |
| world 1 attributes | `$29FF` | 0:`$A9EF` | 256 |
| world 1 small blocks | `$2AFF` | 0:`$AAEF` | 1,024 |
| world 1 big blocks | `$2EFF` | 0:`$AEEF` | 1,024 |
| city map | `$32FF` | 0:`$B2EF` | 64x64 |
| underground map | `$42FF` | 0:`$C2EF` | 64x25 |
| world 2 attributes | `$B9DE` | 1:`$B9CE` | 256 declared |
| world 2 small blocks | `$BAAF` | 1:`$BA9F` | 256x4 declared |
| world 2 CadEditor screen region | `$BDFC` | 1:`$BDEC` | 60x16x15 editor view |
| world 2 stage sequence | `$BDEF` | 1:`$BDDF` | 255 bytes |
| world 2 screen pointers | `$BEEE` | 1:`$BEDE` | 119 standard entries |
| world 2 compressed streams | `$BFDC` | 1:`$BFCC` | through `$FFFA` |
| world 3 attributes | `$15E02` | 2:`$DDF2` | 256 |
| world 3 small blocks | `$15F02` | 2:`$DEF2` | 1,024 |
| world 3 big blocks | `$16302` | 2:`$E2F2` | 1,024 |
| underwater map | `$16702` | 2:`$E6F2` | 64x64 |

Small blocks are linear 2x2 CHR-tile groups. Large blocks are linear 2x2 groups
of small-block indexes. Attribute bytes retain collision/type bits; CadEditor
masks only the low two palette bits while editing.

The world 2 CadEditor declarations are a useful editable projection, not the
runtime storage format. The claimed 256x4 small-block table and 60 fixed-size
screens overlap each other. Runtime code instead reads a 255-byte stage
sequence at `$BDDF`, indexes little-endian stream pointers at `$BEDE`, and
expands variable-length screen tokens beginning at `$BFCC`. The first 119
pointer slots address 116 unique ROM streams. Selectors `$7B` and `$7F` are
special dynamic buffers at `$0515` and `$00FC` rather than ROM screens.

Each standard stream decodes sixteen rows of at least fifteen cells. Bytes
below `$D0` are literal cells, `$D0-$EE` emit an empty cell and spawn an enemy,
`$EF` terminates a row, and `$F1-$FF` repeat the following literal by the low
nibble plus one. The extra copy comes from falling through the counted loop to
the shared literal store. `$F0` is unused. Repeats may deliberately overshoot
the fifteen-cell threshold; the largest decoded row is 22 cells. The final stream
reads through `$FFFA`, reusing the low byte of the NMI vector as data.

`config/prg_data_ranges.txt` retains the CadEditor ranges as provenance for
the editor-compatible view. `config/world2_streaming.json` and
`scripts/world2_streaming.py` are authoritative for the runtime representation.

`scripts/map_data.py` validates all CadEditor-declared regions against
independent CRC32 values and reports their overlap explicitly.
