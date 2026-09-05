# World 3 spawn initializers

Every transient type `$00-$0F` indexes a little-endian pointer at `$8F6C`.
`World3_InitializeSpawnedEntity` clears the new entity's behavior selector and
calls that target through the shared indirect trampoline. The initializer can
adjust appearance, replace the generic random placement with fixed coordinates,
disable the entity, or expand it into a multi-object formation.

## Initializer roles

| Type | Target | Structural role |
| ---: | ---: | --- |
| `$00` | `$8F8C` | selects Kame or Battle Fish graphics by region/randomness |
| `$01` | `$8FA3` | selects Kani or Otoshigo graphics and render flags |
| `$02` | `$8FBF` | fixes a volcanic rock at `$80,$98`, state 1, with optional sound |
| `$03` | `$8FDB` | selects Gyokkun or the castle-room Gansuke metasprite |
| `$04` | `$9028` | gives a skull a one-unit clone budget |
| `$05` | `$902E` | ghost no-op initializer |
| `$06` | `$902F` | selects the punishment-room swarm's collectible dorayaki or damaging skull form |
| `$07` | `$9044` | fixes Genki Candy at `$B0,$A8` in gated rooms `$26/$3B` |
| `$08` | `$9071` | creates a giant-octopus formation in rooms `$27/$28/$34` |
| `$09` | `$90AA` | octopus-segment no-op; not directly scheduled |
| `$0A` | `$90AB` | expands the dragon head/body formation |
| `$0B` | `$90AE` | dragon-segment no-op; not directly scheduled |
| `$0C` | `$90AF` | expands Poseidon into four quadrant objects |
| `$0D-$0F` | `$90B2` | Poseidon-part no-op target; not directly scheduled |

Types `$09`, `$0B`, and `$0D-$0F` retain initializer entries because group
initializers create them and the dispatch table covers the complete low-type
domain. Function names preserve the numeric ID while appending the recovered
identity, for example `World3_InitTransientType0CPoseidon`.

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
| Gansuke room selector | `$8FE8-$9027` | 64 one-byte boolean flags |
| Poseidon formation | `$90F4-$9103` | 4 records: state, X, Y, type |
| dragon formation | `$AC6C-$AC8B` | 8 records: state, X, Y, type |
| giant-octopus formation | `$ACF9-$AD20` | 8 records: state, X, Y, type, frame counter |

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
