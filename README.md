# Doraemon NES Disassembly

A preservation-first, matching ca65 disassembly of Hudson Soft's 1986 Famicom
game **Doraemon** (ドラえもん, catalog `HFC-DO`). The project targets the
original Japanese revision and reconstructs a byte-identical iNES image from
tracked PRG assembly plus one private CHR input.

## Current status

Active development on `source-reconstruction` targets the audited
[Source Reconstruction 1.0](docs/source_reconstruction.md) contract. The
matching preservation state remains fixed on `main`; semantic reconstruction,
runtime evidence, editable primary formats, and debugger integration are added
incrementally without weakening byte identity. Relocation builds are deferred
to Source Reconstruction 2.0.

- The exact local reference is identified by complete file, header, PRG, CHR,
  and payload hashes.
- All four switchable 32 KiB PRG banks are represented by address-ordered ca65
  source; no PRG `.incbin` remains.
- A deterministic Ghidra/GhidraNes pipeline analyzes each bank through a
  temporary fixed-bank image, avoiding ambiguous overlay entry points.
- Every direct PRG branch, jump, and call emitted as code uses a bank-qualified
  label.
- Reset, NMI, the bus-conflict-safe mapper write, interrupt vectors, embedded
  build text, and the known world data have initial semantic names.
- Shared frame, input, demo mode, player lives/health, rendering, score, and audio RAM
  operands use an evidence-backed, bank-aware symbol registry; unresolved
  chapter overlays remain numeric.
- Deterministic FCEUX traces prove the reset-to-title PRG 0 to PRG 3 switch,
  post-write mapping, title NMI path, bus-conflict values, controller shortcut,
  entry into all three gameplay PRG banks, and the World 1 city-to-underground
  mode transition without a mapper change. Controlled RAM-state scenarios also
  prove the stopped World 2 `$7F` terminal sentinel, the World 2-to-World 3
  transition, and the complete ending/credits path.
- World 2's 229-byte stage stream, 119 compressed screens, 208 metatiles, and
  208-bit collision bitmap are losslessly editable; the original ROM marks 100
  metatiles solid.
- World 3's complete 32-type catalog joins properties, dispatch roles,
  metasprites, region-specific enemy forms, bosses, drops, chests, puzzle
  items, and companions with independently sourced Japanese identities.
- The original mapper routine at `$81BB` indexes a ROM table at `$8261` and
  writes back to that same ROM address. The table bytes safely expose mapper 66
  values despite discrete-board bus conflicts.
- CadEditor's city, underground, cave, and underwater regions are independently
  checked by offset, size, dimensions, and CRC32.
- `make verify` proves the assembled 163,856-byte image is byte-identical to the
  reference.

The current static listing contains 6,340 Ghidra instructions in bank 0, 5,055
in bank 1, 7,001 in bank 2, and 2,332 in bank 3. Identical common code through
`$8270` is conservatively propagated between banks when the bytes match.
Unclassified bytes remain explicit `.byte` data rather than speculative code.

## Reference image

```text
Doraemon (Japan, original revision)
Catalog ID      HFC-DO
Release         1986-12-12
File size       163,856 bytes (16-byte iNES header)
File CRC32      A9EB0DE9
Payload CRC32   BDE3AE9B (headerless PRG + CHR)
Mapper          66 / HVC-GNROM, vertical mirroring
PRG             128 KiB, CRC32 B00ABE1C
CHR             32 KiB, CRC32 761F994E
```

Revision A has PRG CRC32 `FE90D6EB` and payload CRC32 `336093EF`; its CHR is
unchanged. Source Reconstruction 1.0 intentionally targets only the original
PRG0 image above: Revision A, translations, regional profiles, and expanded
mapper hacks are not release requirements.

ROM images and locally extracted regions are ignored by Git.

## Bootstrap

Place a legally obtained matching ROM in the project root, then run:

```bash
make inspect REFERENCE_ROM="Doraemon (J) (PRG0) [!].nes"
make split REFERENCE_ROM="Doraemon (J) (PRG0) [!].nes"
make disassemble REFERENCE_ROM="Doraemon (J) (PRG0) [!].nes"
make check REFERENCE_ROM="Doraemon (J) (PRG0) [!].nes"
```

`make inspect` is safe for identifying another dump. `make split` refuses any
image that does not match the manifest.

## Useful targets

```bash
make scaffold-check     # formatting, source policy, and unit tests
make ghidra-bootstrap   # install the hash-pinned static-analysis toolchain
make ghidra-inspect     # inspect native GNROM overlay mapping
make disassemble        # analyze all four banks and regenerate canonical ASM
make disassembly-check  # require tracked ASM to match a fresh analysis
make split              # validate and extract private PRG/CHR regions
make build              # assemble the complete iNES image
make verify             # compare every image region byte-for-byte
make bank-info          # print per-bank CRC32 values and vectors
make bank-gateways      # report the validated cross-bank gateway graph
make object-pools       # validate chapter pool capacities, fields, and lifecycle API
make object-dispatch    # validate indirect object-handler tables and code seeds
make object-placements  # validate and round-trip World 1 object data
make world2-enemy-states # validate World 2 token/state/property domains
make world1-underground-rooms # validate and round-trip underground room profiles
make world2-enemy-handlers # validate all World 2 enemy handler edges and roles
make world2-stage-sequence # validate and round-trip World 2 stage bytecode
make world2-metatiles   # validate and round-trip exact World 2 metatiles
make world2-palettes    # validate and round-trip World 2 palette sets
make world2-metasprites # validate and round-trip World 2 fixed metasprites
make world3-object-catalog # validate and round-trip World 3 object/type data
make world3-entity-types # validate all World 3 type properties and identities
make maps               # describe all CadEditor-backed regions as JSON
make validate-maps      # validate map/table sizes and CRCs
make quality-check      # formatting, lint, and unit tests
make reconstruction-inventory # measure semantic naming and typed-data progress
make validate-common-runtime # validate duplicated reset/NMI/mapper services
make validate-core-dispatch-roles # validate non-audio indirect target roles
make validate-audio-effects # validate request roles, channel leases, and handlers
make validate-audio-music # validate music commands, channel RAM, and helpers
make validate-audio-arbitration # validate effect/music ownership of APU channels
make validate-audio-streams # round-trip all header-reachable music streams
make validate-shell-text # round-trip title/help/ending text and presentation data
make validate-shell-runtime # validate Bank 3 shell routines, callers, and RAM
make validate-world1-core-routines # validate World 1 frame/render core naming
make validate-world1-frame-mechanics # validate World 1 motion/collision frame services
make validate-world1-entity-helpers # validate World 1 movement/aiming helper naming
make validate-world1-final-routines # validate final Bank 0 routine/RAM naming
make validate-world2-frame-core # validate World 2 frame/stage core naming
make validate-world2-player-systems # validate World 2 player/inventory/fire naming
make validate-world2-screen-core # validate World 2 NMI/screen/PPU core naming
make validate-world2-projectile-runtime # validate World 2 projectile/attack runtime
make validate-world2-sprite-runtime # validate World 2 player/inventory/OAM renderer
make validate-world2-final-routines # validate final Bank 1 routine/RAM naming
make validate-debug-symbols # verify ld65 symbols and generated FCEUX name lists
make source-audit       # validate reconstruction milestones and evidence
make runtime-architecture # capture and validate reset/NMI/mapper evidence
make source-check       # complete project and reconstruction development gate
make check              # current byte-identity and subsystem verification gate
make clean              # remove build artifacts only
```

## Repository structure

```text
assets/manifest.json        exact reference and extraction contract
bin/                        local ca65/ld65 toolchain and license
config/linker/gnrom.cfg     header, four PRG windows, and CHR layout
config/prg_data_ranges.txt  bank-qualified evidence-backed data ranges
config/prg_code_entries.txt bank-qualified evidence-backed code seeds
config/object_pools.json machine-checked chapter entity storage contract
config/object_dispatch.json indirect chapter object-handler tables
config/object_placements.json World 1 placement and descriptor contract
config/world2_enemy_states.json World 2 enemy token/state property contract
config/world2_enemy_handlers.json World 2 state handler graph and roles
config/world2_enemy_identities.json evidence-backed World 2 enemy roster
config/world2_stage_sequence.json World 2 stage bytecode contract
config/world2_metatiles.json exact World 2 metatile/render/collision contract
config/world2_palettes.json World 2 palette lookup and upload contract
config/world2_metasprites.json World 2 fixed metasprite and CHR contract
config/world3_ppu_queue.json World 3 PPU ring, RAM, and code contract
config/world3_metasprites.json World 3 metasprite and palette contract
data/world1/object_data.json lossless editable World 1 object representation
data/world2/enemy_states.json lossless editable World 2 state properties
data/world2/stage_sequence.json lossless editable World 2 stage sequence
data/world2/metatiles.json lossless editable World 2 metatile catalog
data/world2/palettes.json lossless editable World 2 palette catalog
data/world2/metasprites.json lossless editable World 2 metasprite catalog
data/world3/object_catalog.json lossless editable World 3 object/type catalog
data/world3/metasprites.json lossless editable World 3 sprite/palette catalog
config/symbols.json         bank-qualified semantic symbol registry
config/debug_symbols.json   linker/debugger export contract and pinned inventory
config/debugger_*.json      checked bank-qualified breakpoints and RAM watches
config/shell_runtime.json   Bank 3 title/transition/ending routine contract
config/world1_core_routines.json World 1 initialization/frame/render contract
config/world1_frame_mechanics.json World 1 motion/collision frame contract
config/world1_entity_helpers.json World 1 movement/aiming helper contract
config/world1_final_routines.json final World 1 routine and RAM contract
config/world2_frame_core.json World 2 frame/stage routine and RAM contract
config/world2_player_systems.json World 2 player/inventory/fire contract
config/world2_screen_core.json World 2 NMI/screen/PPU routine contract
docs/                       architecture, formats, evidence, and roadmap
docs/ram_fields.md          proved shared RAM layout and ownership notes
docs/world3_dormant_code.md statically recovered but unreferenced code islands
docs/world3_ppu_queue.md    World 3 NMI queue record and synchronization model
docs/world2_enemy_handlers.md World 2 enemy handler graph and behavior roles
docs/world2_enemy_identities.md World 2 canonical enemy/state identities
docs/world2_metasprites.md  World 2 fixed sprite format and shared storage
scripts/project.py          identity, split, bank report, and source policy
scripts/run_ghidra.py       deterministic per-bank headless analysis
scripts/generate_disassembly.py  Ghidra facts to canonical ca65 source
scripts/map_data.py         CadEditor region validator
scripts/debug_symbols.py    ld65 debugger validator and FCEUX name-list exporter
scripts/shell_runtime.py    shared bank-local routine validation library
scripts/routine_contract.py shared bank-local routine/caller/RAM validator CLI
scripts/world2_enemy_handlers.py World 2 enemy handler graph validator
scripts/world2_enemy_identities.py World 2 enemy identity and boss validator
scripts/world2_metasprites.py World 2 sprite validator/editor/renderer
scripts/world3_ppu_queue.py World 3 PPU queue and symbol validator
scripts/verify_rom.py       focused byte-difference diagnostics
src/banks/bank_0.asm        generated bank 0 semantic include map
src/banks/bank_1.asm        generated bank 1 semantic include map
src/banks/bank_2.asm        generated bank 2 semantic include map
src/banks/bank_3.asm        generated bank 3 semantic include map
src/common/                 bank-local boot, gateways, and vectors
src/world1/                 city, underground, rendering, map, and audio modules
src/world2/                 cave shooter runtime, screens, and audio modules
src/world3/                 underwater runtime, map, objects, and audio modules
src/shell/                  title, ending, game-over, and transition code
src/rendering/              shell PPU and text services
src/audio/                  effect driver, music engine, and stream data
src/data/                   title/help/ending screens, credits, and typed bank 3 data
src/graphics/chr.asm        private 32 KiB CHR include
tests/                      tooling and data-contract tests
```

Bank roles describe current evidence, not a claim that each bank contains only
one engine. Common interrupt and mapper code is duplicated in every bank, and
music, transition, or presentation data may share chapter banks.

## Research sources and rights

CadEditor provides the published map/table offsets and dimensions used as the
first data boundary evidence. The mapper model follows the NESdev mapper 66 and
discrete-logic bus-conflict documentation. Exact local hashes and every claim
derived directly from the ROM are recorded separately in `docs/provenance.md`.

Original game code, graphics, music, text, and data remain property of their
respective rights holders. This repository does not distribute a ROM or
extracted copyrighted assets.
