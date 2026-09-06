; Doraemon PRG bank 2 $82AD-$875B
; World 3 initialization, frame loop, player state, and map position
; Generated deterministically from pinned Ghidra/GhidraNes facts

World3_DemoEntry:
    LDX #$7F
    TXS
    JSR World3_InitializeHardwareAndRam
    JSR World3_InitializeVideo
    JSR World3_InitializeRoomObjectRegistry
    LDA #$00
    STA World1FlashLightCarryFlag
    STA World3PassingHoopCarryFlag
    LDA #$03
    STA PlayerLives

Bank2_Label_82C3:
    LDA #$01
    STA World3AttractModeActive
    LDX #$00
    LDY #$02
    STX World3AttractFrameCounterLow
    STY World3AttractFrameCounterHigh
    LDA PlayerLives
    AND #$03
    TAX
    LDA a:$82EA,X
    STA World3CurrentRoom
    LDA a:$82EE,X
    STA World3PlayerX
    LDA a:$82F2,X
    STA World3PlayerY
    LDA #$02
    STA PlayerHealthCapacityIndex
    JMP Bank2_Label_8328
    .byte $28, $1F, $0B, $09, $40, $08, $80, $C0, $40, $70, $A0, $A0

Bank2_World3Main:
    LDA $3B
    BPL Bank2_Label_8314
    LDX #$7F
    TXS
    JSR World3_InitializeHardwareAndRam
    JSR World3_InitializeVideo
    JSR World3_InitializeRoomObjectRegistry
    LDA #$00
    STA World3AttractModeActive
    LDA #$00
    STA World3CurrentRoom
    JSR World3_ResetScoreLivesAndHealthCapacity
    JMP Bank2_Label_8328

Bank2_Label_8314:
    LDX #$7F
    TXS
    JSR World3_InitializeHardwareAndRam
    JSR World3_InitializeVideo
    JSR World3_InitializeRoomObjectRegistry
    LDA #$00
    STA World3AttractModeActive
    LDA #$00
    STA World3CurrentRoom

Bank2_Label_8328:
    LDA #$80
    STA $4B
    LDA #$80
    STA $4C
    LDA #$00
    STA World3ChapterCompletionDelay
    LDA #$00
    STA World3Room16MicrophoneEventComplete
    LDA #$00
    STA World3DebugControlsEnabled
    LDA Controller1Buttons
    CMP #$FA
    BNE Bank2_Label_834C
    LDA Controller2Buttons
    CMP #$C5
    BNE Bank2_Label_834C
    LDA #$01
    STA World3DebugControlsEnabled

Bank2_Label_834C:
    LDX #$7F
    TXS
    LDA World3AttractModeActive
    BNE Bank2_Label_836B
    JSR Bank2_DisableRenderingForUpdate
    LDA #$02
    STA $28
    JSR Bank2_CallShellStatusScreen
    LDA #$00
    STA PpuCtrlShadow
    JSR Bank2_EnableNmiAndRendering
    LDA #$5A
    STA World3FrameWaitCounter
    JSR World3_WaitFrames

Bank2_Label_836B:
    JSR Bank2_DisableRenderingForUpdate
    JSR World3_InitializePlayerState
    JSR World3_RefillHealthFromCapacity
    LDA World3AttractModeActive
    BNE Bank2_Label_837B
    JSR World3_InitializePlayerRoomAndPosition

Bank2_Label_837B:
    LDA World3CurrentRoom
    AND #$07
    STA World3RoomColumn
    LDA World3CurrentRoom
    LSR A
    LSR A
    LSR A
    STA World3RoomRow
    JSR World3_PlaceCarriedPassingHoop
    JSR World3_LoadCurrentRoom

Bank2_World3FrameLoop:
    LDX #$7F
    TXS
    LDA #$00
    STA World3FrameWaitCounter
    LDA World3CurrentRoom
    CMP #$3F
    BNE Bank2_Label_839E
    JSR World3_RenderScoreAndLives

Bank2_Label_839E:
    LDA World3ChapterCompletionDelay
    BNE Bank2_Label_83A5
    JSR Bank2_Func_AF30

Bank2_Label_83A5:
    JSR World3_UpdateTransientSpawns
    JSR World3_CheckFinalCompanionRescue
    LDA World3ChapterCompletionDelay
    BNE Bank2_Label_83B5
    JSR World3_UpdatePlayerState
    JSR World3_UpdatePlayerProjectiles

Bank2_Label_83B5:
    JSR World3_UpdateEntities
    JSR World3_RenderPlayer
    LDA World3ChapterCompletionDelay
    BNE Bank2_Label_83C2
    JSR World3_RenderPlayerProjectiles

Bank2_Label_83C2:
    JSR World3_RenderEntities
    JSR World3_CommitScoreAndCheckExtraLife
    LDA World3CurrentRoom
    CMP #$3F
    BEQ Bank2_Label_83D1
    JSR World3_RenderScoreAndLives

Bank2_Label_83D1:
    JSR World3_RenderHealth
    JSR World3_UpdateStopwatchEffect
    JSR World3_CheckPunishmentRoomEntry
    JSR World3_CheckPunishmentRoomExit
    JSR World3_UpdateRoom16MicrophoneEvent
    JSR World3_UpdatePause
    JSR World3_RestoreRoomMusicAfterBossDelay
    LDA ExtraLifeSoundCounter
    BEQ Bank2_Label_83F3
    LDA #$00
    STA ExtraLifeSoundCounter
    LDA #$10
    JSR World3_QueueEffectPreserveXY

Bank2_Label_83F3:
    JSR World3_UpdateDebugAndMicrophoneHooks
    LDA #$01
    STA NmiOamDmaRequest
    LDA #$01
    STA World3FrameWaitCounter
    JSR World3_WaitFrames
    LDA World3AttractModeActive
    BEQ Bank2_Label_8419
    DEC World3AttractFrameCounterLow
    BNE Bank2_Label_840D
    DEC World3AttractFrameCounterHigh
    BEQ Bank2_Label_8416

Bank2_Label_840D:
    LDA CombinedControllerButtons
    AND #$30
    BEQ Bank2_Label_8419
    JMP Bank2_EnterShell

Bank2_Label_8416:
    JMP Bank2_Label_A26D

Bank2_Label_8419:
    LDA World3ChapterCompletionDelay
    BEQ Bank2_Label_8424
    DEC World3ChapterCompletionDelay
    BNE Bank2_Label_8424
    JMP Bank2_Func_AE12

Bank2_Label_8424:
    JMP Bank2_World3FrameLoop

World3_UpdateDebugAndMicrophoneHooks:
    LDA World3DebugControlsEnabled
    BNE Bank2_Label_844E
    LDA World3CurrentRoom
    BNE Bank2_Label_8486
    LDA World3PlayerX
    CMP #$25
    BNE Bank2_Label_8486
    LDA World3PlayerY
    CMP #$BB
    BNE Bank2_Label_8486
    LDA Controller2MicrophoneEdgeTimer
    BNE Bank2_Label_8443
    LDA #$00
    STA World3MicrophoneHoldCounter

Bank2_Label_8443:
    INC World3MicrophoneHoldCounter
    LDA World3MicrophoneHoldCounter
    CMP #$3C
    BNE Bank2_Label_8486
    JMP Bank2_Label_FC00

Bank2_Label_844E:
    LDA Controller2Buttons
    AND #$02
    BEQ Bank2_Label_8457
    JSR World3_EnterRoomLeft

Bank2_Label_8457:
    LDA Controller2Buttons
    AND #$01
    BEQ Bank2_Label_8460
    JSR World3_EnterRoomRight

Bank2_Label_8460:
    LDA Controller2Buttons
    AND #$08
    BEQ Bank2_Label_8469
    JSR World3_EnterRoomAbove

Bank2_Label_8469:
    LDA Controller2Buttons
    AND #$04
    BEQ Bank2_Label_8472
    JSR World3_EnterRoomBelow

Bank2_Label_8472:
    LDA Controller2Buttons
    CMP #$C0
    BNE Bank2_Label_8486
    JSR Bank2_Func_AF6F

Bank2_Label_847B:
    LDA Controller2Buttons
    BNE Bank2_Label_847B

Bank2_Label_847F:
    LDA Controller2Buttons
    BEQ Bank2_Label_847F
    JMP Bank2_EnterShell

Bank2_Label_8486:
    RTS

World3_UpdateRoom16MicrophoneEvent:
    LDA World3Room16MicrophoneEventActive
    BEQ Bank2_Label_849E
    LDX #$78
    LDY #$80
    JSR World3_SetMetaspriteOriginFromXY
    LDA #$00
    STA World3MetaspriteRenderFlags
    LDA #$B8
    STA World3MetaspriteIndex
    JSR World3_ComposeMetasprite
    RTS

Bank2_Label_849E:
    LDA World3Room16MicrophoneEventComplete
    BNE Bank2_Label_8502
    LDA World3CurrentRoom
    CMP #$16
    BNE Bank2_Label_8502
    LDA Controller2MicrophoneEdgeTimer
    BNE Bank2_Label_84B0
    LDA #$00
    STA World3MicrophoneHoldCounter

Bank2_Label_84B0:
    INC World3MicrophoneHoldCounter
    LDA World3MicrophoneHoldCounter
    CMP #$3C
    BNE Bank2_Label_8502
    LDA #$0A
    JSR World3_QueueEffectPreserveXY
    JSR World3_RunPaletteFlash
    LDA #$01
    STA World3Room16MicrophoneEventActive
    STA World3Room16MicrophoneEventComplete
    LDA #$00
    STA World3FollowerActive
    LDX #$00
    LDY #$00

Bank2_Label_84CE:
    LDA a:World3RoomObjectType,X
    CMP #$18
    BCC Bank2_Label_84F0
    CMP #$1C
    BCS Bank2_Label_84F0
    LDA #$16
    STA a:World3RoomObjectRoom,X
    LDA #$00
    STA a:World3RoomObjectState,X
    LDA a:$8503,Y
    STA a:World3RoomObjectX,X
    LDA a:$8507,Y
    STA a:World3RoomObjectY,X
    INY

Bank2_Label_84F0:
    INX
    CPX #$0D
    BNE Bank2_Label_84CE
    LDX #$00

Bank2_Label_84F7:
    JSR World3_ClearEntitySlot
    INX
    CPX #$08
    BNE Bank2_Label_84F7
    JSR World3_MaterializeRoomObjects

Bank2_Label_8502:
    RTS
    .byte $58, $58, $98, $98, $60, $A0, $60, $A0

World3_InitializePlayerRoomAndPosition:
    LDA World3CurrentRoom
    BEQ Bank2_Label_8526
    JSR World3_LoadRoomFromPassingHoop
    CMP #$27
    BEQ Bank2_Label_852F
    CMP #$28
    BEQ Bank2_Label_852F
    CMP #$34
    BEQ Bank2_Label_852F
    CMP #$3C
    BEQ Bank2_Label_8538
    JSR World3_ChoosePassablePlayerPosition
    RTS

Bank2_Label_8526:
    LDA #$80
    STA World3PlayerX
    LDA #$80
    STA World3PlayerY
    RTS

Bank2_Label_852F:
    LDA #$30
    STA World3PlayerX
    LDA #$40
    STA World3PlayerY
    RTS

Bank2_Label_8538:
    LDA #$30
    STA World3PlayerX
    LDA #$B0
    STA World3PlayerY
    RTS

World3_LoadRoomFromPassingHoop:
    LDY #$00

Bank2_Label_8543:
    LDA a:World3RoomObjectType,Y
    CMP #$19
    BEQ Bank2_Label_8554
    INY
    CPY #$0D
    BNE Bank2_Label_8543
    LDA #$07
    JMP Bank2_Func_AF51

Bank2_Label_8554:
    LDA a:World3RoomObjectRoom,Y
    STA World3CurrentRoom
    RTS

World3_ChoosePassablePlayerPosition:
    JSR World3_ChooseSpawnX
    STA $46
    JSR World3_ChooseSpawnY
    STA $47
    JSR World3_ProbeEntityLeftEdge
    BCC World3_ChoosePassablePlayerPosition
    JSR World3_ProbeEntityRightEdge
    BCC World3_ChoosePassablePlayerPosition
    JSR World3_ProbeEntityTopEdge
    BCC World3_ChoosePassablePlayerPosition
    JSR World3_ProbeEntityBottomEdge
    BCC World3_ChoosePassablePlayerPosition
    LDA $46
    STA World3PlayerX
    LDA $47
    STA World3PlayerY
    RTS

World3_RestoreRoomMusicAfterBossDelay:
    LDA World3BossMusicRestoreDelay
    BEQ Bank2_Label_8599
    DEC World3BossMusicRestoreDelay
    BNE Bank2_Label_8599
    LDA World3CurrentRoom
    CMP #$3F
    BEQ Bank2_Label_8599
    LDA World3RoomMusicTrack
    STA a:AudioMusicState
    LDA #$00
    STA a:AudioMusicControl

Bank2_Label_8599:
    RTS

World3_UpdatePause:
    JSR World3_ReadActivePlayerButtons
    AND #$10
    BNE Bank2_Label_85A4
    STA World3PauseInputLatch

Bank2_Label_85A3:
    RTS

Bank2_Label_85A4:
    LDA World3PauseInputLatch
    BNE Bank2_Label_85A3
    INC World3PauseInputLatch
    LDA #$01
    STA a:AudioMusicControl
    LDA #$06
    JSR World3_QueueEffectPreserveXY

Bank2_Label_85B4:
    JSR World3_ReadActivePlayerButtons
    AND #$10
    BNE Bank2_Label_85B4

Bank2_Label_85BB:
    JSR World3_ReadActivePlayerButtons
    AND #$10
    BEQ Bank2_Label_85BB
    LDA #$00
    STA a:AudioMusicControl
    RTS

World3_CheckPunishmentRoomExit:
    LDA World3PunishmentRoomActive
    BEQ Bank2_Label_85FC
    LDA World3CurrentRoom
    CMP #$12
    BNE Bank2_Label_85FC
    LDA World3PunishmentDorayakiRemaining
    BEQ Bank2_Label_85EC
    LDA World3TransientSpawnType
    CMP #$06
    BNE Bank2_Label_85FC
    LDA World3TransientSpawnRemaining
    BNE Bank2_Label_85FC
    LDY #$00

Bank2_Label_85E2:
    LDA a:World3EntityState,Y
    BNE Bank2_Label_85FC
    INY
    CPY #$08
    BNE Bank2_Label_85E2

Bank2_Label_85EC:
    LDA #$0A
    JSR World3_QueueEffectPreserveXY
    LDA #$01
    STA a:AudioMusicControl
    JSR World3_RunPaletteFlash
    JSR World3_ExitPunishmentRoom

Bank2_Label_85FC:
    RTS

World3_CheckPunishmentRoomEntry:
    LDA World3PunishmentRoomActive
    BNE Bank2_Label_864C
    LDA World3TreasurePenaltyCounter
    CMP #$14
    BCC Bank2_Label_864C
    LDA #$00
    STA World3TreasurePenaltyCounter
    LDA #$01
    STA World3PunishmentRoomActive
    LDA #$0A
    JSR World3_QueueEffectPreserveXY
    JSR World3_RunPaletteFlash
    JSR World3_ClearPersistentObjectStates
    JSR World3_SaveRoomObjectsState0
    JSR World3_SaveRoomObjectsState1
    LDA World3CurrentRoom
    STA World3PunishmentReturnRoom
    LDA #$12
    STA World3CurrentRoom
    JSR World3_RefillHealthFromCapacity
    JSR World3_LoadCurrentRoom
    LDY #$00

Bank2_Label_8630:
    LDA a:World3PlayerX,Y
    STA a:World3PunishmentSavedPlayerState,Y
    INY
    CPY #$12
    BNE Bank2_Label_8630
    LDA #$80
    STA World3PlayerX
    LDA #$A8
    STA World3PlayerY
    LDA #$14
    STA World3PunishmentDorayakiRemaining
    LDA #$03
    STA a:AudioMusicState

Bank2_Label_864C:
    RTS

World3_DormantUpdateState55ForRoomBands:
    LDA World3CurrentRoom
    CMP #$2D
    BCC Bank2_Label_8667
    CMP #$30
    BCC Bank2_Label_866B
    CMP #$35
    BCC Bank2_Label_8667
    CMP #$38
    BCC Bank2_Label_866B
    CMP #$3D
    BCC Bank2_Label_8667
    CMP #$40
    BCC Bank2_Label_866B

Bank2_Label_8667:
    LDA #$14
    STA $55

Bank2_Label_866B:
    RTS

World3_ClearPersistentObjectStates:
    LDY #$00

Bank2_Label_866E:
    LDA #$00
    STA a:World3EntityPersistentState,Y
    INY
    CPY #$08
    BNE Bank2_Label_866E
    LDY #$00

Bank2_Label_867A:
    LDA #$00
    STA a:World3RoomObjectState,Y
    INY
    CPY #$0D
    BNE Bank2_Label_867A
    LDA #$00
    STA World3FollowerActive
    RTS

World3_InitializeVideo:
    JSR Bank2_DisableRenderingForUpdate
    LDA #$90
    STA PpuCtrlShadow
    LDA #$02
    JSR Bank2_SelectChrBank
    JSR World3_DisableRendering
    LDX #$AE
    LDY #$BC
    STX $00
    STY $01
    JSR World3_QueuePaletteFromParameters
    LDA #$00
    STA $00
    JSR World3_FillNametables
    LDA #$00
    STA $00
    JSR World3_FillAttributeTables
    JSR World3_HideAllSprites
    JSR Bank2_EnableNmiAndRendering
    JSR World3_EnableRendering
    RTS

World3_ToggleOamBufferHalf:
    LDA World3OamBufferHalf
    EOR #$40
    STA World3OamBufferHalf
    STA World3OamWriteIndex
    RTS

World3_RunPaletteFlash:
    STX $44
    STY $45
    LDA #$0C
    STA $46
    LDA a:World3PaletteShadow
    STA $47
    LDA a:World3PaletteShadow+$07
    STA $48

Bank2_Label_86D6:
    LDA $47
    AND #$0F
    TAX
    LDA a:$8723,X
    TAX
    JSR World3_SetFlashPaletteColors
    LDA #$04
    STA World3FrameWaitCounter
    JSR World3_WaitFrames
    LDA $47
    LDX $48
    JSR World3_SetFlashPaletteColors
    LDA #$04
    STA World3FrameWaitCounter
    JSR World3_WaitFrames
    DEC $46
    BNE Bank2_Label_86D6
    LDX $44
    LDY $45
    RTS

World3_SetFlashPaletteColors:
    STA a:World3PaletteShadow
    STA a:World3PaletteShadow+$04
    STA a:World3PaletteShadow+$08
    STA a:World3PaletteShadow+$0C
    STA a:World3PaletteShadow+$10
    STA a:World3PaletteShadow+$14
    STA a:World3PaletteShadow+$18
    STA a:World3PaletteShadow+$1C
    STX a:World3PaletteShadow+$07
    LDX #$80
    LDY #$04
    JSR World3_QueuePalette
    RTS
    .byte $30, $25, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $26, $30, $30, $27

World3_DefeatActiveCombatEntities:
    LDY #$00

Bank2_Label_8735:
    LDA a:World3EntityState,Y
    CMP #$01
    BEQ Bank2_Label_8743
    CMP #$04
    BEQ Bank2_Label_8743
    JMP Bank2_Label_8756

Bank2_Label_8743:
    LDA #$01
    STA a:World3EntityState,Y
    LDA a:World3EntityType,Y
    CMP #$10
    BCS Bank2_Label_8756
    CMP #$07
    BEQ Bank2_Label_8756
    JSR World3_StartEntityDefeatByY

Bank2_Label_8756:
    INY
    CPY #$08
    BNE Bank2_Label_8735
    RTS
