; Doraemon PRG bank 0 $C92F-$CB60
; World 1 city object state initialization and interaction handlers
; Generated deterministically from pinned Ghidra/GhidraNes facts

World1_ClearWorkingScoreUnlessDemo:
    LDA DemoModeActive
    BNE Bank0_Label_C93D
    LDX #$07
    LDA #$00

Bank0_Label_C937:
    STA a:ScoreDigitsWorking,X
    DEX
    BPL Bank0_Label_C937

Bank0_Label_C93D:
    RTS

World1_ClearEntitySlots00_09:
    LDX #$09
    LDA #$00

Bank0_Label_C942:
    STA a:World1EntityType,X
    DEX
    BPL Bank0_Label_C942
    RTS

World1_ClearEntitySlots10_29:
    LDX #$13
    LDA #$00

Bank0_Label_C94D:
    STA a:World1EntityType+$0A,X
    DEX
    BPL Bank0_Label_C94D
    RTS

World1_ClearEntitySlots30_37:
    LDX #$07
    LDA #$00

Bank0_Label_C958:
    STA a:World1EntityType+$1E,X
    DEX
    BPL Bank0_Label_C958
    RTS

World1_ClearEntitySlots38_47:
    LDX #$09
    LDA #$00

Bank0_Label_C963:
    STA a:World1EntityType+$26,X
    DEX
    BPL Bank0_Label_C963
    RTS

World1_RefreshObjectSpawnMask:
    LDX #$0F

Bank0_Label_C96C:
    LDA a:World1CollectedObjectBits,X
    STA a:World1ObjectSpawnMask,X
    DEX
    BPL Bank0_Label_C96C
    RTS

World1_InitializeObjectSpawnMask:
    LDX #$0F

Bank0_Label_C978:
    LDA a:World1CollectedObjectBits,X
    STA a:World1ObjectSpawnMask,X
    DEX
    BPL Bank0_Label_C978
    RTS

World1_RemoveCityObject:
    LDA #$00
    STA a:World1EntityType+$26,X
    RTS

World1_FindFreeEntitySlot38_47:
    LDX #$26

Bank0_Label_C98A:
    LDA a:World1EntityType,X
    BNE Bank0_Label_C990
    RTS

Bank0_Label_C990:
    INX
    CPX #$30
    BNE Bank0_Label_C98A
    LDA #$01
    RTS

World1_CheckCityObjectInteraction:
    LDA a:World1EntityType+$26,X
    TAY
    DEY
    LDA World1PlayerX
    SEC
    SBC a:World1EntityX+$26,X
    BCS Bank0_Label_C9AA
    CMP #$F4
    BCS Bank0_Label_C9AF
    RTS

Bank0_Label_C9AA:
    CMP a:World1_ObjectInteractionHitboxXByTypeMinusOne,Y
    BCS Bank0_Label_C9CD

Bank0_Label_C9AF:
    LDA World1PlayerY
    SEC
    SBC a:World1EntityY+$26,X
    BCS Bank0_Label_C9BD
    CMP a:World1_ObjectInteractionHitboxYNegativeByTypeMinusOne,Y
    BCS Bank0_Label_C9C2
    RTS

Bank0_Label_C9BD:
    CMP a:World1_ObjectInteractionHitboxYPositiveByTypeMinusOne,Y
    BCS Bank0_Label_C9CD

Bank0_Label_C9C2:
    CPY #$02
    BCS Bank0_Label_C9CE
    TXA
    STA $80
    INY
    TYA
    STA $81

Bank0_Label_C9CD:
    RTS

Bank0_Label_C9CE:
    DEY
    DEY
    TYA
    ASL A
    TAY
    LDA a:$CBF4,Y
    STA $00
    LDA a:$CBF5,Y
    STA $01

World1_JumpToCityItemHandler:
    JMP ($0000)

Bank0_Label_C9E0:
    RTS

World1_ResolvePlayerProjectileCityObjectHit:
    AND #$7F
    TAX
    LDA a:World1EntityPositionHigh+$26,Y
    AND #$0F
    BNE Bank0_Label_C9E0
    LDA a:World1EntityType+$26,Y
    CMP #$8A
    BNE Bank0_Label_C9F6
    LDA Controller2MicrophoneEdgeTimer
    BEQ Bank0_Label_C9E0

Bank0_Label_C9F6:
    LDA $00
    SEC
    SBC a:World1EntityX+$26,Y
    BCS Bank0_Label_CA04
    CLC
    ADC $02
    BCS Bank0_Label_CA09
    RTS

Bank0_Label_CA04:
    CMP a:World1_ObjectProjectileHitboxXByType,X
    BCS Bank0_Label_C9E0

Bank0_Label_CA09:
    LDA $01
    SEC
    SBC a:World1EntityY+$26,Y
    BCS Bank0_Label_CA17
    CLC
    ADC $02
    BCS Bank0_Label_CA1C
    RTS

Bank0_Label_CA17:
    CMP a:World1_ObjectProjectileHitboxYByType,X
    BCS Bank0_Label_C9E0

Bank0_Label_CA1C:
    LDX $95
    LDA a:World1EntityType+$1E,X
    CMP #$03
    BEQ Bank0_Label_CA37
    LDA a:World1EntityX+$1E,X
    SEC
    SBC #$04
    STA a:World1EntityX+$1E,X
    LDA a:World1EntityY+$1E,X
    SEC
    SBC #$04
    STA a:World1EntityY+$1E,X

Bank0_Label_CA37:
    LDA #$80
    STA a:World1EntityType+$1E,X
    LDA a:World1EntityPrimaryBehavior+$26,Y
    SEC
    SBC #$01
    STA a:World1EntityPrimaryBehavior+$26,Y
    BNE Bank0_Label_CA63
    LDA a:World1EntityType+$26,Y
    AND #$7F
    STA a:World1EntityType+$26,Y
    CMP #$0A
    BNE Bank0_Label_CA59
    JSR World1_CollectProgrammerFaceAndClearProjectiles
    JMP Bank0_Label_CA5E

Bank0_Label_CA59:
    LDA #$0A
    JSR World1_Audio_QueueEffectWithPriority

Bank0_Label_CA5E:
    PLA
    PLA
    JMP Bank0_Label_9250

Bank0_Label_CA63:
    LDA #$02
    JSR World1_Audio_QueueEffectWithPriority
    PLA
    PLA
    JMP Bank0_Label_9250

World1_UpdateTimedPowerups:
    LDA World1EnemyFreezeActive
    BEQ Bank0_Label_CA8A
    DEC World1EnemyFreezeTimer
    BNE Bank0_Label_CA7F
    LDA #$00
    STA World1EnemyFreezeActive
    STA a:AudioMusicControl
    JMP Bank0_Label_CA8A

Bank0_Label_CA7F:
    LDA World1EnemyFreezeTimer
    AND #$07
    BNE Bank0_Label_CA8A
    LDA #$07
    JSR World1_Audio_QueueEffect

Bank0_Label_CA8A:
    LDA FrameCounter
    AND #$01
    BEQ Bank0_Label_CAA6
    LDA World1InvulnerabilityTimer
    BEQ Bank0_Label_CAA6
    LDA #$00
    STA World1PlayerDamageState
    LDA FrameCounter
    AND #$02
    STA World1PlayerRenderFlags
    DEC World1InvulnerabilityTimer
    BNE Bank0_Label_CAA6
    LDA #$00
    STA World1PlayerRenderFlags

Bank0_Label_CAA6:
    RTS

World1_CollectGenkiCandy:
    DEC PlayerHealthCapacityIndex
    JSR World1_ResetPlayerHealthAndPose
    LDA a:World1EntitySourceObjectId+$26,X
    BMI Bank0_Label_CAB6
    STA $00
    JSR World1_MarkObjectCollected

Bank0_Label_CAB6:
    JSR World1_RemoveCityObject
    LDA #$0E
    JSR World1_Audio_QueueEffectWithPriority
    LDA #$35
    JMP World1_AddEncodedScore

World1_CollectOneUp:
    INC PlayerLives
    LDA a:World1EntitySourceObjectId+$26,X
    BMI Bank0_Label_CACF
    STA $00
    JSR World1_MarkObjectCollected

Bank0_Label_CACF:
    JSR World1_RemoveCityObject
    LDA #$01
    STA ExtraLifeSoundCounter
    LDA #$31
    JMP World1_AddEncodedScore

World1_CollectDorayaki:
    JSR World1_ResetPlayerHealthAndPose
    LDA a:World1EntitySourceObjectId+$26,X
    BMI Bank0_Label_CAE8
    STA $00
    JSR World1_MarkObjectCollected

Bank0_Label_CAE8:
    JSR World1_RemoveCityObject
    LDA #$0E
    JSR World1_Audio_QueueEffectWithPriority
    LDA #$32
    JMP World1_AddEncodedScore

World1_CollectWeaponUpgrade:
    INC World1WeaponLevel
    LDA a:World1EntitySourceObjectId+$26,X
    BMI Bank0_Label_CB01
    STA $00
    JSR World1_MarkObjectCollected

Bank0_Label_CB01:
    JSR World1_RemoveCityObject
    LDA #$0E
    JSR World1_Audio_QueueEffectWithPriority
    LDA #$31
    JMP World1_AddEncodedScore

World1_CollectStopwatch:
    LDA #$01
    STA World1EnemyFreezeActive
    LDA #$F0
    STA World1EnemyFreezeTimer
    LDA a:World1EntitySourceObjectId+$26,X
    BMI Bank0_Label_CB20
    STA $00
    JSR World1_MarkObjectCollected

Bank0_Label_CB20:
    JSR World1_RemoveCityObject
    LDA #$01
    STA a:AudioMusicControl
    LDA #$07
    JSR World1_Audio_QueueEffect
    LDA #$32
    JMP World1_AddEncodedScore

World1_CollectRapidFireDrink:
    INC World1ProjectileMaxSlot
    LDA a:World1EntitySourceObjectId+$26,X
    BMI Bank0_Label_CB3E
    STA $00
    JSR World1_MarkObjectCollected

Bank0_Label_CB3E:
    JSR World1_RemoveCityObject
    LDA #$0E
    JSR World1_Audio_QueueEffectWithPriority
    LDA #$32
    JMP World1_AddEncodedScore

World1_CollectFlashLight:
    LDA #$01
    STA World1FlashLightCarryFlag
    LDA a:World1EntitySourceObjectId+$26,X
    BMI Bank0_Label_CB59
    STA $00
    JSR World1_MarkObjectCollected

Bank0_Label_CB59:
    LDA #$0B
    JSR World1_Audio_QueueEffectWithPriority
    JMP World1_RemoveCityObject
