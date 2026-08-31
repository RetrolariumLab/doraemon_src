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
- Unknown: enemy, item, NPC, boss, trigger, door, and projectile records.

## AUDIO-001 - driver ownership

- Known: frame/NMI code is duplicated across banks and bank 3 contains extensive
  presentation data.
- Unknown: which sound routines and streams are shared, copied, or bank-local.

## REV-001 - Revision A

- Known: CHR is unchanged; PRG and payload CRCs differ.
- Unknown: exact changed ranges and behavioral fixes until a matching Rev A dump
  is supplied and aligned.
