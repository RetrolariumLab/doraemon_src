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
    LDA a:$B2E2,Y
    STA $2F,X
    STA a:AudioStreamHeaderPointers,X
    DEY
    DEX
    BPL Bank1_Label_AD08
    STX a:$02B4
    STX a:$02B5
    STX a:$02B6
    STX a:$02B7
    INX
    STX $B5
    STX $B6
    STX $B7
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
    JSR World2_Audio_ResetChannels

Bank1_Label_AD77:
    LDA #$00
    STA a:AudioEndedChannelCount
    STA a:AudioChannelIndex

Bank1_Label_AD7F:
    LDX a:AudioChannelIndex
    DEC a:AudioChannelDurations,X
    BEQ Bank1_Label_AD8D
    JSR Bank1_Func_ADA7
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

Bank1_Func_ADA7:
    CPX #$02
    BEQ Bank1_Label_ADF2
    LDA a:$02F3,X
    AND #$10
    BEQ Bank1_Label_ADF2
    LDA a:$02BC,X
    ASL A
    STA a:AudioWorkByte
    BCC Bank1_Label_ADC6
    LDA a:$02B8,X
    SEC
    SBC a:AudioWorkByte
    BCS Bank1_Label_ADD1
    BCC Bank1_Label_ADCF

Bank1_Label_ADC6:
    LDA a:$02B8,X
    CLC
    ADC a:AudioWorkByte
    BCC Bank1_Label_ADD1

Bank1_Label_ADCF:
    LDA #$00

Bank1_Label_ADD1:
    STA a:$02B8,X
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
    LDA a:$02F3,X
    AND #$D0
    ORA a:AudioWorkByte
    STA a:$02F3,X
    STA a:APU_PL1_VOL,Y

Bank1_Label_ADF2:
    RTS

World2_Music_UpdateChannelStream:
    LDX a:AudioChannelIndex
    CPX #$03
    BNE Bank1_Label_AE02
    LDA a:$02FC
    BEQ Bank1_Label_AE02
    JMP Bank1_Label_AF08

Bank1_Label_AE02:
    JSR World2_Audio_ReadStreamByte
    STA a:AudioWorkByte
    TAY
    BMI Bank1_Label_AE0E
    JMP Bank1_Func_AEEC

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
