; Doraemon PRG bank 2 $B406-$B6B9
; World 3 HUD composition, number rendering, and presentation tables
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank2_Func_B406:
    LDY #$00
    LDA #$5C
    STA $83
    LDA #$18
    STA $80
    LDA #$00
    STA $82

Bank2_Label_B414:
    LDA a:ScoreDigitsWorking,Y
    BNE Bank2_Label_B425
    LDA $83
    CLC
    ADC #$08
    STA $83
    INY
    CPY #$06
    BNE Bank2_Label_B414

Bank2_Label_B425:
    LDA a:ScoreDigitsWorking,Y
    AND #$0F
    ORA #$30
    STA $81
    JSR Bank2_Func_B6BA
    LDA $83
    CLC
    ADC #$08
    STA $83
    INY
    CPY #$07
    BNE Bank2_Label_B425
    LDA #$32
    STA $80
    LDA #$E6
    STA $83
    LDA #$00
    STA $82
    LDA #$3A
    STA $81
    JSR Bank2_Func_B6BA
    LDA #$F0
    STA $83
    LDA $2A
    AND #$0F
    ORA #$30
    STA $81
    JSR Bank2_Func_B6BA
    RTS

Bank2_Func_B460:
    LDA $2C
    ASL A
    ASL A
    CLC
    ADC #$50
    STA $80
    LDA #$EC
    STA $83
    LDA #$00
    STA $82
    LDA #$04
    STA $0A
    LDA $2B
    STA $81
    LDY #$07

Bank2_Label_B47B:
    LDA $81
    SEC
    SBC #$04
    BCC Bank2_Label_B48E
    STA $81
    LDA #$3F
    STA a:$000A,Y
    DEY
    BPL Bank2_Label_B47B
    BMI Bank2_Label_B49F

Bank2_Label_B48E:
    CLC
    ADC #$3F
    STA a:$000A,Y
    DEY
    BMI Bank2_Label_B49F
    LDA #$3B

Bank2_Label_B499:
    STA a:$000A,Y
    DEY
    BPL Bank2_Label_B499

Bank2_Label_B49F:
    LDY $2C

Bank2_Label_B4A1:
    LDA a:$000A,Y
    STA $81
    JSR Bank2_Func_B6BA
    LDA $80
    CLC
    ADC #$08
    STA $80
    INY
    CPY #$08
    BNE Bank2_Label_B4A1
    RTS

Bank2_Func_B4B6:
    LDA $7A
    AND #$40
    BEQ Bank2_Label_B4C4
    LDA FrameCounter
    LSR A
    AND #$01
    BEQ Bank2_Label_B4C4
    RTS

Bank2_Label_B4C4:
    LDA $7A
    BPL Bank2_Label_B4DA
    LDA FrameCounter
    AND #$08
    BEQ Bank2_Label_B4DA
    LDA $7A
    ASL A
    ASL A
    AND #$80
    ORA $7A
    LSR A
    LSR A
    STA $7A

Bank2_Label_B4DA:
    LDX $79
    TXA
    ASL A
    TAY
    LDA #$00
    ADC #$B6
    STA $7C
    LDA #$D7
    STA $7B
    INY
    LDA ($7B),Y
    CMP #$04
    BCS Bank2_Label_B532
    PHA
    DEY
    LDA ($7B),Y
    TAX
    ASL A
    TAY
    LDA #$00
    ADC #$B6
    STA $7C
    LDA #$D7
    STA $7B
    LDA ($7B),Y
    PHA
    INY
    LDA ($7B),Y
    STA $7C
    PLA
    STA $7B
    LDY #$00
    LDA ($7B),Y
    INY
    STA $7F
    LDA ($7B),Y
    INY
    STA $7D
    LDA ($7B),Y
    INY
    STA $7E
    PLA
    BEQ Bank2_Label_B529
    CMP #$02
    BEQ Bank2_Label_B52F
    BCC Bank2_Label_B52C
    JMP Bank2_Label_B654

Bank2_Label_B529:
    JMP Bank2_Label_B544

Bank2_Label_B52C:
    JMP Bank2_Label_B5F6

Bank2_Label_B52F:
    JMP Bank2_Label_B598

Bank2_Label_B532:
    PHA
    DEY
    LDA ($7B),Y
    STA $7B
    PLA
    STA $7C
    LDY #$00
    LDA ($7B),Y
    INY
    STA $7F
    INY
    INY

Bank2_Label_B544:
    LDA ($7B),Y
    INY
    TAX
    AND #$7F
    CLC
    ADC $77
    STA $80
    LDA $78
    ADC #$00
    AND #$03
    BNE Bank2_Label_B590
    LDA $80
    CMP #$F0
    BCS Bank2_Label_B590
    TXA
    AND #$80
    STA $82
    LDA ($7B),Y
    INY
    TAX
    AND #$7F
    CLC
    ADC $75
    STA $83
    LDA $76
    ADC #$00
    AND #$03
    BNE Bank2_Label_B591
    TXA
    AND #$80
    LSR A
    ORA $82
    STA $82
    LDA ($7B),Y
    INY
    STA $81
    LDA $7A
    AND #$23
    ORA $82
    STA $82
    JSR Bank2_Func_B6BA
    JMP Bank2_Label_B592

Bank2_Label_B590:
    INY

Bank2_Label_B591:
    INY

Bank2_Label_B592:
    DEC $7F
    BNE Bank2_Label_B544
    CLC
    RTS

Bank2_Label_B598:
    LDA ($7B),Y
    INY
    TAX
    AND #$7F
    SEC
    SBC $7E
    EOR #$FF
    CLC
    ADC #$01
    CLC
    ADC $77
    STA $80
    LDA $78
    ADC #$00
    AND #$03
    BNE Bank2_Label_B5EE
    LDA $80
    CMP #$F0
    BCS Bank2_Label_B5EE
    TXA
    AND #$80
    STA $82
    LDA ($7B),Y
    INY
    TAX
    AND #$7F
    CLC
    ADC $75
    STA $83
    LDA $76
    ADC #$00
    AND #$03
    BNE Bank2_Label_B5EF
    TXA
    AND #$80
    LSR A
    ORA $82
    STA $82
    LDA ($7B),Y
    INY
    STA $81
    LDA $7A
    AND #$23
    ORA $82
    EOR #$80
    STA $82
    JSR Bank2_Func_B6BA
    JMP Bank2_Label_B5F0

Bank2_Label_B5EE:
    INY

Bank2_Label_B5EF:
    INY

Bank2_Label_B5F0:
    DEC $7F
    BNE Bank2_Label_B598
    CLC
    RTS

Bank2_Label_B5F6:
    LDA ($7B),Y
    INY
    TAX
    AND #$7F
    CLC
    ADC $77
    STA $80
    LDA $78
    ADC #$00
    AND #$03
    BNE Bank2_Label_B64C
    LDA $80
    CMP #$F0
    BCS Bank2_Label_B64C
    TXA
    AND #$80
    STA $82
    LDA ($7B),Y
    INY
    TAX
    AND #$7F
    SEC
    SBC $7D
    EOR #$FF
    CLC
    ADC #$01
    CLC
    ADC $75
    STA $83
    LDA $76
    ADC #$00
    AND #$03
    BNE Bank2_Label_B64D
    TXA
    AND #$80
    LSR A
    ORA $82
    STA $82
    LDA ($7B),Y
    INY
    STA $81
    LDA $7A
    AND #$23
    ORA $82
    EOR #$40
    STA $82
    JSR Bank2_Func_B6BA
    JMP Bank2_Label_B64E

Bank2_Label_B64C:
    INY

Bank2_Label_B64D:
    INY

Bank2_Label_B64E:
    DEC $7F
    BNE Bank2_Label_B5F6
    CLC
    RTS

Bank2_Label_B654:
    LDA ($7B),Y
    INY
    TAX
    AND #$7F
    SEC
    SBC $7E
    EOR #$FF
    CLC
    ADC #$01
    CLC
    ADC $77
    STA $80
    LDA $78
    ADC #$00
    AND #$03
    BNE Bank2_Label_B6B2
    LDA $80
    CMP #$F0
    BCS Bank2_Label_B6B2
    TXA
    AND #$80
    STA $82
    LDA ($7B),Y
    INY
    TAX
    AND #$7F
    SEC
    SBC $7D
    EOR #$FF
    CLC
    ADC #$01
    CLC
    ADC $75
    STA $83
    LDA $76
    ADC #$00
    AND #$03
    BNE Bank2_Label_B6B3
    TXA
    AND #$80
    LSR A
    ORA $82
    STA $82
    LDA ($7B),Y
    INY
    STA $81
    LDA $7A
    AND #$23
    ORA $82
    EOR #$C0
    STA $82
    JSR Bank2_Func_B6BA
    JMP Bank2_Label_B6B4

Bank2_Label_B6B2:
    INY

Bank2_Label_B6B3:
    INY

Bank2_Label_B6B4:
    DEC $7F
    BNE Bank2_Label_B654
    CLC
    RTS
