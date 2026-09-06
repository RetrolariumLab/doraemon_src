# Subsystems

## Common bank prefix

All banks expose reset at `$8098`, NMI at `$813C`, mapper switching at `$81BB`,
and the value table at `$8261`. NMI saves registers, gates re-entry through
`$15`, optionally performs OAM DMA, dispatches bank-specific frame work, polls
both controllers, and restores PPU shadows.

Runtime traces establish `$8271` as the top-level chapter entry and show `$8274`
and `$827A` called from NMI in every active bank. `$8277` is used both by the
World 1 attract path and by short calls into bank-3 presentation code. All
sixteen targets now have semantic names and a machine-checked relation to their
bank-local jump stubs.
For gameplay banks, the title's attract loop selects PRG 0, 1, or 2 through
`$8024/$802F/$803A`; the bank-local `$8277` gateways then enter
`World1_DemoEntry`, `World2_DemoEntry`, or `World3_DemoEntry`. Bank 3's `$8277`
remains a distinct callable presentation gateway.
The copied reset/NMI/PPU/mapper routines and all sixteen bank-local dispatch
stubs now have evidence-backed names; see `docs/common_runtime.md`.

## World 1 / bank 0

The bank owns the city and underground maps plus shared two-layer metatile
tables. It must support both top-down city movement and the underground
side-view mode, including door/manhole transitions.

The runtime-backed source path is now named:

```text
Bank0_World1Main
  -> World1_TryEnterAnywhereDoor
  -> World1_TryEnterManhole
       -> World1_EnterManhole
            -> Bank0_InitWorld1SideView
```

The A-button dispatcher distinguishes object type 2 (door) from type 1
(manhole). The tracked start-area scenario executes the manhole branch and
side-view initializer in that order while PRG0/CHR0 stays selected.
The city loop at `$82C1` and side-view loop at `$CE55` each execute exactly once
per emulated frame in their tracked scenarios; the latter begins only after the
accepted manhole transition and side-view initialization.

## World 2 / bank 1

The bank owns a 229-byte stage sequence, 119 standard compressed-screen
selectors, and shooter-specific code/data. Its token decoder expands sixteen
rows of at least fifteen cells; literal cells, runs, early row endings, and
enemy spawns share the same stream. Three overlapping 16-slot RTS tables drive
forward, reverse, and per-frame screen services. Automatic scrolling, player
flight, projectiles, and this screen pipeline form a chapter-specific
object/update system. Runtime reaches the bank-local main entry at `$88A4` and
then repeats the frame loop at `$8959` once per frame with PRG1/CHR1 selected.
The 119 selector views share one globally unambiguous 16,431-byte token pool;
its lossless authoring representation is described in
`docs/world2_streaming.md`.
The stage terminates with a stopped `$7F` sentinel. Its adjacent 26-byte bitmap
classifies all 208 metatiles for collision, and that bitmap is editable alongside
the palette and CHR-tile fields.

## World 3 / bank 2

The embedded build string identifies this bank explicitly as world 3. It owns a
separate 64x64 map and metatile hierarchy. Bank-local NMI dispatch jumps to the
high `$AFxx` region, confirming a different frame implementation.
The `$8271` dispatch jumps across the build string to the runtime-proven main
entry at `$82F6`; after initialization, execution repeats the frame loop at
`$838E` once per frame with PRG2/CHR2 selected.

## Shell and presentation / bank 3

This bank contains title text, item names, the long ending credit stream, and
common presentation material. RESET execution is expected to begin here on
power-on, but every bank retains compatible vectors for interrupt safety.
The recovered `$8A88` ending entry initializes the credits pointer to `$BDBC`;
runtime reaches its `$8B18` scroll loop through the World 3 completion gateway.

## Audio / all four banks

The shared audio driver begins at `$982A`. Requests 0-25 are accepted through
`$02A0`; the table at `$9784` maps each request to an even dispatch index and
therefore also acts as its priority. The per-frame routine at `$983B` services
four effect timers at `$02A3-$02A6`, then dispatches by pushing a little-endian
address from `$979E` and returning through `RTS`. The table contains 52 slots
and 44 unique destinations; its stored values are one less than their actual
entry addresses because `RTS` increments the pulled address.

The recovered handlers write the pulse 1, pulse 2, triangle, and noise APU
registers. Music state is separate at `$02AA-$02FF`: `$9EAB` resets channel
registers, `$9ED8` advances the music driver, and `$A301` reads stream bytes.
The per-channel interpreter at `$9FE7` treats `$EF-$FF` as commands. It indexes
the 17-entry table at `$A017` with `2 * ($FF - command)` and uses the same
target-minus-one RTS dispatch as the effect driver. All 17 commands now have
structural names and explicit operand widths derived from their state changes
and control flow. The shared four-channel ABI covers 92 bytes of duration,
event, envelope, fixed-pitch, loop, call, and stream-pointer state.

World 3 carries a relocated, non-identical copy at `$BE90-$CAxx` in bank 2.
It preserves the same 26-value priority table, 52-slot effect dispatch, and 17
commands. Its exclusive track-ID limit is nine, yielding eight playable tracks
instead of bank 3's four. Its effect table is at `$BE28`, its command table at
`$C634`, and its stream reader at `$C91E`.

World 2 has a smaller local variant in bank 1. It accepts 15 requests through
the priority table at `$A80B` and dispatches 30 effect slots from `$A81A` to 25
unique handlers. Its 17 music commands use the table at `$AE23`, its stream
reader is at `$B10D`, and track IDs 1-6 are playable.

World 1 carries the fourth driver in bank 0. It restores the 26-request and
52-slot shape, with its priority table at `$E316`, effect table at `$E330`, and
38 unique effect handlers. The music command table is at `$EB3C`, the stream
reader at `$EE26`, and track IDs 1-8 are playable. Across the four banks, ID
zero stops music and the playable counts are eight for World 1, six for World
2, eight for World 3, and four for the shell. All copies are validated
independently; shared structure does not imply byte identity or a callable
cross-bank sound service.

`config/audio_dispatch.json` records the complete indirect edge set, while
`make validate-audio-dispatch` proves the ROM tables and Ghidra seed registry
remain synchronized. `config/audio_effects.json` joins all 93 effect requests
to 26 structural synthesis roles and all 145 unique handlers, including their
timer leases, APU writes, shared updates, and no-lease exceptions. Every audio
effect indirect entry and all sixteen bank-local effect helpers now have an
evidence-backed source symbol.
`config/audio_music.json` and `docs/audio_music.md` record the shared command
grammar and RAM ABI; `make validate-audio-music` verifies all 68 bank-local
command targets and the common helper contracts. The state-aware
`make validate-audio-streams` gate additionally proves all 26 headers and
10,016 header-reachable stream bytes round-trip losslessly.

## Object storage and lifecycle

World 1 uses one 48-slot structure-of-arrays split into four traversal classes:
slots 0-9, 10-29, 30-37, and 38-47. Each class has a dedicated clear and render
routine, while signed X/Y stepping and metasprite composition are shared. The
field layout and exact capacities are recorded in `docs/ram_fields.md`.
City entity types `$03-$0D` select eleven interaction handlers through the
ordinary pointer table at `$CBF4` and `JMP ($0000)` at `$C9DD`; this table is
also covered by the object-dispatch manifest.

The ten actively updated city slots use a separate low-state dispatcher at
`$88A7`. It masks the entity type to five bits and uses a 16-slot
target-minus-one table beginning at `$88FB`, followed by the standard
`PHA`/`PHA`/`RTS` idiom. The state-zero entry deliberately overlaps the operand
of the preceding `JMP $88A1` and resolves to the inactive loop tail at `$88A2`;
active states `$01-$0F` reach thirteen unique handlers. Those table targets also
recover the previously opaque behavior code at `$DBDA-$E315` and its shared
motion and collision helpers at `$9065-$95CA`.

City and underground objects share three-byte X-cell/Y-cell/type placement
records at `$D989` and `$D925`. Camera-edge scans preserve the zero-based record
index as the persistence ID. Nonnegative types enter slots 0-9 and dispatch
through eight spawn initializers at `$8DA4`; high-bit types enter slots 38-47
through a 13-entry descriptor table at `$CC0A`. Its runtime type, metasprite,
render flags, and primary behavior fields are joined to the placement encoding,
the transient selector table, and five collision-extent tables. The exact 145
placements and all descriptor contracts are validated by
`config/object_placements.json`; see `docs/world1_descriptors.md`.

World 2 uses three smaller pools: seven enemies, six enemy projectiles, and
seven player projectiles. Its main frame path independently updates the enemy
and player-projectile pools, and initialization clears all three active fields.
Enemy records are embedded directly in compressed screen streams: token values
`$D0-$EE` become the new enemy state while the decoder emits an empty map cell.
Across the 119 standard selectors, the decoder encounters 738 such spawn
tokens. This ties enemy materialization to scrolling rather than to a separate
fixed-size placement list.
The overlapping screen views contain 685 unique physical spawn-token bytes,
all in `$D0-$DE`. The delayed spawn path maps them exactly to states `$01-$0F`;
five further states `$10-$14` arise internally. Three 21-slot property tables
provide attack periods, damage thresholds, and score reward codes across the
complete state domain.
Enemy states use overlapping target-minus-one tables: rendering indexes a base
at `$A548` (reachable states `$01-$14` begin at `$A54A`), while updating indexes
21 slots at `$A570`. The shared bytes at `$A570-$A571`, 36 unique destinations,
and manually pushed continuations `$A355` and `$9965` are validated and supplied
as static-analysis entry points by `config/object_dispatch.json`.

World 3 separates eight active entities from thirteen persistent room-object
records. Room entry materializes matching records into free active slots; room
updates dispatch through a 32-slot type table at `$92DF`. Random spawns have a
separate 16-slot initializer table at `$8F6C`, and the player uses five state
handlers at `$A22F`. All three ordinary pointer tables call through the shared
`JMP ($0040)` trampoline at `$931F` and are covered by the object-dispatch
manifest. Room exit saves coordinates and state back through two state-class
passes. This is a different ownership model from both earlier chapters, not a
shared object engine hidden behind different data.

The thirteen-record registry begins as a 65-byte ROM image at `$D96B`: five
parallel room/type/X/Y/state arrays are copied directly to `$06B0-$06F0`.
Initialization then shuffles types in a four-slot group and an eight-slot group
without moving rooms or coordinates; the final slot retains type `$1F`.
`config/world3_object_data.json` validates this bootstrap representation and
the adjacent sixteen-entry behavior-stream pointer table.

Types below `$10` additionally select a behavior stream through the pointer
table at `$D9AC`. Its sixteen targets span the packed stream region
`$D9CC-$DDF1`. `World3_RunEntityBehaviorScript` decodes the command high
nibble, while the low nibble and following bytes control motion, delays,
direction, loops, branches, position, animation variants, and termination.
The per-entity script offset, wait/rate counters, directions, loop state, HP,
render flags, and persistence field are named in the complete active-pool RAM
grid. Recursive control-flow decoding accounts for all 1,062 stream bytes as
532 instructions; the exact opcode contract and editable form are documented
in `docs/world3_behavior.md`.

Five contiguous 32-byte columns at `$8EB5-$8F54` provide the per-type hit
points, base metasprite, render flags, contact damage, and score reward code.
`config/world3_entity_types.json` joins those columns to all three type-indexed
dispatch views and proves a complete four-domain partition of `$00-$1F`.
The catalog and its encoded type transformations are documented in
`docs/world3_entity_types.md`.

Those type bases feed a 188-entry metasprite index at `$B6D7`. Direct entries
point into 65 contiguous variable-length records, while a high byte below four
encodes an alias and reflection mode. The same renderer serves the player,
projectiles, and all entity domains. Eleven 32-byte palette sets and their
64-room selectors complete the World 3 sprite presentation contract; see
`docs/world3_metasprites.md`.
