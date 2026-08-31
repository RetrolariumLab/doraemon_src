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

World2_MusicCommand_F0:
    JSR World2_Audio_ReadStreamByte

Bank1_Label_AE4F:
    LDX a:AudioChannelIndex
    STA a:AudioChannelNotes,X
    LDA a:$02EF,X
    BNE Bank1_Label_AED6

Bank1_Label_AE5A:
    LDX a:AudioChannelIndex
    LDA a:AudioChannelNotes,X

Bank1_Label_AE60:
    STA a:AudioWorkByte
    LDX a:AudioChannelIndex
    CPX #$02
    BEQ Bank1_Label_AED9
    LDA a:$02F3,X
    AND #$10
    BNE Bank1_Label_AE8C
    LDA a:$02F3,X
    AND #$D0
    STA a:$02F3,X
    LDA a:AudioWorkByte
    LSR A
    CMP #$10
    BCC Bank1_Label_AE83
    LDA #$0F

Bank1_Label_AE83:
    ORA a:$02F3,X
    STA a:$02F3,X
    JMP Bank1_Label_AE97

Bank1_Label_AE8C:
    LDY a:AudioWorkByte
    LDA a:$B1E3,Y
    ORA #$80
    STA a:$02BC,X

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
    STA a:$02F7,X
    LDA a:$02F3,X
    AND #$10
    BEQ Bank1_Label_AED6
    LDA a:$02F7,X
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
    STA a:$02F7,X

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
    STA a:$02F5
    JMP Bank1_Label_AED6

Bank1_Func_AEEC:
    CMP #$00
    BNE Bank1_Label_AEF3
    JMP Bank1_Label_AF7B

Bank1_Label_AEF3:
    LDX a:AudioChannelIndex
    CPX #$03
    BNE Bank1_Label_AF37
    PHA
    AND #$0F
    STA a:$02FC
    PLA
    LSR A
    LSR A
    LSR A
    LSR A
    STA a:$02FB

Bank1_Label_AF08:
    DEC a:$02FC
    LDA a:$02A6
    BNE Bank1_Label_AF7B
    LDA a:$02FB
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
    LDA a:$02F6
    AND #$10
    BEQ Bank1_Label_AF6D
    LDA a:$02F6
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
    LDA a:$02F3,X
    STA a:APU_PL1_VOL,Y
    LDA #$00
    STA a:APU_PL1_SWEEP,Y
    LDA a:AudioWorkByte
    CLC
    ADC a:$B1AF,X
    CLC
    ADC $B5,X
    CLC
    ADC a:$02EC,X
    ASL A
    TAX
    LDA a:$B11B,X
    STA a:APU_PL1_LO,Y
    LDA a:$B11C,X
    LDX a:AudioChannelIndex
    ORA a:$02F7,X
    STA a:APU_PL1_HI,Y

Bank1_Label_AF6D:
    LDX a:AudioChannelIndex
    LDA a:$02EF,X
    BNE Bank1_Label_AF7B
    LDA a:$02B4,X
    STA a:$02B8,X

Bank1_Label_AF7B:
    LDX a:AudioChannelIndex
    LDA a:AudioChannelNotes,X
    STA a:AudioChannelDurations,X
    RTS

World2_MusicCommand_FF:
    LDX a:AudioChannelIndex
    LDA #$01
    STA a:AudioChannelDurations,X
    TXA
    ASL A
    TAX
    LDA $2F,X
    BNE Bank1_Label_AF96
    DEC $30,X

Bank1_Label_AF96:
    DEC $2F,X
    INC a:AudioEndedChannelCount
    RTS

World2_MusicCommand_FD:
    JSR World2_Audio_ReadStreamByte
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
    JMP World2_Music_UpdateChannelStream

World2_MusicCommand_FB:
    JSR World2_Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    CMP a:$02D8,X
    BCS Bank1_Label_AFD2
    TXA
    ASL A
    TAX
    LDA a:$02CC,X
    STA $2F,X
    LDA a:$02CD,X
    STA $30,X

Bank1_Label_AFD2:
    JMP World2_Music_UpdateChannelStream

World2_MusicCommand_FC:
    LDX a:AudioChannelIndex
    LDA a:$02D8,X
    CMP a:$02D4,X
    BCS Bank1_Label_AFFA
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

Bank1_Label_AFFA:
    JMP World2_Music_UpdateChannelStream

World2_MusicCommand_FA:
    JSR World2_Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    STA a:$02C0,X
    LDA a:$02B4,X
    STA a:$02B8,X
    LDA #$FF
    STA a:$02EF,X
    BNE Bank1_Label_B045

World2_MusicCommand_F9:
    LDX a:AudioChannelIndex
    LDA #$00
    STA a:$02EF,X
    LDA a:$02F3,X
    AND #$CF
    STA a:$02F3,X

Bank1_Label_B023:
    JMP Bank1_Label_AE5A

World2_MusicCommand_F8:
    JSR World2_Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    CPX #$02
    BEQ Bank1_Label_AFD2
    AND #$C0
    STA a:AudioWorkByte
    LDA a:$02F3,X
    AND #$10
    ORA a:AudioWorkByte
    STA a:$02F3,X
    LDA a:$02EF,X
    BEQ Bank1_Label_B023

Bank1_Label_B045:
    LDA a:$02C0,X
    JMP Bank1_Label_AE60

World2_MusicCommand_F7:
    JSR Bank1_Func_B051
    JMP World2_Music_UpdateChannelStream

Bank1_Func_B051:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA $2F,X
    STA a:AudioStreamHeaderPointers,X
    LDA $30,X
    STA a:$02DD,X
    RTS

World2_MusicCommand_FE:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA a:AudioStreamHeaderPointers,X
    STA $2F,X
    LDA a:$02DD,X
    STA $30,X
    JMP World2_Music_UpdateChannelStream

World2_MusicCommand_F1:
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
    STA $2F,X
    LDA a:$B2E4,Y
    STA $30,X
    JMP World2_Music_UpdateChannelStream

World2_MusicCommand_F6:
    JSR World2_Audio_ReadStreamByte
    PHA
    JSR World2_Audio_ReadStreamByte
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
    JMP World2_Music_UpdateChannelStream

World2_MusicCommand_F3:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA a:$02E4,X
    STA $2F,X
    LDA a:$02E5,X
    STA $30,X
    JMP World2_Music_UpdateChannelStream

World2_MusicCommand_F4:
    JSR World2_Audio_ReadStreamByte
    LDX a:AudioChannelIndex
    CPX #$03
    BEQ Bank1_Label_B0D2
    STA a:$02EC,X

Bank1_Label_B0D2:
    JMP World2_Music_UpdateChannelStream

World2_MusicCommand_F5:
    JSR World2_Audio_ReadStreamByte
    LDX #$02

Bank1_Label_B0DA:
    STA $B5,X
    DEX
    BPL Bank1_Label_B0DA
    JMP World2_Music_UpdateChannelStream

World2_MusicCommand_F2:
    LDX a:AudioChannelIndex
    LDA #$08
    JMP Bank1_Label_AED3

World2_MusicCommand_EF:
    JSR World2_Audio_ReadStreamByte
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
    JMP World2_Music_UpdateChannelStream

World2_Audio_ReadStreamByte:
    LDA a:AudioChannelIndex
    ASL A
    TAX
    LDA ($2F,X)
    INC $2F,X
    BNE Bank1_Label_B11A
    INC $30,X

Bank1_Label_B11A:
    RTS
