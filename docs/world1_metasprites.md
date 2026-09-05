# World 1 metasprites

World 1 uses one variable-length metasprite catalog for Doraemon, projectiles,
doors, items, enemies, and the chapter boss. `World1_ComposeMetasprite` receives
an index in `World1MetaspriteIndex`, resolves it through the table at `$9CB6`,
and writes ordinary four-byte NES OAM entries.

## Renderer RAM ABI

Bank 0 reserves the contiguous 16-byte workspace `$0041-$0050` for sprite
composition. Its exact field order is part of the validated metasprite
contract:

| Range | Role |
| --- | --- |
| `$0041-$0044` | staged OAM Y, tile, attributes, and X bytes |
| `$0045-$0048` | metasprite origin X/Y low bytes and derived high bytes |
| `$0049-$004A` | metasprite index and render flags |
| `$004B-$004C` | resolved record pointer |
| `$004D-$004E` | X/Y mirror extents from the record header |
| `$004F` | remaining piece count |
| `$0050` | even-valued OAM write index |

`World1_EmitOamEntry` doubles the write index to obtain a four-byte OAM offset,
stores the staged tuple, and adds two to the index. Bit 7 therefore marks the
64-entry OAM buffer as full. The player, HUD, and all four entity-slot classes
share this workspace and emitter.

## Index encoding

The table contains 115 two-byte entries for indexes `$00-$72`.

| Encoded high byte | Meaning |
| --- | --- |
| `$04-$FF` | little-endian pointer to a metasprite record |
| `$00-$03` | alias: low byte is another index and high byte is the flip mode |

Flip mode 0 draws normally, 1 mirrors horizontally, 2 mirrors vertically, and
3 mirrors on both axes. The renderer resolves exactly one alias level. All 42
aliases in the original table point directly to one of the other 73 entries;
there are no nested aliases.

Every `metasprite_base` in the 13-record World 1 descriptor catalog selects a
direct entry. Animation or state code can then select neighboring indexes in
the shared namespace.

## Variable-length records

`$9D9C-$A380` contains 73 contiguous records. A record consists of this header:

| Byte | Meaning |
| --- | --- |
| 0 | number of eight-by-eight sprite pieces |
| 1 | X extent used by horizontal reflection |
| 2 | Y extent used by vertical reflection |

The header is followed by `count` triples in Y-offset, X-offset, CHR-tile
order. Bit 7 of an offset requests the matching OAM flip after the renderer
strips it from the coordinate. Alias flip modes reflect offsets around the
header extents and invert those piece flips.

All 73 direct entries point to distinct record starts, and every record is
referenced. Most records contain four or six pieces; six very large animation
frames contain 20, 24, or 26 pieces. Across the catalog, the records use 234
distinct tiles from CHR bank 0's sprite pattern table.

## Lossless authoring

`data/world1/metasprites.json` exposes every index, pointer, alias mode, record
header, piece coordinate, and tile number. Its two adjacent physical ranges
cover 1,739 bytes with combined CRC32 `afe6e215`.

Run `make validate-world1-metasprites` to prove:

- the exact 73-direct/42-alias partition;
- record boundaries, pointer targets, and absence of nested aliases;
- all descriptor-base cross-references;
- the exact 16-byte renderer workspace and OAM-emitter symbol ownership;
- the pinned CHR bank and renderer code signature;
- a byte-exact decode/encode round trip over the full catalog.

For research, `scripts/world1_metasprites.py render` produces a contact sheet
of all 115 indexes. Descriptor bases are outlined in gold; the image is a build
artifact and is not committed.
