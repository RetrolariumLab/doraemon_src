; Doraemon PRG bank 0 $EB65-$EE33
; World 1 music command handlers and stream reader
; Generated deterministically from pinned Ghidra/GhidraNes facts

World1_MusicCommand_LoadExtendedNote:
    JSR World1_Audio_ReadStreamByte

Bank0_Label_EB68:
    LDX a:AudioChannelIndex
    STA a:AudioChannelNotes,X
    LDA a:AudioChannelFixedPitchFlags,X
    BNE Bank0_Label_EBEF

Bank0_Label_EB73:
    LDX a:AudioChannelIndex
    LDA a:AudioChannelNotes,X

Bank0_Label_EB79:
    STA a:AudioWorkByte
    LDX a:AudioChannelIndex
    CPX #$02
    BEQ Bank0_Label_EBF2
    LDA a:AudioChannelControl,X
    AND #$10
    BNE Bank0_Label_EBA5
    LDA a:AudioChannelControl,X
    AND #$D0
    STA a:AudioChannelControl,X
    LDA a:AudioWorkByte
    LSR A
    CMP #$10
    BCC Bank0_Label_EB9C
    LDA #$0F

Bank0_Label_EB9C:
    ORA a:AudioChannelControl,X
    STA a:AudioChannelControl,X
    JMP Bank0_Label_EBB0

Bank0_Label_EBA5:
    LDY a:AudioWorkByte
    LDA a:$EEFB,Y
    ORA #$80
    STA a:AudioChannelEnvelopeSteps,X

Bank0_Label_EBB0:
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
    BCS Bank0_Label_EBDE
    ASL A
    ASL A
    ASL A
    ASL A
    ORA #$08
    STA a:AudioChannelLengthBits,X
    LDA a:AudioChannelControl,X
    AND #$10
    BEQ Bank0_Label_EBEF
    LDA a:AudioChannelLengthBits,X
    CMP #$08
    BNE Bank0_Label_EBEF
    LDA #$18
    BNE Bank0_Label_EBEC

Bank0_Label_EBDE:
    LDY #$00

Bank0_Label_EBE0:
    CMP a:$EECB,Y
    BCS Bank0_Label_EBE9
    INY
    INY
    BNE Bank0_Label_EBE0

Bank0_Label_EBE9:
    LDA a:$EECC,Y

Bank0_Label_EBEC:
    STA a:AudioChannelLengthBits,X

Bank0_Label_EBEF:
    JMP World1_Music_UpdateChannelStream

Bank0_Label_EBF2:
    LDA a:AudioWorkByte
    ASL A
    BMI Bank0_Label_EBFD
    ADC a:AudioWorkByte
    BPL Bank0_Label_EBFF

Bank0_Label_EBFD:
    LDA #$7F

Bank0_Label_EBFF:
    STA a:AudioChannelControl+$02
    JMP Bank0_Label_EBEF

World1_Music_HandleNoteOrRest:
    CMP #$00
    BNE Bank0_Label_EC0C
    JMP Bank0_Label_EC94

Bank0_Label_EC0C:
    LDX a:AudioChannelIndex
    CPX #$03
    BNE Bank0_Label_EC50
    PHA
    AND #$0F
    STA a:AudioNoiseDuration
    PLA
    LSR A
    LSR A
    LSR A
    LSR A
    STA a:AudioNoisePeriodIndex

Bank0_Label_EC21:
    DEC a:AudioNoiseDuration
    LDA a:AudioEffectTimers+$03
    BNE Bank0_Label_EC94
    LDA a:AudioNoisePeriodIndex
    BEQ Bank0_Label_EC94
    ASL A
    ASL A
    TAX
    LDY #$00

Bank0_Label_EC33:
    LDA a:$EEDB,X
    STA a:APU_NOISE_VOL,Y
    INX
    INY
    CPY #$04
    BCC Bank0_Label_EC33
    LDA a:AudioNoiseControl
    AND #$10
    BEQ Bank0_Label_EC86
    LDA a:AudioNoiseControl
    AND #$1F
    STA a:APU_NOISE_VOL
    BPL Bank0_Label_EC86

Bank0_Label_EC50:
    LDY a:AudioEffectTimers,X
    BNE Bank0_Label_EC94
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
    ADC a:$EEC8,X
    CLC
    ADC $3E,X
    CLC
    ADC a:AudioChannelPitchOffsets,X
    ASL A
    TAX
    LDA a:$EE34,X
    STA a:APU_PL1_LO,Y
    LDA a:$EE35,X
    LDX a:AudioChannelIndex
    ORA a:AudioChannelLengthBits,X
    STA a:APU_PL1_HI,Y

Bank0_Label_EC86:
    LDX a:AudioChannelIndex
    LDA a:AudioChannelFixedPitchFlags,X
    BNE Bank0_Label_EC94
    LDA a:AudioChannelBaseVolumes,X
    STA a:AudioChannelEnvelopeVolumes,X

Bank0_Label_EC94:
    LDX a:AudioChannelIndex
    LDA a:AudioChannelNotes,X
    STA a:AudioChannelDurations,X
    RTS

World1_MusicCommand_EndChannel:
    LDX a:AudioChannelIndex
    LDA #$01
    STA a:AudioChannelDurations,X
    TXA
    ASL A
    TAX
    LDA AudioStreamPointers,X
    BNE Bank0_Label_ECAF
    DEC AudioStreamPointers+$01,X

Bank0_Label_ECAF:
    DEC AudioStreamPointers,X
    INC a:AudioEndedChannelCount
    RTS

World1_MusicCommand_BeginCountedLoop:
    JSR World1_Audio_ReadStreamByte
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
    JMP World1_Music_UpdateChannelStream

World1_MusicCommand_SelectLoopExit:
    JSR World1_Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    CMP a:AudioLoopIterationCounts,X
    BCS Bank0_Label_ECEB
    TXA
    ASL A
    TAX
    LDA a:AudioLoopExitPointers,X
    STA AudioStreamPointers,X
    LDA a:AudioLoopExitPointers+$01,X
    STA AudioStreamPointers+$01,X

Bank0_Label_ECEB:
    JMP World1_Music_UpdateChannelStream

World1_MusicCommand_RepeatCountedLoop:
    LDX a:AudioChannelIndex
    LDA a:AudioLoopIterationCounts,X
    CMP a:AudioLoopRepeatLimits,X
    BCS Bank0_Label_ED13
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

Bank0_Label_ED13:
    JMP World1_Music_UpdateChannelStream

World1_MusicCommand_EnableFixedPitch:
    JSR World1_Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    STA a:AudioChannelFixedPitches,X
    LDA a:AudioChannelBaseVolumes,X
    STA a:AudioChannelEnvelopeVolumes,X
    LDA #$FF
    STA a:AudioChannelFixedPitchFlags,X
    BNE Bank0_Label_ED5E

World1_MusicCommand_DisableFixedPitch:
    LDX a:AudioChannelIndex
    LDA #$00
    STA a:AudioChannelFixedPitchFlags,X
    LDA a:AudioChannelControl,X
    AND #$CF
    STA a:AudioChannelControl,X

Bank0_Label_ED3C:
    JMP Bank0_Label_EB73

World1_MusicCommand_SetDutyCycle:
    JSR World1_Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    CPX #$02
    BEQ Bank0_Label_ECEB
    AND #$C0
    STA a:AudioWorkByte
    LDA a:AudioChannelControl,X
    AND #$10
    ORA a:AudioWorkByte
    STA a:AudioChannelControl,X
    LDA a:AudioChannelFixedPitchFlags,X
    BEQ Bank0_Label_ED3C

Bank0_Label_ED5E:
    LDA a:AudioChannelFixedPitches,X
    JMP Bank0_Label_EB79

World1_MusicCommand_SaveStreamPosition:
    JSR World1_Music_SaveStreamPosition
    JMP World1_Music_UpdateChannelStream

World1_Music_SaveStreamPosition:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA AudioStreamPointers,X
    STA a:AudioStreamHeaderPointers,X
    LDA AudioStreamPointers+$01,X
    STA a:AudioStreamHeaderPointers+$01,X
    RTS

World1_MusicCommand_RestoreStreamPosition:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA a:AudioStreamHeaderPointers,X
    STA AudioStreamPointers,X
    LDA a:AudioStreamHeaderPointers+$01,X
    STA AudioStreamPointers+$01,X
    JMP World1_Music_UpdateChannelStream

World1_MusicCommand_SelectTrackChannelStream:
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
    LDA a:$EFFB,Y
    STA AudioStreamPointers,X
    LDA a:$EFFC,Y
    STA AudioStreamPointers+$01,X
    JMP World1_Music_UpdateChannelStream

World1_MusicCommand_CallStream:
    JSR World1_Audio_ReadStreamByte
    PHA
    JSR World1_Audio_ReadStreamByte
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
    JMP World1_Music_UpdateChannelStream

World1_MusicCommand_ReturnFromStream:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA a:AudioStreamCallReturnPointers,X
    STA AudioStreamPointers,X
    LDA a:AudioStreamCallReturnPointers+$01,X
    STA AudioStreamPointers+$01,X
    JMP World1_Music_UpdateChannelStream

World1_MusicCommand_SetChannelPitchOffset:
    JSR World1_Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    CPX #$03
    BEQ Bank0_Label_EDEB
    STA a:AudioChannelPitchOffsets,X

Bank0_Label_EDEB:
    JMP World1_Music_UpdateChannelStream

World1_MusicCommand_SetGlobalPitchOffset:
    JSR World1_Audio_ReadStreamByte
    LDX #$02

Bank0_Label_EDF3:
    STA $3E,X
    DEX
    BPL Bank0_Label_EDF3
    JMP World1_Music_UpdateChannelStream

World1_MusicCommand_ResetLengthBits:
    LDX a:AudioChannelIndex
    LDA #$08
    JMP Bank0_Label_EBEC

World1_MusicCommand_SetEnvelopeVolume:
    JSR World1_Audio_ReadStreamByte
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
    JMP World1_Music_UpdateChannelStream

World1_Audio_ReadStreamByte:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA (AudioStreamPointers,X)
    INC AudioStreamPointers,X
    BNE Bank0_Label_EE33
    INC AudioStreamPointers+$01,X

Bank0_Label_EE33:
    RTS
