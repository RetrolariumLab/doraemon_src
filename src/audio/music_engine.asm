; Doraemon PRG bank 3 $9ED8-$A30E
; Four-channel music sequencer and stream interpreter
; Generated deterministically from pinned Ghidra/GhidraNes facts

Audio_UpdateMusic:
    LDA a:$02AB
    BNE Bank3_Label_9EA4
    LDA a:$02AA
    BEQ Bank3_Label_9EC9
    BPL Bank3_Label_9EE7
    JMP Bank3_Label_9F6B

Bank3_Label_9EE7:
    LDA a:$02AA
    CMP #$05
    BCC Bank3_Label_9EF1
    JMP Bank3_Label_9F95

Bank3_Label_9EF1:
    ORA #$80
    STA a:$02AA
    ASL A
    ASL A
    ASL A
    TAY
    LDX #$07

Bank3_Label_9EFC:
    LDA a:$A4D5,Y
    STA $2F,X
    STA a:$02DC,X
    DEY
    DEX
    BPL Bank3_Label_9EFC
    STX a:$02B4
    STX a:$02B5
    STX a:$02B6
    STX a:$02B7
    INX
    STX $46
    STX $47
    STX $48
    STX a:$02EC
    STX a:$02ED
    STX a:$02EE
    STX a:$02EF
    STX a:$02F0
    STX a:$02F1
    STX a:$02F2
    STX a:$02FC
    STX a:$02F6
    INX
    STX a:$02B0
    STX a:$02B1
    STX a:$02B2
    STX a:$02B3
    STX a:$02AC
    STX a:$02AD
    STX a:$02AE
    STX a:$02AF
    LDA #$08
    STA a:$02F7
    STA a:$02F8
    STA a:$02F9
    STA a:$02FA
    LDA #$80
    STA a:$02F3
    STA a:$02F4
    STA a:$02F5
    JSR Audio_ResetChannels

Bank3_Label_9F6B:
    LDA #$00
    STA a:$02FE
    STA a:$02FD

Bank3_Label_9F73:
    LDX a:$02FD
    DEC a:$02B0,X
    BEQ Bank3_Label_9F81
    JSR Bank3_Func_9F9B
    JMP Bank3_Label_9F84

Bank3_Label_9F81:
    JSR Bank3_Func_9FE7

Bank3_Label_9F84:
    INC a:$02FD
    LDA a:$02FD
    CMP #$04
    BCC Bank3_Label_9F73
    LDA a:$02FE
    CMP #$04
    BNE Bank3_Label_9F9A

Bank3_Label_9F95:
    LDA #$00
    STA a:$02AA

Bank3_Label_9F9A:
    RTS

Bank3_Func_9F9B:
    CPX #$02
    BEQ Bank3_Label_9FE6
    LDA a:$02F3,X
    AND #$10
    BEQ Bank3_Label_9FE6
    LDA a:$02BC,X
    ASL A
    STA a:$02FF
    BCC Bank3_Label_9FBA
    LDA a:$02B8,X
    SEC
    SBC a:$02FF
    BCS Bank3_Label_9FC5
    BCC Bank3_Label_9FC3

Bank3_Label_9FBA:
    LDA a:$02B8,X
    CLC
    ADC a:$02FF
    BCC Bank3_Label_9FC5

Bank3_Label_9FC3:
    LDA #$00

Bank3_Label_9FC5:
    STA a:$02B8,X
    LDY a:$02A3,X
    BNE Bank3_Label_9FE6
    LSR A
    LSR A
    LSR A
    LSR A
    STA a:$02FF
    TXA
    ASL A
    ASL A
    TAY
    LDA a:$02F3,X
    AND #$D0
    ORA a:$02FF
    STA a:$02F3,X
    STA a:$4000,Y

Bank3_Label_9FE6:
    RTS

Bank3_Func_9FE7:
    LDX a:$02FD
    CPX #$03
    BNE Bank3_Label_9FF6
    LDA a:$02FC
    BEQ Bank3_Label_9FF6
    JMP Bank3_Label_A0FC

Bank3_Label_9FF6:
    JSR Audio_ReadStreamByte
    STA a:$02FF
    TAY
    BMI Bank3_Label_A002
    JMP Bank3_Label_A0E0

Bank3_Label_A002:
    CMP #$EF
    BCC Bank3_Label_A039
    SEC
    LDA #$FF
    SBC a:$02FF
    ASL A
    TAY
    LDA a:$A018,Y
    PHA
    LDA a:$A017,Y
    PHA
    RTS
    .byte $78, $A1, $54, $A2, $8F, $A1, $C8, $A1, $AD, $A1, $F0, $A1, $06, $A2, $19, $A2
    .byte $3E, $A2, $86, $A2, $C8, $A2, $B8, $A2, $A6, $A2, $D5, $A2, $66, $A2, $3F, $A0
    .byte $DD, $A2

Bank3_Label_A039:
    LDA a:$02FF
    AND #$7F
    BPL Bank3_Label_A043
    JSR Audio_ReadStreamByte

Bank3_Label_A043:
    LDX a:$02FD
    STA a:$02AC,X
    LDA a:$02EF,X
    BNE Bank3_Label_A0CA
    LDX a:$02FD
    LDA a:$02AC,X
    STA a:$02FF
    LDX a:$02FD
    CPX #$02
    BEQ Bank3_Label_A0CD
    LDA a:$02F3,X
    AND #$10
    BNE Bank3_Label_A080
    LDA a:$02F3,X
    AND #$D0
    STA a:$02F3,X
    LDA a:$02FF
    LSR A
    CMP #$10
    BCC Bank3_Label_A077
    LDA #$0F

Bank3_Label_A077:
    ORA a:$02F3,X
    STA a:$02F3,X
    JMP Bank3_Label_A08B

Bank3_Label_A080:
    LDY a:$02FF
    LDA a:$A3D6,Y
    ORA #$80
    STA a:$02BC,X

Bank3_Label_A08B:
    LDA a:$02FF
    PHA
    LSR A
    LSR A
    LSR A
    STA a:$02FF
    PLA
    SEC
    SBC a:$02FF
    CMP #$10
    BCS Bank3_Label_A0B9
    ASL A
    ASL A
    ASL A
    ASL A
    ORA #$08
    STA a:$02F7,X
    LDA a:$02F3,X
    AND #$10
    BEQ Bank3_Label_A0CA
    LDA a:$02F7,X
    CMP #$08
    BNE Bank3_Label_A0CA
    LDA #$18
    BNE Bank3_Label_A0C7

Bank3_Label_A0B9:
    LDY #$00

Bank3_Label_A0BB:
    CMP a:$A3A6,Y
    BCS Bank3_Label_A0C4
    INY
    INY
    BNE Bank3_Label_A0BB

Bank3_Label_A0C4:
    LDA a:$A3A7,Y

Bank3_Label_A0C7:
    STA a:$02F7,X

Bank3_Label_A0CA:
    JMP Bank3_Func_9FE7

Bank3_Label_A0CD:
    LDA a:$02FF
    ASL A
    BMI Bank3_Label_A0D8
    ADC a:$02FF
    BPL Bank3_Label_A0DA

Bank3_Label_A0D8:
    LDA #$7F

Bank3_Label_A0DA:
    STA a:$02F5
    JMP Bank3_Label_A0CA

Bank3_Label_A0E0:
    CMP #$00
    BNE Bank3_Label_A0E7
    JMP Bank3_Label_A16F

Bank3_Label_A0E7:
    LDX a:$02FD
    CPX #$03
    BNE Bank3_Label_A12B
    PHA
    AND #$0F
    STA a:$02FC
    PLA
    LSR A
    LSR A
    LSR A
    LSR A
    STA a:$02FB

Bank3_Label_A0FC:
    DEC a:$02FC
    LDA a:$02A6
    BNE Bank3_Label_A16F
    LDA a:$02FB
    BEQ Bank3_Label_A16F
    ASL A
    ASL A
    TAX
    LDY #$00

Bank3_Label_A10E:
    LDA a:$A3B6,X
    STA a:$400C,Y
    INX
    INY
    CPY #$04
    BCC Bank3_Label_A10E
    LDA a:$02F6
    AND #$10
    BEQ Bank3_Label_A161
    LDA a:$02F6
    AND #$1F
    STA a:$400C
    BPL Bank3_Label_A161

Bank3_Label_A12B:
    LDY a:$02A3,X
    BNE Bank3_Label_A16F
    TXA
    ASL A
    ASL A
    TAY
    LDA a:$02F3,X
    STA a:$4000,Y
    LDA #$00
    STA a:$4001,Y
    LDA a:$02FF
    CLC
    ADC a:$A3A3,X
    CLC
    ADC $46,X
    CLC
    ADC a:$02EC,X
    ASL A
    TAX
    LDA a:$A30F,X
    STA a:$4002,Y
    LDA a:$A310,X
    LDX a:$02FD
    ORA a:$02F7,X
    STA a:$4003,Y

Bank3_Label_A161:
    LDX a:$02FD
    LDA a:$02EF,X
    BNE Bank3_Label_A16F
    LDA a:$02B4,X
    STA a:$02B8,X

Bank3_Label_A16F:
    LDX a:$02FD
    LDA a:$02AC,X
    STA a:$02B0,X
    RTS
    .byte $AE, $FD, $02, $A9, $01, $9D, $B0, $02, $8A, $0A, $AA, $B5, $2F, $D0, $02, $D6
    .byte $30, $D6, $2F, $EE, $FE, $02, $60, $20, $01, $A3, $AE, $FD, $02, $9D, $D4, $02
    .byte $A9, $01, $9D, $D8, $02, $8A, $0A, $AA, $B5, $2F, $9D, $C4, $02, $B5, $30, $9D
    .byte $C5, $02, $4C, $E7, $9F, $20, $01, $A3, $AE, $FD, $02, $DD, $D8, $02, $B0, $0D
    .byte $8A, $0A, $AA, $BD, $CC, $02, $95, $2F, $BD, $CD, $02, $95, $30, $4C, $E7, $9F
    .byte $AE, $FD, $02, $BD, $D8, $02, $DD, $D4, $02, $B0, $1A, $FE, $D8, $02, $8A, $0A
    .byte $AA, $B5, $2F, $9D, $CC, $02, $B5, $30, $9D, $CD, $02, $BD, $C4, $02, $95, $2F
    .byte $BD, $C5, $02, $95, $30, $4C, $E7, $9F, $20, $01, $A3, $AE, $FD, $02, $9D, $C0
    .byte $02, $BD, $B4, $02, $9D, $B8, $02, $A9, $FF, $9D, $EF, $02, $D0, $32, $AE, $FD
    .byte $02, $A9, $00, $9D, $EF, $02, $BD, $F3, $02, $29, $CF, $9D, $F3, $02, $4C, $4E
    .byte $A0, $20, $01, $A3, $AE, $FD, $02, $E0, $02, $F0, $A2, $29, $C0, $8D, $FF, $02
    .byte $BD, $F3, $02, $29, $10, $0D, $FF, $02, $9D, $F3, $02, $BD, $EF, $02, $F0, $DE
    .byte $BD, $C0, $02, $4C, $54, $A0, $20, $45, $A2, $4C, $E7, $9F, $AD, $FD, $02, $0A
    .byte $AA, $B5, $2F, $9D, $DC, $02, $B5, $30, $9D, $DD, $02, $60, $AD, $FD, $02, $0A
    .byte $AA, $BD, $DC, $02, $95, $2F, $BD, $DD, $02, $95, $30, $4C, $E7, $9F, $AD, $AA
    .byte $02, $0A, $0A, $38, $E9, $04, $18, $6D, $FD, $02, $0A, $A8, $AD, $FD, $02, $0A
    .byte $AA, $B9, $D6, $A4, $95, $2F, $B9, $D7, $A4, $95, $30, $4C, $E7, $9F, $20, $01
    .byte $A3, $48, $20, $01, $A3, $48, $AD, $FD, $02, $0A, $AA, $B5, $2F, $9D, $E4, $02
    .byte $B5, $30, $9D, $E5, $02, $68, $95, $30, $68, $95, $2F, $4C, $E7, $9F, $AD, $FD
    .byte $02, $0A, $AA, $BD, $E4, $02, $95, $2F, $BD, $E5, $02, $95, $30, $4C, $E7, $9F
    .byte $20, $01, $A3, $AE, $FD, $02, $E0, $03, $F0, $03, $9D, $EC, $02, $4C, $E7, $9F
    .byte $20, $01, $A3, $A2, $02, $95, $46, $CA, $10, $FB, $4C, $E7, $9F, $AE, $FD, $02
    .byte $A9, $08, $4C, $C7, $A0, $20, $01, $A3, $AE, $FD, $02, $9D, $B4, $02, $9D, $B8
    .byte $02, $4A, $4A, $4A, $4A, $8D, $FF, $02, $BD, $F3, $02, $29, $C0, $09, $10, $0D
    .byte $FF, $02, $9D, $F3, $02, $4C, $E7, $9F

Audio_ReadStreamByte:
    LDA a:$02FD
    ASL A
    TAX
    LDA ($2F,X)
    INC $2F,X
    BNE Bank3_Label_A30E
    INC $30,X

Bank3_Label_A30E:
    RTS
