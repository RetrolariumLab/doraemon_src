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

### 5. Semantic naming - Complete

Replace neutral address-based names for all major routines, indirect-dispatch
targets, and key RAM state with evidence-backed roles. Local branch labels are
lower priority and remain address-qualified where their role is not material.
Progress is measured per bank by a machine-audited reconstruction inventory,
not inferred from module names. All 354 indirect entries and all sixteen bank
gateway targets are semantic. Runtime now proves and names the four gameplay
loops (city, underground, World 2, and World 3) at exactly one iteration per
emulated frame. The Bank 3 shell pass removes its final sixteen neutral routine
entries. The first World 1 core pass removes another twenty initialization,
input, pause, and frame-render entries. A second pass names twenty-three motion,
collision, damage, reward, timed-powerup, and PPU-preparation routines; 231
probable routine entries remained. A third World 1 pass names seventeen
direction, map-probe, collision-edge, and projectile-construction helpers; 214
probable routine entries remained. The final World 1 pass names the ten
remaining underground-finale and handler-local entries plus five boss/finale
RAM fields. Bank 0 now has no neutral routine entries; all 204 remaining
routine entries were in Banks 1 and 2. The first World 2 core pass names
fifteen frame/render/stage routines and ten RAM fields, reducing the current
total to 189. The player/inventory/fire pass names thirteen more routines and
nine RAM fields, reducing the current total to 176 (63 in Bank 1 and 113 in
Bank 2). The screen/NMI/PPU pass removes six more Bank 1 entries, reducing the
current total to 170 (57 in Bank 1 and 113 in Bank 2). The projectile-runtime
pass names seventeen hazard, player-projectile, and inventory-attack routines
plus nine zero-page fields, reducing the total to 153. The sprite-runtime pass
names another 27 player, inventory, metasprite, and OAM routines plus nine RAM
symbols, reducing the total to 126. The final Bank 1 pass names its remaining
thirteen enemy collision/rendering, chapter-exit, and HUD routines plus
nineteen RAM symbols. The current total is 113, all in Bank 2; Banks 0, 1, and
3 have no neutral routine entries. The first Bank 2 core pass names eighteen
entry/frame support routines and twenty-two RAM fields spanning initialization,
room/player state, pause, boss/music timing, palette effects, OAM buffering,
and the World 3 HUD. The next Bank 2 pass names twenty-two entity-rendering,
terrain-probe, and special-room override routines plus twenty RAM symbols.
Its machine contract covers 808 executable bytes and 50 direct calls. The next
Bank 2 pass names fifteen input/audio, player-render, directional-transition,
persistence-policy, room-reload, music-selection, and palette-fade routines
plus ten RAM bytes and two music tables. Its contract covers 607 executable
bytes and 76 direct calls. The player-runtime pass names thirteen hierarchical
map lookup, player initialization/reset, state, horizontal, and vertical
movement routines plus fourteen RAM bytes and four tables. Its exact contract
covers 690 executable bytes, 25 direct calls or tail jumps, and four
conditional entries. At that checkpoint, 45 neutral routine entries remained
in the World 3 gameplay subsystems in Bank 2. The interaction-runtime pass names
nine final-companion, arena/barrier, projectile-hit, defeat/score, pickup,
follower, and contact routines plus eight RAM fields and two blank-tile rows.
Its exact contract covers 1,016 executable bytes and 26 direct calls. At that
checkpoint, the remaining 36 neutral routine entries were confined to the
World 3 gameplay subsystems in Bank 2. The entity-runtime pass names ten Passing Hoop,
persistent-object clamp/carry, type-04 split, stopwatch, spawn-coordinate, and
portal-opening helpers plus the 64-entry room clamp table. Its contract covers
545 executable bytes and 17 direct calls or tail jumps. At that checkpoint,
the remaining 26 neutral routine entries were confined to Bank 2. The
room-rendering pass names eight palette-in, map-window, hierarchical expansion,
tile-pair, attribute, and PPU-row helpers plus five RAM fields. Its contract
covers 351 executable bytes and ten direct calls. At that checkpoint, the
remaining 18 neutral routine entries were confined to Bank 2. The
formation-runtime pass names thirteen giant-octopus chain, coordinate-step,
encounter-room, dragon spawn, and dragon update helpers plus the 64-room
encounter exclusion mask and six RAM aliases. Its contract covers 679
executable bytes and 28 direct calls. At that checkpoint, the remaining five
neutral routine entries were confined to Bank 2 chapter transitions. The final
transition-runtime pass names the completion sequence and wipe, room `$3F`
marker, diagnostic halt, and controller-two sprite-test setup plus three fixed
transfer tables and one RAM alias. Its contract covers 374 executable bytes and
twelve direct calls or tail jumps. No neutral routine definitions remain in
any PRG bank; address-derived local branch labels remain intentionally tracked
as a separate readability metric.

### 6. RAM and object systems - Complete

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
The projectile runtime additionally pins the complete seven-slot player
projectile motion path, the player hazard accumulator, both inventory-owned
attacks, their rendering paths, and nine private zero-page fields across 768
executable bytes and 23 direct edges.
The complete World 2 player/inventory sprite chain is now pinned from its
priority ordering and 48-sample companion history through two-sprite row
composition to the four-byte OAM writer: 27 routines, 864 executable bytes,
54 direct edges, and 103 RAM bytes.
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
Bank 3's fixed text path is also exact: game-over text, thirteen title PPU
records, the ending-opening nametable, three chapter-help nametables and their
26 item-name spans, and all 380 active credit rows are losslessly editable.
The 3,200 bytes after the proven credit stop pointer are typed and explicitly
registered as unclassified rather than folded into the active credits.
The completion audit now recalculates 437 RAM symbols, all eight object-pool
layouts and 98 slots, zero unclassified pool field bases, zero neutral routine
definitions, and 354/354 semantically named indirect entries. Its four
components cover common state plus every chapter-specific player, collision,
camera, transition, rendering, and object contract.

### 7. World data formats - Complete

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
a stopped terminal sentinel and `$7B` begins the collision bitmap. The primary
coverage audit enumerates the screen, branch, transition, map-decoder, and
collision cross-references for all three worlds.

### 8. Rendering, graphics, and text - Complete

Recover PPU update paths, palettes, sprites/metasprites, CHR ownership, title,
HUD, dialogue, item names, and ending presentation. World 1's complete
12-record full PPU palette table, area-indexed loader, and all 384 bytes are
exact and losslessly editable. Its complete
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
also documented. The title/HUD/help/ending authoring contract and chapter-level
sprite, palette, CHR-reference, and PPU-path evidence now satisfy the scoped
Source 1.0 presentation family. Exhaustive secondary graphics editors remain
deferred.

### 9. Audio - Complete

Recover the sound driver, channel state, command streams, music, and sound
effects with documented formats and bank ownership. The four local music
drivers now share a machine-validated 92-byte channel ABI and a structurally
named 17-command grammar. All 68 command targets, four track-ID limits, and 980
bytes of envelope/duration/event/stream-position helpers are exact. All 26 playable
track headers and 10,016 header-reachable stream bytes now round-trip through
a state-aware authoring format. The four effect-before-music frame paths,
channel timer leases, guarded music writes, and track-start reset exception are
also exact. All 93 request IDs are classified into 26 conservative structural
effect roles. Exact in-game names for individual effects and bytes outside the
header-reachable streams remain registered unknowns rather than release claims;
they do not weaken the complete driver, ABI, arbitration, or stream contracts.

### 10. Authoring round trips - Complete

Provide lossless decode/encode tools and tests for the primary map/metatile,
gameplay object/collision, chapter metasprite/palette, title/HUD/dialogue, and
audio command-stream families. Secondary fixed tables need typed source or a
registered unknown, not necessarily a dedicated visual editor.
`config/authoring_coverage.json` pins 11 chapter-level components, 23 unique
authoring documents, and 30 focused validators. The aggregate audit rejects
missing chapter coverage, non-lossless components, missing evidence, or
validators omitted from `release-check`.

### 11. Source Reconstruction 1.0 technical scope - Complete

All release-scope unknowns are explicitly classified, and the clean aggregate
`source-1-audit` refreshes all eight runtime scenarios before the annotated
release tag is created. Debugger-symbol validation is complete: the static
gate checks all four linker segments, 3,828 ld65 symbols, eight FCEUX PRG name
lists, 83 shared RAM labels, and required Reset/NMI/mapper/chapter-loop probes.
The live gate additionally joins 14 observed program PCs across all four banks
and five changing RAM watches to those generated names.

The post-review routine pass is complete. The inventory now records 1,228
semantic global labels, no neutral routine definitions in any bank, and all
354 indirect code entries with evidence-backed symbols. The remaining 2,129
address-derived labels are local branches and are tracked separately; they are
renamed only where a behavioral role materially improves the surrounding
routine contract.

The source-byte classification is also complete. The canonical ca65 listing
accounts for 47,789 instruction bytes and 83,283 directive bytes. Every
directive byte is now release-gated as base/supplemental typed data, proven
encoded code, verified fill, or one of 5,700 exact registered-unknown bytes.

### 12. Revision 3 release administration - Complete

The revision-3 manifest, scope, profile/runtime matrix, SHA-256 artifact and
private-input identities, pinned build/runtime toolchain, licensing inventory,
documentation index, and pre/post-tag audits are complete. The owner-approved
rewrite replaces 141 draft changes with 61 coherent commits after the immutable
base; their messages and attribution satisfy the contract. The release
candidate is `tag-ready` and awaits the clean aggregate pre-tag gate.

## Deferred to Source Reconstruction 2.0

Relocation builds, Revision A, translations and regional profiles, and
exhaustive editors for secondary graphics/text tables are outside the 1.0
definition of done.
