# Source Reconstruction 2.0

Source Reconstruction 2.0 keeps the tagged 1.0 preservation source intact and
turns its typed data into a safe, profile-aware editing environment. The
accepted cartridge family contains exactly two official Japanese revisions:
the original release and Revision A. Both retain the original 128 KiB PRG,
32 KiB CHR, Mapper 66 layout, and fixed ROM capacities.

The technical reconstruction, editor scope, and clean-build gate are complete.
The active candidate is `tag-ready`. Its machine-readable boundary is
`config/source_reconstruction_2_0.json`; the studio registry and profile matrix
are `config/authoring/content_studios.json` and
`config/authoring/content_authoring_profiles.json`.

## Repository workflow

Completed repository-facing work:

- the 1.0 and 2.0 manifests expose only project release identity, scope,
  profiles, evidence, and gates;
- the release audit rejects non-English public text while retaining explicitly
  identified Japanese names as primary-source provenance beside English
  descriptions or transliterations;
- the 1,269-line root Makefile has been reduced to a focused interface backed
  by responsibility-oriented `mk/` fragments, while `make help` presents the
  stable workflows and selectors as a categorized public command guide;
- all Python tools are grouped by responsibility and exposed through the
  package-aware `scripts/run.py` launcher; repository lint rejects a return to
  root-level executable scripts;
- unit tests mirror the tool responsibilities under `tests/`, and repository
  lint enforces that mapping;
- `make public-command-smoke` runs the real public lint workflow inside a
  disposable tracked-only clone and rejects any worktree mutation;
- unit tests, authoring/runtime coverage audits, and byte-identical builds of
  both official revisions pass through the modular interface.

The unpublished draft stack has been rebuilt as 45 nonempty, owner-oriented
commits on a separate rewrite branch. The exact dates, primary attribution,
superseded marker commits, and tree-equivalence checkpoint are retained in the
[draft-history rewrite map](source_2_history_rewrite.md). Local `main`, old
draft refs, tags, and remote-tracking refs remain unchanged for owner review.

## Completed foundation

- Both official revisions build byte-identically from a shared source tree.
- All 50 changed PRG bytes are confined to two visible Revision A code paths in
  Bank 2. Header and CHR are identical, so there are no revision-specific
  binary data assets to split.
- Level Studio edits the complete World 1 and World 3 hierarchical maps and
  lays all 119 World 2 compressed screen selectors onto five labelled,
  scrollable route views using the native CHR and per-panel palettes. The
  horizontal and vertical stream orientations match the runtime; Part 2's two
  disconnected routes are explicit Part 2A and Part 2B maps with entrance and
  exit markers on the main path.
- Every World 3 room is rendered with its current selector and can be assigned
  another of the 11 native palette presets without changing room geometry.
- The World 2 encoder preserves exact aliases, separates editable RLE cells,
  rejects enemy tokens and padding as map cells, and enforces the original
  16,431-byte stream capacity.
- Canonical level exports compose back into both source-built ROM profiles with
  zero changed bytes.
- Graphics Studio edits all 2,048 CHR tiles in a four-bank visual atlas and
  pixel editor backed by an atomic ignored workspace. Canonical CHR composes
  back into either revision with zero changed bytes.
- Six additional graphics documents cover 5,577 fixed PRG bytes of palettes,
  World 2 metatiles, and chapter metasprites. Their address sets are checked for
  overlap before they are composed with CHR.
- Visual palette and World 2 metatile tabs edit their typed PRG records while
  rendering directly from the current unsaved CHR and palette workspace.
- World 1 and World 3 maps and hierarchical metatiles have one shared document
  between Level and Graphics Studio. Their independent undo histories change
  only map cells or hierarchy records, and one composer applies the whole
  fixed-size payload without last-writer conflicts.
- The hierarchy tab renders and edits all 512 small blocks and 512 big blocks
  across World 1 and World 3 using the current CHR and palette workspaces.
- Graphics Studio is now a supported editor: its metasprite workbench covers
  every World 1/3 variable record and pointer/alias entry, every World 2 fixed
  2x2 record, and the complete World 2 OAM attribute lookup.
- Object Studio's headless foundation combines ten typed documents covering
  3,130 disjoint PRG bytes with World 2's shared 16,669-byte map/spawn stream.
  Its typed browser edits every document through the native encoders, while a
  dedicated screen grid edits all 738 selector-view spawns and propagates
  aliases through the shared Level Studio repacker. The Studio is supported
  for both revisions.
- Level Studio overlays every World 1 placement, World 2 spawn, and World 3
  persistent object on its map using native CHR, initial metasprites, render
  flags, and sprite palettes. Coordinate-bearing records support constrained
  drag-and-drop and native type changes; room schedules without ROM coordinates
  remain explicit, type-editable sprite previews rather than invented runtime
  positions. Shoot-to-reveal World 1 placements and World 2's coordinate-free
  secret opportunities are visibly translucent.
- Text Studio covers 16,581 fixed presentation bytes and 412 textual fields.
  It preserves exact title/help/credits geometry, exposes raw nametable rows,
  and previews each string through the native CHR bank 3 glyph mapping.
- Sound Studio exposes all 26 tracks and 10,224 header/reachable-stream bytes,
  including 202 editable envelope commands. Its second workbench safely swaps
  the 93 proven effect-request slots without altering dispatch-table geometry.
  Canonical sound exports compose into both revisions with zero changed bytes.
  Its embedded piano roll and NES APU synthesizer play all four channels from
  the current unsaved document without an emulator. Independently, the release
  gate reaches and injects one native request in each of the four cartridge
  audio banks for both authoring profiles.
- The common content composer merges any subset of Level, Graphics, Object,
  Text, and Sound workspaces against one source-built image. It accepts equal
  shared writes, rejects divergent overlap, and round-trips all five Studios
  together with zero changes for both revisions.
- Eight runtime scenarios now run directly on each source-built profile.
  Original completes the existing three-world and ending contracts; Revision A
  has separate assertions for its reproducible reset after entering the changed
  World 3 helper, while its title, World 1, World 2, and transition paths pass.

## Release gate

The complete development gate passed from an empty `build/` directory on the
supported Windows host. It ran 595 unit and contract tests, rebuilt both
163,856-byte cartridge profiles byte-identically, completed the six authoring
round-trip families for each profile, exercised all five headless Studios,
reached each of the four native audio banks for both profiles, and captured and
validated all eight runtime scenarios directly on both revisions.

```console
make source-2-audit
make source-2-check
make source-2-pre-tag-check
make source-2-tag-check
```

`source-2-audit` checks the project manifest, predecessor tag,
two profile identities, runtime coverage, Studio registry, required commands
and documents, licensing, private-path policy, and commit history.
`source-2-check` is the complete gate and begins with the full 1.0 gate.
`source-2-pre-tag-check` additionally requires tag-ready metadata, a clean tree,
and an unused local and remote tag name. After the user creates the annotated
tag directly on the substantive release candidate, `source-2-tag-check`
validates the same full gate and the tagged `HEAD`.

## Explicit 3.0 boundary

Cross-bank common-code includes, deeper unknown recovery, exhaustive local
label polishing, and expanded or relocated ROM layouts are not 2.0 acceptance
criteria. They remain visible future work, but cannot delay the fixed-capacity
authoring release.

ROMs, extracted CHR, workspaces, exports, traces, and edited images remain
ignored local artifacts. No editor writes into a reference ROM directly.
