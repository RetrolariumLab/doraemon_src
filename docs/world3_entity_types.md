# World 3 entity types

World 3 uses one byte-valued type domain `$00-$1F` across its eight active
entity slots. The type selects per-type properties and the 32-slot update
handler table at `$92DF`. Types below `$10` additionally select both a random
spawn initializer at `$8F6C` and a packed behavior stream at `$D9AC`.

`config/authoring/world3/world3_entity_types.json` joins those three dispatch views with five
contiguous 32-byte property columns. `scripts/validation/world3/world3_entity_types.py` validates
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

## Recovered identities

The type byte is a behavior class, not always a single visual identity. Three
low types select a stronger or region-specific form while preserving the same
type: `$00` is either Kame or Battle Fish, `$01` is Kani or Otoshigo, and `$03`
is Gyokkun or the castle-only Gansuke. The initializer's alternate metasprite
indexes `$A4`, `$A8`, and `$B4` establish those pairings.

| Type | Identity | Structural evidence |
| --- | --- | --- |
| `$00` | Kame / Battle Fish (`カメ / バトルフィッシュ`) | base `$10`, initializer alternate `$A4` |
| `$01` | Kani / Otoshigo (`カニ / オトシゴ`) | base `$14`, initializer alternate `$A8` |
| `$02` | volcanic rock (`火山弾`) | fixed spawn and metasprite `$18` |
| `$03` | Gyokkun / Gansuke (`ギョックン / ガンスケ`) | base `$1C`, castle-room alternate `$B4` |
| `$04` | skull (`ガイコツ`) | metasprite `$20`, castle tracking path |
| `$05` | ghost (`ユーレイ`) | metasprite `$24`, delayed capture/relocation path |
| `$06` | punishment-room dorayaki/skull swarm (`おしおき部屋`) | 20-treasure warp to room `$12`, 250-spawn schedule, damaging `$20` skulls, collectible `$40` dorayaki, 20-dorayaki exit |
| `$07` | Genki Candy (`元気キャンディ`) | candy graphic, two flag-gated fixed placements |
| `$08-$09` | giant-octopus tentacle tip and segment (`大ダコ`) | two four-part formations; only `$08` has hit points |
| `$0A-$0B` | dragon head and body (`ドラゴン`) | one head plus seven circular body segments |
| `$0C-$0F` | four Poseidon quadrants (`ポセイドン`) | corner formation, linked movement, four matching graphics |
| `$10-$13` | stopwatch, dorayaki, diamond, gold bar | exact item graphics and post-defeat result domain |
| `$14-$16` | Suneo, Nobita, and Gian chests | key path transforms them to `$1C-$1E` by adding eight |
| `$17` | dragon chest | key path removes it and seeds the `$0A/$0B` formation |
| `$18-$1B` | talisman, Passing Hoop, key, Holding Bag | graphics match roles: reward, terrain, chest conversion, carrying |
| `$1C-$1F` | Suneo, Nobita, Gian, Shizuka | character graphics and persistent follow-player path |

All rows converge between local graphics/control flow and at least one
published guide. Type `$06` deliberately keeps a descriptive name rather than
inventing a standalone character name. Two guides describe the same forced
punishment-room event, and the ROM proves the complete chain: diamond/gold
types `$12/$13` increment a counter, 20 pickups force room `$12`, its only
active schedule emits type `$06`, `$20` is the damaging skull branch, `$40` is
the collectible dorayaki branch, and collecting 20 dorayaki exits. The
machine-readable catalog records the evidence sources, forms, Japanese names,
confidence, and chest-to-companion links for every type.

## Validation

Run the focused contract with:

```text
make validate-world3-entity-types
```

It proves five property columns, 16 initializer pointers, 16 behavior pointers,
32 update pointers, four nonoverlapping lifecycle domains, the exact initial
persistent type multiset, both encoded type transformations, and 32 contiguous
identity records. Three additional code relationships pin the punishment-room
entry, type `$06` collision split, and exit conditions. Confirmed identities
must cite both local-ROM evidence and an external source; base graphics, named
chest transformations, and punishment behavior are checked against the binary
catalogs and code signatures.

For editing, `data/world3/object_catalog.json` joins each type's five property
values into one record and also joins the five persistent registry columns into
thirteen object records. `make validate-world3-object-catalog` transposes that
representation back to the original ROM layout and requires a byte-exact match.

The optional Pillow-backed research renderer reproduces the type contact sheet
from the private CHR input and decoded metasprites without tracking the image:

```text
python -B scripts/run.py validation.world3.world3_metasprites render-types \
  --prg assets/generated/prg/doraemon.prg \
  --chr assets/generated/chr/doraemon.chr \
  --manifest config/authoring/world3/world3_metasprites.json \
  --entity-types config/authoring/world3/world3_entity_types.json \
  --output build/research/world3_entity_types.png
```
