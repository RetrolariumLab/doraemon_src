; Doraemon PRG bank 0 $8000-$827C
; Bank 0 reset, NMI, input, mapper switching, and cross-bank gateways
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank0_EnterWorld1:
    JSR Bank0_DisableNmiAndRendering
    LDA #$00
    JSR Bank0_SelectPrgBank
    JMP Bank0_PrimaryEntryDispatch

Bank0_EnterWorld2:
    JSR Bank0_DisableNmiAndRendering
    LDA #$01
    JSR Bank0_SelectPrgBank
    JMP Bank0_PrimaryEntryDispatch

Bank0_EnterWorld3:
    JSR Bank0_DisableNmiAndRendering
    LDA #$02
    JSR Bank0_SelectPrgBank
    JMP Bank0_PrimaryEntryDispatch
    .byte $4C, $74, $82

Bank0_EnterWorld1Demo:
    JSR Bank0_DisableNmiAndRendering
    LDA #$00
    JSR Bank0_SelectPrgBank
    JMP Bank0_SecondaryEntryDispatch

Bank0_EnterWorld2Demo:
    JSR Bank0_DisableNmiAndRendering
    LDA #$01
    JSR Bank0_SelectPrgBank
    JMP Bank0_SecondaryEntryDispatch

Bank0_EnterWorld3Demo:
    JSR Bank0_DisableNmiAndRendering
    LDA #$02
    JSR Bank0_SelectPrgBank
    JMP Bank0_SecondaryEntryDispatch
    .byte $4C, $7A, $82

Bank0_EnterShell:
    JSR Bank0_DisableNmiAndRendering
    LDA #$03
    JSR Bank0_SelectPrgBank
    JMP Bank0_PrimaryEntryDispatch

Bank0_CallShellStatusScreen:
    JSR Bank0_DisableNmiAndRendering
    LDA MapperSelection
    PHA
    LDA #$03
    JSR Bank0_SelectPrgBank
    JSR Bank0_SecondaryEntryDispatch
    PLA
    JMP Bank0_SelectPrgBank

Bank0_CallShellGameOver:
    JSR Bank0_DisableNmiAndRendering
    LDA MapperSelection
    PHA
    LDA #$03
    JSR Bank0_SelectPrgBank
    JSR World1_Audio_UpdateFrameWithExtraLifeCue
    PLA
    JMP Bank0_SelectPrgBank

Bank0_EnterEnding:
    JSR Bank0_DisableNmiAndRendering
    LDA #$03
    JSR Bank0_SelectPrgBank
    JMP Bank0_Label_8280

Bank0_EnterWorld1ToWorld2Transition:
    JSR Bank0_DisableNmiAndRendering
    LDA #$03
    JSR Bank0_SelectPrgBank
    JMP Bank0_Label_8283

Bank0_EnterWorld2ToWorld3Transition:
    JSR Bank0_DisableNmiAndRendering
    LDA #$03
    JSR Bank0_SelectPrgBank
    JMP Bank0_Label_8286

Bank0_Reset:
    LDX #$7F
    TXS
    LDA #$00
    STA a:PPU_MASK
    STA a:PPU_CTRL
    JSR Bank0_WaitForVblank
    JSR Bank0_WaitForVblank
    LDX #$00
    TXA

Bank0_Label_80AC:
    STA a:World1EntityType,X
    STA a:World1EntityY+$10,X
    STA a:World1EntityDamageTimerOrAcceleration+$20,X
    STA a:World1AttributeTableCache+$50,X
    INX
    BNE Bank0_Label_80AC
    LDA #$10
    STA PpuCtrlShadow
    STA a:PPU_CTRL
    LDA #$06
    STA PpuMaskShadow
    STA a:PPU_MASK
    JSR Bank0_DisableRenderingForUpdate
    JMP Bank0_EnterShell

Bank0_WaitForVblank:
    LDA a:PPU_STATUS
    BPL Bank0_WaitForVblank

Bank0_Label_80D4:
    LDA a:PPU_STATUS
    BMI Bank0_Label_80D4
    RTS

Bank0_DisableRenderingForUpdate:
    JSR Bank0_WaitForVblank
    LDA #$00
    STA NmiOamDmaRequest
    LDA PpuCtrlShadow
    STA a:PPU_CTRL
    LDA PpuMaskShadow
    AND #$E7
    STA PpuMaskShadow
    STA a:PPU_MASK
    RTS

Bank0_DisableNmiAndRendering:
    JSR Bank0_DisableRenderingForUpdate
    LDA PpuCtrlShadow
    AND #$7F
    STA PpuCtrlShadow
    STA a:PPU_CTRL
    RTS

Bank0_EnableNmiAndRendering:
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
    LDA #$00
    STA a:OAM_ADDR
    LDA #$03
    STA a:OAM_DMA
    JSR Bank0_WriteMapper
    LDA PpuMaskShadow
    ORA #$18
    STA PpuMaskShadow
    STA a:PPU_MASK
    RTS

Bank0_HideAllSprites:
    LDA #$F0
    LDX #$00

Bank0_Label_8135:
    STA a:OamBuffer,X
    INX
    BNE Bank0_Label_8135
    RTS

Bank0_Nmi:
    PHA
    TXA
    PHA
    TYA
    PHA
    LDA NmiBusy
    BNE Bank0_Label_81A2
    INC NmiBusy
    LDA NmiOamDmaRequest
    BEQ Bank0_Label_8158
    LDA #$00
    STA a:OAM_ADDR
    LDA #$03
    STA a:OAM_DMA
    JSR Bank0_WriteMapper

Bank0_Label_8158:
    JSR Bank0_NmiFrameDispatch
    LDA #$01
    STA a:JOYPAD1
    LDA #$00
    STA a:JOYPAD1
    LDX #$08

Bank0_Label_8167:
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
    BNE Bank0_Label_8167
    LDA Controller2Buttons
    AND #$CF
    ORA Controller1Buttons
    ORA Controller1ButtonsAlt
    ORA Controller2ButtonsAlt
    STA CombinedControllerButtons
    LDA a:JOYPAD1
    AND #$04
    CMP Controller2MicrophoneSample
    BEQ Bank0_Label_8197
    STA Controller2MicrophoneSample
    LDA #$14
    STA Controller2MicrophoneEdgeTimer

Bank0_Label_8197:
    LDA Controller2MicrophoneEdgeTimer
    BEQ Bank0_Label_819D
    DEC Controller2MicrophoneEdgeTimer

Bank0_Label_819D:
    JSR Bank0_AudioFrameDispatch
    DEC NmiBusy

Bank0_Label_81A2:
    INC FrameCounter
    PLA
    TAY
    PLA
    TAX
    PLA
    RTI

Bank0_SelectChrBank:
    ASL A
    ASL A
    AND #$0C
    STA ChrSelectionBits
    LDA MapperSelection

Bank0_SelectPrgBank:
    AND #$03
    ORA ChrSelectionBits
    STA MapperSelection
    JSR Bank0_WaitForVblank

Bank0_WriteMapper:
    LDA MapperSelection
    TAX
    LDA a:$8261,X
    STA a:$8261,X
    NOP
    NOP
    NOP
    NOP
    RTS

World1_AddEncodedScore:
    STA $07
    LDA DemoModeActive
    BNE Bank0_Label_81E5
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
    JSR World1_AddScoreDigitWithCarry
    PLA
    TAX
    PLA
    TAY

Bank0_Label_81E5:
    RTS

World1_AddScoreDigitWithCarry:
    CLC
    ADC a:ScoreDigitsWorking,X
    LDY #$00

Bank0_Label_81EC:
    CMP #$0A
    BCC Bank0_Label_81F6
    SEC
    SBC #$0A
    INY
    BNE Bank0_Label_81EC

Bank0_Label_81F6:
    STA a:ScoreDigitsWorking,X
    TYA
    BNE Bank0_Label_81FD
    RTS

Bank0_Label_81FD:
    DEX
    BPL World1_AddScoreDigitWithCarry
    LDA #$09
    LDX #$05

Bank0_Label_8204:
    STA a:ScoreDigitsWorking,X
    STA a:ScoreDigitsCurrent,X
    DEX
    BPL Bank0_Label_8204
    RTS

World1_CommitScoreAndCheckExtraLife:
    LDA DemoModeActive
    BNE Bank0_Label_8244
    LDA ExtraLifeScoreThresholdIndex
    CMP #$04
    BEQ Bank0_Label_8233
    ASL A
    ASL A
    TAY
    LDX #$00

Bank0_Label_821D:
    LDA a:ScoreDigitsWorking,X
    CMP a:Bank0_ExtraLifeScoreThresholds,Y
    BCC Bank0_Label_8233
    BNE Bank0_Label_822D
    INX
    INY
    CPX #$04
    BNE Bank0_Label_821D

Bank0_Label_822D:
    INC PlayerLives
    INC ExtraLifeSoundCounter
    INC ExtraLifeScoreThresholdIndex

Bank0_Label_8233:
    LDX #$00

Bank0_Label_8235:
    LDA a:ScoreDigitsCurrent,X
    CMP a:ScoreDigitsWorking,X
    BCC Bank0_Label_8245
    BNE Bank0_Label_8244
    INX
    CPX #$06
    BNE Bank0_Label_8235

Bank0_Label_8244:
    RTS

Bank0_Label_8245:
    LDA a:ScoreDigitsWorking,X
    STA a:ScoreDigitsCurrent,X
    INX
    CPX #$06
    BNE Bank0_Label_8245
    RTS

Bank0_ExtraLifeScoreThresholds:
    .byte $00, $00, $02, $00, $00, $00, $08, $00, $00, $02, $00, $00, $00, $05, $00, $00

Bank0_MapperValueTable:
    .byte $00, $10, $20, $30, $01, $11, $21, $31, $02, $12, $22, $32, $03, $13, $23, $33

Bank0_PrimaryEntryDispatch:
    JMP Bank0_World1Main

Bank0_NmiFrameDispatch:
    JMP World1_NmiFrameServices

Bank0_SecondaryEntryDispatch:
    JMP World1_DemoEntry

Bank0_AudioFrameDispatch:
    JMP World1_Audio_UpdateFrameWithExtraLifeCue
