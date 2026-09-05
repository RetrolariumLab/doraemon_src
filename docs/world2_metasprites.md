# World 2 metasprites

World 2 uses a fixed 16-by-16 metasprite format for the player, enemies,
projectiles, effects, and large composite enemies. The renderer at `$A35B`
selects one of 58 records and emits four ordinary NES OAM entries in a
two-by-two arrangement.

## Three-table format

Each metasprite index selects parallel data:

| Range | Entries | Meaning |
| --- | ---: | --- |
| `$A3DC-$A4C3` | 58 × 4 | top-left, top-right, bottom-left, bottom-right CHR tiles |
| `$A4C4-$A4FD` | 58 | palette in bits 0-1 and OAM-attribute base in bits 2-5 |
| `$A526-$A549` | 36 | per-piece priority and horizontal/vertical flip bits |

The descriptor's attribute base is a multiple of four. The renderer adds the
piece number, reads the corresponding OAM attribute, and then ORs in the
two-bit palette. Horizontal reflection XORs the tile and attribute indexes
with three and toggles the OAM horizontal-flip bit. Tile zero suppresses the
OAM append, which accounts for four empty pieces in the canonical catalog.

The catalog contains 118 distinct CHR tile numbers. Its descriptors select all
four sprite palettes with histogram 11, 22, 10, and 15. World 2 explicitly
selects CHR bank 1 and configures 8-by-8 sprites from pattern table `$0000`.

## Enemy-state references

The 20 ordinary enemy states directly select 45 of the 58 metasprite indexes.
`config/world2_metasprites.json` records each exact state-to-index set,
including the six-index composite renderers for states `$12` and `$13` and
the invisible states `$09` and `$11`.

The remaining thirteen indexes are not unused globally. Most participate in
the `$70-$7A` enemy defeat/effect path or sit between the grouped composite
frames. The contract therefore calls them only *not directly selected by the
ordinary enemy-state render handlers*.

## Shared storage

Two boundaries deliberately have more than one interpretation:

- descriptor 57 at `$A4FD` is also state zero of the enemy attack-period
  table;
- OAM attributes 34 and 35 at `$A548-$A549` are also the unused state-zero
  prefix immediately before the active render dispatch at `$A54A`.

Both views are checked against the enemy-state and object-dispatch contracts.
The source keeps labels at each semantic boundary, so the overlap remains
visible in the assembled representation.

## Lossless authoring and rendering

`data/world2/metasprites.json` exposes all 58 tile quads and descriptors plus
all 36 OAM attribute bytes. The three physical ranges cover 326 unique bytes
with combined CRC32 `512433b5` and round-trip without loss.

Run `make validate-world2-metasprites` for the full data, overlap, CHR, palette,
enemy-reference, renderer-signature, and authoring checks. A research contact
sheet can be generated without adding ROM-derived graphics to Git:

```text
python -B scripts/world2_metasprites.py render \
  --prg assets/generated/prg/doraemon.prg \
  --chr assets/generated/chr/doraemon.chr \
  --manifest config/world2_metasprites.json \
  --palette-authoring data/world2/palettes.json \
  --palette-record 7 \
  --output build/world2_metasprites.png
```
