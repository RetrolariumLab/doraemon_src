# World 1 entity helpers

`config/world1_entity_helpers.json` fixes the movement, aiming, map-probe, and
enemy-projectile primitives shared by the semantically named World 1 entity
handlers. It replaces seventeen address-only routine names with behavioral
contracts.

The direction layer converts player-relative deltas to an eight-way direction,
applies unit-vector movement, reverses horizontal direction, and selects a
matching facing metasprite. The collision layer converts packed entity
coordinates to world-map cells and dispatches bottom, right, top, or left edge
probes, pairing cardinal probes for diagonal movement.

Three projectile constructors are now distinct: a probabilistic directional
shot in the source entity's corresponding transient slot, a random upward arc
in any free transient slot, and a fixed-point aimed shot. The aimed path records
its minor-over-major restoring division and the unusual guard that unwinds its
caller when the source entity is outside the active screen.

The machine contract pins exact code spans and CRC32 values, all direct JSR/JMP
callers from the current Ghidra facts, encoded callsite bytes, and nine existing
Bank 0 RAM symbols covering the player, camera, and shared entity structure.
Entry prefixes that intentionally fall through to another helper are recorded
as separate non-overlapping spans.

Run:

```text
make validate-world1-entity-helpers
```
