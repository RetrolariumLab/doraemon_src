# World 3 entity update handlers

`World3_UpdateEntities` walks eight active slots. Types below `$10` first run
their packed behavior stream; every type `$00-$1F` then indexes the 32-pointer
table at `$92DF`. The table has 19 unique addresses and 17 evidence-backed
structural roles.

## Low scripted types

| Types | Update role |
| --- | --- |
| `$00-$03` | ordinary enemies/hazard; state 4 follows the active ghost |
| `$04` | skull movement toward the player in enabled rooms every fourth update |
| `$05` | ghost captures an eligible object and can relocate persistent targets between rooms |
| `$06-$07` | punishment-room dorayaki/skull swarm and Genki Candy behavior scripts only |
| `$08` | updates the linked giant-octopus tentacle chain |
| `$09` | octopus segment behavior script only |
| `$0A` | updates the dragon head/body encounter chain |
| `$0B` | dragon body behavior script only |
| `$0C` | Poseidon anchor; follows its target and may emit volcanic rocks when two slots are free |
| `$0D` | follows the Poseidon anchor at X + `$10` |
| `$0E` | follows the Poseidon anchor at Y + `$18` and animates |
| `$0F` | follows the Poseidon anchor at X + `$10`, Y + `$18` and animates |

The type `$04` tracking flag is enabled in eight rooms. Type `$05` uses the
four signed motion vectors `(2,2)`, `(-2,2)`, `(2,-2)`, and `(-2,-2)` while it
holds a state-4 target. When that target is persistent and type `$05` leaves
the room bounds, the handler chooses a neighboring or random destination not
blocked by its 64-room mask, then writes the target's room and fresh coordinates
back to the persistent registry.

## Result and persistent types

| Types | Update role |
| --- | --- |
| `$10-$16` | static post-defeat results |
| `$17` | static dragon chest |
| `$18` | talisman completes a dragon encounter and removes its room marker |
| `$19` | Passing Hoop checks a terrain trigger and updates a vertical room column |
| `$1A` | key opens `$14-$16` companion chests or seeds a dragon from `$17` |
| `$1B` | Holding Bag pushes nearby enabled persistent objects |
| `$1C-$1F` | Suneo, Nobita, Gian, and Shizuka face/follow the player when enabled |

Several persistent handlers share `World3_PositionEnabledPersistentEntity`,
which pins an enabled object beside the player with a small vertical animation.
State 4 consistently routes through `World3_FollowActiveGhost`, tying the
persistent and low-type dispatch domains to the type `$05` capture mechanic.

## Lossless handler data

Three non-contiguous data ranges belong to these updates:

| Range | Contents |
| --- | --- |
| `$936C-$93AB` | 64 type-`$04` tracking-enable flags |
| `$93E7-$93EE` | four type-`$05` signed X/Y held-motion vectors |
| `$9550-$958F` | 64 type-`$05` relocation-blocked flags |

`data/world3/update_handler_data.json` transposes all 136 bytes into editable
records while preserving combined CRC32 `14de971d`. Run
`make validate-world3-update-handlers` to verify the dispatch mapping, all 32
roles, representative code signatures, boolean domains and counts, motion
vectors, table CRCs, and full authoring round trip.
