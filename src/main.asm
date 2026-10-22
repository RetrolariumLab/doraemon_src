; Doraemon (Japan) source, assembled through a revision's entry file,
; src/revisions/<id>.asm

.setcpu "6502"

DORAEMON_REVISION_ORIGINAL = 0
DORAEMON_REVISION_REV_A = 1

.ifndef DORAEMON_REVISION
    .error "assemble a revision's entry file, src/revisions/<id>.asm"
.endif

.assert DORAEMON_REVISION = DORAEMON_REVISION_ORIGINAL .or DORAEMON_REVISION = DORAEMON_REVISION_REV_A, error, "unsupported Doraemon revision"

.segment "HEADER"

    .byte "NES", $1A  ; iNES magic
    .byte $08  ; eight 16 KiB PRG-ROM units (128 KiB)
    .byte $04  ; four 8 KiB CHR-ROM units (32 KiB)
    .byte $21  ; mapper 66 low nibble, vertical mirroring
    .byte $40  ; mapper 66 high nibble
    .byte $00  ; original legacy PRG-RAM field
    .byte $00  ; NTSC
    .byte $00, $00, $00, $00, $00, $00

.include "memory/hardware.inc"
.include "memory/ram.inc"

.include "banks/bank_0.asm"
.include "banks/bank_1.asm"
.include "banks/bank_2.asm"
.include "banks/bank_3.asm"
.include "graphics/chr.asm"
