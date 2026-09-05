; Doraemon PRG bank 0 $8D22-$8F9D
; World 1 persistent object masks, spawning, and entity-slot initialization
; Generated deterministically from pinned Ghidra/GhidraNes facts

World1_IsObjectSpawnSuppressed:
    LDA World1CurrentPlacementId
    AND #$07
    TAX
    LDA a:$8D9C,X
    STA $07
    LDA World1CurrentPlacementId
    LSR A
    LSR A
    LSR A
    TAX
    LDA a:World1ObjectSpawnMask,X
    AND $07
    STA $06
    LDA a:World1CollectedObjectBits,X
    AND $07
    ORA $06
    STA $06
    LDA $06
    RTS

World1_MarkObjectSpawned:
    STA $03
    TXA
    PHA
    LDA $03
    AND #$07
    TAX
    LDA a:$8D9C,X
    PHA
    LDA $03
    LSR A
    LSR A
    LSR A
    TAX
    PLA
    ORA a:World1ObjectSpawnMask,X
    STA a:World1ObjectSpawnMask,X
    PLA
    TAX
    RTS

World1_ReleaseObjectSpawn:
    STA $03
    TXA
    PHA
    LDA $03
    AND #$07
    TAX
    LDA a:$8D9C,X
    EOR #$FF
    PHA
    LDA $03
    LSR A
    LSR A
    LSR A
    TAX
    PLA
    AND a:World1ObjectSpawnMask,X
    STA a:World1ObjectSpawnMask,X
    PLA
    TAX
    RTS

World1_MarkObjectCollected:
    TXA
    PHA
    LDA $00
    AND #$07
    TAX
    LDA a:$8D9C,X
    PHA
    LDA $00
    LSR A
    LSR A
    LSR A
    TAX
    PLA
    ORA a:World1CollectedObjectBits,X
    STA a:World1CollectedObjectBits,X
    PLA
    TAX
    RTS
    .byte $80, $40, $20, $10, $08, $04, $02, $01

World1_EntitySpawnInitializerRtsTable:
    .byte $9F, $8E, $32, $DC, $9F, $8E, $9F, $8E, $9F, $8E, $9F, $8E, $16, $E0, $41, $E1
    .byte $9F, $8E, $40, $E2, $9F, $8E, $9F, $8E, $9F, $8E, $9F, $8E, $9F, $8E, $9F, $8E

World1_MaterializePlacement:
    PHA
    LDA World1PlacementXCell
    STA $06
    LDA World1PlacementYCell
    STA $07
    LDA World1CurrentPlacementId
    STA $03
    PLA
    TAY
    BMI Bank0_Label_8E27
    LDX #$00

Bank0_Label_8DD7:
    LDA a:World1EntityType,X
    BEQ Bank0_Label_8DE2
    INX
    CPX #$0A
    BNE Bank0_Label_8DD7
    RTS

Bank0_Label_8DE2:
    LDA World1CurrentPlacementId
    AND #$7F
    STA a:World1EntitySourceObjectId,X
    JSR World1_MarkObjectSpawned
    TYA
    STA a:World1EntityType,X
    INC a:World1EntityType,X
    LDA a:World1_EnemyInitialMetasprites,Y
    STA a:World1EntityMetasprite,X
    LDA a:World1_EnemyInitialRenderFlags,Y
    STA a:World1EntityRenderFlags,X
    LDA a:World1_EnemyInitialHealth,Y
    STA a:World1EntityHealthOrVelocity,X
    LDA #$00
    STA a:World1EntityPrimaryBehavior,X
    STA a:World1EntitySecondaryBehavior,X
    STA a:World1EntityDamageTimerOrAcceleration,X
    STA a:World1EntityActionCooldown,X
    STA a:World1EntityReservedBehavior,X
    TYA
    ASL A
    AND #$0F
    TAY
    JMP Bank0_Label_8E1E

Bank0_Label_8E1E:
    LDA a:$8DA5,Y
    PHA
    LDA a:$8DA4,Y
    PHA
    RTS

Bank0_Label_8E27:
    PHA
    JSR World1_FindFreeEntitySlot38_47
    BEQ Bank0_Label_8E2F
    PLA
    RTS

Bank0_Label_8E2F:
    PLA
    PHA
    ASL A
    ASL A
    AND #$3F
    TAY
    LDA a:World1_ObjectDescriptorTable,Y
    STA a:World1EntityType,X
    LDA a:World1_ObjectDescriptorMetaspriteField,Y
    STA a:World1EntityMetasprite,X
    BNE Bank0_Label_8E4C
    LDA $7B
    CLC
    ADC #$2A
    STA a:World1EntityMetasprite,X

Bank0_Label_8E4C:
    LDA a:World1_ObjectDescriptorRenderFlagsField,Y
    STA a:World1EntityRenderFlags,X
    PLA
    AND #$40
    BEQ Bank0_Label_8E5F
    LDA a:World1EntityType,X
    ORA #$80
    STA a:World1EntityType,X

Bank0_Label_8E5F:
    LDA World1CurrentPlacementId
    STA a:World1EntitySourceObjectId,X
    JSR World1_MarkObjectSpawned
    LDA a:World1_ObjectDescriptorPrimaryBehaviorField,Y
    STA a:World1EntityPrimaryBehavior,X
    JMP World1_InitializeEntityPosition

World1_EnemyInitialMetasprites:
    .byte $64, $5C, $56, $60, $58, $4C, $54, $70, $6C, $3E, $60, $58, $00, $00, $00, $00

World1_EnemyInitialRenderFlags:
    .byte $01, $01, $01, $02, $02, $02, $01, $02, $01, $01, $02, $02, $00, $00, $00, $00

World1_EnemyInitialHealth:
    .byte $02, $01, $02, $04, $01, $01, $02, $01, $02, $04, $04, $01, $00, $00, $00, $00

World1_InitializeEntityPosition:
    LDA #$00
    STA a:World1EntityPositionHigh,X
    LDA $07
    SEC
    SBC $5C
    ASL A
    ASL A
    ROL a:World1EntityPositionHigh,X
    ASL A
    ROL a:World1EntityPositionHigh,X
    STA $07
    LDA PpuScrollYShadow
    AND #$07
    EOR #$FF
    CLC
    ADC $07
    STA a:World1EntityY,X
    BCS Bank0_Label_8EC6
    DEC a:World1EntityPositionHigh,X

Bank0_Label_8EC6:
    LDA $06
    SEC
    SBC $5B
    ASL A
    ASL A
    ROL a:World1EntityPositionHigh,X
    ASL A
    ROL a:World1EntityPositionHigh,X
    STA $06
    LDA PpuScrollXShadow
    AND #$07
    EOR #$FF
    SEC
    ADC $06
    STA a:World1EntityX,X
    BCS Bank0_Label_8EF5
    LDA a:World1EntityPositionHigh,X
    TAY
    AND #$0C
    STA $08
    DEY
    TYA
    AND #$03
    ORA $08
    STA a:World1EntityPositionHigh,X

Bank0_Label_8EF5:
    RTS

Bank0_Func_8EF6:
    LDA $82
    BNE Bank0_Label_8F46
    LDX #$0A

Bank0_Label_8EFC:
    LDA a:World1EntityType,X
    BEQ Bank0_Label_8F41
    CMP #$01
    BEQ Bank0_Label_8F2A
    CMP #$02
    BEQ Bank0_Label_8F12
    JSR Bank0_Func_8F47
    JSR Bank0_Func_8F47
    JMP Bank0_Label_8F2D

Bank0_Label_8F12:
    JSR Bank0_Func_8F9E
    LDA a:World1EntityHealthOrVelocity,X
    BPL Bank0_Label_8F2D
    JSR Bank0_Func_9004
    BEQ Bank0_Label_8F37
    EOR #$FF
    SEC
    ADC #$01
    STA a:World1EntityHealthOrVelocity,X
    JMP Bank0_Label_8F37

Bank0_Label_8F2A:
    JSR Bank0_Func_8FC5

Bank0_Label_8F2D:
    JSR Bank0_Func_9004
    BEQ Bank0_Label_8F37
    LDA #$00
    STA a:World1EntityType,X

Bank0_Label_8F37:
    LDA a:World1EntityPositionHigh,X
    BEQ Bank0_Label_8F41
    LDA #$00
    STA a:World1EntityType,X

Bank0_Label_8F41:
    INX
    CPX #$1E
    BNE Bank0_Label_8EFC

Bank0_Label_8F46:
    RTS

Bank0_Func_8F47:
    LDA #$FF
    STA $95
    STA $96
    LDA a:World1EntityPrimaryBehavior,X
    TAY
    AND #$04
    BEQ Bank0_Label_8F59
    LDA #$01
    STA $95

Bank0_Label_8F59:
    TYA
    AND #$02
    BEQ Bank0_Label_8F62
    LDA #$01
    STA $96

Bank0_Label_8F62:
    TYA
    AND #$01
    BNE Bank0_Label_8F83
    LDA $95
    JSR World1_MoveEntityXByA
    LDA a:World1EntityHealthOrVelocity,X
    CLC
    ADC a:World1EntityDamageTimerOrAcceleration,X
    STA a:World1EntityHealthOrVelocity,X
    BPL Bank0_Label_8F82
    AND #$7F
    STA a:World1EntityHealthOrVelocity,X
    LDA $96
    JMP World1_MoveEntityYByA

Bank0_Label_8F82:
    RTS

Bank0_Label_8F83:
    LDA $96
    JSR World1_MoveEntityYByA
    LDA a:World1EntityHealthOrVelocity,X
    CLC
    ADC a:World1EntityDamageTimerOrAcceleration,X
    STA a:World1EntityHealthOrVelocity,X
    BPL Bank0_Label_8F82
    AND #$7F
    STA a:World1EntityHealthOrVelocity,X
    LDA $95
    JMP World1_MoveEntityXByA
