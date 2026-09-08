# World 1 final routines

`config/reconstruction/world1/world1_final_routines.json` closes the remaining ten address-only
routine entries in Bank 0. Five routines own the vertical underground finale
and scripted Bull Robo battle; five are entity-handler geometry and movement
helpers.

The finale path swaps the city and underground persistence masks, establishes
the special bottom boundary, reveals Bull Robo, runs its hop/patrol/projectile
controller, emits randomized defeat explosions, and transfers to World 2. Its
death path also records the life-loss, game-over, and return-to-city behavior.

The handler-local layer contains an offset map collision test, Chebyshev
distance to the player, two-step direction motion with and without reversal,
and fine-scroll-relative vertical tile alignment. The intentional fallthrough
from the reversing entry to the two-step mover is represented by two
non-overlapping code spans.

The machine contract pins 965 executable bytes, 19 direct JSR/JMP callers, and
21 RAM records. Five newly named Bank 0 fields cover the finale floor flag,
sequence/reveal counters, jump phase, and attack timer. With this contract,
Bank 0 has no remaining neutral routine entry labels; address-qualified local
branches remain lower-priority implementation detail.

Run:

```text
make validate-world1-final-routines
```
