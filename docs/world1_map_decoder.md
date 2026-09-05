# World 1 hierarchical map decoder

World 1 uses one bank-local decoder for the city and underground maps. The
active map pointer selects either `World1_CityMap` at `$B2EF` or
`World1_UndergroundMap` at `$C2EF`; both feed the shared big-block,
small-block, and CHR-tile tables.

## Coordinate decomposition

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

## RAM ABI

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

## Entry points

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

`config/world1_map_decoder.json` pins the exact routine bodies, all 34 direct
`JSR` occurrences, RAM ownership, and the four map-pointer loads. Its validator
also joins those facts to the lossless hierarchy in `config/world_data.json`.

Run the focused contract with:

```text
make validate-world1-map-decoder
```
