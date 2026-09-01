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
| `$0290-$0295` | 6 | current score digits | decimal compare/copy loop |
| `$0298-$029D` | 6 | working score digits | decimal carry loop |
| `$0400-$066F` | 624 | World 1 entity storage | complete 13-column, 48-slot structure-of-arrays grid with class-specific behavior overlays |
| `$0558-$05CE` | 119 | World 2 entity pools | bank-1 overlay containing 7 enemies, 6 enemy projectiles, and 7 player projectiles |
| `$0600-$06AF` | 176 | World 3 active objects | bank-2 overlay containing eight parallel runtime entity slots |
| `$06B0-$06F0` | 65 | World 3 persistent objects | thirteen room records with room, type, coordinates, and saved state |

Only aliases used by a proven access pattern are named. Chapter-specific object,
collision, camera, and transition state remains the main runtime-tracing task.
The field-level registry and its bank ownership are documented in
`docs/ram_fields.md`.
