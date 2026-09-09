# World 1 Data and Rendering Formats

This chapter joins the persistent object, map, streaming, sprite, palette, room, and weapon formats used by World 1. The `config/authoring/world1/` manifests and checked-in `data/world1/` documents remain the canonical schemas and editable representations.

## Contents

- Descriptor objects and identities
- Hierarchical map decoding and PPU streaming
- Metasprites and palettes
- Underground rooms and weapon profiles

## World 1 descriptor identities

The thirteen descriptor records at `$CC0A` represent two portals and eleven
collectible or hidden objects. Their identities are fixed by joining the exact
descriptor fields with placement frequency, the five selector slots at
`$94D4-$94D8`, direct metasprites, the type `$03-$0D` interaction dispatch,
and each handler's concrete state change.

| Descriptor | Runtime type | Identity | Placement / selector | Decisive local effect |
| ---: | ---: | --- | --- | --- |
| `$00` | `$01` | Manhole | 9 placements | A-button portal type 1 |
| `$01` | `$02` | Anywhere Door | 8 placements | A-button portal type 2 |
| `$02` | `$03` | Stopwatch | selector 3 | freeze flag plus `$F0` timer |
| `$03` | `$04` | Genki Candy | 2 placements | expands the health meter |
| `$04` | `$05` | 1UP | 1 placement | increments lives |
| `$05` | `$06` | weapon upgrade | 3 placements | increments weapon level |
| `$06` | `$07` | Dorayaki | 4 placements, selector 0 | refills health |
| `$07` | `$08` | Rapid-Fire Drink | 3 placements | increments shot limit |
| `$08` | `$09` | Flash Light / Small Light | 1 placement | sets World 2 carry-forward flag |
| `$09` | `$0A` | programmer's face | 1 hidden placement | microphone plus projectile gate |
| `$0A` | `$0B` | Gold Bar | selector 1 | awards encoded score `$31` |
| `$0B` | `$0C` | Diamond | 1 placement, selector 2 | awards encoded score `$32` |
| `$0C` | `$0D` | invulnerability | secret selector 4 | sets `World1InvulnerabilityTimer` to `$FF` |

Descriptor `$05` deliberately stores metasprite zero. Materialization replaces
it with `World1WeaponLevel` plus `$2A`, selecting metasprites `$2A-$2C`
for the Shock Gun, Air Gun, and Power Fan. It is therefore a single dynamic
weapon-upgrade descriptor rather than three descriptor records.

The first four selector slots are random post-defeat rewards. Slot 4 is reached
only after the six-defeat sequence and contains descriptor `$0C`; this is the
published temporary-invulnerability reward. Descriptor `$09` is different: its
hidden type `$8A` can be damaged only while the controller-2 microphone flag is
active, matching the published programmer-face secret.

### Evidence and validation

[StrategyWiki's item catalog](https://strategywiki.org/wiki/Doraemon/Items)
provides item names, images, and effects, while its
[World 1 guide](https://strategywiki.org/wiki/Doraemon/World_1) documents the
portal and progression context. The independent
[GameFAQs walkthrough](https://gamefaqs.gamespot.com/nes/578343-doraemon/faqs/48568)
records placements, scores, and effects; its
[secret list](https://gamefaqs.gamespot.com/nes/578343-doraemon/cheats/)
documents both special rewards. Every mapping additionally requires local ROM
evidence; external names alone do not choose a descriptor.

`make validate-world1-descriptor-identities` checks all thirteen descriptor
fields, placement counts, selector slots, direct and dynamic metasprites,
eleven dispatch targets, thirteen effect signatures, and evidence provenance.
It is part of `make release-check`.

## World 1 descriptor objects

World 1 map placements whose type byte has bit 7 set use a second object
materialization path. The low nibble selects one of thirteen four-byte records
at `$CC0A-$CC3D` in PRG bank 0. The table is stored record-major:

| Byte | Field | Runtime use |
| ---: | --- | --- |
| 0 | `runtime_type` | Base type written to the entity slot |
| 1 | `metasprite_base` | Initial metasprite; zero selects the dynamic `$7B + $2A` fallback |
| 2 | `render_flags` | Initial renderer flags |
| 3 | `primary_behavior` | Initial primary behavior/state byte |

The exact records are:

| Index | Runtime type | Metasprite | Render flags | Primary behavior |
| ---: | ---: | ---: | ---: | ---: |
| `$00` | `$01` | `$29` | `$01` | `$03` |
| `$01` | `$02` | `$25` | `$01` | `$03` |
| `$02` | `$03` | `$2E` | `$01` | `$03` |
| `$03` | `$04` | `$2D` | `$00` | `$03` |
| `$04` | `$05` | `$2F` | `$01` | `$10` |
| `$05` | `$06` | `$00` | `$01` | `$02` |
| `$06` | `$07` | `$30` | `$01` | `$02` |
| `$07` | `$08` | `$34` | `$01` | `$02` |
| `$08` | `$09` | `$16` | `$01` | `$04` |
| `$09` | `$0A` | `$14` | `$01` | `$20` |
| `$0A` | `$0B` | `$28` | `$01` | `$02` |
| `$0B` | `$0C` | `$17` | `$00` | `$02` |
| `$0C` | `$0D` | `$35` | `$03` | `$02` |

### Placement type encoding

The placement type byte has this descriptor form:

```text
bit 7    select the descriptor-object path
bit 6    OR $80 into the materialized runtime type
bits 4-5 reserved; both are zero in canonical placements
bits 0-3 descriptor index ($00-$0C)
```

The city and underground lists contain 33 descriptor-backed placements; 21
set bit 6. Their combined descriptor-index frequencies are:

| Index | Count | Index | Count |
| ---: | ---: | ---: | ---: |
| `$00` | 9 | `$06` | 4 |
| `$01` | 8 | `$07` | 3 |
| `$03` | 2 | `$08` | 1 |
| `$04` | 1 | `$09` | 1 |
| `$05` | 3 | `$0B` | 1 |

Indexes `$02`, `$0A`, and `$0C` do not occur in the two persistent placement
lists. A separate transient spawn path selects descriptor indexes
`$06,$0A,$0B,$02` through the first four bytes of the table at `$94D4`.
Completing the six-defeat secret uses selector slot `$04`, the adjacent byte at
`$94D8`, which contains descriptor index `$0C`. This accounts for all three
definitions absent from persistent placement lists.

### Collision extents

Five adjacent tables define collision extents for the descriptor runtime-type
domain:

| Address | Entries | Index | Use |
| ---: | ---: | --- | --- |
| `$CC3D` | 14 | runtime type `$00-$0D` | projectile X extent |
| `$CC4A` | 14 | runtime type `$00-$0D` | projectile Y extent |
| `$CC58` | 13 | runtime type minus one | interaction X extent |
| `$CC65` | 13 | runtime type minus one | negative interaction Y extent |
| `$CC72` | 13 | runtime type minus one | positive interaction Y extent |

The storage deliberately overlaps twice. Byte `$CC3D` is both the primary
behavior field of descriptor `$0C` and the index-zero entry of the projectile-X
table. That 14-byte table then ends at `$CC4A`, the same byte at which the
projectile-Y table begins. These are real shared bytes, not disassembly boundary
errors. The lossless authoring encoder requires both views of either byte to
agree and rejects conflicting edits.

`config/authoring/world1/object_placements.json` is the canonical structural
catalog. Run
`make validate-object-placements` to compare the descriptors, selector table,
collision tables, placement encoding, usage counts, and CRCs with the canonical
PRG and to round-trip the editable representation in
`data/world1/object_data.json`. The tool also supports `decode` and `encode`;
encoding applies the sparse object regions to a supplied base PRG so unrelated
bank bytes remain intact. The evidence-backed identity and effect join is
documented in `world1_formats.md` and enforced by a separate
release gate.

## World 1 hierarchical map decoder

World 1 uses one bank-local decoder for the city and underground maps. The
active map pointer selects either `World1_CityMap` at `$B2EF` or
`World1_UndergroundMap` at `$C2EF`; both feed the shared big-block,
small-block, and CHR-tile tables.

### Coordinate decomposition

`World1_LookupMapTile` receives an 8-pixel world-tile X coordinate in `X` and
Y in `Y`. It decomposes them as follows:

```text
map column              = X >> 2
map row pointer         = active map + (Y >> 2) * 64
small-block quadrant    = ((Y & 2) << 0) | ((X & 2) >> 1)
CHR-tile quadrant       = ((Y & 1) << 1) |  (X & 1)
```

The map byte selects one four-byte big-block record. The selected big-block
quadrant selects a four-byte small-block record, and the final quadrant selects
the CHR tile. The lookup leaves the complete cursor in zero page so callers can
continue horizontally or vertically without recomputing the hierarchy.

### RAM ABI

| Symbol | Address | Size | Role |
| --- | ---: | ---: | --- |
| `World1MapDataPointer` | `$0066` | 2 | Active 64-byte-row map base |
| `World1CurrentSmallBlockPointer` | `$006A` | 2 | `World1_SmallBlocks + id * 4` |
| `World1CurrentBigBlockPointer` | `$006C` | 2 | `World1_BigBlocks + id * 4` |
| `World1MapRowPointer` | `$006E` | 2 | Active map plus the current row offset |
| `World1TileQuadrantIndex` | `$0070` | 1 | Row-major tile index within a small block |
| `World1SmallBlockQuadrantIndex` | `$0071` | 1 | Row-major small-block index within a big block |
| `World1MapColumnIndex` | `$0072` | 1 | Six-bit map-column index |

The holes at `$0068-$0069` are not part of this decoder contract.

### Entry points

| Routine | Address | Direct calls | Operation |
| --- | ---: | ---: | --- |
| `World1_LookupMapTile` | `$A6A7` | 9 | Initialize the cursor and return its CHR tile |
| `World1_ReadCurrentMapTile` | `$A6E2` | 5 | Return the current CHR tile without advancing |
| `World1_ReadMapTileAndStepRight` | `$A6E8` | 7 | Return a tile and carry the cursor right |
| `World1_ReadMapTileAndStepDown` | `$A719` | 3 | Return a tile and carry the cursor down |
| `World1_ReadBlockAttributeAndStepRight` | `$A74E` | 1 | Return a small-block attribute and step right |
| `World1_ReadBlockAttributeAndStepDown` | `$A772` | 1 | Return a small-block attribute and step down |
| `World1_SelectSmallBlock` | `$A79B` | 3 | Build the current small-block pointer |
| `World1_SelectBigBlock` | `$A7B7` | 5 | Build the current big-block pointer |

`config/reconstruction/world1/world1_map_decoder.json` pins the exact routine bodies, all 34 direct
`JSR` occurrences, RAM ownership, and the four map-pointer loads. Its validator
also joins those facts to the lossless hierarchy in `config/authoring/world_data.json`.
The downstream row/column packet builders and NMI consumer are documented in
`docs/world1_formats.md`.

Run the focused contract with:

```text
make validate-world1-map-decoder
```

## World 1 metasprites

World 1 uses one variable-length metasprite catalog for Doraemon, projectiles,
doors, items, enemies, and the chapter boss. `World1_ComposeMetasprite` receives
an index in `World1MetaspriteIndex`, resolves it through the table at `$9CB6`,
and writes ordinary four-byte NES OAM entries.

### Renderer RAM ABI

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

### Index encoding

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

### Variable-length records

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

### Lossless authoring

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

For research, `scripts/validation/world1/world1_metasprites.py render` produces a contact sheet
of all 115 indexes. Descriptor bases are outlined in gold; the image is a build
artifact and is not committed.

## World 1 palettes

World 1 stores twelve complete 32-byte PPU palettes at `$D7A5-$D924` in PRG
bank 0. The area index at `$0029` selects a record directly. The loader at
`$83BD` multiplies that index by 32, adds `$D7A5`, and copies the selected
record into the palette staging buffer at `$0210-$022F`.

The palette table starts four bytes before the former chapter-table source
boundary. Those bytes are data, not a tail of the preceding Bull Robo explosion
routine. `World1PaletteSets` now owns the complete contiguous range.

All twelve records use valid NES color values and repeat `$0F` at each
four-color universal-background position. Nine records are unique; IDs 8 and 9
match, and IDs 7, 10, and 11 match. Duplicate records remain separate because
the runtime indexes all twelve physical area slots.

`data/world1/palettes.json` exposes each full palette as one fixed-width hex
row. Run `make validate-world1-palettes` to verify the table CRC, geometry,
loader signature, NES color domain, universal-background positions, and exact
decode/encode round trip. The encoder permits same-size palette edits while
preserving the rest of PRG bank 0.

## World 1 map PPU streaming

World 1 converts newly exposed map edges into two fixed packet families. Camera
motion builds the packet in CPU RAM; `World1_DrainMapPpuUpdates` consumes it
during NMI, or synchronously while the initial viewport is prefilled with
rendering disabled.

### Packet geometry

| Edge | Queue code | Tile bytes | PPU increment | Attribute bytes |
| --- | ---: | ---: | ---: | ---: |
| vertical column | 1 | 30 | 32 | 8 |
| horizontal row | 2 | 33 | 1 | 9 |

Each packet family has a flags byte. Bit 0 marks its tile address/data as
pending, and bit 1 marks its attribute address/data. Producers can therefore
prepare the two halves on different 8-pixel camera phases. The consumer clears
only the half it writes and preserves the other bit.

The 30-tile column uses `PPUCTRL` increment 32. If it crosses the vertical
nametable boundary, the consumer changes the destination nametable and
continues the remaining bytes. Its eight attributes are written one at a time
with an address stride of 8. The 33-tile row and nine-byte attribute row use
increment 1 and split at horizontal nametable boundaries.

### RAM layout

| Range | Symbol | Role |
| --- | --- | --- |
| `$0230` | `World1ColumnUpdateFlags` | column tile/attribute pending bits |
| `$0231-$0232` | `World1ColumnTilePpuAddress` | little-endian tile destination |
| `$0233-$0250` | `World1ColumnTileData` | 30 decoded CHR-tile indexes |
| `$0253-$0254` | `World1ColumnAttributePpuAddress` | little-endian attribute destination |
| `$0255-$025C` | `World1ColumnAttributeData` | 8 packed attribute bytes |
| `$025E` | `World1ColumnAddressScratch` | column wrap-count calculation |
| `$025F` | `World1EdgeUpdateQueue` | two packed 4-bit edge codes |
| `$0260` | `World1RowUpdateFlags` | row tile/attribute pending bits |
| `$0261-$0262` | `World1RowTilePpuAddress` | little-endian tile destination |
| `$0263-$0283` | `World1RowTileData` | 33 decoded CHR-tile indexes |
| `$0284-$0285` | `World1RowAttributePpuAddress` | little-endian attribute destination |
| `$0286-$028E` | `World1RowAttributeData` | 9 packed attribute bytes |

`$0251-$0252` and `$025D` are gaps and are not claimed by the packet ABI.

### Queue and routines

`World1EdgeUpdateQueue` holds at most two nibbles. A camera edge shifts the old
low nibble into the high nibble and writes 1 for a column or 2 for a row. The
consumer removes one code and dispatches to the matching packet family.

The six validated entry points are:

- `World1_BuildColumnTileUpdate` at `$A4C6`;
- `World1_BuildColumnAttributeUpdate` at `$A50A`;
- `World1_BuildRowTileUpdate` at `$A5CF`;
- `World1_BuildRowAttributeUpdate` at `$A60B`;
- `World1_PrefillMapViewport` at `$A7DB`;
- `World1_DrainMapPpuUpdates` at `$A87E`.

`config/reconstruction/world1/world1_ppu_streaming.json` pins all 1,013 routine bytes, the complete
20-call graph, both packet layouts, queue capacity, and 92 owned RAM bytes.
Run the focused contract with:

```text
make validate-world1-ppu-streaming
```

## World 1 underground room profiles

World 1's side-view mode has nine room IDs. Two contiguous four-byte tables
at `$D1EF-$D236` define each room's initial camera state, player position, and
the city-return profile selected at either end of its scrolling axis. A third
table at `$D37E-$D3A1` defines the nine city camera/manhole destinations.

### Format

The camera table is row-major with one record per room:

| Offset | Field | Consumer |
| ---: | --- | --- |
| 0 | `camera_tile_x` | Initial `World1CameraTileX` |
| 1 | `camera_tile_y` | Initial `World1CameraTileY` |
| 2 | `axis_scroll_limit` | Positive coarse-axis boundary |
| 3 | `axis_scroll_start` | Initial coarse-axis position |

The adjacent entry table uses the same room ordering:

| Offset | Field | Consumer |
| ---: | --- | --- |
| 0 | `player_x` | Initial screen-space player X |
| 1 | `player_y` | Initial screen-space player Y |
| 2 | `negative_axis_city_return_id` | City return selected when coarse-axis position is zero |
| 3 | `positive_axis_city_return_id` | City return selected when coarse-axis position is nonzero |

Return ID `$FF` means that side has no exit and is represented as `null` in
the authoring JSON. Other values select city-return records 0-8; they are not
underground room IDs. The loader multiplies `World1UndergroundRoomId` by four
and reads all eight fields. The exit path chooses between the final two fields
using `World1UndergroundAxisScrollCoarse`.

Each city-return record is also four bytes:

| Offset | Field | Consumer |
| ---: | --- | --- |
| 0 | `camera_tile_x` | Restored city camera X |
| 1 | `camera_tile_y` | Restored city camera Y |
| 2 | `manhole_x` | Player/manhole screen X |
| 3 | `manhole_y` | Player/manhole screen Y |

`World1_ReturnFromUndergroundToCity` consumes the selected record, restores
the city renderer and object state, animates the player out of the manhole,
then resumes the city main loop. Its exact 187 bytes and both direct jumps are
part of the manifest contract.

### Lossless authoring

`data/world1/underground_rooms.json` combines the two adjacent room tables and
the separate city-return table into editable rows. Encoding writes all three
back to their physical ROM locations. The validator pins all CRC32 values,
the room-table boundary, loader and selector signatures, table/routine
symbols, all 108 data bytes, the return routine and its two callers, and an
exact decode/encode round trip.

Run:

```text
make validate-world1-underground-rooms
```

## World 1 weapon profiles

The city and underground player paths share one firing routine and the same
three-level projectile catalog. `data/world1/weapons.json` presents the compact
physical tables as level records with four named directions.

### Physical layout

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

### Lossless authoring

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
