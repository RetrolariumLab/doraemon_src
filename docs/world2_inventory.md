# World 2 inventory and companions

World 2 keeps seven fixed inventory slots in three parallel zero-page arrays:
state at `$7C-$82`, X at `$83-$89`, and Y at `$8A-$90`. The slots cover both
rescued companions and carried items, so the source uses the neutral inventory
name until each fixed index is identified independently.

## Runtime states

| Value | Name | Evidence |
| ---: | --- | --- |
| 0 | absent | update and render routines return immediately |
| 1 | entering | slot moves in from a screen edge |
| 2 | homing to player | X and Y approach their target every frame |
| 3 | active | companion/item behavior and attacks are enabled |
| 4 | knocked loose | damage changes an active slot to this detached state |

The aggregate updater at `$8BAC` calls handlers for all seven fixed slots.
After the damage counter reaches its threshold, `$8C04` searches active slots
0-5 backwards and changes one to state 4. Slot 6 is deliberately outside that
drop scan.

## Spawn screens

The seven-byte table at `$A6B5` contains screen IDs `$14,$1A,$1F,$47,$45,$6D,$74`.
The routine at `$A65E` searches it backwards before trying to activate a free
inventory slot at X `$78`, Y `$F0`. The table identifies eligible screens; it
does not map table index directly to inventory index.

`data/world2/inventory_spawn_screens.json` is the lossless editable view. Run
`make validate-world2-inventory` to verify its round trip, the zero-page pool
layout, all five state transitions, and the code signatures tying them together.
