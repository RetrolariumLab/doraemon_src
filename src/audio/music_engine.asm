; Doraemon PRG bank 3 $9ED8-$A30E
; Four-channel music sequencer and stream interpreter
; Generated deterministically from pinned Ghidra/GhidraNes facts

Audio_UpdateMusic:
    LDA a:AudioMusicControl
    BNE Bank3_Label_9EA4
    LDA a:AudioMusicState
    BEQ Bank3_Label_9EC9
    BPL Bank3_Label_9EE7
    JMP Bank3_Label_9F6B

Bank3_Label_9EE7:
    LDA a:AudioMusicState
    CMP #$05
    BCC Bank3_Label_9EF1
    JMP Bank3_Label_9F95

Bank3_Label_9EF1:
    ORA #$80
    STA a:AudioMusicState
    ASL A
    ASL A
    ASL A
    TAY
    LDX #$07

Bank3_Label_9EFC:
    LDA a:MusicTrackHeaderIndexBase,Y
    STA AudioStreamPointers,X
    STA a:AudioSavedStreamPointers,X
    DEY
    DEX
    BPL Bank3_Label_9EFC
    STX a:AudioChannelBaseVolumes
    STX a:AudioChannelBaseVolumes+$01
    STX a:AudioChannelBaseVolumes+$02
    STX a:AudioChannelBaseVolumes+$03
    INX
    STX $46
    STX $47
    STX $48
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
    JSR Audio_ResetChannels

Bank3_Label_9F6B:
    LDA #$00
    STA a:AudioEndedChannelCount
    STA a:AudioChannelIndex

Bank3_Label_9F73:
    LDX a:AudioChannelIndex
    DEC a:AudioChannelDurations,X
    BEQ Bank3_Label_9F81
    JSR Music_UpdateVolumeEnvelope
    JMP Bank3_Label_9F84

Bank3_Label_9F81:
    JSR Music_UpdateChannelStream

Bank3_Label_9F84:
    INC a:AudioChannelIndex
    LDA a:AudioChannelIndex
    CMP #$04
    BCC Bank3_Label_9F73
    LDA a:AudioEndedChannelCount
    CMP #$04
    BNE Bank3_Label_9F9A

Bank3_Label_9F95:
    LDA #$00
    STA a:AudioMusicState

Bank3_Label_9F9A:
    RTS

Music_UpdateVolumeEnvelope:
    CPX #$02
    BEQ Bank3_Label_9FE6
    LDA a:AudioChannelControl,X
    AND #$10
    BEQ Bank3_Label_9FE6
    LDA a:AudioChannelEnvelopeSteps,X
    ASL A
    STA a:AudioWorkByte
    BCC Bank3_Label_9FBA
    LDA a:AudioChannelEnvelopeVolumes,X
    SEC
    SBC a:AudioWorkByte
    BCS Bank3_Label_9FC5
    BCC Bank3_Label_9FC3

Bank3_Label_9FBA:
    LDA a:AudioChannelEnvelopeVolumes,X
    CLC
    ADC a:AudioWorkByte
    BCC Bank3_Label_9FC5

Bank3_Label_9FC3:
    LDA #$00

Bank3_Label_9FC5:
    STA a:AudioChannelEnvelopeVolumes,X
    LDY a:AudioEffectTimers,X
    BNE Bank3_Label_9FE6
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

Bank3_Label_9FE6:
    RTS

Music_UpdateChannelStream:
    LDX a:AudioChannelIndex
    CPX #$03
    BNE Bank3_Label_9FF6
    LDA a:AudioNoiseDuration
    BEQ Bank3_Label_9FF6
    JMP Bank3_Label_A0FC

Bank3_Label_9FF6:
    JSR Audio_ReadStreamByte
    STA a:AudioWorkByte
    TAY
    BMI Bank3_Label_A002
    JMP Music_HandleNoteOrRest

Bank3_Label_A002:
    CMP #$EF
    BCC Bank3_Label_A039
    SEC
    LDA #$FF
    SBC a:AudioWorkByte
    ASL A
    TAY
    LDA a:$A018,Y
    PHA
    LDA a:$A017,Y
    PHA
    RTS

MusicCommand_RtsDispatchTable:
    .byte $78, $A1, $54, $A2, $8F, $A1, $C8, $A1, $AD, $A1, $F0, $A1, $06, $A2, $19, $A2
    .byte $3E, $A2, $86, $A2, $C8, $A2, $B8, $A2, $A6, $A2, $D5, $A2, $66, $A2, $3F, $A0
    .byte $DD, $A2

Bank3_Label_A039:
    LDA a:AudioWorkByte
    AND #$7F
    BPL Bank3_Label_A043

MusicCommand_LoadExtendedDuration:
    JSR Audio_ReadStreamByte

Bank3_Label_A043:
    LDX a:AudioChannelIndex
    STA a:AudioChannelDurationCodes,X
    LDA a:AudioChannelFixedPitchFlags,X
    BNE Bank3_Label_A0CA

Bank3_Label_A04E:
    LDX a:AudioChannelIndex
    LDA a:AudioChannelDurationCodes,X

Bank3_Label_A054:
    STA a:AudioWorkByte
    LDX a:AudioChannelIndex
    CPX #$02
    BEQ Bank3_Label_A0CD
    LDA a:AudioChannelControl,X
    AND #$10
    BNE Bank3_Label_A080
    LDA a:AudioChannelControl,X
    AND #$D0
    STA a:AudioChannelControl,X
    LDA a:AudioWorkByte
    LSR A
    CMP #$10
    BCC Bank3_Label_A077
    LDA #$0F

Bank3_Label_A077:
    ORA a:AudioChannelControl,X
    STA a:AudioChannelControl,X
    JMP Bank3_Label_A08B

Bank3_Label_A080:
    LDY a:AudioWorkByte
    LDA a:$A3D6,Y
    ORA #$80
    STA a:AudioChannelEnvelopeSteps,X

Bank3_Label_A08B:
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
    BCS Bank3_Label_A0B9
    ASL A
    ASL A
    ASL A
    ASL A
    ORA #$08
    STA a:AudioChannelLengthBits,X
    LDA a:AudioChannelControl,X
    AND #$10
    BEQ Bank3_Label_A0CA
    LDA a:AudioChannelLengthBits,X
    CMP #$08
    BNE Bank3_Label_A0CA
    LDA #$18
    BNE Bank3_Label_A0C7

Bank3_Label_A0B9:
    LDY #$00

Bank3_Label_A0BB:
    CMP a:$A3A6,Y
    BCS Bank3_Label_A0C4
    INY
    INY
    BNE Bank3_Label_A0BB

Bank3_Label_A0C4:
    LDA a:$A3A7,Y

Bank3_Label_A0C7:
    STA a:AudioChannelLengthBits,X

Bank3_Label_A0CA:
    JMP Music_UpdateChannelStream

Bank3_Label_A0CD:
    LDA a:AudioWorkByte
    ASL A
    BMI Bank3_Label_A0D8
    ADC a:AudioWorkByte
    BPL Bank3_Label_A0DA

Bank3_Label_A0D8:
    LDA #$7F

Bank3_Label_A0DA:
    STA a:AudioChannelControl+$02
    JMP Bank3_Label_A0CA

Music_HandleNoteOrRest:
    CMP #$00
    BNE Bank3_Label_A0E7
    JMP Bank3_Label_A16F

Bank3_Label_A0E7:
    LDX a:AudioChannelIndex
    CPX #$03
    BNE Bank3_Label_A12B
    PHA
    AND #$0F
    STA a:AudioNoiseDuration
    PLA
    LSR A
    LSR A
    LSR A
    LSR A
    STA a:AudioNoisePeriodIndex

Bank3_Label_A0FC:
    DEC a:AudioNoiseDuration
    LDA a:AudioEffectTimers+$03
    BNE Bank3_Label_A16F
    LDA a:AudioNoisePeriodIndex
    BEQ Bank3_Label_A16F
    ASL A
    ASL A
    TAX
    LDY #$00

Bank3_Label_A10E:
    LDA a:$A3B6,X
    STA a:APU_NOISE_VOL,Y
    INX
    INY
    CPY #$04
    BCC Bank3_Label_A10E
    LDA a:AudioNoiseControl
    AND #$10
    BEQ Bank3_Label_A161
    LDA a:AudioNoiseControl
    AND #$1F
    STA a:APU_NOISE_VOL
    BPL Bank3_Label_A161

Bank3_Label_A12B:
    LDY a:AudioEffectTimers,X
    BNE Bank3_Label_A16F
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
    ADC a:$A3A3,X
    CLC
    ADC $46,X
    CLC
    ADC a:AudioChannelPitchOffsets,X
    ASL A
    TAX
    LDA a:$A30F,X
    STA a:APU_PL1_LO,Y
    LDA a:$A310,X
    LDX a:AudioChannelIndex
    ORA a:AudioChannelLengthBits,X
    STA a:APU_PL1_HI,Y

Bank3_Label_A161:
    LDX a:AudioChannelIndex
    LDA a:AudioChannelFixedPitchFlags,X
    BNE Bank3_Label_A16F
    LDA a:AudioChannelBaseVolumes,X
    STA a:AudioChannelEnvelopeVolumes,X

Bank3_Label_A16F:
    LDX a:AudioChannelIndex
    LDA a:AudioChannelDurationCodes,X
    STA a:AudioChannelDurations,X
    RTS

MusicCommand_EndChannel:
    LDX a:AudioChannelIndex
    LDA #$01
    STA a:AudioChannelDurations,X
    TXA
    ASL A
    TAX
    LDA AudioStreamPointers,X
    BNE Bank3_Label_A18A
    DEC AudioStreamPointers+$01,X

Bank3_Label_A18A:
    DEC AudioStreamPointers,X
    INC a:AudioEndedChannelCount
    RTS

MusicCommand_BeginCountedLoop:
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

MusicCommand_SelectLoopExit:
    JSR Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    CMP a:AudioLoopIterationCounts,X
    BCS Bank3_Label_A1C6
    TXA
    ASL A
    TAX
    LDA a:AudioLoopExitPointers,X
    STA AudioStreamPointers,X
    LDA a:AudioLoopExitPointers+$01,X
    STA AudioStreamPointers+$01,X

Bank3_Label_A1C6:
    JMP Music_UpdateChannelStream

MusicCommand_RepeatCountedLoop:
    LDX a:AudioChannelIndex
    LDA a:AudioLoopIterationCounts,X
    CMP a:AudioLoopRepeatLimits,X
    BCS Bank3_Label_A1EE
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

Bank3_Label_A1EE:
    JMP Music_UpdateChannelStream

MusicCommand_EnableFixedPitch:
    JSR Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    STA a:AudioChannelFixedPitches,X
    LDA a:AudioChannelBaseVolumes,X
    STA a:AudioChannelEnvelopeVolumes,X
    LDA #$FF
    STA a:AudioChannelFixedPitchFlags,X
    BNE Bank3_Label_A239

MusicCommand_DisableFixedPitch:
    LDX a:AudioChannelIndex
    LDA #$00
    STA a:AudioChannelFixedPitchFlags,X
    LDA a:AudioChannelControl,X
    AND #$CF
    STA a:AudioChannelControl,X

Bank3_Label_A217:
    JMP Bank3_Label_A04E

MusicCommand_SetDutyCycle:
    JSR Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    CPX #$02
    BEQ Bank3_Label_A1C6
    AND #$C0
    STA a:AudioWorkByte
    LDA a:AudioChannelControl,X
    AND #$10
    ORA a:AudioWorkByte
    STA a:AudioChannelControl,X
    LDA a:AudioChannelFixedPitchFlags,X
    BEQ Bank3_Label_A217

Bank3_Label_A239:
    LDA a:AudioChannelFixedPitches,X
    JMP Bank3_Label_A054

MusicCommand_SaveStreamPosition:
    JSR Music_SaveStreamPosition
    JMP Music_UpdateChannelStream

Music_SaveStreamPosition:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA AudioStreamPointers,X
    STA a:AudioSavedStreamPointers,X
    LDA AudioStreamPointers+$01,X
    STA a:AudioSavedStreamPointers+$01,X
    RTS

MusicCommand_RestoreStreamPosition:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA a:AudioSavedStreamPointers,X
    STA AudioStreamPointers,X
    LDA a:AudioSavedStreamPointers+$01,X
    STA AudioStreamPointers+$01,X
    JMP Music_UpdateChannelStream

MusicCommand_SelectTrackChannelStream:
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
    LDA a:$A4D6,Y
    STA AudioStreamPointers,X
    LDA a:$A4D7,Y
    STA AudioStreamPointers+$01,X
    JMP Music_UpdateChannelStream

MusicCommand_CallStream:
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

MusicCommand_ReturnFromStream:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA a:AudioStreamCallReturnPointers,X
    STA AudioStreamPointers,X
    LDA a:AudioStreamCallReturnPointers+$01,X
    STA AudioStreamPointers+$01,X
    JMP Music_UpdateChannelStream

MusicCommand_SetChannelPitchOffset:
    JSR Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    CPX #$03
    BEQ Bank3_Label_A2C6
    STA a:AudioChannelPitchOffsets,X

Bank3_Label_A2C6:
    JMP Music_UpdateChannelStream

MusicCommand_SetGlobalPitchOffset:
    JSR Audio_ReadStreamByte
    LDX #$02

Bank3_Label_A2CE:
    STA $46,X
    DEX
    BPL Bank3_Label_A2CE
    JMP Music_UpdateChannelStream

MusicCommand_ResetLengthBits:
    LDX a:AudioChannelIndex
    LDA #$08
    JMP Bank3_Label_A0C7

MusicCommand_SetEnvelopeVolume:
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

Audio_ReadStreamByte:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA (AudioStreamPointers,X)
    INC AudioStreamPointers,X
    BNE Bank3_Label_A30E
    INC AudioStreamPointers+$01,X

Bank3_Label_A30E:
    RTS
