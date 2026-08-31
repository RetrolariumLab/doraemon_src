; Doraemon PRG bank 2 $A8B0-$AE11
; World 3 room updates, entity collision adjustment, and state tables
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank2_Func_A8B0:
    LDX #$00
    STX $02

Bank2_Label_A8B4:
    LDA a:$0480,X
    CMP a:$0705,X
    BEQ Bank2_Label_A8D3
    INC $02
    CMP #$0F
    BNE Bank2_Label_A8CA
    LDA a:$0705,X
    AND #$0F
    JMP Bank2_Label_A8D0

Bank2_Label_A8CA:
    LDA a:$0480,X
    CLC
    ADC #$10

Bank2_Label_A8D0:
    STA a:$0480,X

Bank2_Label_A8D3:
    INX
    CPX #$20
    BNE Bank2_Label_A8B4
    LDX #$80
    LDY #$04
    JSR Bank2_Func_B2A3
    LDA #$03
    STA $68
    JSR Bank2_Func_B1BB
    LDA $02
    BNE Bank2_Func_A8B0
    RTS

Bank2_Func_A8EB:
    JSR Bank2_Func_A904
    LDA #$00
    STA $88
    STA $86
    STA $87
    LDA #$1E
    STA $07

Bank2_Label_A8FA:
    JSR Bank2_Func_A922
    INC $88
    DEC $07
    BNE Bank2_Label_A8FA
    RTS

Bank2_Func_A904:
    LDA $DF
    AND #$F8
    LSR A
    LSR A
    CLC
    ADC #$E6
    STA $85
    LDA $DF
    AND #$07
    ASL A
    ASL A
    ASL A
    CLC
    ADC #$F2
    STA $84
    LDA $85
    ADC #$00
    STA $85
    RTS

Bank2_Func_A922:
    JSR Bank2_Func_A946
    LDX #$00
    LDY $88
    JSR Bank2_Func_B0BA
    LDX #$A0
    LDY #$04
    LDA #$20
    JSR Bank2_Func_B33A
    LDX #$00
    LDY $88
    JSR Bank2_Func_B0F8
    LDX #$C0
    LDY #$04
    LDA #$08
    JSR Bank2_Func_B33A
    RTS

Bank2_Func_A946:
    JSR Bank2_Func_A967
    LDA $87
    EOR #$02
    STA $87
    BNE Bank2_Label_A966
    LDA $86
    EOR #$02
    STA $86
    BNE Bank2_Label_A966
    LDA $84
    CLC
    ADC #$40
    STA $84
    LDA $85
    ADC #$00
    STA $85

Bank2_Label_A966:
    RTS

Bank2_Func_A967:
    LDX #$00
    STX $01

Bank2_Label_A96B:
    LDA #$00
    STA $03
    LDY $01
    LDA ($84),Y
    ASL A
    ROL $03
    ASL A
    ROL $03
    CLC
    ADC #$F2
    STA $02
    LDA $03
    ADC #$E2
    STA $03
    LDA $86
    STA $00
    JSR Bank2_Func_A99C
    INC $00
    JSR Bank2_Func_A99C
    JSR Bank2_Func_A9C5
    INC $01
    LDA $01
    CMP #$08
    BNE Bank2_Label_A96B
    RTS

Bank2_Func_A99C:
    LDA #$00
    STA $05
    LDY $00
    LDA ($02),Y
    ASL A
    ROL $05
    ASL A
    ROL $05
    CLC
    ADC #$F2
    STA $04
    LDA $05
    ADC #$DE
    STA $05
    LDY $87
    LDA ($04),Y
    STA a:$04A0,X
    INX
    INY
    LDA ($04),Y
    STA a:$04A0,X
    INX
    RTS

Bank2_Func_A9C5:
    STX $3E
    LDY $00
    LDA ($02),Y
    TAX
    LDA a:$DDF2,X
    ASL A
    ASL A
    STA $3C
    DEY
    LDA ($02),Y
    TAX
    LDA a:$DDF2,X
    ORA $3C
    STA $3C
    ASL A
    ASL A
    ASL A
    ASL A
    STA $3D
    LDA $88
    AND #$FC
    ASL A
    CLC
    ADC $01
    TAY
    LDA $88
    AND #$02
    BNE Bank2_Label_A9FD
    LDA a:$0400,Y
    AND #$F0
    ORA $3C
    JMP Bank2_Label_AA04

Bank2_Label_A9FD:
    LDA a:$0400,Y
    AND #$0F
    ORA $3D

Bank2_Label_AA04:
    STA a:$0400,Y
    LDY $01
    STA a:$04C0,Y
    LDX $3E
    RTS

Bank2_Func_AA0F:
    PHA
    AND #$0F
    STA $AA
    PLA
    CLC
    ADC #$10
    STA $A9
    LSR A
    LSR A
    LSR A
    LSR A
    CMP $AA
    BNE Bank2_Label_AA26
    LDA $AA
    SEC
    RTS

Bank2_Label_AA26:
    LDA $A9
    CLC
    RTS
    .byte $A5, $8C, $85, $00, $A5, $8D, $85, $01, $A9, $00, $85, $04, $86, $02, $BD, $20
    .byte $06, $38, $E5, $02, $85, $03, $A9, $68, $85, $A2, $A5, $02, $C9, $01, $F0, $04
    .byte $A9, $80, $85, $A2, $20, $52, $AA, $60, $A0, $F2, $BD, $08, $06, $C5, $00, $B0
    .byte $02, $A0, $0E, $98, $18, $65, $00, $85, $08, $A0, $F2, $BD, $10, $06, $C5, $01
    .byte $B0, $02, $A0, $0E, $98, $18, $65, $01, $85, $09, $20, $AA, $AA, $E6, $02, $C6
    .byte $03, $C6, $03, $20, $9E, $AA, $E6, $02, $C6, $03, $D0, $F7, $A6, $02, $BD, $07
    .byte $06, $85, $08, $BD, $0F, $06, $85, $09, $A9, $80, $85, $3E, $A5, $A2, $85, $3F
    .byte $20, $B6, $AA, $60, $A6, $02, $BD, $07, $06, $85, $08, $BD, $0F, $06, $85, $09
    .byte $A6, $02, $BD, $09, $06, $85, $3E, $BD, $11, $06, $85, $3F, $A6, $02, $BD, $08
    .byte $06, $85, $3C, $BD, $10, $06, $85, $3D, $BD, $18, $06, $20, $0F, $AA, $9D, $18
    .byte $06, $90, $23, $20, $F1, $AA, $A6, $02, $A5, $3C, $38, $E5, $3E, $20, $49, $B1
    .byte $85, $40, $A5, $3D, $38, $E5, $3F, $20, $49, $B1, $85, $41, $A5, $3C, $9D, $08
    .byte $06, $A5, $3D, $9D, $10, $06, $60, $A5, $3C, $38, $E5, $08, $20, $49, $B1, $85
    .byte $40, $A5, $3C, $38, $E5, $3E, $20, $49, $B1, $C5, $40, $B0, $08, $A6, $08, $20
    .byte $3B, $AB, $4C, $14, $AB, $A6, $3E, $20, $3B, $AB, $A5, $3D, $38, $E5, $09, $20
    .byte $49, $B1, $85, $40, $A5, $3D, $38, $E5, $3F, $20, $49, $B1, $C5, $40, $B0, $08
    .byte $A4, $09, $20, $47, $AB, $4C, $37, $AB, $A4, $3F, $20, $47, $AB, $38, $60, $18
    .byte $60, $E4, $3C, $F0, $07, $B0, $03, $C6, $3C, $60, $E6, $3C, $60, $C4, $3D, $F0
    .byte $07, $B0, $03, $C6, $3D, $60, $E6, $3D, $60

Bank2_Func_AB53:
    JSR Bank2_Func_B153
    AND #$07
    TAX
    LDA a:$06F1,X
    CMP #$FF
    BEQ Bank2_Label_AB9D
    STA $3E
    LSR A
    LSR A
    LSR A
    CMP $8A
    BEQ Bank2_Label_AB7F
    BCC Bank2_Label_AB75
    LDA $3E
    SEC
    SBC #$08
    STA $3E
    JMP Bank2_Label_AB7C

Bank2_Label_AB75:
    LDA $3E
    CLC
    ADC #$08
    STA $3E

Bank2_Label_AB7C:
    JSR Bank2_Func_AB9E

Bank2_Label_AB7F:
    LDA $3E
    AND #$07
    CMP $89
    BEQ Bank2_Label_AB9D
    BCC Bank2_Label_AB93
    LDA $3E
    SEC
    SBC #$01
    STA $3E
    JMP Bank2_Label_AB9A

Bank2_Label_AB93:
    LDA $3E
    CLC
    ADC #$01
    STA $3E

Bank2_Label_AB9A:
    JSR Bank2_Func_AB9E

Bank2_Label_AB9D:
    RTS

Bank2_Func_AB9E:
    LDY $3E
    LDA a:$ABB9,Y
    BNE Bank2_Label_ABB8
    LDY #$00

Bank2_Label_ABA7:
    LDA $3E
    CMP a:$06F1,Y
    BEQ Bank2_Label_ABB8
    INY
    CPY #$08
    BNE Bank2_Label_ABA7
    LDA $3E
    STA a:$06F1,X

Bank2_Label_ABB8:
    RTS
    .byte $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $01, $01, $00, $01, $00, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $01, $01, $00, $00, $00, $01, $01, $00, $00, $00, $00, $01, $01, $01
    .byte $00, $00, $00, $00, $01, $01, $01, $01, $00, $00, $00, $00, $01, $01, $01, $01

Bank2_Func_ABF9:
    LDA #$00
    STA $51
    LDX #$00

Bank2_Label_ABFF:
    LDA a:$06F1,X
    CMP $DF
    BEQ Bank2_Label_AC0C
    INX
    CPX #$08
    BNE Bank2_Label_ABFF
    RTS

Bank2_Label_AC0C:
    LDA #$00
    STA $51
    JSR Bank2_Func_9104
    BCC Bank2_Label_AC6B
    LDA #$00
    STA $51
    LDA #$00
    STA $C9
    STA $CA
    LDA #$00
    STA $51
    CPX #$06
    BCS Bank2_Label_AC6B
    STX $C8
    LDA #$01
    STA $51
    LDY #$00

Bank2_Label_AC2F:
    JSR Bank2_Func_8B68
    LDA a:$AC6C,Y
    STA a:$0600,X
    LDA a:$AC74,Y
    CLC
    ADC $C9
    STA a:$0608,X
    LDA a:$AC7C,Y
    CLC
    ADC $CA
    STA a:$0610,X
    LDA a:$AC84,Y
    STA a:$0638,X
    STY $42
    TAY
    LDA a:$8ED5,Y
    STA a:$0628,X
    LDY $42
    LDA #$1E
    STA a:$0668,X
    INY
    INX
    CPX #$08
    BNE Bank2_Label_AC2F
    LDA #$03
    STA a:$02AA

Bank2_Label_AC6B:
    RTS
    .byte $03, $03, $03, $03, $03, $03, $03, $03, $68, $62, $68, $72, $7E, $88, $8E, $88
    .byte $88, $7C, $70, $68, $68, $70, $7C, $88, $0A, $0B, $0B, $0B, $0B, $0B, $0B, $0B
    .byte $A9, $00, $85, $3F, $E0, $06, $B0, $18, $20, $AE, $AC, $A4, $40, $8A, $99, $20
    .byte $06, $E0, $06, $B0, $09, $20, $AE, $AC, $A4, $40, $8A, $99, $20, $06, $38, $60
    .byte $18, $60, $86, $40, $A9, $04, $85, $41, $20, $68, $8B, $A4, $3F, $B9, $F9, $AC
    .byte $9D, $00, $06, $B9, $01, $AD, $9D, $08, $06, $B9, $09, $AD, $9D, $10, $06, $B9
    .byte $11, $AD, $9D, $38, $06, $84, $42, $A8, $B9, $D5, $8E, $9D, $28, $06, $A4, $42
    .byte $AD, $BD, $8E, $9D, $98, $06, $B9, $19, $AD, $9D, $18, $06, $A9, $1E, $9D, $68
    .byte $06, $E6, $3F, $E8, $E0, $08, $F0, $04, $C6, $41, $D0, $BC, $60, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $68, $62, $68, $72, $64, $6C, $74, $74, $88, $7C, $70
    .byte $68, $92, $88, $80, $80, $08, $09, $09, $09, $08, $09, $09, $09, $01, $01, $02
    .byte $02, $02, $02, $03, $03, $A6, $C8, $BD, $80, $06, $D0, $30, $20, $53, $B1, $29
    .byte $20, $09, $10, $9D, $80, $06, $20, $53, $B1, $29, $01, $9D, $70, $06, $20, $53
    .byte $B1, $29, $C0, $09, $10, $DD, $50, $06, $F0, $F4, $9D, $50, $06, $20, $53, $B1
    .byte $29, $C0, $09, $10, $DD, $58, $06, $F0, $F4, $9D, $58, $06, $DE, $80, $06, $BD
    .byte $08, $06, $85, $3C, $BD, $10, $06, $85, $3D, $BD, $70, $06, $F0, $0B, $BD, $58
    .byte $06, $A8, $BD, $50, $06, $AA, $4C, $79, $AD, $A6, $8C, $A4, $8D, $20, $3B, $AB
    .byte $20, $47, $AB, $A6, $C8, $A5, $3C, $9D, $08, $06, $A5, $3D, $9D, $10, $06, $86
    .byte $05, $A6, $05, $BD, $09, $06, $85, $3C, $BD, $11, $06, $85, $3D, $BD, $10, $06
    .byte $A8, $BD, $08, $06, $AA, $8A, $38, $E5, $3C, $20, $49, $B1, $C9, $06, $90, $03
    .byte $20, $3B, $AB, $98, $38, $E5, $3D, $20, $49, $B1, $C9, $06, $90, $03, $20, $47
    .byte $AB, $A6, $05, $A5, $3C, $9D, $09, $06, $A5, $3D, $9D, $11, $06, $E6, $05, $A5
    .byte $05, $C9, $07, $D0, $BC, $60, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01
    .byte $01, $00, $01, $01, $01, $00, $02, $02, $0A, $02, $01, $02, $02, $02, $03, $03
    .byte $03, $02, $03, $03, $03, $03, $04, $04, $04, $04, $04, $04, $05, $05, $06, $04
    .byte $04, $06, $06, $07, $06, $06, $06, $06, $06, $06, $07, $07, $09, $09, $08, $08
    .byte $08, $08, $08, $0A, $0A, $0A
