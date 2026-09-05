; Doraemon PRG bank 0 $E9FD-$EB64
; World 1 four-channel music sequencer and command dispatch
; Generated deterministically from pinned Ghidra/GhidraNes facts

World1_Audio_UpdateMusic:
    LDA a:AudioMusicControl
    BNE Bank0_Label_E9C9
    LDA a:AudioMusicState
    BEQ Bank0_Label_E9EE
    BPL Bank0_Label_EA0C
    JMP Bank0_Label_EA90

Bank0_Label_EA0C:
    LDA a:AudioMusicState
    CMP #$09
    BCC Bank0_Label_EA16
    JMP Bank0_Label_EABA

Bank0_Label_EA16:
    ORA #$80
    STA a:AudioMusicState
    ASL A
    ASL A
    ASL A
    TAY
    LDX #$07

Bank0_Label_EA21:
    LDA a:$EFFA,Y
    STA AudioStreamPointers,X
    STA a:AudioStreamHeaderPointers,X
    DEY
    DEX
    BPL Bank0_Label_EA21
    STX a:AudioChannelBaseVolumes
    STX a:AudioChannelBaseVolumes+$01
    STX a:AudioChannelBaseVolumes+$02
    STX a:AudioChannelBaseVolumes+$03
    INX
    STX $3E
    STX $3F
    STX $40
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
    STX a:AudioChannelNotes
    STX a:AudioChannelNotes+$01
    STX a:AudioChannelNotes+$02
    STX a:AudioChannelNotes+$03
    LDA #$08
    STA a:AudioChannelLengthBits
    STA a:AudioChannelLengthBits+$01
    STA a:AudioChannelLengthBits+$02
    STA a:AudioChannelLengthBits+$03
    LDA #$80
    STA a:AudioChannelControl
    STA a:AudioChannelControl+$01
    STA a:AudioChannelControl+$02
    JSR World1_Audio_ResetChannels

Bank0_Label_EA90:
    LDA #$00
    STA a:AudioEndedChannelCount
    STA a:AudioChannelIndex

Bank0_Label_EA98:
    LDX a:AudioChannelIndex
    DEC a:AudioChannelDurations,X
    BEQ Bank0_Label_EAA6
    JSR World1_Music_UpdateVolumeEnvelope
    JMP Bank0_Label_EAA9

Bank0_Label_EAA6:
    JSR World1_Music_UpdateChannelStream

Bank0_Label_EAA9:
    INC a:AudioChannelIndex
    LDA a:AudioChannelIndex
    CMP #$04
    BCC Bank0_Label_EA98
    LDA a:AudioEndedChannelCount
    CMP #$04
    BNE Bank0_Label_EABF

Bank0_Label_EABA:
    LDA #$00
    STA a:AudioMusicState

Bank0_Label_EABF:
    RTS

World1_Music_UpdateVolumeEnvelope:
    CPX #$02
    BEQ Bank0_Label_EB0B
    LDA a:AudioChannelControl,X
    AND #$10
    BEQ Bank0_Label_EB0B
    LDA a:AudioChannelEnvelopeSteps,X
    ASL A
    STA a:AudioWorkByte
    BCC Bank0_Label_EADF
    LDA a:AudioChannelEnvelopeVolumes,X
    SEC
    SBC a:AudioWorkByte
    BCS Bank0_Label_EAEA
    BCC Bank0_Label_EAE8

Bank0_Label_EADF:
    LDA a:AudioChannelEnvelopeVolumes,X
    CLC
    ADC a:AudioWorkByte
    BCC Bank0_Label_EAEA

Bank0_Label_EAE8:
    LDA #$00

Bank0_Label_EAEA:
    STA a:AudioChannelEnvelopeVolumes,X
    LDY a:AudioEffectTimers,X
    BNE Bank0_Label_EB0B
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

Bank0_Label_EB0B:
    RTS

World1_Music_UpdateChannelStream:
    LDX a:AudioChannelIndex
    CPX #$03
    BNE Bank0_Label_EB1B
    LDA a:AudioNoiseDuration
    BEQ Bank0_Label_EB1B
    JMP Bank0_Label_EC21

Bank0_Label_EB1B:
    JSR World1_Audio_ReadStreamByte
    STA a:AudioWorkByte
    TAY
    BMI Bank0_Label_EB27
    JMP World1_Music_HandleNoteOrRest

Bank0_Label_EB27:
    CMP #$EF
    BCC Bank0_Label_EB5E
    SEC
    LDA #$FF
    SBC a:AudioWorkByte
    ASL A
    TAY
    LDA a:$EB3D,Y
    PHA
    LDA a:$EB3C,Y
    PHA
    RTS

World1_MusicCommand_RtsDispatchTable:
    .byte $9D, $EC, $79, $ED, $B4, $EC, $ED, $EC, $D2, $EC, $15, $ED, $2B, $ED, $3E, $ED
    .byte $63, $ED, $AB, $ED, $ED, $ED, $DD, $ED, $CB, $ED, $FA, $ED, $8B, $ED, $64, $EB
    .byte $02, $EE

Bank0_Label_EB5E:
    LDA a:AudioWorkByte
    AND #$7F
    BPL Bank0_Label_EB68
