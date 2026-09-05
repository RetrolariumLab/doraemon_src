; Doraemon PRG bank 0 $827D-$856B
; World 1 initialization, main frame loop, and queued PPU writes
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank0_Func_827D:
    LDA ExtraLifeSoundCounter

Bank0_Label_8280 = * + 1  ; overlapping entry $8280
    BEQ Bank0_Label_8288
    LDA #$10

Bank0_Label_8283:
    JSR World1_Audio_QueueEffect

Bank0_Label_8286:
    DEC ExtraLifeSoundCounter

Bank0_Label_8288:
    JSR World1_Audio_UpdateEffects
    JMP World1_Audio_UpdateMusic

Bank0_World1Main:
    LDX #$7F
    TXS
    LDA #$00
    STA a:$0180
    JSR Bank0_Func_83A3
    JSR Bank0_Func_837C
    JSR Bank0_Func_830C

Bank0_Label_829F:
    JSR Bank0_Func_83E8
    JSR Bank0_Func_8362
    LDA #$01
    STA $51
    JSR World1_ClearEntitySlots00_09
    JSR World1_ClearEntitySlots10_29
    JSR World1_ClearEntitySlots38_47
    JSR World1_RefreshObjectSpawnMask
    JSR Bank0_Func_9535
    JSR Bank0_Func_A7DB
    JSR Bank0_Func_843B
    JSR Bank0_Func_95ED

Bank0_Label_82C1:
    JSR Bank0_Func_94F1
    JSR Bank0_Func_8490
    JSR Bank0_Func_95CB
    JSR Bank0_Func_9B54
    JSR Bank0_Func_856C
    JSR Bank0_Func_CA6D
    JSR Bank0_Func_9201
    JSR Bank0_Func_8706
    JSR World1_SpawnObjectsAtCameraEdges
    JSR World1_UpdateEntities
    JSR Bank0_Func_8EF6
    JSR Bank0_Func_931B
    JSR World1_TryEnterAnywhereDoor
    JSR World1_TryEnterManhole
    JSR World1_CommitScoreAndCheckExtraLife
    LDA World1PlayerDamageState
    BMI Bank0_Label_82F5
    JMP Bank0_Label_82C1

Bank0_Label_82F5:
    JSR Bank0_Func_884C
    DEC PlayerLives
    BMI Bank0_Label_82FF
    JMP Bank0_Label_829F

Bank0_Label_82FF:
    JSR Bank0_Func_8065
    LDA #$02
    STA PlayerLives
    JSR Bank0_Func_C92F
    JMP Bank0_Label_829F

Bank0_Func_830C:
    JSR Bank0_Func_C92F
    LDA #$00
    STA DemoModeActive

Bank0_Func_8313:
    JSR World1_InitializeObjectSpawnMask
    LDA #$02
    STA PlayerLives
    LDA #$E0
    STA World1CameraTileX
    LDA #$D8
    STA World1CameraTileY
    LDA #$78
    STA World1PlayerX
    LDA #$80
    STA World1PlayerY
    LDA #$00
    STA World1PlayerDamageState
    STA ExtraLifeScoreThresholdIndex
    STA ExtraLifeSoundCounter
    STA World1PlayerMetasprite
    STA World1PlayerDirection
    STA World1PlayerRenderFlags
    STA World1PlayerRenderFlags
    STA World1WeaponLevel
    STA $63
    STA DemoModeActive
    STA $28
    STA $29
    STA Controller2MicrophoneEdgeTimer
    LDA #$06
    STA PlayerHealthCapacityIndex
    JSR Bank0_Func_8362
    RTS

Bank0_Func_834E:
    JSR Bank0_Func_83BD
    LDA #$EF
    STA $66
    LDA #$B2
    STA $67
    LDA #$89
    STA World1ObjectPlacementList
    LDA #$D9
    STA World1ObjectPlacementList+$01
    RTS

Bank0_Func_8362:
    LDA #$08
    SEC
    SBC PlayerHealthCapacityIndex
    ASL A
    ASL A
    STA PlayerHealth
    LDA #$00
    STA World1PlayerDamageState
    LDA #$00
    STA World1PlayerMetasprite
    LDA #$00
    STA World1PlayerDirection
    LDA #$00
    STA World1PlayerRenderFlags
    RTS

Bank0_Func_837C:
    LDX #$00
    TXA

Bank0_Label_837F:
    STA a:OamBuffer,X
    STA a:World1EntityType,X
    STA a:World1EntityY+$10,X
    STA a:World1EntityDamageTimerOrAcceleration+$20,X
    STA a:World1AttributeTableCache+$50,X
    CPX #$F8
    BCS Bank0_Label_8398
    CPX #$3C
    BCC Bank0_Label_8398
    STA $00,X

Bank0_Label_8398:
    CPX #$90
    BCS Bank0_Label_839F
    STA a:$0200,X

Bank0_Label_839F:
    INX
    BNE Bank0_Label_837F
    RTS

Bank0_Func_83A3:
    LDA #$00
    STA a:AudioEffectRequestState
    STA a:AudioMusicState
    STA a:AudioMusicControl
    STA a:$4011
    STA a:APU_STATUS
    STA a:$4010
    LDA #$40
    STA a:$4017
    RTS

Bank0_Func_83BD:
    LDA #$00
    STA $00
    LDA $29
    LSR A
    ROR $00
    LSR A
    ROR $00
    LSR A
    ROR $00
    STA $01
    LDA $00
    CLC
    ADC #$A5
    STA $00
    LDA $01
    ADC #$D7
    STA $01
    LDY #$00

Bank0_Label_83DD:
    LDA ($00),Y
    STA a:$0210,Y
    INY
    CPY #$20
    BCC Bank0_Label_83DD
    RTS

Bank0_Func_83E8:
    JSR Bank0_Func_9614
    JSR Bank0_Func_83A3
    LDA PpuCtrlShadow
    AND #$FE
    ORA #$10
    STA PpuCtrlShadow
    LDA #$00
    STA PpuScrollXShadow
    STA PpuScrollYShadow
    STA World1NametableX
    STA World1PpuScrollXLatched
    STA World1PpuScrollYLatched
    STA $51
    JSR Bank0_Func_8131
    LDA #$5B
    STA FrameCounter
    LDA DemoModeActive
    BNE Bank0_Label_841D
    JSR Bank0_Func_8053
    JSR Bank0_Func_95ED
    LDX #$5A

Bank0_Label_8417:
    JSR Bank0_Func_94F1
    DEX
    BNE Bank0_Label_8417

Bank0_Label_841D:
    JSR Bank0_Func_9614
    JSR Bank0_Func_834E
    JSR Bank0_Func_94F8
    JSR Bank0_Func_951B
    LDA PpuCtrlShadow
    ORA #$10
    STA PpuCtrlShadow
    LDA #$00
    JSR Bank0_Func_81AA
    JSR World1_RefreshObjectSpawnMask
    JSR Bank0_Func_8362
    RTS

Bank0_Func_843B:
    LDA $29
    TAX
    LDA a:$8445,X
    STA a:AudioMusicState
    RTS
    .byte $01, $04, $05, $02, $02, $02, $02, $02, $03, $03, $02, $02

World1_DemoEntry:
    LDX #$7F
    TXS
    LDA #$00
    STA a:$0180
    JSR Bank0_Func_83A3
    JSR Bank0_Func_837C
    JSR Bank0_Func_8313
    LDA #$01
    STA DemoModeActive
    LDA #$00
    STA a:$0180
    LDA #$00
    STA FrameCounter
    STA $52
    STA $53
    STA $54
    STA $55
    STA $56
    STA $57
    LDA #$BF
    STA $A6
    LDA #$FC
    STA $A7
    LDA #$00
    STA $A8
    STA $A9
    LDA #$02
    STA World1WeaponLevel
    JMP Bank0_Label_829F

Bank0_Func_8490:
    LDA DemoModeActive
    BNE Bank0_Label_84A3

Bank0_Label_8494:
    LDA CombinedControllerButtons
    EOR $64
    STA $65
    LDA CombinedControllerButtons
    STA $64
    AND $65
    STA $65
    RTS

Bank0_Label_84A3:
    LDA CombinedControllerButtons
    AND #$30
    BNE Bank0_Label_84D6
    LDA $A8
    BNE Bank0_Label_84CB
    LDY #$00
    LDA ($A6),Y
    STA $A8
    INY
    LDA ($A6),Y
    STA $A9
    LDA $A6
    CLC
    ADC #$02
    STA $A6
    BCC Bank0_Label_84C3
    INC $A7

Bank0_Label_84C3:
    LDA $A8
    AND $A9
    CMP #$FF
    BEQ Bank0_Label_84D6

Bank0_Label_84CB:
    DEC $A8
    LDA $A9
    AND #$CF
    STA CombinedControllerButtons
    JMP Bank0_Label_8494

Bank0_Label_84D6:
    JMP Bank0_Func_8048

Bank0_Func_84D9:
    LDA NmiOamDmaRequest
    BNE Bank0_Label_84E0
    JMP Bank0_Label_856B

Bank0_Label_84E0:
    LDA a:$0260
    ORA a:$0230
    BEQ Bank0_Label_84EE
    JSR Bank0_Func_A87E
    JMP Bank0_Label_8531

Bank0_Label_84EE:
    LDY #$00

Bank0_Label_84F0:
    LDA a:$0180,Y
    BEQ Bank0_Label_8531
    PHA
    LDA #$00
    STA a:$0180,Y
    PLA
    CMP #$02
    BEQ Bank0_Label_8527
    LDA PpuCtrlShadow
    AND #$FB
    STA a:PPU_CTRL

Bank0_Label_8507:
    INY
    LDA a:$0180,Y
    STA a:PPU_ADDR
    INY
    LDA a:$0180,Y
    STA a:PPU_ADDR
    INY
    LDA a:$0180,Y
    TAX
    INY

Bank0_Label_851B:
    LDA a:$0180,Y
    INY
    STA a:PPU_DATA
    DEX
    BNE Bank0_Label_851B
    BEQ Bank0_Label_84F0

Bank0_Label_8527:
    LDA PpuCtrlShadow
    ORA #$04
    STA a:PPU_CTRL
    JMP Bank0_Label_8507

Bank0_Label_8531:
    LDA PpuCtrlShadow
    AND #$FB
    STA a:PPU_CTRL
    LDA PpuMaskShadow
    STA a:PPU_MASK
    LDA World1PpuScrollXLatched
    STA a:PPU_SCROLL
    LDA World1PpuScrollYLatched
    STA a:PPU_SCROLL
    LDA PpuScrollXShadow
    STA World1PpuScrollXLatched
    LDA PpuScrollYShadow
    STA World1PpuScrollYLatched
    LDA PpuCtrlShadow
    AND #$FE
    STA $0A
    LDA World1NametableX
    AND #$01
    ORA $0A
    STA PpuCtrlShadow
    JSR Bank0_Func_8131
    LDA #$00
    STA World1OamWriteIndex
    LDA $51
    BEQ Bank0_Label_856B
    JSR Bank0_Func_9674

Bank0_Label_856B:
    RTS
