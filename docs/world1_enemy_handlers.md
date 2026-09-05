# World 1 enemy handlers

World 1 has two object paths that must not be conflated. Ordinary placement
types `$00-$0B` materialize into the ten-slot update pool at `$0400-$0409`.
Descriptor-backed placements use the separate interactive-object pool at
`$0426-$042F`; their 13 descriptor types are documented independently in
`world1_descriptors.md`.

## Materialization

For an ordinary three-byte placement, `World1_MaterializePlacement` writes
`placement_type + 1` as the runtime state and loads three parallel 16-byte
tables:

| Address | Field |
| ---: | --- |
| `$8E70` | initial metasprite index |
| `$8E80` | initial render flags |
| `$8E90` | initial health |

Only placement types `$00-$0B` occur. They account for 112 records: 77 in the
city and 35 underground. The remaining four property slots are zero padding.
All 12 initial metasprite indexes resolve directly in the World 1 metasprite
catalog.

The placement type, not the resulting runtime state, also selects one of eight
RTS-minus-one initializer slots at `$8DA4` after masking with `$0F`. Types 8-11
therefore reuse initializer slots 0-3.

## Runtime dispatch

`World1_UpdateEntities` walks the ten update slots and masks each active type
to five bits. The overlapping RTS-minus-one table at `$88FB` has 16 entries:
state 0 is the inactive loop tail, and states `$01-$0F` form the catalog in
`config/world1_enemy_handlers.json`.

- States `$01-$0C` are produced directly from map placements.
- State `$0D` has a dispatch entry sharing the state-1 handler, but no ordinary
  placement, initializer properties, or proven writer; it remains explicitly
  classified as dormant.
- States `$0E` and `$0F` share a no-op dispatch target because their boss
  behavior is driven by the surrounding scripted controller at `$D67A`.

Two pairs of directly placed states deliberately share initial artwork while
using different handlers: `$04/$0B` both start at metasprite `$60`, and
`$05/$0C` both start at `$58`. Their placement split matches the distinct city
and underground movement systems and is preserved as separate lifecycle
states.

## Rewards and checks

When an ordinary enemy finishes its defeated-state sequence, its low six state
bits select the encoded score table at `$891B`. The handler contract records
all entries `$01-$0F` and joins each handler to the evidence-backed identity
catalog in `world1_enemy_identities.md`. The generated assembly therefore uses
enemy names while keeping dormant state `$0D` explicit in the shared Yuubou
handler name.

Run `make validate-world1-enemy-handlers` to verify the dispatch bytes and
registered symbols, all four property tables and CRCs, the complete placement
histogram, metasprite-base relationships, lifecycle partition, and the normal
materializer plus scripted-boss code signatures.
