; Draw a group of entity slots in the frame-selected order

.macro SlotRenderEntry name
    ::.ident(.sprintf("Bank0_Label_%04X", SlotRenderCpuBase + (* - SlotRenderStart))):
name:
.endmacro

.macro EmitEntitySlotTraversal firstSlot, slotCount, renderSlot, skipNegative
SlotRenderStart:
    LDA FrameCounter
    AND #$01
    BNE BeginReverse
    LDA #$00
    STA $0A

    SlotRenderEntry RenderForward
    LDY $0A
    LDA a:World1EntityType+firstSlot,Y
    .if skipNegative
        BMI NextForward
    .endif
    BEQ NextForward
    JSR renderSlot
    LDA World1OamWriteIndex
    BMI ReturnFromSlots

    SlotRenderEntry NextForward
    INC $0A
    LDA $0A
    CMP #slotCount
    BNE RenderForward
    RTS

    SlotRenderEntry BeginReverse
    LDA #(slotCount-1)
    STA $0A

    SlotRenderEntry RenderReverse
    LDY $0A
    LDA a:World1EntityType+firstSlot,Y
    .if skipNegative
        BMI NextReverse
    .endif
    BEQ NextReverse
    JSR renderSlot
    LDA World1OamWriteIndex
    BMI ReturnFromSlots

    SlotRenderEntry NextReverse
    DEC $0A
    BPL RenderReverse

    SlotRenderEntry ReturnFromSlots
    RTS
.endmacro
