# Core indirect dispatch roles

Two non-audio indirect domains dispatch through tables; every target has a
conservative role and an evidence-backed name.

World 2 has 17 unique screen-service targets shared by three 16-slot RTS tables.
They cover no-op and stage/row progression, horizontal-row and vertical-column
metatile expansion, attribute read/merge operations, tile and attribute PPU
uploads, and palette application.

World 3 has five player-state handlers: frozen, controlled movement, alternate
movement, damage recovery, and death. The names describe directly observed
state-machine behavior and do not claim unproved story meaning for the
alternate movement mode.

Audio effect entries are a separate subsystem ([audio](audio_system.md)).
