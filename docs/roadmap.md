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

### 4. Semantic source layout - Complete

Replace the four monolithic physical-bank listings with address-ordered common,
world, audio, and data modules. Every byte of all four banks is covered without
gaps or overlaps, and every module remains at or below 700 lines.

### 5. RAM and object systems - In Progress

Recover shared and chapter-specific RAM, enemies, items, NPCs, projectiles,
doors, manholes, bosses, triggers, and persistent progression state. The World
1 entity grid, persistence masks, dispatch graphs, three-byte city and
underground placement lists, thirteen descriptor definitions, transient
selectors, and five collision-extent tables are now machine-validated and
losslessly editable. World 2's embedded screen-stream enemy tokens, overlapping
screen views, lossless authoring data, token-to-state normalization, complete
20-state runtime domain, three editable property tables, and dispatch graphs
are proven;
World 3's initial thirteen-record persistent registry, randomized type groups,
and low-type behavior pointers are now exact. All sixteen low-type behavior
streams are decoded into a lossless editable format. Its full 32-type catalog,
five property columns, four lifecycle domains, and two encoded transformations
are now exact. The registry and property columns also round-trip through one
row-oriented lossless object catalog. The four-channel transient scheduler is
also exact for all 64 rooms: twelve type/count/delay columns, RAM state, timing,
spawn budgets, and initializer dispatch round-trip through a 768-byte editable
format. All sixteen initializer slots are structurally classified, including
their room gates, fixed positions, and type `$08/$09`, `$0A/$0B`, and
`$0C-$0F` formation layouts. The full 32-slot update dispatch is classified
into structural roles with its room gates, relocation masks, and movement
vectors losslessly editable. Character and item identities remain active work.

### 6. World data formats - Planned

Complete maps, metatiles, screen sequences, collision properties, object
placements, transitions, and their cross-references for all three worlds.
The exact World 1 and World 3 map/metatile hierarchies are now validated and
losslessly editable. World 2's runtime screen sequence is also losslessly
editable, including all five stage-sequence command classes and three entry
offsets. Its exact 208-entry metatile catalog, palette selectors, renderer
addressing, all standard-stream cross-references, and the 208 solid flags are
now losslessly editable. The apparent dynamic selectors are resolved: `$7F` is
a stopped terminal sentinel and `$7B` begins the collision bitmap. Remaining
cross-references keep this milestone planned while RAM/object work is active.

### 7. Rendering, graphics, and text - Planned

Recover PPU update paths, palettes, sprites/metasprites, CHR ownership, title,
HUD, dialogue, item names, and ending presentation. World 2's nine palette
sets, background and sprite upload paths, stage palette commands, three chapter
selector pairs, and deliberate code/data overlap are now exact and losslessly
editable. World 3's 188-entry direct/alias sprite index, 65 variable-length
metasprites, eleven complete palette sets, and 64 room selectors are also exact
and losslessly editable.

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
