; Doraemon PRG bank 0 $CB61-$CDB4
; World 1 city item interactions and door transition sequence
; Generated deterministically from pinned Ghidra/GhidraNes facts

World1_CollectProgrammerFaceAndClearProjectiles:
    TXA
    PHA
    TYA
    PHA
    PHA
    JSR World1_ClearEntitySlots30_37
    PLA
    TAX
    JSR World1_CollectProgrammerFaceBonus
    PLA
    TAY
    PLA
    TAX
    RTS

World1_CollectProgrammerFaceBonus:
    LDA a:World1EntitySourceObjectId+$26,X
    BMI Bank0_Label_CB7D
    STA $00
    JSR World1_MarkObjectCollected

Bank0_Label_CB7D:
    TXA
    PHA
    LDA #$0E
    JSR World1_Audio_QueueEffect
    LDA #$0A
    STA $97

Bank0_Label_CB88:
    JSR World1_WaitForNextFrame
    DEC $97
    BNE Bank0_Label_CB88
    LDA #$50
    STA $97

Bank0_Label_CB93:
    JSR World1_WaitForNextFrame
    LDA #$31
    JSR World1_AddEncodedScore
    LDA FrameCounter
    AND #$07
    BNE Bank0_Label_CBA6
    LDA #$08
    JSR World1_Audio_QueueEffectWithPriority

Bank0_Label_CBA6:
    DEC $97
    BNE Bank0_Label_CB93
    PLA
    TAX
    JMP World1_RemoveCityObject

World1_CollectGoldBar:
    LDA a:World1EntitySourceObjectId+$26,X
    BMI Bank0_Label_CBB9
    STA $00
    JSR World1_MarkObjectCollected

Bank0_Label_CBB9:
    JSR World1_RemoveCityObject
    LDA #$0E
    JSR World1_Audio_QueueEffectWithPriority
    LDA #$31
    JMP World1_AddEncodedScore

World1_CollectDiamond:
    LDA a:World1EntitySourceObjectId+$26,X
    BMI Bank0_Label_CBD0
    STA $00
    JSR World1_MarkObjectCollected

Bank0_Label_CBD0:
    JSR World1_RemoveCityObject
    LDA #$0E
    JSR World1_Audio_QueueEffectWithPriority
    LDA #$32
    JMP World1_AddEncodedScore

World1_CollectInvulnerability:
    LDA a:World1EntitySourceObjectId+$26,X
    BMI Bank0_Label_CBE7
    STA $00
    JSR World1_MarkObjectCollected

Bank0_Label_CBE7:
    JSR World1_RemoveCityObject
    LDA #$FF
    STA World1InvulnerabilityTimer
    LDA #$0E
    JSR World1_Audio_QueueEffectWithPriority
    RTS

World1_DescriptorInteractionHandlerTable:
    .byte $0E, $CB, $A7, $CA, $C3, $CA, $F5, $CA, $DB, $CA, $32, $CB, $4B, $CB, $73, $CB
    .byte $AF, $CB, $C6, $CB, $DD, $CB

World1_ObjectDescriptorTable:
    .byte $01

World1_ObjectDescriptorMetaspriteField:
    .byte $29

World1_ObjectDescriptorRenderFlagsField:
    .byte $01

World1_ObjectDescriptorPrimaryBehaviorField:
    .byte $03, $02, $25, $01, $03, $03, $2E, $01, $03, $04, $2D, $00, $03, $05, $2F, $01
    .byte $10, $06, $00, $01, $02, $07, $30, $01, $02, $08, $34, $01, $02, $09, $16, $01
    .byte $04, $0A, $14, $01, $20, $0B, $28, $01, $02, $0C, $17, $00, $02, $0D, $35, $03

World1_ObjectProjectileHitboxXByType:
    .byte $02, $14, $1C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C

World1_ObjectProjectileHitboxYByType:
    .byte $0C, $05, $28, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C

World1_ObjectInteractionHitboxXByTypeMinusOne:
    .byte $14, $1C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C

World1_ObjectInteractionHitboxYNegativeByTypeMinusOne:
    .byte $E8, $FF, $EC, $EC, $EC, $EC, $EC, $EC, $EC, $EC, $EC, $EC, $EC

World1_ObjectInteractionHitboxYPositiveByTypeMinusOne:
    .byte $00, $18, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C

World1_TryEnterAnywhereDoor:
    LDA CombinedControllerButtons
    AND #$80
    BEQ Bank0_Label_CC8B
    LDA $81
    CMP #$02
    BEQ World1_EnterAnywhereDoor

Bank0_Label_CC8B:
    RTS

World1_EnterAnywhereDoor:
    LDA #$00
    STA a:AudioMusicState
    STA a:AudioMusicControl
    STA World1EnemyFreezeActive
    STA World1EnemyFreezeTimer
    STA World1InvulnerabilityTimer
    LDA #$13
    JSR World1_Audio_QueueEffect
    JSR World1_ClearEntitySlots00_09
    JSR World1_ClearEntitySlots10_29
    JSR World1_ClearEntitySlots30_37
    LDX $80
    LDA a:World1EntitySourceObjectId+$26,X
    STA $81
    TAY
    LDA a:World1EntityX+$26,X
    CLC
    ADC #$08
    STA World1PlayerX
    LDA a:World1EntityY+$26,X
    CLC
    ADC #$10
    STA World1PlayerY
    LDA #$04
    STA World1PlayerMetasprite
    LDA #$00
    STA World1PlayerRenderFlags

Bank0_Label_CCC8:
    JSR World1_WaitForNextFrame
    LDA #$00
    STA World1ScreenDeltaX
    STA World1ScreenDeltaY
    JSR World1_UpdateCameraFromPlayer
    LDA World1ScreenDeltaX
    ORA World1ScreenDeltaY
    BNE Bank0_Label_CCC8
    LDA #$14

Bank0_Label_CCDC:
    PHA

Bank0_Label_CCDD:
    PHA
    JSR World1_WaitForNextFrame
    PLA
    SEC
    SBC #$01
    BNE Bank0_Label_CCDD
    LDX $80
    INC a:World1EntityMetasprite+$26,X
    LDA a:World1EntityMetasprite+$26,X
    CMP #$28
    BEQ Bank0_Label_CCF7
    PLA
    JMP Bank0_Label_CCDC

Bank0_Label_CCF7:
    LDA #$F0
    STA World1PlayerY
    DEC a:World1EntityMetasprite+$26,X
    LDA #$13
    JSR World1_Audio_QueueEffect
    PLA

Bank0_Label_CD04:
    PHA

Bank0_Label_CD05:
    PHA
    JSR World1_WaitForNextFrame
    PLA
    SEC
    SBC #$01
    BNE Bank0_Label_CD05
    LDX $80
    DEC a:World1EntityMetasprite+$26,X
    LDA a:World1EntityMetasprite+$26,X
    CMP #$24
    BEQ Bank0_Label_CD1F
    PLA
    JMP Bank0_Label_CD04

Bank0_Label_CD1F:
    PLA
    JSR World1_ClearEntitySlots38_47
    JSR World1_RefreshObjectSpawnMask
    LDA $81
    TAY
    LDA a:$CDA9,Y
    BPL Bank0_Label_CD42
    CMP #$FF
    BNE Bank0_Label_CD35
    JMP World1_EnterUndergroundFinale

Bank0_Label_CD35:
    JSR World1_RandomByte
    AND #$03
    TAY
    LDA a:$CDB1,Y
    CMP $81
    BEQ Bank0_Label_CD35

Bank0_Label_CD42:
    ASL A
    ASL A
    TAY
    LDA a:$CD89,Y
    STA World1CameraTileX
    INY
    LDA a:$CD89,Y
    STA World1CameraTileY
    INY
    LDA a:$CD89,Y
    INY
    CLC
    ADC #$08
    STA World1PlayerX
    LDA a:$CD89,Y
    CLC
    ADC #$10
    STA World1PlayerY
    LDA #$00
    STA World1PlayerDamageState
    STA World1PlayerRenderFlags
    STA World1PlayerMetasprite
    STA World1PlayerDirection
    JSR World1_RefreshObjectSpawnMask
    JSR Bank0_DisableRenderingForUpdate
    JSR World1_PrefillMapViewport
    JSR World1_StartAreaMusic
    JSR World1_EnableGameplayRendering
    LDX #$0A

Bank0_Label_CD7D:
    JSR World1_WaitForNextFrame
    DEX
    BNE Bank0_Label_CD7D
    LDX #$7F
    TXS
    JMP Bank0_World1CityFrameLoop
    .byte $B0, $86, $70, $60, $1C, $C2, $70, $60, $02, $A4, $70, $60, $70, $20, $70, $60
    .byte $B8, $5C, $70, $40, $8C, $8C, $70, $60, $1D, $5C, $70, $40, $0C, $D8, $70, $60
    .byte $80, $05, $06, $FF, $80, $01, $02, $80, $00, $05, $04, $07
