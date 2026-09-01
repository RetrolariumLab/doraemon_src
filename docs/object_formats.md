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
38-47; the low nibble selects a four-byte descriptor at `$CC0A`, bit 6 is
preserved as the spawned entity's high state flag, and bit 7 distinguishes this
descriptor path from the ordinary entity path.

The first 45 records are always scanned. Records after that prefix are ordered
by `x_cell`, allowing horizontal scans to stop once the requested column has
been passed. The underground list has only 33 records; the city list has 112,
of which its 67-record tail satisfies the ordering invariant.

`config/object_placements.json` fixes both ranges, counts, terminators, and
CRCs. `make validate-object-placements` also proves the type encoding and the
sorted-tail invariant directly against the canonical PRG.

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
