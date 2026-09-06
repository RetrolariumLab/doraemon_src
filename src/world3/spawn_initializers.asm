; Doraemon PRG bank 2 $8F55-$9191
; World 3 random-spawn initializer dispatch and handlers
; Generated deterministically from pinned Ghidra/GhidraNes facts

World3_InitializeSpawnedEntity:
    LDA #$00
    STA a:World3EntityBehaviorSelector,X
    LDA World3TransientSpawnWorkType
    ASL A
    TAY
    LDA a:World3_SpawnInitializerTable,Y
    STA $40
    LDA a:$8F6D,Y
    STA $41
    JSR World3_CallIndirect
    RTS

World3_SpawnInitializerTable:
    .byte $8C, $8F, $A3, $8F, $BF, $8F, $DB, $8F, $28, $90, $2E, $90, $2F, $90, $44, $90
    .byte $71, $90, $AA, $90, $AB, $90, $AE, $90, $AF, $90, $B2, $90, $B2, $90, $B2, $90

World3_InitTransientType00TurtleOrBattleFish:
    LDA World3CurrentRoom
    CMP #$10
    BCC Bank2_Label_8FA2
    CMP #$28
    BCS Bank2_Label_8F9D
    JSR World3_RandomByte
    AND #$01
    BNE Bank2_Label_8FA2

Bank2_Label_8F9D:
    LDA #$A4
    STA a:World3EntityMetasprite,X

Bank2_Label_8FA2:
    RTS

World3_InitTransientType01CrabOrSeahorse:
    LDA World3CurrentRoom
    CMP #$18
    BCC Bank2_Label_8FBE
    CMP #$30
    BCS Bank2_Label_8FB4
    JSR World3_RandomByte
    AND #$01
    BNE Bank2_Label_8FBE

Bank2_Label_8FB4:
    LDA #$A8
    STA a:World3EntityMetasprite,X
    LDA #$01
    STA a:World3EntityRenderFlags,X

Bank2_Label_8FBE:
    RTS

World3_InitTransientType02VolcanicRock:
    LDA #$80
    STA a:World3EntityX,X
    LDA #$98
    STA a:World3EntityY,X
    LDA #$01
    STA a:World3EntityState,X
    JSR World3_RandomByte
    AND #$40
    BEQ Bank2_Label_8FDA
    LDA #$09
    JSR World3_QueueEffectPreserveXY

Bank2_Label_8FDA:
    RTS

World3_InitTransientType03GyokkunOrGansuke:
    LDY World3CurrentRoom
    LDA a:World3_Type03GansukeMetaspriteByRoom,Y
    BEQ Bank2_Label_8FE7
    LDA #$B4
    STA a:World3EntityMetasprite,X

Bank2_Label_8FE7:
    RTS

World3_Type03GansukeMetaspriteByRoom:
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01
    .byte $00, $00, $00, $00, $00, $01, $01, $01, $00, $00, $00, $00, $00, $01, $01, $01

World3_InitTransientType04Skull:
    LDA #$01
    STA a:World3EntityBehaviorSelector,X
    RTS

World3_InitTransientType05Ghost:
    RTS

World3_InitTransientType06PunishmentRoomSwarm:
    JSR World3_RandomByte
    CMP #$64
    BCS Bank2_Label_9043
    LDA #$20
    STA a:World3EntityMetasprite,X
    JSR World3_RandomByte
    AND #$02
    STA a:World3EntityMetaspriteVariantBit1,X

Bank2_Label_9043:
    RTS

World3_InitTransientType07GenkiCandy:
    LDA World3CurrentRoom
    CMP #$26
    BNE Bank2_Label_9051
    LDA $56
    BNE Bank2_Label_906B
    JMP Bank2_Label_905B

Bank2_Label_9051:
    LDA World3CurrentRoom
    CMP #$3B
    BNE Bank2_Label_9070
    LDA $57
    BNE Bank2_Label_906B

Bank2_Label_905B:
    LDA #$B0
    STA a:World3EntityX,X
    LDA #$A8
    STA a:World3EntityY,X
    LDA #$01
    STA a:World3EntityState,X
    RTS

Bank2_Label_906B:
    LDA #$00
    STA a:World3EntityState,X

Bank2_Label_9070:
    RTS

World3_InitTransientType08GiantOctopus:
    LDA World3CurrentRoom
    CMP #$27
    BEQ Bank2_Label_9084
    CMP #$28
    BEQ Bank2_Label_908B
    CMP #$34
    BEQ Bank2_Label_9092
    LDA #$03
    JMP Bank2_Func_AF51

Bank2_Label_9084:
    LDA World3BossRoom27Defeated
    BEQ Bank2_Label_9099
    JMP Bank2_Label_90A4

Bank2_Label_908B:
    LDA World3BossRoom28Defeated
    BEQ Bank2_Label_9099
    JMP Bank2_Label_90A4

Bank2_Label_9092:
    LDA World3BossRoom34Defeated
    BEQ Bank2_Label_9099
    JMP Bank2_Label_90A4

Bank2_Label_9099:
    JSR World3_CreateGiantOctopusFormationTypes08To09
    BCC Bank2_Label_90A4
    LDA #$03
    STA a:AudioMusicState
    RTS

Bank2_Label_90A4:
    LDA #$00
    STA a:World3EntityState,X
    RTS

World3_InitTransientType09OctopusSegment:
    RTS

World3_InitTransientType0ADragon:
    JSR World3_CreateDragonFormationTypes0ATo0B

World3_InitTransientType0BDragonSegment:
    RTS

World3_InitTransientType0CPoseidon:
    JSR World3_CreatePoseidonFormationTypes0CTo0F

World3_InitTransientTypes0DTo0F:
    RTS

World3_CreatePoseidonFormationTypes0CTo0F:
    LDY #$00
    JMP Bank2_Label_90BD

Bank2_Label_90B8:
    JSR World3_FindFreeEntitySlot
    BCC Bank2_Label_90F3

Bank2_Label_90BD:
    JSR World3_ClearEntitySlot
    LDA a:World3_PoseidonFormationState,Y
    STA a:World3EntityState,X
    LDA a:World3_PoseidonFormationX,Y
    STA a:World3EntityX,X
    LDA a:World3_PoseidonFormationY,Y
    STA a:World3EntityY,X
    LDA a:World3_PoseidonFormationType,Y
    STA a:World3EntityType,X
    STY $42
    TAY
    LDA a:World3_EntityMetaspriteByType,Y
    STA a:World3EntityMetasprite,X
    LDY $42
    LDA #$1E
    STA a:World3EntityActivationTimer,X
    LDA a:$8EC1
    STA a:World3EntityHitPoints,X
    INY
    CPY #$04
    BNE Bank2_Label_90B8

Bank2_Label_90F3:
    RTS

World3_PoseidonFormationState:
    .byte $03, $03, $03, $03

World3_PoseidonFormationX:
    .byte $28, $D8, $28, $D8

World3_PoseidonFormationY:
    .byte $30, $30, $C0, $C0

World3_PoseidonFormationType:
    .byte $0C, $0D, $0E, $0F

World3_FindFreeEntitySlot:
    LDX #$00

Bank2_Label_9106:
    LDA a:World3EntityState,X
    BEQ Bank2_Label_9112
    INX
    CPX #$08
    BNE Bank2_Label_9106
    CLC
    RTS

Bank2_Label_9112:
    SEC
    RTS

Bank2_Func_9114:
    STX $3C
    JSR World3_FindFreeEntitySlot
    BCS Bank2_Label_911F

Bank2_Label_911B:
    LDX $3C
    CLC
    RTS

Bank2_Label_911F:
    JSR World3_ClearEntitySlot
    TXA
    TAY
    LDX $3C
    LDA a:World3EntityBehaviorSelector,X
    BEQ Bank2_Label_911B
    LSR A
    STA a:World3EntityBehaviorSelector,X
    LDA #$01
    STA a:World3EntityState,Y
    JSR World3_RandomByte
    AND #$08
    SEC
    SBC #$04
    CLC
    ADC a:World3EntityX,X
    STA a:World3EntityX,Y
    JSR World3_RandomByte
    AND #$08
    SEC
    SBC #$04
    CLC
    ADC a:World3EntityY,X
    STA a:World3EntityY,Y
    LDA a:World3EntityMetasprite,X
    STA a:World3EntityMetasprite,Y
    LDA a:World3EntityRenderFlags,X
    STA a:World3EntityRenderFlags,Y
    LDA a:World3EntityType,X
    STA a:World3EntityType,Y
    LDA a:World3EntityScriptOffset,X
    STA a:World3EntityScriptOffset,Y
    LDA a:World3EntityScriptWaitTimer,X
    STA a:World3EntityScriptWaitTimer,Y
    LDA a:World3EntityHorizontalDirection,X
    STA a:World3EntityHorizontalDirection,Y
    LDA a:World3EntityVerticalDirection,X
    STA a:World3EntityVerticalDirection,Y
    LDA a:World3EntityScriptRateCounter,X
    STA a:World3EntityScriptRateCounter,Y
    LDA a:World3EntityBehaviorSelector,X
    STA a:World3EntityBehaviorSelector,Y
    LDA a:$8EB9
    STA a:World3EntityHitPoints,Y
    LDX $3C
    SEC
    RTS
