# World 2 palettes

World 2 stores nine distinct 16-byte NES palette sets at `$87A1-$8830`.
Routine `$8751` uploads a background set to PPU `$3F00`; routine `$8784`
continues at `$3F10` with a sprite set during chapter initialization.

## Lookup relationships

Background IDs are indexed from `$8791`, exactly sixteen bytes before the
tracked data. Therefore ID 1 selects record 0 at `$87A1`, ID 2 selects record 1,
and so on. The decoder accepts `$F9-$FF` as IDs 1-7, while the canonical
229-byte stage sequence contains seven requests using IDs 1-6. Each request
stores the ID in both the pending byte at `$009D` and saved selector `$00B4`.

The pending request consumer at `$8747` uploads the selected set and clears the
request. A negative request, used by the transition loop, instead selects
`$0073 & 3`; ID 0 deliberately starts at `$8791`, overlapping the tail of the
palette-upload code. The complete `$8747-$87A0` signature is pinned so that
this code/data overlap cannot be normalized away accidentally.

Chapter initialization uses two three-byte tables:

| Chapter | Background ID | Sprite offset | Sprite record |
| ---: | ---: | ---: | ---: |
| 0 | 1 | `$10` | 6 |
| 1 | 4 | `$20` | 7 |
| 2 | 5 | `$30` | 8 |

Sprite offsets are added to `$87F1`; the resulting addresses are `$8801`,
`$8811`, and `$8821`. All 144 palette bytes are valid `$00-$3F` NES colors,
all nine sets are distinct, and every set begins with universal color `$0F`.

## Lossless authoring

`data/world2/palettes.json` stores nine ordered color arrays and the three
chapter selector pairs. Decode the canonical data with:

```text
python scripts/run.py validation.world2.world2_palettes decode --prg assets/generated/prg/doraemon.prg --manifest config/authoring/world2/world2_palettes.json --stage-authoring data/world2/stage_sequence.json --output data/world2/palettes.json
```

Apply an edited catalog to a base PRG with:

```text
python scripts/run.py validation.world2.world2_palettes encode --input data/world2/palettes.json --base-prg assets/generated/prg/doraemon.prg --output build/world2_palettes.prg
```

`make validate-world2-palettes` verifies data CRCs, both code signatures,
chapter lookup arithmetic, the seven stage palette commands, NES color limits,
and the complete 150-byte authoring round trip.
