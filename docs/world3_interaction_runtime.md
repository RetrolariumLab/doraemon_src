# World 3 interaction runtime

`config/reconstruction/world3/world3_interaction_runtime.json` fixes nine formerly address-named
World 3 interaction entries. The exact contract covers 1,016 executable bytes,
26 direct calls, and eight Bank 2-private RAM bytes. Two blank-tile rows used
by the arena and barrier updates are also named in the symbol registry.

The frame loop now exposes the complete room `$3C` rescue condition. All three
active companion types `$1C-$1E` must be present before the game flashes the
palette, opens an eight-row barrier, marks the rescue complete, removes the
active companions, and retires their persistent records. Room reload repeats
the same barrier update while the completion flag is set.

The player-projectile path scans both projectile slots against each active
entity, applies the exact target exclusions and 13-pixel axis hitbox, changes
the projectile to its impact animation, decrements hit points, and dispatches
defeat progression. Type `$08` resolves the three giant-octopus room flags;
types `$0C-$0F` start the final completion delay. The shared defeat helper
installs state five and the explosion metasprite, while the score adapter keeps
attract mode scoreless and preserves the entity traversal registers.

The contact path distinguishes the punishment-room type `$06` collectible from
its damaging skull form, records the two fixed Genki Candy pickups, toggles
persistent followers through a B-button edge latch, and implements the four
post-defeat items. Type `$10` starts the stopwatch, `$11` refills health,
`$12` defeats active combat entities and advances the punishment counter, and
`$13` advances the same counter without the mass defeat. All remaining harmful
contacts feed the documented damage-recovery or death player states.

Run:

```text
make validate-world3-interaction-runtime
```
