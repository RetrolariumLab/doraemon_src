; Doraemon PRG bank 2 $AE12-$B1BA
; World 3 completion sequence, transition loop, and support routines
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank2_Func_AE12:
    JSR Bank2_Func_A1F4
    LDA #$00
    STA $00
    LDA #$00
    STA $01
    LDA #$08
    STA $02
    LDA #$07
    STA a:$02AA
    LDA #$00
    STA a:$02AB

Bank2_Label_AE2B:
    LDX #$7F
    TXS
    LDA #$00
    STA $68
    LDA #$00
    STA $74
    JSR Bank2_Func_A601
    JSR Bank2_Func_9D19
    JSR Bank2_Func_AE5D
    LDA #$01
    STA $14
    LDA #$01
    STA $68
    JSR Bank2_Func_B1BB
    LDA $02
    BNE Bank2_Label_AE2B

Bank2_Label_AE4E:
    LDA a:$02AA
    BMI Bank2_Label_AE4E
    LDA #$5A
    STA $68
    JSR Bank2_Func_B1BB
    JMP Bank2_Func_8077

Bank2_Func_AE5D:
    LDA $02
    BEQ Bank2_Label_AEBF
    LDX #$00
    LDY $01
    JSR Bank2_Func_B0BA
    LDA #$00
    STA $72
    LDX #$F2
    LDY #$AE
    LDA #$20
    JSR Bank2_Func_B33A
    LDX #$00
    LDA #$1D
    SEC
    SBC $01
    TAY
    JSR Bank2_Func_B0BA
    LDA #$00
    STA $72
    LDX #$F2
    LDY #$AE
    LDA #$20
    JSR Bank2_Func_B33A
    LDX $00
    LDY #$00
    JSR Bank2_Func_B0BA
    LDA #$01
    STA $72
    LDX #$12
    LDY #$AF
    LDA #$1E
    JSR Bank2_Func_B33A
    LDA #$1F
    SEC
    SBC $00
    TAX
    LDY #$00
    JSR Bank2_Func_B0BA
    LDA #$01
    STA $72
    LDX #$12
    LDY #$AF
    LDA #$1E
    JSR Bank2_Func_B33A
    INC $00
    INC $01
    DEC $02

Bank2_Label_AEBF:
    LDA #$6C
    STA $8C
    LDA #$78
    STA $8D
    LDA #$0D
    STA $90
    LDA #$00
    STA $91
    LDY #$00

Bank2_Label_AED1:
    LDA a:$0600,Y
    CMP #$01
    BNE Bank2_Label_AEEC
    LDA a:$0638,Y
    CMP #$1F
    BNE Bank2_Label_AEE7
    LDA #$00
    STA a:$06A0,Y
    JMP Bank2_Label_AEEC

Bank2_Label_AEE7:
    LDA #$00
    STA a:$0600,Y

Bank2_Label_AEEC:
    INY
    CPY #$08
    BNE Bank2_Label_AED1
    RTS
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Bank2_Func_AF30:
    LDA $DF
    CMP #$3F
    BNE Bank2_Label_AF50
    INC $50
    LDA $50
    AND #$10
    BNE Bank2_Label_AF50
    LDX #$70
    LDY #$74
    JSR Bank2_Func_A71A
    LDA #$00
    STA $7A
    LDA #$AC
    STA $79
    JSR Bank2_Func_B4B6

Bank2_Label_AF50:
    RTS

Bank2_Func_AF51:
    PHA
    JSR Bank2_Func_B25B
    PLA
    ORA #$30
    STA a:$0301
    LDA #$80
    STA a:$0300
    STA a:$0303
    LDA #$00
    STA a:$0302
    LDA #$01
    STA $14

Bank2_Label_AF6C:
    JMP Bank2_Label_AF6C

Bank2_Func_AF6F:
    JSR Bank2_Func_80DA
    LDA #$90
    STA $19
    LDA #$02
    JSR Bank2_Func_81AA
    JSR Bank2_Func_B276
    LDX #$EE
    LDY #$BD
    STX $00
    STY $01
    JSR Bank2_Func_B29F
    LDA #$00
    STA $00
    JSR Bank2_Func_B2D4
    LDA #$00
    STA $00
    JSR Bank2_Func_B2FD
    JSR Bank2_Func_B25B
    JSR Bank2_Func_80FD
    JSR Bank2_Func_B286
    LDX #$C6
    LDY #$AF
    STX $00
    STY $01
    LDX #$00
    LDY #$03
    STX $02
    STY $03
    LDA #$20
    STA $04
    JSR Bank2_Func_B1F1
    LDA #$01
    STA $14
    LDA #$07
    STA a:$02AA
    LDA #$00
    STA a:$02AB
    RTS
    .byte $58, $EE, $00, $78, $58, $EF, $00, $80, $60, $FE, $00, $78, $60, $FF, $00, $80
    .byte $68, $2E, $00, $78, $68, $2F, $00, $80, $70, $E5, $00, $78, $70, $F5, $00, $80

Bank2_Func_AFE6:
    JSR World3_Audio_UpdateEffects
    JSR World3_Audio_UpdateMusic
    RTS

Bank2_Func_AFED:
    LDA $67
    BNE Bank2_Label_B008
    JSR Bank2_Func_B00D
    JSR Bank2_Func_B07D
    JSR Bank2_Func_B08E
    LDA $14
    BEQ Bank2_Label_B008
    LDA #$00
    STA $14
    JSR Bank2_Func_B25B
    JSR Bank2_Func_86BB

Bank2_Label_B008:
    DEC $68
    INC $E1
    RTS

Bank2_Func_B00D:
    LDX $6B
    LDA #$01
    STA $6D
    LDA #$00
    STA $6E

Bank2_Label_B017:
    CPX $6C
    BEQ Bank2_Label_B057
    LDY #$00
    LDA a:$0500,X
    BPL Bank2_Label_B024
    LDY #$04

Bank2_Label_B024:
    AND #$7F
    STA a:$2006
    INX
    LDA a:$0500,X
    STA a:$2006
    INX
    TYA
    ORA $19
    ORA $71
    STA a:$2000
    LDA a:$0500,X
    TAY
    INX
    CLC
    ADC $6E
    STA $6E

Bank2_Label_B043:
    LDA a:$0500,X
    STA a:$2007
    INX
    DEY
    BNE Bank2_Label_B043
    DEC $6D
    BEQ Bank2_Label_B057
    LDA $6E
    CMP #$30
    BCC Bank2_Label_B017

Bank2_Label_B057:
    STX $6B
    RTS

Bank2_Func_B05A:
    LDA $67
    BEQ Bank2_Label_B061
    JSR Bank2_Func_B00D

Bank2_Label_B061:
    RTS

Bank2_Func_B062:
    PHA

Bank2_Label_B063:
    LDA $6C
    CMP $6B
    BNE Bank2_Label_B063
    PLA
    RTS

Bank2_Func_B06B:
    PHA

Bank2_Label_B06C:
    LDA $6C
    CMP $6B
    BEQ Bank2_Label_B07B
    LDA $6B
    SEC
    SBC $6C
    CMP #$24
    BCC Bank2_Label_B06C

Bank2_Label_B07B:
    PLA
    RTS

Bank2_Func_B07D:
    LDA #$3F
    STA a:$2006
    LDA #$00
    STA a:$2006
    STA a:$2006
    STA a:$2006
    RTS

Bank2_Func_B08E:
    LDA $6F
    STA a:$2005
    LDA $70
    STA a:$2005
    LDA $19
    AND #$FC
    ORA $71
    STA $19
    STA a:$2000
    RTS

Bank2_Func_B0A4:
    LDA #$00
    STA a:$2003
    LDA #$03
    STA a:$4014
    RTS

Bank2_Func_B0AF:
    LDA a:$2002
    BMI Bank2_Func_B0AF

Bank2_Label_B0B4:
    LDA a:$2002
    BPL Bank2_Label_B0B4
    RTS

Bank2_Func_B0BA:
    LDA #$20
    STA $6A
    CPX #$20
    BCC Bank2_Label_B0CB
    TXA
    SEC
    SBC #$20
    TAX
    LDA #$24
    STA $6A

Bank2_Label_B0CB:
    CPY #$1E
    BCC Bank2_Label_B0D8
    TYA
    SEC
    SBC #$1E
    TAY
    LDA #$24
    STA $6A

Bank2_Label_B0D8:
    LDA #$00
    STA $69
    TYA
    LSR A
    ROR $69
    LSR A
    ROR $69
    LSR A
    ROR $69
    CLC
    ADC $6A
    STA $6A
    TXA
    CLC
    ADC $69
    STA $69
    LDA $6A
    ADC #$00
    STA $6A
    RTS

Bank2_Func_B0F8:
    LDA #$23
    STA $6A
    LDA #$00
    STA $41
    CPX #$20
    BCC Bank2_Label_B111
    TXA
    SEC
    SBC #$20
    TAX
    LDA #$27
    STA $6A
    LDA #$40
    STA $41

Bank2_Label_B111:
    CPY #$1E
    BCC Bank2_Label_B122
    TYA
    SEC
    SBC #$1E
    TAY
    LDA #$27
    STA $6A
    LDA #$40
    STA $41

Bank2_Label_B122:
    TYA
    AND #$FC
    ASL A
    STA $40
    TXA
    LSR A
    LSR A
    CLC
    ADC $40
    ORA $41
    STA $41
    ORA #$C0
    STA $69
    RTS
    .byte $C9, $80, $90, $0D, $48, $8A, $49, $FF, $18, $69, $01, $AA, $68, $49, $FF, $69
    .byte $00, $60

Bank2_Func_B149:
    CMP #$80
    BCC Bank2_Label_B152
    EOR #$FF
    CLC
    ADC #$01

Bank2_Label_B152:
    RTS

Bank2_Func_B153:
    INC $D6
    DEC $D7
    BNE Bank2_Label_B15D
    LDA #$75
    STA $D7

Bank2_Label_B15D:
    LDA $D6
    CMP #$77
    BNE Bank2_Label_B167
    LDA #$01
    STA $D6

Bank2_Label_B167:
    EOR $D7
    ASL A
    PHP
    LSR A
    PLP
    ROL A
    ASL A
    PHP
    LSR A
    PLP
    ROL A
    EOR $D8
    SEC
    SBC $D7
    CLC
    ADC $D6
    CLC
    ADC $D6
    STA $D8
    STX $E2
    LDX $E1
    EOR $00,X
    LDX $E2
    RTS
    .byte $E6, $D9, $C6, $DA, $D0, $04, $A9, $75, $85, $DA, $A5, $D9, $C9, $77, $D0, $04
    .byte $A9, $01, $85, $D9, $45, $DA, $0A, $08, $4A, $28, $2A, $0A, $08, $4A, $28, $2A
    .byte $45, $DB, $38, $E5, $DA, $18, $65, $D9, $18, $65, $D9, $85, $DB, $60, $A5, $00
    .byte $85, $68
