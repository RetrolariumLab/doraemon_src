# World 2 enemy states

World 2 embeds enemy spawn tokens in its compressed screen streams. Although
the decoder reserves `$D0-$EE`, the canonical physical token pool uses only
`$D0-$DE`.

## Token normalization

Spawned tokens are initially stored unchanged, so their high bit keeps them on
the delayed materialization path. At `$9A32`, the runtime converts a token with:

```text
state = ((token & $1F) ^ $10) + 1
```

This maps `$D0-$DE` one-to-one onto states `$01-$0F`. The shared compressed pool
contains 685 physical spawn bytes; overlapping selector views encounter them
738 times. `config/authoring/world2/world2_enemy_states.json` fixes the
frequency of every token.

## Runtime domain

The ordinary enemy domain is `$01-$14`. States `$01-$0F` come directly from
screen tokens, while `$10-$14` are internal states reached by behavior and
collision transitions. State zero is the inactive pool value.

Rendering has 20 reachable RTS-minus-one slots for `$01-$14`. Updating has 21
slots for `$00-$14`; its state-zero entry supplies the inactive path. The render
view at `$A54A-$A571` and update view at `$A570-$A599` share two bytes. The final
update byte at `$A599` is also the unused state-zero entry of the reward table.

## State properties

| Table | Range | Entries | Runtime use |
| --- | --- | ---: | --- |
| attack period | `$A4FD-$A511` | 21 | threshold for spawning an enemy projectile |
| damage threshold | `$A511-$A525` | 21 | hits required before defeat handling |
| score reward code | `$A599-$A5AD` | 21 | code passed to the score updater on defeat |

The attack-period and damage tables share `$A511`. All three use a state-zero
entry even though active collision/update paths index nonzero states.

`data/world2/enemy_states.json` joins the three columns into 21 row-oriented
state records. Its encoder writes 62 unique ROM bytes: the three 21-byte views
minus their shared `$A511` byte. Matching overlap values are required; a
conflicting edit is rejected. The reward state-zero byte at `$A599` remains
explicit because it is also the final byte of the update dispatch table.

Run `make validate-world2-enemy-states` to verify token frequencies in the
lossless screen authoring data, the normalization machine-code signature,
runtime-state partition, property bytes and CRCs, both dispatch tables, and all
three shared-storage relationships. The same target round-trips the editable
state records. `config/reconstruction/world2/world2_enemy_handlers.json` additionally validates all
20 state-to-update and state-to-render edges and assigns behavior-derived
structural names; see `docs/world2_enemy_handlers.md`. Individual enemy
identities remain unnamed until sprite and behavior evidence supports them.
