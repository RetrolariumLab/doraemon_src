# Core indirect dispatch roles

Two non-audio indirect domains previously had structurally known tables but
address-only target names. `config/core_dispatch_roles.json` joins every target
to a conservative role and evidence-backed symbol.

World 2 has 17 unique screen-service targets shared by three 16-slot RTS tables.
They cover no-op and stage/row progression, horizontal-row and vertical-column
metatile expansion, attribute read/merge operations, tile and attribute PPU
uploads, and palette application.

World 3 has five player-state handlers: frozen, controlled movement, alternate
movement, damage recovery, and death. The names describe directly observed
state-machine behavior and do not claim unproved story meaning for the
alternate movement mode.

`make validate-core-dispatch-roles` checks that the catalog exactly covers the
underlying dispatch target sets and that every target has its declared source
symbol. Audio effect entries remain a separate subsystem.
