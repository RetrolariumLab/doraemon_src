; Doraemon (Japan, original revision) NES preservation entrypoint

.setcpu "6502"

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
