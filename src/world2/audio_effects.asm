; World 2 audio-effect arbitration, RTS dispatch, and handlers
; PRG bank 1, original CPU range $A80B-$AC2F

World2_AudioEffect_RequestPriority:
    .byte $00, $30, $38, $28, $1C, $20, $04, $18, $34, $0C, $2C, $14, $10, $08, $24

World2_AudioEffect_RtsDispatchTable:
    .byte $F1, $A8, $F0, $A8, $77, $A9, $8F, $A9, $CE, $A9, $E8, $A9, $97, $AA, $A4, $AA
    .byte $71, $AB, $85, $AB, $2E, $AB, $3D, $AB, $4E, $AA, $E3, $A8, $40, $A9, $85, $AB
    .byte $48, $A9, $85, $AB, $FE, $AB, $12, $AC, $38, $AA, $E3, $A8, $FD, $AA, $E3, $A8
    .byte $18, $AB, $E3, $A8, $67, $AA, $7E, $AA, $1E, $A9, $E8, $A8

World2_Audio_QueueEffectWithPriority:
    CMP #$0F
    BCS Bank1_Label_A874
    STX $AB
    LDX a:AudioEffectRequestState
    BMI Bank1_Label_A86F
    STY $AC
    TAY
    LDA a:World2_AudioEffect_RequestPriority,X
    CMP a:World2_AudioEffect_RequestPriority,Y
    BCC Bank1_Label_A875
    TYA
    LDY $AC

Bank1_Label_A86F:
    STA a:AudioEffectRequestState

Bank1_Label_A872:
    LDX $AB

Bank1_Label_A874:
    RTS

Bank1_Label_A875:
    LDY $AC
    JMP Bank1_Label_A872

World2_Audio_QueueEffect:
    CMP #$0F
    BCS Bank1_Label_A874
    STX $AB
    LDX #$00
    STX a:AudioCurrentEffectPriority
    STA a:AudioEffectRequestState
    LDX $AB
    RTS

World2_Audio_UpdateEffects:
    LDX #$03

Bank1_Label_A88D:
    LDA a:AudioEffectTimers,X
    BEQ Bank1_Label_A895
    DEC a:AudioEffectTimers,X

Bank1_Label_A895:
    DEX
    BPL Bank1_Label_A88D
    LDA a:AudioEffectRequestState
    BMI Bank1_Label_A8D2
    TAX
    ORA #$80
    STA a:AudioEffectRequestState
    CPX #$0F
    BCS Bank1_Label_A8D2
    LDA a:AudioCurrentEffectPriority
    BEQ Bank1_Label_A8BB
    LDA a:World2_AudioEffect_RequestPriority,X
    CMP a:AudioCurrentEffectPriority
    BCC Bank1_Label_A8BB
    BNE Bank1_Label_A8D2
    LDA a:AudioEffectRetriggerLock
    BNE Bank1_Label_A8D2

Bank1_Label_A8BB:
    LDA a:World2_AudioEffect_RequestPriority,X
    STA a:AudioCurrentEffectPriority
    TAX
    LDA #$00
    STA a:AudioEffectTimers
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectTimers+$03
    BEQ Bank1_Label_A8D7

Bank1_Label_A8D2:
    LDX a:AudioCurrentEffectPriority
    INX
    INX

Bank1_Label_A8D7:
    CPX #$3C
    BCS World2_Audio_StopCurrentEffect
    LDA a:World2_AudioEffect_RtsDispatchTable+1,X
    PHA
    LDA a:World2_AudioEffect_RtsDispatchTable,X
    PHA
    RTS

World2_AudioEffect_UpdateTimedStop:
    DEC a:AudioEffectWork0
    BNE World2_AudioEffect_NoOp

World2_Audio_StopCurrentEffect:
    LDA #$00
    STA a:AudioCurrentEffectPriority
    STA a:AudioEffectRetriggerLock

World2_AudioEffect_NoOp:
    RTS

World2_Audio_ResetEffects:
    LDA #$00
    STA a:AudioEffectRetriggerLock
    STA a:$4011
    STA a:AudioEffectTimers
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectTimers+$03
    STA a:APU_TRI_LINEAR
    STA a:APU_NOISE_VOL
    LDA #$18
    STA a:APU_TRI_HI
    LDA #$10
    STA a:APU_PL1_VOL
    STA a:APU_PL2_VOL
    LDA #$0F
    STA a:APU_STATUS
    RTS

World2_AudioEffect_InitTriangleNoiseBurst:
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
    JSR World2_Apu_WriteTriangleControlTimer
    STA a:APU_NOISE_HI
    RTS

World2_AudioEffect_InitPulse2PitchSequenceLong:
    LDY #$60
    LDA #$17
    LDX #$00
    BEQ Bank1_Label_A94F

World2_AudioEffect_InitPulse2PitchSequenceShort:
    LDY #$08
    LDA #$01
    LDX #$05

Bank1_Label_A94F:
    STY a:AudioEffectTimers+$01
    STA a:AudioEffectWork0
    STX a:AudioEffectWork2
    LDA #$01
    STA a:AudioEffectWork1
    JSR World2_AudioEffect_InitNoiseOnset
    JMP World2_AudioEffect_UpdatePulse2PitchSequence

World2_AudioEffect_InitNoiseOnset:
    LDA #$08
    STA a:AudioEffectTimers+$03
    LDA #$01
    STA a:APU_NOISE_VOL
    LDA #$0A
    STA a:APU_NOISE_LO
    LDA #$08
    STA a:APU_NOISE_HI

Bank1_Label_A977:
    RTS

World2_AudioEffect_InitPulse1AlternatingBurst:
    LDA #$48
    STA a:AudioEffectTimers
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectTimers+$03
    LDA #$01
    STA a:AudioEffectWork0
    LDA #$04
    STA a:AudioEffectWork1

World2_AudioEffect_UpdatePulse1AlternatingBurst:
    LDA a:AudioEffectWork1
    BNE Bank1_Label_A998
    JMP World2_AudioEffect_UpdateTimedStop

Bank1_Label_A998:
    DEC a:AudioEffectWork0
    BNE Bank1_Label_A977
    DEC a:AudioEffectWork1
    BEQ Bank1_Label_A9BC
    LDA #$04
    STA a:AudioEffectWork0
    LDA a:AudioEffectWork1
    LSR A
    BCC Bank1_Label_A9B8
    LDA #$82
    LDX #$00
    JSR World2_Apu_WritePulse1ControlSweep
    LDX #$69
    BNE Bank1_Label_A9CA

Bank1_Label_A9B8:
    LDA #$82
    BNE Bank1_Label_A9C3

Bank1_Label_A9BC:
    LDA #$3C
    STA a:AudioEffectWork0
    LDA #$8F

Bank1_Label_A9C3:
    LDX #$00
    JSR World2_Apu_WritePulse1ControlSweep
    LDX #$8D

Bank1_Label_A9CA:
    LDA #$08
    JMP World2_Apu_WritePulse1Timer

World2_AudioEffect_InitPulse1Sequence:
    LDA #$56
    STA $2D
    LDA #$AC
    STA $2E
    LDA #$01
    STA a:AudioEffectWork0
    STA a:AudioEffectRetriggerLock
    LDA #$09
    STA a:AudioEffectWork1
    LDA #$83
    STA a:AudioEffectWork2

World2_AudioEffect_UpdatePulse1Sequence:
    JSR World2_AudioEffect_GateSequenceStep
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
    BEQ World2_AudioEffect_AdvanceSequencePointer
    ASL A
    TAY
    LDA a:Bank1_Label_B11B,Y
    STA a:APU_PL1_LO,X
    LDA a:Bank1_Label_B11B+1,Y
    ORA #$08
    STA a:APU_PL1_HI,X

World2_AudioEffect_AdvanceSequencePointer:
    INC $2D
    BNE Bank1_Label_AA1F
    INC $2E

Bank1_Label_AA1F:
    RTS

World2_AudioEffect_GateSequenceStep:
    DEC a:AudioEffectWork0
    BNE Bank1_Label_AA36
    LDA a:AudioEffectWork1
    STA a:AudioEffectWork0
    LDY #$00
    LDA ($2D),Y
    CMP #$FF
    BNE Bank1_Label_AA38
    JSR World2_Audio_StopCurrentEffect

Bank1_Label_AA36:
    PLA
    PLA

Bank1_Label_AA38:
    RTS

World2_AudioEffect_InitPulse2FixedToneA:
    LDA #$0A
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectWork0
    LDA #$42
    LDX #$00
    JSR World2_Apu_WritePulse2ControlSweep
    LDX #$BB
    LDA #$08
    JMP World2_Apu_WritePulse2Timer

World2_AudioEffect_InitPulse1ToneWithTriangleLease:
    LDA #$04
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectWork0
    STA a:AudioEffectRetriggerLock
    LDA #$84
    LDX #$8A
    JSR World2_Apu_WritePulse1ControlSweep
    LDX #$7E
    LDA #$38
    JMP World2_Apu_WritePulse1Timer

World2_AudioEffect_InitNoisePeriodRamp:
    LDA #$10
    STA a:AudioEffectTimers+$03
    STA a:AudioEffectWork1
    LDA #$0C
    STA a:AudioEffectWork0
    LDA #$04
    STA a:APU_NOISE_VOL
    LDA #$08
    STA a:APU_NOISE_HI

World2_AudioEffect_UpdateNoisePeriodRamp:
    LDA a:AudioEffectWork0
    STA a:APU_NOISE_LO
    LDA a:AudioEffectWork0
    CMP #$0F
    BEQ Bank1_Label_AA8F
    INC a:AudioEffectWork0

Bank1_Label_AA8F:
    DEC a:AudioEffectWork1
    BNE Bank1_Label_AA97

Bank1_Label_AA94:
    JMP World2_Audio_StopCurrentEffect

Bank1_Label_AA97:
    RTS

World2_AudioEffect_InitIndexedTonalSequenceAlt:
    LDA #$5F
    STA $2D
    LDA #$AC
    STA $2E
    LDA #$01
    STA a:AudioEffectWork0

World2_AudioEffect_UpdateIndexedTonalSequenceAlt:
    DEC a:AudioEffectWork0
    BNE Bank1_Label_AA97
    LDY #$00
    LDA ($2D),Y
    CMP #$FF
    BEQ Bank1_Label_AA94
    STA a:AudioEffectWork0
    STA a:AudioEffectTimers
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectTimers+$03
    JSR World2_AudioEffect_AdvanceSequencePointer
    LDX #$00
    JSR World2_AudioEffect_WriteIndexedTonalEvent
    JSR World2_AudioEffect_WriteIndexedTonalEvent

World2_AudioEffect_WriteIndexedTonalEvent:
    LDY #$00
    LDA ($2D),Y
    BEQ Bank1_Label_AAF7
    ASL A
    TAY
    LDA a:AudioEffectWork0
    CPX #$08
    BEQ Bank1_Label_AAE0
    LSR A
    ORA #$C0
    BNE Bank1_Label_AAE1

Bank1_Label_AAE0:
    ASL A

Bank1_Label_AAE1:
    STA a:APU_PL1_VOL,X
    LDA #$00
    STA a:APU_PL1_SWEEP,X
    LDA a:Bank1_Label_B11B,Y
    STA a:APU_PL1_LO,X
    LDA a:Bank1_Label_B11B+1,Y
    ORA #$08
    STA a:APU_PL1_HI,X

Bank1_Label_AAF7:
    INX
    INX
    INX
    INX
    JMP World2_AudioEffect_AdvanceSequencePointer

World2_AudioEffect_InitPulse2FixedToneB:
    LDA #$18
    STA a:AudioEffectTimers+$01
    LDA #$10
    STA a:AudioEffectWork0
    STA a:AudioEffectRetriggerLock
    LDA #$A0
    LDX #$9B
    JSR World2_Apu_WritePulse2ControlSweep
    LDX #$FE
    LDA #$19
    JMP World2_Apu_WritePulse2Timer

World2_AudioEffect_InitPulse2FixedToneC:
    LDA #$08
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectWork0
    LDA #$C0
    LDX #$83
    JSR World2_Apu_WritePulse2ControlSweep
    LDX #$60
    LDA #$08
    JMP World2_Apu_WritePulse2Timer

World2_AudioEffect_InitPulse2ThreeStep:
    LDA #$03
    STA a:AudioEffectWork1
    LDA #$FF
    STA a:AudioEffectTimers+$01
    LDA #$00
    STA a:AudioEffectWork0

World2_AudioEffect_UpdatePulse2ThreeStep:
    LDA a:AudioEffectWork0
    BNE Bank1_Label_AB6A
    LDA a:AudioEffectWork1
    BNE Bank1_Label_AB50
    LDA #$00
    STA a:AudioEffectTimers+$01
    JMP World2_Audio_StopCurrentEffect

Bank1_Label_AB50:
    DEC a:AudioEffectWork1
    LDA #$84
    LDX #$8B
    JSR World2_Apu_WritePulse2ControlSweep
    LDY a:AudioEffectWork1
    LDX a:Bank1_Label_AB6E,Y
    LDA #$10
    JSR World2_Apu_WritePulse2Timer
    LDA #$04
    STA a:AudioEffectWork0

Bank1_Label_AB6A:
    DEC a:AudioEffectWork0
    RTS
Bank1_Label_AB6E:
    .byte $65, $87, $B4, $F0

World2_AudioEffect_InitPulse2PitchSequenceBase:
    LDY #$14
    LDA #$04
    LDX #$03
    STY a:AudioEffectTimers+$01
    STA a:AudioEffectWork0
    STX a:AudioEffectWork2
    LDA #$01
    STA a:AudioEffectWork1

World2_AudioEffect_UpdatePulse2PitchSequence:
    DEC a:AudioEffectWork1
    BNE Bank1_Label_ABB1
    LDA a:AudioEffectWork0
    BMI Bank1_Label_ABB2
    CLC
    ADC a:AudioEffectWork2
    ASL A
    TAY
    LDA #$DF
    LDX #$8C
    JSR World2_Apu_WritePulse2ControlSweep
    LDA a:Bank1_Label_ABB5,Y
    TAX
    LDA a:Bank1_Label_ABB5+1,Y
    ORA #$88
    JSR World2_Apu_WritePulse2Timer
    DEC a:AudioEffectWork0
    LDA #$04
    STA a:AudioEffectWork1

Bank1_Label_ABB1:
    RTS

Bank1_Label_ABB2:
    JMP World2_Audio_StopCurrentEffect
Bank1_Label_ABB5:
    .byte $00, $06, $00, $03, $00, $02, $40, $01, $C0, $00, $80, $00, $60, $00, $50, $00
    .byte $2B, $03, $35, $00, $2C, $03, $33, $06, $2B, $03, $35, $00, $2C, $03, $33, $06
    .byte $2B, $03, $35, $00, $2C, $03, $33, $06, $2B, $03, $35, $00, $2C, $03, $33, $06
    .byte $69, $00, $70, $00, $76, $00, $7E, $00, $85, $00, $8D, $00, $96, $00, $9F, $00
    .byte $A8, $00, $B2, $00, $BD, $00, $C8, $00, $D4, $00

World2_AudioEffect_InitTrianglePitchDescent:
    LDA #$10
    STA a:AudioEffectTimers+$02
    LDA #$40
    STA a:AudioEffectWork0
    LDA #$01
    STA a:AudioEffectWork1
    LDA #$30
    STA a:AudioEffectWork2

World2_AudioEffect_UpdateTrianglePitchDescent:
    LDY #$01
    LDX a:AudioEffectWork0
    LDA #$08
    JSR World2_Apu_WriteTriangleControlTimer
    LDA a:AudioEffectWork0
    SEC
    SBC a:AudioEffectWork1
    STA a:AudioEffectWork0
    CMP a:AudioEffectWork2
    BNE Bank1_Label_AC2F
    JMP World2_Audio_StopCurrentEffect

Bank1_Label_AC2F:
    RTS
