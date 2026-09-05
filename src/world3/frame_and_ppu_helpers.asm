; Doraemon PRG bank 2 $B1BB-$B405
; World 3 frame synchronization, PPU buffers, and metatile update helpers
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank2_Func_B1BB:
    INC $D6
    LDA $68
    BNE Bank2_Func_B1BB
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
    JSR Bank2_Func_B0AF
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

Bank2_Func_B25B:
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

Bank2_Func_B276:
    JSR Bank2_Func_B25B
    JSR Bank2_Func_B0AF
    LDA #$01
    STA $67
    LDA #$00
    STA a:PPU_MASK
    RTS

Bank2_Func_B286:
    JSR Bank2_Func_B062
    JSR Bank2_Func_B0AF
    JSR Bank2_Func_B0A4
    JSR Bank2_Func_B07D
    JSR Bank2_Func_B08E
    LDA #$00
    STA $67
    LDA #$1E
    STA a:PPU_MASK
    RTS

Bank2_Func_B29F:
    LDX $00
    LDY $01

Bank2_Func_B2A3:
    JSR Bank2_Func_B06B
    STX $3C
    STY $3D
    LDX $6C
    LDY #$00
    LDA #$3F
    STA a:$0500,X
    INX
    LDA #$00
    STA a:$0500,X
    INX
    LDA #$20
    STA a:$0500,X
    INX

Bank2_Label_B2C0:
    LDA ($3C),Y
    STA a:$0500,X
    STA a:$0480,Y
    INX
    INY
    CPY #$20
    BNE Bank2_Label_B2C0
    STX $6C
    JSR Bank2_Func_B05A
    RTS

Bank2_Func_B2D4:
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
    JSR Bank2_Func_B0BA
    LDX #$A0
    LDY #$04
    LDA #$20
    JSR Bank2_Func_B33A
    INC $41
    LDA $41
    CMP #$3C
    BNE Bank2_Label_B2E4
    RTS

Bank2_Func_B2FD:
    LDA $00
    TAX
    LDA a:World3_AttributePaletteFillValues,X
    LDX #$00

Bank2_Label_B305:
    STA a:$0400,X
    INX
    CPX #$80
    BNE Bank2_Label_B305
    LDA #$00
    STA $3F

Bank2_Label_B311:
    LDX #$00
    LDY $3F
    JSR Bank2_Func_B0F8
    LDX #$00
    LDY #$04
    LDA #$20
    JSR Bank2_Func_B33A
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
    JSR Bank2_Func_B0BA
    LDX $02
    LDY $03
    LDA $04

Bank2_Func_B33A:
    JSR Bank2_Func_B06B
    STX $3C
    STY $3D
    STA $3E
    LDX $6C
    LDY $72
    BEQ Bank2_Label_B34B
    LDY #$80

Bank2_Label_B34B:
    TYA
    ORA $6A
    STA a:$0500,X
    INX
    LDA $69
    STA a:$0500,X
    INX
    LDA $3E
    STA a:$0500,X
    INX
    LDY #$00

Bank2_Label_B360:
    LDA ($3C),Y
    STA a:$0500,X
    INX
    INY
    DEC $3E
    BNE Bank2_Label_B360
    STX $6C
    JSR Bank2_Func_B05A
    RTS

World3_DormantQueuePpuByteFromParameters:
    LDX $00
    LDY $01
    JSR Bank2_Func_B0BA
    LDA $02
    JSR Bank2_Func_B06B
    PHA
    LDX $6C
    LDA $6A
    STA a:$0500,X
    INX
    LDA $69
    STA a:$0500,X
    INX
    LDA #$01
    STA a:$0500,X
    INX
    PLA
    STA a:$0500,X
    INX
    STX $6C
    JSR Bank2_Func_B05A
    RTS

World3_DormantQueueAttributeFromParameters:
    LDX $00
    LDY $01
    LDA $02
    STA $3C
    STX $3D
    STY $3E
    JSR Bank2_Func_B06B
    JSR Bank2_Func_B0F8
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
    LDA a:$0400,Y
    AND a:World3_AttributeQuadrantClearMasks,X
    ORA $3C
    STA a:$0400,Y
    PHA
    LDX $6C
    LDA $6A
    STA a:$0500,X
    INX
    LDA $69
    STA a:$0500,X
    INX
    LDA #$01
    STA a:$0500,X
    INX
    PLA
    STA a:$0500,X
    INX
    STX $6C
    JSR Bank2_Func_B05A
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
