; Doraemon PRG bank 0 $D3A9-$D76F
; World 1 underground room changes, completion paths, and entity updates
; Generated deterministically from pinned Ghidra/GhidraNes facts

World1_EnterUndergroundFinale:
    LDX #$00

Bank0_Label_D3AB:
    LDA a:World1CollectedObjectBits,X
    STA a:World1SavedCityObjectBits,X
    LDA a:World1SavedUndergroundObjectBits,X
    STA a:World1CollectedObjectBits,X
    INX
    CPX #$10
    BNE Bank0_Label_D3AB
    JMP Bank0_Label_D3CB

Bank0_Label_D3BF:
    JSR World1_InitializeAreaPresentation
    LDA #$01
    STA $51
    LDA #$06
    JMP World1_ReturnFromUndergroundToCity

Bank0_Label_D3CB:
    LDA #$00
    STA World1PlayerDamageState
    LDA #$01
    STA $51
    LDA #$78
    STA World1PlayerX
    LDA #$B0
    STA World1PlayerY
    LDA #$00
    STA World1CameraTileX
    LDA #$22
    STA World1CameraTileY
    LDA #$22
    STA World1UndergroundAxisScrollLimit
    LDA #$22
    STA World1UndergroundAxisScrollCoarse
    LDA #$00
    STA World1UndergroundAxisScrollFine
    STA World1PlayerAirborne
    STA World1PlayerYVelocity
    STA World1PlayerXSubpixel
    STA World1UndergroundFinaleFloorActive
    STA a:AudioMusicControl
    STA World1EnemyFreezeActive
    STA World1EnemyFreezeTimer
    STA World1InvulnerabilityTimer
    JSR World1_DisableGameplayRendering
    LDA #$EF
    STA World1MapDataPointer
    LDA #$C2
    STA World1MapDataPointer+$01
    LDA #$25
    STA World1ObjectPlacementList
    LDA #$D9
    STA World1ObjectPlacementList+$01
    LDA #$02
    STA $29
    JSR World1_LoadAreaPalette
    JSR World1_PrefillMapViewport
    JSR World1_UploadOrQueuePalette
    JSR World1_StartAreaMusic
    JSR World1_EnableGameplayRendering
    LDX #$7F
    TXS

Bank0_Label_D429:
    JSR World1_WaitForNextFrame
    JSR World1_UpdateInputOrDemoStream
    JSR World1_HandlePause
    JSR World1_UpdatePlayerProjectiles
    JSR World1_UpdateUndergroundPlayer
    JSR World1_UpdateTimedPowerups
    JSR World1_ScanPlayerProjectileHits
    JSR World1_TrackUndergroundVerticalCamera
    JSR World1_SpawnObjectsAtCameraEdges
    JSR World1_UpdateEntities
    JSR World1_UpdateTransientEntities
    JSR World1_ScanPlayerContacts
    JSR World1_CullOffscreenEntities
    JSR World1_CommitScoreAndCheckExtraLife
    LDA PpuScrollYShadow
    AND #$07
    ORA World1CameraTileY
    BEQ Bank0_Label_D462
    LDA World1PlayerDamageState
    BMI World1_HandleFinalePlayerDeath
    JMP Bank0_Label_D429

Bank0_Label_D462:
    JMP World1_RunBullRoboFinale

World1_HandleFinalePlayerDeath:
    JSR World1_PlayPlayerDeathSequence
    DEC PlayerLives
    BMI Bank0_Label_D46F
    JMP Bank0_Label_D3BF

Bank0_Label_D46F:
    JSR Bank0_CallShellGameOver
    LDA #$02
    STA PlayerLives
    JSR World1_ClearWorkingScoreUnlessDemo
    JMP Bank0_Label_D3BF

World1_TrackUndergroundVerticalCamera:
    LDA #$00
    STA World1ScreenDeltaX
    STA World1ScreenDeltaY
    LDA World1PlayerY
    SEC
    SBC #$6E
    BCS Bank0_Label_D4B6
    EOR #$FF
    SEC
    ADC #$00
    STA World1UndergroundAxisScrollBudget
    CMP #$07
    BCC Bank0_Label_D498
    LDA #$06
    STA World1UndergroundAxisScrollBudget

Bank0_Label_D498:
    LDA World1UndergroundAxisScrollCoarse
    ORA World1UndergroundAxisScrollFine
    BEQ Bank0_Label_D4E3
    LDA World1UndergroundAxisScrollFine
    SEC
    SBC #$01
    AND #$07
    STA World1UndergroundAxisScrollFine
    CMP #$07
    BNE Bank0_Label_D4AD
    DEC World1UndergroundAxisScrollCoarse

Bank0_Label_D4AD:
    JSR World1_TryScrollCameraUp
    DEC World1UndergroundAxisScrollBudget
    BNE Bank0_Label_D498
    BEQ Bank0_Label_D4E3

Bank0_Label_D4B6:
    LDA World1PlayerY
    SEC
    SBC #$92
    BCC Bank0_Label_D4E3
    STA World1UndergroundAxisScrollBudget
    CMP #$06
    BCC Bank0_Label_D4C7
    LDA #$05
    STA World1UndergroundAxisScrollBudget

Bank0_Label_D4C7:
    INC World1UndergroundAxisScrollBudget

Bank0_Label_D4C9:
    LDA World1UndergroundAxisScrollCoarse
    CMP World1UndergroundAxisScrollLimit
    BEQ Bank0_Label_D4E3
    LDA World1UndergroundAxisScrollFine
    CLC
    ADC #$01
    AND #$07
    STA World1UndergroundAxisScrollFine
    BNE Bank0_Label_D4DC
    INC World1UndergroundAxisScrollCoarse

Bank0_Label_D4DC:
    JSR World1_TryScrollCameraDown
    DEC World1UndergroundAxisScrollBudget
    BNE Bank0_Label_D4C9

Bank0_Label_D4E3:
    LDA World1PlayerY
    CLC
    ADC World1ScreenDeltaY
    STA World1PlayerY
    JSR World1_ApplyCameraDeltaToEntities
    RTS

World1_RunBullRoboFinale:
    JSR World1_ClearEntitySlots10_29
    LDA #$06
    STA a:AudioMusicState
    LDA #$00
    STA a:AudioMusicControl
    STA World1EnemyFreezeActive
    STA World1EnemyFreezeTimer
    STA World1InvulnerabilityTimer
    LDA #$01
    STA World1UndergroundFinaleFloorActive
    JSR World1_ClearEntitySlots10_29
    JSR World1_ClearEntitySlots00_09
    JSR World1_RefreshObjectSpawnMask
    LDA #$00
    STA a:World1EntityType
    LDA #$3A
    STA a:World1EntityMetasprite
    LDA #$00
    STA a:World1EntityPositionHigh
    LDA #$32
    STA a:World1EntityX
    LDA #$70
    STA a:World1EntityY
    LDA #$01
    STA a:World1EntityRenderFlags
    LDA #$FF
    STA a:World1EntitySourceObjectId
    LDA #$00
    STA a:World1EntityPrimaryBehavior
    LDA #$00
    STA a:World1EntitySecondaryBehavior
    LDA #$18
    STA a:World1EntityHealthOrVelocity
    LDA #$00
    STA a:World1EntityDamageTimerOrAcceleration
    LDA #$07
    STA World1BullRoboSequenceCounter
    LDA #$00
    STA World1BullRoboRevealTimer

Bank0_Label_D54D:
    JSR World1_WaitForNextFrame
    LDA #$00
    STA a:World1EntityType
    LDA World1BullRoboRevealTimer
    AND World1BullRoboSequenceCounter
    BNE Bank0_Label_D560
    LDA #$0F
    STA a:World1EntityType

Bank0_Label_D560:
    JSR World1_UpdateInputOrDemoStream
    JSR World1_HandlePause
    JSR World1_UpdatePlayerProjectiles
    JSR World1_UpdateUndergroundPlayer
    JSR World1_UpdateTimedPowerups
    JSR World1_ScanPlayerProjectileHits
    JSR World1_UpdateEntities
    JSR World1_UpdateTransientEntities
    JSR World1_ScanPlayerContacts
    JSR World1_CullOffscreenEntities
    JSR World1_CommitScoreAndCheckExtraLife
    LDA World1PlayerDamageState
    BMI Bank0_Label_D594
    DEC World1BullRoboRevealTimer
    BEQ Bank0_Label_D598
    LDA World1BullRoboRevealTimer
    AND #$3F
    BNE Bank0_Label_D54D
    LSR World1BullRoboSequenceCounter
    JMP Bank0_Label_D54D

Bank0_Label_D594:
    JMP World1_HandleFinalePlayerDeath

World1_NoOpBullRoboScriptedState:
    RTS

Bank0_Label_D598:
    LDA #$0E
    STA a:World1EntityType
    LDA #$00
    STA World1BullRoboJumpPhase
    STA $98
    LDA #$38
    STA a:World1EntityMetasprite
    JSR World1_RandomByte
    AND #$3F
    CLC
    ADC #$20
    STA World1BullRoboAttackTimer

Bank0_Label_D5B2:
    JSR World1_WaitForNextFrame
    JSR World1_UpdateInputOrDemoStream
    JSR World1_HandlePause
    JSR World1_UpdatePlayerProjectiles
    JSR World1_UpdateUndergroundPlayer
    JSR World1_UpdateTimedPowerups
    JSR World1_UpdateEntities
    JSR World1_ScanPlayerProjectileHits
    JSR World1_UpdateTransientEntities
    JSR World1_ScanPlayerContacts
    JSR World1_CullOffscreenEntities
    JSR World1_CommitScoreAndCheckExtraLife
    JSR World1_UpdateBullRoboBoss
    LDA a:World1EntityType
    BEQ Bank0_Label_D5E5
    LDA World1PlayerDamageState
    BMI Bank0_Label_D594
    JMP Bank0_Label_D5B2

Bank0_Label_D5E5:
    LDA #$00
    STA a:AudioMusicState
    LDA #$04
    JSR World1_Audio_QueueEffect
    LDA #$00
    STA ExtraLifeSoundCounter
    LDA #$0F
    STA a:World1EntityType
    LDA #$00
    STA a:World1EntityPositionHigh
    LDA #$A0
    STA World1BullRoboSequenceCounter

Bank0_Label_D601:
    JSR World1_WaitForNextFrame
    JSR World1_UpdateInputOrDemoStream
    JSR World1_UpdateUndergroundPlayer
    LDA FrameCounter
    AND #$03
    BNE Bank0_Label_D619
    LDA World1BullRoboSequenceCounter
    CMP #$14
    BCC Bank0_Label_D619
    JSR World1_SpawnBullRoboExplosion

Bank0_Label_D619:
    JSR World1_UpdatePlayerProjectiles
    DEC World1BullRoboSequenceCounter
    BNE Bank0_Label_D601
    JSR World1_ClearEntitySlots30_37
    JSR World1_ClearEntitySlots10_29
    LDA #$0F
    STA a:World1EntityType
    LDA #$00
    STA a:World1EntityPositionHigh
    LDA #$36
    STA a:World1EntityMetasprite
    LDA #$01
    STA a:World1EntityRenderFlags
    LDA #$80
    STA a:World1EntityX
    LDA #$88
    STA a:World1EntityY
    LDA #$00
    STA World1PlayerDamageState
    LDA #$12
    STA World1PlayerMetasprite
    LDA #$00
    STA World1PlayerRenderFlags
    LDA #$70
    STA World1PlayerX
    LDA #$86
    STA World1PlayerY
    LDA #$08
    STA a:AudioMusicState

Bank0_Label_D65D:
    JSR World1_WaitForNextFrame
    JSR World1_UpdateInputOrDemoStream
    JSR World1_UpdatePlayerProjectiles
    LDA FrameCounter
    LSR A
    LSR A
    LSR A
    LSR A
    AND #$01
    ORA #$12
    STA World1PlayerMetasprite
    LDA a:AudioMusicState
    BNE Bank0_Label_D65D
    JMP Bank0_EnterWorld1ToWorld2Transition

World1_UpdateBullRoboBoss:
    LDA a:World1EntityRenderFlags
    AND #$8F
    STA a:World1EntityRenderFlags
    LDA a:World1EntityType
    BPL Bank0_Label_D68C
    LDA #$11
    JSR World1_Audio_QueueEffectWithPriority

Bank0_Label_D68C:
    LDA a:World1EntityPrimaryBehavior
    BEQ Bank0_Label_D6D4
    LDA World1BullRoboJumpPhase
    CMP #$18
    BEQ Bank0_Label_D6BD
    AND #$80
    STA $00
    LDA World1BullRoboJumpPhase
    LSR A
    ORA $00
    LSR A
    ORA $00
    CLC
    ADC a:World1EntityY
    STA a:World1EntityY
    LDA #$3B
    STA a:World1EntityMetasprite
    LDA World1BullRoboJumpPhase
    BMI Bank0_Label_D6B8
    LDA #$3A
    STA a:World1EntityMetasprite

Bank0_Label_D6B8:
    INC World1BullRoboJumpPhase
    JMP Bank0_Label_D718

Bank0_Label_D6BD:
    LDA #$00
    STA a:World1EntityPrimaryBehavior
    LDA #$38
    STA a:World1EntityMetasprite
    JSR World1_RandomByte
    AND #$3F
    CLC
    ADC #$40
    STA World1BullRoboAttackTimer
    JMP Bank0_Label_D718

Bank0_Label_D6D4:
    LDA FrameCounter
    LSR A
    LSR A
    LSR A
    AND #$01
    ORA #$38
    STA a:World1EntityMetasprite
    LDA a:World1EntitySecondaryBehavior
    BEQ Bank0_Label_D6F7
    INC a:World1EntityX
    LDA a:World1EntityX
    CMP #$70
    BCC Bank0_Label_D706
    LDA #$00
    STA a:World1EntitySecondaryBehavior
    JMP Bank0_Label_D706

Bank0_Label_D6F7:
    DEC a:World1EntityX
    LDA a:World1EntityX
    CMP #$08
    BCS Bank0_Label_D706
    LDA #$01
    STA a:World1EntitySecondaryBehavior

Bank0_Label_D706:
    DEC World1BullRoboAttackTimer
    BPL Bank0_Label_D718
    LDA #$01
    STA a:World1EntityPrimaryBehavior
    LDA #$EC
    STA World1BullRoboJumpPhase
    LDA #$3A
    STA a:World1EntityMetasprite

Bank0_Label_D718:
    LDY #$00

Bank0_Label_D71A:
    LDA a:World1EntityType+$0A,Y
    BEQ Bank0_Label_D725
    INY
    CPY #$04
    BNE Bank0_Label_D71A
    RTS

Bank0_Label_D725:
    LDA #$02
    STA a:World1EntityType+$0A,Y
    LDA #$32
    STA a:World1EntityMetasprite+$0A,Y
    LDA a:World1EntityPositionHigh
    STA a:World1EntityPositionHigh+$0A,Y
    LDA a:World1EntityX
    CLC
    ADC #$14
    STA a:World1EntityX+$0A,Y
    LDA a:World1EntityY
    STA a:World1EntityY+$0A,Y
    LDA #$01
    STA a:World1EntityRenderFlags+$0A,Y
    LDA #$FF
    STA a:World1EntitySourceObjectId+$0A,Y
    JSR World1_FrameRandomByte
    AND #$03
    CLC
    ADC #$01
    STA a:World1EntityPrimaryBehavior+$0A,Y
    JSR World1_FrameRandomByte
    AND #$07
    TAX
    LDA a:$9126,X
    STA a:World1EntityHealthOrVelocity+$0A,Y
    LDA #$00
    STA a:World1EntityDamageTimerOrAcceleration+$0A,Y
    LDA #$02
    STA a:World1EntitySecondaryBehavior+$0A,Y
    RTS
