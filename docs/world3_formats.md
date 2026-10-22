# World 3 Data and Entity Formats

This chapter joins the behavior bytecode, entity types, persistent and transient
object records, spawn initializers, update-handler data, metasprites, and
palettes used by World 3.

## Contents

- Behavior bytecode and entity identities
- Persistent objects and transient schedules
- Spawn initializers and update handlers
- Metasprites and palettes

## World 3 behavior bytecode

Entity types `$00-$0F` select one of sixteen streams through the pointer table
at bank 2 `$D9AC`. The interpreter at `$9A3B` uses the high nibble as the
command and retains the low nibble as an inline parameter. Stream-local jump
operands are absolute eight-bit offsets from the selected stream base.

### Commands

| High nibble | Size | Operation |
| --- | ---: | --- |
| `$0n` | 1 | Move horizontally by `n`, using the current horizontal direction |
| `$1n` | 1 | Move horizontally by `n`, reversing the direction interpretation |
| `$2n` | 1 | Move vertically by `n`, using the current vertical direction |
| `$3n` | 1 | Move vertically by `n`, reversing the direction interpretation |
| `$4n aa` | 2 | Jump to stream offset `aa`; `n` is ignored |
| `$5n tt` | 2 | Wait for the `tt` countdown; `n` is ignored |
| `$6n` | 1 | Set the packed execution-rate counter to `n` |
| `$7n` | 1 | Set or randomize direction flags, then continue in the same frame |
| `$80 cc` | 2 | Load loop count `cc` and save the following offset as the loop body |
| `$81-$8F` | 1 | If the loop count is nonzero, decrement it and return to the saved body |
| `$9n xx yy` | 3 | Add direction-adjusted X/Y deltas; `n` is ignored |
| `$An xx yy` | 3 | Set absolute X/Y and clear the activation timer; `n` is ignored |
| `$Bn` | 1 | Write `n` to the two-step metasprite variant field |
| `$C0 pp aa` | 3 | Branch to `aa` when random value is at least threshold `pp` |
| `$C1 aa` | 2 | Branch to `aa` when entity X is at least player X |
| `$C2 aa` | 2 | Branch to `aa` when entity Y is at least player Y |
| `$C3-$CF pp aa` | 3 | Same random-threshold form as `$C0` |
| `$Dn vv` | 2 | Set the follow-anchor flag to `vv`; `n` is ignored |
| `$En` | 1 | Toggle the one-step metasprite variant; `n` is ignored |
| `$F0` | 1 | Stop interpreting without deactivating the entity |
| `$F1-$FF` | 1 | Stop and deactivate the entity unless its active state is four |

The loop end tests the count before it decrements it, so `cc` is the number of
extra passes: `$80,$00,<body>,$81` runs the body once and `$80,$01,<body>,$81`
twice. Loops do not nest; one count and one saved offset serve the entity.

Direction command parameters `$70` and `$71` randomize the horizontal and
vertical flags respectively. `$78` clears both; `$79` sets horizontal; `$7A`
sets vertical. Other observed/default parameters set both flags.

Movement commands `$0n-$3n` perform collision probes before applying their
delta. Reaching the chapter bounds or a blocked tile flips the relevant
direction flag; horizontal motion also toggles the two-step metasprite variant.

### Static control-flow proof

The sixteen streams occupy `$D9CC-$DDF1` and range from one to 248 bytes, so
all local offsets fit in one byte. Recursive decoding starts at offset zero,
follows `$4n` jumps and both successors of `$Cn` branches, and classifies every
opcode and operand byte. The canonical payload yields:

- 532 decoded instructions;
- 1,062 covered bytes with no gaps or overlaps;
- 42 conditional branches;
- 12 stop instructions;
- no branch or jump into an operand or outside its stream.

Commands `$1n` and `$5n` are implemented by the interpreter but absent from the
reachable canonical streams.

### Editing

The Studio edits every stream as `world3-behavior`
(`doraemon.world3-behavior.v1`): instruction records with offsets, opcodes,
command names and operands, 1,062 bytes in all. It refuses wrong operand
counts, overlaps, uncovered bytes, invalid control-flow targets and
instruction boundaries that would move.

## World 3 entity types

World 3 uses one byte-valued type domain `$00-$1F` across its eight active
entity slots. The type selects per-type properties and the 32-slot update
handler table at `$92DF`. Types below `$10` additionally select both a random
spawn initializer at `$8F6C` and a packed behavior stream at `$D9AC`.

### Per-type property columns

| CPU range | Source label | Runtime use |
| --- | --- | --- |
| `$8EB5-$8ED4` | `World3_EntityHitPointsByType` | copied into a newly spawned entity's damage countdown |
| `$8ED5-$8EF4` | `World3_EntityMetaspriteByType` | base metasprite selected during spawn, materialization, and type changes |
| `$8EF5-$8F14` | `World3_EntityRenderFlagsByType` | ORed into the per-entity renderer flags |
| `$8F15-$8F34` | `World3_EntityContactDamageByType` | subtracted from player health on contact |
| `$8F35-$8F54` | `World3_EntityScoreRewardCodeByType` | passed to the score updater after defeat or collection |

Each column has exactly 32 entries, so the same type index can be used without
bounds conversion. The symbol registry marks only these proven PRG data labels
as operand symbols; the deterministic generator therefore emits symbolic
indexed loads while leaving unrelated numeric PRG operands untouched.

### Lifecycle domains

| Types | Evidence-backed role |
| --- | --- |
| `$00-$0F` | Scripted spawn types with 16 initializer slots and 16 behavior-stream pointers |
| `$10-$13` | Possible post-defeat results of low types `$00-$04` |
| `$14-$1B`, `$1F` | Types present in the thirteen-record initial persistent registry |
| `$1C-$1E` | Persistent results produced from `$14-$16` by adding eight |

The post-defeat conversion is encoded at `$91F1`: after a random value is
masked to `0-3`, the code adds `$10` and stores the result as the new type. It
is reached only for dying types below `$05`.

The persistent conversion at `$987E` adds eight to a nearby type in the
`$14-$16` range and writes the result to both the persistent registry and the
active entity. Thus the three paired transitions are `$14->$1C`, `$15->$1D`,
and `$16->$1E`.

### Recovered identities

The type byte is a behavior class, not always a single visual identity. Three
low types select a stronger or region-specific form while preserving the same
type: `$00` is either Kame or Battle Fish, `$01` is Kani or Otoshigo, and `$03`
is Gyokkun or the castle-only Gansuke. The initializer's alternate metasprite
indexes `$A4`, `$A8`, and `$B4` establish those pairings.

| Type | Identity | Structural evidence |
| --- | --- | --- |
| `$00` | Kame / Battle Fish (`カメ / バトルフィッシュ`) | base `$10`, initializer alternate `$A4` |
| `$01` | Kani / Otoshigo (`カニ / オトシゴ`) | base `$14`, initializer alternate `$A8` |
| `$02` | volcanic rock (`火山弾`) | fixed spawn and metasprite `$18` |
| `$03` | Gyokkun / Gansuke (`ギョックン / ガンスケ`) | base `$1C`, castle-room alternate `$B4` |
| `$04` | skull (`ガイコツ`) | metasprite `$20`, castle tracking path |
| `$05` | ghost (`ユーレイ`) | metasprite `$24`, delayed capture/relocation path |
| `$06` | punishment-room dorayaki/skull swarm (`おしおき部屋`) | 20-treasure warp to room `$12`, 250-spawn schedule, damaging `$20` skulls, collectible `$40` dorayaki, 20-dorayaki exit |
| `$07` | Genki Candy (`元気キャンディ`) | candy graphic, two flag-gated fixed placements |
| `$08-$09` | giant-octopus tentacle tip and segment (`大ダコ`) | two four-part formations; only `$08` has hit points |
| `$0A-$0B` | dragon head and body (`ドラゴン`) | one head plus seven circular body segments |
| `$0C-$0F` | four Poseidon quadrants (`ポセイドン`) | corner formation, linked movement, four matching graphics |
| `$10-$13` | stopwatch, dorayaki, diamond, gold bar | exact item graphics and post-defeat result domain |
| `$14-$16` | Nobita, Suneo, and Gian chests | key path transforms them to `$1C-$1E` by adding eight |
| `$17` | dragon chest | key path removes it and seeds the `$0A/$0B` formation |
| `$18-$1B` | talisman, Passing Hoop, key, Holding Bag | graphics match roles: reward, terrain, chest conversion, carrying |
| `$1C-$1F` | Nobita, Suneo, Gian, Shizuka | character graphics and persistent follow-player path |

All rows converge between local graphics/control flow and at least one
published guide. Type `$06` deliberately keeps a descriptive name rather than
inventing a standalone character name. Two guides describe the same forced
punishment-room event, and the ROM proves the complete chain: diamond/gold
types `$12/$13` increment a counter, 20 pickups force room `$12`, its only
active schedule emits type `$06`, `$20` is the damaging skull branch, `$40` is
the collectible dorayaki branch, and collecting 20 dorayaki exits. The
machine-readable catalog records the evidence sources, forms, Japanese names,
confidence, and chest-to-companion links for every type.

### Evidence

The types have five property columns, 16 initializer pointers, 16 behavior
pointers, 32 update pointers, four nonoverlapping lifecycle domains and both
encoded type transformations. Three code relationships tie the punishment-room
entry, the type `$06` collision split and the exit conditions together. A
confirmed identity cites both local-ROM evidence and an external source.

## World 3 metasprites and palettes

World 3 renders the player, projectiles, transient entities, and persistent
objects through one metasprite catalog. The renderer at `$B4B6` consumes an
index in `$79`, resolves a two-byte entry at `$B6D7`, and appends ordinary
four-byte NES OAM records through `$B6BA`.

### Index encoding

The index contains 188 entries for values `$00-$BB`.

| Encoded high byte | Meaning |
| --- | --- |
| `$04-$FF` | little-endian direct pointer to a metasprite record |
| `$00-$03` | alias: low byte is another index and high byte is the flip mode |

Flip mode 0 draws normally, 1 mirrors horizontally, 2 mirrors vertically, and
3 mirrors on both axes. The canonical table contains 130 direct entries and 58
horizontal aliases. It references 64 distinct record addresses.

Alias resolution is deliberately one level deep. Index `$07` points to index
`$04`, which is itself an alias; no proven runtime base or variant selects
`$07`.

All 32 base indexes in the entity-type catalog resolve directly. Animation
adds the per-entity zero-to-three variant fields after selecting that base, so
direct and alias entries share one index namespace.

### Variable-length records

`$B84F-$BCAD` holds 65 contiguous records. Each record starts with:

| Byte | Meaning |
| --- | --- |
| 0 | number of sprite pieces |
| 1 | X extent used by horizontal reflection |
| 2 | Y extent used by vertical reflection |

The header is followed by `count` triples in Y-offset, X-offset, CHR-tile
order. Bit 7 of either coordinate becomes the matching NES OAM flip bit after
the renderer strips it from the coordinate. The record histogram is one
two-piece record, 39 four-piece records, and 25 six-piece records. Together
they reference 235 distinct CHR tile indexes.

The direct index targets every record except `$B8CD`. That complete but
unreferenced record remains part of the editable catalog and is protected by
the same round-trip checks.

### Palette selection

Eleven complete 32-byte PPU palettes occupy `$BCAE-$BE0D`. The 64-byte table at
`$ADD2` selects one palette per room. `World3_LoadRoomPalette` multiplies the
selector by 32, adds `$BCAE`, and copies the full result to the palette staging
buffer at `$0705-$0724`. Every selector is in `$00-$0A`; final rooms use palette
10 at `$BDEE`, which the transition path can also upload directly.

### Editing

The Studio edits the index entries, record headers, piece coordinates and tile
numbers as `world3-metasprites` (`doraemon.metasprites.v1`), the room palette
selectors as `world3-room-palette-selectors` and the palettes as
`world3-palette-00` to `world3-palette-10`. The four physical ranges hold
1,911 bytes; all 188 indexes keep their direct-pointer and alias partition.

## World 3 object catalog

World 3's static object data uses two independent structure-of-arrays layouts in
PRG bank 2.

### Persistent registry

The 65 bytes at `$D96B-$D9AB` are five consecutive thirteen-byte columns:

| Column | ROM range | Record field |
| --- | --- | --- |
| room | `$D96B-$D977` | owning room ID |
| type | `$D978-$D984` | initial persistent type |
| X | `$D985-$D991` | saved horizontal position |
| Y | `$D992-$D99E` | saved vertical position |
| state | `$D99F-$D9AB` | initial persistence/materialization state |

The authoring encoder transposes thirteen records back into these columns.

### Entity type properties

Each of the 32 records has five byte-valued properties. Encoding transposes the
records into the contiguous property columns at `$8EB5-$8F54`:

| Property | ROM range |
| --- | --- |
| hit points | `$8EB5-$8ED4` |
| base metasprite | `$8ED5-$8EF4` |
| render flags | `$8EF5-$8F14` |
| contact damage | `$8F15-$8F34` |
| score reward code | `$8F35-$8F54` |

### Commands

## World 3 spawn initializers

Every transient type `$00-$0F` indexes a little-endian pointer at `$8F6C`.
`World3_InitializeSpawnedEntity` clears the new entity's behavior selector and
calls that target through the shared indirect trampoline. The initializer can
adjust appearance, replace the generic random placement with fixed coordinates,
disable the entity, or expand it into a multi-object formation.

### Initializer roles

| Type | Target | Structural role |
| ---: | ---: | --- |
| `$00` | `$8F8C` | selects Kame or Battle Fish graphics by region/randomness |
| `$01` | `$8FA3` | selects Kani or Otoshigo graphics and render flags |
| `$02` | `$8FBF` | fixes a volcanic rock at `$80,$98`, state 1, with optional sound |
| `$03` | `$8FDB` | selects Gyokkun or the castle-room Gansuke metasprite |
| `$04` | `$9028` | gives a skull a one-unit clone budget |
| `$05` | `$902E` | ghost no-op initializer |
| `$06` | `$902F` | selects the punishment-room swarm's collectible dorayaki or damaging skull form |
| `$07` | `$9044` | fixes Genki Candy at `$B0,$A8` in gated rooms `$26/$3B` |
| `$08` | `$9071` | creates a giant-octopus formation in rooms `$27/$28/$34` |
| `$09` | `$90AA` | octopus-segment no-op; not directly scheduled |
| `$0A` | `$90AB` | expands the dragon head/body formation |
| `$0B` | `$90AE` | dragon-segment no-op; not directly scheduled |
| `$0C` | `$90AF` | expands Poseidon into four quadrant objects |
| `$0D-$0F` | `$90B2` | Poseidon-part no-op target; not directly scheduled |

Types `$09`, `$0B`, and `$0D-$0F` retain initializer entries because group
initializers create them and the dispatch table covers the complete low-type
domain. Function names preserve the numeric ID while appending the recovered
identity, for example `World3_InitTransientType0CPoseidon`.

The room schedule directly activates eleven types: `$00-$08`, `$0A`, and `$0C`.
Their active room/channel record counts are 20, 13, 3, 8, 33, 45, 1, 2, 3, 3,
and 1 respectively. Their corresponding byte-count budgets total 140, 98, 300,
78, 197, 45, 250, 2, 3, 3, and 1.

### Formation data

Four non-contiguous regions belong to the initializer system:

| Region | Range | Layout |
| --- | --- | --- |
| Gansuke room selector | `$8FE8-$9027` | 64 one-byte boolean flags |
| Poseidon formation | `$90F4-$9103` | 4 records: state, X, Y, type |
| dragon formation | `$AC6C-$AC8B` | 8 records: state, X, Y, type |
| giant-octopus formation | `$ACF9-$AD20` | 8 records: state, X, Y, type, frame counter |

The type `$0C` initializer replaces its initially allocated slot and then
allocates up to three more, producing types `$0C-$0F` at the four corners
`($28,$30)`, `($D8,$30)`, `($28,$C0)`, and `($D8,$C0)`.

The type `$0A` initializer fills all remaining slots from its eight-entry
type `$0A/$0B` table. The type `$08` initializer requires a low enough free-slot
index, then emits one or two four-entry groups from its type `$08/$09` table and
records each group's ending slot as a collision scan bound.

### Editing

The Studio edits the 64 type-`$03` room flags as a column of `world3-rooms`
and the three formations as `world3-type0c-formation`,
`world3-type0a-formation` and `world3-type08-formation`
(`nes.record-table.v1`), 152 bytes in all.

## World 3 transient spawn schedules

World 3 stores its ordinary room-driven transient entities in twelve contiguous
64-byte columns at bank 2 `$D66B-$D96A`. Each room has four independent
channels. A channel record consists of an entity type, a successful-spawn
budget, and a delay value; a zero count disables that channel even when its
type or delay bytes are nonzero.

| Physical columns | CPU range | Meaning |
| --- | --- | --- |
| type 0-3 | `$D66B-$D76A` | type passed to the 16-entry spawn initializer table |
| count 0-3 | `$D76B-$D86A` | number of successful allocations before completion |
| delay 0-3 | `$D86B-$D96A` | initial and recurring delay |

The complete region is 768 bytes with CRC32 `019b7efd`. It ends immediately
before the persistent room-object registry at `$D96B`.

### Runtime scheduling

`World3_ClearEntityStorage` clears
`World3TransientSpawnScheduleLoaded` during room materialization. On the next
frame, `World3_UpdateTransientSpawns` indexes every ROM column by the current
room, copies the twelve values to zero page, saves each delay as its reload
value, and clears the four completion flags.

All four channels are then visited each frame. A nonzero delay uses a
modulo-four phase counter, so its countdown changes once per four scheduler
calls. When the countdown reaches zero, it is reloaded before allocation is
attempted. If no active-entity slot is free, the budget is not consumed and a
nonzero-delay channel waits through the newly reloaded interval. A zero-delay
channel bypasses the prescaler and retries every frame.

The four phase counters are deliberately not cleared by the room-load path. They
retain their cadence across rooms.

After a successful allocation the routine:

1. clears one slot across all 22 parallel active-entity fields;
2. sets its activation timer to 30, state to 2, and X/Y to `$FF`;
3. copies the scheduled type and its type-derived hit points and metasprite;
4. calls the type-indexed initializer at `$8F6C`;
5. decrements the channel budget and marks it complete after the last spawn.

All canonical scheduled types are `$00-$0C`, within the initializer table's
16-entry `$00-$0F` domain. Type zero is a real entity type; only a zero count
means an inactive room/channel pair.

### Canonical schedule

The original ROM activates 132 room/channel pairs across 62 of 64 rooms. Their
per-channel active counts are 54, 6, 27, and 45, with cumulative spawn budgets
of 874, 66, 132, and 45. Three active channel-zero records use delay zero. The
large budgets, including 100 and 250, are byte values and are preserved without
interpreting them as a different encoding.

The tool also provides `decode` and `encode` subcommands for controlled edits.

## World 3 entity update handlers

`World3_UpdateEntities` walks eight active slots. Types below `$10` first run
their packed behavior stream; every type `$00-$1F` then indexes the 32-pointer
table at `$92DF`. The table has 19 unique addresses and 17 evidence-backed
structural roles.

### Low scripted types

| Types | Update role |
| --- | --- |
| `$00-$03` | ordinary enemies/hazard; state 4 follows the active ghost |
| `$04` | skull movement toward the player in enabled rooms every fourth update |
| `$05` | ghost captures an eligible object and can relocate persistent targets between rooms |
| `$06-$07` | punishment-room dorayaki/skull swarm and Genki Candy behavior scripts only |
| `$08` | updates the linked giant-octopus tentacle chain |
| `$09` | octopus segment behavior script only |
| `$0A` | updates the dragon head/body encounter chain |
| `$0B` | dragon body behavior script only |
| `$0C` | Poseidon anchor; follows its target and may emit volcanic rocks when two slots are free |
| `$0D` | follows the Poseidon anchor at X + `$10` |
| `$0E` | follows the Poseidon anchor at Y + `$18` and animates |
| `$0F` | follows the Poseidon anchor at X + `$10`, Y + `$18` and animates |

The type `$04` tracking flag is enabled in eight rooms. Type `$05` uses the
four signed motion vectors `(2,2)`, `(-2,2)`, `(2,-2)`, and `(-2,-2)` while it
holds a state-4 target. When that target is persistent and type `$05` leaves
the room bounds, the handler chooses a neighboring or random destination not
blocked by its 64-room mask, then writes the target's room and fresh coordinates
back to the persistent registry.

### Result and persistent types

| Types | Update role |
| --- | --- |
| `$10-$16` | static post-defeat results |
| `$17` | static dragon chest |
| `$18` | talisman completes a dragon encounter and removes its room marker |
| `$19` | Passing Hoop checks a terrain trigger and updates a vertical room column |
| `$1A` | key opens `$14-$16` companion chests or seeds a dragon from `$17` |
| `$1B` | Holding Bag pushes nearby enabled persistent objects |
| `$1C-$1F` | Nobita, Suneo, Gian, and Shizuka face/follow the player when enabled |

Several persistent handlers share `World3_PositionEnabledPersistentEntity`,
which pins an enabled object beside the player with a small vertical animation.
State 4 consistently routes through `World3_FollowActiveGhost`, tying the
persistent and low-type dispatch domains to the type `$05` capture mechanic.

### Handler data

Three non-contiguous data ranges belong to these updates:

| Range | Contents |
| --- | --- |
| `$936C-$93AB` | 64 type-`$04` tracking-enable flags |
| `$93E7-$93EE` | four type-`$05` signed X/Y held-motion vectors |
| `$9550-$958F` | 64 type-`$05` relocation-blocked flags |

Each flag is `$00` or `$01`. The Studio edits the two flag tables as columns
of `world3-rooms` and the motion vectors as `world3-type05-motion` (both
`nes.record-table.v1`).
