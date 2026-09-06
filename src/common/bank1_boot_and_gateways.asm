; Doraemon PRG bank 1 $8000-$827C
; Bank 1 reset, NMI, input, mapper switching, and cross-bank gateways
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank1_Func_8000:
    JSR Bank1_Func_80F0
    LDA #$00
    JSR Bank1_Func_81B2
    JMP Bank1_Func_8271

Bank1_Func_800B:
    JSR Bank1_Func_80F0
    LDA #$01
    JSR Bank1_Func_81B2
    JMP Bank1_Func_8271

Bank1_Func_8016:
    JSR Bank1_Func_80F0
    LDA #$02
    JSR Bank1_Func_81B2
    JMP Bank1_Func_8271
    .byte $4C, $74, $82

Bank1_Func_8024:
    JSR Bank1_Func_80F0
    LDA #$00
    JSR Bank1_Func_81B2
    JMP Bank1_Func_8277

Bank1_Func_802F:
    JSR Bank1_Func_80F0
    LDA #$01
    JSR Bank1_Func_81B2
    JMP Bank1_Func_8277

Bank1_Func_803A:
    JSR Bank1_Func_80F0
    LDA #$02
    JSR Bank1_Func_81B2
    JMP Bank1_Func_8277
    .byte $4C, $7A, $82

Bank1_Func_8048:
    JSR Bank1_Func_80F0
    LDA #$03
    JSR Bank1_Func_81B2
    JMP Bank1_Func_8271

Bank1_Func_8053:
    JSR Bank1_Func_80F0
    LDA MapperSelection
    PHA
    LDA #$03
    JSR Bank1_Func_81B2
    JSR Bank1_Func_8277
    PLA
    JMP Bank1_Func_81B2

Bank1_Func_8065:
    JSR Bank1_Func_80F0
    LDA MapperSelection
    PHA
    LDA #$03
    JSR Bank1_Func_81B2
    JSR Bank1_Func_827D
    PLA
    JMP Bank1_Func_81B2

Bank1_Func_8077:
    JSR Bank1_Func_80F0
    LDA #$03
    JSR Bank1_Func_81B2
    JMP Bank1_Label_8280

Bank1_Func_8082:
    JSR Bank1_Func_80F0
    LDA #$03
    JSR Bank1_Func_81B2
    JMP Bank1_Label_8283

Bank1_Func_808D:
    JSR Bank1_Func_80F0
    LDA #$03
    JSR Bank1_Func_81B2
    JMP Bank1_Func_8286

Bank1_Reset:
    LDX #$7F
    TXS
    LDA #$00
    STA a:PPU_MASK
    STA a:PPU_CTRL
    JSR Bank1_WaitForVblank
    JSR Bank1_WaitForVblank
    LDX #$00
    TXA

Bank1_Label_80AC:
    STA a:World2ScreenMetatiles,X
    STA a:$0500,X
    STA a:$0600,X
    STA a:$0700,X
    INX
    BNE Bank1_Label_80AC
    LDA #$10
    STA PpuCtrlShadow
    STA a:PPU_CTRL
    LDA #$06
    STA PpuMaskShadow
    STA a:PPU_MASK
    JSR Bank1_Func_80DA
    JMP Bank1_Func_8048

Bank1_WaitForVblank:
    LDA a:PPU_STATUS
    BPL Bank1_WaitForVblank

Bank1_Label_80D4:
    LDA a:PPU_STATUS
    BMI Bank1_Label_80D4
    RTS

Bank1_Func_80DA:
    JSR Bank1_WaitForVblank
    LDA #$00
    STA NmiOamDmaRequest
    LDA PpuCtrlShadow
    STA a:PPU_CTRL
    LDA PpuMaskShadow
    AND #$E7
    STA PpuMaskShadow
    STA a:PPU_MASK
    RTS

Bank1_Func_80F0:
    JSR Bank1_Func_80DA
    LDA PpuCtrlShadow
    AND #$7F
    STA PpuCtrlShadow
    STA a:PPU_CTRL
    RTS

Bank1_Func_80FD:
    JSR Bank1_Func_8131
    JSR Bank1_WaitForVblank
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
    JSR Bank1_WriteMapper
    LDA PpuMaskShadow
    ORA #$18
    STA PpuMaskShadow
    STA a:PPU_MASK
    RTS

Bank1_Func_8131:
    LDA #$F0
    LDX #$00

Bank1_Label_8135:
    STA a:OamBuffer,X
    INX
    BNE Bank1_Label_8135
    RTS

Bank1_Nmi:
    PHA
    TXA
    PHA
    TYA
    PHA
    LDA NmiBusy
    BNE Bank1_Label_81A2
    INC NmiBusy
    LDA NmiOamDmaRequest
    BEQ Bank1_Label_8158
    LDA #$00
    STA a:OAM_ADDR
    LDA #$03
    STA a:OAM_DMA
    JSR Bank1_WriteMapper

Bank1_Label_8158:
    JSR Bank1_Func_8274
    LDA #$01
    STA a:JOYPAD1
    LDA #$00
    STA a:JOYPAD1
    LDX #$08

Bank1_Label_8167:
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
    BNE Bank1_Label_8167
    LDA Controller2Buttons
    AND #$CF
    ORA Controller1Buttons
    ORA Controller1ButtonsAlt
    ORA Controller2ButtonsAlt
    STA CombinedControllerButtons
    LDA a:JOYPAD1
    AND #$04
    CMP Controller2MicrophoneSample
    BEQ Bank1_Label_8197
    STA Controller2MicrophoneSample
    LDA #$14
    STA Controller2MicrophoneEdgeTimer

Bank1_Label_8197:
    LDA Controller2MicrophoneEdgeTimer
    BEQ Bank1_Label_819D
    DEC Controller2MicrophoneEdgeTimer

Bank1_Label_819D:
    JSR Bank1_Func_827A
    DEC NmiBusy

Bank1_Label_81A2:
    INC FrameCounter
    PLA
    TAY
    PLA
    TAX
    PLA
    RTI

Bank1_Func_81AA:
    ASL A
    ASL A
    AND #$0C
    STA ChrSelectionBits
    LDA MapperSelection

Bank1_Func_81B2:
    AND #$03
    ORA ChrSelectionBits
    STA MapperSelection
    JSR Bank1_WaitForVblank

Bank1_WriteMapper:
    LDA MapperSelection
    TAX
    LDA a:$8261,X
    STA a:$8261,X
    NOP
    NOP
    NOP
    NOP
    RTS

World2_AddEncodedScore:
    STA $07
    LDA DemoModeActive
    BNE Bank1_Label_81E5
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
    JSR World2_AddScoreDigitWithCarry
    PLA
    TAX
    PLA
    TAY

Bank1_Label_81E5:
    RTS

World2_AddScoreDigitWithCarry:
    CLC
    ADC a:ScoreDigitsWorking,X
    LDY #$00

Bank1_Label_81EC:
    CMP #$0A
    BCC Bank1_Label_81F6
    SEC
    SBC #$0A
    INY
    BNE Bank1_Label_81EC

Bank1_Label_81F6:
    STA a:ScoreDigitsWorking,X
    TYA
    BNE Bank1_Label_81FD
    RTS

Bank1_Label_81FD:
    DEX
    BPL World2_AddScoreDigitWithCarry
    LDA #$09
    LDX #$05

Bank1_Label_8204:
    STA a:ScoreDigitsWorking,X
    STA a:ScoreDigitsCurrent,X
    DEX
    BPL Bank1_Label_8204
    RTS

World2_CommitScoreAndCheckExtraLife:
    LDA DemoModeActive
    BNE Bank1_Label_8244
    LDA ExtraLifeScoreThresholdIndex
    CMP #$04
    BEQ Bank1_Label_8233
    ASL A
    ASL A
    TAY
    LDX #$00

Bank1_Label_821D:
    LDA a:ScoreDigitsWorking,X
    CMP a:Bank1_ExtraLifeScoreThresholds,Y
    BCC Bank1_Label_8233
    BNE Bank1_Label_822D
    INX
    INY
    CPX #$04
    BNE Bank1_Label_821D

Bank1_Label_822D:
    INC PlayerLives
    INC ExtraLifeSoundCounter
    INC ExtraLifeScoreThresholdIndex

Bank1_Label_8233:
    LDX #$00

Bank1_Label_8235:
    LDA a:ScoreDigitsCurrent,X
    CMP a:ScoreDigitsWorking,X
    BCC Bank1_Label_8245
    BNE Bank1_Label_8244
    INX
    CPX #$06
    BNE Bank1_Label_8235

Bank1_Label_8244:
    RTS

Bank1_Label_8245:
    LDA a:ScoreDigitsWorking,X
    STA a:ScoreDigitsCurrent,X
    INX
    CPX #$06
    BNE Bank1_Label_8245
    RTS

Bank1_ExtraLifeScoreThresholds:
    .byte $00, $00, $02, $00, $00, $00, $08, $00, $00, $02, $00, $00, $00, $05, $00, $00

Bank1_MapperValueTable:
    .byte $00, $10, $20, $30, $01, $11, $21, $31, $02, $12, $22, $32, $03, $13, $23, $33

Bank1_Func_8271:
    JMP Bank1_World2Main

Bank1_Func_8274:
    JMP Bank1_Func_829F

Bank1_Func_8277:
    JMP World2_DemoEntry

Bank1_Func_827A:
    JMP World2_Audio_UpdateFrame
