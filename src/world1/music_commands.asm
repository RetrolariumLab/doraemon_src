; Doraemon PRG bank 0 $EB65-$EE33
; World 1 music command handlers and stream reader
; Generated deterministically from pinned Ghidra/GhidraNes facts

World1_MusicCommand_F0:
    JSR World1_Audio_ReadStreamByte

Bank0_Label_EB68:
    LDX a:AudioChannelIndex
    STA a:AudioChannelNotes,X
    LDA a:$02EF,X
    BNE Bank0_Label_EBEF

Bank0_Label_EB73:
    LDX a:AudioChannelIndex
    LDA a:AudioChannelNotes,X

Bank0_Label_EB79:
    STA a:AudioWorkByte
    LDX a:AudioChannelIndex
    CPX #$02
    BEQ Bank0_Label_EBF2
    LDA a:$02F3,X
    AND #$10
    BNE Bank0_Label_EBA5
    LDA a:$02F3,X
    AND #$D0
    STA a:$02F3,X
    LDA a:AudioWorkByte
    LSR A
    CMP #$10
    BCC Bank0_Label_EB9C
    LDA #$0F

Bank0_Label_EB9C:
    ORA a:$02F3,X
    STA a:$02F3,X
    JMP Bank0_Label_EBB0

Bank0_Label_EBA5:
    LDY a:AudioWorkByte
    LDA a:$EEFB,Y
    ORA #$80
    STA a:$02BC,X

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
    STA a:$02F7,X
    LDA a:$02F3,X
    AND #$10
    BEQ Bank0_Label_EBEF
    LDA a:$02F7,X
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
    STA a:$02F7,X

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
    STA a:$02F5
    JMP Bank0_Label_EBEF

Bank0_Func_EC05:
    CMP #$00
    BNE Bank0_Label_EC0C
    JMP Bank0_Label_EC94

Bank0_Label_EC0C:
    LDX a:AudioChannelIndex
    CPX #$03
    BNE Bank0_Label_EC50
    PHA
    AND #$0F
    STA a:$02FC
    PLA
    LSR A
    LSR A
    LSR A
    LSR A
    STA a:$02FB

Bank0_Label_EC21:
    DEC a:$02FC
    LDA a:$02A6
    BNE Bank0_Label_EC94
    LDA a:$02FB
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
    LDA a:$02F6
    AND #$10
    BEQ Bank0_Label_EC86
    LDA a:$02F6
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
    LDA a:$02F3,X
    STA a:APU_PL1_VOL,Y
    LDA #$00
    STA a:APU_PL1_SWEEP,Y
    LDA a:AudioWorkByte
    CLC
    ADC a:$EEC8,X
    CLC
    ADC $3E,X
    CLC
    ADC a:$02EC,X
    ASL A
    TAX
    LDA a:$EE34,X
    STA a:APU_PL1_LO,Y
    LDA a:$EE35,X
    LDX a:AudioChannelIndex
    ORA a:$02F7,X
    STA a:APU_PL1_HI,Y

Bank0_Label_EC86:
    LDX a:AudioChannelIndex
    LDA a:$02EF,X
    BNE Bank0_Label_EC94
    LDA a:$02B4,X
    STA a:$02B8,X

Bank0_Label_EC94:
    LDX a:AudioChannelIndex
    LDA a:AudioChannelNotes,X
    STA a:AudioChannelDurations,X
    RTS

World1_MusicCommand_FF:
    LDX a:AudioChannelIndex
    LDA #$01
    STA a:AudioChannelDurations,X
    TXA
    ASL A
    TAX
    LDA $2F,X
    BNE Bank0_Label_ECAF
    DEC $30,X

Bank0_Label_ECAF:
    DEC $2F,X
    INC a:AudioEndedChannelCount
    RTS

World1_MusicCommand_FD:
    JSR World1_Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    STA a:$02D4,X
    LDA #$01
    STA a:$02D8,X
    TXA
    ASL A
    TAX
    LDA $2F,X
    STA a:$02C4,X
    LDA $30,X
    STA a:$02C5,X
    JMP World1_Music_UpdateChannelStream

World1_MusicCommand_FB:
    JSR World1_Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    CMP a:$02D8,X
    BCS Bank0_Label_ECEB
    TXA
    ASL A
    TAX
    LDA a:$02CC,X
    STA $2F,X
    LDA a:$02CD,X
    STA $30,X

Bank0_Label_ECEB:
    JMP World1_Music_UpdateChannelStream

World1_MusicCommand_FC:
    LDX a:AudioChannelIndex
    LDA a:$02D8,X
    CMP a:$02D4,X
    BCS Bank0_Label_ED13
    INC a:$02D8,X
    TXA
    ASL A
    TAX
    LDA $2F,X
    STA a:$02CC,X
    LDA $30,X
    STA a:$02CD,X
    LDA a:$02C4,X
    STA $2F,X
    LDA a:$02C5,X
    STA $30,X

Bank0_Label_ED13:
    JMP World1_Music_UpdateChannelStream

World1_MusicCommand_FA:
    JSR World1_Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    STA a:$02C0,X
    LDA a:$02B4,X
    STA a:$02B8,X
    LDA #$FF
    STA a:$02EF,X
    BNE Bank0_Label_ED5E

World1_MusicCommand_F9:
    LDX a:AudioChannelIndex
    LDA #$00
    STA a:$02EF,X
    LDA a:$02F3,X
    AND #$CF
    STA a:$02F3,X

Bank0_Label_ED3C:
    JMP Bank0_Label_EB73

World1_MusicCommand_F8:
    JSR World1_Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    CPX #$02
    BEQ Bank0_Label_ECEB
    AND #$C0
    STA a:AudioWorkByte
    LDA a:$02F3,X
    AND #$10
    ORA a:AudioWorkByte
    STA a:$02F3,X
    LDA a:$02EF,X
    BEQ Bank0_Label_ED3C

Bank0_Label_ED5E:
    LDA a:$02C0,X
    JMP Bank0_Label_EB79

World1_MusicCommand_F7:
    JSR Bank0_Func_ED6A
    JMP World1_Music_UpdateChannelStream

Bank0_Func_ED6A:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA $2F,X
    STA a:AudioStreamHeaderPointers,X
    LDA $30,X
    STA a:$02DD,X
    RTS

World1_MusicCommand_FE:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA a:AudioStreamHeaderPointers,X
    STA $2F,X
    LDA a:$02DD,X
    STA $30,X
    JMP World1_Music_UpdateChannelStream

World1_MusicCommand_F1:
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
    STA $2F,X
    LDA a:$EFFC,Y
    STA $30,X
    JMP World1_Music_UpdateChannelStream

World1_MusicCommand_F6:
    JSR World1_Audio_ReadStreamByte
    PHA
    JSR World1_Audio_ReadStreamByte
    PHA
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA $2F,X
    STA a:$02E4,X
    LDA $30,X
    STA a:$02E5,X
    PLA
    STA $30,X
    PLA
    STA $2F,X
    JMP World1_Music_UpdateChannelStream

World1_MusicCommand_F3:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA a:$02E4,X
    STA $2F,X
    LDA a:$02E5,X
    STA $30,X
    JMP World1_Music_UpdateChannelStream

World1_MusicCommand_F4:
    JSR World1_Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    CPX #$03
    BEQ Bank0_Label_EDEB
    STA a:$02EC,X

Bank0_Label_EDEB:
    JMP World1_Music_UpdateChannelStream

World1_MusicCommand_F5:
    JSR World1_Audio_ReadStreamByte
    LDX #$02

Bank0_Label_EDF3:
    STA $3E,X
    DEX
    BPL Bank0_Label_EDF3
    JMP World1_Music_UpdateChannelStream

World1_MusicCommand_F2:
    LDX a:AudioChannelIndex
    LDA #$08
    JMP Bank0_Label_EBEC

World1_MusicCommand_EF:
    JSR World1_Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    STA a:$02B4,X
    STA a:$02B8,X
    LSR A
    LSR A
    LSR A
    LSR A
    STA a:AudioWorkByte
    LDA a:$02F3,X
    AND #$C0
    ORA #$10
    ORA a:AudioWorkByte
    STA a:$02F3,X
    JMP World1_Music_UpdateChannelStream

World1_Audio_ReadStreamByte:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA ($2F,X)
    INC $2F,X
    BNE Bank0_Label_EE33
    INC $30,X

Bank0_Label_EE33:
    RTS
