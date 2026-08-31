; Doraemon PRG bank 0 $A50A-$A87D
; World 1 metatile decoding and incremental nametable streaming
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank0_Func_A50A:
    PHA
    LDA #$00
    STA $74
    PLA
    AND #$01
    LSR A
    ROR A
    LSR A
    STA $73
    LDA $1C
    AND #$08
    BEQ Bank0_Label_A52D
    INY
    LDA $1C
    CLC
    ADC #$08
    CMP #$F0
    BCC Bank0_Label_A52F
    CLC
    ADC #$10
    JMP Bank0_Label_A52F

Bank0_Label_A52D:
    LDA $1C

Bank0_Label_A52F:
    AND #$F8
    LSR A
    LSR A
    STA $5D
    LSR A
    LSR A
    LSR A
    ROL $74
    LDA $5D
    AND #$38
    ORA $73
    STA $73
    LDA $1B
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    ROL $74
    ORA $73
    STA $73
    AND #$C7
    STA $5D
    ORA #$C0
    STA a:$0253
    LDA $73
    AND #$40
    LSR A
    LSR A
    LSR A
    LSR A
    ORA #$23
    STA a:$0254
    JSR Bank0_Func_A6A7
    LDX $73
    LDA #$0F
    STA $5E

Bank0_Label_A56E:
    JSR Bank0_Func_A772
    AND #$03
    TAY
    LDA a:$A7D3,Y
    LDY $74
    AND a:$A7D7,Y
    STA $5F
    LDA a:$A7D7,Y
    EOR #$FF
    AND a:$06B0,X
    ORA $5F
    STA a:$06B0,X
    LDA $74
    EOR #$02
    STA $74
    AND #$02
    BEQ Bank0_Label_A5A9
    TXA
    AND #$38
    CMP #$38
    BNE Bank0_Label_A5AE
    TXA
    AND #$C7
    TAX
    LDA $74
    AND #$01
    STA $74
    JMP Bank0_Label_A5AE

Bank0_Label_A5A9:
    TXA
    CLC
    ADC #$08
    TAX

Bank0_Label_A5AE:
    DEC $5E
    BNE Bank0_Label_A56E
    LDX $5D
    LDY #$00

Bank0_Label_A5B6:
    LDA a:$06B0,X
    STA a:$0255,Y
    TXA
    CLC
    ADC #$08
    TAX
    INY
    CPY #$08
    BNE Bank0_Label_A5B6
    LDA a:$0230
    ORA #$02
    STA a:$0230
    RTS

Bank0_Func_A5CF:
    JSR Bank0_Func_A6A7
    LDX #$00

Bank0_Label_A5D4:
    JSR Bank0_Func_A6E8
    STA a:$0263,X
    INX
    CPX #$21
    BNE Bank0_Label_A5D4
    LDA $1C
    AND #$F8
    STA a:$0261
    LDA $58
    AND #$01
    ASL a:$0261
    ROL A
    ASL a:$0261
    ROL A
    ORA #$20
    STA a:$0262
    LDA $1B
    LSR A
    LSR A
    LSR A
    ORA a:$0261
    STA a:$0261
    LDA a:$0260
    ORA #$01
    STA a:$0260
    RTS

Bank0_Func_A60B:
    TYA
    PHA
    LDA #$00
    STA $74
    LDA $58
    AND #$01
    LSR A
    ROR A
    LSR A
    STA $73
    LDA $1C
    AND #$F8
    LSR A
    LSR A
    TAY
    LSR A
    LSR A
    LSR A
    ROL $74
    TYA
    AND #$38
    ORA $73
    STA $73
    LDA $1B
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    ROL $74
    ORA $73
    STA $73
    ORA #$C0
    STA a:$0284
    LDA $73
    AND #$40
    LSR A
    LSR A
    LSR A
    LSR A
    ORA #$23
    STA a:$0285
    PLA
    TAY
    JSR Bank0_Func_A6A7
    LDX $73
    LDA #$00
    STA $5D
    LDA #$11
    STA $5E

Bank0_Label_A65B:
    JSR Bank0_Func_A74E
    AND #$03
    TAY
    LDA a:$A7D3,Y
    LDY $74
    AND a:$A7D7,Y
    STA $5F
    LDA a:$A7D7,Y
    EOR #$FF
    AND a:$06B0,X
    ORA $5F
    STA a:$06B0,X
    LDY $5D
    STA a:$0286,Y
    LDA $74
    EOR #$01
    STA $74
    AND #$01
    BNE Bank0_Label_A69A
    INC $5D
    TXA
    AND #$07
    CMP #$07
    BEQ Bank0_Label_A694
    INX
    JMP Bank0_Label_A69A

Bank0_Label_A694:
    TXA
    AND #$F8
    EOR #$40
    TAX

Bank0_Label_A69A:
    DEC $5E
    BNE Bank0_Label_A65B
    LDA a:$0260
    ORA #$02
    STA a:$0260
    RTS

Bank0_Func_A6A7:
    LDA #$00
    STA $70
    STA $71
    STA $6E
    TYA
    LSR A
    ROL $70
    LSR A
    ROL $71
    LSR A
    ROR $6E
    LSR A
    ROR $6E
    STA $6F
    LDA $6E
    CLC
    ADC $66
    STA $6E
    LDA $6F
    ADC $67
    STA $6F
    TXA
    LSR A
    ROL $70
    LSR A
    ROL $71
    STA $72
    LDY $72
    LDA ($6E),Y
    JSR Bank0_Func_A7B7
    LDY $71
    LDA ($6C),Y
    JSR Bank0_Func_A79B
    LDY $70
    LDA ($6A),Y
    TAY
    RTS

Bank0_Func_A6E8:
    LDY $70
    LDA ($6A),Y
    PHA
    TYA
    EOR #$01
    STA $70
    AND #$01
    BNE Bank0_Label_A716
    LDA $71
    EOR #$01
    STA $71
    AND #$01
    BNE Bank0_Label_A70F
    INC $72
    LDA $72
    AND #$3F
    STA $72
    LDY $72
    LDA ($6E),Y
    JSR Bank0_Func_A7B7

Bank0_Label_A70F:
    LDY $71
    LDA ($6C),Y
    JSR Bank0_Func_A79B

Bank0_Label_A716:
    PLA
    TAY
    RTS

Bank0_Func_A719:
    LDY $70
    LDA ($6A),Y
    PHA
    TYA
    EOR #$02
    STA $70
    AND #$02
    BNE Bank0_Label_A74C
    LDA $71
    EOR #$02
    STA $71
    AND #$02
    BNE Bank0_Label_A745
    LDA $6E
    CLC
    ADC #$40
    STA $6E
    LDA $6F
    ADC #$00
    STA $6F
    LDY $72
    LDA ($6E),Y
    JSR Bank0_Func_A7B7

Bank0_Label_A745:
    LDY $71
    LDA ($6C),Y
    JSR Bank0_Func_A79B

Bank0_Label_A74C:
    PLA
    RTS

Bank0_Func_A74E:
    LDY $71
    LDA ($6C),Y
    TAY
    LDA a:$A9EF,Y
    PHA
    LDA $71
    EOR #$01
    STA $71
    AND #$01
    BNE Bank0_Label_A770
    INC $72
    LDA $72
    AND #$3F
    STA $72
    LDY $72
    LDA ($6E),Y
    JSR Bank0_Func_A7B7

Bank0_Label_A770:
    PLA
    RTS

Bank0_Func_A772:
    LDY $71
    LDA ($6C),Y
    TAY
    LDA a:$A9EF,Y
    PHA
    LDA $71
    EOR #$02
    STA $71
    AND #$02
    BNE Bank0_Label_A799
    LDA $6E
    CLC
    ADC #$40
    STA $6E
    LDA $6F
    ADC #$00
    STA $6F
    LDY $72
    LDA ($6E),Y
    JSR Bank0_Func_A7B7

Bank0_Label_A799:
    PLA
    RTS

Bank0_Func_A79B:
    ASL A
    ROL $6B
    ASL A
    ROL $6B
    STA $6A
    LDA $6B
    AND #$03
    STA $6B
    LDA #$EF
    CLC
    ADC $6A
    STA $6A
    LDA #$AA
    ADC $6B
    STA $6B
    RTS

Bank0_Func_A7B7:
    ASL A
    ROL $6D
    ASL A
    ROL $6D
    STA $6C
    LDA $6D
    AND #$03
    STA $6D
    LDA #$EF
    CLC
    ADC $6C
    STA $6C
    LDA #$AE
    ADC $6D
    STA $6D
    RTS
    .byte $00, $55, $AA, $FF, $03, $0C, $30, $C0

Bank0_Func_A7DB:
    LDA #$00
    STA a:$025F
    STA a:$0260
    STA a:$0230
    LDA $5B
    AND #$01
    ASL A
    ASL A
    ASL A
    STA $1B
    LDA $5C
    AND #$01
    ASL A
    ASL A
    ASL A
    STA $1C
    LDA #$98
    STA $60
    LDA $5C
    BMI Bank0_Label_A84C
    LDA $5C
    CLC
    ADC #$26
    STA $5C

Bank0_Label_A807:
    LDA #$00
    STA $61
    STA $62
    JSR Bank0_Func_A484
    JSR Bank0_Func_A87E
    JSR Bank0_Func_8BDE
    JSR Bank0_Func_8750
    LDA #$00
    STA $61
    STA $62
    JSR Bank0_Func_A484
    JSR Bank0_Func_A87E
    JSR Bank0_Func_8BDE
    JSR Bank0_Func_8750
    DEC $60
    BNE Bank0_Label_A807

Bank0_Label_A82F:
    LDA $1B
    STA $59
    LDA $1C
    STA $5A
    LDA $19
    AND #$FE
    STA $5D
    LDA $58
    AND #$01
    ORA $5D
    STA $19
    LDA #$00
    STA $61
    STA $62
    RTS

Bank0_Label_A84C:
    LDA $5C
    SEC
    SBC #$26
    STA $5C

Bank0_Label_A853:
    LDA #$00
    STA $61
    STA $62
    JSR Bank0_Func_A42F
    JSR Bank0_Func_A87E
    JSR Bank0_Func_8BDE
    JSR Bank0_Func_8750
    LDA #$00
    STA $61
    STA $62
    JSR Bank0_Func_A42F
    JSR Bank0_Func_A87E
    JSR Bank0_Func_8BDE
    JSR Bank0_Func_8750
    DEC $60
    BNE Bank0_Label_A853
    JMP Bank0_Label_A82F
