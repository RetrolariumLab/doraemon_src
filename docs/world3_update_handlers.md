# World 3 entity update handlers

`World3_UpdateEntities` walks eight active slots. Types below `$10` first run
their packed behavior stream; every type `$00-$1F` then indexes the 32-pointer
table at `$92DF`. The table has 19 unique addresses and 17 evidence-backed
structural roles.

## Low scripted types

| Types | Update role |
| --- | --- |
| `$00-$03` | behavior script only; state 4 follows the active type `$05` |
| `$04` | behavior plus room-enabled movement toward the player every fourth update |
| `$05` | captures a nearby eligible object into state 4 and can relocate persistent targets between rooms |
| `$06-$07` | behavior script only |
| `$08` | updates the linked type `$08/$09` formation chain |
| `$09` | behavior script only |
| `$0A` | updates the type `$0A/$0B` encounter chain |
| `$0B` | behavior script only |
| `$0C` | formation anchor; follows its configured target and may create type `$02` children when two slots are free |
| `$0D` | follows active type `$0C` at X + `$10` |
| `$0E` | follows active type `$0C` at Y + `$18` and animates |
| `$0F` | follows active type `$0C` at X + `$10`, Y + `$18` and animates |

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
| `$17` | static persistent type |
| `$18` | completes a type `$0A/$0B` encounter and removes its room marker |
| `$19` | checks a terrain trigger and updates a vertical room column |
| `$1A` | converts persistent `$14-$16` to `$1C-$1E`, or consumes `$17` and seeds an encounter |
| `$1B` | pushes nearby enabled persistent objects |
| `$1C-$1F` | face the player and follow while their persistent state is enabled |

Several persistent handlers share `World3_PositionEnabledPersistentEntity`,
which pins an enabled object beside the player with a small vertical animation.
State 4 consistently routes through `World3_FollowActiveType05`, tying the
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
