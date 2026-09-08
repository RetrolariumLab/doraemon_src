# Official revision profiles

Source Reconstruction 2.0 supports the original Japanese release and the
official Revision A cartridge as separate, byte-identical build profiles. The
private reference images remain outside version control.

| Profile | PRG CRC32 | CHR CRC32 | Payload CRC32 |
| --- | --- | --- | --- |
| `original` | `B00ABE1C` | `761F994E` | `BDE3AE9B` |
| `rev_a` | `FE90D6EB` | `761F994E` | `336093EF` |

The iNES header and all 32 KiB of CHR are identical. Exactly 50 PRG bytes
differ, all in physical PRG bank 2. The comparison contract in
`config/revision_profiles.json` confines them to two source windows:

- CPU `$AB3B-$AB60` in `src/world3/room_collision_helpers.asm`;
- CPU `$AF40-$AF5F` in `src/world3/chapter_transition.asm`.

Both windows intersect executable code in the original revision. Revision A
replaces selected instruction bytes in the first window and the entire second
window with values dominated by `$FF`. Their behavioral purpose has not yet
been proven, so the source records the byte differences without assigning a
bug-fix meaning to them.

Direct source-built runtime traces establish an important profile limitation.
Revision A enters World 3, executes the changed `$AB53` encounter helper, and
reaches the first `$838E` frame-loop probe, but resets in that same frame and
returns to the Bank 3 shell. The sequence repeats independently in two traces.
World 1 and World 2 remain steady under the shared scenarios. The original
profile alone reaches the World 3 steady loop and ending credits. See
`docs/revision_runtime.md`; this observed result is preserved rather than
silently treating the two programs as behaviorally identical.

No map, metatile, object, palette, text, audio, or graphics data difference is
present in the two known images. There are therefore no revision-specific
binary source assets to extract at this time. The revision splitter deliberately
emits none; future data-only differences must be declared and checksum-pinned
as `source_assets` before extraction.

Canonical Ghidra regeneration remains based on the original PRG0 image. For
the two source files named by the classified code windows, the disassembly
checker projects each explicit Revision A conditional onto its original branch
before comparison. `make disassemble` preserves a declared overlay only when
that projection still equals fresh canonical output; if the original branch
changes, regeneration stops instead of silently deleting or carrying forward
stale Revision A bytes. Both complete profile builds then verify the alternate
branches byte for byte.

The original-profile ld65 debug inventory consequently includes one additional
source file and four absolute profile equates (`DORAEMON_REVISION` plus the
three profile-ID constants). Program, RAM, and per-bank FCEUX label counts and
addresses remain unchanged; `config/debugger/debug_symbols.json` pins both the expected
metadata increase and the stable debugger-facing symbol sets.

The reconstruction inventory counts label identities per bank rather than raw
definition lines. A symbol repeated in mutually exclusive original/Revision A
branches therefore remains one navigable label and does not inflate semantic
or neutral naming progress.

Audit the two private references with:

```console
make audit-revisions
```

Build or verify one profile with `PROFILE=original` or `PROFILE=rev_a`. Both
byte-identical images are checked together with:

```console
make verify-revisions
```

Capture and validate both runtime profiles with:

```console
make runtime-revision-matrix
```

Build products are isolated under `build/revisions/<profile>/`. The historical
`make build` and `make verify` targets remain aliases for the original Source
Reconstruction 1.0 baseline.
