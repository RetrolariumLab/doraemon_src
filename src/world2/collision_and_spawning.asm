; Doraemon PRG bank 1 $92EC-$9660
; World 2 collision tests, object spawning, and frame services
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank1_Func_92EC:
    STA $94
    LDA a:$9326,X
    PHA
    AND #$0F
    CLC
    ADC #$9F
    STA $95
    PLA
    BPL Bank1_Label_9300
    LDA #$82
    BNE Bank1_Label_9302

Bank1_Label_9300:
    LDA #$02

Bank1_Label_9302:
    STA $96
    LDA $60
    JMP Bank1_Func_96BA

Bank1_Func_9309:
    LDA $8C
    STA $94
    LDA a:$9326,X
    PHA
    AND #$0F
    CLC
    ADC #$A9
    STA $95
    PLA
    BPL Bank1_Label_931F
    LDA #$42
    BNE Bank1_Label_9321

Bank1_Label_931F:
    LDA #$02

Bank1_Label_9321:
    STA $96
    LDA $60
    RTS
    .byte $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $02, $03, $82, $00
    .byte $00, $00, $00, $00, $00, $04, $03, $84, $00, $00, $00, $00, $00, $05, $06, $07
    .byte $86, $85, $00, $00, $00, $00, $08, $07, $09, $87, $88, $00, $00, $00, $05, $06
    .byte $0A, $09, $8A, $86, $85, $00, $00, $08, $07, $0A, $09, $8A, $87, $88, $00, $05
    .byte $06, $0A, $09, $09, $09, $8A, $86, $85, $08, $07, $0A, $09, $09, $09, $8A, $87
    .byte $88

Bank1_Func_9377:
    LDA $68
    CLC
    ADC $40
    BCC Bank1_Label_9380
    ADC #$0F

Bank1_Label_9380:
    AND #$F0
    CMP #$F0
    BNE Bank1_Label_9388
    LDA #$00

Bank1_Label_9388:
    STA $69
    LDA $67
    CLC
    ADC $3F
    ROR A
    ROR A
    ROR A
    ROR A
    AND #$0F
    ORA $69
    TAY
    LDA a:$0400,Y
    PHA
    AND #$07
    TAY
    LDA a:$93AF,Y
    STA $AF
    PLA
    LSR A
    LSR A
    LSR A
    TAY
    LDA a:$BEC4,Y
    AND $AF
    RTS
    .byte $80, $40, $20, $10, $08, $04, $02, $01

Bank1_Func_93B7:
    JSR Bank1_Func_9606
    JSR Bank1_Func_9573
    JSR Bank1_Func_95B4
    JSR Bank1_Func_9534
    JSR Bank1_Func_94FE
    JSR Bank1_Func_9530
    JSR Bank1_Func_93EC
    JSR Bank1_Func_94BB
    JMP Bank1_Func_9450

Bank1_Func_93D2:
    LDY #$00

Bank1_Label_93D4:
    LDA a:OamBuffer,Y
    CMP #$F8
    BEQ Bank1_Func_93E3
    INY
    INY
    INY
    INY
    BNE Bank1_Label_93D4
    SEC
    RTS

Bank1_Func_93E3:
    CLC
    RTS

Bank1_Func_93E5:
    JSR Bank1_Func_94FE
    JSR Bank1_Func_9534
    RTS

Bank1_Func_93EC:
    LDA $A8
    BEQ Bank1_Label_942F
    AND #$01
    LDX $42
    BEQ Bank1_Label_941A
    DEX
    BEQ Bank1_Label_9408
    TAX
    LDA $5C
    STA $67
    LDA $5D
    CLC
    ADC #$18
    STA $68
    JMP Bank1_Func_9430

Bank1_Label_9408:
    CLC
    ADC #$02
    TAX
    LDA $5C
    STA $67
    LDA $5D
    SEC
    SBC #$10
    STA $68
    JMP Bank1_Func_9430

Bank1_Label_941A:
    CLC
    ADC #$04
    TAX
    LDA $5D
    CLC
    ADC #$09
    STA $68
    LDA $5C
    CLC
    ADC #$10
    STA $67
    JSR Bank1_Func_9430

Bank1_Label_942F:
    RTS

Bank1_Func_9430:
    LDA $67
    STA $60
    STX $67
    LDA $68
    STA $61
    LDA #$00
    CPX #$02
    BCC Bank1_Label_9446
    CPX #$04
    BEQ Bank1_Label_9446
    LDA #$80

Bank1_Label_9446:
    STA $62
    JSR Bank1_Func_93D2
    BCS Bank1_Label_9498
    JMP Bank1_Label_946F

Bank1_Func_9450:
    LDX #$04
    LDA $7C,X
    BEQ Bank1_Label_9498
    CMP #$03
    BEQ Bank1_Label_9498
    JSR Bank1_Func_93D2
    BCS Bank1_Label_9498
    LDA #$00
    STA $62
    LDA $83,X
    STA $60
    LDA $8A,X
    STA $61
    LDA #$00
    STA $67

Bank1_Label_946F:
    LDA $67
    ASL A
    ASL A
    TAX
    JSR Bank1_Func_9477

Bank1_Func_9477:
    JSR Bank1_Func_9499
    LDA $67
    CMP #$04
    BCS Bank1_Label_9486
    LDA $62
    EOR #$40
    STA $62

Bank1_Label_9486:
    JSR Bank1_Func_9499
    LDA $67
    CMP #$04
    BCS Bank1_Label_9495
    LDA $62
    EOR #$40
    STA $62

Bank1_Label_9495:
    JMP Bank1_Label_9560

Bank1_Label_9498:
    RTS

Bank1_Func_9499:
    LDA $61
    STA $94
    LDA a:$978D,X
    STA $95
    LDA $62
    STA $96
    LDA $60
    STA $97
    LDA a:$978D,X
    BEQ Bank1_Label_94B2
    JSR Bank1_Func_96C8

Bank1_Label_94B2:
    INX
    LDA $97
    CLC
    ADC #$08
    STA $60
    RTS

Bank1_Func_94BB:
    LDA $82
    BEQ Bank1_Label_94FD
    CMP #$03
    BEQ Bank1_Label_94FD
    JSR Bank1_Func_93E3
    BCS Bank1_Label_94FD
    LDA $89
    STA $97
    LDA $90
    STA $94
    LDA #$3E
    STA $95
    LDX #$00
    JSR Bank1_Func_94ED
    JSR Bank1_Func_94ED
    LDA $97
    SEC
    SBC #$10
    STA $97
    LDA $94
    CLC
    ADC #$08
    STA $94
    JSR Bank1_Func_94ED

Bank1_Func_94ED:
    LDA a:$97A5,X
    STA $96
    JSR Bank1_Func_96C8
    LDA $97
    CLC
    ADC #$08
    STA $97
    INX

Bank1_Label_94FD:
    RTS

Bank1_Func_94FE:
    LDX #$03
    LDA $7C,X
    BEQ Bank1_Label_956E
    CMP #$03
    BEQ Bank1_Label_956E
    JSR Bank1_Func_93E3
    BCS Bank1_Label_956E
    LDA $83,X
    STA $97
    LDA $8A,X
    STA $94
    LDA #$01
    STA $96
    LDA #$EA
    STA $95
    JSR Bank1_Func_96C8
    LDA $97
    CLC
    ADC #$08
    STA $97
    LDA $96
    ORA #$40
    STA $96
    JMP Bank1_Func_96C8

Bank1_Func_9530:
    LDX #$05
    BNE Bank1_Label_9536

Bank1_Func_9534:
    LDX #$02

Bank1_Label_9536:
    LDA $7C,X
    BEQ Bank1_Label_956E
    CMP #$03
    BEQ Bank1_Label_956E
    JSR Bank1_Func_93D2
    BCS Bank1_Label_956E
    LDA a:$956D,X
    STA $62
    LDA $83,X
    STA $60
    LDA $8A,X
    STA $61
    TXA
    ASL A
    ASL A
    CLC
    ADC #$94
    TAX
    JSR Bank1_Func_955A

Bank1_Func_955A:
    JSR Bank1_Func_966B
    JSR Bank1_Func_966B

Bank1_Label_9560:
    LDA $60
    SEC
    SBC #$10
    STA $60
    LDA $61
    CLC
    ADC #$08
    STA $61

Bank1_Label_956E:
    RTS
    .byte $01, $01, $00, $00

Bank1_Func_9573:
    LDA $7C
    BEQ Bank1_Label_956E
    LDY #$30
    CMP #$03
    BEQ Bank1_Label_9591
    LDX #$18
    LDA $73
    AND #$10
    BEQ Bank1_Label_9586
    INX

Bank1_Label_9586:
    LDA $83
    STA $60
    LDA $8A
    STA $61
    JMP Bank1_Label_95F8

Bank1_Label_9591:
    LDA $5F
    SEC
    SBC #$2F
    BPL Bank1_Label_959A
    ADC #$30

Bank1_Label_959A:
    TAX
    LDA a:$0200,X
    STA $60
    STA $83
    LDA a:$0230,X
    STA $61
    STA $8A
    LDA $42
    ASL A
    CLC
    ADC #$12
    TAX
    JMP Bank1_Label_95F1

Bank1_Label_95B3:
    RTS

Bank1_Func_95B4:
    LDA $7D
    BEQ Bank1_Label_95B3
    LDY #$18
    CMP #$03
    BEQ Bank1_Label_95D2
    LDX #$10
    LDA $73
    AND #$10
    BEQ Bank1_Label_95C7
    INX

Bank1_Label_95C7:
    LDA $84
    STA $60
    LDA $8B
    STA $61
    JMP Bank1_Label_95F8

Bank1_Label_95D2:
    LDA $5F
    SEC
    SBC #$17
    BPL Bank1_Label_95DB
    ADC #$30

Bank1_Label_95DB:
    TAX
    LDA a:$0200,X
    STA $60
    STA $84
    LDA a:$0230,X
    STA $61
    STA $8B
    LDA $42
    ASL A
    CLC
    ADC #$0A
    TAX

Bank1_Label_95F1:
    LDA $73
    AND #$02
    BEQ Bank1_Label_95F8
    INX

Bank1_Label_95F8:
    LDA #$21
    STA $62
    TXA
    STA $98
    ASL A
    ADC $98
    ASL A
    TAX
    BNE Bank1_Label_965B

Bank1_Func_9606:
    LDY #$00
    LDA #$00
    STA $62
    LDA $A2
    BNE Bank1_Label_9619
    LDX $A0
    BEQ Bank1_Label_9628
    LDA $73
    ROR A
    BCS Bank1_Label_966A

Bank1_Label_9619:
    CPX #$50
    BCC Bank1_Label_9628
    LDA $73
    AND #$08
    LSR A
    LSR A
    LSR A
    ADC #$08
    BNE Bank1_Label_964C

Bank1_Label_9628:
    LDA $42
    BEQ Bank1_Label_963D
    TAX
    LDA $73
    AND #$02
    LSR A
    ADC #$04
    CPX #$01
    BEQ Bank1_Label_964C
    CLC
    ADC #$02
    BNE Bank1_Label_964C

Bank1_Label_963D:
    LDA $73
    AND #$02
    LSR A
    TAX
    LDA $73
    AND #$10
    BEQ Bank1_Label_964B
    INX
    INX

Bank1_Label_964B:
    TXA

Bank1_Label_964C:
    STA $98
    ASL A
    ADC $98
    ASL A
    TAX
    LDA $5C
    STA $60
    LDA $5D
    STA $61

Bank1_Label_965B:
    JSR Bank1_Func_9661
    JSR Bank1_Func_9661
