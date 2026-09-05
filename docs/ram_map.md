# RAM map

| Address | Size | Working name | Evidence |
| --- | ---: | --- | --- |
| `$0014` | 1 | NMI OAM-DMA request | gates `$4014` write |
| `$0015` | 1 | NMI busy lock | checked/set/cleared by NMI |
| `$0017` | 1 | compact mapper selection | indexes `$8261` table |
| `$0018` | 1 | compact CHR-selection bits | ORed after preserving `$17 & 3` |
| `$0019` | 1 | PPUCTRL shadow | written to `$2000` |
| `$001A` | 1 | PPUMASK shadow | written to `$2001` |
| `$001B-$001C` | 2 | scroll shadows | written to `$2005` in X/Y order |
| `$001D-$0020` | 4 | controller shift state | populated from `$4016/$4017` |
| `$0023-$0024` | 2 | Famicom microphone state | retained bit-2 sample and 20-frame edge window |
| `$0025-$0027` | 3 | score award and demo state | next 1UP threshold, sound event, and attract-mode flag |
| `$002A-$002C` | 3 | shared player progression | lives, current health, and inverse health-capacity index |
| `$0041-$0050` | 16 | World 1 metasprite workspace (bank 0) | staged OAM tuple, origin, index/flags, record pointer/header, piece count, and write index |
| `$004D` | 1 | World 3 treasure penalty counter | 20 diamond/gold pickups force punishment room `$12` |
| `$0052-$0053` | 2 | World 1 frame-mixed random state | updated with the frame counter by the seven-call generator |
| `$0053-$0054` | 2 | World 3 punishment room state | active flag and saved return room |
| `$0054-$0057` | 4 | World 1 main random state | state-only generator used by eighteen direct callers |
| `$0058` | 1 | World 1 horizontal nametable | PPU control bit 0 and streamed-edge destination selector |
| `$0059-$005A` | 2 | World 1 PPU scroll latch | scroll pair published by NMI one update behind the current shadows |
| `$005B-$005C` | 2 | World 1 coarse camera position | horizontal and vertical world-map coordinates in 8-pixel cells |
| `$0060` | 1 | World 1 map prefill countdown | 152 two-pixel iterations prepare the initial viewport |
| `$0061-$0062` | 2 | World 1 screen delta | signed camera-motion compensation applied to player and entities |
| `$0066-$0067` | 2 | World 1 active map pointer | selects city `$B2EF` or underground `$C2EF` data |
| `$006A-$0072` | 9 | World 1 map-decoder cursor | current small/big-block and row pointers plus three hierarchy indexes |
| `$0075-$007F` | 11 | World 1 player state | X/Y, metasprite, render flags, damage/death state, animation divider, weapon tier, side-view airborne/velocity/subpixel state, and direction |
| `$00A8` | 1 | World 3 punishment dorayaki remaining | starts at 20 and controls early exit |
| `$00AB-$00C7` | 29 | World 3 transient scheduler | four type/count/delay/completion channels, prescaler phases, reload values, and scratch state |
| `$0230-$028E` | 92 of 95 | World 1 map-streaming packets | column and row tile/attribute buffers, pending flags, wrap scratch, and two-entry nibble queue |
| `$0290-$0295` | 6 | current score digits | decimal compare/copy loop |
| `$0298-$029D` | 6 | working score digits | decimal carry loop |
| `$0400-$066F` | 624 | World 1 entity storage | complete 13-column, 48-slot structure-of-arrays grid with class-specific behavior overlays |
| `$0558-$05CE` | 119 | World 2 entity pools | bank-1 overlay containing 7 enemies, 6 enemy projectiles, and 7 player projectiles |
| `$0600-$06AF` | 176 | World 3 active objects | bank-2 overlay containing eight parallel runtime entity slots |
| `$06B0-$06F0` | 65 | World 3 persistent objects | thirteen room records with room, type, coordinates, and saved state |
| `$0725-$0736` | 18 | World 3 punishment player snapshot | saves `$008C-$009D` across the forced room |

Only aliases used by a proven access pattern are named. Chapter-specific
collision, camera, transition state, and remaining object semantics continue to
be recovered incrementally.
The field-level registry and its bank ownership are documented in
`docs/ram_fields.md`.
