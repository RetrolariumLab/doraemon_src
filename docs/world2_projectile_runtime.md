# World 2 projectile runtime

`config/world2_projectile_runtime.json` fixes the World 2 player-projectile
motion helpers, player hazard scan, and both inventory-owned attacks. It pins
17 routines, 768 executable bytes, 23 direct calls or tail jumps, and nine
Bank 1-private zero-page fields.

Inventory slot 0 emits one independently animated projectile from the
companion position. Inventory slot 2 owns a separate axis-aligned attack whose
phase controls both reach and multi-sprite rendering. The normal player weapon
uses seven parallel projectile records and four two-axis composition helpers.

The hazard scan deliberately records a contact request rather than applying
damage itself. The player update consumes that request later, after inventory
and damage-effect state have been updated.

Run:

```text
make validate-world2-projectile-runtime
```
