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
| World 1 city | 744 | PRG3/CHR3 -> PRG0/CHR3 | bank 0 `$8271` | PRG0/CHR0 (`$00`) |
| World 2 cave | 186 | PRG3/CHR3 -> PRG1/CHR3 | bank 1 `$8271` | PRG1/CHR1 (`$05`) |
| World 3 underwater | 194 | PRG3/CHR3 -> PRG2/CHR3 | bank 2 `$8271` | PRG2/CHR2 (`$0A`) |

The World 1 scenario uses two separate Start presses: the first skips the title
animation and the second begins the game. A single press instead lets the title
enter an attract demonstration at frame 1306 through bank-0 `$8277`; that demo
eventually returns to the title. This distinction is enforced by the tracked
input sequence and bank-0 `$8271` entry expectation.

World 2 temporarily follows PRG1 -> PRG3 -> PRG1 at frames 192-195 through the
bank-3 `$8277` entry. World 3 likewise follows PRG2 -> PRG3 -> PRG2 at frames
206-209. These round trips are runtime evidence that bank 3 supplies a callable
common presentation service, not merely the title's top-level loop.

## World 1 city to underground

The `world1-underground` scenario repeats the real two-Start game entry, moves
down across the visible spawn-area manhole, and holds A during the overlap. At
frame 977 execution takes the accepted manhole branch at bank-0 `$D244`; at
frame 1010 it reaches the side-view initializer at bank-0 `$CDB5`. Both probes
are required in order.

The complete transition remains in selector `$00` (PRG0/CHR0). Thus city and
underground are not only stored in the same physical bank: runtime shows that
the renderer/mode transition occurs without a mapper change. The generated
final screenshot is written to `build/runtime/screens/world1-underground.png`
and shows the side-view brick tunnel; screenshots and CSV traces remain ignored
build evidence.
