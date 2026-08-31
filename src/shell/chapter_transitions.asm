; Doraemon PRG bank 3 $8C3B-$8FF1
; World transitions and interstitial cutscenes
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank3_Func_8C3B:
    LDA #$80
    BNE Bank3_Label_8C45

Bank3_World1ToWorld2Transition:
    LDA #$00
    BEQ Bank3_Label_8C45

Bank3_World2ToWorld3Transition:
    LDA #$01

Bank3_Label_8C45:
    STA $08
    LDX #$7F
    TXS
    LDA #$00
    STA a:$02AA
    JSR Bank3_Func_80DA
    LDA #$03
    JSR Bank3_Func_81AA
    JSR Bank3_Func_9152
    LDA #$BC
    STA $00
    LDA #$AD
    STA $01
    LDA #$20
    STA a:$2006
    LDY #$00
    STY a:$2006
    LDX #$04

Bank3_Label_8C6E:
    LDA ($00),Y
    STA a:$2007
    INY
    BNE Bank3_Label_8C6E
    INC $01
    DEX
    BNE Bank3_Label_8C6E
    LDA #$D4
    STA $00
    LDA #$8E
    STA $01
    JSR Bank3_Func_90C4
    JSR Bank3_Func_90D1
    LDA $19
    AND #$E7
    ORA #$08
    STA $19
    LDX #$00
    STX $1B
    STX $1C
    STX $07
    STX $06
    STX $05
    STX a:$0406
    INX
    STX $09
    LDA #$00
    STA a:$0409
    STA a:$040C
    LDA #$70
    STA a:$040A
    LDA #$80
    STA a:$040B
    LDA #$15
    JSR Audio_QueueEffect
    LDA #$00
    STA $16
    JSR Bank3_Func_80FD

Bank3_Label_8CC1:
    JSR Bank3_Func_8F5A
    JSR Bank3_Func_8CE6
    JSR Bank3_Func_8D3A
    JSR Bank3_Func_8DB1
    LDA a:$0406
    BEQ Bank3_Label_8CC1
    LDA #$00
    JSR Audio_QueueEffect
    LDA $08
    BMI Bank3_Label_8CE3
    BNE Bank3_Label_8CE0
    JMP Bank3_Func_800B

Bank3_Label_8CE0:
    JMP Bank3_Func_8016

Bank3_Label_8CE3:
    JMP Bank3_Func_8000

Bank3_Func_8CE6:
    LDA #$01
    STA a:$0408
    LDA $16
    AND #$7F
    BNE Bank3_Label_8CFB
    INC $05
    LDX $05
    LDA a:$8D36,X
    JSR Audio_QueueEffect

Bank3_Label_8CFB:
    LDX $05
    CPX #$04
    BCC Bank3_Label_8D08
    LDA #$01
    STA a:$0406
    LDX #$03

Bank3_Label_8D08:
    LDA $06
    CLC
    ADC a:$8D2E,X
    STA $06
    LDA $07
    ADC a:$8D32,X
    AND #$03
    STA $07
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    TAX
    LDY #$00

Bank3_Label_8D21:
    LDA a:$8ED4,X
    STA a:$0210,Y
    INX
    INY
    CPY #$20
    BCC Bank3_Label_8D21
    RTS
    .byte $20, $40, $80, $00, $00, $00, $00, $01, $15, $16, $17, $18

Bank3_Func_8D3A:
    LDA $05
    CMP #$03
    BCS Bank3_Label_8D7A
    LDA $16
    LSR A
    BCS Bank3_Label_8D5A
    LDX a:$0409
    INX
    TXA
    AND #$0F
    TAX
    STX a:$0409
    LDA a:$040A
    CLC
    ADC a:$8DA1,X
    STA a:$040A

Bank3_Label_8D5A:
    LDA $05
    BEQ Bank3_Label_8D79
    TAX
    LDA $16
    AND #$01
    ASL A
    CPX #$01
    BNE Bank3_Label_8D6E
    SEC
    SBC #$01
    JMP Bank3_Label_8D72

Bank3_Label_8D6E:
    ASL A
    SEC
    SBC #$02

Bank3_Label_8D72:
    CLC
    ADC a:$040B
    STA a:$040B

Bank3_Label_8D79:
    RTS

Bank3_Label_8D7A:
    LDA $16
    AND #$07
    BNE Bank3_Label_8D8B
    LDX a:$040C
    CPX #$03
    BCS Bank3_Label_8D9A
    INX
    STX a:$040C

Bank3_Label_8D8B:
    LDX a:$040C
    LDA a:$8D9B,X
    STA a:$040A
    LDA a:$8D9E,X
    STA a:$040B

Bank3_Label_8D9A:
    RTS
    .byte $70, $78, $7C, $80, $84, $80, $01, $01, $01, $01, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $01, $01, $01, $01

Bank3_Func_8DB1:
    LDA a:$040C
    CMP #$03
    BCS Bank3_Label_8D9A
    ASL A
    TAX
    LDA a:$8DF3,X
    STA $00
    LDA a:$8DF4,X
    STA $01
    JSR Bank3_Func_8E05
    LDA $08
    BMI Bank3_Label_8D9A
    LDA a:$040C
    ASL A
    TAX
    LDA a:$8DFF,X
    STA $00
    LDA a:$8E00,X
    STA $01
    JSR Bank3_Func_8E05
    LDA $08
    BEQ Bank3_Label_8D9A
    LDA a:$040C
    ASL A
    TAX
    LDA a:$8DF9,X
    STA $00
    LDA a:$8DFA,X
    STA $01
    JMP Bank3_Func_8E05
    .byte $33, $8E, $68, $8E, $79, $8E, $7E, $8E, $A3, $8E, $B4, $8E, $B9, $8E, $C6, $8E
    .byte $CF, $8E

Bank3_Func_8E05:
    LDY #$00

Bank3_Label_8E07:
    LDA ($00),Y
    BEQ Bank3_Label_8D9A
    AND #$FC
    TAX
    LDA ($00),Y
    AND #$03
    STA a:$0302,X
    INY
    LDA ($00),Y
    STA a:$0301,X
    LDA a:$040A
    CLC
    INY
    ADC ($00),Y
    STA a:$0303,X
    LDA a:$040B
    CLC
    INY
    ADC ($00),Y
    STA a:$0300,X
    INY
    JMP Bank3_Label_8E07
    .byte $CD, $0E, $10, $00, $D1, $0F, $18, $00, $D5, $1D, $08, $08, $D9, $1E, $10, $08
    .byte $DD, $2F, $18, $08, $E0, $2C, $00, $10, $E5, $2D, $08, $10, $E9, $2E, $10, $10
    .byte $ED, $2F, $18, $10, $F2, $3C, $00, $18, $F6, $3D, $08, $18, $FA, $3E, $10, $18
    .byte $FE, $3F, $18, $18, $00, $CD, $0A, $00, $00, $D1, $0B, $08, $00, $D5, $1A, $00
    .byte $08, $D9, $1B, $08, $08, $00, $CD, $1C, $00, $00, $00, $A8, $07, $00, $08, $AC
    .byte $08, $08, $08, $B0, $09, $10, $08, $B4, $17, $00, $10, $B8, $18, $08, $10, $BC
    .byte $19, $10, $10, $C0, $27, $00, $18, $C4, $28, $08, $18, $C8, $29, $10, $18, $00
    .byte $A8, $2A, $00, $00, $AC, $2B, $08, $00, $B0, $3A, $00, $08, $B4, $3B, $08, $08
    .byte $00, $A8, $0C, $00, $00, $00, $98, $60, $18, $08, $9C, $63, $18, $10, $A0, $78
    .byte $18, $18, $00, $98, $1F, $08, $00, $9C, $6F, $08, $08, $00, $98, $0D, $00, $00
    .byte $00, $05, $15, $25, $35, $05, $15, $25, $35, $05, $15, $25, $35, $05, $15, $25
    .byte $35, $05, $0F, $26, $30, $05, $0F, $26, $21, $05, $01, $26, $29, $05, $00, $10
    .byte $20, $35, $05, $15, $25, $35, $15, $25, $35, $35, $15, $25, $35, $35, $15, $25
    .byte $35, $35, $0F, $26, $30, $35, $0F, $26, $21, $35, $01, $26, $29, $35, $00, $10
    .byte $20, $25, $35, $05, $15, $25, $15, $25, $35, $25, $15, $25, $35, $25, $15, $25
    .byte $35, $25, $0F, $26, $30, $25, $0F, $26, $21, $25, $01, $26, $29, $25, $00, $10
    .byte $20, $15, $25, $35, $05, $15, $15, $25, $35, $15, $15, $25, $35, $15, $15, $25
    .byte $35, $15, $0F, $26, $30, $15, $0F, $26, $21, $15, $01, $26, $29, $15, $00, $10
    .byte $20, $AD, $80, $01, $D0, $FB, $60

Bank3_Func_8F5A:
    LDA $16

Bank3_Label_8F5C:
    CMP $16
    BEQ Bank3_Label_8F5C
    RTS
    .byte $A9, $00

Bank3_Func_8F63:
    PHA
    LDA $19
    AND #$FB
    STA a:$2000
    LDA #$20
    STA a:$2006
    LDA #$00
    STA a:$2006
    LDY #$00
    LDX #$08
    PLA

Bank3_Label_8F7A:
    STA a:$2007
    DEY
    BNE Bank3_Label_8F7A
    DEX
    BNE Bank3_Label_8F7A
    RTS

Bank3_Func_8F84:
    LDA $19
    AND #$FB
    STA $19
    STA a:$2000

Bank3_Label_8F8D:
    LDY #$00
    LDA ($00),Y
    BEQ Bank3_Label_8FC7
    STA a:$2006
    INY
    LDA ($00),Y
    STA a:$2006
    INY
    LDA ($00),Y
    TAX
    INY
    PHA
    TYA
    LDY #$00
    CLC
    ADC $00
    STA $00
    BCC Bank3_Label_8FAE
    INC $01

Bank3_Label_8FAE:
    LDA ($00),Y
    STA a:$2007
    INY
    DEX
    BNE Bank3_Label_8FAE
    PLA
    BEQ Bank3_Label_8FC2
    TYA
    CLC
    ADC $00
    STA $00
    BCC Bank3_Label_8F8D

Bank3_Label_8FC2:
    INC $01
    JMP Bank3_Label_8F8D

Bank3_Label_8FC7:
    RTS
    .byte $A9, $01, $85, $00, $85, $01, $A5, $21, $25, $00, $F0, $0D, $25, $22, $D0, $11
    .byte $A5, $22, $05, $00, $85, $22, $A5, $01, $60, $A5, $00, $49, $FF, $25, $22, $85
    .byte $22, $E6, $01, $06, $00, $90, $DF, $A9, $00, $60
