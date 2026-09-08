# World 1 camera scrolling

World 1 uses four directional routines for the city and underground camera.
Each routine attempts one pixel of movement, returns without changing state at
the corresponding world boundary, and prepares a row or column update when a
new map edge becomes visible.

## Coordinate model

| Axis | Pixel scroll | Coarse coordinate | Inclusive range |
| --- | --- | --- | ---: |
| horizontal | `PpuScrollXShadow` | `World1CameraTileX` | `$00-$E0` |
| vertical | `PpuScrollYShadow` | `World1CameraTileY` | `$00-$E2` |

The low three scroll bits are a sub-cell offset, so the coarse coordinate
changes every eight pixels. Horizontal byte wrap toggles `World1NametableX`.
Vertical scrolling accounts for the NES nametable discontinuity by translating
the `$F0-$FF` interval across a `$10` adjustment.

Every accepted camera pixel changes the matching `World1ScreenDeltaX` or
`World1ScreenDeltaY` in the opposite direction. Entity rendering consumes that
signed delta, keeping objects fixed in world space while the viewport moves.

## Directional entry points

| Routine | Address | Bytes | Direct calls | Edge packet |
| --- | ---: | ---: | ---: | --- |
| `World1_TryScrollCameraRight` | `$A381` | 96 | 3 | column, code 1 |
| `World1_TryScrollCameraLeft` | `$A3E1` | 78 | 3 | column, code 1 |
| `World1_TryScrollCameraDown` | `$A42F` | 85 | 5 | row, code 2 |
| `World1_TryScrollCameraUp` | `$A484` | 66 | 5 | row, code 2 |

Column tile data is built on the coarse eight-pixel boundary; column
attributes are built on the matching 16-pixel phase. Row tile and attribute
data use corresponding vertical phases. A completed edge shifts the existing
low nibble of `World1EdgeUpdateQueue` into the high nibble and appends code 1
for a column or code 2 for a row.

## Underground player tracking

Two room-orientation entry points select the directional primitives above.
`World1_TrackUndergroundHorizontalCamera` holds the player in X `$6E-$82`
and can request at most two camera pixels per update. The vertical-room
counterpart holds Y in `$6E-$92` and can request at most six pixels. Both
reduce the distance outside the band to a per-update budget, stop at axis
position zero or the room-specific limit, and then apply the accumulated
screen delta to the player and all active entities.

The two orientations deliberately overlay one four-byte axis workspace.
`World1UndergroundAxisScrollCoarse` advances whenever the low-three-bit
`World1UndergroundAxisScrollFine` phase wraps. The positive direction stops at
`World1UndergroundAxisScrollLimit`; the fourth byte is the temporary pixel
budget. Horizontal rooms call the left/right primitives, while the vertical
room calls up/down.

| Tracking routine | Address | Bytes | Direct calls | Player band | Max pixels |
| --- | ---: | ---: | ---: | ---: | ---: |
| `World1_TrackUndergroundHorizontalCamera` | `$CF08` | 114 | 1 | X `$6E-$82` | 2 |
| `World1_TrackUndergroundVerticalCamera` | `$D47C` | 114 | 1 | Y `$6E-$92` | 6 |

The normal player-camera path, initial viewport prefill, and scripted movement
all call these same routines. `config/reconstruction/world1/world1_camera.json` pins all 553 routine
bytes, the twelve state symbols and ownership scopes, the coordinate geometry,
the underground tracking bands, and all 18 direct callsites. Run the focused
contract with:

```text
make validate-world1-camera
```

Player tracking, entity coordinate projection, and offscreen culling form the
consumer side of this camera model. Their exact contract is documented in
`docs/world1_camera_entities.md`.
