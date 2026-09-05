# World 3 spawn initializers

Every transient type `$00-$0F` indexes a little-endian pointer at `$8F6C`.
`World3_InitializeSpawnedEntity` clears the new entity's behavior selector and
calls that target through the shared indirect trampoline. The initializer can
adjust appearance, replace the generic random placement with fixed coordinates,
disable the entity, or expand it into a multi-object formation.

## Initializer roles

| Type | Target | Structural role |
| ---: | ---: | --- |
| `$00` | `$8F8C` | room-range and random metasprite variant |
| `$01` | `$8FA3` | room-range and random metasprite/render-flag variant |
| `$02` | `$8FBF` | fixed `$80,$98` position, state 1, optional sound |
| `$03` | `$8FDB` | room-table-selected alternate metasprite |
| `$04` | `$9028` | initializes a one-unit clone budget |
| `$05` | `$902E` | no-op |
| `$06` | `$902F` | random metasprite and variant selection |
| `$07` | `$9044` | fixed `$B0,$A8` position in gated rooms `$26/$3B` |
| `$08` | `$9071` | gated type `$08/$09` encounter in rooms `$27/$28/$34` |
| `$09` | `$90AA` | no-op and not directly scheduled |
| `$0A` | `$90AB` | expands the type `$0A/$0B` encounter formation |
| `$0B` | `$90AE` | no-op and not directly scheduled |
| `$0C` | `$90AF` | expands a four-object type `$0C-$0F` formation |
| `$0D-$0F` | `$90B2` | shared no-op target; not directly scheduled |

These names describe code behavior, not character identities. Types `$09`,
`$0B`, and `$0D-$0F` still have initializer entries because they can be created
by a group initializer or belong to the complete low-type dispatch domain.

The room schedule directly activates eleven types: `$00-$08`, `$0A`, and
`$0C`. Their active room/channel record counts are 20, 13, 3, 8, 33, 45, 1,
2, 3, 3, and 1 respectively. Their corresponding byte-count budgets total
140, 98, 300, 78, 197, 45, 250, 2, 3, 3, and 1. The validator derives these
figures from `data/world3/transient_spawns.json` rather than duplicating the
schedule decoder.

## Formation data

Four non-contiguous regions belong to the initializer system:

| Region | Range | Layout |
| --- | --- | --- |
| type `$03` room variants | `$8FE8-$9027` | 64 one-byte boolean flags |
| type `$0C-$0F` formation | `$90F4-$9103` | 4 records: state, X, Y, type |
| type `$0A/$0B` formation | `$AC6C-$AC8B` | 8 records: state, X, Y, type |
| type `$08/$09` formation | `$ACF9-$AD20` | 8 records: state, X, Y, type, frame counter |

The type `$0C` initializer replaces its initially allocated slot and then
allocates up to three more, producing types `$0C-$0F` at the four corners
`($28,$30)`, `($D8,$30)`, `($28,$C0)`, and `($D8,$C0)`.

The type `$0A` initializer fills all remaining slots from its eight-entry
type `$0A/$0B` table. The type `$08` initializer requires a low enough free-slot
index, then emits one or two four-entry groups from its type `$08/$09` table and
records each group's ending slot as a collision scan bound.

## Lossless authoring

`data/world3/spawn_initializer_data.json` transposes all four physical column
sets into row-oriented records while preserving 152 bytes with combined CRC32
`f8157287`. Run `make validate-world3-spawn-initializers` to verify all sixteen
dispatch targets, initializer code signatures, table CRCs, boolean room flags,
scheduled type frequencies and budgets, and the complete authoring round trip.
The tool also provides `decode` and `encode` subcommands.
