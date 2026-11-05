; Effect handlers shared by World 1 and World 3
; Local labels use offsets from the start of the handler block

SfxHandlerStart:
    SfxCoreEntry AudioEffect_InitNoiseSweep
    LDA #$18
    STA a:AudioEffectTimers+$03
    LDA #$00
    STA a:APU_NOISE_VOL
    LDA #$0C
    STA a:AudioEffectWork0
    STA a:APU_NOISE_LO
    LDA #$08
    STA a:APU_NOISE_HI
    LDA #$00
    STA a:AudioEffectWork1
    LDA #$04
    STA a:AudioEffectWork2
    RTS

    SfxCoreEntry AudioEffect_UpdateNoiseSweepSlow
    LDX a:AudioEffectWork1
    BEQ Local_052
    DEX
    BEQ Local_02D
    JMP AudioEffect_UpdateTimedStop

    SfxHandlerLocal Local_02D
    DEC a:AudioEffectWork0
    LDA a:AudioEffectWork0
    STA a:APU_NOISE_LO
    CMP #$08
    BNE Local_06A
    INC a:AudioEffectWork1
    LDA #$1A
    STA a:APU_NOISE_VOL
    LDA #$03
    STA a:APU_NOISE_LO
    LDA #$F8
    STA a:APU_NOISE_HI
    LDA #$10
    STA a:AudioEffectWork0
    RTS

    SfxHandlerLocal Local_052
    DEC a:AudioEffectWork2
    BNE Local_06A
    INC a:AudioEffectWork1
    LDA #$04
    STA a:APU_NOISE_VOL
    LDA a:AudioEffectWork0
    STA a:APU_NOISE_LO
    LDA #$08
    STA a:APU_NOISE_HI

    SfxHandlerLocal Local_06A
    RTS

    SfxCoreEntry AudioEffect_UpdateNoiseSweepFast
    LDX a:AudioEffectWork1
    BEQ Local_052
    DEX
    BEQ Local_076
    JMP AudioEffect_UpdateTimedStop

    SfxHandlerLocal Local_076
    DEC a:AudioEffectWork0
    LDA a:AudioEffectWork0
    STA a:APU_NOISE_LO
    CMP #$08
    BNE Local_06A
    INC a:AudioEffectWork1
    LDA #$1A
    STA a:APU_NOISE_VOL
    LDA #$06
    STA a:APU_NOISE_LO
    LDA #$68
    STA a:APU_NOISE_HI
    LDA #$06
    STA a:AudioEffectWork0
    RTS

    SfxCoreEntry Sfx_InitTriangleNoiseBurst
    LDA #$04
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectTimers+$03
    STA a:AudioEffectWork0
    LDA #$1F
    STA a:APU_NOISE_VOL
    LDA #$0F
    STA a:APU_NOISE_LO
    LDY #$08
    LDX #$F0
    LDA #$38
    JSR Apu_WriteTriangleControlTimer
    STA a:APU_NOISE_HI
    RTS

    SfxCoreEntry Sfx_InitPulse2PitchSequenceLong
    LDY #$60
    LDA #$17
    LDX #$00
    BEQ Local_0CB

    SfxCoreEntry Sfx_InitPulse2PitchSequenceShort
    LDY #$08
    LDA #$01
    LDX #$05

    SfxHandlerLocal Local_0CB
    STY a:AudioEffectTimers+$01
    STA a:AudioEffectWork0
    STX a:AudioEffectWork2
    LDA #$01
    STA a:AudioEffectWork1
    JSR AudioEffect_InitNoiseOnset
    JMP Sfx_UpdatePulse2PitchSequence

    SfxCoreEntry AudioEffect_InitNoiseOnset
    LDA #$08
    STA a:AudioEffectTimers+$03
    LDA #$01
    STA a:APU_NOISE_VOL
    LDA #$0A
    STA a:APU_NOISE_LO
    LDA #$08
    STA a:APU_NOISE_HI

    SfxHandlerLocal Local_0F3
    RTS

    SfxCoreEntry Sfx_InitPulse1AlternatingBurst
    LDA #$48
    STA a:AudioEffectTimers
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectTimers+$03
    LDA #$01
    STA a:AudioEffectWork0
    LDA #$04
    STA a:AudioEffectWork1

    SfxCoreEntry Sfx_UpdatePulse1AlternatingBurst
    LDA a:AudioEffectWork1
    BNE Local_114
    JMP AudioEffect_UpdateTimedStop

    SfxHandlerLocal Local_114
    DEC a:AudioEffectWork0
    BNE Local_0F3
    DEC a:AudioEffectWork1
    BEQ Local_138
    LDA #$04
    STA a:AudioEffectWork0
    LDA a:AudioEffectWork1
    LSR A
    BCC Local_134
    LDA #$82
    LDX #$00
    JSR Apu_WritePulse1ControlSweep
    LDX #$69
    BNE Local_146

    SfxHandlerLocal Local_134
    LDA #$82
    BNE Local_13F

    SfxHandlerLocal Local_138
    LDA #$3C
    STA a:AudioEffectWork0
    LDA #$8F

    SfxHandlerLocal Local_13F
    LDX #$00
    JSR Apu_WritePulse1ControlSweep
    LDX #$8D

    SfxHandlerLocal Local_146
    LDA #$08
    JMP Apu_WritePulse1Timer

    SfxCoreEntry AudioEffect_InitPulse1Sequence
    LDA #<Pulse1Sequence
    STA $2D
    LDA #>Pulse1Sequence
    STA $2E
    LDA #$01
    STA a:AudioEffectWork0
    STA a:AudioEffectRetriggerLock
    LDA #$09
    STA a:AudioEffectWork1
    LDA #$83
    STA a:AudioEffectWork2

    SfxCoreEntry AudioEffect_UpdatePulse1Sequence
    JSR AudioEffect_GateSequenceStep
    LDX #$00
    LDA a:AudioEffectWork1
    STA a:AudioEffectTimers,X
    TXA
    ASL A
    ASL A
    TAX
    LDA a:AudioEffectWork2
    STA a:APU_PL1_VOL,X
    LDA #$00
    STA a:APU_PL1_SWEEP,X
    LDY #$00
    LDA ($2D),Y
    BEQ Sfx_AdvanceSequencePointer
    ASL A
    TAY
    LDA a:MusicPitchPeriods,Y
    STA a:APU_PL1_LO,X
    LDA a:MusicPitchPeriods+1,Y
    ORA #$08
    STA a:APU_PL1_HI,X

    SfxCoreEntry Sfx_AdvanceSequencePointer
    INC $2D
    BNE Local_19B
    INC $2E

    SfxHandlerLocal Local_19B
    RTS

    SfxCoreEntry AudioEffect_GateSequenceStep
    DEC a:AudioEffectWork0
    BNE Local_1B2
    LDA a:AudioEffectWork1
    STA a:AudioEffectWork0
    LDY #$00
    LDA ($2D),Y
    CMP #$FF
    BNE Local_1B4
    JSR Audio_StopCurrentEffect

    SfxHandlerLocal Local_1B2
    PLA
    PLA

    SfxHandlerLocal Local_1B4
    RTS

    SfxCoreEntry AudioEffect_InitPulse1FixedTone
    LDA #$04
    STA a:AudioEffectTimers
    STA a:AudioEffectWork0
    STA a:AudioEffectRetriggerLock
    LDA #$00
    TAX
    JSR Apu_WritePulse1ControlSweep
    LDX #$3E
    LDA #$38
    JMP Apu_WritePulse1Timer

    SfxCoreEntry AudioEffect_InitPulse2FixedToneA
    LDA #$0A
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectWork0
    LDA #$42
    LDX #$00
    JSR Apu_WritePulse2ControlSweep
    LDX #$BB
    LDA #$08
    JMP Apu_WritePulse2Timer

    SfxCoreEntry Sfx_InitPulse1ToneWithTriLease
    LDA #$04
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectWork0
    STA a:AudioEffectRetriggerLock
    LDA #$84
    LDX #$8A
    JSR Apu_WritePulse1ControlSweep
    LDX #$7E
    LDA #$38
    JMP Apu_WritePulse1Timer

    SfxCoreEntry AudioEffect_InitNoisePeriodRamp
    LDA #$10
    STA a:AudioEffectTimers+$03
    STA a:AudioEffectWork1
    LDA #$0C
    STA a:AudioEffectWork0
    LDA #$04
    STA a:APU_NOISE_VOL
    LDA #$08
    STA a:APU_NOISE_HI

    SfxCoreEntry AudioEffect_UpdateNoisePeriodRamp
    LDA a:AudioEffectWork0
    STA a:APU_NOISE_LO
    LDA a:AudioEffectWork0
    CMP #$0F
    BEQ Local_223
    INC a:AudioEffectWork0

    SfxHandlerLocal Local_223
    DEC a:AudioEffectWork1
    BNE Local_22B

    SfxHandlerLocal Local_228
    JMP Audio_StopCurrentEffect

    SfxHandlerLocal Local_22B
    RTS
    SfxCoreEntry Sfx_InitIndexedTonalSequenceAlt
    LDA #<IndexedTonalSequence
    STA $2D
    LDA #>IndexedTonalSequence
    STA $2E
    LDA #$01
    STA a:AudioEffectWork0

    SfxCoreEntry Sfx_UpdateIndexedTonalSequenceAlt
    DEC a:AudioEffectWork0
    BNE Local_22B
    LDY #$00
    LDA ($2D),Y
    CMP #$FF
    BEQ Local_228
    STA a:AudioEffectWork0
    STA a:AudioEffectTimers
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectTimers+$03
    JSR Sfx_AdvanceSequencePointer
    LDX #$00
    JSR Sfx_WriteIndexedTonalEvent
    JSR Sfx_WriteIndexedTonalEvent

    SfxCoreEntry Sfx_WriteIndexedTonalEvent
    LDY #$00
    LDA ($2D),Y
    BEQ Local_28B
    ASL A
    TAY
    LDA a:AudioEffectWork0
    CPX #$08
    BEQ Local_274
    LSR A
    ORA #$C0
    BNE Local_275

    SfxHandlerLocal Local_274
    ASL A

    SfxHandlerLocal Local_275
    STA a:APU_PL1_VOL,X
    LDA #$00
    STA a:APU_PL1_SWEEP,X
    LDA a:MusicPitchPeriods,Y
    STA a:APU_PL1_LO,X
    LDA a:MusicPitchPeriods+1,Y
    ORA #$08
    STA a:APU_PL1_HI,X

    SfxHandlerLocal Local_28B
    INX
    INX
    INX
    INX
    JMP Sfx_AdvanceSequencePointer

    SfxCoreEntry AudioEffect_InitPulse2FixedToneB
    LDA #$18
    STA a:AudioEffectTimers+$01
    LDA #$10
    STA a:AudioEffectWork0
    STA a:AudioEffectRetriggerLock
    LDA #$A0
    LDX #$9B
    JSR Apu_WritePulse2ControlSweep
    LDX #$FE
    LDA #$19
    JMP Apu_WritePulse2Timer

    SfxCoreEntry AudioEffect_InitPulse2FixedToneC
    LDA #$08
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectWork0
    LDA #$C0
    LDX #$83
    JSR Apu_WritePulse2ControlSweep
    LDX #$60
    LDA #$08
    JMP Apu_WritePulse2Timer

    SfxCoreEntry AudioEffect_InitNoiseVolumeSweep
    LDA #$18
    STA a:AudioEffectTimers+$03
    LDA #$04
    STA a:APU_NOISE_LO
    LDA #$0F
    STA a:AudioEffectWork0
    LDA #$00
    STA a:AudioEffectWork1

    SfxCoreEntry Sfx_UpdateNoiseVolumeSweep
    LDA a:AudioEffectWork0
    CMP #$10
    BEQ Local_303
    ORA #$10
    STA a:APU_NOISE_VOL
    LDA #$28
    STA a:APU_NOISE_HI
    LDA a:AudioEffectWork1
    BEQ Local_2F1
    INC a:AudioEffectWork0
    RTS

    SfxHandlerLocal Local_2F1
    LDA a:AudioEffectWork0
    CMP #$02
    BCC Local_2FF
    DEC a:AudioEffectWork0
    DEC a:AudioEffectWork0
    RTS

    SfxHandlerLocal Local_2FF
    INC a:AudioEffectWork1
    RTS

    SfxHandlerLocal Local_303
    LDA #$10
    STA a:APU_NOISE_VOL
    JMP Audio_StopCurrentEffect

    SfxCoreEntry AudioEffect_InitPulse2ThreeStep
    LDA #$03
    STA a:AudioEffectWork1
    LDA #$FF
    STA a:AudioEffectTimers+$01
    LDA #$00
    STA a:AudioEffectWork0

    SfxCoreEntry AudioEffect_UpdatePulse2ThreeStep
    LDA a:AudioEffectWork0
    BNE Local_346
    LDA a:AudioEffectWork1
    BNE Local_32C
    LDA #$00
    STA a:AudioEffectTimers+$01
    JMP Audio_StopCurrentEffect

    SfxHandlerLocal Local_32C
    DEC a:AudioEffectWork1
    LDA #$84
    LDX #$8B
    JSR Apu_WritePulse2ControlSweep
    LDY a:AudioEffectWork1
    LDX a:Local_34A,Y
    LDA #$10
    JSR Apu_WritePulse2Timer
    LDA #$04
    STA a:AudioEffectWork0

    SfxHandlerLocal Local_346
    DEC a:AudioEffectWork0
    RTS
    SfxHandlerLocal Local_34A
    .incbin .concat(SfxAssetStem, "-tone-low.bin")

    SfxCoreEntry Sfx_InitPulse2PitchSequenceBase
    LDY #$14
    LDA #$04
    LDX #$03

    SfxHandlerLocal Local_354
    STY a:AudioEffectTimers+$01
    STA a:AudioEffectWork0
    STX a:AudioEffectWork2
    LDA #$01
    STA a:AudioEffectWork1

    SfxCoreEntry Sfx_UpdatePulse2PitchSequence
    DEC a:AudioEffectWork1
    BNE Local_38D
    LDA a:AudioEffectWork0
    BMI Local_38E
    CLC
    ADC a:AudioEffectWork2
    ASL A
    TAY
    LDA #$DF
    LDX #$8C
    JSR Apu_WritePulse2ControlSweep
    LDA a:PitchPeriods,Y
    TAX
    LDA a:PitchPeriods+1,Y
    ORA #$88
    JSR Apu_WritePulse2Timer
    DEC a:AudioEffectWork0
    LDA #$04
    STA a:AudioEffectWork1

    SfxHandlerLocal Local_38D
    RTS

    SfxHandlerLocal Local_38E
    JMP Audio_StopCurrentEffect

.if SfxBank = 0
    ::World1_AudioEffectPitchPeriods:
.else
    ::Bank2_Label_C2EA:
.endif
PitchPeriods:
    .incbin .concat(SfxAssetStem, "-pitch-periods.bin")
.if SfxBank = 0
    ::Bank0_Label_E7F3 = PitchPeriods + 1
.endif

    SfxCoreEntry Sfx_InitTrianglePitchDescent
    LDA #$10
    STA a:AudioEffectTimers+$02
    LDA #$40
    STA a:AudioEffectWork0
    LDA #$01
    STA a:AudioEffectWork1
    LDA #$30
    STA a:AudioEffectWork2

    SfxCoreEntry Sfx_UpdateTrianglePitchDescent
    LDY #$01
    LDX a:AudioEffectWork0
    LDA #$08
    JSR Apu_WriteTriangleControlTimer
    LDA a:AudioEffectWork0
    SEC
    SBC a:AudioEffectWork1
    STA a:AudioEffectWork0
    CMP a:AudioEffectWork2
    BNE Local_40B
    JMP Audio_StopCurrentEffect

    SfxHandlerLocal Local_40B
    RTS

    SfxCoreEntry AudioEffect_InitPulse2TwoTone
    LDA #$0E
    STA a:AudioEffectTimers+$01
    LDA #$06
    STA a:AudioEffectWork0
    STA a:AudioEffectWork1
    LDA #$9F
    LDX #$8D
    JSR Apu_WritePulse2ControlSweep
    LDX #$00
    LDA #$89
    JMP Apu_WritePulse2Timer

    SfxCoreEntry AudioEffect_UpdatePulse2TwoTone
    DEC a:AudioEffectWork0
    BNE Local_44C
    LDA a:AudioEffectWork1
    BEQ Local_449
    LDA #$08
    STA a:AudioEffectWork0
    LDA #$00
    STA a:AudioEffectWork1
    LDA #$9F
    LDX #$8C
    JSR Apu_WritePulse2ControlSweep
    LDX #$80
    LDA #$88
    JMP Apu_WritePulse2Timer

    SfxHandlerLocal Local_449
    JMP Audio_StopCurrentEffect

    SfxHandlerLocal Local_44C
    RTS

    SfxCoreEntry Sfx_InitPulse2PitchSequenceWide
    LDY #$34
    LDA #$0C
    LDX #$18
    JMP Local_354

    SfxCoreEntry AudioEffect_InitPulse2VolumeFade
    LDA #$20
    STA a:AudioEffectTimers+$01
    LDA #$1F
    LDX #$85
    JSR Apu_WritePulse2ControlSweep
    LDX #$69
    LDA #$08
    JSR Apu_WritePulse2Timer
    LDA #$02
    STA a:AudioEffectWork0
    LDA #$01
    STA a:AudioEffectWork1

    SfxCoreEntry Sfx_UpdatePulse2VolumeFade
    DEC a:AudioEffectWork1
    BNE ApuPulse1Return
    LDA #$04
    STA a:AudioEffectWork1
    LDY a:AudioEffectWork0
    LDA a:Local_48E,Y
    STA a:APU_PL2_VOL
    DEC a:AudioEffectWork0
    BPL ApuPulse1Return
    JMP Audio_StopCurrentEffect
    SfxHandlerLocal Local_48E
    .byte $00

    SfxCoreEntry AudioEffect_InitPulse1Alternator
    LDA #$00

StoreAlternatorMode:
    STA a:AudioEffectWork0
    LDA #$01
    STA a:AudioEffectWork1

    SfxCoreEntry Sfx_UpdatePulse1Alternator
    DEC a:AudioEffectWork1
    BNE Local_4BE
    LDA a:AudioEffectWork0
    EOR #$04
    STA a:AudioEffectWork0
    TAY
    LDA a:PulseSteps+1,Y
    STA a:AudioEffectWork1
    LDA #$DF
    LDX a:PulseControl,Y
    JSR Apu_WritePulse1ControlSweep
    LDX a:PulseControl+1,Y
    LDA a:PulseSteps,Y
    JMP Apu_WritePulse1Timer

    SfxHandlerLocal Local_4BE
    RTS

    LDA #$08
    BNE StoreAlternatorMode

SetAlternatorMode16:
    LDA #$10
    BNE StoreAlternatorMode
    JMP Sfx_UpdatePulse1Alternator
    JMP SetAlternatorMode16
    JMP Sfx_UpdatePulse1Alternator
    SfxHandlerLocal PulseControl
    .incbin .concat(SfxAssetStem, "-pulse-control.bin")
    SfxHandlerLocal PulseSteps
    .incbin .concat(SfxAssetStem, "-pulse-steps.bin")

.assert * - SfxHandlerStart = $04E8, error, "SFX handler block size changed"
