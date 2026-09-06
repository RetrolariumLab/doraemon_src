# Reconstruction inventory

This inventory measures semantic progress independently from physical source
layout. Moving bytes into a `worldN/` module does not count as naming them.
`config/reconstruction_inventory.json` pins the current snapshot, and
`scripts/reconstruction_inventory.py` recalculates it from tracked source and
evidence manifests. Any change requires an intentional snapshot update.

## Current snapshot

| Bank | Global labels | Semantic labels | Neutral routines | Neutral locals | Semantic indirect entries |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 0 | 1,012 | 327 | 0 | 685 | 84 / 84 |
| 1 | 879 | 320 | 0 | 559 | 97 / 97 |
| 2 | 1,103 | 420 | 0 | 683 | 106 / 106 |
| 3 | 363 | 161 | 0 | 202 | 67 / 67 |
| Total | 3,357 | 1,228 | 0 | 2,129 | 354 / 354 |

The inventory now separates zero neutral routine definitions from 2,129
address-derived local branch labels. The common runtime naming pass removed 88 neutral routine
names by proving copied reset/NMI/mapper services, cross-bank gateways, and
bank-local dispatches. A second pass named all 19 previously neutral non-audio
dispatch entries in World 2 streaming and the World 3 player state machine. The
audio-effect pass then assigned all remaining 137 indirect entries to exact
request pairs, structural synthesis roles, timer leases, and APU channels.
Every one of the 354 registered indirect entries now has an evidence-backed
semantic symbol. It also names the sixteen bank-local effect helpers, including
the previously local-only World 1 indexed-tonal entry at `$E6C1`. Source 1.0
now additionally has runtime-backed names for all four gameplay loops: World 1
city `$82C1`, World 1 underground `$CE55`, World 2 `$8959`, and World 3
`$838E`. All sixteen bank gateway targets, the three bank-local NMI targets
that were still neutral, and the frame waits used by these top-level paths are
also named and checked. Source 1.0 gives priority to the remaining directly
reached core routines. The shell-text pass names the PPU record reader, palette
staging, ending-credit row streamer, fixed screen data, and active credit loop
while correcting a former label from the middle of the title prompt to the
actual `$9248` stream start.
Local labels are renamed only when that materially clarifies a routine contract.

The Bank 3 shell pass removes all sixteen remaining neutral routine entries
from that bank. Title/attract input, chapter transitions, ending OAM setup, and
shell nametable/OAM helpers are tied to exact code spans, complete Ghidra
direct-caller sets, and eight Bank 3-private RAM fields.

The first gameplay-bank pass names twenty World 1 core routines covering
normal/demo initialization, area palette/music/input setup, pause and rendering
boundaries, player/HUD composition, and all four entity-pool render adapters.
Those entries account for 912 executable bytes and 68 direct callers.

The next World 1 pass names twenty-three frame-mechanics routines spanning
transient and player-projectile motion, both collision directions, damage and
reward resolution, timed powerups, death presentation, and PPU preparation.
The corresponding contract covers 1,591 executable bytes and 66 direct
callers. At that checkpoint, 27 probable neutral routine entries remained in
Bank 0.

The World 1 entity-helper pass names seventeen direction, coordinate,
collision-probe, and projectile-construction routines. Its contract covers 877
bytes, 88 direct callers, and 244 bytes of player/camera/entity RAM.

The final Bank 0 pass names the remaining ten routine entries: underground
finale entry/death handling, the Bull Robo scripted controller and explosion
spawner, plus five handler-local collision, distance, movement, and alignment
helpers. Its contract covers 965 bytes, 19 direct callers, and five newly named
finale RAM fields. Bank 0 now has zero neutral routine entries; the remaining
204 are entirely in Banks 1 and 2.

The first World 2 naming pass covers fifteen frame/stage core routines and ten
Bank 1 RAM fields: render cadence, stage/chapter completion, transition delays,
initial presentation, delayed scroll/music activation, player damage/death,
and the microphone item. It removes 15 neutral Bank 1 entries, leaving 76 in
Bank 1 and 113 in Bank 2.

The World 2 player-system pass names thirteen more routines and nine RAM
fields across movement, firing, player history, damage state, and all seven
inventory slots. The subsequent screen-core pass names five NMI/PPU routines,
one post-switch overlay entry, and the scroll-coordinate pair. Bank 1 now has
57 neutral routine entries. The projectile-runtime pass then names seventeen
more entries across hazard scanning, seven player-projectile slots, and both
inventory-owned attacks. Its exact contract covers 768 executable bytes, 23
direct edges, and nine Bank 1-private RAM fields. Bank 1 now has 40 neutral
routine entries. The sprite-runtime pass names another 27 entries across the
player, all seven inventory slots, metasprite composition, and final OAM
emission. It covers 864 executable bytes, 54 direct edges, and nine RAM
symbols covering the 48-sample position-history pair plus renderer staging.
Bank 1 now has 13 neutral routine entries. The final Bank 1 pass names the
remaining enemy activation/collision, projectile/enemy rendering, metasprite,
chapter-exit, and HUD entries. It covers 796 executable bytes, 19 direct
edges, and 19 RAM symbols. Bank 1 now has zero neutral routine entries; all
113 remaining entries are confined to Bank 2.

The first World 3 core pass names eighteen initialization, room/player setup,
pause, palette, object-reset, OAM, and HUD routines. Its machine contract
covers 938 executable bytes, 42 direct calls, and 22 Bank 2-private RAM
fields. The following collision/rendering pass names another twenty-two
routines covering entity metasprite submission, player/entity/projectile edge
probes, the shared terrain-point readers, and final-room/Passing Hoop/boss
terrain overrides. Its exact contract covers 808 executable bytes, 50 direct
calls, and 20 Bank 2-private RAM symbols spanning 21 bytes. The room-runtime
pass then names fifteen input/audio, player-render, directional-transition,
persistence-policy, room-reload, music-selection, and palette-fade routines.
Its exact contract covers 607 executable bytes, 76 direct calls, and ten RAM
bytes; it also names the 64-byte room-music-class and four-byte track tables.
The player-runtime pass then names thirteen map lookup, player initialization,
health/session reset, five-state movement, and room-edge motion routines. Its
exact contract covers 690 executable bytes, 25 direct `JSR`/`JMP` edges,
four conditional entries, and fourteen RAM bytes; it also names the state
dispatch and four state/movement tables. At that checkpoint, Bank 2 contained
the complete remaining population of 45 neutral routine entries. The interaction
pass names another nine final-companion, arena/barrier, projectile-hit,
defeat/score, pickup, follower, and player-contact routines. Its exact contract
covers 1,016 executable bytes, 26 direct calls, and eight RAM bytes; it also
names the two blank-tile rows used by the PPU updates. At that checkpoint,
Bank 2 contained the complete remaining population of 36 neutral routine
entries. The entity-runtime
pass names ten cross-chapter Passing Hoop, persistent-object clamp/carry,
type-04 split, stopwatch, spawn-coordinate, and portal-opening helpers. Its
exact contract covers 545 executable bytes, 17 direct calls or tail jumps, and
seven established RAM fields; it also names the 64-entry room clamp table.
At that checkpoint, Bank 2 contained the complete remaining population of 26
neutral routine entries. The room-rendering pass names eight palette-in,
map-window, hierarchical expansion, tile-pair, attribute, and PPU-row helpers.
Its exact contract covers 351 executable bytes and ten direct calls; it also
names five RAM fields spanning the room map pointer, row selectors, output row,
and target palette. At that checkpoint, Bank 2 contained the complete remaining
population of 18 neutral routine entries. The formation-runtime pass names
thirteen giant-octopus chain, coordinate-step, encounter-room, dragon spawn,
and dragon update helpers. Its exact contract covers 679 executable bytes,
28 direct calls, and twelve RAM fields; it also names the 64-room encounter
exclusion mask and six formation-specific RAM aliases. At that checkpoint,
Bank 2 contained the complete remaining population of five neutral routine
entries. The final
transition-runtime pass names the completion sequence and wipe, room `$3F`
marker, diagnostic halt, and controller-two sprite-test setup. Its exact
contract covers 374 executable bytes, twelve direct calls or tail jumps, and
ten Bank 2 RAM fields; it also names three fixed transfer tables and the marker
blink counter. No neutral routine definitions remain in any PRG bank.

The symbol registry currently contains 1,092 evidence-backed code symbols and
126 operand/table symbols. RAM coverage contains 437 unique aliases: 83 shared
symbols plus 98 Bank 0, 97 Bank 1, 151 Bank 2, and 8 Bank 3 scoped symbols.

Typed PRG ranges cover 66,180 bytes in 58 non-overlapping regions. Bank 0 now
includes the twelve complete World 1 PPU palettes as one 384-byte table. Bank 3
still separates exact title, game-over, chapter-help, ending-opening, active-credit,
and post-credit presentation spans instead of treating them as audio or one
undifferentiated credit tail:

| Bank | Typed bytes | Ranges |
| ---: | ---: | ---: |
| 0 | 11,772 | 11 |
| 1 | 19,954 | 18 |
| 2 | 12,373 | 20 |
| 3 | 22,081 | 9 |

Four sections still contain explicit `Unknown:` claims: `BANK-001`,
`WORLD-DATA-002`, `AUDIO-002`, and `TEXT-001`. `BANK-002` is now resolved by
the sixteen-entry common-runtime dispatch contract. Long sections containing
only resolved `Known:` evidence do not inflate that count.

## Priority rule

Naming work proceeds through common boot/NMI/score paths, four main loops,
audio drivers, and every indirect-dispatch target before cosmetic local-label
cleanup. Inventory counts are descriptive evidence, not a standalone release
percentage: routine importance and subsystem completeness are not uniform.

Run:

```text
make reconstruction-inventory
```
