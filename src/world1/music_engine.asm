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
    STA $2F,X
    STA a:AudioStreamHeaderPointers,X
    DEY
    DEX
    BPL Bank0_Label_EA21
    STX a:$02B4
    STX a:$02B5
    STX a:$02B6
    STX a:$02B7
    INX
    STX $3E
    STX $3F
    STX $40
    STX a:$02EC
    STX a:$02ED
    STX a:$02EE
    STX a:$02EF
    STX a:$02F0
    STX a:$02F1
    STX a:$02F2
    STX a:$02FC
    STX a:$02F6
    INX
    STX a:AudioChannelDurations
    STX a:$02B1
    STX a:$02B2
    STX a:$02B3
    STX a:AudioChannelNotes
    STX a:$02AD
    STX a:$02AE
    STX a:$02AF
    LDA #$08
    STA a:$02F7
    STA a:$02F8
    STA a:$02F9
    STA a:$02FA
    LDA #$80
    STA a:$02F3
    STA a:$02F4
    STA a:$02F5
    JSR World1_Audio_ResetChannels

Bank0_Label_EA90:
    LDA #$00
    STA a:AudioEndedChannelCount
    STA a:AudioChannelIndex

Bank0_Label_EA98:
    LDX a:AudioChannelIndex
    DEC a:AudioChannelDurations,X
    BEQ Bank0_Label_EAA6
    JSR Bank0_Func_EAC0
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

Bank0_Func_EAC0:
    CPX #$02
    BEQ Bank0_Label_EB0B
    LDA a:$02F3,X
    AND #$10
    BEQ Bank0_Label_EB0B
    LDA a:$02BC,X
    ASL A
    STA a:AudioWorkByte
    BCC Bank0_Label_EADF
    LDA a:$02B8,X
    SEC
    SBC a:AudioWorkByte
    BCS Bank0_Label_EAEA
    BCC Bank0_Label_EAE8

Bank0_Label_EADF:
    LDA a:$02B8,X
    CLC
    ADC a:AudioWorkByte
    BCC Bank0_Label_EAEA

Bank0_Label_EAE8:
    LDA #$00

Bank0_Label_EAEA:
    STA a:$02B8,X
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
    LDA a:$02F3,X
    AND #$D0
    ORA a:AudioWorkByte
    STA a:$02F3,X
    STA a:APU_PL1_VOL,Y

Bank0_Label_EB0B:
    RTS

World1_Music_UpdateChannelStream:
    LDX a:AudioChannelIndex
    CPX #$03
    BNE Bank0_Label_EB1B
    LDA a:$02FC
    BEQ Bank0_Label_EB1B
    JMP Bank0_Label_EC21

Bank0_Label_EB1B:
    JSR World1_Audio_ReadStreamByte
    STA a:AudioWorkByte
    TAY
    BMI Bank0_Label_EB27
    JMP Bank0_Func_EC05

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
