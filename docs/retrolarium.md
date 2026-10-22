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

## Studio and source

The studio builds a revision from its original ROM and the documents in
`hack/<revision>/`; it does not assemble `src/`. `make build` assembles `src/`
and never reads `hack/`. So an edit to the source shows in `make build`, not in
the studio, and a studio edit stays in the studio's documents until someone
writes it into the source by hand. Use the studio for content (levels,
graphics, text, music) and the source for code.

## The game's names and tables

Retrolarium keeps nothing taken from the game; this repository gives it what it
needs. `config/names.json` holds the game's own names (the enemies, objects,
World 3 types, sound effects and music titles) in English, and the lists that
carry them (the item and World 2 animations, World 2's enemy states and its
sound order). The studio and the kit read it when a project opens and show the
names as they are, untranslated; without it they show numbers instead. Its
`guard` list names what Retrolarium's own repositories must never contain.

`config/game_profile.json` is the game's Retrolarium profile: its revisions with
their hashes and, for each resource, where it lies in each revision's image and
which codec reads it. The kit reads it when it opens `doraemon.rlj` or a project
made from it; Retrolarium keeps no copy.

`config/profile_tables.json` names, by label, the tables the kit reads from the
image built from this source. `rltool profile tables` prints their offsets in
each revision's build, the values of `config/game_profile.json`; `make
profile-check` (part of `make test`) compares the two, so a source change that
moves such a table fails until the profile is updated. The profile's other
offsets are not derived from labels yet.

## Checking the repository

`make studio-check` runs `rltool studio check doraemon.rlj --present`. In a
throwaway copy of the repository it prepares every revision whose ROM is here, decodes and validates each
document and rebuilds each revision with no edits, requiring the original ROM
byte for byte. It needs the revisions' ROMs and the Retrolarium kit (`rltool` on
`PATH`, or `RLTOOL=...`), and never reads or writes `hack/` or `.retrolarium/`.
