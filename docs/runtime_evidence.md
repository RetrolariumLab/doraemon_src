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

Runtime probes also identify each chapter's long-lived execution path:

| Scenario | Main entry | First frame-loop iteration | Steady selector |
| --- | --- | --- | --- |
| World 1 city | bank 0 `$828E`, frame 744 | bank 0 `$82C1`, frame 878 | `$00` |
| World 1 underground | bank 0 `$828E`, frame 744 | bank 0 `$CE55`, frame 1039 | `$00` |
| World 2 cave | bank 1 `$88A4`, frame 186 | bank 1 `$8959`, frame 295 | `$05` |
| World 3 underwater | bank 2 `$82F6`, frame 194 | bank 2 `$838E`, frame 338 | `$0A` |

All four gameplay-loop probes recur exactly once per emulated frame: 323
consecutive city frames, 362 consecutive underground frames, 606 World 2
frames, and 563 World 3 frames in their dedicated scenarios. The underground
scenario additionally records 99 consecutive city-loop frames before the
manhole transition and requires the ordered city-loop -> manhole -> side-view
initializer -> underground-loop path. The World 3 dispatch target initially sat
behind the build string at `$827D-$82AC`; the runtime entry plus the bank-2
`$8271 -> $82F6` jump establishes the exact code/data boundary used by the
disassembly pipeline.

## World 2 terminal sentinel

Scenario `world2-terminal-screen` enters World 2 normally, then applies two
declared RAM patches at frame 400: stage offset `$83` positions the next decode
at the canonical `$F8,$7F` pair, and row index `$0F` completes the current
screen. At frame 424 the original sequence decoder clears the scrolling byte,
selects screen ID `$7F`, and the generic pointer lookup stores `$00FC`.

The trace continues through frame 1000 without a single execution of the
compressed-token decoder at `$8444` while `$7F` is active. The validator
requires the exact `id=7F;ptr=00FC;scroll=00` selection and rejects any terminal
token-read event. This proves `$7F` is a stopped sentinel, not a RAM-backed
compressed screen.

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

## World 2 to World 3 transition

Long chapter completions are reproduced with declared RAM-state patches rather
than controller macros that play the whole game. The `chapter-transition`
scenario enters World 2 normally, then writes `$01` to the bank-1 completion
flag at `$00B2` on frame 400. It does not patch ROM or redirect the CPU.

The ordinary code path reaches bank-1 `$8A32` on frame 641, uses gateway `$808D`,
and enters the bank-3 transition at `$8C43` on frame 643 with selector `$07`
(PRG3/CHR1). The transition animation exits through `$8016`; World 3 reaches
its normal `$82F6` entry on frame 1162 and its `$838E` frame loop on frame 1306
with selector `$0A`. This proves the complete PRG1 -> PRG3 -> PRG2 chapter edge.

Static code shows the paired World 1 route: bank-3 `$8C3F` stores transition
kind 0 and exits through `$800B` to PRG1, while `$8C43` stores kind 1 and exits
through `$8016` to PRG2.

## Ending and credits

The `ending-credits` scenario enters World 3 normally and applies two declared
RAM patches. `$004F = $01` on frame 400 selects the chapter's existing completion
countdown; `$003B = $00` on frame 800 supplies the full-game state that the title
shortcut does not establish. The resulting execution is entirely original code:

| Frame | Evidence |
| ---: | --- |
| 401 | bank-2 completion sequence at `$AE12` |
| 733 | PRG3 ending entry at `$8A88` via gateway `$8077/$8280` |
| 1490 | credits scroll loop at `$8B18`, reading from `$BDBC` |

The credits loop remains active through the 6000-frame capture with selector
`$0F` (PRG3/CHR3). `build/runtime/screens/ending-credits.png` visibly shows the
scrolling developer credits. Runtime patch events include frame, address, value,
and name, and the validator requires them before accepting the probe sequence.
