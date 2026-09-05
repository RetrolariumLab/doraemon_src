# RAM Fields

This registry lists high-confidence shared RAM roles. Addresses are CPU RAM
addresses; array symbols may be indexed by channel, digit, or sprite slot at the
use site. Chapter-local zero-page overlays remain numeric until their lifetime
and ownership are proved.

## Common frame and input state

| Symbol | Address | Role |
| --- | ---: | --- |
| `NmiOamDmaRequest` | `$0014` | Nonzero requests OAM DMA during the next NMI |
| `NmiBusy` | `$0015` | NMI re-entry guard incremented around bank-local frame work |
| `FrameCounter` | `$0016` | Incremented once at the end of every bank-local NMI |
| `MapperSelection` | `$0017` | Combined GNROM PRG/CHR selection consumed by the mapper writer |
| `ChrSelectionBits` | `$0018` | Prepared CHR-bank bits merged into `MapperSelection` |
| `PpuCtrlShadow` | `$0019` | Software shadow written to `PPU_CTRL` |
| `PpuMaskShadow` | `$001A` | Software shadow written to `PPU_MASK` |
| `PpuScrollXShadow` | `$001B` | First value written to `PPU_SCROLL` during frame setup |
| `PpuScrollYShadow` | `$001C` | Second value written to `PPU_SCROLL` during frame setup |
| `Controller2Buttons` | `$001D` | Primary controller-2 serial shift register |
| `Controller2ButtonsAlt` | `$001E` | Secondary controller-2 serial shift register |
| `Controller1Buttons` | `$001F` | Primary controller-1 serial shift register |
| `Controller1ButtonsAlt` | `$0020` | Secondary controller-1 serial shift register |
| `CombinedControllerButtons` | `$0021` | OR of the four serial button bytes after polling |

## Shared rendering and score state

| Symbol | Address | Role |
| --- | ---: | --- |
| `ScoreDigitsCurrent` | `$0290` | Current eight-byte score digit array |
| `ScoreDigitsWorking` | `$0298` | Eight-byte score arithmetic and carry array |
| `OamBuffer` | `$0300` | CPU page copied by OAM DMA and written as four-byte sprite records |

## World 1 entity slots

Bank 0 uses 48 parallel entity slots. Four active/type subranges at offsets
0, 10, 30, and 38 contain 10, 20, 8, and 10 slots respectively; every field
below spans the complete 48-slot index space. The grouping lets different city
and underground subsystems traverse their own slot class while sharing motion,
collision, and metasprite helpers.

| Symbol | Address | Size | Role |
| --- | ---: | ---: | --- |
| `World1EntityType` | `$0400` | 48 | Zero means inactive; nonzero values select an entity type or state |
| `World1EntityMetasprite` | `$0430` | 48 | Metasprite table index copied into the common sprite composer |
| `World1EntityRenderFlags` | `$0460` | 48 | Visibility and alternating-frame flags consumed by the sprite composer |
| `World1EntityPositionHigh` | `$0490` | 48 | Packed X/Y high bits, updated when either low coordinate crosses a byte boundary |
| `World1EntityX` | `$04C0` | 48 | Low byte of the entity X coordinate |
| `World1EntityY` | `$04F0` | 48 | Low byte of the entity Y coordinate |
| `World1EntitySourceObjectId` | `$0520` | 48 | Map-object ID whose spawn bit belongs to the entity, or `$FF` for transient entities |
| `World1EntityPrimaryBehavior` | `$0550` | 48 | Primary state-specific counter, direction, or motion value |
| `World1EntitySecondaryBehavior` | `$0580` | 48 | Secondary substate, direction, and motion flags |
| `World1EntityHealthOrVelocity` | `$05B0` | 48 | Main-entity hit points, overlaid by transient vertical velocity |
| `World1EntityDamageTimerOrAcceleration` | `$05E0` | 48 | Main-entity damage/recovery counter, overlaid by transient acceleration |
| `World1EntityActionCooldown` | `$0610` | 48 | Randomized countdown gating low-state actions and projectile spawns |
| `World1EntityReservedBehavior` | `$0640` | 48 | Cleared on entity materialization; no read has been proven |

These aliases apply only to PRG bank 0. The manifest proves that entity storage
is a 13-field structure-of-arrays grid from `$0400-$066F`, with a 48-byte
stride. The last six columns are deliberate overlays: slots 0-9 use health,
damage recovery, direction, and action timing, while transient slots 10-29
reuse the same addresses for motion vectors and acceleration. The names retain
both proven roles instead of pretending that every slot class shares one entity
schema. `$0640-$066F` is clear-only in all currently recovered code and remains
explicitly reserved until a read path is demonstrated.

## World 1 object persistence and attribute cache

World 1 addresses each map object by a bit in a 16-byte set. Materializing an
object sets its bit in the current scene's spawn mask. Despawning a temporary
object clears that bit through `World1EntitySourceObjectId`, while collecting a
persistent item sets the corresponding bit in the collected-object set.

The placement decoder owns a small bank-0 zero-page overlay:

| Symbol | Address | Size | Role |
| --- | ---: | ---: | --- |
| `World1ObjectPlacementList` | `$0068` | 2 | Base pointer for the active city or underground placement list |
| `World1CurrentPlacementId` | `$0090` | 1 | Zero-based record index and persistence bit ID |
| `World1PlacementScanPointer` | `$0091` | 2 | Cursor advanced by three bytes per record |
| `World1PlacementXCell` | `$0093` | 1 | Retained record X cell used during materialization |
| `World1PlacementYCell` | `$0094` | 1 | Retained record Y cell used during materialization |

| Symbol | Address | Size | Role |
| --- | ---: | ---: | --- |
| `World1ObjectSpawnMask` | `$0670` | 16 | Suppresses objects already materialized or persistently collected in the current scene |
| `World1CollectedObjectBits` | `$0680` | 16 | Persistent object state for whichever mode is currently active |
| `World1SavedCityObjectBits` | `$0690` | 16 | City state saved while the side-view underground mode is active |
| `World1SavedUndergroundObjectBits` | `$06A0` | 16 | Underground state saved while the city mode is active |
| `World1AttributeTableCache` | `$06B0` | 128 | Attribute bytes for both streamed nametables |

Entering the underground copies `$0680-$068F` to the city backing store and
loads the underground backing store into `$0680-$068F`; returning performs the
inverse exchange. The active spawn mask is then refreshed from the selected
persistent set. The adjacent 128-byte attribute cache spans `$06B0-$072F` and
is updated bitwise as metatiles are streamed into either nametable.

## World 2 screen and palette state

| Symbol | Address | Role |
| --- | ---: | --- |
| `World2ScreenStreamPointer` | `$0046-$0047` | Active compressed-screen stream pointer |
| `World2ScreenStreamOffset` | `$0054` | Byte offset within the selected stream |
| `World2StageSequenceOffset` | `$0055` | Current stage-bytecode offset |
| `World2ScreenRowIndex` | `$0056` | Row counter used to advance after sixteen rows |
| `World2ScreenRunLength` | `$0057` | Low-nibble-derived RLE counter |
| `World2CurrentScreenId` | `$0058` | Masked screen selector |
| `World2PlayerX` | `$005C` | Player horizontal coordinate and branch-zone input |
| `World2PlayerY` | `$005D` | Player vertical coordinate and branch-zone input |
| `World2FrameCounter` | `$0073` | Bank-1 NMI counter and animation phase |
| `World2EnemySpawnState` | `$0074` | Current `$D0-$EE` spawn token |
| `World2InventoryState` | `$007C-$0082` | Seven fixed companion/item runtime states |
| `World2InventoryX` | `$0083-$0089` | Seven companion/item X coordinates |
| `World2InventoryY` | `$008A-$0090` | Seven companion/item Y coordinates |
| `World2PendingBackgroundPalette` | `$009D` | Palette ID consumed and cleared by `$8747` |
| `World2SavedStageSequenceOffset` | `$009E` | Branch return restored by stage token `$F7` |
| `World2StageBranchCooldown` | `$00AE` | 255-frame lockout after a conditional stage branch |
| `World2SavedBackgroundPalette` | `$00B4` | Palette ID restored after a transition |
| `World2ScreenMetatiles` | `$0400-$04FF` | Expanded 16x16 screen used by rendering and collision |

Stage tokens `$F9-$FF` write the same ID to the pending and saved palette
fields. The uploader clears only the pending byte. The transition path copies
the saved byte back, proving that `$00B4` is persistent palette state rather
than a second event channel.

## World 3 frame and PPU state

| Symbol | Address | Role |
| --- | ---: | --- |
| `World3RenderingDisabled` | `$0067` | Bypasses NMI PPU/OAM services and enables synchronous producer-side draining |
| `World3FrameWaitCounter` | `$0068` | Decremented by NMI and polled by `World3_WaitFrames` |
| `World3PpuAddressLow` | `$0069` | Low-byte output of the nametable and attribute address helpers |
| `World3PpuAddressHigh` | `$006A` | High-byte output of the nametable and attribute address helpers |
| `World3PpuQueueReadIndex` | `$006B` | Consumer cursor in the wrapping queue |
| `World3PpuQueueWriteIndex` | `$006C` | Producer cursor in the wrapping queue |
| `World3PpuQueueRecordBudget` | `$006D` | One-record budget initialized by each drain pass |
| `World3PpuQueueByteCount` | `$006E` | Payload-byte accumulator retained by the drain loop |
| `World3ScrollX` | `$006F` | First World 3 `PPU_SCROLL` value |
| `World3ScrollY` | `$0070` | Second World 3 `PPU_SCROLL` value |
| `World3NametableSelect` | `$0071` | Low two `PPU_CTRL` nametable bits |
| `World3PpuQueueVerticalIncrement` | `$0072` | Nonzero encodes PPU increment 32 in a queued record |
| `World3AttributeShadow` | `$0400-$047F` | Attribute bytes filled and updated before upload |
| `World3PaletteShadow` | `$0480-$049F` | Last complete 32-byte palette queued at `$3F00` |
| `World3PpuQueue` | `$0500-$05FF` | 256-byte address/length/payload ring buffer |

The queue record layout, NMI/disabled-rendering ownership split, capacity
guard, and address calculations are described in `docs/world3_ppu_queue.md`.

## World 2 entity pools

Bank 1 uses compact parallel arrays whose stride is the pool capacity, rather
than World 1's single 48-slot layout. Independent clear, spawn, update,
collision, and render loops establish three pools.

| Enemy field | Address | Size | Role |
| --- | ---: | ---: | --- |
| `World2EnemyState` | `$0558` | 7 | Active state and update/render handler index |
| `World2EnemyX` | `$055F` | 7 | X coordinate |
| `World2EnemyY` | `$0566` | 7 | Y coordinate |
| `World2EnemyPhaseCounter` | `$056D` | 7 | Initial spawn delay, then handler-local animation or motion phase |
| `World2EnemyBehaviorParameter` | `$0574` | 7 | Spawn axis/side or type-specific motion parameter |
| `World2EnemyAttackTimer` | `$057B` | 7 | Counter compared with the state-specific firing interval |
| `World2EnemyDamageCounter` | `$0582` | 7 | Incremented on a hit and compared with the state-specific defeat threshold |

| Enemy-projectile field | Address | Size | Role |
| --- | ---: | ---: | --- |
| `World2EnemyProjectileFlags` | `$0589` | 6 | Direction, major axis, and motion-mode flags |
| `World2EnemyProjectileX` | `$058F` | 6 | X coordinate |
| `World2EnemyProjectileY` | `$0595` | 6 | Y coordinate; zero is the inactive sentinel |
| `World2EnemyProjectileStepAccumulator` | `$059B` | 6 | Accumulator used by major/minor-axis line stepping |
| `World2EnemyProjectileMotionX` | `$05A1` | 6 | Signed X step or aimed-line X delta, depending on flags |
| `World2EnemyProjectileMotionY` | `$05A7` | 6 | Signed Y step or aimed-line Y delta, depending on flags |
| `World2EnemyProjectileLifetime` | `$05AD` | 6 | Age counter; timed projectiles despawn at `$8C` |

| Player-projectile field | Address | Size | Role |
| --- | ---: | ---: | --- |
| `World2PlayerProjectileState` | `$05B3` | 7 | Active state |
| `World2PlayerProjectileX` | `$05BA` | 7 | X coordinate |
| `World2PlayerProjectileY` | `$05C1` | 7 | Y coordinate |
| `World2PlayerProjectileDirection` | `$05C8` | 7 | Motion direction selector |

These are three complete structure-of-arrays grids: seven enemy fields from
`$0558-$0588` with stride 7, seven enemy-projectile fields from `$0589-$05B2`
with stride 6, and four player-projectile fields from `$05B3-$05CE` with
stride 7. The manifest accounts for every field base in all three layouts.

## World 3 active and persistent objects

Bank 2 separates the eight objects currently simulated in a room from a
13-record persistent room-object registry. Room loading matches each registry
record's room number, allocates an active slot, and copies type and coordinates
into it. Room exit performs the reverse copy for matching objects.

The room-indexed transient scheduler uses a four-channel zero-page overlay.

| Transient scheduler field | Address | Size | Role |
| --- | ---: | ---: | --- |
| `World3TransientSpawnScheduleLoaded` | `$00AB` | 1 | Zero reloads all room columns; one preserves the active schedule |
| `World3TransientSpawnType` | `$00AC` | 4 | Entity type for each channel |
| `World3TransientSpawnRemaining` | `$00B0` | 4 | Remaining successful spawns in each channel |
| `World3TransientSpawnDelay` | `$00B4` | 4 | Current delay countdown |
| `World3TransientSpawnComplete` | `$00B8` | 4 | Set after the last successful spawn |
| `World3TransientSpawnPhase` | `$00BC` | 4 | Modulo-four prescaler phase; retained across room reloads |
| `World3TransientSpawnDelayReload` | `$00C0` | 4 | Original room delay restored after each expiry |
| `World3TransientSpawnWorkType` | `$00C4` | 1 | Current channel type scratch byte |
| `World3TransientSpawnWorkRemaining` | `$00C5` | 1 | Current channel budget scratch byte |
| `World3TransientSpawnWorkDelay` | `$00C6` | 1 | Current channel delay scratch byte |
| `World3TransientSpawnWorkComplete` | `$00C7` | 1 | Current channel completion scratch byte |

`World3_ClearEntityStorage` clears the schedule-loaded flag when a room is
materialized, but does not clear the four phase bytes. The next frame therefore
loads the new room's type/count/delay columns while retaining each channel's
position in the global modulo-four cadence. See
`docs/world3_transient_spawns.md`.

| Active entity field | Address | Size | Role |
| --- | ---: | ---: | --- |
| `World3EntityState` | `$0600` | 8 | Zero means free; nonzero states select update phases |
| `World3EntityX` | `$0608` | 8 | Active X coordinate |
| `World3EntityY` | `$0610` | 8 | Active Y coordinate |
| `World3EntityFrameCounter` | `$0618` | 8 | Per-frame animation and behavior counter |
| `World3EntityCollisionScanLimit` | `$0620` | 8 | Bound used by room collision scans |
| `World3EntityMetasprite` | `$0628` | 8 | Type-derived animation/metasprite value |
| `World3EntityRenderFlags` | `$0630` | 8 | Per-object flags merged into renderer attributes |
| `World3EntityType` | `$0638` | 8 | Object type and behavior-dispatch index |
| `World3EntityScriptOffset` | `$0640` | 8 | Offset into the type-selected behavior stream |
| `World3EntityScriptWaitTimer` | `$0648` | 8 | Countdown owned by script opcode `$5n` |
| `World3EntityHorizontalDirection` | `$0650` | 8 | Horizontal motion direction flag |
| `World3EntityVerticalDirection` | `$0658` | 8 | Vertical motion direction flag |
| `World3EntityScriptRateCounter` | `$0660` | 8 | Packed execution-rate counter set by opcode `$6n` |
| `World3EntityActivationTimer` | `$0668` | 8 | Spawn countdown before the active-state transition |
| `World3EntityBehaviorSelector` | `$0670` | 8 | Type-specific clone budget or targeting-mode selector |
| `World3EntityPersistentState` | `$0678` | 8 | State synchronized with the persistent room record |
| `World3EntityBehaviorTimer` | `$0680` | 8 | Script-loop and type-specific behavior countdown |
| `World3EntityScriptLoopOffset` | `$0688` | 8 | Behavior-stream offset restored while a loop remains |
| `World3EntityFollowAnchorFlag` | `$0690` | 8 | Enables following the active type-`$0C` anchor |
| `World3EntityHitPoints` | `$0698` | 8 | Type-derived damage countdown and defeat trigger |
| `World3EntityMetaspriteVariantBit1` | `$06A0` | 8 | Zero-or-two offset added to the base metasprite |
| `World3EntityMetaspriteVariantBit0` | `$06A8` | 8 | Zero-or-one offset added to the base metasprite |

| Persistent record field | Address | Size | Role |
| --- | ---: | ---: | --- |
| `World3RoomObjectRoom` | `$06B0` | 13 | Owning room number |
| `World3RoomObjectType` | `$06BD` | 13 | Object type copied to the active pool |
| `World3RoomObjectX` | `$06CA` | 13 | Saved X coordinate |
| `World3RoomObjectY` | `$06D7` | 13 | Saved Y coordinate |
| `World3RoomObjectState` | `$06E4` | 13 | State restored on materialization and saved on room exit |

The active storage is a fully classified 22-field structure-of-arrays grid from
`$0600` through `$06AF`, with an eight-byte stride. The manifest checks every
field base so accidental gaps cannot be mistaken for completed analysis. The
persistent registry is likewise a complete five-field grid from `$06B0`
through `$06F0`, with a 13-byte stride.

Initialization copies this grid byte-for-byte from the matching five-array ROM
image at `$D96B-$D9AB`, then randomizes two type-only slot groups. The exact
initial rooms, types, coordinates, zero states, and shuffle multisets are fixed
by `config/world3_object_data.json`.

The active `World3EntityType` value also indexes five complete ROM columns for
hit points, base metasprite, render flags, contact damage, and score reward.
Their 32-entry contents and the four lifecycle domains spanning `$00-$1F` are
validated by `config/world3_entity_types.json` and described in
`docs/world3_entity_types.md`.

`World3EncounterRoomList` at `$06F1-$06F8` stores eight room numbers. Empty
entries contain `$FF`; encounter placement expands the list to adjacent valid
rooms, room entry uses it to materialize a type-`$0A/$0B` group, and defeating
that group removes the current room.

| Player-projectile field | Address | Size | Role |
| --- | ---: | ---: | --- |
| `World3PlayerProjectileState` | `$06F9` | 2 | Zero is free, one is moving, and two is the impact animation |
| `World3PlayerProjectileX` | `$06FB` | 2 | X coordinate |
| `World3PlayerProjectileY` | `$06FD` | 2 | Y coordinate |
| `World3PlayerProjectileDirection` | `$06FF` | 2 | Horizontal motion direction |
| `World3PlayerProjectileMetasprite` | `$0701` | 2 | Moving or impact metasprite index |
| `World3PlayerProjectileAnimationCounter` | `$0703` | 2 | Four-frame divider for the impact animation |

The projectile pool is a complete six-field grid from `$06F9-$0704`, with a
two-byte stride. Its lifecycle covers whole-pool clearing, free-slot allocation,
motion/collision and impact updates, and rendering.

## Bank-local audio driver state

All four PRG banks carry their own driver code but use the same RAM layout.

| Symbol | Address | Role |
| --- | ---: | --- |
| `AudioEffectRequestState` | `$02A0` | Pending effect index; bit 7 marks a consumed request |
| `AudioCurrentEffectPriority` | `$02A1` | Even priority/dispatch index of the active effect |
| `AudioEffectTimers` | `$02A3` | Four per-frame effect countdown bytes |
| `AudioMusicState` | `$02AA` | Music request and active-state byte |
| `AudioMusicControl` | `$02AB` | Music reset/control state shared with transition code |
| `AudioChannelNotes` | `$02AC` | Four current note values |
| `AudioChannelDurations` | `$02B0` | Four channel countdown values |
| `AudioStreamHeaderPointers` | `$02DC` | Eight-byte copy of the selected track header pointers |
| `AudioChannelIndex` | `$02FD` | Current channel index, 0 through 3 |
| `AudioEndedChannelCount` | `$02FE` | Count used to stop music after all four channels end |
| `AudioWorkByte` | `$02FF` | Music interpreter temporary byte |

The semantic operand mapping is machine-readable in `config/symbols.json`.
`src/memory/ram.inc` supplies the ca65 definitions used by generated source.
`config/object_pools.json` binds the chapter capacities, fields, slot groups,
and lifecycle routines; `make validate-object-pools` checks that contract
against the symbol registry.
