; Doraemon PRG bank 0 $8A6C-$8F9D
; World 1 object coordinate stepping, animation, and collision helpers
; Generated deterministically from pinned Ghidra/GhidraNes facts

World1_MoveEntityXByA:
    ORA #$00
    BMI Bank0_Label_8A8B
    CLC
    ADC a:World1EntityX,X
    STA a:World1EntityX,X
    BCC Bank0_Label_8A8A
    LDA a:World1EntityPositionHigh,X
    TAY
    AND #$0C
    STA $00
    INY
    TYA
    AND #$03
    ORA $00
    STA a:World1EntityPositionHigh,X

Bank0_Label_8A8A:
    RTS

Bank0_Label_8A8B:
    CLC
    ADC a:World1EntityX,X
    STA a:World1EntityX,X
    BCS Bank0_Label_8A8A
    LDA a:World1EntityPositionHigh,X
    TAY
    AND #$0C
    STA $00
    DEY
    TYA
    AND #$03
    ORA $00
    STA a:World1EntityPositionHigh,X
    RTS

World1_MoveEntityYByA:
    ORA #$00
    BMI Bank0_Label_8ABF
    CLC
    ADC a:World1EntityY,X
    STA a:World1EntityY,X
    BCC Bank0_Label_8ABE
    LDA a:World1EntityPositionHigh,X
    CLC
    ADC #$04
    AND #$0F
    STA a:World1EntityPositionHigh,X

Bank0_Label_8ABE:
    RTS

Bank0_Label_8ABF:
    CLC
    ADC a:World1EntityY,X
    STA a:World1EntityY,X
    BCS Bank0_Label_8ABE
    LDA a:World1EntityPositionHigh,X
    SEC
    SBC #$04
    AND #$0F
    STA a:World1EntityPositionHigh,X
    RTS
    .byte $BD, $90, $04, $29, $03, $85, $00, $A5, $1B, $29, $07, $18, $7D, $C0, $04, $85
    .byte $02, $A5, $00, $69, $00, $85, $00, $A5, $02, $46, $00, $6A, $46, $00, $6A, $48
    .byte $29, $80, $85, $00, $68, $4A, $05, $00, $18, $65, $5B, $85, $00, $BD, $90, $04
    .byte $29, $0C, $4A, $4A, $85, $01, $A5, $1C, $29, $07, $18, $7D, $F0, $04, $85, $02
    .byte $A5, $01, $69, $00, $85, $01, $A5, $02, $46, $01, $6A, $46, $01, $6A, $48, $29
    .byte $80, $85, $01, $68, $4A, $05, $01, $18, $65, $5C, $85, $01, $60, $18, $65, $00
    .byte $85, $02, $98, $18, $65, $01, $A8, $8A, $48, $A6, $02, $20, $A7, $A6, $68, $AA
    .byte $60, $29, $07, $A8, $F0, $1B, $88, $F0, $76, $88, $F0, $30, $88, $F0, $79, $88
    .byte $F0, $3E, $88, $F0, $7C, $88, $F0, $53, $20, $65, $8B, $B0, $03, $20, $AF, $8B
    .byte $60, $A9, $00, $A4, $9A, $20, $31, $8B, $20, $E8, $A6, $C9, $42, $B0, $0C, $20
    .byte $E8, $A6, $C9, $42, $B0, $05, $20, $E2, $A6, $C9, $42, $60, $A5, $99, $A0, $01
    .byte $20, $31, $8B, $20, $19, $A7, $C9, $42, $B0, $05, $20, $E2, $A6, $C9, $42, $60
    .byte $A9, $00, $A0, $01, $20, $31, $8B, $20, $E8, $A6, $C9, $42, $B0, $0C, $20, $E8
    .byte $A6, $C9, $42, $B0, $05, $20, $E2, $A6, $C9, $42, $60, $A9, $00, $A0, $01, $20
    .byte $31, $8B, $20, $19, $A7, $C9, $42, $B0, $05, $20, $E2, $A6, $C9, $42, $60, $20
    .byte $65, $8B, $B0, $03, $20, $80, $8B, $60, $20, $94, $8B, $B0, $03, $20, $80, $8B
    .byte $60, $20, $AF, $8B, $B0, $03, $20, $94, $8B, $60

Bank0_Func_8BDE:
    LDA $61
    BMI Bank0_Label_8BE7
    BNE Bank0_Label_8C03
    JMP Bank0_Label_8C1A

Bank0_Label_8BE7:
    EOR #$FF
    CLC
    ADC #$01
    STA $8D
    LDA PpuScrollXShadow
    AND #$07
    CMP $8D
    BCS Bank0_Label_8C02
    LDA $5B
    CLC
    ADC #$24
    BCS Bank0_Label_8C02
    STA $8D
    JMP Bank0_Label_8CBA

Bank0_Label_8C02:
    RTS

Bank0_Label_8C03:
    LDA PpuScrollXShadow
    AND #$07
    CLC
    ADC $61
    CMP #$08
    BCC Bank0_Label_8BE7
    LDA $5B
    SEC
    SBC #$04
    BCC Bank0_Label_8C02
    STA $8D
    JMP Bank0_Label_8CBA

Bank0_Label_8C1A:
    LDA $62
    BMI Bank0_Label_8C21
    BNE Bank0_Label_8C3E
    RTS

Bank0_Label_8C21:
    EOR #$FF
    CLC
    ADC #$01
    STA $8D
    LDA PpuScrollYShadow
    AND #$07
    CMP $8D
    BCC Bank0_Label_8C31
    RTS

Bank0_Label_8C31:
    LDA $5C
    CLC
    ADC #$22
    BCC Bank0_Label_8C39
    RTS

Bank0_Label_8C39:
    STA $8D
    JMP Bank0_Label_8C54

Bank0_Label_8C3E:
    LDA PpuScrollYShadow
    AND #$07
    CLC
    ADC $62
    CMP #$08
    BCS Bank0_Label_8C4A
    RTS

Bank0_Label_8C4A:
    LDA $5C
    SEC
    SBC #$04
    BCS Bank0_Label_8C52
    RTS

Bank0_Label_8C52:
    STA $8D

Bank0_Label_8C54:
    LDA #$FF
    STA $8E
    LDA $5B
    CLC
    ADC #$24
    BCS Bank0_Label_8C61
    STA $8E

Bank0_Label_8C61:
    LDA #$00
    STA $8F
    LDA $5B
    SEC
    SBC #$04
    BCC Bank0_Label_8C6E
    STA $8F

Bank0_Label_8C6E:
    LDA $68
    STA $91
    LDA $69
    STA $92
    LDA #$00
    STA $90

Bank0_Label_8C7A:
    LDY #$00
    LDA ($91),Y
    BEQ Bank0_Label_8CB9
    CMP $8F
    BCS Bank0_Label_8C96

Bank0_Label_8C84:
    LDA $91
    CLC
    ADC #$03
    STA $91
    LDA $92
    ADC #$00
    STA $92
    INC $90
    JMP Bank0_Label_8C7A

Bank0_Label_8C96:
    CMP $8E
    BCS Bank0_Label_8CB3
    STA $93
    INY
    LDA ($91),Y
    CMP $8D
    BNE Bank0_Label_8C84
    STA $94
    JSR Bank0_Func_8D22
    BNE Bank0_Label_8C84
    INY
    LDA ($91),Y
    JSR Bank0_Func_8DC4
    JMP Bank0_Label_8C84

Bank0_Label_8CB3:
    LDA $90
    CMP #$2D
    BCC Bank0_Label_8C84

Bank0_Label_8CB9:
    RTS

Bank0_Label_8CBA:
    LDA #$FF
    STA $8E
    LDA $5C
    CLC
    ADC #$22
    BCS Bank0_Label_8CC7
    STA $8E

Bank0_Label_8CC7:
    LDA #$00
    STA $8F
    LDA $5C
    SEC
    SBC #$04
    BCC Bank0_Label_8CD4
    STA $8F

Bank0_Label_8CD4:
    LDA $68
    STA $91
    LDA $69
    STA $92
    LDA #$00
    STA $90

Bank0_Label_8CE0:
    LDY #$00
    LDA ($91),Y
    BEQ Bank0_Label_8D21
    CMP $8D
    BEQ Bank0_Label_8CFE
    BCS Bank0_Label_8D1B

Bank0_Label_8CEC:
    LDA $91
    CLC
    ADC #$03
    STA $91
    LDA $92
    ADC #$00
    STA $92
    INC $90
    JMP Bank0_Label_8CE0

Bank0_Label_8CFE:
    STA $93
    INY
    LDA ($91),Y
    CMP $8E
    BCS Bank0_Label_8CEC
    CMP $8F
    BCC Bank0_Label_8CEC
    STA $94
    JSR Bank0_Func_8D22
    BNE Bank0_Label_8CEC
    INY
    LDA ($91),Y
    JSR Bank0_Func_8DC4
    JMP Bank0_Label_8CEC

Bank0_Label_8D1B:
    LDA $90
    CMP #$2D
    BCC Bank0_Label_8CEC

Bank0_Label_8D21:
    RTS

Bank0_Func_8D22:
    LDA $90
    AND #$07
    TAX
    LDA a:$8D9C,X
    STA $07
    LDA $90
    LSR A
    LSR A
    LSR A
    TAX
    LDA a:$0670,X
    AND $07
    STA $06
    LDA a:$0680,X
    AND $07
    ORA $06
    STA $06
    LDA $06
    RTS

Bank0_Func_8D45:
    STA $03
    TXA
    PHA
    LDA $03
    AND #$07
    TAX
    LDA a:$8D9C,X
    PHA
    LDA $03
    LSR A
    LSR A
    LSR A
    TAX
    PLA
    ORA a:$0670,X
    STA a:$0670,X
    PLA
    TAX
    RTS

Bank0_Func_8D62:
    STA $03
    TXA
    PHA
    LDA $03
    AND #$07
    TAX
    LDA a:$8D9C,X
    EOR #$FF
    PHA
    LDA $03
    LSR A
    LSR A
    LSR A
    TAX
    PLA
    AND a:$0670,X
    STA a:$0670,X
    PLA
    TAX
    RTS

Bank0_Func_8D81:
    TXA
    PHA
    LDA $00
    AND #$07
    TAX
    LDA a:$8D9C,X
    PHA
    LDA $00
    LSR A
    LSR A
    LSR A
    TAX
    PLA
    ORA a:$0680,X
    STA a:$0680,X
    PLA
    TAX
    RTS
    .byte $80, $40, $20, $10, $08, $04, $02, $01, $9F, $8E, $32, $DC, $9F, $8E, $9F, $8E
    .byte $9F, $8E, $9F, $8E, $16, $E0, $41, $E1, $9F, $8E, $40, $E2, $9F, $8E, $9F, $8E
    .byte $9F, $8E, $9F, $8E, $9F, $8E, $9F, $8E

Bank0_Func_8DC4:
    PHA
    LDA $93
    STA $06
    LDA $94
    STA $07
    LDA $90
    STA $03
    PLA
    TAY
    BMI Bank0_Label_8E27
    LDX #$00

Bank0_Label_8DD7:
    LDA a:World1EntityType,X
    BEQ Bank0_Label_8DE2
    INX
    CPX #$0A
    BNE Bank0_Label_8DD7
    RTS

Bank0_Label_8DE2:
    LDA $90
    AND #$7F
    STA a:$0520,X
    JSR Bank0_Func_8D45
    TYA
    STA a:World1EntityType,X
    INC a:World1EntityType,X
    LDA a:$8E70,Y
    STA a:World1EntityMetasprite,X
    LDA a:$8E80,Y
    STA a:World1EntityRenderFlags,X
    LDA a:$8E90,Y
    STA a:$05B0,X
    LDA #$00
    STA a:$0550,X
    STA a:$0580,X
    STA a:$05E0,X
    STA a:$0610,X
    STA a:$0640,X
    TYA
    ASL A
    AND #$0F
    TAY
    JMP Bank0_Label_8E1E

Bank0_Label_8E1E:
    LDA a:$8DA5,Y
    PHA
    LDA a:$8DA4,Y
    PHA
    RTS

Bank0_Label_8E27:
    PHA
    JSR World1_FindFreeEntitySlot38_47
    BEQ Bank0_Label_8E2F
    PLA
    RTS

Bank0_Label_8E2F:
    PLA
    PHA
    ASL A
    ASL A
    AND #$3F
    TAY
    LDA a:$CC0A,Y
    STA a:World1EntityType,X
    LDA a:$CC0B,Y
    STA a:World1EntityMetasprite,X
    BNE Bank0_Label_8E4C
    LDA $7B
    CLC
    ADC #$2A
    STA a:World1EntityMetasprite,X

Bank0_Label_8E4C:
    LDA a:$CC0C,Y
    STA a:World1EntityRenderFlags,X
    PLA
    AND #$40
    BEQ Bank0_Label_8E5F
    LDA a:World1EntityType,X
    ORA #$80
    STA a:World1EntityType,X

Bank0_Label_8E5F:
    LDA $90
    STA a:$0520,X
    JSR Bank0_Func_8D45
    LDA a:$CC0D,Y
    STA a:$0550,X
    JMP Bank0_Label_8EA0
    .byte $64, $5C, $56, $60, $58, $4C, $54, $70, $6C, $3E, $60, $58, $00, $00, $00, $00
    .byte $01, $01, $01, $02, $02, $02, $01, $02, $01, $01, $02, $02, $00, $00, $00, $00
    .byte $02, $01, $02, $04, $01, $01, $02, $01, $02, $04, $04, $01, $00, $00, $00, $00

Bank0_Label_8EA0:
    LDA #$00
    STA a:World1EntityPositionHigh,X
    LDA $07
    SEC
    SBC $5C
    ASL A
    ASL A
    ROL a:World1EntityPositionHigh,X
    ASL A
    ROL a:World1EntityPositionHigh,X
    STA $07
    LDA PpuScrollYShadow
    AND #$07
    EOR #$FF
    CLC
    ADC $07
    STA a:World1EntityY,X
    BCS Bank0_Label_8EC6
    DEC a:World1EntityPositionHigh,X

Bank0_Label_8EC6:
    LDA $06
    SEC
    SBC $5B
    ASL A
    ASL A
    ROL a:World1EntityPositionHigh,X
    ASL A
    ROL a:World1EntityPositionHigh,X
    STA $06
    LDA PpuScrollXShadow
    AND #$07
    EOR #$FF
    SEC
    ADC $06
    STA a:World1EntityX,X
    BCS Bank0_Label_8EF5
    LDA a:World1EntityPositionHigh,X
    TAY
    AND #$0C
    STA $08
    DEY
    TYA
    AND #$03
    ORA $08
    STA a:World1EntityPositionHigh,X

Bank0_Label_8EF5:
    RTS

Bank0_Func_8EF6:
    LDA $82
    BNE Bank0_Label_8F46
    LDX #$0A

Bank0_Label_8EFC:
    LDA a:World1EntityType,X
    BEQ Bank0_Label_8F41
    CMP #$01
    BEQ Bank0_Label_8F2A
    CMP #$02
    BEQ Bank0_Label_8F12
    JSR Bank0_Func_8F47
    JSR Bank0_Func_8F47
    JMP Bank0_Label_8F2D

Bank0_Label_8F12:
    JSR Bank0_Func_8F9E
    LDA a:$05B0,X
    BPL Bank0_Label_8F2D
    JSR Bank0_Func_9004
    BEQ Bank0_Label_8F37
    EOR #$FF
    SEC
    ADC #$01
    STA a:$05B0,X
    JMP Bank0_Label_8F37

Bank0_Label_8F2A:
    JSR Bank0_Func_8FC5

Bank0_Label_8F2D:
    JSR Bank0_Func_9004
    BEQ Bank0_Label_8F37
    LDA #$00
    STA a:World1EntityType,X

Bank0_Label_8F37:
    LDA a:World1EntityPositionHigh,X
    BEQ Bank0_Label_8F41
    LDA #$00
    STA a:World1EntityType,X

Bank0_Label_8F41:
    INX
    CPX #$1E
    BNE Bank0_Label_8EFC

Bank0_Label_8F46:
    RTS

Bank0_Func_8F47:
    LDA #$FF
    STA $95
    STA $96
    LDA a:$0550,X
    TAY
    AND #$04
    BEQ Bank0_Label_8F59
    LDA #$01
    STA $95

Bank0_Label_8F59:
    TYA
    AND #$02
    BEQ Bank0_Label_8F62
    LDA #$01
    STA $96

Bank0_Label_8F62:
    TYA
    AND #$01
    BNE Bank0_Label_8F83
    LDA $95
    JSR World1_MoveEntityXByA
    LDA a:$05B0,X
    CLC
    ADC a:$05E0,X
    STA a:$05B0,X
    BPL Bank0_Label_8F82
    AND #$7F
    STA a:$05B0,X
    LDA $96
    JMP World1_MoveEntityYByA

Bank0_Label_8F82:
    RTS

Bank0_Label_8F83:
    LDA $96
    JSR World1_MoveEntityYByA
    LDA a:$05B0,X
    CLC
    ADC a:$05E0,X
    STA a:$05B0,X
    BPL Bank0_Label_8F82
    AND #$7F
    STA a:$05B0,X
    LDA $95
    JMP World1_MoveEntityXByA
