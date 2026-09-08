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

## Underground movement

`World1_UpdateUndergroundPlayer` gives held left priority over held right and
uses `World1PlayerXSubpixel` to move 1.5 pixels per update: the integer X
coordinate always changes once and changes a second time on each `$80`
fractional carry or borrow. The same `$05-$EB` horizontal bounds apply as in
the city. Three probes at the leading wall edge cover Y offsets `$02`, `$0E`,
and `$19`; a collision restores the pre-movement X coordinate.

A new press of A (`$80`) calls `World1_StartUndergroundJump`, sets signed
vertical velocity to -24, marks the player airborne, queues sound `$12`, and
falls directly into `World1_IntegrateUndergroundVerticalMotion` for the first
physics update. Airborne updates add signed velocity divided by four to Y,
then add gravity 1 and clamp downward velocity to +24. Two X probes at offsets
`$04` and `$0A` test the ceiling at Y `$02` and the floor at Y `$1A`.
Ceiling contact aligns the player below the tile and clears velocity; floor
contact aligns to the fine-scroll grid, clears `World1PlayerAirborne`, and
returns to grounded movement. `World1_CheckUndergroundGroundSupport` runs the
same two floor probes while grounded and begins a zero-velocity fall when both
miss.

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
| `World1_UpdateUndergroundPlayer` | `$CF7A` | 409 | 5 |
| `World1_CheckUndergroundGroundSupport` | `$D113` | 37 | 1 |
| `World1_StartUndergroundJump` | `$D138` | 13 | 1 |
| `World1_IntegrateUndergroundVerticalMotion` | `$D145` | 126 | 1 |

`config/reconstruction/world1/world1_player_controls.json` pins all 1,174 routine bytes, all 34 direct
callsites, sixteen state fields, city and underground movement constants, ten
city probes, twelve underground probes, the solid threshold, and weapon
timing. Run:

```text
make validate-world1-player-controls
```
