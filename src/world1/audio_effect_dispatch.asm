; World 1 audio-effect arbitration, RTS dispatch, and early handlers
; PRG bank 0, original CPU range $E316-$E68C

World1_AudioEffect_RequestPriority:
    .byte $00, $54, $64, $4C, $40, $44, $04, $38, $34, $3C, $1C, $50, $58, $60, $2C, $28
    .byte $08, $48, $30, $20, $24, $18, $14, $10, $0C, $5C

World1_AudioEffect_RtsDispatchTable:
    .byte $33, $E4, $32, $E4, $54, $E5, $6C, $E5, $AB, $E5, $C5, $E5, $EF, $E8, $F9, $E8
    .byte $EF, $E8, $F9, $E8, $EF, $E8, $F9, $E8, $EF, $E8, $F9, $E8, $8C, $E6, $99, $E6
    .byte $AD, $E8, $C2, $E7, $B6, $E8, $D3, $E8, $AE, $E7, $C2, $E7, $6B, $E7, $7A, $E7
    .byte $6C, $E8, $87, $E8, $43, $E6, $25, $E4, $15, $E6, $25, $E4, $5C, $E6, $73, $E6
    .byte $1D, $E5, $C2, $E7, $25, $E5, $C2, $E7, $3B, $E8, $4F, $E8, $2D, $E6, $25, $E4
    .byte $F2, $E6, $25, $E4, $0D, $E7, $25, $E4, $60, $E4, $82, $E4, $60, $E4, $CB, $E4
    .byte $23, $E7, $37, $E7, $FB, $E4, $2A, $E4

World1_Audio_QueueEffectWithPriority:
.define SfxCorePrefix "World1_"
.scope Bank0SfxDispatch
SfxBank = 0
SfxCoreCpuBase = $E398
SfxRequestLimit = $1A
SfxDispatchLimit = SfxRequestLimit * 4
SfxSavedX = $3C
SfxSavedY = SfxSavedX + 1
RequestPriority = ::World1_AudioEffect_RequestPriority
EffectDispatchTable = ::World1_AudioEffect_RtsDispatchTable

    .include "../audio/sfx_dispatch_shared.inc"
.endscope
.undefine SfxCorePrefix

World1_AudioEffect_InitNoiseSweep:
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

World1_AudioEffect_UpdateNoiseSweepSlow:
    LDX a:AudioEffectWork1
    BEQ Bank0_Label_E4B3
    DEX
    BEQ Bank0_Label_E48E
    JMP World1_AudioEffect_UpdateTimedStop

Bank0_Label_E48E:
    DEC a:AudioEffectWork0
    LDA a:AudioEffectWork0
    STA a:APU_NOISE_LO
    CMP #$08
    BNE Bank0_Label_E4CB
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

Bank0_Label_E4B3:
    DEC a:AudioEffectWork2
    BNE Bank0_Label_E4CB
    INC a:AudioEffectWork1
    LDA #$04
    STA a:APU_NOISE_VOL
    LDA a:AudioEffectWork0
    STA a:APU_NOISE_LO
    LDA #$08
    STA a:APU_NOISE_HI

Bank0_Label_E4CB:
    RTS

World1_AudioEffect_UpdateNoiseSweepFast:
    LDX a:AudioEffectWork1
    BEQ Bank0_Label_E4B3
    DEX
    BEQ Bank0_Label_E4D7
    JMP World1_AudioEffect_UpdateTimedStop

Bank0_Label_E4D7:
    DEC a:AudioEffectWork0
    LDA a:AudioEffectWork0
    STA a:APU_NOISE_LO
    CMP #$08
    BNE Bank0_Label_E4CB
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

World1_Sfx_InitTriangleNoiseBurst:
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
    JSR World1_Apu_WriteTriangleControlTimer
    STA a:APU_NOISE_HI
    RTS

World1_Sfx_InitPulse2PitchSequenceLong:
    LDY #$60
    LDA #$17
    LDX #$00
    BEQ Bank0_Label_E52C

World1_Sfx_InitPulse2PitchSequenceShort:
    LDY #$08
    LDA #$01
    LDX #$05

Bank0_Label_E52C:
    STY a:AudioEffectTimers+$01
    STA a:AudioEffectWork0
    STX a:AudioEffectWork2
    LDA #$01
    STA a:AudioEffectWork1
    JSR World1_AudioEffect_InitNoiseOnset
    JMP World1_Sfx_UpdatePulse2PitchSequence

World1_AudioEffect_InitNoiseOnset:
    LDA #$08
    STA a:AudioEffectTimers+$03
    LDA #$01
    STA a:APU_NOISE_VOL
    LDA #$0A
    STA a:APU_NOISE_LO
    LDA #$08
    STA a:APU_NOISE_HI

Bank0_Label_E554:
    RTS

World1_Sfx_InitPulse1AlternatingBurst:
    LDA #$48
    STA a:AudioEffectTimers
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectTimers+$03
    LDA #$01
    STA a:AudioEffectWork0
    LDA #$04
    STA a:AudioEffectWork1

World1_Sfx_UpdatePulse1AlternatingBurst:
    LDA a:AudioEffectWork1
    BNE Bank0_Label_E575
    JMP World1_AudioEffect_UpdateTimedStop

Bank0_Label_E575:
    DEC a:AudioEffectWork0
    BNE Bank0_Label_E554
    DEC a:AudioEffectWork1
    BEQ Bank0_Label_E599
    LDA #$04
    STA a:AudioEffectWork0
    LDA a:AudioEffectWork1
    LSR A
    BCC Bank0_Label_E595
    LDA #$82
    LDX #$00
    JSR World1_Apu_WritePulse1ControlSweep
    LDX #$69
    BNE Bank0_Label_E5A7

Bank0_Label_E595:
    LDA #$82
    BNE Bank0_Label_E5A0

Bank0_Label_E599:
    LDA #$3C
    STA a:AudioEffectWork0
    LDA #$8F

Bank0_Label_E5A0:
    LDX #$00
    JSR World1_Apu_WritePulse1ControlSweep
    LDX #$8D

Bank0_Label_E5A7:
    LDA #$08
    JMP World1_Apu_WritePulse1Timer

World1_AudioEffect_InitPulse1Sequence:
    LDA #$6F
    STA $2D
    LDA #$E9
    STA $2E
    LDA #$01
    STA a:AudioEffectWork0
    STA a:AudioEffectRetriggerLock
    LDA #$09
    STA a:AudioEffectWork1
    LDA #$83
    STA a:AudioEffectWork2

World1_AudioEffect_UpdatePulse1Sequence:
    JSR World1_AudioEffect_GateSequenceStep
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
    BEQ World1_Sfx_AdvanceSequencePointer
    ASL A
    TAY
    LDA a:Bank0_Label_EE34,Y
    STA a:APU_PL1_LO,X
    LDA a:Bank0_Label_EE34+1,Y
    ORA #$08
    STA a:APU_PL1_HI,X

World1_Sfx_AdvanceSequencePointer:
    INC $2D
    BNE Bank0_Label_E5FC
    INC $2E

Bank0_Label_E5FC:
    RTS

World1_AudioEffect_GateSequenceStep:
    DEC a:AudioEffectWork0
    BNE Bank0_Label_E613
    LDA a:AudioEffectWork1
    STA a:AudioEffectWork0
    LDY #$00
    LDA ($2D),Y
    CMP #$FF
    BNE Bank0_Label_E615
    JSR World1_Audio_StopCurrentEffect

Bank0_Label_E613:
    PLA
    PLA

Bank0_Label_E615:
    RTS

World1_AudioEffect_InitPulse1FixedTone:
    LDA #$04
    STA a:AudioEffectTimers
    STA a:AudioEffectWork0
    STA a:AudioEffectRetriggerLock
    LDA #$00
    TAX
    JSR World1_Apu_WritePulse1ControlSweep
    LDX #$3E
    LDA #$38
    JMP World1_Apu_WritePulse1Timer

World1_AudioEffect_InitPulse2FixedToneA:
    LDA #$0A
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectWork0
    LDA #$42
    LDX #$00
    JSR World1_Apu_WritePulse2ControlSweep
    LDX #$BB
    LDA #$08
    JMP World1_Apu_WritePulse2Timer

World1_Sfx_InitPulse1ToneWithTriLease:
    LDA #$04
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectWork0
    STA a:AudioEffectRetriggerLock
    LDA #$84
    LDX #$8A
    JSR World1_Apu_WritePulse1ControlSweep
    LDX #$7E
    LDA #$38
    JMP World1_Apu_WritePulse1Timer

World1_AudioEffect_InitNoisePeriodRamp:
    LDA #$10
    STA a:AudioEffectTimers+$03
    STA a:AudioEffectWork1
    LDA #$0C
    STA a:AudioEffectWork0
    LDA #$04
    STA a:APU_NOISE_VOL
    LDA #$08
    STA a:APU_NOISE_HI

World1_AudioEffect_UpdateNoisePeriodRamp:
    LDA a:AudioEffectWork0
    STA a:APU_NOISE_LO
    LDA a:AudioEffectWork0
    CMP #$0F
    BEQ Bank0_Label_E684
    INC a:AudioEffectWork0

Bank0_Label_E684:
    DEC a:AudioEffectWork1
    BNE Bank0_Label_E68C

Bank0_Label_E689:
    JMP World1_Audio_StopCurrentEffect

Bank0_Label_E68C:
    RTS
