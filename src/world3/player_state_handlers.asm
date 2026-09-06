; Doraemon PRG bank 2 $A21D-$A5DE
; World 3 player-state dispatch, handlers, and interaction state
; Generated deterministically from pinned Ghidra/GhidraNes facts

World3_UpdatePlayerState:
    LDA World3PlayerState
    ASL A
    TAX
    LDA a:World3_PlayerStateHandlerTable,X
    STA $40
    LDA a:$A230,X
    STA $41
    JSR World3_CallIndirect
    RTS

World3_PlayerStateHandlerTable:
    .byte $39, $A2, $35, $A3, $3C, $A3, $E9, $A2, $3A, $A2

World3_PlayerState_Frozen:
    RTS

World3_PlayerState_Dying:
    INC World3PlayerAnimationCounter
    LDA World3PlayerAnimationCounter
    AND #$07
    BNE Bank2_Label_A248
    LDA World3PlayerAnimationFrame
    EOR #$01
    STA World3PlayerAnimationFrame

Bank2_Label_A248:
    LDY World3PlayerVerticalMotionPhase
    CPY #$0E
    BEQ Bank2_Label_A250
    INC World3PlayerVerticalMotionPhase

Bank2_Label_A250:
    LDA a:World3_PlayerVerticalDeltaByPhase,Y
    BMI Bank2_Label_A25B
    CLC
    ADC World3PlayerY
    JMP Bank2_Label_A262

Bank2_Label_A25B:
    CLC
    ADC World3PlayerY
    BCS Bank2_Label_A262
    LDA #$00

Bank2_Label_A262:
    STA World3PlayerY
    CMP #$F0
    BCC Bank2_Label_A28C

Bank2_Label_A268:
    LDA a:AudioMusicState
    BNE Bank2_Label_A268

Bank2_Label_A26D:
    LDA #$3C
    STA World3FrameWaitCounter
    JSR World3_WaitFrames
    LDA #$00
    STA World3TreasurePenaltyCounter
    LDA PlayerLives
    BEQ Bank2_Label_A2BE
    DEC PlayerLives
    LDA World3AttractModeActive
    BEQ World3_RestartAfterDeath
    JMP Bank2_Label_82C3

World3_RestartAfterDeath:
    LDA World3PunishmentRoomActive
    BNE World3_ExitPunishmentRoom
    JMP Bank2_Label_834C

Bank2_Label_A28C:
    RTS

World3_ExitPunishmentRoom:
    LDA #$00
    STA World3PunishmentRoomActive
    JSR World3_SaveRoomObjectsState0
    JSR World3_SaveRoomObjectsState1
    LDA World3PunishmentReturnRoom
    STA World3CurrentRoom
    LDA World3CurrentRoom
    CMP #$11
    BNE Bank2_Label_A2A5
    LDA #$01
    STA World3PassingHoopPortalActive

Bank2_Label_A2A5:
    JSR World3_LoadCurrentRoom
    LDY #$00

Bank2_Label_A2AA:
    LDA a:World3PunishmentSavedPlayerState,Y
    STA a:World3PlayerX,Y
    INY
    CPY #$12
    BNE Bank2_Label_A2AA
    JSR World3_RefillHealthFromCapacity
    LDA World3RoomMusicTrack
    STA a:AudioMusicState
    RTS

Bank2_Label_A2BE:
    LDA World3AttractModeActive
    BEQ Bank2_Label_A2C5
    JMP Bank2_EnterShell

Bank2_Label_A2C5:
    JSR Bank2_CallShellGameOver

Bank2_Label_A2C8:
    LDA CombinedControllerButtons
    AND #$10
    BEQ Bank2_Label_A2C8
    JSR World3_ResetScoreLivesAndHealthCapacity
    JMP World3_RestartAfterDeath

World3_ResetScoreLivesAndHealthCapacity:
    LDX #$00
    LDA #$00

Bank2_Label_A2D8:
    STA a:ScoreDigitsWorking,X
    INX
    CPX #$08
    BNE Bank2_Label_A2D8
    LDA #$02
    STA PlayerLives
    LDA #$02
    STA PlayerHealthCapacityIndex
    RTS

World3_PlayerState_DamageRecovery:
    JSR World3_UpdateControlledPlayerMovement
    JSR World3_TryFirePlayerProjectile
    LDY World3PlayerDamageRecoveryPhase
    LDA a:World3_DamageRecoveryStepCount,Y
    STA $43
    BNE Bank2_Label_A308
    LDA #$01
    STA World3PlayerState
    LDY World3PlayerHorizontalDirection
    LDA a:World3_PlayerMetaspriteBaseByDirection,Y
    STA World3PlayerMetaspriteBase
    LDA #$00
    STA World3PlayerAnimationFrame
    RTS

Bank2_Label_A308:
    INC World3PlayerDamageRecoveryPhase
    LDA World3PlayerHorizontalDirection
    BEQ Bank2_Label_A31E

Bank2_Label_A30E:
    JSR World3_MovePlayerLeft
    DEC $43
    BNE Bank2_Label_A30E
    LDA #$00
    STA World3PlayerAnimationFrame
    LDA #$0B
    STA World3PlayerMetaspriteBase
    RTS

Bank2_Label_A31E:
    JSR World3_MovePlayerRight
    DEC $43
    BNE Bank2_Label_A31E
    LDA #$01
    STA World3PlayerAnimationFrame
    LDA #$0B
    STA World3PlayerMetaspriteBase
    RTS

World3_DamageRecoveryStepCount:
    .byte $04, $03, $03, $02, $02, $02, $00

World3_PlayerState_ControlledMovement:
    JSR World3_UpdateControlledPlayerMovement
    JSR World3_TryFirePlayerProjectile
    RTS

World3_PlayerState_ScriptedArc:
    JSR World3_UpdateScriptedPlayerArc
    JSR World3_TryFirePlayerProjectile
    RTS

World3_UpdateScriptedPlayerArc:
    LDY World3PlayerVerticalMotionPhase
    LDA a:World3_ScriptedPlayerArcVerticalDelta,Y
    BPL Bank2_Label_A35E
    LDA World3RoomRow
    BNE Bank2_Label_A354
    LDA World3PlayerY
    CMP #$08
    BCC Bank2_Label_A359

Bank2_Label_A354:
    JSR World3_ProbePlayerTopEdge
    BCS Bank2_Label_A35E

Bank2_Label_A359:
    LDA #$0E
    STA World3PlayerVerticalMotionPhase
    RTS

Bank2_Label_A35E:
    JSR World3_ProbePlayerHorizontalMidline
    LDA World3TerrainTile
    CMP #$00
    BNE Bank2_Label_A37B
    LDA #$01
    STA World3PlayerState
    LDY World3PlayerHorizontalDirection
    LDA a:World3_PlayerMetaspriteBaseByDirection,Y
    STA World3PlayerMetaspriteBase
    LDA #$00
    STA World3PlayerAnimationFrame
    LDA #$0E
    STA World3PlayerVerticalMotionPhase
    RTS

Bank2_Label_A37B:
    JSR World3_ApplyHorizontalMovementRate
    LDY World3PlayerVerticalMotionPhase
    LDA a:World3_ScriptedPlayerArcVerticalDelta,Y
    STA $08
    CMP #$04
    BEQ Bank2_Label_A394
    LDA World3PlayerScriptedArcDelay
    BEQ Bank2_Label_A392
    DEC World3PlayerScriptedArcDelay
    JMP Bank2_Label_A394

Bank2_Label_A392:
    INC World3PlayerVerticalMotionPhase

Bank2_Label_A394:
    LDA World3PlayerY
    CLC
    ADC $08
    STA World3PlayerY
    RTS

World3_ScriptedPlayerArcVerticalDelta:
    .byte $FC, $FD, $FD, $FE, $FE, $FE, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $01, $01
    .byte $01, $01, $02, $02, $02, $03, $03, $04

World3_UpdateControlledPlayerMovement:
    LDA World3PlayerFiringPoseActive
    BEQ Bank2_Label_A3CE
    INC World3PlayerAnimationCounter
    LDA World3PlayerAnimationCounter
    AND #$0F
    BNE Bank2_Label_A3CB
    LDA #$00
    STA World3PlayerFiringPoseActive
    LDY World3PlayerHorizontalDirection
    LDA a:World3_PlayerMetaspriteBaseByDirection,Y
    STA World3PlayerMetaspriteBase

Bank2_Label_A3CB:
    JMP Bank2_Label_A3E0

Bank2_Label_A3CE:
    INC World3PlayerAnimationCounter
    LDA World3PlayerAnimationCounter
    AND World3PlayerAnimationMask
    BNE Bank2_Label_A3E0
    LDA World3PlayerAnimationFrame
    BNE Bank2_Label_A3DE
    LDA #$03
    STA World3PlayerAnimationFrame

Bank2_Label_A3DE:
    DEC World3PlayerAnimationFrame

Bank2_Label_A3E0:
    JSR World3_ReadActivePlayerButtons
    AND #$08
    BNE Bank2_Label_A3F2
    LDA #$07
    STA World3PlayerAnimationMask

Bank2_Label_A3EB:
    LDA #$00
    STA World3UpInputHoldCounter
    JMP Bank2_Label_A42B

Bank2_Label_A3F2:
    LDA World3UpInputHoldCounter
    BEQ Bank2_Label_A3FF
    INC World3UpInputHoldCounter
    CMP #$0A
    BEQ Bank2_Label_A3EB
    JMP Bank2_Label_A42B

Bank2_Label_A3FF:
    INC World3UpInputHoldCounter
    LDA World3PlayerFiringPoseActive
    BNE Bank2_Label_A40C
    LDY World3PlayerHorizontalDirection
    LDA a:World3_PlayerMetaspriteBaseByDirection,Y
    STA World3PlayerMetaspriteBase

Bank2_Label_A40C:
    LDA #$03
    STA World3PlayerAnimationMask
    LDY World3PlayerVerticalMotionPhase
    CPY #$0E
    BNE Bank2_Label_A41D
    LDA #$00
    STA World3PlayerScriptedArcDelay
    JMP Bank2_Label_A427

Bank2_Label_A41D:
    LDA World3PlayerScriptedArcDelay
    CMP #$14
    BCS Bank2_Label_A427
    INC World3PlayerScriptedArcDelay
    INC World3PlayerScriptedArcDelay

Bank2_Label_A427:
    LDA #$00
    STA World3PlayerVerticalMotionPhase

Bank2_Label_A42B:
    JSR World3_ApplyVerticalMovement
    JSR World3_ProbePlayerBottomEdge
    BCS Bank2_Label_A449
    JSR World3_ReadActivePlayerButtons
    AND #$03
    BNE Bank2_Label_A449
    LDA World3PlayerFiringPoseActive
    BNE Bank2_Label_A446
    LDA #$08
    STA World3PlayerMetaspriteBase
    LDA #$00
    STA World3PlayerAnimationFrame

Bank2_Label_A446:
    JMP Bank2_Label_A457

Bank2_Label_A449:
    JSR World3_ReadActivePlayerButtons
    AND #$02
    BNE Bank2_Label_A45E
    JSR World3_ReadActivePlayerButtons
    AND #$01
    BNE Bank2_Label_A471

Bank2_Label_A457:
    LDA #$00
    STA World3PlayerHorizontalMotionActive
    JMP Bank2_Label_A481

Bank2_Label_A45E:
    LDA World3PlayerFiringPoseActive
    BNE Bank2_Label_A466
    LDA #$00
    STA World3PlayerMetaspriteBase

Bank2_Label_A466:
    LDA #$00
    STA World3PlayerHorizontalDirection
    LDA #$01
    STA World3PlayerHorizontalMotionActive
    JMP Bank2_Label_A481

Bank2_Label_A471:
    LDA World3PlayerFiringPoseActive
    BNE Bank2_Label_A479
    LDA #$03
    STA World3PlayerMetaspriteBase

Bank2_Label_A479:
    LDA #$01
    STA World3PlayerHorizontalDirection
    LDA #$01
    STA World3PlayerHorizontalMotionActive

Bank2_Label_A481:
    JSR World3_ApplyHorizontalMovementRate
    RTS

World3_PlayerMetaspriteBaseByDirection:
    .byte $00, $03

World3_ApplyHorizontalMovementRate:
    INC World3PlayerHorizontalRatePhase
    LDA World3PlayerHorizontalRatePhase
    AND #$01
    BNE World3_MovePlayerHorizontally
    JSR World3_MovePlayerHorizontally

World3_MovePlayerHorizontally:
    LDA World3PlayerHorizontalMotionActive
    BEQ Bank2_Label_A49D
    LDA World3PlayerHorizontalDirection
    BEQ World3_MovePlayerLeft
    JMP World3_MovePlayerRight

Bank2_Label_A49D:
    RTS

World3_MovePlayerLeft:
    JSR World3_ProbePlayerLeftEdge
    BCS Bank2_Label_A4A8
    LDA #$00
    STA World3PlayerHorizontalMotionActive
    RTS

Bank2_Label_A4A8:
    DEC World3PlayerX
    BNE Bank2_Label_A4B3
    LDA #$EC
    STA World3PlayerX
    JSR World3_EnterRoomLeft

Bank2_Label_A4B3:
    RTS

World3_MovePlayerRight:
    JSR World3_ProbePlayerRightEdge
    BCS Bank2_Label_A4BE
    LDA #$00
    STA World3PlayerHorizontalMotionActive
    RTS

Bank2_Label_A4BE:
    INC World3PlayerX
    LDA World3PlayerX
    CMP #$F0
    BNE Bank2_Label_A4CD
    LDA #$04
    STA World3PlayerX
    JSR World3_EnterRoomRight

Bank2_Label_A4CD:
    RTS

World3_ApplyVerticalMovement:
    LDY World3PlayerVerticalMotionPhase
    CPY #$0E
    BEQ Bank2_Label_A4D6
    INC World3PlayerVerticalMotionPhase

Bank2_Label_A4D6:
    LDA a:World3_PlayerVerticalDeltaByPhase,Y
    STA World3PlayerVerticalDelta
    BEQ Bank2_Label_A4E2
    BPL Bank2_Label_A52F
    JMP Bank2_Label_A4E3

Bank2_Label_A4E2:
    RTS

Bank2_Label_A4E3:
    INC World3PlayerAscentRatePhase
    LDA World3PlayerAscentRatePhase
    AND #$01
    BNE World3_MovePlayerUp
    JSR World3_MovePlayerUp

World3_MovePlayerUp:
    JSR World3_ProbePlayerTopEdge
    BCS Bank2_Label_A4F8
    LDA #$0E
    STA World3PlayerVerticalMotionPhase
    RTS

Bank2_Label_A4F8:
    JSR World3_ProbePlayerHorizontalMidline
    LDA World3TerrainTile
    CMP #$14
    BNE Bank2_Label_A50F
    LDA #$02
    STA World3PlayerState
    LDA #$00
    STA World3PlayerVerticalMotionPhase
    LDA #$0C
    JSR World3_QueuePriorityEffectPreserveXY
    RTS

Bank2_Label_A50F:
    LDA World3PlayerY
    CLC
    ADC World3PlayerVerticalDelta
    STA World3PlayerY
    CMP #$08
    BCS Bank2_Label_A526
    LDA World3RoomRow
    BNE Bank2_Label_A527
    LDA #$00
    STA World3PlayerY
    LDA #$0E
    STA World3PlayerVerticalMotionPhase

Bank2_Label_A526:
    RTS

Bank2_Label_A527:
    LDA #$D0
    STA World3PlayerY
    JSR World3_EnterRoomAbove
    RTS

Bank2_Label_A52F:
    JSR World3_ProbePlayerBottomEdge
    BCS Bank2_Label_A539
    LDA #$00
    STA World3PlayerHorizontalMotionActive
    RTS

Bank2_Label_A539:
    JSR World3_ReadActivePlayerButtons
    AND #$04
    BNE Bank2_Label_A550
    INC World3PlayerPassiveDescentDelay
    LDA World3PlayerPassiveDescentDelay
    CMP #$06
    BCC Bank2_Label_A562
    LDA #$00
    STA World3PlayerPassiveDescentDelay
    LDA #$01
    STA World3PlayerVerticalDelta

Bank2_Label_A550:
    LDA World3PlayerY
    CLC
    ADC World3PlayerVerticalDelta
    STA World3PlayerY
    CMP #$D4
    BCC Bank2_Label_A562
    LDA #$0C
    STA World3PlayerY
    JSR World3_EnterRoomBelow

Bank2_Label_A562:
    RTS

World3_PlayerVerticalDeltaByPhase:
    .byte $FE, $FE, $FE, $FE, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $00, $00, $02

World3_TryFirePlayerProjectile:
    JSR World3_ReadActivePlayerButtons
    AND #$80
    BNE Bank2_Label_A57C
    STA World3FireInputLatch

Bank2_Label_A57B:
    RTS

Bank2_Label_A57C:
    LDA World3FireInputLatch
    BNE Bank2_Label_A57B
    INC World3FireInputLatch
    LDA #$01
    STA World3PlayerFiringPoseActive
    LDA World3PlayerHorizontalDirection
    CLC
    ADC #$09
    STA World3PlayerMetaspriteBase
    LDA #$00
    STA World3PlayerAnimationFrame
    LDA #$00
    STA World3PlayerAnimationCounter
    LDX #$00

Bank2_Label_A597:
    LDA a:World3PlayerProjectileState,X
    BEQ Bank2_Label_A5A2
    INX
    CPX #$02
    BNE Bank2_Label_A597
    RTS

Bank2_Label_A5A2:
    LDA World3PlayerHorizontalDirection
    BNE Bank2_Label_A5B1
    LDA World3PlayerX
    CMP #$12
    BCC Bank2_Label_A5DE
    LDY #$F8
    JMP Bank2_Label_A5B9

Bank2_Label_A5B1:
    LDA World3PlayerX
    CMP #$EE
    BCS Bank2_Label_A5DE
    LDY #$08

Bank2_Label_A5B9:
    TYA
    CLC
    ADC World3PlayerX
    STA a:World3PlayerProjectileX,X
    LDA World3PlayerY
    CLC
    ADC #$08
    STA a:World3PlayerProjectileY,X
    LDA World3PlayerHorizontalDirection
    STA a:World3PlayerProjectileDirection,X
    ASL A
    CLC
    ADC #$68
    STA a:World3PlayerProjectileMetasprite,X
    LDA #$01
    STA a:World3PlayerProjectileState,X
    LDA #$19
    JSR World3_QueuePriorityEffectPreserveXY

Bank2_Label_A5DE:
    RTS
