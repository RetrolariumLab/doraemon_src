# Editing in Retrolarium

Doraemon is edited in Retrolarium Studio, not by tools in this repository. Open
`doraemon.rlj` at the repository root in the studio. It asks which revision to
edit, takes that revision's ROM (copied next to `doraemon.rlj` and never
committed) and keeps the edits in `hack/<revision>/`. Builds go to
`.retrolarium/`. Neither folder is tracked; delete `hack/<revision>/` to start
over from the original.

## Revisions

| Revision   | ROM                            |
| ---------- | ------------------------------ |
| `original` | `Doraemon (J) (PRG0) [!].nes`  |
| `rev_a`    | `Doraemon (Japan) (Rev A).nes` |

## What is edited

The kit's Doraemon profile defines every view; this repository only names the
revisions and the asset split. The studio offers:

- the three worlds' levels: World 1's city and underground, World 2's screens,
  routes and metatiles, World 3's rooms, with their objects;
- each world's object tables (underground rooms, city returns, weapon sounds and
  shots, enemy states, room flags, creature steps and groups) and World 3's
  behavior streams;
- the four CHR banks, metasprites and palettes;
- the title, ending and shell text;
- the music, the sound effects, each driver's effect routing and every stream
  byte;
- the attract demos.

Capacities stay those of the original layout: each table keeps its place and
size, and the studio refuses an edit that would not fit.

## Checking the repository

`make studio-check` runs `rltool studio check doraemon.rlj`. In a throwaway copy
of the repository it prepares both revisions, decodes and validates each
document and rebuilds each revision with no edits, requiring the original ROM
byte for byte. It needs the revisions' ROMs and the Retrolarium kit (`rltool` on
`PATH`, or `RLTOOL=...`), and never reads or writes `hack/` or `.retrolarium/`.

## Source Reconstruction 3.0

`config/source_reconstruction_3_0.json` is the 3.0 release manifest. It names
the descriptor, the profile and the revisions, the kit and studio versions the
release is checked with, and every removed editor with the view that replaced
it. `make source-3-audit` runs studio-check with `--release`, which also checks
that section against the descriptor and the running kit; `make source-3-check`
runs the Source 2.0 gate first. The manifest stays in `development` with the kit unpinned
until Retrolarium publishes its first tags.
