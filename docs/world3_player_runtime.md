# World 3 player runtime

`config/reconstruction/world3/world3_player_runtime.json` fixes thirteen formerly address-named
World 3 player and map-lookup entries. The exact contract covers 690 executable
bytes, 25 direct `JSR` or `JMP` edges, and fourteen Bank 2-private RAM bytes.
Four additional conditional branches enter adjacent routines directly and are
preserved symbolically in the source rather than counted as call instructions.

The player owns the contiguous sixteen-byte state block at `$008E-$009D`.
Initialization clears that block, selects state one, installs its initial
metasprite, and sets the normal animation cadence. The five-entry
`World3_PlayerStateHandlerTable` then dispatches inactive, controlled, scripted
arc, damage-recovery, and death states.

Controlled movement now exposes the fire-button edge latch and firing pose,
direction-selected metasprite bases, alternating horizontal step rate, passive
descent delay, and the signed fifteen-entry vertical delta table. Horizontal
and vertical movement share the terrain probes from the collision contract and
cross room edges through the named room-transition services. Sampling terrain
tile `$14` during upward movement switches the player to state two, whose
24-entry signed curve drives a scripted arc before returning to controlled
movement.

The same slice names health refill, new-session score/lives/capacity reset, and
the death restart gateway. `World3_LookupMapTileAtPixel` documents the runtime
counterpart of the lossless World 3 map format: a pixel coordinate is resolved
through the 64-by-64 large-block map, large-block composition, small-block
composition, and finally the terrain tile id used by collision.

Run:

```text
make validate-world3-player-runtime
```
