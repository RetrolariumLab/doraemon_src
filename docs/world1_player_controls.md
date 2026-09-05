# World 1 player controls

World 1 has separate city and underground movement implementations, but both
share input-edge state, weapon firing, and the player-to-map collision sampler.
The city path is a four-way, two-pixel update with collision rollback.

## City movement

`World1_UpdateCityPlayer` checks held directions in strict priority order:
up, down, left, then right. It moves two pixels and clamps the player to X
`$05-$EB` and Y `$28-$C8` before collision probes run.

| Direction | Encoded value | Collision probes |
| --- | ---: | ---: |
| up | 1 | 3 |
| down | 0 | 3 |
| left | 2 | 2 |
| right | 3 | 2 |

Each probe calls `World1_RollbackCityPlayerOnCollision`. The wrapper calls
`World1_TestPlayerMapCollisionAtOffset` and restores both pre-movement player
coordinates when the returned carry is set. The sampler combines player,
fine-scroll, coarse-camera, and caller-supplied offsets, decodes the map tile,
and classifies metatile IDs from `$42` upward as solid.

The metasprite advances through its two-bit animation frame every five active
updates. Positive `World1PlayerDamageState` values below 6 lock controls; the
recovery sequence ends at `$16`. A negative value is the separate death state.

## Input edges and weapon firing

The frame input path retains `World1PreviousButtons` and computes
`World1PressedButtons` from changed bits that are currently held. Therefore
`World1_UpdateWeaponAndTryFire` reacts once to the `$40` fire edge rather than
repeating from a held button.

Firing requires a nonzero `World1WeaponLevel` and a free slot within the first
eight projectile slots, further limited by `World1ProjectileMaxSlot`. The
routine initializes type, position, metasprite, render flags, direction, and a
transient `$FF` source-object ID, then starts `World1WeaponPoseTimer` at 6.
The three level sounds and twelve direction-specific spawn profiles are
losslessly editable through `data/world1/weapons.json`; see
`docs/world1_weapons.md`.

## Validated routines

| Routine | Address | Bytes | Direct calls |
| --- | ---: | ---: | ---: |
| `World1_UpdateCityPlayer` | `$856C` | 396 | 1 |
| `World1_RollbackCityPlayerOnCollision` | `$86F8` | 14 | 10 |
| `World1_UpdateWeaponAndTryFire` | `$9BFC` | 135 | 2 |
| `World1_TestPlayerMapCollisionAtOffset` | `$D1C3` | 44 | 13 |

`config/world1_player_controls.json` pins all 589 routine bytes, all 26 direct
callsites, thirteen state fields, movement and recovery constants, ten probe
calls, the solid threshold, and weapon timing. Run:

```text
make validate-world1-player-controls
```
