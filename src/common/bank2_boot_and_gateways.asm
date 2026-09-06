; Doraemon PRG bank 2 $8000-$827C
; Bank 2 reset, NMI, input, mapper switching, and cross-bank gateways
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank2_EnterWorld1:
    JSR Bank2_DisableNmiAndRendering
    LDA #$00
    JSR Bank2_SelectPrgBank
    JMP Bank2_PrimaryEntryDispatch

Bank2_EnterWorld2:
    JSR Bank2_DisableNmiAndRendering
    LDA #$01
    JSR Bank2_SelectPrgBank
    JMP Bank2_PrimaryEntryDispatch

Bank2_EnterWorld3:
    JSR Bank2_DisableNmiAndRendering
    LDA #$02
    JSR Bank2_SelectPrgBank
    JMP Bank2_PrimaryEntryDispatch
    .byte $4C, $74, $82

Bank2_EnterWorld1Demo:
    JSR Bank2_DisableNmiAndRendering
    LDA #$00
    JSR Bank2_SelectPrgBank
    JMP Bank2_SecondaryEntryDispatch

Bank2_EnterWorld2Demo:
    JSR Bank2_DisableNmiAndRendering
    LDA #$01
    JSR Bank2_SelectPrgBank
    JMP Bank2_SecondaryEntryDispatch

Bank2_EnterWorld3Demo:
    JSR Bank2_DisableNmiAndRendering
    LDA #$02
    JSR Bank2_SelectPrgBank
    JMP Bank2_SecondaryEntryDispatch
    .byte $4C, $7A, $82

Bank2_EnterShell:
    JSR Bank2_DisableNmiAndRendering
    LDA #$03
    JSR Bank2_SelectPrgBank
    JMP Bank2_PrimaryEntryDispatch

Bank2_CallShellStatusScreen:
    JSR Bank2_DisableNmiAndRendering
    LDA MapperSelection
    PHA
    LDA #$03
    JSR Bank2_SelectPrgBank
    JSR Bank2_SecondaryEntryDispatch
    PLA
    JMP Bank2_SelectPrgBank

Bank2_CallShellGameOver:
    JSR Bank2_DisableNmiAndRendering
    LDA MapperSelection
    PHA
    LDA #$03
    JSR Bank2_SelectPrgBank
    JSR World3_BuildString
    PLA
    JMP Bank2_SelectPrgBank

Bank2_EnterEnding:
    JSR Bank2_DisableNmiAndRendering
    LDA #$03
    JSR Bank2_SelectPrgBank
    JMP Bank2_Label_8280

Bank2_EnterWorld1ToWorld2Transition:
    JSR Bank2_DisableNmiAndRendering
    LDA #$03
    JSR Bank2_SelectPrgBank
    JMP Bank2_Label_8283

Bank2_EnterWorld2ToWorld3Transition:
    JSR Bank2_DisableNmiAndRendering
    LDA #$03
    JSR Bank2_SelectPrgBank
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
    STA a:World3AttributeShadow,X
    STA a:World3PpuQueue,X
    STA a:World3EntityState,X
    STA a:World3PlayerProjectileDirection+$01,X
    INX
    BNE Bank2_Label_80AC
    LDA #$10
    STA PpuCtrlShadow
    STA a:PPU_CTRL
    LDA #$06
    STA PpuMaskShadow
    STA a:PPU_MASK
    JSR Bank2_DisableRenderingForUpdate
    JMP Bank2_EnterShell

Bank2_WaitForVblank:
    LDA a:PPU_STATUS
    BPL Bank2_WaitForVblank

Bank2_Label_80D4:
    LDA a:PPU_STATUS
    BMI Bank2_Label_80D4
    RTS

Bank2_DisableRenderingForUpdate:
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

Bank2_DisableNmiAndRendering:
    JSR Bank2_DisableRenderingForUpdate
    LDA PpuCtrlShadow
    AND #$7F
    STA PpuCtrlShadow
    STA a:PPU_CTRL
    RTS

Bank2_EnableNmiAndRendering:
    JSR Bank2_HideAllSprites
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

Bank2_HideAllSprites:
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
    JSR Bank2_NmiFrameDispatch
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
    CMP Controller2MicrophoneSample
    BEQ Bank2_Label_8197
    STA Controller2MicrophoneSample
    LDA #$14
    STA Controller2MicrophoneEdgeTimer

Bank2_Label_8197:
    LDA Controller2MicrophoneEdgeTimer
    BEQ Bank2_Label_819D
    DEC Controller2MicrophoneEdgeTimer

Bank2_Label_819D:
    JSR Bank2_AudioFrameDispatch
    DEC NmiBusy

Bank2_Label_81A2:
    INC FrameCounter
    PLA
    TAY
    PLA
    TAX
    PLA
    RTI

Bank2_SelectChrBank:
    ASL A
    ASL A
    AND #$0C
    STA ChrSelectionBits
    LDA MapperSelection

Bank2_SelectPrgBank:
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

World3_AddEncodedScore:
    STA $07
    LDA DemoModeActive
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
    JSR World3_AddScoreDigitWithCarry
    PLA
    TAX
    PLA
    TAY

Bank2_Label_81E5:
    RTS

World3_AddScoreDigitWithCarry:
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
    BPL World3_AddScoreDigitWithCarry
    LDA #$09
    LDX #$05

Bank2_Label_8204:
    STA a:ScoreDigitsWorking,X
    STA a:ScoreDigitsCurrent,X
    DEX
    BPL Bank2_Label_8204
    RTS

World3_CommitScoreAndCheckExtraLife:
    LDA DemoModeActive
    BNE Bank2_Label_8244
    LDA ExtraLifeScoreThresholdIndex
    CMP #$04
    BEQ Bank2_Label_8233
    ASL A
    ASL A
    TAY
    LDX #$00

Bank2_Label_821D:
    LDA a:ScoreDigitsWorking,X
    CMP a:Bank2_ExtraLifeScoreThresholds,Y
    BCC Bank2_Label_8233
    BNE Bank2_Label_822D
    INX
    INY
    CPX #$04
    BNE Bank2_Label_821D

Bank2_Label_822D:
    INC PlayerLives
    INC ExtraLifeSoundCounter
    INC ExtraLifeScoreThresholdIndex

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

Bank2_ExtraLifeScoreThresholds:
    .byte $00, $00, $02, $00, $00, $00, $08, $00, $00, $02, $00, $00, $00, $05, $00, $00

Bank2_MapperValueTable:
    .byte $00, $10, $20, $30, $01, $11, $21, $31, $02, $12, $22, $32, $03, $13, $23, $33

Bank2_PrimaryEntryDispatch:
    JMP Bank2_World3Main

Bank2_NmiFrameDispatch:
    JMP World3_NmiFrameServices

Bank2_SecondaryEntryDispatch:
    JMP World3_DemoEntry

Bank2_AudioFrameDispatch:
    JMP World3_Audio_UpdateFrame
