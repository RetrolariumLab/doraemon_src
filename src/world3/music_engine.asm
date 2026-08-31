; Doraemon PRG bank 2 $C4F5-$C633
; World 3 four-channel music sequencer and stream interpreter
; Generated deterministically from pinned Ghidra/GhidraNes facts

World3_Audio_UpdateMusic:
    LDA a:$02AB
    BNE Bank2_Label_C4C1
    LDA a:$02AA
    BEQ Bank2_Label_C4E6
    BPL Bank2_Label_C504
    JMP Bank2_Label_C588

Bank2_Label_C504:
    LDA a:$02AA
    CMP #$09
    BCC Bank2_Label_C50E
    JMP Bank2_Label_C5B2

Bank2_Label_C50E:
    ORA #$80
    STA a:$02AA
    ASL A
    ASL A
    ASL A
    TAY
    LDX #$07

Bank2_Label_C519:
    LDA a:$CAF2,Y
    STA $2F,X
    STA a:$02DC,X
    DEY
    DEX
    BPL Bank2_Label_C519
    STX a:$02B4
    STX a:$02B5
    STX a:$02B6
    STX a:$02B7
    INX
    STX $D3
    STX $D4
    STX $D5
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
    STX a:$02B0
    STX a:$02B1
    STX a:$02B2
    STX a:$02B3
    STX a:$02AC
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
    JSR World3_Audio_ResetChannels

Bank2_Label_C588:
    LDA #$00
    STA a:$02FE
    STA a:$02FD

Bank2_Label_C590:
    LDX a:$02FD
    DEC a:$02B0,X
    BEQ Bank2_Label_C59E
    JSR Bank2_Func_C5B8
    JMP Bank2_Label_C5A1

Bank2_Label_C59E:
    JSR World3_Music_UpdateChannelStream

Bank2_Label_C5A1:
    INC a:$02FD
    LDA a:$02FD
    CMP #$04
    BCC Bank2_Label_C590
    LDA a:$02FE
    CMP #$04
    BNE Bank2_Label_C5B7

Bank2_Label_C5B2:
    LDA #$00
    STA a:$02AA

Bank2_Label_C5B7:
    RTS

Bank2_Func_C5B8:
    CPX #$02
    BEQ Bank2_Label_C603
    LDA a:$02F3,X
    AND #$10
    BEQ Bank2_Label_C603
    LDA a:$02BC,X
    ASL A
    STA a:$02FF
    BCC Bank2_Label_C5D7
    LDA a:$02B8,X
    SEC
    SBC a:$02FF
    BCS Bank2_Label_C5E2
    BCC Bank2_Label_C5E0

Bank2_Label_C5D7:
    LDA a:$02B8,X
    CLC
    ADC a:$02FF
    BCC Bank2_Label_C5E2

Bank2_Label_C5E0:
    LDA #$00

Bank2_Label_C5E2:
    STA a:$02B8,X
    LDY a:$02A3,X
    BNE Bank2_Label_C603
    LSR A
    LSR A
    LSR A
    LSR A
    STA a:$02FF
    TXA
    ASL A
    ASL A
    TAY
    LDA a:$02F3,X
    AND #$D0
    ORA a:$02FF
    STA a:$02F3,X
    STA a:$4000,Y

Bank2_Label_C603:
    RTS

World3_Music_UpdateChannelStream:
    LDX a:$02FD
    CPX #$03
    BNE Bank2_Label_C613
    LDA a:$02FC
    BEQ Bank2_Label_C613
    JMP Bank2_Label_C719

Bank2_Label_C613:
    JSR World3_Audio_ReadStreamByte
    STA a:$02FF
    TAY
    BMI Bank2_Label_C61F
    JMP Bank2_Func_C6FD

Bank2_Label_C61F:
    CMP #$EF
    BCC Bank2_Label_C656
    SEC
    LDA #$FF
    SBC a:$02FF
    ASL A
    TAY
    LDA a:$C635,Y
    PHA
    LDA a:$C634,Y
    PHA
    RTS
