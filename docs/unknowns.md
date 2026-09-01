# Unknowns

## BANK-001 - power-on bank

- Known: every bank contains compatible vectors and reset bytes.
- Unknown: which PRG/CHR state the physical GNROM latch exposes reliably at
  power-on and what assumptions the software makes before its first write.

## BANK-002 - dispatch table roles

- Known: four bank-specific JMP entries begin at `$8271`.
- Unknown: exact init/frame/render/transition meanings for each entry.

## W2-DATA-001 - block-table overlap

- Known: CadEditor requests 1,024 bytes at file `$BAAF`; screens begin at
  `$BDFC`, producing a 179-byte overlap.
- Unknown: the true used block count and whether the overlap is intentional,
  harmless unused capacity, or a configuration approximation.

## OBJ-001 - chapter object formats

- Known: CadEditor disables enemy editing for all four configurations.
- Known: World 1 city and underground placements are three-byte X/Y/type
  records, including their terminators, persistent IDs, type split, and sorted
  city tail; `config/object_placements.json` validates both lists.
- Unknown: the remaining descriptor semantics and the World 2/World 3 enemy,
  item, NPC, boss, trigger, door, and projectile record formats.

## AUDIO-002 - command and stream semantics

- Known: all four banks carry independently validated local drivers. Their
  request limits, effect RTS tables, 17-command dispatch tables, and accepted
  track counts are recorded in `config/audio_dispatch.json`.
- Unknown: semantic names for individual effects, music commands, track headers,
  and stream fields beyond their proven control-flow roles.

## REV-001 - Revision A

- Known: CHR is unchanged; PRG and payload CRCs differ.
- Unknown: exact changed ranges and behavioral fixes until a matching Rev A dump
  is supplied and aligned.
