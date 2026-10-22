; World 1 remaining audio-effect handlers
; PRG bank 0, original CPU range $E68D-$E948

World1_AudioEffect_InitIndexedTonalSequenceAlt:
    LDA #$78
    STA $2D
    LDA #$E9
    STA $2E
    LDA #$01
    STA a:AudioEffectWork0

World1_AudioEffect_UpdateIndexedTonalSequenceAlt:
    DEC a:AudioEffectWork0
    BNE Bank0_Label_E68C
    LDY #$00
    LDA ($2D),Y
    CMP #$FF
    BEQ Bank0_Label_E689
    STA a:AudioEffectWork0
    STA a:AudioEffectTimers
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectTimers+$03
    JSR World1_AudioEffect_AdvanceSequencePointer
    LDX #$00
    .byte $20, $C1
    INC Controller1ButtonsAlt
    CMP ($E6,X)

World1_AudioEffect_WriteIndexedTonalEvent:
    LDY #$00
    LDA ($2D),Y
    BEQ Bank0_Label_E6EC
    ASL A
    TAY
    LDA a:AudioEffectWork0
    CPX #$08
    BEQ Bank0_Label_E6D5
    LSR A
    ORA #$C0
    BNE Bank0_Label_E6D6

Bank0_Label_E6D5:
    ASL A

Bank0_Label_E6D6:
    STA a:APU_PL1_VOL,X
    LDA #$00
    STA a:APU_PL1_SWEEP,X
    LDA a:Bank0_Label_EE34,Y
    STA a:APU_PL1_LO,X
    LDA a:Bank0_Label_EE34+1,Y
    ORA #$08
    STA a:APU_PL1_HI,X

Bank0_Label_E6EC:
    INX
    INX
    INX
    INX
    JMP World1_AudioEffect_AdvanceSequencePointer

World1_AudioEffect_InitPulse2FixedToneB:
    LDA #$18
    STA a:AudioEffectTimers+$01
    LDA #$10
    STA a:AudioEffectWork0
    STA a:AudioEffectRetriggerLock
    LDA #$A0
    LDX #$9B
    JSR World1_Apu_WritePulse2ControlSweep
    LDX #$FE
    LDA #$19
    JMP World1_Apu_WritePulse2Timer

World1_AudioEffect_InitPulse2FixedToneC:
    LDA #$08
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectWork0
    LDA #$C0
    LDX #$83
    JSR World1_Apu_WritePulse2ControlSweep
    LDX #$60
    LDA #$08
    JMP World1_Apu_WritePulse2Timer

World1_AudioEffect_InitNoiseVolumeSweep:
    LDA #$18
    STA a:AudioEffectTimers+$03
    LDA #$04
    STA a:APU_NOISE_LO
    LDA #$0F
    STA a:AudioEffectWork0
    LDA #$00
    STA a:AudioEffectWork1

World1_AudioEffect_UpdateNoiseVolumeSweep:
    LDA a:AudioEffectWork0
    CMP #$10
    BEQ Bank0_Label_E764
    ORA #$10
    STA a:APU_NOISE_VOL
    LDA #$28
    STA a:APU_NOISE_HI
    LDA a:AudioEffectWork1
    BEQ Bank0_Label_E752
    INC a:AudioEffectWork0
    RTS

Bank0_Label_E752:
    LDA a:AudioEffectWork0
    CMP #$02
    BCC Bank0_Label_E760
    DEC a:AudioEffectWork0
    DEC a:AudioEffectWork0
    RTS

Bank0_Label_E760:
    INC a:AudioEffectWork1
    RTS

Bank0_Label_E764:
    LDA #$10
    STA a:APU_NOISE_VOL
    JMP World1_Audio_StopCurrentEffect

World1_AudioEffect_InitPulse2ThreeStep:
    LDA #$03
    STA a:AudioEffectWork1
    LDA #$FF
    STA a:AudioEffectTimers+$01
    LDA #$00
    STA a:AudioEffectWork0

World1_AudioEffect_UpdatePulse2ThreeStep:
    LDA a:AudioEffectWork0
    BNE Bank0_Label_E7A7
    LDA a:AudioEffectWork1
    BNE Bank0_Label_E78D
    LDA #$00
    STA a:AudioEffectTimers+$01
    JMP World1_Audio_StopCurrentEffect

Bank0_Label_E78D:
    DEC a:AudioEffectWork1
    LDA #$84
    LDX #$8B
    JSR World1_Apu_WritePulse2ControlSweep
    LDY a:AudioEffectWork1
    LDX a:Bank0_Label_E7AB,Y
    LDA #$10
    JSR World1_Apu_WritePulse2Timer
    LDA #$04
    STA a:AudioEffectWork0

Bank0_Label_E7A7:
    DEC a:AudioEffectWork0
    RTS
Bank0_Label_E7AB:
    .byte $65, $87, $B4, $F0

World1_AudioEffect_InitPulse2PitchSequenceBase:
    LDY #$14
    LDA #$04
    LDX #$03

Bank0_Label_E7B5:
    STY a:AudioEffectTimers+$01
    STA a:AudioEffectWork0
    STX a:AudioEffectWork2
    LDA #$01
    STA a:AudioEffectWork1

World1_AudioEffect_UpdatePulse2PitchSequence:
    DEC a:AudioEffectWork1
    BNE Bank0_Label_E7EE
    LDA a:AudioEffectWork0
    BMI Bank0_Label_E7EF
    CLC
    ADC a:AudioEffectWork2
    ASL A
    TAY
    LDA #$DF
    LDX #$8C
    JSR World1_Apu_WritePulse2ControlSweep
    LDA a:World1_AudioEffectPitchPeriods,Y
    TAX
    LDA a:Bank0_Label_E7F3,Y
    ORA #$88
    JSR World1_Apu_WritePulse2Timer
    DEC a:AudioEffectWork0
    LDA #$04
    STA a:AudioEffectWork1

Bank0_Label_E7EE:
    RTS

Bank0_Label_E7EF:
    JMP World1_Audio_StopCurrentEffect

World1_AudioEffectPitchPeriods:
    .byte $00
Bank0_Label_E7F3:
    .byte $06, $00, $03, $00, $02, $40, $01, $C0, $00, $80, $00, $60, $00, $50, $00
    .byte $2B, $03, $35, $00, $2C, $03, $33, $06, $2B, $03, $35, $00, $2C, $03, $33, $06
    .byte $2B, $03, $35, $00, $2C, $03, $33, $06, $2B, $03, $35, $00, $2C, $03, $33, $06
    .byte $69, $00, $70, $00, $76, $00, $7E, $00, $85, $00, $8D, $00, $96, $00, $9F, $00
    .byte $A8, $00, $B2, $00, $BD, $00, $C8, $00, $D4, $00

World1_AudioEffect_InitTrianglePitchDescent:
    LDA #$10
    STA a:AudioEffectTimers+$02
    LDA #$40
    STA a:AudioEffectWork0
    LDA #$01
    STA a:AudioEffectWork1
    LDA #$30
    STA a:AudioEffectWork2

World1_AudioEffect_UpdateTrianglePitchDescent:
    LDY #$01
    LDX a:AudioEffectWork0
    LDA #$08
    JSR World1_Apu_WriteTriangleControlTimer
    LDA a:AudioEffectWork0
    SEC
    SBC a:AudioEffectWork1
    STA a:AudioEffectWork0
    CMP a:AudioEffectWork2
    BNE Bank0_Label_E86C
    JMP World1_Audio_StopCurrentEffect

Bank0_Label_E86C:
    RTS

World1_AudioEffect_InitPulse2TwoTone:
    LDA #$0E
    STA a:AudioEffectTimers+$01
    LDA #$06
    STA a:AudioEffectWork0
    STA a:AudioEffectWork1
    LDA #$9F
    LDX #$8D
    JSR World1_Apu_WritePulse2ControlSweep
    LDX #$00
    LDA #$89
    JMP World1_Apu_WritePulse2Timer

World1_AudioEffect_UpdatePulse2TwoTone:
    DEC a:AudioEffectWork0
    BNE Bank0_Label_E8AD
    LDA a:AudioEffectWork1
    BEQ Bank0_Label_E8AA
    LDA #$08
    STA a:AudioEffectWork0
    LDA #$00
    STA a:AudioEffectWork1
    LDA #$9F
    LDX #$8C
    JSR World1_Apu_WritePulse2ControlSweep
    LDX #$80
    LDA #$88
    JMP World1_Apu_WritePulse2Timer

Bank0_Label_E8AA:
    JMP World1_Audio_StopCurrentEffect

Bank0_Label_E8AD:
    RTS

World1_AudioEffect_InitPulse2PitchSequenceWide:
    LDY #$34
    LDA #$0C
    LDX #$18
    JMP Bank0_Label_E7B5

World1_AudioEffect_InitPulse2VolumeFade:
    LDA #$20
    STA a:AudioEffectTimers+$01
    LDA #$1F
    LDX #$85
    JSR World1_Apu_WritePulse2ControlSweep
    LDX #$69
    LDA #$08
    JSR World1_Apu_WritePulse2Timer
    LDA #$02
    STA a:AudioEffectWork0
    LDA #$01
    STA a:AudioEffectWork1

World1_AudioEffect_UpdatePulse2VolumeFade:
    DEC a:AudioEffectWork1
    BNE Bank0_Label_E94F
    LDA #$04
    STA a:AudioEffectWork1
    LDY a:AudioEffectWork0
    LDA a:Bank0_Label_E8EF,Y
    STA a:APU_PL2_VOL
    DEC a:AudioEffectWork0
    BPL Bank0_Label_E94F
    JMP World1_Audio_StopCurrentEffect
Bank0_Label_E8EF:
    .byte $00

World1_AudioEffect_InitPulse1Alternator:
    LDA #$00
    STA a:AudioEffectWork0
    LDA #$01
    STA a:AudioEffectWork1

World1_AudioEffect_UpdatePulse1Alternator:
    DEC a:AudioEffectWork1
    BNE Bank0_Label_E91F
    LDA a:AudioEffectWork0
    EOR #$04
    STA a:AudioEffectWork0
    TAY
    LDA a:Bank0_Label_E933+1,Y
    STA a:AudioEffectWork1
    LDA #$DF
    LDX a:Bank0_Label_E931,Y
    JSR World1_Apu_WritePulse1ControlSweep
    LDX a:Bank0_Label_E931+1,Y
    LDA a:Bank0_Label_E933,Y
    JMP World1_Apu_WritePulse1Timer

Bank0_Label_E91F:
    RTS
    .byte $A9, $08, $D0, $CE, $A9, $10, $D0, $CA, $4C, $FA, $E8, $4C, $24, $E9, $4C, $FA
    .byte $E8
Bank0_Label_E931:
    .byte $8F, $80
Bank0_Label_E933:
    .byte $FC, $08, $87, $00, $FC, $08, $8D, $80, $FC, $06, $85, $00, $FB
    .byte $06, $8B, $80, $FC, $04, $83, $00, $FA, $04
