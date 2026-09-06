; Doraemon PRG bank 2 $A8B0-$AB3A
; World 3 room updates and early entity collision adjustment
; Generated deterministically from pinned Ghidra/GhidraNes facts

World3_FadePaletteIn:
    LDX #$00
    STX $02

Bank2_Label_A8B4:
    LDA a:World3PaletteShadow,X
    CMP a:World3PaletteTarget,X
    BEQ Bank2_Label_A8D3
    INC $02
    CMP #$0F
    BNE Bank2_Label_A8CA
    LDA a:World3PaletteTarget,X
    AND #$0F
    JMP Bank2_Label_A8D0

Bank2_Label_A8CA:
    LDA a:World3PaletteShadow,X
    CLC
    ADC #$10

Bank2_Label_A8D0:
    STA a:World3PaletteShadow,X

Bank2_Label_A8D3:
    INX
    CPX #$20
    BNE Bank2_Label_A8B4
    LDX #$80
    LDY #$04
    JSR World3_QueuePalette
    LDA #$03
    STA World3FrameWaitCounter
    JSR World3_WaitFrames
    LDA $02
    BNE World3_FadePaletteIn
    RTS

World3_StreamCurrentRoomBackground:
    JSR World3_CalculateCurrentRoomMapPointer
    LDA #$00
    STA World3RoomRenderRow
    STA World3RoomBigBlockRowOffset
    STA World3RoomSmallBlockRowOffset
    LDA #$1E
    STA $07

Bank2_Label_A8FA:
    JSR World3_QueueRoomBackgroundRow
    INC World3RoomRenderRow
    DEC $07
    BNE Bank2_Label_A8FA
    RTS

World3_CalculateCurrentRoomMapPointer:
    LDA World3CurrentRoom
    AND #$F8
    LSR A
    LSR A
    CLC
    ADC #$E6
    STA World3RoomMapPointer+$01
    LDA World3CurrentRoom
    AND #$07
    ASL A
    ASL A
    ASL A
    CLC
    ADC #$F2
    STA World3RoomMapPointer
    LDA World3RoomMapPointer+$01
    ADC #$00
    STA World3RoomMapPointer+$01
    RTS

World3_QueueRoomBackgroundRow:
    JSR World3_ExpandNextRoomTileRow
    LDX #$00
    LDY World3RoomRenderRow
    JSR World3_CalculateNametableAddress
    LDX #$A0
    LDY #$04
    LDA #$20
    JSR World3_QueuePpuBlock
    LDX #$00
    LDY World3RoomRenderRow
    JSR World3_CalculateAttributeAddress
    LDX #$C0
    LDY #$04
    LDA #$08
    JSR World3_QueuePpuBlock
    RTS

World3_ExpandNextRoomTileRow:
    JSR World3_ExpandRoomTileRow
    LDA World3RoomSmallBlockRowOffset
    EOR #$02
    STA World3RoomSmallBlockRowOffset
    BNE Bank2_Label_A966
    LDA World3RoomBigBlockRowOffset
    EOR #$02
    STA World3RoomBigBlockRowOffset
    BNE Bank2_Label_A966
    LDA World3RoomMapPointer
    CLC
    ADC #$40
    STA World3RoomMapPointer
    LDA World3RoomMapPointer+$01
    ADC #$00
    STA World3RoomMapPointer+$01

Bank2_Label_A966:
    RTS

World3_ExpandRoomTileRow:
    LDX #$00
    STX $01

Bank2_Label_A96B:
    LDA #$00
    STA $03
    LDY $01
    LDA (World3RoomMapPointer),Y
    ASL A
    ROL $03
    ASL A
    ROL $03
    CLC
    ADC #$F2
    STA $02
    LDA $03
    ADC #$E2
    STA $03
    LDA World3RoomBigBlockRowOffset
    STA $00
    JSR World3_AppendSmallBlockTilePair
    INC $00
    JSR World3_AppendSmallBlockTilePair
    JSR World3_UpdateRoomAttributeByte
    INC $01
    LDA $01
    CMP #$08
    BNE Bank2_Label_A96B
    RTS

World3_AppendSmallBlockTilePair:
    LDA #$00
    STA $05
    LDY $00
    LDA ($02),Y
    ASL A
    ROL $05
    ASL A
    ROL $05
    CLC
    ADC #$F2
    STA $04
    LDA $05
    ADC #$DE
    STA $05
    LDY World3RoomSmallBlockRowOffset
    LDA ($04),Y
    STA a:$04A0,X
    INX
    INY
    LDA ($04),Y
    STA a:$04A0,X
    INX
    RTS

World3_UpdateRoomAttributeByte:
    STX $3E
    LDY $00
    LDA ($02),Y
    TAX
    LDA a:$DDF2,X
    ASL A
    ASL A
    STA $3C
    DEY
    LDA ($02),Y
    TAX
    LDA a:$DDF2,X
    ORA $3C
    STA $3C
    ASL A
    ASL A
    ASL A
    ASL A
    STA $3D
    LDA World3RoomRenderRow
    AND #$FC
    ASL A
    CLC
    ADC $01
    TAY
    LDA World3RoomRenderRow
    AND #$02
    BNE Bank2_Label_A9FD
    LDA a:World3AttributeShadow,Y
    AND #$F0
    ORA $3C
    JMP Bank2_Label_AA04

Bank2_Label_A9FD:
    LDA a:World3AttributeShadow,Y
    AND #$0F
    ORA $3D

Bank2_Label_AA04:
    STA a:World3AttributeShadow,Y
    LDY $01
    STA a:$04C0,Y
    LDX $3E
    RTS

World3_AdvancePackedRateCounter:
    PHA
    AND #$0F
    STA World3PackedRateThreshold
    PLA
    CLC
    ADC #$10
    STA World3PackedRateCounterNext
    LSR A
    LSR A
    LSR A
    LSR A
    CMP World3PackedRateThreshold
    BNE Bank2_Label_AA26
    LDA World3PackedRateThreshold
    SEC
    RTS

Bank2_Label_AA26:
    LDA World3PackedRateCounterNext
    CLC
    RTS

World3_UpdateGiantOctopusTentacle:
    LDA World3PlayerX
    STA $00
    LDA World3PlayerY
    STA $01
    LDA #$00
    STA $04
    STX $02
    LDA a:World3EntityCollisionScanLimit,X
    SEC
    SBC $02
    STA $03
    LDA #$68
    STA World3OctopusTerminalAnchorY
    LDA $02
    CMP #$01
    BEQ Bank2_Label_AA4E
    LDA #$80
    STA World3OctopusTerminalAnchorY

Bank2_Label_AA4E:
    JSR World3_ConstrainGiantOctopusTentacleSegments
    RTS

World3_ConstrainGiantOctopusTentacleSegments:
    LDY #$F2
    LDA a:World3EntityX,X
    CMP $00
    BCS Bank2_Label_AA5D
    LDY #$0E

Bank2_Label_AA5D:
    TYA
    CLC
    ADC $00
    STA $08
    LDY #$F2
    LDA a:World3EntityY,X
    CMP $01
    BCS Bank2_Label_AA6E
    LDY #$0E

Bank2_Label_AA6E:
    TYA
    CLC
    ADC $01
    STA $09
    JSR World3_LoadNextEntityPosition
    INC $02
    DEC $03
    DEC $03

Bank2_Label_AA7D:
    JSR World3_LoadPreviousEntityPosition
    INC $02
    DEC $03
    BNE Bank2_Label_AA7D
    LDX $02
    LDA a:World3EntityState+$07,X
    STA $08
    LDA a:World3EntityX+$07,X
    STA $09
    LDA #$80
    STA $3E
    LDA World3OctopusTerminalAnchorY
    STA $3F
    JSR World3_UpdateTentacleSegmentPosition
    RTS

World3_LoadPreviousEntityPosition:
    LDX $02
    LDA a:World3EntityState+$07,X
    STA $08
    LDA a:World3EntityX+$07,X
    STA $09

World3_LoadNextEntityPosition:
    LDX $02
    LDA a:World3EntityX+$01,X
    STA $3E
    LDA a:World3EntityY+$01,X
    STA $3F

World3_UpdateTentacleSegmentPosition:
    LDX $02
    LDA a:World3EntityX,X
    STA $3C
    LDA a:World3EntityY,X
    STA $3D
    LDA a:World3EntityFrameCounter,X
    JSR World3_AdvancePackedRateCounter
    STA a:World3EntityFrameCounter,X
    BCC Bank2_Label_AAF0
    JSR World3_StepWorkPositionTowardNearestAnchor
    LDX $02
    LDA $3C
    SEC
    SBC $3E
    JSR World3_AbsoluteValue8
    STA $40
    LDA $3D
    SEC
    SBC $3F
    JSR World3_AbsoluteValue8
    STA $41
    LDA $3C
    STA a:World3EntityX,X
    LDA $3D
    STA a:World3EntityY,X

Bank2_Label_AAF0:
    RTS

World3_StepWorkPositionTowardNearestAnchor:
    LDA $3C
    SEC
    SBC $08
    JSR World3_AbsoluteValue8
    STA $40
    LDA $3C
    SEC
    SBC $3E
    JSR World3_AbsoluteValue8
    CMP $40
    BCS Bank2_Label_AB0F
    LDX $08
    JSR World3_StepWorkXTowardTarget
    JMP Bank2_Label_AB14

Bank2_Label_AB0F:
    LDX $3E
    JSR World3_StepWorkXTowardTarget

Bank2_Label_AB14:
    LDA $3D
    SEC
    SBC $09
    JSR World3_AbsoluteValue8
    STA $40
    LDA $3D
    SEC
    SBC $3F
    JSR World3_AbsoluteValue8
    CMP $40
    BCS Bank2_Label_AB32
    LDY $09
    JSR World3_StepWorkYTowardTarget
    JMP Bank2_Label_AB37

Bank2_Label_AB32:
    LDY $3F
    JSR World3_StepWorkYTowardTarget

Bank2_Label_AB37:
    SEC
    RTS
    .byte $18, $60
