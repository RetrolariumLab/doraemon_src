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
| world 2 CadEditor attributes | `$B9DE` | 1:`$B9CE` | 256 declared |
| world 2 runtime palettes | `$B9DF` | 1:`$B9CF` | 208 exact |
| world 2 runtime metatiles | `$BAAF` | 1:`$BA9F` | 208x4 exact |
| world 2 palette sets | `$87B1` | 1:`$87A1` | 9x16 exact |
| world 2 CadEditor screen region | `$BDFC` | 1:`$BDEC` | 60x16x15 editor view |
| world 2 stage sequence | `$BDEF` | 1:`$BDDF` | 229 bytes |
| world 2 metatile collision bits | `$BED4` | 1:`$BEC4` | 26 bytes |
| world 2 screen pointers | `$BEEE` | 1:`$BEDE` | 119 standard entries |
| world 2 compressed streams | `$BFDC` | 1:`$BFCC` | through `$FFFA` |
| world 3 attributes | `$15E02` | 2:`$DDF2` | 256 |
| world 3 initial room objects | `$1597B` | 2:`$D96B` | 5x13 bytes |
| world 3 behavior pointers | `$159BC` | 2:`$D9AC` | 16 pointers |
| world 3 behavior streams | `$159DC` | 2:`$D9CC` | 1,062 bytes |
| world 3 small blocks | `$15F02` | 2:`$DEF2` | 1,024 |
| world 3 big blocks | `$16302` | 2:`$E2F2` | 1,024 |
| underwater map | `$16702` | 2:`$E6F2` | 64x64 |

Small blocks are linear row-major 2x2 CHR-tile groups. Large blocks are linear
row-major 2x2 groups of small-block indexes. CadEditor masks the low two palette
selector bits while editing and preserves the upper six bits. Those upper bits
are zero throughout the canonical World 1 and World 3 tables, so their runtime
meaning remains unclassified rather than being assumed to be collision data.

The world 2 CadEditor declarations are a useful editable projection, not the
runtime storage format. The claimed 256x4 small-block table and 60 fixed-size
screens overlap each other. Runtime code instead reads a 229-byte stage
sequence at `$BDDF`, indexes little-endian stream pointers at `$BEDE`, and
expands variable-length screen tokens beginning at `$BFCC`. The first 119
pointer slots address 116 unique ROM streams. `$7F` is a terminal sentinel:
the preceding stop command prevents stream decoding after the generic selector
stores pointer `$00FC`. `$7B` at `$BEC4` is the first byte of the metatile
collision bitmap, not a selector.

The runtime metatile renderer proves the exact table boundary independently of
CadEditor. Literal IDs `$00-$CF` select 208 palette bytes at `$B9CF-$BA9E` and
208 row-major 2x2 CHR-tile records at `$BA9F-$BDDE`; `$BDDF` is the first stage
bytecode byte. The 208 MSB-first solid flags occupy `$BEC4-$BEDD`. The preceding
`$FF` at `$B9CE` is preserved but not indexed by the renderer. See
`docs/world2_metatiles.md`.

Each standard stream decodes sixteen rows of at least fifteen cells. Bytes
below `$D0` are literal cells, `$D0-$EE` emit an empty cell and spawn an enemy,
`$EF` terminates a row, and `$F1-$FF` repeat the following literal by the low
nibble plus one. The extra copy comes from falling through the counted loop to
the shared literal store. `$F0` is unused. Repeats may deliberately overshoot
the fifteen-cell threshold; the largest decoded row is 22 cells. The final stream
reads through `$FFFA`, reusing the low byte of the NMI vector as data.

`scripts/map_data.py` retains the CadEditor ranges as provenance for the
editor-compatible view. `config/prg_data_ranges.txt`,
`config/world2_streaming.json`, and `scripts/world2_streaming.py` use the exact
non-overlapping runtime regions. All overlapping selector views are losslessly
editable through `data/world2/compressed_screens.json`; see
`docs/world2_streaming.md`.

`scripts/map_data.py` validates all CadEditor-declared regions against
independent CRC32 values and reports their overlap explicitly.

`config/world_data.json` proves the exact contiguous World 1 and World 3
hierarchies and their cross-reference metrics. `scripts/world_data.py` validates
the PRG and the lossless authoring documents at
`data/world1/hierarchical_world.json` and
`data/world3/hierarchical_world.json`; see `docs/world_data.md`.

World 3 initializes its persistent object registry from five contiguous
13-byte arrays rather than from interleaved records. The arrays are room, type,
X, Y, and state. The next 32 bytes are sixteen little-endian behavior-stream
pointers for entity types `$00-$0F`; their targets cover `$D9CC-$DDF1`.
`config/world3_object_data.json` fixes both layouts and their CRCs.
`config/world3_behavior.json` additionally proves that all 1,062 behavior bytes
decode without gaps or invalid control-flow targets and validates the lossless
editable representation in `data/world3/behavior_streams.json`.

World 2's nine background/sprite palette sets and three chapter selector pairs
round-trip through `data/world2/palettes.json`. Their lookup bases, stage
commands, and code/data overlap are fixed by `config/world2_palettes.json`; see
`docs/world2_palettes.md`.
