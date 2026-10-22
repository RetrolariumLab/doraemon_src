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
`docs/world1_formats.md`.

The first 45 records are always scanned. Records after that prefix are ordered
by `x_cell`, allowing horizontal scans to stop once the requested column has
been passed. The underground list has only 33 records; the city list has 112,
of which its 67-record tail satisfies the ordering invariant.

The Studio edits the placements as `world1-city-objects` and
`world1-underground-objects` (`doraemon.world1-placements.v1`, which keeps the
city list's sorted tail), the thirteen descriptors as `world1-descriptors` and
the enemy properties as `world1-enemy-properties`.

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

The 119 standard selectors address 116 unique ROM streams holding 738 spawn
tokens and 3,623 run tokens, read through `$FFFA`; three screen-service RTS
tables dispatch them. The Studio edits them as `world2-screens`
([World 2 formats](world2_formats.md)).

Only physical tokens `$D0-$DE` occur. After their delayed negative-state phase,
the normalization at `$9A32` maps them one-to-one to runtime states `$01-$0F`.
States `$10-$14` are internal-only extensions of the same render/update and
property-table domain. The exact token frequencies, transformation signature,
three state property tables, and overlapping dispatch storage are documented in
`docs/world2_runtime.md`. The Studio edits their 21
state records as `world2-enemy-states`.

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
ending at `$DDF1`. The Studio edits the five initial arrays as
`world3-objects` and the streams as `world3-behavior`.

The behavior bytecode is fully decoded in
[World 3 formats](world3_formats.md): all 1,062 bytes are 532 instructions and
operands.

Across the full `$00-$1F` type domain, five 32-byte property columns supply
hit points, base metasprites, render flags, contact damage, and score reward
codes. The types also fix the initializer/behavior/update dispatch cardinalities,
partitions all types into lifecycle domains, and fixes the `$10-$13` post-defeat
and `$1C-$1E` persistent transformations. See
[World 3 formats](world3_formats.md).

## World 3 transient room schedules

World 3's non-persistent room entities use four scheduling channels. Twelve
64-byte columns at `$D66B-$D96A` provide type, successful-spawn count, and
delay for every channel in each room. A zero count disables the corresponding
channel; type zero remains a valid initializer index.

Nonzero delays are decremented through a modulo-four frame prescaler. Delay
zero retries allocation every frame. Successful allocation consumes one count,
initializes an active entity through the 16-entry table at `$8F6C`, and marks
the channel complete after its last scheduled entity. The phase counters are
not reset when a new room schedule is loaded.

The Studio edits the full 768-byte column layout as 64 room records of
`world3-schedule`; see [World 3 formats](world3_formats.md).

The 16 initializer slots are independently classified and tied back to the
schedule's per-type record counts and spawn budgets. Initializers `$07` and
`$08` are room/progression gated; `$0A` expands a type `$0A/$0B` encounter;
and `$0C` expands a four-corner type `$0C-$0F` formation. See
[World 3 formats](world3_formats.md) for their four data regions.

The 32-entry update dispatch covers script-only low types,
formation members, encounter and persistence transitions, object relocation,
terrain-trigger behavior, pushing, and player-following derived types. Its
three handler-owned table regions are in
[World 3 formats](world3_formats.md).

The entity catalog's base metasprite column is cross-checked against the full
188-entry sprite index at `$B6D7`. Every type base resolves directly to one of
65 variable-length records; animation variants may select direct frames or
one-level horizontal aliases. The exact relationship and editable sprite and
palette data are documented in `docs/world3_formats.md`.
