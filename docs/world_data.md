# World 1 and World 3 hierarchical data

World 1 and World 3 use the same three-level background representation:

```text
64x64 or 64x25 map cells
  -> 2x2 big-block entries
    -> 2x2 small-block entries
      -> CHR tile indexes
```

Every reference at each level is one byte. A small-block record is four CHR tile
indexes in row-major order. A big-block record is four small-block indexes in
the same order. Map rows contain big-block indexes.

## Canonical layouts

World 1 keeps one shared attribute/small-block/big-block hierarchy followed by
the city and underground maps. The whole range is contiguous in PRG bank 0:

| Component       | CPU range     | Records or dimensions |
| --------------- | ------------- | --------------------: |
| attributes      | `$A9EF-$AAEE` |             256 bytes |
| small blocks    | `$AAEF-$AEEE` |      256 records, 2x2 |
| big blocks      | `$AEEF-$B2EE` |      256 records, 2x2 |
| city map        | `$B2EF-$C2EE` |                 64x64 |
| underground map | `$C2EF-$C92E` |                 64x25 |

The combined 8,000-byte payload has CRC32 `fe76a8f2`.

The runtime decoder for this payload is documented in `docs/world1_formats.md`.
Its active pointer switches between the two map bases while retaining the shared
tables, and its cursor walks all three levels without rebuilding the lookup for
every adjacent tile.

World 3 has an independent hierarchy and one underwater map in PRG bank 2:

| Component      | CPU range     | Records or dimensions |
| -------------- | ------------- | --------------------: |
| attributes     | `$DDF2-$DEF1` |             256 bytes |
| small blocks   | `$DEF2-$E2F1` |      256 records, 2x2 |
| big blocks     | `$E2F2-$E6F1` |      256 records, 2x2 |
| underwater map | `$E6F2-$F6F1` |                 64x64 |

The combined 6,400-byte payload has CRC32 `779d61b5`.

World 1's maps use 233 distinct big-block indexes together; its big-block table
references 236 small blocks and the small-block table references 250 CHR
indexes. World 3 uses 204 big blocks, references 175 small blocks, and contains
252 distinct CHR indexes.

## Attribute bytes

CadEditor treats bits 0-1 as the four-way palette selector and preserves bits
2-7 when it writes an edited selector. The authoring format therefore exposes
the byte as two lossless fields:

```text
ppppppCC
      ++-- palette selector, 0-3
++++++--- preserved six-bit properties field
```

All upper property bits are zero in both canonical tables. Their runtime meaning
is not claimed here; naming them collision flags would go beyond the current
evidence. The actual NES palette colors are separate data.

## Editing

The Studio edits the two hierarchies as `world1-hierarchy` and
`world3-hierarchy` (`doraemon.hierarchy.v1`). Attribute entries hold a palette
and properties, small and big blocks four row-major values each, and the maps
fixed-width rows of cells; they write back the exact 8,000 and 6,400 bytes.

World 2 is deliberately excluded from this format. Its CadEditor tables overlap
the runtime screen data, and its actual compressed screen storage is described
in [World 2 formats](world2_formats.md).
