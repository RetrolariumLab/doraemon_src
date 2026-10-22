# Data formats

This page maps each data table to its label in the source and to the resource
the Studio edits it as (`config/game_profile.json`, read by the kit's Doraemon
codecs). The world pages describe the formats: [World 1](world1_formats.md),
[World 2](world2_formats.md), [World 3](world3_formats.md), the
[block hierarchies](world_data.md), the [objects](object_formats.md), the
[shell text](shell_text.md) and the [audio](audio_system.md).

| Data                               | Label                                |       Size | Studio resource                 |
| ---------------------------------- | ------------------------------------ | ---------: | ------------------------------- |
| World 1 attributes                 | `World1_BlockAttributes`             |        256 | `world1-hierarchy`              |
| World 1 small blocks               | `World1_SmallBlocks`                 |      1,024 | `world1-hierarchy`              |
| World 1 big blocks                 | `World1_BigBlocks`                   |      1,024 | `world1-hierarchy`              |
| city map                           | `World1_CityMap`                     |      64x64 | `world1-hierarchy`              |
| underground map                    | `World1_UndergroundMap`              |      64x25 | `world1-hierarchy`              |
| World 1 palettes                   | `World1PaletteSets`                  |      12x32 | `world1-palette-00` to `-11`    |
| World 1 underground objects        | `World1_UndergroundObjectPlacements` |        100 | `world1-underground-objects`    |
| World 1 city objects               | `World1_CityObjectPlacements`        |        337 | `world1-city-objects`           |
| World 2 metatile palettes          | `World2_MetatilePaletteSelectors`    |        208 | `world2-metatiles`              |
| World 2 metatile tiles             | `World2_MetatileTiles_00_3F`         |      208x4 | `world2-metatiles`              |
| World 2 metatile collision bits    | `World2_MetatileCollisionBits`       |         26 | `world2-metatiles`              |
| World 2 palette sets               | `World2_PaletteSets`                 |       9x16 | `world2-palette-00` to `-08`    |
| World 2 stage sequence             | `World2_StageSequenceData`           |        229 | `world2-stage`                  |
| World 2 stage branches             | `World2_StageBranchTriggerScreens`   |       4x17 | `world2-branches`               |
| World 2 inventory-eligible screens | `World2_InventoryEligibleScreenIds`  |          7 | `world2-secret-screens`         |
| World 2 screen pointers            | `World2_ScreenPointerTable`          |      119x2 | `world2-screens`                |
| World 2 compressed screens         | `World2_CompressedScreenStreams`     | to `$FFFA` | `world2-screens`                |
| World 3 attributes                 | `World3_BlockAttributes`             |        256 | `world3-hierarchy`              |
| World 3 small blocks               | `World3_SmallBlocks`                 |      1,024 | `world3-hierarchy`              |
| World 3 big blocks                 | `World3_BigBlocks`                   |      1,024 | `world3-hierarchy`              |
| underwater map                     | `World3_Map`                         |      64x64 | `world3-hierarchy`              |
| World 3 initial room objects       | `World3_InitialRoomObjectRegistry`   |       5x13 | `world3-objects`                |
| World 3 transient spawn schedules  | `World3_TransientSpawnType0ByRoom`   |     3x4x64 | `world3-schedule`               |
| World 3 behavior pointers          | `World3_EntityBehaviorPointerTable`  |       16x2 | `world3-behavior`               |
| World 3 behavior streams           | `World3_EntityBehaviorStreams`       |      1,062 | `world3-behavior`               |
| World 3 room palette selectors     | `World3_RoomPaletteSelector`         |         64 | `world3-room-palette-selectors` |
| World 3 metasprite index           | `World3_MetaspriteIndex`             |      188x2 | `world3-metasprites`            |
| World 3 metasprite records         | `World3_MetaspriteRecords`           |      1,119 | `world3-metasprites`            |
| World 3 palette sets               | `World3_PaletteSets`                 |      11x32 | `world3-palette-00` to `-10`    |

`World2_UnindexedAttributePrefix` (the byte before the metatile palettes) and
`World2_CadEditorScreenRegion` are not runtime tables; see below.

## CadEditor offsets

CadEditor offsets are offsets in the complete `.nes` file, including its 16-byte
iNES header. A CPU address is the file offset minus the header and the physical
32 KiB bank base.

Small blocks are linear row-major 2x2 CHR-tile groups. Large blocks are linear
row-major 2x2 groups of small-block indexes. CadEditor masks the low two palette
selector bits while editing and preserves the upper six bits. Those upper bits
are zero throughout the canonical World 1 and World 3 tables, so their runtime
meaning remains unclassified rather than being assumed to be collision data.

The World 2 CadEditor declarations are a useful editable projection, not the
runtime storage format. The claimed 256x4 small-block table and 60 fixed-size
screens overlap each other. Runtime code instead reads a 229-byte stage sequence
at `World2_StageSequenceData`, indexes little-endian stream pointers at
`World2_ScreenPointerTable`, and expands variable-length screen tokens beginning
at `World2_CompressedScreenStreams`. The first 119 pointer slots address 116
unique ROM streams. `$7F` is a terminal sentinel: the preceding stop command
prevents stream decoding after the generic selector stores pointer `$00FC`.
`$7B`, the first byte of `World2_MetatileCollisionBits`, is collision data, not
a selector.

The metatile renderer fixes the table boundary independently of CadEditor.
Literal IDs `$00-$CF` select 208 palette bytes and 208 row-major 2x2 CHR-tile
records; the stage sequence follows them directly. The 208 MSB-first solid flags
occupy `World2_MetatileCollisionBits`. The `$FF` byte before the palette bytes
(`World2_UnindexedAttributePrefix`) is preserved but not indexed by the
renderer.

Each standard stream decodes sixteen rows of at least fifteen cells. Bytes below
`$D0` are literal cells, `$D0-$EE` emit an empty cell and spawn an enemy, `$EF`
terminates a row, and `$F1-$FF` repeat the following literal by the low nibble
plus one. The extra copy comes from falling through the counted loop to the
shared literal store. `$F0` is unused. Repeats may deliberately overshoot the
fifteen-cell threshold; the largest decoded row is 22 cells. The final stream
reads through `$FFFA`, reusing the low byte of the NMI vector as data.

## Summary by world

World 1's twelve complete 32-byte PPU palettes follow one another; the area
index selects one record directly. Its three weapon levels select one sound and
four direction-specific projectile spawn profiles, 51 contiguous bytes
(`world1-weapon-sounds`, `world1-weapon-shots`).

World 2's nine background/sprite palette sets and three chapter selector pairs
are selected by stage commands. World 2 also has 17 conditional route changes
stored as four parallel tables; they connect screen IDs and player-coordinate
zones to stage-sequence offsets. Seven screen IDs gate the appearance of World 2
companions and carried items.

World 3 initializes its persistent object registry from five contiguous 13-byte
arrays rather than from interleaved records. The arrays are room, type, X, Y,
and state. The next 32 bytes are sixteen little-endian behavior-stream pointers
for entity types `$00-$0F`; their targets cover the 1,062 bytes of
`World3_EntityBehaviorStreams`, which decode without gaps or invalid
control-flow targets.

The 768 bytes immediately before the persistent registry are twelve parallel
World 3 transient-spawn columns: type, count, and delay for four channels in
each of 64 rooms. The Studio shows them as one room-oriented schedule without
changing their physical column order.

Four smaller World 3 initializer-owned regions hold 152 bytes: 64 room flags for
type `$03`, a four-record type `$0C-$0F` formation, an eight-record type
`$0A/$0B` formation, and an eight-record type `$08/$09` formation. The World 3
update handlers own another 136 bytes: 64 type-`$04` tracking flags, four signed
type-`$05` held-motion vectors, and 64 persistent-relocation exclusion flags.

World 3's shared sprite catalog has 188 direct-or-alias index entries and 65
variable-length metasprite records. Eleven complete PPU palettes are selected by
a 64-room table.

The four music drivers expose 26 playable eight-byte track headers and 104
channel entries. A state-aware decoder follows fixed-width commands, counted
loops, saved-position jumps, track-channel restarts, and single-level stream
calls over 10,016 reachable bytes (`music`).
