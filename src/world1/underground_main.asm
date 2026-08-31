; Doraemon PRG bank 0 $CDB5-$D112
; World 1 side-view underground initialization, frame loop, and movement
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank0_InitWorld1SideView:
    LDX #$00

Bank0_Label_CDB7:
    LDA a:$0680,X
    STA a:$0690,X
    LDA a:$06A0,X
    STA a:$0680,X
    INX
    CPX #$10
    BNE Bank0_Label_CDB7
    JSR Bank0_Func_83A3
    LDA $81
    SEC
    SBC #$08
    STA $85
    CLC
    ADC #$03
    STA $29
    JSR Bank0_Func_843B
    JMP Bank0_Label_CDE3

Bank0_Label_CDDD:
    JSR Bank0_Func_83E8
    JSR Bank0_Func_843B

Bank0_Label_CDE3:
    LDA $85
    ASL A
    ASL A
    TAY
    LDA #$01
    STA $51
    LDA #$00
    STA $79
    LDA a:$D213,Y
    STA $75
    LDA a:$D214,Y
    STA $76
    LDA a:$D215,Y
    STA $86
    LDA a:$D216,Y
    STA $87
    LDA a:$D1EF,Y
    STA $5B
    LDA a:$D1F0,Y
    STA $5C
    LDA a:$D1F1,Y
    STA $88
    LDA a:$D1F2,Y
    STA $89
    LDA #$00
    STA $8A
    LDA #$01
    STA $7C
    LDA #$00
    STA $7D
    LDA #$00
    STA $7E
    LDA #$00
    STA $8B
    LDA #$00
    STA $9B
    JSR Bank0_Func_9614
    LDA #$EF
    STA $66
    LDA #$C2
    STA $67
    LDA #$25
    STA $68
    LDA #$D9
    STA $69
    JSR Bank0_Func_C96A
    JSR Bank0_Func_83BD
    JSR Bank0_Func_A7DB
    JSR Bank0_Func_9535
    JSR Bank0_Func_95ED
    LDX #$7F
    TXS

Bank0_Label_CE55:
    JSR Bank0_Func_94F1
    JSR Bank0_Func_8490
    JSR Bank0_Func_95CB
    JSR Bank0_Func_9B54
    JSR Bank0_Func_CF7A
    JSR Bank0_Func_CA6D
    JSR Bank0_Func_9201
    JSR Bank0_Func_CF08
    JSR Bank0_Func_8BDE
    JSR Bank0_Func_8BDE
    JSR Bank0_Func_888F
    JSR Bank0_Func_8EF6
    JSR Bank0_Func_931B
    JSR Bank0_Func_820E
    LDA $79
    BMI Bank0_Label_CE90
    LDA $76
    CMP #$F8
    BCS Bank0_Label_CEAB
    CMP #$E0
    BCS Bank0_Label_CEC2
    JMP Bank0_Label_CE55

Bank0_Label_CE90:
    JSR Bank0_Func_884C
    DEC $2A
    BMI Bank0_Label_CE9E
    LDA $85
    STA $81
    JMP Bank0_Label_CDDD

Bank0_Label_CE9E:
    JSR Bank0_Func_8065
    LDA #$02
    STA $2A
    JSR Bank0_Func_C92F
    JMP Bank0_Label_CDDD

Bank0_Label_CEAB:
    LDA $8B
    BNE Bank0_Label_CEE5
    LDA $86
    STA $00
    LDA $89
    BEQ Bank0_Label_CEBB
    LDA $87
    STA $00

Bank0_Label_CEBB:
    LDA $00
    BMI Bank0_Label_CE55
    JMP Bank0_Func_D2C3

Bank0_Label_CEC2:
    INC $8B
    LDA #$00
    STA $8A
    LDA $5C
    CLC
    ADC #$20
    STA $5C
    LDA $76
    SEC
    SBC #$E0
    STA $76
    JSR Bank0_Func_C96A
    JSR Bank0_Func_9614
    JSR Bank0_Func_A7DB
    JSR Bank0_Func_95ED
    JMP Bank0_Label_CE55

Bank0_Label_CEE5:
    DEC $8B
    LDA #$00
    STA $8A
    LDA $5C
    SEC
    SBC #$20
    STA $5C
    LDA $76
    CLC
    ADC #$B0
    STA $76
    JSR Bank0_Func_C96A
    JSR Bank0_Func_9614
    JSR Bank0_Func_A7DB
    JSR Bank0_Func_95ED
    JMP Bank0_Label_CE55

Bank0_Func_CF08:
    LDA #$00
    STA $61
    STA $62
    LDA $75
    SEC
    SBC #$6E
    BCS Bank0_Label_CF42
    EOR #$FF
    SEC
    ADC #$00
    STA $8C
    CMP #$03
    BCC Bank0_Label_CF24
    LDA #$02
    STA $8C

Bank0_Label_CF24:
    LDA $89
    ORA $8A
    BEQ Bank0_Label_CF6F
    LDA $8A
    SEC
    SBC #$01
    AND #$07
    STA $8A
    CMP #$07
    BNE Bank0_Label_CF39
    DEC $89

Bank0_Label_CF39:
    JSR Bank0_Func_A3E1
    DEC $8C
    BNE Bank0_Label_CF24
    BEQ Bank0_Label_CF6F

Bank0_Label_CF42:
    LDA $75
    SEC
    SBC #$82
    BCC Bank0_Label_CF6F
    STA $8C
    CMP #$02
    BCC Bank0_Label_CF53
    LDA #$01
    STA $8C

Bank0_Label_CF53:
    INC $8C

Bank0_Label_CF55:
    LDA $89
    CMP $88
    BEQ Bank0_Label_CF6F
    LDA $8A
    CLC
    ADC #$01
    AND #$07
    STA $8A
    BNE Bank0_Label_CF68
    INC $89

Bank0_Label_CF68:
    JSR Bank0_Func_A381
    DEC $8C
    BNE Bank0_Label_CF55

Bank0_Label_CF6F:
    LDA $75
    CLC
    ADC $61
    STA $75
    JSR Bank0_Func_8750
    RTS

Bank0_Func_CF7A:
    JSR Bank0_Func_9BFC
    LDA $79
    BEQ Bank0_Label_CFC0
    BPL Bank0_Label_CF84
    RTS

Bank0_Label_CF84:
    LDA #$40
    STA $78
    LDA $16
    AND #$03
    BNE Bank0_Label_CF90
    INC $79

Bank0_Label_CF90:
    LDA $79
    CMP #$06
    BCS Bank0_Label_CFA7
    LDA $16
    LSR A
    LSR A
    AND #$01
    ORA #$10
    STA $77
    LDA #$00
    STA $78
    JMP Bank0_Label_CFDF

Bank0_Label_CFA7:
    CMP #$16
    BCC Bank0_Label_CFAF
    LDA #$00
    STA $79

Bank0_Label_CFAF:
    LDA $77
    AND #$03
    STA $00
    LDA $7F
    ASL A
    ASL A
    ORA $00
    STA $77
    JMP Bank0_Label_CFC4

Bank0_Label_CFC0:
    LDA #$00
    STA $78

Bank0_Label_CFC4:
    LDA $7C
    BNE Bank0_Label_CFDF
    LDA $63
    BEQ Bank0_Label_CFDF
    CMP #$03
    BCS Bank0_Label_CFD9
    LDA $77
    AND #$0C
    STA $77
    JMP Bank0_Label_CFDF

Bank0_Label_CFD9:
    LDA $77
    ORA #$01
    STA $77

Bank0_Label_CFDF:
    LDA $77
    STA $01
    LDA $75
    STA $06
    LDA $76
    STA $07
    LDA $7C
    BEQ Bank0_Label_CFF5
    JSR Bank0_Func_D145
    JMP Bank0_Label_D004

Bank0_Label_CFF5:
    LDA $65
    AND #$80
    BEQ Bank0_Label_D001
    JSR Bank0_Func_D138
    JMP Bank0_Label_D004

Bank0_Label_D001:
    JSR Bank0_Func_D113

Bank0_Label_D004:
    LDA $21
    AND #$02
    BNE Bank0_Label_D036
    LDA $21
    AND #$01
    BNE Bank0_Label_D084
    LDA $79
    BEQ Bank0_Label_D018
    CMP #$06
    BCC Bank0_Label_D02E

Bank0_Label_D018:
    LDA $7C
    BNE Bank0_Label_D02F
    INC $7A
    LDA $7A
    CMP #$05
    BCC Bank0_Label_D02E
    LDA #$00
    STA $7A
    LDA $77
    AND #$0C
    STA $77

Bank0_Label_D02E:
    RTS

Bank0_Label_D02F:
    LDA $77
    ORA #$01
    STA $77
    RTS

Bank0_Label_D036:
    LDA #$02
    STA $7F
    DEC $75
    LDA $7E
    SEC
    SBC #$80
    STA $7E
    BCS Bank0_Label_D047
    DEC $75

Bank0_Label_D047:
    LDA $75
    CMP #$05
    BCS Bank0_Label_D051
    LDA #$05
    STA $75

Bank0_Label_D051:
    LDX #$00
    LDY #$19
    JSR Bank0_Func_D1C3
    BCS Bank0_Label_D06C
    LDX #$00
    LDY #$0E
    JSR Bank0_Func_D1C3
    BCS Bank0_Label_D06C
    LDX #$00
    LDY #$02
    JSR Bank0_Func_D1C3
    BCC Bank0_Label_D070

Bank0_Label_D06C:
    LDA $06
    STA $75

Bank0_Label_D070:
    LDA $7C
    BEQ Bank0_Label_D07D
    LDA #$00
    STA $7A
    LDA #$09
    STA $77
    RTS

Bank0_Label_D07D:
    LDA #$09
    STA $01
    JMP Bank0_Label_D0D2

Bank0_Label_D084:
    LDA #$03
    STA $7F
    INC $75
    LDA $7E
    CLC
    ADC #$80
    STA $7E
    BCC Bank0_Label_D095
    INC $75

Bank0_Label_D095:
    LDA $75
    CMP #$EC
    BCC Bank0_Label_D09F
    LDA #$EB
    STA $75

Bank0_Label_D09F:
    LDX #$0E
    LDY #$19
    JSR Bank0_Func_D1C3
    BCS Bank0_Label_D0BA
    LDX #$0E
    LDY #$0E
    JSR Bank0_Func_D1C3
    BCS Bank0_Label_D0BA
    LDX #$0E
    LDY #$02
    JSR Bank0_Func_D1C3
    BCC Bank0_Label_D0BE

Bank0_Label_D0BA:
    LDA $06
    STA $75

Bank0_Label_D0BE:
    LDA $7C
    BEQ Bank0_Label_D0CB
    LDA #$00
    STA $7A
    LDA #$0D
    STA $77
    RTS

Bank0_Label_D0CB:
    LDA #$0D
    STA $01
    JMP Bank0_Label_D0D2

Bank0_Label_D0D2:
    LDA $79
    BEQ Bank0_Label_D0DA
    CMP #$06
    BCC Bank0_Label_D112

Bank0_Label_D0DA:
    LDA $77
    AND #$0C
    STA $00
    LDA $01
    AND #$0C
    CMP $00
    BEQ Bank0_Label_D0F2
    LDA $01
    STA $77
    LDA #$00
    STA $7A
    STA $63

Bank0_Label_D0F2:
    LDA $63
    BNE Bank0_Label_D112
    INC $7A
    LDA $7A
    CMP #$05
    BCC Bank0_Label_D112
    LDA #$00
    STA $7A
    LDA $77
    AND #$0C
    STA $00
    INC $77
    LDA $77
    AND #$03
    ORA $00
    STA $77

Bank0_Label_D112:
    RTS
