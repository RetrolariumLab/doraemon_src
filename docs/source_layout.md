# Source layout

| Module | Output | Responsibility |
| --- | --- | --- |
| `src/main.asm` | header/include order | canonical entrypoint |
| `src/banks/bank_0.asm` | PRG bank 0 | generated address-order include map |
| `src/banks/bank_1.asm` | PRG bank 1 | generated address-order include map |
| `src/banks/bank_2.asm` | PRG bank 2 | generated address-order include map |
| `src/banks/bank_3.asm` | PRG bank 3 | generated address-order include map |
| `src/common/bank0_*.asm` | PRG bank 0 | reset/NMI/mapper/gateways and vectors |
| `src/world1/*.asm` | PRG bank 0 | city and underground runtime systems |
| `src/world1/data/*.asm` | PRG bank 0 | maps and two-level metatile data |
| `data/world1/*.json` | editable data | lossless World 1 maps, attributes, and metatiles |
| `src/common/bank1_*.asm` | PRG bank 1 | reset/NMI/mapper/gateways and vectors |
| `src/world2/*.asm` | PRG bank 1 | cave shooter runtime and audio systems |
| `src/world2/data/*.asm` | PRG bank 1 | blocks, stage sequence, pointers, and compressed screens |
| `data/world2/*.json` | editable data | lossless shared-token World 2 screen views |
| `src/common/bank2_*.asm` | PRG bank 2 | reset/NMI/mapper/gateways and vectors |
| `src/world3/*.asm` | PRG bank 2 | underwater runtime, objects, and audio |
| `src/world3/data/*.asm` | PRG bank 2 | build string, objects, behavior streams, maps, metatiles, and tail |
| `data/world3/*.json` | editable data | lossless World 3 behavior streams, maps, attributes, and metatiles |
| `src/common/bank3_*.asm` | PRG bank 3 | reset/NMI/mapper/gateways and vectors |
| `src/shell/*.asm` | PRG bank 3 | title, game over, ending, and transitions |
| `src/rendering/*.asm` | PRG bank 3 | shell PPU/text/frame services |
| `src/audio/*.asm` | PRG bank 3 | effect driver, music engine, and streams |
| `src/data/*.asm` | PRG bank 3 | credits and unclassified trailing data |
| `src/graphics/chr.asm` | four 8 KiB banks | private CHR payload |
| `src/memory/*.inc` | no bytes | hardware and evidence-backed RAM aliases |

Each PRG bank maps to `$8000-$FFFF` in its own linker memory area. Generated
labels are bank-qualified because identical CPU addresses can identify different
physical bytes. PRG files contain instructions, explicit `.byte` data, or
generated source includes only; they never include extracted binaries.

`config/source_modules.json` is the canonical address-to-module map. It covers
every byte of all four banks without gaps or overlaps. The generator rejects a
boundary through an instruction, and the reconstruction audit enforces the
700-line limit on every declared semantic module. World 2 separates the stage
sequence and standard pointer table from three contiguous storage shards for
the variable-length screen streams; the shard boundaries do not claim
format-level screen boundaries. Likewise, the two ending-credit files are
contiguous storage shards rather than a claim that `$DBBC` is a format-level
boundary.
