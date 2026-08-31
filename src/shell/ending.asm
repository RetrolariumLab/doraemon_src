; Doraemon PRG bank 3 $8A88-$8C3A
; Ending initialization and credits scroll loop
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank3_RunEnding:
    LDX #$7F
    TXS
    JSR Bank3_Func_80DA
    LDA #$03
    JSR Bank3_Func_81AA
    JSR Bank3_Func_9152
    LDA #$84
    STA $00
    LDA #$93
    STA $01
    LDA #$20
    STA a:$2006
    LDY #$00
    STY a:$2006
    LDX #$04

Bank3_Label_8AAA:
    LDA ($00),Y
    STA a:$2007
    INY
    BNE Bank3_Label_8AAA
    INC $01
    DEX
    BNE Bank3_Label_8AAA
    LDX #$E0

Bank3_Label_8AB9:
    LDA a:$8B3B,X
    STA a:$0130,X
    INX
    BNE Bank3_Label_8AB9
    JSR Bank3_Func_90D1
    LDA #$00
    STA $1B
    STA $1C
    LDA #$01
    STA $09
    LDA #$02
    STA a:$02AA
    LDA $19
    AND #$E0
    STA $19
    JSR Bank3_Func_80FD

Bank3_Label_8ADD:
    JSR Bank3_Func_8F5A
    LDA a:$02AA
    BNE Bank3_Label_8ADD
    LDA #$C4
    STA $16

Bank3_Label_8AE9:
    JSR Bank3_Func_8F5A
    LDA $16
    BNE Bank3_Label_8AE9
    JSR Bank3_Func_80DA
    LDA $3B
    BPL Bank3_Label_8AFA
    JMP Bank3_Func_8048

Bank3_Label_8AFA:
    JSR Bank3_Func_9152
    LDA #$BC
    STA $4B
    LDA #$BD
    STA $4C
    LDA #$03
    STA a:$02AA
    LDA $19
    AND #$E0
    ORA #$10
    STA $19
    JSR Bank3_Func_91A1
    JSR Bank3_Func_80FD

Bank3_Label_8B18:
    JSR Bank3_Func_8F5A
    JSR Bank3_Func_8B8A
    JSR Bank3_Func_91EE
    LDA $4B
    CMP #$3C
    BNE Bank3_Label_8B18
    LDA $4C
    CMP #$ED
    BNE Bank3_Label_8B18
    LDA #$B0
    STA $00
    LDA #$86
    STA $01
    JSR Bank3_Func_90C4
    LDA #$01
    STA a:$0408
    LDA #$00
    STA $1C
    STA $1B
    LDA $19
    AND #$E0
    ORA #$10
    STA $19
    JSR Bank3_Func_91A1
    LDA #$0C
    STA $3E
    LDA #$F2
    STA $3F
    LDA #$00
    STA $40
    STA $41
    STA $42

Bank3_Label_8B5E:
    JSR Bank3_Func_85E2
    LDA $40
    CMP #$20
    BCS Bank3_Label_8B72
    LDA #$02
    STA $09
    LDA #$01
    STA $41
    JMP Bank3_Label_8B5E

Bank3_Label_8B72:
    LDA #$30
    STA $00
    LDA #$86
    STA $01
    JSR Bank3_Func_90C4
    LDX #$00
    STX $43
    INX
    STX a:$0408
    STX $09

Bank3_Label_8B87:
    JMP Bank3_Label_8B87

Bank3_Func_8B8A:
    LDX #$40
    LDY #$00

Bank3_Label_8B8E:
    LDA a:$8B9B,Y
    STA a:$0300,X
    INX
    INY
    CPY #$80
    BCC Bank3_Label_8B8E
    RTS
    .byte $58, $00, $20, $78, $58, $59, $20, $80, $60, $1C, $20, $78, $60, $69, $20, $80
    .byte $68, $2C, $20, $78, $68, $68, $20, $80, $68, $0E, $21, $5C, $68, $0F, $21, $64
    .byte $70, $1E, $21, $5C, $70, $1F, $21, $64, $78, $2E, $21, $5C, $78, $2F, $21, $64
    .byte $68, $4E, $22, $94, $68, $4F, $22, $9C, $70, $5E, $22, $94, $70, $5F, $22, $9C
    .byte $78, $6E, $22, $94, $78, $6F, $22, $9C, $8C, $4C, $21, $6C, $8C, $4D, $21, $74
    .byte $94, $5C, $21, $6C, $94, $5D, $21, $74, $9C, $6C, $21, $6C, $9C, $6D, $21, $74
    .byte $84, $48, $21, $84, $84, $49, $21, $8C, $8C, $4A, $21, $84, $8C, $4B, $21, $8C
    .byte $94, $5A, $21, $84, $94, $5B, $21, $8C, $9C, $6A, $21, $84, $9C, $6B, $21, $8C
    .byte $01, $0F, $11, $30, $01, $15, $00, $30, $01, $09, $08, $26, $01, $10, $30, $26
    .byte $01, $15, $21, $30, $01, $0F, $26, $30, $01, $05, $26, $30, $01, $15, $21, $30
