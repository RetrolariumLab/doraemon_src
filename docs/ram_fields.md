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

These aliases apply only to PRG bank 0. Later fields at `$0520-$066F` contain
parallel behavior state but retain numeric operands until their per-type roles
are separated. The `$0670-$06AF` area is also deliberately unnamed because the
city object bitsets and underground mode reuse parts of it differently.

## World 2 entity pools

Bank 1 uses compact parallel arrays whose stride is the pool capacity, rather
than World 1's single 48-slot layout. Independent clear, spawn, update,
collision, and render loops establish three pools.

| Pool | Capacity | State/flags | X | Y | Additional proved field |
| --- | ---: | --- | --- | --- | --- |
| Enemies | 7 | `World2EnemyState` `$0558` | `World2EnemyX` `$055F` | `World2EnemyY` `$0566` | - |
| Enemy projectiles | 6 | `World2EnemyProjectileFlags` `$0589` | `World2EnemyProjectileX` `$058F` | `World2EnemyProjectileY` `$0595` | Y zero is the inactive sentinel |
| Player projectiles | 7 | `World2PlayerProjectileState` `$05B3` | `World2PlayerProjectileX` `$05BA` | `World2PlayerProjectileY` `$05C1` | `World2PlayerProjectileDirection` `$05C8` |

The unlisted fields between these bases are timers, animation state, velocity,
or handler-specific work. They stay numeric until each meaning is established
across every handler that shares the pool.

## World 3 active and persistent objects

Bank 2 separates the eight objects currently simulated in a room from a
13-record persistent room-object registry. Room loading matches each registry
record's room number, allocates an active slot, and copies type and coordinates
into it. Room exit performs the reverse copy for matching objects.

| Active entity field | Address | Size | Role |
| --- | ---: | ---: | --- |
| `World3EntityState` | `$0600` | 8 | Zero means free; nonzero states select update phases |
| `World3EntityX` | `$0608` | 8 | Active X coordinate |
| `World3EntityY` | `$0610` | 8 | Active Y coordinate |
| `World3EntityMetasprite` | `$0628` | 8 | Type-derived animation/metasprite value |
| `World3EntityType` | `$0638` | 8 | Object type and behavior-dispatch index |

| Persistent record field | Address | Size | Role |
| --- | ---: | ---: | --- |
| `World3RoomObjectRoom` | `$06B0` | 13 | Owning room number |
| `World3RoomObjectType` | `$06BD` | 13 | Object type copied to the active pool |
| `World3RoomObjectX` | `$06CA` | 13 | Saved X coordinate |
| `World3RoomObjectY` | `$06D7` | 13 | Saved Y coordinate |
| `World3RoomObjectState` | `$06E4` | 13 | State restored on materialization and saved on room exit |

Other eight-slot fields between `$0618` and `$06AF`, and the two-slot structure
at `$06F9`, remain numeric pending complete animation, collision, and transient
effect semantics.

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
