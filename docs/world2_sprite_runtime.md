# World 2 sprite runtime

`config/world2_sprite_runtime.json` fixes the World 2 player and inventory
renderer from the slot 2 attack-segment helpers through the final OAM writer.
It pins 27 routines, 864 executable bytes, 54 direct calls or tail jumps, and
nine Bank 1-private RAM symbols covering 103 bytes.

The renderer has three layers:

- player projectiles and both inventory-owned attacks use fixed OAM regions;
- the player, damage effect, and all seven inventory slots are composed from
  two-sprite rows or fixed sprite layouts;
- every path converges on a four-byte Y/tile/attributes/X staging record and
  the OAM writer at `$96C8`.

Inventory slots 0 and 1 read the 48-entry player-position history ring when
active, at delays of 47 and 23 samples respectively. The renderer writes the
resolved historical positions back into each slot before composing its
metasprite. Multi-purpose arithmetic and collision scratch bytes remain
numeric because their lifetime is not a stable renderer ABI.

Run:

```text
make validate-world2-sprite-runtime
```
