# World 2 player systems

`config/reconstruction/world2/world2_player_systems.json` fixes thirteen routines covering player
movement and firing, the position-history ring, and all seven fixed inventory
slot update paths. The inventory routines distinguish the shared slots 2-6
state machine from the history-following slot 0 and slot 1 paths and their
detached-state motion.

Nine Bank 1 RAM names cover movement speed, history position, fire repeat and
companion phases, projectile direction, inventory-drop hit count, the player
damage effect, and the fire-press counter. The contract pins 750 executable
bytes and all thirteen direct callers.

Run:

```text
make validate-world2-player-systems
```
