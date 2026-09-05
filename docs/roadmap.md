# Roadmap

The independent workstream statuses below mirror
`config/source_reconstruction.json`. Detailed acceptance criteria are in
`docs/source_reconstruction.md`.

### 0. Preservation baseline - Complete

The PRG0 identity, four-bank ca65 build, deterministic disassembly pipeline,
known map ranges, and byte-for-byte verification are fixed at the `main`
baseline commit.

### 1. Reconstruction contract - Complete

The target quality, independent workstreams, evidence rules, release gates, and
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

### 5. Semantic naming - Partial

Replace neutral address-based names for all major routines, indirect-dispatch
targets, and key RAM state with evidence-backed roles. Local branch labels are
lower priority and remain address-qualified where their role is not material.
Progress is measured per bank by a machine-audited reconstruction inventory,
not inferred from module names.

### 6. RAM and object systems - Partial

Recover shared and chapter-specific RAM, enemies, items, NPCs, projectiles,
doors, manholes, bosses, triggers, and persistent progression state. The World
1 entity grid, persistence masks, dispatch graphs, three-byte city and
underground placement lists, thirteen descriptor definitions, transient
selectors, and five collision-extent tables are now machine-validated and
losslessly editable. All thirteen descriptor identities and effects are also
joined to their placements, selector slots, metasprites, dispatch targets, and
code signatures, including the dynamic weapon sequence and both hidden
rewards. World 1's ten ordinary enemies, two mode variants, dormant state, and
scripted boss states now have evidence-backed identities and semantically named
handlers. Shared lives, current health, and inverse health-capacity state are
named across all four banks. World 1's shared city/underground player position,
metasprite, render flags, damage/death state, animation divider, weapon tier,
side-view airborne flag, signed vertical velocity, horizontal subpixel,
four-way direction, coarse 8-pixel camera coordinates, nametable selection,
NMI scroll latches, per-frame screen compensation, map-prefill countdown,
projectile limit, Stopwatch state, invulnerability countdown, and Flash Light
handoff into World 2 are also named from their producer and consumer paths.
The complete 16-byte World 1 metasprite renderer workspace and OAM emitter are
now symbol-owned and machine-validated alongside the lossless 115-index sprite
catalog. Its two independent pseudorandom state machines are also named and
machine-validated: the two-byte frame-mixed generator has all seven direct
callsites pinned, while the four-byte state-only generator has all eighteen.
World 1's city player update, shared weapon firing path, collision rollback,
and player-to-map collision sampler are exact across 589 routine bytes and 26
direct calls. Direction priority, movement bounds, ten collision probes, hit
recovery, animation cadence, and three input/weapon RAM fields are also pinned.
The side-view update, grounded support test, jump initializer, and signed
vertical integrator extend that proof to 1,174 routine bytes and 34 calls.
Half-pixel horizontal motion, twelve wall/floor/ceiling probes, jump velocity,
gravity, terminal fall speed, tile alignment, and airborne transitions are
machine-validated.
The nine side-view room profiles now join camera starts and limits, player
starts, both axis city-return selectors, and the nine city-return camera and
manhole profiles in one lossless 108-byte authoring
format, including explicit no-exit sentinels and loader/selector signatures.
Its three weapon sounds and twelve directional projectile spawn profiles are
now losslessly editable across all 51 table bytes, with the biased lookup bases
and loader code signatures enforced.
World 2's embedded screen-stream
enemy tokens, overlapping screen views, lossless authoring data, token-to-state
normalization, complete 20-state runtime domain, three editable property tables,
and dispatch graphs are proven. All 20 update/render edges are now structurally
classified as 19 unique update targets and 18 unique render targets, including deliberate
  shared and no-op paths. All direct enemies, two Gangan variants, three bosses,
  and their internal helpers now have evidence-backed identities; boss tables,
  helper-spawn relationships, scores, and the four-Takkon item rule are enforced.
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
vectors losslessly editable. All 32 World 3 identities are now evidence-backed;
type `$06` is confirmed as the punishment-room dorayaki/skull swarm by the
20-treasure entry and 20-dorayaki exit paths. Eleven formerly raw,
instruction-aligned World 3 helper islands are also reconstructed and
explicitly marked dormant until runtime reachability is demonstrated. The
active World 3 PPU queue now has named RAM ownership and a documented
address/flags/length/payload record.
Its record geometry, capacity invariant, RAM ownership, routine addresses, and
representative consumer/producer bytes are enforced by the release gate.

### 7. World data formats - Partial

Complete maps, metatiles, screen sequences, collision properties, object
placements, transitions, and their cross-references for all three worlds.
The exact World 1 and World 3 map/metatile hierarchies are now validated and
losslessly editable. World 1's eight-entry runtime hierarchy decoder, eleven-byte
RAM ABI, complete 34-call graph, and all four city/underground map-pointer loads
are joined to that authoring model and machine-validated. World 2's runtime screen sequence is also losslessly
editable, including all five stage-sequence command classes and three entry
offsets. Its exact 208-entry metatile catalog, palette selectors, renderer
addressing, all standard-stream cross-references, and the 208 solid flags are
now losslessly editable. The apparent dynamic selectors are resolved: `$7F` is
a stopped terminal sentinel and `$7B` begins the collision bitmap. Remaining
cross-references keep this workstream partial.

### 8. Rendering, graphics, and text - Partial

Recover PPU update paths, palettes, sprites/metasprites, CHR ownership, title,
HUD, dialogue, item names, and ending presentation. World 1's complete
row/column map-streaming path is now exact: two packet families own 92 RAM
bytes, six producer/consumer routines, 1,013 routine bytes, and a complete
20-call graph. Its four bounded directional camera routines, 325 routine
bytes, eight state bytes, pixel/coarse-coordinate rules, and complete 16-call
graph are also exact. The two underground room-orientation trackers add 228
routine bytes, four axis-state bytes, two exhaustive calls, horizontal and
vertical player bands, and their two- or six-pixel budgets. Player-threshold
tracking, all 48 entity coordinate
projections, packed high-bit carry handling, offscreen culling, and spawn-bit
release are pinned across another 326 routine bytes and 13 direct calls. World
2's nine palette
sets, background and sprite upload paths, stage palette commands, three chapter
selector pairs, and deliberate code/data overlap are now exact and losslessly
editable. Its 58 fixed two-by-two metasprites, 36 OAM attribute values, CHR
ownership, all 20 enemy-state index sets, and two shared-storage boundaries are
also exact and losslessly editable. World 3's 188-entry direct/alias sprite index, 65 variable-length
metasprites, eleven complete palette sets, and 64 room selectors are also exact
and losslessly editable. Its NMI/disabled-rendering queue ownership, ring
indexes, record flags, address calculators, and palette/attribute shadows are
also documented.

### 9. Audio - Partial

Recover the sound driver, channel state, command streams, music, and sound
effects with documented formats and bank ownership. The four local music
drivers now share a machine-validated 92-byte channel ABI and a structurally
named 17-command grammar. All 68 command targets, four track limits, and 980
bytes of envelope/note/stream-position helpers are exact. Track-header and
reachable-stream authoring plus effect/music APU arbitration remain open.

### 10. Authoring round trips - Partial

Provide lossless decode/encode tools and tests for the primary map/metatile,
gameplay object/collision, chapter metasprite/palette, title/HUD/dialogue, and
audio command-stream families. Secondary fixed tables need typed source or a
registered unknown, not necessarily a dedicated visual editor.

### 11. Source Reconstruction 1.0 - Planned

Resolve or explicitly classify remaining release-scope unknowns, generate and
live-validate linker-derived debugger symbols, refresh all eight runtime
scenarios, run one clean aggregate `source-1-audit`, and prepare the audited
release commit.

## Deferred to Source Reconstruction 2.0

Relocation builds, Revision A, translations and regional profiles, and
exhaustive editors for secondary graphics/text tables are outside the 1.0
definition of done.
