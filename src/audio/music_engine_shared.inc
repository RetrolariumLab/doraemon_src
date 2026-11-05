; Four-channel music sequencer and stream interpreter, emitted once per PRG bank
; Local labels use offsets from Audio_UpdateMusic

    MusicEntry Audio_UpdateMusic
    LDA a:AudioMusicControl
    BNE ApplyMusicControl
    LDA a:AudioMusicState
    BEQ RefreshIdleEnvelopes
    BPL Local_00F
    JMP Local_093

    MusicLocal Local_00F
    LDA a:AudioMusicState
    CMP #TrackIdLimit
    BCC Local_019
    JMP Local_0BD

    MusicLocal Local_019
    ORA #$80
    STA a:AudioMusicState
    ASL A
    ASL A
    ASL A
    TAY
    LDX #$07

    MusicLocal Local_024
    LDA a:TrackHeaderIndexBase,Y
    STA AudioStreamPointers,X
    STA a:AudioSavedStreamPointers,X
    DEY
    DEX
    BPL Local_024
    STX a:AudioChannelBaseVolumes
    STX a:AudioChannelBaseVolumes+$01
    STX a:AudioChannelBaseVolumes+$02
    STX a:AudioChannelBaseVolumes+$03
    INX
    STX GlobalPitchOffsets
    STX GlobalPitchOffsets+1
    STX GlobalPitchOffsets+2
    STX a:AudioChannelPitchOffsets
    STX a:AudioChannelPitchOffsets+$01
    STX a:AudioChannelPitchOffsets+$02
    STX a:AudioChannelFixedPitchFlags
    STX a:AudioChannelFixedPitchFlags+$01
    STX a:AudioChannelFixedPitchFlags+$02
    STX a:AudioChannelFixedPitchFlags+$03
    STX a:AudioNoiseDuration
    STX a:AudioNoiseControl
    INX
    STX a:AudioChannelDurations
    STX a:AudioChannelDurations+$01
    STX a:AudioChannelDurations+$02
    STX a:AudioChannelDurations+$03
    STX a:AudioChannelDurationCodes
    STX a:AudioChannelDurationCodes+$01
    STX a:AudioChannelDurationCodes+$02
    STX a:AudioChannelDurationCodes+$03
    LDA #$08
    STA a:AudioChannelLengthBits
    STA a:AudioChannelLengthBits+$01
    STA a:AudioChannelLengthBits+$02
    STA a:AudioChannelLengthBits+$03
    LDA #$80
    STA a:AudioChannelControl
    STA a:AudioChannelControl+$01
    STA a:AudioChannelControl+$02
    JSR ResetApuChannels

    MusicLocal Local_093
    LDA #$00
    STA a:AudioEndedChannelCount
    STA a:AudioChannelIndex

    MusicLocal Local_09B
    LDX a:AudioChannelIndex
    DEC a:AudioChannelDurations,X
    BEQ Local_0A9
    JSR Music_UpdateVolumeEnvelope
    JMP Local_0AC

    MusicLocal Local_0A9
    JSR Music_UpdateChannelStream

    MusicLocal Local_0AC
    INC a:AudioChannelIndex
    LDA a:AudioChannelIndex
    CMP #$04
    BCC Local_09B
    LDA a:AudioEndedChannelCount
    CMP #$04
    BNE Local_0C2

    MusicLocal Local_0BD
    LDA #$00
    STA a:AudioMusicState

    MusicLocal Local_0C2
    RTS

    MusicEntry Music_UpdateVolumeEnvelope
    CPX #$02
    BEQ Local_10E
    LDA a:AudioChannelControl,X
    AND #$10
    BEQ Local_10E
    LDA a:AudioChannelEnvelopeSteps,X
    ASL A
    STA a:AudioWorkByte
    BCC Local_0E2
    LDA a:AudioChannelEnvelopeVolumes,X
    SEC
    SBC a:AudioWorkByte
    BCS Local_0ED
    BCC Local_0EB

    MusicLocal Local_0E2
    LDA a:AudioChannelEnvelopeVolumes,X
    CLC
    ADC a:AudioWorkByte
    BCC Local_0ED

    MusicLocal Local_0EB
    LDA #$00

    MusicLocal Local_0ED
    STA a:AudioChannelEnvelopeVolumes,X
    LDY a:AudioEffectTimers,X
    BNE Local_10E
    LSR A
    LSR A
    LSR A
    LSR A
    STA a:AudioWorkByte
    TXA
    ASL A
    ASL A
    TAY
    LDA a:AudioChannelControl,X
    AND #$D0
    ORA a:AudioWorkByte
    STA a:AudioChannelControl,X
    STA a:APU_PL1_VOL,Y

    MusicLocal Local_10E
    RTS

    MusicEntry Music_UpdateChannelStream
    LDX a:AudioChannelIndex
    CPX #$03
    BNE Local_11E
    LDA a:AudioNoiseDuration
    BEQ Local_11E
    JMP Local_224

    MusicLocal Local_11E
    JSR Audio_ReadStreamByte
    STA a:AudioWorkByte
    TAY
    BMI Local_12A
    JMP Music_HandleNoteOrRest

    MusicLocal Local_12A
    CMP #$EF
    BCC Local_161
    SEC
    LDA #$FF
    SBC a:AudioWorkByte
    ASL A
    TAY
    LDA a:MusicCommand_RtsDispatchTable+1,Y
    PHA
    LDA a:MusicCommand_RtsDispatchTable,Y
    PHA
    RTS

    MusicEntry MusicCommand_RtsDispatchTable
    .addr MusicCommand_EndChannel - 1  ; $FF
    .addr MusicCommand_RestoreStreamPosition - 1  ; $FE
    .addr MusicCommand_BeginCountedLoop - 1  ; $FD
    .addr MusicCommand_RepeatCountedLoop - 1  ; $FC
    .addr MusicCommand_SelectLoopExit - 1  ; $FB
    .addr MusicCommand_EnableFixedPitch - 1  ; $FA
    .addr MusicCommand_DisableFixedPitch - 1  ; $F9
    .addr MusicCommand_SetDutyCycle - 1  ; $F8
    .addr MusicCommand_SaveStreamPosition - 1  ; $F7
    .addr MusicCommand_CallStream - 1  ; $F6
    .addr MusicCommand_SetGlobalPitchOffset - 1  ; $F5
    .addr MusicCommand_SetChannelPitchOffset - 1  ; $F4
    .addr MusicCommand_ReturnFromStream - 1  ; $F3
    .addr MusicCommand_ResetLengthBits - 1  ; $F2
    .addr MusicCommand_SelectTrackChannelStream - 1  ; $F1
    .addr MusicCommand_LoadExtendedDuration - 1  ; $F0
    .addr MusicCommand_SetEnvelopeVolume - 1  ; $EF

    MusicLocal Local_161
    LDA a:AudioWorkByte
    AND #$7F
    BPL Local_16B

    MusicEntry MusicCommand_LoadExtendedDuration
    JSR Audio_ReadStreamByte

    MusicLocal Local_16B
    LDX a:AudioChannelIndex
    STA a:AudioChannelDurationCodes,X
    LDA a:AudioChannelFixedPitchFlags,X
    BNE Local_1F2

    MusicLocal Local_176
    LDX a:AudioChannelIndex
    LDA a:AudioChannelDurationCodes,X

    MusicLocal Local_17C
    STA a:AudioWorkByte
    LDX a:AudioChannelIndex
    CPX #$02
    BEQ Local_1F5
    LDA a:AudioChannelControl,X
    AND #$10
    BNE Local_1A8
    LDA a:AudioChannelControl,X
    AND #$D0
    STA a:AudioChannelControl,X
    LDA a:AudioWorkByte
    LSR A
    CMP #$10
    BCC Local_19F
    LDA #$0F

    MusicLocal Local_19F
    ORA a:AudioChannelControl,X
    STA a:AudioChannelControl,X
    JMP Local_1B3

    MusicLocal Local_1A8
    LDY a:AudioWorkByte
    LDA a:EnvelopeStepTable,Y
    ORA #$80
    STA a:AudioChannelEnvelopeSteps,X

    MusicLocal Local_1B3
    LDA a:AudioWorkByte
    PHA
    LSR A
    LSR A
    LSR A
    STA a:AudioWorkByte
    PLA
    SEC
    SBC a:AudioWorkByte
    CMP #$10
    BCS Local_1E1
    ASL A
    ASL A
    ASL A
    ASL A
    ORA #$08
    STA a:AudioChannelLengthBits,X
    LDA a:AudioChannelControl,X
    AND #$10
    BEQ Local_1F2
    LDA a:AudioChannelLengthBits,X
    CMP #$08
    BNE Local_1F2
    LDA #$18
    BNE Local_1EF

    MusicLocal Local_1E1
    LDY #$00

    MusicLocal Local_1E3
    CMP a:LengthBitsTable,Y
    BCS Local_1EC
    INY
    INY
    BNE Local_1E3

    MusicLocal Local_1EC
    LDA a:LengthBitsTable+1,Y

    MusicLocal Local_1EF
    STA a:AudioChannelLengthBits,X

    MusicLocal Local_1F2
    JMP Music_UpdateChannelStream

    MusicLocal Local_1F5
    LDA a:AudioWorkByte
    ASL A
    BMI Local_200
    ADC a:AudioWorkByte
    BPL Local_202

    MusicLocal Local_200
    LDA #$7F

    MusicLocal Local_202
    STA a:AudioChannelControl+$02
    JMP Local_1F2

    MusicEntry Music_HandleNoteOrRest
    CMP #$00
    BNE Local_20F
    JMP Local_297

    MusicLocal Local_20F
    LDX a:AudioChannelIndex
    CPX #$03
    BNE Local_253
    PHA
    AND #$0F
    STA a:AudioNoiseDuration
    PLA
    LSR A
    LSR A
    LSR A
    LSR A
    STA a:AudioNoisePeriodIndex

    MusicLocal Local_224
    DEC a:AudioNoiseDuration
    LDA a:AudioEffectTimers+$03
    BNE Local_297
    LDA a:AudioNoisePeriodIndex
    BEQ Local_297
    ASL A
    ASL A
    TAX
    LDY #$00

    MusicLocal Local_236
    LDA a:NoiseRegisterTable,X
    STA a:APU_NOISE_VOL,Y
    INX
    INY
    CPY #$04
    BCC Local_236
    LDA a:AudioNoiseControl
    AND #$10
    BEQ Local_289
    LDA a:AudioNoiseControl
    AND #$1F
    STA a:APU_NOISE_VOL
    BPL Local_289

    MusicLocal Local_253
    LDY a:AudioEffectTimers,X
    BNE Local_297
    TXA
    ASL A
    ASL A
    TAY
    LDA a:AudioChannelControl,X
    STA a:APU_PL1_VOL,Y
    LDA #$00
    STA a:APU_PL1_SWEEP,Y
    LDA a:AudioWorkByte
    CLC
    ADC a:FixedPitchOffsets,X
    CLC
    ADC GlobalPitchOffsets,X
    CLC
    ADC a:AudioChannelPitchOffsets,X
    ASL A
    TAX
    LDA a:PitchPeriodTable,X
    STA a:APU_PL1_LO,Y
    LDA a:PitchPeriodTable+1,X
    LDX a:AudioChannelIndex
    ORA a:AudioChannelLengthBits,X
    STA a:APU_PL1_HI,Y

    MusicLocal Local_289
    LDX a:AudioChannelIndex
    LDA a:AudioChannelFixedPitchFlags,X
    BNE Local_297
    LDA a:AudioChannelBaseVolumes,X
    STA a:AudioChannelEnvelopeVolumes,X

    MusicLocal Local_297
    LDX a:AudioChannelIndex
    LDA a:AudioChannelDurationCodes,X
    STA a:AudioChannelDurations,X
    RTS

    MusicEntry MusicCommand_EndChannel
    LDX a:AudioChannelIndex
    LDA #$01
    STA a:AudioChannelDurations,X
    TXA
    ASL A
    TAX
    LDA AudioStreamPointers,X
    BNE Local_2B2
    DEC AudioStreamPointers+$01,X

    MusicLocal Local_2B2
    DEC AudioStreamPointers,X
    INC a:AudioEndedChannelCount
    RTS

    MusicEntry MusicCommand_BeginCountedLoop
    JSR Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    STA a:AudioLoopRepeatLimits,X
    LDA #$01
    STA a:AudioLoopIterationCounts,X
    TXA
    ASL A
    TAX
    LDA AudioStreamPointers,X
    STA a:AudioLoopStartPointers,X
    LDA AudioStreamPointers+$01,X
    STA a:AudioLoopStartPointers+$01,X
    JMP Music_UpdateChannelStream

    MusicEntry MusicCommand_SelectLoopExit
    JSR Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    CMP a:AudioLoopIterationCounts,X
    BCS Local_2EE
    TXA
    ASL A
    TAX
    LDA a:AudioLoopExitPointers,X
    STA AudioStreamPointers,X
    LDA a:AudioLoopExitPointers+$01,X
    STA AudioStreamPointers+$01,X

    MusicLocal Local_2EE
    JMP Music_UpdateChannelStream

    MusicEntry MusicCommand_RepeatCountedLoop
    LDX a:AudioChannelIndex
    LDA a:AudioLoopIterationCounts,X
    CMP a:AudioLoopRepeatLimits,X
    BCS Local_316
    INC a:AudioLoopIterationCounts,X
    TXA
    ASL A
    TAX
    LDA AudioStreamPointers,X
    STA a:AudioLoopExitPointers,X
    LDA AudioStreamPointers+$01,X
    STA a:AudioLoopExitPointers+$01,X
    LDA a:AudioLoopStartPointers,X
    STA AudioStreamPointers,X
    LDA a:AudioLoopStartPointers+$01,X
    STA AudioStreamPointers+$01,X

    MusicLocal Local_316
    JMP Music_UpdateChannelStream

    MusicEntry MusicCommand_EnableFixedPitch
    JSR Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    STA a:AudioChannelFixedPitches,X
    LDA a:AudioChannelBaseVolumes,X
    STA a:AudioChannelEnvelopeVolumes,X
    LDA #$FF
    STA a:AudioChannelFixedPitchFlags,X
    BNE Local_361

    MusicEntry MusicCommand_DisableFixedPitch
    LDX a:AudioChannelIndex
    LDA #$00
    STA a:AudioChannelFixedPitchFlags,X
    LDA a:AudioChannelControl,X
    AND #$CF
    STA a:AudioChannelControl,X

    MusicLocal Local_33F
    JMP Local_176

    MusicEntry MusicCommand_SetDutyCycle
    JSR Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    CPX #$02
    BEQ Local_2EE
    AND #$C0
    STA a:AudioWorkByte
    LDA a:AudioChannelControl,X
    AND #$10
    ORA a:AudioWorkByte
    STA a:AudioChannelControl,X
    LDA a:AudioChannelFixedPitchFlags,X
    BEQ Local_33F

    MusicLocal Local_361
    LDA a:AudioChannelFixedPitches,X
    JMP Local_17C

    MusicEntry MusicCommand_SaveStreamPosition
    JSR Music_SaveStreamPosition
    JMP Music_UpdateChannelStream

    MusicEntry Music_SaveStreamPosition
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA AudioStreamPointers,X
    STA a:AudioSavedStreamPointers,X
    LDA AudioStreamPointers+$01,X
    STA a:AudioSavedStreamPointers+$01,X
    RTS

    MusicEntry MusicCommand_RestoreStreamPosition, RestoreStreamPosition
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA a:AudioSavedStreamPointers,X
    STA AudioStreamPointers,X
    LDA a:AudioSavedStreamPointers+$01,X
    STA AudioStreamPointers+$01,X
    JMP Music_UpdateChannelStream

    MusicEntry MusicCommand_SelectTrackChannelStream, SelectTrackChannelStream
    LDA a:AudioMusicState
    ASL A
    ASL A
    SEC
    SBC #$04
    CLC
    ADC a:AudioChannelIndex
    ASL A
    TAY
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA a:TrackHeaders,Y
    STA AudioStreamPointers,X
    LDA a:TrackHeaders+1,Y
    STA AudioStreamPointers+$01,X
    JMP Music_UpdateChannelStream

    MusicEntry MusicCommand_CallStream
    JSR Audio_ReadStreamByte
    PHA
    JSR Audio_ReadStreamByte
    PHA
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA AudioStreamPointers,X
    STA a:AudioStreamCallReturnPointers,X
    LDA AudioStreamPointers+$01,X
    STA a:AudioStreamCallReturnPointers+$01,X
    PLA
    STA AudioStreamPointers+$01,X
    PLA
    STA AudioStreamPointers,X
    JMP Music_UpdateChannelStream

    MusicEntry MusicCommand_ReturnFromStream
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA a:AudioStreamCallReturnPointers,X
    STA AudioStreamPointers,X
    LDA a:AudioStreamCallReturnPointers+$01,X
    STA AudioStreamPointers+$01,X
    JMP Music_UpdateChannelStream

    MusicEntry MusicCommand_SetChannelPitchOffset, SetChannelPitchOffset
    JSR Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    CPX #$03
    BEQ Local_3EE
    STA a:AudioChannelPitchOffsets,X

    MusicLocal Local_3EE
    JMP Music_UpdateChannelStream

    MusicEntry MusicCommand_SetGlobalPitchOffset
    JSR Audio_ReadStreamByte
    LDX #$02

    MusicLocal Local_3F6
    STA GlobalPitchOffsets,X
    DEX
    BPL Local_3F6
    JMP Music_UpdateChannelStream

    MusicEntry MusicCommand_ResetLengthBits
    LDX a:AudioChannelIndex
    LDA #$08
    JMP Local_1EF

    MusicEntry MusicCommand_SetEnvelopeVolume
    JSR Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    STA a:AudioChannelBaseVolumes,X
    STA a:AudioChannelEnvelopeVolumes,X
    LSR A
    LSR A
    LSR A
    LSR A
    STA a:AudioWorkByte
    LDA a:AudioChannelControl,X
    AND #$C0
    ORA #$10
    ORA a:AudioWorkByte
    STA a:AudioChannelControl,X
    JMP Music_UpdateChannelStream

    MusicEntry Audio_ReadStreamByte
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA (AudioStreamPointers,X)
    INC AudioStreamPointers,X
    BNE Local_436
    INC AudioStreamPointers+$01,X

    MusicLocal Local_436
    RTS

.assert Audio_UpdateMusic = MusicCpuBase, lderror, "Music engine moved"
.assert * - Audio_UpdateMusic = $0437, error, "Music engine size changed"
