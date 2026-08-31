; Doraemon PRG bank 1 $827D-$88A3
; World 2 pre-game presentation, PPU services, and local RTS dispatch tables
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank1_Func_827D:
    JSR Bank1_Func_8747

Bank1_Label_8280:
    LDA PpuMaskShadow

Bank1_Label_8283 = * + 1  ; overlapping entry $8283
    STA a:PPU_MASK
    .byte $A9

Bank1_Func_8286:
    BRK
    .byte $8D, $06, $20, $8D, $06, $20, $A5, $3F, $8D, $05, $20, $A5, $40, $8D, $05, $20
    .byte $A5, $19, $8D, $00, $20, $E6, $73, $60

Bank1_Func_829F:
    LDA $41
    BEQ Bank1_Func_827D
    LDX $42
    BEQ Bank1_Label_8302
    DEX
    BEQ Bank1_Label_82D7
    LDX $44
    BEQ Bank1_Label_82B6
    DEX
    STX $44
    BNE Bank1_Label_82B6
    JSR Bank1_Func_8366

Bank1_Label_82B6:
    LDA $40
    CMP #$EF
    BNE Bank1_Label_82C0
    LDA #$FF
    STA $40

Bank1_Label_82C0:
    INC $40
    LDA $40
    ASL A
    AND #$1E
    TAX
    LDA #$82
    PHA
    LDA #$7F
    PHA
    LDA a:$8872,X
    PHA
    LDA a:$8871,X
    PHA
    RTS

Bank1_Label_82D7:
    LDX $44
    BEQ Bank1_Label_82E3
    DEX
    STX $44
    BNE Bank1_Label_82E3
    JSR Bank1_Func_8366

Bank1_Label_82E3:
    LDA $40
    BNE Bank1_Label_82EB
    LDA #$F0
    STA $40

Bank1_Label_82EB:
    DEC $40
    LDA $40
    ASL A
    AND #$1E
    TAX
    LDA #$82
    PHA
    LDA #$7F
    PHA
    LDA a:$8852,X
    PHA
    LDA a:$8851,X
    PHA
    RTS

Bank1_Label_8302:
    LDX $45
    BEQ Bank1_Label_8335
    DEX
    STX $45
    LDA PpuCtrlShadow
    PHA
    LDA $3F
    PHA
    LDA PpuCtrlShadow
    EOR #$01
    STA PpuCtrlShadow
    TXA
    EOR #$0F
    ORA #$F0
    STA $3F
    ASL A
    AND #$1E
    TAX
    JSR Bank1_Func_835D
    PLA
    STA $3F
    PLA
    STA PpuCtrlShadow
    JMP Bank1_Label_8280
    .byte $68, $85, $3F, $68, $85, $19, $4C, $80, $82

Bank1_Label_8335:
    INC $3F
    LDA $3F
    BNE Bank1_Label_8343
    PHA
    LDA PpuCtrlShadow
    EOR #$01
    STA PpuCtrlShadow
    PLA

Bank1_Label_8343:
    LDX $44
    BEQ Bank1_Label_8353
    DEX
    STX $44
    BNE Bank1_Label_8350
    LDA $43
    STA $42

Bank1_Label_8350:
    JMP Bank1_Label_8280

Bank1_Label_8353:
    ASL A
    AND #$1E
    TAX
    LDA #$82
    PHA
    LDA #$7F
    PHA

Bank1_Func_835D:
    LDA a:$8832,X
    PHA
    LDA a:$8831,X
    PHA
    RTS

Bank1_Func_8366:
    LDA $43
    STA $42
    LDA #$0F
    STA $45
    INC $56
    RTS

Bank1_Func_8371:
    JSR Bank1_Func_837D
    LDA $43
    BEQ Bank1_Label_837C
    LDA #$0F
    STA $44

Bank1_Label_837C:
    RTS

Bank1_Func_837D:
    INC $56
    LDA $56
    CMP #$10
    BNE Bank1_Label_837C
    LDA #$00
    STA $54
    STA $56

Bank1_Label_838B:
    INC $55
    LDY $55
    LDA a:$BDDF,Y
    CMP #$F0
    BCC Bank1_Label_83BE
    CMP #$F7
    BCS Bank1_Label_83A3
    AND #$03
    STA $43
    LDA #$0F
    STA $56
    RTS

Bank1_Label_83A3:
    BEQ Bank1_Label_83B7
    CMP #$F8
    BEQ Bank1_Label_83B1
    AND #$07
    STA $9D
    STA $B4
    BNE Bank1_Label_838B

Bank1_Label_83B1:
    LDA #$00
    STA $41
    BEQ Bank1_Label_838B

Bank1_Label_83B7:
    LDA $9E
    STA $55
    JMP Bank1_Label_838B

Bank1_Label_83BE:
    AND #$7F
    STA $58
    ASL A
    TAX
    LDA a:$BEDE,X
    STA $46
    LDA a:$BEDF,X
    STA $47
    RTS

Bank1_Func_83CF:
    LDX #$00
    LDY $54

Bank1_Label_83D3:
    JSR Bank1_Func_8444
    CPX #$0F
    BCC Bank1_Label_83D3
    STY $54
    RTS
    .byte $E6, $56, $A5, $56, $C9, $0E, $D0, $19, $A4, $55, $BE, $E0, $BD, $E0, $F0, $90
    .byte $10, $E0, $F7, $B0, $0C, $8A, $29, $03, $85, $43, $A9, $0F, $85, $44, $E6, $55
    .byte $60, $C9, $0F, $90, $FB, $4C, $85, $83, $A2, $00, $A4, $54, $20, $44, $84, $E0
    .byte $10, $90, $F9, $84, $54, $A5, $40, $29, $F0, $85, $51, $A2, $04, $86, $52, $A5
    .byte $19, $29, $01, $09, $08, $85, $49, $A5, $40, $29, $F0, $0A, $26, $49, $0A, $26
    .byte $49, $09, $20, $85, $48, $0A, $A5, $49, $2A, $0A, $0A, $0A, $09, $C0, $85, $4A
    .byte $A5, $49, $09, $03, $85, $4B, $60

Bank1_Func_8444:
    LDA ($46),Y
    INY
    CMP #$D0
    BCC Bank1_Label_8469
    CMP #$EF
    BEQ Bank1_Label_846E
    BCS Bank1_Label_845A
    STA $74
    JSR World2_SpawnEnemy
    LDA #$00
    BEQ Bank1_Label_8469

Bank1_Label_845A:
    AND #$0F
    STA $57
    LDA ($46),Y
    INY

Bank1_Label_8461:
    STA a:$04F0,X
    INX
    DEC $57
    BNE Bank1_Label_8461

Bank1_Label_8469:
    STA a:$04F0,X
    INX
    RTS

Bank1_Label_846E:
    LDX #$10
    RTS

Bank1_Func_8471:
    LDA $3F
    CLC
    ADC #$10
    ROR A
    ROR A
    ROR A
    ROR A
    AND #$0F
    STA $51
    LDA #$04
    STA $52
    LDA $3F
    LSR A
    LSR A
    LSR A
    LSR A
    ASL A
    CLC
    ADC #$02
    AND #$1F
    STA $48
    BEQ Bank1_Label_8494
    LDA #$01

Bank1_Label_8494:
    EOR PpuCtrlShadow
    AND #$01
    ASL A
    ASL A
    ORA #$20
    STA $49
    ORA #$03
    STA $4B
    LDA $48
    LSR A
    LSR A
    ORA #$C0
    STA $4A
    RTS
    .byte $A2, $00, $86, $53, $BD, $F0, $04, $A4, $53, $91, $51, $A8, $E6, $53, $20, $FC
    .byte $84, $E0, $10, $D0, $EF, $60

Bank1_Func_84C1:
    LDY #$00
    LDX $4A

Bank1_Label_84C5:
    LDA $4B
    STA a:PPU_ADDR
    STX a:PPU_ADDR
    LDA a:PPU_DATA
    LDA a:PPU_DATA
    STA a:$0550,Y
    TXA
    CLC
    ADC #$08
    TAX
    INY
    CPY #$08
    BNE Bank1_Label_84C5
    RTS

Bank1_Func_84E1:
    LDX #$00
    STX $53

Bank1_Label_84E5:
    LDA a:$04F0,X
    LDY $53
    STA ($51),Y
    TAY
    LDA $53
    CLC
    ADC #$10
    STA $53
    JSR Bank1_Func_84FC
    CPX #$0F
    BNE Bank1_Label_84E5
    RTS

Bank1_Func_84FC:
    LDA a:$B9CF,Y
    STA a:$0500,X
    TYA
    ASL A
    BCS Bank1_Label_853F
    ASL A
    BCS Bank1_Label_8524
    TAY
    LDA a:$BA9F,Y
    STA a:$0510,X
    LDA a:$BAA0,Y
    STA a:$0520,X
    LDA a:$BAA1,Y
    STA a:$0530,X
    LDA a:$BAA2,Y
    STA a:$0540,X
    INX
    RTS

Bank1_Label_8524:
    TAY
    LDA a:$BB9F,Y
    STA a:$0510,X
    LDA a:$BBA0,Y
    STA a:$0520,X
    LDA a:$BBA1,Y
    STA a:$0530,X
    LDA a:$BBA2,Y
    STA a:$0540,X
    INX
    RTS

Bank1_Label_853F:
    ASL A
    BCS Bank1_Label_855D
    TAY
    LDA a:$BC9F,Y
    STA a:$0510,X
    LDA a:$BCA0,Y
    STA a:$0520,X
    LDA a:$BCA1,Y
    STA a:$0530,X
    LDA a:$BCA2,Y
    STA a:$0540,X
    INX
    RTS

Bank1_Label_855D:
    TAY
    LDA a:$BD9F,Y
    STA a:$0510,X
    LDA a:$BDA0,Y
    STA a:$0520,X
    LDA a:$BDA1,Y
    STA a:$0530,X
    LDA a:$BDA2,Y
    STA a:$0540,X
    INX
    RTS

Bank1_Func_8578:
    LDA PpuCtrlShadow
    ORA #$04
    STA a:PPU_CTRL
    LDA $49
    STA a:PPU_ADDR
    LDX $48
    STX a:PPU_ADDR
    LDY #$00
    LDX #$0F

Bank1_Label_858D:
    LDA a:$0510,Y
    STA a:PPU_DATA
    LDA a:$0530,Y
    STA a:PPU_DATA
    INY
    DEX
    BNE Bank1_Label_858D
    LDA PpuCtrlShadow
    AND #$FB
    STA a:PPU_CTRL
    RTS

Bank1_Func_85A5:
    LDX #$00
    STX $4E
    LDA $48
    AND #$02
    BEQ Bank1_Label_85B0
    INX

Bank1_Label_85B0:
    STX $50
    LDY #$00
    STY $4C

Bank1_Label_85B6:
    LDX $50
    LDA a:$85F5,X
    STA $4D
    LDA a:$0500,Y
    LDX $50
    BEQ Bank1_Label_85C6
    ASL A
    ASL A

Bank1_Label_85C6:
    LDX $4E
    BEQ Bank1_Label_85D7
    ASL A
    ASL A
    ASL A
    ASL A
    SEC
    ROL $4D
    ROL $4D
    ROL $4D
    ROL $4D

Bank1_Label_85D7:
    STA $4F
    LDX $4C
    LDA a:$0550,X
    AND $4D
    ORA $4F
    STA a:$0550,X
    LDA #$01
    EOR $4E
    STA $4E
    BNE Bank1_Label_85EF
    INC $4C

Bank1_Label_85EF:
    INY
    CPY #$0F
    BNE Bank1_Label_85B6
    RTS
    .byte $FC, $F3

Bank1_Func_85F7:
    LDA PpuCtrlShadow
    ORA #$04
    STA a:PPU_CTRL
    LDX $48
    INX
    LDA $49
    STA a:PPU_ADDR
    STX a:PPU_ADDR
    LDY #$00
    LDX #$0F

Bank1_Label_860D:
    LDA a:$0520,Y
    STA a:PPU_DATA
    LDA a:$0540,Y
    STA a:PPU_DATA
    INY
    DEX
    BNE Bank1_Label_860D
    LDY #$00
    LDX $4A

Bank1_Label_8621:
    LDA $4B
    STA a:PPU_ADDR
    STX a:PPU_ADDR
    LDA a:$0550,Y
    STA a:PPU_DATA
    TXA
    CLC
    ADC #$08
    TAX
    INY
    CPY #$08
    BNE Bank1_Label_8621
    LDA PpuCtrlShadow
    AND #$FB
    STA a:PPU_CTRL
    RTS
    .byte $A6, $48, $A5, $49, $8D, $06, $20, $8E, $06, $20, $A0, $00, $A2, $10, $B9, $30
    .byte $05, $8D, $07, $20, $B9, $40, $05, $8D, $07, $20, $C8, $CA, $D0, $F0, $60, $A6
    .byte $4A, $A5, $4B, $8D, $06, $20, $8E, $06, $20, $A0, $00, $A2, $08, $AD, $07, $20
    .byte $AD, $07, $20, $99, $50, $05, $C8, $CA, $D0, $F6, $A2, $00, $86, $4E, $A5, $48
    .byte $29, $40, $F0, $01, $E8, $86, $50, $A0, $00, $84, $4C, $A6, $50, $BD, $C7, $86
    .byte $85, $4D, $B9, $00, $05, $A6, $50, $F0, $04, $0A, $0A, $0A, $0A, $A6, $4E, $F0
    .byte $07, $0A, $0A, $38, $26, $4D, $26, $4D, $85, $4F, $A6, $4C, $BD, $50, $05, $25
    .byte $4D, $05, $4F, $9D, $50, $05, $A9, $01, $45, $4E, $85, $4E, $D0, $02, $E6, $4C
    .byte $C8, $C0, $10, $D0, $C6, $60, $FC, $CF, $A5, $48, $29, $D0, $AA, $A5, $49, $8D
    .byte $06, $20, $8E, $06, $20, $A0, $00, $A2, $10, $B9, $10, $05, $8D, $07, $20, $B9
    .byte $20, $05, $8D, $07, $20, $C8, $CA, $D0, $F0, $60, $A6, $4A, $A5, $4B, $8D, $06
    .byte $20, $8E, $06, $20, $A0, $00, $A2, $08, $B9, $50, $05, $8D, $07, $20, $C8, $CA
    .byte $D0, $F6, $60

Bank1_Func_8704:
    JSR World2_Audio_UpdateEffects
    JMP World2_Audio_UpdateMusic

Bank1_Func_870A:
    STA a:PPU_ADDR
    STX a:PPU_ADDR
    RTS

Bank1_Func_8711:
    JSR Bank1_Func_80DA
    JSR Bank1_WaitForVblank
    JSR Bank1_Func_80F0
    JSR Bank1_Func_8771
    LDA #$10
    STA PpuCtrlShadow
    STA a:PPU_CTRL
    LDA #$00
    STA $40
    STA $3F
    JSR Bank1_Func_8131
    JSR Bank1_Func_80DA
    JSR Bank1_Func_8771
    LDA #$20
    LDX #$00
    JSR Bank1_Func_870A
    LDY #$08
    TXA

Bank1_Label_873D:
    STA a:PPU_DATA
    DEX
    BNE Bank1_Label_873D
    DEY
    BNE Bank1_Label_873D

Bank1_Label_8746:
    RTS

Bank1_Func_8747:
    LDA $9D
    BEQ Bank1_Label_8746
    BPL Bank1_Func_8751
    LDA $73
    AND #$03

Bank1_Func_8751:
    PHA
    LDA #$00
    STA $9D
    LDA #$3F
    LDX #$00
    JSR Bank1_Func_870A
    PLA
    ASL A
    ASL A
    ASL A
    ASL A
    TAX
    LDY #$10

Bank1_Label_8765:
    LDA a:$8791,X
    STA a:PPU_DATA
    INX
    DEY
    BNE Bank1_Label_8765
    BEQ Bank1_Label_8790

Bank1_Func_8771:
    LDA #$3F
    LDX #$00
    JSR Bank1_Func_870A
    LDY #$10

Bank1_Label_877A:
    LDA a:$87A1,X
    STA a:PPU_DATA
    INX
    DEY
    BNE Bank1_Label_877A

Bank1_Func_8784:
    LDY #$10

Bank1_Label_8786:
    LDA a:$87F1,X
    STA a:PPU_DATA
    INX
    DEY
    BNE Bank1_Label_8786

Bank1_Label_8790:
    LDA #$3F
    STA a:PPU_ADDR
    LDA #$00
    STA a:PPU_ADDR
    STA a:PPU_ADDR
    STA a:PPU_ADDR
    RTS
    .byte $0F, $17, $26, $07, $0F, $19, $29, $07, $0F, $17, $26, $07, $0F, $1C, $11, $07
    .byte $0F, $17, $26, $07, $0F, $19, $29, $07, $0F, $17, $26, $07, $0F, $06, $15, $07
    .byte $0F, $17, $26, $07, $0F, $19, $29, $07, $0F, $17, $26, $07, $0F, $00, $10, $07
    .byte $0F, $17, $26, $07, $0F, $19, $29, $07, $0F, $1C, $10, $08, $0F, $1C, $21, $09
    .byte $0F, $17, $26, $07, $0F, $1A, $10, $0A, $0F, $00, $10, $08, $0F, $00, $31, $0B
    .byte $0F, $05, $15, $0F, $0F, $23, $20, $15, $0F, $00, $10, $08, $0F, $00, $31, $0B
    .byte $0F, $15, $21, $30, $0F, $15, $26, $30, $0F, $19, $28, $30, $0F, $17, $27, $36
    .byte $0F, $15, $21, $30, $0F, $15, $26, $30, $0F, $11, $21, $30, $0F, $17, $27, $36
    .byte $0F, $15, $21, $30, $0F, $15, $26, $30, $0F, $1A, $28, $30, $0F, $13, $25, $35
    .byte $64, $83, $70, $83, $64, $83, $CE, $83, $46, $87, $70, $84, $64, $83, $C0, $84
    .byte $64, $83, $E0, $84, $64, $83, $77, $85, $64, $83, $A4, $85, $64, $83, $F6, $85
    .byte $64, $83, $64, $83, $64, $83, $46, $87, $64, $83, $C8, $86, $64, $83, $64, $83
    .byte $64, $83, $EA, $86, $5F, $86, $40, $86, $AA, $84, $04, $84, $DC, $83, $64, $83
    .byte $64, $83, $DC, $83, $04, $84, $AA, $84, $C8, $86, $5F, $86, $EA, $86, $64, $83
    .byte $64, $83, $64, $83, $40, $86, $64, $83, $46, $87, $64, $83, $64, $83, $64, $83

Bank1_Func_8891:
    LDX #$7F
    TXS
    LDX #$00
    STX $82
    INX
    STX $27
    INX
    STX $2A
    LDA #$05
    STA $2C
    BNE Bank1_Label_88B1
