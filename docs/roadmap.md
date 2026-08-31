# Roadmap

The status sequence below mirrors `config/source_reconstruction.json`. Detailed
acceptance criteria and the evidence policy are in
`docs/source_reconstruction.md`.

### 0. Preservation baseline - Complete

The PRG0 identity, four-bank ca65 build, deterministic disassembly pipeline,
known map ranges, and byte-for-byte verification are fixed at the `main`
baseline commit.

### 1. Reconstruction contract - Complete

The target quality, ordered milestones, evidence rules, release gates, and
immutable predecessor are machine-audited.

### 2. Runtime architecture - Complete

Build deterministic trace tooling and prove reset/NMI, mapper writes, main
dispatch, input, and the complete bank-transition graph.

### 3. Chapter execution evidence - Complete

Capture boot/title, city, underground, cave, underwater, transition, and ending
scenarios. Identify each chapter's initialization, frame, update, collision,
render, and exit paths.

### 4. Semantic source layout - In Progress

Replace the four monolithic physical-bank listings with address-ordered common,
world, audio, and data modules. Keep every module at or below 700 lines. Banks 0
and 3 are complete; banks 1 and 2 remain preservation listings.

### 5. RAM and object systems - Planned

Recover shared and chapter-specific RAM, enemies, items, NPCs, projectiles,
doors, manholes, bosses, triggers, and persistent progression state.

### 6. World data formats - Planned

Complete maps, metatiles, screen sequences, collision properties, object
placements, transitions, and their cross-references for all three worlds.

### 7. Rendering, graphics, and text - Planned

Recover PPU update paths, palettes, sprites/metasprites, CHR ownership, title,
HUD, dialogue, item names, and ending presentation.

### 8. Audio - Planned

Recover the sound driver, channel state, command streams, music, and sound
effects with documented formats and bank ownership.

### 9. Authoring round trips - Planned

Provide lossless decode/encode tools and tests for maps, metatiles, objects,
collisions, graphics, palettes, text, and audio.

### 10. Relocation proof - Planned

Build and validate a deliberately relocated development image to prove source
relationships and expose hidden absolute-address assumptions.

### 11. Source Reconstruction 1.0 - Planned

Resolve or explicitly classify remaining unknowns, run the clean aggregate
gate, finalize the documentation, and prepare the audited release commit.
