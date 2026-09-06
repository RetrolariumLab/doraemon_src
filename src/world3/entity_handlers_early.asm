; Doraemon PRG bank 2 $931F-$968B
; World 3 shared indirect trampoline and early entity-type handlers
; Generated deterministically from pinned Ghidra/GhidraNes facts

World3_CallIndirect:
    JMP ($0040)

World3_UpdateTypes00To03:
    LDA a:World3EntityState,X
    CMP #$04
    BNE Bank2_Label_932C
    JSR World3_FollowActiveGhost

Bank2_Label_932C:
    RTS

World3_UpdateType04Skull:
    LDA a:World3EntityState,X
    CMP #$04
    BNE Bank2_Label_9338
    JSR World3_FollowActiveGhost
    RTS

Bank2_Label_9338:
    LDY World3CurrentRoom
    LDA a:World3_Type04SkullTrackingEnabledByRoom,Y
    BEQ Bank2_Label_936B
    INC a:World3EntityFrameCounter,X
    LDA a:World3EntityFrameCounter,X
    AND #$03
    BNE Bank2_Label_936B
    STX $3E
    LDA a:World3EntityX,X
    STA $3C
    LDA a:World3EntityY,X
    STA $3D
    LDX World3PlayerX
    LDY World3PlayerY
    JSR World3_StepWorkXTowardTarget
    JSR World3_StepWorkYTowardTarget
    LDX $3E
    LDA $3C
    STA a:World3EntityX,X
    LDA $3D
    STA a:World3EntityY,X

Bank2_Label_936B:
    RTS

World3_Type04SkullTrackingEnabledByRoom:
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01
    .byte $00, $00, $00, $00, $00, $01, $01, $01, $00, $00, $00, $00, $00, $01, $01, $00

World3_UpdateType05Ghost:
    LDA a:World3EntityX,X
    CMP #$F0
    BCS Bank2_Label_93EF
    LDA a:World3EntityY,X
    CMP #$D8
    BCS Bank2_Label_93EF
    LDY #$00

Bank2_Label_93BC:
    LDA a:World3EntityState,Y
    CMP #$04
    BEQ Bank2_Label_93CB
    INY
    CPY #$08
    BNE Bank2_Label_93BC
    JMP Bank2_Label_94EC

Bank2_Label_93CB:
    LDA $A3
    AND #$03
    TAY
    LDA a:World3EntityX,X
    CLC
    ADC a:World3_GhostHeldMotionDeltaX,Y
    STA a:World3EntityX,X
    LDA a:World3EntityY,X
    CLC
    ADC a:World3_GhostHeldMotionDeltaY,Y
    STA a:World3EntityY,X
    JMP Bank2_Label_94EC

World3_GhostHeldMotionDeltaX:
    .byte $02, $FE, $02, $FE

World3_GhostHeldMotionDeltaY:
    .byte $02, $02, $FE, $FE

Bank2_Label_93EF:
    LDA #$00
    STA a:World3EntityState,X
    LDY #$00

Bank2_Label_93F6:
    LDA a:World3EntityState,Y
    CMP #$04
    BEQ Bank2_Label_9403
    INY
    CPY #$08
    BNE Bank2_Label_93F6
    RTS

Bank2_Label_9403:
    LDA #$00
    STA a:World3EntityState,Y
    LDA #$00
    STA a:World3EntityPersistentState,Y
    LDA a:World3EntityType,Y
    CMP #$18
    BCS Bank2_Label_9415
    RTS

Bank2_Label_9415:
    LDA World3CurrentRoom
    STA $40
    LDA World3PlayerX
    SEC
    SBC #$78
    JSR World3_AbsoluteValue8
    STA $41
    LDA World3PlayerY
    SEC
    SBC #$78
    JSR World3_AbsoluteValue8
    CMP $41
    BCS Bank2_Label_9449
    LDA World3PlayerX
    CMP #$78
    BCS Bank2_Label_943E
    LDA World3RoomColumn
    BEQ Bank2_Label_9475
    DEC $40
    JMP Bank2_Label_946A

Bank2_Label_943E:
    LDA World3RoomColumn
    CMP #$07
    BEQ Bank2_Label_9475
    INC $40
    JMP Bank2_Label_946A

Bank2_Label_9449:
    LDA World3PlayerY
    CMP #$78
    BCS Bank2_Label_945D
    LDA World3RoomRow
    BEQ Bank2_Label_9475
    LDA $40
    SEC
    SBC #$08
    STA $40
    JMP Bank2_Label_946A

Bank2_Label_945D:
    LDA World3RoomRow
    CMP #$07
    BEQ Bank2_Label_9475
    LDA $40
    CLC
    ADC #$08
    STA $40

Bank2_Label_946A:
    STX $3E
    LDX $40
    LDA a:World3_GhostRelocationBlockedByRoom,X
    BEQ Bank2_Label_94B8
    LDX $3E

Bank2_Label_9475:
    STX $3E
    LDA World3CurrentRoom
    SEC
    SBC #$01
    AND #$3F
    TAX
    LDA a:World3_GhostRelocationBlockedByRoom,X
    BEQ Bank2_Label_94B6
    LDA World3CurrentRoom
    CLC
    ADC #$01
    AND #$3F
    TAX
    LDA a:World3_GhostRelocationBlockedByRoom,X
    BEQ Bank2_Label_94B6
    LDA World3CurrentRoom
    SEC
    SBC #$08
    AND #$3F
    TAX
    LDA a:World3_GhostRelocationBlockedByRoom,X
    BEQ Bank2_Label_94B6
    LDA World3CurrentRoom
    CLC
    ADC #$08
    AND #$3F
    TAX
    LDA a:World3_GhostRelocationBlockedByRoom,X
    BEQ Bank2_Label_94B6

Bank2_Label_94AB:
    JSR World3_RandomByte
    AND #$3F
    TAX
    LDA a:World3_GhostRelocationBlockedByRoom,X
    BNE Bank2_Label_94AB

Bank2_Label_94B6:
    STX $40

Bank2_Label_94B8:
    LDX #$00

Bank2_Label_94BA:
    LDA a:World3RoomObjectRoom,X
    CMP World3CurrentRoom
    BNE Bank2_Label_94C9
    LDA a:World3RoomObjectType,X
    CMP a:World3EntityType,Y
    BEQ Bank2_Label_94D3

Bank2_Label_94C9:
    INX
    CPX #$0D
    BNE Bank2_Label_94BA
    LDA #$04
    JMP World3_HaltWithDiagnosticCode

Bank2_Label_94D3:
    LDA $40
    STA a:World3RoomObjectRoom,X
    JSR World3_ChooseSpawnX
    STA a:World3RoomObjectX,X
    JSR World3_ChooseSpawnY
    STA a:World3RoomObjectY,X
    LDA #$00
    STA a:World3RoomObjectState,X
    LDX $3E
    RTS

Bank2_Label_94EC:
    LDY #$00

Bank2_Label_94EE:
    LDA a:World3EntityState,Y
    CMP #$04
    BEQ Bank2_Label_954F
    INY
    CPY #$08
    BNE Bank2_Label_94EE
    LDY #$00

Bank2_Label_94FC:
    LDA a:World3EntityState,Y
    CMP #$01
    BNE Bank2_Label_954A
    LDA a:World3EntityType,Y
    CMP #$05
    BCC Bank2_Label_9512
    CMP #$18
    BCC Bank2_Label_954A
    CMP #$1B
    BEQ Bank2_Label_954A

Bank2_Label_9512:
    LDA a:World3EntityX,X
    SEC
    SBC a:World3EntityX,Y
    JSR World3_AbsoluteValue8
    CMP #$0D
    BCS Bank2_Label_954A
    LDA a:World3EntityY,X
    SEC
    SBC a:World3EntityY,Y
    JSR World3_AbsoluteValue8
    CMP #$0D
    BCS Bank2_Label_954A
    LDA a:World3EntityFollowAnchorFlag,X
    STA $A3
    LDA #$12
    JSR World3_QueueEffectPreserveXY
    LDA #$04
    STA a:World3EntityState,Y
    LDA a:World3EntityPersistentState,Y
    BEQ Bank2_Label_954F
    LDA #$00
    STA a:World3EntityPersistentState,Y
    STA World3FollowerActive
    RTS

Bank2_Label_954A:
    INY
    CPY #$08
    BNE Bank2_Label_94FC

Bank2_Label_954F:
    RTS

World3_GhostRelocationBlockedByRoom:
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $01, $01, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $01, $01
    .byte $00, $01, $01, $01, $00, $00, $01, $01, $01, $01, $01, $00, $00, $01, $01, $01
    .byte $00, $00, $00, $00, $01, $01, $01, $01, $00, $00, $00, $00, $00, $01, $01, $01

World3_UpdateTypes06HazardAnd07Candy:
    RTS

World3_UpdateType08OctopusTip:
    JSR World3_UpdateGiantOctopusTentacle

World3_UpdateType09OctopusSegment:
    RTS

World3_UpdateType0ADragonHead:
    JSR World3_RandomByte
    AND #$1F
    BNE Bank2_Label_95A1
    LDA #$11
    JSR World3_QueueEffectPreserveXY

Bank2_Label_95A1:
    JSR World3_UpdateDragonFormation

World3_UpdateType0BDragonSegment:
    RTS

World3_UpdateType0CPoseidonUpperLeft:
    JSR World3_RandomByte
    AND #$1F
    BNE Bank2_Label_95B1
    LDA #$11
    JSR World3_QueueEffectPreserveXY

Bank2_Label_95B1:
    LDA a:World3EntityFollowAnchorFlag,X
    BEQ Bank2_Label_95B9
    JSR World3_TrySpawnVolcanicRockFromPoseidon

Bank2_Label_95B9:
    STX $3E
    LDA a:World3EntityFollowAnchorFlag,X
    BEQ Bank2_Label_95F2
    INC a:World3EntityFrameCounter,X
    LDA a:World3EntityFrameCounter,X
    AND #$01
    BNE Bank2_Label_95F2
    LDA a:World3EntityX,X
    STA $3C
    LDA a:World3EntityY,X
    STA $3D
    LDA World3PlayerX
    CLC
    ADC #$08
    TAX
    LDA World3PlayerY
    SEC
    SBC #$0C
    TAY
    JSR World3_StepWorkXTowardTarget
    JSR World3_StepWorkYTowardTarget
    LDX $3E
    LDA $3C
    STA a:World3EntityX,X
    LDA $3D
    STA a:World3EntityY,X

Bank2_Label_95F2:
    RTS

World3_TrySpawnVolcanicRockFromPoseidon:
    STX $3E
    LDX #$00
    LDY #$00

Bank2_Label_95F9:
    LDA a:World3EntityState,X
    BNE Bank2_Label_95FF
    INY

Bank2_Label_95FF:
    INX
    CPX #$08
    BNE Bank2_Label_95F9
    CPY #$02
    BCC Bank2_Label_9640
    JSR World3_FindFreeEntitySlot
    BCC Bank2_Label_9640
    JSR World3_ClearEntitySlot
    LDA #$1E
    STA a:World3EntityActivationTimer,X
    LDA #$02
    STA a:World3EntityType,X
    TAY
    LDA a:World3_EntityHitPointsByType,Y
    STA a:World3EntityHitPoints,X
    LDA a:World3_EntityMetaspriteByType,Y
    STA a:World3EntityMetasprite,X
    LDY $3E
    LDA a:World3EntityX,Y
    CLC
    ADC #$08
    STA a:World3EntityX,X
    LDA a:World3EntityY,Y
    CLC
    ADC #$18
    STA a:World3EntityY,X
    LDA #$01
    STA a:World3EntityState,X

Bank2_Label_9640:
    LDX $3E
    RTS

World3_UpdateType0DPoseidonUpperRight:
    LDA a:World3EntityFollowAnchorFlag,X
    BEQ Bank2_Label_965A
    JSR World3_FindActivePoseidonAnchor
    LDA a:World3EntityX,Y
    CLC
    ADC #$10
    STA a:World3EntityX,X
    LDA a:World3EntityY,Y
    STA a:World3EntityY,X

Bank2_Label_965A:
    RTS

World3_UpdateType0EPoseidonLowerLeft:
    LDA a:World3EntityFollowAnchorFlag,X
    BEQ Bank2_Label_968B
    JSR World3_FindActivePoseidonAnchor
    LDA a:World3EntityX,Y
    STA a:World3EntityX,X
    LDA a:World3EntityY,Y
    CLC
    ADC #$18
    STA a:World3EntityY,X
    INC a:World3EntityFrameCounter,X
    LDA a:World3EntityFrameCounter,X
    LSR A
    LSR A
    LSR A
    AND #$01
    STA a:World3EntityMetaspriteVariantBit0,X
    LDA a:World3EntityFrameCounter,X
    LSR A
    LSR A
    LSR A
    AND #$02
    STA a:World3EntityMetaspriteVariantBit1,X

Bank2_Label_968B:
    RTS
