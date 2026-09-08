# Project Release Lifecycle

`config/source_reconstruction.json` is the machine-readable owner of the Source
Reconstruction 1.0 release identity, scope, requirements, profiles, runtime
coverage, toolchain, artifacts, licensing, deviations, and gates. The Source
Reconstruction 2.0 boundary is owned independently by
`config/source_reconstruction_2_0.json` and names its 1.0 predecessor exactly.

## Accepted boundary

The sole accepted profile is the original Japanese PRG0 image. Its complete
163,856-byte iNES container, 128 KiB PRG, 32 KiB CHR, and significant regions
are hash-pinned and compared byte by byte. Runtime coverage is direct: eight
deterministic scenarios exercise power-on, title, all three worlds, the World 2
terminal condition, a chapter transition, and the ending. Revision A,
translations, expanded images, relocation, and exhaustive secondary editors
remain outside this release.

The build depends on user-supplied ROM/CHR bytes and does not publish an image.
The executable PRG is reconstructed as ca65 source; the private CHR remains an
explicit ignored data input. Tool and documentation licensing does not grant a
license to Hudson Soft game content.

## Current conformance state

The source, identity, documentation, runtime, and aggregate technical gates are
satisfied. The accepted Source 1.0 history contains 61 coherent commits after
the immutable preservation base. Every reconstructed commit has an English
title, two substantive body paragraphs, the project author identity, and the
required Codex trailer. Requirement `source-1.commit-history` is therefore
`satisfied`, and the published annotated tag identifies the accepted release.

Source Reconstruction 2.0 is developed as a separate sequence after that
published predecessor. Its manifest remains `development` until every new
requirement, clean-room gate, and history check is complete.

## Gate lifecycle

- `make source-check` validates the development source and manifest.
- `make source-1-audit` is the pre-tag aggregate gate and requires a clean,
  `tag-ready` manifest plus an absent future tag.
- `make source-1-post-tag-audit` validates an annotated tag from the tagged
  tree after the manifest enters the `tagged` state.
- `make source-1-post-tag-remote-audit` additionally proves that a published
  tag peels to the same commit. It is conditional until the tag is published.

Additional official profiles and artifact publication have explicit false
condition decisions. Their requirements are `not_applicable`, linked to the
corresponding excluded scope, rather than silently omitted.

## Source Reconstruction 2.0 inheritance

`config/source_reconstruction_2_0.json` inherits the tagged 1.0 commit and adds
the official Revision A profile plus five fixed-capacity content Studios. Its
development audit is `make source-2-audit`; the aggregate candidate gate is
`make source-2-check`. The latter reruns the complete 1.0 contract before the
two-profile identity, authoring, isolated Studio smoke, and direct runtime
matrix checks. `make source-2-pre-tag-check` adds clean-tree, tag-ready, and
unused-tag checks; `make source-2-tag-check` validates the annotated tag on the
same substantive `HEAD`.

Earlier local candidate tags are not presented as canonical releases. Published
tags are immutable; a canonical annotated tag is created only after explicit
owner approval and a repeated full gate.
