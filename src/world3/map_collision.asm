; Doraemon PRG bank 2 $A0C4-$A21C
; World 3 hierarchical map lookup and tile collision
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank2_Func_A0C4:
    TXA
    LSR A
    LSR A
    LSR A
    STA $40
    TYA
    LSR A
    LSR A
    LSR A
    STA $41
    JSR Bank2_Func_A904
    LDX #$00
    STX $09
    LDA $41
    AND #$FC
    ASL A
    ROL $09
    ASL A
    ROL $09
    ASL A
    ROL $09
    ASL A
    ROL $09
    CLC
    ADC $84
    STA $08
    LDA $09
    ADC $85
    STA $09
    LDA $40
    LSR A
    LSR A
    TAY
    LDA ($08),Y
    LDX #$00
    STX $3D
    ASL A
    ROL $3D
    ASL A
    ROL $3D
    CLC
    ADC #$F2
    STA $3C
    LDA $3D
    ADC #$E2
    STA $3D
    LDA $41
    AND #$02
    STA $08
    LDA $40
    AND #$02
    LSR A
    ORA $08
    TAY
    LDA ($3C),Y
    LDX #$00
    STX $3D
    ASL A
    ROL $3D
    ASL A
    ROL $3D
    CLC
    ADC #$F2
    STA $3C
    LDA $3D
    ADC #$DE
    STA $3D
    LDA $41
    AND #$01
    ASL A
    STA $08
    LDA $40
    AND #$01
    ORA $08
    TAY
    LDA ($3C),Y
    RTS

Bank2_Label_A144:
    INC a:$0703,X
    LDA a:$0703,X
    AND #$03
    BNE Bank2_Label_A1C0
    INC a:$0701,X
    LDA a:$0701,X
    CMP #$A3
    BNE Bank2_Label_A1C0
    LDA #$00
    STA a:$06F9,X
    JMP Bank2_Label_A1C0

Bank2_Func_A160:
    LDA #$00
    STA $07
    LDA #$02
    STA $06

Bank2_Label_A168:
    LDX $07
    LDA a:$06F9,X
    BEQ Bank2_Label_A1C0
    CMP #$02
    BEQ Bank2_Label_A144
    LDA a:$06FB,X
    STA $46
    LDA a:$06FD,X
    STA $47
    JSR Bank2_Func_9FDB
    BCS Bank2_Label_A19B
    LDX $07
    LDA #$02
    STA a:$06F9,X
    LDA #$00
    STA a:$0703,X
    LDA #$A0
    STA a:$0701,X
    LDA #$02
    JSR Bank2_Func_A5DF
    JMP Bank2_Label_A1C0

Bank2_Label_A19B:
    LDA a:$06FF,X
    BNE Bank2_Label_A1AE
    LDA a:$06FB,X
    SEC
    SBC #$03
    STA a:$06FB,X
    BCS Bank2_Label_A1C0
    JMP Bank2_Label_A1BB

Bank2_Label_A1AE:
    LDA a:$06FB,X
    CLC
    ADC #$03
    STA a:$06FB,X
    CMP #$F0
    BCC Bank2_Label_A1C0

Bank2_Label_A1BB:
    LDA #$00
    STA a:$06F9,X

Bank2_Label_A1C0:
    INC $07
    DEC $06
    BNE Bank2_Label_A168
    RTS

Bank2_Func_A1C7:
    LDA #$00
    STA $00
    LDA #$02
    STA $01

Bank2_Label_A1CF:
    LDX $00
    LDA a:$06F9,X
    BEQ Bank2_Label_A1ED
    LDA a:$0701,X
    STA $79
    LDA a:$06FD,X
    TAY
    LDA a:$06FB,X
    TAX
    JSR Bank2_Func_A71A
    LDA #$00
    STA $7A
    JSR Bank2_Func_B4B6

Bank2_Label_A1ED:
    INC $00
    DEC $01
    BNE Bank2_Label_A1CF
    RTS

Bank2_Func_A1F4:
    LDX #$00
    TXA

Bank2_Label_A1F7:
    STA $8E,X
    INX
    CPX #$10
    BNE Bank2_Label_A1F7
    LDA #$01
    STA $8E
    LDA #$0E
    STA $97
    LDA #$07
    STA $94
    LDA #$01
    STA $95
    LDA #$03
    STA $90
    RTS

Bank2_Func_A213:
    LDA #$08
    SEC
    SBC $2C
    ASL A
    ASL A
    STA $2B
    RTS
