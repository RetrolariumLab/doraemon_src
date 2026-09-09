# World 3 Runtime

This chapter joins the frame, room, player, interaction, entity, formation, rendering, transition, and PPU-queue contracts that cooperate in the World 3 gameplay loop. Machine-readable routine ranges and RAM ownership remain authoritative in `config/reconstruction/world3/`.

## Contents

- Frame, player, and interaction paths
- Room and transition transactions
- Entity and formation updates
- Rendering, PPU queueing, and dormant code

## World 3 collision and rendering

`config/reconstruction/world3/world3_collision_rendering.json` fixes all twenty-two formerly
address-named routine entries in `object_scripts_2.asm`. The exact contract
covers 808 executable bytes, 50 direct calls or tail jumps, and twenty
Bank 2-private RAM symbols covering 21 bytes.

The collision convention is now explicit: carry set means the sampled edge is
passable, while carry clear rejects movement or turns a projectile into its
impact state. Player probes sample three points on each vertical edge and two
points on each horizontal edge. Entity probes sample two points and treat tile
ID `$01` differently from the player. The player path additionally enables
state-dependent openings for:

- the freed companions in final room `$3C`;
- the active Passing Hoop portal;
- defeated formations in rooms `$27`, `$28`, and `$34`.

The rendering half pins forward/reverse entity traversal, one-slot state and
metasprite composition, the complete 15-byte metasprite/OAM workspace, and the
deliberate one-byte no-op hook at `$9DCD`. Scratch coordinates shared with
unrelated routines remain numeric.

Run:

```text
make validate-world3-collision-rendering
```

## World 3 dormant code islands

Bank 2 contains several instruction-aligned islands that are not reached by
the current static call graph. They are reconstructed as code because each is
a complete legal 6502 control-flow unit bounded by existing routines, uses the
same RAM and helper conventions as neighboring live code, and terminates or
falls through coherently. `Dormant` in every public label records the missing
reachability evidence; it does not claim that the retail game executes the
routine.

| Range | Label | Structural evidence |
| --- | --- | --- |
| `$864D-$866B` | `World3_DormantUpdateState55ForRoomBands` | Alternating room-number bands conditionally write `$14` to `$0055`, then return. |
| `$9A35-$9A3A` | `World3_DormantDeactivateEntity` | Clears the current slot's state at `$0600,X` and returns. |
| `$9DCE-$9DE4` | `World3_DormantFaceType03TowardPlayer` | For type `$03`, selects metasprite offset zero or two from relative player X, then returns. The live renderer calls the one-byte RTS stub immediately before it at `$9DCD`. |
| `$9F9F-$9FD6` | `World3_DormantProbeEntityLowerEdge` | Two-column terrain probe using the neighboring collision helpers, with the same saved-X and carry-result convention as the live probes around it. |
| `$B137-$B148` | `World3_DormantAbsoluteValue16` | Returns the absolute value of the signed 16-bit `A:X` input. |
| `$B189-$B1B6` | `World3_DormantRandomByte` | Duplicates the live three-byte pseudorandom-state update with an otherwise unused `$D9-$DB` state. |
| `$B1B7-$B1BA` | `World3_DormantWaitFramesFromParameter` | Copies zero-page `$00` to the frame wait counter and falls through into the live wait loop. |
| `$B1C2-$B1F0` | `World3_DormantUpdateControllerRepeat` | Calls its internal `$B1D1` lane helper for both controller-1 serial bytes; held input repeats after eight frames and then every four frames. |
| `$B32D-$B339` | `World3_DormantQueuePpuBlockFromParameters` | Converts X/Y parameters to a PPU address, restores source-pointer and length parameters, and falls through into the live block queue writer at `$B33A`. |
| `$B371-$B39C` | `World3_DormantQueuePpuByteFromParameters` | Converts X/Y parameters and appends one address/length/data record to the PPU queue. |
| `$B39D-$B3F2` | `World3_DormantQueueAttributeFromParameters` | Computes the attribute address and quadrant, replaces its two palette bits in the RAM shadow, and queues the resulting byte. |

The final helper uses three four-byte tables at `$B3F3-$B3FE`. The first table
is not dormant: the live `$B2FD` attribute-fill path also indexes its expanded
palette values. The other two hold the clear and select masks for the four
attribute quadrants.

No absolute `JSR`, `JMP`, or table pointer to the top-level dormant entries is
present in the canonical PRG0 image. This remains a static conclusion: a later
trace, computed jump, or self-modifying call-site discovery can promote an
entry from dormant without changing its reconstructed bytes.

## World 3 entity runtime

`config/reconstruction/world3/world3_entity_runtime.json` fixes ten formerly address-named World 3
entity-lifecycle helpers. The exact contract covers 545 executable bytes,
17 direct calls or tail jumps, and seven already established Bank 2-private
RAM fields. A 64-entry room table now names the horizontal clamp policy used
for persistent objects during room load.

The persistent-object path consumes the Passing Hoop flag carried from World
2, finds its type `$19` registry record, and materializes it at the player in
room zero. Room loading applies one of two safe horizontal clamps to mid-height
persistent objects in the eight paired edge rooms. During transitions, an
enabled Holding Bag can move one other persistent record into the target room
only while fewer than two persistent objects already occupy it.

The combat lifecycle now exposes the type `$04` skull split. A successful hit
allocates a free entity slot, copies the source runtime record with randomized
four-pixel offsets, and halves the behavior selector in both source and clone.
The stopwatch helper owns its full 240-frame lifetime, emits an effect every
eight frames, and releases the audio/entity freeze when it expires.

Both coordinate samplers have exact ranges: X is `$20-$CF` and Y is
`$30-$AF`. The combined spawn-position selector rejects all four terrain-edge
probes and candidates closer than 24 pixels to the player on both axes. The
Passing Hoop boundary helper separately probes tile `$26` at the left and right
room edges, then converts the matching pixel coordinate into an eight-row PPU
opening using the shared blank-barrier row.

Run:

```text
make validate-world3-entity-runtime
```

## World 3 formation runtime

`config/reconstruction/world3/world3_formation_runtime.json` fixes thirteen formerly address-named
World 3 formation, chain-motion, and encounter helpers. The exact contract
covers 679 executable bytes and 28 direct calls. It also checks twelve
established RAM fields and names six formation-specific scalar fields plus the
64-room encounter exclusion mask.

The type `$08/$09` giant-octopus formation occupies contiguous active slots.
Its head stores the slot limit for the tentacle, while each following segment
is rate-gated and stepped toward the nearer adjacent anchor on each axis. The
player-side anchor stays 14 pixels toward the head; the terminal anchor uses X
`$80` and Y `$68` or `$80` according to the head slot.

The two generic coordinate helpers move the `$3C/$3D` work position by one
pixel toward X/Y register targets. Their direct-call contract covers skull,
Poseidon, Holding Bag, octopus, and dragon users rather than treating them as
octopus-private helpers.

The eight-slot encounter-room list moves toward the player's current room one
random occupied entry at a time. Candidate row and column steps are committed
only when the 64-room mask permits them and no duplicate already exists. On
room load, a matching entry reserves a free active slot and falls into the
fixed type `$0A/$0B` dragon-formation builder.

The dragon head alternates between pursuing the player and randomized target
coordinates. Its contiguous type `$0B` segments follow their predecessor when
either axis separates by at least six pixels. The formation head slot and X/Y
offsets now have explicit Bank 2 RAM ownership.

Run:

```text
make validate-world3-formation-runtime
```

## World 3 frame core

`config/reconstruction/world3/world3_frame_core.json` fixes eighteen formerly address-named Bank 2
routine entries. The contract covers 938 executable bytes, 42 direct calls,
and 22 Bank 2-private RAM fields.

The slice connects the World 3 entry and frame loop to:

- hardware/RAM and PPU initialization;
- start-room selection through the carried Passing Hoop, fixed spawn points,
  and collision-tested random spawn points;
- pause input, boss-music restoration, and the two microphone/debug hooks;
- persistent-object reset, palette flash, and active-entity cleanup;
- alternating OAM halves and score, lives, and health HUD composition.

The room index is decomposed into an eight-by-eight row and column, matching
the 64-room map. Boss completion flags retain the hexadecimal room IDs used by
the runtime (`$27`, `$28`, and `$34`). The room `$16` microphone event names
describe only its proven object relocation and marker behavior; no character
identity is inferred.

Run:

```text
make validate-world3-frame-core
```

## World 3 interaction runtime

`config/reconstruction/world3/world3_interaction_runtime.json` fixes nine formerly address-named
World 3 interaction entries. The exact contract covers 1,016 executable bytes,
26 direct calls, and eight Bank 2-private RAM bytes. Two blank-tile rows used
by the arena and barrier updates are also named in the symbol registry.

The frame loop now exposes the complete room `$3C` rescue condition. All three
active companion types `$1C-$1E` must be present before the game flashes the
palette, opens an eight-row barrier, marks the rescue complete, removes the
active companions, and retires their persistent records. Room reload repeats
the same barrier update while the completion flag is set.

The player-projectile path scans both projectile slots against each active
entity, applies the exact target exclusions and 13-pixel axis hitbox, changes
the projectile to its impact animation, decrements hit points, and dispatches
defeat progression. Type `$08` resolves the three giant-octopus room flags;
types `$0C-$0F` start the final completion delay. The shared defeat helper
installs state five and the explosion metasprite, while the score adapter keeps
attract mode scoreless and preserves the entity traversal registers.

The contact path distinguishes the punishment-room type `$06` collectible from
its damaging skull form, records the two fixed Genki Candy pickups, toggles
persistent followers through a B-button edge latch, and implements the four
post-defeat items. Type `$10` starts the stopwatch, `$11` refills health,
`$12` defeats active combat entities and advances the punishment counter, and
`$13` advances the same counter without the mass defeat. All remaining harmful
contacts feed the documented damage-recovery or death player states.

Run:

```text
make validate-world3-interaction-runtime
```

## World 3 player runtime

`config/reconstruction/world3/world3_player_runtime.json` fixes thirteen formerly address-named
World 3 player and map-lookup entries. The exact contract covers 690 executable
bytes, 25 direct `JSR` or `JMP` edges, and fourteen Bank 2-private RAM bytes.
Four additional conditional branches enter adjacent routines directly and are
preserved symbolically in the source rather than counted as call instructions.

The player owns the contiguous sixteen-byte state block at `$008E-$009D`.
Initialization clears that block, selects state one, installs its initial
metasprite, and sets the normal animation cadence. The five-entry
`World3_PlayerStateHandlerTable` then dispatches inactive, controlled, scripted
arc, damage-recovery, and death states.

Controlled movement now exposes the fire-button edge latch and firing pose,
direction-selected metasprite bases, alternating horizontal step rate, passive
descent delay, and the signed fifteen-entry vertical delta table. Horizontal
and vertical movement share the terrain probes from the collision contract and
cross room edges through the named room-transition services. Sampling terrain
tile `$14` during upward movement switches the player to state two, whose
24-entry signed curve drives a scripted arc before returning to controlled
movement.

The same slice names health refill, new-session score/lives/capacity reset, and
the death restart gateway. `World3_LookupMapTileAtPixel` documents the runtime
counterpart of the lossless World 3 map format: a pixel coordinate is resolved
through the 64-by-64 large-block map, large-block composition, small-block
composition, and finally the terrain tile id used by collision.

Run:

```text
make validate-world3-player-runtime
```

## World 3 PPU update queue

World 3 stages PPU writes in a 256-byte wrapping ring at `$0500-$05FF`.
`World3PpuQueueWriteIndex` (`$6C`) belongs to producers and
`World3PpuQueueReadIndex` (`$6B`) belongs to the NMI consumer. Equal indexes
mean that the queue is empty.

Each record is self-sized:

| Offset | Meaning |
| ---: | --- |
| 0 | PPU address high bits 0-6; bit 7 requests PPU increment 32 |
| 1 | PPU address low byte |
| 2 | Payload length |
| 3... | Bytes written to `PPU_DATA` |

`World3_QueuePpuBlock` appends the general record. The palette path emits a
fixed `$3F00`, 32-byte record and mirrors its payload at `$0480-$049F`.
Single-byte and attribute-quadrant writers use the same format. Before the
largest 35-byte record is appended, `World3_WaitForPpuQueueSpace` requires the
ring to be empty or to have at least `$24` bytes between its modulo-256
indexes.

While rendering is enabled, the common bank-2 NMI optionally performs page-3
OAM DMA before `World3_NmiFrameServices` drains one PPU queue record, resets
the PPU address, and applies the scroll pair and nametable bits. The consumer
explicitly initializes a one-record budget, so the retail path drains at most
one record per NMI even though it also retains a `$30` payload-byte threshold
check.

When rendering is disabled, the NMI bypasses PPU and OAM work. Producers then
call `World3_DrainPpuQueueIfRenderingDisabled` after appending so bulk setup
writes can execute synchronously. Re-enabling rendering first waits for equal
read/write indexes, waits for a vblank edge, restores OAM and scroll state,
and finally writes `$1E` to `PPU_MASK`.

The coordinate helpers accept tile X/Y in registers and wrap them at 32 by 30
tiles. They return the computed nametable or attribute PPU address in
`World3PpuAddressHigh:World3PpuAddressLow`; the attribute helper additionally
returns the matching RAM-shadow offset.

`config/reconstruction/world3/world3_ppu_queue.json` makes this model executable. The release gate
checks the record geometry and capacity invariant, all 15 owned RAM symbols,
23 active or dormant PPU-path routines, and 13 code signatures against the
canonical PRG and semantic symbol registry.

## World 3 room rendering

`config/reconstruction/world3/world3_room_rendering.json` fixes eight formerly address-named World 3
room-rendering routines. The exact contract covers 351 executable bytes and
ten direct calls. It also fixes the current-room map pointer, the two
hierarchical row selectors, the zero-through-29 output row, and both 32-byte
palette copies.

Room loading first derives an eight-cell-wide window in the 64x64 large-block
map from the six-bit room index. Thirty output rows then walk the large-block
and small-block hierarchy with independent zero-or-two row selectors. Each
row expands eight map cells into 32 CHR tile bytes and eight attribute bytes,
then queues both transfers at addresses calculated from the output row.

Attribute generation combines the two two-bit palette selectors belonging to
the selected small-block pair. It replaces the appropriate nibble in the
128-byte attribute shadow and writes the complete result to the current
eight-byte transfer row.

The palette-in routine is the inverse room-load half of
`World3_FadePaletteToBlack`. It advances each shadow entry toward the selected
room target, uploads all 32 bytes every three frames, and repeats until the
copies match.

Run:

```text
make validate-world3-room-rendering
```

## World 3 room runtime

`config/reconstruction/world3/world3_room_runtime.json` fixes fifteen formerly address-named World 3
routines covering input and audio wrappers, player rendering, all four room
edges, room-entry persistence policy, full room reconstruction, music
selection, and the palette fade. The exact contract covers 607 executable
bytes, 76 direct calls, and ten Bank 2-private RAM bytes.

### Room transition transaction

Each directional edge first checks the matching coordinate of the 8 by 8 room
grid and stages the adjacent room in `World3TransitionTargetRoom`. Before
committing `World3CurrentRoom`, the transition:

- drops an active follower if the destination already contains three
  persistent objects;
- clears persistent state before final room `$3F`;
- clears persistent state before undefeated boss rooms `$27`, `$28`, and
  `$34`;
- saves the outgoing and incoming object-persistence phases;
- rebuilds the destination room through `World3_LoadCurrentRoom`.

The load transaction darkens and disables the display, selects World 3 CHR,
prepares the nametable and room palette, clears and rematerializes entities,
rebuilds collision state, restores special-room presentation, renders the HUD,
reenables the display, and selects the room music.

### Input, player, and music

`World3_ReadActivePlayerButtons` returns the combined controller byte during
gameplay and zero during attract mode. Both effect wrappers preserve X and Y,
which accounts for all 29 direct audio-wrapper callers in this slice.

Player rendering adds `World3PlayerAnimationFrame` to
`World3PlayerMetaspriteBase`, stages the player coordinates through the common
metasprite-origin helper, and submits the resolved index. Room music uses a
64-byte room-to-class table followed by a four-byte class-to-track table:

```text
World3CurrentRoom
  -> World3_RoomMusicClassByRoom
  -> World3_MusicTrackByRoomClass
  -> World3RoomMusicTrack
```

Run:

```text
make validate-world3-room-runtime
```

## World 3 transition runtime

`config/reconstruction/world3/world3_transition_runtime.json` fixes the final five address-named
World 3 routines. The exact contract covers 374 executable bytes, twelve
direct calls or tail jumps, and ten Bank 2-private RAM fields. It also names
the two blank completion-wipe sources, the eight-record debug OAM image, and
the room `$3F` marker blink counter.

After the final formation delay expires, the completion sequence resets the
player state and runs an eight-frame inward wipe. Each step queues one blank
row from the top and bottom and one blank column from the left and right. The
player is held at the center, non-type-`$1F` entities are cleared, and surviving
type-`$1F` actors have their metasprite variant reset. The sequence then waits
for music completion, delays another `$5A` frames, and enters the common ending
gateway.

Before that transition begins, room `$3F` conditionally renders metasprite
`$AC` at the fixed `$70,$74` position under a bit-four blink cadence. The
counter now has explicit Bank 2 ownership without assigning an unsupported
character identity to the marker.

Eight impossible-state paths tail-call a common diagnostic halt. The incoming
code is converted to a tile in the `$30-$37` range, placed at the screen center,
submitted for OAM DMA, and followed by an intentional infinite loop.

The controller-two `$C0` debug hook has a separate sprite-test setup path. It
disables rendering, uploads the final-room palette, clears both nametables and
attribute tables, copies eight fixed OAM records to page `$03`, restarts music
track seven, and returns to the debug input handshake.

Run:

```text
make validate-world3-transition-runtime
```
