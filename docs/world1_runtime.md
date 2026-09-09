# World 1 Runtime

This chapter joins the camera, player, entity, enemy, frame, and random-number contracts that cooperate in the World 1 gameplay loop. Machine-readable addresses, call graphs, byte signatures, and RAM ownership remain authoritative in `config/reconstruction/world1/`.

## Contents

- Camera movement and entity projection
- Chapter initialization and frame services
- Enemy dispatch and evidence-backed identities
- Player controls, weapons, and random generators

## World 1 camera scrolling

World 1 uses four directional routines for the city and underground camera.
Each routine attempts one pixel of movement, returns without changing state at
the corresponding world boundary, and prepares a row or column update when a
new map edge becomes visible.

### Coordinate model

| Axis | Pixel scroll | Coarse coordinate | Inclusive range |
| --- | --- | --- | ---: |
| horizontal | `PpuScrollXShadow` | `World1CameraTileX` | `$00-$E0` |
| vertical | `PpuScrollYShadow` | `World1CameraTileY` | `$00-$E2` |

The low three scroll bits are a sub-cell offset, so the coarse coordinate
changes every eight pixels. Horizontal byte wrap toggles `World1NametableX`.
Vertical scrolling accounts for the NES nametable discontinuity by translating
the `$F0-$FF` interval across a `$10` adjustment.

Every accepted camera pixel changes the matching `World1ScreenDeltaX` or
`World1ScreenDeltaY` in the opposite direction. Entity rendering consumes that
signed delta, keeping objects fixed in world space while the viewport moves.

### Directional entry points

| Routine | Address | Bytes | Direct calls | Edge packet |
| --- | ---: | ---: | ---: | --- |
| `World1_TryScrollCameraRight` | `$A381` | 96 | 3 | column, code 1 |
| `World1_TryScrollCameraLeft` | `$A3E1` | 78 | 3 | column, code 1 |
| `World1_TryScrollCameraDown` | `$A42F` | 85 | 5 | row, code 2 |
| `World1_TryScrollCameraUp` | `$A484` | 66 | 5 | row, code 2 |

Column tile data is built on the coarse eight-pixel boundary; column
attributes are built on the matching 16-pixel phase. Row tile and attribute
data use corresponding vertical phases. A completed edge shifts the existing
low nibble of `World1EdgeUpdateQueue` into the high nibble and appends code 1
for a column or code 2 for a row.

### Underground player tracking

Two room-orientation entry points select the directional primitives above.
`World1_TrackUndergroundHorizontalCamera` holds the player in X `$6E-$82`
and can request at most two camera pixels per update. The vertical-room
counterpart holds Y in `$6E-$92` and can request at most six pixels. Both
reduce the distance outside the band to a per-update budget, stop at axis
position zero or the room-specific limit, and then apply the accumulated
screen delta to the player and all active entities.

The two orientations deliberately overlay one four-byte axis workspace.
`World1UndergroundAxisScrollCoarse` advances whenever the low-three-bit
`World1UndergroundAxisScrollFine` phase wraps. The positive direction stops at
`World1UndergroundAxisScrollLimit`; the fourth byte is the temporary pixel
budget. Horizontal rooms call the left/right primitives, while the vertical
room calls up/down.

| Tracking routine | Address | Bytes | Direct calls | Player band | Max pixels |
| --- | ---: | ---: | ---: | ---: | ---: |
| `World1_TrackUndergroundHorizontalCamera` | `$CF08` | 114 | 1 | X `$6E-$82` | 2 |
| `World1_TrackUndergroundVerticalCamera` | `$D47C` | 114 | 1 | Y `$6E-$92` | 6 |

The normal player-camera path, initial viewport prefill, and scripted movement
all call these same routines. `config/reconstruction/world1/world1_camera.json` pins all 553 routine
bytes, the twelve state symbols and ownership scopes, the coordinate geometry,
the underground tracking bands, and all 18 direct callsites. Run the focused
contract with:

```text
make validate-world1-camera
```

Player tracking, entity coordinate projection, and offscreen culling form the
consumer side of this camera model. Their exact contract is documented in
`docs/world1_runtime.md`.

## World 1 camera entity projection

World 1 keeps the player and all active entities in screen-relative
coordinates. Camera movement accumulates signed X/Y deltas; the tracking path
applies those deltas to the player and to every active entity after each
camera decision.

### Player tracking window

`World1_UpdateCameraFromPlayer` clears both deltas, then attempts two camera
pixels on each axis when the player leaves this window:

| Axis | Negative direction | No-scroll interval | Positive direction |
| --- | --- | --- | --- |
| X | player below `$50` | `$50-$9F` | player at or above `$A0` |
| Y | player below `$48` | `$48-$8F` | player at or above `$90` |

The directional routines may reject movement at a world boundary. The
resulting signed deltas, rather than the requested two pixels, are added back
to `World1PlayerX` and `World1PlayerY`.

### Entity projection and culling

`World1_ApplyCameraDeltaToEntities` traverses all 48 slots from 47 down to 0.
For each nonzero `World1EntityType`, it adds the signed delta to the low X and
Y bytes and propagates carry or borrow into the matching two-bit fields of
`World1EntityPositionHigh`. Its X field occupies bits 0-1 and Y occupies bits
2-3.

The routine falls directly into `World1_CullOffscreenEntities`. Culling retains
one adjacent coordinate page as a spawn margin:

| Axis | Negative margin | Positive margin | Always rejected page |
| --- | --- | --- | --- |
| X | 64 pixels | 64 pixels | page 2 |
| Y | 64 pixels | 32 pixels | page 2 |

When a removed entity has a nonnegative `World1EntitySourceObjectId`, the
low seven bits identify the map object passed to `World1_ReleaseObjectSpawn`.
Transient entities use a negative source ID and need no map-bit release.

### Validated routines

| Routine | Address | Bytes | Direct calls |
| --- | ---: | ---: | ---: |
| `World1_UpdateCameraFromPlayer` | `$8706` | 74 | 3 |
| `World1_ApplyCameraDeltaToEntities` | `$8750` | 168 | 7 |
| `World1_CullOffscreenEntities` | `$87F8` | 84 | 3 |

`config/reconstruction/world1/world1_camera_entities.json` pins all 326 routine bytes, the complete
13-call graph, the fallthrough edge, tracking thresholds, culling margins, and
244 RAM bytes across the player, delta, and five entity arrays. Run:

```text
make validate-world1-camera-entities
```

## World 1 core routines

`config/reconstruction/world1/world1_core_routines.json` fixes the high-level initialization, input,
render-state, and sprite-composition path used by both the city and underground
loops. It replaces twenty address-only routine names with behavioral contracts.

The initialization group distinguishes normal entry from the demo entry, then
names the shared gameplay-RAM/OAM clear, audio reset, area palette lookup, map
source setup, health/pose reset, and area music selection. The input routine
has two explicit modes: real input computes newly pressed button edges, while
demo input consumes duration/button pairs and returns to the shell at its
terminator.

The rendering group names the Start-button pause loop, rendering enable/disable
boundaries, the alternating frame-order dispatcher, player and HUD emitters,
and four adapters for entity slots 0-9, 10-29, 30-37, and 38-47. The adapters
convert each structure-of-arrays pool into the common metasprite workspace;
their separate names make the four different base offsets visible at callsites.

For every routine the contract checks its exact address range and CRC32,
semantic registry entry, complete direct JSR/JMP caller set from current Ghidra
facts, and encoded callsite bytes. It also ties the path to the existing
pressed-button, damage-state, and OAM-index RAM fields.

Run:

```text
make validate-world1-core-routines
```

## World 1 enemy handlers

World 1 has two object paths that must not be conflated. Ordinary placement
types `$00-$0B` materialize into the ten-slot update pool at `$0400-$0409`.
Descriptor-backed placements use the separate interactive-object pool at
`$0426-$042F`; their 13 descriptor types are documented independently in
`world1_formats.md`.

### Materialization

For an ordinary three-byte placement, `World1_MaterializePlacement` writes
`placement_type + 1` as the runtime state and loads three parallel 16-byte
tables:

| Address | Field |
| ---: | --- |
| `$8E70` | initial metasprite index |
| `$8E80` | initial render flags |
| `$8E90` | initial health |

Only placement types `$00-$0B` occur. They account for 112 records: 77 in the
city and 35 underground. The remaining four property slots are zero padding.
All 12 initial metasprite indexes resolve directly in the World 1 metasprite
catalog.

The placement type, not the resulting runtime state, also selects one of eight
RTS-minus-one initializer slots at `$8DA4` after masking with `$0F`. Types 8-11
therefore reuse initializer slots 0-3.

### Runtime dispatch

`World1_UpdateEntities` walks the ten update slots and masks each active type
to five bits. The overlapping RTS-minus-one table at `$88FB` has 16 entries:
state 0 is the inactive loop tail, and states `$01-$0F` form the catalog in
`config/reconstruction/world1/world1_enemy_handlers.json`.

- States `$01-$0C` are produced directly from map placements.
- State `$0D` has a dispatch entry sharing the state-1 handler, but no ordinary
  placement, initializer properties, or proven writer; it remains explicitly
  classified as dormant.
- States `$0E` and `$0F` share a no-op dispatch target because their boss
  behavior is driven by the surrounding scripted controller at `$D67A`.

Two pairs of directly placed states deliberately share initial artwork while
using different handlers: `$04/$0B` both start at metasprite `$60`, and
`$05/$0C` both start at `$58`. Their placement split matches the distinct city
and underground movement systems and is preserved as separate lifecycle
states.

### Rewards and checks

When an ordinary enemy finishes its defeated-state sequence, its low six state
bits select the encoded score table at `$891B`. The handler contract records
all entries `$01-$0F` and joins each handler to the evidence-backed identity
catalog in `world1_runtime.md`. The generated assembly therefore uses
enemy names while keeping dormant state `$0D` explicit in the shared Yuubou
handler name.

Run `make validate-world1-enemy-handlers` to verify the dispatch bytes and
registered symbols, all four property tables and CRCs, the complete placement
histogram, metasprite-base relationships, lifecycle partition, and the normal
materializer plus scripted-boss code signatures.

## World 1 enemy identities

World 1 uses runtime states `$01-$0C` for ordinary map placements, `$0D` as an
unreferenced dispatch state, and `$0E-$0F` for the scripted Bull Robo battle.
Joining placement types, property tables, metasprites, movement handlers, and
published enemy lists resolves all ten ordinary identities and both mode
variants. State `$0D` remains deliberately structural because no writer or
placement has been found.

### State catalog

| State | Identity | Context | Stored health | Score | Base metasprite |
| ---: | --- | --- | ---: | ---: | ---: |
| `$01` | ユーボウ / Yuubou | city | 2 | 200 | `$64` |
| `$02` | スネラー / Suneraa | city | 1 | 200 | `$5C` |
| `$03` | メカノッソ / Mekanosso | city | 2 | 500 | `$56` |
| `$04` | ゴズラ / Gozura | city movement | 4 | 100 | `$60` |
| `$05` | ナーメ / Naame | city movement | 1 | 200 | `$58` |
| `$06` | コブーン / Kobuun | city | 1 | 50 | `$4C` |
| `$07` | ネズミ / Nezumi | underground | 2 | 800 | `$54` |
| `$08` | ドバック / Dobakku | underground | 1 | 50 | `$70` |
| `$09` | ヘリメダ / Herimeda | underground | 2 | 1,000 | `$6C` |
| `$0A` | ギラーミン / Giraamin | underground | 4 | 50 | `$3E` |
| `$0B` | ゴズラ / Gozura | underground movement | 4 | 50 | `$60` |
| `$0C` | ナーメ / Naame | underground movement | 1 | 50 | `$58` |
| `$0D` | dormant state | no proven writer | n/a | 10,000 | n/a |
| `$0E` | ブルロボ / Bull Robo | scripted boss state | script | 50 | script |
| `$0F` | ブルロボ / Bull Robo | scripted boss state | script | 50 | script |

The repeated Gozura and Naame records are intentional. States `$04/$0B` share
metasprite base `$60`, and states `$05/$0C` share base `$58`, but each pair has
separate city and underground physics handlers. The stored health byte is an
internal damage threshold, so it must not be read as a published “number of
shots” without also accounting for the comparison order in the damage path.

### Six-defeat secret

The six bytes at `$94D9` are `$06,$06,$05,$04,$01,$06`. The defeat routine at
`$9462` compares the low six bits of the defeated runtime state against this
table and resets progress on a mismatch. Completing the sequence sets selector
index `$04`; the adjacent fifth selector byte at `$94D8` is `$0C`, so the
spawned reward is descriptor `$0C`, whose handler enables invulnerability.
After joining state identities, the exact sequence is:

`Kobuun, Kobuun, Naame, Gozura, Yuubou, Kobuun`.

This ROM-resident sequence independently anchors four otherwise visually
derived assignments: Kobuun `$06`, Naame `$05`, Gozura `$04`, and Yuubou `$01`.

### Evidence policy and validation

The [Japanese WikiWiki guide](https://wikiwiki.jp/neskouryaku1/%E3%83%89%E3%83%A9%E3%81%88%E3%82%82%E3%82%93)
provides Japanese names and behavior descriptions. The
[GameFAQs guide](https://gamefaqs.gamespot.com/nes/578343-doraemon/faqs/48568)
independently records scores, durability, visual labels, and the six-enemy
secret. [StrategyWiki's image set](https://strategywiki.org/wiki/Category:Doraemon_images)
provides another visual reference. Published names alone never select a state:
each confirmed mapping also requires local ROM evidence from metasprites,
properties, placement context, behavior, or the secret table.

`make validate-world1-enemy-identities` checks the 15-state lifecycle join,
metasprite bases, stored health and score codes, the exact direct-enemy roster,
the secret bytes and semantic order, its checker signature, and evidence
provenance. It is part of `make release-check`.

## World 1 entity helpers

`config/reconstruction/world1/world1_entity_helpers.json` fixes the movement, aiming, map-probe, and
enemy-projectile primitives shared by the semantically named World 1 entity
handlers. It replaces seventeen address-only routine names with behavioral
contracts.

The direction layer converts player-relative deltas to an eight-way direction,
applies unit-vector movement, reverses horizontal direction, and selects a
matching facing metasprite. The collision layer converts packed entity
coordinates to world-map cells and dispatches bottom, right, top, or left edge
probes, pairing cardinal probes for diagonal movement.

Three projectile constructors are now distinct: a probabilistic directional
shot in the source entity's corresponding transient slot, a random upward arc
in any free transient slot, and a fixed-point aimed shot. The aimed path records
its minor-over-major restoring division and the unusual guard that unwinds its
caller when the source entity is outside the active screen.

The machine contract pins exact code spans and CRC32 values, all direct JSR/JMP
callers from the current Ghidra facts, encoded callsite bytes, and nine existing
Bank 0 RAM symbols covering the player, camera, and shared entity structure.
Entry prefixes that intentionally fall through to another helper are recorded
as separate non-overlapping spans.

Run:

```text
make validate-world1-entity-helpers
```

## World 1 final routines

`config/reconstruction/world1/world1_final_routines.json` closes the remaining ten address-only
routine entries in Bank 0. Five routines own the vertical underground finale
and scripted Bull Robo battle; five are entity-handler geometry and movement
helpers.

The finale path swaps the city and underground persistence masks, establishes
the special bottom boundary, reveals Bull Robo, runs its hop/patrol/projectile
controller, emits randomized defeat explosions, and transfers to World 2. Its
death path also records the life-loss, game-over, and return-to-city behavior.

The handler-local layer contains an offset map collision test, Chebyshev
distance to the player, two-step direction motion with and without reversal,
and fine-scroll-relative vertical tile alignment. The intentional fallthrough
from the reversing entry to the two-step mover is represented by two
non-overlapping code spans.

The machine contract pins 965 executable bytes, 19 direct JSR/JMP callers, and
21 RAM records. Five newly named Bank 0 fields cover the finale floor flag,
sequence/reveal counters, jump phase, and attack timer. With this contract,
Bank 0 has no remaining neutral routine entry labels; address-qualified local
branches remain lower-priority implementation detail.

Run:

```text
make validate-world1-final-routines
```

## World 1 frame mechanics

`config/reconstruction/world1/world1_frame_mechanics.json` fixes the high-level motion, collision,
damage, reward, and PPU preparation services shared by the city and underground
frame loops. It replaces twenty-three address-only routine names with
behavioral contracts.

The object path distinguishes main enemies in slots 0-9, transient enemy
projectiles and effects in slots 10-29, player projectiles in slots 30-37, and
city objects in slots 38-47. The contract names transient motion integrators,
map-property probes, both collision scan directions, player/enemy damage
resolution, reward spawning, and object removal. It also exposes the common
player death and timed freeze/invulnerability paths.

The presentation path names the full nametable clear, attribute-cache clear,
pending PPU-queue wait, and the direct-versus-NMI-queued palette upload. These
routines make the initialization calls in the World 1 core readable without
claiming semantics for the still-unclassified command-stream decoder bytes
that follow them.

For every entry the machine contract checks its exact address range and CRC32,
semantic registry entry, complete direct JSR/JMP caller set from current Ghidra
facts, and encoded callsite bytes. Seven existing Bank 0 RAM symbols tie the
path to camera coordinates, player damage/render state, and the two timed
powerups.

Run:

```text
make validate-world1-frame-mechanics
```

## World 1 player controls

World 1 has separate city and underground movement implementations, but both
share input-edge state, weapon firing, and the player-to-map collision sampler.
The city path is a four-way, two-pixel update with collision rollback.

### City movement

`World1_UpdateCityPlayer` checks held directions in strict priority order:
up, down, left, then right. It moves two pixels and clamps the player to X
`$05-$EB` and Y `$28-$C8` before collision probes run.

| Direction | Encoded value | Collision probes |
| --- | ---: | ---: |
| up | 1 | 3 |
| down | 0 | 3 |
| left | 2 | 2 |
| right | 3 | 2 |

Each probe calls `World1_RollbackCityPlayerOnCollision`. The wrapper calls
`World1_TestPlayerMapCollisionAtOffset` and restores both pre-movement player
coordinates when the returned carry is set. The sampler combines player,
fine-scroll, coarse-camera, and caller-supplied offsets, decodes the map tile,
and classifies metatile IDs from `$42` upward as solid.

The metasprite advances through its two-bit animation frame every five active
updates. Positive `World1PlayerDamageState` values below 6 lock controls; the
recovery sequence ends at `$16`. A negative value is the separate death state.

### Underground movement

`World1_UpdateUndergroundPlayer` gives held left priority over held right and
uses `World1PlayerXSubpixel` to move 1.5 pixels per update: the integer X
coordinate always changes once and changes a second time on each `$80`
fractional carry or borrow. The same `$05-$EB` horizontal bounds apply as in
the city. Three probes at the leading wall edge cover Y offsets `$02`, `$0E`,
and `$19`; a collision restores the pre-movement X coordinate.

A new press of A (`$80`) calls `World1_StartUndergroundJump`, sets signed
vertical velocity to -24, marks the player airborne, queues sound `$12`, and
falls directly into `World1_IntegrateUndergroundVerticalMotion` for the first
physics update. Airborne updates add signed velocity divided by four to Y,
then add gravity 1 and clamp downward velocity to +24. Two X probes at offsets
`$04` and `$0A` test the ceiling at Y `$02` and the floor at Y `$1A`.
Ceiling contact aligns the player below the tile and clears velocity; floor
contact aligns to the fine-scroll grid, clears `World1PlayerAirborne`, and
returns to grounded movement. `World1_CheckUndergroundGroundSupport` runs the
same two floor probes while grounded and begins a zero-velocity fall when both
miss.

### Input edges and weapon firing

The frame input path retains `World1PreviousButtons` and computes
`World1PressedButtons` from changed bits that are currently held. Therefore
`World1_UpdateWeaponAndTryFire` reacts once to the `$40` fire edge rather than
repeating from a held button.

Firing requires a nonzero `World1WeaponLevel` and a free slot within the first
eight projectile slots, further limited by `World1ProjectileMaxSlot`. The
routine initializes type, position, metasprite, render flags, direction, and a
transient `$FF` source-object ID, then starts `World1WeaponPoseTimer` at 6.
The three level sounds and twelve direction-specific spawn profiles are
losslessly editable through `data/world1/weapons.json`; see
`docs/world1_formats.md`.

### Validated routines

| Routine | Address | Bytes | Direct calls |
| --- | ---: | ---: | ---: |
| `World1_UpdateCityPlayer` | `$856C` | 396 | 1 |
| `World1_RollbackCityPlayerOnCollision` | `$86F8` | 14 | 10 |
| `World1_UpdateWeaponAndTryFire` | `$9BFC` | 135 | 2 |
| `World1_TestPlayerMapCollisionAtOffset` | `$D1C3` | 44 | 13 |
| `World1_UpdateUndergroundPlayer` | `$CF7A` | 409 | 5 |
| `World1_CheckUndergroundGroundSupport` | `$D113` | 37 | 1 |
| `World1_StartUndergroundJump` | `$D138` | 13 | 1 |
| `World1_IntegrateUndergroundVerticalMotion` | `$D145` | 126 | 1 |

`config/reconstruction/world1/world1_player_controls.json` pins all 1,174 routine bytes, all 34 direct
callsites, sixteen state fields, city and underground movement constants, ten
city probes, twelve underground probes, the solid threshold, and weapon
timing. Run:

```text
make validate-world1-player-controls
```

## World 1 pseudorandom generators

PRG bank 0 contains two independent byte-producing pseudorandom routines.
Their RAM ranges, exact machine-code bodies, and every direct `JSR` occurrence
are fixed by `config/reconstruction/world1/world1_random.json` and checked by
`scripts/validation/world1/world1_random.py`.

| Routine | Address | State | Frame mixed | Direct calls |
| --- | ---: | --- | --- | ---: |
| `World1_FrameRandomByte` | `$962F` | `$0052-$0053` (`World1FrameRandomState`) | yes | 7 |
| `World1_RandomByte` | `$964A` | `$0054-$0057` (`World1RandomState`) | no | 18 |

`World1_FrameRandomByte` increments one state byte, decrements the other, and
mixes both with `FrameCounter`. Calls made with the same initial state can
therefore diverge on different frames. `World1_RandomByte` updates its four
state bytes without reading frame timing, so its output is determined by the
previous state alone.

Both ranges are cleared by the normal chapter initialization and explicitly by
the demo-entry path. The adjacent layout does not make them one six-byte
generator: neither routine accesses the other routine's state. The static
callsite totals describe exhaustive bank-wide `JSR` byte-pattern coverage,
not runtime invocation frequency.

Run the focused contract with:

```text
make validate-world1-random
```
