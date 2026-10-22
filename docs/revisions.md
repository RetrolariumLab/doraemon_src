# Revisions

The source builds the original Japanese release and Revision A, each byte
for byte. Whether Revision A is a good dump is open
([unknowns](unknowns.md), REV-A). The
private reference images remain outside version control.

| Profile | PRG CRC32 | CHR CRC32 | Payload CRC32 |
| --- | --- | --- | --- |
| `original` | `B00ABE1C` | `761F994E` | `BDE3AE9B` |
| `rev_a` | `FE90D6EB` | `761F994E` | `336093EF` |

The iNES header and all 32 KiB of CHR are identical. Exactly 50 PRG bytes
differ, all in physical PRG bank 2. They lie in two source
windows:

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
profile alone reaches the World 3 steady loop and ending credits. Releases 1.0
to 3.0 recorded this with FCEUX traces; the observed result is preserved rather
than silently treating the two programs as behaviorally identical.

No map, metatile, object, palette, text, audio, or graphics data difference is
present in the two known images. There are therefore no revision-specific
binary source assets to extract at this time. Future data-only differences
must be declared in `assets/manifest.json`, with their hashes, before
extraction.

Build or verify one revision with `make build REVISION=rev_a` or `make verify
REVISION=rev_a` (the original unless given), each into
`build/revisions/<id>/`; `make verify-revisions` checks every revision whose
ROM is here.
