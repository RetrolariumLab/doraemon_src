# Unknowns

Only open questions live here. The investigation ledger of Source
Reconstruction 1.0 to 3.0, with what it resolved, is at those tags
(`docs/unknowns.md`); the reference pages state the results.

## MOVE-001 - raw pointers left in the source

The source builds byte for byte, but a build whose code moves does not run
yet, so there is no relocated build and no emulator check. These still hold
original addresses rather than labels:

- the six RTS dispatch tables, written as `.byte` runs: one in
  `src/world1/object_persistence_and_spawning.asm`, two in
  `src/world2/enemy_handlers.asm` and three in `src/world2/ppu_screen_services.asm`;
- nine labels defined as "overlapping entry" offsets (`* + 1`) into an
  instruction;
- the pointer tables into data streams, World 2's screen pointers
  (`src/world2/data/screen_pointer_table.asm`) and World 3's behavior pointers
  (`src/world3/data/entity_behavior_pointers.asm`), and any pointers inside the
  streams.

The pointer immediates and pushed return addresses are labels already.

## REV-A - is Revision A a good dump?

- Known: CHR and the header are identical; 50 PRG bytes in bank 2 differ, in
  two windows of World 3 code ([revisions](revisions.md)). 49 of them only
  set bits, and the second window becomes all `$FF`, which looks like a
  failing chip rather than a publisher's patch.
- Known: the 1.0-3.0 traces show Revision A resetting to the shell in the
  frame it enters World 3.
- Unknown: whether a cartridge database confirms this image (SHA-1
  `20c5e40a...`, payload CRC32 `336093EF`). If it is a bad dump, the revision
  goes; if it is good, World 3's reset is the cartridge's own behavior.

## BANK-001 - power-on bank

- Known: every bank contains compatible vectors and reset bytes.
- Unknown: which PRG/CHR state the physical GNROM latch exposes reliably at
  power-on and what assumptions the software makes before its first write.

## WORLD-DATA-002 - attribute properties

- Known: bits 0-1 of each attribute byte select one of four palettes; CadEditor
  preserves bits 2-7 independently. Bits 2-7 are zero in every World 1 and
  World 3 attribute.
- Unknown: whether the engine reserves those upper bits for runtime properties
  or they are simply unused in Doraemon. Collision semantics are not inferred.

## W3-CODE-001 - dormant World 3 code

- Known: eleven instruction-aligned World 3 code islands have coherent control
  flow and helper/RAM conventions ([World 3 runtime](world3_runtime.md)).
- Unknown: no caller is present in the static PRG graph; whether any path
  reaches them.

## AUDIO-002 - effect identities and unreachable bytes

- Unknown: the gameplay identity of each sound effect; the names describe what
  the handlers do.
- Unknown: whether the bytes next to the music streams that no track header
  reaches hold dormant music or unrelated tables: Bank 0 `$EE34-$EFFA` and
  `$FCBF-$FFF9`, Bank 1 `$B11B-$B2E2` and `$B8E2-$B8FF`, Bank 2
  `$C92C-$CAF2`, and Bank 3 `$A30F-$A4D4` and `$ADBC-$B1BB` (3,701 bytes).

## SOURCE-BYTES-001 - inline and dormant directive bytes

- Known: of the 83,283 bytes the source emits through data directives, all
  but 1,999 belong to typed tables, the common local-dispatch JMP encodings or
  `$FF` bank fill.
- Unknown: the 1,999 remaining bytes are small inline or post-return islands
  whose consumer or executable status is not proved. Some may be dormant 6502
  routines or overlapping encodings; an entry point found later can turn such
  a range into instructions.

## TEXT-001 - post-credit presentation data

- Known: the active ending loop reads 380 fixed 32-byte rows from
  `$BDBC-$ED3B` and exits when its source pointer reaches `$ED3C`.
- Unknown: whether a dormant or untraced path consumes the text- and
  graphics-like bytes of `$ED3C-$F9BB` (3,200 bytes), and their screen format.
