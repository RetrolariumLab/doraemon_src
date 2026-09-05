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
| `Controller2MicrophoneSample` | `$0023` | Previous `JOYPAD1` bit-2 sample used for microphone edge detection |
| `Controller2MicrophoneEdgeTimer` | `$0024` | 20-frame window started by a microphone edge and read by chapter secrets |

The Famicom controller-2 microphone is sampled through bit 2 of `JOYPAD1`.
Every bank-local NMI compares that bit with the retained sample; either edge
reloads the timer to `$14`, and NMI decrements it once per frame. World 1's
programmer-face object and hidden interactions in Worlds 2 and 3 test the
nonzero window rather than reading the hardware register directly.

## Shared player progression and health

| Symbol | Address | Role |
| --- | ---: | --- |
| `ExtraLifeScoreThresholdIndex` | `$0025` | Selects the next of four score thresholds; value 4 disables further score awards |
| `ExtraLifeSoundCounter` | `$0026` | Pending extra-life sound event produced by score awards or 1UP and consumed by the active chapter |
| `DemoModeActive` | `$0027` | Nonzero while the title-screen attract sequence drives a chapter demo |
| `PlayerLives` | `$002A` | Remaining lives; initialized at game/chapter entry, decremented on death, and incremented by 1UP or score thresholds |
| `PlayerHealth` | `$002B` | Current health in quarter-meter units, rendered and damaged by every chapter |
| `PlayerHealthCapacityIndex` | `$002C` | Left edge of the eight-cell health meter; lowering it adds four health units |
| `World1FlashLightCarryFlag` | `$0037` | Set by the World 1 Flash Light, converted to World 2 inventory slot 2 at chapter entry, then cleared |

The health capacity field is an inverse index, not a direct maximum. The common
calculation `(8 - PlayerHealthCapacityIndex) * 4` produces full health. World 1
Genki Candy and the matching World 2/3 capacity upgrades decrement the index,
then refill or extend the current health value through that calculation.

Every PRG bank carries the same score implementation at `$81C9-$8250` and a
bank-local copy of the four-record threshold table at `$8251-$8260`. The table
compares the leading four decimal digits of `ScoreDigitsWorking`, in order, at
20,000, 80,000, 200,000, and 500,000 points. Reaching a threshold increments
`PlayerLives`, `ExtraLifeSoundCounter`, and `ExtraLifeScoreThresholdIndex`.
Both score routines return without changing state while `DemoModeActive` is
set. The title shell sets that flag before rotating through the three chapter
entry gateways; normal World 1 and World 2 starts clear it, while demo-specific
entry points set it. The same flag selects demo input, damage, and exit paths.

## World 1 camera state

| Symbol | Address | Role |
| --- | ---: | --- |
| `World1NametableX` | `$0058` | Horizontal nametable bit toggled when the pixel scroll wraps and copied into `PpuCtrlShadow` bit 0 |
| `World1PpuScrollXLatched` | `$0059` | Horizontal scroll value published to `PPU_SCROLL` by NMI before latching the next value |
| `World1PpuScrollYLatched` | `$005A` | Vertical scroll value published to `PPU_SCROLL` by NMI before latching the next value |
| `World1CameraTileX` | `$005B` | Horizontal camera coordinate in 8-pixel world-map cells; bounded from 0 through `$E0` |
| `World1CameraTileY` | `$005C` | Vertical camera coordinate in 8-pixel world-map cells; bounded from 0 through `$E2` |
| `World1MapPrefillCounter` | `$0060` | Initial map-fill countdown: `$98` iterations, each advancing the camera twice |
| `World1ScreenDeltaX` | `$0061` | Signed screen-space X adjustment accumulated while the camera moves during the current update |
| `World1ScreenDeltaY` | `$0062` | Signed screen-space Y adjustment accumulated while the camera moves during the current update |

The low three bits of `PpuScrollXShadow` and `PpuScrollYShadow` are the
sub-cell pixel offsets. Crossing an eight-pixel boundary increments or
decrements the corresponding camera-cell coordinate. Object spawning,
collision lookup, map streaming, and world-to-screen entity conversion all
consume this pair, in both city and underground modes. Each pixel of camera
motion simultaneously accumulates the opposite signed screen delta; that
delta keeps the player and all active entities stationary in world space.

NMI writes the latched scroll pair to `PPU_SCROLL`, then copies the current
scroll shadows into the latch for the following frame. Horizontal byte wrap
toggles `World1NametableX`, which supplies both `PpuCtrlShadow` bit 0 and the
nametable selector used by the edge-streaming address builders.

The four directional entry points are `World1_TryScrollCameraRight`,
`World1_TryScrollCameraLeft`, `World1_TryScrollCameraDown`, and
`World1_TryScrollCameraUp`. Together they own 325 bytes and have 16 exhaustive
direct callsites. Their exact bounds, wrap behavior, packet phases, routine
bodies, and call graph are documented in `docs/world1_camera.md` and enforced
by the release gate.

`World1_UpdateCameraFromPlayer` applies the accumulated delta back to the
player, then `World1_ApplyCameraDeltaToEntities` propagates it through all 48
entity slots. `World1_CullOffscreenEntities` removes slots beyond the retained
viewport margins and releases their source-map spawn bits. The three routines,
their 13 direct calls, and their full coordinate ABI are documented in
`docs/world1_camera_entities.md`.

## World 1 pseudorandom state

| Symbol | Address | Size | Role |
| --- | ---: | ---: | --- |
| `World1FrameRandomState` | `$0052` | 2 | State updated by `World1_FrameRandomByte`, which mixes both bytes with `FrameCounter` |
| `World1RandomState` | `$0054` | 4 | Independent state updated by `World1_RandomByte` without reading the frame counter |

Both sequences are zero-initialized with the chapter RAM and cleared again on
the World 1 demo path. They are separate generators rather than one six-byte
state: the routines access disjoint fields and have disjoint direct-call
graphs. The bank-wide validator pins the complete seven-call and eighteen-call
sets as well as both machine-code bodies.

## World 1 hierarchical map decoder

| Symbol | Address | Size | Role |
| --- | ---: | ---: | --- |
| `World1MapDataPointer` | `$0066` | 2 | Selects the city map at `$B2EF` or underground map at `$C2EF` |
| `World1CurrentSmallBlockPointer` | `$006A` | 2 | Points to the current four-byte record in `World1_SmallBlocks` |
| `World1CurrentBigBlockPointer` | `$006C` | 2 | Points to the current four-byte record in `World1_BigBlocks` |
| `World1MapRowPointer` | `$006E` | 2 | Points to the current 64-byte map row |
| `World1TileQuadrantIndex` | `$0070` | 1 | Row-major CHR-tile quadrant within the current small block |
| `World1SmallBlockQuadrantIndex` | `$0071` | 1 | Row-major small-block quadrant within the current big block |
| `World1MapColumnIndex` | `$0072` | 1 | Current six-bit column in the active map |

The lookup at `$A6A7` consumes 8-pixel world-tile coordinates and returns the
corresponding CHR tile. Horizontal and vertical iterator entries propagate
cursor carries across the small-block, big-block, and map levels. The exact
field geometry, eight entry points, 34 direct calls, and four city/underground
map selections are machine-validated. See `docs/world1_map_decoder.md`.

## World 1 map-streaming PPU packets

| Symbol | Address | Size | Role |
| --- | ---: | ---: | --- |
| `World1ColumnUpdateFlags` | `$0230` | 1 | Pending tile/attribute halves of the vertical-column packet |
| `World1ColumnTilePpuAddress` | `$0231` | 2 | Little-endian tile destination |
| `World1ColumnTileData` | `$0233` | 30 | Vertical edge CHR-tile indexes |
| `World1ColumnAttributePpuAddress` | `$0253` | 2 | Little-endian attribute destination |
| `World1ColumnAttributeData` | `$0255` | 8 | Vertical edge packed attributes |
| `World1ColumnAddressScratch` | `$025E` | 1 | Intermediate for the vertical nametable wrap count |
| `World1EdgeUpdateQueue` | `$025F` | 1 | Two 4-bit entries: column 1 or row 2 |
| `World1RowUpdateFlags` | `$0260` | 1 | Pending tile/attribute halves of the horizontal-row packet |
| `World1RowTilePpuAddress` | `$0261` | 2 | Little-endian tile destination |
| `World1RowTileData` | `$0263` | 33 | Horizontal edge CHR-tile indexes |
| `World1RowAttributePpuAddress` | `$0284` | 2 | Little-endian attribute destination |
| `World1RowAttributeData` | `$0286` | 9 | Horizontal edge packed attributes |

The map decoder populates these buffers as camera coordinates cross tile and
attribute phases. NMI drains at most the selected edge packet while preserving
an independently pending tile or attribute half. Exact routine bodies, packet
sizes, flags, queue capacity, and all direct calls are documented in
`docs/world1_ppu_streaming.md` and enforced by the release gate.

## Shared rendering and score state

| Symbol | Address | Role |
| --- | ---: | --- |
| `ScoreDigitsCurrent` | `$0290` | Current eight-byte score digit array |
| `ScoreDigitsWorking` | `$0298` | Eight-byte score arithmetic and carry array |
| `OamBuffer` | `$0300` | CPU page copied by OAM DMA and written as four-byte sprite records |

## World 1 metasprite renderer workspace

| Symbol | Address | Size | Role |
| --- | ---: | ---: | --- |
| `World1OamY` | `$0041` | 1 | Staged OAM Y coordinate |
| `World1OamTile` | `$0042` | 1 | Staged OAM tile index |
| `World1OamAttributes` | `$0043` | 1 | Staged OAM palette/priority/flip attributes |
| `World1OamX` | `$0044` | 1 | Staged OAM X coordinate |
| `World1MetaspriteOriginX` | `$0045` | 1 | Low byte of the player/entity metasprite origin X |
| `World1MetaspriteOriginXHigh` | `$0046` | 1 | X page bits extracted from packed entity position state |
| `World1MetaspriteOriginY` | `$0047` | 1 | Low byte of the player/entity metasprite origin Y |
| `World1MetaspriteOriginYHigh` | `$0048` | 1 | Y page bits extracted from packed entity position state |
| `World1MetaspriteIndex` | `$0049` | 1 | Index into the 115-entry direct-pointer/alias table |
| `World1MetaspriteRenderFlags` | `$004A` | 1 | OAM low bits plus two frame-modulated visibility modes |
| `World1MetaspriteDataPointer` | `$004B` | 2 | Resolved variable-length metasprite record pointer |
| `World1MetaspriteXMirrorExtent` | `$004D` | 1 | Header extent used to reflect X offsets |
| `World1MetaspriteYMirrorExtent` | `$004E` | 1 | Header extent used to reflect Y offsets |
| `World1MetaspritePiecesRemaining` | `$004F` | 1 | Header sprite count decremented after each piece |
| `World1OamWriteIndex` | `$0050` | 1 | Even index doubled into an OAM byte offset; bit 7 means full |

The player, HUD, and all four World 1 entity-slot classes populate the same
bank-local workspace. `World1_EmitOamEntry` writes its first four bytes to
`OamBuffer`; the metasprite validator pins the complete field geometry,
symbol ownership, emitter address, and emitter machine-code signature.

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

## World 1 item-derived combat state

| Symbol | Address | Role |
| --- | ---: | --- |
| `World1PlayerX` | `$0075` | Player horizontal coordinate used by both top-down and side-view modes |
| `World1PlayerY` | `$0076` | Player vertical coordinate used by both top-down and side-view modes |
| `World1PlayerMetasprite` | `$0077` | Direction and animation frame combined into the metasprite index |
| `World1PlayerRenderFlags` | `$0078` | OAM attribute/visibility flags supplied to the player metasprite composer |
| `World1PlayerDamageState` | `$0079` | Zero during normal control, positive during hit recovery, and negative on death |
| `World1PlayerAnimationCounter` | `$007A` | Five-frame divider that advances the walking animation |
| `World1WeaponLevel` | `$007B` | Weapon tier 0-3; selects the upgrade metasprite, projectile entity type, and shot pattern |
| `World1PlayerAirborne` | `$007C` | Nonzero selects side-view jump/fall integration; vertical collision resolution clears it |
| `World1PlayerYVelocity` | `$007D` | Signed side-view vertical velocity, initialized to -24 and increased by gravity up to +24 |
| `World1PlayerXSubpixel` | `$007E` | Side-view fractional X accumulator; each step adds or subtracts `$80` and carries into the integer coordinate |
| `World1PlayerDirection` | `$007F` | Direction 0/1/2/3 = down/up/left/right; selects the metasprite quadrant and projectile direction |
| `World1EnemyFreezeActive` | `$0082` | Nonzero while the Stopwatch suppresses enemy updates and contact damage |
| `World1EnemyFreezeTimer` | `$0083` | Stopwatch countdown initialized to `$F0`; also phases the warning sound |
| `World1ProjectileMaxSlot` | `$0084` | Inclusive highest usable projectile slot; each Rapid-Fire Drink admits one additional simultaneous shot |
| `World1InvulnerabilityTimer` | `$00B2` | Alternate-frame countdown initialized to `$FF`; blocks damage and drives player flashing |

These aliases are limited to PRG bank 0 because the same zero-page addresses
are chapter-local overlays elsewhere. City and underground modes share the
same player position and rendering fields while applying different movement
and collision rules. Underground movement adds a signed vertical-velocity and
airborne state plus a half-pixel horizontal accumulator. The Flash Light carry
flag is the exception: its producer
in bank 0 and consumer in bank 1 prove a deliberate cross-bank lifetime.

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
| `World2BossEncounterState` | `$00A4` | Waiting, boss-entry, or active encounter phase |
| `World2StageIndex` | `$00A9` | Area index 0-2 for stage, palette, music, and boss tables |
| `World2StageBranchCooldown` | `$00AE` | 255-frame lockout after a conditional stage branch |
| `World2SavedBackgroundPalette` | `$00B4` | Palette ID restored after a transition |
| `World2TakkonDefeatStreak` | `$00B8` | Consecutive state-02 defeats; creates an item at four |
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

## World 3 punishment room

| Symbol | Address | Role |
| --- | ---: | --- |
| `World3TreasurePenaltyCounter` | `$004D` | Counts collected diamond/gold types `$12/$13`; 20 forces punishment entry |
| `World3PunishmentRoomActive` | `$0053` | Distinguishes a forced room `$12` visit from ordinary room flow |
| `World3PunishmentReturnRoom` | `$0054` | Saves the room restored when punishment ends or the player dies |
| `World3PunishmentDorayakiRemaining` | `$00A8` | Starts at 20 and decrements only on collectible type `$06` dorayaki |
| `World3PunishmentSavedPlayerState` | `$0725-$0736` | Snapshot of `$008C-$009D` restored on exit |

`World3_CheckPunishmentRoomEntry` clears the treasure counter, snapshots the
current room and 18 player-state bytes, and loads room `$12` when the counter
reaches `$14`. `World3_CheckPunishmentRoomExit` returns immediately after the
20th dorayaki, or after all 250 scheduled objects and active slots are
exhausted. `World3_ExitPunishmentRoom` restores the saved room, player state,
and music. A type `$06` object with metasprite `$20` follows the damage path;
any other type `$06` form is collected and decrements the remaining count.

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
