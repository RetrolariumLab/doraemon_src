; Effect requests and init/update pairs shared by World 1 and World 3

    SfxCoreEntry AudioEffect_RequestPriority
    .byte $00, $54, $64, $4C, $40, $44, $04, $38, $34, $3C, $1C, $50, $58, $60, $2C, $28
    .byte $08, $48, $30, $20, $24, $18, $14, $10, $0C, $5C

    SfxCoreEntry AudioEffect_RtsDispatchTable
    .addr Audio_ResetEffects - 1, AudioEffect_NoOp - 1
    .addr Sfx_InitPulse1AlternatingBurst - 1, Sfx_UpdatePulse1AlternatingBurst - 1
    .addr AudioEffect_InitPulse1Sequence - 1, AudioEffect_UpdatePulse1Sequence - 1
    .addr AudioEffect_InitPulse1Alternator - 1, Sfx_UpdatePulse1Alternator - 1
    .addr AudioEffect_InitPulse1Alternator - 1, Sfx_UpdatePulse1Alternator - 1
    .addr AudioEffect_InitPulse1Alternator - 1, Sfx_UpdatePulse1Alternator - 1
    .addr AudioEffect_InitPulse1Alternator - 1, Sfx_UpdatePulse1Alternator - 1
    .addr Sfx_InitIndexedTonalSequenceAlt - 1, Sfx_UpdateIndexedTonalSequenceAlt - 1
    .addr Sfx_InitPulse2PitchSequenceWide - 1, Sfx_UpdatePulse2PitchSequence - 1
    .addr AudioEffect_InitPulse2VolumeFade - 1, Sfx_UpdatePulse2VolumeFade - 1
    .addr Sfx_InitPulse2PitchSequenceBase - 1, Sfx_UpdatePulse2PitchSequence - 1
    .addr AudioEffect_InitPulse2ThreeStep - 1, AudioEffect_UpdatePulse2ThreeStep - 1
    .addr AudioEffect_InitPulse2TwoTone - 1, AudioEffect_UpdatePulse2TwoTone - 1
    .addr Sfx_InitPulse1ToneWithTriLease - 1, AudioEffect_UpdateTimedStop - 1
    .addr AudioEffect_InitPulse1FixedTone - 1, AudioEffect_UpdateTimedStop - 1
    .addr AudioEffect_InitNoisePeriodRamp - 1, AudioEffect_UpdateNoisePeriodRamp - 1
    .addr Sfx_InitPulse2PitchSequenceLong - 1, Sfx_UpdatePulse2PitchSequence - 1
    .addr Sfx_InitPulse2PitchSequenceShort - 1, Sfx_UpdatePulse2PitchSequence - 1
    .addr Sfx_InitTrianglePitchDescent - 1, Sfx_UpdateTrianglePitchDescent - 1
    .addr AudioEffect_InitPulse2FixedToneA - 1, AudioEffect_UpdateTimedStop - 1
    .addr AudioEffect_InitPulse2FixedToneB - 1, AudioEffect_UpdateTimedStop - 1
    .addr AudioEffect_InitPulse2FixedToneC - 1, AudioEffect_UpdateTimedStop - 1
    .addr AudioEffect_InitNoiseSweep - 1, AudioEffect_UpdateNoiseSweepSlow - 1
    .addr AudioEffect_InitNoiseSweep - 1, AudioEffect_UpdateNoiseSweepFast - 1
    .addr AudioEffect_InitNoiseVolumeSweep - 1, Sfx_UpdateNoiseVolumeSweep - 1
    .addr Sfx_InitTriangleNoiseBurst - 1, Audio_StopCurrentEffect - 1
