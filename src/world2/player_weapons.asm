; Doraemon PRG bank 1 $8C5D-$8F4A
; World 2 player animation, weapon state, and projectile creation
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank1_Func_8C5D:
    LDA $A8
    BEQ Bank1_Label_8C73
    LDA $73
    AND #$07
    BNE Bank1_Label_8C73
    INC $A8
    LDA $A8
    CMP #$05
    BNE Bank1_Label_8C73
    LDA #$00
    STA $A8

Bank1_Label_8C73:
    RTS

Bank1_Func_8C74:
    LDX #$03
    BNE Bank1_Label_8C86

Bank1_Func_8C78:
    LDX #$05
    BNE Bank1_Label_8C86

Bank1_Func_8C7C:
    LDX #$04
    BNE Bank1_Label_8C86

Bank1_Func_8C80:
    LDX #$06
    BNE Bank1_Label_8C86

Bank1_Func_8C84:
    LDX #$02

Bank1_Label_8C86:
    LDA $7C,X
    CMP #$01
    BEQ Bank1_Label_8CC3
    CMP #$04
    BEQ Bank1_Label_8CC3
    CMP #$02
    BNE Bank1_Label_8CC2
    LDY #$00
    LDA $5C
    CMP $83,X
    BEQ Bank1_Label_8CA5
    BCS Bank1_Label_8CA2
    DEC $83,X
    DEC $83,X

Bank1_Label_8CA2:
    INC $83,X
    INY

Bank1_Label_8CA5:
    LDA $5D
    CMP $8A,X
    BEQ Bank1_Label_8CB4
    BCS Bank1_Label_8CB1
    DEC $8A,X
    DEC $8A,X

Bank1_Label_8CB1:
    INC $8A,X
    INY

Bank1_Label_8CB4:
    TYA
    BNE Bank1_Label_8CC2
    LDA #$09
    JSR World2_Audio_QueueEffectWithPriority
    LDA #$00
    STA $A5
    INC $7C,X

Bank1_Label_8CC2:
    RTS

Bank1_Label_8CC3:
    JSR Bank1_Func_8CD9
    LDA $7C,X
    CMP #$01
    BNE Bank1_Label_8CC2
    LDA $8A,X
    CMP #$67
    BEQ Bank1_Label_8CD6
    CMP #$79
    BNE Bank1_Label_8CC2

Bank1_Label_8CD6:
    INC $7C,X
    RTS

Bank1_Func_8CD9:
    LDY $42
    BEQ Bank1_Label_8CEE
    DEY
    BEQ Bank1_Label_8CE5
    DEC $8A,X
    BEQ Bank1_Label_8CF6
    RTS

Bank1_Label_8CE5:
    INC $8A,X
    LDA $8A,X
    CMP #$E0
    BCS Bank1_Label_8CF6
    RTS

Bank1_Label_8CEE:
    LDA $45
    BNE Bank1_Label_8D00
    DEC $83,X
    BNE Bank1_Label_8D00

Bank1_Label_8CF6:
    LDA $7C,X
    CMP #$01
    BEQ Bank1_Label_8D00
    LDA #$00
    STA $7C,X

Bank1_Label_8D00:
    RTS

Bank1_Func_8D01:
    LDY #$00
    LDA $7D
    CMP #$01
    BEQ Bank1_Label_8D4A
    CMP #$04
    BEQ Bank1_Label_8D4A
    CMP #$02
    BNE Bank1_Label_8D49
    LDA $5F
    SEC
    SBC #$17
    BPL Bank1_Label_8D1A
    ADC #$30

Bank1_Label_8D1A:
    TAX
    LDA a:$0200,X
    CMP $84
    BEQ Bank1_Label_8D2B
    BCS Bank1_Label_8D28
    DEC $84
    DEC $84

Bank1_Label_8D28:
    INC $84
    INY

Bank1_Label_8D2B:
    LDA a:$0230,X
    CMP $8B
    BEQ Bank1_Label_8D3B
    BCS Bank1_Label_8D38
    DEC $8B
    DEC $8B

Bank1_Label_8D38:
    INC $8B
    INY

Bank1_Label_8D3B:
    TYA
    BNE Bank1_Label_8D49
    INC $7D
    LDA #$09
    JSR World2_Audio_QueueEffectWithPriority
    LDA #$00
    STA $A5

Bank1_Label_8D49:
    RTS

Bank1_Label_8D4A:
    JSR Bank1_Func_8D60
    LDA $7D
    CMP #$01
    BNE Bank1_Label_8D49
    LDA $8B
    CMP #$67
    BEQ Bank1_Label_8D5D
    CMP #$79
    BNE Bank1_Label_8D49

Bank1_Label_8D5D:
    INC $7D
    RTS

Bank1_Func_8D60:
    LDY $42
    BEQ Bank1_Label_8D75
    DEY
    BEQ Bank1_Label_8D6C
    DEC $8B
    BEQ Bank1_Label_8D7D
    RTS

Bank1_Label_8D6C:
    INC $8B
    LDA $8B
    CMP #$E0
    BCS Bank1_Label_8D7D
    RTS

Bank1_Label_8D75:
    LDA $45
    BNE Bank1_Label_8D87
    DEC $84
    BNE Bank1_Label_8D87

Bank1_Label_8D7D:
    LDA $7D
    CMP #$01
    BEQ Bank1_Label_8D87
    LDA #$00
    STA $7D

Bank1_Label_8D87:
    RTS

Bank1_Func_8D88:
    LDY #$00
    LDA $7C
    CMP #$01
    BEQ Bank1_Label_8DD1
    CMP #$04
    BEQ Bank1_Label_8DD1
    CMP #$02
    BNE Bank1_Label_8DD0
    LDA $5F
    SEC
    SBC #$2F
    BPL Bank1_Label_8DA1
    ADC #$30

Bank1_Label_8DA1:
    TAX
    LDA a:$0200,X
    CMP $83
    BEQ Bank1_Label_8DB2
    BCS Bank1_Label_8DAF
    DEC $83
    DEC $83

Bank1_Label_8DAF:
    INC $83
    INY

Bank1_Label_8DB2:
    LDA a:$0230,X
    CMP $8A
    BEQ Bank1_Label_8DC2
    BCS Bank1_Label_8DBF
    DEC $8A
    DEC $8A

Bank1_Label_8DBF:
    INC $8A
    INY

Bank1_Label_8DC2:
    TYA
    BNE Bank1_Label_8DD0
    LDA #$09
    JSR World2_Audio_QueueEffectWithPriority
    LDA #$00
    STA $A5
    INC $7C

Bank1_Label_8DD0:
    RTS

Bank1_Label_8DD1:
    JSR Bank1_Func_8DE7
    LDA $7C
    CMP #$01
    BNE Bank1_Label_8DD0
    LDA $8A
    CMP #$67
    BEQ Bank1_Label_8DE4
    CMP #$79
    BNE Bank1_Label_8DD0

Bank1_Label_8DE4:
    INC $7C
    RTS

Bank1_Func_8DE7:
    LDY $42
    BEQ Bank1_Label_8DFC
    DEY
    BEQ Bank1_Label_8DF3
    DEC $8A
    BEQ Bank1_Label_8E04
    RTS

Bank1_Label_8DF3:
    INC $8A
    LDA $8A
    CMP #$E0
    BCS Bank1_Label_8E04
    RTS

Bank1_Label_8DFC:
    LDA $45
    BNE Bank1_Label_8E0E
    DEC $83
    BNE Bank1_Label_8E0E

Bank1_Label_8E04:
    LDA $7C
    CMP #$01
    BEQ Bank1_Label_8E0E
    LDA #$00
    STA $7C

Bank1_Label_8E0E:
    RTS

Bank1_Func_8E0F:
    LDX $5F
    DEX
    BPL Bank1_Label_8E16
    LDX #$30

Bank1_Label_8E16:
    LDA $5C
    CMP a:$0200,X
    BNE Bank1_Label_8E25
    LDA $5D
    CMP a:$0230,X
    BNE Bank1_Label_8E25
    RTS

Bank1_Label_8E25:
    LDX $5F
    LDA $5C
    STA a:$0200,X
    LDA $5D
    STA a:$0230,X
    INX
    TXA
    CMP #$30
    BNE Bank1_Label_8E39
    LDA #$00

Bank1_Label_8E39:
    STA $5F
    RTS

Bank1_Func_8E3C:
    LDA $27
    BEQ Bank1_Label_8E4E
    LDA $73
    ROL A
    ROL A
    ROL A
    ROL A
    AND #$07
    TAY
    LDA a:$97BD,Y
    BNE Bank1_Label_8E50

Bank1_Label_8E4E:
    LDA $21

Bank1_Label_8E50:
    TAX
    AND #$01
    BEQ Bank1_Label_8E63
    LDA $5C
    CMP #$D0
    BCS Bank1_Label_8E73
    LDA $5E
    ADC $5C
    STA $5C
    BNE Bank1_Label_8E73

Bank1_Label_8E63:
    TXA
    AND #$02
    BEQ Bank1_Label_8E73
    LDA $5C
    SEC
    SBC $5E
    CMP #$20
    BCC Bank1_Label_8E73
    STA $5C

Bank1_Label_8E73:
    TXA
    AND #$04
    BEQ Bank1_Label_8E84
    LDA $5D
    CMP #$D0
    BCS Bank1_Label_8E93
    ADC $5E
    STA $5D
    BNE Bank1_Label_8E93

Bank1_Label_8E84:
    TXA
    AND #$08
    BEQ Bank1_Label_8E93
    LDA $5D
    SBC $5E
    CMP #$20
    BCC Bank1_Label_8E93
    STA $5D

Bank1_Label_8E93:
    TXA
    AND #$C0
    BNE Bank1_Label_8E9B
    STA $7A

Bank1_Label_8E9A:
    RTS

Bank1_Label_8E9B:
    INC $B1
    LDA $A0
    CMP #$50
    BCS Bank1_Label_8E9A
    LDA $7A
    BEQ Bank1_Label_8EB3
    INC $7A
    LDX #$1E
    CPX $7A
    BNE Bank1_Label_8E9A
    LDA #$00
    STA $7A

Bank1_Label_8EB3:
    INC $7A
    LDA #$00
    STA $91
    LDA $7D
    CMP #$03
    BNE Bank1_Label_8F0C
    LDA $7B
    EOR #$01
    STA $7B
    AND #$01
    BEQ Bank1_Label_8F0C
    INC $92
    LDA $92
    AND #$01
    BEQ Bank1_Label_8F0C
    LDA $92
    AND #$03
    STA $91
    LDA #$01
    JSR World2_Audio_QueueEffectWithPriority
    LDX #$06

Bank1_Label_8EDE:
    LDA a:$05B3,X
    BEQ Bank1_Label_8EED
    DEX
    CPX #$03
    BNE Bank1_Label_8EDE
    LDA #$00
    STA $7A
    RTS

Bank1_Label_8EED:
    LDA $5F
    SEC
    SBC #$17
    BPL Bank1_Label_8EF6
    ADC #$30

Bank1_Label_8EF6:
    TAY
    LDA a:$0200,Y
    CLC
    ADC #$04
    STA a:$05BA,X
    LDA a:$0230,Y
    CLC
    ADC #$08
    STA a:$05C1,X
    JMP Bank1_Label_8F40

Bank1_Label_8F0C:
    JSR Bank1_Func_8F4B
    LDA $27
    BNE Bank1_Label_8F19
    LDA $7E
    CMP #$03
    BNE Bank1_Label_8F1C

Bank1_Label_8F19:
    JMP Bank1_Func_8F80

Bank1_Label_8F1C:
    LDX #$03

Bank1_Label_8F1E:
    LDA a:$05B3,X
    BEQ Bank1_Label_8F2B
    DEX
    BPL Bank1_Label_8F1E
    LDA #$00
    STA $7A
    RTS

Bank1_Label_8F2B:
    LDA #$01
    JSR World2_Audio_QueueEffectWithPriority
    LDA $5C
    CLC
    ADC #$04
    STA a:$05BA,X
    LDA $5D
    CLC
    ADC #$08
    STA a:$05C1,X

Bank1_Label_8F40:
    LDA #$01
    STA a:$05B3,X
    LDA $91
    STA a:$05C8,X
    RTS
