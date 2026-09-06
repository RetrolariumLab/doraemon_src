; Doraemon PRG bank 3 $8FF2-$9829
; Shell PPU updates, text drawing, and presentation data
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

Bank3_Func_90C4:
    LDY #$00

Bank3_Label_90C6:
    LDA ($00),Y
    STA a:$0210,Y
    INY
    CPY #$20
    BCC Bank3_Label_90C6
    RTS

Bank3_Func_90D1:
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

Bank3_Func_9152:
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

Bank3_Func_91A1:
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

Bank3_Func_91EE:
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
    LDA ($4B),Y
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
    LDA $4B
    CLC
    ADC #$20
    STA $4B
    LDA $4C
    ADC #$00
    STA $4C
    RTS
    .byte $20, $84, $15, $80, $81, $82, $83, $83, $85, $86, $87, $86, $89, $8A, $8B, $8C
    .byte $00, $00, $80, $84, $88, $00, $85, $82, $20, $A4, $15, $90, $10, $92, $93, $94
    .byte $95, $10, $10, $10, $99, $9A, $9B, $9C, $9D, $9E, $9F, $10, $8D, $8E, $8F, $92
    .byte $20, $C4, $16, $A0, $A1, $A2, $A3, $A4, $A5, $A6, $A7, $A8, $A9, $AA, $AB, $AC
    .byte $AD, $AE, $AF, $91, $96, $97, $10, $EC, $EF, $20, $E5, $16, $B1, $B2, $10, $B4
    .byte $A1, $10, $10, $10, $B9, $BA, $10, $BC, $BD, $10, $BF, $98, $B0, $B3, $10, $F4
    .byte $F6, $F8, $21, $04, $17, $C0, $C1, $C2, $C3, $C4, $C5, $C6, $C7, $C8, $C9, $CA
    .byte $10, $CC, $CD, $CE, $CF, $B5, $B6, $B7, $B8, $FA, $20, $FD, $21, $24, $17, $D0
    .byte $D1, $D2, $D3, $D4, $D5, $D6, $10, $D8, $D9, $C8, $DB, $DC, $DD, $DE, $DF, $BB
    .byte $BE, $CB, $D7, $10, $FE, $F7, $21, $44, $16, $E0, $E1, $E2, $E3, $E4, $E5, $20
    .byte $E7, $E8, $B1, $D8, $B2, $10, $ED, $EE, $10, $C8, $DA, $E6, $E9, $10, $FF, $21
    .byte $64, $16, $F0, $F1, $F2, $F3, $00, $F5, $F1, $F7, $00, $F9, $F3, $FB, $FC, $F3
    .byte $F5, $F1, $EA, $FB, $EA, $EB, $F2, $F3, $21, $E7, $11, $50, $55, $53, $48, $00
    .byte $53, $54, $41, $52, $54, $00

TitleScreen_Text:
    .byte $42, $55, $54, $54, $4F, $4E, $22, $48, $0F, $48, $49, $53, $43, $4F, $52, $45
    .byte $00, $00, $00, $00, $00, $00, $00, $30, $22, $8A, $0D, $53, $43, $4F, $52, $45
    .byte $00, $00, $00, $00, $00, $00, $00, $30, $22, $E3, $1B, $43, $4F, $50, $59, $52
    .byte $49, $47, $48, $54, $00, $31, $39, $38, $36, $00, $48, $55, $44, $53, $4F, $4E
    .byte $00, $53, $4F, $46, $54, $5B, $23, $22, $1C, $40, $00, $46, $55, $4A, $49, $4B
    .byte $4F, $5B, $53, $48, $4F, $47, $41, $4B, $55, $4B, $41, $4E, $5B, $54, $56, $00
    .byte $41, $53, $41, $48, $49, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $46, $46, $46, $46, $46, $46, $46, $46, $46, $46
    .byte $46, $46, $46, $46, $46, $46, $46, $46, $46, $46, $46, $46, $46, $46, $46, $46
    .byte $46, $46, $46, $46, $46, $46, $47, $47, $47, $47, $47, $47, $47, $47, $47, $47
    .byte $47, $47, $47, $47, $47, $47, $47, $47, $47, $47, $47, $47, $47, $47, $47, $47
    .byte $47, $47, $47, $47, $47, $47, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55
    .byte $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55
    .byte $7B, $7C, $7D, $55, $55, $55, $56, $56, $56, $56, $7C, $7D, $56, $56, $56, $56
    .byte $56, $56, $56, $56, $56, $56, $56, $56, $56, $56, $56, $56, $56, $56, $56, $56
    .byte $56, $56, $56, $56, $56, $56, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A
    .byte $9A, $9A, $9A, $7B, $7C, $7D, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A
    .byte $9A, $70, $74, $75, $9A, $9A, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B
    .byte $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B
    .byte $79, $DF, $DF, $DF, $7E, $81, $7A, $7A, $7A, $7A, $7A, $7A, $7A, $7A, $7A, $7A
    .byte $71, $72, $73, $7A, $7A, $7A, $77, $78, $76, $7A, $7A, $7A, $7A, $7A, $7A, $71
    .byte $DF, $DF, $DF, $DF, $DF, $91, $EF, $EF, $EF, $62, $66, $80, $64, $65, $63, $62
    .byte $DF, $DF, $DF, $66, $80, $62, $DF, $DF, $DF, $63, $64, $65, $63, $64, $65, $BE
    .byte $DF, $DF, $DF, $DF, $DF, $DF, $66, $80, $62, $DF, $54, $91, $DF, $DF, $BC, $BE
    .byte $DF, $DF, $DF, $54, $91, $DF, $DF, $DF, $DF, $BC, $BE, $DF, $91, $DF, $DF, $BB
    .byte $DF, $DF, $DF, $DF, $DF, $DF, $54, $91, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $BB
    .byte $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $BD, $DF, $DF, $DF, $DF, $DF
    .byte $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF
    .byte $DF, $DF, $DF, $DF, $DF, $DF, $DF, $BD, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF
    .byte $DF, $DF, $DF, $BD, $DF, $DF, $60, $61, $60, $61, $60, $61, $60, $61, $60, $61
    .byte $60, $61, $60, $61, $60, $61, $60, $61, $60, $61, $60, $61, $60, $61, $60, $61
    .byte $60, $61, $60, $61, $60, $61, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9F
    .byte $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9F
    .byte $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8F, $8E, $8F, $8E, $8F, $8E, $8F, $8E, $8F
    .byte $8E, $8F, $8E, $8F, $8E, $8F, $8E, $8F, $8C, $8D, $8E, $8F, $8E, $8F, $8E, $8F
    .byte $8E, $8F, $8E, $8E, $8E, $8E, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9F
    .byte $84, $85, $88, $89, $82, $83, $86, $87, $8A, $8B, $9E, $9F, $9E, $9F, $9E, $9F
    .byte $9E, $9F, $9E, $9F, $8E, $8E, $8E, $8F, $8E, $8F, $8E, $8F, $8E, $8F, $9C, $EF
    .byte $94, $95, $98, $99, $92, $93, $96, $97, $DF, $DF, $EF, $AC, $8E, $8F, $8E, $8F
    .byte $8E, $8F, $8E, $8F, $8E, $8E, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9E, $9D, $EF
    .byte $44, $45, $A8, $A9, $90, $43, $A6, $A7, $AA, $AB, $EF, $AD, $9E, $9F, $9E, $9F
    .byte $9E, $9F, $9E, $9F, $9E, $9F, $8E, $8F, $8E, $8F, $8E, $8F, $8E, $9C, $EF, $EF
    .byte $AE, $AF, $AE, $AF, $AE, $AF, $AE, $AF, $AE, $AF, $EF, $EF, $AC, $8F, $8E, $8F
    .byte $8E, $8F, $8E, $8F, $8E, $8F, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $51, $50, $50
    .byte $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $52, $9E, $9E, $9F
    .byte $9E, $9F, $9E, $9F, $9E, $9F, $8E, $8F, $8E, $8F, $8E, $8F, $8E, $8F, $53, $53
    .byte $53, $53, $53, $53, $53, $53, $53, $53, $53, $53, $53, $53, $8E, $8F, $8E, $8F
    .byte $8E, $8F, $8E, $8F, $8E, $8F, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9F, $8E, $8E
    .byte $8E, $9E, $8E, $8E, $8E, $9E, $8E, $8E, $8E, $8E, $8E, $9F, $9E, $9F, $9E, $9F
    .byte $9E, $9F, $9E, $9F, $9E, $9F, $8E, $8F, $8E, $8F, $8E, $8F, $8E, $8F, $8E, $9E
    .byte $8F, $8F, $9E, $8F, $8E, $8F, $8E, $9E, $8E, $9E, $8E, $8F, $8E, $8F, $8E, $8F
    .byte $8E, $8F, $8E, $8F, $8E, $8F, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9F
    .byte $9E, $9E, $9E, $8E, $9F, $8E, $9E, $9E, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9F
    .byte $9E, $9F, $9E, $9F, $9E, $9F, $8E, $8F, $8E, $8F, $8E, $8F, $8E, $8F, $8E, $8F
    .byte $8E, $8F, $8E, $9E, $8E, $9E, $8E, $8F, $8E, $8F, $8E, $8F, $8E, $8F, $8E, $8F
    .byte $8E, $8F, $8E, $8F, $8E, $8F, $9E, $8F, $9E, $9E, $9E, $8F, $9E, $8F, $9E, $8F
    .byte $9E, $8F, $9E, $8F, $9E, $8F, $9E, $8F, $9E, $8F, $9E, $8F, $9E, $8F, $9E, $8F
    .byte $9E, $8F, $9E, $8F, $9E, $8F, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E
    .byte $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8F
    .byte $8E, $8F, $8E, $8F, $8E, $8F, $9E, $8F, $9E, $8F, $9E, $8F, $9E, $8F, $9E, $8F
    .byte $9E, $8F, $9E, $8F, $9E, $8F, $9E, $8F, $9E, $8F, $9E, $8F, $9E, $8F, $9E, $9E
    .byte $9E, $8E, $9E, $8E, $9E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E
    .byte $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E
    .byte $8E, $8E, $8E, $8E, $8E, $8E, $9E, $8E, $9E, $8E, $9E, $8E, $9E, $8E, $9E, $8E
    .byte $9E, $8E, $9E, $8E, $9E, $8E, $9E, $8E, $9E, $8E, $9E, $8E, $9E, $8E, $9E, $8E
    .byte $9E, $8E, $9E, $8E, $9E, $8E, $AA, $AA, $AA, $AA, $AA, $AA, $EA, $BA, $AA, $AB
    .byte $AA, $AF, $AA, $AA, $AA, $AA, $AA, $AA, $AA, $AA, $AA, $AA, $AA, $AA, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00

AudioEffect_RequestPriority:
    .byte $00, $54, $64, $4C, $40, $44, $04, $38, $34, $3C, $1C, $50, $58, $60, $2C, $28
    .byte $08, $48, $30, $20, $24, $18, $14, $10, $0C, $5C

AudioEffect_RtsDispatchTable:
    .byte $A1, $98, $A0, $98, $C2, $99, $DA, $99, $19, $9A, $33, $9A, $EE, $9D, $9B, $9D
    .byte $C3, $9D, $CD, $9D, $8E, $9D, $98, $9D, $5E, $9D, $68, $9D, $FA, $9A, $07, $9B
    .byte $1B, $9D, $30, $9C, $24, $9D, $41, $9D, $1C, $9C, $30, $9C, $D9, $9B, $E8, $9B
    .byte $DA, $9C, $F5, $9C, $B1, $9A, $93, $98, $83, $9A, $93, $98, $CA, $9A, $E1, $9A
    .byte $8B, $99, $30, $9C, $93, $99, $30, $9C, $A9, $9C, $BD, $9C, $9B, $9A, $93, $98
    .byte $60, $9B, $93, $98, $7B, $9B, $93, $98, $CE, $98, $F0, $98, $CE, $98, $39, $99
    .byte $91, $9B, $A5, $9B, $69, $99, $98, $98, $C9, $1A, $B0, $1A, $86, $49, $AE, $A0
    .byte $02, $30, $0E, $84, $4A, $A8, $BD, $84, $97, $D9, $84, $97, $90, $09, $98, $A4
    .byte $4A, $8D, $A0, $02, $A6, $49

Bank3_Label_9824:
    RTS
    .byte $A4, $4A, $4C, $22, $98
