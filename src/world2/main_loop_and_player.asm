; Doraemon PRG bank 1 $88A4-$8C5C
; World 2 initialization, frame loop, and player flight state
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank1_World2Main:
    LDX #$7F
    TXS
    LDA #$00
    STA World2InventoryState+$06
    STA World2InventorySlot5PickupCount
    STA World2MicrophoneAttackUsed
    STA DemoModeActive

Bank1_Label_88B1:
    LDA #$00
    STA World2FrameCounter
    STA World2StageIndex

Bank1_Label_88B7:
    LDX #$7F
    TXS
    JSR World2_InitializePpuAndNametable
    JSR World2_ResetAudioHardware
    LDA #$02
    STA World2MovementStep
    LDA #$3C
    STA World2PlayerX
    LDA #$78
    STA World2PlayerY
    LDA #$00
    STA World2MicrophoneHoldCounter
    STA World2ScrollY
    STA World2VerticalTransitionDelay
    STA World2ScrollX
    STA World2TakkonDefeatStreak
    STA World2StageBranchCooldown
    STA World2PlayerHistoryWriteIndex
    STA World2BossEncounterState
    STA World2PendingBackgroundPalette
    STA World2SpriteFlickerPhase
    STA World2CompanionFireCounter
    STA World2CompanionFirePhase
    STA World2InventorySlot2AttackActive
    STA World2InventorySlot0ProjectileActive
    STA World2HorizontalTransitionDelay
    STA World2ScrollDirection
    STA World2PendingScrollDirection
    STA World2PlayerDamageTimer
    STA World2PlayerHazardContact
    STA World2InventoryDropHitCounter
    STA World2InventorySlot0ProjectileAimPhase
    STA World2InventoryState
    STA World2InventoryState+$01
    STA World2ScrollingActive
    STA World2InventoryState+$02
    STA World2InventoryState+$04
    STA World2InventoryState+$05
    STA World2InventoryState+$03
    STA World2PlayerDamageEffect
    STA World2StageComplete
    STA World2PlayerDamageTimer
    STA World2PlayerDefeated
    STA World2ChapterComplete
    STA $38
    LDA #$96
    STA World2SequenceTimer
    JSR World2_LoadInitialPlayerHealth
    STA PlayerHealth
    LDA World1FlashLightCarryFlag
    BEQ Bank1_Label_8923
    LDA #$03
    STA World2InventoryState+$02

Bank1_Label_8923:
    LDA #$00
    STA World1FlashLightCarryFlag
    JSR World2_ClearScreenMetatileBuffer
    LDA DemoModeActive
    BNE Bank1_Label_8940
    LDA #$01
    STA $28
    JSR Bank1_CallShellStatusScreen
    JSR Bank1_EnableNmiAndRendering
    LDX #$5A

Bank1_Label_893A:
    JSR Bank1_WaitForVblank
    DEX
    BNE Bank1_Label_893A

Bank1_Label_8940:
    JSR World2_InitializePpuAndNametable
    LDA #$01
    JSR Bank1_SelectChrBank
    JSR World2_InitializeStagePresentation
    LDA PpuCtrlShadow
    AND #$E7
    ORA #$11
    STA PpuCtrlShadow
    JSR Bank1_EnableNmiAndRendering
    JSR World2_ClearEntityPools

Bank1_World2FrameLoop:
    JSR World2_WaitForNextFrame
    JSR World2_UpdateStageStartCountdown
    JSR World2_UpdateStageMusicCountdown
    JSR World2_UpdatePlayerAndInventory
    JSR World2_UpdatePlayerProjectiles
    JSR World2_UpdateEnemies
    JSR World2_UpdateEnemyProjectiles
    JSR World2_UpdateBossEncounter
    JSR World2_ScanPlayerHazardContacts
    JSR World2_CheckStageBranch
    JSR World2_UpdateInventorySpawns
    JSR World2_RenderFrame
    JSR World2_UpdateMicrophoneAttackAndExtraLifeSound
    JSR World2_CheckChapterCompletionExit
    LDA World2ChapterComplete
    BNE Bank1_Label_89D1
    LDA World2StageComplete
    BNE Bank1_Label_89CE
    LDA DemoModeActive
    BEQ Bank1_Label_8991
    LDA #$20

Bank1_Label_8991:
    ORA #$10
    AND CombinedControllerButtons
    BNE Bank1_Label_89D7
    LDA World2PlayerDefeated
    BEQ Bank1_World2FrameLoop
    LDA DemoModeActive
    BNE Bank1_Label_89DB
    LDA #$06
    STA a:AudioMusicState
    LDA #$00
    STA World2ScrollingActive
    LDA #$DC
    STA World2SequenceTimer

Bank1_Label_89AC:
    JSR World2_WaitAndRenderFrame
    DEC World2SequenceTimer
    BNE Bank1_Label_89AC
    DEC PlayerLives
    BMI Bank1_Label_89BA
    JMP Bank1_Label_88B7

Bank1_Label_89BA:
    JSR Bank1_CallShellGameOver
    LDA #$00
    LDX #$06

Bank1_Label_89C1:
    STA a:ScoreDigitsWorking,X
    DEX
    BPL Bank1_Label_89C1
    LDA #$02
    STA PlayerLives
    JMP Bank1_Label_88B7

Bank1_Label_89CE:
    JMP World2_AdvanceStage

Bank1_Label_89D1:
    JSR World2_PlayCompletionEffectAndDelay
    JMP World2_EnterWorld3

Bank1_Label_89D7:
    LDA DemoModeActive
    BEQ Bank1_Label_89DE

Bank1_Label_89DB:
    JMP Bank1_EnterShell

Bank1_Label_89DE:
    LDA World2ScrollingActive
    PHA
    LDA #$00
    STA World2ScrollingActive
    LDA #$06
    JSR World2_Audio_QueueEffectWithPriority
    LDA #$01
    STA a:AudioMusicControl

Bank1_Label_89EF:
    JSR World2_WaitAndRenderFrame
    LDA CombinedControllerButtons
    AND #$10
    BNE Bank1_Label_89EF

Bank1_Label_89F8:
    JSR World2_WaitAndRenderFrame
    LDA CombinedControllerButtons
    AND #$10
    BEQ Bank1_Label_89F8
    LDA #$06
    JSR World2_Audio_QueueEffectWithPriority
    LDA #$00
    STA a:AudioMusicControl

Bank1_Label_8A0B:
    JSR World2_WaitAndRenderFrame
    LDA CombinedControllerButtons
    AND #$10
    BNE Bank1_Label_8A0B
    PLA
    STA World2ScrollingActive
    JMP Bank1_World2FrameLoop

World2_WaitAndRenderFrame:
    JSR World2_WaitForNextFrame

World2_RenderFrame:
    JSR World2_HideAllSpriteBuffers
    JSR World2_RenderProjectilesAndInventoryAttacks
    JSR World2_RenderPriorityInventorySlots2And3
    JSR World2_RenderEnemies
    JSR World2_RenderEnemyProjectiles
    JSR World2_RenderPlayerAndInventory
    JMP World2_RenderHud

World2_EnterWorld3:
    LDA World2InventoryState+$06
    STA $38
    JMP Bank1_EnterWorld2ToWorld3Transition

World2_WaitForNextFrame:
    LDA FrameCounter

Bank1_Label_8A3B:
    CMP FrameCounter
    BEQ Bank1_Label_8A3B
    LDA World2SpriteFlickerPhase
    EOR #$80
    STA World2SpriteFlickerPhase
    RTS

World2_AdvanceStage:
    JSR World2_ClearEntityPools
    JSR World2_RunStageTransitionDelay
    LDA #$01
    STA World2ScrollingActive
    LDA #$00
    STA World2StageComplete
    STA World2BossEncounterState
    LDA #$64
    STA World2SequenceTimer
    LDA World2SavedBackgroundPalette
    STA World2PendingBackgroundPalette
    LDA World2StageIndex
    CMP #$02
    BEQ Bank1_Label_8A66
    INC World2StageIndex

Bank1_Label_8A66:
    BNE Bank1_Label_8A71
    LDX #$00
    JSR World2_DowngradeInventorySlotAfterStage
    INX
    JSR World2_DowngradeInventorySlotAfterStage

Bank1_Label_8A71:
    JMP Bank1_World2FrameLoop

World2_DowngradeInventorySlotAfterStage:
    LDA World2InventoryState,X
    CMP #$03
    BEQ Bank1_Label_8A7E
    LDA #$02
    STA World2InventoryState,X

Bank1_Label_8A7E:
    RTS

World2_PlayCompletionEffectAndDelay:
    LDA #$09
    JSR World2_Audio_QueueEffect

World2_RunStageTransitionDelay:
    LDA #$F0
    STA World2SequenceTimer

Bank1_Label_8A88:
    JSR World2_WaitAndRenderFrame
    LDA #$FF
    STA World2PendingBackgroundPalette
    DEC World2SequenceTimer
    BNE Bank1_Label_8A88
    RTS

World2_HideAllSpriteBuffers:
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

World2_ClearScreenMetatileBuffer:
    LDX #$FF
    LDA #$00

Bank1_Label_8AAF:
    STA a:World2ScreenMetatiles,X
    DEX
    BNE Bank1_Label_8AAF
    RTS

World2_ResetAudioHardware:
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

World2_LoadInitialPlayerHealth:
    STX World2SavedEntitySlot
    LDX PlayerHealthCapacityIndex
    LDA a:$8AD8,X
    LDX World2SavedEntitySlot
    RTS
    .byte $18, $14, $10, $0C, $08

World2_InitializeStagePresentation:
    JSR Bank1_WaitForVblank
    LDY World2StageIndex
    LDX a:World2_StageSequenceStartOffsets,Y
    DEX
    STX World2StageSequenceOffset
    LDX a:World2_InitialSpritePaletteOffsets,Y
    JSR World2_UploadSpritePalette
    LDX World2StageIndex
    LDA a:World2_InitialBackgroundPaletteIds,X
    JSR World2_UploadBackgroundPalette
    LDA #$0F
    STA World2ScreenRowIndex
    LDA #$00
    STA World2ScrollY
    STA World2VerticalTransitionDelay
    STA World2ScrollX
    STA World2ScrollDirection
    STA World2ScrollingActive
    LDA #$F0
    STA World2ScrollX
    LDA #$80
    STA World2StageStartCountdown
    LDA #$11
    STA $67

Bank1_Label_8B14:
    JSR World2_AdvanceScreenStage
    JSR World2_DecodeScreenRow15
    JSR World2_PrepareRowTransferAddresses
    JSR World2_ReadVerticalAttributeColumn
    JSR World2_ExpandVerticalMetatileColumn
    JSR World2_UploadVerticalTileColumnsA
    JSR World2_MergeVerticalAttributes
    JSR World2_UploadVerticalTileColumnsBAndAttributes
    LDA World2ScrollX
    CLC
    ADC #$10
    STA World2ScrollX
    DEC $67
    BNE Bank1_Label_8B14
    RTS

World2_StageSequenceStartOffsets:
    .byte $00, $25, $5C

World2_UpdateStageStartCountdown:
    LDA DemoModeActive
    BNE Bank1_Label_8B47
    LDA World2StageStartCountdown
    BEQ Bank1_Label_8B4B
    DEC World2StageStartCountdown
    BNE Bank1_Label_8B4B

Bank1_Label_8B47:
    LDA #$01
    STA World2ScrollingActive

Bank1_Label_8B4B:
    RTS

World2_UpdateStageMusicCountdown:
    LDA World2SequenceTimer
    BEQ Bank1_Label_8B64
    LDA DemoModeActive
    BNE Bank1_Label_8B58
    DEC World2SequenceTimer
    BNE Bank1_Label_8B64

Bank1_Label_8B58:
    LDX World2StageIndex
    LDA a:$8BA2,X
    STA a:AudioMusicState
    LDA #$00
    STA World2SequenceTimer

Bank1_Label_8B64:
    RTS

World2_UpdateMicrophoneAttackAndExtraLifeSound:
    LDA World2MicrophoneAttackUsed
    BNE Bank1_Label_8B92
    LDA World2InventoryState
    CMP #$03
    BNE Bank1_Label_8B92
    LDA Controller2MicrophoneEdgeTimer
    BEQ Bank1_Label_8B90
    INC World2MicrophoneHoldCounter
    LDA World2MicrophoneHoldCounter
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
    INC World2MicrophoneAttackUsed

Bank1_Label_8B90:
    STA World2MicrophoneHoldCounter

Bank1_Label_8B92:
    JSR World2_CommitScoreAndCheckExtraLife
    LDA ExtraLifeSoundCounter
    BEQ Bank1_Label_8B64
    LDA #$00
    STA ExtraLifeSoundCounter
    LDA #$0D
    JMP World2_Audio_QueueEffect
    .byte $01, $02, $03, $01

World2_InitialBackgroundPaletteIds:
    .byte $01, $04, $05

World2_InitialSpritePaletteOffsets:
    .byte $10, $20, $30

World2_UpdatePlayerAndInventory:
    JSR World2_UpdatePlayerMovementAndFire
    JSR World2_RecordPlayerPositionHistory
    JSR World2_UpdateInventorySlot1
    JSR World2_UpdateInventorySlot0
    JSR World2_UpdateInventorySlot2
    JSR World2_UpdateInventorySlot3
    JSR World2_UpdateInventorySlot5
    JSR World2_UpdateInventorySlot4
    JSR World2_UpdatePlayerDamageEffect
    JSR World2_UpdateInventorySlot6
    LDA World2PlayerDamageTimer
    BNE Bank1_Label_8C3C
    LDA World2PlayerDamageEffect
    BNE Bank1_Label_8C3B
    LDA DemoModeActive
    BEQ Bank1_Label_8BDF
    LDA World2FrameCounter
    ROL A
    BCS Bank1_Label_8BDF
    LDA #$00
    STA World2PlayerHazardContact

Bank1_Label_8BDF:
    LDA World2PlayerHazardContact
    BEQ Bank1_Label_8C3B
    STA $B0
    LDA #$00
    STA World2PlayerHazardContact
    LDA World2InventoryState+$04
    CMP #$03
    BEQ Bank1_Label_8C18
    LDA #$00
    STA World2InventorySlot2AttackActive
    LDA #$0C
    JSR World2_Audio_QueueEffectWithPriority
    LDA #$78
    STA World2PlayerDamageTimer
    INC World2InventoryDropHitCounter
    LDA World2InventoryDropHitCounter
    CMP #$04
    BCC Bank1_Label_8C3B

Bank1_Label_8C04:
    LDA #$00
    STA World2InventoryDropHitCounter
    LDA DemoModeActive
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
    INC World2InventoryDropHitCounter
    LDA World2InventoryDropHitCounter
    CMP #$06
    BCS Bank1_Label_8C04
    LDA #$01
    STA World2PlayerDamageEffect
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
    DEC World2PlayerDamageTimer
    BNE Bank1_Label_8C3B
    LDX $B0
    BPL Bank1_Label_8C4E
    DEX
    BPL Bank1_Label_8C4E
    DEX
    BPL Bank1_Label_8C4C
    DEC PlayerHealth

Bank1_Label_8C4C:
    DEC PlayerHealth

Bank1_Label_8C4E:
    DEC PlayerHealth
    LDA PlayerHealth
    BPL Bank1_Label_8C5C
    LDA #$01
    STA World2PlayerDefeated
    LDA #$00
    STA PlayerHealth

Bank1_Label_8C5C:
    RTS
