# World 3 metasprites and palettes

World 3 renders the player, projectiles, transient entities, and persistent
objects through one metasprite catalog. The renderer at `$B4B6` consumes an
index in `$79`, resolves a two-byte entry at `$B6D7`, and appends ordinary
four-byte NES OAM records through `$B6BA`.

## Index encoding

The index contains 188 entries for values `$00-$BB`.

| Encoded high byte | Meaning |
| --- | --- |
| `$04-$FF` | little-endian direct pointer to a metasprite record |
| `$00-$03` | alias: low byte is another index and high byte is the flip mode |

Flip mode 0 draws normally, 1 mirrors horizontally, 2 mirrors vertically, and
3 mirrors on both axes. The canonical table contains 130 direct entries and 58
horizontal aliases. It references 64 distinct record addresses.

Alias resolution is deliberately one level deep. Index `$07` points to index
`$04`, which is itself an alias; no proven runtime base or variant selects
`$07`. The contract records this exceptional dormant entry instead of treating
the table as recursively resolvable.

All 32 base indexes in the entity-type catalog resolve directly. Animation
adds the per-entity zero-to-three variant fields after selecting that base, so
direct and alias entries share one index namespace.

## Variable-length records

`$B84F-$BCAD` holds 65 contiguous records. Each record starts with:

| Byte | Meaning |
| --- | --- |
| 0 | number of sprite pieces |
| 1 | X extent used by horizontal reflection |
| 2 | Y extent used by vertical reflection |

The header is followed by `count` triples in Y-offset, X-offset, CHR-tile
order. Bit 7 of either coordinate becomes the matching NES OAM flip bit after
the renderer strips it from the coordinate. The record histogram is one
two-piece record, 39 four-piece records, and 25 six-piece records. Together
they reference 235 distinct CHR tile indexes.

The direct index targets every record except `$B8CD`. That complete but
unreferenced record remains part of the editable catalog and is protected by
the same round-trip checks.

## Palette selection

Eleven complete 32-byte PPU palettes occupy `$BCAE-$BE0D`. The 64-byte table at
`$ADD2` selects one palette per room. `World3_LoadRoomPalette` multiplies the
selector by 32, adds `$BCAE`, and copies the full result to the palette staging
buffer at `$0705-$0724`. Every selector is in `$00-$0A`; final rooms use palette
10 at `$BDEE`, which the transition path can also upload directly.

## Lossless authoring

`data/world3/metasprites.json` exposes all index entries, record headers,
sprite-piece coordinates and tile numbers, palette colors, and room selectors.
Its four physical ranges cover 1,911 bytes with combined CRC32 `5d1903b6`.

Run `make validate-world3-metasprites` to prove:

- the direct-pointer and alias partition for all 188 indexes;
- exact variable-record boundaries and pointer targets;
- entity-type base-index cross-references;
- the palette domain and room-selector histogram;
- renderer, OAM writer, and palette-loader code signatures;
- a byte-exact decode/encode round trip of all four ranges.
