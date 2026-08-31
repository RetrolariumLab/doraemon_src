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
| world 2 screens | `$BDFC` | 1:`$BDEC` | 60x16x15 |
| world 3 attributes | `$15E02` | 2:`$DDF2` | 256 |
| world 3 small blocks | `$15F02` | 2:`$DEF2` | 1,024 |
| world 3 big blocks | `$16302` | 2:`$E2F2` | 1,024 |
| underwater map | `$16702` | 2:`$E6F2` | 64x64 |

Small blocks are linear 2x2 CHR-tile groups. Large blocks are linear 2x2 groups
of small-block indexes. Attribute bytes retain collision/type bits; CadEditor
masks only the low two palette bits while editing.

The world 2 CadEditor declarations overlap: a full 256x4 small-block table ends
179 bytes inside the screen array. The editor reads that overlap, but it does
not prove all 256 block slots are valid. `config/prg_data_ranges.txt` therefore
marks the non-overlapping prefix and the screen array separately.

`scripts/map_data.py` validates all declared regions against independent CRC32
values and reports the overlap explicitly.
