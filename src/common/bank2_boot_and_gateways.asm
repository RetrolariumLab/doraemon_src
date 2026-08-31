; Doraemon PRG bank 2 $8000-$827C
; Bank 2 reset, NMI, input, mapper switching, and cross-bank gateways
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank2_Func_8000:
    JSR Bank2_Func_80F0
    LDA #$00
    JSR Bank2_Func_81B2
    JMP Bank2_Func_8271

Bank2_Func_800B:
    JSR Bank2_Func_80F0
    LDA #$01
    JSR Bank2_Func_81B2
    JMP Bank2_Func_8271

Bank2_Func_8016:
    JSR Bank2_Func_80F0
    LDA #$02
    JSR Bank2_Func_81B2
    JMP Bank2_Func_8271
    .byte $4C, $74, $82

Bank2_Func_8024:
    JSR Bank2_Func_80F0
    LDA #$00
    JSR Bank2_Func_81B2
    JMP Bank2_Func_8277

Bank2_Func_802F:
    JSR Bank2_Func_80F0
    LDA #$01
    JSR Bank2_Func_81B2
    JMP Bank2_Func_8277

Bank2_Func_803A:
    JSR Bank2_Func_80F0
    LDA #$02
    JSR Bank2_Func_81B2
    JMP Bank2_Func_8277
    .byte $4C, $7A, $82

Bank2_Func_8048:
    JSR Bank2_Func_80F0
    LDA #$03
    JSR Bank2_Func_81B2
    JMP Bank2_Func_8271

Bank2_Func_8053:
    JSR Bank2_Func_80F0
    LDA MapperSelection
    PHA
    LDA #$03
    JSR Bank2_Func_81B2
    JSR Bank2_Func_8277
    PLA
    JMP Bank2_Func_81B2

Bank2_Func_8065:
    JSR Bank2_Func_80F0
    LDA MapperSelection
    PHA
    LDA #$03
    JSR Bank2_Func_81B2
    JSR World3_BuildString
    PLA
    JMP Bank2_Func_81B2

Bank2_Func_8077:
    JSR Bank2_Func_80F0
    LDA #$03
    JSR Bank2_Func_81B2
    JMP Bank2_Label_8280

Bank2_Func_8082:
    JSR Bank2_Func_80F0
    LDA #$03
    JSR Bank2_Func_81B2
    JMP Bank2_Label_8283

Bank2_Func_808D:
    JSR Bank2_Func_80F0
    LDA #$03
    JSR Bank2_Func_81B2
    JMP Bank2_Label_8286

Bank2_Reset:
    LDX #$7F
    TXS
    LDA #$00
    STA a:PPU_MASK
    STA a:PPU_CTRL
    JSR Bank2_WaitForVblank
    JSR Bank2_WaitForVblank
    LDX #$00
    TXA

Bank2_Label_80AC:
    STA a:$0400,X
    STA a:$0500,X
    STA a:World3EntityState,X
    STA a:$0700,X
    INX
    BNE Bank2_Label_80AC
    LDA #$10
    STA PpuCtrlShadow
    STA a:PPU_CTRL
    LDA #$06
    STA PpuMaskShadow
    STA a:PPU_MASK
    JSR Bank2_Func_80DA
    JMP Bank2_Func_8048

Bank2_WaitForVblank:
    LDA a:PPU_STATUS
    BPL Bank2_WaitForVblank

Bank2_Label_80D4:
    LDA a:PPU_STATUS
    BMI Bank2_Label_80D4
    RTS

Bank2_Func_80DA:
    JSR Bank2_WaitForVblank
    LDA #$00
    STA NmiOamDmaRequest
    LDA PpuCtrlShadow
    STA a:PPU_CTRL
    LDA PpuMaskShadow
    AND #$E7
    STA PpuMaskShadow
    STA a:PPU_MASK
    RTS

Bank2_Func_80F0:
    JSR Bank2_Func_80DA
    LDA PpuCtrlShadow
    AND #$7F
    STA PpuCtrlShadow
    STA a:PPU_CTRL
    RTS

Bank2_Func_80FD:
    JSR Bank2_Func_8131
    JSR Bank2_WaitForVblank
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
    LDA #$00
    STA a:OAM_ADDR
    LDA #$03
    STA a:OAM_DMA
    JSR Bank2_WriteMapper
    LDA PpuMaskShadow
    ORA #$18
    STA PpuMaskShadow
    STA a:PPU_MASK
    RTS

Bank2_Func_8131:
    LDA #$F0
    LDX #$00

Bank2_Label_8135:
    STA a:OamBuffer,X
    INX
    BNE Bank2_Label_8135
    RTS

Bank2_Nmi:
    PHA
    TXA
    PHA
    TYA
    PHA
    LDA NmiBusy
    BNE Bank2_Label_81A2
    INC NmiBusy
    LDA NmiOamDmaRequest
    BEQ Bank2_Label_8158
    LDA #$00
    STA a:OAM_ADDR
    LDA #$03
    STA a:OAM_DMA
    JSR Bank2_WriteMapper

Bank2_Label_8158:
    JSR Bank2_Func_8274
    LDA #$01
    STA a:JOYPAD1
    LDA #$00
    STA a:JOYPAD1
    LDX #$08

Bank2_Label_8167:
    LDA a:JOYPAD1
    LSR A
    ROL Controller1Buttons
    LSR A
    ROL Controller1ButtonsAlt
    LDA a:$4017
    LSR A
    ROL Controller2Buttons
    LSR A
    ROL Controller2ButtonsAlt
    DEX
    BNE Bank2_Label_8167
    LDA Controller2Buttons
    AND #$CF
    ORA Controller1Buttons
    ORA Controller1ButtonsAlt
    ORA Controller2ButtonsAlt
    STA CombinedControllerButtons
    LDA a:JOYPAD1
    AND #$04
    CMP $23
    BEQ Bank2_Label_8197
    STA $23
    LDA #$14
    STA $24

Bank2_Label_8197:
    LDA $24
    BEQ Bank2_Label_819D
    DEC $24

Bank2_Label_819D:
    JSR Bank2_Func_827A
    DEC NmiBusy

Bank2_Label_81A2:
    INC FrameCounter
    PLA
    TAY
    PLA
    TAX
    PLA
    RTI

Bank2_Func_81AA:
    ASL A
    ASL A
    AND #$0C
    STA ChrSelectionBits
    LDA MapperSelection

Bank2_Func_81B2:
    AND #$03
    ORA ChrSelectionBits
    STA MapperSelection
    JSR Bank2_WaitForVblank

Bank2_WriteMapper:
    LDA MapperSelection
    TAX
    LDA a:$8261,X
    STA a:$8261,X
    NOP
    NOP
    NOP
    NOP
    RTS

Bank2_Func_81C9:
    STA $07
    LDA $27
    BNE Bank2_Label_81E5
    TYA
    PHA
    TXA
    PHA
    LDA $07
    LSR A
    LSR A
    LSR A
    LSR A
    TAX
    LDA $07
    AND #$0F
    JSR Bank2_Func_81E6
    PLA
    TAX
    PLA
    TAY

Bank2_Label_81E5:
    RTS

Bank2_Func_81E6:
    CLC
    ADC a:ScoreDigitsWorking,X
    LDY #$00

Bank2_Label_81EC:
    CMP #$0A
    BCC Bank2_Label_81F6
    SEC
    SBC #$0A
    INY
    BNE Bank2_Label_81EC

Bank2_Label_81F6:
    STA a:ScoreDigitsWorking,X
    TYA
    BNE Bank2_Label_81FD
    RTS

Bank2_Label_81FD:
    DEX
    BPL Bank2_Func_81E6
    LDA #$09
    LDX #$05

Bank2_Label_8204:
    STA a:ScoreDigitsWorking,X
    STA a:ScoreDigitsCurrent,X
    DEX
    BPL Bank2_Label_8204
    RTS

Bank2_Func_820E:
    LDA $27
    BNE Bank2_Label_8244
    LDA $25
    CMP #$04
    BEQ Bank2_Label_8233
    ASL A
    ASL A
    TAY
    LDX #$00

Bank2_Label_821D:
    LDA a:ScoreDigitsWorking,X
    CMP a:$8251,Y
    BCC Bank2_Label_8233
    BNE Bank2_Label_822D
    INX
    INY
    CPX #$04
    BNE Bank2_Label_821D

Bank2_Label_822D:
    INC $2A
    INC $26
    INC $25

Bank2_Label_8233:
    LDX #$00

Bank2_Label_8235:
    LDA a:ScoreDigitsCurrent,X
    CMP a:ScoreDigitsWorking,X
    BCC Bank2_Label_8245
    BNE Bank2_Label_8244
    INX
    CPX #$06
    BNE Bank2_Label_8235

Bank2_Label_8244:
    RTS

Bank2_Label_8245:
    LDA a:ScoreDigitsWorking,X
    STA a:ScoreDigitsCurrent,X
    INX
    CPX #$06
    BNE Bank2_Label_8245
    RTS
    .byte $00, $00, $02, $00, $00, $00, $08, $00, $00, $02, $00, $00, $00, $05, $00, $00

Bank2_MapperValueTable:
    .byte $00, $10, $20, $30, $01, $11, $21, $31, $02, $12, $22, $32, $03, $13, $23, $33

Bank2_Func_8271:
    JMP Bank2_World3Main

Bank2_Func_8274:
    JMP Bank2_Func_AFED

Bank2_Func_8277:
    JMP Bank2_World3AlternateEntry

Bank2_Func_827A:
    JMP Bank2_Func_AFE6
