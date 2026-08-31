# RAM map

| Address | Size | Working name | Evidence |
| --- | ---: | --- | --- |
| `$0014` | 1 | NMI OAM-DMA request | gates `$4014` write |
| `$0015` | 1 | NMI busy lock | checked/set/cleared by NMI |
| `$0017` | 1 | compact mapper selection | indexes `$8261` table |
| `$0018` | 1 | compact CHR-selection bits | ORed after preserving `$17 & 3` |
| `$0019` | 1 | PPUCTRL shadow | written to `$2000` |
| `$001A` | 1 | PPUMASK shadow | written to `$2001` |
| `$001D-$0020` | 4 | controller shift state | populated from `$4016/$4017` |
| `$0290-$0295` | 6 | current score digits | decimal compare/copy loop |
| `$0298-$029D` | 6 | working score digits | decimal carry loop |

Only aliases used by a proven access pattern are named. Chapter-specific object,
collision, camera, and transition state remains the main runtime-tracing task.
