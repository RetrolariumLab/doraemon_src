# Doraemon NES Disassembly

A preservation-first, matching ca65 disassembly of Hudson Soft's 1986 Famicom
game **Doraemon** (ドラえもん, catalog `HFC-DO`). The project targets the
original Japanese revision and reconstructs a byte-identical iNES image from
tracked PRG assembly plus one private CHR input.

## Current status

Active development on `source-reconstruction` targets the audited
[Source Reconstruction 1.0](docs/source_reconstruction.md) contract. The
matching preservation state remains fixed on `main`; semantic reconstruction,
runtime evidence, editable formats, and relocation proof are added
incrementally without weakening byte identity.

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
- Deterministic FCEUX traces prove the reset-to-title PRG 0 to PRG 3 switch,
  post-write mapping, title NMI path, bus-conflict values, controller shortcut,
  entry into all three gameplay PRG banks, and the World 1 city-to-underground
  mode transition without a mapper change. Controlled RAM-state scenarios also
  prove the World 2-to-World 3 transition and the complete ending/credits path.
- The original mapper routine at `$81BB` indexes a ROM table at `$8261` and
  writes back to that same ROM address. The table bytes safely expose mapper 66
  values despite discrete-board bus conflicts.
- CadEditor's city, underground, cave, and underwater regions are independently
  checked by offset, size, dimensions, and CRC32.
- `make verify` proves the assembled 163,856-byte image is byte-identical to the
  reference.

The current static listing contains 6,340 Ghidra instructions in bank 0, 4,162
in bank 1, 5,391 in bank 2, and 2,332 in bank 3. Identical common code through
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
unchanged. The project does not treat translations or expanded mapper hacks as
baseline revisions.

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
make maps               # describe all CadEditor-backed regions as JSON
make validate-maps      # validate map/table sizes and CRCs
make quality-check      # formatting, lint, and unit tests
make source-audit       # validate reconstruction milestones and evidence
make runtime-architecture # capture and validate reset/NMI/mapper evidence
make source-check       # complete project and reconstruction development gate
make check              # complete release gate
make clean              # remove build artifacts only
```

## Repository structure

```text
assets/manifest.json        exact reference and extraction contract
bin/                        local ca65/ld65 toolchain and license
config/linker/gnrom.cfg     header, four PRG windows, and CHR layout
config/prg_data_ranges.txt  bank-qualified evidence-backed data ranges
config/prg_code_entries.txt bank-qualified evidence-backed code seeds
config/symbols.json         bank-qualified semantic symbol registry
config/debugger_*.json      initial Mesen watches and breakpoints
docs/                       architecture, formats, evidence, and roadmap
scripts/project.py          identity, split, bank report, and source policy
scripts/run_ghidra.py       deterministic per-bank headless analysis
scripts/generate_disassembly.py  Ghidra facts to canonical ca65 source
scripts/map_data.py         CadEditor region validator
scripts/verify_rom.py       focused byte-difference diagnostics
src/banks/bank_0.asm        generated bank 0 semantic include map
src/banks/bank_1.asm        generated bank 1 semantic include map
src/banks/bank_2.asm        world 3 / underwater bank
src/banks/bank_3.asm        generated bank 3 semantic include map
src/common/                 bank-local boot, gateways, and vectors
src/world1/                 city, underground, rendering, map, and audio modules
src/world2/                 cave shooter runtime, screens, and audio modules
src/shell/                  title, ending, game-over, and transition code
src/rendering/              shell PPU and text services
src/audio/                  effect driver, music engine, and stream data
src/data/                   ending credits and pending bank 3 data formats
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
