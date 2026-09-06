; Doraemon PRG bank 2 $A5DF-$A8AF
; World 3 audio wrappers, nametable streaming, and PPU update preparation
; Generated deterministically from pinned Ghidra/GhidraNes facts

World3_QueuePriorityEffectPreserveXY:
    STX World3AudioSavedX
    STY World3AudioSavedY
    JSR World3_Audio_QueueEffectWithPriority
    LDX World3AudioSavedX
    LDY World3AudioSavedY
    RTS

World3_QueueEffectPreserveXY:
    STX World3AudioSavedX
    STY World3AudioSavedY
    JSR World3_Audio_QueueEffect
    LDX World3AudioSavedX
    LDY World3AudioSavedY
    RTS

World3_ReadActivePlayerButtons:
    LDA World3AttractModeActive
    BNE Bank2_Label_A5FE
    LDA CombinedControllerButtons
    RTS

Bank2_Label_A5FE:
    LDA #$00
    RTS

World3_RenderPlayer:
    LDX World3PlayerX
    LDY World3PlayerY
    JSR World3_SetMetaspriteOriginFromXY
    LDA World3PlayerMetaspriteBase
    CLC
    ADC World3PlayerAnimationFrame
    STA World3PlayerMetasprite
    STA World3MetaspriteIndex
    LDA #$00
    STA World3MetaspriteRenderFlags
    JSR World3_ComposeMetasprite
    RTS

World3_EnterRoomLeft:
    LDA World3RoomColumn
    BEQ Bank2_Label_A639
    DEC World3RoomColumn
    LDA World3CurrentRoom
    STA World3TransitionTargetRoom
    DEC World3TransitionTargetRoom
    JSR World3_DropFollowerBeforeCrowdedRoom
    JSR World3_ResetPersistentObjectsForFinalRoomEntry
    JSR World3_ResetPersistentObjectsForActiveBossRoom
    JSR World3_SaveRoomObjectsState0
    DEC World3CurrentRoom
    JSR World3_SaveRoomObjectsState1
    JSR World3_LoadCurrentRoom

Bank2_Label_A639:
    RTS

World3_EnterRoomRight:
    LDA World3RoomColumn
    CMP #$07
    BEQ Bank2_Label_A65C
    INC World3RoomColumn
    LDA World3CurrentRoom
    STA World3TransitionTargetRoom
    INC World3TransitionTargetRoom
    JSR World3_DropFollowerBeforeCrowdedRoom
    JSR World3_ResetPersistentObjectsForFinalRoomEntry
    JSR World3_ResetPersistentObjectsForActiveBossRoom
    JSR World3_SaveRoomObjectsState0
    INC World3CurrentRoom
    JSR World3_SaveRoomObjectsState1
    JSR World3_LoadCurrentRoom

Bank2_Label_A65C:
    RTS

World3_EnterRoomAbove:
    LDA World3RoomRow
    BEQ Bank2_Label_A687
    DEC World3RoomRow
    LDA World3CurrentRoom
    STA World3TransitionTargetRoom
    LDA World3TransitionTargetRoom
    SEC
    SBC #$08
    STA World3TransitionTargetRoom
    JSR World3_DropFollowerBeforeCrowdedRoom
    JSR World3_ResetPersistentObjectsForFinalRoomEntry
    JSR World3_ResetPersistentObjectsForActiveBossRoom
    JSR World3_SaveRoomObjectsState0
    LDA World3CurrentRoom
    SEC
    SBC #$08
    STA World3CurrentRoom
    JSR World3_SaveRoomObjectsState1
    JSR World3_LoadCurrentRoom

Bank2_Label_A687:
    RTS

World3_EnterRoomBelow:
    LDA World3RoomRow
    CMP #$07
    BEQ Bank2_Label_A6B4
    INC World3RoomRow
    LDA World3CurrentRoom
    STA World3TransitionTargetRoom
    LDA World3TransitionTargetRoom
    CLC
    ADC #$08
    STA World3TransitionTargetRoom
    JSR World3_DropFollowerBeforeCrowdedRoom
    JSR World3_ResetPersistentObjectsForFinalRoomEntry
    JSR World3_ResetPersistentObjectsForActiveBossRoom
    JSR World3_SaveRoomObjectsState0
    LDA World3CurrentRoom
    CLC
    ADC #$08
    STA World3CurrentRoom
    JSR World3_SaveRoomObjectsState1
    JSR World3_LoadCurrentRoom

Bank2_Label_A6B4:
    RTS

World3_ResetPersistentObjectsForFinalRoomEntry:
    LDA World3TransitionTargetRoom
    CMP #$3F
    BNE Bank2_Label_A6BE
    JSR World3_ClearPersistentObjectStates

Bank2_Label_A6BE:
    RTS

World3_ResetPersistentObjectsForActiveBossRoom:
    LDA World3TransitionTargetRoom
    CMP #$27
    BEQ Bank2_Label_A6CE
    CMP #$28
    BEQ Bank2_Label_A6D6
    CMP #$34
    BEQ Bank2_Label_A6DE

Bank2_Label_A6CD:
    RTS

Bank2_Label_A6CE:
    LDA World3BossRoom27Defeated
    BNE Bank2_Label_A6CD
    JSR World3_ClearPersistentObjectStates
    RTS

Bank2_Label_A6D6:
    LDA World3BossRoom28Defeated
    BNE Bank2_Label_A6CD
    JSR World3_ClearPersistentObjectStates
    RTS

Bank2_Label_A6DE:
    LDA World3BossRoom34Defeated
    BNE Bank2_Label_A6CD
    JSR World3_ClearPersistentObjectStates
    RTS

World3_DropFollowerBeforeCrowdedRoom:
    LDY #$00
    STY $3E

Bank2_Label_A6EA:
    LDA a:World3RoomObjectRoom,Y
    CMP World3TransitionTargetRoom
    BNE Bank2_Label_A6FA
    LDA a:World3RoomObjectType,Y
    CMP #$18
    BCC Bank2_Label_A6FA
    INC $3E

Bank2_Label_A6FA:
    INY
    CPY #$0D
    BNE Bank2_Label_A6EA
    LDA $3E
    CMP #$03
    BCC Bank2_Label_A719
    LDA World3FollowerActive
    BEQ Bank2_Label_A719
    LDA #$00
    STA World3FollowerActive
    LDY #$00

Bank2_Label_A70F:
    LDA #$00
    STA a:World3EntityPersistentState,Y
    INY
    CPY #$08
    BNE Bank2_Label_A70F

Bank2_Label_A719:
    RTS

World3_SetMetaspriteOriginFromXY:
    LDA #$00
    CPX #$F8
    BCC Bank2_Label_A722
    LDA #$03

Bank2_Label_A722:
    STX World3MetaspriteOriginX
    STA World3MetaspriteOriginXHigh
    LDA #$00
    CPY #$F8
    BCC Bank2_Label_A72E
    LDA #$03

Bank2_Label_A72E:
    STY World3MetaspriteOriginY
    STA World3MetaspriteOriginYHigh
    RTS

World3_LoadCurrentRoom:
    JSR World3_FadePaletteToBlack
    JSR World3_DisableRendering
    LDA #$02
    JSR Bank2_SelectChrBank
    LDA #$90
    STA PpuCtrlShadow
    JSR World3_StreamCurrentRoomBackground
    JSR World3_LoadRoomPalette
    JSR World3_ClearPlayerProjectiles
    JSR World3_ClearEntityStorage
    JSR World3_ClampPersistentObjectsAtRoomEdges
    JSR World3_MaterializeRoomObjects
    JSR World3_AdvanceRandomEncounterRoomTowardPlayer
    JSR World3_TrySpawnDragonEncounter
    LDA World3FinalCompanionsFreed
    BEQ Bank2_Label_A761
    JSR World3_OpenFinalCompanionBarrier

Bank2_Label_A761:
    LDA World3FormationActive
    BNE Bank2_Label_A78B
    LDA World3CurrentRoom
    CMP #$27
    BEQ Bank2_Label_A776
    CMP #$28
    BEQ Bank2_Label_A77D
    CMP #$34
    BEQ Bank2_Label_A784
    JMP Bank2_Label_A79C

Bank2_Label_A776:
    LDA World3BossRoom27Defeated
    BNE Bank2_Label_A78B
    JMP Bank2_Label_A79C

Bank2_Label_A77D:
    LDA World3BossRoom28Defeated
    BNE Bank2_Label_A78B
    JMP Bank2_Label_A79C

Bank2_Label_A784:
    LDA World3BossRoom34Defeated
    BNE Bank2_Label_A78B
    JMP Bank2_Label_A79C

Bank2_Label_A78B:
    LDA World3CurrentRoom
    CMP #$27
    BEQ Bank2_Label_A799
    CMP #$28
    BEQ Bank2_Label_A799
    CMP #$34
    BNE Bank2_Label_A79C

Bank2_Label_A799:
    JSR World3_ClearFormationArenaTiles

Bank2_Label_A79C:
    LDA World3PassingHoopPortalActive
    BEQ Bank2_Label_A7AB
    JSR World3_UpdatePassingHoopBoundary
    LDA World3PassingHoopBoundaryPresent
    BNE Bank2_Label_A7AB
    LDA #$00
    STA World3PassingHoopPortalActive

Bank2_Label_A7AB:
    JSR World3_RenderHud
    JSR World3_EnableRendering
    JSR World3_FadePaletteIn
    LDA #$00
    STA World3OamBufferHalf
    STA World3OamWriteIndex
    LDA #$00
    STA World3StopwatchActive
    STA World3StopwatchTimer
    LDA #$00
    STA World3Room16MicrophoneEventActive
    STA World3MicrophoneHoldCounter
    JSR World3_SelectRoomMusicTrack
    LDA a:AudioMusicState
    AND #$7F
    CMP World3RoomMusicTrack
    BEQ Bank2_Label_A7DF
    CMP #$03
    BNE Bank2_Label_A7DA
    LDA World3FormationActive
    BNE Bank2_Label_A7DF

Bank2_Label_A7DA:
    LDA World3RoomMusicTrack
    STA a:AudioMusicState

Bank2_Label_A7DF:
    LDA #$00
    STA a:AudioMusicControl
    RTS

World3_SelectRoomMusicTrack:
    LDY World3CurrentRoom
    LDA a:World3_RoomMusicClassByRoom,Y
    TAY
    LDA a:World3_MusicTrackByRoomClass,Y
    STA World3RoomMusicTrack
    RTS

World3_RoomMusicClassByRoom:
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $01, $01, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $02, $02, $02
    .byte $01, $01, $01, $01, $01, $02, $02, $02, $01, $01, $01, $01, $01, $02, $02, $03

World3_MusicTrackByRoomClass:
    .byte $01, $02, $05, $06

World3_LoadRoomPalette:
    LDA #$00
    STA $40
    LDX World3CurrentRoom
    LDA a:World3_RoomPaletteSelector,X
    LSR A
    ROR $40
    LSR A
    ROR $40
    LSR A
    ROR $40
    STA $41
    LDA $40
    CLC
    ADC #$AE
    STA $40
    LDA $41
    ADC #$BC
    STA $41
    LDY #$00

Bank2_Label_A858:
    LDA ($40),Y
    STA a:World3PaletteTarget,Y
    INY
    CPY #$20
    BNE Bank2_Label_A858
    RTS

World3_FadePaletteToBlack:
    LDX #$80
    LDY #$04
    STX $00
    STY $01
    LDX #$05
    LDY #$07
    STX $02
    STY $03
    LDA #$20
    STA $04
    JSR World3_CopyBytes

Bank2_Label_A87A:
    LDX #$00
    STX $02

Bank2_Label_A87E:
    LDA a:World3PaletteShadow,X
    CMP #$0F
    BEQ Bank2_Label_A898
    INC $02
    TAY
    AND #$30
    BNE Bank2_Label_A891
    LDA #$0F
    JMP Bank2_Label_A895

Bank2_Label_A891:
    TYA
    SEC
    SBC #$10

Bank2_Label_A895:
    STA a:World3PaletteShadow,X

Bank2_Label_A898:
    INX
    CPX #$20
    BNE Bank2_Label_A87E
    LDX #$80
    LDY #$04
    JSR World3_QueuePalette
    LDA #$03
    STA World3FrameWaitCounter
    JSR World3_WaitFrames
    LDA $02
    BNE Bank2_Label_A87A
    RTS
