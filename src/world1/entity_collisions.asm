; Doraemon PRG bank 0 $9201-$95CA
; World 1 entity collision scans, damage resolution, and interaction helpers
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank0_Func_9201:
    LDA #$00
    STA $95

Bank0_Label_9205:
    LDX $95
    LDA a:World1EntityType+$1E,X
    BEQ Bank0_Label_9250
    BMI Bank0_Label_9250
    TAY
    LDA a:$9317,Y
    STA $02
    LDA a:World1EntityX+$1E,X
    STA $00
    LDA a:World1EntityY+$1E,X
    STA $01
    LDA #$00
    STA $96

Bank0_Label_9222:
    LDY $96
    LDX $95
    LDA a:World1EntityType+$26,Y
    BEQ Bank0_Label_9230
    BPL Bank0_Label_9230
    JSR Bank0_Func_C9E1

Bank0_Label_9230:
    INC $96
    LDY $96
    CPY #$0A
    BNE Bank0_Label_9222
    LDA #$00
    STA $96

Bank0_Label_923C:
    LDY $96
    LDX $95
    LDA a:World1EntityType,Y
    BEQ Bank0_Label_9248
    JSR Bank0_Func_925A

Bank0_Label_9248:
    INC $96
    LDY $96
    CPY #$0A
    BNE Bank0_Label_923C

Bank0_Label_9250:
    INC $95
    LDA $95
    CMP #$08
    BNE Bank0_Label_9205
    RTS

Bank0_Label_9259:
    RTS

Bank0_Func_925A:
    CMP #$C0
    BCS Bank0_Label_9259
    CMP #$0F
    BEQ Bank0_Label_9259
    AND #$1F
    TAX
    LDA a:World1EntityPositionHigh,Y
    AND #$0F
    BNE Bank0_Label_9259
    LDA $00
    SEC
    SBC a:World1EntityX,Y
    BCS Bank0_Label_927A
    CLC
    ADC $02
    BCS Bank0_Label_927F
    RTS

Bank0_Label_927A:
    CMP a:$92F9,X
    BCS Bank0_Label_9259

Bank0_Label_927F:
    LDA $01
    SEC
    SBC a:World1EntityY,Y
    BCS Bank0_Label_928D
    CLC
    ADC $02
    BCS Bank0_Label_9292
    RTS

Bank0_Label_928D:
    CMP a:$9308,X
    BCS Bank0_Label_9259

Bank0_Label_9292:
    LDX $95
    LDA a:World1EntityType+$1E,X
    CMP #$03
    BEQ Bank0_Label_92AD
    LDA a:World1EntityX+$1E,X
    SEC
    SBC #$04
    STA a:World1EntityX+$1E,X
    LDA a:World1EntityY+$1E,X
    SEC
    SBC #$04
    STA a:World1EntityY+$1E,X

Bank0_Label_92AD:
    LDA a:World1EntityType,Y
    BMI Bank0_Label_92EB
    LDA a:World1EntityType+$1E,X
    AND #$07
    STA $04
    LDA a:World1EntityHealthOrVelocity,Y
    SEC
    SBC $04
    STA a:World1EntityHealthOrVelocity,Y
    BCC Bank0_Label_92D3
    LDA a:World1EntityType,Y
    ORA #$80
    STA a:World1EntityType,Y
    LDA #$00
    STA a:World1EntityDamageTimerOrAcceleration,Y
    BEQ Bank0_Label_92EB

Bank0_Label_92D3:
    LDA #$00
    STA a:World1EntityDamageTimerOrAcceleration,Y
    LDA a:World1EntityType,Y
    ORA #$C0
    STA a:World1EntityType,Y
    LDA #$05
    JSR World1_Audio_QueueEffectWithPriority
    JSR Bank0_Func_9462
    JMP Bank0_Label_92F0

Bank0_Label_92EB:
    LDA #$03
    JSR World1_Audio_QueueEffectWithPriority

Bank0_Label_92F0:
    LDA #$80
    STA a:World1EntityType+$1E,X
    PLA
    PLA
    JMP Bank0_Label_9250
    .byte $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $24, $0C, $0C
    .byte $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $28, $0C, $04, $08
    .byte $0C

Bank0_Func_931B:
    LDA #$00
    STA $81
    STA $80
    LDA World1PlayerDamageState
    BNE Bank0_Label_9363
    LDA #$00
    STA $95

Bank0_Label_9329:
    LDX $95
    LDA a:World1EntityType+$0A,X
    BEQ Bank0_Label_933C
    BMI Bank0_Label_933C
    LDA a:World1EntityPositionHigh+$0A,X
    AND #$0F
    BNE Bank0_Label_933C
    JSR Bank0_Func_9383

Bank0_Label_933C:
    INC $95
    LDX $95
    CPX #$14
    BNE Bank0_Label_9329
    LDA #$00
    STA $95

Bank0_Label_9348:
    LDX $95
    LDA a:World1EntityType,X
    BEQ Bank0_Label_935B
    BMI Bank0_Label_935B
    LDA a:World1EntityPositionHigh,X
    AND #$0F
    BNE Bank0_Label_935B
    JSR Bank0_Func_93D4

Bank0_Label_935B:
    INC $95
    LDX $95
    CPX #$0A
    BNE Bank0_Label_9348

Bank0_Label_9363:
    LDA #$00
    STA $95

Bank0_Label_9367:
    LDX $95
    LDA a:World1EntityType+$26,X
    BEQ Bank0_Label_937A
    BMI Bank0_Label_937A
    LDA a:World1EntityPositionHigh+$26,X
    AND #$0F
    BNE Bank0_Label_937A
    JSR World1_CheckCityObjectInteraction

Bank0_Label_937A:
    INC $95
    LDX $95
    CPX #$0A
    BNE Bank0_Label_9367
    RTS

Bank0_Func_9383:
    LDA World1PlayerX
    SEC
    SBC a:World1EntityX+$0A,X
    BCS Bank0_Label_9391
    CMP #$F4
    BCC Bank0_Label_93D3
    BCS Bank0_Label_9395

Bank0_Label_9391:
    CMP #$05
    BCS Bank0_Label_93D3

Bank0_Label_9395:
    LDA World1PlayerY
    SEC
    SBC a:World1EntityY+$0A,X
    BCS Bank0_Label_93A3
    CMP #$E4
    BCC Bank0_Label_93D3
    BCS Bank0_Label_93A7

Bank0_Label_93A3:
    CMP #$04
    BCS Bank0_Label_93D3

Bank0_Label_93A7:
    LDA World1InvulnerabilityTimer
    BNE Bank0_Label_93CE
    LDA World1EnemyFreezeActive
    BNE Bank0_Label_93D3
    LDA #$0F
    JSR World1_Audio_QueueEffectWithPriority
    LDA #$01
    STA World1PlayerDamageState
    LDA a:World1EntitySecondaryBehavior+$0A,X
    STA $00
    LDA PlayerHealth
    SEC
    SBC $00
    BCS Bank0_Label_93CA
    LDA #$80
    STA World1PlayerDamageState
    LDA #$00

Bank0_Label_93CA:
    STA PlayerHealth
    PLA
    PLA

Bank0_Label_93CE:
    LDA #$00
    STA a:World1EntityType+$0A,X

Bank0_Label_93D3:
    RTS

Bank0_Func_93D4:
    LDA a:World1EntityType,X
    CMP #$0F
    BEQ Bank0_Label_942A
    AND #$3F
    TAY
    DEY
    LDA World1PlayerX
    SEC
    SBC a:World1EntityX,X
    BCS Bank0_Label_93ED
    CMP #$F4
    BCC Bank0_Label_942A
    BCS Bank0_Label_93F2

Bank0_Label_93ED:
    CMP a:$9442,Y
    BCS Bank0_Label_942A

Bank0_Label_93F2:
    LDA World1PlayerY
    SEC
    SBC a:World1EntityY,X
    BCS Bank0_Label_9400
    CMP #$EC
    BCC Bank0_Label_942A
    BCS Bank0_Label_9405

Bank0_Label_9400:
    CMP a:$9452,Y
    BCS Bank0_Label_942A

Bank0_Label_9405:
    LDA World1InvulnerabilityTimer
    BNE Bank0_Label_942B
    LDA World1EnemyFreezeActive
    BNE Bank0_Label_942A
    LDA #$0F
    JSR World1_Audio_QueueEffectWithPriority
    LDA #$01
    STA World1PlayerDamageState
    LDA PlayerHealth
    CLC
    SBC a:World1EntityHealthOrVelocity,X
    STA PlayerHealth
    BPL Bank0_Label_9428
    LDA #$80
    STA World1PlayerDamageState
    LDA #$00
    STA PlayerHealth

Bank0_Label_9428:
    PLA
    PLA

Bank0_Label_942A:
    RTS

Bank0_Label_942B:
    LDA #$00
    STA a:World1EntityDamageTimerOrAcceleration,X
    LDA a:World1EntityType,X
    ORA #$C0
    STA a:World1EntityType,X
    LDA #$05
    JSR World1_Audio_QueueEffectWithPriority
    TXA
    TAY
    JMP Bank0_Func_9462
    .byte $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $2C, $0C, $0C
    .byte $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $1E, $0C, $0C

Bank0_Func_9462:
    TXA
    PHA
    TYA
    PHA
    LDX $B3
    LDA a:World1EntityType,Y
    AND #$3F
    CMP a:World1_InvincibilityDefeatSequence,X
    BNE Bank0_Label_947F
    INC $B3
    LDA $B3
    CMP #$06
    BNE Bank0_Label_9483
    LDA #$04
    JMP Bank0_Label_9494

Bank0_Label_947F:
    LDA #$00
    STA $B3

Bank0_Label_9483:
    INC $98
    LDA $98
    CMP #$04
    BCC Bank0_Label_94CF
    LDA #$00
    STA $98
    JSR Bank0_Func_962F
    AND #$03

Bank0_Label_9494:
    TAX
    LDA a:World1_TransientDescriptorSelectorTable,X
    STA $00
    BEQ Bank0_Label_94CF
    JSR World1_FindFreeEntitySlot38_47
    BNE Bank0_Label_94CF
    LDA a:World1EntityPositionHigh,Y
    STA a:World1EntityPositionHigh,X
    LDA a:World1EntityX,Y
    STA a:World1EntityX,X
    LDA a:World1EntityY,Y
    STA a:World1EntityY,X
    LDA #$FF
    STA a:World1EntitySourceObjectId,X
    LDA $00
    ASL A
    ASL A
    TAY
    LDA a:World1_ObjectDescriptorTable,Y
    STA a:World1EntityType,X
    LDA a:World1_ObjectDescriptorMetaspriteField,Y
    STA a:World1EntityMetasprite,X
    LDA a:World1_ObjectDescriptorRenderFlagsField,Y
    STA a:World1EntityRenderFlags,X

Bank0_Label_94CF:
    PLA
    TAY
    PLA
    TAX
    RTS

World1_TransientDescriptorSelectorTable:
    .byte $06, $0A, $0B, $02

World1_InvincibilityDescriptorSelector:
    .byte $0C

World1_InvincibilityDefeatSequence:
    .byte $06, $06, $05, $04, $01, $06, $06, $A2, $15, $CA, $D0, $FD, $EA, $EA, $88, $D0
    .byte $F6, $60

Bank0_Func_94EB:
    LDA a:$0180
    BNE Bank0_Func_94EB
    RTS

Bank0_Func_94F1:
    LDA FrameCounter

Bank0_Label_94F3:
    CMP FrameCounter
    BEQ Bank0_Label_94F3
    RTS

Bank0_Func_94F8:
    LDA #$00
    PHA
    LDA PpuCtrlShadow
    AND #$FB
    STA a:PPU_CTRL
    LDA #$20
    STA a:PPU_ADDR
    LDA #$00
    STA a:PPU_ADDR
    LDY #$00
    LDX #$10
    PLA

Bank0_Label_9511:
    STA a:PPU_DATA
    DEY
    BNE Bank0_Label_9511
    DEX
    BNE Bank0_Label_9511
    RTS

Bank0_Func_951B:
    LDX #$00
    LDA #$00

Bank0_Label_951F:
    STA a:World1AttributeTableCache,X
    INX
    CPX #$80
    BNE Bank0_Label_951F
    RTS
    .byte $A0, $00, $B1, $00, $99, $10, $02, $C8, $C0, $20, $D0, $F6, $60

Bank0_Func_9535:
    LDA NmiOamDmaRequest
    BNE Bank0_Label_955C
    JSR Bank0_WaitForVblank
    LDA PpuCtrlShadow
    AND #$FB
    STA a:PPU_CTRL
    LDA #$3F
    STA a:PPU_ADDR
    LDA #$00
    STA a:PPU_ADDR
    LDX #$00
    LDY #$20

Bank0_Label_9551:
    LDA a:$0210,X
    STA a:PPU_DATA
    INX
    DEY
    BNE Bank0_Label_9551
    RTS

Bank0_Label_955C:
    JSR Bank0_Func_94EB
    LDY #$00
    LDX #$20
    LDA #$3F
    STA a:$0181
    LDA #$00
    STA a:$0182
    LDA #$20
    STA a:$0183

Bank0_Label_9572:
    LDA a:$0210,Y
    STA a:$0184,Y
    INY
    DEX
    BNE Bank0_Label_9572
    LDA #$00
    STA a:$0184,Y
    LDA #$01
    STA a:$0180
    RTS
    .byte $A5, $19, $29, $FB, $85, $19, $8D, $00, $20, $A0, $00, $B1, $00, $F0, $34, $8D
    .byte $06, $20, $C8, $B1, $00, $8D, $06, $20, $C8, $B1, $00, $AA, $C8, $48, $98, $A0
    .byte $00, $18, $65, $00, $85, $00, $90, $02, $E6, $01, $B1, $00, $8D, $07, $20, $C8
    .byte $CA, $D0, $F7, $68, $F0, $08, $98, $18, $65, $00, $85, $00, $90, $CB, $E6, $01
    .byte $4C, $90, $95, $60
