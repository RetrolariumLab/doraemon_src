; Doraemon PRG bank 1 $ACE4-$AE22
; World 2 four-channel music sequencer and stream interpreter
; Generated deterministically from pinned Ghidra/GhidraNes facts

World2_Audio_UpdateMusic:
    LDA a:AudioMusicControl
    BNE Bank1_Label_ACB0
    LDA a:AudioMusicState
    BEQ Bank1_Label_ACD5
    BPL Bank1_Label_ACF3
    JMP Bank1_Label_AD77

Bank1_Label_ACF3:
    LDA a:AudioMusicState
    CMP #$07
    BCC Bank1_Label_ACFD
    JMP Bank1_Label_ADA1

Bank1_Label_ACFD:
    ORA #$80
    STA a:AudioMusicState
    ASL A
    ASL A
    ASL A
    TAY
    LDX #$07

Bank1_Label_AD08:
    LDA a:World2_MusicTrackHeaderIndexBase,Y
    STA AudioStreamPointers,X
    STA a:AudioSavedStreamPointers,X
    DEY
    DEX
    BPL Bank1_Label_AD08
    STX a:AudioChannelBaseVolumes
    STX a:AudioChannelBaseVolumes+$01
    STX a:AudioChannelBaseVolumes+$02
    STX a:AudioChannelBaseVolumes+$03
    INX
    STX $B5
    STX $B6
    STX $B7
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
    JSR World2_Audio_ResetChannels

Bank1_Label_AD77:
    LDA #$00
    STA a:AudioEndedChannelCount
    STA a:AudioChannelIndex

Bank1_Label_AD7F:
    LDX a:AudioChannelIndex
    DEC a:AudioChannelDurations,X
    BEQ Bank1_Label_AD8D
    JSR World2_Music_UpdateVolumeEnvelope
    JMP Bank1_Label_AD90

Bank1_Label_AD8D:
    JSR World2_Music_UpdateChannelStream

Bank1_Label_AD90:
    INC a:AudioChannelIndex
    LDA a:AudioChannelIndex
    CMP #$04
    BCC Bank1_Label_AD7F
    LDA a:AudioEndedChannelCount
    CMP #$04
    BNE Bank1_Label_ADA6

Bank1_Label_ADA1:
    LDA #$00
    STA a:AudioMusicState

Bank1_Label_ADA6:
    RTS

World2_Music_UpdateVolumeEnvelope:
    CPX #$02
    BEQ Bank1_Label_ADF2
    LDA a:AudioChannelControl,X
    AND #$10
    BEQ Bank1_Label_ADF2
    LDA a:AudioChannelEnvelopeSteps,X
    ASL A
    STA a:AudioWorkByte
    BCC Bank1_Label_ADC6
    LDA a:AudioChannelEnvelopeVolumes,X
    SEC
    SBC a:AudioWorkByte
    BCS Bank1_Label_ADD1
    BCC Bank1_Label_ADCF

Bank1_Label_ADC6:
    LDA a:AudioChannelEnvelopeVolumes,X
    CLC
    ADC a:AudioWorkByte
    BCC Bank1_Label_ADD1

Bank1_Label_ADCF:
    LDA #$00

Bank1_Label_ADD1:
    STA a:AudioChannelEnvelopeVolumes,X
    LDY a:AudioEffectTimers,X
    BNE Bank1_Label_ADF2
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

Bank1_Label_ADF2:
    RTS

World2_Music_UpdateChannelStream:
    LDX a:AudioChannelIndex
    CPX #$03
    BNE Bank1_Label_AE02
    LDA a:AudioNoiseDuration
    BEQ Bank1_Label_AE02
    JMP Bank1_Label_AF08

Bank1_Label_AE02:
    JSR World2_Audio_ReadStreamByte
    STA a:AudioWorkByte
    TAY
    BMI Bank1_Label_AE0E
    JMP World2_Music_HandleNoteOrRest

Bank1_Label_AE0E:
    CMP #$EF
    BCC Bank1_Label_AE45
    SEC
    LDA #$FF
    SBC a:AudioWorkByte
    ASL A
    TAY
    LDA a:$AE24,Y
    PHA
    LDA a:$AE23,Y
    PHA
    RTS
