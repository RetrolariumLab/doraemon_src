; Doraemon PRG bank 2 $968C-$9A3A
; World 3 later entity-type collision, reward, and interaction handlers
; Generated deterministically from pinned Ghidra/GhidraNes facts

World3_UpdateType0FPoseidonLowerRight:
    LDA a:World3EntityFollowAnchorFlag,X
    BEQ Bank2_Label_96BF
    JSR World3_FindActivePoseidonAnchor
    LDA a:World3EntityX,Y
    CLC
    ADC #$10
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

Bank2_Label_96BF:
    RTS

World3_FindActivePoseidonAnchor:
    LDY #$00

Bank2_Label_96C2:
    LDA a:World3EntityState,Y
    CMP #$01
    BNE Bank2_Label_96D0
    LDA a:World3EntityType,Y
    CMP #$0C
    BEQ Bank2_Label_96D5

Bank2_Label_96D0:
    INY
    CPY #$08
    BNE Bank2_Label_96C2

Bank2_Label_96D5:
    RTS

World3_UpdateTypes10To16:
    RTS

World3_UpdateType17DragonChest:
    RTS

World3_UpdateType18Talisman:
    LDA a:World3EntityState,X
    CMP #$04
    BNE Bank2_Label_96E3
    JSR World3_FollowActiveGhost
    RTS

Bank2_Label_96E3:
    JSR World3_PositionEnabledPersistentEntity
    LDA a:World3EntityPersistentState,X
    BEQ Bank2_Label_9700
    LDY #$00

Bank2_Label_96ED:
    LDA a:World3EntityState,Y
    CMP #$01
    BNE Bank2_Label_96FB
    LDA a:World3EntityType,Y
    CMP #$0A
    BEQ Bank2_Label_9701

Bank2_Label_96FB:
    INY
    CPY #$08
    BNE Bank2_Label_96ED

Bank2_Label_9700:
    RTS

Bank2_Label_9701:
    LDA a:World3EntityX,X
    SEC
    SBC a:World3EntityX,Y
    JSR World3_AbsoluteValue8
    CMP #$0D
    BCS Bank2_Label_9700
    LDA a:World3EntityY,X
    SEC
    SBC a:World3EntityY,Y
    JSR World3_AbsoluteValue8
    CMP #$0D
    BCS Bank2_Label_9700

Bank2_Label_971D:
    JSR Bank2_Func_8972
    INY
    CPY #$08
    BEQ Bank2_Label_972C
    LDA a:World3EntityType,Y
    CMP #$0B
    BEQ Bank2_Label_971D

Bank2_Label_972C:
    LDY #$00

Bank2_Label_972E:
    LDA a:World3EncounterRoomList,Y
    CMP World3CurrentRoom
    BNE Bank2_Label_973A
    LDA #$FF
    STA a:World3EncounterRoomList,Y

Bank2_Label_973A:
    INY
    CPY #$08
    BNE Bank2_Label_972E
    LDA #$01
    STA a:AudioMusicControl
    LDA #$04
    JSR World3_QueueEffectPreserveXY
    LDA #$28
    STA World3BossMusicRestoreDelay
    JSR World3_RunPaletteFlash
    LDY #$0A
    LDA a:World3_EntityScoreRewardCodeByType,Y
    JSR Bank2_Func_898C
    RTS

World3_UpdateType19PassingHoop:
    LDA a:World3EntityState,X
    CMP #$04
    BNE Bank2_Label_9764
    JSR World3_FollowActiveGhost
    RTS

Bank2_Label_9764:
    JSR World3_PositionEnabledPersistentEntity
    LDA a:World3EntityPersistentState,X
    BEQ Bank2_Label_97AE
    LDA World3PassingHoopPortalActive
    BNE Bank2_Label_97AE
    STX $44
    LDA a:World3EntityY,X
    CLC
    ADC #$07
    TAY
    LDA a:World3EntityX,X
    CLC
    ADC #$07
    TAX
    JSR Bank2_Func_A0C4
    CMP #$26
    BCC Bank2_Label_97AC
    CMP #$2A
    BCS Bank2_Label_97AC
    LDA World3CurrentRoom
    CMP #$3C
    BEQ Bank2_Label_97AC
    CMP #$27
    BEQ Bank2_Label_97AC
    CMP #$28
    BEQ Bank2_Label_97AC
    CMP #$34
    BEQ Bank2_Label_97AC
    LDA #$13
    JSR World3_QueueEffectPreserveXY
    JSR World3_RunPaletteFlash
    JSR Bank2_Func_97AF
    LDA #$01
    STA World3PassingHoopPortalActive

Bank2_Label_97AC:
    LDX $44

Bank2_Label_97AE:
    RTS

Bank2_Func_97AF:
    LDA #$00
    STA World3PassingHoopBoundaryPresent
    LDX #$00
    LDY #$60
    STX $46
    STY $47
    JSR Bank2_Func_A0C4
    CMP #$26
    BNE Bank2_Label_97CA
    JSR Bank2_Func_97E2
    LDA #$01
    STA World3PassingHoopBoundaryPresent
    RTS

Bank2_Label_97CA:
    LDX #$E0
    LDY #$60
    STX $46
    STY $47
    JSR Bank2_Func_A0C4
    CMP #$26
    BNE Bank2_Label_97E1
    JSR Bank2_Func_97E2
    LDA #$01
    STA World3PassingHoopBoundaryPresent
    RTS

Bank2_Label_97E1:
    RTS

Bank2_Func_97E2:
    LDA $46
    LSR A
    LSR A
    LSR A
    STA $46
    LDA $47
    LSR A
    LSR A
    LSR A
    STA $47
    LDA #$08
    STA $48

Bank2_Label_97F4:
    LDX $46
    LDY $47
    JSR World3_CalculateNametableAddress
    LDA #$00
    STA World3PpuQueueVerticalIncrement
    LDX #$0F
    LDY #$98
    LDA #$04
    JSR World3_QueuePpuBlock
    INC $47
    DEC $48
    BNE Bank2_Label_97F4
    RTS
    .byte $00, $00, $00, $00

World3_UpdateType1AKey:
    LDA a:World3EntityState,X
    CMP #$04
    BNE Bank2_Label_981E
    JSR World3_FollowActiveGhost
    RTS

Bank2_Label_981E:
    JSR World3_PositionEnabledPersistentEntity
    LDA a:World3EntityPersistentState,X
    BEQ Bank2_Label_985B
    LDY #$00

Bank2_Label_9828:
    LDA a:World3EntityState,Y
    CMP #$01
    BNE Bank2_Label_9856
    LDA a:World3EntityType,Y
    CMP #$14
    BCC Bank2_Label_9856
    CMP #$18
    BCS Bank2_Label_9856
    LDA a:World3EntityX,X
    SEC
    SBC a:World3EntityX,Y
    JSR World3_AbsoluteValue8
    CMP #$0D
    BCS Bank2_Label_9856
    LDA a:World3EntityY,X
    SEC
    SBC a:World3EntityY,Y
    JSR World3_AbsoluteValue8
    CMP #$0D
    BCC Bank2_Label_985C

Bank2_Label_9856:
    INY
    CPY #$08
    BNE Bank2_Label_9828

Bank2_Label_985B:
    RTS

Bank2_Label_985C:
    LDA #$0A
    JSR World3_QueueEffectPreserveXY
    JSR World3_RunPaletteFlash
    LDA a:World3EntityType,Y
    CMP #$17
    BEQ Bank2_Label_9895
    STX $3E
    LDX #$00

Bank2_Label_986F:
    CMP a:World3RoomObjectType,X
    BEQ Bank2_Label_987E
    INX
    CPX #$0D
    BNE Bank2_Label_986F
    LDA #$05
    JMP Bank2_Func_AF51

Bank2_Label_987E:
    CLC
    ADC #$08
    STA a:World3RoomObjectType,X
    STA a:World3EntityType,Y
    TAX
    LDA a:World3_EntityMetaspriteByType,X
    STA a:World3EntityMetasprite,Y
    LDA #$00
    STA World3TreasurePenaltyCounter
    LDX $3E
    RTS

Bank2_Label_9895:
    LDA #$00
    STA a:World3EntityState,Y
    LDA a:World3EntityType,Y
    STA $3E
    LDY #$00

Bank2_Label_98A1:
    LDA a:World3RoomObjectRoom,Y
    CMP World3CurrentRoom
    BNE Bank2_Label_98AF
    LDA a:World3RoomObjectType,Y
    CMP $3E
    BEQ Bank2_Label_98B3

Bank2_Label_98AF:
    INY
    JMP Bank2_Label_98A1

Bank2_Label_98B3:
    LDA #$FF
    STA a:World3RoomObjectRoom,Y
    LDY #$00

Bank2_Label_98BA:
    LDA a:World3EncounterRoomList,Y
    CMP #$FF
    BEQ Bank2_Label_98C5
    INY
    JMP Bank2_Label_98BA

Bank2_Label_98C5:
    LDA World3CurrentRoom
    STA a:World3EncounterRoomList,Y
    JSR World3_FindFreeEntitySlot
    BCC Bank2_Label_98E2
    LDA a:World3EntityX,X
    SEC
    SBC #$78
    STA $C9
    LDA a:World3EntityY,X
    SEC
    SBC #$78
    STA $CA
    JSR Bank2_Func_AC1F

Bank2_Label_98E2:
    RTS

World3_UpdateType1BHoldingBag:
    LDA a:World3EntityState,X
    CMP #$04
    BNE Bank2_Label_98EE
    JSR World3_FollowActiveGhost
    RTS

Bank2_Label_98EE:
    JSR World3_PositionEnabledPersistentEntity
    LDA a:World3EntityPersistentState,X
    BEQ Bank2_Label_9962
    LDA a:World3EntityY,X
    CMP #$F8
    BEQ Bank2_Label_9962
    LDY #$00

Bank2_Label_98FF:
    LDA a:World3EntityState,Y
    CMP #$01
    BNE Bank2_Label_995D
    LDA a:World3EntityType,Y
    CMP #$18
    BCC Bank2_Label_995D
    CMP #$1B
    BEQ Bank2_Label_995D
    CMP #$1F
    BEQ Bank2_Label_995D
    LDA a:World3EntityX,X
    STA $40
    LDA a:World3EntityY,X
    STA $41
    LDA a:World3EntityX,Y
    STA $3C
    LDA a:World3EntityY,Y
    STA $3D
    STX $3E
    STY $3F
    LDX $40
    LDY $41
    LDA $3C
    SEC
    SBC $40
    JSR World3_AbsoluteValue8
    CMP #$0F
    BCC Bank2_Label_9940
    JSR Bank2_Func_AB3B

Bank2_Label_9940:
    LDA $3D
    SEC
    SBC $41
    JSR World3_AbsoluteValue8
    CMP #$0F
    BCC Bank2_Label_994F
    JSR Bank2_Func_AB47

Bank2_Label_994F:
    LDX $3E
    LDY $3F
    LDA $3C
    STA a:World3EntityX,Y
    LDA $3D
    STA a:World3EntityY,Y

Bank2_Label_995D:
    INY
    CPY #$08
    BNE Bank2_Label_98FF

Bank2_Label_9962:
    RTS

World3_PositionEnabledPersistentEntity:
    LDA a:World3EntityPersistentState,X
    BEQ Bank2_Label_9998
    LDA $95
    ASL A
    STA a:World3EntityMetaspriteVariantBit1,X
    LDY #$F4
    LDA $95
    BEQ Bank2_Label_9976
    LDY #$0C

Bank2_Label_9976:
    TYA
    CLC
    ADC World3PlayerX
    STA a:World3EntityX,X
    CMP #$F4
    BCC Bank2_Label_9986
    LDA World3PlayerX
    STA a:World3EntityX,X

Bank2_Label_9986:
    INC a:World3EntityVerticalDirection,X
    LDA a:World3EntityVerticalDirection,X
    LSR A
    AND #$02
    CLC
    ADC #$04
    CLC
    ADC World3PlayerY
    STA a:World3EntityY,X

Bank2_Label_9998:
    RTS

World3_UpdateTypes1CTo1FCompanions:
    LDA a:World3EntityState,X
    CMP #$04
    BNE Bank2_Label_99A4
    JSR World3_FollowActiveGhost
    RTS

Bank2_Label_99A4:
    LDY #$00
    LDA a:World3EntityX,X
    CMP World3PlayerX
    BCS Bank2_Label_99AF
    LDY #$02

Bank2_Label_99AF:
    TYA
    STA a:World3EntityMetaspriteVariantBit1,X
    INC a:World3EntityFrameCounter,X
    LDA a:World3EntityFrameCounter,X
    AND #$07
    BNE Bank2_Label_99C5
    LDA a:World3EntityMetaspriteVariantBit0,X
    EOR #$01
    STA a:World3EntityMetaspriteVariantBit0,X

Bank2_Label_99C5:
    STX $3E
    LDA a:World3EntityPersistentState,X
    BEQ Bank2_Label_9A02
    LDA a:World3EntityX,X
    STA $3C
    LDA a:World3EntityY,X
    STA $3D
    LDX World3PlayerX
    LDY World3PlayerY
    TXA
    SEC
    SBC $3C
    JSR World3_AbsoluteValue8
    CMP #$0D
    BCC Bank2_Label_99E8
    JSR Bank2_Func_AB3B

Bank2_Label_99E8:
    TYA
    SEC
    SBC $3D
    JSR World3_AbsoluteValue8
    CMP #$0D
    BCC Bank2_Label_99F6
    JSR Bank2_Func_AB47

Bank2_Label_99F6:
    LDX $3E
    LDA $3C
    STA a:World3EntityX,X
    LDA $3D
    STA a:World3EntityY,X

Bank2_Label_9A02:
    LDX $3E
    RTS

World3_FollowActiveGhost:
    LDY #$00

Bank2_Label_9A07:
    LDA a:World3EntityState,Y
    CMP #$01
    BNE Bank2_Label_9A15
    LDA a:World3EntityType,Y
    CMP #$05
    BEQ Bank2_Label_9A1B

Bank2_Label_9A15:
    INY
    CPY #$08
    BNE Bank2_Label_9A07
    RTS

Bank2_Label_9A1B:
    INC a:World3EntityFrameCounter,X
    LDA a:World3EntityFrameCounter,X
    LSR A
    AND #$02
    CLC
    ADC a:World3EntityX,Y
    STA a:World3EntityX,X
    LDA #$10
    CLC
    ADC a:World3EntityY,Y
    STA a:World3EntityY,X
    RTS

World3_DormantDeactivateEntity:
    LDA #$00
    STA a:World3EntityState,X

Bank2_Label_9A3A:
    RTS
