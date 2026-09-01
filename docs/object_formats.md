# Object formats

## World 1 map placements

City initialization installs `$D989` as the active placement pointer, while
underground initialization installs `$D925`. Both lists use the same packed
three-byte record:

| Byte | Field | Meaning |
| ---: | --- | --- |
| 0 | `x_cell` | World X coordinate in eight-pixel cells; zero terminates the list |
| 1 | `y_cell` | World Y coordinate in eight-pixel cells |
| 2 | `type` | Entity state selector or high-bit city-object descriptor selector |

The decoder advances the pointer by three bytes and uses the zero-based record
index as the persistent object ID. It compares the first two fields with the
current camera-edge cell, multiplies their differences by eight, and writes the
resulting camera-relative pixel coordinates into a free entity slot.

Types below `$80` materialize in slots 0-9. The stored entity state is
`type + 1`, and `type & 7` selects one of eight target-minus-one spawn
initializers at `$8DA4`. Types `$80-$8F` and `$C0-$CF` materialize in slots
38-47; the low nibble selects one of thirteen four-byte descriptors at `$CC0A`,
bit 6 sets the spawned runtime type's high flag, and bit 7 distinguishes this
descriptor path from the ordinary entity path. Bits 4-5 are reserved and zero
in every canonical placement.

Each descriptor supplies the runtime type, base metasprite, render flags, and
primary behavior. The exact table, transient selector path, per-index placement
counts, and five related collision-extent tables are documented in
`docs/world1_descriptors.md`.

The first 45 records are always scanned. Records after that prefix are ordered
by `x_cell`, allowing horizontal scans to stop once the requested column has
been passed. The underground list has only 33 records; the city list has 112,
of which its 67-record tail satisfies the ordering invariant.

`config/object_placements.json` fixes both ranges, counts, terminators, CRCs,
all thirteen descriptors, and their collision tables.
`make validate-object-placements` proves these contracts and the sorted-tail
invariant directly against the canonical PRG. The same command losslessly
round-trips the editable placements, descriptors, transient selectors, and
collision extents in `data/world1/object_data.json`.

## World 2 embedded enemy spawns

World 2 has no separate fixed-size enemy placement list. Its screen decoder at
`$8444` consumes map cells and enemy records from one variable-length stream:

| Token | Meaning |
| --- | --- |
| `$00-$CF` | literal screen cell |
| `$D0-$EE` | write an empty cell and spawn an enemy with this state |
| `$EF` | terminate the current row |
| `$F0` | reserved and absent from all standard streams |
| `$F1-$FF` | repeat the following literal `(token & $0F) + 1` times |

The selected screen pointer is stored at `$0046-$0047`; `$0054` is its current
byte offset, `$0056` counts rows, and `$0074` carries an embedded spawn state
into the enemy allocator. Each standard screen expands sixteen rows, stopping
each row after at least fifteen cells. Because a final run is not clipped, row
width can reach 22 cells.

`config/world2_streaming.json` fixes all 119 standard selectors, 116 unique ROM
streams, three screen-service RTS tables, 738 spawn tokens, 3,623 run tokens,
and the final read at `$FFFA`. `make validate-world2-streaming` checks those
invariants and every indirect dispatch target against the canonical PRG.
The shared token storage and all selector row views also round-trip through
`data/world2/compressed_screens.json` as documented in
`docs/world2_streaming.md`.

## World 3 initial persistent registry

`World3_InitializeRoomObjectRegistry` copies 65 bytes at `$D96B` directly into
RAM `$06B0-$06F0`. ROM and RAM therefore share the same structure-of-arrays
layout, with thirteen bytes in each field:

| Field | ROM | RAM | Meaning |
| --- | --- | --- | --- |
| room | `$D96B` | `$06B0` | owning room number |
| type | `$D978` | `$06BD` | persistent object type |
| X | `$D985` | `$06CA` | saved horizontal position |
| Y | `$D992` | `$06D7` | saved vertical position |
| state | `$D99F` | `$06E4` | materialization/persistence state |

All thirteen initial states are zero. After the copy, initialization randomly
permutes types `$18-$1B` among slots 0-3. It separately permutes the slot 4-11
multiset (five `$17` values plus `$14`, `$15`, and `$16`). Slot 12 remains the
fixed type `$1F`. Rooms and coordinates stay in their original slots; only the
type arrays are shuffled.

Types below `$10` select one of sixteen packed behavior streams through the
little-endian pointer table at `$D9AC`. The table targets are strictly
increasing from `$D9CC` through `$DDE0`, within the 1,062-byte stream region
ending at `$DDF1`. `make validate-world3-object-data` proves the five initial
arrays, shuffle groups, fixed slot, pointer table, and stream payload.

The behavior bytecode is fully decoded in `docs/world3_behavior.md`. Its
machine contract covers all 1,062 bytes as 532 instructions and operands, and
`data/world3/behavior_streams.json` provides a lossless editable round trip.

The full `$00-$1F` type domain is joined in
`config/world3_entity_types.json`. Five 32-byte property columns supply hit
points, base metasprites, render flags, contact damage, and score reward codes.
The catalog also proves the initializer/behavior/update dispatch cardinalities,
partitions all types into lifecycle domains, and fixes the `$10-$13` post-defeat
and `$1C-$1E` persistent transformations. See
`docs/world3_entity_types.md`. The row-oriented editable view in
`data/world3/object_catalog.json` losslessly transposes both the thirteen
persistent records and all 32 five-property type records back into their ROM
structure-of-arrays layouts.
