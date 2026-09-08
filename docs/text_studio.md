# Text Studio

Text Studio edits the complete proven shell-text surface in PRG bank 3 while
preserving every physical range. It is supported for the original Japanese
revision and Revision A through the same source document and encoder.

Initialize, validate, and open an ignored profile workspace with:

```bash
make text-content-init PROFILE=original
make text-content-check PROFILE=original
make text-studio PROFILE=original
```

The editor exposes 412 fixed-width fields: game over, five title/HUD strings,
26 chapter-help item names, and all 380 ending-credit rows. It also exposes the
eight graphical title packets and all 32 rows of the ending-opening nametable
as exact-width hexadecimal records. Address, count, row-width, and span
geometry remain structural and cannot be resized by the editor.

The preview renders source text through the actual background pattern table in
CHR bank 3. It applies the game's distinct encodings: zero-space game-over
text, title period tile `$5B`, direct help-screen bytes, and the credits
uploader's space/period/ampersand remap. This makes the preview aware of the
real tile indexes rather than treating the source as an ordinary host font.

Each edit is one undoable transaction. The native shell-text encoder validates
ASCII domains and exact lengths before accepting it; failed changes restore the
previous document. Saving is atomic and never modifies canonical data or a
reference ROM.

Deterministic workflows are:

```bash
make text-content-export PROFILE=original
make text-content-rom PROFILE=original
make text-content-roundtrip
```

The canonical round trip applies all 16,581 editable bytes to source-built
images and requires zero changed bytes for both official revisions. The 3,200
post-credit bytes remain typed unclassified presentation data and are not
misrepresented as editable text without a proven consumer.
