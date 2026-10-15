; Doraemon PRG bank 3 $9784-$9C1C
; Audio-effect request tables, arbitration, and primary handlers
; Generated deterministically from pinned Ghidra/GhidraNes facts

AudioEffect_RequestPriority:
    .byte $00, $54, $64, $4C, $40, $44, $04, $38, $34, $3C, $1C, $50, $58, $60, $2C, $28
    .byte $08, $48, $30, $20, $24, $18, $14, $10, $0C, $5C

AudioEffect_RtsDispatchTable:
    .byte $A1, $98, $A0, $98, $C2, $99, $DA, $99, $19, $9A, $33, $9A, $EE, $9D, $9B, $9D
    .byte $C3, $9D, $CD, $9D, $8E, $9D, $98, $9D, $5E, $9D, $68, $9D, $FA, $9A, $07, $9B
    .byte $1B, $9D, $30, $9C, $24, $9D, $41, $9D, $1C, $9C, $30, $9C, $D9, $9B, $E8, $9B
    .byte $DA, $9C, $F5, $9C, $B1, $9A, $93, $98, $83, $9A, $93, $98, $CA, $9A, $E1, $9A
    .byte $8B, $99, $30, $9C, $93, $99, $30, $9C, $A9, $9C, $BD, $9C, $9B, $9A, $93, $98
    .byte $60, $9B, $93, $98, $7B, $9B, $93, $98, $CE, $98, $F0, $98, $CE, $98, $39, $99
    .byte $91, $9B, $A5, $9B, $69, $99, $98, $98, $C9, $1A, $B0, $1A, $86, $49, $AE, $A0
    .byte $02, $30, $0E, $84, $4A, $A8, $BD, $84, $97, $D9, $84, $97, $90, $09, $98, $A4
    .byte $4A, $8D, $A0, $02, $A6, $49

Bank3_Label_9824:
    RTS
    .byte $A4, $4A, $4C, $22, $98

Audio_QueueEffect:
    CMP #$1A
    BCS Bank3_Label_9824
    STX $49
    LDX #$00
    STX a:AudioCurrentEffectPriority
    STA a:AudioEffectRequestState
    LDX $49
    RTS

Audio_UpdateEffects:
    LDX #$03

Bank3_Label_983D:
    LDA a:AudioEffectTimers,X
    BEQ Bank3_Label_9845
    DEC a:AudioEffectTimers,X

Bank3_Label_9845:
    DEX
    BPL Bank3_Label_983D
    LDA a:AudioEffectRequestState
    BMI Bank3_Label_9882
    TAX
    ORA #$80
    STA a:AudioEffectRequestState
    CPX #$1A
    BCS Bank3_Label_9882
    LDA a:AudioCurrentEffectPriority
    BEQ Bank3_Label_986B
    LDA a:AudioEffect_RequestPriority,X
    CMP a:AudioCurrentEffectPriority
    BCC Bank3_Label_986B
    BNE Bank3_Label_9882
    LDA a:AudioEffectRetriggerLock
    BNE Bank3_Label_9882

Bank3_Label_986B:
    LDA a:AudioEffect_RequestPriority,X
    STA a:AudioCurrentEffectPriority
    TAX
    LDA #$00
    STA a:AudioEffectTimers
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectTimers+$03
    BEQ Bank3_Label_9887

Bank3_Label_9882:
    LDX a:AudioCurrentEffectPriority
    INX
    INX

Bank3_Label_9887:
    CPX #$68
    BCS Audio_StopCurrentEffect
    LDA a:AudioEffect_RtsDispatchTable+1,X
    PHA
    LDA a:AudioEffect_RtsDispatchTable,X
    PHA
    RTS

AudioEffect_UpdateTimedStop:
    DEC a:AudioEffectWork0
    BNE AudioEffect_NoOp

Audio_StopCurrentEffect:
    LDA #$00
    STA a:AudioCurrentEffectPriority
    STA a:AudioEffectRetriggerLock

AudioEffect_NoOp:
    RTS

Audio_ResetEffects:
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

AudioEffect_InitNoiseSweep:
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

AudioEffect_UpdateNoiseSweepSlow:
    LDX a:AudioEffectWork1
    BEQ Bank3_Label_9921
    DEX
    BEQ Bank3_Label_98FC
    JMP AudioEffect_UpdateTimedStop

Bank3_Label_98FC:
    DEC a:AudioEffectWork0
    LDA a:AudioEffectWork0
    STA a:APU_NOISE_LO
    CMP #$08
    BNE Bank3_Label_9939
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

Bank3_Label_9921:
    DEC a:AudioEffectWork2
    BNE Bank3_Label_9939
    INC a:AudioEffectWork1
    LDA #$04
    STA a:APU_NOISE_VOL
    LDA a:AudioEffectWork0
    STA a:APU_NOISE_LO
    LDA #$08
    STA a:APU_NOISE_HI

Bank3_Label_9939:
    RTS

AudioEffect_UpdateNoiseSweepFast:
    LDX a:AudioEffectWork1
    BEQ Bank3_Label_9921
    DEX
    BEQ Bank3_Label_9945
    JMP AudioEffect_UpdateTimedStop

Bank3_Label_9945:
    DEC a:AudioEffectWork0
    LDA a:AudioEffectWork0
    STA a:APU_NOISE_LO
    CMP #$08
    BNE Bank3_Label_9939
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

AudioEffect_InitTriangleNoiseBurst:
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

AudioEffect_InitPulse2PitchSequenceLong:
    LDY #$60
    LDA #$17
    LDX #$00
    BEQ Bank3_Label_999A

AudioEffect_InitPulse2PitchSequenceShort:
    LDY #$08
    LDA #$01
    LDX #$05

Bank3_Label_999A:
    STY a:AudioEffectTimers+$01
    STA a:AudioEffectWork0
    STX a:AudioEffectWork2
    LDA #$01
    STA a:AudioEffectWork1
    JSR AudioEffect_InitNoiseOnset
    JMP AudioEffect_UpdatePulse2PitchSequence

AudioEffect_InitNoiseOnset:
    LDA #$08
    STA a:AudioEffectTimers+$03
    LDA #$01
    STA a:APU_NOISE_VOL
    LDA #$0A
    STA a:APU_NOISE_LO
    LDA #$08
    STA a:APU_NOISE_HI

Bank3_Label_99C2:
    RTS

AudioEffect_InitPulse1AlternatingBurst:
    LDA #$48
    STA a:AudioEffectTimers
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectTimers+$03
    LDA #$01
    STA a:AudioEffectWork0
    LDA #$04
    STA a:AudioEffectWork1

AudioEffect_UpdatePulse1AlternatingBurst:
    LDA a:AudioEffectWork1
    BNE Bank3_Label_99E3
    JMP AudioEffect_UpdateTimedStop

Bank3_Label_99E3:
    DEC a:AudioEffectWork0
    BNE Bank3_Label_99C2
    DEC a:AudioEffectWork1
    BEQ Bank3_Label_9A07
    LDA #$04
    STA a:AudioEffectWork0
    LDA a:AudioEffectWork1
    LSR A
    BCC Bank3_Label_9A03
    LDA #$82
    LDX #$00
    JSR Apu_WritePulse1ControlSweep
    LDX #$69
    BNE Bank3_Label_9A15

Bank3_Label_9A03:
    LDA #$82
    BNE Bank3_Label_9A0E

Bank3_Label_9A07:
    LDA #$3C
    STA a:AudioEffectWork0
    LDA #$8F

Bank3_Label_9A0E:
    LDX #$00
    JSR Apu_WritePulse1ControlSweep
    LDX #$8D

Bank3_Label_9A15:
    LDA #$08
    JMP Apu_WritePulse1Timer

AudioEffect_InitPulse1Sequence:
    LDA #$4A
    STA $2D
    LDA #$9E
    STA $2E
    LDA #$01
    STA a:AudioEffectWork0
    STA a:AudioEffectRetriggerLock
    LDA #$09
    STA a:AudioEffectWork1
    LDA #$83
    STA a:AudioEffectWork2

AudioEffect_UpdatePulse1Sequence:
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
    BEQ AudioEffect_AdvanceSequencePointer
    ASL A
    TAY
    LDA a:Bank3_Label_A30F,Y
    STA a:APU_PL1_LO,X
    LDA a:Bank3_Label_A30F+1,Y
    ORA #$08
    STA a:APU_PL1_HI,X

AudioEffect_AdvanceSequencePointer:
    INC $2D
    BNE Bank3_Label_9A6A
    INC $2E

Bank3_Label_9A6A:
    RTS

AudioEffect_GateSequenceStep:
    DEC a:AudioEffectWork0
    BNE Bank3_Label_9A81
    LDA a:AudioEffectWork1
    STA a:AudioEffectWork0
    LDY #$00
    LDA ($2D),Y
    CMP #$FF
    BNE Bank3_Label_9A83
    JSR Audio_StopCurrentEffect

Bank3_Label_9A81:
    PLA
    PLA

Bank3_Label_9A83:
    RTS

AudioEffect_InitPulse1FixedTone:
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

AudioEffect_InitPulse2FixedToneA:
    LDA #$0A
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectWork0
    LDA #$42
    LDX #$00
    JSR Apu_WritePulse2ControlSweep
    LDX #$BB
    LDA #$08
    JMP Apu_WritePulse2Timer

AudioEffect_InitPulse1ToneWithTriangleLease:
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

AudioEffect_InitNoisePeriodRamp:
    LDA #$10
    STA a:AudioEffectTimers+$03
    STA a:AudioEffectWork1
    LDA #$0C
    STA a:AudioEffectWork0
    LDA #$04
    STA a:APU_NOISE_VOL
    LDA #$08
    STA a:APU_NOISE_HI

AudioEffect_UpdateNoisePeriodRamp:
    LDA a:AudioEffectWork0
    STA a:APU_NOISE_LO
    LDA a:AudioEffectWork0
    CMP #$0F
    BEQ Bank3_Label_9AF2
    INC a:AudioEffectWork0

Bank3_Label_9AF2:
    DEC a:AudioEffectWork1
    BNE Bank3_Label_9AFA

Bank3_Label_9AF7:
    JMP Audio_StopCurrentEffect

Bank3_Label_9AFA:
    RTS

AudioEffect_InitIndexedTonalSequenceAlt:
    LDA #$53
    STA $2D
    LDA #$9E
    STA $2E
    LDA #$01
    STA a:AudioEffectWork0

AudioEffect_UpdateIndexedTonalSequenceAlt:
    DEC a:AudioEffectWork0
    BNE Bank3_Label_9AFA
    LDY #$00
    LDA ($2D),Y
    CMP #$FF
    BEQ Bank3_Label_9AF7
    STA a:AudioEffectWork0
    STA a:AudioEffectTimers
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectTimers+$03
    JSR AudioEffect_AdvanceSequencePointer
    LDX #$00
    JSR AudioEffect_WriteIndexedTonalEvent
    JSR AudioEffect_WriteIndexedTonalEvent

AudioEffect_WriteIndexedTonalEvent:
    LDY #$00
    LDA ($2D),Y
    BEQ Bank3_Label_9B5A
    ASL A
    TAY
    LDA a:AudioEffectWork0
    CPX #$08
    BEQ Bank3_Label_9B43
    LSR A
    ORA #$C0
    BNE Bank3_Label_9B44

Bank3_Label_9B43:
    ASL A

Bank3_Label_9B44:
    STA a:APU_PL1_VOL,X
    LDA #$00
    STA a:APU_PL1_SWEEP,X
    LDA a:Bank3_Label_A30F,Y
    STA a:APU_PL1_LO,X
    LDA a:Bank3_Label_A30F+1,Y
    ORA #$08
    STA a:APU_PL1_HI,X

Bank3_Label_9B5A:
    INX
    INX
    INX
    INX
    JMP AudioEffect_AdvanceSequencePointer

AudioEffect_InitPulse2FixedToneB:
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

AudioEffect_InitPulse2FixedToneC:
    LDA #$08
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectWork0
    LDA #$C0
    LDX #$83
    JSR Apu_WritePulse2ControlSweep
    LDX #$60
    LDA #$08
    JMP Apu_WritePulse2Timer

AudioEffect_InitNoiseVolumeSweep:
    LDA #$18
    STA a:AudioEffectTimers+$03
    LDA #$04
    STA a:APU_NOISE_LO
    LDA #$0F
    STA a:AudioEffectWork0
    LDA #$00
    STA a:AudioEffectWork1

AudioEffect_UpdateNoiseVolumeSweep:
    LDA a:AudioEffectWork0
    CMP #$10
    BEQ Bank3_Label_9BD2
    ORA #$10
    STA a:APU_NOISE_VOL
    LDA #$28
    STA a:APU_NOISE_HI
    LDA a:AudioEffectWork1
    BEQ Bank3_Label_9BC0
    INC a:AudioEffectWork0
    RTS

Bank3_Label_9BC0:
    LDA a:AudioEffectWork0
    CMP #$02
    BCC Bank3_Label_9BCE
    DEC a:AudioEffectWork0
    DEC a:AudioEffectWork0
    RTS

Bank3_Label_9BCE:
    INC a:AudioEffectWork1
    RTS

Bank3_Label_9BD2:
    LDA #$10
    STA a:APU_NOISE_VOL
    JMP Audio_StopCurrentEffect

AudioEffect_InitPulse2ThreeStep:
    LDA #$03
    STA a:AudioEffectWork1
    LDA #$FF
    STA a:AudioEffectTimers+$01
    LDA #$00
    STA a:AudioEffectWork0

AudioEffect_UpdatePulse2ThreeStep:
    LDA a:AudioEffectWork0
    BNE Bank3_Label_9C15
    LDA a:AudioEffectWork1
    BNE Bank3_Label_9BFB
    LDA #$00
    STA a:AudioEffectTimers+$01
    JMP Audio_StopCurrentEffect

Bank3_Label_9BFB:
    DEC a:AudioEffectWork1
    LDA #$84
    LDX #$8B
    JSR Apu_WritePulse2ControlSweep
    LDY a:AudioEffectWork1
    LDX a:Bank3_Label_9C19,Y
    LDA #$10
    JSR Apu_WritePulse2Timer
    LDA #$04
    STA a:AudioEffectWork0

Bank3_Label_9C15:
    DEC a:AudioEffectWork0
    RTS
Bank3_Label_9C19:
    .byte $65, $87, $B4, $F0
