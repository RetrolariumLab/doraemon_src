; Doraemon PRG bank 2 $C634-$C92B
; World 3 music RTS table, command handlers, and stream reader
; Generated deterministically from pinned Ghidra/GhidraNes facts

World3_MusicCommand_RtsDispatchTable:
    .byte $95, $C7, $71, $C8, $AC, $C7, $E5, $C7, $CA, $C7, $0D, $C8, $23, $C8, $36, $C8
    .byte $5B, $C8, $A3, $C8, $E5, $C8, $D5, $C8, $C3, $C8, $F2, $C8, $83, $C8, $5C, $C6
    .byte $FA, $C8

Bank2_Label_C656:
    LDA a:AudioWorkByte
    AND #$7F
    BPL Bank2_Label_C660

World3_MusicCommand_LoadExtendedNote:
    JSR World3_Audio_ReadStreamByte

Bank2_Label_C660:
    LDX a:AudioChannelIndex
    STA a:AudioChannelNotes,X
    LDA a:AudioChannelFixedPitchFlags,X
    BNE Bank2_Label_C6E7

Bank2_Label_C66B:
    LDX a:AudioChannelIndex
    LDA a:AudioChannelNotes,X

Bank2_Label_C671:
    STA a:AudioWorkByte
    LDX a:AudioChannelIndex
    CPX #$02
    BEQ Bank2_Label_C6EA
    LDA a:AudioChannelControl,X
    AND #$10
    BNE Bank2_Label_C69D
    LDA a:AudioChannelControl,X
    AND #$D0
    STA a:AudioChannelControl,X
    LDA a:AudioWorkByte
    LSR A
    CMP #$10
    BCC Bank2_Label_C694
    LDA #$0F

Bank2_Label_C694:
    ORA a:AudioChannelControl,X
    STA a:AudioChannelControl,X
    JMP Bank2_Label_C6A8

Bank2_Label_C69D:
    LDY a:AudioWorkByte
    LDA a:$C9F3,Y
    ORA #$80
    STA a:AudioChannelEnvelopeSteps,X

Bank2_Label_C6A8:
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
    BCS Bank2_Label_C6D6
    ASL A
    ASL A
    ASL A
    ASL A
    ORA #$08
    STA a:AudioChannelLengthBits,X
    LDA a:AudioChannelControl,X
    AND #$10
    BEQ Bank2_Label_C6E7
    LDA a:AudioChannelLengthBits,X
    CMP #$08
    BNE Bank2_Label_C6E7
    LDA #$18
    BNE Bank2_Label_C6E4

Bank2_Label_C6D6:
    LDY #$00

Bank2_Label_C6D8:
    CMP a:$C9C3,Y
    BCS Bank2_Label_C6E1
    INY
    INY
    BNE Bank2_Label_C6D8

Bank2_Label_C6E1:
    LDA a:$C9C4,Y

Bank2_Label_C6E4:
    STA a:AudioChannelLengthBits,X

Bank2_Label_C6E7:
    JMP World3_Music_UpdateChannelStream

Bank2_Label_C6EA:
    LDA a:AudioWorkByte
    ASL A
    BMI Bank2_Label_C6F5
    ADC a:AudioWorkByte
    BPL Bank2_Label_C6F7

Bank2_Label_C6F5:
    LDA #$7F

Bank2_Label_C6F7:
    STA a:AudioChannelControl+$02
    JMP Bank2_Label_C6E7

World3_Music_HandleNoteOrRest:
    CMP #$00
    BNE Bank2_Label_C704
    JMP Bank2_Label_C78C

Bank2_Label_C704:
    LDX a:AudioChannelIndex
    CPX #$03
    BNE Bank2_Label_C748
    PHA
    AND #$0F
    STA a:AudioNoiseDuration
    PLA
    LSR A
    LSR A
    LSR A
    LSR A
    STA a:AudioNoisePeriodIndex

Bank2_Label_C719:
    DEC a:AudioNoiseDuration
    LDA a:AudioEffectTimers+$03
    BNE Bank2_Label_C78C
    LDA a:AudioNoisePeriodIndex
    BEQ Bank2_Label_C78C
    ASL A
    ASL A
    TAX
    LDY #$00

Bank2_Label_C72B:
    LDA a:$C9D3,X
    STA a:APU_NOISE_VOL,Y
    INX
    INY
    CPY #$04
    BCC Bank2_Label_C72B
    LDA a:AudioNoiseControl
    AND #$10
    BEQ Bank2_Label_C77E
    LDA a:AudioNoiseControl
    AND #$1F
    STA a:APU_NOISE_VOL
    BPL Bank2_Label_C77E

Bank2_Label_C748:
    LDY a:AudioEffectTimers,X
    BNE Bank2_Label_C78C
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
    ADC a:$C9C0,X
    CLC
    ADC $D3,X
    CLC
    ADC a:AudioChannelPitchOffsets,X
    ASL A
    TAX
    LDA a:$C92C,X
    STA a:APU_PL1_LO,Y
    LDA a:$C92D,X
    LDX a:AudioChannelIndex
    ORA a:AudioChannelLengthBits,X
    STA a:APU_PL1_HI,Y

Bank2_Label_C77E:
    LDX a:AudioChannelIndex
    LDA a:AudioChannelFixedPitchFlags,X
    BNE Bank2_Label_C78C
    LDA a:AudioChannelBaseVolumes,X
    STA a:AudioChannelEnvelopeVolumes,X

Bank2_Label_C78C:
    LDX a:AudioChannelIndex
    LDA a:AudioChannelNotes,X
    STA a:AudioChannelDurations,X
    RTS

World3_MusicCommand_EndChannel:
    LDX a:AudioChannelIndex
    LDA #$01
    STA a:AudioChannelDurations,X
    TXA
    ASL A
    TAX
    LDA AudioStreamPointers,X
    BNE Bank2_Label_C7A7
    DEC AudioStreamPointers+$01,X

Bank2_Label_C7A7:
    DEC AudioStreamPointers,X
    INC a:AudioEndedChannelCount
    RTS

World3_MusicCommand_BeginCountedLoop:
    JSR World3_Audio_ReadStreamByte
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
    JMP World3_Music_UpdateChannelStream

World3_MusicCommand_SelectLoopExit:
    JSR World3_Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    CMP a:AudioLoopIterationCounts,X
    BCS Bank2_Label_C7E3
    TXA
    ASL A
    TAX
    LDA a:AudioLoopExitPointers,X
    STA AudioStreamPointers,X
    LDA a:AudioLoopExitPointers+$01,X
    STA AudioStreamPointers+$01,X

Bank2_Label_C7E3:
    JMP World3_Music_UpdateChannelStream

World3_MusicCommand_RepeatCountedLoop:
    LDX a:AudioChannelIndex
    LDA a:AudioLoopIterationCounts,X
    CMP a:AudioLoopRepeatLimits,X
    BCS Bank2_Label_C80B
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

Bank2_Label_C80B:
    JMP World3_Music_UpdateChannelStream

World3_MusicCommand_EnableFixedPitch:
    JSR World3_Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    STA a:AudioChannelFixedPitches,X
    LDA a:AudioChannelBaseVolumes,X
    STA a:AudioChannelEnvelopeVolumes,X
    LDA #$FF
    STA a:AudioChannelFixedPitchFlags,X
    BNE Bank2_Label_C856

World3_MusicCommand_DisableFixedPitch:
    LDX a:AudioChannelIndex
    LDA #$00
    STA a:AudioChannelFixedPitchFlags,X
    LDA a:AudioChannelControl,X
    AND #$CF
    STA a:AudioChannelControl,X

Bank2_Label_C834:
    JMP Bank2_Label_C66B

World3_MusicCommand_SetDutyCycle:
    JSR World3_Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    CPX #$02
    BEQ Bank2_Label_C7E3
    AND #$C0
    STA a:AudioWorkByte
    LDA a:AudioChannelControl,X
    AND #$10
    ORA a:AudioWorkByte
    STA a:AudioChannelControl,X
    LDA a:AudioChannelFixedPitchFlags,X
    BEQ Bank2_Label_C834

Bank2_Label_C856:
    LDA a:AudioChannelFixedPitches,X
    JMP Bank2_Label_C671

World3_MusicCommand_SaveStreamPosition:
    JSR World3_Music_SaveStreamPosition
    JMP World3_Music_UpdateChannelStream

World3_Music_SaveStreamPosition:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA AudioStreamPointers,X
    STA a:AudioStreamHeaderPointers,X
    LDA AudioStreamPointers+$01,X
    STA a:AudioStreamHeaderPointers+$01,X
    RTS

World3_MusicCommand_RestoreStreamPosition:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA a:AudioStreamHeaderPointers,X
    STA AudioStreamPointers,X
    LDA a:AudioStreamHeaderPointers+$01,X
    STA AudioStreamPointers+$01,X
    JMP World3_Music_UpdateChannelStream

World3_MusicCommand_SelectTrackChannelStream:
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
    LDA a:$CAF3,Y
    STA AudioStreamPointers,X
    LDA a:$CAF4,Y
    STA AudioStreamPointers+$01,X
    JMP World3_Music_UpdateChannelStream

World3_MusicCommand_CallStream:
    JSR World3_Audio_ReadStreamByte
    PHA
    JSR World3_Audio_ReadStreamByte
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
    JMP World3_Music_UpdateChannelStream

World3_MusicCommand_ReturnFromStream:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA a:AudioStreamCallReturnPointers,X
    STA AudioStreamPointers,X
    LDA a:AudioStreamCallReturnPointers+$01,X
    STA AudioStreamPointers+$01,X
    JMP World3_Music_UpdateChannelStream

World3_MusicCommand_SetChannelPitchOffset:
    JSR World3_Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    CPX #$03
    BEQ Bank2_Label_C8E3
    STA a:AudioChannelPitchOffsets,X

Bank2_Label_C8E3:
    JMP World3_Music_UpdateChannelStream

World3_MusicCommand_SetGlobalPitchOffset:
    JSR World3_Audio_ReadStreamByte
    LDX #$02

Bank2_Label_C8EB:
    STA $D3,X
    DEX
    BPL Bank2_Label_C8EB
    JMP World3_Music_UpdateChannelStream

World3_MusicCommand_ResetLengthBits:
    LDX a:AudioChannelIndex
    LDA #$08
    JMP Bank2_Label_C6E4

World3_MusicCommand_SetEnvelopeVolume:
    JSR World3_Audio_ReadStreamByte
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
    JMP World3_Music_UpdateChannelStream

World3_Audio_ReadStreamByte:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA (AudioStreamPointers,X)
    INC AudioStreamPointers,X
    BNE Bank2_Label_C92B
    INC AudioStreamPointers+$01,X

Bank2_Label_C92B:
    RTS
