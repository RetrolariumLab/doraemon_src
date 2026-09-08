# World 1 weapon profiles

The city and underground player paths share one firing routine and the same
three-level projectile catalog. `data/world1/weapons.json` presents the compact
physical tables as level records with four named directions.

## Physical layout

| Range | Bytes | Contents |
| --- | ---: | --- |
| `$9C83-$9C85` | 3 | sound effect ID for weapon levels 1-3 |
| `$9C86-$9CB5` | 48 | 3 levels × 4 directions × 4 profile fields |

The sound instruction indexes from `$9C82`, one byte before the actual sound
data, because weapon levels begin at 1. That byte is also the final `RTS` of
`World1_UpdateWeaponAndTryFire`; the source therefore names it
`World1_WeaponSoundByLevelMinusOne`. This is an intentional biased lookup, not
an extra level-zero sound.

Each profile stores `x_offset`, `y_offset`, `metasprite`, and `render_flags`.
The index is `(weapon_level - 1) * 16 + direction * 4`, where direction values
0-3 mean down, up, left, and right. The loader adds the first two fields to the
player position and copies the remaining fields into the allocated projectile
slot.

## Lossless authoring

The authoring encoder preserves physical order and emits exactly 51 contiguous
bytes. Level IDs must be 1-3, every level must contain all four directions in
runtime order, and every field is an unsigned byte. Edits can be applied to a
base PRG with:

```text
python scripts/run.py validation.world1.world1_weapons encode \
  --input data/world1/weapons.json \
  --manifest config/authoring/world1/world1_weapons.json \
  --base-prg assets/generated/prg/doraemon.prg \
  --output build/world1-weapons.prg
```

The release gate checks both table CRCs, the complete authoring round trip,
both operand symbols, and three code signatures covering the biased sound
lookup, level/direction index arithmetic, and four-field loader. Run:

```text
make validate-world1-weapons
```
