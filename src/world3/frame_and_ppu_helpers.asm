; Doraemon PRG bank 2 $B1BB-$B405
; World 3 frame synchronization, PPU buffers, and metatile update helpers
; Generated deterministically from pinned Ghidra/GhidraNes facts

World3_WaitFrames:
    INC $D6
    LDA World3FrameWaitCounter
    BNE World3_WaitFrames
    RTS

World3_DormantUpdateControllerRepeat:
    LDX #$00
    JSR World3_DormantUpdateControllerRepeatLane
    STA $65
    LDX #$01
    JSR World3_DormantUpdateControllerRepeatLane
    STA $66
    RTS

World3_DormantUpdateControllerRepeatLane:
    LDA Controller1Buttons,X
    BNE Bank2_Label_B1D8
    STA $5F,X
    RTS

Bank2_Label_B1D8:
    LDA $5F,X
    BNE Bank2_Label_B1E3
    LDA #$08
    STA $5F,X
    LDA Controller1Buttons,X
    RTS

Bank2_Label_B1E3:
    DEC $5F,X
    BEQ Bank2_Label_B1EA
    LDA #$00
    RTS

Bank2_Label_B1EA:
    LDA #$04
    STA $5F,X
    LDA Controller1Buttons,X
    RTS

Bank2_Func_B1F1:
    LDY #$00
    LDX $04

Bank2_Label_B1F5:
    LDA ($00),Y
    STA ($02),Y
    INY
    DEX
    BNE Bank2_Label_B1F5
    RTS

Bank2_Func_B1FE:
    LDA #$10
    STA a:PPU_CTRL
    STA PpuCtrlShadow
    LDA #$00
    STA a:PPU_MASK
    JSR World3_WaitForVblankEdge
    LDX #$00
    TXA

Bank2_Label_B210:
    EOR $00,X
    INX
    BNE Bank2_Label_B210
    STA $D6
    TAX
    LDA a:$B1FE,X
    STA $D7
    TAX
    LDA a:$B1FE,X
    STA $D8
    LDX #$3C
    LDA #$00

Bank2_Label_B227:
    STA $00,X
    INX
    CPX #$D6
    BNE Bank2_Label_B227
    LDA #$00
    STA PpuScrollXShadow
    STA PpuScrollYShadow
    LDA #$04
    STA $5E
    LDA #$90
    STA a:PPU_CTRL
    STA PpuCtrlShadow
    LDA #$00
    STA a:$4011
    STA a:APU_STATUS
    STA a:$4010
    LDA #$40
    STA a:$4017
    LDA #$00
    STA a:AudioEffectRequestState
    STA a:AudioMusicState
    STA a:AudioMusicControl
    RTS

World3_HideAllSprites:
    LDX #$00
    LDY #$10

Bank2_Label_B25F:
    LDA #$F4
    STA a:OamBuffer,X
    STA a:$0304,X
    STA a:$0308,X
    STA a:$030C,X
    TXA
    CLC
    ADC #$10
    TAX
    DEY
    BNE Bank2_Label_B25F
    RTS

World3_DisableRendering:
    JSR World3_HideAllSprites
    JSR World3_WaitForVblankEdge
    LDA #$01
    STA World3RenderingDisabled
    LDA #$00
    STA a:PPU_MASK
    RTS

World3_EnableRendering:
    JSR World3_WaitForPpuQueueEmpty
    JSR World3_WaitForVblankEdge
    JSR World3_RunOamDma
    JSR World3_ResetPpuAddressAfterUpdates
    JSR World3_ApplyScroll
    LDA #$00
    STA World3RenderingDisabled
    LDA #$1E
    STA a:PPU_MASK
    RTS

World3_QueuePaletteFromParameters:
    LDX $00
    LDY $01

World3_QueuePalette:
    JSR World3_WaitForPpuQueueSpace
    STX $3C
    STY $3D
    LDX World3PpuQueueWriteIndex
    LDY #$00
    LDA #$3F
    STA a:World3PpuQueue,X
    INX
    LDA #$00
    STA a:World3PpuQueue,X
    INX
    LDA #$20
    STA a:World3PpuQueue,X
    INX

Bank2_Label_B2C0:
    LDA ($3C),Y
    STA a:World3PpuQueue,X
    STA a:World3PaletteShadow,Y
    INX
    INY
    CPY #$20
    BNE Bank2_Label_B2C0
    STX World3PpuQueueWriteIndex
    JSR World3_DrainPpuQueueIfRenderingDisabled
    RTS

World3_FillNametables:
    LDA $00
    LDX #$00

Bank2_Label_B2D8:
    STA a:$04A0,X
    INX
    CPX #$20
    BNE Bank2_Label_B2D8
    LDA #$00
    STA $41

Bank2_Label_B2E4:
    LDX #$00
    LDY $41
    JSR World3_CalculateNametableAddress
    LDX #$A0
    LDY #$04
    LDA #$20
    JSR World3_QueuePpuBlock
    INC $41
    LDA $41
    CMP #$3C
    BNE Bank2_Label_B2E4
    RTS

World3_FillAttributeTables:
    LDA $00
    TAX
    LDA a:World3_AttributePaletteFillValues,X
    LDX #$00

Bank2_Label_B305:
    STA a:World3AttributeShadow,X
    INX
    CPX #$80
    BNE Bank2_Label_B305
    LDA #$00
    STA $3F

Bank2_Label_B311:
    LDX #$00
    LDY $3F
    JSR World3_CalculateAttributeAddress
    LDX #$00
    LDY #$04
    LDA #$20
    JSR World3_QueuePpuBlock
    LDA $3F
    CLC
    ADC #$10
    STA $3F
    CMP #$40
    BNE Bank2_Label_B311
    RTS

World3_DormantQueuePpuBlockFromParameters:
    LDX $00
    LDY $01
    JSR World3_CalculateNametableAddress
    LDX $02
    LDY $03
    LDA $04

World3_QueuePpuBlock:
    JSR World3_WaitForPpuQueueSpace
    STX $3C
    STY $3D
    STA $3E
    LDX World3PpuQueueWriteIndex
    LDY World3PpuQueueVerticalIncrement
    BEQ Bank2_Label_B34B
    LDY #$80

Bank2_Label_B34B:
    TYA
    ORA World3PpuAddressHigh
    STA a:World3PpuQueue,X
    INX
    LDA World3PpuAddressLow
    STA a:World3PpuQueue,X
    INX
    LDA $3E
    STA a:World3PpuQueue,X
    INX
    LDY #$00

Bank2_Label_B360:
    LDA ($3C),Y
    STA a:World3PpuQueue,X
    INX
    INY
    DEC $3E
    BNE Bank2_Label_B360
    STX World3PpuQueueWriteIndex
    JSR World3_DrainPpuQueueIfRenderingDisabled
    RTS

World3_DormantQueuePpuByteFromParameters:
    LDX $00
    LDY $01
    JSR World3_CalculateNametableAddress
    LDA $02
    JSR World3_WaitForPpuQueueSpace
    PHA
    LDX World3PpuQueueWriteIndex
    LDA World3PpuAddressHigh
    STA a:World3PpuQueue,X
    INX
    LDA World3PpuAddressLow
    STA a:World3PpuQueue,X
    INX
    LDA #$01
    STA a:World3PpuQueue,X
    INX
    PLA
    STA a:World3PpuQueue,X
    INX
    STX World3PpuQueueWriteIndex
    JSR World3_DrainPpuQueueIfRenderingDisabled
    RTS

World3_DormantQueueAttributeFromParameters:
    LDX $00
    LDY $01
    LDA $02
    STA $3C
    STX $3D
    STY $3E
    JSR World3_WaitForPpuQueueSpace
    JSR World3_CalculateAttributeAddress
    TXA
    LSR A
    AND #$01
    STA $3D
    TYA
    AND #$02
    CLC
    ADC $3D
    TAX
    LDY $3C
    LDA a:World3_AttributePaletteFillValues,Y
    AND a:World3_AttributeQuadrantSelectMasks,X
    STA $3C
    LDY $41
    LDA a:World3AttributeShadow,Y
    AND a:World3_AttributeQuadrantClearMasks,X
    ORA $3C
    STA a:World3AttributeShadow,Y
    PHA
    LDX World3PpuQueueWriteIndex
    LDA World3PpuAddressHigh
    STA a:World3PpuQueue,X
    INX
    LDA World3PpuAddressLow
    STA a:World3PpuQueue,X
    INX
    LDA #$01
    STA a:World3PpuQueue,X
    INX
    PLA
    STA a:World3PpuQueue,X
    INX
    STX World3PpuQueueWriteIndex
    JSR World3_DrainPpuQueueIfRenderingDisabled
    RTS

World3_AttributePaletteFillValues:
    .byte $00, $55, $AA, $FF

World3_AttributeQuadrantClearMasks:
    .byte $FC, $F3, $CF, $3F

World3_AttributeQuadrantSelectMasks:
    .byte $03, $0C, $30, $C0

Bank2_Func_B3FF:
    JSR Bank2_Func_B406
    JSR Bank2_Func_B460
    RTS
