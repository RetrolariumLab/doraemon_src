; Doraemon PRG bank 3 $8FF2-$9247
; Shell PPU updates, palette staging, and ending-credit row streaming
; Generated deterministically from pinned Ghidra/GhidraNes facts

Shell_NmiFrameServices:
    LDA $09
    ASL A
    TAX
    CPX #$06
    BCS Bank3_Label_9002
    LDA a:$9004,X
    PHA
    LDA a:$9003,X
    PHA

Bank3_Label_9002:
    RTS
    .byte $08, $90, $66, $90, $89, $90, $A5, $14, $F0, $4E, $A5, $19, $8D, $00, $20, $A5
    .byte $1A, $8D, $01, $20, $A5, $1B, $8D, $05, $20, $A5, $1C, $8D, $05, $20, $A5, $0D
    .byte $F0, $36, $A4, $0E, $20, $5C, $90, $A5, $0F, $0A, $2A, $29, $01, $05, $19, $8D
    .byte $00, $20, $A5, $0F, $0A, $8D, $05, $20, $A5, $1C, $8D, $05, $20, $A4, $10, $20
    .byte $5C, $90, $A5, $11, $0A, $2A, $29, $01, $05, $19, $8D, $00, $20, $A5, $11, $0A
    .byte $8D, $05, $20, $A5, $1C, $8D, $05, $20, $60, $A2, $15, $CA, $D0, $FD, $EA, $EA
    .byte $88, $D0, $F6, $60, $20, $03, $91, $20, $2C, $91, $20, $D7, $90, $A5, $19, $29
    .byte $FC, $8D, $00, $20, $A5, $1A, $8D, $01, $20, $A5, $1B, $8D, $05, $20, $A5, $1C
    .byte $8D, $05, $20, $20, $A1, $91, $60, $20, $AF, $91, $20, $D7, $90, $A5, $1B, $8D
    .byte $05, $20, $A5, $1C, $8D, $05, $20, $A5, $1A, $8D, $01, $20, $A5, $42, $F0, $17
    .byte $A5, $19, $29, $E0, $8D, $00, $20, $2C, $02, $20, $70, $FB, $2C, $02, $20, $50
    .byte $FB, $A2, $00, $EA, $CA, $D0, $FC, $A5, $19, $29, $FC, $8D, $00, $20, $4C, $9D
    .byte $91

Shell_CopyPaletteToStaging:
    LDY #$00

Bank3_Label_90C6:
    LDA ($00),Y
    STA a:$0210,Y
    INY
    CPY #$20
    BCC Bank3_Label_90C6
    RTS

Shell_UploadStagedPalette:
    JSR Bank3_WaitForVblank
    JMP Bank3_Label_90DC
    .byte $AD, $08, $04, $F0, $26

Bank3_Label_90DC:
    LDA #$3F
    STA a:PPU_ADDR
    LDA #$00
    STA a:PPU_ADDR
    LDY #$E0

Bank3_Label_90E8:
    LDA a:$0130,Y
    STA a:PPU_DATA
    INY
    BNE Bank3_Label_90E8
    LDA #$3F
    STA a:PPU_ADDR
    STY a:PPU_ADDR
    STY a:PPU_ADDR
    STY a:PPU_ADDR
    STA a:$0408
    RTS
    .byte $A5, $1C, $29, $07, $C9, $03, $D0, $F7, $AD, $80, $01, $F0, $F2, $8D, $06, $20
    .byte $AD, $81, $01, $8D, $06, $20, $A2, $00, $BD, $82, $01, $8D, $07, $20, $E8, $E0
    .byte $20, $90, $F5, $A9, $00, $8D, $80, $01, $60, $A5, $1C, $29, $07, $C9, $04, $D0
    .byte $F7, $AD, $C0, $01, $F0, $F2, $A2, $23, $8E, $06, $20, $8D, $06, $20, $A2, $00
    .byte $8E, $C0, $01, $BD, $C1, $01, $8D, $07, $20, $E8, $E0, $08, $90, $F5, $60

Shell_ClearBothNametables:
    LDA PpuCtrlShadow
    AND #$FB
    STA PpuCtrlShadow
    AND #$7F
    STA a:PPU_CTRL
    LDA #$20
    STA a:PPU_ADDR
    LDX #$00
    STX a:PPU_ADDR
    LDY #$08
    LDA #$7F

Bank3_Label_916B:
    STA a:PPU_DATA
    INX
    BNE Bank3_Label_916B
    DEY
    BNE Bank3_Label_916B
    LDA #$23
    STA a:PPU_ADDR
    LDA #$C0
    STA a:PPU_ADDR
    LDX #$40
    LDA #$00

Bank3_Label_9182:
    STA a:PPU_DATA
    INX
    BNE Bank3_Label_9182
    LDA #$27
    STA a:PPU_ADDR
    LDA #$C0
    STA a:PPU_ADDR
    LDX #$40
    LDA #$00

Bank3_Label_9196:
    STA a:PPU_DATA
    INX
    BNE Bank3_Label_9196
    RTS
    .byte $A2, $04, $D0, $02

Shell_HideAllOamEntries:
    LDX #$00
    LDA #$F0

Bank3_Label_91A5:
    STA a:OamBuffer,X
    INX
    INX
    INX
    INX
    BNE Bank3_Label_91A5
    RTS
    .byte $A5, $41, $F0, $FB, $A5, $40, $85, $00, $A9, $08, $06, $00, $06, $00, $06, $00
    .byte $06, $00, $2A, $06, $00, $2A, $8D, $06, $20, $A5, $00, $8D, $06, $20, $A0, $00
    .byte $B1, $3E, $8D, $07, $20, $C8, $C0, $20, $90, $F6, $A5, $3E, $18, $69, $20, $85
    .byte $3E, $A5, $3F, $69, $00, $85, $3F, $A9, $00, $85, $41, $E6, $40, $60

Bank3_Label_91ED:
    RTS

Shell_StreamEndingCreditRow:
    LDA FrameCounter
    AND #$03
    BNE Bank3_Label_91ED
    LDX PpuScrollYShadow
    INX
    CPX #$F0
    BCC Bank3_Label_91FD
    LDX #$00

Bank3_Label_91FD:
    STX PpuScrollYShadow
    TXA
    AND #$07
    CMP #$03
    BNE Bank3_Label_91ED
    LDA #$08
    STA $01
    LDA PpuScrollYShadow
    AND #$F8
    ASL A
    ROL $01
    ASL A
    ROL $01
    STA a:$0181
    LDA $01
    STA a:$0180
    LDY #$00

Bank3_Label_921E:
    LDA (EndingCreditSourcePointer),Y
    CMP #$20
    BNE Bank3_Label_9226
    LDA #$7F

Bank3_Label_9226:
    CMP #$2E
    BNE Bank3_Label_922C
    LDA #$5B

Bank3_Label_922C:
    CMP #$26
    BNE Bank3_Label_9232
    LDA #$5F

Bank3_Label_9232:
    STA a:$0182,Y
    INY
    CPY #$20
    BCC Bank3_Label_921E
    LDA EndingCreditSourcePointer
    CLC
    ADC #$20
    STA EndingCreditSourcePointer
    LDA EndingCreditSourcePointer+$01
    ADC #$00
    STA EndingCreditSourcePointer+$01
    RTS
