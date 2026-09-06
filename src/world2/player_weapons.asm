; Doraemon PRG bank 1 $8C5D-$8F4A
; World 2 player animation, weapon state, and projectile creation
; Generated deterministically from pinned Ghidra/GhidraNes facts

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
    LDY World2ScrollDirection
    BEQ Bank1_Label_8CEE
    DEY
    BEQ Bank1_Label_8CE5
    DEC World2InventoryY,X
    BEQ Bank1_Label_8CF6
    RTS

Bank1_Label_8CE5:
    INC World2InventoryY,X
    LDA World2InventoryY,X
    CMP #$E0
    BCS Bank1_Label_8CF6
    RTS

Bank1_Label_8CEE:
    LDA World2HorizontalTransitionDelay
    BNE Bank1_Label_8D00
    DEC World2InventoryX,X
    BNE Bank1_Label_8D00

Bank1_Label_8CF6:
    LDA World2InventoryState,X
    CMP #$01
    BEQ Bank1_Label_8D00
    LDA #$00
    STA World2InventoryState,X

Bank1_Label_8D00:
    RTS

World2_UpdateInventorySlot1:
    LDY #$00
    LDA World2InventoryState+$01
    CMP #$01
    BEQ Bank1_Label_8D4A
    CMP #$04
    BEQ Bank1_Label_8D4A
    CMP #$02
    BNE Bank1_Label_8D49
    LDA World2PlayerHistoryWriteIndex
    SEC
    SBC #$17
    BPL Bank1_Label_8D1A
    ADC #$30

Bank1_Label_8D1A:
    TAX
    LDA a:World2PlayerXHistory,X
    CMP World2InventoryX+$01
    BEQ Bank1_Label_8D2B
    BCS Bank1_Label_8D28
    DEC World2InventoryX+$01
    DEC World2InventoryX+$01

Bank1_Label_8D28:
    INC World2InventoryX+$01
    INY

Bank1_Label_8D2B:
    LDA a:World2PlayerYHistory,X
    CMP World2InventoryY+$01
    BEQ Bank1_Label_8D3B
    BCS Bank1_Label_8D38
    DEC World2InventoryY+$01
    DEC World2InventoryY+$01

Bank1_Label_8D38:
    INC World2InventoryY+$01
    INY

Bank1_Label_8D3B:
    TYA
    BNE Bank1_Label_8D49
    INC World2InventoryState+$01
    LDA #$09
    JSR World2_Audio_QueueEffectWithPriority
    LDA #$00
    STA World2InventoryDropHitCounter

Bank1_Label_8D49:
    RTS

Bank1_Label_8D4A:
    JSR World2_UpdateDetachedInventorySlot1
    LDA World2InventoryState+$01
    CMP #$01
    BNE Bank1_Label_8D49
    LDA World2InventoryY+$01
    CMP #$67
    BEQ Bank1_Label_8D5D
    CMP #$79
    BNE Bank1_Label_8D49

Bank1_Label_8D5D:
    INC World2InventoryState+$01
    RTS

World2_UpdateDetachedInventorySlot1:
    LDY World2ScrollDirection
    BEQ Bank1_Label_8D75
    DEY
    BEQ Bank1_Label_8D6C
    DEC World2InventoryY+$01
    BEQ Bank1_Label_8D7D
    RTS

Bank1_Label_8D6C:
    INC World2InventoryY+$01
    LDA World2InventoryY+$01
    CMP #$E0
    BCS Bank1_Label_8D7D
    RTS

Bank1_Label_8D75:
    LDA World2HorizontalTransitionDelay
    BNE Bank1_Label_8D87
    DEC World2InventoryX+$01
    BNE Bank1_Label_8D87

Bank1_Label_8D7D:
    LDA World2InventoryState+$01
    CMP #$01
    BEQ Bank1_Label_8D87
    LDA #$00
    STA World2InventoryState+$01

Bank1_Label_8D87:
    RTS

World2_UpdateInventorySlot0:
    LDY #$00
    LDA World2InventoryState
    CMP #$01
    BEQ Bank1_Label_8DD1
    CMP #$04
    BEQ Bank1_Label_8DD1
    CMP #$02
    BNE Bank1_Label_8DD0
    LDA World2PlayerHistoryWriteIndex
    SEC
    SBC #$2F
    BPL Bank1_Label_8DA1
    ADC #$30

Bank1_Label_8DA1:
    TAX
    LDA a:World2PlayerXHistory,X
    CMP World2InventoryX
    BEQ Bank1_Label_8DB2
    BCS Bank1_Label_8DAF
    DEC World2InventoryX
    DEC World2InventoryX

Bank1_Label_8DAF:
    INC World2InventoryX
    INY

Bank1_Label_8DB2:
    LDA a:World2PlayerYHistory,X
    CMP World2InventoryY
    BEQ Bank1_Label_8DC2
    BCS Bank1_Label_8DBF
    DEC World2InventoryY
    DEC World2InventoryY

Bank1_Label_8DBF:
    INC World2InventoryY
    INY

Bank1_Label_8DC2:
    TYA
    BNE Bank1_Label_8DD0
    LDA #$09
    JSR World2_Audio_QueueEffectWithPriority
    LDA #$00
    STA World2InventoryDropHitCounter
    INC World2InventoryState

Bank1_Label_8DD0:
    RTS

Bank1_Label_8DD1:
    JSR World2_UpdateDetachedInventorySlot0
    LDA World2InventoryState
    CMP #$01
    BNE Bank1_Label_8DD0
    LDA World2InventoryY
    CMP #$67
    BEQ Bank1_Label_8DE4
    CMP #$79
    BNE Bank1_Label_8DD0

Bank1_Label_8DE4:
    INC World2InventoryState
    RTS

World2_UpdateDetachedInventorySlot0:
    LDY World2ScrollDirection
    BEQ Bank1_Label_8DFC
    DEY
    BEQ Bank1_Label_8DF3
    DEC World2InventoryY
    BEQ Bank1_Label_8E04
    RTS

Bank1_Label_8DF3:
    INC World2InventoryY
    LDA World2InventoryY
    CMP #$E0
    BCS Bank1_Label_8E04
    RTS

Bank1_Label_8DFC:
    LDA World2HorizontalTransitionDelay
    BNE Bank1_Label_8E0E
    DEC World2InventoryX
    BNE Bank1_Label_8E0E

Bank1_Label_8E04:
    LDA World2InventoryState
    CMP #$01
    BEQ Bank1_Label_8E0E
    LDA #$00
    STA World2InventoryState

Bank1_Label_8E0E:
    RTS

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
    LDA a:$97BD,Y
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
