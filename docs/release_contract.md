# Release Contract Revision 3

The project adopts
`retrolarium.source_reconstruction_release_contract` revision 3 for the Source
Reconstruction 1.0 release line. `config/source_reconstruction.json` is the
machine-readable owner of release identity, scope, requirements, profiles,
runtime coverage, toolchain, artifacts, licensing, deviations, and gates.

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
satisfied. The owner approved an explicit old-to-new map, and the draft history
was rebuilt on `rewrite/source-1-contract3` as 61 coherent commits after the
immutable preservation base. Every reconstructed commit has an English title,
two substantive body paragraphs, the project author identity, and the required
Codex trailer. Requirement `source-1.commit-history` is therefore `satisfied`,
and the manifest is `tag-ready`.

The old tip remains available as
`archive/source-reconstruction-pre-squash`, and the unpublished legacy tag is
preserved as `source-reconstruction-1.0-pre-contract3`. The rewrite candidate
must still pass the complete pre-tag gate before the final release commit is
created; branch promotion and canonical tag creation remain separate,
owner-approved operations.

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

The legacy tag predates revision 3 and is not presented as a revision-3
release. Published tags are immutable; the canonical annotated tag is created
only after explicit owner approval and a repeated full gate.
