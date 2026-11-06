; World 2 player animation, weapon state, and projectile creation
; PRG bank 1, original CPU range $8C5D-$8F4A

.include "inventory_macros.inc"

World2_UpdatePlayerDamageEffect:
    LDA World2PlayerDamageEffect
    BEQ Bank1_Label_8C73
    LDA World2FrameCounter
    AND #$07
    BNE Bank1_Label_8C73
    INC World2PlayerDamageEffect
    LDA World2PlayerDamageEffect
    CMP #$05
    BNE Bank1_Label_8C73
    LDA #$00
    STA World2PlayerDamageEffect

Bank1_Label_8C73:
    RTS

World2_UpdateInventorySlot3:
    LDX #$03
    BNE Bank1_Label_8C86

World2_UpdateInventorySlot5:
    LDX #$05
    BNE Bank1_Label_8C86

World2_UpdateInventorySlot4:
    LDX #$04
    BNE Bank1_Label_8C86

World2_UpdateInventorySlot6:
    LDX #$06
    BNE Bank1_Label_8C86

World2_UpdateInventorySlot2:
    LDX #$02

Bank1_Label_8C86:
    LDA World2InventoryState,X
    CMP #$01
    BEQ Bank1_Label_8CC3
    CMP #$04
    BEQ Bank1_Label_8CC3
    CMP #$02
    BNE Bank1_Label_8CC2
    LDY #$00
    LDA World2PlayerX
    CMP World2InventoryX,X
    BEQ Bank1_Label_8CA5
    BCS Bank1_Label_8CA2
    DEC World2InventoryX,X
    DEC World2InventoryX,X

Bank1_Label_8CA2:
    INC World2InventoryX,X
    INY

Bank1_Label_8CA5:
    LDA World2PlayerY
    CMP World2InventoryY,X
    BEQ Bank1_Label_8CB4
    BCS Bank1_Label_8CB1
    DEC World2InventoryY,X
    DEC World2InventoryY,X

Bank1_Label_8CB1:
    INC World2InventoryY,X
    INY

Bank1_Label_8CB4:
    TYA
    BNE Bank1_Label_8CC2
    LDA #$09
    JSR World2_Audio_QueueEffectWithPriority
    LDA #$00
    STA World2InventoryDropHitCounter
    INC World2InventoryState,X

Bank1_Label_8CC2:
    RTS

Bank1_Label_8CC3:
    JSR World2_UpdateDetachedInventorySlot2To6
    LDA World2InventoryState,X
    CMP #$01
    BNE Bank1_Label_8CC2
    LDA World2InventoryY,X
    CMP #$67
    BEQ Bank1_Label_8CD6
    CMP #$79
    BNE Bank1_Label_8CC2

Bank1_Label_8CD6:
    INC World2InventoryState,X
    RTS

World2_UpdateDetachedInventorySlot2To6:
.scope DetachedIndexed
InventoryCpuBase = $8CD9
    EmitDetachedInventorySlot {World2InventoryState,X}, {World2InventoryX,X}, {World2InventoryY,X}
.endscope

World2_UpdateInventorySlot1:
.scope Inventory1
InventoryCpuBase = $8D01
    EmitHistoryInventorySlot World2InventoryState+1, World2InventoryX+1, World2InventoryY+1, $17, World2_UpdateDetachedInventorySlot1, 1
.endscope

World2_UpdateDetachedInventorySlot1:
.scope Detached1
InventoryCpuBase = $8D60
    EmitDetachedInventorySlot World2InventoryState+1, World2InventoryX+1, World2InventoryY+1
.endscope

World2_UpdateInventorySlot0:
.scope Inventory0
InventoryCpuBase = $8D88
    EmitHistoryInventorySlot World2InventoryState, World2InventoryX, World2InventoryY, $2F, World2_UpdateDetachedInventorySlot0, 0
.endscope

World2_UpdateDetachedInventorySlot0:
.scope Detached0
InventoryCpuBase = $8DE7
    EmitDetachedInventorySlot World2InventoryState, World2InventoryX, World2InventoryY
.endscope

World2_RecordPlayerPositionHistory:
    LDX World2PlayerHistoryWriteIndex
    DEX
    BPL Bank1_Label_8E16
    LDX #$30

Bank1_Label_8E16:
    LDA World2PlayerX
    CMP a:World2PlayerXHistory,X
    BNE Bank1_Label_8E25
    LDA World2PlayerY
    CMP a:World2PlayerYHistory,X
    BNE Bank1_Label_8E25
    RTS

Bank1_Label_8E25:
    LDX World2PlayerHistoryWriteIndex
    LDA World2PlayerX
    STA a:World2PlayerXHistory,X
    LDA World2PlayerY
    STA a:World2PlayerYHistory,X
    INX
    TXA
    CMP #$30
    BNE Bank1_Label_8E39
    LDA #$00

Bank1_Label_8E39:
    STA World2PlayerHistoryWriteIndex
    RTS

World2_UpdatePlayerMovementAndFire:
    LDA DemoModeActive
    BEQ Bank1_Label_8E4E
    LDA World2FrameCounter
    ROL A
    ROL A
    ROL A
    ROL A
    AND #$07
    TAY
    LDA a:Bank1_Label_97BD,Y
    BNE Bank1_Label_8E50

Bank1_Label_8E4E:
    LDA CombinedControllerButtons

Bank1_Label_8E50:
    TAX
    AND #$01
    BEQ Bank1_Label_8E63
    LDA World2PlayerX
    CMP #$D0
    BCS Bank1_Label_8E73
    LDA World2MovementStep
    ADC World2PlayerX
    STA World2PlayerX
    BNE Bank1_Label_8E73

Bank1_Label_8E63:
    TXA
    AND #$02
    BEQ Bank1_Label_8E73
    LDA World2PlayerX
    SEC
    SBC World2MovementStep
    CMP #$20
    BCC Bank1_Label_8E73
    STA World2PlayerX

Bank1_Label_8E73:
    TXA
    AND #$04
    BEQ Bank1_Label_8E84
    LDA World2PlayerY
    CMP #$D0
    BCS Bank1_Label_8E93
    ADC World2MovementStep
    STA World2PlayerY
    BNE Bank1_Label_8E93

Bank1_Label_8E84:
    TXA
    AND #$08
    BEQ Bank1_Label_8E93
    LDA World2PlayerY
    SBC World2MovementStep
    CMP #$20
    BCC Bank1_Label_8E93
    STA World2PlayerY

Bank1_Label_8E93:
    TXA
    AND #$C0
    BNE Bank1_Label_8E9B
    STA World2FireRepeatTimer

Bank1_Label_8E9A:
    RTS

Bank1_Label_8E9B:
    INC World2FirePressCounter
    LDA World2PlayerDamageTimer
    CMP #$50
    BCS Bank1_Label_8E9A
    LDA World2FireRepeatTimer
    BEQ Bank1_Label_8EB3
    INC World2FireRepeatTimer
    LDX #$1E
    CPX World2FireRepeatTimer
    BNE Bank1_Label_8E9A
    LDA #$00
    STA World2FireRepeatTimer

Bank1_Label_8EB3:
    INC World2FireRepeatTimer
    LDA #$00
    STA World2NextProjectileDirection
    LDA World2InventoryState+$01
    CMP #$03
    BNE Bank1_Label_8F0C
    LDA World2CompanionFirePhase
    EOR #$01
    STA World2CompanionFirePhase
    AND #$01
    BEQ Bank1_Label_8F0C
    INC World2CompanionFireCounter
    LDA World2CompanionFireCounter
    AND #$01
    BEQ Bank1_Label_8F0C
    LDA World2CompanionFireCounter
    AND #$03
    STA World2NextProjectileDirection
    LDA #$01
    JSR World2_Audio_QueueEffectWithPriority
    LDX #$06

Bank1_Label_8EDE:
    LDA a:World2PlayerProjectileState,X
    BEQ Bank1_Label_8EED
    DEX
    CPX #$03
    BNE Bank1_Label_8EDE
    LDA #$00
    STA World2FireRepeatTimer
    RTS

Bank1_Label_8EED:
    LDA World2PlayerHistoryWriteIndex
    SEC
    SBC #$17
    BPL Bank1_Label_8EF6
    ADC #$30

Bank1_Label_8EF6:
    TAY
    LDA a:World2PlayerXHistory,Y
    CLC
    ADC #$04
    STA a:World2PlayerProjectileX,X
    LDA a:World2PlayerYHistory,Y
    CLC
    ADC #$08
    STA a:World2PlayerProjectileY,X
    JMP Bank1_Label_8F40

Bank1_Label_8F0C:
    JSR World2_TryStartInventorySlot0Projectile
    LDA DemoModeActive
    BNE Bank1_Label_8F19
    LDA World2InventoryState+$02
    CMP #$03
    BNE Bank1_Label_8F1C

Bank1_Label_8F19:
    JMP World2_StartInventorySlot2Attack

Bank1_Label_8F1C:
    LDX #$03

Bank1_Label_8F1E:
    LDA a:World2PlayerProjectileState,X
    BEQ Bank1_Label_8F2B
    DEX
    BPL Bank1_Label_8F1E
    LDA #$00
    STA World2FireRepeatTimer
    RTS

Bank1_Label_8F2B:
    LDA #$01
    JSR World2_Audio_QueueEffectWithPriority
    LDA World2PlayerX
    CLC
    ADC #$04
    STA a:World2PlayerProjectileX,X
    LDA World2PlayerY
    CLC
    ADC #$08
    STA a:World2PlayerProjectileY,X

Bank1_Label_8F40:
    LDA #$01
    STA a:World2PlayerProjectileState,X
    LDA World2NextProjectileDirection
    STA a:World2PlayerProjectileDirection,X
    RTS
