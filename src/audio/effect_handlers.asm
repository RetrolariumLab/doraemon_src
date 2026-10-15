; Doraemon PRG bank 3 $9C1D-$9ED7
; Remaining audio-effect handlers and APU write helpers
; Generated deterministically from pinned Ghidra/GhidraNes facts

AudioEffect_InitPulse2PitchSequenceBase:
    LDY #$14
    LDA #$04
    LDX #$03

Bank3_Label_9C23:
    STY a:AudioEffectTimers+$01
    STA a:AudioEffectWork0
    STX a:AudioEffectWork2
    LDA #$01
    STA a:AudioEffectWork1

AudioEffect_UpdatePulse2PitchSequence:
    DEC a:AudioEffectWork1
    BNE Bank3_Label_9C5C
    LDA a:AudioEffectWork0
    BMI Bank3_Label_9C5D
    CLC
    ADC a:AudioEffectWork2
    ASL A
    TAY
    LDA #$DF
    LDX #$8C
    JSR Apu_WritePulse2ControlSweep
    LDA a:Bank3_Label_9C60,Y
    TAX
    LDA a:Bank3_Label_9C60+1,Y
    ORA #$88
    JSR Apu_WritePulse2Timer
    DEC a:AudioEffectWork0
    LDA #$04
    STA a:AudioEffectWork1

Bank3_Label_9C5C:
    RTS

Bank3_Label_9C5D:
    JMP Audio_StopCurrentEffect
Bank3_Label_9C60:
    .byte $00, $06, $00, $03, $00, $02, $40, $01, $C0, $00, $80, $00, $60, $00, $50, $00
    .byte $2B, $03, $35, $00, $2C, $03, $33, $06, $2B, $03, $35, $00, $2C, $03, $33, $06
    .byte $2B, $03, $35, $00, $2C, $03, $33, $06, $2B, $03, $35, $00, $2C, $03, $33, $06
    .byte $69, $00, $70, $00, $76, $00, $7E, $00, $85, $00, $8D, $00, $96, $00, $9F, $00
    .byte $A8, $00, $B2, $00, $BD, $00, $C8, $00, $D4, $00

AudioEffect_InitTrianglePitchDescent:
    LDA #$10
    STA a:AudioEffectTimers+$02
    LDA #$40
    STA a:AudioEffectWork0
    LDA #$01
    STA a:AudioEffectWork1
    LDA #$30
    STA a:AudioEffectWork2

AudioEffect_UpdateTrianglePitchDescent:
    LDY #$01
    LDX a:AudioEffectWork0
    LDA #$08
    JSR Apu_WriteTriangleControlTimer
    LDA a:AudioEffectWork0
    SEC
    SBC a:AudioEffectWork1
    STA a:AudioEffectWork0
    CMP a:AudioEffectWork2
    BNE Bank3_Label_9CDA
    JMP Audio_StopCurrentEffect

Bank3_Label_9CDA:
    RTS

AudioEffect_InitPulse2TwoTone:
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

AudioEffect_UpdatePulse2TwoTone:
    DEC a:AudioEffectWork0
    BNE Bank3_Label_9D1B
    LDA a:AudioEffectWork1
    BEQ Bank3_Label_9D18
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

Bank3_Label_9D18:
    JMP Audio_StopCurrentEffect

Bank3_Label_9D1B:
    RTS

AudioEffect_InitPulse2PitchSequenceWide:
    LDY #$34
    LDA #$0C
    LDX #$18
    JMP Bank3_Label_9C23

AudioEffect_InitPulse2VolumeFade:
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

AudioEffect_UpdatePulse2VolumeFade:
    DEC a:AudioEffectWork1
    BNE Bank3_Label_9D5D
    LDA #$04
    STA a:AudioEffectWork1
    LDY a:AudioEffectWork0
    LDA a:Bank3_Label_9D5E,Y
    STA a:APU_PL2_VOL
    DEC a:AudioEffectWork0
    BPL Bank3_Label_9D5D
    JMP Audio_StopCurrentEffect

Bank3_Label_9D5D:
    RTS
Bank3_Label_9D5E:
    .byte $00

AudioEffect_InitPulse1Alternator:
    LDA #$00

Bank3_Label_9D61:
    STA a:AudioEffectWork0
    LDA #$01
    STA a:AudioEffectWork1

AudioEffect_UpdatePulse1Alternator:
    DEC a:AudioEffectWork1
    BNE Bank3_Label_9D8E
    LDA a:AudioEffectWork0
    EOR #$04
    STA a:AudioEffectWork0
    TAY
    LDA a:Bank3_Label_9E0E+1,Y
    STA a:AudioEffectWork1
    LDA #$DF
    LDX a:Bank3_Label_9E0C,Y
    JSR Apu_WritePulse1ControlSweep
    LDX a:Bank3_Label_9E0C+1,Y
    LDA a:Bank3_Label_9E0E,Y
    JMP Apu_WritePulse1Timer

Bank3_Label_9D8E:
    RTS

AudioEffect_InitPulse1NoiseRise:
    LDA #$00
    STA a:AudioEffectWork2
    LDA #$08
    JMP Bank3_Label_9D61

AudioEffect_UpdatePulse1NoiseRise:
    JSR AudioEffect_UpdatePulse1Alternator

AudioEffect_UpdateNoiseRise:
    LDA #$00
    STA a:APU_NOISE_VOL
    LDA a:AudioEffectWork2
    AND #$03
    BEQ Bank3_Label_9DB6
    LDA a:AudioEffectWork2
    LSR A
    LSR A
    LSR A
    STA a:APU_NOISE_LO
    LDA #$08
    STA a:APU_NOISE_HI

Bank3_Label_9DB6:
    INC a:AudioEffectWork2
    LDA a:AudioEffectWork2
    BPL Bank3_Label_9DC3
    LDA #$7F
    STA a:AudioEffectWork2

Bank3_Label_9DC3:
    RTS

AudioEffect_InitPulse1NoiseDecay:
    LDA #$0F
    STA a:AudioEffectWork2
    LDA #$10
    JMP Bank3_Label_9D61

AudioEffect_UpdatePulse1NoiseDecay:
    JSR AudioEffect_UpdatePulse1Alternator
    LDA a:AudioEffectWork2
    LSR A
    BCS Bank3_Label_9DEB
    LDA #$00
    STA a:APU_NOISE_VOL
    LDA a:AudioEffectWork2
    LSR A
    LSR A
    LSR A
    LSR A
    STA a:APU_NOISE_LO
    LDA #$18
    STA a:APU_NOISE_HI

Bank3_Label_9DEB:
    DEC a:AudioEffectWork2
    RTS

AudioEffect_InitPulsePairNoiseTail:
    LDA #$1F
    LDX #$AB
    JSR Apu_WritePulse1ControlSweep
    LDA #$98
    LDA #$9B
    JSR Apu_WritePulse2ControlSweep
    LDX #$00
    STX a:AudioEffectWork0
    LDA #$0C
    JSR Apu_WritePulse1Timer
    LDA #$0A
    JMP Apu_WritePulse2Timer
Bank3_Label_9E0C:
    .byte $8F, $80
Bank3_Label_9E0E:
    .byte $FC, $08, $87, $00, $FC, $08, $8D, $80, $FC, $06, $85, $00, $FB, $06
    .byte $8B, $80, $FC, $04, $83, $00, $FA, $04

Apu_WritePulse1ControlSweep:
    STA a:APU_PL1_VOL
    STX a:APU_PL1_SWEEP
    RTS

Apu_WritePulse2ControlSweep:
    STA a:APU_PL2_VOL
    STX a:APU_PL2_SWEEP
    RTS

Apu_WritePulse1Timer:
    STX a:APU_PL1_LO
    STA a:APU_PL1_HI
    RTS

Apu_WritePulse2Timer:
    STX a:APU_PL2_LO
    STA a:APU_PL2_HI
    RTS

Apu_WriteTriangleControlTimer:
    STY a:APU_TRI_LINEAR
    STX a:APU_TRI_LO
    STA a:APU_TRI_HI
    RTS
    .byte $2C, $31, $2C, $31, $35, $38, $3D, $41, $FF, $08, $2E, $2B, $27, $08, $30, $2C
    .byte $29, $08, $32, $2D, $2A, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E
    .byte $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E
    .byte $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E
    .byte $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E
    .byte $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $FF

Bank3_Label_9EA4:
    BMI Bank3_Label_9EC9
    ORA #$80
    STA a:AudioMusicControl

Audio_ResetChannels:
    LDA #$10
    STA a:APU_PL1_VOL
    STA a:APU_PL2_VOL
    STA a:APU_NOISE_VOL
    LDA #$00
    STA a:APU_TRI_LINEAR
    LDA #$18
    STA a:APU_PL1_HI
    STA a:APU_PL2_HI
    STA a:APU_TRI_HI
    STA a:APU_NOISE_HI

Bank3_Label_9EC9:
    LDX #$00
    JSR Music_UpdateVolumeEnvelope
    INX
    JSR Music_UpdateVolumeEnvelope
    INX
    INX
    JMP Music_UpdateVolumeEnvelope
    .byte $60
