; Doraemon PRG bank 1 $8444-$88A3
; World 2 compressed row expansion, palette catalog, PPU transfer services, and RTS dispatch tables
; Generated deterministically from pinned Ghidra/GhidraNes facts

World2_DecodeScreenToken:
    LDA (World2ScreenStreamPointer),Y
    INY
    CMP #$D0
    BCC Bank1_Label_8469
    CMP #$EF
    BEQ Bank1_Label_846E
    BCS Bank1_Label_845A
    STA World2EnemySpawnState
    JSR World2_SpawnEnemy
    LDA #$00
    BEQ Bank1_Label_8469

Bank1_Label_845A:
    AND #$0F
    STA World2ScreenRunLength
    LDA (World2ScreenStreamPointer),Y
    INY

Bank1_Label_8461:
    STA a:World2ScreenMetatiles+$F0,X
    INX
    DEC World2ScreenRunLength
    BNE Bank1_Label_8461

Bank1_Label_8469:
    STA a:World2ScreenMetatiles+$F0,X
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

Bank1_Func_84AB:
    LDX #$00
    STX $53

Bank1_Label_84AF:
    LDA a:World2ScreenMetatiles+$F0,X
    LDY $53
    STA ($51),Y
    TAY
    INC $53
    JSR World2_ExpandMetatileToTransferBuffers
    CPX #$10
    BNE Bank1_Label_84AF
    RTS

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
    LDA a:World2ScreenMetatiles+$F0,X
    LDY $53
    STA ($51),Y
    TAY
    LDA $53
    CLC
    ADC #$10
    STA $53
    JSR World2_ExpandMetatileToTransferBuffers
    CPX #$0F
    BNE Bank1_Label_84E5
    RTS

World2_ExpandMetatileToTransferBuffers:
    LDA a:World2_MetatilePaletteSelectors,Y
    STA a:$0500,X
    TYA
    ASL A
    BCS Bank1_Label_853F
    ASL A
    BCS Bank1_Label_8524
    TAY
    LDA a:World2_MetatileTiles_00_3F,Y
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
    LDA a:World2_MetatileTiles_40_7F,Y
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
    LDA a:World2_MetatileTiles_80_BF,Y
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
    LDA a:World2_MetatileTiles_C0_CF,Y
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

Bank1_Func_8641:
    LDX $48
    LDA $49
    STA a:PPU_ADDR
    STX a:PPU_ADDR
    LDY #$00
    LDX #$10

Bank1_Label_864F:
    LDA a:$0530,Y
    STA a:PPU_DATA
    LDA a:$0540,Y
    STA a:PPU_DATA
    INY
    DEX
    BNE Bank1_Label_864F
    RTS

Bank1_Func_8660:
    LDX $4A
    LDA $4B
    STA a:PPU_ADDR
    STX a:PPU_ADDR
    LDY #$00
    LDX #$08
    LDA a:PPU_DATA

Bank1_Label_8671:
    LDA a:PPU_DATA
    STA a:$0550,Y
    INY
    DEX
    BNE Bank1_Label_8671
    LDX #$00
    STX $4E
    LDA $48
    AND #$40
    BEQ Bank1_Label_8686
    INX

Bank1_Label_8686:
    STX $50
    LDY #$00
    STY $4C

Bank1_Label_868C:
    LDX $50
    LDA a:$86C7,X
    STA $4D
    LDA a:$0500,Y
    LDX $50
    BEQ Bank1_Label_869E
    ASL A
    ASL A
    ASL A
    ASL A

Bank1_Label_869E:
    LDX $4E
    BEQ Bank1_Label_86A9
    ASL A
    ASL A
    SEC
    ROL $4D
    ROL $4D

Bank1_Label_86A9:
    STA $4F
    LDX $4C
    LDA a:$0550,X
    AND $4D
    ORA $4F
    STA a:$0550,X
    LDA #$01
    EOR $4E
    STA $4E
    BNE Bank1_Label_86C1
    INC $4C

Bank1_Label_86C1:
    INY
    CPY #$10
    BNE Bank1_Label_868C
    RTS
    .byte $FC, $CF

Bank1_Func_86C9:
    LDA $48
    AND #$D0
    TAX
    LDA $49
    STA a:PPU_ADDR
    STX a:PPU_ADDR
    LDY #$00
    LDX #$10

Bank1_Label_86DA:
    LDA a:$0510,Y
    STA a:PPU_DATA
    LDA a:$0520,Y
    STA a:PPU_DATA
    INY
    DEX
    BNE Bank1_Label_86DA
    RTS

Bank1_Func_86EB:
    LDX $4A
    LDA $4B
    STA a:PPU_ADDR
    STX a:PPU_ADDR
    LDY #$00
    LDX #$08

Bank1_Label_86F9:
    LDA a:$0550,Y
    STA a:PPU_DATA
    INY
    DEX
    BNE Bank1_Label_86F9
    RTS

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
    JSR World2_UploadDefaultBackgroundPalette
    LDA #$10
    STA PpuCtrlShadow
    STA a:PPU_CTRL
    LDA #$00
    STA $40
    STA $3F
    JSR Bank1_Func_8131
    JSR Bank1_Func_80DA
    JSR World2_UploadDefaultBackgroundPalette
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

World2_ApplyPendingBackgroundPalette:
    LDA World2PendingBackgroundPalette
    BEQ Bank1_Label_8746
    BPL World2_UploadBackgroundPalette
    LDA World2FrameCounter
    AND #$03

World2_UploadBackgroundPalette:
    PHA
    LDA #$00
    STA World2PendingBackgroundPalette
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
    LDA a:World2_BackgroundPaletteIndexBase,X
    STA a:PPU_DATA
    INX
    DEY
    BNE Bank1_Label_8765
    BEQ Bank1_Label_8790

World2_UploadDefaultBackgroundPalette:
    LDA #$3F
    LDX #$00
    JSR Bank1_Func_870A
    LDY #$10

Bank1_Label_877A:
    LDA a:World2_PaletteSets,X
    STA a:PPU_DATA
    INX
    DEY
    BNE Bank1_Label_877A

World2_UploadSpritePalette:
    LDY #$10

Bank1_Label_8786:
    LDA a:World2_SpritePaletteOffsetBase,X
    STA a:PPU_DATA
    INX
    DEY
    BNE Bank1_Label_8786

World2_BackgroundPaletteIndexBase = * + 1  ; overlapping entry $8791

Bank1_Label_8790:
    LDA #$3F
    STA a:PPU_ADDR
    LDA #$00
    STA a:PPU_ADDR
    STA a:PPU_ADDR
    STA a:PPU_ADDR
    RTS

World2_PaletteSets:
    .byte $0F, $17, $26, $07, $0F, $19, $29, $07, $0F, $17, $26, $07, $0F, $1C, $11, $07
    .byte $0F, $17, $26, $07, $0F, $19, $29, $07, $0F, $17, $26, $07, $0F, $06, $15, $07
    .byte $0F, $17, $26, $07, $0F, $19, $29, $07, $0F, $17, $26, $07, $0F, $00, $10, $07
    .byte $0F, $17, $26, $07, $0F, $19, $29, $07, $0F, $1C, $10, $08, $0F, $1C, $21, $09
    .byte $0F, $17, $26, $07, $0F, $1A, $10, $0A, $0F, $00, $10, $08, $0F, $00, $31, $0B

World2_SpritePaletteOffsetBase:
    .byte $0F, $05, $15, $0F, $0F, $23, $20, $15, $0F, $00, $10, $08, $0F, $00, $31, $0B
    .byte $0F, $15, $21, $30, $0F, $15, $26, $30, $0F, $19, $28, $30, $0F, $17, $27, $36
    .byte $0F, $15, $21, $30, $0F, $15, $26, $30, $0F, $11, $21, $30, $0F, $17, $27, $36
    .byte $0F, $15, $21, $30, $0F, $15, $26, $30, $0F, $1A, $28, $30, $0F, $13, $25, $35

World2_FrameScreenServiceRtsTable:
    .byte $64, $83, $70, $83, $64, $83, $CE, $83, $46, $87, $70, $84, $64, $83, $C0, $84
    .byte $64, $83, $E0, $84, $64, $83, $77, $85, $64, $83, $A4, $85, $64, $83, $F6, $85

World2_ReverseScreenServiceRtsTable:
    .byte $64, $83, $64, $83, $64, $83, $46, $87, $64, $83, $C8, $86, $64, $83, $64, $83
    .byte $64, $83, $EA, $86, $5F, $86, $40, $86, $AA, $84, $04, $84, $DC, $83, $64, $83

World2_ForwardScreenServiceRtsTable:
    .byte $64, $83, $DC, $83, $04, $84, $AA, $84, $C8, $86, $5F, $86, $EA, $86, $64, $83
    .byte $64, $83, $64, $83, $40, $86, $64, $83, $46, $87, $64, $83, $64, $83, $64, $83

World2_DemoEntry:
    LDX #$7F
    TXS
    LDX #$00
    STX World2InventoryState+$06
    INX
    STX DemoModeActive
    INX
    STX PlayerLives
    LDA #$05
    STA PlayerHealthCapacityIndex
    BNE Bank1_Label_88B1
