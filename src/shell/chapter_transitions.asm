; Doraemon PRG bank 3 $8C3B-$8FF1
; World transitions and interstitial cutscenes
; Generated deterministically from pinned Ghidra/GhidraNes facts

Shell_RunWorld1OpeningTransition:
    LDA #$80
    BNE Bank3_Label_8C45

Bank3_World1ToWorld2Transition:
    LDA #$00
    BEQ Bank3_Label_8C45

Bank3_World2ToWorld3Transition:
    LDA #$01

Bank3_Label_8C45:
    STA $08
    LDX #$7F
    TXS
    LDA #$00
    STA a:AudioMusicState
    JSR Bank3_DisableRenderingForUpdate
    LDA #$03
    JSR Bank3_SelectChrBank
    JSR Shell_ClearBothNametables
    LDA #$BC
    STA $00
    LDA #$AD
    STA $01
    LDA #$20
    STA a:PPU_ADDR
    LDY #$00
    STY a:PPU_ADDR
    LDX #$04

Bank3_Label_8C6E:
    LDA ($00),Y
    STA a:PPU_DATA
    INY
    BNE Bank3_Label_8C6E
    INC $01
    DEX
    BNE Bank3_Label_8C6E
    LDA #$D4
    STA $00
    LDA #$8E
    STA $01
    JSR Shell_CopyPaletteToStaging
    JSR Shell_UploadStagedPalette
    LDA PpuCtrlShadow
    AND #$E7
    ORA #$08
    STA PpuCtrlShadow
    LDX #$00
    STX PpuScrollXShadow
    STX PpuScrollYShadow
    STX $07
    STX $06
    STX $05
    STX a:ShellTransitionCompleteFlag
    INX
    STX $09
    LDA #$00
    STA a:ShellTransitionMotionIndex
    STA a:ShellTransitionSettleStep
    LDA #$70
    STA a:ShellTransitionOriginX
    LDA #$80
    STA a:ShellTransitionOriginY
    LDA #$15
    JSR Audio_QueueEffect
    LDA #$00
    STA FrameCounter
    JSR Bank3_EnableNmiAndRendering

Bank3_Label_8CC1:
    JSR Shell_WaitForNextFrame
    JSR Shell_UpdateTransitionAnimation
    JSR Shell_UpdateTransitionPosition
    JSR Shell_DrawTransitionSprites
    LDA a:ShellTransitionCompleteFlag
    BEQ Bank3_Label_8CC1
    LDA #$00
    JSR Audio_QueueEffect
    LDA $08
    BMI Bank3_Label_8CE3
    BNE Bank3_Label_8CE0
    JMP Bank3_EnterWorld2

Bank3_Label_8CE0:
    JMP Bank3_EnterWorld3

Bank3_Label_8CE3:
    JMP Bank3_EnterWorld1

Shell_UpdateTransitionAnimation:
    LDA #$01
    STA a:$0408
    LDA FrameCounter
    AND #$7F
    BNE Bank3_Label_8CFB
    INC $05
    LDX $05
    LDA a:$8D36,X
    JSR Audio_QueueEffect

Bank3_Label_8CFB:
    LDX $05
    CPX #$04
    BCC Bank3_Label_8D08
    LDA #$01
    STA a:ShellTransitionCompleteFlag
    LDX #$03

Bank3_Label_8D08:
    LDA $06
    CLC
    ADC a:$8D2E,X
    STA $06
    LDA $07
    ADC a:$8D32,X
    AND #$03
    STA $07
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    TAX
    LDY #$00

Bank3_Label_8D21:
    LDA a:$8ED4,X
    STA a:$0210,Y
    INX
    INY
    CPY #$20
    BCC Bank3_Label_8D21
    RTS
    .byte $20, $40, $80, $00, $00, $00, $00, $01, $15, $16, $17, $18

Shell_UpdateTransitionPosition:
    LDA $05
    CMP #$03
    BCS Bank3_Label_8D7A
    LDA FrameCounter
    LSR A
    BCS Bank3_Label_8D5A
    LDX a:ShellTransitionMotionIndex
    INX
    TXA
    AND #$0F
    TAX
    STX a:ShellTransitionMotionIndex
    LDA a:ShellTransitionOriginX
    CLC
    ADC a:$8DA1,X
    STA a:ShellTransitionOriginX

Bank3_Label_8D5A:
    LDA $05
    BEQ Bank3_Label_8D79
    TAX
    LDA FrameCounter
    AND #$01
    ASL A
    CPX #$01
    BNE Bank3_Label_8D6E
    SEC
    SBC #$01
    JMP Bank3_Label_8D72

Bank3_Label_8D6E:
    ASL A
    SEC
    SBC #$02

Bank3_Label_8D72:
    CLC
    ADC a:ShellTransitionOriginY
    STA a:ShellTransitionOriginY

Bank3_Label_8D79:
    RTS

Bank3_Label_8D7A:
    LDA FrameCounter
    AND #$07
    BNE Bank3_Label_8D8B
    LDX a:ShellTransitionSettleStep
    CPX #$03
    BCS Bank3_Label_8D9A
    INX
    STX a:ShellTransitionSettleStep

Bank3_Label_8D8B:
    LDX a:ShellTransitionSettleStep
    LDA a:$8D9B,X
    STA a:ShellTransitionOriginX
    LDA a:$8D9E,X
    STA a:ShellTransitionOriginY

Bank3_Label_8D9A:
    RTS
    .byte $70, $78, $7C, $80, $84, $80, $01, $01, $01, $01, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $01, $01, $01, $01

Shell_DrawTransitionSprites:
    LDA a:ShellTransitionSettleStep
    CMP #$03
    BCS Bank3_Label_8D9A
    ASL A
    TAX
    LDA a:$8DF3,X
    STA $00
    LDA a:$8DF4,X
    STA $01
    JSR Shell_DrawRelativeOamStream
    LDA $08
    BMI Bank3_Label_8D9A
    LDA a:ShellTransitionSettleStep
    ASL A
    TAX
    LDA a:$8DFF,X
    STA $00
    LDA a:$8E00,X
    STA $01
    JSR Shell_DrawRelativeOamStream
    LDA $08
    BEQ Bank3_Label_8D9A
    LDA a:ShellTransitionSettleStep
    ASL A
    TAX
    LDA a:$8DF9,X
    STA $00
    LDA a:$8DFA,X
    STA $01
    JMP Shell_DrawRelativeOamStream
    .byte $33, $8E, $68, $8E, $79, $8E, $7E, $8E, $A3, $8E, $B4, $8E, $B9, $8E, $C6, $8E
    .byte $CF, $8E

Shell_DrawRelativeOamStream:
    LDY #$00

Bank3_Label_8E07:
    LDA ($00),Y
    BEQ Bank3_Label_8D9A
    AND #$FC
    TAX
    LDA ($00),Y
    AND #$03
    STA a:$0302,X
    INY
    LDA ($00),Y
    STA a:$0301,X
    LDA a:ShellTransitionOriginX
    CLC
    INY
    ADC ($00),Y
    STA a:$0303,X
    LDA a:ShellTransitionOriginY
    CLC
    INY
    ADC ($00),Y
    STA a:OamBuffer,X
    INY
    JMP Bank3_Label_8E07
    .byte $CD, $0E, $10, $00, $D1, $0F, $18, $00, $D5, $1D, $08, $08, $D9, $1E, $10, $08
    .byte $DD, $2F, $18, $08, $E0, $2C, $00, $10, $E5, $2D, $08, $10, $E9, $2E, $10, $10
    .byte $ED, $2F, $18, $10, $F2, $3C, $00, $18, $F6, $3D, $08, $18, $FA, $3E, $10, $18
    .byte $FE, $3F, $18, $18, $00, $CD, $0A, $00, $00, $D1, $0B, $08, $00, $D5, $1A, $00
    .byte $08, $D9, $1B, $08, $08, $00, $CD, $1C, $00, $00, $00, $A8, $07, $00, $08, $AC
    .byte $08, $08, $08, $B0, $09, $10, $08, $B4, $17, $00, $10, $B8, $18, $08, $10, $BC
    .byte $19, $10, $10, $C0, $27, $00, $18, $C4, $28, $08, $18, $C8, $29, $10, $18, $00
    .byte $A8, $2A, $00, $00, $AC, $2B, $08, $00, $B0, $3A, $00, $08, $B4, $3B, $08, $08
    .byte $00, $A8, $0C, $00, $00, $00, $98, $60, $18, $08, $9C, $63, $18, $10, $A0, $78
    .byte $18, $18, $00, $98, $1F, $08, $00, $9C, $6F, $08, $08, $00, $98, $0D, $00, $00
    .byte $00, $05, $15, $25, $35, $05, $15, $25, $35, $05, $15, $25, $35, $05, $15, $25
    .byte $35, $05, $0F, $26, $30, $05, $0F, $26, $21, $05, $01, $26, $29, $05, $00, $10
    .byte $20, $35, $05, $15, $25, $35, $15, $25, $35, $35, $15, $25, $35, $35, $15, $25
    .byte $35, $35, $0F, $26, $30, $35, $0F, $26, $21, $35, $01, $26, $29, $35, $00, $10
    .byte $20, $25, $35, $05, $15, $25, $15, $25, $35, $25, $15, $25, $35, $25, $15, $25
    .byte $35, $25, $0F, $26, $30, $25, $0F, $26, $21, $25, $01, $26, $29, $25, $00, $10
    .byte $20, $15, $25, $35, $05, $15, $15, $25, $35, $15, $15, $25, $35, $15, $15, $25
    .byte $35, $15, $0F, $26, $30, $15, $0F, $26, $21, $15, $01, $26, $29, $15, $00, $10
    .byte $20, $AD, $80, $01, $D0, $FB, $60

Shell_WaitForNextFrame:
    LDA FrameCounter

Bank3_Label_8F5C:
    CMP FrameCounter
    BEQ Bank3_Label_8F5C
    RTS
    .byte $A9, $00

Shell_FillTwoNametables:
    PHA
    LDA PpuCtrlShadow
    AND #$FB
    STA a:PPU_CTRL
    LDA #$20
    STA a:PPU_ADDR
    LDA #$00
    STA a:PPU_ADDR
    LDY #$00
    LDX #$08
    PLA

Bank3_Label_8F7A:
    STA a:PPU_DATA
    DEY
    BNE Bank3_Label_8F7A
    DEX
    BNE Bank3_Label_8F7A
    RTS

Shell_UploadPpuCommandStream:
    LDA PpuCtrlShadow
    AND #$FB
    STA PpuCtrlShadow
    STA a:PPU_CTRL

Bank3_Label_8F8D:
    LDY #$00
    LDA ($00),Y
    BEQ Bank3_Label_8FC7
    STA a:PPU_ADDR
    INY
    LDA ($00),Y
    STA a:PPU_ADDR
    INY
    LDA ($00),Y
    TAX
    INY
    PHA
    TYA
    LDY #$00
    CLC
    ADC $00
    STA $00
    BCC Bank3_Label_8FAE
    INC $01

Bank3_Label_8FAE:
    LDA ($00),Y
    STA a:PPU_DATA
    INY
    DEX
    BNE Bank3_Label_8FAE
    PLA
    BEQ Bank3_Label_8FC2
    TYA
    CLC
    ADC $00
    STA $00
    BCC Bank3_Label_8F8D

Bank3_Label_8FC2:
    INC $01
    JMP Bank3_Label_8F8D

Bank3_Label_8FC7:
    RTS
    .byte $A9, $01, $85, $00, $85, $01, $A5, $21, $25, $00, $F0, $0D, $25, $22, $D0, $11
    .byte $A5, $22, $05, $00, $85, $22, $A5, $01, $60, $A5, $00, $49, $FF, $25, $22, $85
    .byte $22, $E6, $01, $06, $00, $90, $DF, $A9, $00, $60
