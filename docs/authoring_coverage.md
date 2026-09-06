# Source 1.0 authoring coverage

`config/authoring_coverage.json` is the machine-readable inventory for the five
primary format families required by Source Reconstruction 1.0. It records the
authoring data, structural contracts, documentation, tests, and release-gated
validators for each chapter rather than inferring completeness from filenames.

| Primary family | Chapter components | Unique authoring files |
| --- | ---: | ---: |
| world maps and metatiles | World 1, World 2, World 3 | 6 |
| gameplay objects and collisions | World 1, World 2, World 3 | 14 |
| chapter metasprites and palettes | World 1, World 2, World 3 | 5 |
| title, HUD, and dialogue | shell | 1 |
| audio command streams | four bank-local drivers | 1 |

Files shared by two families count once in the aggregate. The complete matrix
contains 11 chapter-level components and 23 unique authoring documents. Thirty
focused validator targets join those documents to the canonical PRG, runtime
code, and the aggregate `release-check` gate.

Collision ownership differs by chapter. World 1 and World 3 derive passability
from the tile identities reached through their editable hierarchical maps; the
machine contracts pin the probes, thresholds, and state-dependent overrides.
World 2 stores one editable solid bit for every one of its 208 metatiles. World
1 object descriptors additionally expose their five collision-extent tables.
The audit therefore requires both the lossless data and the relevant runtime
collision validator instead of treating an arbitrary `collision` filename as
evidence.

The fixed presentation contract covers the title and score labels, game-over
line, all three chapter-help screens and item names, ending opening, and the 380
active credit rows. The remaining post-credit region is typed source and a
registered unknown under the secondary-table policy. Likewise, audio coverage
is limited to all header-reachable command streams; adjacent unreachable bytes
remain registered without blocking Source 1.0.

Run:

```text
make validate-authoring-coverage
```

The audit rejects a missing chapter component, a non-lossless primary format,
missing evidence, a validator absent from the Makefile, or a validator omitted
from `release-check`. The focused validators still perform the actual CRC,
geometry, code-signature, cross-reference, and byte-exact round-trip checks.
