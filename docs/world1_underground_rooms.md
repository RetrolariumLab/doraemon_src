# World 1 underground room profiles

World 1's side-view mode has nine room IDs. Two contiguous four-byte tables
at `$D1EF-$D236` define each room's initial camera state, player position, and
the city-return profile selected at either end of its scrolling axis. A third
table at `$D37E-$D3A1` defines the nine city camera/manhole destinations.

## Format

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

## Lossless authoring

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
