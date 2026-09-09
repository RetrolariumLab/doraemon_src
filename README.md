# Doraemon NES source reconstruction

A byte-identical ca65 reconstruction and content-authoring workspace for
Hudson Soft's 1986 Famicom game **Doraemon** (`HFC-DO`). The repository
rebuilds both known Japanese revisions from shared source, keeps private
ROM-derived assets outside version control, and validates the result with
static analysis, format contracts, debugger data, and emulator traces.

## Status

Source Reconstruction 1.0 is the preservation baseline for the original
revision. Source Reconstruction 2.0 adds:

- byte-identical `original` and `rev_a` build profiles;
- address-ordered ca65 source for all four switchable 32 KiB PRG banks;
- deterministic Ghidra/GhidraNes regeneration and bank-aware symbols;
- fixed-capacity level, graphics, object, text, and sound authoring;
- five visual Studios backed by the same validated headless codecs;
- profile-aware round trips, runtime scenarios, and release contracts.

The cartridge uses GNROM mapper 66 with 128 KiB of PRG and 32 KiB of CHR.
The two profiles share their header and CHR; 50 classified PRG bytes differ in
bank 2. These differences are represented explicitly without assigning an
unproven behavioral explanation.

## Quick start

The supported release host is Windows x64 with PowerShell. Python 3 and GNU
Make are required; the pinned ca65/ld65 toolchain is included. Ghidra,
GhidraNes, and the automation emulator are installed or verified through Make
targets described in the [verification guide](docs/verification.md).

Place legally obtained reference ROMs in the repository root using the
default names from the Makefile, then prepare the original profile:

```bash
make inspect
make split
make verify
```

Build and verify both supported profiles:

```bash
make verify-revisions
```

Use `PROFILE=original` or `PROFILE=rev_a` to select one revision. Expected
hashes and source windows are documented in [Revision profiles](docs/revisions.md)
and declared in `assets/manifest.json` and `config/revision_profiles.json`.
Generated ROMs, extracted private assets, editor workspaces, runtime captures,
and build products are ignored by Git.

## Content editors

After splitting the original reference, open any Studio with the selected
profile:

```bash
make level-studio PROFILE=original
make graphics-studio PROFILE=original
make object-studio PROFILE=original
make text-studio PROFILE=original
make sound-studio PROFILE=original
```

The Studios cover all three world formats, all four CHR banks, typed object
data, fixed-layout presentation text, and the reachable music and effect
streams. They write an ignored workspace and delegate serialization to
validated codecs. Common non-GUI operations are:

```bash
make content-init PROFILE=original
make content-check PROFILE=original
make content-roundtrip
make content-rom PROFILE=original
```

See [Level Studio](docs/level_studio.md), [Graphics Studio](docs/graphics_studio.md),
[Object Studio](docs/object_studio.md), [Text Studio](docs/text_studio.md), and
[Sound Studio](docs/sound_studio.md) for formats, capacity limits, and controls.

## Verification and release gates

```bash
make help            # show the curated public command catalog
make format          # normalize authored source, configuration, and docs
make lint            # validate style, layout, links, manifests, and policy
make scaffold-check  # run the ROM-less repository gate
make quality-check   # run lint and the complete Python test suite
make check           # rebuild and validate the original reconstruction
make source-2-audit  # reconcile the Source 2.0 manifest and evidence
make source-2-check  # run the complete two-profile release gate
```

`make disassembly-check` regenerates the four-bank analysis facts and ca65
source before comparison. `make source-2-tag-check` repeats the complete gate
and validates the annotated release tag. The exact gate composition and
private-input requirements are documented in
[Verification](docs/verification.md) and the
[Source Reconstruction 2.0 boundary](docs/source_reconstruction_2_0.md).

## Repository map

```text
assets/                 reference manifest and ignored extracted assets
config/authoring/       editor schemas, capacities, and profile contracts
config/debugger/        bank-qualified breakpoints, watches, and inventories
config/reconstruction/  symbols, ranges, source layout, and evidence
content/workspace/      ignored editable content documents
docs/                   architecture, formats, workflows, and release policy
mk/                     authoring, runtime, workflow, and validation rules
scripts/authoring/      headless codecs and visual Studios
scripts/build/          identity, profiles, assembly, and comparison tools
scripts/runtime/        emulator capture and runtime validation
scripts/validation/     repository, release, and subsystem contracts
scripts/workflow/       deterministic disassembly workflow
src/                    bank- and subsystem-oriented ca65 source
tests/                  tests mirroring the script package layout
```

Start with the [documentation index](docs/index.md). The key technical guides
are [Architecture](docs/architecture.md), [Source layout](docs/source_layout.md),
[Data formats](docs/data_formats.md), [Runtime evidence](docs/runtime_evidence.md),
and [Provenance](docs/provenance.md). The [Roadmap](docs/roadmap.md) separates
released work from deferred reconstruction and expansion goals.

## Research and rights

Published CadEditor map and table information and public NES mapper references
provide external boundary evidence; exact attribution and ROM-derived claims
are recorded in [Provenance](docs/provenance.md). External tools and references
are not copied into this repository unless their licenses permit it.

Original game code, graphics, music, text, and data remain property of their
respective rights holders. This repository does not distribute ROM images or
extracted copyrighted assets. Users must supply their own lawful references.
