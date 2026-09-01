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
