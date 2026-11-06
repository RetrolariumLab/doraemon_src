; Inventory slot movement and state updates

.macro InventoryEntry name
    ::.ident(.sprintf("Bank1_Label_%04X", InventoryCpuBase + (* - InventoryStart))):
name:
.endmacro

.macro EmitHistoryInventorySlot slotState, slotX, slotY, historyDelay, detachedEntry, advanceBeforeCue
InventoryStart:
    LDY #$00
    LDA slotState
    CMP #$01
    BEQ UpdateDetached
    CMP #$04
    BEQ UpdateDetached
    CMP #$02
    BNE ReturnFromSlot
    LDA World2PlayerHistoryWriteIndex
    SEC
    SBC #historyDelay
    BPL HistoryIndex
    ADC #$30

    InventoryEntry HistoryIndex
    TAX
    LDA a:World2PlayerXHistory,X
    CMP slotX
    BEQ CompareY
    BCS MoveX
    DEC slotX
    DEC slotX

    InventoryEntry MoveX
    INC slotX
    INY

    InventoryEntry CompareY
    LDA a:World2PlayerYHistory,X
    CMP slotY
    BEQ CheckArrival
    BCS MoveY
    DEC slotY
    DEC slotY

    InventoryEntry MoveY
    INC slotY
    INY

    InventoryEntry CheckArrival
    TYA
    BNE ReturnFromSlot
    .if advanceBeforeCue
        INC slotState
    .endif
    LDA #$09
    JSR World2_Audio_QueueEffectWithPriority
    LDA #$00
    STA World2InventoryDropHitCounter
    .if !advanceBeforeCue
        INC slotState
    .endif

    InventoryEntry ReturnFromSlot
    RTS

    InventoryEntry UpdateDetached
    JSR detachedEntry
    LDA slotState
    CMP #$01
    BNE ReturnFromSlot
    LDA slotY
    CMP #$67
    BEQ AdvanceDetachedState
    CMP #$79
    BNE ReturnFromSlot

    InventoryEntry AdvanceDetachedState
    INC slotState
    RTS
.endmacro

.macro EmitDetachedInventorySlot slotState, slotX, slotY
InventoryStart:
    LDY World2ScrollDirection
    BEQ ScrollLeft
    DEY
    BEQ ScrollDown
    DEC slotY
    BEQ CheckDetachedState
    RTS

    InventoryEntry ScrollDown
    INC slotY
    LDA slotY
    CMP #$E0
    BCS CheckDetachedState
    RTS

    InventoryEntry ScrollLeft
    LDA World2HorizontalTransitionDelay
    BNE ReturnFromDetached
    DEC slotX
    BNE ReturnFromDetached

    InventoryEntry CheckDetachedState
    LDA slotState
    CMP #$01
    BEQ ReturnFromDetached
    LDA #$00
    STA slotState

    InventoryEntry ReturnFromDetached
    RTS
.endmacro
