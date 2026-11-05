; Emitted at $8000 in each PRG bank. On a mapper write, the next
; instruction can be fetched from the newly selected bank

    BootEntry EnterWorld1
    JSR DisableNmiAndRendering
    LDA #$00
    JSR SelectPrgBank
    JMP PrimaryEntryDispatch

    BootEntry EnterWorld2
    JSR DisableNmiAndRendering
    LDA #$01
    JSR SelectPrgBank
    JMP PrimaryEntryDispatch

    BootEntry EnterWorld3
    JSR DisableNmiAndRendering
    LDA #$02
    JSR SelectPrgBank
    JMP PrimaryEntryDispatch

    JMP NmiFrameDispatch

    BootEntry EnterWorld1Demo
    JSR DisableNmiAndRendering
    LDA #$00
    JSR SelectPrgBank
    JMP SecondaryEntryDispatch

    BootEntry EnterWorld2Demo
    JSR DisableNmiAndRendering
    LDA #$01
    JSR SelectPrgBank
    JMP SecondaryEntryDispatch

    BootEntry EnterWorld3Demo
    JSR DisableNmiAndRendering
    LDA #$02
    JSR SelectPrgBank
    JMP SecondaryEntryDispatch

    JMP AudioFrameDispatch

    BootEntry EnterShell
    JSR DisableNmiAndRendering
    LDA #$03
    JSR SelectPrgBank
    JMP PrimaryEntryDispatch

    BootEntry CallShellStatusScreen
    JSR DisableNmiAndRendering
    LDA MapperSelection
    PHA
    LDA #$03
    JSR SelectPrgBank
    JSR SecondaryEntryDispatch
    PLA
    JMP SelectPrgBank

    BootEntry CallShellGameOver
    JSR DisableNmiAndRendering
    LDA MapperSelection
    PHA
    LDA #$03
    JSR SelectPrgBank
    JSR ::Bank3_GameOverDispatch
    PLA
    JMP SelectPrgBank

    BootEntry EnterEnding
    JSR DisableNmiAndRendering
    LDA #$03
    JSR SelectPrgBank
    JMP ::Bank3_EndingDispatch

    BootEntry EnterWorld1ToWorld2Transition
    JSR DisableNmiAndRendering
    LDA #$03
    JSR SelectPrgBank
    JMP ::Bank3_World1TransitionDispatch

    BootEntry EnterWorld2ToWorld3Transition
    JSR DisableNmiAndRendering
    LDA #$03
    JSR SelectPrgBank
    JMP ::Bank3_World2TransitionDispatch

    BootEntry Reset
    LDX #$7F
    TXS
    LDA #$00
    STA a:PPU_MASK
    STA a:PPU_CTRL
    JSR WaitForVblank
    JSR WaitForVblank
    LDX #$00
    TXA

    BootEntry Label_80AC
    STA a:$0400,X
    STA a:$0500,X
    STA a:$0600,X
    STA a:$0700,X
    INX
    BNE Label_80AC
    LDA #$10
    STA PpuCtrlShadow
    STA a:PPU_CTRL
    LDA #$06
    STA PpuMaskShadow
    STA a:PPU_MASK
    JSR DisableRenderingForUpdate
    JMP EnterShell

    BootEntry WaitForVblank
    LDA a:PPU_STATUS
    BPL WaitForVblank

    BootEntry Label_80D4
    LDA a:PPU_STATUS
    BMI Label_80D4
    RTS

    BootEntry DisableRenderingForUpdate
    JSR WaitForVblank
    LDA #$00
    STA NmiOamDmaRequest
    LDA PpuCtrlShadow
    STA a:PPU_CTRL
    LDA PpuMaskShadow
    AND #$E7
    STA PpuMaskShadow
    STA a:PPU_MASK
    RTS

    BootEntry DisableNmiAndRendering
    JSR DisableRenderingForUpdate
    LDA PpuCtrlShadow
    AND #$7F
    STA PpuCtrlShadow
    STA a:PPU_CTRL
    RTS

    BootEntry EnableNmiAndRendering
    JSR HideAllSprites
    JSR WaitForVblank
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
    JSR WriteMapper
    LDA PpuMaskShadow
    ORA #$18
    STA PpuMaskShadow
    STA a:PPU_MASK
    RTS

    BootEntry HideAllSprites
    LDA #$F0
    LDX #$00

    BootEntry Label_8135
    STA a:OamBuffer,X
    INX
    BNE Label_8135
    RTS

    BootEntry Nmi
    PHA
    TXA
    PHA
    TYA
    PHA
    LDA NmiBusy
    BNE Label_81A2
    INC NmiBusy
    LDA NmiOamDmaRequest
    BEQ Label_8158
    LDA #$00
    STA a:OAM_ADDR
    LDA #$03
    STA a:OAM_DMA
    JSR WriteMapper

    BootEntry Label_8158
    JSR NmiFrameDispatch
    LDA #$01
    STA a:JOYPAD1
    LDA #$00
    STA a:JOYPAD1
    LDX #$08

    BootEntry Label_8167
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
    BNE Label_8167
    LDA Controller2Buttons
    AND #$CF
    ORA Controller1Buttons
    ORA Controller1ButtonsAlt
    ORA Controller2ButtonsAlt
    STA CombinedControllerButtons
    LDA a:JOYPAD1
    AND #$04
    CMP Controller2MicrophoneSample
    BEQ Label_8197
    STA Controller2MicrophoneSample
    LDA #$14
    STA Controller2MicrophoneEdgeTimer

    BootEntry Label_8197
    LDA Controller2MicrophoneEdgeTimer
    BEQ Label_819D
    DEC Controller2MicrophoneEdgeTimer

    BootEntry Label_819D
    JSR AudioFrameDispatch
    DEC NmiBusy

    BootEntry Label_81A2
    INC FrameCounter
    PLA
    TAY
    PLA
    TAX
    PLA
    RTI

    BootEntry SelectChrBank
    ASL A
    ASL A
    AND #$0C
    STA ChrSelectionBits
    LDA MapperSelection

    BootEntry SelectPrgBank
    AND #$03
    ORA ChrSelectionBits
    STA MapperSelection
    JSR WaitForVblank

    BootEntry WriteMapper
    LDA MapperSelection
    TAX
    LDA a:MapperValueTable,X
    STA a:MapperValueTable,X
    NOP
    NOP
    NOP
    NOP
    RTS

    BootEntry AddEncodedScore, ScorePrefix
    STA $07
    LDA DemoModeActive
    BNE Label_81E5
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
    JSR AddScoreDigitWithCarry
    PLA
    TAX
    PLA
    TAY

    BootEntry Label_81E5
    RTS

    BootEntry AddScoreDigitWithCarry, ScorePrefix
    CLC
    ADC a:ScoreDigitsWorking,X
    LDY #$00

    BootEntry Label_81EC
    CMP #$0A
    BCC Label_81F6
    SEC
    SBC #$0A
    INY
    BNE Label_81EC

    BootEntry Label_81F6
    STA a:ScoreDigitsWorking,X
    TYA
    BNE Label_81FD
    RTS

    BootEntry Label_81FD
    DEX
    BPL AddScoreDigitWithCarry
    LDA #$09
    LDX #$05

    BootEntry Label_8204
    STA a:ScoreDigitsWorking,X
    STA a:ScoreDigitsCurrent,X
    DEX
    BPL Label_8204
    RTS

    BootEntry CommitScoreAndCheckExtraLife, ScorePrefix
    LDA DemoModeActive
    BNE Label_8244
    LDA ExtraLifeScoreThresholdIndex
    CMP #$04
    BEQ Label_8233
    ASL A
    ASL A
    TAY
    LDX #$00

    BootEntry Label_821D
    LDA a:ScoreDigitsWorking,X
    CMP a:ExtraLifeScoreThresholds,Y
    BCC Label_8233
    BNE Label_822D
    INX
    INY
    CPX #$04
    BNE Label_821D

    BootEntry Label_822D
    INC PlayerLives
    INC ExtraLifeSoundCounter
    INC ExtraLifeScoreThresholdIndex

    BootEntry Label_8233
    LDX #$00

    BootEntry Label_8235
    LDA a:ScoreDigitsCurrent,X
    CMP a:ScoreDigitsWorking,X
    BCC Label_8245
    BNE Label_8244
    INX
    CPX #$06
    BNE Label_8235

    BootEntry Label_8244
    RTS

    BootEntry Label_8245
    LDA a:ScoreDigitsWorking,X
    STA a:ScoreDigitsCurrent,X
    INX
    CPX #$06
    BNE Label_8245
    RTS

    BootEntry ExtraLifeScoreThresholds
    .byte $00, $00, $02, $00, $00, $00, $08, $00, $00, $02, $00, $00, $00, $05, $00, $00

    BootEntry MapperValueTable
    .byte $00, $10, $20, $30, $01, $11, $21, $31, $02, $12, $22, $32, $03, $13, $23, $33

.assert EnterWorld1 = $8000, lderror, "Boot runtime moved"
.assert Reset = $8098, lderror, "Reset moved"
.assert Nmi = $813C, lderror, "NMI moved"
.assert WriteMapper = $81BB, lderror, "Mapper writer moved"
.assert MapperValueTable = $8261, lderror, "Mapper value table moved"
.assert * = $8271, lderror, "Boot runtime end moved"
.assert PrimaryEntryDispatch = $8271, lderror, "Primary dispatch moved"
.assert NmiFrameDispatch = $8274, lderror, "NMI dispatch moved"
.assert SecondaryEntryDispatch = $8277, lderror, "Secondary dispatch moved"
.assert AudioFrameDispatch = $827A, lderror, "Audio dispatch moved"
