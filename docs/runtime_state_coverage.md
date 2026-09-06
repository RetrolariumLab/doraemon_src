# RAM and object-system coverage

`config/runtime_state_coverage.json` is the completion inventory for the shared
runtime and each gameplay bank. It joins the semantic RAM registry, object-pool
layouts, indirect dispatches, chapter routine contracts, and the focused
validators already run by `release-check`.

The measured baseline is:

- 437 unique evidence-backed RAM symbols;
- 83 shared RAM symbols;
- 181, 180, 234, and 91 effective symbols in PRG banks 0 through 3;
- eight complete object-pool layouts, 98 total slots, and 67 field columns;
- 48 lifecycle routines and zero unclassified pool field bases;
- zero neutral routine definitions;
- all 354 registered indirect code entries semantically named.

Coverage is divided into four independently checked components: common shell
and audio state, World 1, World 2, and World 3. The three chapter components
include their frame/player state, render and PPU workspaces, collision state,
object layouts, dispatch domains, lifecycle routines, and chapter-specific
transitions. The manifest pins the exact validator set for each component; a
validator must exist and remain a prerequisite of `release-check`.

This is not a claim that every unused byte in internal RAM has a name. The
Source 1.0 contract requires key state and complete active object layouts, so
aliases are added only when an access pattern establishes ownership and role.
Bank overlays remain explicitly bank-scoped in `config/symbols.json`.

Run:

```text
make validate-runtime-state-coverage
```

The audit recalculates the RAM, routine, indirect-entry, and object-pool metrics
from current source and manifests. It rejects stale counts, incomplete chapter
components, missing evidence, changed validator inventories, and validators
that have fallen out of the aggregate release gate.
