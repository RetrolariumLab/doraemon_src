; Doraemon PRG bank 0 $C92F-$CB60
; World 1 city object state initialization and interaction handlers
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank0_Func_C92F:
    LDA $27
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

Bank0_Func_C982:
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
    LDA $75
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
    LDA $76
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

Bank0_Func_C9E1:
    AND #$7F
    TAX
    LDA a:World1EntityPositionHigh+$26,Y
    AND #$0F
    BNE Bank0_Label_C9E0
    LDA a:World1EntityType+$26,Y
    CMP #$8A
    BNE Bank0_Label_C9F6
    LDA $24
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
    JSR Bank0_Func_CB61
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

Bank0_Func_CA6D:
    LDA $82
    BEQ Bank0_Label_CA8A
    DEC $83
    BNE Bank0_Label_CA7F
    LDA #$00
    STA $82
    STA a:AudioMusicControl
    JMP Bank0_Label_CA8A

Bank0_Label_CA7F:
    LDA $83
    AND #$07
    BNE Bank0_Label_CA8A
    LDA #$07
    JSR World1_Audio_QueueEffect

Bank0_Label_CA8A:
    LDA FrameCounter
    AND #$01
    BEQ Bank0_Label_CAA6
    LDA $B2
    BEQ Bank0_Label_CAA6
    LDA #$00
    STA $79
    LDA FrameCounter
    AND #$02
    STA $78
    DEC $B2
    BNE Bank0_Label_CAA6
    LDA #$00
    STA $78

Bank0_Label_CAA6:
    RTS

World1_CityItemHandler_Type04:
    DEC $2C
    JSR Bank0_Func_8362
    LDA a:World1EntitySourceObjectId+$26,X
    BMI Bank0_Label_CAB6
    STA $00
    JSR World1_MarkObjectCollected

Bank0_Label_CAB6:
    JSR Bank0_Func_C982
    LDA #$0E
    JSR World1_Audio_QueueEffectWithPriority
    LDA #$35
    JMP Bank0_Func_81C9

World1_CityItemHandler_Type05:
    INC $2A
    LDA a:World1EntitySourceObjectId+$26,X
    BMI Bank0_Label_CACF
    STA $00
    JSR World1_MarkObjectCollected

Bank0_Label_CACF:
    JSR Bank0_Func_C982
    LDA #$01
    STA $26
    LDA #$31
    JMP Bank0_Func_81C9

World1_CityItemHandler_Type07:
    JSR Bank0_Func_8362
    LDA a:World1EntitySourceObjectId+$26,X
    BMI Bank0_Label_CAE8
    STA $00
    JSR World1_MarkObjectCollected

Bank0_Label_CAE8:
    JSR Bank0_Func_C982
    LDA #$0E
    JSR World1_Audio_QueueEffectWithPriority
    LDA #$32
    JMP Bank0_Func_81C9

World1_CityItemHandler_Type06:
    INC $7B
    LDA a:World1EntitySourceObjectId+$26,X
    BMI Bank0_Label_CB01
    STA $00
    JSR World1_MarkObjectCollected

Bank0_Label_CB01:
    JSR Bank0_Func_C982
    LDA #$0E
    JSR World1_Audio_QueueEffectWithPriority
    LDA #$31
    JMP Bank0_Func_81C9

World1_CityItemHandler_Type03:
    LDA #$01
    STA $82
    LDA #$F0
    STA $83
    LDA a:World1EntitySourceObjectId+$26,X
    BMI Bank0_Label_CB20
    STA $00
    JSR World1_MarkObjectCollected

Bank0_Label_CB20:
    JSR Bank0_Func_C982
    LDA #$01
    STA a:AudioMusicControl
    LDA #$07
    JSR World1_Audio_QueueEffect
    LDA #$32
    JMP Bank0_Func_81C9

World1_CityItemHandler_Type08:
    INC $84
    LDA a:World1EntitySourceObjectId+$26,X
    BMI Bank0_Label_CB3E
    STA $00
    JSR World1_MarkObjectCollected

Bank0_Label_CB3E:
    JSR Bank0_Func_C982
    LDA #$0E
    JSR World1_Audio_QueueEffectWithPriority
    LDA #$32
    JMP Bank0_Func_81C9

World1_CityItemHandler_Type09:
    LDA #$01
    STA $37
    LDA a:World1EntitySourceObjectId+$26,X
    BMI Bank0_Label_CB59
    STA $00
    JSR World1_MarkObjectCollected

Bank0_Label_CB59:
    LDA #$0B
    JSR World1_Audio_QueueEffectWithPriority
    JMP Bank0_Func_C982
