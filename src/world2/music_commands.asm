; Doraemon PRG bank 1 $AE23-$B11A
; World 2 music RTS table, command handlers, and stream reader
; Generated deterministically from pinned Ghidra/GhidraNes facts

World2_MusicCommand_RtsDispatchTable:
    .byte $84, $AF, $60, $B0, $9B, $AF, $D4, $AF, $B9, $AF, $FC, $AF, $12, $B0, $25, $B0
    .byte $4A, $B0, $92, $B0, $D4, $B0, $C4, $B0, $B2, $B0, $E1, $B0, $72, $B0, $4B, $AE
    .byte $E9, $B0

Bank1_Label_AE45:
    LDA a:AudioWorkByte
    AND #$7F
    BPL Bank1_Label_AE4F

World2_MusicCommand_LoadExtendedNote:
    JSR World2_Audio_ReadStreamByte

Bank1_Label_AE4F:
    LDX a:AudioChannelIndex
    STA a:AudioChannelNotes,X
    LDA a:AudioChannelFixedPitchFlags,X
    BNE Bank1_Label_AED6

Bank1_Label_AE5A:
    LDX a:AudioChannelIndex
    LDA a:AudioChannelNotes,X

Bank1_Label_AE60:
    STA a:AudioWorkByte
    LDX a:AudioChannelIndex
    CPX #$02
    BEQ Bank1_Label_AED9
    LDA a:AudioChannelControl,X
    AND #$10
    BNE Bank1_Label_AE8C
    LDA a:AudioChannelControl,X
    AND #$D0
    STA a:AudioChannelControl,X
    LDA a:AudioWorkByte
    LSR A
    CMP #$10
    BCC Bank1_Label_AE83
    LDA #$0F

Bank1_Label_AE83:
    ORA a:AudioChannelControl,X
    STA a:AudioChannelControl,X
    JMP Bank1_Label_AE97

Bank1_Label_AE8C:
    LDY a:AudioWorkByte
    LDA a:$B1E3,Y
    ORA #$80
    STA a:AudioChannelEnvelopeSteps,X

Bank1_Label_AE97:
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
    BCS Bank1_Label_AEC5
    ASL A
    ASL A
    ASL A
    ASL A
    ORA #$08
    STA a:AudioChannelLengthBits,X
    LDA a:AudioChannelControl,X
    AND #$10
    BEQ Bank1_Label_AED6
    LDA a:AudioChannelLengthBits,X
    CMP #$08
    BNE Bank1_Label_AED6
    LDA #$18
    BNE Bank1_Label_AED3

Bank1_Label_AEC5:
    LDY #$00

Bank1_Label_AEC7:
    CMP a:$B1B3,Y
    BCS Bank1_Label_AED0
    INY
    INY
    BNE Bank1_Label_AEC7

Bank1_Label_AED0:
    LDA a:$B1B4,Y

Bank1_Label_AED3:
    STA a:AudioChannelLengthBits,X

Bank1_Label_AED6:
    JMP World2_Music_UpdateChannelStream

Bank1_Label_AED9:
    LDA a:AudioWorkByte
    ASL A
    BMI Bank1_Label_AEE4
    ADC a:AudioWorkByte
    BPL Bank1_Label_AEE6

Bank1_Label_AEE4:
    LDA #$7F

Bank1_Label_AEE6:
    STA a:AudioChannelControl+$02
    JMP Bank1_Label_AED6

World2_Music_HandleNoteOrRest:
    CMP #$00
    BNE Bank1_Label_AEF3
    JMP Bank1_Label_AF7B

Bank1_Label_AEF3:
    LDX a:AudioChannelIndex
    CPX #$03
    BNE Bank1_Label_AF37
    PHA
    AND #$0F
    STA a:AudioNoiseDuration
    PLA
    LSR A
    LSR A
    LSR A
    LSR A
    STA a:AudioNoisePeriodIndex

Bank1_Label_AF08:
    DEC a:AudioNoiseDuration
    LDA a:AudioEffectTimers+$03
    BNE Bank1_Label_AF7B
    LDA a:AudioNoisePeriodIndex
    BEQ Bank1_Label_AF7B
    ASL A
    ASL A
    TAX
    LDY #$00

Bank1_Label_AF1A:
    LDA a:$B1C3,X
    STA a:APU_NOISE_VOL,Y
    INX
    INY
    CPY #$04
    BCC Bank1_Label_AF1A
    LDA a:AudioNoiseControl
    AND #$10
    BEQ Bank1_Label_AF6D
    LDA a:AudioNoiseControl
    AND #$1F
    STA a:APU_NOISE_VOL
    BPL Bank1_Label_AF6D

Bank1_Label_AF37:
    LDY a:AudioEffectTimers,X
    BNE Bank1_Label_AF7B
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
    ADC a:$B1AF,X
    CLC
    ADC $B5,X
    CLC
    ADC a:AudioChannelPitchOffsets,X
    ASL A
    TAX
    LDA a:$B11B,X
    STA a:APU_PL1_LO,Y
    LDA a:$B11C,X
    LDX a:AudioChannelIndex
    ORA a:AudioChannelLengthBits,X
    STA a:APU_PL1_HI,Y

Bank1_Label_AF6D:
    LDX a:AudioChannelIndex
    LDA a:AudioChannelFixedPitchFlags,X
    BNE Bank1_Label_AF7B
    LDA a:AudioChannelBaseVolumes,X
    STA a:AudioChannelEnvelopeVolumes,X

Bank1_Label_AF7B:
    LDX a:AudioChannelIndex
    LDA a:AudioChannelNotes,X
    STA a:AudioChannelDurations,X
    RTS

World2_MusicCommand_EndChannel:
    LDX a:AudioChannelIndex
    LDA #$01
    STA a:AudioChannelDurations,X
    TXA
    ASL A
    TAX
    LDA AudioStreamPointers,X
    BNE Bank1_Label_AF96
    DEC AudioStreamPointers+$01,X

Bank1_Label_AF96:
    DEC AudioStreamPointers,X
    INC a:AudioEndedChannelCount
    RTS

World2_MusicCommand_BeginCountedLoop:
    JSR World2_Audio_ReadStreamByte
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
    JMP World2_Music_UpdateChannelStream

World2_MusicCommand_SelectLoopExit:
    JSR World2_Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    CMP a:AudioLoopIterationCounts,X
    BCS Bank1_Label_AFD2
    TXA
    ASL A
    TAX
    LDA a:AudioLoopExitPointers,X
    STA AudioStreamPointers,X
    LDA a:AudioLoopExitPointers+$01,X
    STA AudioStreamPointers+$01,X

Bank1_Label_AFD2:
    JMP World2_Music_UpdateChannelStream

World2_MusicCommand_RepeatCountedLoop:
    LDX a:AudioChannelIndex
    LDA a:AudioLoopIterationCounts,X
    CMP a:AudioLoopRepeatLimits,X
    BCS Bank1_Label_AFFA
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

Bank1_Label_AFFA:
    JMP World2_Music_UpdateChannelStream

World2_MusicCommand_EnableFixedPitch:
    JSR World2_Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    STA a:AudioChannelFixedPitches,X
    LDA a:AudioChannelBaseVolumes,X
    STA a:AudioChannelEnvelopeVolumes,X
    LDA #$FF
    STA a:AudioChannelFixedPitchFlags,X
    BNE Bank1_Label_B045

World2_MusicCommand_DisableFixedPitch:
    LDX a:AudioChannelIndex
    LDA #$00
    STA a:AudioChannelFixedPitchFlags,X
    LDA a:AudioChannelControl,X
    AND #$CF
    STA a:AudioChannelControl,X

Bank1_Label_B023:
    JMP Bank1_Label_AE5A

World2_MusicCommand_SetDutyCycle:
    JSR World2_Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    CPX #$02
    BEQ Bank1_Label_AFD2
    AND #$C0
    STA a:AudioWorkByte
    LDA a:AudioChannelControl,X
    AND #$10
    ORA a:AudioWorkByte
    STA a:AudioChannelControl,X
    LDA a:AudioChannelFixedPitchFlags,X
    BEQ Bank1_Label_B023

Bank1_Label_B045:
    LDA a:AudioChannelFixedPitches,X
    JMP Bank1_Label_AE60

World2_MusicCommand_SaveStreamPosition:
    JSR World2_Music_SaveStreamPosition
    JMP World2_Music_UpdateChannelStream

World2_Music_SaveStreamPosition:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA AudioStreamPointers,X
    STA a:AudioStreamHeaderPointers,X
    LDA AudioStreamPointers+$01,X
    STA a:AudioStreamHeaderPointers+$01,X
    RTS

World2_MusicCommand_RestoreStreamPosition:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA a:AudioStreamHeaderPointers,X
    STA AudioStreamPointers,X
    LDA a:AudioStreamHeaderPointers+$01,X
    STA AudioStreamPointers+$01,X
    JMP World2_Music_UpdateChannelStream

World2_MusicCommand_SelectTrackChannelStream:
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
    LDA a:$B2E3,Y
    STA AudioStreamPointers,X
    LDA a:$B2E4,Y
    STA AudioStreamPointers+$01,X
    JMP World2_Music_UpdateChannelStream

World2_MusicCommand_CallStream:
    JSR World2_Audio_ReadStreamByte
    PHA
    JSR World2_Audio_ReadStreamByte
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
    JMP World2_Music_UpdateChannelStream

World2_MusicCommand_ReturnFromStream:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA a:AudioStreamCallReturnPointers,X
    STA AudioStreamPointers,X
    LDA a:AudioStreamCallReturnPointers+$01,X
    STA AudioStreamPointers+$01,X
    JMP World2_Music_UpdateChannelStream

World2_MusicCommand_SetChannelPitchOffset:
    JSR World2_Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    CPX #$03
    BEQ Bank1_Label_B0D2
    STA a:AudioChannelPitchOffsets,X

Bank1_Label_B0D2:
    JMP World2_Music_UpdateChannelStream

World2_MusicCommand_SetGlobalPitchOffset:
    JSR World2_Audio_ReadStreamByte
    LDX #$02

Bank1_Label_B0DA:
    STA $B5,X
    DEX
    BPL Bank1_Label_B0DA
    JMP World2_Music_UpdateChannelStream

World2_MusicCommand_ResetLengthBits:
    LDX a:AudioChannelIndex
    LDA #$08
    JMP Bank1_Label_AED3

World2_MusicCommand_SetEnvelopeVolume:
    JSR World2_Audio_ReadStreamByte
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
    JMP World2_Music_UpdateChannelStream

World2_Audio_ReadStreamByte:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA (AudioStreamPointers,X)
    INC AudioStreamPointers,X
    BNE Bank1_Label_B11A
    INC AudioStreamPointers+$01,X

Bank1_Label_B11A:
    RTS
