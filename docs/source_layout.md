# Source layout

| Module | Output | Responsibility |
| --- | --- | --- |
| `src/main.asm` | header/include order | canonical entrypoint |
| `src/banks/bank_0.asm` | PRG bank 0 | generated address-order include map |
| `src/banks/bank_1.asm` | PRG bank 1 | world 2 preservation listing |
| `src/banks/bank_2.asm` | PRG bank 2 | world 3 preservation listing |
| `src/banks/bank_3.asm` | PRG bank 3 | generated address-order include map |
| `src/common/bank0_*.asm` | PRG bank 0 | reset/NMI/mapper/gateways and vectors |
| `src/world1/*.asm` | PRG bank 0 | city and underground runtime systems |
| `src/world1/data/*.asm` | PRG bank 0 | maps and two-level metatile data |
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

`config/source_modules.json` is the canonical address-to-module map. It currently
covers every byte of banks 0 and 3 without gaps or overlaps. The generator
rejects a boundary through an instruction, and the reconstruction audit enforces
the 700-line limit on every declared semantic module. The two ending-credit
files are contiguous storage shards rather than a claim that `$DBBC` is a
format-level boundary.

Banks 1 and 2 remain preservation listings while their remaining subsystem
boundaries are being proved. Their future splits must preserve address order and
use the same manifest contract.
