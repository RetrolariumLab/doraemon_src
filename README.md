# Doraemon NES source reconstruction

A byte-identical ca65 reconstruction of Hudson Soft's 1986 Famicom game
**Doraemon** (`HFC-DO`), edited in Retrolarium Studio. Both known Japanese
revisions build from shared source; the ROM-derived assets stay private.

## Status

Source Reconstruction 3.1. Editing happens in Retrolarium Studio:
`doraemon.rlj` opens both revisions
([`docs/retrolarium.md`](docs/retrolarium.md)).

3.1 keeps only what builds and checks the source. The earlier releases' Ghidra
regeneration pipeline and its ledgers, audits, authoring contracts and editable
JSON, FCEUX runtime scenarios and debugger exports remain in the history (tags
`source-reconstruction-1.0` to `3.0`); the source is now edited directly.

The cartridge uses GNROM mapper 66 with 128 KiB of PRG and 32 KiB of CHR. The
two revisions share their header and CHR; 50 classified PRG bytes differ in
bank 2 ([`docs/revisions.md`](docs/revisions.md)).

The source does not yet survive moving its code. ROM addresses in instruction
operands, the bank 3 entry points the other banks call, and the NMI services
of bank 3 are symbolic, but many pointer tables (RTS dispatch tables, pointer
loads, pointers inside data streams) are still raw bytes, so a build whose
modules move does not run. Until they are labelled there is no emulator run
in the checks.

## Quick start

You need Python 3, GNU Make and Retrolarium Kit (`rltool` on `PATH`, or
`RLTOOL=...`); the kit supplies the pinned ca65 and ld65 of
`config/toolchain.json`. Copy `Doraemon (J) (PRG0) [!].nes` and
`Doraemon (Japan) (Rev A).nes` into the repository root, then:

```bash
make split              # unpack the private assets (once)
make verify             # build the original revision and compare byte for byte
make verify-revisions   # both revisions
```

ROMs, extracted assets and build products are ignored by Git.

## Targets

```bash
make build / verify                    # the original revision
make verify-revisions                  # both revisions (PROFILE=original|rev_a for one)
make audit-revisions                   # compare the two reference ROMs
make studio-check                      # open and rebuild both revisions in the kit
make test                              # the checks
make lint / format / format-check / hooks / rom-info / bank-info / clean / help
```

`make test` (well under a minute) runs the unit tests, verifies both revisions
byte for byte and runs the studio check.

## Repository map

```text
src/           ca65 source (main.asm, one include map per PRG bank)
config/        linker layout, revisions, toolchain, lint, names, profile
assets/        manifest.json (the extracted assets are ignored)
scripts/build/ split, verification and revision scripts
tests/         their unit tests
docs/          architecture, subsystems, RAM, data formats, worlds
doraemon.rlj   the Retrolarium project
```

Start with the [documentation index](docs/index.md).

## Research and rights

Published CadEditor map and table information, cartridge databases and
community guides provide external boundary evidence; the sources and how they
are used are listed in [Provenance](docs/provenance.md). External tools and
references are not copied into this repository.

Original game code, graphics, music, text, and data remain property of their
respective rights holders. This repository does not distribute ROM images or
extracted copyrighted assets. Users must supply their own lawful references.

## Trademarks

This is an unofficial reconstruction, made for study and preservation. The game,
its title and its characters are trademarks of their owners, who have not made,
licensed or endorsed this project. It contains no part of the game: you need
your own copy of Doraemon to build anything.
