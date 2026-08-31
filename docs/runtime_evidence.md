# Runtime evidence

Runtime claims are captured from the exact PRG0 reference with the instrumented
FCEUX checkout shared by the reference projects. Generated CSV traces live under
the ignored `build/runtime/traces` directory; scenario definitions, capture
hooks, validators, and their tests are tracked.

## Boot and title shell

Scenario `boot-title` runs 360 frames with no controller input. Its first
observed control sequence is:

| Frame | Event | Active PRG | Selector | Result |
| ---: | --- | ---: | ---: | --- |
| 1 | reset at `$8098` | 0 | `$FF` | FCEUX power-on mapping only |
| 7 | mapper entry at `$81BB` | 0 | `$03` | request PRG 3 / CHR 0 |
| 7 | instruction after mapper write | 3 | `$03` | PRG 3 committed |
| 7 | dispatch at `$8271` | 3 | `$03` | title/common shell entry |
| 9 | mapper entry at `$81BB` | 3 | `$0F` | request PRG 3 / CHR 3 |
| 13 | first NMI at `$813C` | 3 | `$0F` | compatible PRG 3 NMI path |

From frame 13 onward, the title idle path invokes the mapper routine from NMI
and executes dispatch entries `$8274` and `$827A` every frame. Across the full
capture, 351 mapper writes were paired with 351 post-write hooks and 348 NMIs.
Every write used address `$8261 + selector`; the ROM byte at that address equaled
`(PRG << 4) | CHR`, and the post-`STA` bank fingerprint equaled the requested
PRG bank.

The reset observation resolves the automation environment's initial mapping:
this FCEUX build starts mapper 66 in PRG bank 0. It does **not** resolve the
physical cartridge's unspecified power-on latch, so `BANK-001` remains open.

Reproduce and validate the evidence with:

```bash
make runtime-architecture
```

## Chapter entry graph

The same capture system drives the documented title shortcut rather than
patching RAM. Controller polling observes `$10` for Start, `$C0` for A+B,
`$E0` for A+B+Select, and `$D0` for A+B+Start. Each scenario validates that the
input appeared in the game's own controller byte before accepting a bank entry.

| Scenario | Entry frame | Observed edge | Entry dispatch | Steady selection |
| --- | ---: | --- | --- | --- |
| World 1 city | 1306 | PRG3/CHR3 -> PRG0/CHR3 | bank 0 `$8277` | PRG0/CHR0 (`$00`) |
| World 2 cave | 186 | PRG3/CHR3 -> PRG1/CHR3 | bank 1 `$8271` | PRG1/CHR1 (`$05`) |
| World 3 underwater | 194 | PRG3/CHR3 -> PRG2/CHR3 | bank 2 `$8271` | PRG2/CHR2 (`$0A`) |

The natural World 1 path spends about 1,120 additional frames in the shell's
intro sequence before entering bank 0. The A+B shortcut bypasses that sequence
and enters the selected chapter's `$8271` dispatcher directly.

World 2 temporarily follows PRG1 -> PRG3 -> PRG1 at frames 192-195 through the
bank-3 `$8277` entry. World 3 likewise follows PRG2 -> PRG3 -> PRG2 at frames
206-209. These round trips are runtime evidence that bank 3 supplies a callable
common presentation service, not merely the title's top-level loop.
