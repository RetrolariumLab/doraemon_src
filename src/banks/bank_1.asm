; Address-ordered Doraemon PRG bank 1 preservation listing
; Generated deterministically from pinned Ghidra/GhidraNes facts
; Keep byte-identical through make verify

.segment "PRG1"

Bank1_Func_8000:
    JSR Bank1_Func_80F0
    LDA #$00
    JSR Bank1_Func_81B2
    JMP Bank1_Func_8271

Bank1_Func_800B:
    JSR Bank1_Func_80F0
    LDA #$01
    JSR Bank1_Func_81B2
    JMP Bank1_Func_8271

Bank1_Func_8016:
    JSR Bank1_Func_80F0
    LDA #$02
    JSR Bank1_Func_81B2
    JMP Bank1_Func_8271
    .byte $4C, $74, $82

Bank1_Func_8024:
    JSR Bank1_Func_80F0
    LDA #$00
    JSR Bank1_Func_81B2
    JMP Bank1_Func_8277

Bank1_Func_802F:
    JSR Bank1_Func_80F0
    LDA #$01
    JSR Bank1_Func_81B2
    JMP Bank1_Func_8277

Bank1_Func_803A:
    JSR Bank1_Func_80F0
    LDA #$02
    JSR Bank1_Func_81B2
    JMP Bank1_Func_8277
    .byte $4C, $7A, $82

Bank1_Func_8048:
    JSR Bank1_Func_80F0
    LDA #$03
    JSR Bank1_Func_81B2
    JMP Bank1_Func_8271

Bank1_Func_8053:
    JSR Bank1_Func_80F0
    LDA $17
    PHA
    LDA #$03
    JSR Bank1_Func_81B2
    JSR Bank1_Func_8277
    PLA
    JMP Bank1_Func_81B2

Bank1_Func_8065:
    JSR Bank1_Func_80F0
    LDA $17
    PHA
    LDA #$03
    JSR Bank1_Func_81B2
    JSR Bank1_Func_827D
    PLA
    JMP Bank1_Func_81B2

Bank1_Func_8077:
    JSR Bank1_Func_80F0
    LDA #$03
    JSR Bank1_Func_81B2
    JMP Bank1_Label_8280

Bank1_Func_8082:
    JSR Bank1_Func_80F0
    LDA #$03
    JSR Bank1_Func_81B2
    JMP Bank1_Label_8283

Bank1_Func_808D:
    JSR Bank1_Func_80F0
    LDA #$03
    JSR Bank1_Func_81B2
    JMP Bank1_Func_8286

Bank1_Reset:
    LDX #$7F
    TXS
    LDA #$00
    STA a:$2001
    STA a:$2000
    JSR Bank1_WaitForVblank
    JSR Bank1_WaitForVblank
    LDX #$00
    TXA

Bank1_Label_80AC:
    STA a:$0400,X
    STA a:$0500,X
    STA a:$0600,X
    STA a:$0700,X
    INX
    BNE Bank1_Label_80AC
    LDA #$10
    STA $19
    STA a:$2000
    LDA #$06
    STA $1A
    STA a:$2001
    JSR Bank1_Func_80DA
    JMP Bank1_Func_8048

Bank1_WaitForVblank:
    LDA a:$2002
    BPL Bank1_WaitForVblank

Bank1_Label_80D4:
    LDA a:$2002
    BMI Bank1_Label_80D4
    RTS

Bank1_Func_80DA:
    JSR Bank1_WaitForVblank
    LDA #$00
    STA $14
    LDA $19
    STA a:$2000
    LDA $1A
    AND #$E7
    STA $1A
    STA a:$2001
    RTS

Bank1_Func_80F0:
    JSR Bank1_Func_80DA
    LDA $19
    AND #$7F
    STA $19
    STA a:$2000
    RTS

Bank1_Func_80FD:
    JSR Bank1_Func_8131
    JSR Bank1_WaitForVblank
    LDA #$01
    STA $14
    LDA $1B
    STA a:$2005
    LDA $1C
    STA a:$2005
    LDA $19
    ORA #$80
    STA $19
    STA a:$2000
    LDA #$00
    STA a:$2003
    LDA #$03
    STA a:$4014
    JSR Bank1_WriteMapper
    LDA $1A
    ORA #$18
    STA $1A
    STA a:$2001
    RTS

Bank1_Func_8131:
    LDA #$F0
    LDX #$00

Bank1_Label_8135:
    STA a:$0300,X
    INX
    BNE Bank1_Label_8135
    RTS

Bank1_Nmi:
    PHA
    TXA
    PHA
    TYA
    PHA
    LDA $15
    BNE Bank1_Label_81A2
    INC $15
    LDA $14
    BEQ Bank1_Label_8158
    LDA #$00
    STA a:$2003
    LDA #$03
    STA a:$4014
    JSR Bank1_WriteMapper

Bank1_Label_8158:
    JSR Bank1_Func_8274
    LDA #$01
    STA a:$4016
    LDA #$00
    STA a:$4016
    LDX #$08

Bank1_Label_8167:
    LDA a:$4016
    LSR A
    ROL $1F
    LSR A
    ROL $20
    LDA a:$4017
    LSR A
    ROL $1D
    LSR A
    ROL $1E
    DEX
    BNE Bank1_Label_8167
    LDA $1D
    AND #$CF
    ORA $1F
    ORA $20
    ORA $1E
    STA $21
    LDA a:$4016
    AND #$04
    CMP $23
    BEQ Bank1_Label_8197
    STA $23
    LDA #$14
    STA $24

Bank1_Label_8197:
    LDA $24
    BEQ Bank1_Label_819D
    DEC $24

Bank1_Label_819D:
    JSR Bank1_Func_827A
    DEC $15

Bank1_Label_81A2:
    INC $16
    PLA
    TAY
    PLA
    TAX
    PLA
    RTI

Bank1_Func_81AA:
    ASL A
    ASL A
    AND #$0C
    STA $18
    LDA $17

Bank1_Func_81B2:
    AND #$03
    ORA $18
    STA $17
    JSR Bank1_WaitForVblank

Bank1_WriteMapper:
    LDA $17
    TAX
    LDA a:$8261,X
    STA a:$8261,X
    NOP
    NOP
    NOP
    NOP
    RTS

Bank1_Func_81C9:
    STA $07
    LDA $27
    BNE Bank1_Label_81E5
    TYA
    PHA
    TXA
    PHA
    LDA $07
    LSR A
    LSR A
    LSR A
    LSR A
    TAX
    LDA $07
    AND #$0F
    JSR Bank1_Func_81E6
    PLA
    TAX
    PLA
    TAY

Bank1_Label_81E5:
    RTS

Bank1_Func_81E6:
    CLC
    ADC a:$0298,X
    LDY #$00

Bank1_Label_81EC:
    CMP #$0A
    BCC Bank1_Label_81F6
    SEC
    SBC #$0A
    INY
    BNE Bank1_Label_81EC

Bank1_Label_81F6:
    STA a:$0298,X
    TYA
    BNE Bank1_Label_81FD
    RTS

Bank1_Label_81FD:
    DEX
    BPL Bank1_Func_81E6
    LDA #$09
    LDX #$05

Bank1_Label_8204:
    STA a:$0298,X
    STA a:$0290,X
    DEX
    BPL Bank1_Label_8204
    RTS

Bank1_Func_820E:
    LDA $27
    BNE Bank1_Label_8244
    LDA $25
    CMP #$04
    BEQ Bank1_Label_8233
    ASL A
    ASL A
    TAY
    LDX #$00

Bank1_Label_821D:
    LDA a:$0298,X
    CMP a:$8251,Y
    BCC Bank1_Label_8233
    BNE Bank1_Label_822D
    INX
    INY
    CPX #$04
    BNE Bank1_Label_821D

Bank1_Label_822D:
    INC $2A
    INC $26
    INC $25

Bank1_Label_8233:
    LDX #$00

Bank1_Label_8235:
    LDA a:$0290,X
    CMP a:$0298,X
    BCC Bank1_Label_8245
    BNE Bank1_Label_8244
    INX
    CPX #$06
    BNE Bank1_Label_8235

Bank1_Label_8244:
    RTS

Bank1_Label_8245:
    LDA a:$0298,X
    STA a:$0290,X
    INX
    CPX #$06
    BNE Bank1_Label_8245
    RTS
    .byte $00, $00, $02, $00, $00, $00, $08, $00, $00, $02, $00, $00, $00, $05, $00, $00

Bank1_MapperValueTable:
    .byte $00, $10, $20, $30, $01, $11, $21, $31, $02, $12, $22, $32, $03, $13, $23, $33

Bank1_Func_8271:
    JMP Bank1_World2Main

Bank1_Func_8274:
    JMP Bank1_Func_829F

Bank1_Func_8277:
    JMP Bank1_Func_8891

Bank1_Func_827A:
    JMP Bank1_Func_8704

Bank1_Func_827D:
    JSR Bank1_Func_8747

Bank1_Label_8280:
    LDA $1A

Bank1_Label_8283 = * + 1  ; overlapping entry $8283
    STA a:$2001
    .byte $A9

Bank1_Func_8286:
    BRK
    .byte $8D, $06, $20, $8D, $06, $20, $A5, $3F, $8D, $05, $20, $A5, $40, $8D, $05, $20
    .byte $A5, $19, $8D, $00, $20, $E6, $73, $60

Bank1_Func_829F:
    LDA $41
    BEQ Bank1_Func_827D
    LDX $42
    BEQ Bank1_Label_8302
    DEX
    BEQ Bank1_Label_82D7
    LDX $44
    BEQ Bank1_Label_82B6
    DEX
    STX $44
    BNE Bank1_Label_82B6
    JSR Bank1_Func_8366

Bank1_Label_82B6:
    LDA $40
    CMP #$EF
    BNE Bank1_Label_82C0
    LDA #$FF
    STA $40

Bank1_Label_82C0:
    INC $40
    LDA $40
    ASL A
    AND #$1E
    TAX
    LDA #$82
    PHA
    LDA #$7F
    PHA
    LDA a:$8872,X
    PHA
    LDA a:$8871,X
    PHA
    RTS

Bank1_Label_82D7:
    LDX $44
    BEQ Bank1_Label_82E3
    DEX
    STX $44
    BNE Bank1_Label_82E3
    JSR Bank1_Func_8366

Bank1_Label_82E3:
    LDA $40
    BNE Bank1_Label_82EB
    LDA #$F0
    STA $40

Bank1_Label_82EB:
    DEC $40
    LDA $40
    ASL A
    AND #$1E
    TAX
    LDA #$82
    PHA
    LDA #$7F
    PHA
    LDA a:$8852,X
    PHA
    LDA a:$8851,X
    PHA
    RTS

Bank1_Label_8302:
    LDX $45
    BEQ Bank1_Label_8335
    DEX
    STX $45
    LDA $19
    PHA
    LDA $3F
    PHA
    LDA $19
    EOR #$01
    STA $19
    TXA
    EOR #$0F
    ORA #$F0
    STA $3F
    ASL A
    AND #$1E
    TAX
    JSR Bank1_Func_835D
    PLA
    STA $3F
    PLA
    STA $19
    JMP Bank1_Label_8280
    .byte $68, $85, $3F, $68, $85, $19, $4C, $80, $82

Bank1_Label_8335:
    INC $3F
    LDA $3F
    BNE Bank1_Label_8343
    PHA
    LDA $19
    EOR #$01
    STA $19
    PLA

Bank1_Label_8343:
    LDX $44
    BEQ Bank1_Label_8353
    DEX
    STX $44
    BNE Bank1_Label_8350
    LDA $43
    STA $42

Bank1_Label_8350:
    JMP Bank1_Label_8280

Bank1_Label_8353:
    ASL A
    AND #$1E
    TAX
    LDA #$82
    PHA
    LDA #$7F
    PHA

Bank1_Func_835D:
    LDA a:$8832,X
    PHA
    LDA a:$8831,X
    PHA
    RTS

Bank1_Func_8366:
    LDA $43
    STA $42
    LDA #$0F
    STA $45
    INC $56
    RTS

Bank1_Func_8371:
    JSR Bank1_Func_837D
    LDA $43
    BEQ Bank1_Label_837C
    LDA #$0F
    STA $44

Bank1_Label_837C:
    RTS

Bank1_Func_837D:
    INC $56
    LDA $56
    CMP #$10
    BNE Bank1_Label_837C
    LDA #$00
    STA $54
    STA $56

Bank1_Label_838B:
    INC $55
    LDY $55
    LDA a:$BDDF,Y
    CMP #$F0
    BCC Bank1_Label_83BE
    CMP #$F7
    BCS Bank1_Label_83A3
    AND #$03
    STA $43
    LDA #$0F
    STA $56
    RTS

Bank1_Label_83A3:
    BEQ Bank1_Label_83B7
    CMP #$F8
    BEQ Bank1_Label_83B1
    AND #$07
    STA $9D
    STA $B4
    BNE Bank1_Label_838B

Bank1_Label_83B1:
    LDA #$00
    STA $41
    BEQ Bank1_Label_838B

Bank1_Label_83B7:
    LDA $9E
    STA $55
    JMP Bank1_Label_838B

Bank1_Label_83BE:
    AND #$7F
    STA $58
    ASL A
    TAX
    LDA a:$BEDE,X
    STA $46
    LDA a:$BEDF,X
    STA $47
    RTS

Bank1_Func_83CF:
    LDX #$00
    LDY $54

Bank1_Label_83D3:
    JSR Bank1_Func_8444
    CPX #$0F
    BCC Bank1_Label_83D3
    STY $54
    RTS
    .byte $E6, $56, $A5, $56, $C9, $0E, $D0, $19, $A4, $55, $BE, $E0, $BD, $E0, $F0, $90
    .byte $10, $E0, $F7, $B0, $0C, $8A, $29, $03, $85, $43, $A9, $0F, $85, $44, $E6, $55
    .byte $60, $C9, $0F, $90, $FB, $4C, $85, $83, $A2, $00, $A4, $54, $20, $44, $84, $E0
    .byte $10, $90, $F9, $84, $54, $A5, $40, $29, $F0, $85, $51, $A2, $04, $86, $52, $A5
    .byte $19, $29, $01, $09, $08, $85, $49, $A5, $40, $29, $F0, $0A, $26, $49, $0A, $26
    .byte $49, $09, $20, $85, $48, $0A, $A5, $49, $2A, $0A, $0A, $0A, $09, $C0, $85, $4A
    .byte $A5, $49, $09, $03, $85, $4B, $60

Bank1_Func_8444:
    LDA ($46),Y
    INY
    CMP #$D0
    BCC Bank1_Label_8469
    CMP #$EF
    BEQ Bank1_Label_846E
    BCS Bank1_Label_845A
    STA $74
    JSR Bank1_Func_98C7
    LDA #$00
    BEQ Bank1_Label_8469

Bank1_Label_845A:
    AND #$0F
    STA $57
    LDA ($46),Y
    INY

Bank1_Label_8461:
    STA a:$04F0,X
    INX
    DEC $57
    BNE Bank1_Label_8461

Bank1_Label_8469:
    STA a:$04F0,X
    INX
    RTS

Bank1_Label_846E:
    LDX #$10
    RTS

Bank1_Func_8471:
    LDA $3F
    CLC
    ADC #$10
    ROR A
    ROR A
    ROR A
    ROR A
    AND #$0F
    STA $51
    LDA #$04
    STA $52
    LDA $3F
    LSR A
    LSR A
    LSR A
    LSR A
    ASL A
    CLC
    ADC #$02
    AND #$1F
    STA $48
    BEQ Bank1_Label_8494
    LDA #$01

Bank1_Label_8494:
    EOR $19
    AND #$01
    ASL A
    ASL A
    ORA #$20
    STA $49
    ORA #$03
    STA $4B
    LDA $48
    LSR A
    LSR A
    ORA #$C0
    STA $4A
    RTS
    .byte $A2, $00, $86, $53, $BD, $F0, $04, $A4, $53, $91, $51, $A8, $E6, $53, $20, $FC
    .byte $84, $E0, $10, $D0, $EF, $60

Bank1_Func_84C1:
    LDY #$00
    LDX $4A

Bank1_Label_84C5:
    LDA $4B
    STA a:$2006
    STX a:$2006
    LDA a:$2007
    LDA a:$2007
    STA a:$0550,Y
    TXA
    CLC
    ADC #$08
    TAX
    INY
    CPY #$08
    BNE Bank1_Label_84C5
    RTS

Bank1_Func_84E1:
    LDX #$00
    STX $53

Bank1_Label_84E5:
    LDA a:$04F0,X
    LDY $53
    STA ($51),Y
    TAY
    LDA $53
    CLC
    ADC #$10
    STA $53
    JSR Bank1_Func_84FC
    CPX #$0F
    BNE Bank1_Label_84E5
    RTS

Bank1_Func_84FC:
    LDA a:$B9CF,Y
    STA a:$0500,X
    TYA
    ASL A
    BCS Bank1_Label_853F
    ASL A
    BCS Bank1_Label_8524
    TAY
    LDA a:$BA9F,Y
    STA a:$0510,X
    LDA a:$BAA0,Y
    STA a:$0520,X
    LDA a:$BAA1,Y
    STA a:$0530,X
    LDA a:$BAA2,Y
    STA a:$0540,X
    INX
    RTS

Bank1_Label_8524:
    TAY
    LDA a:$BB9F,Y
    STA a:$0510,X
    LDA a:$BBA0,Y
    STA a:$0520,X
    LDA a:$BBA1,Y
    STA a:$0530,X
    LDA a:$BBA2,Y
    STA a:$0540,X
    INX
    RTS

Bank1_Label_853F:
    ASL A
    BCS Bank1_Label_855D
    TAY
    LDA a:$BC9F,Y
    STA a:$0510,X
    LDA a:$BCA0,Y
    STA a:$0520,X
    LDA a:$BCA1,Y
    STA a:$0530,X
    LDA a:$BCA2,Y
    STA a:$0540,X
    INX
    RTS

Bank1_Label_855D:
    TAY
    LDA a:$BD9F,Y
    STA a:$0510,X
    LDA a:$BDA0,Y
    STA a:$0520,X
    LDA a:$BDA1,Y
    STA a:$0530,X
    LDA a:$BDA2,Y
    STA a:$0540,X
    INX
    RTS

Bank1_Func_8578:
    LDA $19
    ORA #$04
    STA a:$2000
    LDA $49
    STA a:$2006
    LDX $48
    STX a:$2006
    LDY #$00
    LDX #$0F

Bank1_Label_858D:
    LDA a:$0510,Y
    STA a:$2007
    LDA a:$0530,Y
    STA a:$2007
    INY
    DEX
    BNE Bank1_Label_858D
    LDA $19
    AND #$FB
    STA a:$2000
    RTS

Bank1_Func_85A5:
    LDX #$00
    STX $4E
    LDA $48
    AND #$02
    BEQ Bank1_Label_85B0
    INX

Bank1_Label_85B0:
    STX $50
    LDY #$00
    STY $4C

Bank1_Label_85B6:
    LDX $50
    LDA a:$85F5,X
    STA $4D
    LDA a:$0500,Y
    LDX $50
    BEQ Bank1_Label_85C6
    ASL A
    ASL A

Bank1_Label_85C6:
    LDX $4E
    BEQ Bank1_Label_85D7
    ASL A
    ASL A
    ASL A
    ASL A
    SEC
    ROL $4D
    ROL $4D
    ROL $4D
    ROL $4D

Bank1_Label_85D7:
    STA $4F
    LDX $4C
    LDA a:$0550,X
    AND $4D
    ORA $4F
    STA a:$0550,X
    LDA #$01
    EOR $4E
    STA $4E
    BNE Bank1_Label_85EF
    INC $4C

Bank1_Label_85EF:
    INY
    CPY #$0F
    BNE Bank1_Label_85B6
    RTS
    .byte $FC, $F3

Bank1_Func_85F7:
    LDA $19
    ORA #$04
    STA a:$2000
    LDX $48
    INX
    LDA $49
    STA a:$2006
    STX a:$2006
    LDY #$00
    LDX #$0F

Bank1_Label_860D:
    LDA a:$0520,Y
    STA a:$2007
    LDA a:$0540,Y
    STA a:$2007
    INY
    DEX
    BNE Bank1_Label_860D
    LDY #$00
    LDX $4A

Bank1_Label_8621:
    LDA $4B
    STA a:$2006
    STX a:$2006
    LDA a:$0550,Y
    STA a:$2007
    TXA
    CLC
    ADC #$08
    TAX
    INY
    CPY #$08
    BNE Bank1_Label_8621
    LDA $19
    AND #$FB
    STA a:$2000
    RTS
    .byte $A6, $48, $A5, $49, $8D, $06, $20, $8E, $06, $20, $A0, $00, $A2, $10, $B9, $30
    .byte $05, $8D, $07, $20, $B9, $40, $05, $8D, $07, $20, $C8, $CA, $D0, $F0, $60, $A6
    .byte $4A, $A5, $4B, $8D, $06, $20, $8E, $06, $20, $A0, $00, $A2, $08, $AD, $07, $20
    .byte $AD, $07, $20, $99, $50, $05, $C8, $CA, $D0, $F6, $A2, $00, $86, $4E, $A5, $48
    .byte $29, $40, $F0, $01, $E8, $86, $50, $A0, $00, $84, $4C, $A6, $50, $BD, $C7, $86
    .byte $85, $4D, $B9, $00, $05, $A6, $50, $F0, $04, $0A, $0A, $0A, $0A, $A6, $4E, $F0
    .byte $07, $0A, $0A, $38, $26, $4D, $26, $4D, $85, $4F, $A6, $4C, $BD, $50, $05, $25
    .byte $4D, $05, $4F, $9D, $50, $05, $A9, $01, $45, $4E, $85, $4E, $D0, $02, $E6, $4C
    .byte $C8, $C0, $10, $D0, $C6, $60, $FC, $CF, $A5, $48, $29, $D0, $AA, $A5, $49, $8D
    .byte $06, $20, $8E, $06, $20, $A0, $00, $A2, $10, $B9, $10, $05, $8D, $07, $20, $B9
    .byte $20, $05, $8D, $07, $20, $C8, $CA, $D0, $F0, $60, $A6, $4A, $A5, $4B, $8D, $06
    .byte $20, $8E, $06, $20, $A0, $00, $A2, $08, $B9, $50, $05, $8D, $07, $20, $C8, $CA
    .byte $D0, $F6, $60

Bank1_Func_8704:
    JSR Bank1_Func_A88B
    JMP Bank1_Func_ACE4

Bank1_Func_870A:
    STA a:$2006
    STX a:$2006
    RTS

Bank1_Func_8711:
    JSR Bank1_Func_80DA
    JSR Bank1_WaitForVblank
    JSR Bank1_Func_80F0
    JSR Bank1_Func_8771
    LDA #$10
    STA $19
    STA a:$2000
    LDA #$00
    STA $40
    STA $3F
    JSR Bank1_Func_8131
    JSR Bank1_Func_80DA
    JSR Bank1_Func_8771
    LDA #$20
    LDX #$00
    JSR Bank1_Func_870A
    LDY #$08
    TXA

Bank1_Label_873D:
    STA a:$2007
    DEX
    BNE Bank1_Label_873D
    DEY
    BNE Bank1_Label_873D

Bank1_Label_8746:
    RTS

Bank1_Func_8747:
    LDA $9D
    BEQ Bank1_Label_8746
    BPL Bank1_Func_8751
    LDA $73
    AND #$03

Bank1_Func_8751:
    PHA
    LDA #$00
    STA $9D
    LDA #$3F
    LDX #$00
    JSR Bank1_Func_870A
    PLA
    ASL A
    ASL A
    ASL A
    ASL A
    TAX
    LDY #$10

Bank1_Label_8765:
    LDA a:$8791,X
    STA a:$2007
    INX
    DEY
    BNE Bank1_Label_8765
    BEQ Bank1_Label_8790

Bank1_Func_8771:
    LDA #$3F
    LDX #$00
    JSR Bank1_Func_870A
    LDY #$10

Bank1_Label_877A:
    LDA a:$87A1,X
    STA a:$2007
    INX
    DEY
    BNE Bank1_Label_877A

Bank1_Func_8784:
    LDY #$10

Bank1_Label_8786:
    LDA a:$87F1,X
    STA a:$2007
    INX
    DEY
    BNE Bank1_Label_8786

Bank1_Label_8790:
    LDA #$3F
    STA a:$2006
    LDA #$00
    STA a:$2006
    STA a:$2006
    STA a:$2006
    RTS
    .byte $0F, $17, $26, $07, $0F, $19, $29, $07, $0F, $17, $26, $07, $0F, $1C, $11, $07
    .byte $0F, $17, $26, $07, $0F, $19, $29, $07, $0F, $17, $26, $07, $0F, $06, $15, $07
    .byte $0F, $17, $26, $07, $0F, $19, $29, $07, $0F, $17, $26, $07, $0F, $00, $10, $07
    .byte $0F, $17, $26, $07, $0F, $19, $29, $07, $0F, $1C, $10, $08, $0F, $1C, $21, $09
    .byte $0F, $17, $26, $07, $0F, $1A, $10, $0A, $0F, $00, $10, $08, $0F, $00, $31, $0B
    .byte $0F, $05, $15, $0F, $0F, $23, $20, $15, $0F, $00, $10, $08, $0F, $00, $31, $0B
    .byte $0F, $15, $21, $30, $0F, $15, $26, $30, $0F, $19, $28, $30, $0F, $17, $27, $36
    .byte $0F, $15, $21, $30, $0F, $15, $26, $30, $0F, $11, $21, $30, $0F, $17, $27, $36
    .byte $0F, $15, $21, $30, $0F, $15, $26, $30, $0F, $1A, $28, $30, $0F, $13, $25, $35
    .byte $64, $83, $70, $83, $64, $83, $CE, $83, $46, $87, $70, $84, $64, $83, $C0, $84
    .byte $64, $83, $E0, $84, $64, $83, $77, $85, $64, $83, $A4, $85, $64, $83, $F6, $85
    .byte $64, $83, $64, $83, $64, $83, $46, $87, $64, $83, $C8, $86, $64, $83, $64, $83
    .byte $64, $83, $EA, $86, $5F, $86, $40, $86, $AA, $84, $04, $84, $DC, $83, $64, $83
    .byte $64, $83, $DC, $83, $04, $84, $AA, $84, $C8, $86, $5F, $86, $EA, $86, $64, $83
    .byte $64, $83, $64, $83, $40, $86, $64, $83, $46, $87, $64, $83, $64, $83, $64, $83

Bank1_Func_8891:
    LDX #$7F
    TXS
    LDX #$00
    STX $82
    INX
    STX $27
    INX
    STX $2A
    LDA #$05
    STA $2C
    BNE Bank1_Label_88B1

Bank1_World2Main:
    LDX #$7F
    TXS
    LDA #$00
    STA $82
    STA $A3
    STA $BA
    STA $27

Bank1_Label_88B1:
    LDA #$00
    STA $73
    STA $A9

Bank1_Label_88B7:
    LDX #$7F
    TXS
    JSR Bank1_Func_8711
    JSR Bank1_Func_8AB6
    LDA #$02
    STA $5E
    LDA #$3C
    STA $5C
    LDA #$78
    STA $5D
    LDA #$00
    STA $B9
    STA $40
    STA $44
    STA $3F
    STA $B8
    STA $AE
    STA $5F
    STA $A4
    STA $9D
    STA $93
    STA $92
    STA $7B
    STA $6A
    STA $6F
    STA $45
    STA $42
    STA $43
    STA $A0
    STA $9C
    STA $A5
    STA $A1
    STA $7C
    STA $7D
    STA $41
    STA $7E
    STA $80
    STA $81
    STA $7F
    STA $A8
    STA $B3
    STA $A0
    STA $A2
    STA $B2
    STA $38
    LDA #$96
    STA $AD
    JSR Bank1_Func_8AD0
    STA $2B
    LDA $37
    BEQ Bank1_Label_8923
    LDA #$03
    STA $7E

Bank1_Label_8923:
    LDA #$00
    STA $37
    JSR Bank1_Func_8AAB
    LDA $27
    BNE Bank1_Label_8940
    LDA #$01
    STA $28
    JSR Bank1_Func_8053
    JSR Bank1_Func_80FD
    LDX #$5A

Bank1_Label_893A:
    JSR Bank1_WaitForVblank
    DEX
    BNE Bank1_Label_893A

Bank1_Label_8940:
    JSR Bank1_Func_8711
    LDA #$01
    JSR Bank1_Func_81AA
    JSR Bank1_Func_8ADF
    LDA $19
    AND #$E7
    ORA #$11
    STA $19
    JSR Bank1_Func_80FD
    JSR Bank1_Func_98F8

Bank1_World2FrameLoop:
    JSR Bank1_Func_8A39
    JSR Bank1_Func_8B3B
    JSR Bank1_Func_8B4C
    JSR Bank1_Func_8BAC
    JSR Bank1_Func_9036
    JSR Bank1_Func_9913
    JSR Bank1_Func_A1D1
    JSR Bank1_Func_97C5
    JSR Bank1_Func_8FA2
    JSR Bank1_Func_A6BC
    JSR Bank1_Func_A62B
    JSR Bank1_Func_8A1D
    JSR Bank1_Func_8B65
    JSR Bank1_Func_A612
    LDA $B2
    BNE Bank1_Label_89D1
    LDA $B3
    BNE Bank1_Label_89CE
    LDA $27
    BEQ Bank1_Label_8991
    LDA #$20

Bank1_Label_8991:
    ORA #$10
    AND $21
    BNE Bank1_Label_89D7
    LDA $A2
    BEQ Bank1_World2FrameLoop
    LDA $27
    BNE Bank1_Label_89DB
    LDA #$06
    STA a:$02AA
    LDA #$00
    STA $41
    LDA #$DC
    STA $AD

Bank1_Label_89AC:
    JSR Bank1_Func_8A1A
    DEC $AD
    BNE Bank1_Label_89AC
    DEC $2A
    BMI Bank1_Label_89BA
    JMP Bank1_Label_88B7

Bank1_Label_89BA:
    JSR Bank1_Func_8065
    LDA #$00
    LDX #$06

Bank1_Label_89C1:
    STA a:$0298,X
    DEX
    BPL Bank1_Label_89C1
    LDA #$02
    STA $2A
    JMP Bank1_Label_88B7

Bank1_Label_89CE:
    JMP Bank1_Func_8A46

Bank1_Label_89D1:
    JSR Bank1_Func_8A7F
    JMP Bank1_Func_8A32

Bank1_Label_89D7:
    LDA $27
    BEQ Bank1_Label_89DE

Bank1_Label_89DB:
    JMP Bank1_Func_8048

Bank1_Label_89DE:
    LDA $41
    PHA
    LDA #$00
    STA $41
    LDA #$06
    JSR Bank1_Func_A856
    LDA #$01
    STA a:$02AB

Bank1_Label_89EF:
    JSR Bank1_Func_8A1A
    LDA $21
    AND #$10
    BNE Bank1_Label_89EF

Bank1_Label_89F8:
    JSR Bank1_Func_8A1A
    LDA $21
    AND #$10
    BEQ Bank1_Label_89F8
    LDA #$06
    JSR Bank1_Func_A856
    LDA #$00
    STA a:$02AB

Bank1_Label_8A0B:
    JSR Bank1_Func_8A1A
    LDA $21
    AND #$10
    BNE Bank1_Label_8A0B
    PLA
    STA $41
    JMP Bank1_World2FrameLoop

Bank1_Func_8A1A:
    JSR Bank1_Func_8A39

Bank1_Func_8A1D:
    JSR Bank1_Func_8A94
    JSR Bank1_Func_91CD
    JSR Bank1_Func_93E5
    JSR Bank1_Func_A304
    JSR Bank1_Func_A2CA
    JSR Bank1_Func_93B7
    JMP Bank1_Func_A753

Bank1_Func_8A32:
    LDA $82
    STA $38
    JMP Bank1_Func_808D

Bank1_Func_8A39:
    LDA $16

Bank1_Label_8A3B:
    CMP $16
    BEQ Bank1_Label_8A3B
    LDA $93
    EOR #$80
    STA $93
    RTS

Bank1_Func_8A46:
    JSR Bank1_Func_98F8
    JSR Bank1_Func_8A84
    LDA #$01
    STA $41
    LDA #$00
    STA $B3
    STA $A4
    LDA #$64
    STA $AD
    LDA $B4
    STA $9D
    LDA $A9
    CMP #$02
    BEQ Bank1_Label_8A66
    INC $A9

Bank1_Label_8A66:
    BNE Bank1_Label_8A71
    LDX #$00
    JSR Bank1_Func_8A74
    INX
    JSR Bank1_Func_8A74

Bank1_Label_8A71:
    JMP Bank1_World2FrameLoop

Bank1_Func_8A74:
    LDA $7C,X
    CMP #$03
    BEQ Bank1_Label_8A7E
    LDA #$02
    STA $7C,X

Bank1_Label_8A7E:
    RTS

Bank1_Func_8A7F:
    LDA #$09
    JSR Bank1_Func_A87A

Bank1_Func_8A84:
    LDA #$F0
    STA $AD

Bank1_Label_8A88:
    JSR Bank1_Func_8A1A
    LDA #$FF
    STA $9D
    DEC $AD
    BNE Bank1_Label_8A88
    RTS

Bank1_Func_8A94:
    LDX #$3C
    LDA #$F8

Bank1_Label_8A98:
    STA a:$0300,X
    STA a:$0340,X
    STA a:$0380,X
    STA a:$03C0,X
    DEX
    DEX
    DEX
    DEX
    BPL Bank1_Label_8A98
    RTS

Bank1_Func_8AAB:
    LDX #$FF
    LDA #$00

Bank1_Label_8AAF:
    STA a:$0400,X
    DEX
    BNE Bank1_Label_8AAF
    RTS

Bank1_Func_8AB6:
    LDA #$00
    STA a:$4011
    STA a:$4015
    STA a:$4010
    STA a:$02A0
    STA a:$02AA
    STA a:$02AB
    LDA #$40
    STA a:$4017
    RTS

Bank1_Func_8AD0:
    STX $76
    LDX $2C
    LDA a:$8AD8,X
    LDX $76
    RTS
    .byte $18, $14, $10, $0C, $08

Bank1_Func_8ADF:
    JSR Bank1_WaitForVblank
    LDY $A9
    LDX a:$8B38,Y
    DEX
    STX $55
    LDX a:$8BA9,Y
    JSR Bank1_Func_8784
    LDX $A9
    LDA a:$8BA6,X
    JSR Bank1_Func_8751
    LDA #$0F
    STA $56
    LDA #$00
    STA $40
    STA $44
    STA $3F
    STA $42
    STA $41
    LDA #$F0
    STA $3F
    LDA #$80
    STA $AA
    LDA #$11
    STA $67

Bank1_Label_8B14:
    JSR Bank1_Func_8371
    JSR Bank1_Func_83CF
    JSR Bank1_Func_8471
    JSR Bank1_Func_84C1
    JSR Bank1_Func_84E1
    JSR Bank1_Func_8578
    JSR Bank1_Func_85A5
    JSR Bank1_Func_85F7
    LDA $3F
    CLC
    ADC #$10
    STA $3F
    DEC $67
    BNE Bank1_Label_8B14
    RTS
    .byte $00, $25, $5C

Bank1_Func_8B3B:
    LDA $27
    BNE Bank1_Label_8B47
    LDA $AA
    BEQ Bank1_Label_8B4B
    DEC $AA
    BNE Bank1_Label_8B4B

Bank1_Label_8B47:
    LDA #$01
    STA $41

Bank1_Label_8B4B:
    RTS

Bank1_Func_8B4C:
    LDA $AD
    BEQ Bank1_Label_8B64
    LDA $27
    BNE Bank1_Label_8B58
    DEC $AD
    BNE Bank1_Label_8B64

Bank1_Label_8B58:
    LDX $A9
    LDA a:$8BA2,X
    STA a:$02AA
    LDA #$00
    STA $AD

Bank1_Label_8B64:
    RTS

Bank1_Func_8B65:
    LDA $BA
    BNE Bank1_Label_8B92
    LDA $7C
    CMP #$03
    BNE Bank1_Label_8B92
    LDA $24
    BEQ Bank1_Label_8B90
    INC $B9
    LDA $B9
    CMP #$60
    BCC Bank1_Label_8B92
    LDX #$06

Bank1_Label_8B7D:
    LDA a:$0558,X
    BEQ Bank1_Label_8B8B
    CMP #$70
    BCS Bank1_Label_8B8B
    LDA #$78
    STA a:$0558,X

Bank1_Label_8B8B:
    DEX
    BPL Bank1_Label_8B7D
    INC $BA

Bank1_Label_8B90:
    STA $B9

Bank1_Label_8B92:
    JSR Bank1_Func_820E
    LDA $26
    BEQ Bank1_Label_8B64
    LDA #$00
    STA $26
    LDA #$0D
    JMP Bank1_Func_A87A
    .byte $01, $02, $03, $01, $01, $04, $05, $10, $20, $30

Bank1_Func_8BAC:
    JSR Bank1_Func_8E3C
    JSR Bank1_Func_8E0F
    JSR Bank1_Func_8D01
    JSR Bank1_Func_8D88
    JSR Bank1_Func_8C84
    JSR Bank1_Func_8C74
    JSR Bank1_Func_8C78
    JSR Bank1_Func_8C7C
    JSR Bank1_Func_8C5D
    JSR Bank1_Func_8C80
    LDA $A0
    BNE Bank1_Label_8C3C
    LDA $A8
    BNE Bank1_Label_8C3B
    LDA $27
    BEQ Bank1_Label_8BDF
    LDA $73
    ROL A
    BCS Bank1_Label_8BDF
    LDA #$00
    STA $9C

Bank1_Label_8BDF:
    LDA $9C
    BEQ Bank1_Label_8C3B
    STA $B0
    LDA #$00
    STA $9C
    LDA $80
    CMP #$03
    BEQ Bank1_Label_8C18
    LDA #$00
    STA $6A
    LDA #$0C
    JSR Bank1_Func_A856
    LDA #$78
    STA $A0
    INC $A5
    LDA $A5
    CMP #$04
    BCC Bank1_Label_8C3B

Bank1_Label_8C04:
    LDA #$00
    STA $A5
    LDA $27
    BNE Bank1_Label_8C17
    LDX #$05

Bank1_Label_8C0E:
    LDA $7C,X
    CMP #$03
    BEQ Bank1_Label_8C25
    DEX
    BPL Bank1_Label_8C0E

Bank1_Label_8C17:
    RTS

Bank1_Label_8C18:
    INC $A5
    LDA $A5
    CMP #$06
    BCS Bank1_Label_8C04
    LDA #$01
    STA $A8
    RTS

Bank1_Label_8C25:
    LDA #$04
    STA $7C,X
    CPX #$02
    BCC Bank1_Label_8C3B
    LDA $5C
    CLC
    ADC #$04
    STA $83,X
    LDA $5D
    CLC
    ADC #$04
    STA $8A,X

Bank1_Label_8C3B:
    RTS

Bank1_Label_8C3C:
    DEC $A0
    BNE Bank1_Label_8C3B
    LDX $B0
    BPL Bank1_Label_8C4E
    DEX
    BPL Bank1_Label_8C4E
    DEX
    BPL Bank1_Label_8C4C
    DEC $2B

Bank1_Label_8C4C:
    DEC $2B

Bank1_Label_8C4E:
    DEC $2B
    LDA $2B
    BPL Bank1_Label_8C5C
    LDA #$01
    STA $A2
    LDA #$00
    STA $2B

Bank1_Label_8C5C:
    RTS

Bank1_Func_8C5D:
    LDA $A8
    BEQ Bank1_Label_8C73
    LDA $73
    AND #$07
    BNE Bank1_Label_8C73
    INC $A8
    LDA $A8
    CMP #$05
    BNE Bank1_Label_8C73
    LDA #$00
    STA $A8

Bank1_Label_8C73:
    RTS

Bank1_Func_8C74:
    LDX #$03
    BNE Bank1_Label_8C86

Bank1_Func_8C78:
    LDX #$05
    BNE Bank1_Label_8C86

Bank1_Func_8C7C:
    LDX #$04
    BNE Bank1_Label_8C86

Bank1_Func_8C80:
    LDX #$06
    BNE Bank1_Label_8C86

Bank1_Func_8C84:
    LDX #$02

Bank1_Label_8C86:
    LDA $7C,X
    CMP #$01
    BEQ Bank1_Label_8CC3
    CMP #$04
    BEQ Bank1_Label_8CC3
    CMP #$02
    BNE Bank1_Label_8CC2
    LDY #$00
    LDA $5C
    CMP $83,X
    BEQ Bank1_Label_8CA5
    BCS Bank1_Label_8CA2
    DEC $83,X
    DEC $83,X

Bank1_Label_8CA2:
    INC $83,X
    INY

Bank1_Label_8CA5:
    LDA $5D
    CMP $8A,X
    BEQ Bank1_Label_8CB4
    BCS Bank1_Label_8CB1
    DEC $8A,X
    DEC $8A,X

Bank1_Label_8CB1:
    INC $8A,X
    INY

Bank1_Label_8CB4:
    TYA
    BNE Bank1_Label_8CC2
    LDA #$09
    JSR Bank1_Func_A856
    LDA #$00
    STA $A5
    INC $7C,X

Bank1_Label_8CC2:
    RTS

Bank1_Label_8CC3:
    JSR Bank1_Func_8CD9
    LDA $7C,X
    CMP #$01
    BNE Bank1_Label_8CC2
    LDA $8A,X
    CMP #$67
    BEQ Bank1_Label_8CD6
    CMP #$79
    BNE Bank1_Label_8CC2

Bank1_Label_8CD6:
    INC $7C,X
    RTS

Bank1_Func_8CD9:
    LDY $42
    BEQ Bank1_Label_8CEE
    DEY
    BEQ Bank1_Label_8CE5
    DEC $8A,X
    BEQ Bank1_Label_8CF6
    RTS

Bank1_Label_8CE5:
    INC $8A,X
    LDA $8A,X
    CMP #$E0
    BCS Bank1_Label_8CF6
    RTS

Bank1_Label_8CEE:
    LDA $45
    BNE Bank1_Label_8D00
    DEC $83,X
    BNE Bank1_Label_8D00

Bank1_Label_8CF6:
    LDA $7C,X
    CMP #$01
    BEQ Bank1_Label_8D00
    LDA #$00
    STA $7C,X

Bank1_Label_8D00:
    RTS

Bank1_Func_8D01:
    LDY #$00
    LDA $7D
    CMP #$01
    BEQ Bank1_Label_8D4A
    CMP #$04
    BEQ Bank1_Label_8D4A
    CMP #$02
    BNE Bank1_Label_8D49
    LDA $5F
    SEC
    SBC #$17
    BPL Bank1_Label_8D1A
    ADC #$30

Bank1_Label_8D1A:
    TAX
    LDA a:$0200,X
    CMP $84
    BEQ Bank1_Label_8D2B
    BCS Bank1_Label_8D28
    DEC $84
    DEC $84

Bank1_Label_8D28:
    INC $84
    INY

Bank1_Label_8D2B:
    LDA a:$0230,X
    CMP $8B
    BEQ Bank1_Label_8D3B
    BCS Bank1_Label_8D38
    DEC $8B
    DEC $8B

Bank1_Label_8D38:
    INC $8B
    INY

Bank1_Label_8D3B:
    TYA
    BNE Bank1_Label_8D49
    INC $7D
    LDA #$09
    JSR Bank1_Func_A856
    LDA #$00
    STA $A5

Bank1_Label_8D49:
    RTS

Bank1_Label_8D4A:
    JSR Bank1_Func_8D60
    LDA $7D
    CMP #$01
    BNE Bank1_Label_8D49
    LDA $8B
    CMP #$67
    BEQ Bank1_Label_8D5D
    CMP #$79
    BNE Bank1_Label_8D49

Bank1_Label_8D5D:
    INC $7D
    RTS

Bank1_Func_8D60:
    LDY $42
    BEQ Bank1_Label_8D75
    DEY
    BEQ Bank1_Label_8D6C
    DEC $8B
    BEQ Bank1_Label_8D7D
    RTS

Bank1_Label_8D6C:
    INC $8B
    LDA $8B
    CMP #$E0
    BCS Bank1_Label_8D7D
    RTS

Bank1_Label_8D75:
    LDA $45
    BNE Bank1_Label_8D87
    DEC $84
    BNE Bank1_Label_8D87

Bank1_Label_8D7D:
    LDA $7D
    CMP #$01
    BEQ Bank1_Label_8D87
    LDA #$00
    STA $7D

Bank1_Label_8D87:
    RTS

Bank1_Func_8D88:
    LDY #$00
    LDA $7C
    CMP #$01
    BEQ Bank1_Label_8DD1
    CMP #$04
    BEQ Bank1_Label_8DD1
    CMP #$02
    BNE Bank1_Label_8DD0
    LDA $5F
    SEC
    SBC #$2F
    BPL Bank1_Label_8DA1
    ADC #$30

Bank1_Label_8DA1:
    TAX
    LDA a:$0200,X
    CMP $83
    BEQ Bank1_Label_8DB2
    BCS Bank1_Label_8DAF
    DEC $83
    DEC $83

Bank1_Label_8DAF:
    INC $83
    INY

Bank1_Label_8DB2:
    LDA a:$0230,X
    CMP $8A
    BEQ Bank1_Label_8DC2
    BCS Bank1_Label_8DBF
    DEC $8A
    DEC $8A

Bank1_Label_8DBF:
    INC $8A
    INY

Bank1_Label_8DC2:
    TYA
    BNE Bank1_Label_8DD0
    LDA #$09
    JSR Bank1_Func_A856
    LDA #$00
    STA $A5
    INC $7C

Bank1_Label_8DD0:
    RTS

Bank1_Label_8DD1:
    JSR Bank1_Func_8DE7
    LDA $7C
    CMP #$01
    BNE Bank1_Label_8DD0
    LDA $8A
    CMP #$67
    BEQ Bank1_Label_8DE4
    CMP #$79
    BNE Bank1_Label_8DD0

Bank1_Label_8DE4:
    INC $7C
    RTS

Bank1_Func_8DE7:
    LDY $42
    BEQ Bank1_Label_8DFC
    DEY
    BEQ Bank1_Label_8DF3
    DEC $8A
    BEQ Bank1_Label_8E04
    RTS

Bank1_Label_8DF3:
    INC $8A
    LDA $8A
    CMP #$E0
    BCS Bank1_Label_8E04
    RTS

Bank1_Label_8DFC:
    LDA $45
    BNE Bank1_Label_8E0E
    DEC $83
    BNE Bank1_Label_8E0E

Bank1_Label_8E04:
    LDA $7C
    CMP #$01
    BEQ Bank1_Label_8E0E
    LDA #$00
    STA $7C

Bank1_Label_8E0E:
    RTS

Bank1_Func_8E0F:
    LDX $5F
    DEX
    BPL Bank1_Label_8E16
    LDX #$30

Bank1_Label_8E16:
    LDA $5C
    CMP a:$0200,X
    BNE Bank1_Label_8E25
    LDA $5D
    CMP a:$0230,X
    BNE Bank1_Label_8E25
    RTS

Bank1_Label_8E25:
    LDX $5F
    LDA $5C
    STA a:$0200,X
    LDA $5D
    STA a:$0230,X
    INX
    TXA
    CMP #$30
    BNE Bank1_Label_8E39
    LDA #$00

Bank1_Label_8E39:
    STA $5F
    RTS

Bank1_Func_8E3C:
    LDA $27
    BEQ Bank1_Label_8E4E
    LDA $73
    ROL A
    ROL A
    ROL A
    ROL A
    AND #$07
    TAY
    LDA a:$97BD,Y
    BNE Bank1_Label_8E50

Bank1_Label_8E4E:
    LDA $21

Bank1_Label_8E50:
    TAX
    AND #$01
    BEQ Bank1_Label_8E63
    LDA $5C
    CMP #$D0
    BCS Bank1_Label_8E73
    LDA $5E
    ADC $5C
    STA $5C
    BNE Bank1_Label_8E73

Bank1_Label_8E63:
    TXA
    AND #$02
    BEQ Bank1_Label_8E73
    LDA $5C
    SEC
    SBC $5E
    CMP #$20
    BCC Bank1_Label_8E73
    STA $5C

Bank1_Label_8E73:
    TXA
    AND #$04
    BEQ Bank1_Label_8E84
    LDA $5D
    CMP #$D0
    BCS Bank1_Label_8E93
    ADC $5E
    STA $5D
    BNE Bank1_Label_8E93

Bank1_Label_8E84:
    TXA
    AND #$08
    BEQ Bank1_Label_8E93
    LDA $5D
    SBC $5E
    CMP #$20
    BCC Bank1_Label_8E93
    STA $5D

Bank1_Label_8E93:
    TXA
    AND #$C0
    BNE Bank1_Label_8E9B
    STA $7A

Bank1_Label_8E9A:
    RTS

Bank1_Label_8E9B:
    INC $B1
    LDA $A0
    CMP #$50
    BCS Bank1_Label_8E9A
    LDA $7A
    BEQ Bank1_Label_8EB3
    INC $7A
    LDX #$1E
    CPX $7A
    BNE Bank1_Label_8E9A
    LDA #$00
    STA $7A

Bank1_Label_8EB3:
    INC $7A
    LDA #$00
    STA $91
    LDA $7D
    CMP #$03
    BNE Bank1_Label_8F0C
    LDA $7B
    EOR #$01
    STA $7B
    AND #$01
    BEQ Bank1_Label_8F0C
    INC $92
    LDA $92
    AND #$01
    BEQ Bank1_Label_8F0C
    LDA $92
    AND #$03
    STA $91
    LDA #$01
    JSR Bank1_Func_A856
    LDX #$06

Bank1_Label_8EDE:
    LDA a:$05B3,X
    BEQ Bank1_Label_8EED
    DEX
    CPX #$03
    BNE Bank1_Label_8EDE
    LDA #$00
    STA $7A
    RTS

Bank1_Label_8EED:
    LDA $5F
    SEC
    SBC #$17
    BPL Bank1_Label_8EF6
    ADC #$30

Bank1_Label_8EF6:
    TAY
    LDA a:$0200,Y
    CLC
    ADC #$04
    STA a:$05BA,X
    LDA a:$0230,Y
    CLC
    ADC #$08
    STA a:$05C1,X
    JMP Bank1_Label_8F40

Bank1_Label_8F0C:
    JSR Bank1_Func_8F4B
    LDA $27
    BNE Bank1_Label_8F19
    LDA $7E
    CMP #$03
    BNE Bank1_Label_8F1C

Bank1_Label_8F19:
    JMP Bank1_Func_8F80

Bank1_Label_8F1C:
    LDX #$03

Bank1_Label_8F1E:
    LDA a:$05B3,X
    BEQ Bank1_Label_8F2B
    DEX
    BPL Bank1_Label_8F1E
    LDA #$00
    STA $7A
    RTS

Bank1_Label_8F2B:
    LDA #$01
    JSR Bank1_Func_A856
    LDA $5C
    CLC
    ADC #$04
    STA a:$05BA,X
    LDA $5D
    CLC
    ADC #$08
    STA a:$05C1,X

Bank1_Label_8F40:
    LDA #$01
    STA a:$05B3,X
    LDA $91
    STA a:$05C8,X
    RTS

Bank1_Func_8F4B:
    LDA $7C
    CMP #$03
    BNE Bank1_Label_8F7F
    LDA $6F
    BNE Bank1_Label_8F7F
    INC $6F
    LDA $83
    CLC
    ADC #$04
    STA $70
    LDA $8A
    CLC
    ADC #$0A
    STA $71
    LDA $42
    BEQ Bank1_Label_8F7B
    LDA $A1
    EOR #$01
    STA $A1
    BEQ Bank1_Label_8F76
    LDA #$0B
    STA $72
    RTS

Bank1_Label_8F76:
    LDA #$05
    STA $72
    RTS

Bank1_Label_8F7B:
    LDA #$02
    STA $72

Bank1_Label_8F7F:
    RTS

Bank1_Func_8F80:
    LDA $6A
    BNE Bank1_Label_8FA1
    LDA #$0A
    JSR Bank1_Func_A856
    INC $6A
    LDA $5C
    CLC
    ADC #$04
    STA $85
    LDA $5D
    CLC
    ADC #$08
    STA $8C
    LDA #$00
    STA $6B
    LDA $42
    STA $6E

Bank1_Label_8FA1:
    RTS

Bank1_Func_8FA2:
    LDA #$00
    STA $9C
    LDA $A0
    BNE Bank1_Label_8FA1
    LDA $5C
    CLC
    ADC #$04
    STA $67
    LDA $5D
    CLC
    ADC #$08
    STA $68
    JSR Bank1_Func_9377
    BEQ Bank1_Label_8FC3
    LDA $A9
    ORA #$80
    STA $9C

Bank1_Label_8FC3:
    LDA $A0
    CMP #$50
    BCS Bank1_Label_9009
    LDX #$06

Bank1_Label_8FCB:
    LDA a:$0558,X
    BEQ Bank1_Label_9006
    CMP #$70
    BCC Bank1_Label_8FD8
    CMP #$80
    BCC Bank1_Label_9006

Bank1_Label_8FD8:
    LDA a:$0566,X
    CLC
    ADC #$08
    SEC
    SBC $5D
    BCC Bank1_Label_9006
    CMP #$18
    BCS Bank1_Label_9006
    LDA a:$055F,X
    CLC
    ADC #$08
    SEC
    SBC $5C
    BCC Bank1_Label_9006
    CMP #$10
    BCS Bank1_Label_9006
    INC $9C
    LDA a:$0558,X
    CMP #$10
    BCS Bank1_Label_9009
    LDA #$70
    STA a:$0558,X
    BNE Bank1_Label_9009

Bank1_Label_9006:
    DEX
    BPL Bank1_Label_8FCB

Bank1_Label_9009:
    LDX #$05

Bank1_Label_900B:
    LDA a:$0595,X
    BEQ Bank1_Label_9032
    CLC
    ADC #$02
    SEC
    SBC $5D
    BCC Bank1_Label_9032
    CMP #$16
    BCS Bank1_Label_9032
    LDA a:$058F,X
    CLC
    ADC #$02
    SEC
    SBC $5C
    BCC Bank1_Label_9032
    CMP #$0E
    BCS Bank1_Label_9032
    INC $9C
    LDA #$00
    STA a:$0595,X

Bank1_Label_9032:
    DEX
    BPL Bank1_Label_900B
    RTS

Bank1_Func_9036:
    JSR Bank1_Func_9177
    JSR Bank1_Func_912F
    LDX #$06

Bank1_Label_903E:
    LDA a:$05B3,X
    BNE Bank1_Label_9046
    JMP Bank1_Label_90D2

Bank1_Label_9046:
    INC a:$05B3,X
    BMI Bank1_Label_9071
    LDY $42
    BEQ Bank1_Label_909F
    DEY
    BEQ Bank1_Label_9074
    LDA a:$05C8,X
    BEQ Bank1_Label_9067
    CMP #$01
    BEQ Bank1_Label_9061
    JSR Bank1_Func_90DF
    JMP Bank1_Label_9093

Bank1_Label_9061:
    JSR Bank1_Func_90E5
    JMP Bank1_Label_9093

Bank1_Label_9067:
    LDA a:$05C1,X
    CLC
    ADC #$03
    CMP #$04
    BCS Bank1_Label_9093

Bank1_Label_9071:
    JMP Bank1_Label_90CD

Bank1_Label_9074:
    LDA a:$05C8,X
    BEQ Bank1_Label_9089
    CMP #$01
    BEQ Bank1_Label_9083
    JSR Bank1_Func_90D9
    JMP Bank1_Label_9093

Bank1_Label_9083:
    JSR Bank1_Func_90EB
    JMP Bank1_Label_9093

Bank1_Label_9089:
    LDA a:$05C1,X
    SEC
    SBC #$03
    CMP #$E0
    BCS Bank1_Label_90CD

Bank1_Label_9093:
    STA a:$05C1,X
    STA $68
    LDA a:$05BA,X
    STA $67
    BNE Bank1_Label_90C8

Bank1_Label_909F:
    LDA a:$05C8,X
    BEQ Bank1_Label_90B4
    CMP #$01
    BEQ Bank1_Label_90AE
    JSR Bank1_Func_90E5
    JMP Bank1_Label_9093

Bank1_Label_90AE:
    JSR Bank1_Func_90D9
    JMP Bank1_Label_9093

Bank1_Label_90B4:
    LDA a:$05BA,X
    CLC
    ADC #$04
    CMP #$FC
    BCS Bank1_Label_90CD
    STA a:$05BA,X
    STA $67
    LDA a:$05C1,X
    STA $68

Bank1_Label_90C8:
    JSR Bank1_Func_9377
    BEQ Bank1_Label_90D2

Bank1_Label_90CD:
    LDA #$00
    STA a:$05B3,X

Bank1_Label_90D2:
    DEX
    BMI Bank1_Label_90D8
    JMP Bank1_Label_903E

Bank1_Label_90D8:
    RTS

Bank1_Func_90D9:
    JSR Bank1_Func_90FF
    JMP Bank1_Func_910D

Bank1_Func_90DF:
    JSR Bank1_Func_90F1
    JMP Bank1_Func_911B

Bank1_Func_90E5:
    JSR Bank1_Func_90FF
    JMP Bank1_Func_911B

Bank1_Func_90EB:
    JSR Bank1_Func_90F1
    JMP Bank1_Func_910D

Bank1_Func_90F1:
    LDA a:$05BA,X
    SEC
    SBC #$02
    STA a:$05BA,X
    CMP #$04
    BCC Bank1_Label_9129
    RTS

Bank1_Func_90FF:
    LDA a:$05BA,X
    CLC
    ADC #$02
    STA a:$05BA,X
    CMP #$FC
    BCS Bank1_Label_9129
    RTS

Bank1_Func_910D:
    LDA a:$05C1,X
    SEC
    SBC #$02
    STA a:$05C1,X
    CMP #$10
    BCC Bank1_Label_9129
    RTS

Bank1_Func_911B:
    LDA a:$05C1,X
    CLC
    ADC #$02
    STA a:$05C1,X
    CMP #$E0
    BCS Bank1_Label_9129
    RTS

Bank1_Label_9129:
    LDA #$00
    STA a:$05B3,X
    RTS

Bank1_Func_912F:
    LDA $6F
    BEQ Bank1_Label_916E
    INC $6F
    LDA $6F
    CMP #$96
    BCS Bank1_Label_9172
    LDX $72
    LDA $70
    CLC
    ADC a:$97AD,X
    STA $70
    CMP #$F8
    BCS Bank1_Label_9172
    STA $67
    LDA $71
    CLC
    ADC a:$97A9,X
    STA $68
    STA $71
    CMP #$E0
    BCS Bank1_Label_9172
    JSR Bank1_Func_9377
    BNE Bank1_Label_9172
    LDA $73
    AND #$07
    BNE Bank1_Label_916E
    LDA $72
    CMP #$08
    BEQ Bank1_Label_916E
    BCS Bank1_Label_916F
    INC $72

Bank1_Label_916E:
    RTS

Bank1_Label_916F:
    DEC $72
    RTS

Bank1_Label_9172:
    LDA #$00
    STA $6F
    RTS

Bank1_Func_9177:
    LDA $6A
    BEQ Bank1_Label_91A3
    JSR Bank1_Func_9190
    LDA $85
    STA $67
    LDA $8C
    STA $68
    JSR Bank1_Func_9377
    BEQ Bank1_Label_918F
    LDA #$00
    STA $6A

Bank1_Label_918F:
    RTS

Bank1_Func_9190:
    LDA $6E
    BNE Bank1_Label_91A4
    INC $6B
    LDA $85
    CMP #$F8
    BCS Bank1_Label_91C8
    LDA $85
    CLC
    ADC #$08
    STA $85

Bank1_Label_91A3:
    RTS

Bank1_Label_91A4:
    CMP #$02
    BNE Bank1_Label_91B8
    INC $6B
    LDA $8C
    CMP #$F9
    BCS Bank1_Label_91C8
    LDA $8C
    CLC
    ADC #$07
    STA $8C
    RTS

Bank1_Label_91B8:
    INC $6B
    LDA $8C
    CMP #$10
    BCC Bank1_Label_91C8
    LDA $8C
    SEC
    SBC #$07
    STA $8C
    RTS

Bank1_Label_91C8:
    LDA #$00
    STA $6A

Bank1_Label_91CC:
    RTS

Bank1_Func_91CD:
    JSR Bank1_Func_9220
    JSR Bank1_Func_9208
    LDY #$D8
    LDX #$06

Bank1_Label_91D7:
    LDA a:$05B3,X
    BEQ Bank1_Label_91E6
    LDA a:$05C1,X
    STA $94
    LDA #$3D
    JSR Bank1_Func_96B1

Bank1_Label_91E6:
    DEX
    CPX #$03
    BNE Bank1_Label_91D7
    LDY #$C8

Bank1_Label_91ED:
    LDA a:$05B3,X
    BEQ Bank1_Label_9204
    LDA a:$05C1,X
    STA $94
    LDA $42
    BEQ Bank1_Label_91FF
    LDA #$3B
    BNE Bank1_Label_9201

Bank1_Label_91FF:
    LDA #$3A

Bank1_Label_9201:
    JSR Bank1_Func_96B1

Bank1_Label_9204:
    DEX
    BPL Bank1_Label_91ED
    RTS

Bank1_Func_9208:
    LDA $6F
    BEQ Bank1_Label_921F
    LDY #$E4
    LDA $71
    STA $94
    LDA #$3C
    STA $95
    LDA #$03
    STA $96
    LDA $70
    JMP Bank1_Func_96BA

Bank1_Label_921F:
    RTS

Bank1_Func_9220:
    LDA $6A
    BEQ Bank1_Label_91CC
    LDA $6B
    LSR A
    CMP #$08
    BCC Bank1_Label_922D
    LDA #$08

Bank1_Label_922D:
    STA $69
    ASL A
    ADC $69
    STA $69
    ASL A
    CLC
    ADC $69
    TAX
    LDY #$B8
    LDA $6E
    BEQ Bank1_Label_9242
    JMP Bank1_Label_9295

Bank1_Label_9242:
    LDA $85
    STA $60
    LDA #$20
    STA $6D
    LDA #$04
    STA $69

Bank1_Label_924E:
    LDA a:$9326,X
    BEQ Bank1_Label_9261
    LDA $8C
    SEC
    SBC $6D
    BCC Bank1_Label_9261
    CMP #$10
    BCC Bank1_Label_9261
    JSR Bank1_Func_92EC

Bank1_Label_9261:
    LDA $6D
    SEC
    SBC #$08
    STA $6D
    INX
    DEC $69
    BNE Bank1_Label_924E
    LDA #$00
    STA $6D
    LDA #$05
    STA $69

Bank1_Label_9275:
    LDA a:$9326,X
    BEQ Bank1_Label_9288
    LDA $8C
    CLC
    ADC $6D
    BCS Bank1_Label_9288
    CMP #$E0
    BCS Bank1_Label_9288
    JSR Bank1_Func_92EC

Bank1_Label_9288:
    LDA $6D
    CLC
    ADC #$08
    STA $6D
    INX
    DEC $69
    BNE Bank1_Label_9275
    RTS

Bank1_Label_9295:
    LDA $85
    STA $60
    LDA #$20
    STA $6D
    LDA #$04
    STA $69

Bank1_Label_92A1:
    LDA a:$9326,X
    BEQ Bank1_Label_92B6
    LDA $60
    SEC
    SBC $6D
    BCC Bank1_Label_92B6
    JSR Bank1_Func_9309
    SEC
    SBC $6D
    JSR Bank1_Func_96BA

Bank1_Label_92B6:
    LDA $6D
    SEC
    SBC #$08
    STA $6D
    INX
    DEC $69
    BNE Bank1_Label_92A1
    LDA #$00
    STA $6D
    LDA #$04
    STA $69

Bank1_Label_92CA:
    LDA a:$9326,X
    BEQ Bank1_Label_92DF
    LDA $85
    CLC
    ADC $6D
    BCS Bank1_Label_92DF
    JSR Bank1_Func_9309
    CLC
    ADC $6D
    JSR Bank1_Func_96BA

Bank1_Label_92DF:
    LDA $6D
    CLC
    ADC #$08
    STA $6D
    INX
    DEC $69
    BNE Bank1_Label_92CA
    RTS

Bank1_Func_92EC:
    STA $94
    LDA a:$9326,X
    PHA
    AND #$0F
    CLC
    ADC #$9F
    STA $95
    PLA
    BPL Bank1_Label_9300
    LDA #$82
    BNE Bank1_Label_9302

Bank1_Label_9300:
    LDA #$02

Bank1_Label_9302:
    STA $96
    LDA $60
    JMP Bank1_Func_96BA

Bank1_Func_9309:
    LDA $8C
    STA $94
    LDA a:$9326,X
    PHA
    AND #$0F
    CLC
    ADC #$A9
    STA $95
    PLA
    BPL Bank1_Label_931F
    LDA #$42
    BNE Bank1_Label_9321

Bank1_Label_931F:
    LDA #$02

Bank1_Label_9321:
    STA $96
    LDA $60
    RTS
    .byte $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $02, $03, $82, $00
    .byte $00, $00, $00, $00, $00, $04, $03, $84, $00, $00, $00, $00, $00, $05, $06, $07
    .byte $86, $85, $00, $00, $00, $00, $08, $07, $09, $87, $88, $00, $00, $00, $05, $06
    .byte $0A, $09, $8A, $86, $85, $00, $00, $08, $07, $0A, $09, $8A, $87, $88, $00, $05
    .byte $06, $0A, $09, $09, $09, $8A, $86, $85, $08, $07, $0A, $09, $09, $09, $8A, $87
    .byte $88

Bank1_Func_9377:
    LDA $68
    CLC
    ADC $40
    BCC Bank1_Label_9380
    ADC #$0F

Bank1_Label_9380:
    AND #$F0
    CMP #$F0
    BNE Bank1_Label_9388
    LDA #$00

Bank1_Label_9388:
    STA $69
    LDA $67
    CLC
    ADC $3F
    ROR A
    ROR A
    ROR A
    ROR A
    AND #$0F
    ORA $69
    TAY
    LDA a:$0400,Y
    PHA
    AND #$07
    TAY
    LDA a:$93AF,Y
    STA $AF
    PLA
    LSR A
    LSR A
    LSR A
    TAY
    LDA a:$BEC4,Y
    AND $AF
    RTS
    .byte $80, $40, $20, $10, $08, $04, $02, $01

Bank1_Func_93B7:
    JSR Bank1_Func_9606
    JSR Bank1_Func_9573
    JSR Bank1_Func_95B4
    JSR Bank1_Func_9534
    JSR Bank1_Func_94FE
    JSR Bank1_Func_9530
    JSR Bank1_Func_93EC
    JSR Bank1_Func_94BB
    JMP Bank1_Func_9450

Bank1_Func_93D2:
    LDY #$00

Bank1_Label_93D4:
    LDA a:$0300,Y
    CMP #$F8
    BEQ Bank1_Func_93E3
    INY
    INY
    INY
    INY
    BNE Bank1_Label_93D4
    SEC
    RTS

Bank1_Func_93E3:
    CLC
    RTS

Bank1_Func_93E5:
    JSR Bank1_Func_94FE
    JSR Bank1_Func_9534
    RTS

Bank1_Func_93EC:
    LDA $A8
    BEQ Bank1_Label_942F
    AND #$01
    LDX $42
    BEQ Bank1_Label_941A
    DEX
    BEQ Bank1_Label_9408
    TAX
    LDA $5C
    STA $67
    LDA $5D
    CLC
    ADC #$18
    STA $68
    JMP Bank1_Func_9430

Bank1_Label_9408:
    CLC
    ADC #$02
    TAX
    LDA $5C
    STA $67
    LDA $5D
    SEC
    SBC #$10
    STA $68
    JMP Bank1_Func_9430

Bank1_Label_941A:
    CLC
    ADC #$04
    TAX
    LDA $5D
    CLC
    ADC #$09
    STA $68
    LDA $5C
    CLC
    ADC #$10
    STA $67
    JSR Bank1_Func_9430

Bank1_Label_942F:
    RTS

Bank1_Func_9430:
    LDA $67
    STA $60
    STX $67
    LDA $68
    STA $61
    LDA #$00
    CPX #$02
    BCC Bank1_Label_9446
    CPX #$04
    BEQ Bank1_Label_9446
    LDA #$80

Bank1_Label_9446:
    STA $62
    JSR Bank1_Func_93D2
    BCS Bank1_Label_9498
    JMP Bank1_Label_946F

Bank1_Func_9450:
    LDX #$04
    LDA $7C,X
    BEQ Bank1_Label_9498
    CMP #$03
    BEQ Bank1_Label_9498
    JSR Bank1_Func_93D2
    BCS Bank1_Label_9498
    LDA #$00
    STA $62
    LDA $83,X
    STA $60
    LDA $8A,X
    STA $61
    LDA #$00
    STA $67

Bank1_Label_946F:
    LDA $67
    ASL A
    ASL A
    TAX
    JSR Bank1_Func_9477

Bank1_Func_9477:
    JSR Bank1_Func_9499
    LDA $67
    CMP #$04
    BCS Bank1_Label_9486
    LDA $62
    EOR #$40
    STA $62

Bank1_Label_9486:
    JSR Bank1_Func_9499
    LDA $67
    CMP #$04
    BCS Bank1_Label_9495
    LDA $62
    EOR #$40
    STA $62

Bank1_Label_9495:
    JMP Bank1_Label_9560

Bank1_Label_9498:
    RTS

Bank1_Func_9499:
    LDA $61
    STA $94
    LDA a:$978D,X
    STA $95
    LDA $62
    STA $96
    LDA $60
    STA $97
    LDA a:$978D,X
    BEQ Bank1_Label_94B2
    JSR Bank1_Func_96C8

Bank1_Label_94B2:
    INX
    LDA $97
    CLC
    ADC #$08
    STA $60
    RTS

Bank1_Func_94BB:
    LDA $82
    BEQ Bank1_Label_94FD
    CMP #$03
    BEQ Bank1_Label_94FD
    JSR Bank1_Func_93E3
    BCS Bank1_Label_94FD
    LDA $89
    STA $97
    LDA $90
    STA $94
    LDA #$3E
    STA $95
    LDX #$00
    JSR Bank1_Func_94ED
    JSR Bank1_Func_94ED
    LDA $97
    SEC
    SBC #$10
    STA $97
    LDA $94
    CLC
    ADC #$08
    STA $94
    JSR Bank1_Func_94ED

Bank1_Func_94ED:
    LDA a:$97A5,X
    STA $96
    JSR Bank1_Func_96C8
    LDA $97
    CLC
    ADC #$08
    STA $97
    INX

Bank1_Label_94FD:
    RTS

Bank1_Func_94FE:
    LDX #$03
    LDA $7C,X
    BEQ Bank1_Label_956E
    CMP #$03
    BEQ Bank1_Label_956E
    JSR Bank1_Func_93E3
    BCS Bank1_Label_956E
    LDA $83,X
    STA $97
    LDA $8A,X
    STA $94
    LDA #$01
    STA $96
    LDA #$EA
    STA $95
    JSR Bank1_Func_96C8
    LDA $97
    CLC
    ADC #$08
    STA $97
    LDA $96
    ORA #$40
    STA $96
    JMP Bank1_Func_96C8

Bank1_Func_9530:
    LDX #$05
    BNE Bank1_Label_9536

Bank1_Func_9534:
    LDX #$02

Bank1_Label_9536:
    LDA $7C,X
    BEQ Bank1_Label_956E
    CMP #$03
    BEQ Bank1_Label_956E
    JSR Bank1_Func_93D2
    BCS Bank1_Label_956E
    LDA a:$956D,X
    STA $62
    LDA $83,X
    STA $60
    LDA $8A,X
    STA $61
    TXA
    ASL A
    ASL A
    CLC
    ADC #$94
    TAX
    JSR Bank1_Func_955A

Bank1_Func_955A:
    JSR Bank1_Func_966B
    JSR Bank1_Func_966B

Bank1_Label_9560:
    LDA $60
    SEC
    SBC #$10
    STA $60
    LDA $61
    CLC
    ADC #$08
    STA $61

Bank1_Label_956E:
    RTS
    .byte $01, $01, $00, $00

Bank1_Func_9573:
    LDA $7C
    BEQ Bank1_Label_956E
    LDY #$30
    CMP #$03
    BEQ Bank1_Label_9591
    LDX #$18
    LDA $73
    AND #$10
    BEQ Bank1_Label_9586
    INX

Bank1_Label_9586:
    LDA $83
    STA $60
    LDA $8A
    STA $61
    JMP Bank1_Label_95F8

Bank1_Label_9591:
    LDA $5F
    SEC
    SBC #$2F
    BPL Bank1_Label_959A
    ADC #$30

Bank1_Label_959A:
    TAX
    LDA a:$0200,X
    STA $60
    STA $83
    LDA a:$0230,X
    STA $61
    STA $8A
    LDA $42
    ASL A
    CLC
    ADC #$12
    TAX
    JMP Bank1_Label_95F1

Bank1_Label_95B3:
    RTS

Bank1_Func_95B4:
    LDA $7D
    BEQ Bank1_Label_95B3
    LDY #$18
    CMP #$03
    BEQ Bank1_Label_95D2
    LDX #$10
    LDA $73
    AND #$10
    BEQ Bank1_Label_95C7
    INX

Bank1_Label_95C7:
    LDA $84
    STA $60
    LDA $8B
    STA $61
    JMP Bank1_Label_95F8

Bank1_Label_95D2:
    LDA $5F
    SEC
    SBC #$17
    BPL Bank1_Label_95DB
    ADC #$30

Bank1_Label_95DB:
    TAX
    LDA a:$0200,X
    STA $60
    STA $84
    LDA a:$0230,X
    STA $61
    STA $8B
    LDA $42
    ASL A
    CLC
    ADC #$0A
    TAX

Bank1_Label_95F1:
    LDA $73
    AND #$02
    BEQ Bank1_Label_95F8
    INX

Bank1_Label_95F8:
    LDA #$21
    STA $62
    TXA
    STA $98
    ASL A
    ADC $98
    ASL A
    TAX
    BNE Bank1_Label_965B

Bank1_Func_9606:
    LDY #$00
    LDA #$00
    STA $62
    LDA $A2
    BNE Bank1_Label_9619
    LDX $A0
    BEQ Bank1_Label_9628
    LDA $73
    ROR A
    BCS Bank1_Label_966A

Bank1_Label_9619:
    CPX #$50
    BCC Bank1_Label_9628
    LDA $73
    AND #$08
    LSR A
    LSR A
    LSR A
    ADC #$08
    BNE Bank1_Label_964C

Bank1_Label_9628:
    LDA $42
    BEQ Bank1_Label_963D
    TAX
    LDA $73
    AND #$02
    LSR A
    ADC #$04
    CPX #$01
    BEQ Bank1_Label_964C
    CLC
    ADC #$02
    BNE Bank1_Label_964C

Bank1_Label_963D:
    LDA $73
    AND #$02
    LSR A
    TAX
    LDA $73
    AND #$10
    BEQ Bank1_Label_964B
    INX
    INX

Bank1_Label_964B:
    TXA

Bank1_Label_964C:
    STA $98
    ASL A
    ADC $98
    ASL A
    TAX
    LDA $5C
    STA $60
    LDA $5D
    STA $61

Bank1_Label_965B:
    JSR Bank1_Func_9661
    JSR Bank1_Func_9661

Bank1_Func_9661:
    JSR Bank1_Func_9688
    JSR Bank1_Func_9688
    JMP Bank1_Label_9560

Bank1_Label_966A:
    RTS

Bank1_Func_966B:
    LDA $61
    STA $94
    LDA a:$96E1,X
    STA $95
    LDA $62
    STA $96
    LDA $60
    STA $97
    INX
    JSR Bank1_Func_96C8
    LDA $97
    CLC
    ADC #$08
    STA $60
    RTS

Bank1_Func_9688:
    LDA $61
    STA $94
    LDA a:$96E1,X
    BPL Bank1_Label_969B
    AND #$7F
    STA $95
    LDA $62
    ORA #$40
    BNE Bank1_Label_969F

Bank1_Label_969B:
    STA $95
    LDA $62

Bank1_Label_969F:
    STA $96
    LDA $60
    STA $97
    INX
    JSR Bank1_Func_96BC
    LDA $97
    CLC
    ADC #$08
    STA $60
    RTS

Bank1_Func_96B1:
    STA $95
    LDA #$02
    STA $96
    LDA a:$05BA,X

Bank1_Func_96BA:
    STA $97

Bank1_Func_96BC:
    TYA
    EOR $93
    TAY
    JSR Bank1_Func_96C8
    TYA
    EOR $93
    TAY
    RTS

Bank1_Func_96C8:
    LDA $94
    STA a:$0300,Y
    INY
    LDA $95
    STA a:$0300,Y
    INY
    LDA $96
    STA a:$0300,Y
    INY
    LDA $97
    STA a:$0300,Y
    INY
    RTS
    .byte $00, $01, $10, $11, $20, $21, $04, $05, $10, $11, $20, $21, $00, $01, $10, $11
    .byte $14, $15, $04, $05, $10, $11, $14, $15, $03, $83, $13, $93, $23, $A3, $03, $83
    .byte $13, $93, $23, $A3, $02, $82, $12, $24, $22, $A2, $02, $82, $A4, $92, $22, $A2
    .byte $06, $07, $16, $17, $37, $25, $87, $86, $97, $96, $A5, $B7, $0E, $0F, $1E, $1F
    .byte $2E, $2F, $30, $39, $1E, $1F, $2E, $2F, $0D, $8D, $1D, $9D, $2D, $AD, $0D, $8D
    .byte $1D, $9D, $2D, $AD, $31, $B1, $33, $34, $32, $B2, $31, $B1, $35, $36, $32, $B2
    .byte $0D, $8D, $1D, $9D, $2D, $AD, $0D, $8D, $2C, $AC, $2D, $AD, $09, $0A, $19, $1A
    .byte $29, $2A, $38, $26, $19, $1A, $29, $2A, $08, $88, $18, $98, $28, $A8, $08, $88
    .byte $18, $98, $28, $A8, $0B, $8B, $1B, $27, $2B, $AB, $0B, $8B, $A7, $9B, $2B, $AB
    .byte $08, $88, $18, $98, $28, $A8, $08, $88, $0C, $8C, $28, $A8, $D6, $D7, $E6, $E7
    .byte $00, $00, $EA, $EA, $D0, $D0, $E0, $E0, $D4, $D5, $E4, $E5, $D0, $D0, $E0, $E0
    .byte $D1, $D1, $00, $00, $E0, $E0, $D0, $D0, $00, $00, $D1, $D1, $D3, $D2, $E1, $00
    .byte $E1, $00, $D3, $D2, $01, $41, $81, $C1, $FD, $FD, $FE, $FF, $00, $01, $02, $03
    .byte $03, $03, $02, $01, $00, $FF, $FE, $FD, $FD, $FD, $FE, $FF, $C1, $C1, $C2, $C1
    .byte $C2, $C2, $C1, $C2

Bank1_Func_97C5:
    LDX $A9
    LDA $A4
    BNE Bank1_Label_97D5
    LDA $58
    CMP a:$98BB,X
    BNE Bank1_Label_97D4
    INC $A4

Bank1_Label_97D4:
    RTS

Bank1_Label_97D5:
    CMP #$02
    BEQ Bank1_Label_97FC
    LDA $3F
    CMP #$F0
    BNE Bank1_Label_97D4
    INC $A4
    LDA #$04
    STA a:$02AA
    LDA a:$98BE,X
    STA a:$0558
    LDA a:$98C1,X
    STA a:$055F
    LDA a:$98C4,X
    STA a:$0566
    LDX #$00
    BEQ Bank1_Func_9858

Bank1_Label_97FC:
    LDA a:$0558
    BNE Bank1_Label_9809
    LDA #$04
    JSR Bank1_Func_A87A
    JMP Bank1_Func_98A3

Bank1_Label_9809:
    LDX $A9
    BEQ Bank1_Label_9864
    DEX
    BEQ Bank1_Label_9834
    LDA $73
    AND #$07
    BNE Bank1_Label_9822
    LDX #$06

Bank1_Label_9818:
    LDA a:$0558,X
    BEQ Bank1_Label_9823
    DEX
    CPX #$03
    BNE Bank1_Label_9818

Bank1_Label_9822:
    RTS

Bank1_Label_9823:
    LDA #$04
    STA a:$0558,X
    LDA #$30
    STA a:$0566,X
    LDA #$C8
    STA a:$055F,X
    BNE Bank1_Func_9858

Bank1_Label_9834:
    LDA $73
    AND #$07
    BNE Bank1_Label_98A2
    LDX #$06

Bank1_Label_983C:
    LDA a:$0558,X
    BEQ Bank1_Label_9847
    DEX
    CPX #$03
    BNE Bank1_Label_983C
    RTS

Bank1_Label_9847:
    LDA #$14
    STA a:$0558,X
    LDA a:$0566
    STA a:$0566,X
    LDA a:$055F
    STA a:$055F,X

Bank1_Func_9858:
    JSR Bank1_Func_9CD8

Bank1_Func_985B:
    LDA #$00
    STA a:$0582,X
    STA a:$057B,X
    RTS

Bank1_Label_9864:
    LDA $73
    AND #$03
    BNE Bank1_Label_98A2
    LDX #$06

Bank1_Label_986C:
    LDA a:$0558,X
    BEQ Bank1_Label_9875
    DEX
    BPL Bank1_Label_986C
    RTS

Bank1_Label_9875:
    LDA #$08
    JSR Bank1_Func_A856
    LDA #$10
    STA a:$0558,X
    LDA #$80
    STA a:$0566,X
    LDA $73
    AND #$04
    ASL A
    ASL A
    CLC
    ADC #$CE
    STA a:$055F,X
    JSR Bank1_Func_9858
    LDA $73
    LSR A
    LSR A
    LSR A
    LSR A
    AND #$0F
    TAY
    LDA a:$98AB,Y
    STA a:$0574,X

Bank1_Label_98A2:
    RTS

Bank1_Func_98A3:
    LDA #$05
    STA a:$02AA
    INC $B3
    RTS
    .byte $02, $03, $04, $05, $06, $07, $08, $09, $0A, $09, $08, $07, $06, $05, $04, $03
    .byte $11, $40, $67, $11, $12, $13, $DC, $78, $B4, $98, $50, $64

Bank1_Func_98C7:
    STX $75
    LDX #$06

Bank1_Label_98CB:
    LDA a:$0558,X
    BEQ Bank1_Label_98D6
    DEX
    BPL Bank1_Label_98CB
    LDX $75
    RTS

Bank1_Label_98D6:
    LDA $42
    BEQ Bank1_Label_98DE
    LDA #$01
    BNE Bank1_Label_98E0

Bank1_Label_98DE:
    LDA #$1E

Bank1_Label_98E0:
    STA a:$056D,X
    LDA $74
    STA a:$0558,X
    LDA $75
    STA a:$055F,X
    LDA $42
    STA a:$0574,X
    JSR Bank1_Func_985B
    LDX $75
    RTS

Bank1_Func_98F8:
    LDX #$06
    LDA #$00

Bank1_Label_98FC:
    STA a:$0558,X
    DEX
    BPL Bank1_Label_98FC
    LDX #$05

Bank1_Label_9904:
    STA a:$0595,X
    DEX
    BPL Bank1_Label_9904
    LDX #$06

Bank1_Label_990C:
    STA a:$05B3,X
    DEX
    BPL Bank1_Label_990C
    RTS

Bank1_Func_9913:
    LDX #$06

Bank1_Label_9915:
    LDA a:$0558,X
    BNE Bank1_Label_991D

Bank1_Label_991A:
    JMP Bank1_Label_9A3F

Bank1_Label_991D:
    BPL Bank1_Label_9922
    JMP Bank1_Label_99F6

Bank1_Label_9922:
    STX $76
    CMP #$70
    BCC Bank1_Label_9946
    JSR Bank1_Func_A0DC
    LDA $73
    AND #$07
    BNE Bank1_Label_991A
    INC a:$0558,X
    LDA a:$0558,X
    CMP #$7B
    BEQ Bank1_Label_993F
    CMP #$74
    BNE Bank1_Label_991A

Bank1_Label_993F:
    LDA #$00
    STA a:$0558,X
    BEQ Bank1_Label_991A

Bank1_Label_9946:
    STA $9F
    ASL A
    TAX
    LDA #$99
    PHA
    LDA #$64
    PHA
    LDA a:$A571,X
    PHA
    LDA a:$A570,X
    PHA
    LDX $76
    LDA a:$055F,X
    STA $67
    LDA a:$0566,X
    STA $68
    RTS
    .byte $A6, $76, $A4, $9F, $BD, $58, $05, $F0, $AC, $BD, $5F, $05, $85, $98, $BD, $66
    .byte $05, $85, $99, $20, $46, $9A, $90, $63, $FE, $82, $05, $BD, $58, $05, $C9, $11
    .byte $B0, $0A, $A5, $27, $D0, $0E, $A5, $7E, $C9, $03, $F0, $08, $BD, $82, $05, $D9
    .byte $11, $A5, $90, $3F, $A5, $27, $D0, $04, $A5, $7E, $F0, $04, $A9, $78, $D0, $02
    .byte $A9, $70, $48, $BD, $58, $05, $A8, $C9, $02, $D0, $10, $E6, $B8, $A5, $B8, $C9
    .byte $04, $D0, $0C, $A9, $02, $85, $7F, $85, $86, $85, $8D, $A9, $00, $85, $B8, $B9
    .byte $99, $A5, $F0, $03, $20, $C9, $81, $A9, $05, $20, $56, $A8, $68, $9D, $58, $05
    .byte $4C, $3F, $9A, $A9, $03, $20, $56, $A8, $4C, $3F, $9A, $FE, $7B, $05, $BD, $7B
    .byte $05, $D9, $FD, $A4, $90, $54, $A9, $00, $9D, $7B, $05, $20, $40, $A1, $4C, $3F
    .byte $9A

Bank1_Label_99F6:
    DEC a:$056D,X
    BNE Bank1_Label_9A3F
    LDA #$00
    STA a:$057B,X
    LDA a:$0574,X
    BEQ Bank1_Label_9A23
    PHA
    LDA a:$055F,X
    ASL A
    ASL A
    ASL A
    ASL A
    STA a:$055F,X
    PLA
    CMP #$01
    BEQ Bank1_Label_9A1C
    LDA #$EC
    STA a:$0566,X
    BNE Bank1_Label_9A32

Bank1_Label_9A1C:
    LDA #$F4
    STA a:$0566,X
    BNE Bank1_Label_9A32

Bank1_Label_9A23:
    LDA a:$055F,X
    ASL A
    ASL A
    ASL A
    ASL A
    STA a:$0566,X
    LDA #$F0
    STA a:$055F,X

Bank1_Label_9A32:
    LDA a:$0558,X
    AND #$1F
    EOR #$10
    CLC
    ADC #$01
    STA a:$0558,X

Bank1_Label_9A3F:
    DEX
    BMI Bank1_Label_9A45
    JMP Bank1_Label_9915

Bank1_Label_9A45:
    RTS
    .byte $86, $9A, $A5, $27, $D0, $06, $A5, $7E, $C9, $03, $D0, $08, $20, $BE, $9A, $90
    .byte $03, $A6, $9A, $60, $A5, $6F, $F0, $05, $20, $9B, $9A, $B0, $F4, $A2, $06, $BD
    .byte $B3, $05, $F0, $2A, $BD, $C1, $05, $38, $E5, $99, $90, $06, $C9, $11, $B0, $1E
    .byte $90, $04, $C9, $F8, $90, $18, $A5, $98, $38, $FD, $BA, $05, $90, $0C, $C9, $11
    .byte $B0, $0C, $A9, $00, $9D, $B3, $05, $38, $F0, $08, $C9, $F8, $B0, $F4, $CA, $10
    .byte $CE, $18, $A6, $9A, $60, $A5, $71, $38, $E5, $99, $90, $06, $C9, $15, $B0, $16
    .byte $90, $04, $C9, $F4, $90, $10, $A5, $98, $38, $E5, $70, $90, $06, $C9, $15, $B0
    .byte $05, $38, $60, $C9, $F4, $60, $18, $60, $A5, $6A, $F0, $D5, $A5, $42, $F0, $32
    .byte $A5, $99, $38, $E5, $8C, $90, $06, $C9, $11, $90, $06, $18, $60, $C9, $F8, $90
    .byte $FA, $A5, $6B, $C9, $10, $90, $02, $A9, $10, $0A, $85, $9B, $A5, $85, $38, $E5
    .byte $9B, $E9, $10, $C5, $98, $B0, $E4, $65, $9B, $65, $9B, $69, $08, $C5, $98, $B0
    .byte $33, $60, $A5, $98, $38, $E5, $85, $90, $06, $C9, $11, $90, $06, $18, $60, $C9
    .byte $F8, $90, $FA, $A5, $6B, $C9, $10, $90, $02, $A9, $10, $0A, $85, $9B, $A5, $8C
    .byte $38, $E5, $9B, $E9, $10, $C5, $99, $B0, $E4, $65, $9B, $65, $9B, $69, $08, $C5
    .byte $99, $B0, $01, $60, $A9, $00, $85, $6A, $60, $FE, $6D, $05, $20, $DC, $A0, $BD
    .byte $58, $05, $F0, $05, $DE, $5F, $05, $F0, $01, $60

Bank1_Func_9B40:
    LDA #$00
    STA a:$0558,X
    RTS
    .byte $A9, $00, $85, $98, $BD, $6D, $05, $29, $10, $F0, $02, $E6, $98, $A5, $98, $4C
    .byte $5B, $A3, $A9, $02, $85, $98, $A5, $73, $29, $20, $F0, $02, $E6, $98, $A5, $5C
    .byte $DD, $5F, $05, $A9, $00, $2A, $85, $63, $A5, $98, $4C, $5B, $A3, $BD, $74, $05
    .byte $F0, $4F, $FE, $6D, $05, $BD, $6D, $05, $C9, $28, $B0, $12, $BD, $66, $05, $38
    .byte $E5, $5D, $B0, $04, $C9, $FA, $B0, $06, $C9, $05, $90, $02, $B0, $30, $A5, $5C
    .byte $18, $69, $04, $38, $FD, $5F, $05, $F0, $47, $B0, $0F, $49, $FF, $C5, $5E, $90
    .byte $6B, $BD, $5F, $05, $38, $E5, $5E, $4C, $BA, $9B, $C5, $5E, $90, $5E, $BD, $5F
    .byte $05, $18, $65, $5E, $85, $67, $20, $77, $93, $D0, $03, $20, $2B, $9D, $4C, $DC
    .byte $A0, $FE, $6D, $05, $BD, $6D, $05, $C9, $32, $B0, $0C, $BD, $5F, $05, $38, $E5
    .byte $5C, $C9, $05, $90, $02, $B0, $E7, $A5, $5D, $18, $69, $08, $38, $FD, $66, $05
    .byte $F0, $2A, $B0, $0F, $49, $FF, $C5, $5E, $90, $22, $BD, $66, $05, $38, $E5, $5E
    .byte $4C, $03, $9C, $C5, $5E, $90, $15, $BD, $66, $05, $18, $65, $5E, $85, $68, $20
    .byte $77, $93, $D0, $05, $A5, $68, $9D, $66, $05, $4C, $DC, $A0, $20, $D8, $9C, $4C
    .byte $DC, $A0, $A5, $73, $29, $18, $4A, $4A, $4A, $AA, $BD, $28, $9C, $A6, $76, $4C
    .byte $5B, $A3, $04, $05, $06, $05, $20, $DC, $A0, $A5, $73, $29, $01, $D0, $03, $FE
    .byte $6D, $05, $BD, $6D, $05, $29, $1F, $A8, $BD, $66, $05, $18, $79, $AE, $A5, $C9
    .byte $F0, $B0, $39, $85, $68, $BD, $6D, $05, $C9, $20, $90, $0B, $BD, $5F, $05, $18
    .byte $69, $02, $B0, $28, $4C, $65, $9C, $BD, $5F, $05, $38, $E9, $02, $90, $1D, $85
    .byte $67, $20, $77, $93, $D0, $06, $20, $2B, $9D, $4C, $78, $9C, $FE, $6D, $05, $FE
    .byte $6D, $05, $BD, $6D, $05, $C9, $40, $90, $25, $4C, $D8, $9C, $4C, $40, $9B, $A9
    .byte $08, $85, $98, $A5, $73, $29, $08, $F0, $02, $C6, $98, $A5, $98, $4C, $5B, $A3
    .byte $20, $DC, $A0, $FE, $6D, $05, $BD, $6D, $05, $38, $E9, $32, $B0, $01, $60, $29
    .byte $1F, $A8, $BD, $66, $05, $38, $F9, $AE, $A5, $85, $68, $BD, $6D, $05, $C9, $52
    .byte $90, $09, $BD, $5F, $05, $38, $E9, $02, $4C, $C7, $9C, $BD, $5F, $05, $18, $69
    .byte $02, $85, $67, $20, $77, $93, $D0, $03, $20, $2B, $9D, $BD, $6D, $05, $C9, $72
    .byte $D0, $05

Bank1_Func_9CD8:
    LDA #$00
    STA a:$056D,X
    RTS
    .byte $BD, $6D, $05, $C9, $32, $B0, $06, $A9, $0B, $85, $98, $D0, $15, $A9, $09, $85
    .byte $98, $A5, $73, $29, $04, $F0, $02, $E6, $98, $BD, $6D, $05, $C9, $54, $B0, $02
    .byte $E6, $63, $A5, $98, $4C, $5B, $A3, $20, $E4, $9D, $BD, $58, $05, $F0, $28, $FE
    .byte $6D, $05, $BD, $6D, $05, $29, $20, $D0, $1E, $BD, $6D, $05, $29, $0F, $A8, $BD
    .byte $66, $05, $38, $F9, $CE, $A5, $85, $68, $20, $77, $93, $D0, $0A, $A5, $67, $9D
    .byte $5F, $05, $A5, $68, $9D, $66, $05, $60, $A9, $0C, $85, $98, $BD, $6D, $05, $29
    .byte $20, $F0, $08, $A5, $73, $29, $04, $F0, $02, $E6, $98, $A5, $98, $4C, $5B, $A3
    .byte $BD, $74, $05, $D0, $0B, $BD, $6D, $05, $C9, $07, $F0, $17, $FE, $6D, $05, $60
    .byte $BD, $6D, $05, $D0, $0E, $BD, $5F, $05, $18, $69, $08, $9D, $5F, $05, $A9, $07
    .byte $9D, $6D, $05, $20, $DC, $A0, $BD, $66, $05, $C9, $20, $90, $1F, $C9, $D0, $B0
    .byte $1B, $BD, $5F, $05, $C9, $F0, $B0, $14, $C9, $10, $90, $10, $A5, $73, $29, $03
    .byte $D0, $0A, $A0, $05, $B9, $95, $05, $F0, $04, $88, $10, $F8, $60, $A9, $08, $20
    .byte $56, $A8, $BD, $5F, $05, $18, $69, $04, $99, $8F, $05, $BD, $66, $05, $99, $95
    .byte $05, $A9, $80, $99, $89, $05, $A5, $73, $29, $1C, $6A, $6A, $09, $F8, $99, $A7
    .byte $05, $29, $01, $0A, $38, $E9, $01, $99, $A1, $05, $60, $BD, $6D, $05, $C9, $07
    .byte $D0, $F8, $A9, $0E, $85, $98, $A5, $73, $29, $20, $F0, $02, $E6, $98, $A5, $98
    .byte $4C, $5B, $A3, $20, $E4, $9D, $20, $DC, $A0, $4C, $DC, $A0, $A5, $73, $29, $0C
    .byte $4A, $4A, $AA, $BD, $02, $9E, $85, $63, $BD, $FE, $9D, $A6, $76, $4C, $5B, $A3
    .byte $11, $11, $12, $12, $00, $01, $01, $00, $BD, $6D, $05, $D0, $0C, $FE, $6D, $05
    .byte $BD, $5F, $05, $38, $E9, $0C, $9D, $5F, $05, $4C, $DC, $A0, $60, $BD, $6D, $05
    .byte $C9, $50, $B0, $12, $BD, $6D, $05, $BD, $74, $05, $F0, $4B, $FE, $6D, $05, $BD
    .byte $6D, $05, $C9, $28, $B0, $03, $4C, $DC, $A0, $BD, $6D, $05, $C9, $3C, $B0, $27
    .byte $A5, $5C, $18, $69, $04, $38, $FD, $5F, $05, $F0, $0B, $BD, $5F, $05, $B0, $02
    .byte $E9, $05, $69, $02, $85, $67, $20, $77, $93, $D0, $06, $20, $2B, $9D, $4C, $DC
    .byte $A0, $20, $D8, $9C, $4C, $DC, $A0, $BD, $66, $05, $C5, $5D, $B0, $02, $69, $09
    .byte $E9, $04, $85, $68, $4C, $54, $9E, $FE, $6D, $05, $BD, $6D, $05, $C9, $28, $B0
    .byte $03, $4C, $DC, $A0, $BD, $6D, $05, $C9, $3C, $B0, $19, $A5, $5D, $18, $69, $08
    .byte $38, $FD, $66, $05, $F0, $C0, $BD, $66, $05, $B0, $02, $E9, $05, $69, $02, $85
    .byte $68, $4C, $54, $9E, $BD, $5F, $05, $C5, $5C, $B0, $02, $69, $09, $E9, $04, $85
    .byte $67, $4C, $54, $9E, $A5, $73, $29, $08, $6A, $6A, $6A, $69, $24, $4C, $5B, $A3
    .byte $BD, $74, $05, $F0, $0E, $BC, $6D, $05, $A5, $67, $18, $79, $DE, $A5, $85, $67
    .byte $4C, $DC, $9E, $BC, $6D, $05, $A5, $68, $18, $79, $DE, $A5, $85, $68, $20, $77
    .byte $93, $D0, $0C, $20, $2B, $9D, $9D, $66, $05, $A5, $73, $29, $03, $D0, $0B, $FE
    .byte $6D, $05, $BD, $6D, $05, $29, $0F, $9D, $6D, $05, $4C, $DC, $A0, $BD, $6D, $05
    .byte $29, $08, $85, $67, $A5, $73, $29, $10, $6A, $6A, $05, $67, $6A, $6A, $69, $20
    .byte $4C, $5B, $A3, $BD, $5F, $05, $18, $79, $C2, $A2, $79, $C2, $A2, $85, $67, $20
    .byte $77, $93, $F0, $06, $FE, $6D, $05, $4C, $DC, $A0, $20, $2B, $9D, $4C, $DC, $A0
    .byte $A5, $73, $29, $08, $6A, $6A, $6A, $69, $26, $4C, $5B, $A3, $BD, $6D, $05, $D0
    .byte $0F, $FE, $6D, $05, $BD, $66, $05, $18, $69, $10, $9D, $66, $05, $4C, $DC, $A0
    .byte $C9, $28, $B0, $06, $FE, $6D, $05, $4C, $DC, $A0, $BC, $6D, $05, $BD, $66, $05
    .byte $18, $79, $DA, $A5, $9D, $66, $05, $C9, $F0, $B0, $18, $A5, $73, $29, $03, $D0
    .byte $0F, $FE, $6D, $05, $BD, $6D, $05, $C9, $38, $D0, $05, $A9, $28, $9D, $6D, $05
    .byte $4C, $DC, $A0, $4C, $40, $9B, $BD, $6D, $05, $C9, $28, $90, $0E, $C9, $30, $90
    .byte $05, $A9, $1F, $4C, $5B, $A3, $A9, $1E, $4C, $5B, $A3, $60, $BC, $6D, $05, $A5
    .byte $73, $29, $03, $D0, $1F, $BD, $66, $05, $18, $79, $EE, $A5, $9D, $66, $05, $BD
    .byte $5F, $05, $18, $79, $F2, $A5, $9D, $5F, $05, $FE, $6D, $05, $BD, $6D, $05, $29
    .byte $0F, $9D, $6D, $05, $4C, $DC, $A0, $20, $DC, $A0, $FE, $66, $05, $FE, $66, $05
    .byte $FE, $66, $05, $BC, $6D, $05, $BD, $66, $05, $18, $79, $EE, $A5, $9D, $66, $05
    .byte $BD, $5F, $05, $18, $79, $F2, $A5, $9D, $5F, $05, $FE, $6D, $05, $BD, $6D, $05
    .byte $29, $0F, $9D, $6D, $05, $60, $DE, $5F, $05, $DE, $5F, $05, $DE, $5F, $05, $A5
    .byte $73, $6A, $B0, $0D, $BD, $66, $05, $38, $FD, $74, $05, $9D, $66, $05, $DE, $74
    .byte $05, $20, $77, $93, $F0, $03, $20, $40, $9B, $A5, $73, $29, $0F, $D0, $03, $FE
    .byte $6D, $05, $60, $BD, $6D, $05, $48, $29, $01, $AA, $68, $C9, $02, $90, $06, $29
    .byte $01, $18, $69, $02, $AA, $BD, $39, $A0, $4C, $5B, $A3, $17, $18, $19, $18, $60
    .byte $20, $C4, $A0, $A5, $73, $29, $03, $F0, $10, $60, $A5, $73, $29, $01, $D0, $14
    .byte $20, $C4, $A0, $A5, $73, $29, $02, $D0, $0B, $FE, $6D, $05, $BD, $6D, $05, $29
    .byte $0F, $9D, $6D, $05, $60, $A5, $73, $29, $10, $6A, $6A, $69, $30, $D0, $06, $A5
    .byte $73, $29, $04, $69, $28, $85, $67, $20, $8C, $A0, $20, $8C, $A0, $A5, $60, $18
    .byte $69, $10, $85, $60, $A5, $61, $38, $E9, $20, $85, $61, $20, $8C, $A0, $A5, $67
    .byte $20, $5B, $A3, $A5, $60, $38, $E9, $10, $85, $60, $A5, $61, $18, $69, $08, $85
    .byte $61, $E6, $67, $60, $FE, $66, $05, $DE, $5F, $05, $DE, $5F, $05, $DE, $5F, $05
    .byte $BD, $5F, $05, $C9, $F0, $90, $03, $4C, $40, $9B, $60, $A5, $73, $29, $04, $6A
    .byte $6A, $69, $38, $4C, $5B, $A3, $BC, $6D, $05, $BD, $66, $05, $18, $79, $EE, $A5
    .byte $9D, $66, $05, $BD, $5F, $05, $18, $79, $F2, $A5, $9D, $5F, $05, $60

Bank1_Func_A0DC:
    LDA $41
    BEQ Bank1_Label_A114
    LDY $42
    BEQ Bank1_Label_A103
    DEY
    BEQ Bank1_Label_A0F4
    DEC a:$0566,X
    BEQ Bank1_Label_A111
    LDA a:$0566,X
    CMP #$F0
    BCS Bank1_Label_A111
    RTS

Bank1_Label_A0F4:
    INC a:$0566,X
    LDA a:$0566,X
    CMP #$E0
    BCC Bank1_Label_A102
    CMP #$F2
    BCC Bank1_Label_A111

Bank1_Label_A102:
    RTS

Bank1_Label_A103:
    LDA $45
    BNE Bank1_Label_A114
    DEC a:$055F,X
    LDA a:$055F,X
    CMP #$FA
    BCC Bank1_Label_A114

Bank1_Label_A111:
    JSR Bank1_Func_9B40

Bank1_Label_A114:
    RTS

Bank1_Func_A115:
    LDA $41
    BEQ Bank1_Label_A114
    LDY $42
    BEQ Bank1_Label_A131
    DEY
    BEQ Bank1_Label_A126
    DEC a:$0595,X
    BEQ Bank1_Label_A13A
    RTS

Bank1_Label_A126:
    INC a:$0595,X
    LDA a:$0595,X
    CMP #$D0
    BCS Bank1_Label_A13A
    RTS

Bank1_Label_A131:
    LDA $45
    BNE Bank1_Label_A13F
    DEC a:$058F,X
    BNE Bank1_Label_A13F

Bank1_Label_A13A:
    LDA #$00
    STA a:$0595,X

Bank1_Label_A13F:
    RTS
    .byte $A5, $A0, $D0, $FB, $86, $79, $A5, $5C, $18, $69, $04, $85, $A6, $A5, $5D, $69
    .byte $08, $85, $A7, $A5, $41, $F0, $27, $A5, $42, $F0, $18, $C9, $01, $F0, $0A, $A5
    .byte $5D, $18, $69, $1F, $85, $A7, $4C, $70, $A1, $A5, $5D, $38, $E9, $1F, $85, $A7
    .byte $4C, $7E, $A1, $A5, $5C, $18, $69, $40, $90, $02, $A9, $FF, $85, $A6, $BD, $5F
    .byte $05, $85, $77, $BD, $66, $05, $85, $78, $A0, $05, $B9, $95, $05, $F0, $04, $88
    .byte $10, $F8, $60, $A5, $77, $18, $69, $04, $99, $8F, $05, $38, $E5, $A6, $A2, $03
    .byte $B0, $03, $CA, $49, $FF, $99, $A1, $05, $A5, $78, $18, $69, $04, $99, $95, $05
    .byte $38, $E5, $A7, $B0, $04, $CA, $CA, $49, $FF, $99, $A7, $05, $D9, $A1, $05, $B0
    .byte $04, $8A, $69, $04, $AA, $8A, $99, $89, $05, $A9, $00, $99, $AD, $05, $A6, $79
    .byte $60

Bank1_Func_A1D1:
    LDX #$05

Bank1_Label_A1D3:
    LDA a:$0595,X
    BEQ Bank1_Label_A233
    LDA a:$0589,X
    BPL Bank1_Label_A21B
    JSR Bank1_Func_A115
    LDA a:$0595,X
    BEQ Bank1_Label_A233
    LDA a:$058F,X
    CLC
    ADC a:$05A1,X
    CMP #$F0
    BCS Bank1_Label_A213
    STA a:$058F,X
    LDA a:$0595,X
    CLC
    ADC a:$05A7,X
    CMP #$E0
    BCS Bank1_Label_A213
    STA a:$0595,X
    LDA $73
    AND #$03
    BNE Bank1_Label_A269
    INC a:$05A7,X
    LDA a:$05A7,X
    BMI Bank1_Label_A269
    CMP #$08
    BCC Bank1_Label_A269

Bank1_Label_A213:
    LDA #$00
    STA a:$0595,X
    JMP Bank1_Label_A2BE

Bank1_Label_A21B:
    JSR Bank1_Func_A115
    LDA a:$0595,X
    BEQ Bank1_Label_A233
    INC a:$05AD,X
    LDA a:$05AD,X
    CMP #$8C
    BCC Bank1_Label_A236
    LDA #$00
    STA a:$0595,X
    RTS

Bank1_Label_A233:
    JMP Bank1_Label_A2BE

Bank1_Label_A236:
    LDY a:$0589,X
    CPY #$04
    BCC Bank1_Label_A26C
    LDA a:$058F,X
    CLC
    ADC a:$A2BE,Y
    BEQ Bank1_Label_A29F
    STA a:$058F,X
    LDA a:$059B,X
    CLC
    ADC a:$05A7,X
    BCS Bank1_Label_A257
    CMP a:$05A1,X
    BCC Bank1_Label_A266

Bank1_Label_A257:
    SBC a:$05A1,X
    PHA
    LDA a:$0595,X
    CLC
    ADC a:$A2C2,Y
    STA a:$0595,X
    PLA

Bank1_Label_A266:
    STA a:$059B,X

Bank1_Label_A269:
    JMP Bank1_Label_A2A4

Bank1_Label_A26C:
    LDA a:$0595,X
    CLC
    ADC a:$A2C6,Y
    STA a:$0595,X
    LDA a:$059B,X
    CLC
    ADC a:$05A1,X
    BCS Bank1_Label_A284
    CMP a:$05A7,X
    BCC Bank1_Label_A295

Bank1_Label_A284:
    SBC a:$05A7,X
    PHA
    LDA a:$058F,X
    CLC
    ADC a:$A2C2,Y
    STA a:$058F,X
    BEQ Bank1_Label_A29E
    PLA

Bank1_Label_A295:
    STA a:$059B,X
    JMP Bank1_Label_A2A4

Bank1_Label_A29B:
    JMP Bank1_Label_A1D3

Bank1_Label_A29E:
    PLA

Bank1_Label_A29F:
    LDA #$00
    STA a:$0595,X

Bank1_Label_A2A4:
    LDA a:$058F,X
    CLC
    ADC #$04
    STA $67
    LDA a:$0595,X
    CLC
    ADC #$04
    STA $68
    JSR Bank1_Func_9377
    BEQ Bank1_Label_A2BE
    LDA #$00
    STA a:$0595,X

Bank1_Label_A2BE:
    DEX
    BPL Bank1_Label_A29B
    RTS
    .byte $01, $FF, $01, $FF, $01, $01, $FF, $FF

Bank1_Func_A2CA:
    LDX #$05

Bank1_Label_A2CC:
    TXA
    ASL A
    ASL A
    CLC
    ADC #$E8
    TAY
    LDA a:$0595,X
    BEQ Bank1_Label_A300
    STA $94
    LDA a:$0558
    CMP #$12
    BNE Bank1_Label_A2E5
    LDA #$9F
    BNE Bank1_Label_A2E7

Bank1_Label_A2E5:
    LDA #$4B

Bank1_Label_A2E7:
    PHA
    LDA a:$0589,X
    BPL Bank1_Label_A2F1
    PLA
    LDA #$4A
    PHA

Bank1_Label_A2F1:
    PLA
    STA $95
    LDA #$01
    STA $96
    LDA a:$058F,X
    STA $97
    JSR Bank1_Func_96BC

Bank1_Label_A300:
    DEX
    BPL Bank1_Label_A2CC
    RTS

Bank1_Func_A304:
    LDY #$48
    LDX #$06

Bank1_Label_A308:
    LDA a:$0558,X
    BEQ Bank1_Label_A357
    BMI Bank1_Label_A357
    CMP #$70
    BCC Bank1_Label_A330
    PHA
    LDA #$00
    STA $63
    LDA a:$055F,X
    STA $60
    LDA a:$0566,X
    STA $61
    STX $76
    PLA
    AND #$0F
    CLC
    ADC #$13
    JSR Bank1_Func_A35B
    JMP Bank1_Label_A355

Bank1_Label_A330:
    PHA
    LDA #$00
    STA $63
    LDA a:$055F,X
    STA $60
    LDA a:$0566,X
    STA $61
    STX $76
    PLA
    ASL A
    TAX
    LDA #$A3
    PHA
    LDA #$54
    PHA
    LDA a:$A549,X
    PHA
    LDA a:$A548,X
    PHA
    LDX $76
    RTS

Bank1_Label_A355:
    LDX $76

Bank1_Label_A357:
    DEX
    BPL Bank1_Label_A308
    RTS

Bank1_Func_A35B:
    STX $64
    TAX
    LDA a:$A4C4,X
    PHA
    AND #$03
    STA $62
    PLA
    AND #$3C
    STA $65
    TXA
    ASL A
    ASL A
    TAX
    LDA $60
    PHA
    JSR Bank1_Func_A389
    LDA $61
    CMP #$F8
    BEQ Bank1_Label_A380
    CLC
    ADC #$08
    STA $61

Bank1_Label_A380:
    PLA
    STA $60
    JSR Bank1_Func_A389
    LDX $64
    RTS

Bank1_Func_A389:
    JSR Bank1_Func_A38C

Bank1_Func_A38C:
    TXA
    EOR $63
    TAX
    PHA
    LDA a:$A3DC,X
    STA $66
    LDA $65
    EOR $63
    TAX
    LDA $63
    BEQ Bank1_Label_A3A7
    LDA a:$A526,X
    EOR #$40
    JMP Bank1_Label_A3AA

Bank1_Label_A3A7:
    LDA a:$A526,X

Bank1_Label_A3AA:
    ORA $62
    STA $62
    PLA
    EOR $63
    TAX
    INX
    INC $65
    LDA $61
    STA $94
    LDA $66
    STA $95
    LDA $62
    STA $96
    LDA $62
    AND #$03
    STA $62
    LDA $60
    STA $97
    PHA
    LDA $66
    BEQ Bank1_Label_A3D3
    JSR Bank1_Func_96BC

Bank1_Label_A3D3:
    PLA
    CLC
    LDA #$08
    ADC $60
    STA $60
    RTS
    .byte $80, $81, $90, $91, $82, $83, $92, $93, $60, $61, $70, $71, $62, $63, $72, $73
    .byte $B4, $B4, $B4, $B4, $B5, $B5, $B5, $B5, $B6, $B6, $B6, $B6, $46, $46, $56, $56
    .byte $47, $47, $57, $57, $64, $65, $74, $75, $66, $67, $76, $77, $00, $00, $66, $67
    .byte $BA, $BB, $BA, $BB, $C0, $C1, $C0, $C1, $C2, $C3, $C4, $C5, $C6, $C7, $C8, $C9
    .byte $00, $00, $CA, $CB, $84, $85, $94, $95, $94, $95, $84, $85, $D8, $D8, $D8, $D8
    .byte $D9, $D9, $D9, $D9, $E8, $E8, $E8, $E8, $E9, $E9, $E9, $E9, $51, $51, $51, $51
    .byte $50, $50, $50, $50, $41, $41, $41, $41, $40, $40, $40, $40, $4F, $4F, $4F, $4F
    .byte $5F, $5F, $5F, $5F, $8D, $8D, $8D, $8D, $7C, $7C, $6E, $6E, $6E, $6E, $7C, $7C
    .byte $87, $86, $87, $86, $97, $96, $97, $96, $86, $87, $86, $87, $96, $97, $96, $97
    .byte $4D, $4E, $5D, $5E, $6F, $7F, $6D, $7E, $CA, $CB, $CA, $CB, $7D, $DA, $7D, $DA
    .byte $BC, $BD, $CC, $CD, $DC, $DD, $EC, $ED, $BE, $BF, $CE, $CF, $DE, $DF, $EE, $EF
    .byte $E2, $E3, $CC, $CD, $DC, $DD, $EC, $ED, $EB, $BF, $CE, $8E, $DE, $8F, $EE, $9E
    .byte $42, $43, $52, $53, $44, $45, $54, $55, $43, $42, $53, $52, $45, $44, $55, $54
    .byte $42, $43, $4C, $B7, $44, $45, $B8, $B9, $43, $42, $B7, $4C, $45, $44, $B9, $B8
    .byte $48, $49, $58, $59, $5A, $5B, $58, $5C, $01, $01, $01, $01, $12, $12, $12, $05
    .byte $05, $02, $02, $02, $0E, $0E, $03, $03, $03, $01, $09, $10, $10, $10, $10, $10
    .byte $10, $10, $10, $10, $10, $10, $16, $1A, $1F, $1F, $0F, $0F, $01, $01, $0D, $0D
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $03, $03, $23, $23, $03, $03, $23, $23
    .byte $01, $01, $40, $30, $80, $30, $20, $40, $FF, $FF, $35, $FF, $FF, $20, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $04, $01, $01, $01, $01, $01, $01, $08, $02, $20, $03
    .byte $08, $04, $02, $20, $08, $01, $20, $20, $20, $01, $00, $00, $00, $00, $00, $40
    .byte $00, $40, $80, $80, $80, $80, $00, $00, $80, $80, $00, $40, $80, $C0, $20, $60
    .byte $20, $60, $A0, $E0, $A0, $E0, $40, $40, $C0, $C0, $40, $40, $40, $40, $45, $9B
    .byte $57, $9B, $17, $9C, $84, $9C, $DD, $9C, $35, $9D, $C8, $9D, $E9, $9D, $19, $9E
    .byte $B1, $9E, $FA, $9E, $2D, $9F, $83, $9F, $20, $A0, $E9, $9D, $20, $A0, $3C, $A0
    .byte $6C, $A0, $62, $A0, $B8, $A0, $2E, $9B, $E6, $9D, $72, $9B, $2B, $9C, $95, $9C
    .byte $04, $9D, $4D, $9D, $E0, $9D, $05, $9E, $1A, $9E, $BD, $9E, $72, $9B, $39, $9F
    .byte $99, $9F, $C4, $9F, $F3, $9F, $3C, $A0, $3D, $A0, $47, $A0, $A1, $A0, $51, $52
    .byte $53, $41, $31, $55, $43, $45, $32, $45, $45, $31, $41, $41, $31, $00, $21, $21
    .byte $21, $45, $01, $02, $03, $04, $05, $06, $07, $06, $05, $04, $03, $02, $01, $00
    .byte $00, $00, $FF, $FE, $FD, $FC, $FB, $FA, $F9, $FA, $FB, $FC, $FD, $FE, $FF, $00
    .byte $00, $00, $02, $04, $06, $08, $06, $04, $02, $00, $FE, $FC, $FA, $F8, $FA, $FC
    .byte $FE, $00, $01, $01, $02, $02, $03, $03, $04, $04, $FF, $FF, $FE, $FE, $FD, $FD
    .byte $FC, $FC, $FD, $FE, $FF, $00, $01, $02, $03, $04, $03, $02, $01, $00, $FF, $FE
    .byte $FD, $FC, $FD, $FE, $FF, $00, $F8, $FA, $FB, $FC, $FD, $FE, $FF, $00, $00, $01
    .byte $02, $03, $04, $05, $06, $08

Bank1_Func_A612:
    LDA $58
    CMP #$7F
    BNE Bank1_Label_A62A
    LDA $5C
    CMP #$C8
    BCC Bank1_Label_A62A
    LDA $5D
    CMP #$28
    BCS Bank1_Label_A62A
    LDA $41
    BNE Bank1_Label_A62A
    INC $B2

Bank1_Label_A62A:
    RTS

Bank1_Func_A62B:
    LDA $7F
    CMP #$03
    BNE Bank1_Label_A649
    LDA $2B
    CLC
    ADC #$10
    STA $67
    JSR Bank1_Func_8AD0
    CMP $67
    BCC Bank1_Label_A641
    LDA $67

Bank1_Label_A641:
    STA $2B
    LDA #$00
    STA $7F
    STA $A5

Bank1_Label_A649:
    LDA $81
    CMP #$03
    BNE Bank1_Label_A65E
    INC $A3
    DEC $2C
    JSR Bank1_Func_8AD0
    STA $2B
    LDA #$00
    STA $81
    STA $A5

Bank1_Label_A65E:
    LDY #$06

Bank1_Label_A660:
    LDA a:$A6B5,Y
    CMP $58
    BEQ Bank1_Label_A66B
    DEY
    BPL Bank1_Label_A660
    RTS

Bank1_Label_A66B:
    LDA $40
    CMP #$78
    BEQ Bank1_Label_A672
    RTS

Bank1_Label_A672:
    LDA $B1
    AND #$01
    TAX

Bank1_Label_A677:
    CPX #$05
    BEQ Bank1_Label_A690
    CPX #$03
    BNE Bank1_Label_A696
    LDA $7C,X
    BNE Bank1_Label_A69A
    JSR Bank1_Func_8AD0
    SEC
    SBC $2B
    CMP #$06
    BCS Bank1_Label_A6AA
    JMP Bank1_Label_A69A

Bank1_Label_A690:
    LDA $A3
    CMP #$02
    BEQ Bank1_Label_A69A

Bank1_Label_A696:
    LDA $7C,X
    BEQ Bank1_Label_A6AA

Bank1_Label_A69A:
    INX
    CPX #$07
    BNE Bank1_Label_A677
    LDA #$09
    JSR Bank1_Func_A856
    LDA #$11
    JSR Bank1_Func_81C9
    RTS

Bank1_Label_A6AA:
    INC $7C,X
    LDA #$78
    STA $83,X
    LDA #$F0
    STA $8A,X
    RTS
    .byte $14, $1A, $1F, $47, $45, $6D, $74

Bank1_Func_A6BC:
    LDA $AE
    BNE Bank1_Label_A6D5
    LDA $56
    CMP #$0D
    BNE Bank1_Label_A6D4
    LDY #$00

Bank1_Label_A6C8:
    LDA a:$A70F,Y
    CMP $58
    BEQ Bank1_Label_A6D8
    INY
    CPY #$11
    BNE Bank1_Label_A6C8

Bank1_Label_A6D4:
    RTS

Bank1_Label_A6D5:
    DEC $AE
    RTS

Bank1_Label_A6D8:
    LDA a:$A731,Y
    BEQ Bank1_Label_A6FA
    CMP #$01
    BEQ Bank1_Label_A6F3
    CMP #$02
    BEQ Bank1_Label_A6EC
    LDA $5D
    CMP #$A0
    BCS Bank1_Label_A6FA
    RTS

Bank1_Label_A6EC:
    LDA $5C
    CMP #$A0
    BCS Bank1_Label_A6FA
    RTS

Bank1_Label_A6F3:
    LDA $5D
    CMP #$50
    BCC Bank1_Label_A6FA
    RTS

Bank1_Label_A6FA:
    LDA $55
    STA $9E
    LDA a:$A742,Y
    BEQ Bank1_Label_A705
    STA $9E

Bank1_Label_A705:
    LDA a:$A720,Y
    STA $55
    DEC $55
    DEC $AE
    RTS
    .byte $07, $0C, $10, $25, $2B, $33, $3E, $2F, $6B, $6A, $5A, $75, $73, $76, $72, $57
    .byte $6F, $86, $90, $9A, $A2, $B4, $C0, $CA, $D4, $45, $48, $D7, $66, $6A, $7A, $7E
    .byte $62, $DF, $03, $01, $03, $03, $03, $03, $03, $02, $00, $01, $01, $00, $01, $00
    .byte $01, $00, $03, $00, $00, $00, $3C, $32, $44, $50, $42, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00

Bank1_Func_A753:
    LDY #$00
    STY $96
    LDA $2C
    ASL A
    ASL A
    CLC
    ADC #$50
    STA $94
    LDA #$EC
    STA $97
    LDA #$04
    STA $0A
    LDA $2B
    STA $98
    LDX #$07

Bank1_Label_A76E:
    LDA $98
    SEC
    SBC #$04
    BCC Bank1_Label_A780
    STA $98
    LDA #$FF
    STA $0A,X
    DEX
    BPL Bank1_Label_A76E
    BMI Bank1_Label_A78F

Bank1_Label_A780:
    CLC
    ADC #$FF
    STA $0A,X
    DEX
    BMI Bank1_Label_A78F
    LDA #$FB

Bank1_Label_A78A:
    STA $0A,X
    DEX
    BPL Bank1_Label_A78A

Bank1_Label_A78F:
    LDX $2C

Bank1_Label_A791:
    LDA $0A,X
    STA $95
    JSR Bank1_Func_A7FA
    BEQ Bank1_Label_A7F9
    LDA $94
    CLC
    ADC #$08
    STA $94
    INX
    CPX #$08
    BNE Bank1_Label_A791
    LDA #$E6
    STA $97
    LDA #$32
    STA $94
    LDA #$FA
    STA $95
    JSR Bank1_Func_A7FA
    BEQ Bank1_Label_A7F9
    LDA #$F0
    STA $97
    LDA $2A
    ORA #$F0
    STA $95
    JSR Bank1_Func_A7FA
    BEQ Bank1_Label_A7F9
    LDA #$18
    STA $94
    LDA #$5C
    STA $97
    LDX #$00

Bank1_Label_A7D0:
    LDA a:$0298,X
    BNE Bank1_Label_A7E1
    LDA $97
    CLC
    ADC #$08
    STA $97
    INX
    CPX #$06
    BNE Bank1_Label_A7D0

Bank1_Label_A7E1:
    LDA a:$0298,X
    ORA #$F0
    STA $95
    JSR Bank1_Func_A7FA
    LDA $97
    CLC
    ADC #$08
    STA $97
    BEQ Bank1_Label_A7F9
    INX
    CPX #$07
    BNE Bank1_Label_A7E1

Bank1_Label_A7F9:
    RTS

Bank1_Func_A7FA:
    LDA a:$0300,Y
    CMP #$F8
    BNE Bank1_Label_A804
    JMP Bank1_Func_96C8

Bank1_Label_A804:
    INY
    INY
    INY
    INY
    BNE Bank1_Func_A7FA
    RTS
    .byte $00, $30, $38, $28, $1C, $20, $04, $18, $34, $0C, $2C, $14, $10, $08, $24, $F1
    .byte $A8, $F0, $A8, $77, $A9, $8F, $A9, $CE, $A9, $E8, $A9, $97, $AA, $A4, $AA, $71
    .byte $AB, $85, $AB, $2E, $AB, $3D, $AB, $4E, $AA, $E3, $A8, $40, $A9, $85, $AB, $48
    .byte $A9, $85, $AB, $FE, $AB, $12, $AC, $38, $AA, $E3, $A8, $FD, $AA, $E3, $A8, $18
    .byte $AB, $E3, $A8, $67, $AA, $7E, $AA, $1E, $A9, $E8, $A8

Bank1_Func_A856:
    CMP #$0F
    BCS Bank1_Label_A874
    STX $AB
    LDX a:$02A0
    BMI Bank1_Label_A86F
    STY $AC
    TAY
    LDA a:$A80B,X
    CMP a:$A80B,Y
    BCC Bank1_Label_A875
    TYA
    LDY $AC

Bank1_Label_A86F:
    STA a:$02A0

Bank1_Label_A872:
    LDX $AB

Bank1_Label_A874:
    RTS

Bank1_Label_A875:
    LDY $AC
    JMP Bank1_Label_A872

Bank1_Func_A87A:
    CMP #$0F
    BCS Bank1_Label_A874
    STX $AB
    LDX #$00
    STX a:$02A1
    STA a:$02A0
    LDX $AB
    RTS

Bank1_Func_A88B:
    LDX #$03

Bank1_Label_A88D:
    LDA a:$02A3,X
    BEQ Bank1_Label_A895
    DEC a:$02A3,X

Bank1_Label_A895:
    DEX
    BPL Bank1_Label_A88D
    LDA a:$02A0
    BMI Bank1_Label_A8D2
    TAX
    ORA #$80
    STA a:$02A0
    CPX #$0F
    BCS Bank1_Label_A8D2
    LDA a:$02A1
    BEQ Bank1_Label_A8BB
    LDA a:$A80B,X
    CMP a:$02A1
    BCC Bank1_Label_A8BB
    BNE Bank1_Label_A8D2
    LDA a:$02A2
    BNE Bank1_Label_A8D2

Bank1_Label_A8BB:
    LDA a:$A80B,X
    STA a:$02A1
    TAX
    LDA #$00
    STA a:$02A3
    STA a:$02A4
    STA a:$02A5
    STA a:$02A6
    BEQ Bank1_Label_A8D7

Bank1_Label_A8D2:
    LDX a:$02A1
    INX
    INX

Bank1_Label_A8D7:
    CPX #$3C
    BCS Bank1_Label_A8E9
    LDA a:$A81B,X
    PHA
    LDA a:$A81A,X
    PHA
    RTS
    .byte $CE, $A7, $02, $D0, $08

Bank1_Label_A8E9:
    LDA #$00
    STA a:$02A1
    STA a:$02A2
    RTS
    .byte $A9, $00, $8D, $A2, $02, $8D, $11, $40, $8D, $A3, $02, $8D, $A4, $02, $8D, $A5
    .byte $02, $8D, $A6, $02, $8D, $08, $40, $8D, $0C, $40, $A9, $18, $8D, $0B, $40, $A9
    .byte $10, $8D, $00, $40, $8D, $04, $40, $A9, $0F, $8D, $15, $40, $60, $A9, $04, $8D
    .byte $A5, $02, $8D, $A6, $02, $8D, $A7, $02, $A9, $1F, $8D, $0C, $40, $A9, $0F, $8D
    .byte $0E, $40, $A0, $08, $A2, $F0, $A9, $38, $20, $4C, $AC, $8D, $0F, $40, $60, $A0
    .byte $60, $A9, $17, $A2, $00, $F0, $06, $A0, $08, $A9, $01, $A2, $05, $8C, $A4, $02
    .byte $8D, $A7, $02, $8E, $A9, $02, $A9, $01, $8D, $A8, $02, $20, $63, $A9, $4C, $86
    .byte $AB, $A9, $08, $8D, $A6, $02, $A9, $01, $8D, $0C, $40, $A9, $0A, $8D, $0E, $40
    .byte $A9, $08, $8D, $0F, $40, $60, $A9, $48, $8D, $A3, $02, $8D, $A4, $02, $8D, $A5
    .byte $02, $8D, $A6, $02, $A9, $01, $8D, $A7, $02, $A9, $04, $8D, $A8, $02, $AD, $A8
    .byte $02, $D0, $03, $4C, $E4, $A8, $CE, $A7, $02, $D0, $DA, $CE, $A8, $02, $F0, $1A
    .byte $A9, $04, $8D, $A7, $02, $AD, $A8, $02, $4A, $90, $0B, $A9, $82, $A2, $00, $20
    .byte $30, $AC, $A2, $69, $D0, $12, $A9, $82, $D0, $07, $A9, $3C, $8D, $A7, $02, $A9
    .byte $8F, $A2, $00, $20, $30, $AC, $A2, $8D, $A9, $08, $4C, $3E, $AC, $A9, $56, $85
    .byte $2D, $A9, $AC, $85, $2E, $A9, $01, $8D, $A7, $02, $8D, $A2, $02, $A9, $09, $8D
    .byte $A8, $02, $A9, $83, $8D, $A9, $02, $20, $20, $AA, $A2, $00, $AD, $A8, $02, $9D
    .byte $A3, $02, $8A, $0A, $0A, $AA, $AD, $A9, $02, $9D, $00, $40, $A9, $00, $9D, $01
    .byte $40, $A0, $00, $B1, $2D, $F0, $10, $0A, $A8, $B9, $1B, $B1, $9D, $02, $40, $B9
    .byte $1C, $B1, $09, $08, $9D, $03, $40, $E6, $2D, $D0, $02, $E6, $2E, $60, $CE, $A7
    .byte $02, $D0, $11, $AD, $A8, $02, $8D, $A7, $02, $A0, $00, $B1, $2D, $C9, $FF, $D0
    .byte $05, $20, $E9, $A8, $68, $68, $60, $A9, $0A, $8D, $A4, $02, $8D, $A7, $02, $A9
    .byte $42, $A2, $00, $20, $37, $AC, $A2, $BB, $A9, $08, $4C, $45, $AC, $A9, $04, $8D
    .byte $A5, $02, $8D, $A7, $02, $8D, $A2, $02, $A9, $84, $A2, $8A, $20, $30, $AC, $A2
    .byte $7E, $A9, $38, $4C, $3E, $AC, $A9, $10, $8D, $A6, $02, $8D, $A8, $02, $A9, $0C
    .byte $8D, $A7, $02, $A9, $04, $8D, $0C, $40, $A9, $08, $8D, $0F, $40, $AD, $A7, $02
    .byte $8D, $0E, $40, $AD, $A7, $02, $C9, $0F, $F0, $03, $EE, $A7, $02, $CE, $A8, $02
    .byte $D0, $03, $4C, $E9, $A8, $60, $A9, $5F, $85, $2D, $A9, $AC, $85, $2E, $A9, $01
    .byte $8D, $A7, $02, $CE, $A7, $02, $D0, $ED, $A0, $00, $B1, $2D, $C9, $FF, $F0, $E2
    .byte $8D, $A7, $02, $8D, $A3, $02, $8D, $A4, $02, $8D, $A5, $02, $8D, $A6, $02, $20
    .byte $19, $AA, $A2, $00, $20, $CC, $AA, $20, $CC, $AA, $A0, $00, $B1, $2D, $F0, $25
    .byte $0A, $A8, $AD, $A7, $02, $E0, $08, $F0, $05, $4A, $09, $C0, $D0, $01, $0A, $9D
    .byte $00, $40, $A9, $00, $9D, $01, $40, $B9, $1B, $B1, $9D, $02, $40, $B9, $1C, $B1
    .byte $09, $08, $9D, $03, $40, $E8, $E8, $E8, $E8, $4C, $19, $AA, $A9, $18, $8D, $A4
    .byte $02, $A9, $10, $8D, $A7, $02, $8D, $A2, $02, $A9, $A0, $A2, $9B, $20, $37, $AC
    .byte $A2, $FE, $A9, $19, $4C, $45, $AC, $A9, $08, $8D, $A4, $02, $8D, $A7, $02, $A9
    .byte $C0, $A2, $83, $20, $37, $AC, $A2, $60, $A9, $08, $4C, $45, $AC, $A9, $03, $8D
    .byte $A8, $02, $A9, $FF, $8D, $A4, $02, $A9, $00, $8D, $A7, $02, $AD, $A7, $02, $D0
    .byte $27, $AD, $A8, $02, $D0, $08, $A9, $00, $8D, $A4, $02, $4C, $E9, $A8, $CE, $A8
    .byte $02, $A9, $84, $A2, $8B, $20, $37, $AC, $AC, $A8, $02, $BE, $6E, $AB, $A9, $10
    .byte $20, $45, $AC, $A9, $04, $8D, $A7, $02, $CE, $A7, $02, $60
    .incbin "assets/generated/audio/sfx/prg1-tone-low.bin", $0, $4  ; rom-asset .byte
    .byte $A0, $14, $A9, $04, $A2, $03, $8C, $A4, $02, $8D, $A7, $02, $8E, $A9, $02, $A9
    .byte $01, $8D, $A8, $02, $CE, $A8, $02, $D0, $26, $AD, $A7, $02, $30, $22, $18, $6D
    .byte $A9, $02, $0A, $A8, $A9, $DF, $A2, $8C, $20, $37, $AC, $B9, $B5, $AB, $AA, $B9
    .byte $B6, $AB, $09, $88, $20, $45, $AC, $CE, $A7, $02, $A9, $04, $8D, $A8, $02, $60
    .byte $4C, $E9, $A8
    .incbin "assets/generated/audio/sfx/prg1-pitch-periods.bin", $0, $D  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg1-pitch-periods.bin", $D, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg1-pitch-periods.bin", $1D, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg1-pitch-periods.bin", $2D, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg1-pitch-periods.bin", $3D, $D  ; rom-asset .byte
    .byte $A9, $10, $8D
    .byte $A5, $02, $A9, $40, $8D, $A7, $02, $A9, $01, $8D, $A8, $02, $A9, $30, $8D, $A9
    .byte $02, $A0, $01, $AE, $A7, $02, $A9, $08, $20, $4C, $AC, $AD, $A7, $02, $38, $ED
    .byte $A8, $02, $8D, $A7, $02, $CD, $A9, $02, $D0, $03, $4C, $E9, $A8, $60, $8D, $00
    .byte $40, $8E, $01, $40, $60, $8D, $04, $40, $8E, $05, $40, $60, $8E, $02, $40, $8D
    .byte $03, $40, $60, $8E, $06, $40, $8D, $07, $40, $60, $8C, $08, $40, $8E, $0A, $40
    .byte $8D, $0B, $40, $60, $2C, $31, $2C, $31, $35, $38, $3D, $41, $FF, $08, $2E, $2B
    .byte $27, $08, $30, $2C, $29, $08, $32, $2D, $2A, $03, $33, $2E, $2B, $03, $35, $30
    .byte $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $03, $35, $30
    .byte $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $03, $35, $30
    .byte $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $03, $35, $30
    .byte $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $FF

Bank1_Label_ACB0:
    BMI Bank1_Label_ACD5
    ORA #$80
    STA a:$02AB

Bank1_Func_ACB7:
    LDA #$10
    STA a:$4000
    STA a:$4004
    STA a:$400C
    LDA #$00
    STA a:$4008
    LDA #$18
    STA a:$4003
    STA a:$4007
    STA a:$400B
    STA a:$400F

Bank1_Label_ACD5:
    LDX #$00
    JSR Bank1_Func_ADA7
    INX
    JSR Bank1_Func_ADA7
    INX
    INX
    JMP Bank1_Func_ADA7
    .byte $60

Bank1_Func_ACE4:
    LDA a:$02AB
    BNE Bank1_Label_ACB0
    LDA a:$02AA
    BEQ Bank1_Label_ACD5
    BPL Bank1_Label_ACF3
    JMP Bank1_Label_AD77

Bank1_Label_ACF3:
    LDA a:$02AA
    CMP #$07
    BCC Bank1_Label_ACFD
    JMP Bank1_Label_ADA1

Bank1_Label_ACFD:
    ORA #$80
    STA a:$02AA
    ASL A
    ASL A
    ASL A
    TAY
    LDX #$07

Bank1_Label_AD08:
    LDA a:$B2E2,Y
    STA $2F,X
    STA a:$02DC,X
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
    JSR Bank1_Func_ACB7

Bank1_Label_AD77:
    LDA #$00
    STA a:$02FE
    STA a:$02FD

Bank1_Label_AD7F:
    LDX a:$02FD
    DEC a:$02B0,X
    BEQ Bank1_Label_AD8D
    JSR Bank1_Func_ADA7
    JMP Bank1_Label_AD90

Bank1_Label_AD8D:
    JSR Bank1_Func_ADF3

Bank1_Label_AD90:
    INC a:$02FD
    LDA a:$02FD
    CMP #$04
    BCC Bank1_Label_AD7F
    LDA a:$02FE
    CMP #$04
    BNE Bank1_Label_ADA6

Bank1_Label_ADA1:
    LDA #$00
    STA a:$02AA

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
    STA a:$02FF
    BCC Bank1_Label_ADC6
    LDA a:$02B8,X
    SEC
    SBC a:$02FF
    BCS Bank1_Label_ADD1
    BCC Bank1_Label_ADCF

Bank1_Label_ADC6:
    LDA a:$02B8,X
    CLC
    ADC a:$02FF
    BCC Bank1_Label_ADD1

Bank1_Label_ADCF:
    LDA #$00

Bank1_Label_ADD1:
    STA a:$02B8,X
    LDY a:$02A3,X
    BNE Bank1_Label_ADF2
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

Bank1_Label_ADF2:
    RTS

Bank1_Func_ADF3:
    LDX a:$02FD
    CPX #$03
    BNE Bank1_Label_AE02
    LDA a:$02FC
    BEQ Bank1_Label_AE02
    JMP Bank1_Label_AF08

Bank1_Label_AE02:
    JSR Bank1_Func_B10D
    STA a:$02FF
    TAY
    BMI Bank1_Label_AE0E
    JMP Bank1_Label_AEEC

Bank1_Label_AE0E:
    CMP #$EF
    BCC Bank1_Label_AE45
    SEC
    LDA #$FF
    SBC a:$02FF
    ASL A
    TAY
    LDA a:$AE24,Y
    PHA
    LDA a:$AE23,Y
    PHA
    RTS
    .byte $84, $AF, $60, $B0, $9B, $AF, $D4, $AF, $B9, $AF, $FC, $AF, $12, $B0, $25, $B0
    .byte $4A, $B0, $92, $B0, $D4, $B0, $C4, $B0, $B2, $B0, $E1, $B0, $72, $B0, $4B, $AE
    .byte $E9, $B0

Bank1_Label_AE45:
    LDA a:$02FF
    AND #$7F
    BPL Bank1_Label_AE4F
    JSR Bank1_Func_B10D

Bank1_Label_AE4F:
    LDX a:$02FD
    STA a:$02AC,X
    LDA a:$02EF,X
    BNE Bank1_Label_AED6
    LDX a:$02FD
    LDA a:$02AC,X
    STA a:$02FF
    LDX a:$02FD
    CPX #$02
    BEQ Bank1_Label_AED9
    LDA a:$02F3,X
    AND #$10
    BNE Bank1_Label_AE8C
    LDA a:$02F3,X
    AND #$D0
    STA a:$02F3,X
    LDA a:$02FF
    LSR A
    CMP #$10
    BCC Bank1_Label_AE83
    LDA #$0F

Bank1_Label_AE83:
    ORA a:$02F3,X
    STA a:$02F3,X
    JMP Bank1_Label_AE97

Bank1_Label_AE8C:
    LDY a:$02FF
    LDA a:$B1E3,Y
    ORA #$80
    STA a:$02BC,X

Bank1_Label_AE97:
    LDA a:$02FF
    PHA
    LSR A
    LSR A
    LSR A
    STA a:$02FF
    PLA
    SEC
    SBC a:$02FF
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
    JMP Bank1_Func_ADF3

Bank1_Label_AED9:
    LDA a:$02FF
    ASL A
    BMI Bank1_Label_AEE4
    ADC a:$02FF
    BPL Bank1_Label_AEE6

Bank1_Label_AEE4:
    LDA #$7F

Bank1_Label_AEE6:
    STA a:$02F5
    JMP Bank1_Label_AED6

Bank1_Label_AEEC:
    CMP #$00
    BNE Bank1_Label_AEF3
    JMP Bank1_Label_AF7B

Bank1_Label_AEF3:
    LDX a:$02FD
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
    STA a:$400C,Y
    INX
    INY
    CPY #$04
    BCC Bank1_Label_AF1A
    LDA a:$02F6
    AND #$10
    BEQ Bank1_Label_AF6D
    LDA a:$02F6
    AND #$1F
    STA a:$400C
    BPL Bank1_Label_AF6D

Bank1_Label_AF37:
    LDY a:$02A3,X
    BNE Bank1_Label_AF7B
    TXA
    ASL A
    ASL A
    TAY
    LDA a:$02F3,X
    STA a:$4000,Y
    LDA #$00
    STA a:$4001,Y
    LDA a:$02FF
    CLC
    ADC a:$B1AF,X
    CLC
    ADC $B5,X
    CLC
    ADC a:$02EC,X
    ASL A
    TAX
    LDA a:$B11B,X
    STA a:$4002,Y
    LDA a:$B11C,X
    LDX a:$02FD
    ORA a:$02F7,X
    STA a:$4003,Y

Bank1_Label_AF6D:
    LDX a:$02FD
    LDA a:$02EF,X
    BNE Bank1_Label_AF7B
    LDA a:$02B4,X
    STA a:$02B8,X

Bank1_Label_AF7B:
    LDX a:$02FD
    LDA a:$02AC,X
    STA a:$02B0,X
    RTS
    .byte $AE, $FD, $02, $A9, $01, $9D, $B0, $02, $8A, $0A, $AA, $B5, $2F, $D0, $02, $D6
    .byte $30, $D6, $2F, $EE, $FE, $02, $60, $20, $0D, $B1, $AE, $FD, $02, $9D, $D4, $02
    .byte $A9, $01, $9D, $D8, $02, $8A, $0A, $AA, $B5, $2F, $9D, $C4, $02, $B5, $30, $9D
    .byte $C5, $02, $4C, $F3, $AD, $20, $0D, $B1, $AE, $FD, $02, $DD, $D8, $02, $B0, $0D
    .byte $8A, $0A, $AA, $BD, $CC, $02, $95, $2F, $BD, $CD, $02, $95, $30, $4C, $F3, $AD
    .byte $AE, $FD, $02, $BD, $D8, $02, $DD, $D4, $02, $B0, $1A, $FE, $D8, $02, $8A, $0A
    .byte $AA, $B5, $2F, $9D, $CC, $02, $B5, $30, $9D, $CD, $02, $BD, $C4, $02, $95, $2F
    .byte $BD, $C5, $02, $95, $30, $4C, $F3, $AD, $20, $0D, $B1, $AE, $FD, $02, $9D, $C0
    .byte $02, $BD, $B4, $02, $9D, $B8, $02, $A9, $FF, $9D, $EF, $02, $D0, $32, $AE, $FD
    .byte $02, $A9, $00, $9D, $EF, $02, $BD, $F3, $02, $29, $CF, $9D, $F3, $02, $4C, $5A
    .byte $AE, $20, $0D, $B1, $AE, $FD, $02, $E0, $02, $F0, $A2, $29, $C0, $8D, $FF, $02
    .byte $BD, $F3, $02, $29, $10, $0D, $FF, $02, $9D, $F3, $02, $BD, $EF, $02, $F0, $DE
    .byte $BD, $C0, $02, $4C, $60, $AE, $20, $51, $B0, $4C, $F3, $AD, $AD, $FD, $02, $0A
    .byte $AA, $B5, $2F, $9D, $DC, $02, $B5, $30, $9D, $DD, $02, $60, $AD, $FD, $02, $0A
    .byte $AA, $BD, $DC, $02, $95, $2F, $BD, $DD, $02, $95, $30, $4C, $F3, $AD, $AD, $AA
    .byte $02, $0A, $0A, $38, $E9, $04, $18, $6D, $FD, $02, $0A, $A8, $AD, $FD, $02, $0A
    .byte $AA, $B9, $E3, $B2, $95, $2F, $B9, $E4, $B2, $95, $30, $4C, $F3, $AD, $20, $0D
    .byte $B1, $48, $20, $0D, $B1, $48, $AD, $FD, $02, $0A, $AA, $B5, $2F, $9D, $E4, $02
    .byte $B5, $30, $9D, $E5, $02, $68, $95, $30, $68, $95, $2F, $4C, $F3, $AD, $AD, $FD
    .byte $02, $0A, $AA, $BD, $E4, $02, $95, $2F, $BD, $E5, $02, $95, $30, $4C, $F3, $AD
    .byte $20, $0D, $B1, $AE, $FD, $02, $E0, $03, $F0, $03, $9D, $EC, $02, $4C, $F3, $AD
    .byte $20, $0D, $B1, $A2, $02, $95, $B5, $CA, $10, $FB, $4C, $F3, $AD, $AE, $FD, $02
    .byte $A9, $08, $4C, $D3, $AE, $20, $0D, $B1, $AE, $FD, $02, $9D, $B4, $02, $9D, $B8
    .byte $02, $4A, $4A, $4A, $4A, $8D, $FF, $02, $BD, $F3, $02, $29, $C0, $09, $10, $0D
    .byte $FF, $02, $9D, $F3, $02, $4C, $F3, $AD

Bank1_Func_B10D:
    LDA a:$02FD
    ASL A
    TAX
    LDA ($2F,X)
    INC $2F,X
    BNE Bank1_Label_B11A
    INC $30,X

Bank1_Label_B11A:
    RTS
    .byte $00, $00, $AE, $06, $4E, $06, $F3, $05, $9F, $05, $4D, $05, $01, $05, $B9, $04
    .byte $75, $04, $35, $04, $F8, $03, $BF, $03, $89, $03, $57, $03, $27, $03, $F9, $02
    .byte $CF, $02, $A6, $02, $80, $02, $5C, $02, $3A, $02, $1A, $02, $FC, $01, $DF, $01
    .byte $C4, $01, $AB, $01, $93, $01, $7C, $01, $67, $01, $52, $01, $3F, $01, $2D, $01
    .byte $1C, $01, $0C, $01, $FD, $00, $EE, $00, $E1, $00, $D4, $00, $C8, $00, $BD, $00
    .byte $B2, $00, $A8, $00, $9F, $00, $96, $00, $8D, $00, $85, $00, $7E, $00, $76, $00
    .byte $70, $00, $69, $00, $63, $00, $5E, $00, $58, $00, $53, $00, $4F, $00, $4A, $00
    .byte $46, $00, $42, $00, $3E, $00, $3A, $00, $37, $00, $34, $00, $31, $00, $2E, $00
    .byte $2B, $00, $29, $00, $27, $00, $24, $00, $22, $00, $20, $00, $1E, $00, $1C, $00
    .byte $1B, $00, $19, $00, $F4, $F4, $00, $00, $7F, $08, $60, $C0, $50, $40, $30, $B0
    .byte $28, $30, $24, $D0, $1E, $50, $18, $A0, $14, $20, $00, $F0, $00, $00, $06, $20
    .byte $01, $00, $0E, $20, $1C, $00, $02, $68, $00, $00, $04, $20, $00, $00, $0C, $20
    .byte $1A, $00, $04, $A8, $1A, $00, $04, $48, $7F, $7F, $40, $2A, $20, $19, $15, $12
    .byte $10, $0E, $0C, $0B, $0A, $09, $09, $08, $08, $07, $07, $06, $06, $06, $05, $05
    .byte $05, $05, $04, $04, $04, $04, $04, $04, $04, $03, $03, $03, $03, $03, $03, $03
    .byte $03, $03, $03, $02, $02, $02, $02, $02, $03, $02, $02, $02, $02, $02, $02, $02
    .byte $02, $02, $02, $02, $02, $02, $02, $02, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $13, $B3, $DB, $B3, $89, $B4, $CE, $B9
    .byte $5B, $B6, $08, $B6, $A9, $B6, $CE, $B9, $50, $B7, $A0, $B7, $EA, $B7, $CE, $B9
    .byte $42, $B8, $61, $B8, $80, $B8, $CE, $B9, $00, $B9, $26, $B9, $4B, $B9, $6D, $B9
    .byte $80, $B9, $9C, $B9, $AE, $B9, $CE, $B9
    .incbin "assets/generated/audio/music/prg1-b313.bin", $0, $8  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $18, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $28, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $38, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $48, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $58, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $68, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $78, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $88, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $98, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $A8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $B8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $C8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $D8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $E8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $F8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $108, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $118, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $128, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $138, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $148, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $158, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $168, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $178, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $188, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $198, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $1A8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $1B8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $1C8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $1D8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $1E8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $1F8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $208, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $218, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $228, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $238, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $248, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $258, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $268, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $278, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $288, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $298, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $2A8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $2B8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $2C8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $2D8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $2E8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $2F8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $308, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $318, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $328, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $338, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $348, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $358, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $368, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $378, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $388, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $398, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $3A8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $3B8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $3C8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $3D8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $3E8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $3F8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $408, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $418, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $428, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $438, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $448, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $458, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $468, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $478, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $488, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $498, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $4A8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $4B8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $4C8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $4D8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $4E8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $4F8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $508, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $518, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $528, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $538, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $548, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $558, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $568, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $578, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $588, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $598, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $5A8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $5B8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $5C8, $7  ; rom-asset .byte
    .byte $F9, $88, $22, $FA, $FF, $98, $21, $90, $21
    .byte $86, $21, $85, $22, $21, $86, $22, $85, $2D, $2E, $86, $39, $85, $3A, $2D, $86
    .byte $2E, $85, $21, $22, $F3
    .incbin "assets/generated/audio/music/prg1-b900.bin", $0, $B  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b900.bin", $B, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b900.bin", $1B, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b900.bin", $2B, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b900.bin", $3B, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b900.bin", $4B, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b900.bin", $5B, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b900.bin", $6B, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b900.bin", $7B, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b900.bin", $8B, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b900.bin", $9B, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b900.bin", $AB, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b900.bin", $BB, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b900.bin", $CB, $3  ; rom-asset .byte

World2_BlockAttributes:
    .incbin "assets/generated/audio/music/prg1-b900.bin", $CE, $1  ; rom-asset .byte
    .byte $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $02, $02, $02, $00, $00, $00, $02, $02, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $02, $02, $00, $00, $01, $02, $00, $00, $01, $01, $00, $00, $00
    .byte $02, $01, $00, $00, $00, $00, $00, $03, $01, $01, $01, $00, $00, $00, $01, $03
    .byte $02, $03, $00, $00, $00, $01, $01, $00, $01, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $02, $02, $00, $00, $00, $00, $02, $02, $00, $00, $00, $00, $00, $00, $02
    .byte $02, $00, $00, $02, $02, $03, $00, $00, $00, $03, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $02, $02, $01, $03, $00, $03, $00, $03, $03, $03, $00, $02, $00, $00
    .byte $03, $03, $02, $00, $03, $03, $00, $03, $03, $02, $03, $03, $03, $03, $03, $03
    .byte $03, $03, $03, $03, $03, $03, $03, $03, $03, $00, $00, $01, $01, $02, $00, $03
    .byte $00, $03, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $03, $02, $01, $02, $00, $03, $02, $02, $01, $01, $01
    .byte $01

World2_SmallBlocks:
    .byte $00, $00, $00, $00, $01, $01, $01, $01, $01, $1C, $01, $01, $1D, $21, $01, $01
    .byte $29, $2A, $01, $01, $13, $20, $20, $21, $20, $31, $21, $29, $17, $18, $00, $2A
    .byte $17, $C0, $1C, $1D, $19, $19, $1E, $1F, $19, $24, $24, $0C, $21, $08, $10, $11
    .byte $2B, $01, $08, $2B, $2B, $01, $01, $01, $1C, $1D, $0D, $0E, $1E, $25, $12, $01
    .byte $16, $01, $01, $27, $0D, $05, $20, $21, $06, $17, $29, $2A, $18, $28, $01, $01
    .byte $28, $18, $01, $27, $00, $00, $00, $04, $00, $00, $05, $06, $00, $09, $13, $19
    .byte $19, $24, $1B, $14, $25, $16, $15, $11, $2B, $0A, $16, $01, $00, $00, $0B, $17
    .byte $00, $00, $18, $17, $04, $05, $14, $15, $06, $00, $16, $0A, $00, $04, $13, $14
    .byte $05, $06, $15, $2B, $00, $00, $0A, $00, $35, $36, $45, $46, $37, $38, $47, $48
    .byte $3D, $4E, $60, $61, $4D, $4E, $60, $60, $00, $00, $04, $05, $00, $00, $06, $42
    .byte $39, $3A, $49, $63, $3B, $3C, $4B, $4C, $62, $71, $80, $81, $64, $65, $82, $83
    .byte $90, $91, $70, $71, $92, $93, $72, $73, $60, $3D, $00, $60, $3D, $3E, $4D, $4E
    .byte $59, $3E, $5E, $4E, $3D, $53, $4D, $54, $3D, $57, $4D, $5C, $58, $3E, $59, $4E
    .byte $60, $00, $00, $00, $00, $55, $55, $4E, $A1, $A2, $01, $01, $57, $57, $52, $57
    .byte $01, $01, $2A, $01, $01, $0F, $1C, $1D, $0B, $A4, $A1, $A2, $00, $23, $00, $26
    .byte $C9, $CA, $D9, $DA, $0C, $10, $01, $10, $03, $01, $0C, $01, $44, $57, $00, $44
    .byte $5E, $A4, $00, $1A, $00, $00, $00, $55, $56, $55, $5A, $4E, $00, $55, $55, $3E
    .byte $16, $2B, $2A, $01, $2B, $01, $16, $01, $0A, $00, $01, $0B, $6F, $7F, $00, $00
    .byte $98, $A4, $00, $1A, $99, $7F, $00, $00, $14, $0C, $24, $0C, $00, $56, $00, $5A
    .byte $14, $0C, $0C, $01, $A8, $A9, $00, $1A, $B1, $19, $B1, $19, $3D, $3E, $81, $49
    .byte $40, $95, $C5, $CB, $01, $0B, $01, $01, $00, $00, $00, $AA, $B0, $19, $B1, $B1
    .byte $7F, $FD, $00, $00, $0B, $A4, $01, $A4, $78, $79, $00, $7A, $84, $84, $84, $84
    .byte $18, $09, $0F, $19, $0D, $05, $4D, $4E, $76, $79, $00, $7A, $B1, $24, $24, $0C
    .byte $00, $B0, $AA, $B1, $B1, $19, $B1, $19, $11, $3E, $4D, $4E, $E9, $EA, $F9, $FA
    .byte $80, $81, $90, $91, $82, $83, $92, $93, $00, $42, $42, $5A, $43, $00, $5A, $41
    .byte $0B, $00, $01, $0B, $09, $B1, $B1, $B2, $39, $3A, $49, $4A, $59, $3E, $5E, $4E
    .byte $35, $36, $45, $46, $B1, $B1, $B1, $24, $55, $56, $3D, $3E, $37, $38, $47, $48
    .byte $00, $AA, $00, $B0, $00, $00, $B5, $B6, $3D, $3E, $60, $4E, $00, $60, $00, $00
    .byte $53, $00, $54, $00, $57, $00, $50, $00, $00, $58, $00, $59, $00, $5A, $00, $BB
    .byte $A0, $00, $C1, $A0, $4E, $4D, $3E, $3D, $00, $56, $42, $5A, $56, $00, $52, $41
    .byte $A3, $00, $A3, $00, $39, $3A, $49, $63, $3B, $3C, $4B, $4C, $00, $22, $00, $5E
    .byte $00, $5D, $00, $00, $51, $57, $5E, $52, $57, $57, $52, $57, $57, $5C, $51, $5B
    .byte $5C, $00, $5B, $00, $60, $61, $00, $00, $61, $60, $00, $00, $A8, $A9, $00, $00
    .byte $E4, $C1, $F4, $C1, $13, $19, $19, $24, $C1, $E5, $C1, $F5, $15, $0A, $25, $B4
    .byte $C1, $C1, $C1, $C1, $B9, $C1, $D4, $C1, $C1, $BA, $C1, $D5, $3D, $08, $4D, $4E
    .byte $00, $60, $00, $00, $01, $0F, $0F, $19, $00, $13, $09, $24, $2D, $2E, $2F, $32
    .byte $33, $34, $74, $75, $C2, $C3, $D2, $D3, $A6, $A7, $A7, $A6, $76, $76, $00, $00
    .byte $76, $34, $00, $00, $00, $58, $00, $22, $D1, $1B, $1B, $19, $00, $00, $A5, $A5
    .byte $60, $00, $00, $00, $00, $00, $00, $AA, $00, $B0, $AA, $B1, $B0, $19, $B1, $B1
    .byte $19, $24, $24, $0C, $B1, $19, $B1, $24, $19, $19, $1E, $1F, $17, $C0, $1C, $1D
    .byte $14, $0C, $0C, $01, $21, $08, $10, $11, $00, $04, $13, $14, $B1, $24, $1B, $14
    .byte $25, $16, $15, $11, $2B, $01, $08, $2B, $2B, $01, $16, $01, $06, $00, $16, $0A
    .byte $72, $73, $82, $83, $57, $C3, $57, $52, $7F, $7F, $00, $00, $00, $A4, $00, $1A
    .byte $C2, $C3, $D2, $D0, $C2, $C3, $D2, $D3, $E4, $E4, $E4, $E4, $57, $57, $3E, $C3
    .byte $D1, $D1, $C1, $C1, $C4, $C4, $E4, $E4, $40, $95, $F8, $CB, $00, $6C, $00, $7C
    .byte $6D, $6E, $7D, $7E, $EB, $EC, $FB, $FC, $ED, $EE, $00, $FE, $EF, $00, $FF, $17
    .byte $67, $68, $84, $84, $69, $6A, $2C, $96, $6B, $00, $84, $07, $8B, $8C, $9B, $9C
    .byte $8D, $8E, $9D, $9E, $8F, $00, $9F, $00, $AB, $AC, $BB, $BC, $AD, $AE, $BD, $BE
    .byte $AF, $00, $BF, $00, $00, $CC, $DB, $DC, $CD, $CE, $DD, $DE, $CF, $00, $DF, $00
    .byte $40, $9A, $C5, $CB, $43, $00, $5A, $41, $00, $00, $A6, $A7, $E0, $E3, $F0, $F3
    .byte $C9, $CA, $F6, $F7, $B8, $9A, $F8, $CB, $E0, $E1, $F0, $F1, $E2, $E3, $F2, $F3
    .byte $00, $E6, $A6, $A7, $E7, $E8, $A6, $A7, $00, $C6, $00, $D6, $C7, $C8, $D7, $D8
    .byte $32, $F9, $32, $01, $02, $03, $F2, $04, $04, $05, $F0, $06, $07

World2_Screens:
    .byte $06, $06, $08, $09, $F1, $0A, $0A, $0B, $F0, $0C, $FA, $0D, $0D, $09, $F1, $0E
    .byte $0F, $F0, $10, $FB, $00, $11, $F8, $22, $32, $FC, $23, $23, $24, $25, $26, $F2
    .byte $27, $28, $F0, $29, $2A, $2B, $2C, $F2, $2D, $F0, $2E, $2F, $F2, $30, $31, $F0
    .byte $33, $34, $F1, $35, $36, $F0, $37, $38, $69, $6A, $6B, $F1, $39, $3A, $3B, $3C
    .byte $3D, $F0, $3E, $3F, $FD, $40, $F8, $F2, $54, $F0, $55, $F1, $56, $FE, $57, $5B
    .byte $55, $F1, $56, $FE, $57, $58, $59, $F0, $5A, $5B, $5B, $73, $75, $F1, $5C, $5D
    .byte $5E, $F0, $5A, $60, $F1, $61, $62, $63, $64, $F0, $65, $6F, $72, $65, $71, $72
    .byte $76, $F1, $66, $F0, $67, $F8, $68, $F8, $7F, $F2, $12, $13, $14, $F1, $15, $16
    .byte $17, $F0, $F7, $F1, $18, $19, $1A, $F2, $1B, $1C, $1D, $F0, $F7, $F2, $1E, $1F
    .byte $F1, $20, $21, $F0, $F7, $F2, $41, $42, $F0, $43, $F2, $44, $F0, $43, $F2, $44
    .byte $F0, $43, $F2, $45, $F0, $4F, $F7, $F2, $46, $47, $F0, $48, $49, $F1, $4A, $50
    .byte $F0, $2A, $F7, $F2, $4B, $47, $F0, $49, $F1, $4A, $51, $F0, $F7, $F2, $4C, $47
    .byte $F0, $49, $F1, $4D, $52, $F0, $F7, $4E, $53, $F7, $F1, $6C, $6D, $F2, $70, $5F
    .byte $F0, $F7, $F2, $74, $F1, $6E, $F0, $F7, $7B, $FF, $F8, $C0, $3C, $FD, $23, $FE
    .byte $8C, $AB, $D5, $D6, $06, $D0, $04, $62, $00, $15, $A2, $1F, $DE, $CF, $60, $00
    .byte $09, $F0, $CC, $BF, $40, $C0, $BB, $C0, $8D, $C1, $27, $C2, $C9, $C2, $4E, $C3
    .byte $F2, $C3, $82, $C4, $13, $C5, $AE, $C5, $58, $C6, $F2, $C6, $9D, $C7, $48, $C8
    .byte $FB, $C8, $48, $C9, $AA, $C9, $32, $CA, $D3, $CA, $6C, $CB, $18, $CC, $BD, $CC
    .byte $65, $CD, $D8, $CD, $5E, $CE, $F0, $CE, $80, $CF, $0A, $D0, $8D, $D0, $2C, $D1
    .byte $C5, $D1, $72, $D2, $16, $D3, $5C, $D3, $AE, $D3, $64, $D4, $2D, $D5, $84, $D5
    .byte $F3, $D5, $97, $D6, $49, $D7, $F0, $D7, $A1, $D8, $45, $D9, $D6, $D9, $62, $DA
    .byte $03, $DB, $92, $DB, $35, $DC, $CC, $BF, $B6, $DC, $54, $DD, $E4, $DD, $A0, $DE
    .byte $38, $DF, $EA, $DF, $89, $E0, $27, $E1, $D5, $E1, $82, $E2, $29, $E3, $A1, $E3
    .byte $EC, $E3, $52, $E4, $AF, $E4, $4C, $E5, $C3, $E5, $40, $E6, $C5, $E6, $59, $E7
    .byte $F7, $E7, $6A, $E8, $0C, $E9, $A1, $E9, $4F, $EA, $D4, $EA, $70, $EB, $14, $EC
    .byte $C0, $EC, $22, $ED, $C3, $ED, $38, $EE, $84, $EE, $2B, $EF, $B6, $EF, $2B, $F0
    .byte $8F, $F0, $ED, $F0, $91, $F1, $11, $F2, $B4, $F2, $58, $F3, $F7, $F3, $71, $F4
    .byte $DF, $F4, $2A, $F5, $B2, $F5, $45, $F6, $E3, $F6, $73, $F7, $C2, $F7, $51, $F8
    .byte $C0, $F8, $25, $F9, $78, $F9, $34, $FA, $E8, $FA, $9B, $FB, $00, $FC, $41, $FC
    .byte $BC, $FC, $54, $FD, $C1, $FD, $68, $FE, $FB, $FE, $85, $FF, $B4, $F2, $C2, $F7
    .byte $F2, $00, $D0, $F3, $00, $D0, $F2, $00, $15, $05, $01, $FB, $00, $16, $06, $01
    .byte $FC, $00, $07, $01, $F4, $00, $D0, $F2, $00, $D0, $F2, $00, $08, $01, $FB, $00
    .byte $17, $09, $01, $F3, $00, $D0, $00, $D0, $F3, $00, $1F, $18, $0A, $01, $FA, $00
    .byte $20, $19, $0B, $01, $00, $D0, $F8, $00, $21, $1A, $0C, $01, $F9, $00, $D0, $00
    .byte $1B, $0D, $02, $FB, $00, $1C, $0E, $03, $F1, $00, $D0, $F4, $00, $D0, $F2, $00
    .byte $1D, $0F, $04, $FB, $00, $1E, $10, $01, $FC, $00, $11, $01, $F2, $00, $D0, $F2
    .byte $00, $D0, $F4, $00, $12, $01, $FC, $00, $13, $01, $F4, $00, $D0, $F2, $00, $D0
    .byte $F2, $00, $14, $01, $F9, $00, $D0, $00, $15, $05, $01, $F6, $00, $D0, $F3, $00
    .byte $16, $06, $01, $FC, $00, $07, $01, $FC, $00, $08, $01, $FB, $00, $1F, $0A, $01
    .byte $FB, $00, $1D, $0B, $01, $F7, $00, $D0, $F2, $00, $1E, $0C, $39, $FC, $00, $58
    .byte $5D, $F8, $00, $D0, $F1, $00, $17, $F1, $5D, $F6, $00, $D0, $F2, $00, $1F, $5D
    .byte $69, $5B, $FA, $00, $1D, $18, $0A, $3D, $FA, $00, $1D, $4A, $0B, $5E, $F3, $00
    .byte $52, $5C, $56, $F3, $00, $1D, $F1, $5E, $2F, $F1, $00, $52, $5C, $53, $5D, $5A
    .byte $00, $D0, $F1, $00, $59, $5E, $F1, $2F, $00, $6C, $65, $F1, $5D, $18, $5A, $F3
    .byte $00, $59, $F2, $2F, $1F, $F2, $18, $0A, $3D, $24, $F3, $00, $1E, $F2, $2F, $1D
    .byte $5B, $4A, $4C, $F1, $3D, $24, $00, $D0, $F1, $00, $1F, $22, $28, $2A, $1D, $4C
    .byte $F1, $5E, $F1, $2F, $25, $F3, $00, $1E, $2F, $29, $2B, $59, $5E, $F3, $2F, $24
    .byte $F3, $00, $62, $2F, $28, $2A, $59, $5E, $F1, $2F, $29, $2F, $25, $F3, $00, $63
    .byte $2F, $29, $2B, $66, $22, $2F, $22, $66, $22, $24, $F1, $00, $D0, $00, $62, $2F
    .byte $28, $2A, $29, $23, $29, $23, $29, $23, $25, $F3, $00, $63, $2F, $29, $2B, $66
    .byte $22, $66, $22, $66, $23, $24, $F3, $00, $1F, $2F, $28, $2A, $29, $23, $29, $23
    .byte $29, $23, $81, $F2, $00, $1F, $18, $2F, $29, $2B, $66, $22, $66, $22, $66, $25
    .byte $F2, $00, $D1, $1D, $18, $2F, $28, $2A, $29, $23, $29, $23, $29, $25, $F3, $00
    .byte $1D, $4C, $2F, $29, $2B, $66, $22, $66, $22, $4F, $24, $00, $D0, $F1, $00, $1D
    .byte $19, $2F, $28, $2A, $29, $23, $29, $23, $4F, $81, $F3, $00, $20, $45, $2F, $29
    .byte $2B, $66, $22, $66, $22, $4F, $81, $F3, $00, $21, $1A, $2F, $28, $2A, $29, $23
    .byte $29, $4F, $24, $F5, $00, $1B, $2F, $29, $2B, $66, $22, $66, $24, $F2, $00, $D0
    .byte $F1, $00, $D1, $1D, $2F, $28, $2A, $29, $23, $4F, $81, $F6, $00, $1E, $2F, $29
    .byte $2B, $66, $23, $4F, $81, $F3, $00, $D0, $F1, $00, $1F, $22, $28, $2C, $29, $6E
    .byte $24, $F1, $00, $D0, $F4, $00, $1E, $2F, $29, $2D, $66, $6E, $81, $F7, $00, $D1
    .byte $63, $6E, $2F, $29, $6E, $81, $F9, $00, $70, $71, $66, $4F, $82, $FB, $00, $F1
    .byte $4F, $81, $FB, $00, $66, $4F, $2E, $FB, $00, $29, $4F, $24, $F4, $00, $D0, $F5
    .byte $00, $66, $22, $4F, $2E, $FA, $00, $29, $23, $F1, $4F, $2E, $F9, $00, $66, $22
    .byte $66, $F1, $4F, $24, $F8, $00, $29, $23, $29, $23, $F1, $4F, $2E, $72, $73, $72
    .byte $73, $F3, $00, $66, $22, $66, $22, $66, $F3, $4F, $2F, $4F, $3F, $72, $73, $00
    .byte $29, $23, $29, $23, $29, $23, $29, $23, $2F, $4F, $F3, $2F, $30, $66, $22, $66
    .byte $22, $66, $22, $66, $F1, $23, $22, $4F, $2F, $4F, $F1, $2F, $29, $23, $29, $23
    .byte $29, $23, $29, $23, $29, $23, $29, $23, $29, $23, $29, $60, $61, $2F, $63, $D2
    .byte $F7, $00, $30, $66, $29, $2A, $2B, $F1, $2F, $63, $F7, $00, $30, $22, $23, $2C
    .byte $2D, $F1, $2F, $4F, $63, $D1, $F4, $00, $72, $2F, $6B, $29, $60, $F1, $2F, $24
    .byte $25, $24, $4F, $70, $F3, $00, $73, $F1, $2F, $23, $2F, $29, $2F, $71, $F1, $00
    .byte $2E, $71, $F3, $00, $D2, $30, $2F, $29, $22, $23, $2F, $70, $F8, $00, $30, $6E
    .byte $6B, $66, $29, $2F, $71, $F7, $00, $72, $2F, $6E, $29, $22, $23, $32, $D2, $F7
    .byte $00, $73, $2F, $6E, $23, $66, $29, $32, $F9, $00, $30, $2F, $29, $22, $23, $2F
    .byte $63, $F6, $00, $D1, $35, $2F, $68, $23, $66, $29, $2F, $24, $F4, $00, $35, $F1
    .byte $6A, $F2, $2F, $29, $22, $23, $32, $F5, $00, $2E, $6E, $F1, $2F, $6B, $68, $6B
    .byte $66, $29, $32, $F6, $00, $2E, $25, $F2, $2F, $29, $22, $23, $32, $D2, $F7, $00
    .byte $3F, $2F, $29, $23, $66, $29, $32, $F8, $00, $D2, $67, $23, $29, $66, $29, $32
    .byte $63, $F7, $00, $D1, $30, $2F, $23, $22, $23, $F1, $2F, $63, $F7, $00, $73, $F1
    .byte $2F, $66, $29, $2F, $24, $25, $70, $F7, $00, $2E, $2F, $22, $23, $2F, $70, $00
    .byte $98, $F8, $00, $81, $66, $29, $2F, $71, $FB, $00, $22, $23, $2F, $70, $FB, $00
    .byte $66, $29, $2F, $71, $FB, $00, $22, $23, $32, $D2, $FB, $00, $66, $29, $32, $FC
    .byte $00, $22, $23, $2F, $63, $FB, $00, $66, $29, $2F, $32, $D2, $FA, $00, $22, $23
    .byte $F1, $2F, $63, $F6, $00, $62, $6A, $63, $00, $66, $29, $22, $F1, $2F, $63, $F1
    .byte $6D, $62, $63, $D1, $62, $2F, $6E, $2F, $63, $22, $23, $66, $2F, $F5, $6E, $2F
    .byte $F4, $6E, $28, $2B, $2A, $2B, $2A, $2B, $2A, $2B, $2A, $2B, $2A, $2B, $2A, $2B
    .byte $2A, $2B, $F1, $2F, $81, $F8, $00, $35, $2F, $2A, $F1, $2F, $25, $D3, $F7, $00
    .byte $63, $4F, $2B, $2F, $4F, $7E, $6F, $F7, $00, $6D, $4F, $2A, $F1, $2F, $F1, $7E
    .byte $30, $3F, $F5, $00, $6D, $4F, $2B, $2F, $4F, $2F, $F1, $6E, $2F, $25, $D3, $F3
    .byte $00, $6D, $2F, $2A, $F1, $2F, $6E, $F1, $7E, $7F, $71, $F4, $00, $6D, $4F, $2B
    .byte $2F, $4F, $2F, $32, $71, $F6, $00, $6D, $2F, $2A, $F1, $2F, $7E, $81, $F6, $00
    .byte $D2, $62, $4F, $2B, $F1, $2F, $24, $F7, $00, $62, $7E, $2F, $2A, $F1, $2F, $81
    .byte $F5, $00, $4B, $33, $2F, $6E, $4F, $2B, $2F, $4F, $81, $F4, $00, $43, $F1, $2F
    .byte $6E, $F1, $2F, $2A, $F1, $2F, $24, $D3, $F3, $00, $63, $7E, $F2, $2F, $4F, $2B
    .byte $2F, $4F, $25, $F5, $00, $70, $31, $32, $F1, $2F, $2A, $F1, $2F, $81, $F3, $00
    .byte $D5, $F3, $00, $63, $4F, $2B, $F1, $2F, $2E, $F8, $00, $D1, $2F, $2A, $F1, $2F
    .byte $25, $F8, $00, $D1, $4F, $2B, $22, $2F, $81, $F1, $00, $D5, $F5, $00, $35, $2F
    .byte $2A, $23, $6E, $25, $F5, $00, $D5, $F1, $00, $63, $2F, $2B, $22, $2F, $6E, $6F
    .byte $F7, $00, $6D, $2F, $2A, $23, $6E, $2F, $F1, $30, $73, $F5, $00, $6D, $2F, $2B
    .byte $22, $F4, $2F, $25, $F5, $00, $89, $84, $23, $6E, $F1, $2F, $32, $7F, $71, $F4
    .byte $00, $D4, $F1, $88, $22, $2F, $24, $71, $F8, $00, $F1, $88, $23, $6E, $24, $D3
    .byte $F8, $00, $F1, $88, $22, $2F, $81, $F9, $00, $F1, $88, $23, $6E, $81, $F9, $00
    .byte $F1, $88, $22, $2F, $81, $F9, $00, $F1, $88, $23, $6E, $81, $F9, $00, $8A, $86
    .byte $22, $2F, $81, $F4, $00, $D5, $F2, $00, $62, $2F, $2A, $23, $6E, $81, $F7, $00
    .byte $62, $F1, $2F, $2B, $22, $2F, $2E, $F7, $00, $63, $F1, $2F, $2A, $23, $6E, $25
    .byte $D3, $F7, $00, $63, $2F, $2B, $68, $2F, $81, $F8, $00, $35, $2F, $2A, $6B, $2F
    .byte $25, $F8, $00, $63, $2F, $2B, $68, $F1, $2F, $6F, $F7, $00, $6D, $2F, $2A, $6B
    .byte $F1, $2F, $24, $F7, $00, $6D, $2F, $2B, $68, $2F, $24, $F8, $00, $17, $4F, $2A
    .byte $6B, $2F, $81, $F7, $00, $1F, $18, $4F, $2B, $68, $2F, $81, $F5, $00, $52, $5C
    .byte $18, $4A, $8B, $2A, $6B, $2F, $81, $F4, $00, $D6, $85, $F1, $4A, $4C, $4F, $2B
    .byte $68, $2F, $81, $F5, $00, $87, $F2, $19, $4F, $2A, $6B, $2F, $81, $F6, $00, $64
    .byte $F1, $45, $4F, $2B, $68, $2F, $81, $F7, $00, $64, $0D, $8B, $2A, $6B, $2F, $81
    .byte $F8, $00, $64, $8B, $2B, $68, $2F, $81, $F8, $00, $62, $2F, $2A, $6B, $2F, $81
    .byte $F7, $00, $6D, $F1, $2F, $2B, $68, $2F, $2E, $F7, $00, $6D, $F1, $2F, $2A, $6B
    .byte $2F, $25, $F8, $00, $63, $2F, $2B, $22, $2F, $81, $F8, $00, $6D, $2F, $2A, $23
    .byte $2F, $24, $F8, $00, $6D, $2F, $2B, $32, $71, $D3, $F8, $00, $6D, $2F, $2A, $FB
    .byte $00, $62, $2F, $2B, $F8, $00, $D2, $72, $33, $4F, $2F, $2A, $F8, $00, $62, $6E
    .byte $F1, $4F, $2F, $2B, $F7, $00, $6D, $6E, $F2, $4F, $2F, $2A, $F8, $00, $70, $71
    .byte $63, $F1, $2F, $2B, $FA, $00, $6D, $F1, $2F, $2A, $00, $41, $6F, $F7, $00, $62
    .byte $6E, $2F, $2B, $00, $42, $6E, $8C, $F5, $00, $72, $F2, $2F, $2A, $D1, $42, $6E
    .byte $81, $F4, $00, $D1, $7D, $2F, $6E, $2F, $2B, $62, $4F, $F1, $6E, $8C, $00, $72
    .byte $73, $00, $35, $F3, $2F, $2A, $F1, $4F, $F1, $29, $6E, $67, $F1, $2F, $F1, $67
    .byte $F1, $2F, $6E, $7A, $2B, $66, $68, $66, $68, $66, $68, $F1, $2F, $66, $F2, $2F
    .byte $23, $7A, $2A, $7A, $23, $7A, $23, $7A, $6B, $7A, $6B, $7A, $F1, $2F, $6B, $6E
    .byte $23, $2B, $66, $29, $32, $F8, $00, $D2, $67, $23, $29, $22, $23, $32, $F8, $00
    .byte $3F, $2F, $29, $23, $66, $29, $32, $00, $D7, $F4, $00, $2E, $25, $F2, $2F, $29
    .byte $22, $23, $32, $F5, $00, $2E, $6E, $F1, $2F, $6B, $68, $6B, $66, $29, $2F, $24
    .byte $F4, $00, $35, $F1, $6A, $F2, $2F, $29, $22, $23, $2F, $63, $F5, $00, $D1, $00
    .byte $35, $2F, $68, $23, $66, $29, $32, $F3, $00, $D7, $F4, $00, $30, $2F, $29, $22
    .byte $23, $32, $F8, $00, $73, $2F, $6E, $23, $66, $29, $2F, $71, $00, $D7, $F5, $00
    .byte $72, $2F, $6E, $29, $22, $23, $2F, $70, $F8, $00, $30, $6E, $6B, $2F, $29, $2F
    .byte $71, $F1, $00, $2E, $71, $F3, $00, $D2, $30, $2F, $29, $60, $F1, $2F, $24, $25
    .byte $24, $4F, $70, $F3, $00, $73, $F1, $2F, $23, $2C, $2D, $F1, $2F, $4F, $63, $6D
    .byte $F4, $00, $72, $2F, $6B, $29, $2A, $2B, $F1, $2F, $63, $F7, $00, $30, $22, $23
    .byte $60, $61, $2F, $63, $F5, $00, $D7, $F1, $00, $30, $66, $29, $66, $7A, $32, $24
    .byte $F6, $00, $D7, $00, $30, $8B, $2A, $22, $23, $F1, $4F, $24, $F1, $00, $D7, $F3
    .byte $00, $D2, $67, $2F, $6E, $66, $7A, $2F, $F1, $4F, $24, $D2, $F5, $00, $72, $F1
    .byte $6E, $22, $23, $F1, $2F, $F1, $4F, $71, $F6, $00, $62, $63, $66, $7A, $F2, $2F
    .byte $4F, $70, $F8, $00, $22, $23, $F1, $2F, $4F, $63, $F9, $00, $66, $7A, $F1, $2F
    .byte $63, $F4, $00, $D7, $F4, $00, $22, $23, $2F, $63, $FB, $00, $66, $7A, $2F, $71
    .byte $F1, $00, $D7, $F8, $00, $22, $6B, $2F, $70, $FB, $00, $66, $29, $2F, $71, $F5
    .byte $00, $81, $24, $F3, $00, $22, $23, $2F, $24, $81, $F2, $00, $D7, $2E, $F1, $5E
    .byte $25, $F2, $00, $66, $F1, $29, $F1, $2F, $F1, $24, $F1, $25, $F3, $2F, $24, $F1
    .byte $81, $22, $F3, $23, $FA, $2F, $66, $29, $22, $23, $22, $23, $22, $23, $22, $23
    .byte $22, $23, $22, $23, $22, $23, $22, $8B, $81, $49, $F7, $00, $6D, $6E, $2A, $23
    .byte $8B, $40, $48, $3B, $48, $3B, $6F, $F3, $00, $62, $6E, $2B, $22, $2F, $81, $F3
    .byte $00, $D8, $F2, $00, $6D, $2F, $6E, $2A, $23, $2F, $24, $00, $83, $F6, $00, $63
    .byte $6E, $2B, $22, $2F, $81, $00, $83, $49, $F5, $00, $35, $6E, $2A, $23, $2F, $40
    .byte $3B, $F1, $48, $6F, $F3, $00, $35, $4F, $6E, $2B, $70, $71, $F3, $00, $D8, $F2
    .byte $00, $6D, $2F, $4F, $6E, $2A, $F9, $00, $62, $2F, $4F, $6E, $2B, $F9, $00, $63
    .byte $2F, $4F, $6E, $2A, $72, $73, $F7, $00, $6D, $6E, $4F, $6E, $2B, $22, $2F, $40
    .byte $48, $3B, $48, $6F, $F3, $00, $63, $4F, $6E, $2A, $23, $2F, $25, $00, $47, $00
    .byte $D8, $F4, $00, $63, $6E, $2B, $22, $2F, $81, $00, $54, $F6, $00, $62, $6E, $2A
    .byte $23, $2F, $40, $3B, $48, $3B, $48, $6F, $F2, $00, $6D, $2F, $6E, $2B, $22, $2F
    .byte $81, $F3, $00, $D8, $F3, $00, $63, $6E, $2A, $23, $2F, $81, $F8, $00, $6D, $6E
    .byte $2B, $22, $2F, $81, $F8, $00, $35, $2F, $2A, $23, $6E, $25, $F1, $00, $83, $F4
    .byte $00, $43, $4F, $2F, $2B, $22, $2F, $6E, $6F, $D1, $83, $F4, $00, $C5, $4F, $2F
    .byte $2A, $23, $6E, $24, $49, $00, $83, $F5, $00, $63, $2F, $2B, $22, $2F, $40, $48
    .byte $3B, $48, $8C, $F5, $00, $89, $84, $23, $6E, $25, $00, $47, $00, $D8, $F5, $00
    .byte $F1, $88, $22, $2F, $24, $00, $54, $00, $83, $F4, $00, $D4, $F1, $88, $23, $6E
    .byte $24, $F1, $00, $D1, $83, $F5, $00, $F1, $88, $22, $2F, $81, $F2, $00, $83, $F5
    .byte $00, $F1, $88, $23, $6E, $40, $3B, $AB, $3B, $48, $8C, $F4, $00, $F1, $88, $22
    .byte $2F, $81, $F2, $47, $00, $D8, $F4, $00, $F1, $88, $23, $6E, $81, $54, $83, $54
    .byte $F6, $00, $8A, $86, $22, $2F, $81, $00, $83, $F5, $00, $72, $33, $2F, $2A, $23
    .byte $6E, $81, $D1, $83, $F4, $00, $6D, $4F, $F1, $2F, $2B, $22, $2F, $2E, $F7, $00
    .byte $63, $F1, $2F, $2A, $23, $6E, $25, $F8, $00, $63, $2F, $2B, $68, $23, $32, $F1
    .byte $00, $D7, $F3, $00, $D7, $F1, $00, $67, $23, $29, $66, $29, $32, $F9, $00, $30
    .byte $7A, $23, $22, $23, $32, $F8, $00, $73, $F1, $2F, $29, $66, $7A, $32, $24, $25
    .byte $81, $82, $F4, $00, $72, $F1, $2F, $6B, $22, $23, $4F, $F2, $6E, $C5, $F4, $00
    .byte $D2, $30, $F1, $2F, $66, $7A, $4F, $F1, $6E, $C5, $F2, $00, $D7, $F2, $00, $30
    .byte $F1, $2F, $22, $23, $4F, $6E, $70, $F6, $00, $24, $4F, $66, $29, $66, $7A, $2F
    .byte $C5, $D2, $F5, $00, $2E, $4F, $F1, $2F, $6B, $22, $23, $32, $F6, $00, $73, $F1
    .byte $4F, $F1, $2F, $29, $66, $7A, $2F, $71, $F1, $00, $D7, $F2, $00, $72, $F2, $4F
    .byte $22, $6B, $22, $23, $2F, $70, $F6, $00, $D1, $4F, $2F, $66, $29, $66, $7A, $2F
    .byte $24, $F7, $00, $43, $2F, $22, $23, $F1, $5E, $F1, $2F, $71, $D7, $F4, $00, $6F
    .byte $25, $29, $6B, $29, $5B, $F1, $5E, $2F, $32, $F2, $00, $D7, $F1, $00, $30, $F2
    .byte $5E, $45, $5D, $69, $5B, $4A, $32, $D2, $F4, $00, $30, $F1, $19, $F1, $45, $8D
    .byte $F1, $5D, $5B, $32, $D2, $F3, $00, $D2, $30, $F2, $45, $01, $13, $8D, $F1, $5D
    .byte $4A, $71, $F1, $00, $D7, $00, $73, $0B, $F1, $45, $13, $14, $F1, $00, $17, $5D
    .byte $0A, $70, $D7, $F2, $00, $72, $0B, $01, $64, $D1, $00, $F2, $00, $17, $18, $71
    .byte $F3, $00, $73, $0B, $46, $F2, $00, $F3, $00, $8E, $70, $F3, $00, $72, $1E, $F3
    .byte $00, $FF, $00, $EF, $EF, $EF, $EF, $EF, $EF, $EF, $EF, $EF, $D0, $F7, $00, $D0
    .byte $F2, $00, $13, $8D, $F5, $00, $D0, $F5, $00, $58, $5D, $FB, $00, $17, $F1, $5D
    .byte $F2, $00, $D0, $F6, $00, $1F, $F1, $5D, $5B, $FA, $00, $1D, $0A, $4A, $32, $FA
    .byte $00, $1D, $4A, $24, $D2, $F7, $00, $D0, $F1, $00, $70, $71, $F1, $00, $F4, $00
    .byte $D0, $F8, $00, $FE, $00, $00, $D0, $F8, $00, $72, $73, $F1, $00, $FA, $00, $1D
    .byte $19, $2E, $00, $F3, $00, $D0, $F5, $00, $1E, $0C, $0B, $30, $FB, $00, $64, $45
    .byte $0C, $FC, $00, $13, $45, $EF, $D0, $F8, $00, $D0, $F1, $00, $14, $01, $F4, $00
    .byte $D0, $F2, $00, $D0, $F1, $00, $15, $05, $01, $FB, $00, $16, $06, $01, $FB, $00
    .byte $52, $08, $01, $F9, $00, $52, $5C, $53, $09, $01, $F2, $00, $D0, $F2, $00, $D0
    .byte $00, $6C, $85, $18, $F1, $5B, $01, $F8, $00, $1E, $19, $0B, $19, $0B, $01, $F9
    .byte $00, $46, $45, $0C, $0B, $01, $FA, $00, $46, $45, $0C, $01, $F3, $00, $D0, $F6
    .byte $00, $46, $F1, $01, $FB, $00, $99, $9F, $01, $F9, $00, $99, $9A, $9B, $9E, $01
    .byte $F7, $00, $99, $00, $97, $F2, $4E, $01, $F5, $00, $99, $9A, $8F, $93, $97, $4E
    .byte $9D, $9C, $01, $F4, $00, $A2, $9B, $A3, $90, $94, $97, $9C, $A0, $A1, $01, $F4
    .byte $00, $A7, $F1, $A4, $F1, $A1, $F1, $A4, $A1, $F1, $01, $F5, $00, $64, $A5, $A6
    .byte $A5, $A6, $F1, $A5, $A6, $01, $2C, $2D, $2C, $2D, $89, $F5, $88, $8A, $2C, $2D
    .byte $2C, $2D, $60, $61, $60, $61, $84, $F5, $88, $86, $60, $61, $60, $61, $2A, $A8
    .byte $24, $81, $F7, $00, $82, $25, $2A, $A8, $2C, $2D, $63, $D2, $F8, $00, $72, $2C
    .byte $2D, $60, $F1, $61, $63, $F8, $00, $73, $60, $61, $2A, $A8, $F1, $61, $63, $D2
    .byte $F6, $00, $72, $2A, $A8, $2C, $2D, $F2, $61, $70, $F5, $00, $D2, $73, $2C, $2D
    .byte $60, $F3, $61, $71, $F6, $00, $72, $60, $61, $2A, $A8, $F1, $61, $32, $F5, $00
    .byte $D1, $62, $61, $2A, $A8, $2C, $2D, $F1, $61, $71, $F4, $00, $62, $F2, $61, $2C
    .byte $2D, $60, $61, $24, $81, $D2, $F3, $00, $62, $F3, $61, $60, $61, $2A, $A8, $70
    .byte $F4, $00, $72, $F4, $61, $2A, $A8, $2C, $2D, $71, $F4, $00, $73, $F3, $61, $6E
    .byte $2C, $2D, $60, $61, $70, $D2, $F4, $00, $2E, $F2, $24, $61, $60, $61, $2A, $A8
    .byte $71, $F8, $00, $D2, $2E, $2A, $A8, $2C, $2D, $63, $D2, $F8, $00, $72, $2C, $2D
    .byte $60, $F1, $61, $63, $F8, $00, $73, $60, $61, $2A, $A8, $F1, $61, $63, $D2, $F5
    .byte $00, $D2, $72, $2A, $A8, $2C, $2D, $F2, $61, $63, $F6, $00, $73, $2C, $2D, $60
    .byte $F3, $61, $24, $70, $F5, $00, $72, $60, $61, $2A, $A8, $F2, $61, $71, $34, $F5
    .byte $00, $73, $2A, $A8, $2C, $2D, $61, $24, $81, $D2, $F6, $00, $72, $2C, $2D, $60
    .byte $61, $24, $D2, $F7, $00, $D2, $33, $60, $61, $2A, $A8, $70, $F8, $00, $62, $61
    .byte $2A, $A8, $2C, $2D, $71, $F6, $00, $41, $42, $F1, $61, $2C, $2D, $60, $61, $D2
    .byte $F5, $00, $62, $F3, $61, $60, $61, $2A, $A8, $70, $F4, $00, $72, $F4, $61, $2A
    .byte $A8, $2C, $2D, $71, $F4, $00, $73, $F3, $61, $6E, $2C, $2D, $60, $61, $70, $F5
    .byte $00, $2E, $F2, $24, $61, $60, $61, $2A, $A8, $71, $F8, $00, $D2, $2E, $2A, $A8
    .byte $2C, $2D, $70, $F9, $00, $72, $2C, $2D, $60, $61, $71, $F9, $00, $73, $60, $61
    .byte $2A, $A8, $FA, $00, $72, $2A, $A8, $2C, $2D, $70, $F9, $00, $73, $2C, $2D, $60
    .byte $61, $71, $F9, $00, $73, $60, $61, $2A, $A8, $70, $F9, $00, $72, $2A, $A8, $2C
    .byte $2D, $71, $F9, $00, $73, $2C, $2D, $60, $61, $70, $F9, $00, $72, $60, $61, $2A
    .byte $A8, $71, $00, $35, $63, $6D, $00, $6D, $62, $63, $F1, $00, $73, $2A, $A8, $2C
    .byte $2D, $70, $00, $2E, $25, $F2, $6E, $F1, $24, $F1, $00, $72, $2C, $2D, $60, $61
    .byte $31, $F1, $1C, $42, $F2, $4F, $C5, $F2, $1C, $33, $60, $61, $2A, $A8, $2A, $2B
    .byte $2A, $2B, $2A, $2B, $2A, $2B, $2A, $2B, $2A, $2B, $2A, $A8, $2C, $2D, $2C, $2D
    .byte $2C, $2D, $2C, $2D, $2C, $2D, $2C, $2D, $2C, $2D, $2C, $2D, $60, $61, $60, $61
    .byte $60, $61, $60, $61, $60, $61, $60, $61, $60, $61, $60, $61, $2A, $A8, $2A, $A8
    .byte $2A, $A8, $2A, $A8, $2A, $A8, $2A, $A8, $2A, $A8, $2A, $A8, $2A, $A8, $71, $F9
    .byte $00, $2E, $2A, $A8, $60, $61, $70, $F3, $00, $D7, $00, $2E, $F2, $24, $61, $60
    .byte $61, $2C, $2D, $71, $D7, $F3, $00, $73, $F3, $61, $6E, $2C, $2D, $2A, $A8, $70
    .byte $F4, $00, $72, $F4, $61, $2A, $A8, $60, $61, $D2, $F5, $00, $62, $F3, $61, $60
    .byte $61, $2C, $2D, $71, $F6, $00, $41, $42, $F1, $61, $2C, $2D, $2A, $A8, $70, $F2
    .byte $00, $D7, $F4, $00, $62, $61, $2A, $A8, $60, $61, $24, $D7, $F7, $00, $D2, $33
    .byte $60, $61, $2C, $2D, $61, $24, $81, $F7, $00, $72, $2C, $2D, $2A, $A8, $F2, $61
    .byte $71, $34, $F5, $00, $73, $2A, $A8, $60, $F3, $61, $24, $70, $F2, $00, $D7, $F1
    .byte $00, $72, $60, $61, $2C, $2D, $F2, $61, $63, $F6, $00, $73, $2C, $2D, $2A, $A8
    .byte $F1, $61, $63, $D2, $F6, $00, $72, $2A, $A8, $60, $F1, $61, $63, $F8, $00, $73
    .byte $60, $61, $2C, $2D, $63, $00, $D7, $F1, $00, $D7, $F2, $00, $D7, $00, $72, $2C
    .byte $2D, $2A, $A8, $71, $F4, $00, $D7, $F3, $00, $2E, $2A, $A8, $60, $61, $70, $F5
    .byte $00, $2E, $F2, $24, $61, $60, $61, $2C, $2D, $71, $D7, $F1, $00, $D7, $00, $73
    .byte $F3, $61, $6E, $2C, $2D, $2A, $A8, $70, $F4, $00, $72, $F4, $61, $2A, $A8, $60
    .byte $61, $24, $81, $F3, $00, $D2, $62, $F3, $61, $60, $61, $2C, $2D, $F1, $61, $71
    .byte $D7, $F3, $00, $62, $F2, $61, $2C, $2D, $2A, $A8, $F1, $61, $32, $F6, $00, $62
    .byte $61, $2A, $A8, $60, $F3, $61, $71, $F5, $00, $D2, $72, $60, $61, $2C, $2D, $F2
    .byte $61, $70, $D7, $F5, $00, $73, $2C, $2D, $2A, $A8, $F1, $61, $63, $F7, $00, $72
    .byte $2A, $A8, $60, $F1, $61, $63, $D2, $F7, $00, $73, $60, $61, $2C, $2D, $63, $F5
    .byte $00, $D7, $F2, $00, $72, $2C, $2D, $2A, $A8, $24, $81, $F7, $00, $82, $25, $2A
    .byte $A8, $60, $61, $60, $61, $84, $F5, $88, $86, $60, $61, $60, $61, $2C, $2D, $2C
    .byte $2D, $89, $F5, $88, $8A, $2C, $2D, $2C, $2D, $2A, $2B, $2A, $2B, $84, $F5, $88
    .byte $86, $2A, $2B, $2A, $2B, $F3, $2F, $89, $F5, $88, $8A, $F3, $2F, $35, $63, $F1
    .byte $6D, $F6, $00, $D2, $62, $F1, $2F, $63, $FC, $00, $62, $63, $00, $FF, $00, $EF
    .byte $EF, $EF, $F3, $00, $25, $71, $F9, $00, $F2, $00, $73, $2F, $7F, $F9, $00, $F2
    .byte $00, $30, $2F, $32, $F9, $00, $F1, $00, $6F, $30, $F1, $2F, $71, $D3, $F6, $00
    .byte $D3, $81, $25, $6E, $F2, $2F, $F1, $24, $F5, $81, $2E, $25, $2F, $6E, $2F, $6E
    .byte $2F, $6E, $2F, $6E, $2F, $6E, $2F, $6E, $2F, $6E, $2F, $6E, $22, $23, $22, $23
    .byte $22, $23, $22, $23, $22, $23, $22, $23, $22, $23, $22, $23, $28, $29, $28, $29
    .byte $28, $29, $71, $F1, $00, $73, $28, $29, $28, $29, $28, $29, $F5, $6E, $70, $F1
    .byte $00, $72, $F5, $6E, $71, $3B, $F3, $6D, $F3, $00, $F1, $6D, $D1, $6D, $3B, $73
    .byte $70, $48, $D2, $FA, $00, $AB, $72, $71, $3B, $47, $54, $F9, $00, $3B, $73, $70
    .byte $AB, $47, $F1, $83, $F2, $00, $D7, $F4, $00, $48, $72, $71, $3B, $00, $D1, $F9
    .byte $00, $3B, $73, $70, $AB, $FA, $00, $49, $48, $72, $71, $3B, $47, $54, $F8, $00
    .byte $D2, $3B, $73, $70, $AB, $47, $AA, $F2, $83, $F6, $00, $48, $72, $71, $3B, $F2
    .byte $00, $D1, $F7, $00, $48, $73, $70, $00, $D2, $FA, $00, $3B, $72, $71, $FB, $00
    .byte $49, $48, $73, $70, $F8, $00, $F2, $83, $AA, $48, $72, $24, $F9, $00, $D1, $F2
    .byte $00, $2E, $2F, $24, $71, $F4, $00, $F1, $81, $25, $24, $25, $24, $25, $2F, $F1
    .byte $6E, $24, $71, $F2, $00, $2E, $F1, $4F, $F5, $6E, $F2, $6E, $70, $F2, $00, $62
    .byte $F7, $6E, $70, $48, $6D, $F1, $00, $D7, $F1, $00, $F5, $6D, $AB, $72, $71, $3B
    .byte $47, $54, $F9, $00, $3B, $73, $70, $AB, $47, $F1, $83, $F7, $00, $49, $48, $72
    .byte $71, $3B, $00, $D1, $F5, $00, $F2, $83, $AA, $48, $73, $70, $AB, $F8, $00, $D1
    .byte $49, $AA, $48, $72, $71, $3B, $FB, $00, $3B, $73, $70, $AB, $D2, $F5, $00, $F2
    .byte $83, $F1, $AA, $48, $72, $71, $3B, $F7, $00, $D1, $F2, $00, $48, $73, $70, $AB
    .byte $F2, $00, $D7, $F7, $00, $3B, $72, $71, $3B, $47, $F2, $83, $F3, $00, $F2, $83
    .byte $AA, $48, $73, $70, $F1, $00, $D1, $F6, $00, $D1, $F2, $00, $72, $71, $F5, $00
    .byte $D7, $F6, $00, $73, $2F, $24, $25, $24, $25, $7F, $24, $25, $F3, $00, $25, $24
    .byte $25, $2F, $F7, $6E, $71, $F1, $00, $73, $F3, $6E, $F7, $6E, $70, $F1, $00, $72
    .byte $F3, $6E, $70, $F3, $6D, $62, $37, $63, $F3, $00, $67, $63, $6D, $72, $71, $F2
    .byte $00, $34, $3F, $C5, $F3, $00, $3F, $63, $F1, $00, $73, $70, $F1, $00, $73, $F1
    .byte $37, $24, $F1, $81, $82, $25, $32, $F2, $00, $72, $71, $F1, $00, $72, $F7, $37
    .byte $71, $F1, $00, $73, $70, $F2, $00, $43, $63, $6D, $F1, $00, $F1, $6D, $62, $70
    .byte $F1, $00, $72, $71, $FD, $00, $73, $70, $FD, $00, $72, $71, $FD, $00, $73, $70
    .byte $FD, $00, $72, $71, $FD, $00, $2E, $25, $24, $F1, $81, $00, $24, $F1, $81, $82
    .byte $F3, $00, $82, $25, $4F, $F1, $4F, $2F, $4F, $2F, $4F, $2F, $4F, $2F, $4F, $F2
    .byte $2F, $4F, $F1, $2F, $71, $FD, $00, $73, $70, $F2, $00, $D2, $F4, $00, $D1, $F3
    .byte $00, $72, $71, $3B, $47, $F2, $83, $F3, $00, $F2, $83, $AA, $48, $73, $70, $AB
    .byte $FB, $00, $3B, $72, $71, $3B, $F7, $00, $D2, $F2, $00, $48, $73, $70, $AB, $D2
    .byte $F5, $00, $F2, $83, $F1, $AA, $48, $72, $71, $3B, $FB, $00, $3B, $73, $70, $AB
    .byte $F8, $00, $D1, $49, $AA, $48, $72, $71, $3B, $00, $D1, $F5, $00, $F2, $83, $AA
    .byte $48, $73, $70, $AB, $47, $F1, $83, $F6, $00, $D2, $49, $48, $72, $71, $3B, $47
    .byte $54, $F9, $00, $3B, $73, $70, $48, $6D, $F4, $00, $F5, $6D, $AB, $72, $F2, $6E
    .byte $70, $F2, $00, $62, $F7, $6E, $F1, $6E, $24, $71, $F2, $00, $2E, $F1, $4F, $F5
    .byte $6E, $2F, $24, $71, $F4, $00, $F1, $81, $25, $24, $25, $24, $25, $2F, $24, $F9
    .byte $00, $D1, $F1, $00, $D2, $2E, $70, $F8, $00, $F2, $83, $AA, $48, $72, $71, $FB
    .byte $00, $49, $48, $73, $70, $00, $D2, $FA, $00, $3B, $72, $71, $3B, $F1, $00, $D1
    .byte $F8, $00, $48, $73, $70, $AB, $47, $AA, $F2, $83, $F6, $00, $48, $72, $71, $3B
    .byte $47, $54, $F8, $00, $D2, $3B, $73, $70, $AB, $FA, $00, $49, $48, $72, $71, $3B
    .byte $D2, $00, $D1, $F8, $00, $3B, $73, $70, $AB, $47, $F1, $83, $F8, $00, $48, $72
    .byte $71, $3B, $47, $54, $F9, $00, $3B, $73, $70, $48, $D2, $FA, $00, $AB, $72, $71
    .byte $3B, $F3, $6D, $F3, $00, $F3, $6D, $3B, $73, $F5, $6E, $70, $F1, $00, $72, $F5
    .byte $6E, $28, $29, $28, $29, $28, $29, $71, $F1, $00, $73, $28, $29, $28, $29, $28
    .byte $29, $22, $23, $22, $23, $22, $23, $70, $F1, $00, $72, $22, $23, $22, $23, $22
    .byte $23, $F1, $8B, $F3, $2F, $71, $F1, $00, $73, $F5, $2F, $81, $40, $81, $24, $81
    .byte $40, $F3, $00, $40, $25, $81, $40, $F1, $81, $49, $48, $F2, $00, $3B, $F3, $00
    .byte $48, $F1, $00, $3B, $F1, $00, $00, $3B, $00, $F1, $83, $48, $F3, $00, $3B, $47
    .byte $54, $48, $F1, $00, $00, $48, $F1, $00, $49, $48, $F3, $00, $48, $F1, $00, $3B
    .byte $F1, $00, $00, $3B, $F2, $00, $6F, $D8, $F2, $00, $6F, $D8, $00, $48, $F1, $00
    .byte $00, $6F, $D8, $F9, $00, $6F, $D8, $00, $FF, $00, $EF, $F5, $00, $6D, $62, $63
    .byte $6D, $F5, $00, $F1, $00, $6D, $F1, $00, $35, $F2, $2F, $6E, $63, $F1, $00, $6D
    .byte $F1, $00, $6D, $62, $2F, $63, $35, $F5, $4F, $63, $62, $2F, $63, $6D, $FF, $6E
    .byte $2A, $2B, $2A, $2B, $2A, $2B, $2A, $2B, $2A, $2B, $2A, $2B, $2A, $2B, $2A, $2B
    .byte $5D, $69, $5B, $4A, $32, $F5, $00, $30, $F1, $19, $F1, $45, $5B, $F2, $5E, $71
    .byte $F5, $00, $30, $F2, $5E, $45, $F1, $5E, $2F, $32, $D2, $F5, $00, $6F, $25, $F2
    .byte $8B, $2F, $32, $40, $34, $F8, $00, $40, $6E, $8B, $2F, $71, $3B, $F9, $00, $3B
    .byte $73, $A8, $61, $70, $AB, $F1, $00, $D1, $F6, $00, $48, $72, $61, $A8, $71, $3B
    .byte $47, $F2, $83, $F4, $00, $D2, $3B, $73, $A8, $61, $70, $48, $F9, $00, $48, $72
    .byte $61, $A8, $71, $3B, $F9, $00, $3B, $73, $A8, $61, $70, $AB, $D2, $F6, $00, $D1
    .byte $00, $AB, $72, $61, $A8, $71, $3B, $47, $54, $F4, $00, $F2, $83, $48, $73, $A8
    .byte $61, $70, $AB, $F8, $00, $49, $48, $72, $61, $A8, $71, $3B, $00, $D1, $F6, $00
    .byte $D2, $3B, $73, $A8, $61, $70, $48, $47, $F1, $83, $F6, $00, $48, $72, $61, $A8
    .byte $71, $3B, $47, $54, $F7, $00, $3B, $73, $A8, $A8, $70, $3B, $F8, $00, $D2, $3B
    .byte $73, $A8, $61, $71, $AB, $D2, $F8, $00, $48, $72, $61, $A8, $00, $3B, $47, $F8
    .byte $00, $48, $73, $A8, $61, $70, $AB, $F9, $00, $AB, $72, $61, $A8, $71, $3B, $F9
    .byte $00, $3B, $73, $A8, $61, $70, $AB, $47, $F8, $00, $AB, $72, $61, $A8, $71, $3B
    .byte $47, $F8, $00, $3B, $73, $A8, $61, $70, $48, $F9, $00, $48, $72, $61, $A8, $71
    .byte $3B, $F1, $00, $6D, $F3, $00, $6D, $F1, $00, $3B, $73, $A8, $61, $70, $AB, $00
    .byte $72, $4F, $63, $F1, $00, $62, $6E, $70, $00, $AB, $72, $61, $A8, $71, $3B, $47
    .byte $73, $F5, $61, $71, $00, $48, $73, $A8, $61, $70, $AB, $F1, $00, $81, $3F, $F1
    .byte $61, $32, $81, $00, $49, $48, $72, $61, $A8, $63, $3B, $F2, $6D, $35, $F1, $4F
    .byte $31, $F2, $6D, $3B, $62, $A8, $61, $2F, $4F, $2F, $4F, $2F, $4F, $2F, $4F, $2F
    .byte $4F, $2F, $4F, $2F, $4F, $61, $A8, $2A, $2B, $2A, $2B, $2A, $2B, $2A, $2B, $2A
    .byte $2B, $2A, $2B, $2A, $2B, $2A, $A8, $71, $3B, $47, $54, $F1, $00, $D7, $F4, $00
    .byte $3B, $73, $A8, $61, $70, $48, $47, $F1, $83, $F6, $00, $48, $72, $61, $A8, $71
    .byte $3B, $00, $D2, $F4, $00, $D7, $F1, $00, $3B, $73, $A8, $61, $70, $AB, $F8, $00
    .byte $49, $48, $72, $61, $A8, $71, $3B, $47, $54, $F4, $00, $F2, $83, $48, $73, $A8
    .byte $61, $70, $AB, $F7, $00, $D2, $00, $AB, $72, $61, $A8, $71, $3B, $F1, $00, $D7
    .byte $F6, $00, $3B, $73, $A8, $61, $70, $48, $F9, $00, $48, $72, $61, $A8, $71, $3B
    .byte $47, $F2, $83, $F5, $00, $3B, $73, $A8, $61, $70, $AB, $F1, $00, $D2, $F1, $00
    .byte $D7, $F3, $00, $48, $72, $61, $2F, $71, $3B, $F9, $00, $3B, $73, $A8, $2F, $32
    .byte $40, $34, $F8, $00, $40, $6E, $8B, $F1, $5E, $2F, $32, $F6, $00, $6F, $25, $F2
    .byte $8B, $5B, $F2, $5E, $71, $F2, $00, $D7, $F1, $00, $30, $F2, $5E, $45, $5D, $69
    .byte $5B, $4A, $32, $F5, $00, $30, $F1, $19, $F1, $45, $8D, $F1, $5D, $5B, $32, $D2
    .byte $F1, $00, $D7, $F1, $00, $30, $0C, $F1, $45, $01, $13, $58, $F1, $5D, $4A, $24
    .byte $F3, $00, $2E, $0B, $45, $F1, $13, $14, $F1, $00, $17, $5D, $0A, $4A, $71, $F1
    .byte $00, $73, $19, $0C, $64, $F2, $00, $F2, $00, $1F, $F1, $1D, $70, $F1, $00, $72
    .byte $1D, $1E, $F3, $00, $FF, $00, $EF, $EF, $EF, $EF, $EF, $EF, $EF, $EF, $EF, $EF
    .byte $F6, $00, $64, $F1, $01, $A6, $01, $F1, $A6, $01, $F7, $00, $46, $F1, $01, $A6
    .byte $01, $A6, $01, $F8, $00, $46, $F1, $01, $A6, $F1, $01, $F9, $00, $64, $F3, $01
    .byte $FA, $00, $46, $F2, $01, $FB, $00, $64, $F1, $01, $FC, $00, $13, $01, $FC, $00
    .byte $08, $01, $FB, $00, $17, $09, $01, $FA, $00, $1F, $18, $0A, $01, $FA, $00, $1E
    .byte $F1, $19, $01, $FB, $00, $1E, $45, $01, $FC, $00, $13, $01, $EF, $EF, $FC, $00
    .byte $14, $01, $00, $83, $00, $83, $F3, $00, $83, $F2, $00, $15, $05, $01, $00, $83
    .byte $00, $83, $F2, $00, $D1, $83, $F2, $00, $16, $06, $01, $3B, $48, $3B, $48, $8C
    .byte $D0, $F1, $00, $83, $49, $F2, $00, $07, $01, $83, $F6, $00, $F1, $48, $3B, $AB
    .byte $3B, $55, $36, $83, $F8, $00, $4D, $AB, $3B, $55, $36, $83, $F1, $00, $D1, $83
    .byte $D0, $F3, $00, $83, $4D, $3B, $3A, $01, $83, $00, $83, $00, $83, $F3, $00, $D1
    .byte $F2, $83, $13, $01, $48, $3B, $48, $3B, $48, $8C, $D0, $F2, $00, $4D, $48, $3B
    .byte $55, $36, $FA, $00, $83, $00, $13, $01, $F9, $00, $4D, $48, $3B, $55, $36, $48
    .byte $AB, $3B, $48, $8C, $D0, $F2, $00, $D1, $83, $F1, $00, $11, $01, $F1, $00, $83
    .byte $F6, $00, $83, $F1, $00, $12, $01, $F1, $00, $83, $F2, $00, $D0, $4D, $48, $3B
    .byte $4D, $AB, $3B, $3A, $01, $00, $D1, $83, $F2, $00, $D1, $83, $00, $48, $3B, $48
    .byte $3B, $55, $36, $F1, $00, $83, $F3, $00, $83, $00, $83, $47, $F1, $00, $13, $01
    .byte $F8, $00, $83, $54, $F1, $00, $14, $01, $00, $D0, $F5, $00, $83, $F2, $00, $15
    .byte $05, $01, $F6, $00, $D1, $83, $F2, $00, $16, $06, $01, $F4, $00, $83, $F1, $00
    .byte $83, $49, $F2, $00, $07, $01, $F2, $00, $D0, $D1, $4D, $48, $AB, $F1, $48, $3B
    .byte $AB, $3B, $55, $36, $F5, $00, $83, $00, $4D, $AB, $48, $AB, $3B, $55, $36, $F1
    .byte $00, $D0, $F1, $00, $D1, $83, $49, $83, $AB, $3B, $AB, $3B, $3A, $01, $F4, $00
    .byte $83, $00, $AA, $00, $54, $F2, $00, $13, $01, $F4, $00, $4D, $3B, $48, $3B, $48
    .byte $3B, $AB, $3B, $55, $36, $F2, $00, $D0, $D1, $83, $47, $00, $83, $00, $47, $F1
    .byte $00, $13, $01, $F4, $00, $83, $AA, $4D, $3B, $AB, $3B, $AB, $3B, $55, $36, $F4
    .byte $00, $83, $54, $83, $00, $83, $47, $F1, $00, $11, $01, $00, $D0, $F1, $00, $F1
    .byte $83, $00, $49, $D1, $83, $54, $F1, $00, $12, $01, $F3, $00, $4D, $AB, $3B, $48
    .byte $3B, $48, $3B, $AB, $3B, $3A, $01, $F1, $00, $D0, $D1, $F1, $83, $00, $83, $00
    .byte $48, $3B, $48, $3B, $55, $36, $F3, $00, $83, $F1, $00, $83, $00, $83, $47, $F1
    .byte $00, $13, $01, $00, $D0, $F1, $00, $83, $F2, $00, $D1, $83, $54, $F1, $00, $14
    .byte $01, $FB, $00, $41, $05, $8D, $F4, $00, $D0, $F6, $00, $58, $5D, $FB, $00, $1F
    .byte $5D, $69, $FB, $00, $1D, $4A, $4C, $F3, $00, $D0, $F6, $00, $77, $4C, $7D, $FC
    .byte $00, $70, $71, $F1, $00, $D0, $FB, $00, $FE, $00, $EF, $EF, $00, $D0, $F6, $00
    .byte $D0, $F1, $00, $1F, $2E, $D1, $F6, $00, $D0, $F3, $00, $1D, $0B, $0C, $FB, $00
    .byte $1E, $45, $0C, $FC, $00, $13, $45, $F3, $00, $D0, $F2, $00, $D0, $F3, $00, $13
    .byte $45, $F2, $00, $D0, $F8, $00, $13, $01, $F7, $00, $D0, $F3, $00, $13, $8B, $FC
    .byte $00, $1E, $5E, $F3, $00, $D0, $F8, $00, $70, $FE, $00, $EF, $F1, $00, $D0, $FB
    .byte $00, $F4, $00, $D0, $F8, $00, $FE, $00, $F7, $00, $D0, $F5, $00, $FE, $00, $F9
    .byte $00, $72, $33, $3F, $F1, $00, $F6, $00, $72, $73, $33, $F1, $61, $37, $F1, $67
    .byte $F4, $00, $72, $33, $F2, $61, $4F, $61, $F2, $4F, $72, $73, $72, $73, $72, $37
    .byte $F1, $AC, $61, $AC, $61, $F1, $AC, $F1, $91, $91, $AC, $F1, $4F, $AC, $91, $4F
    .byte $91, $AC, $4F, $F1, $91, $4F, $91, $AC, $AC, $F1, $91, $AC, $91, $AC, $91, $AC
    .byte $91, $AC, $91, $AC, $91, $F1, $AC, $8B, $5E, $63, $F7, $00, $3F, $4F, $F1, $91
    .byte $AC, $8B, $F1, $7E, $63, $F6, $00, $D2, $3F, $4F, $AC, $91, $F3, $7E, $63, $F7
    .byte $00, $3F, $4F, $91, $F1, $AF, $7E, $F1, $25, $63, $6D, $F5, $00, $72, $4F, $91
    .byte $A9, $AF, $7E, $70, $00, $2E, $7E, $70, $F4, $00, $73, $91, $AC, $A9, $AF, $71
    .byte $34, $00, $7B, $7E, $31, $F4, $00, $72, $AC, $91, $A9, $AF, $70, $F2, $00, $2E
    .byte $2F, $70, $F2, $00, $D2, $33, $F1, $91, $F1, $AF, $71, $F3, $00, $2E, $71, $F2
    .byte $00, $72, $91, $AC, $91, $F1, $7E, $70, $F8, $00, $33, $91, $F1, $AC, $A9, $7E
    .byte $71, $F7, $00, $72, $4F, $F2, $91, $7E, $AF, $70, $F7, $00, $73, $F1, $4F, $AC
    .byte $4F, $A9, $AF, $71, $F6, $00, $72, $C5, $F1, $6E, $F1, $AC, $7E, $AF, $70, $F6
    .byte $00, $73, $37, $F1, $4F, $37, $91, $7E, $AF, $31, $DA, $F6, $00, $82, $F1, $24
    .byte $4F, $91, $F2, $7E, $63, $F7, $00, $DA, $72, $AC, $91, $F1, $AF, $2E, $25, $63
    .byte $F7, $00, $73, $91, $AC, $A9, $AF, $63, $00, $2E, $63, $6D, $D2, $F4, $00, $72
    .byte $4F, $91, $F1, $AF, $2E, $63, $00, $2E, $25, $63, $F4, $00, $73, $24, $82, $A9
    .byte $AF, $63, $2E, $63, $F1, $00, $2E, $70, $F6, $00, $F1, $AF, $2E, $70, $2E, $63
    .byte $F1, $00, $71, $F6, $00, $A9, $AF, $70, $34, $00, $2E, $70, $F8, $00, $F1, $AF
    .byte $71, $F1, $00, $43, $71, $F8, $00, $A9, $AF, $70, $F1, $00, $2E, $70, $F3, $00
    .byte $6D, $F3, $00, $F1, $AF, $71, $F2, $00, $71, $F3, $00, $2E, $31, $F2, $00, $A9
    .byte $AF, $77, $F7, $00, $62, $AF, $70, $F1, $00, $F1, $AF, $75, $63, $D1, $F3, $00
    .byte $6D, $62, $7E, $AF, $31, $F1, $00, $A9, $AF, $F1, $7E, $63, $62, $70, $00, $62
    .byte $A9, $7E, $F2, $A9, $70, $00, $A9, $AF, $F3, $7E, $71, $62, $7E, $A9, $7E, $F1
    .byte $AF, $A9, $31, $1F, $7E, $A9, $F3, $AF, $AD, $AF, $AD, $AF, $AD, $F1, $AF, $F2
    .byte $AD, $F1, $7E, $A9, $7E, $F3, $A9, $F1, $AF, $A9, $AF, $F3, $A9, $F1, $91, $81
    .byte $F8, $00, $1D, $F1, $AD, $F1, $AC, $24, $F3, $00, $62, $25, $F2, $00, $1E, $F1
    .byte $AD, $F1, $91, $24, $F3, $00, $63, $25, $F2, $00, $43, $F1, $AD, $91, $AC, $81
    .byte $F4, $00, $63, $2E, $7C, $62, $75, $F1, $AD, $F1, $AC, $3F, $F2, $00, $D5, $F1
    .byte $00, $70, $31, $25, $6A, $A9, $AD, $F1, $91, $4F, $3F, $F7, $00, $D1, $70, $84
    .byte $91, $AC, $F1, $4F, $3F, $F8, $00, $88, $AC, $91, $4F, $24, $37, $73, $F7, $00
    .byte $88, $91, $AC, $32, $82, $C5, $24, $F7, $00, $88, $91, $AC, $24, $F3, $00, $D5
    .byte $F5, $00, $88, $AC, $91, $82, $D9, $F7, $00, $D1, $95, $86, $91, $AC, $81, $F8
    .byte $00, $62, $AF, $AD, $91, $AC, $82, $F4, $00, $4B, $43, $2E, $35, $AF, $F1, $AD
    .byte $AC, $91, $81, $F3, $00, $43, $7E, $71, $70, $71, $63, $F1, $AD, $91, $AC, $82
    .byte $F3, $00, $70, $71, $F2, $00, $1F, $F1, $AD, $F1, $91, $81, $F1, $00, $D5, $F5
    .byte $00, $1D, $F1, $AD, $F1, $91, $81, $F8, $00, $1D, $F1, $AD, $F1, $AC, $24, $D9
    .byte $F2, $00, $62, $25, $F2, $00, $1E, $F1, $AD, $F1, $91, $24, $F2, $00, $D5, $63
    .byte $25, $F2, $00, $43, $F1, $AD, $91, $AC, $81, $F4, $00, $63, $2E, $7C, $62, $75
    .byte $F1, $AD, $F1, $AC, $3F, $F5, $00, $70, $31, $25, $6A, $A9, $AD, $F1, $91, $4F
    .byte $3F, $F7, $00, $63, $F1, $AD, $91, $AC, $F1, $4F, $3F, $F6, $00, $62, $AF, $AD
    .byte $AC, $91, $4F, $24, $37, $73, $F3, $00, $4B, $76, $7E, $AF, $AD, $91, $AC, $32
    .byte $82, $C5, $24, $D9, $F2, $00, $70, $71, $63, $A9, $AD, $91, $AC, $24, $D9, $F7
    .byte $00, $D1, $A9, $AD, $AC, $91, $82, $F8, $00, $6D, $AF, $AD, $91, $AC, $81, $F2
    .byte $00, $D5, $F4, $00, $62, $AF, $AD, $91, $AC, $82, $F4, $00, $4B, $43, $2E, $35
    .byte $AF, $F1, $AD, $AC, $91, $81, $F3, $00, $43, $7E, $71, $70, $71, $63, $F1, $AD
    .byte $91, $AC, $82, $F3, $00, $70, $71, $F2, $00, $1F, $F1, $AD, $F1, $91, $81, $D5
    .byte $F7, $00, $1D, $F1, $AD, $F1, $91, $81, $F8, $00, $1D, $F1, $AD, $F1, $AC, $24
    .byte $F3, $00, $62, $25, $F2, $00, $1E, $F1, $AD, $F1, $91, $24, $D9, $F2, $00, $63
    .byte $25, $F2, $00, $43, $F1, $AD, $91, $AC, $81, $F4, $00, $63, $2E, $7C, $62, $75
    .byte $F1, $AD, $F1, $AC, $3F, $F5, $00, $70, $31, $25, $6A, $A9, $AD, $F1, $91, $4F
    .byte $3F, $F5, $00, $D9, $F1, $00, $70, $84, $91, $AC, $F1, $4F, $3F, $F8, $00, $88
    .byte $AC, $91, $4F, $24, $37, $73, $F7, $00, $88, $91, $AC, $32, $82, $C5, $24, $F7
    .byte $00, $88, $91, $AC, $24, $FA, $00, $88, $AC, $91, $82, $F9, $00, $95, $86, $91
    .byte $AC, $81, $D9, $F4, $00, $D9, $F1, $00, $62, $AF, $AD, $91, $AC, $82, $F4, $00
    .byte $4B, $43, $2E, $35, $AF, $F1, $AD, $AC, $91, $81, $F3, $00, $43, $7E, $71, $70
    .byte $71, $63, $F1, $AD, $91, $AC, $82, $D9, $F2, $00, $70, $71, $F2, $00, $1F, $F1
    .byte $AD, $F1, $91, $81, $F8, $00, $1D, $F1, $AD, $AC, $91, $24, $D9, $F2, $00, $D5
    .byte $F3, $00, $1E, $F1, $AD, $F1, $91, $24, $F9, $00, $70, $31, $AC, $91, $82, $F5
    .byte $00, $D5, $F4, $00, $91, $4F, $81, $FB, $00, $91, $AC, $82, $F1, $00, $D5, $F8
    .byte $00, $F1, $91, $82, $FB, $00, $AC, $91, $24, $D9, $FA, $00, $91, $4F, $24, $F4
    .byte $00, $D5, $F5, $00, $AC, $91, $81, $FB, $00, $F1, $91, $82, $FB, $00, $91, $AC
    .byte $82, $F6, $00, $43, $2E, $F2, $00, $AC, $91, $82, $F4, $00, $D1, $42, $F1, $7E
    .byte $25, $F1, $00, $91, $AC, $24, $F4, $00, $62, $7E, $7D, $7E, $71, $F1, $00, $AC
    .byte $91, $24, $F1, $00, $95, $7B, $62, $7D, $F1, $7E, $7D, $2E, $F1, $7B, $F1, $91
    .byte $24, $00, $42, $7E, $7D, $7E, $F1, $7D, $7E, $F3, $7D, $91, $AC, $81, $35, $2F
    .byte $7E, $7D, $F1, $7E, $7D, $F1, $7E, $7D, $7E, $7D, $F1, $AF, $63, $DA, $F8, $00
    .byte $7B, $7D, $7E, $A9, $AF, $2F, $63, $DA, $F7, $00, $D2, $2E, $7E, $F1, $AF, $2E
    .byte $7E, $63, $F2, $6D, $F6, $00, $2E, $A9, $AF, $63, $2E, $7E, $F1, $25, $2F, $63
    .byte $F6, $00, $F1, $AF, $2E, $70, $2E, $63, $00, $34, $2E, $63, $F5, $00, $A9, $AF
    .byte $70, $34, $00, $2E, $70, $F1, $00, $2E, $70, $F4, $00, $F1, $AF, $71, $F1, $00
    .byte $43, $71, $F2, $00, $34, $F4, $00, $A9, $AF, $70, $F1, $00, $2E, $70, $F8, $00
    .byte $F1, $AF, $71, $F1, $00, $35, $71, $F8, $00, $A9, $AF, $77, $F1, $00, $34, $F9
    .byte $00, $F1, $AF, $75, $63, $FB, $00, $A9, $AF, $F1, $7E, $DA, $FA, $00, $2E, $C0
    .byte $2E, $C0, $F4, $00, $1F, $1E, $F4, $00, $F7, $B0, $96, $9C, $A1, $89, $F3, $B0
    .byte $F8, $B1, $F2, $AE, $F3, $B1, $7E, $AF, $25, $F8, $00, $DC, $B0, $AE, $7E, $A9
    .byte $7D, $25, $F3, $00, $D5, $F3, $00, $B0, $AE, $AF, $A9, $2F, $7E, $25, $2E, $F5
    .byte $00, $DC, $B0, $B1, $AF, $A9, $7E, $F2, $2F, $2E, $F5, $00, $B0, $B1, $F1, $AF
    .byte $F2, $7E, $F1, $2F, $25, $F3, $00, $DC, $B0, $B1, $AF, $F2, $A9, $7F, $71, $70
    .byte $71, $F4, $00, $B0, $B1, $AF, $A9, $AF, $7F, $34, $F6, $00, $DC, $96, $B1, $AF
    .byte $7E, $71, $F8, $00, $17, $B0, $B1, $AF, $7E, $2E, $F7, $00, $17, $18, $96, $AE
    .byte $AF, $A9, $25, $D9, $F5, $00, $17, $18, $4A, $9C, $AE, $AF, $A9, $25, $F4, $00
    .byte $D5, $1F, $F1, $4A, $4C, $A1, $AE, $AF, $A9, $7E, $34, $F4, $00, $1E, $0C, $19
    .byte $0B, $A4, $AE, $AF, $7E, $71, $F6, $00, $64, $F1, $0C, $A5, $AE, $AF, $7E, $25
    .byte $D9, $F6, $00, $64, $0D, $A6, $AE, $AF, $7E, $80, $F8, $00, $64, $A6, $AE, $F1
    .byte $AF, $2E, $F8, $00, $DC, $89, $AE, $7E, $AF, $25, $D9, $F4, $00, $D5, $F2, $00
    .byte $B0, $AE, $7E, $A9, $2E, $D9, $F8, $00, $74, $89, $AF, $A9, $2E, $FA, $00, $78
    .byte $AF, $A9, $7E, $34, $FA, $00, $F1, $AF, $2F, $2E, $FA, $00, $AF, $A9, $F1, $2F
    .byte $2E, $F1, $00, $D5, $F2, $00, $DB, $F2, $00, $AF, $A9, $7E, $2F, $7E, $2E, $F8
    .byte $00, $AF, $F2, $7E, $71, $F9, $00, $AF, $7E, $7F, $71, $FA, $00, $AF, $A9, $2E
    .byte $F3, $00, $62, $25, $F5, $00, $AF, $A9, $2E, $F2, $00, $62, $7E, $71, $F5, $00
    .byte $AF, $A9, $25, $F2, $00, $63, $7E, $2E, $F5, $00, $AF, $7E, $2E, $F3, $00, $63
    .byte $25, $F5, $00, $7E, $A9, $F1, $25, $F3, $00, $63, $25, $7B, $7C, $95, $F1, $7B
    .byte $AF, $F1, $A9, $7D, $2E, $F2, $00, $62, $F5, $7D, $F4, $7E, $F1, $00, $D1, $7E
    .byte $F1, $7D, $F1, $7E, $7D, $7E, $AE, $89, $78, $F7, $00, $35, $F1, $7E, $F1, $7D
    .byte $AE, $84, $78, $DD, $F5, $00, $42, $F4, $7E, $AE, $89, $78, $F3, $00, $DD, $00
    .byte $35, $F1, $7E, $7D, $7E, $7D, $7E, $AE, $84, $78, $F5, $00, $2E, $7D, $7E, $7D
    .byte $F2, $7E, $AE, $89, $78, $F6, $00, $2E, $F1, $25, $7E, $7D, $7E, $AE, $84, $78
    .byte $F8, $00, $2E, $25, $F1, $7D, $AE, $89, $78, $F2, $00, $DD, $F5, $00, $7C, $7D
    .byte $7E, $AE, $84, $78, $FA, $00, $7D, $7E, $AE, $89, $78, $F5, $00, $D1, $D1, $D1
    .byte $00, $43, $F1, $7E, $AE, $84, $78, $F4, $00, $35, $F2, $42, $F1, $7E, $F1, $7D
    .byte $AE, $89, $78, $00, $DD, $F1, $00, $35, $F5, $7E, $7D, $7E, $AE, $84, $78, $F3
    .byte $00, $2E, $F1, $25, $7E, $25, $F1, $7E, $7D, $7E, $AE, $89, $78, $F6, $00, $2E
    .byte $F1, $25, $7E, $F1, $7D, $AE, $84, $78, $F3, $00, $DD, $F4, $00, $2E, $7D, $7E
    .byte $AE, $89, $78, $DD, $F8, $00, $7B, $7D, $7E, $AE, $89, $78, $F9, $00, $7B, $7E
    .byte $7D, $AE, $84, $78, $00, $DD, $F8, $00, $25, $7E, $AE, $89, $78, $F8, $00, $DD
    .byte $F1, $00, $2E, $AE, $84, $78, $F4, $00, $DD, $F6, $00, $84, $88, $78, $FC, $00
    .byte $F1, $88, $78, $FC, $00, $F1, $88, $78, $00, $DD, $F5, $00, $DD, $F3, $00, $F1
    .byte $88, $78, $FC, $00, $EF, $89, $88, $78, $F2, $00, $D6, $F8, $00, $AE, $89, $78
    .byte $F1, $00, $52, $85, $87, $F7, $00, $AE, $84, $78, $F1, $00, $5C, $4A, $19, $64
    .byte $F4, $00, $D1, $00, $AE, $89, $78, $00, $1F, $18, $4A, $19, $45, $64, $F2, $00
    .byte $1F, $F1, $1D, $AE, $84, $B0, $96, $4E, $9C, $A0, $A4, $A5, $A6, $89, $B0, $96
    .byte $9D, $9C, $A1, $AE, $F4, $B1, $F4, $AE, $F4, $B1, $7E, $AF, $25, $F5, $00, $D5
    .byte $F1, $00, $1E, $A5, $AE, $7E, $A9, $7E, $25, $95, $7C, $F6, $00, $89, $84, $AF
    .byte $A9, $AF, $F2, $7E, $25, $F4, $00, $DC, $B0, $88, $AF, $A9, $F1, $AF, $F2, $7E
    .byte $2E, $F4, $00, $B0, $88, $AF, $A9, $7E, $AF, $7E, $25, $70, $71, $F3, $00, $DC
    .byte $B0, $88, $AF, $A9, $AF, $7E, $25, $F7, $00, $96, $86, $AF, $A9, $7E, $25, $71
    .byte $F6, $00, $17, $9D, $B1, $AF, $7E, $71, $F6, $00, $52, $5C, $69, $9C, $B1, $AF
    .byte $7E, $2E, $F5, $00, $D6, $85, $18, $5B, $A0, $AE, $AF, $7E, $25, $F6, $00, $87
    .byte $0B, $3E, $A1, $AE, $F1, $AF, $25, $F7, $00, $64, $45, $A6, $AE, $F1, $AF, $7E
    .byte $34, $F7, $00, $64, $A6, $AE, $AF, $7E, $71, $F9, $00, $89, $B1, $AF, $7E, $25
    .byte $D9, $F4, $00, $D5, $F1, $00, $DC, $B0, $B1, $F1, $AF, $80, $F9, $00, $B0, $B1
    .byte $AF, $7E, $2E, $F8, $00, $DC, $B0, $B1, $7E, $AF, $25, $F8, $00, $DC, $B0, $B1
    .byte $AF, $F1, $7E, $2E, $F2, $00, $D5, $F4, $00, $B0, $B1, $71, $63, $F1, $7E, $25
    .byte $F6, $00, $DC, $B0, $B1, $F1, $00, $63, $7E, $2E, $F7, $00, $B0, $B1, $F2, $00
    .byte $63, $7E, $25, $F2, $00, $D5, $F1, $00, $DC, $B0, $B1, $F3, $00, $70, $34, $F6
    .byte $00, $96, $B1, $FB, $00, $17, $9D, $B1, $F9, $00, $52, $5C, $69, $9C, $B1, $F8
    .byte $00, $D6, $85, $18, $5B, $A0, $AE, $F9, $00, $87, $0B, $3E, $A1, $AE, $2E, $F9
    .byte $00, $64, $45, $A6, $AE, $7E, $2E, $F9, $00, $64, $A6, $AE, $7D, $7E, $25, $F8
    .byte $00, $DC, $89, $AE, $7E, $7D, $7E, $2E, $95, $7B, $95, $7B, $95, $F1, $7B, $F1
    .byte $00, $8A, $AE, $7D, $7E, $FA, $7D, $A6, $AE, $7D, $F1, $7E, $7D, $F1, $7E, $7D
    .byte $7E, $7D, $7E, $7D, $F1, $7E, $A6, $AE, $F1, $7E, $70, $F6, $00, $7E, $F1, $7D
    .byte $7E, $7D, $7E, $7E, $AF, $71, $2E, $71, $F4, $00, $42, $63, $62, $F1, $6A, $7E
    .byte $7E, $AF, $70, $43, $70, $F7, $00, $D1, $00, $7E, $A9, $AF, $71, $95, $71, $F7
    .byte $00, $34, $2E, $7E, $7E, $AF, $70, $25, $62, $71, $00, $DE, $F3, $00, $2E, $F2
    .byte $7D, $A9, $7E, $25, $63, $00, $62, $71, $F3, $00, $7B, $35, $F2, $7E, $F1, $7E
    .byte $63, $F1, $00, $25, $70, $F3, $00, $95, $30, $63, $00, $62, $F1, $AF, $71, $F1
    .byte $2E, $25, $34, $F4, $00, $D1, $2E, $2F, $25, $A9, $AF, $25, $F2, $7E, $25, $34
    .byte $00, $DD, $F2, $00, $62, $7E, $7D, $A9, $AF, $F1, $7E, $63, $00, $43, $25, $34
    .byte $F4, $00, $30, $7E, $A9, $AF, $7E, $63, $F1, $00, $2E, $7E, $70, $F3, $00, $7C
    .byte $7D, $7E, $F1, $AF, $63, $F1, $00, $2E, $7E, $63, $F4, $00, $7B, $F1, $7D, $F1
    .byte $7E, $71, $00, $2E, $7E, $31, $F5, $00, $25, $7D, $7E, $8B, $F3, $7E, $63, $F1
    .byte $00, $DE, $F2, $00, $25, $7E, $F1, $7D, $8B, $5E, $71, $F1, $6D, $F5, $00, $2E
    .byte $F1, $7E, $7D, $7E, $F1, $7E, $70, $F1, $00, $2E, $34, $F1, $00, $D7, $00, $42
    .byte $F2, $7E, $7D, $7E, $AF, $71, $00, $2E, $70, $35, $F4, $00, $43, $F2, $7E, $7E
    .byte $AF, $70, $00, $43, $71, $F5, $00, $D1, $76, $77, $35, $A9, $AF, $71, $00, $2E
    .byte $70, $F9, $00, $7E, $AF, $70, $2E, $63, $F2, $00, $DD, $F6, $00, $A9, $7E, $71
    .byte $76, $71, $FA, $00, $F1, $7E, $70, $2E, $70, $FA, $00, $F1, $AF, $25, $63, $F2
    .byte $00, $7C, $F7, $00, $63, $62, $63, $F3, $00, $4B, $71, $F6, $00, $F6, $00, $7C
    .byte $70, $F3, $00, $2E, $F1, $25, $F6, $00, $4B, $71, $F1, $00, $34, $2E, $7E, $A9
    .byte $7E, $F6, $00, $2E, $70, $00, $2E, $F1, $7E, $A9, $F1, $7E, $25, $2E, $F2, $25
    .byte $71, $2E, $7E, $71, $2E, $7E, $F4, $A9, $A9, $F1, $AF, $F7, $7E, $F1, $A9, $7E
    .byte $F1, $A9, $A9, $AF, $7E, $F7, $AF, $7E, $AF, $7E, $F1, $AF, $F1, $A9, $F1, $7E
    .byte $A9, $71, $F2, $00, $D5, $F2, $00, $AF, $A9, $F1, $AF, $25, $7F, $80, $F6, $00
    .byte $6D, $AF, $AD, $F1, $7E, $25, $F8, $00, $6D, $AF, $A9, $AF, $25, $34, $F5, $00
    .byte $76, $2E, $00, $6D, $AF, $AD, $AF, $25, $D9, $F3, $00, $43, $25, $71, $63, $2E
    .byte $43, $F1, $AF, $AF, $25, $F3, $00, $6D, $2F, $25, $F1, $00, $63, $7E, $AF, $AD
    .byte $AF, $2E, $F2, $00, $D5, $6D, $2F, $2E, $F2, $00, $63, $F1, $AD, $AF, $7E, $F4
    .byte $00, $63, $2F, $2E, $F1, $00, $6D, $AF, $AD, $AF, $7E, $2E, $F4, $00, $70, $71
    .byte $F1, $00, $6D, $F1, $AD, $AF, $7E, $2E, $F8, $00, $D1, $F1, $AD, $AF, $7E, $25
    .byte $D9, $F7, $00, $62, $F1, $AD, $F2, $7E, $2E, $F6, $00, $35, $7E, $AF, $AD, $AF
    .byte $F2, $7E, $2E, $D5, $F3, $00, $62, $F1, $2F, $AF, $AD, $F1, $7E, $2F, $7E, $71
    .byte $F4, $00, $63, $25, $63, $AF, $AD, $AF, $7E, $2F, $71, $F5, $00, $35, $25, $6D
    .byte $F1, $AF, $AF, $7E, $25, $D9, $F4, $00, $35, $25, $00, $35, $F1, $AF, $7E, $AF
    .byte $25, $F3, $00, $D5, $F3, $00, $42, $AF, $A9, $AF, $25, $34, $F8, $00, $42, $AF
    .byte $A9, $7E, $25, $F8, $00, $43, $7E, $A9, $AD, $7E, $34, $F7, $00, $43, $F1, $7E
    .byte $A9, $AD, $7E, $2E, $F7, $00, $63, $F1, $7E, $A9, $AD, $7E, $25, $D9, $F7, $00
    .byte $70, $31, $F1, $A9, $7E, $25, $D9, $F1, $00, $D5, $F2, $00, $D5, $F2, $00, $89
    .byte $84, $7E, $34, $F9, $00, $DC, $B0, $88, $7E, $2E, $F9, $00, $DC, $B0, $88, $7E
    .byte $25, $FA, $00, $8A, $86, $7E, $2E, $F8, $00, $95, $43, $AD, $A9, $A9, $7E, $25
    .byte $F2, $00, $D5, $F2, $00, $42, $F1, $7E, $AF, $AD, $F1, $A9, $7E, $25, $F4, $00
    .byte $62, $7E, $F1, $A9, $AF, $AD, $F1, $A9, $7E, $2E, $F3, $00, $D5, $63, $7E, $A9
    .byte $7D, $AF, $7E, $7E, $A9, $7E, $AF, $2E, $F3, $00, $62, $7D, $A9, $F1, $7E, $AD
    .byte $A9, $7E, $A9, $7E, $25, $F3, $00, $63, $F1, $7E, $A9, $7E, $AD, $F2, $37, $C5
    .byte $F3, $00, $73, $6E, $4F, $6E, $F3, $37, $25, $00, $34, $F4, $00, $72, $C5, $00
    .byte $2E, $F3, $25, $7E, $25, $70, $F6, $00, $2E, $7D, $F1, $2F, $7D, $2F, $A9, $AF
    .byte $71, $F6, $00, $43, $F1, $2F, $7E, $7D, $7E, $7E, $AF, $70, $D2, $F5, $00, $D2
    .byte $F1, $42, $7E, $F1, $7D, $A9, $7E, $71, $F9, $00, $42, $F1, $7E, $F1, $7E, $70
    .byte $F9, $00, $95, $F1, $7E, $F1, $AF, $71, $DA, $F7, $00, $DA, $2E, $2F, $7E, $A9
    .byte $AF, $70, $00, $F1, $2E, $F5, $00, $2E, $F1, $7E, $7D, $A9, $AF, $71, $2E, $7E
    .byte $63, $F4, $00, $DA, $6D, $95, $F1, $7E, $A9, $AF, $F1, $7E, $63, $F6, $00, $34
    .byte $2E, $7D, $7E, $F1, $AF, $63, $6D, $F6, $00, $95, $F1, $7E, $F1, $7D, $F1, $81
    .byte $DA, $F8, $00, $62, $63, $00, $62, $AC, $37, $98, $F7, $00, $2E, $F1, $25, $2E
    .byte $25, $F1, $AC, $32, $F5, $00, $DA, $25, $F3, $7E, $7D, $AC, $91, $32, $F5, $00
    .byte $2E, $F1, $7E, $7D, $7E, $7D, $7E, $91, $AC, $32, $F5, $00, $30, $7D, $F1, $7E
    .byte $7D, $F1, $7E, $F1, $91, $32, $82, $F4, $00, $35, $42, $7D, $F3, $7E, $AC, $91
    .byte $32, $C5, $F6, $00, $43, $7D, $7E, $7D, $7E, $91, $AC, $32, $F1, $00, $DD, $F5
    .byte $00, $76, $7E, $F1, $7D, $F1, $AC, $32, $F8, $00, $D1, $7B, $7D, $7E, $91, $4F
    .byte $32, $F5, $00, $DD, $F2, $00, $95, $F1, $7E, $AC, $91, $32, $24, $F8, $00, $2E
    .byte $2F, $7E, $F1, $91, $6E, $37, $73, $24, $81, $F4, $00, $2E, $F1, $7E, $7D, $AC
    .byte $91, $32, $C5, $72, $6E, $C5, $F4, $00, $D2, $95, $F1, $7E, $91, $4F, $C5, $00
    .byte $24, $C5, $F1, $00, $DD, $F2, $00, $34, $2E, $7D, $7E, $91, $37, $F1, $24, $C5
    .byte $F5, $00, $95, $F1, $7E, $F1, $7D, $91, $AC, $37, $C5, $F7, $00, $62, $63, $00
    .byte $62, $AC, $91, $32, $81, $98, $00, $DD, $F5, $00, $2E, $F1, $25, $F2, $AC, $6E
    .byte $32, $F3, $00, $DD, $F2, $00, $62, $7E, $7D, $F1, $AC, $32, $6E, $32, $98, $F6
    .byte $00, $2E, $7D, $7E, $F3, $AC, $6E, $32, $F6, $00, $F1, $6A, $7E, $91, $F2, $AC
    .byte $6E, $32, $F6, $00, $D1, $00, $7E, $F1, $91, $AC, $F1, $6E, $C5, $F2, $00, $D7
    .byte $F2, $00, $34, $2E, $7E, $F1, $AC, $F1, $6E, $C5, $D2, $F5, $00, $2E, $F2, $7D
    .byte $91, $AC, $32, $C5, $F6, $00, $7B, $35, $F2, $7E, $F1, $AC, $32, $F7, $00, $95
    .byte $30, $63, $D8, $62, $AC, $6E, $C5, $F4, $00, $7C, $80, $F1, $00, $6D, $2E, $2F
    .byte $25, $91, $32, $DA, $F4, $00, $7B, $7F, $F2, $00, $F1, $7E, $7D, $AC, $32, $81
    .byte $8C, $F3, $00, $95, $25, $71, $00, $2E, $63, $30, $7E, $91, $AC, $4F, $C5, $00
    .byte $DD, $F2, $00, $43, $7E, $25, $63, $7C, $7D, $7E, $F1, $91, $C5, $F6, $00, $F1
    .byte $6A, $00, $7B, $F1, $7D, $91, $32, $98, $F6, $00, $D1, $F1, $00, $7B, $7D, $7E
    .byte $91, $AC, $32, $24, $98, $F1, $00, $DD, $F4, $00, $7B, $F1, $7D, $AC, $91, $F2
    .byte $32, $F7, $00, $7B, $7D, $7E, $F1, $AC, $32, $6E, $32, $98, $F6, $00, $2E, $7D
    .byte $7E, $F3, $AC, $6E, $32, $F6, $00, $F1, $6A, $7E, $91, $F2, $AC, $6E, $32, $F6
    .byte $00, $D2, $00, $7E, $F1, $91, $AC, $F1, $6E, $C5, $F6, $00, $34, $2E, $7E, $F1
    .byte $AC, $F1, $6E, $C5, $F6, $00, $2E, $F2, $7D, $91, $AC, $32, $C5, $D2, $F5, $00
    .byte $7B, $35, $F2, $7E, $F1, $AC, $32, $D2, $F6, $00, $95, $30, $63, $D8, $62, $AC
    .byte $6E, $C5, $F4, $00, $7C, $80, $F1, $00, $6D, $2E, $2F, $25, $91, $32, $D2, $F4
    .byte $00, $7B, $7F, $F2, $00, $F1, $7E, $7D, $AC, $32, $81, $8C, $F3, $00, $95, $25
    .byte $71, $00, $2E, $63, $30, $7E, $91, $AC, $4F, $C5, $F4, $00, $43, $7E, $25, $63
    .byte $7C, $7D, $7E, $F1, $91, $C5, $D2, $F5, $00, $F1, $6A, $00, $7B, $F1, $7D, $91
    .byte $32, $98, $F7, $00, $D1, $00, $7B, $7D, $7E, $91, $AC, $32, $24, $98, $F7, $00
    .byte $7B, $F1, $7D, $AC, $91, $F2, $32, $D2, $F6, $00, $7B, $7D, $7E, $AC, $37, $F1
    .byte $4F, $32, $F7, $00, $2E, $7D, $45, $91, $AC, $F2, $4F, $F1, $00, $D7, $F4, $00
    .byte $62, $4C, $45, $F1, $91, $AC, $4F, $C5, $F8, $00, $26, $D1, $AC, $91, $32, $C5
    .byte $FB, $00, $91, $AC, $C5, $F7, $00, $D7, $F3, $00, $F1, $AC, $24, $F2, $00, $D7
    .byte $F8, $00, $91, $4F, $C5, $F9, $00, $D7, $F1, $00, $AC, $C5, $F7, $00, $D7, $F4
    .byte $00, $91, $24, $98, $00, $D7, $FA, $00, $AC, $91, $32, $F3, $00, $D7, $F7, $00
    .byte $91, $4F, $C5, $F1, $00, $24, $F3, $00, $D7, $F4, $00, $91, $37, $24, $82, $3F
    .byte $C5, $F9, $00, $91, $AC, $37, $4F, $C5, $FA, $00, $AC, $91, $32, $C5, $FB, $00
    .byte $F1, $AC, $32, $FC, $00, $FC, $00, $13, $8D, $F8, $00, $D0, $F2, $00, $58, $5D
    .byte $FB, $00, $1F, $F1, $5D, $F2, $00, $D0, $F7, $00, $1D, $69, $5B, $FB, $00, $1D
    .byte $4A, $25, $F6, $00, $D0, $F3, $00, $70, $71, $D2, $F8, $00, $D0, $F4, $00, $FE
    .byte $00, $EF, $EF, $FB, $00, $1D, $2E, $D2, $F4, $00, $D0, $F5, $00, $6A, $0B, $30
    .byte $F9, $00, $D0, $00, $1E, $45, $0C, $FC, $00, $13, $45, $EF, $FC, $00, $13, $01
    .byte $F3, $00, $D0, $F7, $00, $13, $8D, $FC, $00, $8D, $5D, $F7, $00, $D0, $F2, $00
    .byte $17, $F1, $5D, $F3, $00, $D0, $F5, $00, $17, $5D, $69, $4A, $F9, $00, $8E, $18
    .byte $0A, $4C, $25, $F9, $00, $70, $71, $70, $71, $00, $F8, $00, $D0, $F4, $00, $F2
    .byte $00, $D0, $F1, $00, $D0, $F7, $00, $FE, $00, $EF, $F3, $00, $D0, $F4, $00, $7B
    .byte $62, $2E, $F1, $7B, $F9, $00, $1E, $F2, $0B, $7D, $F6, $00, $D0, $F2, $00, $64
    .byte $01, $F1, $45, $FB, $00, $64, $F1, $45, $F3, $00, $D0, $F3, $00, $D0, $F2, $00
    .byte $13, $45, $FC, $00, $14, $01, $FB, $00, $15, $05, $8D, $FB, $00, $16, $8D, $5D
    .byte $FB, $00, $17, $5D, $69, $FA, $00, $1F, $F1, $0A, $4A, $FA, $00, $70, $71, $70
    .byte $71, $FE, $00, $EF, $FA, $00, $95, $F1, $7B, $00, $FA, $00, $1E, $F1, $19, $2E
    .byte $FB, $00, $13, $F1, $0C, $FB, $00, $13, $F1, $01, $F6, $00, $B3, $BB, $BE, $C1
    .byte $B5, $B8, $F1, $01, $F6, $00, $B4, $BC, $BF, $C2, $B6, $B9, $F1, $01, $F7, $00
    .byte $BD, $C0, $C3, $B7, $BA, $02, $01, $FA, $00, $1C, $8E, $03, $01, $FA, $00, $8E
    .byte $5B, $03, $01, $5D, $69, $4A, $7D, $7E, $70, $F2, $00, $D2, $2E, $25, $45, $0C
    .byte $F1, $45, $69, $5B, $5E, $71, $2E, $31, $F5, $00, $2E, $5E, $F1, $0C, $5B, $5E
    .byte $7E, $70, $00, $2E, $70, $F5, $00, $25, $F1, $75, $F2, $25, $71, $00, $35, $71
    .byte $F6, $00, $F1, $2E, $F4, $00, $2E, $70, $F6, $00, $D2, $00, $61, $C5, $F2, $00
    .byte $35, $80, $F6, $00, $72, $61, $AC, $32, $C5, $00, $72, $71, $F7, $00, $73, $AC
    .byte $61, $32, $3F, $C5, $33, $C5, $D2, $F6, $00, $D2, $61, $AC, $98, $00, $81, $82
    .byte $24, $C5, $F4, $00, $72, $00, $72, $AC, $61, $C5, $D2, $F2, $00, $81, $F4, $00
    .byte $73, $C5, $33, $61, $4F, $32, $F9, $00, $33, $4F, $8F, $AC, $61, $98, $F9, $00
    .byte $81, $82, $3F, $61, $AC, $C5, $D2, $F9, $00, $D2, $72, $AC, $61, $6E, $C5, $F7
    .byte $00, $D2, $33, $F1, $6E, $61, $AC, $32, $24, $F7, $00, $72, $F1, $6E, $F1, $AC
    .byte $61, $32, $D2, $F7, $00, $33, $F3, $AC, $37, $98, $F7, $00, $72, $AC, $F1, $24
    .byte $8C, $24, $61, $C5, $F7, $00, $33, $24, $00, $D9, $F1, $00, $AC, $24, $F6, $00
    .byte $72, $24, $F4, $00, $AC, $C5, $D2, $F5, $00, $8C, $F5, $00, $61, $24, $FD, $00
    .byte $AC, $32, $C5, $FC, $00, $61, $32, $3F, $C5, $FB, $00, $AC, $98, $73, $24, $F7
    .byte $00, $72, $D1, $72, $C5, $61, $C5, $F9, $00, $73, $C5, $33, $61, $4F, $32, $D2
    .byte $F8, $00, $33, $4F, $8F, $AC, $61, $98, $F9, $00, $81, $82, $3F, $61, $AC, $C5
    .byte $F3, $00, $72, $C5, $F5, $00, $72, $AC, $F1, $24, $F3, $00, $33, $37, $C5, $F2
    .byte $00, $73, $F1, $6E, $61, $FF, $B0, $61, $24, $F6, $00, $61, $4F, $61, $AC, $4F
    .byte $B0, $32, $98, $F6, $00, $C5, $32, $24, $C5, $4F, $74, $24, $D9, $00, $D5, $F5
    .byte $00, $C5, $24, $F2, $00, $24, $D9, $F8, $00, $C5, $24, $F1, $00, $24, $FA, $00
    .byte $C5, $3F, $00, $24, $D9, $F4, $00, $D5, $F3, $00, $D1, $37, $3F, $24, $D9, $FA
    .byte $00, $C5, $37, $6E, $FC, $00, $C5, $37, $3F, $F3, $00, $D5, $F7, $00, $37, $24
    .byte $FC, $00, $37, $24, $00, $D5, $FA, $00, $37, $81, $FC, $00, $37, $6E, $73, $F6
    .byte $00, $72, $33, $81, $F1, $00, $F1, $37, $6E, $33, $81, $F3, $00, $72, $F1, $37
    .byte $3F, $F1, $00, $F3, $37, $67, $73, $F1, $00, $72, $F3, $37, $F1, $67, $F5, $37
    .byte $F1, $67, $F6, $37, $89, $88, $78, $F2, $00, $3F, $37, $C5, $F4, $00, $72, $AC
    .byte $84, $88, $78, $F2, $00, $72, $4F, $24, $F3, $00, $DD, $8C, $24, $89, $88, $78
    .byte $F2, $00, $8C, $98, $F3, $00, $DD, $F2, $00, $84, $88, $78, $FC, $00, $89, $88
    .byte $78, $F7, $00, $DD, $F3, $00, $84, $88, $78, $FC, $00, $89, $88, $78, $F3, $00
    .byte $DD, $F7, $00, $84, $88, $78, $FC, $00, $89, $88, $78, $F8, $00, $72, $D1, $72
    .byte $C5, $84, $88, $78, $F8, $00, $73, $C5, $33, $61, $89, $88, $78, $F8, $00, $33
    .byte $4F, $8F, $AC, $84, $88, $78, $F8, $00, $81, $82, $3F, $61, $89, $88, $78, $F2
    .byte $00, $72, $C5, $F5, $00, $72, $AC, $84, $88, $74, $F2, $00, $33, $37, $C5, $F2
    .byte $00, $73, $F1, $6E, $61, $F2, $88, $FC, $B0, $89, $88, $78, $F2, $00, $3F, $37
    .byte $C5, $F4, $00, $72, $AC, $84, $88, $78, $F2, $00, $72, $4F, $24, $F4, $00, $73
    .byte $AC, $89, $88, $78, $F2, $00, $8C, $98, $F5, $00, $72, $AC, $84, $88, $78, $FA
    .byte $00, $73, $61, $89, $88, $78, $FB, $00, $86, $84, $88, $78, $FB, $00, $88, $89
    .byte $88, $78, $FB, $00, $88, $84, $88, $78, $FB, $00, $88, $89, $88, $78, $F8, $00
    .byte $72, $F1, $00, $88, $84, $88, $78, $F1, $00, $6E, $F2, $61, $24, $F1, $00, $73
    .byte $C5, $97, $8A, $89, $88, $78, $F1, $00, $8C, $3F, $37, $32, $F2, $00, $33, $4F
    .byte $8F, $AC, $84, $88, $78, $F2, $00, $73, $37, $98, $F2, $00, $81, $82, $93, $61
    .byte $89, $88, $78, $F2, $00, $72, $37, $F5, $00, $72, $AC, $84, $88, $74, $F2, $00
    .byte $33, $37, $C5, $F2, $00, $73, $F1, $6E, $61, $F2, $88, $FC, $B0, $AF, $F3, $AD
    .byte $89, $F3, $88, $8A, $F1, $AD, $AF, $F1, $AD, $A9, $AD, $A9, $AF, $A9, $71, $F3
    .byte $00, $7B, $A9, $AF, $A9, $AF, $A9, $F1, $25, $F1, $7E, $25, $70, $F4, $00, $2E
    .byte $25, $F1, $7E, $25, $F1, $00, $2E, $34, $00, $34, $F6, $00, $2E, $34, $00, $72
    .byte $C5, $FA, $00, $DA, $33, $C5, $4F, $37, $DA, $F9, $00, $72, $37, $91, $91, $4F
    .byte $C5, $F9, $00, $73, $37, $AC, $F1, $AC, $37, $C5, $F8, $00, $72, $91, $37, $91
    .byte $37, $3F, $61, $C5, $DA, $F6, $00, $33, $F1, $AC, $AC, $37, $C5, $81, $24, $C5
    .byte $F6, $00, $F1, $24, $4F, $91, $F1, $37, $F1, $00, $37, $C5, $F4, $00, $DA, $72
    .byte $C5, $6E, $AC, $37, $81, $F1, $00, $3F, $37, $F5, $00, $73, $AC, $91, $AC, $37
    .byte $C5, $F2, $00, $81, $F5, $00, $72, $F1, $AC, $91, $F1, $37, $DA, $F7, $00, $DA
    .byte $33, $4F, $91, $AC, $37, $81, $F9, $00, $3F, $37, $AC, $61, $32, $FB, $00, $67
    .byte $AC, $37, $98, $FB, $00, $8C, $24, $61, $C5, $FD, $00, $AC, $24, $FD, $00, $AC
    .byte $C5, $FD, $00, $61, $24, $FD, $00, $AC, $32, $C5, $FC, $00, $61, $32, $3F, $C5
    .byte $FB, $00, $AC, $98, $73, $24, $FB, $00, $61, $C5, $F1, $00, $73, $F3, $61, $C5
    .byte $F5, $00, $4F, $32, $F2, $00, $3F, $4F, $24, $F1, $81, $F1, $00, $72, $6E, $C5
    .byte $00, $61, $98, $F2, $00, $72, $4F, $F4, $00, $33, $4F, $8F, $C5, $37, $C5, $F2
    .byte $00, $33, $4F, $C5, $00, $72, $C5, $00, $F1, $82, $3F, $AC, $F1, $37, $C5, $33
    .byte $C5, $67, $F1, $37, $C5, $33, $32, $C5, $73, $F1, $6E, $61, $FF, $37, $61, $81
    .byte $F7, $00, $72, $33, $60, $61, $37, $4F, $98, $F5, $00, $72, $33, $61, $60, $4F
    .byte $66, $37, $AC, $81, $F5, $00, $37, $60, $61, $F1, $6E, $66, $37, $AC, $81, $F5
    .byte $00, $C5, $60, $61, $4F, $6E, $66, $37, $4F, $81, $F6, $00, $C5, $61, $6E, $4F
    .byte $66, $37, $4F, $81, $F2, $00, $DD, $F3, $00, $C5, $6E, $4F, $66, $37, $AC, $24
    .byte $D9, $F7, $00, $A7, $4F, $F1, $37, $AC, $6E, $24, $F8, $00, $C5, $F1, $37, $4F
    .byte $91, $6E, $3F, $73, $F7, $00, $C5, $37, $AC, $91, $4F, $6E, $37, $3F, $F5, $00
    .byte $72, $33, $37, $91, $AC, $F1, $91, $F1, $4F, $8C, $DD, $F3, $00, $C5, $32, $37
    .byte $91, $AC, $F1, $91, $F1, $4F, $81, $F3, $00, $DD, $00, $C5, $37, $AC, $91, $AC
    .byte $4F, $37, $24, $F5, $00, $72, $73, $37, $F1, $AC, $4F, $32, $98, $F6, $00, $C5
    .byte $4F, $37, $AC, $4F, $32, $98, $F8, $00, $C5, $37, $AC, $24, $FA, $00, $D1, $37
    .byte $61, $81, $F1, $00, $DD, $F4, $00, $72, $33, $60, $61, $37, $32, $98, $F5, $00
    .byte $72, $33, $61, $60, $4F, $66, $37, $F7, $00, $37, $60, $61, $F1, $6E, $66, $37
    .byte $F5, $00, $DD, $00, $C5, $F1, $61, $4F, $6E, $66, $37, $F1, $00, $DD, $F5, $00
    .byte $C5, $61, $6E, $4F, $66, $37, $F9, $00, $C5, $6E, $4F, $66, $37, $FA, $00, $A7
    .byte $4F, $66, $37, $FB, $00, $C5, $F1, $37, $F4, $00, $DD, $F1, $00, $DD, $F3, $00
    .byte $C5, $37, $FB, $00, $72, $33, $37, $DD, $FA, $00, $C5, $32, $37, $FC, $00, $C5
    .byte $37, $F9, $00, $72, $33, $82, $73, $37, $73, $72, $73, $72, $73, $72, $73, $72
    .byte $73, $72, $F1, $6E, $82, $6E, $37, $F1, $37, $61, $AC, $91, $61, $91, $61, $91
    .byte $F1, $AC, $90, $3F, $6E, $37, $AC, $61, $F1, $91, $61, $AC, $61, $AC, $91, $61
    .byte $91, $F1, $AC, $61, $37, $AC, $37, $81, $F9, $00, $3F, $37, $AC, $91, $F1, $37
    .byte $00, $D7, $F3, $00, $D7, $F2, $00, $33, $4F, $91, $AC, $37, $C5, $F2, $00, $81
    .byte $F5, $00, $72, $F1, $AC, $AC, $37, $81, $F1, $00, $3F, $37, $F5, $00, $73, $AC
    .byte $91, $91, $F1, $37, $F1, $00, $37, $C5, $F5, $00, $72, $C5, $6E, $AC, $37, $C5
    .byte $81, $24, $C5, $F4, $00, $D7, $00, $F1, $24, $4F, $91, $37, $3F, $61, $C5, $F1
    .byte $00, $D7, $F4, $00, $33, $F1, $AC, $F1, $AC, $37, $C5, $F4, $00, $D7, $F2, $00
    .byte $72, $91, $37, $91, $4F, $C5, $F9, $00, $73, $37, $AC, $4F, $37, $F2, $00, $D7
    .byte $F6, $00, $72, $37, $91, $72, $C5, $F8, $00, $D7, $F1, $00, $33, $C5, $F1, $00
    .byte $2E, $34, $F8, $00, $2E, $34, $00, $F1, $25, $F1, $7E, $F1, $25, $00, $D7, $00
    .byte $7C, $25, $2E, $25, $F1, $7E, $25, $A9, $AD, $A9, $AF, $A9, $7E, $71, $F1, $00
    .byte $7B, $7E, $A9, $AF, $A9, $AF, $A9, $AF, $F4, $AD, $89, $F1, $88, $8A, $F2, $AD
    .byte $AF, $F1, $AD, $AE, $89, $F2, $88, $8A, $F9, $AE, $AE, $84, $F2, $88, $86, $F9
    .byte $AE, $32, $F4, $00, $73, $F3, $24, $98, $3F, $24, $3F, $24, $98, $FA, $00, $D2
    .byte $F2, $00, $72, $C5, $FB, $00, $33, $C5, $4F, $37, $FA, $00, $72, $37, $91, $91
    .byte $4F, $C5, $F9, $00, $73, $37, $AC, $F1, $AC, $37, $C5, $D1, $F7, $00, $72, $91
    .byte $37, $91, $37, $81, $24, $37, $C5, $F5, $00, $D2, $33, $F1, $AC, $AC, $37, $C5
    .byte $00, $F1, $24, $C5, $F5, $00, $F1, $24, $4F, $91, $F1, $37, $F2, $00, $24, $D2
    .byte $F4, $00, $72, $C5, $6E, $AC, $37, $81, $F9, $00, $73, $AC, $91, $AC, $37, $C5
    .byte $DA, $F8, $00, $72, $F1, $AC, $91, $F1, $37, $F8, $00, $DA, $33, $4F, $91, $AC
    .byte $37, $81, $DA, $F8, $00, $3F, $37, $AC, $5D, $69, $5B, $4A, $71, $F5, $00, $30
    .byte $F1, $19, $F1, $45, $5B, $F1, $4C, $7E, $70, $F5, $00, $30, $F2, $5E, $45, $4C
    .byte $AF, $F1, $7E, $71, $F5, $00, $2E, $25, $F2, $8B, $F2, $25, $34, $F6, $00, $DA
    .byte $7C, $F1, $25, $8B, $FF, $00, $61, $C5, $FB, $00, $72, $61, $F1, $61, $C5, $D2
    .byte $F9, $00, $73, $37, $61, $32, $37, $C5, $F1, $00, $DA, $F6, $00, $72, $61, $37
    .byte $32, $81, $3F, $C5, $72, $37, $C5, $F5, $00, $73, $37, $37, $32, $C5, $72, $82
    .byte $81, $F1, $82, $F4, $00, $DA, $72, $61, $61, $32, $81, $73, $C5, $DA, $F6, $00
    .byte $72, $6E, $37, $37, $32, $00, $72, $81, $F6, $00, $72, $6E, $81, $61, $37, $32
    .byte $C5, $73, $C5, $F5, $00, $72, $6E, $81, $73, $37, $61, $32, $3F, $C5, $81, $F4
    .byte $00, $72, $6E, $81, $00, $72, $61, $37, $32, $00, $82, $DA, $F4, $00, $33, $81
    .byte $F1, $00, $73, $37, $37, $32, $00, $82, $F5, $00, $33, $81, $F1, $00, $73, $37
    .byte $61, $32, $3F, $C5, $81, $00, $DE, $F2, $00, $72, $6E, $81, $00, $72, $61, $37
    .byte $32, $C5, $73, $C5, $F5, $00, $72, $6E, $81, $73, $37, $37, $32, $00, $72, $81
    .byte $F6, $00, $72, $6E, $81, $61, $61, $32, $81, $73, $C5, $F1, $00, $DE, $F4, $00
    .byte $72, $6E, $37, $37, $32, $C5, $72, $82, $81, $F1, $82, $F5, $00, $72, $61, $37
    .byte $32, $81, $3F, $C5, $72, $37, $C5, $F2, $00, $DE, $F1, $00, $73, $37, $61, $32
    .byte $37, $C5, $F9, $00, $72, $61, $F1, $61, $C5, $FA, $00, $73, $37, $61, $C5, $F5
    .byte $00, $DE, $F4, $00, $72, $61, $FA, $00, $DE, $F3, $00, $F2, $25, $34, $00, $DE
    .byte $F5, $00, $7C, $F1, $25, $8B, $4C, $AF, $F1, $7E, $71, $F5, $00, $2E, $25, $F2
    .byte $8B, $5B, $F1, $4C, $7E, $70, $F5, $00, $30, $F2, $5E, $45, $5D, $69, $5B, $4A
    .byte $71, $F5, $00, $30, $F1, $19, $F1, $45, $7E, $AF, $F1, $7E, $25, $F2, $00, $43
    .byte $7D, $7E, $7D, $F2, $7E, $7E, $A9, $F1, $7E, $25, $F2, $00, $63, $F5, $7E, $AF
    .byte $A9, $7E, $7F, $80, $F3, $00, $63, $F4, $7E, $AF, $A9, $7E, $34, $F5, $00, $63
    .byte $F3, $7E, $F1, $AF, $2F, $2E, $F5, $00, $6D, $AF, $F2, $7E, $AF, $A9, $F1, $2F
    .byte $2E, $F4, $00, $6D, $AF, $F2, $7E, $AF, $A9, $7E, $2F, $7E, $2E, $F3, $00, $6D
    .byte $F3, $7E, $AF, $F2, $7E, $71, $F4, $00, $62, $AF, $F2, $7E, $AF, $7E, $7F, $71
    .byte $F4, $00, $62, $AF, $A9, $F2, $7E, $AF, $A9, $2E, $F4, $00, $43, $AF, $F4, $7E
    .byte $AF, $A9, $2E, $F3, $00, $43, $AF, $F1, $7E, $A9, $F2, $7E, $AF, $A9, $25, $F3
    .byte $00, $63, $AF, $F1, $7E, $A9, $F2, $7E, $AF, $7E, $2E, $F4, $00, $63, $AF, $7E
    .byte $A9, $F2, $7E, $7E, $A9, $25, $F4, $00, $62, $7E, $AF, $F3, $7E, $AF, $A9, $2E
    .byte $F3, $00, $95, $7E, $F1, $7D, $F3, $7E, $F1, $7E, $25, $F2, $00, $62, $F3, $7D
    .byte $F1, $7E, $7D, $7E, $F3, $AE, $84, $F3, $88, $89, $F4, $AE, $89, $84, $89, $84
    .byte $F5, $88, $89, $84, $89, $84, $B1, $FC, $78, $B0, $B1, $FC, $00, $96, $B1, $FB
    .byte $00, $1F, $4E, $B1, $F9, $00, $52, $5C, $18, $9C, $B1, $F8, $00, $D6, $85, $F1
    .byte $4A, $A0, $AE, $F9, $00, $87, $F1, $19, $A4, $AE, $FA, $00, $64, $45, $A5, $AE
    .byte $FB, $00, $64, $A6, $AE, $FC, $00, $89, $AE, $FC, $00, $B0, $B1, $FC, $00, $96
    .byte $B1, $7B, $FA, $00, $1F, $9D, $B1, $7E, $25, $F9, $00, $1D, $9C, $B1, $7D, $7E
    .byte $2E, $F8, $00, $1D, $A1, $B1, $F4, $AD, $AF, $89, $F1, $88, $8A, $A9, $F4, $AD
    .byte $F3, $AD, $A9, $63, $F3, $00, $62, $AF, $F3, $AD, $1D, $1E, $43, $75, $6A, $D1
    .byte $F3, $00, $D1, $62, $AF, $63, $1F, $1D, $F2, $00, $62, $25, $F6, $00, $35, $71
    .byte $F1, $00, $F2, $00, $7C, $31, $F6, $00, $2E, $70, $F1, $00, $F2, $00, $2E, $70
    .byte $F6, $00, $43, $71, $F1, $00, $00, $F1, $25, $63, $F7, $00, $4B, $7E, $71, $00
    .byte $00, $62, $63, $F5, $00, $D5, $F2, $00, $43, $70, $00, $F3, $00, $D5, $FA, $00
    .byte $F6, $00, $73, $24, $F5, $00, $D5, $F5, $00, $3F, $37, $C5, $F6, $00, $F4, $00
    .byte $3F, $4F, $24, $82, $00, $D9, $F4, $00, $81, $F1, $24, $81, $3F, $F2, $4F, $32
    .byte $24, $82, $81, $82, $81, $82, $81, $91, $AC, $91, $F1, $AC, $91, $AC, $91, $F1
    .byte $AC, $91, $F1, $AC, $91, $AC, $91, $91, $AC, $F1, $91, $AC, $F1, $91, $AC, $F1
    .byte $91, $AC, $F1, $91, $AC, $F1, $91, $F1, $A9, $F2, $AD, $A9, $84, $F1, $88, $86
    .byte $A9, $F1, $AD, $7E, $F1, $AD, $F1, $AF, $F3, $A9, $89, $F1, $B0, $8A, $AD, $F2
    .byte $AF, $F1, $7E, $F1, $42, $F2, $7E, $31, $F3, $00, $43, $7E, $A9, $7D, $7E, $A9
    .byte $F1, $00, $43, $F1, $7E, $70, $F3, $00, $95, $7E, $F2, $A9, $7E, $F2, $00, $43
    .byte $63, $F5, $00, $42, $F1, $7E, $7D, $7E, $FB, $00, $62, $63, $62, $63, $FF, $00
    .byte $EF, $EF, $EF, $FD, $00, $2E, $25, $FB, $00, $25, $2E, $AF, $7E, $25, $34, $F8
    .byte $00, $25, $F2, $7E, $A9, $AF, $F1, $25, $34, $2E, $F1, $25, $34, $2E, $25, $2E
    .byte $7E, $F2, $A9, $7E, $7E, $AF, $F8, $7E, $F2, $A9, $7E, $A9, $8D, $F1, $5D, $4A
    .byte $25, $00, $D7, $F2, $00, $7B, $7D, $F2, $45, $01, $13, $8D, $5D, $69, $4C, $71
    .byte $F2, $00, $D7, $7B, $0B, $F1, $45, $13, $14, $F1, $00, $17, $5D, $0A, $70, $F3
    .byte $00, $2E, $0B, $01, $64, $F1, $00, $F2, $00, $17, $18, $71, $F3, $00, $62, $0B
    .byte $64, $F2, $00, $F3, $00, $8E, $70, $F3, $00, $7B, $1E, $F3, $00, $FF, $00, $EF
    .byte $EF, $EF, $EF, $EF, $EF, $EF, $EF, $EF, $F1, $A9, $25, $F2, $00, $63, $AF, $7E
    .byte $A9, $7E, $A9, $F2, $7E, $F1, $AF, $2E, $F2, $00, $62, $AF, $F1, $7E, $F3, $AF
    .byte $7E, $7E, $AF, $25, $F2, $00, $63, $25, $70, $71, $70, $71, $70, $71, $70, $AF
    .byte $7E, $25, $F3, $00, $63, $2E, $76, $2E, $F3, $00, $AF, $7E, $25, $00, $D5, $F2
    .byte $00, $70, $71, $63, $2E, $43, $2E, $00, $AF, $7E, $71, $F7, $00, $70, $71, $70
    .byte $2E, $AF, $7E, $2E, $F9, $00, $35, $34, $AF, $F1, $7E, $2E, $4B, $7C, $4B, $7C
    .byte $F6, $00, $AF, $7E, $71, $70, $71, $70, $71, $F7, $00, $AF, $7E, $2E, $F5, $00
    .byte $D5, $F4, $00, $AF, $F1, $7E, $2E, $FA, $00, $7E, $F1, $A9, $7E, $34, $F8, $00
    .byte $42, $AF, $F1, $A9, $7E, $2E, $F6, $00, $D1, $43, $7E, $F1, $7E, $F1, $A9, $7E
    .byte $2E, $F5, $00, $76, $F1, $7E, $AF, $F1, $A9, $7E, $A9, $25, $F5, $00, $77, $F1
    .byte $7E, $AF, $F1, $A9, $F1, $7E, $25, $F2, $00, $D5, $F1, $00, $35, $7E, $7D, $5D
    .byte $69, $4C, $25, $70, $F3, $00, $2E, $0B, $0C, $F2, $0D, $C7, $5B, $4C, $5E, $70
    .byte $34, $F4, $00, $2E, $8B, $F1, $0C, $01, $C7, $4C, $AF, $7E, $71, $F6, $00, $2E
    .byte $25, $F1, $8B, $C7, $F2, $25, $F8, $00, $7C, $F1, $25, $C7, $FF, $00, $37, $C5
    .byte $FD, $00, $F1, $AC, $C5, $FC, $00, $AC, $37, $32, $C5, $FB, $00, $91, $AC, $F1
    .byte $24, $C5, $FA, $00, $F1, $AC, $C5, $00, $81, $FA, $00, $91, $AC, $37, $C5, $72
    .byte $C5, $F2, $00, $72, $C5, $72, $C5, $F2, $00, $AC, $37, $24, $82, $67, $6E, $C5
    .byte $F1, $00, $33, $F2, $37, $C5, $00, $C7, $AC, $4F, $C5, $33, $F2, $61, $C5, $72
    .byte $F2, $4F, $F1, $61, $C5, $C7, $37, $4F, $37, $F1, $4F, $37, $F1, $4F, $37, $F1
    .byte $4F, $37, $F1, $4F, $61, $37, $FD, $37, $61, $37, $F4, $C7, $F4, $00, $F2, $C7
    .byte $F1, $37, $F3, $C7, $F5, $00, $F2, $C7, $4F, $37, $FA, $00, $F1, $C7, $F1, $37
    .byte $FA, $00, $F1, $C7, $4F, $37, $FA, $00, $F1, $C7, $61, $37, $EF, $FA, $00, $CA
    .byte $60, $61, $37, $F9, $00, $C7, $CB, $F1, $61, $37, $F9, $00, $F1, $C7, $CA, $F1
    .byte $37, $F9, $00, $C7, $CA, $CB, $61, $37, $F9, $00, $C7, $CB, $CA, $4F, $37, $FA
    .byte $00, $C7, $CB, $F1, $37, $FA, $00, $C7, $CA, $61, $37, $FA, $00, $C7, $CB, $61
    .byte $37, $CA, $C7, $CA, $C7, $CA, $C7, $CA, $C7, $CA, $C7, $CA, $C7, $CA, $F1, $61
    .byte $CB, $C7, $CB, $C7, $CB, $C7, $CB, $C7, $CB, $C7, $CB, $C7, $CB, $F1, $61, $F2
    .byte $C7, $F9, $00, $F2, $C7, $F1, $C7, $CA, $CB, $F7, $00, $CA, $CB, $F1, $C7, $CA
    .byte $CB, $D1, $F9, $00, $D1, $CA, $CB, $F1, $C7, $FB, $00, $F1, $C7, $CA, $CB, $FB
    .byte $00, $CA, $CB, $F1, $C7, $FB, $00, $F1, $C7, $CA, $CB, $DA, $FA, $00, $CA, $CB
    .byte $F1, $C7, $FB, $00, $F1, $C7, $CA, $CB, $FB, $00, $CA, $CB, $F1, $C7, $FA, $00
    .byte $DA, $F1, $C7, $CA, $CB, $FB, $00, $CA, $CB, $F1, $C7, $DA, $FA, $00, $F1, $C7
    .byte $CA, $CB, $FB, $00, $CA, $CB, $F1, $C7, $FB, $00, $F1, $C7, $CA, $CB, $FA, $00
    .byte $DA, $CA, $CB, $F2, $C7, $F9, $00, $F2, $C7, $AC, $C7, $CA, $CB, $F7, $00, $CA
    .byte $CB, $C7, $AC, $AC, $C7, $DB, $F8, $00, $DA, $00, $C7, $AC, $AC, $C7, $FB, $00
    .byte $C7, $AC, $EF, $EF, $AC, $C7, $FA, $00, $DA, $C7, $AC, $AC, $C7, $FB, $00, $C7
    .byte $AC, $AC, $C7, $DA, $FA, $00, $C7, $AC, $AC, $C7, $FB, $00, $C7, $AC, $AC, $F3
    .byte $C7, $DA, $F7, $00, $C7, $AC, $AC, $F3, $C7, $F8, $00, $C7, $AC, $AC, $C7, $FA
    .byte $00, $DA, $C7, $AC, $AC, $C7, $FB, $00, $C7, $AC, $AC, $C7, $DA, $FA, $00, $C7
    .byte $AC, $CA, $CB, $C7, $CA, $CB, $F5, $00, $CA, $CB, $C7, $CA, $CB, $F1, $C7, $CA
    .byte $CB, $CA, $CB, $F3, $00, $CA, $CB, $CA, $CB, $F1, $C7, $CA, $CB, $50, $C7, $D1
    .byte $F5, $00, $D1, $C7, $50, $CA, $CB, $F1, $C7, $CA, $CB, $F7, $00, $CA, $CB, $F1
    .byte $C7, $CA, $CB, $50, $C7, $F7, $00, $C7, $50, $CA, $CB, $F1, $C7, $CA, $CB, $F6
    .byte $00, $DA, $CA, $CB, $F1, $C7, $CA, $CB, $50, $C7, $F7, $00, $C7, $50, $CA, $CB
    .byte $F1, $C7, $CA, $CB, $DA, $F6, $00, $CA, $CB, $F1, $C7, $CA, $CB, $50, $C7, $F6
    .byte $00, $D2, $C7, $50, $CA, $CB, $C7, $CA, $CB, $C7, $F7, $00, $C7, $CA, $CB, $C7
    .byte $CA, $CB, $50, $DB, $F7, $00, $DB, $B2, $CA, $CB, $C7, $CA, $CB, $C7, $DA, $F5
    .byte $00, $DA, $C7, $CA, $CB, $C7, $CA, $CB, $50, $DB, $F7, $00, $DB, $B2, $CA, $CB
    .byte $C7, $CA, $CB, $C7, $F7, $00, $C7, $CA, $CB, $C7, $CA, $CB, $50, $C7, $D2, $F6
    .byte $00, $C7, $50, $CA, $CB, $F1, $C7, $50, $C7, $F7, $00, $C7, $50, $C7, $37, $F1
    .byte $C7, $CA, $CB, $F7, $00, $F2, $C7, $37, $CA, $CB, $C4, $C7, $F1, $00, $DD, $F5
    .byte $00, $D1, $F1, $00, $F1, $C7, $C4, $C7, $FB, $00, $CA, $CB, $50, $C7, $FB, $00
    .byte $F1, $C7, $CA, $CB, $F5, $00, $DD, $F4, $00, $CA, $CB, $C4, $C7, $FB, $00, $F1
    .byte $B2, $50, $D1, $FB, $00, $CA, $CB, $C7, $FC, $00, $F3, $C7, $C4, $F1, $00, $DD
    .byte $F7, $00, $CA, $CB, $F1, $C7, $C4, $FA, $00, $F3, $C7, $C4, $FA, $00, $CA, $CB
    .byte $CA, $CB, $50, $F9, $B2, $00, $F2, $C7, $CA, $CB, $CA, $CB, $CA, $CB, $CA, $CB
    .byte $CA, $CB, $CA, $50, $B2, $CA, $CB, $CA, $CB, $CA, $CB, $CA, $CB, $CA, $CB, $CA
    .byte $CB, $CA, $CB, $F1, $C9, $C9, $B2, $F1, $00, $D0, $F1, $00, $C9, $B2, $F3, $00
    .byte $F1, $37, $C9, $B2, $F4, $00, $C9, $B2, $F3, $00, $CA, $CB, $C9, $50, $00, $DD
    .byte $F2, $00, $C9, $B2, $F3, $00, $CB, $CA, $C9, $B2, $F4, $00, $C9, $B2, $F3, $00
    .byte $CA, $CB, $C9, $B2, $F3, $00, $D1, $C9, $B2, $F3, $00, $CB, $CA, $C9, $B2, $F4
    .byte $00, $C9, $B2, $F3, $00, $CA, $CB, $F3, $00, $DD, $F1, $00, $C9, $B2, $F3, $00
    .byte $CB, $CA, $F6, $00, $C9, $B2, $F3, $00, $CA, $CB, $F6, $00, $C9, $50, $F3, $00
    .byte $CB, $CA, $F6, $00, $C9, $B2, $F3, $00, $CA, $CB, $F6, $00, $C9, $B2, $F3, $00
    .byte $CB, $CA, $C9, $B2, $F4, $00, $C9, $B2, $F3, $00, $CA, $CB, $C9, $B2, $00, $DD
    .byte $F2, $00, $C9, $B2, $F3, $00, $CB, $CA, $C9, $B2, $F3, $00, $D1, $C9, $B2, $F3
    .byte $00, $CA, $CB, $C9, $B2, $F4, $00, $C9, $B2, $F3, $00, $CB, $CA, $C9, $B2, $F3
    .byte $00, $D1, $C9, $B2, $F3, $00, $F1, $37, $C9, $F1, $B2, $F8, $00, $C7, $F1, $37
    .byte $C9, $F1, $B2, $F2, $00, $D0, $F3, $00, $F1, $C7, $37, $C7, $F1, $C7, $B2, $D9
    .byte $F6, $00, $C7, $B2, $37, $C7, $F1, $C7, $B2, $F6, $00, $D1, $C7, $B2, $37, $C7
    .byte $F1, $C7, $B2, $F7, $00, $C7, $B2, $37, $C7, $F1, $C7, $B2, $D9, $F3, $00, $D0
    .byte $F1, $00, $C7, $B2, $37, $C7, $F1, $C7, $B2, $F3, $C7, $F3, $00, $C7, $B2, $37
    .byte $C7, $F1, $C7, $B2, $F2, $C7, $F4, $00, $C7, $B2, $37, $C7, $F1, $C7, $B2, $D9
    .byte $F2, $00, $D0, $F2, $00, $C7, $B2, $37, $C7, $F1, $C7, $B2, $F7, $00, $C7, $B2
    .byte $37, $C7, $EF, $F1, $C7, $B2, $D9, $00, $DD, $F3, $00, $D1, $C7, $B2, $37, $C7
    .byte $F1, $C7, $B2, $F7, $00, $C7, $B2, $37, $C7, $F1, $C7, $B2, $C7, $F3, $00, $F3
    .byte $C7, $B2, $37, $C7, $C7, $CB, $B2, $C7, $F2, $00, $F4, $C7, $B2, $37, $C7, $C9
    .byte $F1, $B2, $F1, $C7, $D0, $F1, $00, $F3, $C7, $B2, $37, $C7, $CB, $CA, $CB, $CA
    .byte $CB, $CA, $CB, $F2, $00, $C7, $CA, $CB, $CA, $CB, $37, $37, $CA, $CB, $F1, $C7
    .byte $F6, $00, $D1, $CA, $CB, $37, $37, $CA, $CB, $F1, $C7, $F1, $00, $DE, $F4, $00
    .byte $CA, $CB, $37, $37, $CA, $CB, $F1, $C7, $F7, $00, $CA, $CB, $37, $F1, $37, $F1
    .byte $C7, $F8, $00, $C7, $50, $37, $EF, $F1, $37, $F1, $C7, $F4, $00, $DE, $F2, $00
    .byte $C7, $50, $37, $37, $CA, $CB, $C7, $F7, $00, $C7, $CA, $CB, $37, $37, $CA, $CB
    .byte $C4, $00, $DE, $F4, $00, $C7, $C4, $C9, $F1, $37, $37, $CA, $CB, $C4, $F6, $00
    .byte $C7, $C4, $C9, $F1, $37, $EF, $37, $CA, $CB, $50, $F2, $00, $DE, $F2, $00, $CA
    .byte $50, $CA, $CB, $37, $F1, $37, $CA, $CB, $50, $F5, $00, $C7, $CA, $CB, $F1, $37
    .byte $37, $CA, $CB, $CA, $CB, $50, $F5, $00, $C7, $CA, $CB, $37, $F1, $37, $CA, $CB
    .byte $CA, $CB, $F2, $00, $DE, $F1, $00, $CA, $CB, $F1, $37, $37, $CA, $CB, $CA, $CB
    .byte $F6, $00, $CA, $CB, $F1, $37, $37, $CA, $CB, $F2, $C7, $F6, $00, $CA, $CB, $37
    .byte $F1, $37, $CA, $CB, $CA, $CB, $F7, $00, $F1, $C9, $37, $CA, $CB, $CA, $CB, $D1
    .byte $F7, $00, $F1, $C9, $F1, $37, $CA, $CB, $D1, $F7, $00, $C7, $50, $C4, $37, $CA
    .byte $CB, $F9, $00, $CA, $CB, $C9, $37, $F1, $C9, $F9, $00, $D1, $F1, $C9, $37, $F1
    .byte $C9, $FA, $00, $F1, $C9, $37, $C9, $D1, $F1, $00, $DD, $00, $C9, $C4, $F4, $00
    .byte $C9, $37, $37, $C9, $F4, $00, $C9, $C4, $F4, $00, $C9, $37, $EF, $EF, $37, $C9
    .byte $00, $DD, $F2, $00, $C9, $C4, $F4, $00, $C9, $37, $37, $C9, $F4, $00, $C9, $C4
    .byte $F4, $00, $C9, $37, $EF, $37, $CA, $F1, $CB, $F2, $00, $C9, $C4, $F2, $00, $CA
    .byte $CB, $F1, $37, $37, $CA, $CB, $C7, $F2, $00, $C9, $C4, $F2, $00, $D1, $CA, $CB
    .byte $37, $F1, $37, $CA, $CB, $F2, $00, $C9, $C4, $F6, $00, $37, $CA, $F1, $CB, $00
    .byte $DE, $00, $C9, $C4, $F6, $00, $F1, $37, $CB, $D1, $F2, $00, $C9, $C4, $DA, $F5
    .byte $00, $37, $CA, $CB, $F3, $00, $C9, $C4, $F6, $00, $F1, $37, $C9, $F3, $00, $C9
    .byte $50, $F6, $B2, $37, $F1, $C9, $F1, $00, $DE, $00, $F8, $C9, $37, $C9, $D1, $F8
    .byte $00, $D1, $F2, $00, $37, $C9, $FD, $00, $EF, $EF, $EF, $37, $C9, $50, $FC, $B2
    .byte $37, $FE, $C9, $F5, $C9, $F4, $00, $F4, $C9, $F1, $B2, $50, $F2, $B2, $F4, $00
    .byte $F4, $B2, $FD, $00, $D9, $00, $FF, $00, $EF, $EF, $F1, $00, $D1, $F9, $00, $D1
    .byte $00, $D1, $FF, $C9, $F7, $B2, $50, $F6, $B2, $FF, $00, $EF, $EF, $EF, $37, $CA
    .byte $CB, $CA, $CB, $CA, $CB, $CA, $CB, $CA, $CB, $CA, $CB, $CA, $CB, $37, $37, $CB
    .byte $CA, $CB, $CA, $CB, $CA, $CB, $CA, $CB, $CA, $CB, $CA, $CB, $CA, $37, $C9, $B2
    .byte $F4, $00, $C9, $B2, $F1, $00, $D0, $00, $F1, $37, $C9, $B2, $F1, $00, $D0, $F1
    .byte $00, $C9, $B2, $F3, $00, $F1, $CA, $F6, $00, $C9, $B2, $F3, $00, $F1, $CB, $F6
    .byte $00, $C9, $B2, $F3, $00, $CA, $CB, $F6, $00, $C9, $B2, $F3, $00, $CB, $CA, $D9
    .byte $F5, $00, $C9, $B2, $00, $D0, $F1, $00, $CA, $CB, $F7, $C9, $B2, $F3, $00, $CB
    .byte $CA, $C9, $50, $F5, $C4, $B2, $F3, $00, $CA, $CB, $D9, $FB, $00, $CB, $CA, $FB
    .byte $00, $D0, $CA, $CB, $FC, $00, $CB, $CA, $F5, $00, $D9, $F5, $00, $CA, $CB, $CA
    .byte $B2, $CA, $B2, $CA, $B2, $CA, $B2, $CA, $B2, $CA, $B2, $CA, $CB, $CA, $CB, $B2
    .byte $CB, $B2, $CB, $B2, $CB, $B2, $CB, $B2, $CB, $CA, $CB, $CA, $CB, $FA, $7B, $CB
    .byte $37, $CB, $37, $FD, $7D, $37, $7E, $F1, $C9, $F8, $00, $CA, $CB, $C7, $7D, $7E
    .byte $F1, $C9, $F8, $00, $F1, $B2, $CA, $CB, $7E, $C9, $D1, $F8, $00, $CA, $CB, $C7
    .byte $7D, $7E, $C9, $F8, $00, $D9, $F1, $B2, $CA, $CB, $7E, $C9, $F9, $00, $CA, $CB
    .byte $C7, $7D, $7E, $C9, $F2, $00, $DD, $F5, $00, $F1, $B2, $CA, $CB, $7E, $C9, $F8
    .byte $00, $D9, $CA, $CB, $C7, $7D, $7E, $C9, $F9, $00, $F1, $B2, $CA, $CB, $7E, $C9
    .byte $00, $DD, $F7, $00, $CA, $F1, $CB, $7D, $7E, $C9, $F8, $00, $D9, $F1, $B2, $CA
    .byte $CB, $7E, $C9, $F9, $00, $CA, $CB, $C7, $7E, $7E, $C9, $F3, $00, $DD, $F3, $00
    .byte $CA, $CB, $C7, $CA, $CB, $7E, $C9, $00, $DD, $F5, $00, $CA, $CB, $CA, $CB, $C7
    .byte $7E, $7E, $C9, $F5, $00, $C7, $CA, $CB, $CA, $CB, $C7, $CA, $CB, $7E, $C9, $F5
    .byte $00, $CA, $CB, $CA, $CB, $CA, $CB, $C7, $7E, $7E, $C9, $F4, $00, $CA, $CB, $CA
    .byte $CB, $CA, $CB, $CA, $CB, $7D, $7E, $C9, $F5, $00, $CA, $CB, $D1, $00, $CA, $F1
    .byte $CB, $7D, $7E, $C9, $F9, $00, $CA, $CB, $C7, $7D, $7E, $C9, $00, $DD, $F7, $00
    .byte $F1, $B2, $CA, $CB, $7E, $C9, $F8, $00, $D9, $CA, $CB, $C7, $7D, $7E, $C9, $F9
    .byte $00, $F1, $B2, $CA, $CB, $7E, $C9, $F5, $00, $DD, $F2, $00, $CA, $CB, $C7, $7D
    .byte $7E, $C9, $F9, $00, $F1, $B2, $CA, $CB, $7E, $C9, $C4, $F8, $00, $CA, $CB, $C7
    .byte $7D, $7E, $7F, $50, $C4, $F7, $00, $C7, $7B, $7D, $7E, $7E, $7F, $C9, $C4, $D9
    .byte $F1, $00, $DD, $F3, $00, $CA, $CB, $7D, $7E, $F1, $7E, $7F, $50, $B2, $F7, $00
    .byte $C7, $7D, $7E, $F1, $7E, $7F, $C9, $50, $B2, $F6, $00, $C7, $7D, $7E, $F1, $7E
    .byte $7F, $F2, $C9, $50, $F5, $00, $C7, $7D, $7E, $F1, $7E, $7F, $F3, $C9, $50, $F1
    .byte $00, $DD, $F1, $00, $C7, $7D, $7E, $F1, $7E, $7F, $F3, $C9, $C4, $F4, $00, $C7
    .byte $F1, $7D, $F1, $7E, $7F, $F3, $C9, $C4, $F3, $00, $D2, $C7, $F1, $7D, $7E, $7F
    .byte $C4, $F1, $C9, $D1, $F6, $00, $C7, $F1, $7D, $7E, $7F, $C4, $C9, $F8, $00, $C7
    .byte $F1, $7D, $7E, $7F, $C4, $F8, $00, $CA, $CB, $7D, $7E, $7E, $7F, $C4, $D2, $F7
    .byte $00, $DB, $CB, $7D, $7E, $7E, $7F, $C4, $F9, $00, $CB, $7D, $7E, $EF, $7E, $7F
    .byte $C4, $D2, $F2, $00, $DD, $F4, $00, $CB, $7D, $7E, $7E, $7F, $50, $C4, $F8, $00
    .byte $CB, $7D, $7E, $7E, $7F, $50, $C4, $F7, $00, $CA, $CB, $7D, $7E, $F1, $7E, $7F
    .byte $50, $C4, $D2, $F6, $00, $C7, $7D, $7E, $F1, $7E, $7F, $50, $C4, $F7, $00, $C7
    .byte $7D, $7E, $F1, $7E, $7F, $50, $C4, $F6, $00, $D2, $C7, $7D, $7E, $F1, $7E, $7F
    .byte $50, $C4, $F7, $00, $C7, $7D, $7E, $F1, $7E, $7F, $C9, $F8, $00, $C7, $F1, $7D
    .byte $EF, $7E, $7F, $F1, $C4, $D9, $F7, $00, $F1, $C7, $7E, $7E, $7F, $F1, $C4, $FB
    .byte $00, $7E, $7F, $F1, $C4, $D9, $F3, $00, $DD, $F5, $00, $7E, $7F, $F1, $C4, $FB
    .byte $00, $EF, $7E, $7F, $F1, $C4, $D9, $F6, $00, $DD, $F2, $00, $7E, $7F, $F1, $C4
    .byte $FB, $00, $7E, $7F, $50, $C4, $FB, $00, $EF, $F1, $7E, $7F, $50, $F8, $B2, $C7
    .byte $7D, $7F, $FF, $7E, $EF, $EF, $F2, $7E, $7D, $00, $D0, $F5, $00, $F2, $7E, $F1
    .byte $7E, $F1, $A9, $F7, $00, $7F, $F1, $7E, $F1, $7E, $25, $C4, $F7, $00, $C9, $7F
    .byte $7E, $F1, $7E, $B2, $C9, $D9, $F6, $00, $F1, $C9, $7E, $F1, $7E, $B2, $C9, $F2
    .byte $00, $D0, $F2, $00, $F1, $C9, $F1, $7E, $F1, $7E, $B2, $C9, $F6, $00, $C9, $F2
    .byte $7E, $EF, $F1, $7E, $B2, $C9, $D9, $F2, $00, $D0, $F1, $00, $D1, $F2, $7E, $F1
    .byte $7E, $B2, $C9, $F6, $00, $C9, $F2, $7E, $EF, $EF, $F1, $7E, $B2, $C9, $D9, $00
    .byte $D0, $F3, $00, $F1, $C9, $F1, $7E, $F1, $7E, $B2, $C9, $F6, $00, $D1, $C9, $F1
    .byte $7E, $F1, $7E, $F1, $25, $F5, $00, $F1, $7B, $F1, $C9, $7E, $F3, $7E, $F1, $7D
    .byte $25, $F1, $00, $6A, $F1, $2F, $7E, $7D, $7E, $F2, $7E, $7F, $70, $71, $F3, $00
    .byte $70, $71, $7E, $F1, $7D, $F4, $7E, $F3, $00, $7B, $F4, $7E, $7D, $F1, $7E, $F1
    .byte $C8, $7E, $F3, $00, $7B, $F2, $7E, $C8, $F1, $7D, $7E, $F3, $C8, $F3, $00, $7B
    .byte $C8, $5F, $F2, $C8, $7E, $F2, $00, $D1, $5F, $F4, $00, $5F, $3C, $00, $7B, $2F
    .byte $71, $F3, $00, $3C, $F4, $00, $3C, $D1, $00, $7B, $2F, $70, $FD, $00, $6A, $00
    .byte $FF, $00, $EF, $FD, $00, $25, $00, $FD, $00, $7D, $71, $F3, $00, $25, $D9, $25
    .byte $F1, $00, $25, $D9, $25, $F1, $00, $7D, $70, $7D, $A9, $F1, $C8, $25, $C8, $25
    .byte $F1, $C8, $25, $C8, $25, $C8, $25, $7E, $7F, $7E, $A9, $25, $F9, $C8, $25, $F1
    .byte $7E, $FF, $7E, $EF, $F2, $7E, $F8, $00, $F2, $7E, $F1, $7E, $C8, $F8, $00, $C8
    .byte $F1, $7E, $7E, $F2, $C8, $F6, $00, $F2, $C8, $7E, $7E, $C8, $92, $F8, $00, $92
    .byte $C8, $7E, $7E, $C8, $92, $F6, $00, $F1, $C8, $92, $C8, $7E, $7E, $C8, $92, $F3
    .byte $00, $3C, $5F, $3C, $5F, $C8, $92, $C8, $7E, $7E, $C8, $92, $F8, $00, $92, $C8
    .byte $7E, $EF, $EF, $EF, $EF, $EF, $EF, $7E, $C8, $3C, $5F, $F6, $00, $3C, $5F, $C8
    .byte $7E, $F1, $7E, $3C, $5F, $3C, $5F, $F2, $00, $3C, $5F, $3C, $5F, $7D, $7E, $F1
    .byte $7E, $F3, $92, $F2, $00, $F3, $92, $F1, $7D, $F5, $92, $F3, $00, $F4, $92, $F4
    .byte $92, $F4, $00, $F4, $92, $EF, $F3, $92, $F5, $00, $F4, $92, $F3, $92, $F4, $00
    .byte $F5, $92, $F2, $92, $F5, $00, $F5, $92, $F2, $92, $F4, $00, $F6, $92, $F1, $92
    .byte $F5, $00, $F6, $92, $F1, $92, $F4, $00, $F7, $92, $92, $F5, $00, $F7, $92, $92
    .byte $F4, $00, $F8, $92, $EF, $92, $00, $CE, $CC, $57, $F9, $92, $92, $00, $CF, $CD
    .byte $57, $F9, $92, $92, $F1, $00, $C6, $57, $F9, $92, $FE, $92, $7E, $AF, $F1, $7E
    .byte $25, $00, $D5, $F1, $00, $76, $F2, $7E, $AF, $A9, $AF, $F1, $7E, $2F, $34, $F3
    .byte $00, $77, $F2, $7E, $AF, $A9, $71, $70, $71, $70, $34, $F4, $00, $77, $F1, $7E
    .byte $A9, $AD, $F2, $67, $6F, $F5, $00, $D1, $70, $71, $70, $71, $AC, $4F, $6E, $6F
    .byte $F1, $00, $D5, $F2, $00, $72, $33, $3F, $73, $72, $91, $4F, $24, $F4, $00, $72
    .byte $33, $F1, $4F, $F2, $37, $91, $37, $81, $00, $D5, $F2, $00, $F2, $6E, $F1, $37
    .byte $4F, $37, $AC, $24, $F5, $00, $C5, $F1, $6E, $37, $4F, $F1, $37, $91, $24, $D9
    .byte $F5, $00, $C5, $6E, $4F, $F2, $37, $91, $24, $D9, $F5, $00, $33, $F1, $4F, $F2
    .byte $37, $AC, $4F, $3F, $F1, $00, $D5, $F2, $00, $C5, $4F, $37, $4F, $37, $4F, $91
    .byte $F1, $4F, $81, $F5, $00, $C5, $4F, $37, $4F, $37, $F1, $91, $4F, $81, $F5, $00
    .byte $D1, $C5, $F1, $4F, $37, $AC, $91, $4F, $24, $F5, $00, $72, $33, $4F, $F1, $37
    .byte $F2, $91, $4F, $24, $F1, $00, $D5, $00, $72, $F1, $4F, $F2, $37, $AC, $F1, $91
    .byte $4F, $24, $F3, $00, $C5, $4F, $F3, $37, $37, $AC, $91, $4F, $24, $F1, $00, $D5
    .byte $00, $33, $4F, $F1, $37, $4F, $37, $F1, $37, $AC, $4F, $6E, $81, $F2, $00, $C5
    .byte $F1, $4F, $F2, $37, $F2, $37, $4F, $32, $98, $F3, $00, $C5, $37, $4F, $37, $4F
    .byte $F3, $32, $98, $F4, $00, $D1, $C5, $4F, $F1, $37, $F5, $00, $D5, $F2, $00, $72
    .byte $33, $F1, $37, $4F, $F8, $00, $33, $F1, $4F, $F2, $37, $F7, $00, $33, $F1, $6E
    .byte $F1, $37, $4F, $37, $F4, $00, $D5, $F1, $00, $C5, $F1, $6E, $37, $4F, $F1, $37
    .byte $72, $73, $F5, $00, $D1, $C5, $6E, $4F, $F2, $37, $37, $4F, $82, $F5, $00, $33
    .byte $F1, $4F, $F2, $37, $37, $4F, $3F, $F3, $00, $D5, $00, $C5, $4F, $37, $4F, $37
    .byte $4F, $37, $F1, $4F, $81, $F5, $00, $C5, $4F, $37, $4F, $37, $37, $AC, $4F, $81
    .byte $F5, $00, $D1, $C5, $F1, $4F, $37, $37, $AC, $4F, $24, $F2, $00, $D5, $F1, $00
    .byte $72, $33, $4F, $F1, $37, $37, $AC, $91, $4F, $24, $F3, $00, $72, $F1, $4F, $F2
    .byte $37, $AC, $F1, $91, $4F, $24, $F3, $00, $C5, $4F, $F3, $37, $91, $AC, $91, $4F
    .byte $24, $F3, $00, $33, $4F, $F1, $37, $4F, $37, $AC, $91, $AC, $4F, $6E, $81, $F2
    .byte $00, $C5, $F1, $4F, $F2, $37, $91, $F1, $AC, $4F, $32, $98, $00, $D5, $F1, $00
    .byte $C5, $37, $4F, $37, $4F, $F1, $91, $4F, $32, $98, $F5, $00, $C5, $4F, $F1, $37
    .byte $AC, $4F, $24, $F6, $00, $72, $33, $F1, $37, $4F, $91, $4F, $24, $F5, $00, $33
    .byte $F1, $4F, $F2, $37, $91, $4F, $81, $F2, $00, $DB, $00, $33, $F1, $6E, $F1, $37
    .byte $4F, $37, $AC, $91, $81, $F4, $00, $C5, $F1, $6E, $37, $4F, $F1, $37, $AC, $4F
    .byte $82, $F5, $00, $37, $6E, $4F, $F2, $37, $91, $4F, $82, $F5, $00, $C5, $F1, $4F
    .byte $F2, $37, $AC, $37, $24, $F6, $00, $C5, $37, $4F, $37, $4F, $32, $98, $D9, $F1
    .byte $00, $D5, $F1, $00, $DB, $F1, $00, $C5, $37, $4F, $37, $F1, $7D, $2E, $F8, $00
    .byte $C5, $4F, $37, $7D, $F1, $AF, $2E, $F7, $00, $D1, $C5, $32, $F1, $AF, $7E, $71
    .byte $F8, $00, $35, $7E, $7E, $AF, $25, $F3, $00, $D5, $F3, $00, $41, $AF, $A9, $CB
    .byte $CA, $CB, $CA, $CB, $CA, $F4, $00, $CA, $CB, $CA, $CB, $CA, $F1, $C7, $F3, $37
    .byte $F4, $00, $F2, $37, $F1, $C7, $F1, $C9, $C4, $DA, $F9, $00, $D2, $C9, $F1, $C9
    .byte $C4, $FB, $00, $C9, $EF, $F1, $C9, $C4, $50, $F3, $B2, $F5, $00, $D2, $C9, $F1
    .byte $C9, $C4, $F4, $C9, $F6, $00, $C9, $F1, $C9, $C4, $D1, $F1, $00, $D1, $F6, $00
    .byte $D2, $C9, $F1, $C9, $C4, $FB, $00, $C9, $EF, $EF, $F1, $C9, $C4, $FA, $00, $D2
    .byte $C9, $F1, $C9, $50, $B2, $F1, $00, $F7, $B2, $00, $C9, $F2, $C9, $C7, $F1, $00
    .byte $C7, $F8, $C9, $EF, $F2, $C9, $C7, $F1, $00, $C7, $F8, $C9, $EF, $F1, $C9, $C4
    .byte $F4, $00, $C9, $F4, $00, $F1, $C9, $EF, $EF, $F1, $C9, $C4, $F2, $00, $F1, $B2
    .byte $C9, $F1, $B2, $F2, $00, $F1, $C9, $F1, $C9, $C4, $F2, $00, $F4, $C9, $F2, $00
    .byte $F1, $C9, $F1, $C9, $C4, $FB, $00, $C9, $EF, $EF, $EF, $EF, $F1, $C9, $50, $FB
    .byte $B2, $C9, $FF, $C9, $EF, $F4, $7E, $80, $F3, $00, $7B, $F3, $7E, $7D, $F1, $7E
    .byte $7F, $C9, $7E, $80, $F3, $00, $7B, $F1, $7E, $C9, $F1, $7D, $F1, $7E, $F1, $C9
    .byte $C8, $80, $F3, $00, $7B, $C8, $F1, $C9, $F1, $7E, $F2, $00, $D1, $C9, $F5, $00
    .byte $C9, $D1, $7B, $2F, $71, $FC, $00, $7B, $2F, $70, $FD, $00, $6A, $00, $F6, $00
    .byte $D5, $F7, $00, $F1, $00, $D5, $FC, $00, $FA, $00, $D5, $F1, $00, $25, $00, $FD
    .byte $00, $7D, $71, $F3, $00, $D9, $F4, $00, $D9, $F2, $00, $7D, $70, $7D, $7E, $50
    .byte $F1, $C9, $5F, $C4, $5F, $C9, $5F, $C4, $F1, $C9, $25, $7E, $7F, $7E, $A9, $25
    .byte $50, $B2, $3C, $50, $3C, $B2, $3C, $50, $F1, $B2, $25, $F1, $7E, $FF, $7E, $EF
    .byte $F2, $7E, $7D, $F7, $00, $F2, $7E, $F1, $7E, $A9, $7E, $F1, $00, $D5, $F4, $00
    .byte $F2, $7E, $F1, $7E, $25, $50, $F7, $00, $C9, $7F, $7E, $F1, $7E, $50, $C9, $D9
    .byte $F5, $00, $D1, $F1, $C9, $7E, $F1, $7E, $B2, $C9, $F3, $00, $D5, $F1, $00, $C9
    .byte $C8, $F1, $7E, $F1, $7E, $3C, $5F, $F6, $00, $F3, $80, $F1, $7E, $50, $C4, $FA
    .byte $00, $F1, $7E, $3C, $5F, $00, $D5, $F8, $00, $F1, $7E, $B2, $C9, $FA, $00, $F1
    .byte $7E, $3C, $5F, $FA, $00, $F1, $7E, $50, $C4, $D9, $F5, $00, $F3, $7B, $F1, $7E
    .byte $B2, $C9, $F4, $00, $D5, $00, $C9, $C8, $F1, $7E, $F1, $7E, $B2, $C9, $F6, $00
    .byte $D1, $C9, $F1, $7E, $F1, $7E, $F1, $25, $F5, $00, $F1, $7B, $F1, $C9, $7E, $F3
    .byte $7E, $F1, $7D, $25, $F1, $00, $6A, $F1, $2F, $7E, $7D, $7E, $F2, $7E, $7F, $70
    .byte $71, $F3, $00, $70, $71, $7E, $F1, $7D, $F2, $C9, $C7, $F1, $00, $C7, $F8, $C9
    .byte $EF, $F1, $C9, $50, $B2, $F1, $00, $F7, $B2, $00, $C9, $F1, $C9, $C4, $FB, $00
    .byte $C9, $F1, $C9, $C4, $DA, $FA, $00, $C9, $F1, $C9, $C4, $FA, $00, $DA, $C9, $F1
    .byte $C9, $C4, $FB, $00, $C9, $EF, $F1, $C9, $C4, $F4, $C9, $DA, $F5, $00, $C9, $F1
    .byte $C9, $C4, $50, $F3, $B2, $F6, $00, $C9, $F1, $C9, $C4, $FB, $00, $C9, $F1, $C9
    .byte $C4, $FA, $00, $DA, $C9, $F1, $C9, $C4, $F1, $00, $D1, $F8, $00, $C9, $F1, $C7
    .byte $F3, $37, $F4, $00, $F2, $37, $F1, $C7, $CB, $CA, $CB, $CA, $CB, $CA, $F4, $00
    .byte $CA, $CB, $CA, $CB, $CA, $F2, $7E, $7D, $F5, $00, $D5, $00, $F2, $7E, $F1, $7E
    .byte $A9, $7E, $F7, $00, $F2, $7E, $F1, $7E, $25, $50, $F2, $00, $D5, $F3, $00, $C9
    .byte $7F, $7E, $F1, $7E, $50, $C9, $F7, $00, $F1, $C9, $7E, $F1, $7E, $B2, $C9, $F6
    .byte $00, $C9, $C8, $F1, $7E, $F1, $7E, $3C, $5F, $D9, $F6, $00, $7E, $F1, $80, $F1
    .byte $7E, $50, $C4, $F7, $00, $7E, $F1, $00, $F1, $7E, $3C, $5F, $F3, $00, $D5, $F1
    .byte $00, $D1, $7E, $F1, $00, $F1, $7E, $B2, $C9, $F7, $00, $7E, $F1, $00, $F1, $7E
    .byte $3C, $5F, $D9, $F6, $00, $7E, $F1, $00, $F1, $7E, $50, $C4, $F7, $00, $7E, $F1
    .byte $7B, $F1, $7E, $B2, $C9, $F2, $00, $D5, $F2, $00, $C9, $C8, $F1, $7E, $F1, $7E
    .byte $B2, $C9, $D9, $F6, $00, $C9, $F1, $7E, $F1, $7E, $F1, $25, $F5, $00, $F1, $7B
    .byte $F1, $C9, $7E, $F3, $7E, $F1, $7D, $25, $F1, $00, $6A, $F1, $2F, $7E, $7D, $7E
    .byte $F2, $7E, $7F, $70, $71, $F3, $00, $70, $71, $7E, $F1, $7D, $F2, $7E, $7D, $F7
    .byte $00, $F2, $7E, $F1, $7E, $A9, $7E, $F7, $00, $F2, $7E, $F1, $7E, $25, $50, $F1
    .byte $00, $DD, $F4, $00, $C9, $7F, $7E, $F1, $7E, $50, $C9, $F6, $00, $D1, $F1, $C9
    .byte $7E, $7E, $C8, $3C, $5F, $00, $DD, $F4, $00, $F1, $C9, $F1, $7E, $FA, $00, $C9
    .byte $C8, $F1, $7E, $EF, $F5, $00, $DD, $F3, $00, $C9, $C8, $F1, $7E, $FA, $00, $C9
    .byte $C8, $F1, $7E, $F3, $7B, $F6, $00, $C9, $C8, $F1, $7E, $7E, $C8, $3C, $5F, $00
    .byte $DD, $F4, $00, $C9, $C8, $F1, $7E, $F1, $7E, $B2, $C9, $F6, $00, $F1, $C9, $F1
    .byte $7E, $F1, $7E, $B2, $C9, $F6, $00, $D1, $C9, $F1, $7E, $F1, $7E, $F1, $25, $F5
    .byte $00, $F1, $7B, $F1, $C9, $7E, $F3, $7E, $F1, $7D, $25, $F1, $00, $6A, $F1, $2F
    .byte $7E, $7D, $7E, $F2, $7E, $7F, $70, $71, $F3, $00, $70, $71, $7E, $F1, $7D, $F1
    .byte $C7, $B2, $F7, $00, $C7, $B2, $37, $C7, $F1, $C7, $B2, $D9, $F1, $00, $D0, $F3
    .byte $00, $C7, $B2, $37, $C7, $F1, $C7, $B2, $F7, $00, $C7, $B2, $37, $C7, $EF, $EF
    .byte $F1, $C7, $B2, $F3, $00, $D0, $F2, $00, $C7, $B2, $37, $C7, $F1, $C7, $B2, $D9
    .byte $F6, $00, $C7, $B2, $37, $C7, $FA, $00, $C7, $B2, $37, $C7, $EF, $F4, $00, $D0
    .byte $F4, $00, $C7, $B2, $37, $C7, $F1, $C7, $B2, $D9, $F6, $00, $C7, $B2, $37, $C7
    .byte $F1, $C7, $B2, $F7, $00, $C7, $B2, $37, $C7, $F1, $C7, $B2, $F1, $00, $D0, $F3
    .byte $00, $D1, $C7, $B2, $37, $C7, $F1, $C7, $B2, $C7, $F5, $00, $F1, $C7, $B2, $37
    .byte $C7, $C7, $CB, $B2, $F1, $C7, $F3, $00, $F2, $C7, $B2, $37, $C7, $F1, $C7, $B2
    .byte $F1, $C7, $F3, $00, $F2, $C7, $B2, $37, $C7, $F4, $7E, $80, $F3, $00, $7B, $F4
    .byte $7E, $EF, $7E, $A9, $25, $50, $B2, $F5, $00, $F1, $B2, $25, $F1, $7E, $F1, $7E
    .byte $50, $F1, $C9, $F5, $00, $F1, $C9, $25, $F1, $7E, $F1, $7E, $FB, $00, $7D, $7E
    .byte $7E, $7D, $FB, $00, $7D, $7E, $7E, $7D, $FB, $00, $25, $7E, $7E, $7D, $F2, $C9
    .byte $F9, $00, $7E, $7E, $7D, $C9, $FB, $00, $7E, $7E, $7D, $C9, $F3, $00, $F4, $C9
    .byte $F1, $00, $6A, $7E, $7E, $7D, $C9, $F5, $00, $C9, $50, $F1, $00, $7B, $2F, $7E
    .byte $7E, $7D, $C9, $F4, $00, $F3, $C9, $00, $7B, $2F, $7E, $7E, $7D, $F5, $C9, $F2
    .byte $7E, $F2, $C9, $F1, $7E, $FC, $7E, $C9, $F1, $7D, $FE, $7E, $7D, $FF
Bank1_NmiVector:
    .addr Bank1_Nmi

Bank1_ResetVector:
    .addr Bank1_Reset

Bank1_IrqVector:
    .addr Bank1_Reset
