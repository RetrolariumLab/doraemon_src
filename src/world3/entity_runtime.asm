; Doraemon PRG bank 2 $8B68-$9191
; World 3 entity storage, movement, collision, and behavior dispatch
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank2_Func_8B68:
    TXA
    PHA

Bank2_Label_8B6A:
    LDA #$00
    STA a:$0600,X
    TXA
    CLC
    ADC #$08
    TAX
    CPX #$B0
    BCC Bank2_Label_8B6A
    PLA
    TAX
    RTS

Bank2_Func_8B7B:
    LDX #$00

Bank2_Label_8B7D:
    LDA a:$D96B,X
    STA a:$06B0,X
    INX
    CPX #$41
    BNE Bank2_Label_8B7D
    LDX #$00

Bank2_Label_8B8A:
    LDA a:$06BD,X
    STA a:$04A0,X
    LDA #$00
    STA a:$04A4,X
    INX
    CPX #$04
    BNE Bank2_Label_8B8A
    LDX #$00

Bank2_Label_8B9C:
    JSR Bank2_Func_B153
    AND #$03
    TAY
    LDA a:$04A4,Y
    BNE Bank2_Label_8B9C
    LDA #$01
    STA a:$04A4,Y
    LDA a:$04A0,Y
    STA a:$06BD,X
    INX
    CPX #$04
    BNE Bank2_Label_8B9C
    LDX #$00

Bank2_Label_8BB9:
    LDA a:$06C1,X
    STA a:$04A0,X
    LDA #$00
    STA a:$04A8,X
    INX
    CPX #$08
    BNE Bank2_Label_8BB9
    LDX #$00

Bank2_Label_8BCB:
    JSR Bank2_Func_B153
    AND #$07
    TAY
    LDA a:$04A8,Y
    BNE Bank2_Label_8BCB
    LDA #$01
    STA a:$04A8,Y
    LDA a:$04A0,Y
    STA a:$06C1,X
    INX
    CPX #$08
    BNE Bank2_Label_8BCB
    LDX #$00
    LDA #$FF

Bank2_Label_8BEA:
    STA a:$06F1,X
    INX
    CPX #$08
    BNE Bank2_Label_8BEA
    RTS

Bank2_Func_8BF3:
    LDA $38
    BEQ Bank2_Label_8C24
    LDA #$00
    STA $38
    LDY #$00

Bank2_Label_8BFD:
    LDA a:$06BD,Y
    CMP #$19
    BEQ Bank2_Label_8C0E
    INY
    CPY #$0D
    BNE Bank2_Label_8BFD
    LDA #$06
    JMP Bank2_Func_AF51

Bank2_Label_8C0E:
    LDA #$00
    STA a:$06B0,Y
    LDA #$01
    STA a:$06E4,Y
    STA $9A
    LDA $8C
    STA a:$06CA,Y
    LDA $8D
    STA a:$06D7,Y

Bank2_Label_8C24:
    RTS

Bank2_Func_8C25:
    LDX $DF
    LDA a:$8C6D,X
    BEQ Bank2_Label_8C6C
    TAX
    LDY #$00

Bank2_Label_8C2F:
    LDA a:$06B0,Y
    CMP $DF
    BNE Bank2_Label_8C67
    LDA a:$06BD,Y
    CMP #$18
    BCC Bank2_Label_8C67
    LDA a:$06D7,Y
    CMP #$50
    BCC Bank2_Label_8C67
    CMP #$A0
    BCS Bank2_Label_8C67
    CPX #$01
    BEQ Bank2_Label_8C5B
    LDA a:$06CA,Y
    CMP #$14
    BCS Bank2_Label_8C67
    LDA #$18
    STA a:$06CA,Y
    JMP Bank2_Label_8C67

Bank2_Label_8C5B:
    LDA a:$06CA,Y
    CMP #$DC
    BCC Bank2_Label_8C67
    LDA #$D8
    STA a:$06CA,Y

Bank2_Label_8C67:
    INY
    CPY #$0D
    BNE Bank2_Label_8C2F

Bank2_Label_8C6C:
    RTS
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $01, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $02, $00
    .byte $01, $02, $00, $00, $00, $01, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Bank2_Func_8CAD:
    LDX #$00
    LDY #$00

Bank2_Label_8CB1:
    LDA a:$06B0,Y
    CMP $DF
    BNE Bank2_Label_8CF0
    JSR Bank2_Func_8B68
    LDA #$01
    STA a:$0600,X
    LDA a:$06CA,Y
    STA a:$0608,X
    LDA a:$06D7,Y
    STA a:$0610,X
    LDA a:$06BD,Y
    STA a:$0638,X
    STY $42
    TAY
    LDA a:$8ED5,Y
    STA a:$0628,X
    LDY $42
    LDA a:$06E4,Y
    STA a:$0678,X
    BEQ Bank2_Label_8CEF
    LDA $8C
    STA a:$0608,X
    LDA $8D
    STA a:$0610,X

Bank2_Label_8CEF:
    INX

Bank2_Label_8CF0:
    INY
    CPY #$0D
    BNE Bank2_Label_8CB1
    RTS

Bank2_Func_8CF6:
    LDA #$00
    STA $3E
    JMP Bank2_Label_8D01

Bank2_Func_8CFD:
    LDA #$01
    STA $3E

Bank2_Label_8D01:
    LDX #$00

Bank2_Label_8D03:
    LDA a:$0600,X
    CMP #$01
    BEQ Bank2_Label_8D11
    CMP #$04
    BEQ Bank2_Label_8D11
    JMP Bank2_Label_8D4C

Bank2_Label_8D11:
    LDA a:$0638,X
    CMP #$18
    BCC Bank2_Label_8D4C
    LDY #$00

Bank2_Label_8D1A:
    CMP a:$06BD,Y
    BEQ Bank2_Label_8D29
    INY
    CPY #$0D
    BNE Bank2_Label_8D1A
    LDA #$02
    JMP Bank2_Func_AF51

Bank2_Label_8D29:
    LDA a:$0678,X
    CMP $3E
    BNE Bank2_Label_8D4C
    JSR Bank2_Func_8D52
    BCS Bank2_Label_8D46
    LDA $DF
    STA a:$06B0,Y
    LDA a:$0608,X
    STA a:$06CA,Y
    LDA a:$0610,X
    STA a:$06D7,Y

Bank2_Label_8D46:
    LDA a:$0678,X
    STA a:$06E4,Y

Bank2_Label_8D4C:
    INX
    CPX #$08
    BNE Bank2_Label_8D03
    RTS

Bank2_Func_8D52:
    STX $3F
    LDA $9A
    BEQ Bank2_Label_8DA4
    LDX #$00

Bank2_Label_8D5A:
    LDA a:$0600,X
    CMP #$01
    BNE Bank2_Label_8D9F
    LDA a:$0638,X
    CMP #$1B
    BNE Bank2_Label_8D9F
    LDA a:$0678,X
    BEQ Bank2_Label_8D9F
    LDX #$00
    STX $40

Bank2_Label_8D71:
    LDA a:$06B0,X
    CMP $8B
    BNE Bank2_Label_8D81
    LDA a:$06BD,X
    CMP #$18
    BCC Bank2_Label_8D81
    INC $40

Bank2_Label_8D81:
    INX
    CPX #$0D
    BNE Bank2_Label_8D71
    LDA $40
    CMP #$02
    BCS Bank2_Label_8DA4
    LDA $8B
    STA a:$06B0,Y
    LDA $8C
    STA a:$06CA,Y
    LDA $8D
    STA a:$06D7,Y
    LDX $3F
    SEC
    RTS

Bank2_Label_8D9F:
    INX
    CPX #$08
    BNE Bank2_Label_8D5A

Bank2_Label_8DA4:
    LDX $3F
    CLC
    RTS

Bank2_Func_8DA8:
    LDX #$00
    TXA

Bank2_Label_8DAB:
    STA a:$06F9,X
    INX
    CPX #$0C
    BNE Bank2_Label_8DAB
    RTS

Bank2_Func_8DB4:
    LDA #$00
    STA $AB
    LDX #$00
    TXA

Bank2_Label_8DBB:
    STA a:$0600,X
    INX
    CPX #$B0
    BNE Bank2_Label_8DBB

Bank2_Label_8DC3:
    RTS

Bank2_Func_8DC4:
    LDA $8E
    CMP #$04
    BEQ Bank2_Label_8DC3
    LDA $CB
    BNE Bank2_Label_8DC3
    LDA $AB
    BNE Bank2_Label_8E26
    LDA #$01
    STA $AB
    LDX $DF
    LDA a:$D66B,X
    STA $AC
    LDA a:$D6AB,X
    STA $AD
    LDA a:$D6EB,X
    STA $AE
    LDA a:$D72B,X
    STA $AF
    LDA a:$D76B,X
    STA $B0
    LDA a:$D7AB,X
    STA $B1
    LDA a:$D7EB,X
    STA $B2
    LDA a:$D82B,X
    STA $B3
    LDA a:$D86B,X
    STA $B4
    STA $C0
    LDA a:$D8AB,X
    STA $B5
    STA $C1
    LDA a:$D8EB,X
    STA $B6
    STA $C2
    LDA a:$D92B,X
    STA $B7
    STA $C3
    LDA #$00
    STA $B8
    STA $B9
    STA $BA
    STA $BB

Bank2_Label_8E26:
    LDA #$00
    STA $00
    LDA #$04
    STA $01

Bank2_Label_8E2E:
    LDX $00
    LDA $B4,X
    BEQ Bank2_Label_8E3F
    LDA $BC,X
    CLC
    ADC #$01
    AND #$03
    STA $BC,X
    BNE Bank2_Label_8E60

Bank2_Label_8E3F:
    LDA $AC,X
    STA $C4
    LDA $B0,X
    STA $C5
    LDA $B4,X
    STA $C6
    LDA $B8,X
    STA $C7
    JSR Bank2_Func_8E67
    LDX $00
    LDA $C5
    STA $B0,X
    LDA $C6
    STA $B4,X
    LDA $C7
    STA $B8,X

Bank2_Label_8E60:
    INC $00
    DEC $01
    BNE Bank2_Label_8E2E
    RTS

Bank2_Func_8E67:
    LDA $C7
    BNE Bank2_Label_8EB4
    LDA $C5
    BEQ Bank2_Label_8EB4
    LDA $C6
    BEQ Bank2_Label_8E7D
    DEC $C6
    BNE Bank2_Label_8EB4
    LDX $00
    LDA $C0,X
    STA $C6

Bank2_Label_8E7D:
    JSR Bank2_Func_9104
    BCC Bank2_Label_8EB4
    JSR Bank2_Func_8B68
    LDA #$1E
    STA a:$0668,X
    LDA $C4
    STA a:$0638,X
    TAY
    LDA a:$8EB5,Y
    STA a:$0698,X
    LDA a:$8ED5,Y
    STA a:$0628,X
    LDA #$FF
    STA a:$0608,X
    STA a:$0610,X
    LDA #$02
    STA a:$0600,X
    JSR Bank2_Func_8F55
    DEC $C5
    BNE Bank2_Label_8EB4
    LDA #$01
    STA $C7

Bank2_Label_8EB4:
    RTS
    .byte $01, $02, $01, $02, $02, $00, $00, $00, $08, $00, $00, $00, $10, $10, $10, $10
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $10, $14, $18, $1C, $20, $24, $40, $B0, $30, $34, $28, $2C, $80, $84, $88, $8C
    .byte $64, $40, $70, $74, $50, $54, $58, $5C, $44, $60, $4C, $48, $90, $94, $98, $9C
    .byte $02, $03, $01, $03, $20, $00, $01, $00, $03, $03, $00, $00, $02, $02, $02, $02
    .byte $00, $01, $00, $01, $01, $01, $01, $01, $00, $00, $01, $00, $01, $01, $01, $01
    .byte $02, $02, $04, $02, $02, $00, $04, $00, $02, $02, $04, $04, $04, $04, $04, $04
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $55, $41, $51, $42, $41, $51, $45, $33, $35, $51, $35, $51, $25, $25, $25, $25
    .byte $45, $41, $32, $31, $31, $31, $31, $31, $51, $51, $51, $51, $51, $51, $51, $51

Bank2_Func_8F55:
    LDA #$00
    STA a:$0670,X
    LDA $C4
    ASL A
    TAY
    LDA a:$8F6C,Y
    STA $40
    LDA a:$8F6D,Y
    STA $41
    JSR Bank2_Func_931F
    RTS
    .byte $8C, $8F, $A3, $8F, $BF, $8F, $DB, $8F, $28, $90, $2E, $90, $2F, $90, $44, $90
    .byte $71, $90, $AA, $90, $AB, $90, $AE, $90, $AF, $90, $B2, $90, $B2, $90, $B2, $90
    .byte $A5, $DF, $C9, $10, $90, $10, $C9, $28, $B0, $07, $20, $53, $B1, $29, $01, $D0
    .byte $05, $A9, $A4, $9D, $28, $06, $60, $A5, $DF, $C9, $18, $90, $15, $C9, $30, $B0
    .byte $07, $20, $53, $B1, $29, $01, $D0, $0A, $A9, $A8, $9D, $28, $06, $A9, $01, $9D
    .byte $30, $06, $60, $A9, $80, $9D, $08, $06, $A9, $98, $9D, $10, $06, $A9, $01, $9D
    .byte $00, $06, $20, $53, $B1, $29, $40, $F0, $05, $A9, $09, $20, $EB, $A5, $60, $A4
    .byte $DF, $B9, $E8, $8F, $F0, $05, $A9, $B4, $9D, $28, $06, $60, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $00, $00, $00, $00
    .byte $00, $01, $01, $01, $00, $00, $00, $00, $00, $01, $01, $01, $A9, $01, $9D, $70
    .byte $06, $60, $60, $20, $53, $B1, $C9, $64, $B0, $0D, $A9, $20, $9D, $28, $06, $20
    .byte $53, $B1, $29, $02, $9D, $A0, $06, $60, $A5, $DF, $C9, $26, $D0, $07, $A5, $56
    .byte $D0, $1D, $4C, $5B, $90, $A5, $DF, $C9, $3B, $D0, $19, $A5, $57, $D0, $10, $A9
    .byte $B0, $9D, $08, $06, $A9, $A8, $9D, $10, $06, $A9, $01, $9D, $00, $06, $60, $A9
    .byte $00, $9D, $00, $06, $60, $A5, $DF, $C9, $27, $F0, $0D, $C9, $28, $F0, $10, $C9
    .byte $34, $F0, $13, $A9, $03, $4C, $51, $AF, $A5, $58, $F0, $11, $4C, $A4, $90, $A5
    .byte $59, $F0, $0A, $4C, $A4, $90, $A5, $5A, $F0, $03, $4C, $A4, $90, $20, $8C, $AC
    .byte $90, $06, $A9, $03, $8D, $AA, $02, $60, $A9, $00, $9D, $00, $06, $60, $60, $20
    .byte $15, $AC, $60, $20, $B3, $90, $60, $A0, $00, $4C, $BD, $90, $20, $04, $91, $90
    .byte $36, $20, $68, $8B, $B9, $F4, $90, $9D, $00, $06, $B9, $F8, $90, $9D, $08, $06
    .byte $B9, $FC, $90, $9D, $10, $06, $B9, $00, $91, $9D, $38, $06, $84, $42, $A8, $B9
    .byte $D5, $8E, $9D, $28, $06, $A4, $42, $A9, $1E, $9D, $68, $06, $AD, $C1, $8E, $9D
    .byte $98, $06, $C8, $C0, $04, $D0, $C5, $60, $03, $03, $03, $03, $28, $D8, $28, $D8
    .byte $30, $30, $C0, $C0, $0C, $0D, $0E, $0F

Bank2_Func_9104:
    LDX #$00

Bank2_Label_9106:
    LDA a:$0600,X
    BEQ Bank2_Label_9112
    INX
    CPX #$08
    BNE Bank2_Label_9106
    CLC
    RTS

Bank2_Label_9112:
    SEC
    RTS

Bank2_Func_9114:
    STX $3C
    JSR Bank2_Func_9104
    BCS Bank2_Label_911F

Bank2_Label_911B:
    LDX $3C
    CLC
    RTS

Bank2_Label_911F:
    JSR Bank2_Func_8B68
    TXA
    TAY
    LDX $3C
    LDA a:$0670,X
    BEQ Bank2_Label_911B
    LSR A
    STA a:$0670,X
    LDA #$01
    STA a:$0600,Y
    JSR Bank2_Func_B153
    AND #$08
    SEC
    SBC #$04
    CLC
    ADC a:$0608,X
    STA a:$0608,Y
    JSR Bank2_Func_B153
    AND #$08
    SEC
    SBC #$04
    CLC
    ADC a:$0610,X
    STA a:$0610,Y
    LDA a:$0628,X
    STA a:$0628,Y
    LDA a:$0630,X
    STA a:$0630,Y
    LDA a:$0638,X
    STA a:$0638,Y
    LDA a:$0640,X
    STA a:$0640,Y
    LDA a:$0648,X
    STA a:$0648,Y
    LDA a:$0650,X
    STA a:$0650,Y
    LDA a:$0658,X
    STA a:$0658,Y
    LDA a:$0660,X
    STA a:$0660,Y
    LDA a:$0670,X
    STA a:$0670,Y
    LDA a:$8EB9
    STA a:$0698,Y
    LDX $3C
    SEC
    RTS
