; Doraemon PRG bank 0 $856C-$888E
; World 1 player state, directional movement, and camera-relative positioning
; Generated deterministically from pinned Ghidra/GhidraNes facts

World1_UpdateCityPlayer:
    JSR World1_UpdateWeaponAndTryFire
    LDA World1PlayerDamageState
    BEQ Bank0_Label_85B2
    BPL Bank0_Label_8576
    RTS

Bank0_Label_8576:
    LDA #$40
    STA World1PlayerRenderFlags
    LDA FrameCounter
    AND #$03
    BNE Bank0_Label_8582
    INC World1PlayerDamageState

Bank0_Label_8582:
    LDA World1PlayerDamageState
    CMP #$06
    BCS Bank0_Label_8599
    LDA FrameCounter
    LSR A
    LSR A
    AND #$01
    ORA #$10
    STA World1PlayerMetasprite
    LDA #$00
    STA World1PlayerRenderFlags
    JMP Bank0_Label_85CD

Bank0_Label_8599:
    CMP #$16
    BCC Bank0_Label_85A1
    LDA #$00
    STA World1PlayerDamageState

Bank0_Label_85A1:
    LDA World1PlayerMetasprite
    AND #$03
    STA $00
    LDA World1PlayerDirection
    ASL A
    ASL A
    ORA $00
    STA World1PlayerMetasprite
    JMP Bank0_Label_85B6

Bank0_Label_85B2:
    LDA #$00
    STA World1PlayerRenderFlags

Bank0_Label_85B6:
    LDA World1WeaponPoseTimer
    BEQ Bank0_Label_85CD
    CMP #$03
    BCS Bank0_Label_85C7
    LDA World1PlayerMetasprite
    AND #$0C
    STA World1PlayerMetasprite
    JMP Bank0_Label_85CD

Bank0_Label_85C7:
    LDA World1PlayerMetasprite
    ORA #$01
    STA World1PlayerMetasprite

Bank0_Label_85CD:
    LDA World1PlayerMetasprite
    STA $01
    LDA World1PlayerX
    STA $06
    LDA World1PlayerY
    STA $07
    LDY CombinedControllerButtons
    TYA
    AND #$08
    BNE Bank0_Label_860D
    TYA
    AND #$04
    BNE Bank0_Label_863B
    TYA
    AND #$02
    BNE Bank0_Label_8669
    TYA
    AND #$01
    BNE Bank0_Label_860A
    LDA World1PlayerDamageState
    BEQ Bank0_Label_85F7
    CMP #$06
    BCC Bank0_Label_8609

Bank0_Label_85F7:
    INC World1PlayerAnimationCounter
    LDA World1PlayerAnimationCounter
    CMP #$05
    BCC Bank0_Label_8609
    LDA #$00
    STA World1PlayerAnimationCounter
    LDA World1PlayerMetasprite
    AND #$0C
    STA World1PlayerMetasprite

Bank0_Label_8609:
    RTS

Bank0_Label_860A:
    JMP Bank0_Label_8690

Bank0_Label_860D:
    LDA #$01
    STA World1PlayerDirection
    DEC World1PlayerY
    DEC World1PlayerY
    LDA World1PlayerY
    CMP #$28
    BCS Bank0_Label_861F
    LDA #$28
    STA World1PlayerY

Bank0_Label_861F:
    LDA #$05
    STA $01
    LDX #$00
    LDY #$14
    JSR World1_RollbackCityPlayerOnCollision
    LDX #$07
    LDY #$14
    JSR World1_RollbackCityPlayerOnCollision
    LDX #$0E
    LDY #$14
    JSR World1_RollbackCityPlayerOnCollision
    JMP Bank0_Label_86B7

Bank0_Label_863B:
    LDA #$00
    STA World1PlayerDirection
    INC World1PlayerY
    INC World1PlayerY
    LDA World1PlayerY
    CMP #$C9
    BCC Bank0_Label_864D
    LDA #$C8
    STA World1PlayerY

Bank0_Label_864D:
    LDA #$01
    STA $01
    LDX #$00
    LDY #$18
    JSR World1_RollbackCityPlayerOnCollision
    LDX #$07
    LDY #$18
    JSR World1_RollbackCityPlayerOnCollision
    LDX #$0E
    LDY #$18
    JSR World1_RollbackCityPlayerOnCollision
    JMP Bank0_Label_86B7

Bank0_Label_8669:
    LDA #$02
    STA World1PlayerDirection
    DEC World1PlayerX
    DEC World1PlayerX
    LDA World1PlayerX
    CMP #$05
    BCS Bank0_Label_867B
    LDA #$05
    STA World1PlayerX

Bank0_Label_867B:
    LDA #$09
    STA $01
    LDX #$00
    LDY #$18
    JSR World1_RollbackCityPlayerOnCollision
    LDX #$00
    LDY #$14
    JSR World1_RollbackCityPlayerOnCollision
    JMP Bank0_Label_86B7

Bank0_Label_8690:
    LDA #$03
    STA World1PlayerDirection
    INC World1PlayerX
    INC World1PlayerX
    LDA World1PlayerX
    CMP #$EC
    BCC Bank0_Label_86A2
    LDA #$EB
    STA World1PlayerX

Bank0_Label_86A2:
    LDA #$0D
    STA $01
    LDX #$0E
    LDY #$18
    JSR World1_RollbackCityPlayerOnCollision
    LDX #$0E
    LDY #$14
    JSR World1_RollbackCityPlayerOnCollision
    JMP Bank0_Label_86B7

Bank0_Label_86B7:
    LDA World1PlayerDamageState
    BEQ Bank0_Label_86BF
    CMP #$06
    BCC Bank0_Label_86F7

Bank0_Label_86BF:
    LDA World1PlayerMetasprite
    AND #$0C
    STA $00
    LDA $01
    AND #$0C
    CMP $00
    BEQ Bank0_Label_86D7
    LDA $01
    STA World1PlayerMetasprite
    LDA #$00
    STA World1PlayerAnimationCounter
    STA World1WeaponPoseTimer

Bank0_Label_86D7:
    LDA World1WeaponPoseTimer
    BNE Bank0_Label_86F7
    INC World1PlayerAnimationCounter
    LDA World1PlayerAnimationCounter
    CMP #$05
    BCC Bank0_Label_86F7
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

Bank0_Label_86F7:
    RTS

World1_RollbackCityPlayerOnCollision:
    JSR World1_TestPlayerMapCollisionAtOffset
    BCC Bank0_Label_8705
    LDA $06
    STA World1PlayerX
    LDA $07
    STA World1PlayerY

Bank0_Label_8705:
    RTS

World1_UpdateCameraFromPlayer:
    LDA #$00
    STA World1ScreenDeltaX
    STA World1ScreenDeltaY
    LDA World1PlayerX
    CMP #$50
    BCS Bank0_Label_871B
    JSR World1_TryScrollCameraLeft
    JSR World1_TryScrollCameraLeft
    JMP Bank0_Label_8725

Bank0_Label_871B:
    CMP #$A0
    BCC Bank0_Label_8725
    JSR World1_TryScrollCameraRight
    JSR World1_TryScrollCameraRight

Bank0_Label_8725:
    LDA World1PlayerY
    CMP #$48
    BCS Bank0_Label_8734
    JSR World1_TryScrollCameraUp
    JSR World1_TryScrollCameraUp
    JMP Bank0_Label_873E

Bank0_Label_8734:
    CMP #$90
    BCC Bank0_Label_873E
    JSR World1_TryScrollCameraDown
    JSR World1_TryScrollCameraDown

Bank0_Label_873E:
    LDA World1PlayerX
    CLC
    ADC World1ScreenDeltaX
    STA World1PlayerX
    LDA World1PlayerY
    CLC
    ADC World1ScreenDeltaY
    STA World1PlayerY
    JSR World1_ApplyCameraDeltaToEntities
    RTS

World1_ApplyCameraDeltaToEntities:
    LDY #$2F
    LDA World1ScreenDeltaX
    BEQ Bank0_Label_87A2
    BMI Bank0_Label_877E

Bank0_Label_8758:
    LDA a:World1EntityType,Y
    BEQ Bank0_Label_8779
    LDA a:World1EntityX,Y
    CLC
    ADC World1ScreenDeltaX
    STA a:World1EntityX,Y
    BCC Bank0_Label_8779
    LDA a:World1EntityPositionHigh,Y
    TAX
    AND #$FC
    STA $00
    INX
    TXA
    AND #$03
    ORA $00
    STA a:World1EntityPositionHigh,Y

Bank0_Label_8779:
    DEY
    BPL Bank0_Label_8758
    BMI Bank0_Label_87A2

Bank0_Label_877E:
    LDA a:World1EntityType,Y
    BEQ Bank0_Label_879F
    LDA a:World1EntityX,Y
    CLC
    ADC World1ScreenDeltaX
    STA a:World1EntityX,Y
    BCS Bank0_Label_879F
    LDA a:World1EntityPositionHigh,Y
    TAX
    AND #$FC
    STA $00
    DEX
    TXA
    AND #$03
    ORA $00
    STA a:World1EntityPositionHigh,Y

Bank0_Label_879F:
    DEY
    BPL Bank0_Label_877E

Bank0_Label_87A2:
    LDY #$2F
    LDA World1ScreenDeltaY
    BEQ World1_CullOffscreenEntities
    BMI Bank0_Label_87D2

Bank0_Label_87AA:
    LDA a:World1EntityType,Y
    BEQ Bank0_Label_87CD
    LDA a:World1EntityY,Y
    CLC
    ADC World1ScreenDeltaY
    STA a:World1EntityY,Y
    BCC Bank0_Label_87CD
    LDA a:World1EntityPositionHigh,Y
    TAX
    AND #$F3
    STA $00
    TXA
    CLC
    ADC #$04
    AND #$0C
    ORA $00
    STA a:World1EntityPositionHigh,Y

Bank0_Label_87CD:
    DEY
    BPL Bank0_Label_87AA
    BMI World1_CullOffscreenEntities

Bank0_Label_87D2:
    LDA a:World1EntityType,Y
    BEQ Bank0_Label_87F5
    LDA a:World1EntityY,Y
    CLC
    ADC World1ScreenDeltaY
    STA a:World1EntityY,Y
    BCS Bank0_Label_87F5
    LDA a:World1EntityPositionHigh,Y
    TAX
    AND #$F3
    STA $00
    TXA
    SEC
    SBC #$04
    AND #$0C
    ORA $00
    STA a:World1EntityPositionHigh,Y

Bank0_Label_87F5:
    DEY
    BPL Bank0_Label_87D2

World1_CullOffscreenEntities:
    LDY #$2F

Bank0_Label_87FA:
    LDA a:World1EntityType,Y
    BEQ Bank0_Label_8848
    LDA a:World1EntityPositionHigh,Y
    AND #$03
    BEQ Bank0_Label_881C
    CMP #$02
    BEQ Bank0_Label_8839
    BCC Bank0_Label_8815
    LDA a:World1EntityX,Y
    CMP #$C0
    BCC Bank0_Label_8839
    BCS Bank0_Label_881C

Bank0_Label_8815:
    LDA a:World1EntityX,Y
    CMP #$40
    BCS Bank0_Label_8839

Bank0_Label_881C:
    LDA a:World1EntityPositionHigh,Y
    AND #$0C
    BEQ Bank0_Label_8848
    CMP #$08
    BEQ Bank0_Label_8839
    BCC Bank0_Label_8832
    LDA a:World1EntityY,Y
    CMP #$C0
    BCC Bank0_Label_8839
    BCS Bank0_Label_8848

Bank0_Label_8832:
    LDA a:World1EntityY,Y
    CMP #$20
    BCC Bank0_Label_8848

Bank0_Label_8839:
    LDA #$00
    STA a:World1EntityType,Y
    LDA a:World1EntitySourceObjectId,Y
    BMI Bank0_Label_8848
    AND #$7F
    JSR World1_ReleaseObjectSpawn

Bank0_Label_8848:
    DEY
    BPL Bank0_Label_87FA
    RTS

Bank0_Func_884C:
    JSR World1_ClearEntitySlots10_29
    JSR World1_ClearEntitySlots30_37
    LDA #$00
    STA a:AudioMusicState
    LDA #$00
    STA World1PlayerRenderFlags
    LDA #$78
    STA $97

Bank0_Label_885F:
    LDA $97
    LSR A
    LSR A
    LSR A
    AND #$01
    ORA #$10
    STA World1PlayerMetasprite
    JSR Bank0_Func_94F1
    LDA $97
    CMP #$3C
    BNE Bank0_Label_8878
    LDA #$07
    STA a:AudioMusicState

Bank0_Label_8878:
    DEC $97
    BNE Bank0_Label_885F
    LDA #$78
    STA $97

Bank0_Label_8880:
    JSR Bank0_Func_94F1
    DEC $97
    BNE Bank0_Label_8880
    LDA DemoModeActive
    BEQ Bank0_Label_888E
    JMP Bank0_Func_8048

Bank0_Label_888E:
    RTS
