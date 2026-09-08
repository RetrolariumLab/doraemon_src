# World 2 enemy handlers

World 2 dispatches its enemies by runtime state through two RTS-minus-one
tables in PRG bank 1. `config/reconstruction/world2/world2_enemy_handlers.json` records every active
state-to-handler edge and gives each target a behavior-derived structural name.
It deliberately does not assign character identities that sprite or external
evidence has not established.

## Lifecycle domains

States `$01-$0F` are created directly by normalized `$D0-$DE` screen tokens.
States `$10-$14` occur only through internal behavior and collision
transitions. State zero is inactive and has no render slot.

| Domain | States | Count |
| --- | --- | ---: |
| direct spawn | `$01-$0F` | 15 |
| internal | `$10-$14` | 5 |

The 20 active states resolve to 19 unique update targets and 18 unique render
targets. The sharing is meaningful:

- states `$03` and `$0C` use the same axis-selected chase update;
- states `$08` and `$0F` use the same reflected render path;
- states `$0E` and `$10` use the same phase-selected render path;
- state `$11` sends both update and render to the same one-byte `RTS`;
- state `$09` also has a one-byte invisible render path;
- update slot zero points at `$A0B9`, which is active render code for state
  `$14`; it is retained as an exact shared-storage edge, not an active update.

## Validation

`make validate-world2-enemy-handlers` checks the lifecycle partition against
`config/authoring/world2/world2_enemy_states.json`, both exact dispatch
mappings and their ROM
bytes against `config/reconstruction/common/object_dispatch.json`, and every handler symbol against
`config/reconstruction/symbols.json`. The target is part of `make release-check`.

The original structural names described only observable motion, timing,
projectile, and rendering behavior. The canonical identities are now resolved
by joining this graph with metasprites, property tables, boss control flow, and
published Japanese names; see `docs/world2_enemy_identities.md`.
