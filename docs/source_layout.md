# Source layout

| Module | Output | Responsibility |
| --- | --- | --- |
| `src/main.asm` | header/include order | canonical entrypoint |
| `src/banks/bank_0.asm` | PRG bank 0 | world 1 preservation listing |
| `src/banks/bank_1.asm` | PRG bank 1 | world 2 preservation listing |
| `src/banks/bank_2.asm` | PRG bank 2 | world 3 preservation listing |
| `src/banks/bank_3.asm` | PRG bank 3 | shell/title/ending preservation listing |
| `src/graphics/chr.asm` | four 8 KiB banks | private CHR payload |
| `src/memory/*.inc` | no bytes | hardware and evidence-backed RAM aliases |

Each PRG module maps to `$8000-$FFFF` in its own linker memory area. Generated
labels are bank-qualified because identical CPU addresses can identify different
physical bytes. PRG files contain instructions and explicit `.byte` data only;
they never include extracted binaries.

Future splits must preserve order inside a bank. Prefer coherent modules of
roughly 200-500 lines after boundaries and consumers are proven.
