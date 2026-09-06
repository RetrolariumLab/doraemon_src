; Doraemon PRG bank 3 $8000-$827C
; Reset, NMI, input, mapper switching, and cross-bank gateways
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank3_EnterWorld1:
    JSR Bank3_DisableNmiAndRendering
    LDA #$00
    JSR Bank3_SelectPrgBank
    JMP Bank3_PrimaryEntryDispatch

Bank3_EnterWorld2:
    JSR Bank3_DisableNmiAndRendering
    LDA #$01
    JSR Bank3_SelectPrgBank
    JMP Bank3_PrimaryEntryDispatch

Bank3_EnterWorld3:
    JSR Bank3_DisableNmiAndRendering
    LDA #$02
    JSR Bank3_SelectPrgBank
    JMP Bank3_PrimaryEntryDispatch
    .byte $4C, $74, $82

Bank3_EnterWorld1Demo:
    JSR Bank3_DisableNmiAndRendering
    LDA #$00
    JSR Bank3_SelectPrgBank
    JMP Bank3_SecondaryEntryDispatch

Bank3_EnterWorld2Demo:
    JSR Bank3_DisableNmiAndRendering
    LDA #$01
    JSR Bank3_SelectPrgBank
    JMP Bank3_SecondaryEntryDispatch

Bank3_EnterWorld3Demo:
    JSR Bank3_DisableNmiAndRendering
    LDA #$02
    JSR Bank3_SelectPrgBank
    JMP Bank3_SecondaryEntryDispatch
    .byte $4C, $7A, $82

Bank3_EnterShell:
    JSR Bank3_DisableNmiAndRendering
    LDA #$03
    JSR Bank3_SelectPrgBank
    JMP Bank3_PrimaryEntryDispatch

Bank3_CallShellStatusScreen:
    JSR Bank3_DisableNmiAndRendering
    LDA MapperSelection
    PHA
    LDA #$03
    JSR Bank3_SelectPrgBank
    JSR Bank3_SecondaryEntryDispatch
    PLA
    JMP Bank3_SelectPrgBank

Bank3_CallShellGameOver:
    JSR Bank3_DisableNmiAndRendering
    LDA MapperSelection
    PHA
    LDA #$03
    JSR Bank3_SelectPrgBank
    JSR Bank3_GameOverDispatch
    PLA
    JMP Bank3_SelectPrgBank

Bank3_EnterEnding:
    JSR Bank3_DisableNmiAndRendering
    LDA #$03
    JSR Bank3_SelectPrgBank
    JMP Bank3_EndingDispatch

Bank3_EnterWorld1ToWorld2Transition:
    JSR Bank3_DisableNmiAndRendering
    LDA #$03
    JSR Bank3_SelectPrgBank
    JMP Bank3_World1TransitionDispatch

Bank3_EnterWorld2ToWorld3Transition:
    JSR Bank3_DisableNmiAndRendering
    LDA #$03
    JSR Bank3_SelectPrgBank
    JMP Bank3_World2TransitionDispatch

Bank3_Reset:
    LDX #$7F
    TXS
    LDA #$00
    STA a:PPU_MASK
    STA a:PPU_CTRL
    JSR Bank3_WaitForVblank
    JSR Bank3_WaitForVblank
    LDX #$00
    TXA

Bank3_Label_80AC:
    STA a:$0400,X
    STA a:$0500,X
    STA a:$0600,X
    STA a:$0700,X
    INX
    BNE Bank3_Label_80AC
    LDA #$10
    STA PpuCtrlShadow
    STA a:PPU_CTRL
    LDA #$06
    STA PpuMaskShadow
    STA a:PPU_MASK
    JSR Bank3_DisableRenderingForUpdate
    JMP Bank3_EnterShell

Bank3_WaitForVblank:
    LDA a:PPU_STATUS
    BPL Bank3_WaitForVblank

Bank3_Label_80D4:
    LDA a:PPU_STATUS
    BMI Bank3_Label_80D4
    RTS

Bank3_DisableRenderingForUpdate:
    JSR Bank3_WaitForVblank
    LDA #$00
    STA NmiOamDmaRequest
    LDA PpuCtrlShadow
    STA a:PPU_CTRL
    LDA PpuMaskShadow
    AND #$E7
    STA PpuMaskShadow
    STA a:PPU_MASK
    RTS

Bank3_DisableNmiAndRendering:
    JSR Bank3_DisableRenderingForUpdate
    LDA PpuCtrlShadow
    AND #$7F
    STA PpuCtrlShadow
    STA a:PPU_CTRL
    RTS

Bank3_EnableNmiAndRendering:
    JSR Bank3_HideAllSprites
    JSR Bank3_WaitForVblank
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
    JSR Bank3_WriteMapper
    LDA PpuMaskShadow
    ORA #$18
    STA PpuMaskShadow
    STA a:PPU_MASK
    RTS

Bank3_HideAllSprites:
    LDA #$F0
    LDX #$00

Bank3_Label_8135:
    STA a:OamBuffer,X
    INX
    BNE Bank3_Label_8135
    RTS

Bank3_Nmi:
    PHA
    TXA
    PHA
    TYA
    PHA
    LDA NmiBusy
    BNE Bank3_Label_81A2
    INC NmiBusy
    LDA NmiOamDmaRequest
    BEQ Bank3_Label_8158
    LDA #$00
    STA a:OAM_ADDR
    LDA #$03
    STA a:OAM_DMA
    JSR Bank3_WriteMapper

Bank3_Label_8158:
    JSR Bank3_NmiFrameDispatch
    LDA #$01
    STA a:JOYPAD1
    LDA #$00
    STA a:JOYPAD1
    LDX #$08

Bank3_Label_8167:
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
    BNE Bank3_Label_8167
    LDA Controller2Buttons
    AND #$CF
    ORA Controller1Buttons
    ORA Controller1ButtonsAlt
    ORA Controller2ButtonsAlt
    STA CombinedControllerButtons
    LDA a:JOYPAD1
    AND #$04
    CMP Controller2MicrophoneSample
    BEQ Bank3_Label_8197
    STA Controller2MicrophoneSample
    LDA #$14
    STA Controller2MicrophoneEdgeTimer

Bank3_Label_8197:
    LDA Controller2MicrophoneEdgeTimer
    BEQ Bank3_Label_819D
    DEC Controller2MicrophoneEdgeTimer

Bank3_Label_819D:
    JSR Bank3_AudioFrameDispatch
    DEC NmiBusy

Bank3_Label_81A2:
    INC FrameCounter
    PLA
    TAY
    PLA
    TAX
    PLA
    RTI

Bank3_SelectChrBank:
    ASL A
    ASL A
    AND #$0C
    STA ChrSelectionBits
    LDA MapperSelection

Bank3_SelectPrgBank:
    AND #$03
    ORA ChrSelectionBits
    STA MapperSelection
    JSR Bank3_WaitForVblank

Bank3_WriteMapper:
    LDA MapperSelection
    TAX
    LDA a:$8261,X
    STA a:$8261,X
    NOP
    NOP
    NOP
    NOP
    RTS

Bank3_AddEncodedScore:
    STA $07
    LDA DemoModeActive
    BNE Bank3_Label_81E5
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
    JSR Bank3_AddScoreDigitWithCarry
    PLA
    TAX
    PLA
    TAY

Bank3_Label_81E5:
    RTS

Bank3_AddScoreDigitWithCarry:
    CLC
    ADC a:ScoreDigitsWorking,X
    LDY #$00

Bank3_Label_81EC:
    CMP #$0A
    BCC Bank3_Label_81F6
    SEC
    SBC #$0A
    INY
    BNE Bank3_Label_81EC

Bank3_Label_81F6:
    STA a:ScoreDigitsWorking,X
    TYA
    BNE Bank3_Label_81FD
    RTS

Bank3_Label_81FD:
    DEX
    BPL Bank3_AddScoreDigitWithCarry
    LDA #$09
    LDX #$05

Bank3_Label_8204:
    STA a:ScoreDigitsWorking,X
    STA a:ScoreDigitsCurrent,X
    DEX
    BPL Bank3_Label_8204
    RTS

Bank3_CommitScoreAndCheckExtraLife:
    LDA DemoModeActive
    BNE Bank3_Label_8244
    LDA ExtraLifeScoreThresholdIndex
    CMP #$04
    BEQ Bank3_Label_8233
    ASL A
    ASL A
    TAY
    LDX #$00

Bank3_Label_821D:
    LDA a:ScoreDigitsWorking,X
    CMP a:Bank3_ExtraLifeScoreThresholds,Y
    BCC Bank3_Label_8233
    BNE Bank3_Label_822D
    INX
    INY
    CPX #$04
    BNE Bank3_Label_821D

Bank3_Label_822D:
    INC PlayerLives
    INC ExtraLifeSoundCounter
    INC ExtraLifeScoreThresholdIndex

Bank3_Label_8233:
    LDX #$00

Bank3_Label_8235:
    LDA a:ScoreDigitsCurrent,X
    CMP a:ScoreDigitsWorking,X
    BCC Bank3_Label_8245
    BNE Bank3_Label_8244
    INX
    CPX #$06
    BNE Bank3_Label_8235

Bank3_Label_8244:
    RTS

Bank3_Label_8245:
    LDA a:ScoreDigitsWorking,X
    STA a:ScoreDigitsCurrent,X
    INX
    CPX #$06
    BNE Bank3_Label_8245
    RTS

Bank3_ExtraLifeScoreThresholds:
    .byte $00, $00, $02, $00, $00, $00, $08, $00, $00, $02, $00, $00, $00, $05, $00, $00

Bank3_MapperValueTable:
    .byte $00, $10, $20, $30, $01, $11, $21, $31, $02, $12, $22, $32, $03, $13, $23, $33

Bank3_PrimaryEntryDispatch:
    JMP Bank3_ShellMain

Bank3_NmiFrameDispatch:
    JMP Shell_NmiFrameServices

Bank3_SecondaryEntryDispatch:
    JMP Shell_ShowStatusScreen

Bank3_AudioFrameDispatch:
    JMP Audio_UpdateFrame
