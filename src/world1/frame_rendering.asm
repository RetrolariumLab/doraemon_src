; World 1 frame synchronization, PPU preparation, and sprite traversal
; PRG bank 0, original CPU range $95CB-$9909

.include "sprite_slot_macros.inc"

World1_HandlePause:
    LDA World1PressedButtons
    AND #$10
    BEQ Bank0_Label_95EC
    LDA #$01
    STA a:AudioMusicControl
    LDA #$06
    JSR World1_Audio_QueueEffect

Bank0_Label_95DB:
    JSR World1_WaitForNextFrame
    JSR World1_UpdateInputOrDemoStream
    LDA World1PressedButtons
    AND #$10
    BEQ Bank0_Label_95DB
    LDA #$00
    STA a:AudioMusicControl

Bank0_Label_95EC:
    RTS

World1_EnableGameplayRendering:
    JSR Bank0_HideAllSprites
    JSR Bank0_WaitForVblank
    LDA #$01
    STA NmiOamDmaRequest
    LDA PpuScrollXShadow
    STA a:PPU_SCROLL
    LDA PpuScrollYShadow
    STA a:PPU_SCROLL
    LDA PpuCtrlShadow
    ORA #$80
    STA PpuCtrlShadow
    STA a:PPU_CTRL
    JSR World1_WaitForNextFrame
    LDA PpuMaskShadow
    ORA #$18
    STA PpuMaskShadow
    RTS

World1_DisableGameplayRendering:
    LDA PpuCtrlShadow
    ORA #$80
    STA PpuCtrlShadow
    STA a:PPU_CTRL
    LDA PpuMaskShadow
    AND #$E7
    STA PpuMaskShadow
    LDA #$01
    STA NmiOamDmaRequest
    JSR World1_WaitForNextFrame
    LDA #$00
    STA NmiOamDmaRequest
    RTS

World1_FrameRandomByte:
    INC World1FrameRandomState+$01
    DEC World1FrameRandomState
    LDA FrameCounter
    EOR #$F0
    EOR World1FrameRandomState
    STA World1FrameRandomState
    LDA FrameCounter
    EOR #$AA
    ROR A
    ROR A
    ROR A
    EOR World1FrameRandomState+$01
    STA World1FrameRandomState+$01
    ROR A
    EOR World1FrameRandomState
    RTS

World1_RandomByte:
    LDA World1RandomState
    ROL A
    ROL A
    EOR #$41
    ROL A
    ROL A
    EOR #$93
    ADC World1RandomState+$01
    STA World1RandomState
    ROL A
    ROL A
    EOR #$12
    ROL A
    ROL A
    ADC World1RandomState+$02
    STA World1RandomState+$01
    ADC World1RandomState
    INC World1RandomState+$02
    BNE Bank0_Label_9671
    PHA
    LDA World1RandomState+$03
    CLC
    ADC #$1D
    STA World1RandomState+$03
    PLA

Bank0_Label_9671:
    EOR World1RandomState+$03
    RTS

World1_RenderFrameSprites:
    LDA FrameCounter
    AND #$01
    BNE Bank0_Label_968D
    JSR World1_RenderHud
    JSR World1_RenderPlayerSprite
    JSR World1_RenderEntitySlots38_47
    JSR World1_RenderEntitySlots30_37
    JSR World1_RenderEntitySlots00_09
    JSR World1_RenderEntitySlots10_29
    RTS

Bank0_Label_968D:
    JSR World1_RenderPlayerSprite
    JSR World1_RenderEntitySlots10_29
    JSR World1_RenderEntitySlots00_09
    JSR World1_RenderEntitySlots30_37
    JSR World1_RenderEntitySlots38_47
    JSR World1_RenderHud
    RTS

World1_RenderPlayerSprite:
    LDA World1PlayerDamageState
    LDA World1PlayerX
    STA World1MetaspriteOriginX
    LDA World1PlayerY
    STA World1MetaspriteOriginY
    LDA #$00
    STA World1MetaspriteOriginXHigh
    STA World1MetaspriteOriginYHigh
    LDA World1PlayerMetasprite
    STA World1MetaspriteIndex
    LDA World1PlayerRenderFlags
    STA World1MetaspriteRenderFlags
    JSR World1_ComposeMetasprite
    RTS

World1_RenderHud:
    LDY #$00
    LDA #$5C
    STA World1OamX
    LDA #$18
    STA World1OamY
    LDA #$00
    STA World1OamAttributes

Bank0_Label_96CA:
    LDA a:ScoreDigitsWorking,Y
    BNE Bank0_Label_96DB
    LDA World1OamX
    CLC
    ADC #$08
    STA World1OamX
    INY
    CPY #$06
    BNE Bank0_Label_96CA

Bank0_Label_96DB:
    LDA a:ScoreDigitsWorking,Y
    AND #$0F
    ORA #$30
    STA World1OamTile
    JSR World1_EmitOamEntry
    LDA World1OamX
    CLC
    ADC #$08
    STA World1OamX
    INY
    CPY #$07
    BNE Bank0_Label_96DB
    LDA #$32
    STA World1OamY
    LDA #$E6
    STA World1OamX
    LDA #$00
    STA World1OamAttributes
    LDA #$3A
    STA World1OamTile
    JSR World1_EmitOamEntry
    LDA #$F0
    STA World1OamX
    LDA PlayerLives
    AND #$0F
    ORA #$30
    STA World1OamTile
    JSR World1_EmitOamEntry
    EmitHealthGauge World1OamY, World1OamX, World1OamAttributes, World1OamTile, World1_EmitOamEntry, Bank0_Label_9730, Bank0_Label_9743, Bank0_Label_974E, Bank0_Label_9754, Bank0_Label_9756
    LDA FrameCounter
    AND #$10
    BEQ Bank0_Label_978E
    LDA #$E8
    STA World1MetaspriteOriginX
    LDA #$96
    STA World1MetaspriteOriginY
    LDA #$00
    STA World1MetaspriteOriginXHigh
    STA World1MetaspriteOriginYHigh
    LDA World1WeaponLevel
    BEQ Bank0_Label_978E
    CLC
    ADC #$29
    STA World1MetaspriteIndex
    LDA #$01
    STA World1MetaspriteRenderFlags
    JSR World1_ComposeMetasprite

Bank0_Label_978E:
    RTS

World1_RenderEntitySlots00_09:
    LDA World1EnemyFreezeActive
    BEQ Bank0_Label_979A
    LDA FrameCounter
    AND #$04
    BEQ Bank0_Label_979A
    RTS

Bank0_Label_979A:
.scope RenderSlots00_09
SlotRenderCpuBase = $979A
    EmitEntitySlotTraversal $00, $0A, World1_RenderEntitySlot00_09, 0
.endscope

World1_RenderEntitySlot00_09:
    LDA a:World1EntityType,Y
    CMP #$D0
    BCC Bank0_Label_97E0
    LDA FrameCounter
    AND #$04
    BEQ Bank0_Label_97E0
    RTS

Bank0_Label_97E0:
    LDA a:World1EntityPositionHigh,Y
    STA World1MetaspriteOriginXHigh
    LSR A
    LSR A
    STA World1MetaspriteOriginYHigh
    LDA a:World1EntityX,Y
    STA World1MetaspriteOriginX
    LDA a:World1EntityY,Y
    STA World1MetaspriteOriginY
    LDA a:World1EntityRenderFlags,Y
    STA World1MetaspriteRenderFlags
    LDA a:World1EntityMetasprite,Y
    STA World1MetaspriteIndex
    JSR World1_ComposeMetasprite
    RTS

World1_RenderEntitySlots10_29:
    LDA World1EnemyFreezeActive
    BEQ Bank0_Label_980C
    LDA FrameCounter
    AND #$04
    BNE Bank0_Label_980C
    RTS

Bank0_Label_980C:
    LDA #$00
    STA World1MetaspriteOriginXHigh
    STA World1MetaspriteOriginYHigh
.scope RenderSlots10_29
SlotRenderCpuBase = $9812
    EmitEntitySlotTraversal $0A, $14, World1_RenderEntitySlot10_29, 0
.endscope

World1_RenderEntitySlot10_29:
    LDA a:World1EntityPositionHigh+$0A,Y
    STA World1MetaspriteOriginXHigh
    LSR A
    LSR A
    STA World1MetaspriteOriginYHigh
    LDA a:World1EntityX+$0A,Y
    STA World1MetaspriteOriginX
    LDA a:World1EntityY+$0A,Y
    STA World1MetaspriteOriginY
    LDA a:World1EntityRenderFlags+$0A,Y
    STA World1MetaspriteRenderFlags
    LDA a:World1EntityMetasprite+$0A,Y
    STA World1MetaspriteIndex
    JMP World1_ComposeMetasprite

World1_RenderEntitySlots30_37:
    LDA #$00
    STA World1MetaspriteOriginXHigh
    STA World1MetaspriteOriginYHigh
.scope RenderSlots30_37
SlotRenderCpuBase = $9870
    EmitEntitySlotTraversal $1E, $08, World1_RenderEntitySlot30_37, 0
.endscope

World1_RenderEntitySlot30_37:
    LDA a:World1EntityPositionHigh+$1E,Y
    STA World1MetaspriteOriginXHigh
    LSR A
    LSR A
    STA World1MetaspriteOriginYHigh
    LDA a:World1EntityX+$1E,Y
    STA World1MetaspriteOriginX
    LDA a:World1EntityY+$1E,Y
    STA World1MetaspriteOriginY
    LDA a:World1EntityRenderFlags+$1E,Y
    STA World1MetaspriteRenderFlags
    LDA a:World1EntityMetasprite+$1E,Y
    STA World1MetaspriteIndex
    JMP World1_ComposeMetasprite

World1_RenderEntitySlots38_47:
    LDA #$00
    STA World1MetaspriteOriginXHigh
    STA World1MetaspriteOriginYHigh
.scope RenderSlots38_47
SlotRenderCpuBase = $98CE
    EmitEntitySlotTraversal $26, $0A, World1_RenderEntitySlot38_47, 1
.endscope
