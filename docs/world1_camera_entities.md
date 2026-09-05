# World 1 camera entity projection

World 1 keeps the player and all active entities in screen-relative
coordinates. Camera movement accumulates signed X/Y deltas; the tracking path
applies those deltas to the player and to every active entity after each
camera decision.

## Player tracking window

`World1_UpdateCameraFromPlayer` clears both deltas, then attempts two camera
pixels on each axis when the player leaves this window:

| Axis | Negative direction | No-scroll interval | Positive direction |
| --- | --- | --- | --- |
| X | player below `$50` | `$50-$9F` | player at or above `$A0` |
| Y | player below `$48` | `$48-$8F` | player at or above `$90` |

The directional routines may reject movement at a world boundary. The
resulting signed deltas, rather than the requested two pixels, are added back
to `World1PlayerX` and `World1PlayerY`.

## Entity projection and culling

`World1_ApplyCameraDeltaToEntities` traverses all 48 slots from 47 down to 0.
For each nonzero `World1EntityType`, it adds the signed delta to the low X and
Y bytes and propagates carry or borrow into the matching two-bit fields of
`World1EntityPositionHigh`. Its X field occupies bits 0-1 and Y occupies bits
2-3.

The routine falls directly into `World1_CullOffscreenEntities`. Culling retains
one adjacent coordinate page as a spawn margin:

| Axis | Negative margin | Positive margin | Always rejected page |
| --- | --- | --- | --- |
| X | 64 pixels | 64 pixels | page 2 |
| Y | 64 pixels | 32 pixels | page 2 |

When a removed entity has a nonnegative `World1EntitySourceObjectId`, the
low seven bits identify the map object passed to `World1_ReleaseObjectSpawn`.
Transient entities use a negative source ID and need no map-bit release.

## Validated routines

| Routine | Address | Bytes | Direct calls |
| --- | ---: | ---: | ---: |
| `World1_UpdateCameraFromPlayer` | `$8706` | 74 | 3 |
| `World1_ApplyCameraDeltaToEntities` | `$8750` | 168 | 7 |
| `World1_CullOffscreenEntities` | `$87F8` | 84 | 3 |

`config/world1_camera_entities.json` pins all 326 routine bytes, the complete
13-call graph, the fallthrough edge, tracking thresholds, culling margins, and
244 RAM bytes across the player, delta, and five entity arrays. Run:

```text
make validate-world1-camera-entities
```
