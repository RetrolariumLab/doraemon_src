; Doraemon PRG bank 1 $88A4-$8C5C
; World 2 initialization, frame loop, and player flight state
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank1_World2Main:
    LDX #$7F
    TXS
    LDA #$00
    STA World2InventoryState+$06
    STA $A3
    STA $BA
    STA $27

Bank1_Label_88B1:
    LDA #$00
    STA World2FrameCounter
    STA $A9

Bank1_Label_88B7:
    LDX #$7F
    TXS
    JSR Bank1_Func_8711
    JSR Bank1_Func_8AB6
    LDA #$02
    STA $5E
    LDA #$3C
    STA World2PlayerX
    LDA #$78
    STA World2PlayerY
    LDA #$00
    STA $B9
    STA $40
    STA $44
    STA $3F
    STA $B8
    STA World2StageBranchCooldown
    STA $5F
    STA $A4
    STA World2PendingBackgroundPalette
    STA $93
    STA $92
    STA $7B
    STA $6A
    STA $6F
    STA $45
    STA $42
    STA $43
    STA $A0
    STA $9C
    STA $A5
    STA $A1
    STA World2InventoryState
    STA World2InventoryState+$01
    STA $41
    STA World2InventoryState+$02
    STA World2InventoryState+$04
    STA World2InventoryState+$05
    STA World2InventoryState+$03
    STA $A8
    STA $B3
    STA $A0
    STA $A2
    STA $B2
    STA $38
    LDA #$96
    STA $AD
    JSR Bank1_Func_8AD0
    STA $2B
    LDA $37
    BEQ Bank1_Label_8923
    LDA #$03
    STA World2InventoryState+$02

Bank1_Label_8923:
    LDA #$00
    STA $37
    JSR Bank1_Func_8AAB
    LDA $27
    BNE Bank1_Label_8940
    LDA #$01
    STA $28
    JSR Bank1_Func_8053
    JSR Bank1_Func_80FD
    LDX #$5A

Bank1_Label_893A:
    JSR Bank1_WaitForVblank
    DEX
    BNE Bank1_Label_893A

Bank1_Label_8940:
    JSR Bank1_Func_8711
    LDA #$01
    JSR Bank1_Func_81AA
    JSR Bank1_Func_8ADF
    LDA PpuCtrlShadow
    AND #$E7
    ORA #$11
    STA PpuCtrlShadow
    JSR Bank1_Func_80FD
    JSR World2_ClearEntityPools

Bank1_World2FrameLoop:
    JSR Bank1_Func_8A39
    JSR Bank1_Func_8B3B
    JSR Bank1_Func_8B4C
    JSR World2_UpdatePlayerAndInventory
    JSR World2_UpdatePlayerProjectiles
    JSR World2_UpdateEnemies
    JSR World2_UpdateEnemyProjectiles
    JSR Bank1_Func_97C5
    JSR Bank1_Func_8FA2
    JSR World2_CheckStageBranch
    JSR World2_UpdateInventorySpawns
    JSR Bank1_Func_8A1D
    JSR Bank1_Func_8B65
    JSR Bank1_Func_A612
    LDA $B2
    BNE Bank1_Label_89D1
    LDA $B3
    BNE Bank1_Label_89CE
    LDA $27
    BEQ Bank1_Label_8991
    LDA #$20

Bank1_Label_8991:
    ORA #$10
    AND CombinedControllerButtons
    BNE Bank1_Label_89D7
    LDA $A2
    BEQ Bank1_World2FrameLoop
    LDA $27
    BNE Bank1_Label_89DB
    LDA #$06
    STA a:AudioMusicState
    LDA #$00
    STA $41
    LDA #$DC
    STA $AD

Bank1_Label_89AC:
    JSR Bank1_Func_8A1A
    DEC $AD
    BNE Bank1_Label_89AC
    DEC $2A
    BMI Bank1_Label_89BA
    JMP Bank1_Label_88B7

Bank1_Label_89BA:
    JSR Bank1_Func_8065
    LDA #$00
    LDX #$06

Bank1_Label_89C1:
    STA a:ScoreDigitsWorking,X
    DEX
    BPL Bank1_Label_89C1
    LDA #$02
    STA $2A
    JMP Bank1_Label_88B7

Bank1_Label_89CE:
    JMP Bank1_Func_8A46

Bank1_Label_89D1:
    JSR Bank1_Func_8A7F
    JMP Bank1_Func_8A32

Bank1_Label_89D7:
    LDA $27
    BEQ Bank1_Label_89DE

Bank1_Label_89DB:
    JMP Bank1_Func_8048

Bank1_Label_89DE:
    LDA $41
    PHA
    LDA #$00
    STA $41
    LDA #$06
    JSR World2_Audio_QueueEffectWithPriority
    LDA #$01
    STA a:AudioMusicControl

Bank1_Label_89EF:
    JSR Bank1_Func_8A1A
    LDA CombinedControllerButtons
    AND #$10
    BNE Bank1_Label_89EF

Bank1_Label_89F8:
    JSR Bank1_Func_8A1A
    LDA CombinedControllerButtons
    AND #$10
    BEQ Bank1_Label_89F8
    LDA #$06
    JSR World2_Audio_QueueEffectWithPriority
    LDA #$00
    STA a:AudioMusicControl

Bank1_Label_8A0B:
    JSR Bank1_Func_8A1A
    LDA CombinedControllerButtons
    AND #$10
    BNE Bank1_Label_8A0B
    PLA
    STA $41
    JMP Bank1_World2FrameLoop

Bank1_Func_8A1A:
    JSR Bank1_Func_8A39

Bank1_Func_8A1D:
    JSR Bank1_Func_8A94
    JSR Bank1_Func_91CD
    JSR Bank1_Func_93E5
    JSR Bank1_Func_A304
    JSR Bank1_Func_A2CA
    JSR Bank1_Func_93B7
    JMP Bank1_Func_A753

Bank1_Func_8A32:
    LDA World2InventoryState+$06
    STA $38
    JMP Bank1_Func_808D

Bank1_Func_8A39:
    LDA FrameCounter

Bank1_Label_8A3B:
    CMP FrameCounter
    BEQ Bank1_Label_8A3B
    LDA $93
    EOR #$80
    STA $93
    RTS

Bank1_Func_8A46:
    JSR World2_ClearEntityPools
    JSR Bank1_Func_8A84
    LDA #$01
    STA $41
    LDA #$00
    STA $B3
    STA $A4
    LDA #$64
    STA $AD
    LDA World2SavedBackgroundPalette
    STA World2PendingBackgroundPalette
    LDA $A9
    CMP #$02
    BEQ Bank1_Label_8A66
    INC $A9

Bank1_Label_8A66:
    BNE Bank1_Label_8A71
    LDX #$00
    JSR Bank1_Func_8A74
    INX
    JSR Bank1_Func_8A74

Bank1_Label_8A71:
    JMP Bank1_World2FrameLoop

Bank1_Func_8A74:
    LDA World2InventoryState,X
    CMP #$03
    BEQ Bank1_Label_8A7E
    LDA #$02
    STA World2InventoryState,X

Bank1_Label_8A7E:
    RTS

Bank1_Func_8A7F:
    LDA #$09
    JSR World2_Audio_QueueEffect

Bank1_Func_8A84:
    LDA #$F0
    STA $AD

Bank1_Label_8A88:
    JSR Bank1_Func_8A1A
    LDA #$FF
    STA World2PendingBackgroundPalette
    DEC $AD
    BNE Bank1_Label_8A88
    RTS

Bank1_Func_8A94:
    LDX #$3C
    LDA #$F8

Bank1_Label_8A98:
    STA a:OamBuffer,X
    STA a:$0340,X
    STA a:$0380,X
    STA a:$03C0,X
    DEX
    DEX
    DEX
    DEX
    BPL Bank1_Label_8A98
    RTS

Bank1_Func_8AAB:
    LDX #$FF
    LDA #$00

Bank1_Label_8AAF:
    STA a:World2ScreenMetatiles,X
    DEX
    BNE Bank1_Label_8AAF
    RTS

Bank1_Func_8AB6:
    LDA #$00
    STA a:$4011
    STA a:APU_STATUS
    STA a:$4010
    STA a:AudioEffectRequestState
    STA a:AudioMusicState
    STA a:AudioMusicControl
    LDA #$40
    STA a:$4017
    RTS

Bank1_Func_8AD0:
    STX $76
    LDX $2C
    LDA a:$8AD8,X
    LDX $76
    RTS
    .byte $18, $14, $10, $0C, $08

Bank1_Func_8ADF:
    JSR Bank1_WaitForVblank
    LDY $A9
    LDX a:World2_StageSequenceStartOffsets,Y
    DEX
    STX World2StageSequenceOffset
    LDX a:World2_InitialSpritePaletteOffsets,Y
    JSR World2_UploadSpritePalette
    LDX $A9
    LDA a:World2_InitialBackgroundPaletteIds,X
    JSR World2_UploadBackgroundPalette
    LDA #$0F
    STA World2ScreenRowIndex
    LDA #$00
    STA $40
    STA $44
    STA $3F
    STA $42
    STA $41
    LDA #$F0
    STA $3F
    LDA #$80
    STA $AA
    LDA #$11
    STA $67

Bank1_Label_8B14:
    JSR Bank1_Func_8371
    JSR World2_DecodeScreenRow15
    JSR Bank1_Func_8471
    JSR Bank1_Func_84C1
    JSR Bank1_Func_84E1
    JSR Bank1_Func_8578
    JSR Bank1_Func_85A5
    JSR Bank1_Func_85F7
    LDA $3F
    CLC
    ADC #$10
    STA $3F
    DEC $67
    BNE Bank1_Label_8B14
    RTS

World2_StageSequenceStartOffsets:
    .byte $00, $25, $5C

Bank1_Func_8B3B:
    LDA $27
    BNE Bank1_Label_8B47
    LDA $AA
    BEQ Bank1_Label_8B4B
    DEC $AA
    BNE Bank1_Label_8B4B

Bank1_Label_8B47:
    LDA #$01
    STA $41

Bank1_Label_8B4B:
    RTS

Bank1_Func_8B4C:
    LDA $AD
    BEQ Bank1_Label_8B64
    LDA $27
    BNE Bank1_Label_8B58
    DEC $AD
    BNE Bank1_Label_8B64

Bank1_Label_8B58:
    LDX $A9
    LDA a:$8BA2,X
    STA a:AudioMusicState
    LDA #$00
    STA $AD

Bank1_Label_8B64:
    RTS

Bank1_Func_8B65:
    LDA $BA
    BNE Bank1_Label_8B92
    LDA World2InventoryState
    CMP #$03
    BNE Bank1_Label_8B92
    LDA $24
    BEQ Bank1_Label_8B90
    INC $B9
    LDA $B9
    CMP #$60
    BCC Bank1_Label_8B92
    LDX #$06

Bank1_Label_8B7D:
    LDA a:World2EnemyState,X
    BEQ Bank1_Label_8B8B
    CMP #$70
    BCS Bank1_Label_8B8B
    LDA #$78
    STA a:World2EnemyState,X

Bank1_Label_8B8B:
    DEX
    BPL Bank1_Label_8B7D
    INC $BA

Bank1_Label_8B90:
    STA $B9

Bank1_Label_8B92:
    JSR Bank1_Func_820E
    LDA $26
    BEQ Bank1_Label_8B64
    LDA #$00
    STA $26
    LDA #$0D
    JMP World2_Audio_QueueEffect
    .byte $01, $02, $03, $01

World2_InitialBackgroundPaletteIds:
    .byte $01, $04, $05

World2_InitialSpritePaletteOffsets:
    .byte $10, $20, $30

World2_UpdatePlayerAndInventory:
    JSR Bank1_Func_8E3C
    JSR Bank1_Func_8E0F
    JSR Bank1_Func_8D01
    JSR Bank1_Func_8D88
    JSR Bank1_Func_8C84
    JSR Bank1_Func_8C74
    JSR Bank1_Func_8C78
    JSR Bank1_Func_8C7C
    JSR Bank1_Func_8C5D
    JSR Bank1_Func_8C80
    LDA $A0
    BNE Bank1_Label_8C3C
    LDA $A8
    BNE Bank1_Label_8C3B
    LDA $27
    BEQ Bank1_Label_8BDF
    LDA World2FrameCounter
    ROL A
    BCS Bank1_Label_8BDF
    LDA #$00
    STA $9C

Bank1_Label_8BDF:
    LDA $9C
    BEQ Bank1_Label_8C3B
    STA $B0
    LDA #$00
    STA $9C
    LDA World2InventoryState+$04
    CMP #$03
    BEQ Bank1_Label_8C18
    LDA #$00
    STA $6A
    LDA #$0C
    JSR World2_Audio_QueueEffectWithPriority
    LDA #$78
    STA $A0
    INC $A5
    LDA $A5
    CMP #$04
    BCC Bank1_Label_8C3B

Bank1_Label_8C04:
    LDA #$00
    STA $A5
    LDA $27
    BNE Bank1_Label_8C17
    LDX #$05

Bank1_Label_8C0E:
    LDA World2InventoryState,X
    CMP #$03
    BEQ Bank1_Label_8C25
    DEX
    BPL Bank1_Label_8C0E

Bank1_Label_8C17:
    RTS

Bank1_Label_8C18:
    INC $A5
    LDA $A5
    CMP #$06
    BCS Bank1_Label_8C04
    LDA #$01
    STA $A8
    RTS

Bank1_Label_8C25:
    LDA #$04
    STA World2InventoryState,X
    CPX #$02
    BCC Bank1_Label_8C3B
    LDA World2PlayerX
    CLC
    ADC #$04
    STA World2InventoryX,X
    LDA World2PlayerY
    CLC
    ADC #$04
    STA World2InventoryY,X

Bank1_Label_8C3B:
    RTS

Bank1_Label_8C3C:
    DEC $A0
    BNE Bank1_Label_8C3B
    LDX $B0
    BPL Bank1_Label_8C4E
    DEX
    BPL Bank1_Label_8C4E
    DEX
    BPL Bank1_Label_8C4C
    DEC $2B

Bank1_Label_8C4C:
    DEC $2B

Bank1_Label_8C4E:
    DEC $2B
    LDA $2B
    BPL Bank1_Label_8C5C
    LDA #$01
    STA $A2
    LDA #$00
    STA $2B

Bank1_Label_8C5C:
    RTS
