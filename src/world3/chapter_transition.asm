; Doraemon PRG bank 2 $AE12-$B1BA
; World 3 completion sequence, transition loop, and support routines
; Generated deterministically from pinned Ghidra/GhidraNes facts

World3_RunChapterCompletionSequence:
    JSR World3_InitializePlayerState
    LDA #$00
    STA $00
    LDA #$00
    STA $01
    LDA #$08
    STA $02
    LDA #$07
    STA a:AudioMusicState
    LDA #$00
    STA a:AudioMusicControl

Bank2_Label_AE2B:
    LDX #$7F
    TXS
    LDA #$00
    STA World3FrameWaitCounter
    LDA #$00
    STA World3OamWriteIndex
    JSR World3_RenderPlayer
    JSR World3_RenderEntities
    JSR World3_UpdateChapterCompletionWipe
    LDA #$01
    STA NmiOamDmaRequest
    LDA #$01
    STA World3FrameWaitCounter
    JSR World3_WaitFrames
    LDA $02
    BNE Bank2_Label_AE2B

Bank2_Label_AE4E:
    LDA a:AudioMusicState
    BMI Bank2_Label_AE4E
    LDA #$5A
    STA World3FrameWaitCounter
    JSR World3_WaitFrames
    JMP Bank2_EnterEnding

World3_UpdateChapterCompletionWipe:
    LDA $02
    BEQ Bank2_Label_AEBF
    LDX #$00
    LDY $01
    JSR World3_CalculateNametableAddress
    LDA #$00
    STA World3PpuQueueVerticalIncrement
    LDX #$F2
    LDY #$AE
    LDA #$20
    JSR World3_QueuePpuBlock
    LDX #$00
    LDA #$1D
    SEC
    SBC $01
    TAY
    JSR World3_CalculateNametableAddress
    LDA #$00
    STA World3PpuQueueVerticalIncrement
    LDX #$F2
    LDY #$AE
    LDA #$20
    JSR World3_QueuePpuBlock
    LDX $00
    LDY #$00
    JSR World3_CalculateNametableAddress
    LDA #$01
    STA World3PpuQueueVerticalIncrement
    LDX #$12
    LDY #$AF
    LDA #$1E
    JSR World3_QueuePpuBlock
    LDA #$1F
    SEC
    SBC $00
    TAX
    LDY #$00
    JSR World3_CalculateNametableAddress
    LDA #$01
    STA World3PpuQueueVerticalIncrement
    LDX #$12
    LDY #$AF
    LDA #$1E
    JSR World3_QueuePpuBlock
    INC $00
    INC $01
    DEC $02

Bank2_Label_AEBF:
    LDA #$6C
    STA World3PlayerX
    LDA #$78
    STA World3PlayerY
    LDA #$0D
    STA World3PlayerMetaspriteBase
    LDA #$00
    STA World3PlayerAnimationFrame
    LDY #$00

Bank2_Label_AED1:
    LDA a:World3EntityState,Y
    CMP #$01
    BNE Bank2_Label_AEEC
    LDA a:World3EntityType,Y
    CMP #$1F
    BNE Bank2_Label_AEE7
    LDA #$00
    STA a:World3EntityMetaspriteVariantBit1,Y
    JMP Bank2_Label_AEEC

Bank2_Label_AEE7:
    LDA #$00
    STA a:World3EntityState,Y

Bank2_Label_AEEC:
    INY
    CPY #$08
    BNE Bank2_Label_AED1
    RTS

World3_CompletionBlankRow:
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

World3_CompletionBlankColumn:
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

World3_RenderRoom3FCompletionMarker:
    LDA World3CurrentRoom
    CMP #$3F
    BNE Bank2_Label_AF50
    INC World3Room3FMarkerBlinkCounter
    LDA World3Room3FMarkerBlinkCounter
    AND #$10
    BNE Bank2_Label_AF50
    LDX #$70
    LDY #$74
    JSR World3_SetMetaspriteOriginFromXY
    LDA #$00
    STA World3MetaspriteRenderFlags
    LDA #$AC
    STA World3MetaspriteIndex
    JSR World3_ComposeMetasprite

Bank2_Label_AF50:
    RTS

World3_HaltWithDiagnosticCode:
    PHA
    JSR World3_HideAllSprites
    PLA
    ORA #$30
    STA a:$0301
    LDA #$80
    STA a:OamBuffer
    STA a:$0303
    LDA #$00
    STA a:$0302
    LDA #$01
    STA NmiOamDmaRequest

Bank2_Label_AF6C:
    JMP Bank2_Label_AF6C

World3_SetupDebugSpriteTestScreen:
    JSR Bank2_DisableRenderingForUpdate
    LDA #$90
    STA PpuCtrlShadow
    LDA #$02
    JSR Bank2_SelectChrBank
    JSR World3_DisableRendering
    LDX #$EE
    LDY #$BD
    STX $00
    STY $01
    JSR World3_QueuePaletteFromParameters
    LDA #$00
    STA $00
    JSR World3_FillNametables
    LDA #$00
    STA $00
    JSR World3_FillAttributeTables
    JSR World3_HideAllSprites
    JSR Bank2_EnableNmiAndRendering
    JSR World3_EnableRendering
    LDX #$C6
    LDY #$AF
    STX $00
    STY $01
    LDX #$00
    LDY #$03
    STX $02
    STY $03
    LDA #$20
    STA $04
    JSR World3_CopyBytes
    LDA #$01
    STA NmiOamDmaRequest
    LDA #$07
    STA a:AudioMusicState
    LDA #$00
    STA a:AudioMusicControl
    RTS

World3_DebugSpriteTestOam:
    .byte $58, $EE, $00, $78, $58, $EF, $00, $80, $60, $FE, $00, $78, $60, $FF, $00, $80
    .byte $68, $2E, $00, $78, $68, $2F, $00, $80, $70, $E5, $00, $78, $70, $F5, $00, $80

World3_Audio_UpdateFrame:
    JSR World3_Audio_UpdateEffects
    JSR World3_Audio_UpdateMusic
    RTS

World3_NmiFrameServices:
    LDA World3RenderingDisabled
    BNE Bank2_Label_B008
    JSR World3_DrainOnePpuQueueRecord
    JSR World3_ResetPpuAddressAfterUpdates
    JSR World3_ApplyScroll
    LDA NmiOamDmaRequest
    BEQ Bank2_Label_B008
    LDA #$00
    STA NmiOamDmaRequest
    JSR World3_HideAllSprites
    JSR World3_ToggleOamBufferHalf

Bank2_Label_B008:
    DEC World3FrameWaitCounter
    INC $E1
    RTS

World3_DrainOnePpuQueueRecord:
    LDX World3PpuQueueReadIndex
    LDA #$01
    STA World3PpuQueueRecordBudget
    LDA #$00
    STA World3PpuQueueByteCount

Bank2_Label_B017:
    CPX World3PpuQueueWriteIndex
    BEQ Bank2_Label_B057
    LDY #$00
    LDA a:World3PpuQueue,X
    BPL Bank2_Label_B024
    LDY #$04

Bank2_Label_B024:
    AND #$7F
    STA a:PPU_ADDR
    INX
    LDA a:World3PpuQueue,X
    STA a:PPU_ADDR
    INX
    TYA
    ORA PpuCtrlShadow
    ORA World3NametableSelect
    STA a:PPU_CTRL
    LDA a:World3PpuQueue,X
    TAY
    INX
    CLC
    ADC World3PpuQueueByteCount
    STA World3PpuQueueByteCount

Bank2_Label_B043:
    LDA a:World3PpuQueue,X
    STA a:PPU_DATA
    INX
    DEY
    BNE Bank2_Label_B043
    DEC World3PpuQueueRecordBudget
    BEQ Bank2_Label_B057
    LDA World3PpuQueueByteCount
    CMP #$30
    BCC Bank2_Label_B017

Bank2_Label_B057:
    STX World3PpuQueueReadIndex
    RTS

World3_DrainPpuQueueIfRenderingDisabled:
    LDA World3RenderingDisabled
    BEQ Bank2_Label_B061
    JSR World3_DrainOnePpuQueueRecord

Bank2_Label_B061:
    RTS

World3_WaitForPpuQueueEmpty:
    PHA

Bank2_Label_B063:
    LDA World3PpuQueueWriteIndex
    CMP World3PpuQueueReadIndex
    BNE Bank2_Label_B063
    PLA
    RTS

World3_WaitForPpuQueueSpace:
    PHA

Bank2_Label_B06C:
    LDA World3PpuQueueWriteIndex
    CMP World3PpuQueueReadIndex
    BEQ Bank2_Label_B07B
    LDA World3PpuQueueReadIndex
    SEC
    SBC World3PpuQueueWriteIndex
    CMP #$24
    BCC Bank2_Label_B06C

Bank2_Label_B07B:
    PLA
    RTS

World3_ResetPpuAddressAfterUpdates:
    LDA #$3F
    STA a:PPU_ADDR
    LDA #$00
    STA a:PPU_ADDR
    STA a:PPU_ADDR
    STA a:PPU_ADDR
    RTS

World3_ApplyScroll:
    LDA World3ScrollX
    STA a:PPU_SCROLL
    LDA World3ScrollY
    STA a:PPU_SCROLL
    LDA PpuCtrlShadow
    AND #$FC
    ORA World3NametableSelect
    STA PpuCtrlShadow
    STA a:PPU_CTRL
    RTS

World3_RunOamDma:
    LDA #$00
    STA a:OAM_ADDR
    LDA #$03
    STA a:OAM_DMA
    RTS

World3_WaitForVblankEdge:
    LDA a:PPU_STATUS
    BMI World3_WaitForVblankEdge

Bank2_Label_B0B4:
    LDA a:PPU_STATUS
    BPL Bank2_Label_B0B4
    RTS

World3_CalculateNametableAddress:
    LDA #$20
    STA World3PpuAddressHigh
    CPX #$20
    BCC Bank2_Label_B0CB
    TXA
    SEC
    SBC #$20
    TAX
    LDA #$24
    STA World3PpuAddressHigh

Bank2_Label_B0CB:
    CPY #$1E
    BCC Bank2_Label_B0D8
    TYA
    SEC
    SBC #$1E
    TAY
    LDA #$24
    STA World3PpuAddressHigh

Bank2_Label_B0D8:
    LDA #$00
    STA World3PpuAddressLow
    TYA
    LSR A
    ROR World3PpuAddressLow
    LSR A
    ROR World3PpuAddressLow
    LSR A
    ROR World3PpuAddressLow
    CLC
    ADC World3PpuAddressHigh
    STA World3PpuAddressHigh
    TXA
    CLC
    ADC World3PpuAddressLow
    STA World3PpuAddressLow
    LDA World3PpuAddressHigh
    ADC #$00
    STA World3PpuAddressHigh
    RTS

World3_CalculateAttributeAddress:
    LDA #$23
    STA World3PpuAddressHigh
    LDA #$00
    STA $41
    CPX #$20
    BCC Bank2_Label_B111
    TXA
    SEC
    SBC #$20
    TAX
    LDA #$27
    STA World3PpuAddressHigh
    LDA #$40
    STA $41

Bank2_Label_B111:
    CPY #$1E
    BCC Bank2_Label_B122
    TYA
    SEC
    SBC #$1E
    TAY
    LDA #$27
    STA World3PpuAddressHigh
    LDA #$40
    STA $41

Bank2_Label_B122:
    TYA
    AND #$FC
    ASL A
    STA $40
    TXA
    LSR A
    LSR A
    CLC
    ADC $40
    ORA $41
    STA $41
    ORA #$C0
    STA World3PpuAddressLow
    RTS

World3_DormantAbsoluteValue16:
    CMP #$80
    BCC Bank2_Label_B148
    PHA
    TXA
    EOR #$FF
    CLC
    ADC #$01
    TAX
    PLA
    EOR #$FF
    ADC #$00

Bank2_Label_B148:
    RTS

World3_AbsoluteValue8:
    CMP #$80
    BCC Bank2_Label_B152
    EOR #$FF
    CLC
    ADC #$01

Bank2_Label_B152:
    RTS

World3_RandomByte:
    INC $D6
    DEC $D7
    BNE Bank2_Label_B15D
    LDA #$75
    STA $D7

Bank2_Label_B15D:
    LDA $D6
    CMP #$77
    BNE Bank2_Label_B167
    LDA #$01
    STA $D6

Bank2_Label_B167:
    EOR $D7
    ASL A
    PHP
    LSR A
    PLP
    ROL A
    ASL A
    PHP
    LSR A
    PLP
    ROL A
    EOR $D8
    SEC
    SBC $D7
    CLC
    ADC $D6
    CLC
    ADC $D6
    STA $D8
    STX $E2
    LDX $E1
    EOR $00,X
    LDX $E2
    RTS

World3_DormantRandomByte:
    INC $D9
    DEC $DA
    BNE Bank2_Label_B193
    LDA #$75
    STA $DA

Bank2_Label_B193:
    LDA $D9
    CMP #$77
    BNE Bank2_Label_B19D
    LDA #$01
    STA $D9

Bank2_Label_B19D:
    EOR $DA
    ASL A
    PHP
    LSR A
    PLP
    ROL A
    ASL A
    PHP
    LSR A
    PLP
    ROL A
    EOR $DB
    SEC
    SBC $DA
    CLC
    ADC $D9
    CLC
    ADC $D9
    STA $DB
    RTS

World3_DormantWaitFramesFromParameter:
    LDA $00
    STA World3FrameWaitCounter
