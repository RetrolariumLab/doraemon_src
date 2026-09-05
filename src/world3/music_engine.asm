; Doraemon PRG bank 2 $C4F5-$C633
; World 3 four-channel music sequencer and stream interpreter
; Generated deterministically from pinned Ghidra/GhidraNes facts

World3_Audio_UpdateMusic:
    LDA a:AudioMusicControl
    BNE Bank2_Label_C4C1
    LDA a:AudioMusicState
    BEQ Bank2_Label_C4E6
    BPL Bank2_Label_C504
    JMP Bank2_Label_C588

Bank2_Label_C504:
    LDA a:AudioMusicState
    CMP #$09
    BCC Bank2_Label_C50E
    JMP Bank2_Label_C5B2

Bank2_Label_C50E:
    ORA #$80
    STA a:AudioMusicState
    ASL A
    ASL A
    ASL A
    TAY
    LDX #$07

Bank2_Label_C519:
    LDA a:$CAF2,Y
    STA AudioStreamPointers,X
    STA a:AudioStreamHeaderPointers,X
    DEY
    DEX
    BPL Bank2_Label_C519
    STX a:AudioChannelBaseVolumes
    STX a:AudioChannelBaseVolumes+$01
    STX a:AudioChannelBaseVolumes+$02
    STX a:AudioChannelBaseVolumes+$03
    INX
    STX $D3
    STX $D4
    STX $D5
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
    JSR World3_Audio_ResetChannels

Bank2_Label_C588:
    LDA #$00
    STA a:AudioEndedChannelCount
    STA a:AudioChannelIndex

Bank2_Label_C590:
    LDX a:AudioChannelIndex
    DEC a:AudioChannelDurations,X
    BEQ Bank2_Label_C59E
    JSR World3_Music_UpdateVolumeEnvelope
    JMP Bank2_Label_C5A1

Bank2_Label_C59E:
    JSR World3_Music_UpdateChannelStream

Bank2_Label_C5A1:
    INC a:AudioChannelIndex
    LDA a:AudioChannelIndex
    CMP #$04
    BCC Bank2_Label_C590
    LDA a:AudioEndedChannelCount
    CMP #$04
    BNE Bank2_Label_C5B7

Bank2_Label_C5B2:
    LDA #$00
    STA a:AudioMusicState

Bank2_Label_C5B7:
    RTS

World3_Music_UpdateVolumeEnvelope:
    CPX #$02
    BEQ Bank2_Label_C603
    LDA a:AudioChannelControl,X
    AND #$10
    BEQ Bank2_Label_C603
    LDA a:AudioChannelEnvelopeSteps,X
    ASL A
    STA a:AudioWorkByte
    BCC Bank2_Label_C5D7
    LDA a:AudioChannelEnvelopeVolumes,X
    SEC
    SBC a:AudioWorkByte
    BCS Bank2_Label_C5E2
    BCC Bank2_Label_C5E0

Bank2_Label_C5D7:
    LDA a:AudioChannelEnvelopeVolumes,X
    CLC
    ADC a:AudioWorkByte
    BCC Bank2_Label_C5E2

Bank2_Label_C5E0:
    LDA #$00

Bank2_Label_C5E2:
    STA a:AudioChannelEnvelopeVolumes,X
    LDY a:AudioEffectTimers,X
    BNE Bank2_Label_C603
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

Bank2_Label_C603:
    RTS

World3_Music_UpdateChannelStream:
    LDX a:AudioChannelIndex
    CPX #$03
    BNE Bank2_Label_C613
    LDA a:AudioNoiseDuration
    BEQ Bank2_Label_C613
    JMP Bank2_Label_C719

Bank2_Label_C613:
    JSR World3_Audio_ReadStreamByte
    STA a:AudioWorkByte
    TAY
    BMI Bank2_Label_C61F
    JMP World3_Music_HandleNoteOrRest

Bank2_Label_C61F:
    CMP #$EF
    BCC Bank2_Label_C656
    SEC
    LDA #$FF
    SBC a:AudioWorkByte
    ASL A
    TAY
    LDA a:$C635,Y
    PHA
    LDA a:$C634,Y
    PHA
    RTS
