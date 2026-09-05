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

The normal player-camera path, initial viewport prefill, and scripted movement
all call these same routines. `config/world1_camera.json` pins all 325 routine
bytes, the eight state symbols and ownership scopes, the coordinate geometry,
and all 16 direct callsites. Run the focused contract with:

```text
make validate-world1-camera
```

Player tracking, entity coordinate projection, and offscreen culling form the
consumer side of this camera model. Their exact contract is documented in
`docs/world1_camera_entities.md`.
