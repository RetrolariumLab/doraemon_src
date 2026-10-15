; Doraemon PRG bank 2 $C016-$C440
; World 3 remaining audio-effect handlers
; Generated deterministically from pinned Ghidra/GhidraNes facts

World3_AudioEffect_InitPulse2PitchSequenceLong:
    LDY #$60
    LDA #$17
    LDX #$00
    BEQ Bank2_Label_C024

World3_AudioEffect_InitPulse2PitchSequenceShort:
    LDY #$08
    LDA #$01
    LDX #$05

Bank2_Label_C024:
    STY a:AudioEffectTimers+$01
    STA a:AudioEffectWork0
    STX a:AudioEffectWork2
    LDA #$01
    STA a:AudioEffectWork1
    JSR World3_AudioEffect_InitNoiseOnset
    JMP World3_AudioEffect_UpdatePulse2PitchSequence

World3_AudioEffect_InitNoiseOnset:
    LDA #$08
    STA a:AudioEffectTimers+$03
    LDA #$01
    STA a:APU_NOISE_VOL
    LDA #$0A
    STA a:APU_NOISE_LO
    LDA #$08
    STA a:APU_NOISE_HI

Bank2_Label_C04C:
    RTS

World3_AudioEffect_InitPulse1AlternatingBurst:
    LDA #$48
    STA a:AudioEffectTimers
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectTimers+$03
    LDA #$01
    STA a:AudioEffectWork0
    LDA #$04
    STA a:AudioEffectWork1

World3_AudioEffect_UpdatePulse1AlternatingBurst:
    LDA a:AudioEffectWork1
    BNE Bank2_Label_C06D
    JMP World3_AudioEffect_UpdateTimedStop

Bank2_Label_C06D:
    DEC a:AudioEffectWork0
    BNE Bank2_Label_C04C
    DEC a:AudioEffectWork1
    BEQ Bank2_Label_C091
    LDA #$04
    STA a:AudioEffectWork0
    LDA a:AudioEffectWork1
    LSR A
    BCC Bank2_Label_C08D
    LDA #$82
    LDX #$00
    JSR World3_Apu_WritePulse1ControlSweep
    LDX #$69
    BNE Bank2_Label_C09F

Bank2_Label_C08D:
    LDA #$82
    BNE Bank2_Label_C098

Bank2_Label_C091:
    LDA #$3C
    STA a:AudioEffectWork0
    LDA #$8F

Bank2_Label_C098:
    LDX #$00
    JSR World3_Apu_WritePulse1ControlSweep
    LDX #$8D

Bank2_Label_C09F:
    LDA #$08
    JMP World3_Apu_WritePulse1Timer

World3_AudioEffect_InitPulse1Sequence:
    LDA #$67
    STA $2D
    LDA #$C4
    STA $2E
    LDA #$01
    STA a:AudioEffectWork0
    STA a:AudioEffectRetriggerLock
    LDA #$09
    STA a:AudioEffectWork1
    LDA #$83
    STA a:AudioEffectWork2

World3_AudioEffect_UpdatePulse1Sequence:
    JSR World3_AudioEffect_GateSequenceStep
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
    BEQ World3_AudioEffect_AdvanceSequencePointer
    ASL A
    TAY
    LDA a:Bank2_Label_C92C,Y
    STA a:APU_PL1_LO,X
    LDA a:Bank2_Label_C92C+1,Y
    ORA #$08
    STA a:APU_PL1_HI,X

World3_AudioEffect_AdvanceSequencePointer:
    INC $2D
    BNE Bank2_Label_C0F4
    INC $2E

Bank2_Label_C0F4:
    RTS

World3_AudioEffect_GateSequenceStep:
    DEC a:AudioEffectWork0
    BNE Bank2_Label_C10B
    LDA a:AudioEffectWork1
    STA a:AudioEffectWork0
    LDY #$00
    LDA ($2D),Y
    CMP #$FF
    BNE Bank2_Label_C10D
    JSR World3_Audio_StopCurrentEffect

Bank2_Label_C10B:
    PLA
    PLA

Bank2_Label_C10D:
    RTS

World3_AudioEffect_InitPulse1FixedTone:
    LDA #$04
    STA a:AudioEffectTimers
    STA a:AudioEffectWork0
    STA a:AudioEffectRetriggerLock
    LDA #$00
    TAX
    JSR World3_Apu_WritePulse1ControlSweep
    LDX #$3E
    LDA #$38
    JMP World3_Apu_WritePulse1Timer

World3_AudioEffect_InitPulse2FixedToneA:
    LDA #$0A
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectWork0
    LDA #$42
    LDX #$00
    JSR World3_Apu_WritePulse2ControlSweep
    LDX #$BB
    LDA #$08
    JMP World3_Apu_WritePulse2Timer

World3_AudioEffect_InitPulse1ToneWithTriangleLease:
    LDA #$04
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectWork0
    STA a:AudioEffectRetriggerLock
    LDA #$84
    LDX #$8A
    JSR World3_Apu_WritePulse1ControlSweep
    LDX #$7E
    LDA #$38
    JMP World3_Apu_WritePulse1Timer

World3_AudioEffect_InitNoisePeriodRamp:
    LDA #$10
    STA a:AudioEffectTimers+$03
    STA a:AudioEffectWork1
    LDA #$0C
    STA a:AudioEffectWork0
    LDA #$04
    STA a:APU_NOISE_VOL
    LDA #$08
    STA a:APU_NOISE_HI

World3_AudioEffect_UpdateNoisePeriodRamp:
    LDA a:AudioEffectWork0
    STA a:APU_NOISE_LO
    LDA a:AudioEffectWork0
    CMP #$0F
    BEQ Bank2_Label_C17C
    INC a:AudioEffectWork0

Bank2_Label_C17C:
    DEC a:AudioEffectWork1
    BNE Bank2_Label_C184

Bank2_Label_C181:
    JMP World3_Audio_StopCurrentEffect

Bank2_Label_C184:
    RTS

World3_AudioEffect_InitIndexedTonalSequenceAlt:
    LDA #$70
    STA $2D
    LDA #$C4
    STA $2E
    LDA #$01
    STA a:AudioEffectWork0

World3_AudioEffect_UpdateIndexedTonalSequenceAlt:
    DEC a:AudioEffectWork0
    BNE Bank2_Label_C184
    LDY #$00
    LDA ($2D),Y
    CMP #$FF
    BEQ Bank2_Label_C181
    STA a:AudioEffectWork0
    STA a:AudioEffectTimers
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectTimers+$03
    JSR World3_AudioEffect_AdvanceSequencePointer
    LDX #$00
    JSR World3_AudioEffect_WriteIndexedTonalEvent
    JSR World3_AudioEffect_WriteIndexedTonalEvent

World3_AudioEffect_WriteIndexedTonalEvent:
    LDY #$00
    LDA ($2D),Y
    BEQ Bank2_Label_C1E4
    ASL A
    TAY
    LDA a:AudioEffectWork0
    CPX #$08
    BEQ Bank2_Label_C1CD
    LSR A
    ORA #$C0
    BNE Bank2_Label_C1CE

Bank2_Label_C1CD:
    ASL A

Bank2_Label_C1CE:
    STA a:APU_PL1_VOL,X
    LDA #$00
    STA a:APU_PL1_SWEEP,X
    LDA a:Bank2_Label_C92C,Y
    STA a:APU_PL1_LO,X
    LDA a:Bank2_Label_C92C+1,Y
    ORA #$08
    STA a:APU_PL1_HI,X

Bank2_Label_C1E4:
    INX
    INX
    INX
    INX
    JMP World3_AudioEffect_AdvanceSequencePointer

World3_AudioEffect_InitPulse2FixedToneB:
    LDA #$18
    STA a:AudioEffectTimers+$01
    LDA #$10
    STA a:AudioEffectWork0
    STA a:AudioEffectRetriggerLock
    LDA #$A0
    LDX #$9B
    JSR World3_Apu_WritePulse2ControlSweep
    LDX #$FE
    LDA #$19
    JMP World3_Apu_WritePulse2Timer

World3_AudioEffect_InitPulse2FixedToneC:
    LDA #$08
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectWork0
    LDA #$C0
    LDX #$83
    JSR World3_Apu_WritePulse2ControlSweep
    LDX #$60
    LDA #$08
    JMP World3_Apu_WritePulse2Timer

World3_AudioEffect_InitNoiseVolumeSweep:
    LDA #$18
    STA a:AudioEffectTimers+$03
    LDA #$04
    STA a:APU_NOISE_LO
    LDA #$0F
    STA a:AudioEffectWork0
    LDA #$00
    STA a:AudioEffectWork1

World3_AudioEffect_UpdateNoiseVolumeSweep:
    LDA a:AudioEffectWork0
    CMP #$10
    BEQ Bank2_Label_C25C
    ORA #$10
    STA a:APU_NOISE_VOL
    LDA #$28
    STA a:APU_NOISE_HI
    LDA a:AudioEffectWork1
    BEQ Bank2_Label_C24A
    INC a:AudioEffectWork0
    RTS

Bank2_Label_C24A:
    LDA a:AudioEffectWork0
    CMP #$02
    BCC Bank2_Label_C258
    DEC a:AudioEffectWork0
    DEC a:AudioEffectWork0
    RTS

Bank2_Label_C258:
    INC a:AudioEffectWork1
    RTS

Bank2_Label_C25C:
    LDA #$10
    STA a:APU_NOISE_VOL
    JMP World3_Audio_StopCurrentEffect

World3_AudioEffect_InitPulse2ThreeStep:
    LDA #$03
    STA a:AudioEffectWork1
    LDA #$FF
    STA a:AudioEffectTimers+$01
    LDA #$00
    STA a:AudioEffectWork0

World3_AudioEffect_UpdatePulse2ThreeStep:
    LDA a:AudioEffectWork0
    BNE Bank2_Label_C29F
    LDA a:AudioEffectWork1
    BNE Bank2_Label_C285
    LDA #$00
    STA a:AudioEffectTimers+$01
    JMP World3_Audio_StopCurrentEffect

Bank2_Label_C285:
    DEC a:AudioEffectWork1
    LDA #$84
    LDX #$8B
    JSR World3_Apu_WritePulse2ControlSweep
    LDY a:AudioEffectWork1
    LDX a:Bank2_Label_C2A3,Y
    LDA #$10
    JSR World3_Apu_WritePulse2Timer
    LDA #$04
    STA a:AudioEffectWork0

Bank2_Label_C29F:
    DEC a:AudioEffectWork0
    RTS
Bank2_Label_C2A3:
    .byte $65, $87, $B4, $F0

World3_AudioEffect_InitPulse2PitchSequenceBase:
    LDY #$14
    LDA #$04
    LDX #$03

Bank2_Label_C2AD:
    STY a:AudioEffectTimers+$01
    STA a:AudioEffectWork0
    STX a:AudioEffectWork2
    LDA #$01
    STA a:AudioEffectWork1

World3_AudioEffect_UpdatePulse2PitchSequence:
    DEC a:AudioEffectWork1
    BNE Bank2_Label_C2E6
    LDA a:AudioEffectWork0
    BMI Bank2_Label_C2E7
    CLC
    ADC a:AudioEffectWork2
    ASL A
    TAY
    LDA #$DF
    LDX #$8C
    JSR World3_Apu_WritePulse2ControlSweep
    LDA a:Bank2_Label_C2EA,Y
    TAX
    LDA a:Bank2_Label_C2EA+1,Y
    ORA #$88
    JSR World3_Apu_WritePulse2Timer
    DEC a:AudioEffectWork0
    LDA #$04
    STA a:AudioEffectWork1

Bank2_Label_C2E6:
    RTS

Bank2_Label_C2E7:
    JMP World3_Audio_StopCurrentEffect
Bank2_Label_C2EA:
    .byte $00, $06, $00, $03, $00, $02, $40, $01, $C0, $00, $80, $00, $60, $00, $50, $00
    .byte $2B, $03, $35, $00, $2C, $03, $33, $06, $2B, $03, $35, $00, $2C, $03, $33, $06
    .byte $2B, $03, $35, $00, $2C, $03, $33, $06, $2B, $03, $35, $00, $2C, $03, $33, $06
    .byte $69, $00, $70, $00, $76, $00, $7E, $00, $85, $00, $8D, $00, $96, $00, $9F, $00
    .byte $A8, $00, $B2, $00, $BD, $00, $C8, $00, $D4, $00

World3_AudioEffect_InitTrianglePitchDescent:
    LDA #$10
    STA a:AudioEffectTimers+$02
    LDA #$40
    STA a:AudioEffectWork0
    LDA #$01
    STA a:AudioEffectWork1
    LDA #$30
    STA a:AudioEffectWork2

World3_AudioEffect_UpdateTrianglePitchDescent:
    LDY #$01
    LDX a:AudioEffectWork0
    LDA #$08
    JSR World3_Apu_WriteTriangleControlTimer
    LDA a:AudioEffectWork0
    SEC
    SBC a:AudioEffectWork1
    STA a:AudioEffectWork0
    CMP a:AudioEffectWork2
    BNE Bank2_Label_C364
    JMP World3_Audio_StopCurrentEffect

Bank2_Label_C364:
    RTS

World3_AudioEffect_InitPulse2TwoTone:
    LDA #$0E
    STA a:AudioEffectTimers+$01
    LDA #$06
    STA a:AudioEffectWork0
    STA a:AudioEffectWork1
    LDA #$9F
    LDX #$8D
    JSR World3_Apu_WritePulse2ControlSweep
    LDX #$00
    LDA #$89
    JMP World3_Apu_WritePulse2Timer

World3_AudioEffect_UpdatePulse2TwoTone:
    DEC a:AudioEffectWork0
    BNE Bank2_Label_C3A5
    LDA a:AudioEffectWork1
    BEQ Bank2_Label_C3A2
    LDA #$08
    STA a:AudioEffectWork0
    LDA #$00
    STA a:AudioEffectWork1
    LDA #$9F
    LDX #$8C
    JSR World3_Apu_WritePulse2ControlSweep
    LDX #$80
    LDA #$88
    JMP World3_Apu_WritePulse2Timer

Bank2_Label_C3A2:
    JMP World3_Audio_StopCurrentEffect

Bank2_Label_C3A5:
    RTS

World3_AudioEffect_InitPulse2PitchSequenceWide:
    LDY #$34
    LDA #$0C
    LDX #$18
    JMP Bank2_Label_C2AD

World3_AudioEffect_InitPulse2VolumeFade:
    LDA #$20
    STA a:AudioEffectTimers+$01
    LDA #$1F
    LDX #$85
    JSR World3_Apu_WritePulse2ControlSweep
    LDX #$69
    LDA #$08
    JSR World3_Apu_WritePulse2Timer
    LDA #$02
    STA a:AudioEffectWork0
    LDA #$01
    STA a:AudioEffectWork1

World3_AudioEffect_UpdatePulse2VolumeFade:
    DEC a:AudioEffectWork1
    BNE Bank2_Label_C447
    LDA #$04
    STA a:AudioEffectWork1
    LDY a:AudioEffectWork0
    LDA a:Bank2_Label_C3E7,Y
    STA a:APU_PL2_VOL
    DEC a:AudioEffectWork0
    BPL Bank2_Label_C447
    JMP World3_Audio_StopCurrentEffect
Bank2_Label_C3E7:
    .byte $00

World3_AudioEffect_InitPulse1Alternator:
    LDA #$00
    STA a:AudioEffectWork0
    LDA #$01
    STA a:AudioEffectWork1

World3_AudioEffect_UpdatePulse1Alternator:
    DEC a:AudioEffectWork1
    BNE Bank2_Label_C417
    LDA a:AudioEffectWork0
    EOR #$04
    STA a:AudioEffectWork0
    TAY
    LDA a:Bank2_Label_C42B+1,Y
    STA a:AudioEffectWork1
    LDA #$DF
    LDX a:Bank2_Label_C429,Y
    JSR World3_Apu_WritePulse1ControlSweep
    LDX a:Bank2_Label_C429+1,Y
    LDA a:Bank2_Label_C42B,Y
    JMP World3_Apu_WritePulse1Timer

Bank2_Label_C417:
    RTS
    .byte $A9, $08, $D0, $CE, $A9, $10, $D0, $CA, $4C, $F2, $C3, $4C, $1C, $C4, $4C, $F2
    .byte $C3
Bank2_Label_C429:
    .byte $8F, $80
Bank2_Label_C42B:
    .byte $FC, $08, $87, $00, $FC, $08, $8D, $80, $FC, $06, $85, $00, $FB
    .byte $06, $8B, $80, $FC, $04, $83, $00, $FA, $04
