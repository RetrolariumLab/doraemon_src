; Doraemon PRG bank 2 $A0C4-$A5DE
; World 3 hierarchical map lookup, tile collision, and interaction state
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank2_Func_A0C4:
    TXA
    LSR A
    LSR A
    LSR A
    STA $40
    TYA
    LSR A
    LSR A
    LSR A
    STA $41
    JSR Bank2_Func_A904
    LDX #$00
    STX $09
    LDA $41
    AND #$FC
    ASL A
    ROL $09
    ASL A
    ROL $09
    ASL A
    ROL $09
    ASL A
    ROL $09
    CLC
    ADC $84
    STA $08
    LDA $09
    ADC $85
    STA $09
    LDA $40
    LSR A
    LSR A
    TAY
    LDA ($08),Y
    LDX #$00
    STX $3D
    ASL A
    ROL $3D
    ASL A
    ROL $3D
    CLC
    ADC #$F2
    STA $3C
    LDA $3D
    ADC #$E2
    STA $3D
    LDA $41
    AND #$02
    STA $08
    LDA $40
    AND #$02
    LSR A
    ORA $08
    TAY
    LDA ($3C),Y
    LDX #$00
    STX $3D
    ASL A
    ROL $3D
    ASL A
    ROL $3D
    CLC
    ADC #$F2
    STA $3C
    LDA $3D
    ADC #$DE
    STA $3D
    LDA $41
    AND #$01
    ASL A
    STA $08
    LDA $40
    AND #$01
    ORA $08
    TAY
    LDA ($3C),Y
    RTS

Bank2_Label_A144:
    INC a:$0703,X
    LDA a:$0703,X
    AND #$03
    BNE Bank2_Label_A1C0
    INC a:$0701,X
    LDA a:$0701,X
    CMP #$A3
    BNE Bank2_Label_A1C0
    LDA #$00
    STA a:$06F9,X
    JMP Bank2_Label_A1C0

Bank2_Func_A160:
    LDA #$00
    STA $07
    LDA #$02
    STA $06

Bank2_Label_A168:
    LDX $07
    LDA a:$06F9,X
    BEQ Bank2_Label_A1C0
    CMP #$02
    BEQ Bank2_Label_A144
    LDA a:$06FB,X
    STA $46
    LDA a:$06FD,X
    STA $47
    JSR Bank2_Func_9FDB
    BCS Bank2_Label_A19B
    LDX $07
    LDA #$02
    STA a:$06F9,X
    LDA #$00
    STA a:$0703,X
    LDA #$A0
    STA a:$0701,X
    LDA #$02
    JSR Bank2_Func_A5DF
    JMP Bank2_Label_A1C0

Bank2_Label_A19B:
    LDA a:$06FF,X
    BNE Bank2_Label_A1AE
    LDA a:$06FB,X
    SEC
    SBC #$03
    STA a:$06FB,X
    BCS Bank2_Label_A1C0
    JMP Bank2_Label_A1BB

Bank2_Label_A1AE:
    LDA a:$06FB,X
    CLC
    ADC #$03
    STA a:$06FB,X
    CMP #$F0
    BCC Bank2_Label_A1C0

Bank2_Label_A1BB:
    LDA #$00
    STA a:$06F9,X

Bank2_Label_A1C0:
    INC $07
    DEC $06
    BNE Bank2_Label_A168
    RTS

Bank2_Func_A1C7:
    LDA #$00
    STA $00
    LDA #$02
    STA $01

Bank2_Label_A1CF:
    LDX $00
    LDA a:$06F9,X
    BEQ Bank2_Label_A1ED
    LDA a:$0701,X
    STA $79
    LDA a:$06FD,X
    TAY
    LDA a:$06FB,X
    TAX
    JSR Bank2_Func_A71A
    LDA #$00
    STA $7A
    JSR Bank2_Func_B4B6

Bank2_Label_A1ED:
    INC $00
    DEC $01
    BNE Bank2_Label_A1CF
    RTS

Bank2_Func_A1F4:
    LDX #$00
    TXA

Bank2_Label_A1F7:
    STA $8E,X
    INX
    CPX #$10
    BNE Bank2_Label_A1F7
    LDA #$01
    STA $8E
    LDA #$0E
    STA $97
    LDA #$07
    STA $94
    LDA #$01
    STA $95
    LDA #$03
    STA $90
    RTS

Bank2_Func_A213:
    LDA #$08
    SEC
    SBC $2C
    ASL A
    ASL A
    STA $2B
    RTS

Bank2_Func_A21D:
    LDA $8E
    ASL A
    TAX
    LDA a:$A22F,X
    STA $40
    LDA a:$A230,X
    STA $41
    JSR Bank2_Func_931F
    RTS
    .byte $39, $A2, $35, $A3, $3C, $A3, $E9, $A2, $3A, $A2, $60, $E6, $93, $A5, $93, $29
    .byte $07, $D0, $06, $A5, $91, $49, $01, $85, $91, $A4, $97, $C0, $0E, $F0, $02, $E6
    .byte $97, $B9, $63, $A5, $30, $06, $18, $65, $8D, $4C, $62, $A2, $18, $65, $8D, $B0
    .byte $02, $A9, $00, $85, $8D, $C9, $F0, $90, $24, $AD, $AA, $02, $D0, $FB

Bank2_Func_A26D:
    LDA #$3C
    STA $68
    JSR Bank2_Func_B1BB
    LDA #$00
    STA $4D
    LDA $2A
    BEQ Bank2_Label_A2BE
    DEC $2A
    LDA $DC
    BEQ Bank2_Func_A285
    JMP Bank2_Label_82C3

Bank2_Func_A285:
    LDA $53
    BNE Bank2_Func_A28D
    JMP Bank2_Label_834C
    .byte $60

Bank2_Func_A28D:
    LDA #$00
    STA $53
    JSR World3_SaveRoomObjectsState0
    JSR World3_SaveRoomObjectsState1
    LDA $54
    STA $DF
    LDA $DF
    CMP #$11
    BNE Bank2_Label_A2A5
    LDA #$01
    STA $9F

Bank2_Label_A2A5:
    JSR Bank2_Func_A733
    LDY #$00

Bank2_Label_A2AA:
    LDA a:$0725,Y
    STA a:$008C,Y
    INY
    CPY #$12
    BNE Bank2_Label_A2AA
    JSR Bank2_Func_A213
    LDA $A5
    STA a:AudioMusicState
    RTS

Bank2_Label_A2BE:
    LDA $DC
    BEQ Bank2_Label_A2C5
    JMP Bank2_Func_8048

Bank2_Label_A2C5:
    JSR Bank2_Func_8065

Bank2_Label_A2C8:
    LDA CombinedControllerButtons
    AND #$10
    BEQ Bank2_Label_A2C8
    JSR Bank2_Func_A2D4
    JMP Bank2_Func_A285

Bank2_Func_A2D4:
    LDX #$00
    LDA #$00

Bank2_Label_A2D8:
    STA a:ScoreDigitsWorking,X
    INX
    CPX #$08
    BNE Bank2_Label_A2D8
    LDA #$02
    STA $2A
    LDA #$02
    STA $2C
    RTS
    .byte $20, $B4, $A3, $20, $72, $A5, $A4, $9B, $B9, $2E, $A3, $85, $43, $D0, $10, $A9
    .byte $01, $85, $8E, $A4, $95, $B9, $85, $A4, $85, $90, $A9, $00, $85, $91, $60, $E6
    .byte $9B, $A5, $95, $F0, $10, $20, $9E, $A4, $C6, $43, $D0, $F9, $A9, $00, $85, $91
    .byte $A9, $0B, $85, $90, $60, $20, $B4, $A4, $C6, $43, $D0, $F9, $A9, $01, $85, $91
    .byte $A9, $0B, $85, $90, $60, $04, $03, $03, $02, $02, $02, $00, $20, $B4, $A3, $20
    .byte $72, $A5, $60, $20, $43, $A3, $20, $72, $A5, $60, $A4, $97, $B9, $9C, $A3, $10
    .byte $14, $A5, $8A, $D0, $06, $A5, $8D, $C9, $08, $90, $05, $20, $3B, $9E, $B0, $05
    .byte $A9, $0E, $85, $97, $60, $20, $8F, $9E, $A5, $9E, $C9, $00, $D0, $14, $A9, $01
    .byte $85, $8E, $A4, $95, $B9, $85, $A4, $85, $90, $A9, $00, $85, $91, $A9, $0E, $85
    .byte $97, $60, $20, $87, $A4, $A4, $97, $B9, $9C, $A3, $85, $08, $C9, $04, $F0, $0B
    .byte $A5, $99, $F0, $05, $C6, $99, $4C, $94, $A3, $E6, $97, $A5, $8D, $18, $65, $08
    .byte $85, $8D, $60, $FC, $FD, $FD, $FE, $FE, $FE, $FF, $FF, $FF, $FF, $00, $00, $00
    .byte $00, $01, $01, $01, $01, $02, $02, $02, $03, $03, $04, $A5, $92, $F0, $16, $E6
    .byte $93, $A5, $93, $29, $0F, $D0, $0B, $A9, $00, $85, $92, $A4, $95, $B9, $85, $A4
    .byte $85, $90, $4C, $E0, $A3, $E6, $93, $A5, $93, $25, $94, $D0, $0A, $A5, $91, $D0
    .byte $04, $A9, $03, $85, $91, $C6, $91, $20, $F7, $A5, $29, $08, $D0, $0B, $A9, $07
    .byte $85, $94, $A9, $00, $85, $61, $4C, $2B, $A4, $A5, $61, $F0, $09, $E6, $61, $C9
    .byte $0A, $F0, $EF, $4C, $2B, $A4, $E6, $61, $A5, $92, $D0, $07, $A4, $95, $B9, $85
    .byte $A4, $85, $90, $A9, $03, $85, $94, $A4, $97, $C0, $0E, $D0, $07, $A9, $00, $85
    .byte $99, $4C, $27, $A4, $A5, $99, $C9, $14, $B0, $04, $E6, $99, $E6, $99, $A9, $00
    .byte $85, $97, $20, $CE, $A4, $20, $65, $9E, $B0, $16, $20, $F7, $A5, $29, $03, $D0
    .byte $0F, $A5, $92, $D0, $08, $A9, $08, $85, $90, $A9, $00, $85, $91, $4C, $57, $A4
    .byte $20, $F7, $A5, $29, $02, $D0, $0E, $20, $F7, $A5, $29, $01, $D0, $1A, $A9, $00
    .byte $85, $96, $4C, $81, $A4, $A5, $92, $D0, $04, $A9, $00, $85, $90, $A9, $00, $85
    .byte $95, $A9, $01, $85, $96, $4C, $81, $A4, $A5, $92, $D0, $04, $A9, $03, $85, $90
    .byte $A9, $01, $85, $95, $A9, $01, $85, $96, $20, $87, $A4, $60, $00, $03, $E6, $9C
    .byte $A5, $9C, $29, $01, $D0, $03, $20, $92, $A4, $A5, $96, $F0, $07, $A5, $95, $F0
    .byte $04, $4C, $B4, $A4, $60, $20, $E5, $9D, $B0, $05, $A9, $00, $85, $96, $60, $C6
    .byte $8C, $D0, $07, $A9, $EC, $85, $8C, $20, $19, $A6, $60, $20, $0F, $9E, $B0, $05
    .byte $A9, $00, $85, $96, $60, $E6, $8C, $A5, $8C, $C9, $F0, $D0, $07, $A9, $04, $85
    .byte $8C, $20, $3A, $A6, $60, $A4, $97, $C0, $0E, $F0, $02, $E6, $97, $B9, $63, $A5
    .byte $85, $A7, $F0, $05, $10, $50, $4C, $E3, $A4, $60, $E6, $9D, $A5, $9D, $29, $01
    .byte $D0, $03, $20, $EE, $A4, $20, $3B, $9E, $B0, $05, $A9, $0E, $85, $97, $60, $20
    .byte $8F, $9E, $A5, $9E, $C9, $14, $D0, $0E, $A9, $02, $85, $8E, $A9, $00, $85, $97
    .byte $A9, $0C, $20, $DF, $A5, $60, $A5, $8D, $18, $65, $A7, $85, $8D, $C9, $08, $B0
    .byte $0C, $A5, $8A, $D0, $09, $A9, $00, $85, $8D, $A9, $0E, $85, $97, $60, $A9, $D0
    .byte $85, $8D, $20, $5D, $A6, $60, $20, $65, $9E, $B0, $05, $A9, $00, $85, $96, $60
    .byte $20, $F7, $A5, $29, $04, $D0, $10, $E6, $98, $A5, $98, $C9, $06, $90, $1A, $A9
    .byte $00, $85, $98, $A9, $01, $85, $A7, $A5, $8D, $18, $65, $A7, $85, $8D, $C9, $D4
    .byte $90, $07, $A9, $0C, $85, $8D, $20, $88, $A6, $60, $FE, $FE, $FE, $FE, $FF, $FF
    .byte $FF, $FF, $00, $00, $00, $00, $00, $00, $02, $20, $F7, $A5, $29, $80, $D0, $03
    .byte $85, $63, $60, $A5, $63, $D0, $FB, $E6, $63, $A9, $01, $85, $92, $A5, $95, $18
    .byte $69, $09, $85, $90, $A9, $00, $85, $91, $A9, $00, $85, $93, $A2, $00, $BD, $F9
    .byte $06, $F0, $06, $E8, $E0, $02, $D0, $F6, $60, $A5, $95, $D0, $0B, $A5, $8C, $C9
    .byte $12, $90, $32, $A0, $F8, $4C, $B9, $A5, $A5, $8C, $C9, $EE, $B0, $27, $A0, $08
    .byte $98, $18, $65, $8C, $9D, $FB, $06, $A5, $8D, $18, $69, $08, $9D, $FD, $06, $A5
    .byte $95, $9D, $FF, $06, $0A, $18, $69, $68, $9D, $01, $07, $A9, $01, $9D, $F9, $06
    .byte $A9, $19, $20, $DF, $A5, $60
