# World 2 metatiles

World 2 screen literals are not CHR tile indexes. The renderer expands every
`$00-$CF` literal into one 2x2 CHR-tile metatile and merges a two-bit palette
selector into the nametable attribute cache.

## Exact runtime layout

| Region | Address | Size |
| --- | ---: | ---: |
| unindexed CadEditor prefix | `$B9CE` | 1 byte |
| palette selectors | `$B9CF-$BA9E` | 208 bytes |
| 2x2 CHR-tile quads | `$BA9F-$BDDE` | 208x4 bytes |
| stage sequence | `$BDDF-$BEC3` | 229 bytes |
| collision bitmap | `$BEC4-$BEDD` | 26 bytes / 208 bits |
| next region: screen pointers | `$BEDE` | - |

The four tile bytes are top-left, top-right, bottom-left, and bottom-right.
Routine `$84FC` uses the high two bits of the metatile ID to select bases
`$BA9F`, `$BB9F`, `$BC9F`, or `$BD9F`; the low six bits become a four-byte
offset. This addresses exactly 208 records because screen literals stop at
`$CF`. The last record ends at `$BDDE`, immediately before stage bytecode.

The collision routine at `$9377` converts a world coordinate to one of the 256
cells in the current `$0400` screen buffer. It splits the resulting metatile ID
into `id >> 3` and an MSB-first mask `$80 >> (id & 7)`, then tests the byte at
`$BEC4`. A set bit is treated as solid by movement and projectile callers. The
canonical bitmap marks 100 of 208 metatiles solid.

The byte `$FF` at `$B9CE` is the first byte of CadEditor's declared attribute
view, but the renderer indexes from `$B9CF`. It is preserved losslessly and
explicitly classified as unindexed; no gameplay meaning is inferred.

All 208 palette values are in `$00-$03`. Their canonical counts are 123, 20,
28, and 37. The standard ROM screen streams reference 203 metatile IDs. Five
records (`$27`, `$38`, `$44`, `$51`, and `$79`) are not referenced by those
streams. `$7F` is a stopped terminal sentinel and does not add another stream.

## Lossless authoring

`data/world2/metatiles.json` stores the prefix and 208 row-oriented records.
Each record contains its palette, four CHR indexes, solid flag, and whether a
standard ROM stream references the ID. Decode it with:

```text
python scripts/world2_metatiles.py decode --prg assets/generated/prg/doraemon.prg --manifest config/world2_metatiles.json --screen-authoring data/world2/compressed_screens.json --output data/world2/metatiles.json
```

An edited catalog can be applied to a base PRG:

```text
python scripts/world2_metatiles.py encode --input data/world2/metatiles.json --base-prg assets/generated/prg/doraemon.prg --output build/world2_metatiles.prg
```

`make validate-world2-metatiles` locks all four data CRCs, the complete
124-byte renderer signature, table boundaries, palette domain and histogram,
screen cross-references, collision lookup and bit order, authoring metadata,
and the 1,067-byte round trip.
