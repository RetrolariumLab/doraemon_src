# World 3 formation runtime

`config/world3_formation_runtime.json` fixes thirteen formerly address-named
World 3 formation, chain-motion, and encounter helpers. The exact contract
covers 679 executable bytes and 28 direct calls. It also checks twelve
established RAM fields and names six formation-specific scalar fields plus the
64-room encounter exclusion mask.

The type `$08/$09` giant-octopus formation occupies contiguous active slots.
Its head stores the slot limit for the tentacle, while each following segment
is rate-gated and stepped toward the nearer adjacent anchor on each axis. The
player-side anchor stays 14 pixels toward the head; the terminal anchor uses X
`$80` and Y `$68` or `$80` according to the head slot.

The two generic coordinate helpers move the `$3C/$3D` work position by one
pixel toward X/Y register targets. Their direct-call contract covers skull,
Poseidon, Holding Bag, octopus, and dragon users rather than treating them as
octopus-private helpers.

The eight-slot encounter-room list moves toward the player's current room one
random occupied entry at a time. Candidate row and column steps are committed
only when the 64-room mask permits them and no duplicate already exists. On
room load, a matching entry reserves a free active slot and falls into the
fixed type `$0A/$0B` dragon-formation builder.

The dragon head alternates between pursuing the player and randomized target
coordinates. Its contiguous type `$0B` segments follow their predecessor when
either axis separates by at least six pixels. The formation head slot and X/Y
offsets now have explicit Bank 2 RAM ownership.

Run:

```text
make validate-world3-formation-runtime
```
