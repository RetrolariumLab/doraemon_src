; Doraemon PRG bank 0 $8F9E-$95CA
; World 1 entity behavior handlers and object update services
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank0_Func_8F9E:
    LDA a:$0550,X
    JSR Bank0_Func_8A6C
    INC a:$05E0,X
    LDA a:$05E0,X
    AND #$03
    BNE Bank0_Label_8FBF
    INC a:$05B0,X
    BMI Bank0_Label_8FBF
    LDA a:$05B0,X
    CMP #$09
    BCC Bank0_Label_8FBF
    LDA #$08
    STA a:$05B0,X

Bank0_Label_8FBF:
    LDA a:$05B0,X
    JMP Bank0_Func_8AA6

Bank0_Func_8FC5:
    LDA a:$0550,X
    AND #$07
    ASL A
    STA $01
    LDA $16
    AND #$01
    ORA $01
    PHA
    TAY
    LDA a:$8FE4,Y
    JSR Bank0_Func_8A6C
    PLA
    TAY
    LDA a:$8FF4,Y
    JSR Bank0_Func_8AA6
    RTS
    .byte $00, $00, $01, $01, $02, $01, $01, $00, $00, $00, $FF, $00, $FE, $FF, $FF, $00
    .byte $02, $01, $01, $01, $00, $00, $FF, $00, $FE, $FF, $FF, $00, $00, $00, $01, $00

Bank0_Func_9004:
    LDA a:$0490,X
    STA $A4
    LDA $1B
    AND #$07
    CLC
    ADC #$04
    ADC a:$04C0,X
    STA $A0
    LDA $A4
    ADC #$00
    LSR A
    ROR $A0
    LSR A
    ROR $A0
    LDA $A0
    AND #$80
    LSR $A0
    ORA $A0
    CLC
    ADC $5B
    STA $A0
    LDA a:$0490,X
    LSR A
    LSR A
    STA $A4
    LDA $1C
    AND #$07
    CLC
    ADC #$04
    ADC a:$04F0,X
    STA $A2
    LDA $A4
    ADC #$00
    LSR A
    ROR $A2
    LSR A
    ROR $A2
    LDA $A2
    AND #$80
    LSR $A2
    ORA $A2
    CLC
    ADC $5C
    STA $A2
    STX $A4
    LDX $A0
    LDY $A2
    JSR Bank0_Func_A6A7
    LDX $A4
    LDA a:$DADA,Y
    RTS
    .byte $20, $87, $89, $85, $AA, $20, $E3, $91, $BD, $0A, $04, $D0, $3D, $20, $2F, $96
    .byte $C9, $08, $B0, $36, $A9, $01, $9D, $0A, $04, $A9, $33, $9D, $3A, $04, $BD, $90
    .byte $04, $9D, $9A, $04, $A9, $81, $9D, $6A, $04, $BD, $C0, $04, $18, $69, $04, $9D
    .byte $CA, $04, $BD, $F0, $04, $18, $69, $04, $9D, $FA, $04, $A9, $FF, $9D, $2A, $05
    .byte $A5, $AA, $9D, $5A, $05, $A9, $02, $9D, $8A, $05, $60, $A0, $0A, $B9, $0A, $04
    .byte $F0, $07, $C8, $C0, $14, $D0, $F6, $38, $60, $20, $E3, $91, $A9, $02, $99, $0A
    .byte $04, $A9, $32, $99, $3A, $04, $A9, $01, $99, $6A, $04, $BD, $90, $04, $99, $9A
    .byte $04, $BD, $C0, $04, $18, $69, $04, $99, $CA, $04, $BD, $F0, $04, $18, $69, $04
    .byte $99, $FA, $04, $A9, $FF, $99, $2A, $05, $8A, $48, $20, $2F, $96, $29, $0F, $AA
    .byte $BD, $16, $91, $99, $5A, $05, $20, $2F, $96, $4A, $4A, $29, $07, $AA, $BD, $26
    .byte $91, $99, $BA, $05, $A9, $00, $99, $EA, $05, $A9, $01, $99, $8A, $05, $68, $AA
    .byte $60, $FC, $FD, $FE, $FF, $00, $01, $02, $03, $FF, $FE, $FF, $00, $01, $02, $04
    .byte $01, $F9, $FA, $FB, $FC, $FC, $FD, $FD, $FE, $38, $60, $BD, $0A, $04, $D0, $F9
    .byte $20, $E3, $91, $A9, $00, $85, $AD, $BD, $C0, $04, $38, $E5, $75, $B0, $07, $E6
    .byte $AD, $49, $FF, $18, $69, $01, $85, $AA, $06, $AD, $BD, $F0, $04, $38, $E5, $76
    .byte $B0, $07, $E6, $AD, $49, $FF, $18, $69, $01, $85, $AB, $06, $AD, $C5, $AA, $90
    .byte $0C, $A5, $AA, $85, $AE, $A5, $AB, $85, $B0, $E6, $AD, $D0, $08, $A5, $AA, $85
    .byte $B0, $A5, $AB, $85, $AE, $20, $BF, $91, $A9, $03, $9D, $0A, $04, $A9, $31, $9D
    .byte $3A, $04, $A9, $01, $9D, $6A, $04, $BD, $90, $04, $9D, $9A, $04, $BD, $C0, $04
    .byte $18, $69, $04, $9D, $CA, $04, $BD, $F0, $04, $18, $69, $04, $9D, $FA, $04, $A9
    .byte $FF, $9D, $2A, $05, $A5, $AD, $9D, $5A, $05, $A9, $01, $9D, $8A, $05, $A9, $00
    .byte $9D, $BA, $05, $A5, $AF, $9D, $EA, $05, $18, $60, $A9, $00, $85, $AF, $A9, $08
    .byte $85, $B1, $A5, $AE, $38, $E5, $B0, $90, $0D, $26, $AF, $2A, $C6, $B1, $D0, $F4
    .byte $60, $18, $65, $B0, $B0, $F3, $26, $AF, $2A, $C6, $B1, $D0, $F4, $60, $BD, $90
    .byte $04, $29, $0F, $D0, $13, $BD, $C0, $04, $C9, $F5, $B0, $0C, $BD, $F0, $04, $C9
    .byte $08, $90, $05, $C9, $E4, $B0, $01, $60, $68, $68, $38, $60

Bank0_Func_9201:
    LDA #$00
    STA $95

Bank0_Label_9205:
    LDX $95
    LDA a:$041E,X
    BEQ Bank0_Label_9250
    BMI Bank0_Label_9250
    TAY
    LDA a:$9317,Y
    STA $02
    LDA a:$04DE,X
    STA $00
    LDA a:$050E,X
    STA $01
    LDA #$00
    STA $96

Bank0_Label_9222:
    LDY $96
    LDX $95
    LDA a:$0426,Y
    BEQ Bank0_Label_9230
    BPL Bank0_Label_9230
    JSR Bank0_Func_C9E1

Bank0_Label_9230:
    INC $96
    LDY $96
    CPY #$0A
    BNE Bank0_Label_9222
    LDA #$00
    STA $96

Bank0_Label_923C:
    LDY $96
    LDX $95
    LDA a:$0400,Y
    BEQ Bank0_Label_9248
    JSR Bank0_Func_925A

Bank0_Label_9248:
    INC $96
    LDY $96
    CPY #$0A
    BNE Bank0_Label_923C

Bank0_Label_9250:
    INC $95
    LDA $95
    CMP #$08
    BNE Bank0_Label_9205
    RTS

Bank0_Label_9259:
    RTS

Bank0_Func_925A:
    CMP #$C0
    BCS Bank0_Label_9259
    CMP #$0F
    BEQ Bank0_Label_9259
    AND #$1F
    TAX
    LDA a:$0490,Y
    AND #$0F
    BNE Bank0_Label_9259
    LDA $00
    SEC
    SBC a:$04C0,Y
    BCS Bank0_Label_927A
    CLC
    ADC $02
    BCS Bank0_Label_927F
    RTS

Bank0_Label_927A:
    CMP a:$92F9,X
    BCS Bank0_Label_9259

Bank0_Label_927F:
    LDA $01
    SEC
    SBC a:$04F0,Y
    BCS Bank0_Label_928D
    CLC
    ADC $02
    BCS Bank0_Label_9292
    RTS

Bank0_Label_928D:
    CMP a:$9308,X
    BCS Bank0_Label_9259

Bank0_Label_9292:
    LDX $95
    LDA a:$041E,X
    CMP #$03
    BEQ Bank0_Label_92AD
    LDA a:$04DE,X
    SEC
    SBC #$04
    STA a:$04DE,X
    LDA a:$050E,X
    SEC
    SBC #$04
    STA a:$050E,X

Bank0_Label_92AD:
    LDA a:$0400,Y
    BMI Bank0_Label_92EB
    LDA a:$041E,X
    AND #$07
    STA $04
    LDA a:$05B0,Y
    SEC
    SBC $04
    STA a:$05B0,Y
    BCC Bank0_Label_92D3
    LDA a:$0400,Y
    ORA #$80
    STA a:$0400,Y
    LDA #$00
    STA a:$05E0,Y
    BEQ Bank0_Label_92EB

Bank0_Label_92D3:
    LDA #$00
    STA a:$05E0,Y
    LDA a:$0400,Y
    ORA #$C0
    STA a:$0400,Y
    LDA #$05
    JSR World1_Audio_QueueEffectWithPriority
    JSR Bank0_Func_9462
    JMP Bank0_Label_92F0

Bank0_Label_92EB:
    LDA #$03
    JSR World1_Audio_QueueEffectWithPriority

Bank0_Label_92F0:
    LDA #$80
    STA a:$041E,X
    PLA
    PLA
    JMP Bank0_Label_9250
    .byte $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $24, $0C, $0C
    .byte $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $28, $0C, $04, $08
    .byte $0C

Bank0_Func_931B:
    LDA #$00
    STA $81
    STA $80
    LDA $79
    BNE Bank0_Label_9363
    LDA #$00
    STA $95

Bank0_Label_9329:
    LDX $95
    LDA a:$040A,X
    BEQ Bank0_Label_933C
    BMI Bank0_Label_933C
    LDA a:$049A,X
    AND #$0F
    BNE Bank0_Label_933C
    JSR Bank0_Func_9383

Bank0_Label_933C:
    INC $95
    LDX $95
    CPX #$14
    BNE Bank0_Label_9329
    LDA #$00
    STA $95

Bank0_Label_9348:
    LDX $95
    LDA a:$0400,X
    BEQ Bank0_Label_935B
    BMI Bank0_Label_935B
    LDA a:$0490,X
    AND #$0F
    BNE Bank0_Label_935B
    JSR Bank0_Func_93D4

Bank0_Label_935B:
    INC $95
    LDX $95
    CPX #$0A
    BNE Bank0_Label_9348

Bank0_Label_9363:
    LDA #$00
    STA $95

Bank0_Label_9367:
    LDX $95
    LDA a:$0426,X
    BEQ Bank0_Label_937A
    BMI Bank0_Label_937A
    LDA a:$04B6,X
    AND #$0F
    BNE Bank0_Label_937A
    JSR Bank0_Func_C998

Bank0_Label_937A:
    INC $95
    LDX $95
    CPX #$0A
    BNE Bank0_Label_9367
    RTS

Bank0_Func_9383:
    LDA $75
    SEC
    SBC a:$04CA,X
    BCS Bank0_Label_9391
    CMP #$F4
    BCC Bank0_Label_93D3
    BCS Bank0_Label_9395

Bank0_Label_9391:
    CMP #$05
    BCS Bank0_Label_93D3

Bank0_Label_9395:
    LDA $76
    SEC
    SBC a:$04FA,X
    BCS Bank0_Label_93A3
    CMP #$E4
    BCC Bank0_Label_93D3
    BCS Bank0_Label_93A7

Bank0_Label_93A3:
    CMP #$04
    BCS Bank0_Label_93D3

Bank0_Label_93A7:
    LDA $B2
    BNE Bank0_Label_93CE
    LDA $82
    BNE Bank0_Label_93D3
    LDA #$0F
    JSR World1_Audio_QueueEffectWithPriority
    LDA #$01
    STA $79
    LDA a:$058A,X
    STA $00
    LDA $2B
    SEC
    SBC $00
    BCS Bank0_Label_93CA
    LDA #$80
    STA $79
    LDA #$00

Bank0_Label_93CA:
    STA $2B
    PLA
    PLA

Bank0_Label_93CE:
    LDA #$00
    STA a:$040A,X

Bank0_Label_93D3:
    RTS

Bank0_Func_93D4:
    LDA a:$0400,X
    CMP #$0F
    BEQ Bank0_Label_942A
    AND #$3F
    TAY
    DEY
    LDA $75
    SEC
    SBC a:$04C0,X
    BCS Bank0_Label_93ED
    CMP #$F4
    BCC Bank0_Label_942A
    BCS Bank0_Label_93F2

Bank0_Label_93ED:
    CMP a:$9442,Y
    BCS Bank0_Label_942A

Bank0_Label_93F2:
    LDA $76
    SEC
    SBC a:$04F0,X
    BCS Bank0_Label_9400
    CMP #$EC
    BCC Bank0_Label_942A
    BCS Bank0_Label_9405

Bank0_Label_9400:
    CMP a:$9452,Y
    BCS Bank0_Label_942A

Bank0_Label_9405:
    LDA $B2
    BNE Bank0_Label_942B
    LDA $82
    BNE Bank0_Label_942A
    LDA #$0F
    JSR World1_Audio_QueueEffectWithPriority
    LDA #$01
    STA $79
    LDA $2B
    CLC
    SBC a:$05B0,X
    STA $2B
    BPL Bank0_Label_9428
    LDA #$80
    STA $79
    LDA #$00
    STA $2B

Bank0_Label_9428:
    PLA
    PLA

Bank0_Label_942A:
    RTS

Bank0_Label_942B:
    LDA #$00
    STA a:$05E0,X
    LDA a:$0400,X
    ORA #$C0
    STA a:$0400,X
    LDA #$05
    JSR World1_Audio_QueueEffectWithPriority
    TXA
    TAY
    JMP Bank0_Func_9462
    .byte $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $2C, $0C, $0C
    .byte $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $1E, $0C, $0C

Bank0_Func_9462:
    TXA
    PHA
    TYA
    PHA
    LDX $B3
    LDA a:$0400,Y
    AND #$3F
    CMP a:$94D9,X
    BNE Bank0_Label_947F
    INC $B3
    LDA $B3
    CMP #$06
    BNE Bank0_Label_9483
    LDA #$04
    JMP Bank0_Label_9494

Bank0_Label_947F:
    LDA #$00
    STA $B3

Bank0_Label_9483:
    INC $98
    LDA $98
    CMP #$04
    BCC Bank0_Label_94CF
    LDA #$00
    STA $98
    JSR Bank0_Func_962F
    AND #$03

Bank0_Label_9494:
    TAX
    LDA a:$94D4,X
    STA $00
    BEQ Bank0_Label_94CF
    JSR Bank0_Func_C988
    BNE Bank0_Label_94CF
    LDA a:$0490,Y
    STA a:$0490,X
    LDA a:$04C0,Y
    STA a:$04C0,X
    LDA a:$04F0,Y
    STA a:$04F0,X
    LDA #$FF
    STA a:$0520,X
    LDA $00
    ASL A
    ASL A
    TAY
    LDA a:$CC0A,Y
    STA a:$0400,X
    LDA a:$CC0B,Y
    STA a:$0430,X
    LDA a:$CC0C,Y
    STA a:$0460,X

Bank0_Label_94CF:
    PLA
    TAY
    PLA
    TAX
    RTS
    .byte $06, $0A, $0B, $02, $0C, $06, $06, $05, $04, $01, $06, $06, $A2, $15, $CA, $D0
    .byte $FD, $EA, $EA, $88, $D0, $F6, $60

Bank0_Func_94EB:
    LDA a:$0180
    BNE Bank0_Func_94EB
    RTS

Bank0_Func_94F1:
    LDA $16

Bank0_Label_94F3:
    CMP $16
    BEQ Bank0_Label_94F3
    RTS

Bank0_Func_94F8:
    LDA #$00
    PHA
    LDA $19
    AND #$FB
    STA a:$2000
    LDA #$20
    STA a:$2006
    LDA #$00
    STA a:$2006
    LDY #$00
    LDX #$10
    PLA

Bank0_Label_9511:
    STA a:$2007
    DEY
    BNE Bank0_Label_9511
    DEX
    BNE Bank0_Label_9511
    RTS

Bank0_Func_951B:
    LDX #$00
    LDA #$00

Bank0_Label_951F:
    STA a:$06B0,X
    INX
    CPX #$80
    BNE Bank0_Label_951F
    RTS
    .byte $A0, $00, $B1, $00, $99, $10, $02, $C8, $C0, $20, $D0, $F6, $60

Bank0_Func_9535:
    LDA $14
    BNE Bank0_Label_955C
    JSR Bank0_WaitForVblank
    LDA $19
    AND #$FB
    STA a:$2000
    LDA #$3F
    STA a:$2006
    LDA #$00
    STA a:$2006
    LDX #$00
    LDY #$20

Bank0_Label_9551:
    LDA a:$0210,X
    STA a:$2007
    INX
    DEY
    BNE Bank0_Label_9551
    RTS

Bank0_Label_955C:
    JSR Bank0_Func_94EB
    LDY #$00
    LDX #$20
    LDA #$3F
    STA a:$0181
    LDA #$00
    STA a:$0182
    LDA #$20
    STA a:$0183

Bank0_Label_9572:
    LDA a:$0210,Y
    STA a:$0184,Y
    INY
    DEX
    BNE Bank0_Label_9572
    LDA #$00
    STA a:$0184,Y
    LDA #$01
    STA a:$0180
    RTS
    .byte $A5, $19, $29, $FB, $85, $19, $8D, $00, $20, $A0, $00, $B1, $00, $F0, $34, $8D
    .byte $06, $20, $C8, $B1, $00, $8D, $06, $20, $C8, $B1, $00, $AA, $C8, $48, $98, $A0
    .byte $00, $18, $65, $00, $85, $00, $90, $02, $E6, $01, $B1, $00, $8D, $07, $20, $C8
    .byte $CA, $D0, $F7, $68, $F0, $08, $98, $18, $65, $00, $85, $00, $90, $CB, $E6, $01
    .byte $4C, $90, $95, $60
