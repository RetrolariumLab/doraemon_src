# Source Reconstruction 1.0

The project has completed the technical reconstruction scope comparable to
`smb1_src` and `pacman_src`, including the metadata and curated history required
by revision 3 of the shared release contract. Exact ROM identity remains a
permanent constraint; semantic source, runtime evidence, and editable data are
added without replacing or weakening the preservation build.

Version 1.0 targets exactly one image: the original Japanese PRG0 revision with
payload CRC32 `BDE3AE9B`, PRG CRC32 `B00ABE1C`, and CHR CRC32 `761F994E`.
Revision A, translations, regional variants, and multi-revision source profiles
are outside the 1.0 definition of done. They may be considered only after the
base reconstruction is complete.

The immutable starting point is commit
`499d4f8cdfa505456127d629fee58f185e79ce93`, retained as an ancestor of the
promoted `main` release history. The machine-readable release contract is
`config/source_reconstruction.json`; `config/authoring_coverage.json` proves
the five primary format families across all three chapters, while
`config/runtime_state_coverage.json` proves the shared and chapter-local RAM
and object-system completion metrics. `config/source_classification.json`
assigns every PRG source byte to instructions, typed data, encoded code,
padding, or a registered unknown. `make source-audit` rejects milestone claims
that are out of order, lack evidence, or detach the release history from the
preservation baseline.

## Definition of done

Source Reconstruction 1.0 is tag-ready only when all of these conditions hold:

- the original PRG0 ROM still builds byte-for-byte from tracked ca65 source and
  a private CHR input;
- boot/title, each gameplay mode, transitions, and ending have reproducible
  runtime evidence tied to symbols and static call paths;
- physical bank listings have been split into address-ordered semantic modules,
  normally 200-500 lines and never more than 700 lines;
- all major routines, indirect-dispatch targets, and key RAM state are named
  from evidence rather than guessed from bank ownership;
- primary maps/metatiles, gameplay objects/collisions, chapter
  metasprites/palettes, title/HUD/dialogue, and audio command streams have
  documented lossless decode/encode formats with round-trip tests;
- secondary fixed tables are typed source or explicit registered unknowns; a
  visual editor for every graphics or text byte is not required;
- linker-derived debugger symbols and fresh runtime captures cover every bank,
  NMI, all three worlds, transitions, and the ending;
- one `source-1-audit` target performs the clean release gate;
- `make source-check` passes on a clean tree and the manifest is changed to
  `tag-ready` in the committed release candidate before the pre-tag gate.

An `.incbin` remains acceptable for the private CHR input. Executable PRG bytes
must stay represented as source. A bank boundary is a hardware layout fact, not
by itself a semantic module boundary.

## Evidence policy

A milestone may be marked `complete` only when its evidence files are tracked
and its focused checks pass. Independent workstreams use `partial`; their order
does not imply that later formats are untouched. Unknown behavior stays listed
in `docs/unknowns.md`; a plausible name is not evidence.

Runtime captures will use the original PRG0 image, deterministic inputs, frame
or event boundaries, bank-qualified program counters, and relevant RAM/mapper
observations. Static and runtime evidence should agree before a subsystem is
treated as reconstructed.

## Release gates

```bash
make source-audit          # validate the active development contract
make validate-authoring-coverage # validate all primary format families
make validate-runtime-state-coverage # validate RAM/object completion metrics
make validate-source-classification # classify every canonical PRG source byte
make source-release-audit  # additionally require tag-ready status
make source-check          # full project gate plus reconstruction audit
make source-1-audit         # clean tag-ready gate with fresh runtime captures
make source-1-post-tag-audit # validate the annotated local release tag
make source-1-post-tag-remote-audit # validate the published tag target
```

The normal `make verify` and `make check` targets remain available throughout
the work. `source-1-audit` first rejects a non-ready manifest, then runs the
complete static/source gate, regenerates and validates all eight runtime
scenarios, and finally requires both the tag-ready contract and a clean Git
worktree. It is therefore run from the committed release candidate, not during
an ordinary development edit. Incremental commits should finish one coherent
evidence or source change and leave all checks relevant to that change passing.

Relocation builds, Revision A, translations/region profiles, and exhaustive
editors for secondary graphics/text tables are explicitly deferred to Source
Reconstruction 2.0.

The tracked manifest is `tag-ready`: all technical requirements are satisfied,
and the owner-approved rewrite condenses the 141 draft changes after the
preservation base into 61 coherent, attributed commits. The unpublished legacy
tag is retained under `source-reconstruction-1.0-pre-contract3`; the canonical
release tag is created only after `make source-1-audit` succeeds from the clean,
committed release candidate.
