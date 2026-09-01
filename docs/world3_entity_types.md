# World 3 entity types

World 3 uses one byte-valued type domain `$00-$1F` across its eight active
entity slots. The type selects per-type properties and the 32-slot update
handler table at `$92DF`. Types below `$10` additionally select both a random
spawn initializer at `$8F6C` and a packed behavior stream at `$D9AC`.

`config/world3_entity_types.json` joins those three dispatch views with five
contiguous 32-byte property columns. `scripts/world3_entity_types.py` validates
the catalog against the canonical PRG, the ordinary object-dispatch manifest,
and the persistent registry manifest.

## Per-type property columns

| CPU range | Source label | Runtime use |
| --- | --- | --- |
| `$8EB5-$8ED4` | `World3_EntityHitPointsByType` | copied into a newly spawned entity's damage countdown |
| `$8ED5-$8EF4` | `World3_EntityMetaspriteByType` | base metasprite selected during spawn, materialization, and type changes |
| `$8EF5-$8F14` | `World3_EntityRenderFlagsByType` | ORed into the per-entity renderer flags |
| `$8F15-$8F34` | `World3_EntityContactDamageByType` | subtracted from player health on contact |
| `$8F35-$8F54` | `World3_EntityScoreRewardCodeByType` | passed to the score updater after defeat or collection |

Each column has exactly 32 entries, so the same type index can be used without
bounds conversion. The symbol registry marks only these proven PRG data labels
as operand symbols; the deterministic generator therefore emits symbolic
indexed loads while leaving unrelated numeric PRG operands untouched.

## Lifecycle domains

The catalog partitions every type ID exactly once:

| Types | Evidence-backed role |
| --- | --- |
| `$00-$0F` | Scripted spawn types with 16 initializer slots and 16 behavior-stream pointers |
| `$10-$13` | Possible post-defeat results of low types `$00-$04` |
| `$14-$1B`, `$1F` | Types present in the thirteen-record initial persistent registry |
| `$1C-$1E` | Persistent results produced from `$14-$16` by adding eight |

The post-defeat conversion is encoded at `$91F1`: after a random value is
masked to `0-3`, the code adds `$10` and stores the result as the new type. It
is reached only for dying types below `$05`.

The persistent conversion at `$987E` adds eight to a nearby type in the
`$14-$16` range and writes the result to both the persistent registry and the
active entity. Thus the three paired transitions are `$14->$1C`, `$15->$1D`,
and `$16->$1E`.

These names describe storage and control-flow roles, not character identities.
Assigning names from sprites or external game guides remains separate work.

## Validation

Run the focused contract with:

```text
make validate-world3-entity-types
```

It proves five property columns, 16 initializer pointers, 16 behavior pointers,
32 update pointers, four nonoverlapping lifecycle domains, the exact initial
persistent type multiset, and both encoded type transformations.
