; Doraemon PRG bank 3 $827D-$8A16
; Title flow, menus, and common presentation services
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank3_GameOverDispatch:
    JMP Bank3_ShowGameOver

Bank3_EndingDispatch:
    JMP Bank3_RunEnding

Bank3_World1TransitionDispatch:
    JMP Bank3_World1ToWorld2Transition

Bank3_World2TransitionDispatch:
    JMP Bank3_World2ToWorld3Transition

Audio_UpdateFrame:
    JSR Audio_UpdateEffects
    JMP Audio_UpdateMusic

Bank3_ShellMain:
    LDA #$00
    STA a:PPU_CTRL
    STA a:PPU_MASK
    STA $09
    STA $3C
    STA $3D
    LDX #$7F
    TXS
    LDA #$00
    STA a:$0180
    JSR Bank3_DisableRenderingForUpdate
    LDA #$03
    JSR Bank3_SelectChrBank
    JSR Bank3_Func_9152
    LDA #$86
    STA $01
    LDA #$30
    STA $00
    JSR Bank3_Func_90C4
    JSR Bank3_Func_90D1
    JSR Bank3_Func_858D
    LDA $3B
    AND #$7F
    STA $3B
    LDA #$48
    STA $00
    LDA #$92
    STA $01
    JSR Bank3_WaitForVblank
    JSR Bank3_Func_8F84
    LDA #$FF
    STA PpuScrollXShadow
    LDA #$D0
    STA PpuScrollYShadow
    LDA #$96
    STA $0E
    LDA #$22
    STA $10
    LDA #$80
    STA $0F
    LDA #$80
    STA $11
    LDX #$00

Bank3_Label_82EF:
    LDA a:ScoreDigitsWorking,X
    BNE Bank3_Label_82F9
    INX
    CPX #$05
    BNE Bank3_Label_82EF

Bank3_Label_82F9:
    TXA
    CLC
    ADC #$91
    PHA
    LDA #$22
    STA a:PPU_ADDR
    PLA
    STA a:PPU_ADDR

Bank3_Label_8307:
    LDA a:ScoreDigitsWorking,X
    ORA #$30
    STA a:PPU_DATA
    INX
    CPX #$07
    BNE Bank3_Label_8307
    LDX #$00

Bank3_Label_8316:
    LDA a:ScoreDigitsCurrent,X
    BNE Bank3_Label_8320
    INX
    CPX #$05
    BNE Bank3_Label_8316

Bank3_Label_8320:
    TXA
    CLC
    ADC #$51
    PHA
    LDA #$22
    STA a:PPU_ADDR
    PLA
    STA a:PPU_ADDR

Bank3_Label_832E:
    LDA a:ScoreDigitsCurrent,X
    ORA #$30
    STA a:PPU_DATA
    INX
    CPX #$07
    BNE Bank3_Label_832E
    LDA PpuCtrlShadow
    ORA #$10
    AND #$F4
    STA PpuCtrlShadow
    JSR Bank3_Func_91A1
    LDA #$01
    STA $0D
    STA NmiOamDmaRequest
    LDA #$00
    STA NmiBusy
    STA DemoModeActive
    LDA #$00
    STA a:$4011
    STA a:APU_STATUS
    STA a:$4010
    STA a:AudioEffectRequestState
    STA a:AudioMusicState
    STA a:AudioMusicControl
    LDA #$40
    STA a:$4017
    LDA #$01
    STA a:AudioMusicState
    JSR Bank3_EnableNmiAndRendering

Bank3_Label_8373:
    JSR Bank3_Func_83C5
    DEC PpuScrollXShadow
    BNE Bank3_Label_8373
    LDX #$64

Bank3_Label_837C:
    JSR Bank3_Func_83C5
    DEX
    BNE Bank3_Label_837C

Bank3_Label_8382:
    JSR Bank3_Func_83C5
    INC PpuScrollYShadow
    DEC $0E
    INC $10
    LDA PpuScrollYShadow
    CMP #$F0
    BNE Bank3_Label_8382
    LDA #$00
    STA PpuScrollYShadow

Bank3_Label_8395:
    JSR Bank3_Func_83C5
    INC $11
    DEC $0F
    BNE Bank3_Label_8395

Bank3_Label_839E:
    LDX #$7F
    TXS
    LDA #$00
    STA $0D
    STA PpuScrollXShadow
    STA PpuScrollYShadow
    STA a:$0180
    STA a:$01C0
    STA a:$0405
    STA a:$0406
    STA a:$0407
    INC $09

Bank3_Label_83BA:
    LDA Controller1Buttons
    ORA Controller1ButtonsAlt
    AND #$10
    BNE Bank3_Label_83BA
    JMP Shell_WaitForStartOrRunAttract

Bank3_Func_83C5:
    JSR Bank3_Func_84D2
    AND #$30
    BNE Bank3_Label_839E
    RTS

Bank3_Label_83CD:
    JSR Bank3_DisableRenderingForUpdate
    LDA #$00
    STA ExtraLifeScoreThresholdIndex
    STA ExtraLifeSoundCounter
    STA World1FlashLightCarryFlag
    STA $38
    LDX #$07

Bank3_Label_83DC:
    STA a:ScoreDigitsWorking,X
    DEX
    BPL Bank3_Label_83DC
    LDA #$02
    STA PlayerLives
    LDA #$08
    STA PlayerHealth
    LDA #$06
    STA PlayerHealthCapacityIndex
    LDA CombinedControllerButtons
    AND #$C0
    CMP #$C0
    BEQ Bank3_Label_83F9
    JMP Bank3_Func_8C3B

Bank3_Label_83F9:
    LDA #$80
    STA $3B
    LDX $3C
    BNE Bank3_Label_8404
    JMP Bank3_EnterWorld1

Bank3_Label_8404:
    LDA #$04
    STA PlayerHealthCapacityIndex
    LDA #$02
    STA PlayerLives
    DEX
    BNE Bank3_Label_8412
    JMP Bank3_EnterWorld2

Bank3_Label_8412:
    JMP Bank3_EnterWorld3

Shell_WaitForStartOrRunAttract:
    LDA #$00
    STA a:$0400

Bank3_Label_841A:
    JSR Bank3_Func_84D2
    AND #$10
    BNE Bank3_Label_83CD
    DEC a:$0400
    BNE Bank3_Label_841A

Bank3_Label_8426:
    JSR Bank3_Func_84FC
    JSR Bank3_Func_85B9
    BCC Bank3_Label_8426
    LDA #$B0
    STA $00
    LDA #$86
    STA $01
    JSR Bank3_Func_90C4
    LDA #$01
    STA a:$0408
    LDA $3B
    ASL A
    TAX
    LDA a:$84C0,X
    STA $3E
    LDA a:$84C1,X
    STA $3F
    LDA #$00
    STA $40
    STA $41
    STA $42
    LDA a:$84CC,X
    STA $44
    LDA a:$84CD,X
    STA $45

Bank3_Label_845E:
    JSR Bank3_Func_84FC
    LDA $40
    CMP #$20
    BCS Bank3_Label_8478
    LDA #$02
    STA $09
    JSR Bank3_Func_85F7
    JSR Bank3_Func_85E2
    LDA #$01
    STA $41
    JMP Bank3_Label_845E

Bank3_Label_8478:
    LDA $3B
    ASL A
    TAX
    LDA a:$84C6,X
    STA $00
    LDA a:$84C7,X
    STA $01
    JSR Bank3_Func_90C4
    LDX #$00
    STX $43
    INX
    STA a:$0408
    STA $42

Bank3_Label_8493:
    JSR Bank3_Func_84FC
    JSR Bank3_Func_85F7
    JSR Bank3_Func_85E2
    LDA a:AudioMusicState
    BNE Bank3_Label_8493
    LDA #$01
    STA DemoModeActive
    LDA $3B
    TAX
    INX
    CPX #$03
    BCC Bank3_Label_84AF
    LDX #$00

Bank3_Label_84AF:
    STX $3B
    TAX
    BNE Bank3_Label_84B7
    JMP Bank3_EnterWorld1Demo

Bank3_Label_84B7:
    DEX
    BNE Bank3_Label_84BD
    JMP Bank3_EnterWorld2Demo

Bank3_Label_84BD:
    JMP Bank3_EnterWorld3Demo
    .byte $BC, $B1, $BC, $B5, $BC, $B9, $50, $86, $70, $86, $90, $86, $D0, $86, $29, $87
    .byte $62, $87

Bank3_Func_84D2:
    JSR Shell_WaitForNextFrame
    LDA Controller1Buttons
    ORA Controller1ButtonsAlt
    AND #$20
    BEQ Bank3_Label_84F3
    LDA $3D
    BNE Bank3_Label_84F7
    LDX $3C
    INX
    CPX #$03
    BCC Bank3_Label_84EA
    LDX #$00

Bank3_Label_84EA:
    STX $3C
    LDA #$01
    STA $3D
    JMP Bank3_Label_84F7

Bank3_Label_84F3:
    LDA #$00
    STA $3D

Bank3_Label_84F7:
    LDA Controller1Buttons
    ORA Controller1ButtonsAlt

Bank3_Label_84FB:
    RTS

Bank3_Func_84FC:
    JSR Bank3_Func_84D2
    AND #$30
    BEQ Bank3_Label_84FB
    LDA #$00
    STA a:AudioMusicState
    LDA #$01
    STA $09
    JSR Bank3_DisableRenderingForUpdate
    JSR Bank3_Func_9152
    LDA #$48
    STA $00
    LDA #$92
    STA $01
    JSR Bank3_WaitForVblank
    JSR Bank3_Func_8F84
    LDX #$00

Bank3_Label_8522:
    LDA a:ScoreDigitsWorking,X
    BNE Bank3_Label_852C
    INX
    CPX #$05
    BNE Bank3_Label_8522

Bank3_Label_852C:
    TXA
    CLC
    ADC #$91
    PHA
    LDA #$22
    STA a:PPU_ADDR
    PLA
    STA a:PPU_ADDR

Bank3_Label_853A:
    LDA a:ScoreDigitsWorking,X
    ORA #$30
    STA a:PPU_DATA
    INX
    CPX #$07
    BNE Bank3_Label_853A
    LDX #$00

Bank3_Label_8549:
    LDA a:ScoreDigitsCurrent,X
    BNE Bank3_Label_8553
    INX
    CPX #$05
    BNE Bank3_Label_8549

Bank3_Label_8553:
    TXA
    CLC
    ADC #$51
    PHA
    LDA #$22
    STA a:PPU_ADDR
    PLA
    STA a:PPU_ADDR

Bank3_Label_8561:
    LDA a:ScoreDigitsCurrent,X
    ORA #$30
    STA a:PPU_DATA
    INX
    CPX #$07
    BNE Bank3_Label_8561
    LDA #$86
    STA $01
    LDA #$30
    STA $00
    JSR Bank3_Func_90C4
    JSR Bank3_Func_90D1
    LDA #$00
    STA PpuScrollYShadow
    STA PpuScrollXShadow
    LDA #$01
    STA a:AudioMusicState
    JSR Bank3_EnableNmiAndRendering
    JMP Bank3_Label_83BA

Bank3_Func_858D:
    LDA $39
    CMP #$4F
    BNE Bank3_Label_859A
    LDA $3A
    CMP #$4B
    BNE Bank3_Label_859A
    RTS

Bank3_Label_859A:
    LDA #$4F
    STA $39
    LDA #$4B
    STA $3A
    LDA #$00
    LDX #$07

Bank3_Label_85A6:
    STA a:ScoreDigitsWorking,X
    DEX
    BPL Bank3_Label_85A6
    LDX #$07

Bank3_Label_85AE:
    STA a:ScoreDigitsCurrent,X
    DEX
    BPL Bank3_Label_85AE
    LDA #$00
    STA $3B
    RTS

Bank3_Func_85B9:
    LDA #$01
    STA a:$0408
    CLC
    LDA FrameCounter
    AND #$03
    BNE Bank3_Label_85E1
    LDA a:$0400
    CMP #$05
    BCS Bank3_Label_85E1
    ASL A
    ASL A
    TAX
    LDY #$00

Bank3_Label_85D1:
    LDA a:$861C,X
    STA a:$0210,Y
    INX
    INY
    CPY #$04
    BCC Bank3_Label_85D1
    INC a:$0400
    CLC

Bank3_Label_85E1:
    RTS

Bank3_Func_85E2:
    LDA #$37
    STA a:OamBuffer
    LDA #$EF
    STA a:$0301
    LDA #$23
    STA a:$0302
    LDA #$00
    STA a:$0303
    RTS

Bank3_Func_85F7:
    LDX #$80
    LDY #$00

Bank3_Label_85FB:
    LDA ($44),Y
    BEQ Bank3_Label_861B
    INY
    STA a:OamBuffer,X
    LDA ($44),Y
    INY
    STA a:$0301,X
    LDA ($44),Y
    INY
    STA a:$0302,X
    LDA ($44),Y
    INY
    STA a:$0303,X
    INX
    INX
    INX
    INX
    BNE Bank3_Label_85FB

Bank3_Label_861B:
    RTS
    .byte $01, $0F, $17, $20, $01, $01, $07, $10, $01, $01, $01, $00, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $0F, $27, $30, $01, $15, $20, $26, $01, $15, $21, $29
    .byte $01, $15, $26, $0F, $01, $0F, $27, $30, $01, $15, $20, $36, $01, $15, $21, $30
    .byte $01, $15, $26, $01, $01, $0F, $11, $30, $01, $05, $25, $30, $01, $09, $08, $26
    .byte $01, $10, $30, $01, $01, $0F, $26, $30, $01, $15, $21, $30, $01, $0F, $26, $30
    .byte $01, $0F, $26, $30, $01, $0F, $11, $30, $01, $05, $25, $30, $01, $09, $08, $26
    .byte $01, $10, $30, $01, $01, $05, $25, $30, $01, $05, $25, $30, $01, $05, $25, $30
    .byte $01, $05, $25, $30, $01, $0F, $11, $30, $01, $05, $25, $30, $01, $09, $08, $26
    .byte $01, $10, $30, $01, $01, $15, $26, $30, $01, $15, $21, $30, $01, $15, $26, $30
    .byte $01, $15, $21, $30, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $4C, $03, $00, $50, $4C, $04, $00, $58, $54, $13, $00, $50
    .byte $54, $14, $00, $58, $64, $05, $00, $50, $64, $06, $00, $58, $6C, $15, $00, $50
    .byte $6C, $16, $00, $58, $7C, $07, $00, $50, $7C, $08, $00, $58, $84, $17, $00, $50
    .byte $84, $18, $00, $58, $94, $0B, $00, $50, $94, $0D, $00, $58, $9C, $1B, $00, $50
    .byte $9C, $1D, $00, $58, $B0, $0C, $00, $50, $B0, $0C, $40, $58, $C4, $09, $01, $50
    .byte $C4, $0A, $01, $58, $CC, $19, $01, $50, $CC, $1A, $01, $58, $00, $54, $23, $00
    .byte $50, $54, $24, $00, $58, $5C, $25, $00, $50, $5C, $26, $00, $58, $74, $27, $00
    .byte $50, $74, $27, $40, $58, $7C, $28, $00, $50, $7C, $28, $40, $58, $98, $0C, $00
    .byte $50, $98, $0C, $40, $58, $B4, $09, $00, $50, $B4, $0A, $00, $58, $BC, $19, $00
    .byte $50, $BC, $1A, $00, $58, $00, $44, $29, $00, $50, $44, $29, $40, $58, $4C, $29
    .byte $80, $50, $4C, $29, $C0, $58, $5C, $2A, $00, $50, $5C, $2B, $00, $58, $64, $3A
    .byte $00, $50, $64, $3B, $00, $58, $74, $3C, $01, $50, $74, $3D, $01, $58, $7C, $3E
    .byte $01, $50, $7C, $3F, $01, $58, $8C, $40, $01, $50, $8C, $41, $01, $58, $94, $42
    .byte $01, $50, $94, $2D, $01, $58, $A4, $03, $01, $50, $A4, $04, $01, $58, $AC, $13
    .byte $01, $50, $AC, $14, $01, $58, $C0, $0C, $00, $50, $C0, $0C, $40, $58, $D4, $09
    .byte $01, $50, $D4, $0A, $01, $58, $DC, $19, $01, $50, $DC, $1A, $01, $58, $00

Shell_ShowStatusScreen:
    LDA #$FF
    JSR Bank3_Func_8F63
    LDA PpuCtrlShadow
    AND #$FE
    STA PpuCtrlShadow
    LDA #$3F
    STA $00
    LDA #$88
    STA $01
    JSR Bank3_WaitForVblank
    JSR Bank3_Func_8F84
    LDA $28
    ASL A
    TAY
    LDA a:$8839,Y
    STA $00
    LDA a:$883A,Y
    STA $01
    JSR Bank3_Func_8F84
    LDA #$03
    JSR Bank3_SelectChrBank
    LDA PpuCtrlShadow
    AND #$E7
    STA PpuCtrlShadow
    LDA #$23
    STA a:PPU_ADDR
    LDA #$14
    STA a:PPU_ADDR
    LDA PlayerLives
    ORA #$30
    STA a:PPU_DATA
    LDX #$00

Bank3_Label_8813:
    LDA a:ScoreDigitsWorking,X
    BNE Bank3_Label_881D
    INX
    CPX #$05
    BNE Bank3_Label_8813

Bank3_Label_881D:
    TXA
    CLC
    ADC #$CF
    PHA
    LDA #$22
    STA a:PPU_ADDR
    PLA
    STA a:PPU_ADDR

Bank3_Label_882B:
    LDA a:ScoreDigitsWorking,X
    ORA #$30
    STA a:PPU_DATA
    INX
    CPX #$07
    BNE Bank3_Label_882B
    RTS
    .byte $63, $88, $F0, $88, $8A, $89, $3F, $00, $20, $02, $15, $21, $30, $02, $0F, $26
    .byte $30, $02, $16, $30, $36, $02, $16, $30, $36, $02, $15, $21, $30, $02, $0F, $26
    .byte $30, $02, $16, $30, $36, $02, $16, $30, $36, $00, $20, $AC, $07, $57, $C7, $B7
    .byte $BF, $58, $FF, $31, $21, $28, $0F, $D0, $D1, $D2, $FF, $FF, $FF, $D3, $D4, $D5
    .byte $FF, $FF, $FF, $DC, $DD, $DE, $21, $48, $0F, $E0, $E1, $E2, $FF, $FF, $FF, $E3
    .byte $E4, $E5, $FF, $FF, $FF, $EC, $ED, $EE, $21, $68, $0F, $F0, $F1, $F2, $FF, $FF
    .byte $FF, $F3, $F4, $F5, $FF, $FF, $FF, $FC, $FD, $FE, $22, $0C, $07, $00, $59, $FF
    .byte $FF, $FF, $0E, $0F, $22, $2C, $07, $1C, $69, $FF, $FF, $FF, $1E, $1F, $22, $4C
    .byte $07, $2C, $68, $FF, $FF, $FF, $2E, $2F, $22, $C9, $05, $CA, $B8, $C7, $B7, $CE
    .byte $23, $0A, $04, $BF, $CE, $CF, $CB, $23, $CB, $02, $55, $55, $23, $D2, $04, $00
    .byte $00, $00, $00, $23, $E3, $02, $00, $55, $23, $EA, $04, $55, $55, $55, $55, $23
    .byte $F2, $04, $55, $55, $55, $55, $00, $20, $AC, $07, $57, $C7, $B7, $BF, $58, $FF
    .byte $32, $21, $28, $0F, $D6, $D7, $D8, $FF, $FF, $FF, $D9, $DA, $DB, $FF, $FF, $FF
    .byte $DC, $DD, $DE, $21, $48, $0F, $E6, $E7, $E8, $FF, $FF, $FF, $E9, $EA, $EB, $FF
    .byte $FF, $FF, $EC, $ED, $EE, $21, $68, $0F, $F6, $F7, $F8, $FF, $FF, $FF, $F9, $FA
    .byte $FB, $FF, $FF, $FF, $FC, $FD, $FE, $21, $EF, $02, $48, $49, $22, $0C, $08, $00
    .byte $59, $FF, $4A, $4B, $FF, $4C, $4D, $22, $2C, $08, $1C, $69, $FF, $5A, $5B, $FF
    .byte $5C, $5D, $22, $4C, $08, $2C, $68, $FF, $6A, $6B, $FF, $6C, $6D, $22, $C9, $05
    .byte $CA, $B8, $C7, $B7, $CE, $23, $0A, $04, $BF, $CE, $CF, $CB, $23, $CB, $02, $55
    .byte $55, $23, $D2, $04, $00, $00, $00, $00, $23, $DB, $02, $55, $55, $23, $E3, $02
    .byte $44, $55, $23, $EA, $04, $55, $55, $55, $55, $23, $F2, $04, $55, $55, $55, $55
    .byte $00, $20, $AC, $07, $57, $C7, $B7, $BF, $58, $FF, $33, $21, $28, $0F, $A0, $A1
    .byte $A2, $FF, $FF, $FF, $A3, $A4, $A5, $FF, $FF, $FF, $DC, $DD, $DE, $21, $48, $0F
    .byte $B0, $B1, $B2, $FF, $FF, $FF, $B3, $B4, $B5, $FF, $FF, $FF, $EC, $ED, $EE, $21
    .byte $68, $0F, $C0, $C1, $C2, $FF, $FF, $FF, $C3, $C4, $C5, $FF, $FF, $FF, $FC, $FD
    .byte $FE, $22, $0C, $07, $00, $59, $FF, $FF, $FF, $4E, $4F, $22, $2C, $07, $1C, $69
    .byte $FF, $FF, $FF, $5E, $5F, $22, $4C, $07, $2C, $68, $FF, $FF, $FF, $6E, $6F, $22
    .byte $C9, $05, $CA, $B8, $C7, $B7, $CE, $23, $0A, $04, $BF, $CE, $CF, $CB, $23, $CB
    .byte $02, $55, $55, $23, $D2, $04, $00, $00, $00, $00, $23, $E3, $02, $00, $AA, $23
    .byte $EA, $04, $55, $55, $55, $55, $23, $F2, $04, $55, $55, $55, $55, $00
