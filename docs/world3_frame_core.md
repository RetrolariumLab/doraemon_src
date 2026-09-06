# World 3 frame core

`config/world3_frame_core.json` fixes eighteen formerly address-named Bank 2
routine entries. The contract covers 938 executable bytes, 42 direct calls,
and 22 Bank 2-private RAM fields.

The slice connects the World 3 entry and frame loop to:

- hardware/RAM and PPU initialization;
- start-room selection through the carried Passing Hoop, fixed spawn points,
  and collision-tested random spawn points;
- pause input, boss-music restoration, and the two microphone/debug hooks;
- persistent-object reset, palette flash, and active-entity cleanup;
- alternating OAM halves and score, lives, and health HUD composition.

The room index is decomposed into an eight-by-eight row and column, matching
the 64-room map. Boss completion flags retain the hexadecimal room IDs used by
the runtime (`$27`, `$28`, and `$34`). The room `$16` microphone event names
describe only its proven object relocation and marker behavior; no character
identity is inferred.

Run:

```text
make validate-world3-frame-core
```
