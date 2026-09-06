; Doraemon PRG bank 0 $CDB5-$D112
; World 1 side-view underground initialization, frame loop, and movement
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank0_InitWorld1SideView:
    LDX #$00

Bank0_Label_CDB7:
    LDA a:World1CollectedObjectBits,X
    STA a:World1SavedCityObjectBits,X
    LDA a:World1SavedUndergroundObjectBits,X
    STA a:World1CollectedObjectBits,X
    INX
    CPX #$10
    BNE Bank0_Label_CDB7
    JSR Bank0_Func_83A3
    LDA $81
    SEC
    SBC #$08
    STA World1UndergroundRoomId
    CLC
    ADC #$03
    STA $29
    JSR Bank0_Func_843B
    JMP Bank0_Label_CDE3

Bank0_Label_CDDD:
    JSR Bank0_Func_83E8
    JSR Bank0_Func_843B

Bank0_Label_CDE3:
    LDA World1UndergroundRoomId
    ASL A
    ASL A
    TAY
    LDA #$01
    STA $51
    LDA #$00
    STA World1PlayerDamageState
    LDA a:World1_UndergroundRoomEntryProfiles,Y
    STA World1PlayerX
    LDA a:World1_UndergroundRoomPlayerYField,Y
    STA World1PlayerY
    LDA a:World1_UndergroundRoomNegativeAxisCityReturnIdField,Y
    STA World1UndergroundNegativeAxisCityReturnId
    LDA a:World1_UndergroundRoomPositiveAxisCityReturnIdField,Y
    STA World1UndergroundPositiveAxisCityReturnId
    LDA a:World1_UndergroundRoomCameraProfiles,Y
    STA World1CameraTileX
    LDA a:World1_UndergroundRoomCameraTileYField,Y
    STA World1CameraTileY
    LDA a:World1_UndergroundRoomAxisScrollLimitField,Y
    STA World1UndergroundAxisScrollLimit
    LDA a:World1_UndergroundRoomAxisScrollStartField,Y
    STA World1UndergroundAxisScrollCoarse
    LDA #$00
    STA World1UndergroundAxisScrollFine
    LDA #$01
    STA World1PlayerAirborne
    LDA #$00
    STA World1PlayerYVelocity
    LDA #$00
    STA World1PlayerXSubpixel
    LDA #$00
    STA World1UndergroundVerticalPage
    LDA #$00
    STA $9B
    JSR Bank0_Func_9614
    LDA #$EF
    STA World1MapDataPointer
    LDA #$C2
    STA World1MapDataPointer+$01
    LDA #$25
    STA World1ObjectPlacementList
    LDA #$D9
    STA World1ObjectPlacementList+$01
    JSR World1_RefreshObjectSpawnMask
    JSR Bank0_Func_83BD
    JSR World1_PrefillMapViewport
    JSR Bank0_Func_9535
    JSR Bank0_Func_95ED
    LDX #$7F
    TXS

Bank0_World1UndergroundFrameLoop:
    JSR World1_WaitForNextFrame
    JSR Bank0_Func_8490
    JSR Bank0_Func_95CB
    JSR Bank0_Func_9B54
    JSR World1_UpdateUndergroundPlayer
    JSR Bank0_Func_CA6D
    JSR Bank0_Func_9201
    JSR World1_TrackUndergroundHorizontalCamera
    JSR World1_SpawnObjectsAtCameraEdges
    JSR World1_SpawnObjectsAtCameraEdges
    JSR World1_UpdateEntities
    JSR Bank0_Func_8EF6
    JSR Bank0_Func_931B
    JSR World1_CommitScoreAndCheckExtraLife
    LDA World1PlayerDamageState
    BMI Bank0_Label_CE90
    LDA World1PlayerY
    CMP #$F8
    BCS Bank0_Label_CEAB
    CMP #$E0
    BCS Bank0_Label_CEC2
    JMP Bank0_World1UndergroundFrameLoop

Bank0_Label_CE90:
    JSR Bank0_Func_884C
    DEC PlayerLives
    BMI Bank0_Label_CE9E
    LDA World1UndergroundRoomId
    STA $81
    JMP Bank0_Label_CDDD

Bank0_Label_CE9E:
    JSR Bank0_CallShellGameOver
    LDA #$02
    STA PlayerLives
    JSR Bank0_Func_C92F
    JMP Bank0_Label_CDDD

Bank0_Label_CEAB:
    LDA World1UndergroundVerticalPage
    BNE Bank0_Label_CEE5
    LDA World1UndergroundNegativeAxisCityReturnId
    STA $00
    LDA World1UndergroundAxisScrollCoarse
    BEQ Bank0_Label_CEBB
    LDA World1UndergroundPositiveAxisCityReturnId
    STA $00

Bank0_Label_CEBB:
    LDA $00
    BMI Bank0_World1UndergroundFrameLoop
    JMP World1_ReturnFromUndergroundToCity

Bank0_Label_CEC2:
    INC World1UndergroundVerticalPage
    LDA #$00
    STA World1UndergroundAxisScrollFine
    LDA World1CameraTileY
    CLC
    ADC #$20
    STA World1CameraTileY
    LDA World1PlayerY
    SEC
    SBC #$E0
    STA World1PlayerY
    JSR World1_RefreshObjectSpawnMask
    JSR Bank0_Func_9614
    JSR World1_PrefillMapViewport
    JSR Bank0_Func_95ED
    JMP Bank0_World1UndergroundFrameLoop

Bank0_Label_CEE5:
    DEC World1UndergroundVerticalPage
    LDA #$00
    STA World1UndergroundAxisScrollFine
    LDA World1CameraTileY
    SEC
    SBC #$20
    STA World1CameraTileY
    LDA World1PlayerY
    CLC
    ADC #$B0
    STA World1PlayerY
    JSR World1_RefreshObjectSpawnMask
    JSR Bank0_Func_9614
    JSR World1_PrefillMapViewport
    JSR Bank0_Func_95ED
    JMP Bank0_World1UndergroundFrameLoop

World1_TrackUndergroundHorizontalCamera:
    LDA #$00
    STA World1ScreenDeltaX
    STA World1ScreenDeltaY
    LDA World1PlayerX
    SEC
    SBC #$6E
    BCS Bank0_Label_CF42
    EOR #$FF
    SEC
    ADC #$00
    STA World1UndergroundAxisScrollBudget
    CMP #$03
    BCC Bank0_Label_CF24
    LDA #$02
    STA World1UndergroundAxisScrollBudget

Bank0_Label_CF24:
    LDA World1UndergroundAxisScrollCoarse
    ORA World1UndergroundAxisScrollFine
    BEQ Bank0_Label_CF6F
    LDA World1UndergroundAxisScrollFine
    SEC
    SBC #$01
    AND #$07
    STA World1UndergroundAxisScrollFine
    CMP #$07
    BNE Bank0_Label_CF39
    DEC World1UndergroundAxisScrollCoarse

Bank0_Label_CF39:
    JSR World1_TryScrollCameraLeft
    DEC World1UndergroundAxisScrollBudget
    BNE Bank0_Label_CF24
    BEQ Bank0_Label_CF6F

Bank0_Label_CF42:
    LDA World1PlayerX
    SEC
    SBC #$82
    BCC Bank0_Label_CF6F
    STA World1UndergroundAxisScrollBudget
    CMP #$02
    BCC Bank0_Label_CF53
    LDA #$01
    STA World1UndergroundAxisScrollBudget

Bank0_Label_CF53:
    INC World1UndergroundAxisScrollBudget

Bank0_Label_CF55:
    LDA World1UndergroundAxisScrollCoarse
    CMP World1UndergroundAxisScrollLimit
    BEQ Bank0_Label_CF6F
    LDA World1UndergroundAxisScrollFine
    CLC
    ADC #$01
    AND #$07
    STA World1UndergroundAxisScrollFine
    BNE Bank0_Label_CF68
    INC World1UndergroundAxisScrollCoarse

Bank0_Label_CF68:
    JSR World1_TryScrollCameraRight
    DEC World1UndergroundAxisScrollBudget
    BNE Bank0_Label_CF55

Bank0_Label_CF6F:
    LDA World1PlayerX
    CLC
    ADC World1ScreenDeltaX
    STA World1PlayerX
    JSR World1_ApplyCameraDeltaToEntities
    RTS

World1_UpdateUndergroundPlayer:
    JSR World1_UpdateWeaponAndTryFire
    LDA World1PlayerDamageState
    BEQ Bank0_Label_CFC0
    BPL Bank0_Label_CF84
    RTS

Bank0_Label_CF84:
    LDA #$40
    STA World1PlayerRenderFlags
    LDA FrameCounter
    AND #$03
    BNE Bank0_Label_CF90
    INC World1PlayerDamageState

Bank0_Label_CF90:
    LDA World1PlayerDamageState
    CMP #$06
    BCS Bank0_Label_CFA7
    LDA FrameCounter
    LSR A
    LSR A
    AND #$01
    ORA #$10
    STA World1PlayerMetasprite
    LDA #$00
    STA World1PlayerRenderFlags
    JMP Bank0_Label_CFDF

Bank0_Label_CFA7:
    CMP #$16
    BCC Bank0_Label_CFAF
    LDA #$00
    STA World1PlayerDamageState

Bank0_Label_CFAF:
    LDA World1PlayerMetasprite
    AND #$03
    STA $00
    LDA World1PlayerDirection
    ASL A
    ASL A
    ORA $00
    STA World1PlayerMetasprite
    JMP Bank0_Label_CFC4

Bank0_Label_CFC0:
    LDA #$00
    STA World1PlayerRenderFlags

Bank0_Label_CFC4:
    LDA World1PlayerAirborne
    BNE Bank0_Label_CFDF
    LDA World1WeaponPoseTimer
    BEQ Bank0_Label_CFDF
    CMP #$03
    BCS Bank0_Label_CFD9
    LDA World1PlayerMetasprite
    AND #$0C
    STA World1PlayerMetasprite
    JMP Bank0_Label_CFDF

Bank0_Label_CFD9:
    LDA World1PlayerMetasprite
    ORA #$01
    STA World1PlayerMetasprite

Bank0_Label_CFDF:
    LDA World1PlayerMetasprite
    STA $01
    LDA World1PlayerX
    STA $06
    LDA World1PlayerY
    STA $07
    LDA World1PlayerAirborne
    BEQ Bank0_Label_CFF5
    JSR World1_IntegrateUndergroundVerticalMotion
    JMP Bank0_Label_D004

Bank0_Label_CFF5:
    LDA World1PressedButtons
    AND #$80
    BEQ Bank0_Label_D001
    JSR World1_StartUndergroundJump
    JMP Bank0_Label_D004

Bank0_Label_D001:
    JSR World1_CheckUndergroundGroundSupport

Bank0_Label_D004:
    LDA CombinedControllerButtons
    AND #$02
    BNE Bank0_Label_D036
    LDA CombinedControllerButtons
    AND #$01
    BNE Bank0_Label_D084
    LDA World1PlayerDamageState
    BEQ Bank0_Label_D018
    CMP #$06
    BCC Bank0_Label_D02E

Bank0_Label_D018:
    LDA World1PlayerAirborne
    BNE Bank0_Label_D02F
    INC World1PlayerAnimationCounter
    LDA World1PlayerAnimationCounter
    CMP #$05
    BCC Bank0_Label_D02E
    LDA #$00
    STA World1PlayerAnimationCounter
    LDA World1PlayerMetasprite
    AND #$0C
    STA World1PlayerMetasprite

Bank0_Label_D02E:
    RTS

Bank0_Label_D02F:
    LDA World1PlayerMetasprite
    ORA #$01
    STA World1PlayerMetasprite
    RTS

Bank0_Label_D036:
    LDA #$02
    STA World1PlayerDirection
    DEC World1PlayerX
    LDA World1PlayerXSubpixel
    SEC
    SBC #$80
    STA World1PlayerXSubpixel
    BCS Bank0_Label_D047
    DEC World1PlayerX

Bank0_Label_D047:
    LDA World1PlayerX
    CMP #$05
    BCS Bank0_Label_D051
    LDA #$05
    STA World1PlayerX

Bank0_Label_D051:
    LDX #$00
    LDY #$19
    JSR World1_TestPlayerMapCollisionAtOffset
    BCS Bank0_Label_D06C
    LDX #$00
    LDY #$0E
    JSR World1_TestPlayerMapCollisionAtOffset
    BCS Bank0_Label_D06C
    LDX #$00
    LDY #$02
    JSR World1_TestPlayerMapCollisionAtOffset
    BCC Bank0_Label_D070

Bank0_Label_D06C:
    LDA $06
    STA World1PlayerX

Bank0_Label_D070:
    LDA World1PlayerAirborne
    BEQ Bank0_Label_D07D
    LDA #$00
    STA World1PlayerAnimationCounter
    LDA #$09
    STA World1PlayerMetasprite
    RTS

Bank0_Label_D07D:
    LDA #$09
    STA $01
    JMP Bank0_Label_D0D2

Bank0_Label_D084:
    LDA #$03
    STA World1PlayerDirection
    INC World1PlayerX
    LDA World1PlayerXSubpixel
    CLC
    ADC #$80
    STA World1PlayerXSubpixel
    BCC Bank0_Label_D095
    INC World1PlayerX

Bank0_Label_D095:
    LDA World1PlayerX
    CMP #$EC
    BCC Bank0_Label_D09F
    LDA #$EB
    STA World1PlayerX

Bank0_Label_D09F:
    LDX #$0E
    LDY #$19
    JSR World1_TestPlayerMapCollisionAtOffset
    BCS Bank0_Label_D0BA
    LDX #$0E
    LDY #$0E
    JSR World1_TestPlayerMapCollisionAtOffset
    BCS Bank0_Label_D0BA
    LDX #$0E
    LDY #$02
    JSR World1_TestPlayerMapCollisionAtOffset
    BCC Bank0_Label_D0BE

Bank0_Label_D0BA:
    LDA $06
    STA World1PlayerX

Bank0_Label_D0BE:
    LDA World1PlayerAirborne
    BEQ Bank0_Label_D0CB
    LDA #$00
    STA World1PlayerAnimationCounter
    LDA #$0D
    STA World1PlayerMetasprite
    RTS

Bank0_Label_D0CB:
    LDA #$0D
    STA $01
    JMP Bank0_Label_D0D2

Bank0_Label_D0D2:
    LDA World1PlayerDamageState
    BEQ Bank0_Label_D0DA
    CMP #$06
    BCC Bank0_Label_D112

Bank0_Label_D0DA:
    LDA World1PlayerMetasprite
    AND #$0C
    STA $00
    LDA $01
    AND #$0C
    CMP $00
    BEQ Bank0_Label_D0F2
    LDA $01
    STA World1PlayerMetasprite
    LDA #$00
    STA World1PlayerAnimationCounter
    STA World1WeaponPoseTimer

Bank0_Label_D0F2:
    LDA World1WeaponPoseTimer
    BNE Bank0_Label_D112
    INC World1PlayerAnimationCounter
    LDA World1PlayerAnimationCounter
    CMP #$05
    BCC Bank0_Label_D112
    LDA #$00
    STA World1PlayerAnimationCounter
    LDA World1PlayerMetasprite
    AND #$0C
    STA $00
    INC World1PlayerMetasprite
    LDA World1PlayerMetasprite
    AND #$03
    ORA $00
    STA World1PlayerMetasprite

Bank0_Label_D112:
    RTS
