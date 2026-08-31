# Source Reconstruction 1.0

The project is moving from a matching preservation disassembly to a source
reconstruction comparable in scope to `smb1_src` and `pacman_src`. Exact ROM
identity remains a permanent constraint; semantic source, runtime evidence, and
editable data are added without replacing or weakening the preservation build.

The immutable starting point is commit
`499d4f8cdfa505456127d629fee58f185e79ce93` on `main`. Development takes place
on `source-reconstruction`. The machine-readable contract is
`config/source_reconstruction.json`, and `make source-audit` rejects milestone
claims that are out of order, lack evidence, or move the preservation baseline.

## Definition of done

Source Reconstruction 1.0 is tag-ready only when all of these conditions hold:

- the original PRG0 ROM still builds byte-for-byte from tracked ca65 source and
  a private CHR input;
- boot/title, each gameplay mode, transitions, and ending have reproducible
  runtime evidence tied to symbols and static call paths;
- physical bank listings have been split into address-ordered semantic modules,
  normally 200-500 lines and never more than 700 lines;
- routines, RAM state, object systems, collision, rendering, sound, and text are
  named from evidence rather than guessed from bank ownership;
- maps, metatiles, objects, collisions, graphics, palettes, text, and audio have
  documented lossless decode/encode formats with round-trip tests;
- a relocation build proves that reconstructed code and references are genuine
  source relationships rather than position-dependent transcription;
- `make source-check` passes on a clean tree and the manifest status is changed
  to `tag-ready` only in the release commit.

An `.incbin` remains acceptable for the private CHR input. Executable PRG bytes
must stay represented as source. A bank boundary is a hardware layout fact, not
by itself a semantic module boundary.

## Evidence policy

A milestone may be marked `complete` only when its evidence files are tracked
and its focused checks pass. Development manifests must contain one active
milestone, preceded only by completed milestones and followed only by planned
ones. Unknown behavior stays listed in `docs/unknowns.md`; a plausible name is
not evidence.

Runtime captures will use the original PRG0 image, deterministic inputs, frame
or event boundaries, bank-qualified program counters, and relevant RAM/mapper
observations. Static and runtime evidence should agree before a subsystem is
treated as reconstructed.

## Release gates

```bash
make source-audit          # validate the active development contract
make source-release-audit  # additionally require tag-ready status
make source-check          # full project gate plus reconstruction audit
```

The normal `make verify` and `make check` targets remain available throughout
the work. Incremental commits should finish one coherent evidence or source
change and leave all checks relevant to that change passing.
