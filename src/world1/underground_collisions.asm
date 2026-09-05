; Doraemon PRG bank 0 $D113-$D3A8
; World 1 underground collision tests and manhole return transition
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank0_Func_D113:
    LDA $9B
    BEQ Bank0_Label_D11D
    LDA World1PlayerY
    CMP #$C6
    BCS Bank0_Label_D137

Bank0_Label_D11D:
    LDX #$04
    LDY #$1A
    JSR World1_TestPlayerMapCollisionAtOffset
    BCS Bank0_Label_D137
    LDX #$0A
    LDY #$1A
    JSR World1_TestPlayerMapCollisionAtOffset
    BCS Bank0_Label_D137
    LDA #$01
    STA World1PlayerAirborne
    LDA #$00
    STA World1PlayerYVelocity

Bank0_Label_D137:
    RTS

Bank0_Func_D138:
    LDA #$E8
    STA World1PlayerYVelocity
    LDA #$01
    STA World1PlayerAirborne
    LDA #$12
    JSR World1_Audio_QueueEffect

Bank0_Func_D145:
    LDA World1PlayerYVelocity
    AND #$80
    STA $00
    LDA World1PlayerYVelocity
    LSR A
    ORA $00
    LSR A
    ORA $00
    ADC World1PlayerY
    STA World1PlayerY
    INC World1PlayerYVelocity
    LDA World1PlayerYVelocity
    BMI Bank0_Label_D165
    CMP #$18
    BCC Bank0_Label_D165
    LDA #$18
    STA World1PlayerYVelocity

Bank0_Label_D165:
    LDA World1PlayerYVelocity
    BMI Bank0_Label_D186
    LDA $9B
    BEQ Bank0_Label_D173
    LDA World1PlayerY
    CMP #$C6
    BCS Bank0_Label_D1AB

Bank0_Label_D173:
    LDX #$04
    LDY #$1A
    JSR World1_TestPlayerMapCollisionAtOffset
    BCS Bank0_Label_D1AB
    LDX #$0A
    LDY #$1A
    JSR World1_TestPlayerMapCollisionAtOffset
    BCS Bank0_Label_D1AB
    RTS

Bank0_Label_D186:
    LDX #$04
    LDY #$02
    JSR World1_TestPlayerMapCollisionAtOffset
    BCS Bank0_Label_D199
    LDX #$0A
    LDY #$02
    JSR World1_TestPlayerMapCollisionAtOffset
    BCS Bank0_Label_D199
    RTS

Bank0_Label_D199:
    LDA World1PlayerY
    CLC
    ADC #$0A
    AND #$F8
    STA World1PlayerY
    DEC World1PlayerY
    DEC World1PlayerY
    LDA #$00
    STA World1PlayerYVelocity
    RTS

Bank0_Label_D1AB:
    LDA PpuScrollYShadow
    AND #$07
    CLC
    ADC #$02
    STA $00
    CLC
    ADC World1PlayerY
    AND #$F8
    SEC
    SBC $00
    STA World1PlayerY
    LDA #$00
    STA World1PlayerAirborne
    RTS

World1_TestPlayerMapCollisionAtOffset:
    STX $04
    LDA PpuScrollXShadow
    AND #$07
    CLC
    ADC World1PlayerX
    CLC
    ADC $04
    LSR A
    LSR A
    LSR A
    CLC
    ADC World1CameraTileX
    TAX
    STY $04
    LDA PpuScrollYShadow
    AND #$07
    CLC
    ADC World1PlayerY
    CLC
    ADC $04
    LSR A
    LSR A
    LSR A
    CLC
    ADC World1CameraTileY
    TAY
    JSR World1_LookupMapTile
    CPY #$42
    RTS
    .byte $40, $22, $20, $00, $80, $22, $20, $00, $CA, $22, $20, $0A, $00, $42, $20, $00
    .byte $40, $42, $40, $00, $20, $02, $C0, $00, $E0, $02, $C0, $C0, $A0, $42, $40, $40
    .byte $60, $42, $40, $00, $18, $10, $00, $FF, $38, $10, $01, $FF, $78, $10, $02, $02
    .byte $38, $10, $03, $FF, $18, $10, $04, $FF, $18, $10, $05, $06, $B8, $10, $05, $06
    .byte $D8, $10, $08, $07, $18, $10, $08, $07

World1_TryEnterManhole:
    LDA CombinedControllerButtons
    AND #$80
    BEQ Bank0_Label_D243
    LDA $81
    CMP #$01
    BEQ World1_EnterManhole

Bank0_Label_D243:
    RTS

World1_EnterManhole:
    LDA a:World1SavedUndergroundObjectBits
    AND #$FE
    STA a:World1SavedUndergroundObjectBits
    LDA #$00
    STA a:AudioMusicState
    STA a:AudioMusicControl
    STA World1EnemyFreezeActive
    STA World1EnemyFreezeTimer
    STA World1InvulnerabilityTimer
    JSR World1_ClearEntitySlots00_09
    JSR World1_ClearEntitySlots10_29
    JSR World1_ClearEntitySlots30_37
    LDX $80
    LDA a:World1EntitySourceObjectId+$26,X
    STA $81
    TAY
    LDA a:World1EntityX+$26,X
    CLC
    ADC #$04
    STA World1PlayerX
    LDA a:World1EntityY+$26,X
    SEC
    SBC #$14
    STA World1PlayerY
    LDA #$00
    STA World1PlayerMetasprite
    STA World1PlayerRenderFlags
    STA World1PlayerDirection

Bank0_Label_D283:
    JSR Bank0_Func_94F1
    LDA #$00
    STA World1ScreenDeltaX
    STA World1ScreenDeltaY
    JSR World1_UpdateCameraFromPlayer
    LDA World1ScreenDeltaX
    ORA World1ScreenDeltaY
    BNE Bank0_Label_D283
    LDX #$0A

Bank0_Label_D297:
    JSR Bank0_Func_94F1
    DEX
    BNE Bank0_Label_D297
    LDX #$00
    LDA #$12
    JSR World1_Audio_QueueEffect

Bank0_Label_D2A4:
    JSR Bank0_Func_94F1
    TXA
    LSR A
    LSR A
    TAY
    LDA a:$D3A3,Y
    CLC
    ADC World1PlayerY
    STA World1PlayerY
    INX
    CPX #$14
    BNE Bank0_Label_D2A4
    JSR World1_ClearEntitySlots38_47
    JSR World1_RefreshObjectSpawnMask
    LDX $81
    JMP Bank0_InitWorld1SideView

Bank0_Func_D2C3:
    PHA
    LDA #$00
    STA a:AudioMusicState
    STA a:AudioMusicControl
    STA World1EnemyFreezeActive
    STA World1EnemyFreezeTimer
    STA World1InvulnerabilityTimer
    JSR World1_ClearEntitySlots38_47
    JSR World1_RefreshObjectSpawnMask
    JSR World1_ClearEntitySlots00_09
    JSR World1_ClearEntitySlots10_29
    JSR World1_ClearEntitySlots30_37
    PLA
    ASL A
    ASL A
    TAX
    LDA a:$D37E,X
    STA World1CameraTileX
    LDA a:$D37F,X
    STA World1CameraTileY
    LDA a:$D380,X
    STA a:World1EntityX+$26
    CLC
    ADC #$04
    STA World1PlayerX
    LDA a:$D381,X
    STA a:World1EntityY+$26
    SEC
    SBC #$14
    STA World1PlayerY
    LDA #$00
    STA World1PlayerDamageState
    LDA #$00
    STA World1PlayerMetasprite
    LDA #$00
    STA World1PlayerDirection
    LDA #$00
    STA World1PlayerRenderFlags
    LDA #$00
    STA World1PlayerAnimationCounter
    JSR Bank0_Func_9614
    LDA #$EF
    STA World1MapDataPointer
    LDA #$B2
    STA World1MapDataPointer+$01
    LDA #$89
    STA World1ObjectPlacementList
    LDA #$D9
    STA World1ObjectPlacementList+$01
    LDA #$00
    STA $29
    LDA World1CameraTileY
    CMP #$40
    BCS Bank0_Label_D33A
    LDA #$01
    STA $29

Bank0_Label_D33A:
    LDX #$00

Bank0_Label_D33C:
    LDA a:World1CollectedObjectBits,X
    STA a:World1SavedUndergroundObjectBits,X
    LDA a:World1SavedCityObjectBits,X
    STA a:World1CollectedObjectBits,X
    INX
    CPX #$10
    BNE Bank0_Label_D33C
    JSR World1_ClearEntitySlots38_47
    JSR World1_RefreshObjectSpawnMask
    JSR Bank0_Func_83BD
    JSR Bank0_Func_9535
    JSR World1_PrefillMapViewport
    JSR Bank0_Func_843B
    JSR Bank0_Func_95ED
    LDX #$00

Bank0_Label_D364:
    JSR Bank0_Func_94F1
    TXA
    LSR A
    LSR A
    TAY
    LDA a:$D3A2,Y
    CLC
    ADC World1PlayerY
    STA World1PlayerY
    INX
    CPX #$1C
    BNE Bank0_Label_D364
    LDX #$7F
    TXS
    JMP Bank0_Label_82C1
    .byte $E0, $E0, $70, $90, $B0, $D0, $70, $90, $92, $66, $70, $90, $3E, $68, $70, $90
    .byte $3A, $9A, $70, $90, $00, $5C, $30, $70, $DE, $00, $70, $70, $64, $34, $70, $90
    .byte $10, $26, $70, $90, $FD, $FE, $FF, $00, $01, $02, $03
