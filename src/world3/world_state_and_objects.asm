; Doraemon PRG bank 2 $875C-$8B67
; World 3 world-state progression, object spawning, and player interactions
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank2_Func_875C:
    STX $44
    STY $45
    LDA #$07
    STA $47
    LDA #$0D
    STA $48

Bank2_Label_8768:
    LDX #$0C
    LDY $47
    JSR World3_CalculateNametableAddress
    LDA #$00
    STA World3PpuQueueVerticalIncrement
    LDX #$87
    LDY #$87
    LDA #$12
    JSR World3_QueuePpuBlock
    INC $47
    DEC $48
    BNE Bank2_Label_8768
    LDX $44
    LDY $45
    RTS
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00

Bank2_Func_879B:
    LDA World3CurrentRoom
    CMP #$3C
    BEQ Bank2_Label_87A2
    RTS

Bank2_Label_87A2:
    LDA World3FinalCompanionsFreed
    BNE Bank2_Label_8816
    LDY #$00
    LDA #$03
    STA $3E

Bank2_Label_87AC:
    LDA a:World3EntityState,Y
    CMP #$01
    BNE Bank2_Label_87C0
    LDA a:World3EntityType,Y
    CMP #$1C
    BCC Bank2_Label_87C0
    CMP #$1F
    BCS Bank2_Label_87C0
    DEC $3E

Bank2_Label_87C0:
    INY
    CPY #$08
    BNE Bank2_Label_87AC
    LDA $3E
    BNE Bank2_Label_8816
    LDA #$04
    JSR World3_QueueEffectPreserveXY
    JSR World3_RunPaletteFlash
    JSR Bank2_Func_8817
    LDA #$01
    STA World3FinalCompanionsFreed
    LDY #$00

Bank2_Label_87DA:
    LDA a:World3EntityState,Y
    CMP #$01
    BNE Bank2_Label_87F1
    LDA a:World3EntityType,Y
    CMP #$1C
    BCC Bank2_Label_87F1
    CMP #$1F
    BCS Bank2_Label_87F1
    LDA #$00
    STA a:World3EntityState,Y

Bank2_Label_87F1:
    INY
    CPY #$08
    BNE Bank2_Label_87DA
    LDY #$00

Bank2_Label_87F8:
    LDA a:World3RoomObjectType,Y
    CMP #$1C
    BCC Bank2_Label_880D
    CMP #$1F
    BCS Bank2_Label_880D
    LDA #$23
    STA a:World3RoomObjectRoom,Y
    LDA #$00
    STA a:World3RoomObjectState,Y

Bank2_Label_880D:
    INY
    CPY #$0D
    BNE Bank2_Label_87F8
    LDA #$00
    STA World3FollowerActive

Bank2_Label_8816:
    RTS

Bank2_Func_8817:
    LDA World3CurrentRoom
    CMP #$3C
    BNE Bank2_Label_8847
    STX $44
    STY $45
    LDA #$14
    STA $47
    LDA #$08
    STA $48

Bank2_Label_8829:
    LDX #$14
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
    BNE Bank2_Label_8829
    LDX $44
    LDY $45

Bank2_Label_8847:
    RTS

Bank2_Func_8848:
    STX $5C
    LDA #$00
    STA $05
    LDA #$02
    STA $04

Bank2_Label_8852:
    LDY $05
    LDA a:World3PlayerProjectileState,Y
    CMP #$01
    BNE Bank2_Label_8868
    LDA a:World3PlayerProjectileX,Y
    STA $3C
    LDA a:World3PlayerProjectileY,Y
    STA $3D
    JSR Bank2_Func_886F

Bank2_Label_8868:
    INC $05
    DEC $04
    BNE Bank2_Label_8852

Bank2_Label_886E:
    RTS

Bank2_Func_886F:
    LDA a:World3EntityState,X
    CMP #$01
    BNE Bank2_Label_886E
    LDA a:World3EntityX,X
    SEC
    SBC $3C
    JSR World3_AbsoluteValue8
    CMP #$0D
    BCS Bank2_Label_886E
    LDA a:World3EntityY,X
    SEC
    SBC $3D
    JSR World3_AbsoluteValue8
    CMP #$0D
    BCS Bank2_Label_886E
    LDA a:World3EntityType,X
    CMP #$10
    BCS Bank2_Label_886E
    CMP #$05
    BEQ Bank2_Label_886E
    CMP #$06
    BEQ Bank2_Label_886E
    CMP #$07
    BEQ Bank2_Label_886E
    CMP #$02
    BNE Bank2_Label_88AD
    LDA World3CurrentRoom
    CMP #$3F
    BEQ Bank2_Label_886E

Bank2_Label_88AD:
    LDA #$02
    STA a:World3PlayerProjectileState,Y
    LDA #$00
    STA a:World3PlayerProjectileAnimationCounter,Y
    LDA #$A0
    STA a:World3PlayerProjectileMetasprite,Y
    LDA a:World3EntityType,X
    CMP #$04
    BNE Bank2_Label_88C6
    JSR Bank2_Func_9114

Bank2_Label_88C6:
    LDA a:World3EntityType,X
    CMP #$0A
    BEQ Bank2_Label_88D1
    CMP #$0B
    BNE Bank2_Label_88D6

Bank2_Label_88D1:
    LDA #$03
    JSR World3_QueueEffectPreserveXY

Bank2_Label_88D6:
    LDA a:World3EntityHitPoints,X
    BEQ Bank2_Label_886E
    LDA a:World3EntityType,X
    CMP #$0C
    BCC Bank2_Label_88E6
    CMP #$10
    BCC Bank2_Label_88EE

Bank2_Label_88E6:
    LDA a:World3EntityX,X
    EOR #$04
    STA a:World3EntityX,X

Bank2_Label_88EE:
    DEC a:World3EntityHitPoints,X
    BNE Bank2_Label_896C
    LDA a:World3EntityType,X
    CMP #$08
    BNE Bank2_Label_8939
    LDA #$01
    STA a:AudioMusicControl
    LDA #$04
    JSR World3_QueueEffectPreserveXY
    LDA #$28
    STA World3BossMusicRestoreDelay
    JSR World3_RunPaletteFlash
    JSR World3_DefeatActiveCombatEntities
    JSR Bank2_Func_875C
    LDA World3CurrentRoom
    CMP #$27
    BEQ Bank2_Label_8924
    CMP #$28
    BEQ Bank2_Label_892B
    CMP #$34
    BEQ Bank2_Label_8932
    LDA #$00
    JMP Bank2_Func_AF51

Bank2_Label_8924:
    LDA #$01
    STA World3BossRoom27Defeated
    JMP Bank2_Label_895C

Bank2_Label_892B:
    LDA #$01
    STA World3BossRoom28Defeated
    JMP Bank2_Label_895C

Bank2_Label_8932:
    LDA #$01
    STA World3BossRoom34Defeated
    JMP Bank2_Label_895C

Bank2_Label_8939:
    LDA a:World3EntityType,X
    CMP #$0C
    BCC Bank2_Label_895C
    CMP #$10
    BCS Bank2_Label_895C
    LDA #$01
    STA a:AudioMusicControl
    LDA #$04
    JSR World3_QueueEffectPreserveXY
    LDA #$28
    STA World3BossMusicRestoreDelay
    JSR World3_RunPaletteFlash
    JSR World3_DefeatActiveCombatEntities
    LDA #$46
    STA World3ChapterCompletionDelay

Bank2_Label_895C:
    LDX $5C
    JSR Bank2_Func_897C
    LDA a:World3EntityType,X
    TAY
    LDA a:World3_EntityScoreRewardCodeByType,Y
    JSR Bank2_Func_898C
    RTS

Bank2_Label_896C:
    LDA #$03
    JSR World3_QueuePriorityEffectPreserveXY
    RTS

Bank2_Func_8972:
    TXA
    PHA
    TYA
    TAX
    JSR Bank2_Func_897C
    PLA
    TAX
    RTS

Bank2_Func_897C:
    LDA #$05
    STA a:World3EntityState,X
    LDA #$6C
    STA a:World3EntityMetasprite,X
    LDA #$05
    JSR World3_QueuePriorityEffectPreserveXY
    RTS

Bank2_Func_898C:
    STX $5B
    LDX $07
    STX $5D
    LDX World3AttractModeActive
    BNE Bank2_Label_8999
    JSR World3_AddEncodedScore

Bank2_Label_8999:
    LDX $5D
    STX $07
    LDX $5B
    RTS

Bank2_Label_89A0:
    RTS

Bank2_Func_89A1:
    LDA a:World3EntityState,X
    CMP #$01
    BNE Bank2_Label_89A0
    LDA a:World3EntityX,X
    SEC
    SBC World3PlayerX
    JSR World3_AbsoluteValue8
    CMP #$0D
    BCS Bank2_Label_89A0
    LDA a:World3EntityY,X
    SEC
    SBC #$04
    SEC
    SBC World3PlayerY
    JSR World3_AbsoluteValue8
    CMP #$11
    BCS Bank2_Label_89A0
    LDA a:World3EntityType,X
    CMP #$06
    BNE Bank2_Label_89EA
    LDA a:World3EntityMetasprite,X
    CMP #$20
    BEQ Bank2_Label_89E7
    JSR Bank2_Func_897C
    LDA a:World3EntityType,X
    TAY
    LDA a:World3_EntityScoreRewardCodeByType,Y
    JSR Bank2_Func_898C
    LDA World3PunishmentDorayakiRemaining
    BEQ Bank2_Label_89E6
    DEC World3PunishmentDorayakiRemaining

Bank2_Label_89E6:
    RTS

Bank2_Label_89E7:
    JMP Bank2_Label_8AEC

Bank2_Label_89EA:
    CMP #$07
    BNE Bank2_Label_8A28
    LDA #$0A
    JSR World3_QueueEffectPreserveXY
    JSR World3_RunPaletteFlash
    JSR Bank2_Func_897C
    LDA a:World3EntityType,X
    TAY
    LDA a:World3_EntityScoreRewardCodeByType,Y
    JSR Bank2_Func_898C
    LDA #$0E
    JSR World3_QueueEffectPreserveXY
    LDA World3CurrentRoom
    CMP #$26
    BEQ Bank2_Label_8A17
    CMP #$3B
    BEQ Bank2_Label_8A1C
    LDA #$01
    JMP Bank2_Func_AF51

Bank2_Label_8A17:
    INC $56
    JMP Bank2_Label_8A1E

Bank2_Label_8A1C:
    INC $57

Bank2_Label_8A1E:
    LDA PlayerHealthCapacityIndex
    BEQ Bank2_Label_8A27
    DEC PlayerHealthCapacityIndex
    JSR Bank2_Func_A213

Bank2_Label_8A27:
    RTS

Bank2_Label_8A28:
    CMP #$18
    BCC Bank2_Label_8A60
    JSR World3_ReadActivePlayerButtons
    AND #$40
    BNE Bank2_Label_8A36
    STA $62

Bank2_Label_8A35:
    RTS

Bank2_Label_8A36:
    LDA $62
    BNE Bank2_Label_8A35
    LDA World3FollowerActive
    BNE Bank2_Label_8A48
    LDA #$01
    STA World3FollowerActive
    STA a:World3EntityPersistentState,X
    JMP Bank2_Label_8A54

Bank2_Label_8A48:
    LDA a:World3EntityPersistentState,X
    BEQ Bank2_Label_8A5B
    LDA #$00
    STA World3FollowerActive
    STA a:World3EntityPersistentState,X

Bank2_Label_8A54:
    INC $62
    LDA #$08
    JSR World3_QueueEffectPreserveXY

Bank2_Label_8A5B:
    RTS

Bank2_Label_8A5C:
    RTS

Bank2_Label_8A5D:
    JMP Bank2_Label_8AEC

Bank2_Label_8A60:
    CMP #$10
    BCC Bank2_Label_8A5D
    CMP #$14
    BCS Bank2_Label_8A5C
    CMP #$10
    BNE Bank2_Label_8A87
    JSR Bank2_Func_897C
    LDA a:World3EntityType,X
    TAY
    LDA a:World3_EntityScoreRewardCodeByType,Y
    JSR Bank2_Func_898C
    LDA #$01
    STA World3StopwatchActive
    LDA #$00
    STA World3StopwatchTimer
    LDA #$01
    STA a:AudioMusicControl
    RTS

Bank2_Label_8A87:
    CMP #$11
    BNE Bank2_Label_8AB7
    JSR Bank2_Func_897C
    LDA a:World3EntityType,X
    TAY
    LDA a:World3_EntityScoreRewardCodeByType,Y
    JSR Bank2_Func_898C
    LDA #$0E
    JSR World3_QueueEffectPreserveXY
    LDA #$08
    SEC
    SBC PlayerHealthCapacityIndex
    ASL A
    ASL A
    STA $3E
    LDA #$10
    STA $3F

Bank2_Label_8AAA:
    LDA PlayerHealth
    CMP $3E
    BEQ Bank2_Label_8AB6
    INC PlayerHealth
    DEC $3F
    BNE Bank2_Label_8AAA

Bank2_Label_8AB6:
    RTS

Bank2_Label_8AB7:
    CMP #$12
    BNE Bank2_Label_8AD7
    JSR Bank2_Func_897C
    LDA a:World3EntityType,X
    TAY
    LDA a:World3_EntityScoreRewardCodeByType,Y
    JSR Bank2_Func_898C
    LDA #$13
    JSR World3_QueueEffectPreserveXY
    INC World3TreasurePenaltyCounter
    JSR World3_DefeatActiveCombatEntities
    LDA #$04
    STA $A4
    RTS

Bank2_Label_8AD7:
    JSR Bank2_Func_897C
    LDA a:World3EntityType,X
    TAY
    LDA a:World3_EntityScoreRewardCodeByType,Y
    JSR Bank2_Func_898C
    LDA #$0E
    JSR World3_QueueEffectPreserveXY
    INC World3TreasurePenaltyCounter
    RTS

Bank2_Label_8AEC:
    LDA World3PlayerState
    CMP #$01
    BNE Bank2_Label_8B67
    LDA World3StopwatchActive
    BNE Bank2_Label_8B67
    LDA a:World3EntityType,X
    TAY
    CMP #$05
    BEQ Bank2_Label_8B67
    LDA PlayerHealth
    SEC
    SBC a:World3_EntityContactDamageByType,Y
    BCS Bank2_Label_8B08
    LDA #$00

Bank2_Label_8B08:
    STA PlayerHealth
    LDA PlayerHealth
    BNE Bank2_Label_8B4E
    LDA #$04
    STA World3PlayerState
    LDA #$0B
    STA World3PlayerMetaspriteBase
    LDA #$00
    STA World3PlayerAnimationFrame
    LDA #$00
    STA $93
    LDA #$00
    STA $97
    LDA #$00
    STA World3FollowerActive
    LDA World3PlayerX
    STA $4B
    LDA World3PlayerY
    STA $4C
    JSR World3_SaveRoomObjectsState0
    JSR World3_SaveRoomObjectsState1
    LDY #$00

Bank2_Label_8B36:
    LDA #$00
    STA a:World3RoomObjectState,Y
    INY
    CPY #$0D
    BNE Bank2_Label_8B36
    LDA #$00
    STA a:World3PlayerProjectileState
    STA a:World3PlayerProjectileState+$01
    LDA #$08
    STA a:AudioMusicState
    RTS

Bank2_Label_8B4E:
    LDA #$03
    STA World3PlayerState
    LDA #$00
    STA $9B
    LDA #$0B
    STA World3PlayerMetaspriteBase
    LDA #$00
    STA World3PlayerAnimationFrame
    LDA #$00
    STA $93
    LDA #$0F
    JSR World3_QueueEffectPreserveXY

Bank2_Label_8B67:
    RTS
