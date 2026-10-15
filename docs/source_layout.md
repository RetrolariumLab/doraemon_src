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
| `src/common/bank1_*.asm` | PRG bank 1 | reset/NMI/mapper/gateways and vectors |
| `src/world2/*.asm` | PRG bank 1 | cave shooter runtime and audio systems |
| `src/world2/data/*.asm` | PRG bank 1 | blocks, stage sequence, pointers, and compressed screens |
| `src/common/bank2_*.asm` | PRG bank 2 | reset/NMI/mapper/gateways and vectors |
| `src/world3/*.asm` | PRG bank 2 | underwater runtime, objects, and audio |
| `src/world3/data/*.asm` | PRG bank 2 | build string, objects, behavior streams, maps, metatiles, and tail |
| `src/common/bank3_*.asm` | PRG bank 3 | reset/NMI/mapper/gateways and vectors |
| `src/shell/*.asm` | PRG bank 3 | title, game over, ending, and transitions |
| `src/rendering/*.asm` | PRG bank 3 | shell PPU/text/frame services |
| `src/audio/*.asm` | PRG bank 3 | effect driver, music engine, and streams |
| `src/data/*.asm` | PRG bank 3 | title/help/ending screens, credits, and typed trailing data |
| `src/graphics/chr.asm` | four 8 KiB banks | private CHR payload |
| `src/memory/*.inc` | no bytes | hardware and evidence-backed RAM aliases |

Each PRG bank maps to `$8000-$FFFF` in its own linker memory area. Generated
labels are bank-qualified because identical CPU addresses can identify different
physical bytes. PRG files contain instructions, explicit `.byte` data, or
generated source includes only; they never include extracted binaries.

Releases 1.0 to 3.0 regenerated every module from Ghidra facts and a symbol
registry and audited the result; that pipeline remains at those tags. From
3.1 the source is the authority and is edited directly; `make test` rebuilds
both revisions byte for byte.

World 2 separates the stage
sequence and standard pointer table from three contiguous storage shards for
the variable-length screen streams; the shard boundaries do not claim
format-level screen boundaries. Likewise, the two active ending-credit files
are contiguous storage shards rather than a claim that `$DBBC` is a
format-level boundary. The semantic credit range ends at the proven exclusive
reader pointer `$ED3C`; subsequent presentation bytes remain separately typed.
