; Shell PPU updates, palette staging, and ending-credit row streaming
; PRG bank 3, original CPU range $8FF2-$9247

Shell_NmiFrameServices:
    LDA $09
    ASL A
    TAX
    CPX #$06
    BCS Bank3_Label_9002
    LDA a:Bank3_Label_9003+1,X
    PHA
    LDA a:Bank3_Label_9003,X
    PHA

Bank3_Label_9002:
    RTS
Bank3_Label_9003:
    .addr Bank3_Label_9009-1
    .addr Bank3_Label_9067-1
    .addr Bank3_Label_908A-1

Bank3_Label_9009:
    LDA NmiOamDmaRequest
    BEQ Bank3_Label_905B
    LDA PpuCtrlShadow
    STA a:PPU_CTRL
    LDA PpuMaskShadow
    STA a:PPU_MASK
    LDA PpuScrollXShadow
    STA a:PPU_SCROLL
    LDA PpuScrollYShadow
    STA a:PPU_SCROLL
    LDA $0D
    BEQ Bank3_Label_905B
    LDY $0E
    JSR Bank3_Label_905C
    LDA $0F
    ASL A
    ROL A
    AND #$01
    ORA PpuCtrlShadow
    STA a:PPU_CTRL
    LDA $0F
    ASL A
    STA a:PPU_SCROLL
    LDA PpuScrollYShadow
    STA a:PPU_SCROLL
    LDY $10
    JSR Bank3_Label_905C
    LDA $11
    ASL A
    ROL A
    AND #$01
    ORA PpuCtrlShadow
    STA a:PPU_CTRL
    LDA $11
    ASL A
    STA a:PPU_SCROLL
    LDA PpuScrollYShadow
    STA a:PPU_SCROLL

Bank3_Label_905B:
    RTS

Bank3_Label_905C:
    LDX #$15

Bank3_Label_905E:
    DEX
    BNE Bank3_Label_905E
    NOP
    NOP
    DEY
    BNE Bank3_Label_905C
    RTS

Bank3_Label_9067:
    JSR Bank3_Label_9103
    JSR Bank3_Label_912C
    JSR Bank3_Label_90D7
    LDA PpuCtrlShadow
    AND #$FC
    STA a:PPU_CTRL
    LDA PpuMaskShadow
    STA a:PPU_MASK
    LDA PpuScrollXShadow
    STA a:PPU_SCROLL
    LDA PpuScrollYShadow
    STA a:PPU_SCROLL
    JSR Shell_HideAllOamEntries
    RTS

Bank3_Label_908A:
    JSR Bank3_Label_91AF
    JSR Bank3_Label_90D7
    LDA PpuScrollXShadow
    STA a:PPU_SCROLL
    LDA PpuScrollYShadow
    STA a:PPU_SCROLL
    LDA PpuMaskShadow
    STA a:PPU_MASK
    LDA $42
    BEQ Bank3_Label_90BA
    LDA PpuCtrlShadow
    AND #$E0
    STA a:PPU_CTRL

Bank3_Label_90AA:
    BIT a:PPU_STATUS
    BVS Bank3_Label_90AA

Bank3_Label_90AF:
    BIT a:PPU_STATUS
    BVC Bank3_Label_90AF
    LDX #$00

Bank3_Label_90B6:
    NOP
    DEX
    BNE Bank3_Label_90B6

Bank3_Label_90BA:
    LDA PpuCtrlShadow
    AND #$FC
    STA a:PPU_CTRL
    JMP Bank3_Label_919D

Shell_CopyPaletteToStaging:
    LDY #$00

Bank3_Label_90C6:
    LDA ($00),Y
    STA a:$0210,Y
    INY
    CPY #$20
    BCC Bank3_Label_90C6
    RTS

Shell_UploadStagedPalette:
    JSR Bank3_WaitForVblank
    JMP Bank3_Label_90DC
Bank3_Label_90D7:
    LDA a:$0408
    BEQ Bank3_Label_9102

Bank3_Label_90DC:
    LDA #$3F
    STA a:PPU_ADDR
    LDA #$00
    STA a:PPU_ADDR
    LDY #$E0

Bank3_Label_90E8:
    LDA a:$0130,Y
    STA a:PPU_DATA
    INY
    BNE Bank3_Label_90E8
    LDA #$3F
    STA a:PPU_ADDR
    STY a:PPU_ADDR
    STY a:PPU_ADDR
    STY a:PPU_ADDR
    STA a:$0408

Bank3_Label_9102:
    RTS

Bank3_Label_9103:
    LDA PpuScrollYShadow
    AND #$07
    CMP #$03
    BNE Bank3_Label_9102
    LDA a:$0180
    BEQ Bank3_Label_9102
    STA a:PPU_ADDR
    LDA a:$0181
    STA a:PPU_ADDR
    LDX #$00

Bank3_Label_911B:
    LDA a:$0182,X
    STA a:PPU_DATA
    INX
    CPX #$20
    BCC Bank3_Label_911B
    LDA #$00
    STA a:$0180
Bank3_Label_912B:
    RTS

Bank3_Label_912C:
    LDA PpuScrollYShadow
    AND #$07
    CMP #$04
    BNE Bank3_Label_912B
    LDA a:$01C0
    BEQ Bank3_Label_912B
    LDX #$23
    STX a:PPU_ADDR
    STA a:PPU_ADDR
    LDX #$00
    STX a:$01C0

Bank3_Label_9146:
    LDA a:$01C1,X
    STA a:PPU_DATA
    INX
    CPX #$08
    BCC Bank3_Label_9146
    RTS

Shell_ClearBothNametables:
    LDA PpuCtrlShadow
    AND #$FB
    STA PpuCtrlShadow
    AND #$7F
    STA a:PPU_CTRL
    LDA #$20
    STA a:PPU_ADDR
    LDX #$00
    STX a:PPU_ADDR
    LDY #$08
    LDA #$7F

Bank3_Label_916B:
    STA a:PPU_DATA
    INX
    BNE Bank3_Label_916B
    DEY
    BNE Bank3_Label_916B
    LDA #$23
    STA a:PPU_ADDR
    LDA #$C0
    STA a:PPU_ADDR
    LDX #$40
    LDA #$00

Bank3_Label_9182:
    STA a:PPU_DATA
    INX
    BNE Bank3_Label_9182
    LDA #$27
    STA a:PPU_ADDR
    LDA #$C0
    STA a:PPU_ADDR
    LDX #$40
    LDA #$00

Bank3_Label_9196:
    STA a:PPU_DATA
    INX
    BNE Bank3_Label_9196
    RTS
Bank3_Label_919D:
    LDX #$04
    BNE Bank3_Label_91A3

Shell_HideAllOamEntries:
    LDX #$00
Bank3_Label_91A3:
    LDA #$F0

Bank3_Label_91A5:
    STA a:OamBuffer,X
    INX
    INX
    INX
    INX
    BNE Bank3_Label_91A5
Bank3_Label_91AE:
    RTS
Bank3_Label_91AF:
    LDA $41
    BEQ Bank3_Label_91AE
    LDA $40
    STA $00
    LDA #$08
    ASL $00
    ASL $00
    ASL $00
    ASL $00
    ROL A
    ASL $00
    ROL A
    STA a:PPU_ADDR
    LDA $00
    STA a:PPU_ADDR
    LDY #$00

Bank3_Label_91CF:
    LDA ($3E),Y
    STA a:PPU_DATA
    INY
    CPY #$20
    BCC Bank3_Label_91CF
    LDA $3E
    CLC
    ADC #$20
    STA $3E
    LDA $3F
    ADC #$00
    STA $3F
    LDA #$00
    STA $41
    INC $40
    RTS

Bank3_Label_91ED:
    RTS

Shell_StreamEndingCreditRow:
    LDA FrameCounter
    AND #$03
    BNE Bank3_Label_91ED
    LDX PpuScrollYShadow
    INX
    CPX #$F0
    BCC Bank3_Label_91FD
    LDX #$00

Bank3_Label_91FD:
    STX PpuScrollYShadow
    TXA
    AND #$07
    CMP #$03
    BNE Bank3_Label_91ED
    LDA #$08
    STA $01
    LDA PpuScrollYShadow
    AND #$F8
    ASL A
    ROL $01
    ASL A
    ROL $01
    STA a:$0181
    LDA $01
    STA a:$0180
    LDY #$00

Bank3_Label_921E:
    LDA (EndingCreditSourcePointer),Y
    CMP #$20
    BNE Bank3_Label_9226
    LDA #$7F

Bank3_Label_9226:
    CMP #$2E
    BNE Bank3_Label_922C
    LDA #$5B

Bank3_Label_922C:
    CMP #$26
    BNE Bank3_Label_9232
    LDA #$5F

Bank3_Label_9232:
    STA a:$0182,Y
    INY
    CPY #$20
    BCC Bank3_Label_921E
    LDA EndingCreditSourcePointer
    CLC
    ADC #$20
    STA EndingCreditSourcePointer
    LDA EndingCreditSourcePointer+$01
    ADC #$00
    STA EndingCreditSourcePointer+$01
    RTS
