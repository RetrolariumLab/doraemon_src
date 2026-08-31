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

World3_MusicCommand_F0:
    JSR World3_Audio_ReadStreamByte

Bank2_Label_C660:
    LDX a:AudioChannelIndex
    STA a:AudioChannelNotes,X
    LDA a:$02EF,X
    BNE Bank2_Label_C6E7

Bank2_Label_C66B:
    LDX a:AudioChannelIndex
    LDA a:AudioChannelNotes,X

Bank2_Label_C671:
    STA a:AudioWorkByte
    LDX a:AudioChannelIndex
    CPX #$02
    BEQ Bank2_Label_C6EA
    LDA a:$02F3,X
    AND #$10
    BNE Bank2_Label_C69D
    LDA a:$02F3,X
    AND #$D0
    STA a:$02F3,X
    LDA a:AudioWorkByte
    LSR A
    CMP #$10
    BCC Bank2_Label_C694
    LDA #$0F

Bank2_Label_C694:
    ORA a:$02F3,X
    STA a:$02F3,X
    JMP Bank2_Label_C6A8

Bank2_Label_C69D:
    LDY a:AudioWorkByte
    LDA a:$C9F3,Y
    ORA #$80
    STA a:$02BC,X

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
    STA a:$02F7,X
    LDA a:$02F3,X
    AND #$10
    BEQ Bank2_Label_C6E7
    LDA a:$02F7,X
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
    STA a:$02F7,X

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
    STA a:$02F5
    JMP Bank2_Label_C6E7

Bank2_Func_C6FD:
    CMP #$00
    BNE Bank2_Label_C704
    JMP Bank2_Label_C78C

Bank2_Label_C704:
    LDX a:AudioChannelIndex
    CPX #$03
    BNE Bank2_Label_C748
    PHA
    AND #$0F
    STA a:$02FC
    PLA
    LSR A
    LSR A
    LSR A
    LSR A
    STA a:$02FB

Bank2_Label_C719:
    DEC a:$02FC
    LDA a:$02A6
    BNE Bank2_Label_C78C
    LDA a:$02FB
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
    LDA a:$02F6
    AND #$10
    BEQ Bank2_Label_C77E
    LDA a:$02F6
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
    LDA a:$02F3,X
    STA a:APU_PL1_VOL,Y
    LDA #$00
    STA a:APU_PL1_SWEEP,Y
    LDA a:AudioWorkByte
    CLC
    ADC a:$C9C0,X
    CLC
    ADC $D3,X
    CLC
    ADC a:$02EC,X
    ASL A
    TAX
    LDA a:$C92C,X
    STA a:APU_PL1_LO,Y
    LDA a:$C92D,X
    LDX a:AudioChannelIndex
    ORA a:$02F7,X
    STA a:APU_PL1_HI,Y

Bank2_Label_C77E:
    LDX a:AudioChannelIndex
    LDA a:$02EF,X
    BNE Bank2_Label_C78C
    LDA a:$02B4,X
    STA a:$02B8,X

Bank2_Label_C78C:
    LDX a:AudioChannelIndex
    LDA a:AudioChannelNotes,X
    STA a:AudioChannelDurations,X
    RTS

World3_MusicCommand_FF:
    LDX a:AudioChannelIndex
    LDA #$01
    STA a:AudioChannelDurations,X
    TXA
    ASL A
    TAX
    LDA $2F,X
    BNE Bank2_Label_C7A7
    DEC $30,X

Bank2_Label_C7A7:
    DEC $2F,X
    INC a:AudioEndedChannelCount
    RTS

World3_MusicCommand_FD:
    JSR World3_Audio_ReadStreamByte
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
    JMP World3_Music_UpdateChannelStream

World3_MusicCommand_FB:
    JSR World3_Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    CMP a:$02D8,X
    BCS Bank2_Label_C7E3
    TXA
    ASL A
    TAX
    LDA a:$02CC,X
    STA $2F,X
    LDA a:$02CD,X
    STA $30,X

Bank2_Label_C7E3:
    JMP World3_Music_UpdateChannelStream

World3_MusicCommand_FC:
    LDX a:AudioChannelIndex
    LDA a:$02D8,X
    CMP a:$02D4,X
    BCS Bank2_Label_C80B
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

Bank2_Label_C80B:
    JMP World3_Music_UpdateChannelStream

World3_MusicCommand_FA:
    JSR World3_Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    STA a:$02C0,X
    LDA a:$02B4,X
    STA a:$02B8,X
    LDA #$FF
    STA a:$02EF,X
    BNE Bank2_Label_C856

World3_MusicCommand_F9:
    LDX a:AudioChannelIndex
    LDA #$00
    STA a:$02EF,X
    LDA a:$02F3,X
    AND #$CF
    STA a:$02F3,X

Bank2_Label_C834:
    JMP Bank2_Label_C66B

World3_MusicCommand_F8:
    JSR World3_Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    CPX #$02
    BEQ Bank2_Label_C7E3
    AND #$C0
    STA a:AudioWorkByte
    LDA a:$02F3,X
    AND #$10
    ORA a:AudioWorkByte
    STA a:$02F3,X
    LDA a:$02EF,X
    BEQ Bank2_Label_C834

Bank2_Label_C856:
    LDA a:$02C0,X
    JMP Bank2_Label_C671

World3_MusicCommand_F7:
    JSR Bank2_Func_C862
    JMP World3_Music_UpdateChannelStream

Bank2_Func_C862:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA $2F,X
    STA a:AudioStreamHeaderPointers,X
    LDA $30,X
    STA a:$02DD,X
    RTS

World3_MusicCommand_FE:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA a:AudioStreamHeaderPointers,X
    STA $2F,X
    LDA a:$02DD,X
    STA $30,X
    JMP World3_Music_UpdateChannelStream

World3_MusicCommand_F1:
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
    STA $2F,X
    LDA a:$CAF4,Y
    STA $30,X
    JMP World3_Music_UpdateChannelStream

World3_MusicCommand_F6:
    JSR World3_Audio_ReadStreamByte
    PHA
    JSR World3_Audio_ReadStreamByte
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
    JMP World3_Music_UpdateChannelStream

World3_MusicCommand_F3:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA a:$02E4,X
    STA $2F,X
    LDA a:$02E5,X
    STA $30,X
    JMP World3_Music_UpdateChannelStream

World3_MusicCommand_F4:
    JSR World3_Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    CPX #$03
    BEQ Bank2_Label_C8E3
    STA a:$02EC,X

Bank2_Label_C8E3:
    JMP World3_Music_UpdateChannelStream

World3_MusicCommand_F5:
    JSR World3_Audio_ReadStreamByte
    LDX #$02

Bank2_Label_C8EB:
    STA $D3,X
    DEX
    BPL Bank2_Label_C8EB
    JMP World3_Music_UpdateChannelStream

World3_MusicCommand_F2:
    LDX a:AudioChannelIndex
    LDA #$08
    JMP Bank2_Label_C6E4

World3_MusicCommand_EF:
    JSR World3_Audio_ReadStreamByte
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
    JMP World3_Music_UpdateChannelStream

World3_Audio_ReadStreamByte:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA ($2F,X)
    INC $2F,X
    BNE Bank2_Label_C92B
    INC $30,X

Bank2_Label_C92B:
    RTS
