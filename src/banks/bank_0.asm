; Address-ordered Doraemon PRG bank 0 preservation listing
; Generated deterministically from pinned Ghidra/GhidraNes facts
; Keep byte-identical through make verify

.segment "PRG0"

Bank0_Func_8000:
    JSR Bank0_Func_80F0
    LDA #$00
    JSR Bank0_Func_81B2
    JMP Bank0_Func_8271

Bank0_Func_800B:
    JSR Bank0_Func_80F0
    LDA #$01
    JSR Bank0_Func_81B2
    JMP Bank0_Func_8271

Bank0_Func_8016:
    JSR Bank0_Func_80F0
    LDA #$02
    JSR Bank0_Func_81B2
    JMP Bank0_Func_8271
    .byte $4C, $74, $82

Bank0_Func_8024:
    JSR Bank0_Func_80F0
    LDA #$00
    JSR Bank0_Func_81B2
    JMP Bank0_Func_8277

Bank0_Func_802F:
    JSR Bank0_Func_80F0
    LDA #$01
    JSR Bank0_Func_81B2
    JMP Bank0_Func_8277

Bank0_Func_803A:
    JSR Bank0_Func_80F0
    LDA #$02
    JSR Bank0_Func_81B2
    JMP Bank0_Func_8277
    .byte $4C, $7A, $82

Bank0_Func_8048:
    JSR Bank0_Func_80F0
    LDA #$03
    JSR Bank0_Func_81B2
    JMP Bank0_Func_8271

Bank0_Func_8053:
    JSR Bank0_Func_80F0
    LDA $17
    PHA
    LDA #$03
    JSR Bank0_Func_81B2
    JSR Bank0_Func_8277
    PLA
    JMP Bank0_Func_81B2

Bank0_Func_8065:
    JSR Bank0_Func_80F0
    LDA $17
    PHA
    LDA #$03
    JSR Bank0_Func_81B2
    JSR Bank0_Func_827D
    PLA
    JMP Bank0_Func_81B2

Bank0_Func_8077:
    JSR Bank0_Func_80F0
    LDA #$03
    JSR Bank0_Func_81B2
    JMP Bank0_Label_8280

Bank0_Func_8082:
    JSR Bank0_Func_80F0
    LDA #$03
    JSR Bank0_Func_81B2
    JMP Bank0_Label_8283

Bank0_Func_808D:
    JSR Bank0_Func_80F0
    LDA #$03
    JSR Bank0_Func_81B2
    JMP Bank0_Label_8286

Bank0_Reset:
    LDX #$7F
    TXS
    LDA #$00
    STA a:$2001
    STA a:$2000
    JSR Bank0_WaitForVblank
    JSR Bank0_WaitForVblank
    LDX #$00
    TXA

Bank0_Label_80AC:
    STA a:$0400,X
    STA a:$0500,X
    STA a:$0600,X
    STA a:$0700,X
    INX
    BNE Bank0_Label_80AC
    LDA #$10
    STA $19
    STA a:$2000
    LDA #$06
    STA $1A
    STA a:$2001
    JSR Bank0_Func_80DA
    JMP Bank0_Func_8048

Bank0_WaitForVblank:
    LDA a:$2002
    BPL Bank0_WaitForVblank

Bank0_Label_80D4:
    LDA a:$2002
    BMI Bank0_Label_80D4
    RTS

Bank0_Func_80DA:
    JSR Bank0_WaitForVblank
    LDA #$00
    STA $14
    LDA $19
    STA a:$2000
    LDA $1A
    AND #$E7
    STA $1A
    STA a:$2001
    RTS

Bank0_Func_80F0:
    JSR Bank0_Func_80DA
    LDA $19
    AND #$7F
    STA $19
    STA a:$2000
    RTS

Bank0_Func_80FD:
    JSR Bank0_Func_8131
    JSR Bank0_WaitForVblank
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
    JSR Bank0_WriteMapper
    LDA $1A
    ORA #$18
    STA $1A
    STA a:$2001
    RTS

Bank0_Func_8131:
    LDA #$F0
    LDX #$00

Bank0_Label_8135:
    STA a:$0300,X
    INX
    BNE Bank0_Label_8135
    RTS

Bank0_Nmi:
    PHA
    TXA
    PHA
    TYA
    PHA
    LDA $15
    BNE Bank0_Label_81A2
    INC $15
    LDA $14
    BEQ Bank0_Label_8158
    LDA #$00
    STA a:$2003
    LDA #$03
    STA a:$4014
    JSR Bank0_WriteMapper

Bank0_Label_8158:
    JSR Bank0_Func_8274
    LDA #$01
    STA a:$4016
    LDA #$00
    STA a:$4016
    LDX #$08

Bank0_Label_8167:
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
    BNE Bank0_Label_8167
    LDA $1D
    AND #$CF
    ORA $1F
    ORA $20
    ORA $1E
    STA $21
    LDA a:$4016
    AND #$04
    CMP $23
    BEQ Bank0_Label_8197
    STA $23
    LDA #$14
    STA $24

Bank0_Label_8197:
    LDA $24
    BEQ Bank0_Label_819D
    DEC $24

Bank0_Label_819D:
    JSR Bank0_Func_827A
    DEC $15

Bank0_Label_81A2:
    INC $16
    PLA
    TAY
    PLA
    TAX
    PLA
    RTI

Bank0_Func_81AA:
    ASL A
    ASL A
    AND #$0C
    STA $18
    LDA $17

Bank0_Func_81B2:
    AND #$03
    ORA $18
    STA $17
    JSR Bank0_WaitForVblank

Bank0_WriteMapper:
    LDA $17
    TAX
    LDA a:$8261,X
    STA a:$8261,X
    NOP
    NOP
    NOP
    NOP
    RTS

Bank0_Func_81C9:
    STA $07
    LDA $27
    BNE Bank0_Label_81E5
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
    JSR Bank0_Func_81E6
    PLA
    TAX
    PLA
    TAY

Bank0_Label_81E5:
    RTS

Bank0_Func_81E6:
    CLC
    ADC a:$0298,X
    LDY #$00

Bank0_Label_81EC:
    CMP #$0A
    BCC Bank0_Label_81F6
    SEC
    SBC #$0A
    INY
    BNE Bank0_Label_81EC

Bank0_Label_81F6:
    STA a:$0298,X
    TYA
    BNE Bank0_Label_81FD
    RTS

Bank0_Label_81FD:
    DEX
    BPL Bank0_Func_81E6
    LDA #$09
    LDX #$05

Bank0_Label_8204:
    STA a:$0298,X
    STA a:$0290,X
    DEX
    BPL Bank0_Label_8204
    RTS

Bank0_Func_820E:
    LDA $27
    BNE Bank0_Label_8244
    LDA $25
    CMP #$04
    BEQ Bank0_Label_8233
    ASL A
    ASL A
    TAY
    LDX #$00

Bank0_Label_821D:
    LDA a:$0298,X
    CMP a:$8251,Y
    BCC Bank0_Label_8233
    BNE Bank0_Label_822D
    INX
    INY
    CPX #$04
    BNE Bank0_Label_821D

Bank0_Label_822D:
    INC $2A
    INC $26
    INC $25

Bank0_Label_8233:
    LDX #$00

Bank0_Label_8235:
    LDA a:$0290,X
    CMP a:$0298,X
    BCC Bank0_Label_8245
    BNE Bank0_Label_8244
    INX
    CPX #$06
    BNE Bank0_Label_8235

Bank0_Label_8244:
    RTS

Bank0_Label_8245:
    LDA a:$0298,X
    STA a:$0290,X
    INX
    CPX #$06
    BNE Bank0_Label_8245
    RTS
    .byte $00, $00, $02, $00, $00, $00, $08, $00, $00, $02, $00, $00, $00, $05, $00, $00

Bank0_MapperValueTable:
    .byte $00, $10, $20, $30, $01, $11, $21, $31, $02, $12, $22, $32, $03, $13, $23, $33

Bank0_Func_8271:
    JMP Bank0_World1Main

Bank0_Func_8274:
    JMP Bank0_Func_84D9

Bank0_Func_8277:
    JMP Bank0_Func_8451

Bank0_Func_827A:
    JMP Bank0_Func_827D

Bank0_Func_827D:
    LDA $26

Bank0_Label_8280 = * + 1  ; overlapping entry $8280
    BEQ Bank0_Label_8288
    LDA #$10

Bank0_Label_8283:
    JSR Bank0_Func_E3BC

Bank0_Label_8286:
    DEC $26

Bank0_Label_8288:
    JSR Bank0_Func_E3CD
    JMP Bank0_Func_E9FD

Bank0_World1Main:
    LDX #$7F
    TXS
    LDA #$00
    STA a:$0180
    JSR Bank0_Func_83A3
    JSR Bank0_Func_837C
    JSR Bank0_Func_830C

Bank0_Label_829F:
    JSR Bank0_Func_83E8
    JSR Bank0_Func_8362
    LDA #$01
    STA $51
    JSR Bank0_Func_C93E
    JSR Bank0_Func_C949
    JSR Bank0_Func_C95F
    JSR Bank0_Func_C96A
    JSR Bank0_Func_9535
    JSR Bank0_Func_A7DB
    JSR Bank0_Func_843B
    JSR Bank0_Func_95ED

Bank0_Label_82C1:
    JSR Bank0_Func_94F1
    JSR Bank0_Func_8490
    JSR Bank0_Func_95CB
    JSR Bank0_Func_9B54
    JSR Bank0_Func_856C
    JSR Bank0_Func_CA6D
    JSR Bank0_Func_9201
    JSR Bank0_Func_8706
    JSR Bank0_Func_8BDE
    JSR Bank0_Func_888F
    JSR Bank0_Func_8EF6
    JSR Bank0_Func_931B
    JSR Bank0_TryEnterWorld1Door
    JSR Bank0_TryEnterWorld1Manhole
    JSR Bank0_Func_820E
    LDA $79
    BMI Bank0_Label_82F5
    JMP Bank0_Label_82C1

Bank0_Label_82F5:
    JSR Bank0_Func_884C
    DEC $2A
    BMI Bank0_Label_82FF
    JMP Bank0_Label_829F

Bank0_Label_82FF:
    JSR Bank0_Func_8065
    LDA #$02
    STA $2A
    JSR Bank0_Func_C92F
    JMP Bank0_Label_829F

Bank0_Func_830C:
    JSR Bank0_Func_C92F
    LDA #$00
    STA $27

Bank0_Func_8313:
    JSR Bank0_Func_C976
    LDA #$02
    STA $2A
    LDA #$E0
    STA $5B
    LDA #$D8
    STA $5C
    LDA #$78
    STA $75
    LDA #$80
    STA $76
    LDA #$00
    STA $79
    STA $25
    STA $26
    STA $77
    STA $7F
    STA $78
    STA $78
    STA $7B
    STA $63
    STA $27
    STA $28
    STA $29
    STA $24
    LDA #$06
    STA $2C
    JSR Bank0_Func_8362
    RTS

Bank0_Func_834E:
    JSR Bank0_Func_83BD
    LDA #$EF
    STA $66
    LDA #$B2
    STA $67
    LDA #$89
    STA $68
    LDA #$D9
    STA $69
    RTS

Bank0_Func_8362:
    LDA #$08
    SEC
    SBC $2C
    ASL A
    ASL A
    STA $2B
    LDA #$00
    STA $79
    LDA #$00
    STA $77
    LDA #$00
    STA $7F
    LDA #$00
    STA $78
    RTS

Bank0_Func_837C:
    LDX #$00
    TXA

Bank0_Label_837F:
    STA a:$0300,X
    STA a:$0400,X
    STA a:$0500,X
    STA a:$0600,X
    STA a:$0700,X
    CPX #$F8
    BCS Bank0_Label_8398
    CPX #$3C
    BCC Bank0_Label_8398
    STA $00,X

Bank0_Label_8398:
    CPX #$90
    BCS Bank0_Label_839F
    STA a:$0200,X

Bank0_Label_839F:
    INX
    BNE Bank0_Label_837F
    RTS

Bank0_Func_83A3:
    LDA #$00
    STA a:$02A0
    STA a:$02AA
    STA a:$02AB
    STA a:$4011
    STA a:$4015
    STA a:$4010
    LDA #$40
    STA a:$4017
    RTS

Bank0_Func_83BD:
    LDA #$00
    STA $00
    LDA $29
    LSR A
    ROR $00
    LSR A
    ROR $00
    LSR A
    ROR $00
    STA $01
    LDA $00
    CLC
    ADC #$A5
    STA $00
    LDA $01
    ADC #$D7
    STA $01
    LDY #$00

Bank0_Label_83DD:
    LDA ($00),Y
    STA a:$0210,Y
    INY
    CPY #$20
    BCC Bank0_Label_83DD
    RTS

Bank0_Func_83E8:
    JSR Bank0_Func_9614
    JSR Bank0_Func_83A3
    LDA $19
    AND #$FE
    ORA #$10
    STA $19
    LDA #$00
    STA $1B
    STA $1C
    STA $58
    STA $59
    STA $5A
    STA $51
    JSR Bank0_Func_8131
    LDA #$5B
    STA $16
    LDA $27
    BNE Bank0_Label_841D
    JSR Bank0_Func_8053
    JSR Bank0_Func_95ED
    LDX #$5A

Bank0_Label_8417:
    JSR Bank0_Func_94F1
    DEX
    BNE Bank0_Label_8417

Bank0_Label_841D:
    JSR Bank0_Func_9614
    JSR Bank0_Func_834E
    JSR Bank0_Func_94F8
    JSR Bank0_Func_951B
    LDA $19
    ORA #$10
    STA $19
    LDA #$00
    JSR Bank0_Func_81AA
    JSR Bank0_Func_C96A
    JSR Bank0_Func_8362
    RTS

Bank0_Func_843B:
    LDA $29
    TAX
    LDA a:$8445,X
    STA a:$02AA
    RTS
    .byte $01, $04, $05, $02, $02, $02, $02, $02, $03, $03, $02, $02

Bank0_Func_8451:
    LDX #$7F
    TXS
    LDA #$00
    STA a:$0180
    JSR Bank0_Func_83A3
    JSR Bank0_Func_837C
    JSR Bank0_Func_8313
    LDA #$01
    STA $27
    LDA #$00
    STA a:$0180
    LDA #$00
    STA $16
    STA $52
    STA $53
    STA $54
    STA $55
    STA $56
    STA $57
    LDA #$BF
    STA $A6
    LDA #$FC
    STA $A7
    LDA #$00
    STA $A8
    STA $A9
    LDA #$02
    STA $7B
    JMP Bank0_Label_829F

Bank0_Func_8490:
    LDA $27
    BNE Bank0_Label_84A3

Bank0_Label_8494:
    LDA $21
    EOR $64
    STA $65
    LDA $21
    STA $64
    AND $65
    STA $65
    RTS

Bank0_Label_84A3:
    LDA $21
    AND #$30
    BNE Bank0_Label_84D6
    LDA $A8
    BNE Bank0_Label_84CB
    LDY #$00
    LDA ($A6),Y
    STA $A8
    INY
    LDA ($A6),Y
    STA $A9
    LDA $A6
    CLC
    ADC #$02
    STA $A6
    BCC Bank0_Label_84C3
    INC $A7

Bank0_Label_84C3:
    LDA $A8
    AND $A9
    CMP #$FF
    BEQ Bank0_Label_84D6

Bank0_Label_84CB:
    DEC $A8
    LDA $A9
    AND #$CF
    STA $21
    JMP Bank0_Label_8494

Bank0_Label_84D6:
    JMP Bank0_Func_8048

Bank0_Func_84D9:
    LDA $14
    BNE Bank0_Label_84E0
    JMP Bank0_Label_856B

Bank0_Label_84E0:
    LDA a:$0260
    ORA a:$0230
    BEQ Bank0_Label_84EE
    JSR Bank0_Func_A87E
    JMP Bank0_Label_8531

Bank0_Label_84EE:
    LDY #$00

Bank0_Label_84F0:
    LDA a:$0180,Y
    BEQ Bank0_Label_8531
    PHA
    LDA #$00
    STA a:$0180,Y
    PLA
    CMP #$02
    BEQ Bank0_Label_8527
    LDA $19
    AND #$FB
    STA a:$2000

Bank0_Label_8507:
    INY
    LDA a:$0180,Y
    STA a:$2006
    INY
    LDA a:$0180,Y
    STA a:$2006
    INY
    LDA a:$0180,Y
    TAX
    INY

Bank0_Label_851B:
    LDA a:$0180,Y
    INY
    STA a:$2007
    DEX
    BNE Bank0_Label_851B
    BEQ Bank0_Label_84F0

Bank0_Label_8527:
    LDA $19
    ORA #$04
    STA a:$2000
    JMP Bank0_Label_8507

Bank0_Label_8531:
    LDA $19
    AND #$FB
    STA a:$2000
    LDA $1A
    STA a:$2001
    LDA $59
    STA a:$2005
    LDA $5A
    STA a:$2005
    LDA $1B
    STA $59
    LDA $1C
    STA $5A
    LDA $19
    AND #$FE
    STA $0A
    LDA $58
    AND #$01
    ORA $0A
    STA $19
    JSR Bank0_Func_8131
    LDA #$00
    STA $50
    LDA $51
    BEQ Bank0_Label_856B
    JSR Bank0_Func_9674

Bank0_Label_856B:
    RTS

Bank0_Func_856C:
    JSR Bank0_Func_9BFC
    LDA $79
    BEQ Bank0_Label_85B2
    BPL Bank0_Label_8576
    RTS

Bank0_Label_8576:
    LDA #$40
    STA $78
    LDA $16
    AND #$03
    BNE Bank0_Label_8582
    INC $79

Bank0_Label_8582:
    LDA $79
    CMP #$06
    BCS Bank0_Label_8599
    LDA $16
    LSR A
    LSR A
    AND #$01
    ORA #$10
    STA $77
    LDA #$00
    STA $78
    JMP Bank0_Label_85CD

Bank0_Label_8599:
    CMP #$16
    BCC Bank0_Label_85A1
    LDA #$00
    STA $79

Bank0_Label_85A1:
    LDA $77
    AND #$03
    STA $00
    LDA $7F
    ASL A
    ASL A
    ORA $00
    STA $77
    JMP Bank0_Label_85B6

Bank0_Label_85B2:
    LDA #$00
    STA $78

Bank0_Label_85B6:
    LDA $63
    BEQ Bank0_Label_85CD
    CMP #$03
    BCS Bank0_Label_85C7
    LDA $77
    AND #$0C
    STA $77
    JMP Bank0_Label_85CD

Bank0_Label_85C7:
    LDA $77
    ORA #$01
    STA $77

Bank0_Label_85CD:
    LDA $77
    STA $01
    LDA $75
    STA $06
    LDA $76
    STA $07
    LDY $21
    TYA
    AND #$08
    BNE Bank0_Label_860D
    TYA
    AND #$04
    BNE Bank0_Label_863B
    TYA
    AND #$02
    BNE Bank0_Label_8669
    TYA
    AND #$01
    BNE Bank0_Label_860A
    LDA $79
    BEQ Bank0_Label_85F7
    CMP #$06
    BCC Bank0_Label_8609

Bank0_Label_85F7:
    INC $7A
    LDA $7A
    CMP #$05
    BCC Bank0_Label_8609
    LDA #$00
    STA $7A
    LDA $77
    AND #$0C
    STA $77

Bank0_Label_8609:
    RTS

Bank0_Label_860A:
    JMP Bank0_Label_8690

Bank0_Label_860D:
    LDA #$01
    STA $7F
    DEC $76
    DEC $76
    LDA $76
    CMP #$28
    BCS Bank0_Label_861F
    LDA #$28
    STA $76

Bank0_Label_861F:
    LDA #$05
    STA $01
    LDX #$00
    LDY #$14
    JSR Bank0_Func_86F8
    LDX #$07
    LDY #$14
    JSR Bank0_Func_86F8
    LDX #$0E
    LDY #$14
    JSR Bank0_Func_86F8
    JMP Bank0_Label_86B7

Bank0_Label_863B:
    LDA #$00
    STA $7F
    INC $76
    INC $76
    LDA $76
    CMP #$C9
    BCC Bank0_Label_864D
    LDA #$C8
    STA $76

Bank0_Label_864D:
    LDA #$01
    STA $01
    LDX #$00
    LDY #$18
    JSR Bank0_Func_86F8
    LDX #$07
    LDY #$18
    JSR Bank0_Func_86F8
    LDX #$0E
    LDY #$18
    JSR Bank0_Func_86F8
    JMP Bank0_Label_86B7

Bank0_Label_8669:
    LDA #$02
    STA $7F
    DEC $75
    DEC $75
    LDA $75
    CMP #$05
    BCS Bank0_Label_867B
    LDA #$05
    STA $75

Bank0_Label_867B:
    LDA #$09
    STA $01
    LDX #$00
    LDY #$18
    JSR Bank0_Func_86F8
    LDX #$00
    LDY #$14
    JSR Bank0_Func_86F8
    JMP Bank0_Label_86B7

Bank0_Label_8690:
    LDA #$03
    STA $7F
    INC $75
    INC $75
    LDA $75
    CMP #$EC
    BCC Bank0_Label_86A2
    LDA #$EB
    STA $75

Bank0_Label_86A2:
    LDA #$0D
    STA $01
    LDX #$0E
    LDY #$18
    JSR Bank0_Func_86F8
    LDX #$0E
    LDY #$14
    JSR Bank0_Func_86F8
    JMP Bank0_Label_86B7

Bank0_Label_86B7:
    LDA $79
    BEQ Bank0_Label_86BF
    CMP #$06
    BCC Bank0_Label_86F7

Bank0_Label_86BF:
    LDA $77
    AND #$0C
    STA $00
    LDA $01
    AND #$0C
    CMP $00
    BEQ Bank0_Label_86D7
    LDA $01
    STA $77
    LDA #$00
    STA $7A
    STA $63

Bank0_Label_86D7:
    LDA $63
    BNE Bank0_Label_86F7
    INC $7A
    LDA $7A
    CMP #$05
    BCC Bank0_Label_86F7
    LDA #$00
    STA $7A
    LDA $77
    AND #$0C
    STA $00
    INC $77
    LDA $77
    AND #$03
    ORA $00
    STA $77

Bank0_Label_86F7:
    RTS

Bank0_Func_86F8:
    JSR Bank0_Func_D1C3
    BCC Bank0_Label_8705
    LDA $06
    STA $75
    LDA $07
    STA $76

Bank0_Label_8705:
    RTS

Bank0_Func_8706:
    LDA #$00
    STA $61
    STA $62
    LDA $75
    CMP #$50
    BCS Bank0_Label_871B
    JSR Bank0_Func_A3E1
    JSR Bank0_Func_A3E1
    JMP Bank0_Label_8725

Bank0_Label_871B:
    CMP #$A0
    BCC Bank0_Label_8725
    JSR Bank0_Func_A381
    JSR Bank0_Func_A381

Bank0_Label_8725:
    LDA $76
    CMP #$48
    BCS Bank0_Label_8734
    JSR Bank0_Func_A484
    JSR Bank0_Func_A484
    JMP Bank0_Label_873E

Bank0_Label_8734:
    CMP #$90
    BCC Bank0_Label_873E
    JSR Bank0_Func_A42F
    JSR Bank0_Func_A42F

Bank0_Label_873E:
    LDA $75
    CLC
    ADC $61
    STA $75
    LDA $76
    CLC
    ADC $62
    STA $76
    JSR Bank0_Func_8750
    RTS

Bank0_Func_8750:
    LDY #$2F
    LDA $61
    BEQ Bank0_Label_87A2
    BMI Bank0_Label_877E

Bank0_Label_8758:
    LDA a:$0400,Y
    BEQ Bank0_Label_8779
    LDA a:$04C0,Y
    CLC
    ADC $61
    STA a:$04C0,Y
    BCC Bank0_Label_8779
    LDA a:$0490,Y
    TAX
    AND #$FC
    STA $00
    INX
    TXA
    AND #$03
    ORA $00
    STA a:$0490,Y

Bank0_Label_8779:
    DEY
    BPL Bank0_Label_8758
    BMI Bank0_Label_87A2

Bank0_Label_877E:
    LDA a:$0400,Y
    BEQ Bank0_Label_879F
    LDA a:$04C0,Y
    CLC
    ADC $61
    STA a:$04C0,Y
    BCS Bank0_Label_879F
    LDA a:$0490,Y
    TAX
    AND #$FC
    STA $00
    DEX
    TXA
    AND #$03
    ORA $00
    STA a:$0490,Y

Bank0_Label_879F:
    DEY
    BPL Bank0_Label_877E

Bank0_Label_87A2:
    LDY #$2F
    LDA $62
    BEQ Bank0_Func_87F8
    BMI Bank0_Label_87D2

Bank0_Label_87AA:
    LDA a:$0400,Y
    BEQ Bank0_Label_87CD
    LDA a:$04F0,Y
    CLC
    ADC $62
    STA a:$04F0,Y
    BCC Bank0_Label_87CD
    LDA a:$0490,Y
    TAX
    AND #$F3
    STA $00
    TXA
    CLC
    ADC #$04
    AND #$0C
    ORA $00
    STA a:$0490,Y

Bank0_Label_87CD:
    DEY
    BPL Bank0_Label_87AA
    BMI Bank0_Func_87F8

Bank0_Label_87D2:
    LDA a:$0400,Y
    BEQ Bank0_Label_87F5
    LDA a:$04F0,Y
    CLC
    ADC $62
    STA a:$04F0,Y
    BCS Bank0_Label_87F5
    LDA a:$0490,Y
    TAX
    AND #$F3
    STA $00
    TXA
    SEC
    SBC #$04
    AND #$0C
    ORA $00
    STA a:$0490,Y

Bank0_Label_87F5:
    DEY
    BPL Bank0_Label_87D2

Bank0_Func_87F8:
    LDY #$2F

Bank0_Label_87FA:
    LDA a:$0400,Y
    BEQ Bank0_Label_8848
    LDA a:$0490,Y
    AND #$03
    BEQ Bank0_Label_881C
    CMP #$02
    BEQ Bank0_Label_8839
    BCC Bank0_Label_8815
    LDA a:$04C0,Y
    CMP #$C0
    BCC Bank0_Label_8839
    BCS Bank0_Label_881C

Bank0_Label_8815:
    LDA a:$04C0,Y
    CMP #$40
    BCS Bank0_Label_8839

Bank0_Label_881C:
    LDA a:$0490,Y
    AND #$0C
    BEQ Bank0_Label_8848
    CMP #$08
    BEQ Bank0_Label_8839
    BCC Bank0_Label_8832
    LDA a:$04F0,Y
    CMP #$C0
    BCC Bank0_Label_8839
    BCS Bank0_Label_8848

Bank0_Label_8832:
    LDA a:$04F0,Y
    CMP #$20
    BCC Bank0_Label_8848

Bank0_Label_8839:
    LDA #$00
    STA a:$0400,Y
    LDA a:$0520,Y
    BMI Bank0_Label_8848
    AND #$7F
    JSR Bank0_Func_8D62

Bank0_Label_8848:
    DEY
    BPL Bank0_Label_87FA
    RTS

Bank0_Func_884C:
    JSR Bank0_Func_C949
    JSR Bank0_Func_C954
    LDA #$00
    STA a:$02AA
    LDA #$00
    STA $78
    LDA #$78
    STA $97

Bank0_Label_885F:
    LDA $97
    LSR A
    LSR A
    LSR A
    AND #$01
    ORA #$10
    STA $77
    JSR Bank0_Func_94F1
    LDA $97
    CMP #$3C
    BNE Bank0_Label_8878
    LDA #$07
    STA a:$02AA

Bank0_Label_8878:
    DEC $97
    BNE Bank0_Label_885F
    LDA #$78
    STA $97

Bank0_Label_8880:
    JSR Bank0_Func_94F1
    DEC $97
    BNE Bank0_Label_8880
    LDA $27
    BEQ Bank0_Label_888E
    JMP Bank0_Func_8048

Bank0_Label_888E:
    RTS

Bank0_Func_888F:
    LDX #$00

Bank0_Label_8891:
    LDA a:$0400,X
    BEQ Bank0_Label_88A1
    BMI Bank0_Label_88B8
    PHA
    LDA $82
    BNE Bank0_Label_88B4
    PLA
    JSR Bank0_Func_88A7

Bank0_Label_88A1:
    INX
    CPX #$0A
    BNE Bank0_Label_8891
    RTS

Bank0_Func_88A7:
    AND #$1F
    ASL A
    TAY
    LDA a:$88FC,Y
    PHA
    LDA a:$88FB,Y
    PHA
    RTS

Bank0_Label_88B4:
    PLA
    JMP Bank0_Label_88A1

Bank0_Label_88B8:
    CMP #$C0
    BCS Bank0_Label_88E4
    INC a:$05E0,X
    LDA a:$05E0,X
    CMP #$28
    BCS Bank0_Label_88D1
    LDA a:$0460,X
    ORA #$C0
    STA a:$0460,X
    JMP Bank0_Label_88A1

Bank0_Label_88D1:
    LDA a:$0460,X
    AND #$03
    STA a:$0460,X
    LDA a:$0400,X
    AND #$7F
    STA a:$0400,X
    JMP Bank0_Label_88A1

Bank0_Label_88E4:
    LDA #$02
    STA a:$0490,X
    LDA a:$0520,X
    BMI Bank0_Label_88EE

Bank0_Label_88EE:
    LDA a:$0400,X
    AND #$3F
    TAY
    LDA a:$891B,Y
    JSR Bank0_Func_81C9
    JMP Bank0_Label_88A1
    .byte $D9, $DB, $48, $DC, $B1, $DC, $28, $DD, $BA, $DE, $6F, $DF, $1E, $E0, $4A, $E1
    .byte $DF, $E1, $48, $E2, $D2, $DD, $07, $DF, $D9, $DB, $96, $D5, $96, $D5, $41, $42
    .byte $42, $45, $41, $42, $55, $48, $55, $31, $55, $55, $55, $21, $55, $55, $20, $D4
    .byte $8A, $BD, $80, $05, $4C, $45, $8B, $38, $BD, $C0, $04, $E5, $75, $08, $A9, $00
    .byte $2A, $0A, $0A, $09, $02, $9D, $80, $05, $28, $90, $04, $A9, $40, $D0, $02, $A9
    .byte $42, $9D, $30, $04, $60, $BD, $80, $05, $49, $04, $9D, $80, $05, $BD, $80, $05
    .byte $29, $07, $4C, $62, $89, $48, $29, $07, $48, $A8, $B9, $77, $89, $20, $6C, $8A
    .byte $68, $A8, $B9, $7F, $89, $20, $A6, $8A, $68, $60, $00, $01, $01, $01, $00, $FF
    .byte $FF, $FF, $01, $01, $00, $FF, $FF, $FF, $00, $01, $BD, $90, $04, $85, $00, $BD
    .byte $C0, $04, $46, $00, $6A, $46, $00, $6A, $18, $69, $40, $85, $01, $BD, $F0, $04
    .byte $46, $00, $6A, $46, $00, $6A, $18, $69, $40, $85, $00, $A5, $75, $4A, $4A, $09
    .byte $40, $38, $E5, $01, $85, $01, $B0, $49, $49, $FF, $18, $69, $01, $85, $01, $A5
    .byte $76, $4A, $4A, $09, $40, $38, $E5, $00, $85, $00, $B0, $1E, $49, $FF, $18, $69
    .byte $01, $85, $00, $A5, $01, $4A, $C5, $00, $90, $03, $A9, $06, $60, $A5, $00, $4A
    .byte $C5, $01, $90, $03, $A9, $04, $60, $A9, $05, $60, $A5, $01, $4A, $C5, $00, $90
    .byte $03, $A9, $06, $60, $A5, $00, $4A, $C5, $01, $90, $03, $A9, $00, $60, $A9, $07
    .byte $60, $A5, $76, $4A, $4A, $09, $40, $38, $E5, $00, $85, $00, $B0, $1E, $49, $FF
    .byte $18, $69, $01, $85, $00, $A5, $01, $4A, $C5, $00, $90, $03, $A9, $02, $60, $A5
    .byte $00, $4A, $C5, $01, $90, $03, $A9, $04, $60, $A9, $03, $60, $A5, $01, $4A, $C5
    .byte $00, $90, $03, $A9, $02, $60, $A5, $00, $4A, $C5, $01, $90, $03, $A9, $00, $60
    .byte $A9, $01, $60, $BD, $90, $04, $29, $03, $F0, $0D, $C9, $03, $D0, $1B, $BD, $C0
    .byte $04, $C9, $E0, $B0, $02, $B0, $12, $BD, $90, $04, $29, $0C, $F0, $0E, $C9, $0C
    .byte $D0, $07, $BD, $F0, $04, $C9, $E0, $B0, $03, $A9, $01, $60, $A9, $00, $60

Bank0_Func_8A6C:
    ORA #$00
    BMI Bank0_Label_8A8B
    CLC
    ADC a:$04C0,X
    STA a:$04C0,X
    BCC Bank0_Label_8A8A
    LDA a:$0490,X
    TAY
    AND #$0C
    STA $00
    INY
    TYA
    AND #$03
    ORA $00
    STA a:$0490,X

Bank0_Label_8A8A:
    RTS

Bank0_Label_8A8B:
    CLC
    ADC a:$04C0,X
    STA a:$04C0,X
    BCS Bank0_Label_8A8A
    LDA a:$0490,X
    TAY
    AND #$0C
    STA $00
    DEY
    TYA
    AND #$03
    ORA $00
    STA a:$0490,X
    RTS

Bank0_Func_8AA6:
    ORA #$00
    BMI Bank0_Label_8ABF
    CLC
    ADC a:$04F0,X
    STA a:$04F0,X
    BCC Bank0_Label_8ABE
    LDA a:$0490,X
    CLC
    ADC #$04
    AND #$0F
    STA a:$0490,X

Bank0_Label_8ABE:
    RTS

Bank0_Label_8ABF:
    CLC
    ADC a:$04F0,X
    STA a:$04F0,X
    BCS Bank0_Label_8ABE
    LDA a:$0490,X
    SEC
    SBC #$04
    AND #$0F
    STA a:$0490,X
    RTS
    .byte $BD, $90, $04, $29, $03, $85, $00, $A5, $1B, $29, $07, $18, $7D, $C0, $04, $85
    .byte $02, $A5, $00, $69, $00, $85, $00, $A5, $02, $46, $00, $6A, $46, $00, $6A, $48
    .byte $29, $80, $85, $00, $68, $4A, $05, $00, $18, $65, $5B, $85, $00, $BD, $90, $04
    .byte $29, $0C, $4A, $4A, $85, $01, $A5, $1C, $29, $07, $18, $7D, $F0, $04, $85, $02
    .byte $A5, $01, $69, $00, $85, $01, $A5, $02, $46, $01, $6A, $46, $01, $6A, $48, $29
    .byte $80, $85, $01, $68, $4A, $05, $01, $18, $65, $5C, $85, $01, $60, $18, $65, $00
    .byte $85, $02, $98, $18, $65, $01, $A8, $8A, $48, $A6, $02, $20, $A7, $A6, $68, $AA
    .byte $60, $29, $07, $A8, $F0, $1B, $88, $F0, $76, $88, $F0, $30, $88, $F0, $79, $88
    .byte $F0, $3E, $88, $F0, $7C, $88, $F0, $53, $20, $65, $8B, $B0, $03, $20, $AF, $8B
    .byte $60, $A9, $00, $A4, $9A, $20, $31, $8B, $20, $E8, $A6, $C9, $42, $B0, $0C, $20
    .byte $E8, $A6, $C9, $42, $B0, $05, $20, $E2, $A6, $C9, $42, $60, $A5, $99, $A0, $01
    .byte $20, $31, $8B, $20, $19, $A7, $C9, $42, $B0, $05, $20, $E2, $A6, $C9, $42, $60
    .byte $A9, $00, $A0, $01, $20, $31, $8B, $20, $E8, $A6, $C9, $42, $B0, $0C, $20, $E8
    .byte $A6, $C9, $42, $B0, $05, $20, $E2, $A6, $C9, $42, $60, $A9, $00, $A0, $01, $20
    .byte $31, $8B, $20, $19, $A7, $C9, $42, $B0, $05, $20, $E2, $A6, $C9, $42, $60, $20
    .byte $65, $8B, $B0, $03, $20, $80, $8B, $60, $20, $94, $8B, $B0, $03, $20, $80, $8B
    .byte $60, $20, $AF, $8B, $B0, $03, $20, $94, $8B, $60

Bank0_Func_8BDE:
    LDA $61
    BMI Bank0_Label_8BE7
    BNE Bank0_Label_8C03
    JMP Bank0_Label_8C1A

Bank0_Label_8BE7:
    EOR #$FF
    CLC
    ADC #$01
    STA $8D
    LDA $1B
    AND #$07
    CMP $8D
    BCS Bank0_Label_8C02
    LDA $5B
    CLC
    ADC #$24
    BCS Bank0_Label_8C02
    STA $8D
    JMP Bank0_Label_8CBA

Bank0_Label_8C02:
    RTS

Bank0_Label_8C03:
    LDA $1B
    AND #$07
    CLC
    ADC $61
    CMP #$08
    BCC Bank0_Label_8BE7
    LDA $5B
    SEC
    SBC #$04
    BCC Bank0_Label_8C02
    STA $8D
    JMP Bank0_Label_8CBA

Bank0_Label_8C1A:
    LDA $62
    BMI Bank0_Label_8C21
    BNE Bank0_Label_8C3E
    RTS

Bank0_Label_8C21:
    EOR #$FF
    CLC
    ADC #$01
    STA $8D
    LDA $1C
    AND #$07
    CMP $8D
    BCC Bank0_Label_8C31
    RTS

Bank0_Label_8C31:
    LDA $5C
    CLC
    ADC #$22
    BCC Bank0_Label_8C39
    RTS

Bank0_Label_8C39:
    STA $8D
    JMP Bank0_Label_8C54

Bank0_Label_8C3E:
    LDA $1C
    AND #$07
    CLC
    ADC $62
    CMP #$08
    BCS Bank0_Label_8C4A
    RTS

Bank0_Label_8C4A:
    LDA $5C
    SEC
    SBC #$04
    BCS Bank0_Label_8C52
    RTS

Bank0_Label_8C52:
    STA $8D

Bank0_Label_8C54:
    LDA #$FF
    STA $8E
    LDA $5B
    CLC
    ADC #$24
    BCS Bank0_Label_8C61
    STA $8E

Bank0_Label_8C61:
    LDA #$00
    STA $8F
    LDA $5B
    SEC
    SBC #$04
    BCC Bank0_Label_8C6E
    STA $8F

Bank0_Label_8C6E:
    LDA $68
    STA $91
    LDA $69
    STA $92
    LDA #$00
    STA $90

Bank0_Label_8C7A:
    LDY #$00
    LDA ($91),Y
    BEQ Bank0_Label_8CB9
    CMP $8F
    BCS Bank0_Label_8C96

Bank0_Label_8C84:
    LDA $91
    CLC
    ADC #$03
    STA $91
    LDA $92
    ADC #$00
    STA $92
    INC $90
    JMP Bank0_Label_8C7A

Bank0_Label_8C96:
    CMP $8E
    BCS Bank0_Label_8CB3
    STA $93
    INY
    LDA ($91),Y
    CMP $8D
    BNE Bank0_Label_8C84
    STA $94
    JSR Bank0_Func_8D22
    BNE Bank0_Label_8C84
    INY
    LDA ($91),Y
    JSR Bank0_Func_8DC4
    JMP Bank0_Label_8C84

Bank0_Label_8CB3:
    LDA $90
    CMP #$2D
    BCC Bank0_Label_8C84

Bank0_Label_8CB9:
    RTS

Bank0_Label_8CBA:
    LDA #$FF
    STA $8E
    LDA $5C
    CLC
    ADC #$22
    BCS Bank0_Label_8CC7
    STA $8E

Bank0_Label_8CC7:
    LDA #$00
    STA $8F
    LDA $5C
    SEC
    SBC #$04
    BCC Bank0_Label_8CD4
    STA $8F

Bank0_Label_8CD4:
    LDA $68
    STA $91
    LDA $69
    STA $92
    LDA #$00
    STA $90

Bank0_Label_8CE0:
    LDY #$00
    LDA ($91),Y
    BEQ Bank0_Label_8D21
    CMP $8D
    BEQ Bank0_Label_8CFE
    BCS Bank0_Label_8D1B

Bank0_Label_8CEC:
    LDA $91
    CLC
    ADC #$03
    STA $91
    LDA $92
    ADC #$00
    STA $92
    INC $90
    JMP Bank0_Label_8CE0

Bank0_Label_8CFE:
    STA $93
    INY
    LDA ($91),Y
    CMP $8E
    BCS Bank0_Label_8CEC
    CMP $8F
    BCC Bank0_Label_8CEC
    STA $94
    JSR Bank0_Func_8D22
    BNE Bank0_Label_8CEC
    INY
    LDA ($91),Y
    JSR Bank0_Func_8DC4
    JMP Bank0_Label_8CEC

Bank0_Label_8D1B:
    LDA $90
    CMP #$2D
    BCC Bank0_Label_8CEC

Bank0_Label_8D21:
    RTS

Bank0_Func_8D22:
    LDA $90
    AND #$07
    TAX
    LDA a:$8D9C,X
    STA $07
    LDA $90
    LSR A
    LSR A
    LSR A
    TAX
    LDA a:$0670,X
    AND $07
    STA $06
    LDA a:$0680,X
    AND $07
    ORA $06
    STA $06
    LDA $06
    RTS

Bank0_Func_8D45:
    STA $03
    TXA
    PHA
    LDA $03
    AND #$07
    TAX
    LDA a:$8D9C,X
    PHA
    LDA $03
    LSR A
    LSR A
    LSR A
    TAX
    PLA
    ORA a:$0670,X
    STA a:$0670,X
    PLA
    TAX
    RTS

Bank0_Func_8D62:
    STA $03
    TXA
    PHA
    LDA $03
    AND #$07
    TAX
    LDA a:$8D9C,X
    EOR #$FF
    PHA
    LDA $03
    LSR A
    LSR A
    LSR A
    TAX
    PLA
    AND a:$0670,X
    STA a:$0670,X
    PLA
    TAX
    RTS

Bank0_Func_8D81:
    TXA
    PHA
    LDA $00
    AND #$07
    TAX
    LDA a:$8D9C,X
    PHA
    LDA $00
    LSR A
    LSR A
    LSR A
    TAX
    PLA
    ORA a:$0680,X
    STA a:$0680,X
    PLA
    TAX
    RTS
    .byte $80, $40, $20, $10, $08, $04, $02, $01, $9F, $8E, $32, $DC, $9F, $8E, $9F, $8E
    .byte $9F, $8E, $9F, $8E, $16, $E0, $41, $E1, $9F, $8E, $40, $E2, $9F, $8E, $9F, $8E
    .byte $9F, $8E, $9F, $8E, $9F, $8E, $9F, $8E

Bank0_Func_8DC4:
    PHA
    LDA $93
    STA $06
    LDA $94
    STA $07
    LDA $90
    STA $03
    PLA
    TAY
    BMI Bank0_Label_8E27
    LDX #$00

Bank0_Label_8DD7:
    LDA a:$0400,X
    BEQ Bank0_Label_8DE2
    INX
    CPX #$0A
    BNE Bank0_Label_8DD7
    RTS

Bank0_Label_8DE2:
    LDA $90
    AND #$7F
    STA a:$0520,X
    JSR Bank0_Func_8D45
    TYA
    STA a:$0400,X
    INC a:$0400,X
    LDA a:$8E70,Y
    STA a:$0430,X
    LDA a:$8E80,Y
    STA a:$0460,X
    LDA a:$8E90,Y
    STA a:$05B0,X
    LDA #$00
    STA a:$0550,X
    STA a:$0580,X
    STA a:$05E0,X
    STA a:$0610,X
    STA a:$0640,X
    TYA
    ASL A
    AND #$0F
    TAY
    JMP Bank0_Label_8E1E

Bank0_Label_8E1E:
    LDA a:$8DA5,Y
    PHA
    LDA a:$8DA4,Y
    PHA
    RTS

Bank0_Label_8E27:
    PHA
    JSR Bank0_Func_C988
    BEQ Bank0_Label_8E2F
    PLA
    RTS

Bank0_Label_8E2F:
    PLA
    PHA
    ASL A
    ASL A
    AND #$3F
    TAY
    LDA a:$CC0A,Y
    STA a:$0400,X
    LDA a:$CC0B,Y
    STA a:$0430,X
    BNE Bank0_Label_8E4C
    LDA $7B
    CLC
    ADC #$2A
    STA a:$0430,X

Bank0_Label_8E4C:
    LDA a:$CC0C,Y
    STA a:$0460,X
    PLA
    AND #$40
    BEQ Bank0_Label_8E5F
    LDA a:$0400,X
    ORA #$80
    STA a:$0400,X

Bank0_Label_8E5F:
    LDA $90
    STA a:$0520,X
    JSR Bank0_Func_8D45
    LDA a:$CC0D,Y
    STA a:$0550,X
    JMP Bank0_Label_8EA0
    .byte $64, $5C, $56, $60, $58, $4C, $54, $70, $6C, $3E, $60, $58, $00, $00, $00, $00
    .byte $01, $01, $01, $02, $02, $02, $01, $02, $01, $01, $02, $02, $00, $00, $00, $00
    .byte $02, $01, $02, $04, $01, $01, $02, $01, $02, $04, $04, $01, $00, $00, $00, $00

Bank0_Label_8EA0:
    LDA #$00
    STA a:$0490,X
    LDA $07
    SEC
    SBC $5C
    ASL A
    ASL A
    ROL a:$0490,X
    ASL A
    ROL a:$0490,X
    STA $07
    LDA $1C
    AND #$07
    EOR #$FF
    CLC
    ADC $07
    STA a:$04F0,X
    BCS Bank0_Label_8EC6
    DEC a:$0490,X

Bank0_Label_8EC6:
    LDA $06
    SEC
    SBC $5B
    ASL A
    ASL A
    ROL a:$0490,X
    ASL A
    ROL a:$0490,X
    STA $06
    LDA $1B
    AND #$07
    EOR #$FF
    SEC
    ADC $06
    STA a:$04C0,X
    BCS Bank0_Label_8EF5
    LDA a:$0490,X
    TAY
    AND #$0C
    STA $08
    DEY
    TYA
    AND #$03
    ORA $08
    STA a:$0490,X

Bank0_Label_8EF5:
    RTS

Bank0_Func_8EF6:
    LDA $82
    BNE Bank0_Label_8F46
    LDX #$0A

Bank0_Label_8EFC:
    LDA a:$0400,X
    BEQ Bank0_Label_8F41
    CMP #$01
    BEQ Bank0_Label_8F2A
    CMP #$02
    BEQ Bank0_Label_8F12
    JSR Bank0_Func_8F47
    JSR Bank0_Func_8F47
    JMP Bank0_Label_8F2D

Bank0_Label_8F12:
    JSR Bank0_Func_8F9E
    LDA a:$05B0,X
    BPL Bank0_Label_8F2D
    JSR Bank0_Func_9004
    BEQ Bank0_Label_8F37
    EOR #$FF
    SEC
    ADC #$01
    STA a:$05B0,X
    JMP Bank0_Label_8F37

Bank0_Label_8F2A:
    JSR Bank0_Func_8FC5

Bank0_Label_8F2D:
    JSR Bank0_Func_9004
    BEQ Bank0_Label_8F37
    LDA #$00
    STA a:$0400,X

Bank0_Label_8F37:
    LDA a:$0490,X
    BEQ Bank0_Label_8F41
    LDA #$00
    STA a:$0400,X

Bank0_Label_8F41:
    INX
    CPX #$1E
    BNE Bank0_Label_8EFC

Bank0_Label_8F46:
    RTS

Bank0_Func_8F47:
    LDA #$FF
    STA $95
    STA $96
    LDA a:$0550,X
    TAY
    AND #$04
    BEQ Bank0_Label_8F59
    LDA #$01
    STA $95

Bank0_Label_8F59:
    TYA
    AND #$02
    BEQ Bank0_Label_8F62
    LDA #$01
    STA $96

Bank0_Label_8F62:
    TYA
    AND #$01
    BNE Bank0_Label_8F83
    LDA $95
    JSR Bank0_Func_8A6C
    LDA a:$05B0,X
    CLC
    ADC a:$05E0,X
    STA a:$05B0,X
    BPL Bank0_Label_8F82
    AND #$7F
    STA a:$05B0,X
    LDA $96
    JMP Bank0_Func_8AA6

Bank0_Label_8F82:
    RTS

Bank0_Label_8F83:
    LDA $96
    JSR Bank0_Func_8AA6
    LDA a:$05B0,X
    CLC
    ADC a:$05E0,X
    STA a:$05B0,X
    BPL Bank0_Label_8F82
    AND #$7F
    STA a:$05B0,X
    LDA $95
    JMP Bank0_Func_8A6C

Bank0_Func_8F9E:
    LDA a:$0550,X
    JSR Bank0_Func_8A6C
    INC a:$05E0,X
    LDA a:$05E0,X
    AND #$03
    BNE Bank0_Label_8FBF
    INC a:$05B0,X
    BMI Bank0_Label_8FBF
    LDA a:$05B0,X
    CMP #$09
    BCC Bank0_Label_8FBF
    LDA #$08
    STA a:$05B0,X

Bank0_Label_8FBF:
    LDA a:$05B0,X
    JMP Bank0_Func_8AA6

Bank0_Func_8FC5:
    LDA a:$0550,X
    AND #$07
    ASL A
    STA $01
    LDA $16
    AND #$01
    ORA $01
    PHA
    TAY
    LDA a:$8FE4,Y
    JSR Bank0_Func_8A6C
    PLA
    TAY
    LDA a:$8FF4,Y
    JSR Bank0_Func_8AA6
    RTS
    .byte $00, $00, $01, $01, $02, $01, $01, $00, $00, $00, $FF, $00, $FE, $FF, $FF, $00
    .byte $02, $01, $01, $01, $00, $00, $FF, $00, $FE, $FF, $FF, $00, $00, $00, $01, $00

Bank0_Func_9004:
    LDA a:$0490,X
    STA $A4
    LDA $1B
    AND #$07
    CLC
    ADC #$04
    ADC a:$04C0,X
    STA $A0
    LDA $A4
    ADC #$00
    LSR A
    ROR $A0
    LSR A
    ROR $A0
    LDA $A0
    AND #$80
    LSR $A0
    ORA $A0
    CLC
    ADC $5B
    STA $A0
    LDA a:$0490,X
    LSR A
    LSR A
    STA $A4
    LDA $1C
    AND #$07
    CLC
    ADC #$04
    ADC a:$04F0,X
    STA $A2
    LDA $A4
    ADC #$00
    LSR A
    ROR $A2
    LSR A
    ROR $A2
    LDA $A2
    AND #$80
    LSR $A2
    ORA $A2
    CLC
    ADC $5C
    STA $A2
    STX $A4
    LDX $A0
    LDY $A2
    JSR Bank0_Func_A6A7
    LDX $A4
    LDA a:$DADA,Y
    RTS
    .byte $20, $87, $89, $85, $AA, $20, $E3, $91, $BD, $0A, $04, $D0, $3D, $20, $2F, $96
    .byte $C9, $08, $B0, $36, $A9, $01, $9D, $0A, $04, $A9, $33, $9D, $3A, $04, $BD, $90
    .byte $04, $9D, $9A, $04, $A9, $81, $9D, $6A, $04, $BD, $C0, $04, $18, $69, $04, $9D
    .byte $CA, $04, $BD, $F0, $04, $18, $69, $04, $9D, $FA, $04, $A9, $FF, $9D, $2A, $05
    .byte $A5, $AA, $9D, $5A, $05, $A9, $02, $9D, $8A, $05, $60, $A0, $0A, $B9, $0A, $04
    .byte $F0, $07, $C8, $C0, $14, $D0, $F6, $38, $60, $20, $E3, $91, $A9, $02, $99, $0A
    .byte $04, $A9, $32, $99, $3A, $04, $A9, $01, $99, $6A, $04, $BD, $90, $04, $99, $9A
    .byte $04, $BD, $C0, $04, $18, $69, $04, $99, $CA, $04, $BD, $F0, $04, $18, $69, $04
    .byte $99, $FA, $04, $A9, $FF, $99, $2A, $05, $8A, $48, $20, $2F, $96, $29, $0F, $AA
    .byte $BD, $16, $91, $99, $5A, $05, $20, $2F, $96, $4A, $4A, $29, $07, $AA, $BD, $26
    .byte $91, $99, $BA, $05, $A9, $00, $99, $EA, $05, $A9, $01, $99, $8A, $05, $68, $AA
    .byte $60, $FC, $FD, $FE, $FF, $00, $01, $02, $03, $FF, $FE, $FF, $00, $01, $02, $04
    .byte $01, $F9, $FA, $FB, $FC, $FC, $FD, $FD, $FE, $38, $60, $BD, $0A, $04, $D0, $F9
    .byte $20, $E3, $91, $A9, $00, $85, $AD, $BD, $C0, $04, $38, $E5, $75, $B0, $07, $E6
    .byte $AD, $49, $FF, $18, $69, $01, $85, $AA, $06, $AD, $BD, $F0, $04, $38, $E5, $76
    .byte $B0, $07, $E6, $AD, $49, $FF, $18, $69, $01, $85, $AB, $06, $AD, $C5, $AA, $90
    .byte $0C, $A5, $AA, $85, $AE, $A5, $AB, $85, $B0, $E6, $AD, $D0, $08, $A5, $AA, $85
    .byte $B0, $A5, $AB, $85, $AE, $20, $BF, $91, $A9, $03, $9D, $0A, $04, $A9, $31, $9D
    .byte $3A, $04, $A9, $01, $9D, $6A, $04, $BD, $90, $04, $9D, $9A, $04, $BD, $C0, $04
    .byte $18, $69, $04, $9D, $CA, $04, $BD, $F0, $04, $18, $69, $04, $9D, $FA, $04, $A9
    .byte $FF, $9D, $2A, $05, $A5, $AD, $9D, $5A, $05, $A9, $01, $9D, $8A, $05, $A9, $00
    .byte $9D, $BA, $05, $A5, $AF, $9D, $EA, $05, $18, $60, $A9, $00, $85, $AF, $A9, $08
    .byte $85, $B1, $A5, $AE, $38, $E5, $B0, $90, $0D, $26, $AF, $2A, $C6, $B1, $D0, $F4
    .byte $60, $18, $65, $B0, $B0, $F3, $26, $AF, $2A, $C6, $B1, $D0, $F4, $60, $BD, $90
    .byte $04, $29, $0F, $D0, $13, $BD, $C0, $04, $C9, $F5, $B0, $0C, $BD, $F0, $04, $C9
    .byte $08, $90, $05, $C9, $E4, $B0, $01, $60, $68, $68, $38, $60

Bank0_Func_9201:
    LDA #$00
    STA $95

Bank0_Label_9205:
    LDX $95
    LDA a:$041E,X
    BEQ Bank0_Label_9250
    BMI Bank0_Label_9250
    TAY
    LDA a:$9317,Y
    STA $02
    LDA a:$04DE,X
    STA $00
    LDA a:$050E,X
    STA $01
    LDA #$00
    STA $96

Bank0_Label_9222:
    LDY $96
    LDX $95
    LDA a:$0426,Y
    BEQ Bank0_Label_9230
    BPL Bank0_Label_9230
    JSR Bank0_Func_C9E1

Bank0_Label_9230:
    INC $96
    LDY $96
    CPY #$0A
    BNE Bank0_Label_9222
    LDA #$00
    STA $96

Bank0_Label_923C:
    LDY $96
    LDX $95
    LDA a:$0400,Y
    BEQ Bank0_Label_9248
    JSR Bank0_Func_925A

Bank0_Label_9248:
    INC $96
    LDY $96
    CPY #$0A
    BNE Bank0_Label_923C

Bank0_Label_9250:
    INC $95
    LDA $95
    CMP #$08
    BNE Bank0_Label_9205
    RTS

Bank0_Label_9259:
    RTS

Bank0_Func_925A:
    CMP #$C0
    BCS Bank0_Label_9259
    CMP #$0F
    BEQ Bank0_Label_9259
    AND #$1F
    TAX
    LDA a:$0490,Y
    AND #$0F
    BNE Bank0_Label_9259
    LDA $00
    SEC
    SBC a:$04C0,Y
    BCS Bank0_Label_927A
    CLC
    ADC $02
    BCS Bank0_Label_927F
    RTS

Bank0_Label_927A:
    CMP a:$92F9,X
    BCS Bank0_Label_9259

Bank0_Label_927F:
    LDA $01
    SEC
    SBC a:$04F0,Y
    BCS Bank0_Label_928D
    CLC
    ADC $02
    BCS Bank0_Label_9292
    RTS

Bank0_Label_928D:
    CMP a:$9308,X
    BCS Bank0_Label_9259

Bank0_Label_9292:
    LDX $95
    LDA a:$041E,X
    CMP #$03
    BEQ Bank0_Label_92AD
    LDA a:$04DE,X
    SEC
    SBC #$04
    STA a:$04DE,X
    LDA a:$050E,X
    SEC
    SBC #$04
    STA a:$050E,X

Bank0_Label_92AD:
    LDA a:$0400,Y
    BMI Bank0_Label_92EB
    LDA a:$041E,X
    AND #$07
    STA $04
    LDA a:$05B0,Y
    SEC
    SBC $04
    STA a:$05B0,Y
    BCC Bank0_Label_92D3
    LDA a:$0400,Y
    ORA #$80
    STA a:$0400,Y
    LDA #$00
    STA a:$05E0,Y
    BEQ Bank0_Label_92EB

Bank0_Label_92D3:
    LDA #$00
    STA a:$05E0,Y
    LDA a:$0400,Y
    ORA #$C0
    STA a:$0400,Y
    LDA #$05
    JSR Bank0_Func_E398
    JSR Bank0_Func_9462
    JMP Bank0_Label_92F0

Bank0_Label_92EB:
    LDA #$03
    JSR Bank0_Func_E398

Bank0_Label_92F0:
    LDA #$80
    STA a:$041E,X
    PLA
    PLA
    JMP Bank0_Label_9250
    .byte $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $24, $0C, $0C
    .byte $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $28, $0C, $04, $08
    .byte $0C

Bank0_Func_931B:
    LDA #$00
    STA $81
    STA $80
    LDA $79
    BNE Bank0_Label_9363
    LDA #$00
    STA $95

Bank0_Label_9329:
    LDX $95
    LDA a:$040A,X
    BEQ Bank0_Label_933C
    BMI Bank0_Label_933C
    LDA a:$049A,X
    AND #$0F
    BNE Bank0_Label_933C
    JSR Bank0_Func_9383

Bank0_Label_933C:
    INC $95
    LDX $95
    CPX #$14
    BNE Bank0_Label_9329
    LDA #$00
    STA $95

Bank0_Label_9348:
    LDX $95
    LDA a:$0400,X
    BEQ Bank0_Label_935B
    BMI Bank0_Label_935B
    LDA a:$0490,X
    AND #$0F
    BNE Bank0_Label_935B
    JSR Bank0_Func_93D4

Bank0_Label_935B:
    INC $95
    LDX $95
    CPX #$0A
    BNE Bank0_Label_9348

Bank0_Label_9363:
    LDA #$00
    STA $95

Bank0_Label_9367:
    LDX $95
    LDA a:$0426,X
    BEQ Bank0_Label_937A
    BMI Bank0_Label_937A
    LDA a:$04B6,X
    AND #$0F
    BNE Bank0_Label_937A
    JSR Bank0_Func_C998

Bank0_Label_937A:
    INC $95
    LDX $95
    CPX #$0A
    BNE Bank0_Label_9367
    RTS

Bank0_Func_9383:
    LDA $75
    SEC
    SBC a:$04CA,X
    BCS Bank0_Label_9391
    CMP #$F4
    BCC Bank0_Label_93D3
    BCS Bank0_Label_9395

Bank0_Label_9391:
    CMP #$05
    BCS Bank0_Label_93D3

Bank0_Label_9395:
    LDA $76
    SEC
    SBC a:$04FA,X
    BCS Bank0_Label_93A3
    CMP #$E4
    BCC Bank0_Label_93D3
    BCS Bank0_Label_93A7

Bank0_Label_93A3:
    CMP #$04
    BCS Bank0_Label_93D3

Bank0_Label_93A7:
    LDA $B2
    BNE Bank0_Label_93CE
    LDA $82
    BNE Bank0_Label_93D3
    LDA #$0F
    JSR Bank0_Func_E398
    LDA #$01
    STA $79
    LDA a:$058A,X
    STA $00
    LDA $2B
    SEC
    SBC $00
    BCS Bank0_Label_93CA
    LDA #$80
    STA $79
    LDA #$00

Bank0_Label_93CA:
    STA $2B
    PLA
    PLA

Bank0_Label_93CE:
    LDA #$00
    STA a:$040A,X

Bank0_Label_93D3:
    RTS

Bank0_Func_93D4:
    LDA a:$0400,X
    CMP #$0F
    BEQ Bank0_Label_942A
    AND #$3F
    TAY
    DEY
    LDA $75
    SEC
    SBC a:$04C0,X
    BCS Bank0_Label_93ED
    CMP #$F4
    BCC Bank0_Label_942A
    BCS Bank0_Label_93F2

Bank0_Label_93ED:
    CMP a:$9442,Y
    BCS Bank0_Label_942A

Bank0_Label_93F2:
    LDA $76
    SEC
    SBC a:$04F0,X
    BCS Bank0_Label_9400
    CMP #$EC
    BCC Bank0_Label_942A
    BCS Bank0_Label_9405

Bank0_Label_9400:
    CMP a:$9452,Y
    BCS Bank0_Label_942A

Bank0_Label_9405:
    LDA $B2
    BNE Bank0_Label_942B
    LDA $82
    BNE Bank0_Label_942A
    LDA #$0F
    JSR Bank0_Func_E398
    LDA #$01
    STA $79
    LDA $2B
    CLC
    SBC a:$05B0,X
    STA $2B
    BPL Bank0_Label_9428
    LDA #$80
    STA $79
    LDA #$00
    STA $2B

Bank0_Label_9428:
    PLA
    PLA

Bank0_Label_942A:
    RTS

Bank0_Label_942B:
    LDA #$00
    STA a:$05E0,X
    LDA a:$0400,X
    ORA #$C0
    STA a:$0400,X
    LDA #$05
    JSR Bank0_Func_E398
    TXA
    TAY
    JMP Bank0_Func_9462
    .byte $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $2C, $0C, $0C
    .byte $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $1E, $0C, $0C

Bank0_Func_9462:
    TXA
    PHA
    TYA
    PHA
    LDX $B3
    LDA a:$0400,Y
    AND #$3F
    CMP a:$94D9,X
    BNE Bank0_Label_947F
    INC $B3
    LDA $B3
    CMP #$06
    BNE Bank0_Label_9483
    LDA #$04
    JMP Bank0_Label_9494

Bank0_Label_947F:
    LDA #$00
    STA $B3

Bank0_Label_9483:
    INC $98
    LDA $98
    CMP #$04
    BCC Bank0_Label_94CF
    LDA #$00
    STA $98
    JSR Bank0_Func_962F
    AND #$03

Bank0_Label_9494:
    TAX
    LDA a:$94D4,X
    STA $00
    BEQ Bank0_Label_94CF
    JSR Bank0_Func_C988
    BNE Bank0_Label_94CF
    LDA a:$0490,Y
    STA a:$0490,X
    LDA a:$04C0,Y
    STA a:$04C0,X
    LDA a:$04F0,Y
    STA a:$04F0,X
    LDA #$FF
    STA a:$0520,X
    LDA $00
    ASL A
    ASL A
    TAY
    LDA a:$CC0A,Y
    STA a:$0400,X
    LDA a:$CC0B,Y
    STA a:$0430,X
    LDA a:$CC0C,Y
    STA a:$0460,X

Bank0_Label_94CF:
    PLA
    TAY
    PLA
    TAX
    RTS
    .byte $06, $0A, $0B, $02, $0C, $06, $06, $05, $04, $01, $06, $06, $A2, $15, $CA, $D0
    .byte $FD, $EA, $EA, $88, $D0, $F6, $60

Bank0_Func_94EB:
    LDA a:$0180
    BNE Bank0_Func_94EB
    RTS

Bank0_Func_94F1:
    LDA $16

Bank0_Label_94F3:
    CMP $16
    BEQ Bank0_Label_94F3
    RTS

Bank0_Func_94F8:
    LDA #$00
    PHA
    LDA $19
    AND #$FB
    STA a:$2000
    LDA #$20
    STA a:$2006
    LDA #$00
    STA a:$2006
    LDY #$00
    LDX #$10
    PLA

Bank0_Label_9511:
    STA a:$2007
    DEY
    BNE Bank0_Label_9511
    DEX
    BNE Bank0_Label_9511
    RTS

Bank0_Func_951B:
    LDX #$00
    LDA #$00

Bank0_Label_951F:
    STA a:$06B0,X
    INX
    CPX #$80
    BNE Bank0_Label_951F
    RTS
    .byte $A0, $00, $B1, $00, $99, $10, $02, $C8, $C0, $20, $D0, $F6, $60

Bank0_Func_9535:
    LDA $14
    BNE Bank0_Label_955C
    JSR Bank0_WaitForVblank
    LDA $19
    AND #$FB
    STA a:$2000
    LDA #$3F
    STA a:$2006
    LDA #$00
    STA a:$2006
    LDX #$00
    LDY #$20

Bank0_Label_9551:
    LDA a:$0210,X
    STA a:$2007
    INX
    DEY
    BNE Bank0_Label_9551
    RTS

Bank0_Label_955C:
    JSR Bank0_Func_94EB
    LDY #$00
    LDX #$20
    LDA #$3F
    STA a:$0181
    LDA #$00
    STA a:$0182
    LDA #$20
    STA a:$0183

Bank0_Label_9572:
    LDA a:$0210,Y
    STA a:$0184,Y
    INY
    DEX
    BNE Bank0_Label_9572
    LDA #$00
    STA a:$0184,Y
    LDA #$01
    STA a:$0180
    RTS
    .byte $A5, $19, $29, $FB, $85, $19, $8D, $00, $20, $A0, $00, $B1, $00, $F0, $34, $8D
    .byte $06, $20, $C8, $B1, $00, $8D, $06, $20, $C8, $B1, $00, $AA, $C8, $48, $98, $A0
    .byte $00, $18, $65, $00, $85, $00, $90, $02, $E6, $01, $B1, $00, $8D, $07, $20, $C8
    .byte $CA, $D0, $F7, $68, $F0, $08, $98, $18, $65, $00, $85, $00, $90, $CB, $E6, $01
    .byte $4C, $90, $95, $60

Bank0_Func_95CB:
    LDA $65
    AND #$10
    BEQ Bank0_Label_95EC
    LDA #$01
    STA a:$02AB
    LDA #$06
    JSR Bank0_Func_E3BC

Bank0_Label_95DB:
    JSR Bank0_Func_94F1
    JSR Bank0_Func_8490
    LDA $65
    AND #$10
    BEQ Bank0_Label_95DB
    LDA #$00
    STA a:$02AB

Bank0_Label_95EC:
    RTS

Bank0_Func_95ED:
    JSR Bank0_Func_8131
    JSR Bank0_WaitForVblank
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
    JSR Bank0_Func_94F1
    LDA $1A
    ORA #$18
    STA $1A
    RTS

Bank0_Func_9614:
    LDA $19
    ORA #$80
    STA $19
    STA a:$2000
    LDA $1A
    AND #$E7
    STA $1A
    LDA #$01
    STA $14
    JSR Bank0_Func_94F1
    LDA #$00
    STA $14
    RTS

Bank0_Func_962F:
    INC $53
    DEC $52
    LDA $16
    EOR #$F0
    EOR $52
    STA $52
    LDA $16
    EOR #$AA
    ROR A
    ROR A
    ROR A
    EOR $53
    STA $53
    ROR A
    EOR $52
    RTS

Bank0_Func_964A:
    LDA $54
    ROL A
    ROL A
    EOR #$41
    ROL A
    ROL A
    EOR #$93
    ADC $55
    STA $54
    ROL A
    ROL A
    EOR #$12
    ROL A
    ROL A
    ADC $56
    STA $55
    ADC $54
    INC $56
    BNE Bank0_Label_9671
    PHA
    LDA $57
    CLC
    ADC #$1D
    STA $57
    PLA

Bank0_Label_9671:
    EOR $57
    RTS

Bank0_Func_9674:
    LDA $16
    AND #$01
    BNE Bank0_Label_968D
    JSR Bank0_Func_96BC
    JSR Bank0_Func_96A0
    JSR Bank0_Func_98C8
    JSR Bank0_Func_986A
    JSR Bank0_Func_978F
    JSR Bank0_Func_9801
    RTS

Bank0_Label_968D:
    JSR Bank0_Func_96A0
    JSR Bank0_Func_9801
    JSR Bank0_Func_978F
    JSR Bank0_Func_986A
    JSR Bank0_Func_98C8
    JSR Bank0_Func_96BC
    RTS

Bank0_Func_96A0:
    LDA $79
    LDA $75
    STA $45
    LDA $76
    STA $47
    LDA #$00
    STA $46
    STA $48
    LDA $77
    STA $49
    LDA $78
    STA $4A
    JSR Bank0_Func_992A
    RTS

Bank0_Func_96BC:
    LDY #$00
    LDA #$5C
    STA $44
    LDA #$18
    STA $41
    LDA #$00
    STA $43

Bank0_Label_96CA:
    LDA a:$0298,Y
    BNE Bank0_Label_96DB
    LDA $44
    CLC
    ADC #$08
    STA $44
    INY
    CPY #$06
    BNE Bank0_Label_96CA

Bank0_Label_96DB:
    LDA a:$0298,Y
    AND #$0F
    ORA #$30
    STA $42
    JSR Bank0_Func_9B35
    LDA $44
    CLC
    ADC #$08
    STA $44
    INY
    CPY #$07
    BNE Bank0_Label_96DB
    LDA #$32
    STA $41
    LDA #$E6
    STA $44
    LDA #$00
    STA $43
    LDA #$3A
    STA $42
    JSR Bank0_Func_9B35
    LDA #$F0
    STA $44
    LDA $2A
    AND #$0F
    ORA #$30
    STA $42
    JSR Bank0_Func_9B35
    LDA $2C
    ASL A
    ASL A
    CLC
    ADC #$50
    STA $41
    LDA #$EC
    STA $44
    LDA #$00
    STA $43
    LDA #$04
    STA $0A
    LDA $2B
    STA $42
    LDY #$07

Bank0_Label_9730:
    LDA $42
    SEC
    SBC #$04
    BCC Bank0_Label_9743
    STA $42
    LDA #$3F
    STA a:$000A,Y
    DEY
    BPL Bank0_Label_9730
    BMI Bank0_Label_9754

Bank0_Label_9743:
    CLC
    ADC #$3F
    STA a:$000A,Y
    DEY
    BMI Bank0_Label_9754
    LDA #$3B

Bank0_Label_974E:
    STA a:$000A,Y
    DEY
    BPL Bank0_Label_974E

Bank0_Label_9754:
    LDY $2C

Bank0_Label_9756:
    LDA a:$000A,Y
    STA $42
    JSR Bank0_Func_9B35
    LDA $41
    CLC
    ADC #$08
    STA $41
    INY
    CPY #$08
    BNE Bank0_Label_9756
    LDA $16
    AND #$10
    BEQ Bank0_Label_978E
    LDA #$E8
    STA $45
    LDA #$96
    STA $47
    LDA #$00
    STA $46
    STA $48
    LDA $7B
    BEQ Bank0_Label_978E
    CLC
    ADC #$29
    STA $49
    LDA #$01
    STA $4A
    JSR Bank0_Func_992A

Bank0_Label_978E:
    RTS

Bank0_Func_978F:
    LDA $82
    BEQ Bank0_Label_979A
    LDA $16
    AND #$04
    BEQ Bank0_Label_979A
    RTS

Bank0_Label_979A:
    LDA $16
    AND #$01
    BNE Bank0_Label_97BB
    LDA #$00
    STA $0A

Bank0_Label_97A4:
    LDY $0A
    LDA a:$0400,Y
    BEQ Bank0_Label_97B2
    JSR Bank0_Func_97D2
    LDA $50
    BMI Bank0_Label_97D1

Bank0_Label_97B2:
    INC $0A
    LDA $0A
    CMP #$0A
    BNE Bank0_Label_97A4
    RTS

Bank0_Label_97BB:
    LDA #$09
    STA $0A

Bank0_Label_97BF:
    LDY $0A
    LDA a:$0400,Y
    BEQ Bank0_Label_97CD
    JSR Bank0_Func_97D2
    LDA $50
    BMI Bank0_Label_97D1

Bank0_Label_97CD:
    DEC $0A
    BPL Bank0_Label_97BF

Bank0_Label_97D1:
    RTS

Bank0_Func_97D2:
    LDA a:$0400,Y
    CMP #$D0
    BCC Bank0_Label_97E0
    LDA $16
    AND #$04
    BEQ Bank0_Label_97E0
    RTS

Bank0_Label_97E0:
    LDA a:$0490,Y
    STA $46
    LSR A
    LSR A
    STA $48
    LDA a:$04C0,Y
    STA $45
    LDA a:$04F0,Y
    STA $47
    LDA a:$0460,Y
    STA $4A
    LDA a:$0430,Y
    STA $49
    JSR Bank0_Func_992A
    RTS

Bank0_Func_9801:
    LDA $82
    BEQ Bank0_Label_980C
    LDA $16
    AND #$04
    BNE Bank0_Label_980C
    RTS

Bank0_Label_980C:
    LDA #$00
    STA $46
    STA $48
    LDA $16
    AND #$01
    BNE Bank0_Label_9833
    LDA #$00
    STA $0A

Bank0_Label_981C:
    LDY $0A
    LDA a:$040A,Y
    BEQ Bank0_Label_982A
    JSR Bank0_Func_984A
    LDA $50
    BMI Bank0_Label_9849

Bank0_Label_982A:
    INC $0A
    LDA $0A
    CMP #$14
    BNE Bank0_Label_981C
    RTS

Bank0_Label_9833:
    LDA #$13
    STA $0A

Bank0_Label_9837:
    LDY $0A
    LDA a:$040A,Y
    BEQ Bank0_Label_9845
    JSR Bank0_Func_984A
    LDA $50
    BMI Bank0_Label_9849

Bank0_Label_9845:
    DEC $0A
    BPL Bank0_Label_9837

Bank0_Label_9849:
    RTS

Bank0_Func_984A:
    LDA a:$049A,Y
    STA $46
    LSR A
    LSR A
    STA $48
    LDA a:$04CA,Y
    STA $45
    LDA a:$04FA,Y
    STA $47
    LDA a:$046A,Y
    STA $4A
    LDA a:$043A,Y
    STA $49
    JMP Bank0_Func_992A

Bank0_Func_986A:
    LDA #$00
    STA $46
    STA $48
    LDA $16
    AND #$01
    BNE Bank0_Label_9891
    LDA #$00
    STA $0A

Bank0_Label_987A:
    LDY $0A
    LDA a:$041E,Y
    BEQ Bank0_Label_9888
    JSR Bank0_Func_98A8
    LDA $50
    BMI Bank0_Label_98A7

Bank0_Label_9888:
    INC $0A
    LDA $0A
    CMP #$08
    BNE Bank0_Label_987A
    RTS

Bank0_Label_9891:
    LDA #$07
    STA $0A

Bank0_Label_9895:
    LDY $0A
    LDA a:$041E,Y
    BEQ Bank0_Label_98A3
    JSR Bank0_Func_98A8
    LDA $50
    BMI Bank0_Label_98A7

Bank0_Label_98A3:
    DEC $0A
    BPL Bank0_Label_9895

Bank0_Label_98A7:
    RTS

Bank0_Func_98A8:
    LDA a:$04AE,Y
    STA $46
    LSR A
    LSR A
    STA $48
    LDA a:$04DE,Y
    STA $45
    LDA a:$050E,Y
    STA $47
    LDA a:$047E,Y
    STA $4A
    LDA a:$044E,Y
    STA $49
    JMP Bank0_Func_992A

Bank0_Func_98C8:
    LDA #$00
    STA $46
    STA $48
    LDA $16
    AND #$01
    BNE Bank0_Label_98F1
    LDA #$00
    STA $0A

Bank0_Label_98D8:
    LDY $0A
    LDA a:$0426,Y
    BMI Bank0_Label_98E8
    BEQ Bank0_Label_98E8
    JSR Bank0_Func_990A
    LDA $50
    BMI Bank0_Label_9909

Bank0_Label_98E8:
    INC $0A
    LDA $0A
    CMP #$0A
    BNE Bank0_Label_98D8
    RTS

Bank0_Label_98F1:
    LDA #$09
    STA $0A

Bank0_Label_98F5:
    LDY $0A
    LDA a:$0426,Y
    BMI Bank0_Label_9905
    BEQ Bank0_Label_9905
    JSR Bank0_Func_990A
    LDA $50
    BMI Bank0_Label_9909

Bank0_Label_9905:
    DEC $0A
    BPL Bank0_Label_98F5

Bank0_Label_9909:
    RTS

Bank0_Func_990A:
    LDA a:$04B6,Y
    STA $46
    LSR A
    LSR A
    STA $48
    LDA a:$04E6,Y
    STA $45
    LDA a:$0516,Y
    STA $47
    LDA a:$0486,Y
    STA $4A
    LDA a:$0456,Y
    STA $49
    JMP Bank0_Func_992A

Bank0_Func_992A:
    LDA $4A
    AND #$40
    BEQ Bank0_Label_9937
    LDA $16
    AND #$01
    BEQ Bank0_Label_9937
    RTS

Bank0_Label_9937:
    LDA $4A
    BPL Bank0_Label_9945
    LDA $16
    AND #$08
    BEQ Bank0_Label_9945
    LSR $4A
    LSR $4A

Bank0_Label_9945:
    LDX $49
    TXA
    ASL A
    TAY
    LDA #$00
    ADC #$9C
    STA $4C
    LDA #$B6
    STA $4B
    INY
    LDA ($4B),Y
    CMP #$04
    BCS Bank0_Label_999D
    PHA
    DEY
    LDA ($4B),Y
    TAX
    ASL A
    TAY
    LDA #$00
    ADC #$9C
    STA $4C
    LDA #$B6
    STA $4B
    LDA ($4B),Y
    PHA
    INY
    LDA ($4B),Y
    STA $4C
    PLA
    STA $4B
    LDY #$00
    LDA ($4B),Y
    INY
    STA $4F
    LDA ($4B),Y
    INY
    STA $4D
    LDA ($4B),Y
    INY
    STA $4E
    PLA
    BEQ Bank0_Label_9994
    CMP #$02
    BEQ Bank0_Label_999A
    BCC Bank0_Label_9997
    JMP Bank0_Label_9ACB

Bank0_Label_9994:
    JMP Bank0_Label_99AF

Bank0_Label_9997:
    JMP Bank0_Label_9A69

Bank0_Label_999A:
    JMP Bank0_Label_9A07

Bank0_Label_999D:
    PHA
    DEY
    LDA ($4B),Y
    STA $4B
    PLA
    STA $4C
    LDY #$00
    LDA ($4B),Y
    INY
    STA $4F
    INY
    INY

Bank0_Label_99AF:
    LDA $50
    BMI Bank0_Label_9A06
    LDA ($4B),Y
    INY
    TAX
    AND #$7F
    CLC
    ADC $47
    STA $41
    LDA $48
    ADC #$00
    AND #$03
    BNE Bank0_Label_99FF
    LDA $41
    CMP #$F0
    BCS Bank0_Label_99FF
    TXA
    AND #$80
    STA $43
    LDA ($4B),Y
    INY
    TAX
    AND #$7F
    CLC
    ADC $45
    STA $44
    LDA $46
    ADC #$00
    AND #$03
    BNE Bank0_Label_9A00
    TXA
    AND #$80
    LSR A
    ORA $43
    STA $43
    LDA ($4B),Y
    INY
    STA $42
    LDA $4A
    AND #$03
    ORA $43
    STA $43
    JSR Bank0_Func_9B35
    JMP Bank0_Label_9A01

Bank0_Label_99FF:
    INY

Bank0_Label_9A00:
    INY

Bank0_Label_9A01:
    DEC $4F
    BNE Bank0_Label_99AF
    CLC

Bank0_Label_9A06:
    RTS

Bank0_Label_9A07:
    LDA $50
    BMI Bank0_Label_9A68
    LDA ($4B),Y
    INY
    TAX
    AND #$7F
    SEC
    SBC $4E
    EOR #$FF
    CLC
    ADC #$01
    CLC
    ADC $47
    STA $41
    LDA $48
    ADC #$00
    AND #$03
    BNE Bank0_Label_9A61
    LDA $41
    CMP #$F0
    BCS Bank0_Label_9A61
    TXA
    AND #$80
    STA $43
    LDA ($4B),Y
    INY
    TAX
    AND #$7F
    CLC
    ADC $45
    STA $44
    LDA $46
    ADC #$00
    AND #$03
    BNE Bank0_Label_9A62
    TXA
    AND #$80
    LSR A
    ORA $43
    STA $43
    LDA ($4B),Y
    INY
    STA $42
    LDA $4A
    AND #$03
    ORA $43
    EOR #$80
    STA $43
    JSR Bank0_Func_9B35
    JMP Bank0_Label_9A63

Bank0_Label_9A61:
    INY

Bank0_Label_9A62:
    INY

Bank0_Label_9A63:
    DEC $4F
    BNE Bank0_Label_9A07
    CLC

Bank0_Label_9A68:
    RTS

Bank0_Label_9A69:
    LDA $50
    BMI Bank0_Label_9ACA
    LDA ($4B),Y
    INY
    TAX
    AND #$7F
    CLC
    ADC $47
    STA $41
    LDA $48
    ADC #$00
    AND #$03
    BNE Bank0_Label_9AC3
    LDA $41
    CMP #$F0
    BCS Bank0_Label_9AC3
    TXA
    AND #$80
    STA $43
    LDA ($4B),Y
    INY
    TAX
    AND #$7F
    SEC
    SBC $4D
    EOR #$FF
    CLC
    ADC #$01
    CLC
    ADC $45
    STA $44
    LDA $46
    ADC #$00
    AND #$03
    BNE Bank0_Label_9AC4
    TXA
    AND #$80
    LSR A
    ORA $43
    STA $43
    LDA ($4B),Y
    INY
    STA $42
    LDA $4A
    AND #$03
    ORA $43
    EOR #$40
    STA $43
    JSR Bank0_Func_9B35
    JMP Bank0_Label_9AC5

Bank0_Label_9AC3:
    INY

Bank0_Label_9AC4:
    INY

Bank0_Label_9AC5:
    DEC $4F
    BNE Bank0_Label_9A69
    CLC

Bank0_Label_9ACA:
    RTS

Bank0_Label_9ACB:
    LDA $50
    BMI Bank0_Label_9B34
    LDA ($4B),Y
    INY
    TAX
    AND #$7F
    SEC
    SBC $4E
    EOR #$FF
    CLC
    ADC #$01
    CLC
    ADC $47
    STA $41
    LDA $48
    ADC #$00
    AND #$03
    BNE Bank0_Label_9B2D
    LDA $41
    CMP #$F0
    BCS Bank0_Label_9B2D
    TXA
    AND #$80
    STA $43
    LDA ($4B),Y
    INY
    TAX
    AND #$7F
    SEC
    SBC $4D
    EOR #$FF
    CLC
    ADC #$01
    CLC
    ADC $45
    STA $44
    LDA $46
    ADC #$00
    AND #$03
    BNE Bank0_Label_9B2E
    TXA
    AND #$80
    LSR A
    ORA $43
    STA $43
    LDA ($4B),Y
    INY
    STA $42
    LDA $4A
    AND #$03
    ORA $43
    EOR #$C0
    STA $43
    JSR Bank0_Func_9B35
    JMP Bank0_Label_9B2F

Bank0_Label_9B2D:
    INY

Bank0_Label_9B2E:
    INY

Bank0_Label_9B2F:
    DEC $4F
    BNE Bank0_Label_9ACB
    CLC

Bank0_Label_9B34:
    RTS

Bank0_Func_9B35:
    LDA $50
    BMI Bank0_Label_9B53
    ASL A
    TAX
    LDA $41
    STA a:$0300,X
    LDA $42
    STA a:$0301,X
    LDA $43
    STA a:$0302,X
    LDA $44
    STA a:$0303,X
    INC $50
    INC $50

Bank0_Label_9B53:
    RTS

Bank0_Func_9B54:
    LDX #$00

Bank0_Label_9B56:
    LDA a:$041E,X
    BEQ Bank0_Label_9BBD
    BPL Bank0_Label_9B7A
    AND #$7F
    LSR A
    LSR A
    CMP #$04
    BCS Bank0_Label_9B72
    AND #$03
    ORA #$20
    STA a:$044E,X
    INC a:$041E,X
    JMP Bank0_Label_9BBD

Bank0_Label_9B72:
    LDA #$00
    STA a:$041E,X
    JMP Bank0_Label_9BBD

Bank0_Label_9B7A:
    LDA a:$056E,X
    ASL A
    TAY
    LDA a:$9BC3,Y
    CLC
    ADC a:$04DE,X
    CMP #$F8
    BCS Bank0_Label_9BB8
    STA a:$04DE,X
    LDA a:$9BC4,Y
    CLC
    ADC a:$050E,X
    CMP #$08
    BCC Bank0_Label_9BB8
    CMP #$E0
    BCS Bank0_Label_9BB8
    STA a:$050E,X
    LDA #$04
    STA $00
    CMP #$03
    BNE Bank0_Label_9BAB
    LDA #$08
    STA $00

Bank0_Label_9BAB:
    JSR Bank0_Func_9BCB
    BEQ Bank0_Label_9BBD
    LDA #$80
    STA a:$041E,X
    JMP Bank0_Label_9BBD

Bank0_Label_9BB8:
    LDA #$00
    STA a:$041E,X

Bank0_Label_9BBD:
    INX
    CPX #$08
    BNE Bank0_Label_9B56
    RTS
    .byte $00, $04, $00, $FC, $FC, $00, $04, $00

Bank0_Func_9BCB:
    LDA $1B
    AND #$07
    CLC
    ADC $00
    ADC a:$04DE,X
    LSR A
    LSR A
    LSR A
    ADC $5B
    STA $A0
    LDA $1C
    AND #$07
    CLC
    ADC $00
    ADC a:$050E,X
    LSR A
    LSR A
    LSR A
    ADC $5C
    STA $A2
    STX $A4
    LDX $A0
    LDY $A2
    JSR Bank0_Func_A6A7
    LDX $A4
    LDA a:$DADA,Y
    RTS

Bank0_Func_9BFC:
    LDA $63
    BEQ Bank0_Label_9C02
    DEC $63

Bank0_Label_9C02:
    LDA $79
    BEQ Bank0_Label_9C0A
    CMP #$06
    BCC Bank0_Label_9C10

Bank0_Label_9C0A:
    LDA $65
    AND #$40
    BNE Bank0_Label_9C11

Bank0_Label_9C10:
    RTS

Bank0_Label_9C11:
    LDA $7B
    BEQ Bank0_Label_9C10
    LDX #$00

Bank0_Label_9C17:
    LDA a:$041E,X
    BEQ Bank0_Label_9C26
    CPX $84
    BEQ Bank0_Label_9C25
    INX
    CPX #$08
    BNE Bank0_Label_9C17

Bank0_Label_9C25:
    RTS

Bank0_Label_9C26:
    LDY $7B
    LDA a:$9C82,Y
    JSR Bank0_Func_E398
    LDA $7B
    SEC
    SBC #$01
    ASL A
    ASL A
    ASL A
    ASL A
    STA $00
    LDA $7F
    ASL A
    ASL A
    AND #$0C
    ORA $00
    TAY
    LDA a:$9C86,Y
    INY
    CLC
    ADC $75
    STA a:$04DE,X
    LDA a:$9C86,Y
    INY
    CLC
    ADC $76
    STA a:$050E,X
    LDA a:$9C86,Y
    INY
    STA a:$044E,X
    LDA a:$9C86,Y
    INY
    STA a:$047E,X
    LDA #$00
    STA a:$04AE,X
    LDA $7B
    STA a:$041E,X
    LDA $7F
    AND #$03
    STA a:$056E,X
    LDA #$FF
    STA a:$053E,X
    LDA $77
    AND #$0C
    LDA #$06
    STA $63
    RTS
    .byte $01, $0C, $0D, $04, $10, $24, $00, $04, $08, $24, $00, $04, $0C, $24, $00, $04
    .byte $0C, $24, $00, $00, $10, $18, $00, $00, $0C, $19, $00, $00, $08, $1A, $00, $00
    .byte $08, $1B, $00, $00, $10, $1C, $82, $00, $0C, $1D, $82, $00, $08, $1E, $82, $00
    .byte $08, $1F, $82, $B1, $9D, $C6, $9D, $00, $00, $01, $01, $DB, $9D, $F0, $9D, $04
    .byte $01, $05, $01, $05, $9E, $1A, $9E, $08, $00, $2F, $9E, $08, $01, $09, $01, $08
    .byte $01, $0B, $01, $44, $9E, $10, $01, $59, $9E, $6E, $9E, $B8, $A2, $CD, $A2, $DC
    .byte $A2, $EB, $A2, $5E, $9F, $18, $02, $6D, $9F, $1A, $01, $7C, $9F, $1C, $02, $8B
    .byte $9F, $1E, $01, $9A, $9F, $A9, $9F, $B8, $9F, $C7, $9F, $58, $9F, $83, $9E, $CE
    .byte $9E, $0D, $9F, $FA, $A2, $4C, $9F, $D6, $9F, $E5, $9F, $F4, $9F, $03, $A0, $12
    .byte $A0, $21, $A0, $30, $A0, $A6, $A2, $AC, $A2, $B2, $A2, $39, $A0, $72, $A3, $9C
    .byte $9D, $36, $01, $48, $A0, $38, $01, $93, $A0, $E4, $A0, $35, $A1, $3C, $01, $4A
    .byte $A1, $3E, $01, $5F, $A1, $74, $A1, $40, $01, $41, $01, $89, $A1, $44, $01, $E6
    .byte $A1, $46, $01, $9E, $A1, $B3, $A1, $48, $01, $49, $01, $C8, $A1, $D7, $A1, $4C
    .byte $01, $4D, $01, $25, $A2, $34, $A2, $50, $01, $51, $01, $43, $A2, $54, $01, $F8
    .byte $A1, $56, $01, $52, $A2, $5E, $A2, $58, $01, $59, $01, $6A, $A2, $79, $A2, $5C
    .byte $01, $5D, $01, $88, $A2, $97, $A2, $60, $01, $61, $01, $07, $A2, $16, $A2, $64
    .byte $01, $00, $00, $09, $A3, $18, $A3, $68, $01, $69, $01, $27, $A3, $36, $A3, $6C
    .byte $01, $6D, $01, $45, $A3, $54, $A3, $63, $A3, $06, $08, $10, $00, $00, $0E, $00
    .byte $08, $0F, $08, $00, $1E, $08, $08, $1F, $10, $00, $2E, $10, $08, $2F, $06, $07
    .byte $11, $01, $00, $00, $01, $87, $00, $09, $00, $10, $09, $87, $10, $11, $00, $01
    .byte $11, $87, $01, $06, $07, $11, $00, $00, $00, $00, $87, $00, $08, $00, $10, $08
    .byte $07, $11, $10, $00, $20, $10, $07, $21, $06, $07, $11, $01, $00, $02, $01, $87
    .byte $02, $09, $00, $12, $09, $87, $12, $11, $00, $03, $11, $87, $03, $06, $07, $11
    .byte $00, $00, $02, $00, $87, $02, $08, $00, $12, $08, $07, $13, $10, $00, $22, $10
    .byte $07, $23, $06, $07, $11, $01, $00, $04, $01, $07, $05, $09, $00, $14, $09, $07
    .byte $15, $11, $00, $24, $11, $07, $25, $06, $07, $11, $00, $00, $06, $00, $07, $07
    .byte $08, $00, $16, $08, $07, $17, $10, $00, $26, $10, $07, $27, $06, $07, $11, $00
    .byte $00, $08, $00, $07, $09, $08, $00, $18, $08, $07, $19, $10, $00, $28, $10, $07
    .byte $29, $06, $07, $11, $00, $00, $0A, $00, $07, $0B, $08, $00, $1A, $08, $07, $1B
    .byte $10, $00, $2A, $10, $07, $2B, $06, $07, $11, $01, $00, $00, $01, $87, $00, $09
    .byte $00, $1D, $09, $87, $1D, $11, $00, $2D, $11, $87, $2D, $06, $07, $11, $01, $00
    .byte $00, $01, $87, $00, $09, $00, $1C, $09, $87, $1C, $11, $00, $2C, $11, $87, $2C
    .byte $18, $18, $20, $00, $00, $42, $00, $08, $43, $00, $10, $43, $00, $98, $42, $28
    .byte $00, $52, $28, $08, $53, $28, $10, $53, $28, $98, $52, $08, $02, $44, $08, $16
    .byte $44, $10, $02, $44, $10, $16, $44, $18, $02, $44, $18, $16, $44, $20, $02, $44
    .byte $20, $16, $44, $08, $10, $55, $10, $10, $55, $18, $10, $55, $20, $10, $55, $08
    .byte $08, $55, $10, $08, $55, $18, $08, $45, $20, $08, $55, $14, $18, $20, $00, $00
    .byte $42, $00, $08, $43, $00, $10, $43, $00, $98, $42, $28, $00, $52, $28, $08, $53
    .byte $28, $10, $53, $28, $98, $52, $08, $02, $44, $08, $16, $44, $10, $02, $44, $10
    .byte $16, $44, $18, $02, $44, $18, $16, $44, $20, $02, $44, $20, $16, $44, $08, $10
    .byte $56, $10, $10, $54, $18, $10, $46, $A0, $10, $56, $14, $18, $20, $00, $00, $42
    .byte $00, $08, $43, $00, $10, $43, $00, $98, $42, $28, $00, $52, $28, $08, $53, $28
    .byte $10, $53, $28, $98, $52, $08, $02, $44, $08, $16, $44, $10, $02, $44, $10, $16
    .byte $44, $18, $02, $44, $18, $16, $44, $20, $02, $44, $20, $16, $44, $08, $15, $44
    .byte $10, $15, $44, $18, $10, $47, $20, $15, $44, $03, $10, $00, $00, $00, $50, $00
    .byte $08, $51, $00, $90, $50, $01, $00, $00, $00, $00, $0D, $04, $08, $08, $00, $00
    .byte $C4, $00, $08, $C5, $08, $00, $D4, $08, $08, $D5, $04, $08, $08, $00, $00, $A0
    .byte $00, $08, $A1, $08, $00, $B0, $08, $08, $B1, $04, $08, $08, $80, $00, $85, $80
    .byte $88, $85, $88, $00, $84, $88, $88, $84, $04, $08, $08, $00, $00, $74, $00, $08
    .byte $75, $88, $00, $74, $88, $08, $75, $04, $08, $08, $00, $00, $E4, $00, $88, $E4
    .byte $88, $00, $E4, $88, $88, $E4, $04, $08, $08, $00, $00, $E5, $00, $88, $E5, $88
    .byte $00, $E5, $88, $88, $E5, $04, $08, $08, $00, $00, $F4, $00, $88, $F4, $88, $00
    .byte $F4, $88, $88, $F4, $04, $08, $08, $00, $00, $F5, $00, $88, $F5, $88, $00, $F5
    .byte $88, $88, $F5, $04, $08, $08, $00, $00, $E0, $00, $08, $E1, $08, $00, $F0, $08
    .byte $08, $F1, $04, $08, $08, $00, $00, $E2, $00, $08, $E3, $08, $00, $F2, $08, $08
    .byte $F3, $04, $08, $08, $00, $00, $C0, $00, $08, $C1, $08, $00, $D0, $08, $08, $D1
    .byte $04, $08, $08, $00, $00, $82, $00, $08, $83, $08, $00, $92, $08, $08, $93, $04
    .byte $08, $08, $00, $00, $80, $00, $08, $81, $08, $00, $90, $08, $08, $91, $04, $00
    .byte $00, $00, $00, $0C, $00, $88, $0C, $08, $00, $CC, $08, $08, $CD, $02, $08, $04
    .byte $04, $00, $0C, $04, $88, $0C, $04, $00, $00, $00, $00, $6E, $00, $08, $6F, $08
    .byte $00, $DD, $08, $87, $DD, $18, $28, $28, $00, $08, $4A, $00, $10, $4B, $00, $98
    .byte $4B, $00, $A0, $4A, $08, $08, $5A, $08, $10, $5B, $08, $98, $5B, $08, $A0, $5A
    .byte $10, $08, $6A, $10, $10, $6B, $10, $98, $6B, $10, $A0, $6A, $18, $08, $7A, $18
    .byte $10, $7B, $18, $98, $7B, $18, $20, $7D, $20, $08, $8A, $20, $10, $8B, $20, $98
    .byte $8B, $20, $20, $8D, $28, $08, $9A, $28, $10, $9B, $28, $18, $9C, $28, $20, $9D
    .byte $1A, $28, $28, $00, $08, $4A, $00, $10, $4B, $00, $98, $4B, $00, $A0, $4A, $08
    .byte $08, $5A, $08, $10, $5B, $08, $98, $5B, $08, $A0, $5A, $10, $08, $6A, $10, $10
    .byte $6B, $10, $98, $6B, $10, $A0, $6A, $18, $80, $6D, $18, $88, $6C, $18, $10, $7B
    .byte $18, $98, $7B, $18, $20, $6C, $18, $28, $6D, $20, $88, $7C, $20, $10, $8B, $20
    .byte $98, $8B, $20, $20, $7C, $28, $08, $9A, $28, $10, $9B, $28, $98, $9B, $28, $A0
    .byte $9A, $1A, $28, $28, $00, $08, $4A, $00, $10, $4B, $00, $98, $4B, $00, $A0, $4A
    .byte $08, $08, $5A, $08, $10, $5B, $08, $98, $5B, $08, $A0, $5A, $10, $08, $6A, $10
    .byte $10, $6B, $10, $98, $6B, $10, $A0, $6A, $18, $80, $6D, $18, $88, $6C, $18, $10
    .byte $7B, $18, $98, $7B, $18, $20, $6C, $18, $28, $6D, $20, $88, $7C, $20, $10, $8B
    .byte $20, $98, $8B, $20, $20, $7C, $28, $88, $9D, $28, $90, $9C, $28, $18, $9C, $28
    .byte $20, $9D, $06, $10, $08, $00, $00, $EB, $00, $08, $EC, $00, $10, $ED, $08, $00
    .byte $FC, $08, $08, $FD, $08, $10, $FE, $06, $08, $10, $00, $00, $A8, $00, $88, $A8
    .byte $08, $00, $B8, $08, $88, $B8, $10, $00, $C8, $10, $08, $C9, $06, $08, $10, $00
    .byte $00, $76, $00, $08, $77, $08, $00, $86, $08, $08, $87, $10, $00, $96, $10, $08
    .byte $97, $06, $08, $10, $00, $00, $76, $00, $08, $77, $08, $00, $86, $08, $08, $87
    .byte $10, $00, $A6, $10, $08, $A7, $06, $08, $10, $00, $00, $76, $00, $08, $77, $08
    .byte $00, $86, $08, $08, $87, $10, $00, $B6, $10, $08, $B7, $06, $08, $10, $00, $00
    .byte $94, $00, $08, $95, $08, $00, $A4, $08, $08, $A5, $10, $00, $B4, $10, $08, $B5
    .byte $06, $08, $10, $00, $00, $C4, $00, $08, $C5, $08, $00, $A4, $08, $08, $A5, $10
    .byte $00, $D4, $10, $08, $D5, $04, $08, $08, $00, $00, $7E, $00, $08, $7F, $08, $00
    .byte $8E, $08, $08, $8F, $04, $08, $08, $00, $00, $78, $00, $08, $79, $08, $00, $88
    .byte $08, $08, $89, $05, $08, $10, $00, $00, $A0, $00, $08, $A1, $08, $00, $B0, $08
    .byte $08, $B1, $10, $04, $EB, $04, $08, $08, $00, $00, $A2, $00, $08, $A3, $08, $00
    .byte $B2, $08, $08, $B3, $04, $08, $08, $00, $00, $C6, $00, $08, $C7, $08, $00, $D6
    .byte $08, $08, $D7, $04, $08, $08, $00, $00, $E6, $00, $08, $E7, $08, $00, $F6, $08
    .byte $08, $F7, $04, $08, $08, $00, $00, $D8, $00, $08, $D9, $08, $00, $E8, $08, $08
    .byte $E9, $04, $08, $08, $00, $00, $D8, $00, $08, $D9, $08, $00, $F8, $08, $08, $F9
    .byte $04, $08, $08, $00, $00, $EA, $00, $88, $EA, $08, $00, $FA, $08, $08, $FB, $03
    .byte $08, $08, $00, $08, $57, $08, $00, $66, $08, $08, $67, $03, $08, $08, $00, $08
    .byte $59, $08, $00, $68, $08, $08, $69, $04, $08, $08, $00, $00, $AA, $00, $08, $AB
    .byte $08, $00, $BA, $08, $08, $BB, $04, $08, $08, $00, $00, $AC, $00, $08, $AD, $08
    .byte $00, $BC, $08, $08, $BD, $04, $0A, $0A, $00, $02, $CA, $00, $0A, $CB, $08, $02
    .byte $DA, $08, $0A, $DB, $04, $0A, $0A, $00, $00, $98, $00, $08, $99, $08, $00, $B9
    .byte $08, $08, $A9, $01, $00, $00, $00, $00, $48, $01, $00, $00, $00, $00, $49, $01
    .byte $00, $00, $00, $00, $58, $06, $00, $00, $00, $00, $60, $00, $08, $61, $08, $00
    .byte $70, $08, $08, $71, $10, $00, $38, $10, $08, $DC, $04, $00, $00, $00, $00, $62
    .byte $00, $08, $63, $08, $00, $72, $08, $08, $73, $04, $00, $00, $00, $00, $4C, $00
    .byte $08, $4D, $08, $00, $5C, $08, $08, $5D, $04, $00, $00, $00, $00, $4E, $00, $08
    .byte $4F, $08, $00, $5E, $08, $08, $5F, $04, $00, $00, $00, $00, $62, $00, $08, $63
    .byte $08, $00, $72, $08, $08, $73, $04, $08, $08, $00, $00, $78, $00, $08, $79, $08
    .byte $00, $88, $08, $08, $88, $04, $08, $08, $00, $00, $78, $00, $08, $79, $08, $00
    .byte $DE, $08, $08, $DF, $04, $08, $08, $00, $00, $EC, $00, $08, $ED, $08, $00, $FC
    .byte $08, $08, $FD, $04, $08, $08, $00, $00, $EE, $00, $08, $EF, $08, $00, $FE, $08
    .byte $08, $FF, $04, $08, $08, $00, $00, $94, $00, $08, $95, $08, $00, $AE, $08, $08
    .byte $AF, $04, $08, $08, $00, $00, $A4, $00, $08, $A5, $08, $00, $BE, $08, $08, $BF
    .byte $04, $08, $08, $00, $00, $B4, $00, $08, $B5, $08, $00, $CE, $08, $08, $CF, $04
    .byte $08, $08, $00, $00, $40, $00, $08, $41, $08, $00, $64, $08, $08, $65

Bank0_Func_A381:
    LDA $5B
    CMP #$E0
    BNE Bank0_Label_A38E
    LDA $1B
    AND #$07
    BNE Bank0_Label_A38E
    RTS

Bank0_Label_A38E:
    DEC $61
    INC $1B
    BNE Bank0_Label_A39A
    LDA $58
    EOR #$01
    STA $58

Bank0_Label_A39A:
    LDA $1B
    AND #$07
    BEQ Bank0_Label_A3A1
    RTS

Bank0_Label_A3A1:
    INC $5B
    LDA $5B
    CLC
    ADC #$20
    TAX
    LDY $5C
    LDA $1C
    AND #$07
    CMP #$04
    BCC Bank0_Label_A3B4
    INY

Bank0_Label_A3B4:
    LDA $58
    EOR #$01
    AND #$01
    JSR Bank0_Func_A4C6
    LDA $1B
    AND #$0F
    BNE Bank0_Label_A3D4
    LDY $5C
    LDA $5B
    CLC
    ADC #$20
    TAX
    LDA $58
    AND #$01
    EOR #$01
    JSR Bank0_Func_A50A

Bank0_Label_A3D4:
    LDA a:$025F
    ASL A
    ASL A
    ASL A
    ASL A
    ORA #$01
    STA a:$025F
    RTS

Bank0_Func_A3E1:
    LDA $5B
    BNE Bank0_Label_A3EC
    LDA $1B
    AND #$07
    BNE Bank0_Label_A3EC
    RTS

Bank0_Label_A3EC:
    INC $61
    LDA $1B
    BNE Bank0_Label_A3F8
    LDA $58
    EOR #$01
    STA $58

Bank0_Label_A3F8:
    DEC $1B
    LDA $1B
    AND #$07
    CMP #$07
    BEQ Bank0_Label_A403
    RTS

Bank0_Label_A403:
    DEC $5B
    LDX $5B
    LDY $5C
    LDA $1C
    AND #$07
    CMP #$04
    BCC Bank0_Label_A412
    INY

Bank0_Label_A412:
    LDA $58
    AND #$01
    JSR Bank0_Func_A4C6
    LDA $1B
    AND #$0F
    CMP #$0F
    BNE Bank0_Label_A3D4
    LDY $5C
    LDX $5B
    LDA $58
    AND #$01
    JSR Bank0_Func_A50A
    JMP Bank0_Label_A3D4

Bank0_Func_A42F:
    LDA $5C
    CMP #$E2
    BNE Bank0_Label_A43C
    LDA $1C
    AND #$07
    BNE Bank0_Label_A43C

Bank0_Label_A43B:
    RTS

Bank0_Label_A43C:
    DEC $62
    INC $1C
    LDA $1C
    CMP #$F0
    BCC Bank0_Label_A44B
    CLC
    ADC #$10
    STA $1C

Bank0_Label_A44B:
    AND #$07
    BNE Bank0_Label_A451
    INC $5C

Bank0_Label_A451:
    CMP #$04
    BNE Bank0_Label_A463
    LDX $5B
    LDA $5C
    CLC
    ADC #$1E
    TAY
    JSR Bank0_Func_A5CF
    JMP Bank0_Label_A476

Bank0_Label_A463:
    LDA $1C
    AND #$0F
    CMP #$08
    BNE Bank0_Label_A43B
    LDX $5B
    LDA $5C
    CLC
    ADC #$1E
    TAY
    JSR Bank0_Func_A60B

Bank0_Label_A476:
    LDA a:$025F
    ASL A
    ASL A
    ASL A
    ASL A
    ORA #$02
    STA a:$025F
    RTS
    .byte $60

Bank0_Func_A484:
    LDA $5C
    BNE Bank0_Label_A48F
    LDA $1C
    AND #$07
    BNE Bank0_Label_A48F

Bank0_Label_A48E:
    RTS

Bank0_Label_A48F:
    INC $62
    DEC $1C
    LDA $1C
    CMP #$F0
    BCC Bank0_Label_A49E
    SEC
    SBC #$10
    STA $1C

Bank0_Label_A49E:
    AND #$07
    CMP #$07
    BNE Bank0_Label_A4A6
    DEC $5C

Bank0_Label_A4A6:
    CMP #$03
    BNE Bank0_Label_A4B4
    LDX $5B
    LDY $5C
    JSR Bank0_Func_A5CF
    JMP Bank0_Label_A476

Bank0_Label_A4B4:
    LDA $1C
    AND #$0F
    CMP #$07
    BNE Bank0_Label_A48E
    LDX $5B
    LDY $5C
    JSR Bank0_Func_A60B
    JMP Bank0_Label_A476

Bank0_Func_A4C6:
    PHA
    JSR Bank0_Func_A6A7
    LDX #$00

Bank0_Label_A4CC:
    JSR Bank0_Func_A719
    STA a:$0233,X
    INX
    CPX #$1E
    BNE Bank0_Label_A4CC
    LDA $1C
    CLC
    ADC #$04
    CMP #$F0
    BCC Bank0_Label_A4E3
    CLC
    ADC #$10

Bank0_Label_A4E3:
    AND #$F8
    STA a:$0231
    PLA
    ASL a:$0231
    ROL A
    ASL a:$0231
    ROL A
    ORA #$20
    STA a:$0232
    LDA $1B
    LSR A
    LSR A
    LSR A
    ORA a:$0231
    STA a:$0231
    LDA a:$0230
    ORA #$01
    STA a:$0230
    RTS

Bank0_Func_A50A:
    PHA
    LDA #$00
    STA $74
    PLA
    AND #$01
    LSR A
    ROR A
    LSR A
    STA $73
    LDA $1C
    AND #$08
    BEQ Bank0_Label_A52D
    INY
    LDA $1C
    CLC
    ADC #$08
    CMP #$F0
    BCC Bank0_Label_A52F
    CLC
    ADC #$10
    JMP Bank0_Label_A52F

Bank0_Label_A52D:
    LDA $1C

Bank0_Label_A52F:
    AND #$F8
    LSR A
    LSR A
    STA $5D
    LSR A
    LSR A
    LSR A
    ROL $74
    LDA $5D
    AND #$38
    ORA $73
    STA $73
    LDA $1B
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    ROL $74
    ORA $73
    STA $73
    AND #$C7
    STA $5D
    ORA #$C0
    STA a:$0253
    LDA $73
    AND #$40
    LSR A
    LSR A
    LSR A
    LSR A
    ORA #$23
    STA a:$0254
    JSR Bank0_Func_A6A7
    LDX $73
    LDA #$0F
    STA $5E

Bank0_Label_A56E:
    JSR Bank0_Func_A772
    AND #$03
    TAY
    LDA a:$A7D3,Y
    LDY $74
    AND a:$A7D7,Y
    STA $5F
    LDA a:$A7D7,Y
    EOR #$FF
    AND a:$06B0,X
    ORA $5F
    STA a:$06B0,X
    LDA $74
    EOR #$02
    STA $74
    AND #$02
    BEQ Bank0_Label_A5A9
    TXA
    AND #$38
    CMP #$38
    BNE Bank0_Label_A5AE
    TXA
    AND #$C7
    TAX
    LDA $74
    AND #$01
    STA $74
    JMP Bank0_Label_A5AE

Bank0_Label_A5A9:
    TXA
    CLC
    ADC #$08
    TAX

Bank0_Label_A5AE:
    DEC $5E
    BNE Bank0_Label_A56E
    LDX $5D
    LDY #$00

Bank0_Label_A5B6:
    LDA a:$06B0,X
    STA a:$0255,Y
    TXA
    CLC
    ADC #$08
    TAX
    INY
    CPY #$08
    BNE Bank0_Label_A5B6
    LDA a:$0230
    ORA #$02
    STA a:$0230
    RTS

Bank0_Func_A5CF:
    JSR Bank0_Func_A6A7
    LDX #$00

Bank0_Label_A5D4:
    JSR Bank0_Func_A6E8
    STA a:$0263,X
    INX
    CPX #$21
    BNE Bank0_Label_A5D4
    LDA $1C
    AND #$F8
    STA a:$0261
    LDA $58
    AND #$01
    ASL a:$0261
    ROL A
    ASL a:$0261
    ROL A
    ORA #$20
    STA a:$0262
    LDA $1B
    LSR A
    LSR A
    LSR A
    ORA a:$0261
    STA a:$0261
    LDA a:$0260
    ORA #$01
    STA a:$0260
    RTS

Bank0_Func_A60B:
    TYA
    PHA
    LDA #$00
    STA $74
    LDA $58
    AND #$01
    LSR A
    ROR A
    LSR A
    STA $73
    LDA $1C
    AND #$F8
    LSR A
    LSR A
    TAY
    LSR A
    LSR A
    LSR A
    ROL $74
    TYA
    AND #$38
    ORA $73
    STA $73
    LDA $1B
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    ROL $74
    ORA $73
    STA $73
    ORA #$C0
    STA a:$0284
    LDA $73
    AND #$40
    LSR A
    LSR A
    LSR A
    LSR A
    ORA #$23
    STA a:$0285
    PLA
    TAY
    JSR Bank0_Func_A6A7
    LDX $73
    LDA #$00
    STA $5D
    LDA #$11
    STA $5E

Bank0_Label_A65B:
    JSR Bank0_Func_A74E
    AND #$03
    TAY
    LDA a:$A7D3,Y
    LDY $74
    AND a:$A7D7,Y
    STA $5F
    LDA a:$A7D7,Y
    EOR #$FF
    AND a:$06B0,X
    ORA $5F
    STA a:$06B0,X
    LDY $5D
    STA a:$0286,Y
    LDA $74
    EOR #$01
    STA $74
    AND #$01
    BNE Bank0_Label_A69A
    INC $5D
    TXA
    AND #$07
    CMP #$07
    BEQ Bank0_Label_A694
    INX
    JMP Bank0_Label_A69A

Bank0_Label_A694:
    TXA
    AND #$F8
    EOR #$40
    TAX

Bank0_Label_A69A:
    DEC $5E
    BNE Bank0_Label_A65B
    LDA a:$0260
    ORA #$02
    STA a:$0260
    RTS

Bank0_Func_A6A7:
    LDA #$00
    STA $70
    STA $71
    STA $6E
    TYA
    LSR A
    ROL $70
    LSR A
    ROL $71
    LSR A
    ROR $6E
    LSR A
    ROR $6E
    STA $6F
    LDA $6E
    CLC
    ADC $66
    STA $6E
    LDA $6F
    ADC $67
    STA $6F
    TXA
    LSR A
    ROL $70
    LSR A
    ROL $71
    STA $72
    LDY $72
    LDA ($6E),Y
    JSR Bank0_Func_A7B7
    LDY $71
    LDA ($6C),Y
    JSR Bank0_Func_A79B
    LDY $70
    LDA ($6A),Y
    TAY
    RTS

Bank0_Func_A6E8:
    LDY $70
    LDA ($6A),Y
    PHA
    TYA
    EOR #$01
    STA $70
    AND #$01
    BNE Bank0_Label_A716
    LDA $71
    EOR #$01
    STA $71
    AND #$01
    BNE Bank0_Label_A70F
    INC $72
    LDA $72
    AND #$3F
    STA $72
    LDY $72
    LDA ($6E),Y
    JSR Bank0_Func_A7B7

Bank0_Label_A70F:
    LDY $71
    LDA ($6C),Y
    JSR Bank0_Func_A79B

Bank0_Label_A716:
    PLA
    TAY
    RTS

Bank0_Func_A719:
    LDY $70
    LDA ($6A),Y
    PHA
    TYA
    EOR #$02
    STA $70
    AND #$02
    BNE Bank0_Label_A74C
    LDA $71
    EOR #$02
    STA $71
    AND #$02
    BNE Bank0_Label_A745
    LDA $6E
    CLC
    ADC #$40
    STA $6E
    LDA $6F
    ADC #$00
    STA $6F
    LDY $72
    LDA ($6E),Y
    JSR Bank0_Func_A7B7

Bank0_Label_A745:
    LDY $71
    LDA ($6C),Y
    JSR Bank0_Func_A79B

Bank0_Label_A74C:
    PLA
    RTS

Bank0_Func_A74E:
    LDY $71
    LDA ($6C),Y
    TAY
    LDA a:$A9EF,Y
    PHA
    LDA $71
    EOR #$01
    STA $71
    AND #$01
    BNE Bank0_Label_A770
    INC $72
    LDA $72
    AND #$3F
    STA $72
    LDY $72
    LDA ($6E),Y
    JSR Bank0_Func_A7B7

Bank0_Label_A770:
    PLA
    RTS

Bank0_Func_A772:
    LDY $71
    LDA ($6C),Y
    TAY
    LDA a:$A9EF,Y
    PHA
    LDA $71
    EOR #$02
    STA $71
    AND #$02
    BNE Bank0_Label_A799
    LDA $6E
    CLC
    ADC #$40
    STA $6E
    LDA $6F
    ADC #$00
    STA $6F
    LDY $72
    LDA ($6E),Y
    JSR Bank0_Func_A7B7

Bank0_Label_A799:
    PLA
    RTS

Bank0_Func_A79B:
    ASL A
    ROL $6B
    ASL A
    ROL $6B
    STA $6A
    LDA $6B
    AND #$03
    STA $6B
    LDA #$EF
    CLC
    ADC $6A
    STA $6A
    LDA #$AA
    ADC $6B
    STA $6B
    RTS

Bank0_Func_A7B7:
    ASL A
    ROL $6D
    ASL A
    ROL $6D
    STA $6C
    LDA $6D
    AND #$03
    STA $6D
    LDA #$EF
    CLC
    ADC $6C
    STA $6C
    LDA #$AE
    ADC $6D
    STA $6D
    RTS
    .byte $00, $55, $AA, $FF, $03, $0C, $30, $C0

Bank0_Func_A7DB:
    LDA #$00
    STA a:$025F
    STA a:$0260
    STA a:$0230
    LDA $5B
    AND #$01
    ASL A
    ASL A
    ASL A
    STA $1B
    LDA $5C
    AND #$01
    ASL A
    ASL A
    ASL A
    STA $1C
    LDA #$98
    STA $60
    LDA $5C
    BMI Bank0_Label_A84C
    LDA $5C
    CLC
    ADC #$26
    STA $5C

Bank0_Label_A807:
    LDA #$00
    STA $61
    STA $62
    JSR Bank0_Func_A484
    JSR Bank0_Func_A87E
    JSR Bank0_Func_8BDE
    JSR Bank0_Func_8750
    LDA #$00
    STA $61
    STA $62
    JSR Bank0_Func_A484
    JSR Bank0_Func_A87E
    JSR Bank0_Func_8BDE
    JSR Bank0_Func_8750
    DEC $60
    BNE Bank0_Label_A807

Bank0_Label_A82F:
    LDA $1B
    STA $59
    LDA $1C
    STA $5A
    LDA $19
    AND #$FE
    STA $5D
    LDA $58
    AND #$01
    ORA $5D
    STA $19
    LDA #$00
    STA $61
    STA $62
    RTS

Bank0_Label_A84C:
    LDA $5C
    SEC
    SBC #$26
    STA $5C

Bank0_Label_A853:
    LDA #$00
    STA $61
    STA $62
    JSR Bank0_Func_A42F
    JSR Bank0_Func_A87E
    JSR Bank0_Func_8BDE
    JSR Bank0_Func_8750
    LDA #$00
    STA $61
    STA $62
    JSR Bank0_Func_A42F
    JSR Bank0_Func_A87E
    JSR Bank0_Func_8BDE
    JSR Bank0_Func_8750
    DEC $60
    BNE Bank0_Label_A853
    JMP Bank0_Label_A82F

Bank0_Func_A87E:
    LDA a:$025F
    BEQ Bank0_Label_A8AC
    CMP #$01
    BEQ Bank0_Label_A89C
    CMP #$02
    BEQ Bank0_Label_A8A4
    TAY
    AND #$F0
    TAX
    TYA
    AND #$0F
    STA a:$025F
    CPX #$20
    BEQ Bank0_Label_A8AD
    JMP Bank0_Label_A94C

Bank0_Label_A89C:
    LDA #$00
    STA a:$025F
    JMP Bank0_Label_A94C

Bank0_Label_A8A4:
    LDA #$00
    STA a:$025F
    JMP Bank0_Label_A8AD

Bank0_Label_A8AC:
    RTS

Bank0_Label_A8AD:
    LDA a:$0260
    AND #$01
    BEQ Bank0_Label_A8FC
    LDA $19
    AND #$FB
    STA a:$2000
    LDA a:$0262
    STA a:$2006
    LDA a:$0261
    STA a:$2006
    AND #$1F
    EOR #$1F
    TAY
    INY
    LDX #$00

Bank0_Label_A8CF:
    LDA a:$0263,X
    STA a:$2007
    INX
    DEY
    BNE Bank0_Label_A8CF
    LDA a:$0262
    EOR #$04
    STA a:$2006
    LDA a:$0261
    AND #$E0
    STA a:$2006

Bank0_Label_A8E9:
    LDA a:$0263,X
    STA a:$2007
    INX
    CPX #$21
    BNE Bank0_Label_A8E9
    LDA a:$0260
    AND #$02
    STA a:$0260

Bank0_Label_A8FC:
    LDA a:$0260
    AND #$02
    BEQ Bank0_Label_A94B
    LDA $19
    AND #$FB
    STA a:$2000
    LDA a:$0285
    STA a:$2006
    LDA a:$0284
    STA a:$2006
    AND #$07
    EOR #$07
    TAY
    INY
    LDX #$00

Bank0_Label_A91E:
    LDA a:$0286,X
    STA a:$2007
    INX
    DEY
    BNE Bank0_Label_A91E
    LDA a:$0285
    EOR #$04
    STA a:$2006
    LDA a:$0284
    AND #$F8
    STA a:$2006

Bank0_Label_A938:
    LDA a:$0286,X
    STA a:$2007
    INX
    CPX #$09
    BNE Bank0_Label_A938
    LDA a:$0260
    AND #$01
    STA a:$0260

Bank0_Label_A94B:
    RTS

Bank0_Label_A94C:
    LDA a:$0230
    AND #$01
    BEQ Bank0_Label_A9B6
    LDA $19
    ORA #$04
    STA a:$2000
    LDA a:$0232
    STA a:$2006
    LDA a:$0231
    STA a:$2006
    STA a:$025E
    LDA a:$0232
    ASL a:$025E
    ROL A
    ASL a:$025E
    ROL A
    ASL a:$025E
    ROL A
    STA a:$025E
    AND #$1F
    EOR #$1F
    TAY
    DEY
    LDX #$00

Bank0_Label_A983:
    LDA a:$0233,X
    STA a:$2007
    INX
    CPX #$1E
    BEQ Bank0_Label_A9AC
    DEY
    BNE Bank0_Label_A983
    LDA a:$0232
    AND #$FC
    STA a:$2006
    LDA a:$0231
    AND #$1F
    STA a:$2006

Bank0_Label_A9A1:
    LDA a:$0233,X
    STA a:$2007
    INX
    CPX #$1E
    BNE Bank0_Label_A9A1

Bank0_Label_A9AC:
    LDA a:$0230
    AND #$02
    STA a:$0230
    BEQ Bank0_Label_A9EE

Bank0_Label_A9B6:
    LDA a:$0230
    AND #$02
    BEQ Bank0_Label_A9EE
    LDA $19
    AND #$FB
    STA a:$2000
    LDX #$00

Bank0_Label_A9C6:
    LDA a:$0254
    STA a:$2006
    LDA a:$0253
    STA a:$2006
    LDA a:$0255,X
    STA a:$2007
    LDA a:$0253
    CLC
    ADC #$08
    STA a:$0253
    INX
    CPX #$08
    BNE Bank0_Label_A9C6
    LDA a:$0230
    AND #$01
    STA a:$0230

Bank0_Label_A9EE:
    RTS

World1_BlockAttributes:
    .byte $00, $03, $01, $00, $02, $01, $01, $01, $01, $01, $01, $01, $01, $02, $01, $02
    .byte $01, $01, $02, $01, $01, $01, $03, $00, $01, $01, $01, $03, $03, $01, $01, $02
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $02, $02, $02, $02, $00
    .byte $01, $02, $02, $02, $02, $00, $03, $01, $02, $01, $01, $01, $02, $02, $02, $02
    .byte $00, $01, $01, $01, $01, $01, $01, $02, $03, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $03, $03, $02, $02, $03, $03, $03, $03, $00, $00, $03, $03
    .byte $03, $03, $00, $00, $00, $00, $01, $01, $01, $03, $00, $02, $00, $00, $01, $02
    .byte $01, $00, $01, $03, $00, $00, $00, $00, $02, $00, $03, $01, $03, $00, $00, $00
    .byte $00, $02, $02, $02, $02, $02, $00, $00, $02, $02, $02, $02, $02, $02, $02, $03
    .byte $01, $02, $02, $03, $01, $03, $01, $01, $03, $00, $00, $00, $01, $03, $03, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $03, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $01, $01, $03, $03, $01, $01, $01, $01, $01, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $02, $02, $02, $02, $02
    .byte $02, $01, $01, $03, $03, $03, $03, $00, $03, $03, $03, $03, $03, $03, $03, $00
    .byte $03, $03, $03, $03, $03, $03, $03, $01, $03, $03, $03, $03, $03, $03, $01, $01

World1_SmallBlocks:
    .byte $00, $00, $00, $00, $10, $10, $10, $10, $F7, $F7, $F7, $F7, $10, $10, $10, $10
    .byte $11, $11, $11, $11, $5A, $5B, $6A, $6B, $F8, $F8, $CF, $CE, $F8, $F8, $CD, $CE
    .byte $5C, $5D, $6C, $6D, $5E, $5F, $6E, $6F, $6A, $7B, $6A, $7B, $5C, $5D, $5C, $5D
    .byte $7E, $7F, $7E, $7F, $1C, $1C, $94, $95, $F8, $F8, $F8, $F8, $A4, $A5, $94, $95
    .byte $B9, $E8, $C9, $B8, $E8, $BA, $F8, $CA, $0E, $0E, $94, $95, $B9, $E8, $C9, $F8
    .byte $E8, $BA, $F8, $CA, $E8, $E8, $F8, $F8, $94, $95, $A4, $A5, $86, $A6, $99, $EE
    .byte $C9, $F8, $C9, $F8, $F8, $CA, $F8, $CA, $F8, $CA, $F8, $CA, $F0, $7A, $8B, $F8
    .byte $F8, $8B, $8B, $F8, $E8, $E8, $C7, $C7, $F7, $EF, $F7, $EF, $11, $EC, $EC, $F8
    .byte $F0, $AF, $FF, $EF, $F8, $FF, $FF, $F7, $FD, $DC, $FC, $EF, $B8, $F8, $CD, $CD
    .byte $F8, $F8, $C7, $C7, $C9, $F8, $C6, $C7, $F8, $CA, $C7, $C8, $F8, $B8, $C7, $C7
    .byte $FD, $FD, $F7, $F7, $F7, $FC, $FC, $F7, $8A, $7B, $9A, $9B, $F7, $DE, $FE, $03
    .byte $F7, $DE, $DE, $00, $00, $00, $02, $03, $02, $03, $11, $11, $96, $76, $ED, $A9
    .byte $D8, $6D, $5C, $5D, $6E, $6F, $7E, $7F, $09, $0A, $00, $00, $00, $0B, $00, $1B
    .byte $16, $11, $11, $11, $76, $76, $99, $A9, $F7, $CC, $CC, $F8, $76, $86, $76, $86
    .byte $11, $DD, $DD, $F7, $F7, $EF, $F7, $EF, $42, $43, $4E, $4F, $4E, $4F, $E0, $D0
    .byte $77, $78, $87, $88, $79, $79, $F8, $F8, $56, $57, $66, $67, $58, $59, $68, $69
    .byte $86, $86, $99, $A9, $AA, $AB, $F7, $9F, $F8, $F8, $CF, $CE, $5C, $5D, $CE, $CF
    .byte $8E, $8F, $AC, $F8, $F8, $F8, $CD, $CD, $DA, $6B, $6A, $7B, $CF, $CF, $F8, $F8
    .byte $FD, $C0, $CC, $F8, $70, $71, $80, $81, $E2, $E3, $F2, $F3, $72, $73, $82, $83
    .byte $0F, $10, $10, $10, $10, $91, $A0, $81, $B0, $71, $33, $C1, $A1, $71, $B1, $81
    .byte $92, $10, $82, $A3, $72, $B3, $C2, $23, $72, $A2, $82, $B2, $EE, $ED, $ED, $EE
    .byte $70, $71, $60, $61, $E2, $E3, $D2, $D3, $72, $73, $62, $63, $C4, $10, $D4, $10
    .byte $10, $C5, $10, $D5, $10, $10, $E4, $E5, $10, $10, $F4, $F5, $89, $89, $10, $10
    .byte $ED, $98, $ED, $A9, $10, $10, $10, $0F, $76, $86, $89, $89, $3C, $3D, $3E, $3F
    .byte $ED, $89, $ED, $89, $97, $EE, $99, $EE, $96, $86, $ED, $89, $76, $A6, $89, $EE
    .byte $B9, $E8, $C9, $F8, $E8, $BA, $F8, $CA, $D6, $D7, $E6, $E7, $58, $59, $F6, $69
    .byte $E8, $E8, $F8, $F8, $C9, $F8, $C9, $F8, $F8, $CA, $F8, $CA, $F8, $FF, $FF, $F7
    .byte $11, $EC, $EC, $F8, $F7, $FC, $FC, $F7, $C9, $CA, $C9, $CA, $C9, $F8, $C6, $C7
    .byte $F8, $CA, $C7, $C8, $F8, $F8, $C7, $C7, $E8, $00, $00, $00, $FD, $FD, $F7, $F7
    .byte $42, $43, $4E, $4F, $4E, $4F, $E0, $D0, $7E, $7C, $7E, $8C, $9E, $9E, $AE, $AE
    .byte $BB, $7B, $CB, $7B, $F0, $AF, $FF, $EF, $EA, $EA, $FA, $FA, $76, $86, $11, $11
    .byte $11, $11, $11, $11, $EA, $EA, $E9, $F9, $7E, $9C, $7E, $7F, $AD, $AD, $11, $11
    .byte $DB, $7B, $6A, $7B, $EA, $11, $FA, $40, $EA, $EA, $EA, $EA, $F8, $F8, $F8, $F8
    .byte $F7, $F7, $F7, $F7, $FD, $DC, $FC, $EF, $F7, $EF, $F7, $EF, $F7, $DE, $FE, $03
    .byte $11, $DD, $DD, $F7, $F7, $DE, $DE, $00, $EA, $EA, $EA, $EA, $44, $47, $44, $47
    .byte $44, $46, $44, $46, $E9, $41, $E9, $41, $E9, $41, $FA, $40, $EA, $11, $E9, $41
    .byte $E9, $EA, $FA, $FA, $0E, $0E, $0E, $0E, $12, $1C, $0C, $0E, $1C, $13, $0E, $0D
    .byte $0C, $0E, $07, $1D, $0E, $0D, $1D, $08, $00, $3D, $00, $3F, $00, $00, $00, $3F
    .byte $0C, $0E, $0C, $0E, $0E, $0D, $0E, $0D, $1C, $1C, $0E, $0E, $0E, $0E, $1D, $1D
    .byte $A4, $A5, $B4, $B5, $B4, $B5, $1D, $1D, $B4, $B5, $0E, $0E, $F0, $F0, $F8, $F8
    .byte $F0, $F0, $F8, $F8, $56, $57, $E6, $E7, $D6, $D7, $66, $67, $D1, $F1, $E1, $FB
    .byte $D1, $F1, $E1, $FB, $7D, $EB, $8D, $9D, $7D, $EB, $8D, $9D, $8C, $CB, $8C, $CB
    .byte $8C, $CB, $8C, $CB, $C3, $C3, $C3, $C3, $97, $98, $99, $A9, $42, $43, $E0, $D0
    .byte $B6, $B7, $B6, $B7, $B6, $B7, $B6, $B7, $4E, $4F, $4E, $4F, $D0, $D0, $D0, $D0
    .byte $20, $21, $21, $20, $30, $31, $21, $20, $30, $31, $31, $20, $22, $21, $21, $20
    .byte $32, $31, $21, $20, $30, $21, $31, $20, $22, $21, $37, $20, $B6, $B7, $B7, $B6
    .byte $74, $75, $84, $85, $74, $75, $74, $75, $64, $65, $74, $75, $50, $51, $52, $53
    .byte $51, $51, $53, $53, $4C, $51, $4D, $53, $50, $51, $52, $53, $51, $24, $53, $34
    .byte $00, $25, $00, $35, $51, $50, $53, $52, $4C, $50, $4D, $52, $00, $00, $3E, $3F
    .byte $51, $00, $53, $00, $22, $21, $31, $20, $30, $21, $21, $20, $B6, $B7, $A7, $B6
    .byte $B6, $B7, $B7, $A7, $0E, $0E, $0E, $0E, $2A, $2B, $3A, $3B, $2A, $29, $3A, $39
    .byte $26, $26, $3A, $39, $26, $27, $3A, $3B, $19, $00, $1E, $1F, $00, $28, $00, $1E
    .byte $28, $06, $1E, $2C, $00, $06, $1F, $06, $00, $04, $00, $06, $05, $00, $00, $00
    .byte $2E, $2F, $2D, $00, $00, $2E, $00, $38, $2F, $06, $00, $06, $2E, $18, $38, $06
    .byte $00, $06, $00, $14, $00, $00, $15, $00, $51, $00, $53, $00, $44, $45, $44, $45
    .byte $46, $47, $46, $47, $48, $49, $44, $45, $4A, $4B, $46, $47, $90, $93, $44, $45
    .byte $54, $55, $46, $47, $9E, $9E, $AD, $AD, $AE, $AE, $AD, $AD, $B6, $B7, $A7, $A7
    .byte $10, $A8, $B6, $01, $10, $10, $B7, $17, $10, $10, $1A, $10, $00, $3D, $3E, $3F
    .byte $B9, $E8, $C9, $42, $E8, $E8, $43, $42, $E8, $BA, $43, $CA, $00, $00, $00, $00
    .byte $10, $D9, $10, $D9, $00, $00, $1A, $10, $1A, $10, $10, $10, $10, $25, $10, $35
    .byte $C9, $E0, $C9, $42, $D0, $E0, $43, $42, $D0, $CA, $43, $CA, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $A9, $00, $00, $00
    .byte $C9, $E0, $C6, $C7, $D0, $E0, $C7, $C7, $D0, $CA, $C7, $C8, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $A9, $00, $00, $00, $A9, $00, $00, $00

World1_BigBlocks:
    .byte $00, $00, $00, $00, $04, $04, $04, $04, $05, $06, $0A, $0E, $23, $07, $0E, $0E
    .byte $08, $09, $0B, $0C, $01, $01, $01, $01, $10, $11, $18, $19, $01, $01, $04, $04
    .byte $7B, $7B, $7C, $7C, $0A, $0E, $0A, $0E, $02, $02, $02, $02, $02, $29, $29, $02
    .byte $04, $1F, $1F, $0E, $A0, $A0, $0E, $0E, $A0, $20, $21, $1E, $0B, $0C, $0B, $0C
    .byte $3A, $3A, $3B, $3B, $0E, $0E, $0E, $0E, $0E, $0E, $24, $24, $9F, $1B, $1C, $83
    .byte $18, $0E, $25, $27, $13, $14, $25, $26, $15, $14, $0E, $19, $13, $13, $18, $15
    .byte $02, $2C, $2B, $2E, $37, $37, $37, $37, $53, $53, $53, $53, $00, $00, $2D, $2E
    .byte $2D, $2E, $04, $04, $00, $32, $00, $33, $15, $14, $14, $19, $13, $15, $18, $13
    .byte $15, $15, $15, $15, $24, $24, $04, $04, $5E, $5E, $AA, $AA, $73, $48, $36, $83
    .byte $28, $22, $29, $39, $2D, $34, $04, $04, $28, $28, $02, $02, $02, $39, $02, $39
    .byte $2A, $0E, $41, $42, $0E, $0E, $45, $45, $0B, $0C, $43, $44, $04, $38, $38, $02
    .byte $3C, $3D, $46, $47, $3D, $3D, $47, $47, $3E, $3F, $30, $31, $9A, $9A, $91, $91
    .byte $03, $03, $03, $03, $49, $49, $49, $49, $4A, $4A, $4A, $4A, $4B, $4B, $4B, $4B
    .byte $4B, $4B, $4B, $4A, $4B, $4B, $4A, $4B, $4A, $4A, $4A, $49, $4A, $4A, $49, $4A
    .byte $4B, $51, $51, $03, $50, $03, $4B, $50, $4B, $57, $4B, $50, $4B, $51, $4B, $57
    .byte $4B, $4A, $4B, $4B, $4A, $4B, $4B, $4B, $4A, $49, $4A, $4A, $49, $4A, $4A, $4A
    .byte $5A, $5A, $4B, $4B, $50, $5A, $4A, $4A, $59, $4D, $4A, $4A, $03, $4D, $4D, $4A
    .byte $4E, $4A, $03, $4E, $4E, $4A, $58, $49, $58, $49, $4D, $4A, $59, $59, $49, $49
    .byte $52, $03, $4B, $57, $4B, $57, $52, $03, $03, $4F, $58, $4A, $58, $4A, $03, $4F
    .byte $49, $4A, $54, $54, $4A, $4A, $55, $55, $49, $49, $49, $4A, $49, $49, $4A, $49
    .byte $4B, $4A, $51, $4E, $4B, $4A, $56, $56, $03, $59, $4D, $49, $03, $4D, $58, $49
    .byte $03, $03, $5A, $5A, $4F, $57, $4F, $50, $49, $4A, $49, $49, $4A, $49, $49, $49
    .byte $4B, $4B, $5B, $5B, $4C, $03, $5D, $03, $5D, $03, $03, $03, $AA, $AA, $AA, $AA
    .byte $60, $AA, $60, $AA, $AA, $61, $AA, $61, $4A, $4A, $4A, $4B, $4A, $4A, $4B, $4A
    .byte $62, $5E, $60, $AA, $5E, $63, $AA, $61, $66, $67, $30, $31, $64, $65, $69, $6A
    .byte $83, $6B, $6B, $84, $84, $6D, $6D, $84, $4A, $4B, $4A, $4A, $4B, $4A, $4A, $4A
    .byte $04, $6C, $6C, $83, $64, $68, $69, $64, $68, $65, $65, $6A, $68, $65, $68, $65
    .byte $69, $6A, $6F, $70, $68, $68, $71, $71, $83, $83, $71, $71, $73, $73, $84, $84
    .byte $9F, $9F, $83, $83, $74, $74, $75, $75, $0B, $76, $0B, $7E, $77, $77, $7F, $7F
    .byte $78, $0E, $80, $0E, $9F, $79, $6B, $86, $92, $0D, $98, $0F, $0D, $93, $0F, $99
    .byte $0D, $0D, $9C, $9C, $0F, $99, $0F, $99, $A1, $67, $30, $31, $84, $89, $87, $2E
    .byte $84, $86, $84, $86, $9A, $93, $91, $99, $73, $85, $6D, $86, $A2, $3F, $30, $31
    .byte $84, $89, $89, $00, $7D, $7A, $8D, $04, $7A, $7A, $04, $04, $81, $04, $04, $04
    .byte $8F, $04, $8D, $04, $92, $0D, $98, $9C, $0D, $93, $9C, $99, $91, $99, $9B, $95
    .byte $98, $91, $94, $9B, $91, $91, $91, $91, $8D, $04, $8D, $04, $8D, $04, $8E, $04
    .byte $90, $7A, $04, $04, $8E, $04, $04, $04, $E1, $5F, $E1, $5F, $98, $0F, $98, $9C
    .byte $0F, $99, $9C, $99, $0D, $0D, $0F, $0F, $9C, $9C, $9B, $9B, $91, $99, $91, $99
    .byte $91, $91, $12, $12, $91, $91, $9B, $9B, $9C, $0F, $91, $0F, $A5, $A5, $A5, $A5
    .byte $A6, $A6, $A6, $A6, $A3, $A3, $A3, $A3, $A4, $A4, $A4, $A4, $8B, $8B, $8B, $8B
    .byte $82, $82, $82, $82, $8A, $8A, $8A, $8A, $8C, $8C, $8C, $8C, $A7, $A7, $A7, $A7
    .byte $A8, $A8, $A8, $A8, $A9, $A9, $A9, $A9, $92, $9A, $98, $91, $AB, $AB, $AB, $AB
    .byte $AC, $AC, $AC, $AC, $AD, $AD, $AD, $AD, $AE, $AE, $AE, $AE, $AF, $AF, $AF, $AF
    .byte $B7, $B7, $B7, $B7, $BB, $BC, $B7, $B7, $BC, $BC, $B7, $B7, $B0, $B0, $B0, $B0
    .byte $BB, $BC, $B1, $B1, $BC, $BC, $B1, $B1, $BB, $BC, $BA, $B2, $B9, $B5, $B9, $B5
    .byte $BE, $B6, $B1, $B3, $B0, $BD, $B0, $B4, $BC, $BC, $B1, $BA, $C1, $BC, $B7, $B7
    .byte $B9, $CB, $B8, $CB, $C1, $BC, $BA, $CC, $CA, $CB, $CA, $CB, $C1, $BC, $CD, $CC
    .byte $CA, $B9, $CA, $B8, $C1, $BC, $CD, $BA, $C1, $BF, $CD, $CC, $EF, $BD, $CD, $CC
    .byte $C0, $C0, $CD, $CC, $C1, $BC, $BA, $CE, $C1, $BC, $D2, $D3, $C1, $BC, $D7, $CE
    .byte $C1, $DA, $D7, $D3, $D6, $00, $D8, $D9, $DD, $DE, $DB, $DC, $DF, $E0, $DB, $DC
    .byte $B9, $00, $B8, $00, $B9, $CF, $B8, $00, $D1, $D5, $D0, $D4, $D6, $CF, $D8, $D9
    .byte $C1, $BC, $BA, $00, $C1, $BC, $00, $00, $B9, $D5, $B8, $D4, $B9, $CE, $B8, $CF
    .byte $C1, $C4, $BA, $CE, $C0, $BD, $D2, $D3, $C1, $C4, $D7, $CE, $00, $BD, $00, $00
    .byte $C1, $BC, $BA, $D4, $C0, $BD, $D7, $CE, $98, $91, $98, $91, $04, $04, $2F, $35
    .byte $04, $04, $35, $40, $04, $04, $40, $17, $5C, $AA, $5C, $AA, $B0, $B9, $B0, $B8
    .byte $C8, $B5, $C8, $B5, $B0, $C7, $B0, $C7, $BB, $B6, $BA, $B5, $00, $B9, $00, $B8
    .byte $C1, $C1, $00, $B8, $B7, $B7, $C8, $B2, $B7, $B7, $B1, $B1, $B7, $B7, $B1, $B7
    .byte $C2, $BC, $D2, $D3, $5F, $5F, $5F, $5F, $C8, $C5, $B1, $C6, $B0, $C7, $B0, $B4
    .byte $E1, $E1, $C3, $C3, $DB, $DC, $DB, $DC, $5F, $E1, $5F, $E1, $E1, $5F, $E1, $5F
    .byte $C8, $96, $C3, $E7, $E1, $E1, $E1, $E1, $C7, $B7, $E3, $00, $E4, $E5, $EC, $ED
    .byte $E6, $03, $EE, $03, $1F, $A0, $E8, $E9, $A0, $20, $EA, $1E, $5F, $C7, $5F, $C3
    .byte $C8, $96, $C8, $96, $5F, $C7, $5F, $C7, $B7, $B7, $C8, $97, $B7, $B7, $C3, $C3
    .byte $B7, $B7, $C3, $B7, $F0, $F1, $F8, $F9, $F2, $1E, $FA, $2B, $32, $03, $2E, $03
    .byte $E1, $E1, $E1, $C3, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

World1_CityMap:
    .byte $3C, $32, $32, $32, $32, $35, $3C, $32, $32, $36, $32, $32, $35, $34, $37, $32
    .byte $32, $3D, $34, $32, $32, $35, $33, $34, $36, $32, $32, $32, $32, $32, $32, $09
    .byte $11, $0F, $3C, $32, $32, $3D, $3C, $32, $32, $35, $34, $36, $32, $3D, $32, $32
    .byte $32, $32, $32, $32, $32, $32, $3D, $33, $33, $34, $32, $32, $57, $37, $32, $35
    .byte $33, $3C, $4D, $56, $32, $3D, $51, $4D, $36, $31, $37, $3D, $51, $36, $56, $37
    .byte $3D, $51, $36, $4E, $32, $32, $3D, $51, $32, $32, $3D, $51, $4C, $4C, $32, $02
    .byte $03, $04, $34, $32, $32, $35, $33, $32, $32, $3D, $51, $31, $3F, $35, $3C, $4D
    .byte $4D, $32, $32, $5E, $4F, $32, $35, $33, $34, $32, $32, $34, $32, $57, $32, $32
    .byte $33, $38, $30, $44, $4D, $38, $30, $5A, $44, $4C, $4D, $38, $30, $44, $4C, $4D
    .byte $38, $30, $44, $4E, $3F, $35, $38, $30, $44, $4C, $38, $30, $30, $30, $44, $09
    .byte $11, $0F, $51, $32, $32, $3D, $51, $36, $5E, $38, $30, $44, $4D, $4D, $38, $5A
    .byte $30, $44, $51, $51, $38, $44, $32, $33, $4D, $37, $3D, $51, $4D, $31, $37, $32
    .byte $3B, $30, $30, $30, $30, $59, $30, $30, $30, $30, $30, $54, $59, $30, $30, $30
    .byte $30, $5A, $30, $44, $50, $38, $30, $5A, $30, $30, $30, $5A, $0C, $0D, $0E, $02
    .byte $03, $04, $2B, $26, $24, $38, $5A, $45, $3B, $30, $5A, $30, $30, $5A, $30, $54
    .byte $30, $5A, $54, $30, $30, $59, $45, $3B, $5A, $44, $38, $30, $30, $44, $31, $56
    .byte $3A, $30, $5A, $30, $30, $30, $43, $39, $30, $5A, $53, $5E, $39, $54, $5A, $30
    .byte $43, $39, $30, $30, $59, $30, $30, $43, $39, $5A, $30, $30, $17, $1E, $0B, $28
    .byte $29, $2A, $06, $1E, $27, $30, $30, $46, $3A, $30, $43, $39, $30, $30, $43, $3D
    .byte $41, $42, $38, $5A, $30, $30, $46, $48, $30, $30, $30, $30, $30, $30, $45, $31
    .byte $34, $41, $42, $39, $5A, $43, $3F, $35, $39, $54, $46, $50, $4D, $33, $41, $42
    .byte $5E, $33, $41, $47, $42, $41, $42, $4D, $35, $39, $30, $30, $1F, $10, $1F, $20
    .byte $1E, $1F, $10, $1E, $27, $59, $30, $45, $3B, $5A, $45, $35, $41, $42, $3F, $35
    .byte $33, $38, $30, $30, $30, $30, $45, $3A, $30, $EB, $EC, $30, $EB, $EC, $46, $37
    .byte $31, $3F, $3D, $3B, $30, $44, $37, $35, $3D, $3F, $38, $5A, $30, $44, $4D, $4D
    .byte $66, $34, $4D, $50, $32, $3D, $38, $30, $46, $3B, $30, $30, $17, $1E, $20, $20
    .byte $20, $20, $17, $1E, $27, $1D, $30, $46, $3A, $30, $46, $3B, $45, $32, $3D, $50
    .byte $38, $30, $30, $30, $30, $30, $46, $3B, $30, $30, $30, $30, $30, $30, $44, $37
    .byte $3F, $3D, $33, $3A, $5A, $30, $45, $32, $3D, $3B, $30, $43, $39, $30, $5A, $30
    .byte $44, $38, $30, $30, $44, $38, $5A, $43, $3D, $49, $5A, $30, $14, $15, $12, $12
    .byte $12, $12, $14, $15, $18, $25, $43, $5E, $38, $30, $45, $3A, $46, $33, $38, $5A
    .byte $30, $5A, $30, $30, $30, $5A, $44, $3A, $54, $30, $30, $30, $30, $30, $30, $45
    .byte $3D, $33, $51, $38, $30, $30, $46, $32, $35, $3A, $5A, $45, $3D, $41, $42, $39
    .byte $5A, $30, $43, $39, $5A, $30, $30, $45, $35, $3A, $30, $30, $30, $30, $30, $30
    .byte $30, $30, $5A, $30, $30, $30, $45, $38, $5A, $30, $46, $32, $35, $3B, $30, $30
    .byte $30, $30, $30, $30, $30, $30, $30, $45, $35, $39, $30, $30, $30, $5A, $30, $46
    .byte $33, $38, $30, $30, $5A, $30, $44, $4D, $37, $3B, $30, $46, $66, $3F, $3F, $4D
    .byte $41, $42, $3F, $66, $39, $30, $30, $46, $3D, $33, $39, $54, $43, $39, $30, $5A
    .byte $43, $41, $42, $39, $30, $5A, $46, $39, $30, $43, $31, $32, $3D, $3A, $30, $30
    .byte $5A, $30, $30, $30, $30, $30, $5A, $4A, $32, $3B, $30, $5A, $30, $EB, $EC, $45
    .byte $3B, $5A, $30, $30, $30, $30, $30, $30, $45, $3A, $30, $44, $51, $50, $38, $30
    .byte $44, $51, $50, $51, $38, $5A, $30, $44, $50, $66, $35, $34, $4D, $66, $41, $42
    .byte $3D, $4D, $32, $35, $39, $43, $5E, $3B, $30, $45, $4E, $3D, $33, $38, $5A, $30
    .byte $30, $30, $5A, $30, $30, $30, $30, $46, $32, $3A, $30, $EB, $EC, $30, $5A, $46
    .byte $3A, $30, $30, $5A, $30, $30, $30, $54, $46, $38, $5A, $30, $30, $30, $30, $5A
    .byte $30, $30, $30, $5A, $30, $30, $30, $30, $30, $45, $3D, $38, $30, $44, $4D, $4D
    .byte $38, $5A, $44, $3F, $33, $4D, $66, $3A, $30, $46, $5E, $35, $38, $30, $30, $54
    .byte $30, $30, $30, $30, $30, $30, $30, $45, $3D, $38, $30, $30, $30, $30, $43, $31
    .byte $34, $39, $30, $30, $43, $41, $42, $51, $38, $30, $30, $30, $30, $43, $41, $42
    .byte $41, $42, $39, $30, $30, $30, $5A, $30, $30, $4A, $3B, $30, $59, $30, $30, $30
    .byte $30, $30, $30, $44, $38, $5A, $44, $38, $30, $44, $51, $35, $39, $5A, $53, $37
    .byte $39, $54, $54, $5A, $30, $30, $30, $46, $38, $30, $5A, $30, $30, $5A, $45, $57
    .byte $3D, $38, $5A, $30, $45, $5E, $38, $5A, $30, $30, $30, $5A, $43, $32, $3B, $44
    .byte $50, $32, $35, $41, $40, $42, $39, $30, $5A, $46, $3A, $30, $30, $30, $30, $30
    .byte $5A, $30, $30, $30, $30, $30, $30, $5A, $30, $30, $30, $44, $3B, $30, $46, $3F
    .byte $35, $33, $38, $30, $30, $30, $43, $3B, $5A, $30, $EB, $EC, $EB, $EC, $46, $4F
    .byte $3B, $30, $30, $30, $46, $66, $39, $30, $30, $43, $41, $42, $3F, $3D, $3A, $5A
    .byte $30, $44, $3D, $3C, $3F, $5E, $3B, $30, $43, $5E, $3B, $5A, $30, $ED, $EE, $30
    .byte $30, $30, $30, $30, $30, $30, $30, $ED, $EE, $30, $30, $30, $55, $30, $44, $51
    .byte $34, $3B, $59, $43, $41, $42, $3D, $3A, $30, $30, $30, $30, $5A, $30, $44, $31
    .byte $49, $30, $30, $5A, $44, $51, $32, $41, $42, $51, $50, $32, $3D, $50, $38, $30
    .byte $30, $5A, $45, $35, $3C, $33, $3A, $30, $45, $33, $49, $30, $30, $F5, $F6, $F7
    .byte $30, $30, $30, $30, $30, $30, $30, $F5, $F6, $F7, $30, $5A, $45, $39, $5A, $30
    .byte $45, $3A, $30, $44, $35, $3C, $34, $38, $30, $30, $30, $30, $30, $EB, $EC, $45
    .byte $48, $5A, $30, $30, $30, $30, $44, $51, $38, $5A, $30, $44, $38, $5A, $30, $43
    .byte $39, $30, $46, $32, $51, $51, $38, $30, $46, $66, $49, $30, $5A, $30, $30, $30
    .byte $5A, $30, $30, $54, $30, $30, $30, $30, $5A, $30, $30, $30, $46, $3B, $30, $30
    .byte $46, $35, $39, $30, $44, $51, $38, $5A, $30, $EB, $EC, $EB, $EC, $30, $30, $46
    .byte $3A, $30, $30, $30, $5A, $30, $30, $5A, $30, $30, $30, $5A, $30, $30, $43, $32
    .byte $3B, $30, $44, $38, $30, $30, $30, $5A, $44, $66, $48, $30, $30, $30, $5A, $30
    .byte $30, $30, $53, $32, $41, $42, $39, $30, $30, $30, $5A, $43, $5E, $3A, $30, $59
    .byte $44, $51, $38, $30, $30, $5A, $30, $30, $30, $30, $30, $30, $30, $30, $43, $31
    .byte $33, $41, $42, $39, $30, $30, $5A, $30, $43, $41, $42, $39, $54, $43, $4E, $3D
    .byte $3A, $30, $5A, $30, $43, $41, $42, $41, $42, $3F, $3A, $43, $41, $42, $39, $30
    .byte $30, $5A, $46, $32, $37, $33, $33, $41, $42, $41, $42, $3F, $3D, $33, $39, $30
    .byte $30, $30, $30, $5A, $30, $54, $54, $30, $5A, $30, $30, $54, $59, $53, $31, $3F
    .byte $67, $32, $3D, $33, $41, $42, $41, $42, $3D, $5E, $32, $35, $34, $57, $3F, $35
    .byte $33, $41, $47, $42, $3D, $34, $3D, $32, $3D, $34, $36, $32, $3D, $3D, $33, $41
    .byte $47, $42, $32, $3D, $5F, $37, $34, $32, $3D, $33, $67, $32, $3D, $35, $34, $41
    .byte $47, $47, $42, $41, $42, $32, $33, $41, $42, $41, $42, $32, $39, $46, $3F, $3D
    .byte $37, $3D, $3C, $3C, $67, $3D, $67, $3D, $33, $33, $3C, $37, $37, $3D, $32, $32
    .byte $35, $67, $3D, $33, $34, $32, $3D, $33, $67, $3F, $3F, $5F, $35, $33, $67, $3D
    .byte $3D, $5E, $5F, $35, $33, $3D, $32, $3D, $33, $33, $3D, $33, $3C, $32, $32, $3D
    .byte $3C, $32, $3D, $3C, $5E, $33, $33, $3C, $32, $32, $5E, $33, $33, $5E, $3D, $33
    .byte $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58
    .byte $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58
    .byte $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58
    .byte $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58
    .byte $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07
    .byte $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07
    .byte $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07
    .byte $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07
    .byte $75, $13, $70, $13, $70, $13, $70, $13, $70, $13, $70, $13, $70, $13, $70, $70
    .byte $13, $70, $13, $70, $13, $70, $13, $70, $13, $70, $13, $70, $13, $70, $70, $13
    .byte $13, $70, $70, $13, $70, $13, $70, $13, $70, $70, $13, $70, $13, $70, $13, $13
    .byte $70, $13, $70, $13, $70, $70, $13, $70, $70, $13, $70, $13, $70, $13, $70, $75
    .byte $7C, $63, $63, $63, $63, $63, $63, $63, $63, $63, $63, $63, $63, $63, $63, $63
    .byte $63, $63, $63, $63, $63, $63, $63, $63, $63, $63, $63, $63, $63, $63, $63, $63
    .byte $63, $63, $63, $63, $63, $63, $63, $63, $63, $63, $63, $63, $63, $63, $63, $63
    .byte $63, $63, $63, $63, $63, $63, $63, $63, $63, $63, $63, $63, $63, $63, $63, $7C
    .byte $7C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C
    .byte $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C
    .byte $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C
    .byte $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $7B
    .byte $7C, $01, $01, $01, $01, $01, $01, $01, $01, $01, $8A, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $60, $22, $22, $22
    .byte $61, $01, $8A, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $2C
    .byte $62, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $0C, $0D
    .byte $7C, $01, $01, $01, $01, $01, $01, $01, $01, $01, $8A, $01, $81, $82, $82, $82
    .byte $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $84, $5C, $5B, $5B, $5B
    .byte $5D, $01, $8A, $81, $82, $82, $82, $82, $82, $82, $82, $82, $82, $84, $84, $09
    .byte $0F, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $06, $98
    .byte $65, $6F, $7E, $01, $01, $01, $01, $01, $01, $01, $8A, $01, $8A, $85, $91, $2F
    .byte $2F, $91, $7D, $01, $A2, $91, $2F, $78, $78, $7D, $01, $8A, $08, $08, $08, $08
    .byte $08, $01, $8A, $8A, $A2, $2F, $78, $78, $2F, $78, $2F, $77, $01, $8A, $8A, $02
    .byte $04, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $06, $98
    .byte $9D, $9D, $7C, $01, $01, $01, $01, $01, $01, $01, $8A, $01, $8A, $88, $92, $95
    .byte $95, $92, $87, $01, $88, $92, $95, $95, $95, $87, $01, $8A, $60, $22, $22, $22
    .byte $61, $01, $8A, $8A, $88, $89, $89, $89, $89, $89, $89, $90, $01, $8B, $8A, $09
    .byte $0F, $01, $01, $68, $70, $75, $01, $01, $01, $01, $01, $01, $01, $01, $1F, $71
    .byte $71, $9D, $7C, $01, $01, $01, $01, $01, $01, $01, $8A, $01, $8A, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $8A, $5C, $5B, $5B, $5B
    .byte $5D, $01, $8A, $8A, $01, $D2, $94, $89, $94, $94, $89, $87, $01, $01, $8A, $02
    .byte $04, $01, $01, $A5, $A5, $7C, $01, $01, $01, $01, $01, $01, $01, $01, $06, $98
    .byte $9D, $63, $7C, $1D, $01, $01, $01, $01, $01, $01, $8A, $01, $8A, $85, $2F, $78
    .byte $2F, $91, $86, $01, $85, $2F, $78, $2F, $78, $86, $01, $8A, $5C, $5B, $5B, $5B
    .byte $5D, $01, $8A, $8C, $01, $88, $92, $95, $92, $92, $87, $01, $81, $82, $8D, $09
    .byte $72, $73, $73, $A5, $A5, $65, $23, $75, $01, $01, $01, $01, $01, $01, $14, $15
    .byte $6D, $6C, $7B, $25, $01, $01, $01, $01, $01, $01, $8A, $01, $8A, $88, $95, $95
    .byte $95, $92, $87, $01, $88, $95, $95, $95, $95, $87, $01, $8A, $5C, $5B, $5B, $5B
    .byte $5D, $01, $8C, $82, $82, $82, $82, $82, $82, $82, $82, $82, $8D, $0C, $0E, $02
    .byte $04, $0C, $0E, $A5, $99, $A5, $A5, $7C, $01, $01, $01, $01, $01, $01, $2C, $7F
    .byte $2C, $2D, $7F, $01, $01, $01, $01, $01, $01, $01, $8A, $01, $8C, $82, $82, $82
    .byte $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $84, $8A, $5C, $5B, $5B, $5B
    .byte $5D, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $9F, $0B, $28
    .byte $2A, $9F, $27, $A5, $1A, $99, $A5, $65, $23, $75, $01, $01, $01, $01, $09, $0F
    .byte $09, $11, $0F, $75, $68, $75, $01, $68, $75, $82, $8A, $01, $85, $2F, $2F, $2F
    .byte $78, $86, $01, $85, $78, $78, $78, $78, $7D, $01, $8A, $8A, $5C, $5B, $5B, $5B
    .byte $5D, $68, $75, $01, $01, $01, $01, $01, $68, $70, $70, $75, $01, $9F, $9F, $9F
    .byte $9F, $9F, $27, $A5, $99, $A5, $99, $A5, $63, $7C, $1D, $01, $01, $01, $02, $04
    .byte $09, $11, $0F, $7C, $63, $7C, $1D, $63, $7C, $1D, $8A, $01, $D2, $94, $94, $89
    .byte $95, $87, $01, $88, $95, $89, $89, $94, $93, $01, $8A, $8A, $5C, $5B, $5B, $5B
    .byte $5D, $A5, $65, $7E, $7A, $01, $68, $70, $70, $75, $6A, $7C, $68, $70, $75, $15
    .byte $15, $15, $18, $6C, $6D, $6D, $6D, $6D, $6C, $7B, $25, $01, $0C, $0E, $09, $0F
    .byte $02, $03, $04, $7B, $6C, $7B, $25, $6C, $7B, $25, $8A, $01, $88, $92, $92, $87
    .byte $01, $D3, $D4, $D5, $01, $88, $95, $92, $87, $01, $8A, $8A, $5C, $5B, $5B, $5B
    .byte $5D, $A5, $A5, $7C, $72, $73, $A0, $A0, $A0, $7C, $63, $7C, $97, $97, $7C, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $06, $0B, $28, $2A
    .byte $09, $11, $0F, $01, $01, $01, $01, $01, $01, $01, $8A, $01, $01, $01, $01, $01
    .byte $01, $D6, $5B, $5D, $01, $01, $01, $01, $01, $01, $8A, $8A, $5C, $5B, $5B, $5B
    .byte $5D, $A5, $71, $65, $23, $75, $A0, $A3, $A0, $7C, $6C, $7B, $97, $71, $7C, $01
    .byte $01, $01, $81, $82, $82, $82, $82, $82, $82, $82, $82, $84, $1F, $71, $06, $71
    .byte $09, $11, $0F, $01, $01, $01, $01, $01, $01, $01, $8A, $01, $85, $2F, $78, $7D
    .byte $01, $08, $08, $08, $01, $A2, $78, $2F, $86, $01, $8A, $8A, $5C, $5B, $5B, $5B
    .byte $5D, $A5, $A5, $A5, $A5, $7C, $6D, $6D, $6D, $7B, $25, $01, $97, $97, $7C, $01
    .byte $01, $01, $8A, $85, $78, $2F, $78, $2F, $78, $86, $01, $8A, $06, $A7, $06, $A7
    .byte $02, $03, $04, $01, $01, $01, $01, $01, $01, $01, $8A, $01, $D2, $94, $94, $94
    .byte $2F, $86, $01, $A2, $91, $94, $89, $94, $93, $01, $8A, $8A, $5C, $5B, $5B, $5B
    .byte $5D, $63, $71, $63, $63, $7C, $1D, $01, $01, $01, $01, $01, $97, $71, $7C, $01
    .byte $01, $01, $8A, $D2, $89, $94, $89, $94, $89, $93, $01, $8A, $15, $12, $12, $12
    .byte $09, $11, $0F, $01, $01, $01, $01, $01, $01, $01, $8A, $01, $88, $92, $92, $92
    .byte $95, $87, $01, $88, $92, $92, $95, $92, $87, $01, $8A, $81, $5C, $5B, $5B, $5B
    .byte $5D, $6C, $6D, $6C, $6C, $7B, $25, $01, $01, $01, $01, $01, $97, $97, $7C, $01
    .byte $01, $01, $8A, $88, $95, $92, $95, $92, $95, $87, $01, $8A, $01, $01, $01, $68
    .byte $02, $03, $04, $01, $01, $01, $01, $01, $01, $01, $8A, $01, $01, $01, $81, $82
    .byte $82, $82, $82, $82, $82, $82, $82, $84, $01, $01, $8A, $8A, $08, $08, $08, $08
    .byte $08, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $68, $70, $70, $70, $70
    .byte $70, $75, $8D, $01, $01, $01, $01, $01, $01, $01, $01, $8A, $01, $01, $01, $97
    .byte $09, $11, $0F, $01, $01, $0C, $0D, $0D, $0D, $0E, $8C, $82, $82, $82, $8D, $01
    .byte $01, $01, $01, $68, $70, $70, $75, $8B, $01, $01, $8A, $8A, $60, $22, $22, $22
    .byte $61, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $63, $97, $69, $6A, $97
    .byte $63, $7C, $01, $01, $01, $01, $2C, $2D, $2E, $82, $82, $8D, $01, $01, $01, $97
    .byte $13, $75, $2A, $24, $01, $06, $19, $19, $19, $27, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $63, $6A, $6B, $7C, $01, $01, $01, $8A, $8A, $5C, $5B, $5B, $5B
    .byte $5D, $0C, $0D, $0E, $01, $01, $01, $01, $01, $01, $01, $97, $97, $97, $97, $97
    .byte $97, $7C, $01, $0C, $0D, $0E, $09, $11, $0F, $01, $01, $01, $01, $01, $68, $97
    .byte $A5, $7C, $19, $27, $01, $17, $9A, $9A, $19, $27, $01, $01, $01, $01, $01, $01
    .byte $01, $68, $70, $69, $A3, $6A, $7C, $01, $01, $01, $8A, $8A, $5C, $5B, $5B, $5B
    .byte $5D, $A7, $A7, $27, $01, $01, $01, $01, $01, $01, $01, $97, $71, $97, $97, $71
    .byte $97, $7C, $01, $17, $1E, $0B, $28, $29, $2A, $24, $01, $01, $01, $01, $97, $97
    .byte $A5, $7C, $19, $27, $1D, $06, $9A, $9A, $19, $27, $1D, $01, $01, $01, $01, $01
    .byte $01, $69, $6B, $A3, $1A, $6B, $7C, $1D, $01, $01, $8A, $8A, $5C, $5B, $5B, $5B
    .byte $5D, $71, $71, $27, $1D, $01, $01, $01, $01, $01, $01, $97, $63, $97, $97, $63
    .byte $97, $7C, $1D, $1F, $20, $20, $1E, $16, $16, $27, $01, $01, $01, $01, $63, $99
    .byte $A5, $65, $23, $13, $75, $15, $15, $15, $15, $18, $25, $01, $01, $01, $0C, $0D
    .byte $0E, $6D, $6C, $6D, $6D, $6C, $7B, $25, $01, $01, $8A, $8B, $5C, $5B, $5B, $5B
    .byte $5D, $15, $15, $18, $25, $0C, $0D, $0E, $2C, $2E, $01, $6C, $6E, $6D, $6D, $6E
    .byte $6C, $7B, $25, $17, $71, $A7, $71, $A7, $1E, $27, $01, $01, $01, $01, $6C, $6E
    .byte $A5, $A5, $A5, $A5, $7C, $1D, $01, $01, $01, $01, $0C, $0D, $0E, $01, $A4, $A4
    .byte $27, $01, $01, $01, $01, $01, $01, $01, $01, $01, $8A, $01, $5C, $5B, $5B, $5B
    .byte $5D, $01, $68, $70, $70, $1F, $06, $0B, $28, $2A, $24, $01, $01, $01, $01, $01
    .byte $01, $01, $0C, $0D, $0D, $0E, $20, $20, $1E, $27, $1D, $01, $01, $01, $01, $0C
    .byte $6E, $6E, $6E, $6E, $7B, $25, $01, $01, $01, $01, $A4, $A4, $0B, $26, $A4, $A4
    .byte $27, $01, $01, $81, $82, $82, $82, $82, $82, $82, $8C, $84, $5C, $5B, $5B, $5B
    .byte $5D, $01, $69, $9D, $9D, $06, $71, $0D, $71, $1E, $0B, $24, $01, $01, $01, $01
    .byte $01, $01, $17, $71, $15, $0A, $15, $15, $15, $18, $25, $01, $01, $0C, $0D, $06
    .byte $2D, $7A, $01, $01, $01, $01, $01, $68, $70, $75, $A4, $A7, $A4, $A4, $A7, $A4
    .byte $27, $1D, $01, $8A, $85, $2F, $78, $91, $2F, $86, $01, $8A, $5C, $5B, $5B, $5B
    .byte $5D, $01, $99, $9D, $99, $17, $20, $20, $20, $20, $1E, $27, $1D, $01, $01, $01
    .byte $01, $01, $14, $15, $15, $18, $25, $01, $01, $01, $01, $01, $01, $06, $0D, $06
    .byte $03, $04, $01, $01, $01, $01, $01, $69, $6B, $7C, $14, $12, $15, $15, $14, $15
    .byte $18, $25, $01, $8A, $88, $95, $95, $92, $95, $87, $01, $8A, $5C, $5B, $5B, $5B
    .byte $5D, $01, $6C, $6D, $6C, $14, $15, $14, $15, $14, $15, $18, $25, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $68, $70, $75, $01, $01, $01, $0C, $0E, $71, $71
    .byte $11, $0F, $01, $01, $01, $01, $01, $A3, $A3, $7C, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $8A, $01, $01, $01, $01, $01, $01, $01, $8A, $5C, $5B, $5B, $5B
    .byte $5D, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $A5, $A5, $7C, $01, $01, $01, $17, $0A, $14, $15
    .byte $03, $04, $01, $01, $01, $01, $01, $69, $6A, $7C, $01, $01, $01, $01, $68, $75
    .byte $01, $01, $01, $8A, $76, $2F, $78, $2F, $78, $86, $01, $8A, $5C, $5B, $5B, $5B
    .byte $5D, $01, $0C, $0D, $0D, $0E, $68, $70, $70, $70, $75, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $68, $A5, $A5, $7C, $01, $01, $01, $14, $18, $25, $68
    .byte $11, $0F, $01, $01, $01, $01, $01, $A3, $A3, $7C, $01, $01, $01, $01, $A5, $7C
    .byte $01, $68, $75, $8A, $8F, $89, $94, $94, $89, $93, $01, $8A, $5C, $5B, $5B, $5B
    .byte $5D, $01, $98, $98, $98, $27, $99, $99, $99, $99, $7C, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $A5, $71, $A5, $7C, $01, $01, $01, $01, $01, $01, $A0
    .byte $70, $70, $70, $75, $01, $01, $0C, $0D, $0E, $7C, $0C, $0D, $0D, $0D, $A5, $7C
    .byte $01, $A5, $7C, $8A, $88, $95, $92, $92, $95, $87, $01, $8A, $08, $08, $08, $08
    .byte $08, $01, $98, $71, $98, $27, $99, $99, $99, $99, $7C, $01, $01, $2C, $62, $01
    .byte $01, $01, $01, $01, $01, $A5, $1A, $A5, $7C, $01, $01, $01, $01, $01, $01, $A0
    .byte $A5, $A5, $A5, $7C, $01, $01, $06, $19, $0B, $26, $19, $19, $19, $19, $A5, $65
    .byte $6F, $A5, $7C, $8C, $82, $83, $82, $82, $82, $82, $82, $8C, $60, $22, $22, $22
    .byte $61, $01, $98, $98, $98, $27, $99, $A5, $A5, $99, $7C, $01, $01, $09, $0F, $01
    .byte $01, $01, $01, $0C, $0E, $63, $63, $63, $7C, $1D, $01, $01, $01, $68, $70, $A0
    .byte $70, $75, $A0, $7C, $01, $01, $06, $71, $19, $19, $19, $19, $19, $16, $A5, $A3
    .byte $A3, $A5, $7C, $01, $01, $01, $01, $01, $01, $01, $01, $01, $5C, $5B, $5B, $5B
    .byte $5D, $0C, $98, $71, $98, $27, $63, $99, $99, $63, $7C, $1D, $01, $09, $0F, $01
    .byte $01, $01, $01, $06, $27, $6C, $6C, $6C, $7B, $25, $01, $01, $01, $A0, $A0, $A0
    .byte $A5, $7C, $A0, $7C, $01, $01, $14, $15, $15, $15, $15, $15, $15, $14, $63, $A3
    .byte $A3, $63, $7C, $1D, $01, $01, $01, $01, $01, $01, $01, $01, $5C, $5B, $5B, $5B
    .byte $5D, $98, $98, $98, $98, $27, $6C, $6D, $6D, $6C, $7B, $25, $01, $09, $72, $73
    .byte $73, $73, $73, $9A, $27, $01, $01, $01, $01, $01, $01, $01, $01, $A0, $A3, $A3
    .byte $A0, $7C, $A5, $7C, $1D, $01, $01, $01, $01, $01, $01, $01, $01, $01, $6C, $6D
    .byte $6D, $6C, $7B, $25, $01, $01, $01, $01, $2C, $2D, $7F, $01, $5C, $5B, $5B, $5B
    .byte $5D, $14, $14, $14, $15, $18, $25, $01, $01, $01, $01, $01, $01, $02, $04, $01
    .byte $01, $01, $0C, $9A, $0B, $24, $01, $01, $01, $01, $01, $01, $01, $A0, $A0, $A0
    .byte $A5, $7C, $6C, $7B, $25, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $2C, $2D, $2E, $01, $09, $71, $0F, $01, $5C, $5B, $5B, $5B
    .byte $5D, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $68, $70, $70, $70
    .byte $70, $75, $06, $9C, $06, $27, $1D, $01, $01, $01, $01, $01, $01, $63, $A0, $63
    .byte $6C, $7B, $25, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $68, $70
    .byte $70, $75, $01, $01, $09, $71, $72, $73, $74, $11, $0F, $01, $08, $08, $08, $08
    .byte $08, $01, $2C, $2D, $7F, $01, $01, $01, $2C, $2D, $2E, $01, $69, $6B, $63, $6B
    .byte $6A, $7C, $15, $15, $15, $18, $25, $01, $01, $01, $01, $01, $01, $6C, $6C, $6C
    .byte $62, $01, $01, $68, $70, $75, $01, $01, $01, $2C, $2D, $7F, $01, $01, $A0, $A0
    .byte $A0, $7C, $01, $01, $09, $11, $72, $73, $74, $11, $0F, $01, $60, $22, $22, $22
    .byte $61, $68, $70, $75, $72, $73, $73, $73, $74, $11, $72, $73, $63, $A1, $A1, $A1
    .byte $6B, $7C, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $2C, $7A
    .byte $72, $73, $73, $69, $6A, $65, $7E, $01, $01, $09, $11, $72, $73, $73, $A0, $63
    .byte $A0, $7C, $01, $01, $09, $71, $72, $73, $74, $71, $0F, $82, $5C, $5B, $5B, $5B
    .byte $5D, $99, $99, $7C, $04, $2C, $62, $01, $02, $03, $04, $01, $69, $6B, $A1, $6A
    .byte $63, $65, $6F, $7E, $01, $01, $01, $68, $70, $75, $2C, $62, $01, $01, $09, $0F
    .byte $04, $68, $70, $63, $63, $6B, $65, $23, $75, $02, $03, $04, $01, $01, $A0, $63
    .byte $A0, $65, $23, $70, $75, $03, $04, $01, $02, $03, $04, $01, $5C, $5B, $5B, $5B
    .byte $5D, $99, $99, $7C, $72, $74, $72, $73, $74, $06, $72, $73, $63, $A1, $A1, $A1
    .byte $6B, $6B, $6A, $65, $23, $70, $70, $69, $6A, $7C, $09, $72, $73, $73, $74, $0F

World1_UndergroundMap:
    .byte $C7, $C6, $C7, $C6, $C7, $C6, $C7, $C6, $AF, $D9, $A8, $A8, $A8, $A8, $A8, $A8
    .byte $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8
    .byte $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8
    .byte $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $D8, $D9, $A8
    .byte $D0, $C8, $C9, $C9, $C9, $C9, $C9, $C9, $DA, $B1, $AC, $AD, $AC, $AD, $AC, $AD
    .byte $AC, $AD, $AC, $AD, $AC, $AD, $AC, $AD, $AC, $AD, $AC, $AD, $AC, $AD, $AC, $AD
    .byte $AC, $AD, $AC, $AD, $AC, $AD, $AC, $AD, $AC, $AD, $AC, $AD, $AC, $AD, $AC, $AD
    .byte $AE, $AD, $AC, $AD, $AC, $AD, $AC, $AD, $AC, $AD, $AC, $AD, $AC, $B0, $B1, $B2
    .byte $CB, $C4, $00, $00, $00, $00, $00, $C3, $AF, $AB, $AB, $AB, $AB, $AB, $AB, $AB
    .byte $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB
    .byte $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB
    .byte $AF, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $D7
    .byte $CA, $C4, $00, $00, $00, $00, $00, $C2, $AE, $AD, $B0, $AB, $AB, $AB, $AB, $AB
    .byte $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB
    .byte $AB, $AB, $AB, $AB, $AB, $B1, $AC, $AD, $AC, $AD, $AC, $AD, $AC, $AD, $AC, $AD
    .byte $AC, $AD, $AC, $AD, $AE, $AD, $B0, $AB, $AB, $AB, $AB, $AB, $B1, $AD, $AC, $B2
    .byte $CB, $C4, $00, $00, $00, $00, $00, $C2, $AF, $AB, $AB, $AB, $AB, $AB, $AB, $AB
    .byte $AB, $AB, $AB, $B1, $AC, $AD, $AC, $AD, $AC, $AD, $AC, $AD, $B0, $AB, $AB, $AB
    .byte $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB
    .byte $AB, $AB, $AB, $AB, $AF, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $D7
    .byte $BD, $BE, $BF, $BE, $C0, $00, $00, $C2, $DA, $B1, $AC, $AD, $AC, $AD, $AC, $AD
    .byte $AC, $AD, $DA, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $B1, $AC, $AD
    .byte $B0, $AB, $B1, $AD, $AC, $AD, $B0, $B1, $AC, $AD, $B0, $AB, $AB, $AB, $B1, $AD
    .byte $AC, $AD, $AC, $AD, $B0, $B1, $AC, $AD, $AC, $AD, $AC, $AD, $B0, $AB, $B1, $B2
    .byte $C5, $C6, $C7, $C6, $C1, $00, $00, $C2, $AF, $AB, $AB, $AB, $AB, $AB, $AB, $AB
    .byte $AB, $AB, $AF, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB
    .byte $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB
    .byte $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $D7
    .byte $CC, $CD, $BF, $BE, $BF, $BE, $C0, $C2, $A9, $AA, $A9, $AA, $A9, $AA, $A9, $AA
    .byte $A9, $AA, $A9, $AA, $A9, $AA, $A9, $AA, $A9, $AA, $A9, $AA, $A9, $AA, $A9, $AA
    .byte $A9, $AA, $A9, $AA, $A9, $AA, $A9, $AA, $A9, $AA, $A9, $AA, $A9, $AA, $A9, $AA
    .byte $A9, $AA, $A9, $AA, $A9, $AA, $A9, $AA, $A9, $AA, $A9, $AA, $A9, $AA, $A9, $AA
    .byte $C5, $C6, $C7, $C6, $C7, $C6, $C1, $C2, $C5, $C6, $C7, $C6, $C7, $C6, $C7, $C6
    .byte $D8, $D9, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8
    .byte $A8, $D8, $D9, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8
    .byte $E5, $E9, $E9, $E9, $E9, $E9, $E1, $E9, $E9, $E9, $E9, $E9, $E9, $E9, $E9, $E5
    .byte $BD, $BE, $BF, $BE, $CE, $CD, $C0, $C2, $C8, $C9, $C9, $C9, $C9, $C9, $C9, $DC
    .byte $D8, $E3, $DE, $DE, $DE, $DE, $DE, $DE, $DE, $DE, $DE, $DE, $DE, $DE, $DE, $DF
    .byte $EA, $E2, $E3, $DE, $DE, $DE, $DE, $DF, $DD, $DE, $DE, $DE, $DE, $DE, $DE, $DF
    .byte $E5, $E4, $E4, $E4, $E4, $E4, $E1, $E4, $E4, $E4, $E4, $E4, $E4, $E4, $E4, $E5
    .byte $C5, $C6, $C7, $C6, $C7, $C6, $C1, $C2, $C4, $00, $00, $00, $00, $00, $00, $DB
    .byte $D8, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $D9
    .byte $D8, $00, $00, $00, $00, $00, $00, $D9, $D8, $00, $00, $00, $00, $00, $00, $D9
    .byte $E5, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E5
    .byte $B5, $BA, $BB, $B7, $B7, $B7, $B7, $B9, $C4, $00, $00, $00, $00, $00, $00, $DB
    .byte $DD, $E2, $E3, $E2, $E3, $E2, $E3, $E2, $E3, $E2, $E3, $E2, $E3, $E2, $E3, $DF
    .byte $DD, $DE, $E2, $00, $00, $00, $00, $D9, $DD, $DE, $DE, $DE, $DE, $E2, $00, $D9
    .byte $E5, $E1, $E1, $E1, $E1, $E1, $E4, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E5
    .byte $B4, $B6, $B6, $B6, $B6, $B6, $B6, $B8, $C4, $CF, $C9, $C9, $C9, $C9, $C9, $DC
    .byte $D8, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $D9
    .byte $D8, $00, $00, $00, $E3, $DE, $DE, $DF, $D8, $00, $00, $00, $00, $00, $00, $D9
    .byte $E5, $E1, $E1, $E9, $E4, $E1, $E1, $E1, $E1, $E1, $E4, $E4, $E9, $E1, $E1, $E5
    .byte $B5, $B7, $B7, $B7, $B7, $BA, $BB, $B9, $C4, $00, $00, $00, $00, $00, $00, $DB
    .byte $DD, $DE, $E2, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $E3, $DE, $DF
    .byte $DD, $DE, $DE, $E2, $00, $00, $00, $D9, $DD, $DE, $DE, $DE, $DE, $DE, $E2, $D9
    .byte $E5, $E1, $E4, $E4, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $F8, $E4, $E1, $E5
    .byte $B4, $B6, $B6, $B6, $B6, $B6, $B6, $B8, $C8, $BE, $00, $00, $00, $00, $E0, $DC
    .byte $D8, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $D9
    .byte $D8, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $D9
    .byte $E5, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $8E, $E1, $E1, $E5
    .byte $B3, $B3, $B3, $B3, $B3, $B3, $B3, $B3, $BD, $BE, $BF, $BE, $BF, $BE, $BF, $BE
    .byte $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8
    .byte $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8
    .byte $E5, $E9, $E9, $E9, $E9, $E9, $E7, $E6, $E9, $E9, $E9, $E9, $E7, $E6, $E9, $E5
    .byte $A8, $D8, $D9, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8
    .byte $F0, $F1, $A8, $A8, $A8, $A8, $A8, $A8, $F0, $F1, $A8, $A8, $A8, $A8, $A8, $A8
    .byte $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $F0, $F1
    .byte $A8, $A8, $A8, $A8, $A8, $A8, $F0, $F1, $A8, $A8, $A8, $A8, $F0, $F1, $A8, $A8
    .byte $DD, $E2, $E3, $DE, $DE, $DE, $DE, $DE, $DE, $DE, $DE, $DE, $DE, $DE, $DE, $DF
    .byte $F0, $EF, $F3, $F3, $F3, $F3, $F3, $F4, $F0, $EF, $F3, $F3, $F3, $F3, $F3, $F3
    .byte $F3, $F3, $F3, $F3, $F3, $F3, $F3, $F3, $F3, $F3, $F3, $F3, $F3, $F3, $E8, $F1
    .byte $F2, $F3, $F3, $F3, $F3, $F3, $E8, $EF, $F3, $F3, $F3, $F3, $E8, $EF, $F3, $F4
    .byte $D8, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $D9
    .byte $F0, $E1, $E1, $E1, $E1, $E1, $E1, $F1, $F0, $E1, $E1, $E1, $E1, $E1, $E1, $E1
    .byte $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $F1
    .byte $F0, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $F1
    .byte $D8, $E3, $E2, $AB, $AB, $E3, $E2, $AB, $AB, $E3, $E2, $AB, $AB, $E3, $E2, $D9
    .byte $F2, $F3, $F3, $F3, $F3, $F0, $E1, $F1, $A8, $A8, $F0, $E1, $E1, $F1, $F0, $E1
    .byte $E1, $F1, $F0, $E1, $E1, $F1, $F0, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $F1
    .byte $F0, $E1, $E1, $E1, $E1, $E1, $F1, $F0, $E1, $F1, $F0, $E1, $EF, $F3, $F3, $F4
    .byte $DD, $E2, $AB, $AB, $E3, $E2, $AB, $AB, $AB, $AB, $E3, $E2, $AB, $AB, $E3, $DF
    .byte $F0, $E1, $E1, $E1, $E1, $F3, $E8, $EF, $F3, $F3, $F3, $F3, $F3, $F3, $F3, $F3
    .byte $F3, $F3, $F3, $F3, $F3, $F3, $F3, $F4, $F0, $EF, $E8, $E1, $E1, $EF, $E8, $F1
    .byte $F0, $EF, $F3, $F3, $E8, $EF, $F4, $F0, $E1, $F1, $F0, $E1, $E1, $E1, $E1, $F1
    .byte $D8, $AB, $AB, $E3, $E2, $AB, $AB, $E3, $E2, $AB, $AB, $E3, $E2, $AB, $AB, $D9
    .byte $F0, $EF, $F3, $E8, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1
    .byte $E1, $E1, $E1, $E1, $E1, $E1, $E1, $F1, $F0, $E1, $E1, $EF, $E8, $E1, $E1, $F1
    .byte $F0, $E1, $E1, $E1, $E1, $E1, $F1, $F0, $E1, $EF, $F3, $F3, $F3, $F3, $E8, $F1
    .byte $D8, $AB, $E3, $E2, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB, $E3, $E2, $AB, $D9
    .byte $F0, $E1, $E1, $E1, $E1, $E1, $F1, $A8, $F0, $E1, $E1, $F1, $F0, $E1, $E1, $F1
    .byte $F0, $E1, $E1, $F1, $F0, $E1, $E1, $F1, $A8, $F0, $E1, $E1, $E1, $E1, $F1, $A8
    .byte $A8, $F0, $E1, $E1, $E1, $E1, $F1, $F0, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $F1
    .byte $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8
    .byte $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8
    .byte $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8
    .byte $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8
    .byte $F0, $F1, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8
    .byte $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8
    .byte $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8
    .byte $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $A8, $F0, $F1

Bank0_Func_C92F:
    LDA $27
    BNE Bank0_Label_C93D
    LDX #$07
    LDA #$00

Bank0_Label_C937:
    STA a:$0298,X
    DEX
    BPL Bank0_Label_C937

Bank0_Label_C93D:
    RTS

Bank0_Func_C93E:
    LDX #$09
    LDA #$00

Bank0_Label_C942:
    STA a:$0400,X
    DEX
    BPL Bank0_Label_C942
    RTS

Bank0_Func_C949:
    LDX #$13
    LDA #$00

Bank0_Label_C94D:
    STA a:$040A,X
    DEX
    BPL Bank0_Label_C94D
    RTS

Bank0_Func_C954:
    LDX #$07
    LDA #$00

Bank0_Label_C958:
    STA a:$041E,X
    DEX
    BPL Bank0_Label_C958
    RTS

Bank0_Func_C95F:
    LDX #$09
    LDA #$00

Bank0_Label_C963:
    STA a:$0426,X
    DEX
    BPL Bank0_Label_C963
    RTS

Bank0_Func_C96A:
    LDX #$0F

Bank0_Label_C96C:
    LDA a:$0680,X
    STA a:$0670,X
    DEX
    BPL Bank0_Label_C96C
    RTS

Bank0_Func_C976:
    LDX #$0F

Bank0_Label_C978:
    LDA a:$0680,X
    STA a:$0670,X
    DEX
    BPL Bank0_Label_C978
    RTS

Bank0_Func_C982:
    LDA #$00
    STA a:$0426,X
    RTS

Bank0_Func_C988:
    LDX #$26

Bank0_Label_C98A:
    LDA a:$0400,X
    BNE Bank0_Label_C990
    RTS

Bank0_Label_C990:
    INX
    CPX #$30
    BNE Bank0_Label_C98A
    LDA #$01
    RTS

Bank0_Func_C998:
    LDA a:$0426,X
    TAY
    DEY
    LDA $75
    SEC
    SBC a:$04E6,X
    BCS Bank0_Label_C9AA
    CMP #$F4
    BCS Bank0_Label_C9AF
    RTS

Bank0_Label_C9AA:
    CMP a:$CC58,Y
    BCS Bank0_Label_C9CD

Bank0_Label_C9AF:
    LDA $76
    SEC
    SBC a:$0516,X
    BCS Bank0_Label_C9BD
    CMP a:$CC65,Y
    BCS Bank0_Label_C9C2
    RTS

Bank0_Label_C9BD:
    CMP a:$CC72,Y
    BCS Bank0_Label_C9CD

Bank0_Label_C9C2:
    CPY #$02
    BCS Bank0_Label_C9CE
    TXA
    STA $80
    INY
    TYA
    STA $81

Bank0_Label_C9CD:
    RTS

Bank0_Label_C9CE:
    DEY
    DEY
    TYA
    ASL A
    TAY
    LDA a:$CBF4,Y
    STA $00
    LDA a:$CBF5,Y
    STA $01
    JMP ($0000)

Bank0_Label_C9E0:
    RTS

Bank0_Func_C9E1:
    AND #$7F
    TAX
    LDA a:$04B6,Y
    AND #$0F
    BNE Bank0_Label_C9E0
    LDA a:$0426,Y
    CMP #$8A
    BNE Bank0_Label_C9F6
    LDA $24
    BEQ Bank0_Label_C9E0

Bank0_Label_C9F6:
    LDA $00
    SEC
    SBC a:$04E6,Y
    BCS Bank0_Label_CA04
    CLC
    ADC $02
    BCS Bank0_Label_CA09
    RTS

Bank0_Label_CA04:
    CMP a:$CC3D,X
    BCS Bank0_Label_C9E0

Bank0_Label_CA09:
    LDA $01
    SEC
    SBC a:$0516,Y
    BCS Bank0_Label_CA17
    CLC
    ADC $02
    BCS Bank0_Label_CA1C
    RTS

Bank0_Label_CA17:
    CMP a:$CC4A,X
    BCS Bank0_Label_C9E0

Bank0_Label_CA1C:
    LDX $95
    LDA a:$041E,X
    CMP #$03
    BEQ Bank0_Label_CA37
    LDA a:$04DE,X
    SEC
    SBC #$04
    STA a:$04DE,X
    LDA a:$050E,X
    SEC
    SBC #$04
    STA a:$050E,X

Bank0_Label_CA37:
    LDA #$80
    STA a:$041E,X
    LDA a:$0576,Y
    SEC
    SBC #$01
    STA a:$0576,Y
    BNE Bank0_Label_CA63
    LDA a:$0426,Y
    AND #$7F
    STA a:$0426,Y
    CMP #$0A
    BNE Bank0_Label_CA59
    JSR Bank0_Func_CB61
    JMP Bank0_Label_CA5E

Bank0_Label_CA59:
    LDA #$0A
    JSR Bank0_Func_E398

Bank0_Label_CA5E:
    PLA
    PLA
    JMP Bank0_Label_9250

Bank0_Label_CA63:
    LDA #$02
    JSR Bank0_Func_E398
    PLA
    PLA
    JMP Bank0_Label_9250

Bank0_Func_CA6D:
    LDA $82
    BEQ Bank0_Label_CA8A
    DEC $83
    BNE Bank0_Label_CA7F
    LDA #$00
    STA $82
    STA a:$02AB
    JMP Bank0_Label_CA8A

Bank0_Label_CA7F:
    LDA $83
    AND #$07
    BNE Bank0_Label_CA8A
    LDA #$07
    JSR Bank0_Func_E3BC

Bank0_Label_CA8A:
    LDA $16
    AND #$01
    BEQ Bank0_Label_CAA6
    LDA $B2
    BEQ Bank0_Label_CAA6
    LDA #$00
    STA $79
    LDA $16
    AND #$02
    STA $78
    DEC $B2
    BNE Bank0_Label_CAA6
    LDA #$00
    STA $78

Bank0_Label_CAA6:
    RTS
    DEC $2C
    JSR Bank0_Func_8362
    LDA a:$0546,X
    BMI Bank0_Label_CAB6
    STA $00
    JSR Bank0_Func_8D81

Bank0_Label_CAB6:
    JSR Bank0_Func_C982
    LDA #$0E
    JSR Bank0_Func_E398
    LDA #$35
    JMP Bank0_Func_81C9
    INC $2A
    LDA a:$0546,X
    BMI Bank0_Label_CACF
    STA $00
    JSR Bank0_Func_8D81

Bank0_Label_CACF:
    JSR Bank0_Func_C982
    LDA #$01
    STA $26
    LDA #$31
    JMP Bank0_Func_81C9
    JSR Bank0_Func_8362
    LDA a:$0546,X
    BMI Bank0_Label_CAE8
    STA $00
    JSR Bank0_Func_8D81

Bank0_Label_CAE8:
    JSR Bank0_Func_C982
    LDA #$0E
    JSR Bank0_Func_E398
    LDA #$32
    JMP Bank0_Func_81C9
    INC $7B
    LDA a:$0546,X
    BMI Bank0_Label_CB01
    STA $00
    JSR Bank0_Func_8D81

Bank0_Label_CB01:
    JSR Bank0_Func_C982
    LDA #$0E
    JSR Bank0_Func_E398
    LDA #$31
    JMP Bank0_Func_81C9

Bank0_Func_CB0E:
    LDA #$01
    STA $82
    LDA #$F0
    STA $83
    LDA a:$0546,X
    BMI Bank0_Label_CB20
    STA $00
    JSR Bank0_Func_8D81

Bank0_Label_CB20:
    JSR Bank0_Func_C982
    LDA #$01
    STA a:$02AB
    LDA #$07
    JSR Bank0_Func_E3BC
    LDA #$32
    JMP Bank0_Func_81C9
    INC $84
    LDA a:$0546,X
    BMI Bank0_Label_CB3E
    STA $00
    JSR Bank0_Func_8D81

Bank0_Label_CB3E:
    JSR Bank0_Func_C982
    LDA #$0E
    JSR Bank0_Func_E398
    LDA #$32
    JMP Bank0_Func_81C9
    LDA #$01
    STA $37
    LDA a:$0546,X
    BMI Bank0_Label_CB59
    STA $00
    JSR Bank0_Func_8D81

Bank0_Label_CB59:
    LDA #$0B
    JSR Bank0_Func_E398
    JMP Bank0_Func_C982

Bank0_Func_CB61:
    TXA
    PHA
    TYA
    PHA
    PHA
    JSR Bank0_Func_C954
    PLA
    TAX
    JSR Bank0_Func_CB73
    PLA
    TAY
    PLA
    TAX
    RTS

Bank0_Func_CB73:
    LDA a:$0546,X
    BMI Bank0_Label_CB7D
    STA $00
    JSR Bank0_Func_8D81

Bank0_Label_CB7D:
    TXA
    PHA
    LDA #$0E
    JSR Bank0_Func_E3BC
    LDA #$0A
    STA $97

Bank0_Label_CB88:
    JSR Bank0_Func_94F1
    DEC $97
    BNE Bank0_Label_CB88
    LDA #$50
    STA $97

Bank0_Label_CB93:
    JSR Bank0_Func_94F1
    LDA #$31
    JSR Bank0_Func_81C9
    LDA $16
    AND #$07
    BNE Bank0_Label_CBA6
    LDA #$08
    JSR Bank0_Func_E398

Bank0_Label_CBA6:
    DEC $97
    BNE Bank0_Label_CB93
    PLA
    TAX
    JMP Bank0_Func_C982
    LDA a:$0546,X
    BMI Bank0_Label_CBB9
    STA $00
    JSR Bank0_Func_8D81

Bank0_Label_CBB9:
    JSR Bank0_Func_C982
    LDA #$0E
    JSR Bank0_Func_E398
    LDA #$31
    JMP Bank0_Func_81C9
    LDA a:$0546,X
    BMI Bank0_Label_CBD0
    STA $00
    JSR Bank0_Func_8D81

Bank0_Label_CBD0:
    JSR Bank0_Func_C982
    LDA #$0E
    JSR Bank0_Func_E398
    LDA #$32
    JMP Bank0_Func_81C9
    LDA a:$0546,X
    BMI Bank0_Label_CBE7
    STA $00
    JSR Bank0_Func_8D81

Bank0_Label_CBE7:
    JSR Bank0_Func_C982
    LDA #$FF
    STA $B2
    LDA #$0E
    JSR Bank0_Func_E398
    RTS
    .byte $0E, $CB, $A7, $CA, $C3, $CA, $F5, $CA, $DB, $CA, $32, $CB, $4B, $CB, $73, $CB
    .byte $AF, $CB, $C6, $CB, $DD, $CB, $01, $29, $01, $03, $02, $25, $01, $03, $03, $2E
    .byte $01, $03, $04, $2D, $00, $03, $05, $2F, $01, $10, $06, $00, $01, $02, $07, $30
    .byte $01, $02, $08, $34, $01, $02, $09, $16, $01, $04, $0A, $14, $01, $20, $0B, $28
    .byte $01, $02, $0C, $17, $00, $02, $0D, $35, $03, $02, $14, $1C, $0C, $0C, $0C, $0C
    .byte $0C, $0C, $0C, $0C, $0C, $0C, $0C, $05, $28, $0C, $0C, $0C, $0C, $0C, $0C, $0C
    .byte $0C, $0C, $0C, $0C, $14, $1C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
    .byte $0C, $E8, $FF, $EC, $EC, $EC, $EC, $EC, $EC, $EC, $EC, $EC, $EC, $EC, $00, $18
    .byte $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C

Bank0_TryEnterWorld1Door:
    LDA $21
    AND #$80
    BEQ Bank0_Label_CC8B
    LDA $81
    CMP #$02
    BEQ Bank0_EnterWorld1Door

Bank0_Label_CC8B:
    RTS

Bank0_EnterWorld1Door:
    LDA #$00
    STA a:$02AA
    STA a:$02AB
    STA $82
    STA $83
    STA $B2
    LDA #$13
    JSR Bank0_Func_E3BC
    JSR Bank0_Func_C93E
    JSR Bank0_Func_C949
    JSR Bank0_Func_C954
    LDX $80
    LDA a:$0546,X
    STA $81
    TAY
    LDA a:$04E6,X
    CLC
    ADC #$08
    STA $75
    LDA a:$0516,X
    CLC
    ADC #$10
    STA $76
    LDA #$04
    STA $77
    LDA #$00
    STA $78

Bank0_Label_CCC8:
    JSR Bank0_Func_94F1
    LDA #$00
    STA $61
    STA $62
    JSR Bank0_Func_8706
    LDA $61
    ORA $62
    BNE Bank0_Label_CCC8
    LDA #$14

Bank0_Label_CCDC:
    PHA

Bank0_Label_CCDD:
    PHA
    JSR Bank0_Func_94F1
    PLA
    SEC
    SBC #$01
    BNE Bank0_Label_CCDD
    LDX $80
    INC a:$0456,X
    LDA a:$0456,X
    CMP #$28
    BEQ Bank0_Label_CCF7
    PLA
    JMP Bank0_Label_CCDC

Bank0_Label_CCF7:
    LDA #$F0
    STA $76
    DEC a:$0456,X
    LDA #$13
    JSR Bank0_Func_E3BC
    PLA

Bank0_Label_CD04:
    PHA

Bank0_Label_CD05:
    PHA
    JSR Bank0_Func_94F1
    PLA
    SEC
    SBC #$01
    BNE Bank0_Label_CD05
    LDX $80
    DEC a:$0456,X
    LDA a:$0456,X
    CMP #$24
    BEQ Bank0_Label_CD1F
    PLA
    JMP Bank0_Label_CD04

Bank0_Label_CD1F:
    PLA
    JSR Bank0_Func_C95F
    JSR Bank0_Func_C96A
    LDA $81
    TAY
    LDA a:$CDA9,Y
    BPL Bank0_Label_CD42
    CMP #$FF
    BNE Bank0_Label_CD35
    JMP Bank0_Func_D3A9

Bank0_Label_CD35:
    JSR Bank0_Func_964A
    AND #$03
    TAY
    LDA a:$CDB1,Y
    CMP $81
    BEQ Bank0_Label_CD35

Bank0_Label_CD42:
    ASL A
    ASL A
    TAY
    LDA a:$CD89,Y
    STA $5B
    INY
    LDA a:$CD89,Y
    STA $5C
    INY
    LDA a:$CD89,Y
    INY
    CLC
    ADC #$08
    STA $75
    LDA a:$CD89,Y
    CLC
    ADC #$10
    STA $76
    LDA #$00
    STA $79
    STA $78
    STA $77
    STA $7F
    JSR Bank0_Func_C96A
    JSR Bank0_Func_80DA
    JSR Bank0_Func_A7DB
    JSR Bank0_Func_843B
    JSR Bank0_Func_95ED
    LDX #$0A

Bank0_Label_CD7D:
    JSR Bank0_Func_94F1
    DEX
    BNE Bank0_Label_CD7D
    LDX #$7F
    TXS
    JMP Bank0_Label_82C1
    .byte $B0, $86, $70, $60, $1C, $C2, $70, $60, $02, $A4, $70, $60, $70, $20, $70, $60
    .byte $B8, $5C, $70, $40, $8C, $8C, $70, $60, $1D, $5C, $70, $40, $0C, $D8, $70, $60
    .byte $80, $05, $06, $FF, $80, $01, $02, $80, $00, $05, $04, $07

Bank0_InitWorld1SideView:
    LDX #$00

Bank0_Label_CDB7:
    LDA a:$0680,X
    STA a:$0690,X
    LDA a:$06A0,X
    STA a:$0680,X
    INX
    CPX #$10
    BNE Bank0_Label_CDB7
    JSR Bank0_Func_83A3
    LDA $81
    SEC
    SBC #$08
    STA $85
    CLC
    ADC #$03
    STA $29
    JSR Bank0_Func_843B
    JMP Bank0_Label_CDE3

Bank0_Label_CDDD:
    JSR Bank0_Func_83E8
    JSR Bank0_Func_843B

Bank0_Label_CDE3:
    LDA $85
    ASL A
    ASL A
    TAY
    LDA #$01
    STA $51
    LDA #$00
    STA $79
    LDA a:$D213,Y
    STA $75
    LDA a:$D214,Y
    STA $76
    LDA a:$D215,Y
    STA $86
    LDA a:$D216,Y
    STA $87
    LDA a:$D1EF,Y
    STA $5B
    LDA a:$D1F0,Y
    STA $5C
    LDA a:$D1F1,Y
    STA $88
    LDA a:$D1F2,Y
    STA $89
    LDA #$00
    STA $8A
    LDA #$01
    STA $7C
    LDA #$00
    STA $7D
    LDA #$00
    STA $7E
    LDA #$00
    STA $8B
    LDA #$00
    STA $9B
    JSR Bank0_Func_9614
    LDA #$EF
    STA $66
    LDA #$C2
    STA $67
    LDA #$25
    STA $68
    LDA #$D9
    STA $69
    JSR Bank0_Func_C96A
    JSR Bank0_Func_83BD
    JSR Bank0_Func_A7DB
    JSR Bank0_Func_9535
    JSR Bank0_Func_95ED
    LDX #$7F
    TXS

Bank0_Label_CE55:
    JSR Bank0_Func_94F1
    JSR Bank0_Func_8490
    JSR Bank0_Func_95CB
    JSR Bank0_Func_9B54
    JSR Bank0_Func_CF7A
    JSR Bank0_Func_CA6D
    JSR Bank0_Func_9201
    JSR Bank0_Func_CF08
    JSR Bank0_Func_8BDE
    JSR Bank0_Func_8BDE
    JSR Bank0_Func_888F
    JSR Bank0_Func_8EF6
    JSR Bank0_Func_931B
    JSR Bank0_Func_820E
    LDA $79
    BMI Bank0_Label_CE90
    LDA $76
    CMP #$F8
    BCS Bank0_Label_CEAB
    CMP #$E0
    BCS Bank0_Label_CEC2
    JMP Bank0_Label_CE55

Bank0_Label_CE90:
    JSR Bank0_Func_884C
    DEC $2A
    BMI Bank0_Label_CE9E
    LDA $85
    STA $81
    JMP Bank0_Label_CDDD

Bank0_Label_CE9E:
    JSR Bank0_Func_8065
    LDA #$02
    STA $2A
    JSR Bank0_Func_C92F
    JMP Bank0_Label_CDDD

Bank0_Label_CEAB:
    LDA $8B
    BNE Bank0_Label_CEE5
    LDA $86
    STA $00
    LDA $89
    BEQ Bank0_Label_CEBB
    LDA $87
    STA $00

Bank0_Label_CEBB:
    LDA $00
    BMI Bank0_Label_CE55
    JMP Bank0_Func_D2C3

Bank0_Label_CEC2:
    INC $8B
    LDA #$00
    STA $8A
    LDA $5C
    CLC
    ADC #$20
    STA $5C
    LDA $76
    SEC
    SBC #$E0
    STA $76
    JSR Bank0_Func_C96A
    JSR Bank0_Func_9614
    JSR Bank0_Func_A7DB
    JSR Bank0_Func_95ED
    JMP Bank0_Label_CE55

Bank0_Label_CEE5:
    DEC $8B
    LDA #$00
    STA $8A
    LDA $5C
    SEC
    SBC #$20
    STA $5C
    LDA $76
    CLC
    ADC #$B0
    STA $76
    JSR Bank0_Func_C96A
    JSR Bank0_Func_9614
    JSR Bank0_Func_A7DB
    JSR Bank0_Func_95ED
    JMP Bank0_Label_CE55

Bank0_Func_CF08:
    LDA #$00
    STA $61
    STA $62
    LDA $75
    SEC
    SBC #$6E
    BCS Bank0_Label_CF42
    EOR #$FF
    SEC
    ADC #$00
    STA $8C
    CMP #$03
    BCC Bank0_Label_CF24
    LDA #$02
    STA $8C

Bank0_Label_CF24:
    LDA $89
    ORA $8A
    BEQ Bank0_Label_CF6F
    LDA $8A
    SEC
    SBC #$01
    AND #$07
    STA $8A
    CMP #$07
    BNE Bank0_Label_CF39
    DEC $89

Bank0_Label_CF39:
    JSR Bank0_Func_A3E1
    DEC $8C
    BNE Bank0_Label_CF24
    BEQ Bank0_Label_CF6F

Bank0_Label_CF42:
    LDA $75
    SEC
    SBC #$82
    BCC Bank0_Label_CF6F
    STA $8C
    CMP #$02
    BCC Bank0_Label_CF53
    LDA #$01
    STA $8C

Bank0_Label_CF53:
    INC $8C

Bank0_Label_CF55:
    LDA $89
    CMP $88
    BEQ Bank0_Label_CF6F
    LDA $8A
    CLC
    ADC #$01
    AND #$07
    STA $8A
    BNE Bank0_Label_CF68
    INC $89

Bank0_Label_CF68:
    JSR Bank0_Func_A381
    DEC $8C
    BNE Bank0_Label_CF55

Bank0_Label_CF6F:
    LDA $75
    CLC
    ADC $61
    STA $75
    JSR Bank0_Func_8750
    RTS

Bank0_Func_CF7A:
    JSR Bank0_Func_9BFC
    LDA $79
    BEQ Bank0_Label_CFC0
    BPL Bank0_Label_CF84
    RTS

Bank0_Label_CF84:
    LDA #$40
    STA $78
    LDA $16
    AND #$03
    BNE Bank0_Label_CF90
    INC $79

Bank0_Label_CF90:
    LDA $79
    CMP #$06
    BCS Bank0_Label_CFA7
    LDA $16
    LSR A
    LSR A
    AND #$01
    ORA #$10
    STA $77
    LDA #$00
    STA $78
    JMP Bank0_Label_CFDF

Bank0_Label_CFA7:
    CMP #$16
    BCC Bank0_Label_CFAF
    LDA #$00
    STA $79

Bank0_Label_CFAF:
    LDA $77
    AND #$03
    STA $00
    LDA $7F
    ASL A
    ASL A
    ORA $00
    STA $77
    JMP Bank0_Label_CFC4

Bank0_Label_CFC0:
    LDA #$00
    STA $78

Bank0_Label_CFC4:
    LDA $7C
    BNE Bank0_Label_CFDF
    LDA $63
    BEQ Bank0_Label_CFDF
    CMP #$03
    BCS Bank0_Label_CFD9
    LDA $77
    AND #$0C
    STA $77
    JMP Bank0_Label_CFDF

Bank0_Label_CFD9:
    LDA $77
    ORA #$01
    STA $77

Bank0_Label_CFDF:
    LDA $77
    STA $01
    LDA $75
    STA $06
    LDA $76
    STA $07
    LDA $7C
    BEQ Bank0_Label_CFF5
    JSR Bank0_Func_D145
    JMP Bank0_Label_D004

Bank0_Label_CFF5:
    LDA $65
    AND #$80
    BEQ Bank0_Label_D001
    JSR Bank0_Func_D138
    JMP Bank0_Label_D004

Bank0_Label_D001:
    JSR Bank0_Func_D113

Bank0_Label_D004:
    LDA $21
    AND #$02
    BNE Bank0_Label_D036
    LDA $21
    AND #$01
    BNE Bank0_Label_D084
    LDA $79
    BEQ Bank0_Label_D018
    CMP #$06
    BCC Bank0_Label_D02E

Bank0_Label_D018:
    LDA $7C
    BNE Bank0_Label_D02F
    INC $7A
    LDA $7A
    CMP #$05
    BCC Bank0_Label_D02E
    LDA #$00
    STA $7A
    LDA $77
    AND #$0C
    STA $77

Bank0_Label_D02E:
    RTS

Bank0_Label_D02F:
    LDA $77
    ORA #$01
    STA $77
    RTS

Bank0_Label_D036:
    LDA #$02
    STA $7F
    DEC $75
    LDA $7E
    SEC
    SBC #$80
    STA $7E
    BCS Bank0_Label_D047
    DEC $75

Bank0_Label_D047:
    LDA $75
    CMP #$05
    BCS Bank0_Label_D051
    LDA #$05
    STA $75

Bank0_Label_D051:
    LDX #$00
    LDY #$19
    JSR Bank0_Func_D1C3
    BCS Bank0_Label_D06C
    LDX #$00
    LDY #$0E
    JSR Bank0_Func_D1C3
    BCS Bank0_Label_D06C
    LDX #$00
    LDY #$02
    JSR Bank0_Func_D1C3
    BCC Bank0_Label_D070

Bank0_Label_D06C:
    LDA $06
    STA $75

Bank0_Label_D070:
    LDA $7C
    BEQ Bank0_Label_D07D
    LDA #$00
    STA $7A
    LDA #$09
    STA $77
    RTS

Bank0_Label_D07D:
    LDA #$09
    STA $01
    JMP Bank0_Label_D0D2

Bank0_Label_D084:
    LDA #$03
    STA $7F
    INC $75
    LDA $7E
    CLC
    ADC #$80
    STA $7E
    BCC Bank0_Label_D095
    INC $75

Bank0_Label_D095:
    LDA $75
    CMP #$EC
    BCC Bank0_Label_D09F
    LDA #$EB
    STA $75

Bank0_Label_D09F:
    LDX #$0E
    LDY #$19
    JSR Bank0_Func_D1C3
    BCS Bank0_Label_D0BA
    LDX #$0E
    LDY #$0E
    JSR Bank0_Func_D1C3
    BCS Bank0_Label_D0BA
    LDX #$0E
    LDY #$02
    JSR Bank0_Func_D1C3
    BCC Bank0_Label_D0BE

Bank0_Label_D0BA:
    LDA $06
    STA $75

Bank0_Label_D0BE:
    LDA $7C
    BEQ Bank0_Label_D0CB
    LDA #$00
    STA $7A
    LDA #$0D
    STA $77
    RTS

Bank0_Label_D0CB:
    LDA #$0D
    STA $01
    JMP Bank0_Label_D0D2

Bank0_Label_D0D2:
    LDA $79
    BEQ Bank0_Label_D0DA
    CMP #$06
    BCC Bank0_Label_D112

Bank0_Label_D0DA:
    LDA $77
    AND #$0C
    STA $00
    LDA $01
    AND #$0C
    CMP $00
    BEQ Bank0_Label_D0F2
    LDA $01
    STA $77
    LDA #$00
    STA $7A
    STA $63

Bank0_Label_D0F2:
    LDA $63
    BNE Bank0_Label_D112
    INC $7A
    LDA $7A
    CMP #$05
    BCC Bank0_Label_D112
    LDA #$00
    STA $7A
    LDA $77
    AND #$0C
    STA $00
    INC $77
    LDA $77
    AND #$03
    ORA $00
    STA $77

Bank0_Label_D112:
    RTS

Bank0_Func_D113:
    LDA $9B
    BEQ Bank0_Label_D11D
    LDA $76
    CMP #$C6
    BCS Bank0_Label_D137

Bank0_Label_D11D:
    LDX #$04
    LDY #$1A
    JSR Bank0_Func_D1C3
    BCS Bank0_Label_D137
    LDX #$0A
    LDY #$1A
    JSR Bank0_Func_D1C3
    BCS Bank0_Label_D137
    LDA #$01
    STA $7C
    LDA #$00
    STA $7D

Bank0_Label_D137:
    RTS

Bank0_Func_D138:
    LDA #$E8
    STA $7D
    LDA #$01
    STA $7C
    LDA #$12
    JSR Bank0_Func_E3BC

Bank0_Func_D145:
    LDA $7D
    AND #$80
    STA $00
    LDA $7D
    LSR A
    ORA $00
    LSR A
    ORA $00
    ADC $76
    STA $76
    INC $7D
    LDA $7D
    BMI Bank0_Label_D165
    CMP #$18
    BCC Bank0_Label_D165
    LDA #$18
    STA $7D

Bank0_Label_D165:
    LDA $7D
    BMI Bank0_Label_D186
    LDA $9B
    BEQ Bank0_Label_D173
    LDA $76
    CMP #$C6
    BCS Bank0_Label_D1AB

Bank0_Label_D173:
    LDX #$04
    LDY #$1A
    JSR Bank0_Func_D1C3
    BCS Bank0_Label_D1AB
    LDX #$0A
    LDY #$1A
    JSR Bank0_Func_D1C3
    BCS Bank0_Label_D1AB
    RTS

Bank0_Label_D186:
    LDX #$04
    LDY #$02
    JSR Bank0_Func_D1C3
    BCS Bank0_Label_D199
    LDX #$0A
    LDY #$02
    JSR Bank0_Func_D1C3
    BCS Bank0_Label_D199
    RTS

Bank0_Label_D199:
    LDA $76
    CLC
    ADC #$0A
    AND #$F8
    STA $76
    DEC $76
    DEC $76
    LDA #$00
    STA $7D
    RTS

Bank0_Label_D1AB:
    LDA $1C
    AND #$07
    CLC
    ADC #$02
    STA $00
    CLC
    ADC $76
    AND #$F8
    SEC
    SBC $00
    STA $76
    LDA #$00
    STA $7C
    RTS

Bank0_Func_D1C3:
    STX $04
    LDA $1B
    AND #$07
    CLC
    ADC $75
    CLC
    ADC $04
    LSR A
    LSR A
    LSR A
    CLC
    ADC $5B
    TAX
    STY $04
    LDA $1C
    AND #$07
    CLC
    ADC $76
    CLC
    ADC $04
    LSR A
    LSR A
    LSR A
    CLC
    ADC $5C
    TAY
    JSR Bank0_Func_A6A7
    CPY #$42
    RTS
    .byte $40, $22, $20, $00, $80, $22, $20, $00, $CA, $22, $20, $0A, $00, $42, $20, $00
    .byte $40, $42, $40, $00, $20, $02, $C0, $00, $E0, $02, $C0, $C0, $A0, $42, $40, $40
    .byte $60, $42, $40, $00, $18, $10, $00, $FF, $38, $10, $01, $FF, $78, $10, $02, $02
    .byte $38, $10, $03, $FF, $18, $10, $04, $FF, $18, $10, $05, $06, $B8, $10, $05, $06
    .byte $D8, $10, $08, $07, $18, $10, $08, $07

Bank0_TryEnterWorld1Manhole:
    LDA $21
    AND #$80
    BEQ Bank0_Label_D243
    LDA $81
    CMP #$01
    BEQ Bank0_EnterWorld1Manhole

Bank0_Label_D243:
    RTS

Bank0_EnterWorld1Manhole:
    LDA a:$06A0
    AND #$FE
    STA a:$06A0
    LDA #$00
    STA a:$02AA
    STA a:$02AB
    STA $82
    STA $83
    STA $B2
    JSR Bank0_Func_C93E
    JSR Bank0_Func_C949
    JSR Bank0_Func_C954
    LDX $80
    LDA a:$0546,X
    STA $81
    TAY
    LDA a:$04E6,X
    CLC
    ADC #$04
    STA $75
    LDA a:$0516,X
    SEC
    SBC #$14
    STA $76
    LDA #$00
    STA $77
    STA $78
    STA $7F

Bank0_Label_D283:
    JSR Bank0_Func_94F1
    LDA #$00
    STA $61
    STA $62
    JSR Bank0_Func_8706
    LDA $61
    ORA $62
    BNE Bank0_Label_D283
    LDX #$0A

Bank0_Label_D297:
    JSR Bank0_Func_94F1
    DEX
    BNE Bank0_Label_D297
    LDX #$00
    LDA #$12
    JSR Bank0_Func_E3BC

Bank0_Label_D2A4:
    JSR Bank0_Func_94F1
    TXA
    LSR A
    LSR A
    TAY
    LDA a:$D3A3,Y
    CLC
    ADC $76
    STA $76
    INX
    CPX #$14
    BNE Bank0_Label_D2A4
    JSR Bank0_Func_C95F
    JSR Bank0_Func_C96A
    LDX $81
    JMP Bank0_InitWorld1SideView

Bank0_Func_D2C3:
    PHA
    LDA #$00
    STA a:$02AA
    STA a:$02AB
    STA $82
    STA $83
    STA $B2
    JSR Bank0_Func_C95F
    JSR Bank0_Func_C96A
    JSR Bank0_Func_C93E
    JSR Bank0_Func_C949
    JSR Bank0_Func_C954
    PLA
    ASL A
    ASL A
    TAX
    LDA a:$D37E,X
    STA $5B
    LDA a:$D37F,X
    STA $5C
    LDA a:$D380,X
    STA a:$04E6
    CLC
    ADC #$04
    STA $75
    LDA a:$D381,X
    STA a:$0516
    SEC
    SBC #$14
    STA $76
    LDA #$00
    STA $79
    LDA #$00
    STA $77
    LDA #$00
    STA $7F
    LDA #$00
    STA $78
    LDA #$00
    STA $7A
    JSR Bank0_Func_9614
    LDA #$EF
    STA $66
    LDA #$B2
    STA $67
    LDA #$89
    STA $68
    LDA #$D9
    STA $69
    LDA #$00
    STA $29
    LDA $5C
    CMP #$40
    BCS Bank0_Label_D33A
    LDA #$01
    STA $29

Bank0_Label_D33A:
    LDX #$00

Bank0_Label_D33C:
    LDA a:$0680,X
    STA a:$06A0,X
    LDA a:$0690,X
    STA a:$0680,X
    INX
    CPX #$10
    BNE Bank0_Label_D33C
    JSR Bank0_Func_C95F
    JSR Bank0_Func_C96A
    JSR Bank0_Func_83BD
    JSR Bank0_Func_9535
    JSR Bank0_Func_A7DB
    JSR Bank0_Func_843B
    JSR Bank0_Func_95ED
    LDX #$00

Bank0_Label_D364:
    JSR Bank0_Func_94F1
    TXA
    LSR A
    LSR A
    TAY
    LDA a:$D3A2,Y
    CLC
    ADC $76
    STA $76
    INX
    CPX #$1C
    BNE Bank0_Label_D364
    LDX #$7F
    TXS
    JMP Bank0_Label_82C1
    .byte $E0, $E0, $70, $90, $B0, $D0, $70, $90, $92, $66, $70, $90, $3E, $68, $70, $90
    .byte $3A, $9A, $70, $90, $00, $5C, $30, $70, $DE, $00, $70, $70, $64, $34, $70, $90
    .byte $10, $26, $70, $90, $FD, $FE, $FF, $00, $01, $02, $03

Bank0_Func_D3A9:
    LDX #$00

Bank0_Label_D3AB:
    LDA a:$0680,X
    STA a:$0690,X
    LDA a:$06A0,X
    STA a:$0680,X
    INX
    CPX #$10
    BNE Bank0_Label_D3AB
    JMP Bank0_Label_D3CB

Bank0_Label_D3BF:
    JSR Bank0_Func_83E8
    LDA #$01
    STA $51
    LDA #$06
    JMP Bank0_Func_D2C3

Bank0_Label_D3CB:
    LDA #$00
    STA $79
    LDA #$01
    STA $51
    LDA #$78
    STA $75
    LDA #$B0
    STA $76
    LDA #$00
    STA $5B
    LDA #$22
    STA $5C
    LDA #$22
    STA $88
    LDA #$22
    STA $89
    LDA #$00
    STA $8A
    STA $7C
    STA $7D
    STA $7E
    STA $9B
    STA a:$02AB
    STA $82
    STA $83
    STA $B2
    JSR Bank0_Func_9614
    LDA #$EF
    STA $66
    LDA #$C2
    STA $67
    LDA #$25
    STA $68
    LDA #$D9
    STA $69
    LDA #$02
    STA $29
    JSR Bank0_Func_83BD
    JSR Bank0_Func_A7DB
    JSR Bank0_Func_9535
    JSR Bank0_Func_843B
    JSR Bank0_Func_95ED
    LDX #$7F
    TXS

Bank0_Label_D429:
    JSR Bank0_Func_94F1
    JSR Bank0_Func_8490
    JSR Bank0_Func_95CB
    JSR Bank0_Func_9B54
    JSR Bank0_Func_CF7A
    JSR Bank0_Func_CA6D
    JSR Bank0_Func_9201
    JSR Bank0_Func_D47C
    JSR Bank0_Func_8BDE
    JSR Bank0_Func_888F
    JSR Bank0_Func_8EF6
    JSR Bank0_Func_931B
    JSR Bank0_Func_87F8
    JSR Bank0_Func_820E
    LDA $1C
    AND #$07
    ORA $5C
    BEQ Bank0_Label_D462
    LDA $79
    BMI Bank0_Func_D465
    JMP Bank0_Label_D429

Bank0_Label_D462:
    JMP Bank0_Func_D4EE

Bank0_Func_D465:
    JSR Bank0_Func_884C
    DEC $2A
    BMI Bank0_Label_D46F
    JMP Bank0_Label_D3BF

Bank0_Label_D46F:
    JSR Bank0_Func_8065
    LDA #$02
    STA $2A
    JSR Bank0_Func_C92F
    JMP Bank0_Label_D3BF

Bank0_Func_D47C:
    LDA #$00
    STA $61
    STA $62
    LDA $76
    SEC
    SBC #$6E
    BCS Bank0_Label_D4B6
    EOR #$FF
    SEC
    ADC #$00
    STA $8C
    CMP #$07
    BCC Bank0_Label_D498
    LDA #$06
    STA $8C

Bank0_Label_D498:
    LDA $89
    ORA $8A
    BEQ Bank0_Label_D4E3
    LDA $8A
    SEC
    SBC #$01
    AND #$07
    STA $8A
    CMP #$07
    BNE Bank0_Label_D4AD
    DEC $89

Bank0_Label_D4AD:
    JSR Bank0_Func_A484
    DEC $8C
    BNE Bank0_Label_D498
    BEQ Bank0_Label_D4E3

Bank0_Label_D4B6:
    LDA $76
    SEC
    SBC #$92
    BCC Bank0_Label_D4E3
    STA $8C
    CMP #$06
    BCC Bank0_Label_D4C7
    LDA #$05
    STA $8C

Bank0_Label_D4C7:
    INC $8C

Bank0_Label_D4C9:
    LDA $89
    CMP $88
    BEQ Bank0_Label_D4E3
    LDA $8A
    CLC
    ADC #$01
    AND #$07
    STA $8A
    BNE Bank0_Label_D4DC
    INC $89

Bank0_Label_D4DC:
    JSR Bank0_Func_A42F
    DEC $8C
    BNE Bank0_Label_D4C9

Bank0_Label_D4E3:
    LDA $76
    CLC
    ADC $62
    STA $76
    JSR Bank0_Func_8750
    RTS

Bank0_Func_D4EE:
    JSR Bank0_Func_C949
    LDA #$06
    STA a:$02AA
    LDA #$00
    STA a:$02AB
    STA $82
    STA $83
    STA $B2
    LDA #$01
    STA $9B
    JSR Bank0_Func_C949
    JSR Bank0_Func_C93E
    JSR Bank0_Func_C96A
    LDA #$00
    STA a:$0400
    LDA #$3A
    STA a:$0430
    LDA #$00
    STA a:$0490
    LDA #$32
    STA a:$04C0
    LDA #$70
    STA a:$04F0
    LDA #$01
    STA a:$0460
    LDA #$FF
    STA a:$0520
    LDA #$00
    STA a:$0550
    LDA #$00
    STA a:$0580
    LDA #$18
    STA a:$05B0
    LDA #$00
    STA a:$05E0
    LDA #$07
    STA $9C
    LDA #$00
    STA $9E

Bank0_Label_D54D:
    JSR Bank0_Func_94F1
    LDA #$00
    STA a:$0400
    LDA $9E
    AND $9C
    BNE Bank0_Label_D560
    LDA #$0F
    STA a:$0400

Bank0_Label_D560:
    JSR Bank0_Func_8490
    JSR Bank0_Func_95CB
    JSR Bank0_Func_9B54
    JSR Bank0_Func_CF7A
    JSR Bank0_Func_CA6D
    JSR Bank0_Func_9201
    JSR Bank0_Func_888F
    JSR Bank0_Func_8EF6
    JSR Bank0_Func_931B
    JSR Bank0_Func_87F8
    JSR Bank0_Func_820E
    LDA $79
    BMI Bank0_Label_D594
    DEC $9E
    BEQ Bank0_Label_D598
    LDA $9E
    AND #$3F
    BNE Bank0_Label_D54D
    LSR $9C
    JMP Bank0_Label_D54D

Bank0_Label_D594:
    JMP Bank0_Func_D465
    .byte $60

Bank0_Label_D598:
    LDA #$0E
    STA a:$0400
    LDA #$00
    STA $9D
    STA $98
    LDA #$38
    STA a:$0430
    JSR Bank0_Func_964A
    AND #$3F
    CLC
    ADC #$20
    STA $9F

Bank0_Label_D5B2:
    JSR Bank0_Func_94F1
    JSR Bank0_Func_8490
    JSR Bank0_Func_95CB
    JSR Bank0_Func_9B54
    JSR Bank0_Func_CF7A
    JSR Bank0_Func_CA6D
    JSR Bank0_Func_888F
    JSR Bank0_Func_9201
    JSR Bank0_Func_8EF6
    JSR Bank0_Func_931B
    JSR Bank0_Func_87F8
    JSR Bank0_Func_820E
    JSR Bank0_Func_D67A
    LDA a:$0400
    BEQ Bank0_Label_D5E5
    LDA $79
    BMI Bank0_Label_D594
    JMP Bank0_Label_D5B2

Bank0_Label_D5E5:
    LDA #$00
    STA a:$02AA
    LDA #$04
    JSR Bank0_Func_E3BC
    LDA #$00
    STA $26
    LDA #$0F
    STA a:$0400
    LDA #$00
    STA a:$0490
    LDA #$A0
    STA $9C

Bank0_Label_D601:
    JSR Bank0_Func_94F1
    JSR Bank0_Func_8490
    JSR Bank0_Func_CF7A
    LDA $16
    AND #$03
    BNE Bank0_Label_D619
    LDA $9C
    CMP #$14
    BCC Bank0_Label_D619
    JSR Bank0_Func_D770

Bank0_Label_D619:
    JSR Bank0_Func_9B54
    DEC $9C
    BNE Bank0_Label_D601
    JSR Bank0_Func_C954
    JSR Bank0_Func_C949
    LDA #$0F
    STA a:$0400
    LDA #$00
    STA a:$0490
    LDA #$36
    STA a:$0430
    LDA #$01
    STA a:$0460
    LDA #$80
    STA a:$04C0
    LDA #$88
    STA a:$04F0
    LDA #$00
    STA $79
    LDA #$12
    STA $77
    LDA #$00
    STA $78
    LDA #$70
    STA $75
    LDA #$86
    STA $76
    LDA #$08
    STA a:$02AA

Bank0_Label_D65D:
    JSR Bank0_Func_94F1
    JSR Bank0_Func_8490
    JSR Bank0_Func_9B54
    LDA $16
    LSR A
    LSR A
    LSR A
    LSR A
    AND #$01
    ORA #$12
    STA $77
    LDA a:$02AA
    BNE Bank0_Label_D65D
    JMP Bank0_Func_8082

Bank0_Func_D67A:
    LDA a:$0460
    AND #$8F
    STA a:$0460
    LDA a:$0400
    BPL Bank0_Label_D68C
    LDA #$11
    JSR Bank0_Func_E398

Bank0_Label_D68C:
    LDA a:$0550
    BEQ Bank0_Label_D6D4
    LDA $9D
    CMP #$18
    BEQ Bank0_Label_D6BD
    AND #$80
    STA $00
    LDA $9D
    LSR A
    ORA $00
    LSR A
    ORA $00
    CLC
    ADC a:$04F0
    STA a:$04F0
    LDA #$3B
    STA a:$0430
    LDA $9D
    BMI Bank0_Label_D6B8
    LDA #$3A
    STA a:$0430

Bank0_Label_D6B8:
    INC $9D
    JMP Bank0_Label_D718

Bank0_Label_D6BD:
    LDA #$00
    STA a:$0550
    LDA #$38
    STA a:$0430
    JSR Bank0_Func_964A
    AND #$3F
    CLC
    ADC #$40
    STA $9F
    JMP Bank0_Label_D718

Bank0_Label_D6D4:
    LDA $16
    LSR A
    LSR A
    LSR A
    AND #$01
    ORA #$38
    STA a:$0430
    LDA a:$0580
    BEQ Bank0_Label_D6F7
    INC a:$04C0
    LDA a:$04C0
    CMP #$70
    BCC Bank0_Label_D706
    LDA #$00
    STA a:$0580
    JMP Bank0_Label_D706

Bank0_Label_D6F7:
    DEC a:$04C0
    LDA a:$04C0
    CMP #$08
    BCS Bank0_Label_D706
    LDA #$01
    STA a:$0580

Bank0_Label_D706:
    DEC $9F
    BPL Bank0_Label_D718
    LDA #$01
    STA a:$0550
    LDA #$EC
    STA $9D
    LDA #$3A
    STA a:$0430

Bank0_Label_D718:
    LDY #$00

Bank0_Label_D71A:
    LDA a:$040A,Y
    BEQ Bank0_Label_D725
    INY
    CPY #$04
    BNE Bank0_Label_D71A
    RTS

Bank0_Label_D725:
    LDA #$02
    STA a:$040A,Y
    LDA #$32
    STA a:$043A,Y
    LDA a:$0490
    STA a:$049A,Y
    LDA a:$04C0
    CLC
    ADC #$14
    STA a:$04CA,Y
    LDA a:$04F0
    STA a:$04FA,Y
    LDA #$01
    STA a:$046A,Y
    LDA #$FF
    STA a:$052A,Y
    JSR Bank0_Func_962F
    AND #$03
    CLC
    ADC #$01
    STA a:$055A,Y
    JSR Bank0_Func_962F
    AND #$07
    TAX
    LDA a:$9126,X
    STA a:$05BA,Y
    LDA #$00
    STA a:$05EA,Y
    LDA #$02
    STA a:$058A,Y
    RTS

Bank0_Func_D770:
    LDX #$00

Bank0_Label_D772:
    LDA a:$041E,X
    BEQ Bank0_Label_D77D
    INX
    CPX #$08
    BNE Bank0_Label_D772
    RTS

Bank0_Label_D77D:
    LDA #$80
    STA a:$041E,X
    LDA #$00
    STA a:$04AE,X
    LDA #$FF
    STA a:$053E,X
    JSR Bank0_Func_964A
    AND #$1F
    CLC
    ADC a:$04C0
    STA a:$04DE,X
    JSR Bank0_Func_964A
    AND #$1F
    CLC
    ADC a:$04F0
    STA a:$050E,X
    RTS
    .byte $0F, $01, $11, $1B, $0F, $09, $19, $29, $0F, $09, $19, $1B, $0F, $01, $11, $21
    .byte $0F, $15, $21, $30, $0F, $0F, $26, $30, $0F, $0F, $15, $30, $0F, $15, $25, $35
    .byte $0F, $07, $17, $37, $0F, $0C, $11, $31, $0F, $0C, $11, $07, $0F, $07, $00, $30
    .byte $0F, $15, $21, $30, $0F, $0F, $26, $30, $0F, $0F, $15, $30, $0F, $15, $25, $35
    .byte $0F, $09, $1C, $31, $0F, $06, $07, $26, $0F, $05, $15, $35, $0F, $07, $17, $26
    .byte $0F, $15, $21, $30, $0F, $01, $26, $30, $0F, $07, $15, $30, $0F, $15, $25, $35
    .byte $0F, $07, $17, $37, $0F, $06, $17, $26, $0F, $0C, $11, $07, $0F, $00, $10, $20
    .byte $0F, $15, $21, $30, $0F, $0F, $26, $30, $0F, $0F, $15, $30, $0F, $15, $25, $35
    .byte $0F, $07, $17, $27, $0F, $0F, $0F, $0F, $0F, $07, $17, $27, $0F, $07, $17, $27
    .byte $0F, $15, $21, $30, $0F, $01, $26, $30, $0F, $07, $15, $30, $0F, $15, $25, $35
    .byte $0F, $07, $17, $37, $0F, $07, $17, $27, $0F, $17, $27, $37, $0F, $00, $10, $20
    .byte $0F, $15, $21, $30, $0F, $0F, $26, $30, $0F, $0F, $15, $30, $0F, $15, $25, $35
    .byte $0F, $07, $16, $27, $0F, $09, $0B, $19, $0F, $05, $15, $35, $0F, $05, $15, $25
    .byte $0F, $15, $21, $30, $0F, $0F, $26, $30, $0F, $0F, $15, $30, $0F, $15, $25, $35
    .byte $0F, $01, $16, $27, $0F, $09, $0B, $19, $0F, $05, $15, $35, $0F, $01, $0F, $25
    .byte $0F, $15, $21, $30, $0F, $0F, $26, $30, $0F, $0F, $15, $30, $0F, $15, $25, $35
    .byte $0F, $07, $16, $27, $0F, $07, $0C, $19, $0F, $05, $15, $35, $0F, $06, $17, $29
    .byte $0F, $15, $21, $30, $0F, $0F, $26, $30, $0F, $0F, $15, $30, $0F, $15, $25, $35
    .byte $0F, $07, $16, $27, $0F, $07, $0C, $19, $0F, $05, $15, $35, $0F, $06, $17, $29
    .byte $0F, $15, $21, $30, $0F, $0F, $26, $30, $0F, $0F, $15, $30, $0F, $15, $25, $35
    .byte $0F, $01, $16, $27, $0F, $09, $0B, $19, $0F, $05, $15, $35, $0F, $01, $0F, $25
    .byte $0F, $15, $21, $30, $0F, $0F, $26, $30, $0F, $0F, $15, $30, $0F, $15, $25, $35
    .byte $0F, $01, $16, $27, $0F, $09, $0B, $19, $0F, $05, $15, $35, $0F, $01, $0F, $25
    .byte $0F, $15, $21, $30, $0F, $0F, $26, $30, $0F, $0F, $15, $30, $0F, $15, $25, $35
    .byte $7B, $39, $85, $A3, $29, $C5, $D0, $55, $83, $3B, $4D, $C5, $9B, $55, $C4, $BB
    .byte $0A, $C8, $A9, $55, $C7, $48, $36, $86, $88, $32, $06, $B2, $32, $06, $B0, $3A
    .byte $06, $CA, $3A, $00, $F4, $2A, $00, $13, $5A, $0A, $2B, $5A, $0A, $5F, $56, $0A
    .byte $8F, $56, $06, $40, $0A, $08, $50, $0A, $08, $5E, $1A, $0B, $68, $12, $06, $6F
    .byte $1A, $0A, $8C, $08, $09, $94, $1A, $0B, $A2, $12, $06, $D8, $1A, $0B, $F8, $0A
    .byte $06, $B0, $5A, $0B, $08, $32, $0A, $08, $3A, $06, $06, $1A, $01, $08, $12, $06
    .byte $08, $22, $00, $00, $BE, $92, $81, $2A, $CE, $C1, $10, $B0, $81, $7E, $1C, $C1
    .byte $C6, $64, $C1, $9A, $98, $81, $2B, $64, $C1, $1A, $E4, $C1, $EE, $F2, $80, $BE
    .byte $E2, $C0, $A0, $78, $80, $4C, $7A, $C0, $48, $AC, $80, $06, $6A, $C0, $EC, $0E
    .byte $80, $72, $46, $C0, $1E, $38, $80, $08, $0E, $C3, $0A, $28, $02, $0A, $F2, $03
    .byte $0C, $32, $00, $0C, $42, $03, $0C, $D0, $03, $10, $76, $05, $10, $82, $05, $12
    .byte $EC, $05, $14, $10, $03, $14, $18, $01, $14, $6C, $03, $14, $98, $05, $1A, $78
    .byte $05, $1A, $86, $05, $20, $0E, $02, $20, $98, $04, $20, $9C, $05, $22, $7C, $02
    .byte $24, $8C, $C7, $26, $44, $07, $2C, $B8, $05, $2E, $2E, $05, $30, $94, $02, $32
    .byte $0E, $01, $32, $EC, $05, $34, $AC, $03, $35, $BD, $C6, $36, $40, $01, $3C, $2C
    .byte $02, $3C, $B4, $05, $40, $8C, $05, $44, $0C, $01, $46, $48, $05, $4A, $A0, $03
    .byte $4A, $EC, $05, $4C, $70, $05, $4C, $7C, $05, $54, $9E, $05, $56, $22, $00, $56
    .byte $22, $05, $58, $E0, $05, $5C, $2E, $07, $5C, $D6, $03, $62, $92, $02, $64, $78
    .byte $05, $66, $9A, $05, $68, $10, $04, $6A, $20, $05, $70, $32, $05, $80, $22, $01
    .byte $82, $34, $01, $82, $40, $03, $85, $C0, $C6, $86, $DA, $03, $90, $22, $05, $90
    .byte $86, $05, $90, $A8, $05, $94, $34, $05, $96, $B4, $05, $98, $10, $C9, $99, $A4
    .byte $05, $A0, $6E, $07, $A2, $22, $01, $A6, $EA, $00, $A8, $1C, $02, $A8, $3C, $07
    .byte $A8, $B4, $03, $A9, $B9, $CB, $B0, $D0, $03, $B1, $85, $03, $B4, $C0, $04, $BA
    .byte $46, $05, $BE, $0A, $03, $BE, $1E, $05, $C0, $9C, $02, $C0, $C0, $05, $CA, $D2
    .byte $05, $CC, $1A, $04, $D0, $0E, $02, $D2, $32, $05, $DC, $24, $01, $DC, $46, $03
    .byte $E6, $1C, $05, $E6, $68, $02, $E8, $18, $05, $E9, $98, $87, $EA, $30, $02, $EA
    .byte $80, $04, $EA, $AC, $04, $EC, $BC, $05, $F2, $44, $05, $F2, $72, $05, $F4, $A4
    .byte $05, $FA, $BD, $C6, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $00, $00, $00, $00, $01, $01, $00, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $00, $00, $00, $00, $01, $01, $00, $01, $01, $00, $01
    .byte $01, $01, $01, $01, $01, $01, $00, $00, $01, $00, $00, $00, $00, $00, $00, $01
    .byte $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $01, $01, $00, $01
    .byte $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $01, $01, $01, $00, $00
    .byte $01, $01, $00, $00, $01, $01, $01, $00, $00, $00, $00, $01, $01, $01, $00, $00
    .byte $01, $01, $01, $00, $01, $A5, $16, $29, $03, $D0, $0F, $FE, $30, $04, $BD, $30
    .byte $04, $C9, $67, $90, $05, $A9, $64, $9D, $30, $04, $BD, $50, $05, $D0, $1E, $20
    .byte $4A, $96, $29, $89, $C9, $89, $F0, $07, $A5, $79, $D0, $06, $20, $87, $89, $9D
    .byte $80, $05, $20, $4A, $96, $29, $1F, $18, $69, $10, $9D, $50, $05, $BD, $80, $05
    .byte $30, $03, $20, $62, $89, $DE, $50, $05, $BD, $10, $06, $D0, $0D, $20, $30, $91
    .byte $20, $4A, $96, $29, $1F, $69, $20, $9D, $10, $06, $DE, $10, $06, $60, $20, $A0
    .byte $8E, $A5, $00, $48, $A5, $01, $48, $20, $87, $89, $9D, $80, $05, $68, $85, $01
    .byte $68, $85, $00, $60, $BD, $50, $05, $D0, $27, $20, $4A, $96, $29, $07, $18, $69
    .byte $10, $9D, $50, $05, $A5, $79, $D0, $18, $20, $87, $89, $38, $FD, $80, $05, $29
    .byte $07, $F0, $0D, $C9, $04, $90, $06, $DE, $80, $05, $4C, $75, $DC, $FE, $80, $05
    .byte $BD, $80, $05, $20, $62, $89, $20, $62, $89, $DE, $50, $05, $BD, $80, $05, $29
    .byte $04, $F0, $04, $A9, $5E, $D0, $02, $A9, $5C, $85, $00, $A5, $16, $4A, $4A, $4A
    .byte $29, $01, $05, $00, $9D, $30, $04, $BD, $10, $06, $D0, $0D, $20, $30, $91, $20
    .byte $4A, $96, $29, $1F, $69, $50, $9D, $10, $06, $DE, $E0, $05, $60, $A9, $02, $85
    .byte $99, $85, $9A, $FE, $80, $05, $BD, $80, $05, $29, $30, $F0, $54, $BD, $80, $05
    .byte $4A, $4A, $4A, $29, $01, $09, $56, $9D, $30, $04, $BD, $50, $05, $30, $0D, $BD
    .byte $80, $05, $29, $07, $D0, $0F, $20, $87, $89, $4C, $E7, $DC, $BD, $50, $05, $18
    .byte $69, $08, $9D, $50, $05, $BD, $50, $05, $20, $62, $89, $20, $D4, $8A, $BD, $50
    .byte $05, $20, $45, $8B, $90, $1B, $BD, $50, $05, $49, $04, $20, $62, $89, $A9, $00
    .byte $9D, $50, $05, $20, $4A, $96, $C9, $80, $90, $07, $29, $07, $09, $80, $9D, $50
    .byte $05, $A5, $5C, $C9, $48, $B0, $0C, $BD, $80, $05, $29, $3F, $C9, $08, $D0, $03
    .byte $20, $30, $91, $60, $BD, $80, $05, $4A, $A8, $B9, $BB, $DD, $20, $A6, $8A, $BD
    .byte $50, $05, $F0, $07, $30, $05, $29, $07, $20, $62, $89, $BD, $80, $05, $4A, $4A
    .byte $4A, $29, $01, $85, $00, $BD, $30, $04, $29, $FE, $05, $00, $9D, $30, $04, $FE
    .byte $80, $05, $BD, $80, $05, $C9, $10, $90, $47, $A9, $00, $9D, $80, $05, $A9, $00
    .byte $9D, $50, $05, $20, $8E, $DE, $C9, $60, $B0, $36, $C9, $28, $90, $32, $20, $87
    .byte $89, $09, $08, $9D, $50, $05, $29, $07, $A8, $B9, $C3, $DD, $85, $A0, $B9, $CB
    .byte $DD, $85, $A2, $20, $12, $DE, $20, $E8, $A6, $C9, $42, $B0, $0E, $20, $E8, $A6
    .byte $C9, $42, $B0, $07, $20, $E2, $A6, $C9, $42, $90, $05, $A9, $00, $9D, $50, $05
    .byte $A5, $5C, $C9, $50, $B0, $0F, $20, $8E, $DE, $C9, $30, $B0, $08, $BD, $50, $05
    .byte $D0, $03, $20, $B0, $90, $60, $FD, $FE, $FF, $00, $00, $01, $02, $03, $00, $10
    .byte $10, $10, $00, $F0, $F0, $F0, $1C, $1C, $0C, $FC, $FC, $FC, $0C, $1C, $BD, $80
    .byte $05, $4A, $4A, $18, $69, $FD, $20, $A6, $8A, $BD, $80, $05, $4A, $4A, $4A, $29
    .byte $01, $85, $00, $BD, $30, $04, $29, $FE, $05, $00, $9D, $30, $04, $FE, $80, $05
    .byte $BD, $80, $05, $C9, $1C, $90, $08, $A9, $00, $9D, $80, $05, $9D, $50, $05, $20
    .byte $2F, $96, $C9, $10, $B0, $06, $20, $B0, $90, $20, $30, $91, $60, $BD, $90, $04
    .byte $85, $A4, $A5, $1B, $29, $07, $18, $65, $A0, $10, $0C, $7D, $C0, $04, $85, $A0
    .byte $A5, $A4, $E9, $00, $4C, $35, $DE, $7D, $C0, $04, $85, $A0, $A5, $A4, $69, $00
    .byte $4A, $66, $A0, $4A, $66, $A0, $A5, $A0, $29, $80, $46, $A0, $05, $A0, $18, $65
    .byte $5B, $85, $A0, $BD, $90, $04, $4A, $4A, $85, $A4, $A5, $1C, $29, $07, $18, $65
    .byte $A2, $10, $0C, $7D, $F0, $04, $85, $A2, $A5, $A4, $E9, $00, $4C, $6D, $DE, $7D
    .byte $F0, $04, $85, $A2, $A5, $A4, $69, $00, $4A, $66, $A2, $4A, $66, $A2, $A5, $A2
    .byte $29, $80, $46, $A2, $05, $A2, $18, $65, $5C, $85, $A2, $86, $A4, $A6, $A0, $A4
    .byte $A2, $20, $A7, $A6, $A6, $A4, $C9, $42, $60, $BD, $90, $04, $29, $0F, $D0, $23
    .byte $38, $BD, $C0, $04, $E5, $75, $B0, $05, $49, $FF, $18, $69, $01, $85, $A0, $38
    .byte $BD, $F0, $04, $E5, $76, $B0, $05, $49, $FF, $18, $69, $01, $C5, $A0, $B0, $02
    .byte $A5, $A0, $60, $A9, $FF, $60, $A9, $02, $85, $99, $85, $9A, $FE, $50, $05, $BD
    .byte $50, $05, $4A, $4A, $4A, $4A, $29, $01, $85, $00, $BD, $30, $04, $29, $FE, $05
    .byte $00, $9D, $30, $04, $BD, $30, $04, $29, $02, $F0, $04, $A9, $06, $D0, $02, $A9
    .byte $02, $48, $20, $62, $89, $20, $D4, $8A, $68, $48, $20, $45, $8B, $90, $0F, $68
    .byte $49, $04, $20, $62, $89, $BD, $30, $04, $49, $02, $9D, $30, $04, $48, $68, $20
    .byte $65, $90, $60, $FE, $50, $05, $BD, $50, $05, $4A, $4A, $4A, $4A, $29, $01, $85
    .byte $00, $BD, $30, $04, $29, $FE, $05, $00, $9D, $30, $04, $BD, $50, $05, $29, $01
    .byte $D0, $01, $60, $BD, $30, $04, $29, $02, $F0, $04, $A9, $06, $D0, $02, $A9, $02
    .byte $48, $20, $62, $89, $68, $48, $49, $04, $29, $04, $0A, $0A, $85, $A0, $A9, $08
    .byte $85, $A2, $20, $12, $DE, $90, $12, $68, $49, $04, $20, $62, $89, $BD, $30, $04
    .byte $49, $02, $9D, $30, $04, $20, $65, $90, $60, $A9, $11, $85, $A2, $A9, $08, $85
    .byte $A0, $20, $12, $DE, $90, $E1, $68, $20, $65, $90, $60, $A9, $02, $85, $99, $85
    .byte $9A, $DE, $50, $05, $10, $41, $A9, $1E, $9D, $50, $05, $20, $87, $89, $29, $06
    .byte $85, $01, $20, $4A, $96, $C9, $40, $B0, $06, $A5, $01, $49, $04, $85, $01, $A5
    .byte $01, $29, $02, $F0, $06, $A5, $01, $0A, $4C, $A3, $DF, $BD, $80, $05, $29, $08
    .byte $05, $01, $9D, $80, $05, $20, $4A, $96, $C9, $40, $B0, $0B, $BD, $80, $05, $09
    .byte $80, $9D, $80, $05, $5E, $50, $05, $BD, $80, $05, $30, $22, $20, $62, $89, $20
    .byte $D4, $8A, $BD, $80, $05, $20, $45, $8B, $90, $14, $BD, $80, $05, $49, $04, $29
    .byte $07, $20, $62, $89, $A9, $00, $9D, $50, $05, $9D, $80, $05, $F0, $18, $BD, $10
    .byte $06, $D0, $13, $20, $4A, $96, $29, $1F, $69, $60, $9D, $10, $06, $A5, $5C, $C9
    .byte $48, $B0, $03, $20, $30, $91, $DE, $10, $06, $BD, $80, $05, $29, $08, $49, $08
    .byte $85, $01, $A5, $16, $4A, $29, $04, $05, $01, $4A, $4A, $18, $69, $4C, $9D, $30
    .byte $04, $60, $A9, $3C, $9D, $50, $05, $4C, $A0, $8E, $A9, $02, $85, $99, $85, $9A
    .byte $BD, $80, $05, $D0, $24, $DE, $50, $05, $10, $17, $20, $87, $89, $29, $04, $09
    .byte $02, $9D, $80, $05, $29, $04, $F0, $04, $A9, $50, $D0, $02, $A9, $52, $9D, $30
    .byte $04, $BD, $80, $05, $D0, $03, $4C, $D7, $E0, $29, $08, $D0, $12, $20, $8E, $DE
    .byte $B0, $69, $BD, $80, $05, $09, $08, $9D, $80, $05, $A9, $FA, $9D, $50, $05, $20
    .byte $1A, $E1, $DE, $F0, $04, $20, $D4, $8A, $FE, $F0, $04, $BD, $80, $05, $20, $45
    .byte $8B, $90, $03, $20, $0A, $E1, $BD, $50, $05, $20, $A6, $8A, $20, $D4, $8A, $BD
    .byte $50, $05, $30, $1C, $A9, $00, $20, $45, $8B, $90, $26, $A9, $01, $20, $27, $E1
    .byte $A9, $00, $9D, $80, $05, $A9, $1E, $9D, $50, $05, $A9, $54, $9D, $30, $04, $60
    .byte $A9, $04, $20, $45, $8B, $90, $0A, $A9, $11, $20, $27, $E1, $A9, $00, $9D, $50
    .byte $05, $A5, $16, $29, $03, $D0, $03, $FE, $50, $05, $60, $20, $1A, $E1, $DE, $F0
    .byte $04, $20, $D4, $8A, $FE, $F0, $04, $BD, $80, $05, $20, $45, $8B, $90, $03, $20
    .byte $0A, $E1, $FE, $F0, $04, $20, $D4, $8A, $DE, $F0, $04, $20, $65, $8B, $B0, $0D
    .byte $BD, $80, $05, $09, $08, $9D, $80, $05, $A9, $01, $9D, $50, $05, $A5, $16, $29
    .byte $03, $D0, $08, $BD, $30, $04, $49, $01, $9D, $30, $04, $60, $20, $D4, $8A, $BD
    .byte $80, $05, $4C, $45, $8B, $BD, $30, $04, $49, $02, $9D, $30, $04, $BD, $80, $05
    .byte $49, $04, $9D, $80, $05, $BD, $80, $05, $29, $07, $48, $20, $62, $89, $68, $4C
    .byte $62, $89, $48, $A5, $1C, $29, $07, $85, $09, $68, $18, $7D, $F0, $04, $18, $65
    .byte $09, $29, $F8, $38, $E9, $01, $38, $E5, $09, $9D, $F0, $04, $60, $20, $4A, $96
    .byte $9D, $50, $05, $4C, $A0, $8E, $A9, $02, $85, $99, $85, $9A, $DE, $50, $05, $BD
    .byte $50, $05, $BC, $80, $05, $F0, $4C, $88, $F0, $30, $88, $F0, $1F, $A8, $D0, $1B
    .byte $BD, $30, $04, $C9, $70, $F0, $09, $DE, $30, $04, $A9, $05, $9D, $50, $05, $60
    .byte $A9, $00, $9D, $80, $05, $20, $4A, $96, $9D, $50, $05, $60, $A8, $08, $20, $B0
    .byte $90, $28, $D0, $F7, $FE, $80, $05, $4C, $6F, $E1, $A8, $D0, $EE, $BD, $30, $04
    .byte $C9, $72, $F0, $09, $FE, $30, $04, $A9, $0A, $9D, $50, $05, $60, $FE, $80, $05
    .byte $4C, $7A, $E1, $A8, $08, $20, $87, $89, $48, $20, $62, $89, $20, $D4, $8A, $68
    .byte $48, $20, $45, $8B, $90, $07, $68, $48, $49, $04, $20, $62, $89, $68, $28, $D0
    .byte $0B, $A9, $70, $9D, $30, $04, $FE, $80, $05, $4C, $9C, $E1, $A5, $16, $29, $08
    .byte $F0, $08, $BD, $30, $04, $49, $01, $9D, $30, $04, $60, $BD, $50, $05, $4A, $4A
    .byte $29, $0F, $A8, $B9, $31, $E2, $20, $A6, $8A, $BD, $50, $05, $29, $3F, $D0, $06
    .byte $20, $87, $89, $9D, $80, $05, $BD, $80, $05, $09, $01, $20, $62, $89, $A5, $16
    .byte $29, $01, $09, $6C, $9D, $30, $04, $BD, $80, $05, $4A, $29, $02, $1D, $30, $04
    .byte $9D, $30, $04, $BD, $10, $06, $D0, $0D, $20, $30, $91, $20, $4A, $96, $29, $1F
    .byte $69, $50, $9D, $10, $06, $DE, $10, $06, $FE, $50, $05, $60, $03, $02, $01, $00
    .byte $00, $FF, $FE, $FD, $FD, $FE, $FF, $00, $00, $01, $02, $03, $A9, $80, $9D, $50
    .byte $05, $4C, $A0, $8E, $A9, $02, $85, $99, $A9, $03, $85, $9A, $BD, $80, $05, $D0
    .byte $05, $DE, $50, $05, $10, $64, $BD, $80, $05, $29, $08, $D0, $23, $20, $30, $91
    .byte $A5, $16, $29, $1F, $D0, $70, $20, $34, $89, $20, $4A, $96, $C9, $20, $B0, $66
    .byte $4C, $DB, $E2, $BD, $80, $05, $09, $08, $9D, $80, $05, $A9, $FA, $9D, $50, $05
    .byte $20, $5A, $89, $20, $D4, $8A, $BD, $80, $05, $20, $45, $8B, $90, $03, $20, $52
    .byte $89, $BD, $50, $05, $20, $A6, $8A, $20, $D4, $8A, $BD, $50, $05, $30, $1C, $A9
    .byte $00, $20, $45, $8B, $90, $26, $A9, $01, $20, $27, $E1, $A9, $00, $9D, $80, $05
    .byte $A9, $14, $9D, $50, $05, $A9, $3E, $9D, $30, $04, $60, $A9, $04, $20, $45, $8B
    .byte $90, $0A, $A9, $11, $20, $27, $E1, $A9, $00, $9D, $50, $05, $A5, $16, $29, $03
    .byte $D0, $03, $FE, $50, $05, $60, $FE, $F0, $04, $20, $D4, $8A, $DE, $F0, $04, $20
    .byte $65, $8B, $B0, $0D, $BD, $80, $05, $09, $08, $9D, $80, $05, $A9, $01, $9D, $50
    .byte $05, $20, $5A, $89, $20, $D4, $8A, $BD, $80, $05, $20, $45, $8B, $90, $03, $20
    .byte $52, $89, $A5, $16, $29, $03, $D0, $B2, $BD, $30, $04, $49, $01, $9D, $30, $04
    .byte $60, $00, $54, $64, $4C, $40, $44, $04, $38, $34, $3C, $1C, $50, $58, $60, $2C
    .byte $28, $08, $48, $30, $20, $24, $18, $14, $10, $0C, $5C, $33, $E4, $32, $E4, $54
    .byte $E5, $6C, $E5, $AB, $E5, $C5, $E5, $EF, $E8, $F9, $E8, $EF, $E8, $F9, $E8, $EF
    .byte $E8, $F9, $E8, $EF, $E8, $F9, $E8, $8C, $E6, $99, $E6, $AD, $E8, $C2, $E7, $B6
    .byte $E8, $D3, $E8, $AE, $E7, $C2, $E7, $6B, $E7, $7A, $E7, $6C, $E8, $87, $E8, $43
    .byte $E6, $25, $E4, $15, $E6, $25, $E4, $5C, $E6, $73, $E6, $1D, $E5, $C2, $E7, $25
    .byte $E5, $C2, $E7, $3B, $E8, $4F, $E8, $2D, $E6, $25, $E4, $F2, $E6, $25, $E4, $0D
    .byte $E7, $25, $E4, $60, $E4, $82, $E4, $60, $E4, $CB, $E4, $23, $E7, $37, $E7, $FB
    .byte $E4, $2A, $E4

Bank0_Func_E398:
    CMP #$1A
    BCS Bank0_Label_E3B6
    STX $3C
    LDX a:$02A0
    BMI Bank0_Label_E3B1
    STY $3D
    TAY
    LDA a:$E316,X
    CMP a:$E316,Y
    BCC Bank0_Label_E3B7
    TYA
    LDY $3D

Bank0_Label_E3B1:
    STA a:$02A0

Bank0_Label_E3B4:
    LDX $3C

Bank0_Label_E3B6:
    RTS

Bank0_Label_E3B7:
    LDY $3D
    JMP Bank0_Label_E3B4

Bank0_Func_E3BC:
    CMP #$1A
    BCS Bank0_Label_E3B6
    STX $3C
    LDX #$00
    STX a:$02A1
    STA a:$02A0
    LDX $3C
    RTS

Bank0_Func_E3CD:
    LDX #$03

Bank0_Label_E3CF:
    LDA a:$02A3,X
    BEQ Bank0_Label_E3D7
    DEC a:$02A3,X

Bank0_Label_E3D7:
    DEX
    BPL Bank0_Label_E3CF
    LDA a:$02A0
    BMI Bank0_Label_E414
    TAX
    ORA #$80
    STA a:$02A0
    CPX #$1A
    BCS Bank0_Label_E414
    LDA a:$02A1
    BEQ Bank0_Label_E3FD
    LDA a:$E316,X
    CMP a:$02A1
    BCC Bank0_Label_E3FD
    BNE Bank0_Label_E414
    LDA a:$02A2
    BNE Bank0_Label_E414

Bank0_Label_E3FD:
    LDA a:$E316,X
    STA a:$02A1
    TAX
    LDA #$00
    STA a:$02A3
    STA a:$02A4
    STA a:$02A5
    STA a:$02A6
    BEQ Bank0_Label_E419

Bank0_Label_E414:
    LDX a:$02A1
    INX
    INX

Bank0_Label_E419:
    CPX #$68
    BCS Bank0_Label_E42B
    LDA a:$E331,X
    PHA
    LDA a:$E330,X
    PHA
    RTS
    .byte $CE, $A7, $02, $D0, $08

Bank0_Label_E42B:
    LDA #$00
    STA a:$02A1
    STA a:$02A2
    RTS
    .byte $A9, $00, $8D, $A2, $02, $8D, $11, $40, $8D, $A3, $02, $8D, $A4, $02, $8D, $A5
    .byte $02, $8D, $A6, $02, $8D, $08, $40, $8D, $0C, $40, $A9, $18, $8D, $0B, $40, $A9
    .byte $10, $8D, $00, $40, $8D, $04, $40, $A9, $0F, $8D, $15, $40, $60, $A9, $18, $8D
    .byte $A6, $02, $A9, $00, $8D, $0C, $40, $A9, $0C, $8D, $A7, $02, $8D, $0E, $40, $A9
    .byte $08, $8D, $0F, $40, $A9, $00, $8D, $A8, $02, $A9, $04, $8D, $A9, $02, $60, $AE
    .byte $A8, $02, $F0, $2B, $CA, $F0, $03, $4C, $26, $E4, $CE, $A7, $02, $AD, $A7, $02
    .byte $8D, $0E, $40, $C9, $08, $D0, $30, $EE, $A8, $02, $A9, $1A, $8D, $0C, $40, $A9
    .byte $03, $8D, $0E, $40, $A9, $F8, $8D, $0F, $40, $A9, $10, $8D, $A7, $02, $60, $CE
    .byte $A9, $02, $D0, $13, $EE, $A8, $02, $A9, $04, $8D, $0C, $40, $AD, $A7, $02, $8D
    .byte $0E, $40, $A9, $08, $8D, $0F, $40, $60, $AE, $A8, $02, $F0, $E2, $CA, $F0, $03
    .byte $4C, $26, $E4, $CE, $A7, $02, $AD, $A7, $02, $8D, $0E, $40, $C9, $08, $D0, $E7
    .byte $EE, $A8, $02, $A9, $1A, $8D, $0C, $40, $A9, $06, $8D, $0E, $40, $A9, $68, $8D
    .byte $0F, $40, $A9, $06, $8D, $A7, $02, $60, $A9, $04, $8D, $A5, $02, $8D, $A6, $02
    .byte $8D, $A7, $02, $A9, $1F, $8D, $0C, $40, $A9, $0F, $8D, $0E, $40, $A0, $08, $A2
    .byte $F0, $A9, $38, $20, $65, $E9, $8D, $0F, $40, $60, $A0, $60, $A9, $17, $A2, $00
    .byte $F0, $06, $A0, $08, $A9, $01, $A2, $05, $8C, $A4, $02, $8D, $A7, $02, $8E, $A9
    .byte $02, $A9, $01, $8D, $A8, $02, $20, $40, $E5, $4C, $C3, $E7, $A9, $08, $8D, $A6
    .byte $02, $A9, $01, $8D, $0C, $40, $A9, $0A, $8D, $0E, $40, $A9, $08, $8D, $0F, $40
    .byte $60, $A9, $48, $8D, $A3, $02, $8D, $A4, $02, $8D, $A5, $02, $8D, $A6, $02, $A9
    .byte $01, $8D, $A7, $02, $A9, $04, $8D, $A8, $02, $AD, $A8, $02, $D0, $03, $4C, $26
    .byte $E4, $CE, $A7, $02, $D0, $DA, $CE, $A8, $02, $F0, $1A, $A9, $04, $8D, $A7, $02
    .byte $AD, $A8, $02, $4A, $90, $0B, $A9, $82, $A2, $00, $20, $49, $E9, $A2, $69, $D0
    .byte $12, $A9, $82, $D0, $07, $A9, $3C, $8D, $A7, $02, $A9, $8F, $A2, $00, $20, $49
    .byte $E9, $A2, $8D, $A9, $08, $4C, $57, $E9, $A9, $6F, $85, $2D, $A9, $E9, $85, $2E
    .byte $A9, $01, $8D, $A7, $02, $8D, $A2, $02, $A9, $09, $8D, $A8, $02, $A9, $83, $8D
    .byte $A9, $02, $20, $FD, $E5, $A2, $00, $AD, $A8, $02, $9D, $A3, $02, $8A, $0A, $0A
    .byte $AA, $AD, $A9, $02, $9D, $00, $40, $A9, $00, $9D, $01, $40, $A0, $00, $B1, $2D
    .byte $F0, $10, $0A, $A8, $B9, $34, $EE, $9D, $02, $40, $B9, $35, $EE, $09, $08, $9D
    .byte $03, $40

Bank0_Label_E5F6:
    INC $2D
    BNE Bank0_Label_E5FC
    INC $2E

Bank0_Label_E5FC:
    RTS
    .byte $CE, $A7, $02, $D0, $11, $AD, $A8, $02, $8D, $A7, $02, $A0, $00, $B1, $2D, $C9
    .byte $FF, $D0, $05, $20, $2B, $E4, $68, $68, $60, $A9, $04, $8D, $A3, $02, $8D, $A7
    .byte $02, $8D, $A2, $02, $A9, $00, $AA, $20, $49, $E9, $A2, $3E, $A9, $38, $4C, $57
    .byte $E9, $A9, $0A, $8D, $A4, $02, $8D, $A7, $02, $A9, $42, $A2, $00, $20, $50, $E9
    .byte $A2, $BB, $A9, $08, $4C, $5E, $E9, $A9, $04, $8D, $A5, $02, $8D, $A7, $02, $8D
    .byte $A2, $02, $A9, $84, $A2, $8A, $20, $49, $E9, $A2, $7E, $A9, $38, $4C, $57, $E9
    .byte $A9, $10, $8D, $A6, $02, $8D, $A8, $02, $A9, $0C, $8D, $A7, $02, $A9, $04, $8D
    .byte $0C, $40, $A9, $08, $8D, $0F, $40, $AD, $A7, $02, $8D, $0E, $40, $AD, $A7, $02
    .byte $C9, $0F, $F0, $03, $EE, $A7, $02, $CE, $A8, $02, $D0, $03, $4C, $2B, $E4, $60
    .byte $A9, $78, $85, $2D, $A9, $E9, $85, $2E, $A9, $01, $8D, $A7, $02, $CE, $A7, $02
    .byte $D0, $ED, $A0, $00, $B1, $2D, $C9, $FF, $F0, $E2, $8D, $A7, $02, $8D, $A3, $02
    .byte $8D, $A4, $02, $8D, $A5, $02, $8D, $A6, $02, $20, $F6, $E5, $A2, $00, $20, $C1
    INC $20
    CMP ($E6,X)
    LDY #$00
    LDA ($2D),Y
    BEQ Bank0_Label_E6EC
    ASL A
    TAY
    LDA a:$02A7
    CPX #$08
    BEQ Bank0_Label_E6D5
    LSR A
    ORA #$C0
    BNE Bank0_Label_E6D6

Bank0_Label_E6D5:
    ASL A

Bank0_Label_E6D6:
    STA a:$4000,X
    LDA #$00
    STA a:$4001,X
    LDA a:$EE34,Y
    STA a:$4002,X
    LDA a:$EE35,Y
    ORA #$08
    STA a:$4003,X

Bank0_Label_E6EC:
    INX
    INX
    INX
    INX
    JMP Bank0_Label_E5F6
    .byte $A9, $18, $8D, $A4, $02, $A9, $10, $8D, $A7, $02, $8D, $A2, $02, $A9, $A0, $A2
    .byte $9B, $20, $50, $E9, $A2, $FE, $A9, $19, $4C, $5E, $E9, $A9, $08, $8D, $A4, $02
    .byte $8D, $A7, $02, $A9, $C0, $A2, $83, $20, $50, $E9, $A2, $60, $A9, $08, $4C, $5E
    .byte $E9, $A9, $18, $8D, $A6, $02, $A9, $04, $8D, $0E, $40, $A9, $0F, $8D, $A7, $02
    .byte $A9, $00, $8D, $A8, $02, $AD, $A7, $02, $C9, $10, $F0, $25, $09, $10, $8D, $0C
    .byte $40, $A9, $28, $8D, $0F, $40, $AD, $A8, $02, $F0, $04, $EE, $A7, $02, $60, $AD
    .byte $A7, $02, $C9, $02, $90, $07, $CE, $A7, $02, $CE, $A7, $02, $60, $EE, $A8, $02
    .byte $60, $A9, $10, $8D, $0C, $40, $4C, $2B, $E4, $A9, $03, $8D, $A8, $02, $A9, $FF
    .byte $8D, $A4, $02, $A9, $00, $8D, $A7, $02, $AD, $A7, $02, $D0, $27, $AD, $A8, $02
    .byte $D0, $08, $A9, $00, $8D, $A4, $02, $4C, $2B, $E4, $CE, $A8, $02, $A9, $84, $A2
    .byte $8B, $20, $50, $E9, $AC, $A8, $02, $BE, $AB, $E7, $A9, $10, $20, $5E, $E9, $A9
    .byte $04, $8D, $A7, $02, $CE, $A7, $02, $60
    .incbin "assets/generated/audio/sfx/prg0-tone-low.bin", $0, $4  ; rom-asset .byte
    .byte $A0, $14, $A9, $04
    .byte $A2, $03, $8C, $A4, $02, $8D, $A7, $02, $8E, $A9, $02, $A9, $01, $8D, $A8, $02
    .byte $CE, $A8, $02, $D0, $26, $AD, $A7, $02, $30, $22, $18, $6D, $A9, $02, $0A, $A8
    .byte $A9, $DF, $A2, $8C, $20, $50, $E9, $B9, $F2, $E7, $AA, $B9, $F3, $E7, $09, $88
    .byte $20, $5E, $E9, $CE, $A7, $02, $A9, $04, $8D, $A8, $02, $60, $4C, $2B, $E4
    .incbin "assets/generated/audio/sfx/prg0-pitch-periods.bin", $0, $1  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg0-pitch-periods.bin", $1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg0-pitch-periods.bin", $11, $9  ; rom-asset .byte
    AND $00,X
    BIT a:$3303
    ASL $2B
    .incbin "assets/generated/audio/sfx/prg0-pitch-periods.bin", $21, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg0-pitch-periods.bin", $31, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg0-pitch-periods.bin", $41, $9  ; rom-asset .byte
    .byte $A9, $10, $8D, $A5, $02, $A9, $40
    .byte $8D, $A7, $02, $A9, $01, $8D, $A8, $02, $A9, $30, $8D, $A9, $02, $A0, $01, $AE
    .byte $A7, $02, $A9, $08, $20, $65, $E9, $AD, $A7, $02, $38, $ED, $A8, $02, $8D, $A7
    .byte $02, $CD, $A9, $02, $D0, $03, $4C, $2B, $E4, $60, $A9, $0E, $8D, $A4, $02, $A9
    .byte $06, $8D, $A7, $02, $8D, $A8, $02, $A9, $9F, $A2, $8D, $20, $50, $E9, $A2, $00
    .byte $A9, $89, $4C, $5E, $E9, $CE, $A7, $02, $D0, $20, $AD, $A8, $02, $F0, $18, $A9
    .byte $08, $8D, $A7, $02, $A9, $00, $8D, $A8, $02, $A9, $9F, $A2, $8C, $20, $50, $E9
    .byte $A2, $80, $A9, $88, $4C, $5E, $E9, $4C, $2B, $E4, $60, $A0, $34, $A9, $0C, $A2
    .byte $18, $4C, $B5, $E7, $A9, $20, $8D, $A4, $02, $A9, $1F, $A2, $85, $20, $50, $E9
    .byte $A2, $69, $A9, $08, $20, $5E, $E9, $A9, $02, $8D, $A7, $02, $A9, $01, $8D, $A8
    .byte $02, $CE, $A8, $02, $D0, $76, $A9, $04, $8D, $A8, $02, $AC, $A7, $02, $B9, $EF
    .byte $E8, $8D, $04, $40, $CE, $A7, $02, $10, $63, $4C, $2B, $E4, $00, $A9, $00, $8D
    .byte $A7, $02, $A9, $01, $8D, $A8, $02, $CE, $A8, $02, $D0, $20, $AD, $A7, $02, $49
    .byte $04, $8D, $A7, $02, $A8, $B9, $34, $E9, $8D, $A8, $02, $A9, $DF, $BE, $31, $E9
    .byte $20, $49, $E9, $BE, $32, $E9, $B9, $33, $E9, $4C, $57, $E9, $60, $A9, $08, $D0
    .byte $CE, $A9, $10, $D0, $CA, $4C, $FA, $E8, $4C, $24, $E9, $4C, $FA, $E8
    .incbin "assets/generated/audio/sfx/prg0-pulse-control.bin", $0, $2  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg0-pulse-steps.bin", $0, $5  ; rom-asset .byte
    PHP
    STA a:$FC80
    ASL $85
    BRK
    .incbin "assets/generated/audio/sfx/prg3-pulse-steps.bin", $C, $A  ; rom-asset .byte
    .byte $8D, $00, $40, $8E, $01, $40
    .byte $60, $8D, $04, $40, $8E, $05, $40, $60, $8E, $02, $40, $8D, $03, $40, $60, $8E
    .byte $06, $40, $8D, $07, $40, $60, $8C, $08, $40, $8E, $0A, $40, $8D, $0B, $40, $60
    .byte $2C, $31, $2C, $31, $35, $38, $3D, $41, $FF, $08, $2E, $2B, $27, $08, $30, $2C
    .byte $29, $08, $32, $2D, $2A, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E
    .byte $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E
    .byte $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E
    .byte $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E
    .byte $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $FF

Bank0_Label_E9C9:
    BMI Bank0_Label_E9EE
    ORA #$80
    STA a:$02AB

Bank0_Func_E9D0:
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

Bank0_Label_E9EE:
    LDX #$00
    JSR Bank0_Func_EAC0
    INX
    JSR Bank0_Func_EAC0
    INX
    INX
    JMP Bank0_Func_EAC0
    .byte $60

Bank0_Func_E9FD:
    LDA a:$02AB
    BNE Bank0_Label_E9C9
    LDA a:$02AA
    BEQ Bank0_Label_E9EE
    BPL Bank0_Label_EA0C
    JMP Bank0_Label_EA90

Bank0_Label_EA0C:
    LDA a:$02AA
    CMP #$09
    BCC Bank0_Label_EA16
    JMP Bank0_Label_EABA

Bank0_Label_EA16:
    ORA #$80
    STA a:$02AA
    ASL A
    ASL A
    ASL A
    TAY
    LDX #$07

Bank0_Label_EA21:
    LDA a:$EFFA,Y
    STA $2F,X
    STA a:$02DC,X
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
    JSR Bank0_Func_E9D0

Bank0_Label_EA90:
    LDA #$00
    STA a:$02FE
    STA a:$02FD

Bank0_Label_EA98:
    LDX a:$02FD
    DEC a:$02B0,X
    BEQ Bank0_Label_EAA6
    JSR Bank0_Func_EAC0
    JMP Bank0_Label_EAA9

Bank0_Label_EAA6:
    JSR Bank0_Func_EB0C

Bank0_Label_EAA9:
    INC a:$02FD
    LDA a:$02FD
    CMP #$04
    BCC Bank0_Label_EA98
    LDA a:$02FE
    CMP #$04
    BNE Bank0_Label_EABF

Bank0_Label_EABA:
    LDA #$00
    STA a:$02AA

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
    STA a:$02FF
    BCC Bank0_Label_EADF
    LDA a:$02B8,X
    SEC
    SBC a:$02FF
    BCS Bank0_Label_EAEA
    BCC Bank0_Label_EAE8

Bank0_Label_EADF:
    LDA a:$02B8,X
    CLC
    ADC a:$02FF
    BCC Bank0_Label_EAEA

Bank0_Label_EAE8:
    LDA #$00

Bank0_Label_EAEA:
    STA a:$02B8,X
    LDY a:$02A3,X
    BNE Bank0_Label_EB0B
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

Bank0_Label_EB0B:
    RTS

Bank0_Func_EB0C:
    LDX a:$02FD
    CPX #$03
    BNE Bank0_Label_EB1B
    LDA a:$02FC
    BEQ Bank0_Label_EB1B
    JMP Bank0_Label_EC21

Bank0_Label_EB1B:
    JSR Bank0_Func_EE26
    STA a:$02FF
    TAY
    BMI Bank0_Label_EB27
    JMP Bank0_Label_EC05

Bank0_Label_EB27:
    CMP #$EF
    BCC Bank0_Label_EB5E
    SEC
    LDA #$FF
    SBC a:$02FF
    ASL A
    TAY
    LDA a:$EB3D,Y
    PHA
    LDA a:$EB3C,Y
    PHA
    RTS
    .byte $9D, $EC, $79, $ED, $B4, $EC, $ED, $EC, $D2, $EC, $15, $ED, $2B, $ED, $3E, $ED
    .byte $63, $ED, $AB, $ED, $ED, $ED, $DD, $ED, $CB, $ED, $FA, $ED, $8B, $ED, $64, $EB
    .byte $02, $EE

Bank0_Label_EB5E:
    LDA a:$02FF
    AND #$7F
    BPL Bank0_Label_EB68
    JSR Bank0_Func_EE26

Bank0_Label_EB68:
    LDX a:$02FD
    STA a:$02AC,X
    LDA a:$02EF,X
    BNE Bank0_Label_EBEF
    LDX a:$02FD
    LDA a:$02AC,X
    STA a:$02FF
    LDX a:$02FD
    CPX #$02
    BEQ Bank0_Label_EBF2
    LDA a:$02F3,X
    AND #$10
    BNE Bank0_Label_EBA5
    LDA a:$02F3,X
    AND #$D0
    STA a:$02F3,X
    LDA a:$02FF
    LSR A
    CMP #$10
    BCC Bank0_Label_EB9C
    LDA #$0F

Bank0_Label_EB9C:
    ORA a:$02F3,X
    STA a:$02F3,X
    JMP Bank0_Label_EBB0

Bank0_Label_EBA5:
    LDY a:$02FF
    LDA a:$EEFB,Y
    ORA #$80
    STA a:$02BC,X

Bank0_Label_EBB0:
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
    JMP Bank0_Func_EB0C

Bank0_Label_EBF2:
    LDA a:$02FF
    ASL A
    BMI Bank0_Label_EBFD
    ADC a:$02FF
    BPL Bank0_Label_EBFF

Bank0_Label_EBFD:
    LDA #$7F

Bank0_Label_EBFF:
    STA a:$02F5
    JMP Bank0_Label_EBEF

Bank0_Label_EC05:
    CMP #$00
    BNE Bank0_Label_EC0C
    JMP Bank0_Label_EC94

Bank0_Label_EC0C:
    LDX a:$02FD
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
    STA a:$400C,Y
    INX
    INY
    CPY #$04
    BCC Bank0_Label_EC33
    LDA a:$02F6
    AND #$10
    BEQ Bank0_Label_EC86
    LDA a:$02F6
    AND #$1F
    STA a:$400C
    BPL Bank0_Label_EC86

Bank0_Label_EC50:
    LDY a:$02A3,X
    BNE Bank0_Label_EC94
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
    ADC a:$EEC8,X
    CLC
    ADC $3E,X
    CLC
    ADC a:$02EC,X
    ASL A
    TAX
    LDA a:$EE34,X
    STA a:$4002,Y
    LDA a:$EE35,X
    LDX a:$02FD
    ORA a:$02F7,X
    STA a:$4003,Y

Bank0_Label_EC86:
    LDX a:$02FD
    LDA a:$02EF,X
    BNE Bank0_Label_EC94
    LDA a:$02B4,X
    STA a:$02B8,X

Bank0_Label_EC94:
    LDX a:$02FD
    LDA a:$02AC,X
    STA a:$02B0,X
    RTS
    .byte $AE, $FD, $02, $A9, $01, $9D, $B0, $02, $8A, $0A, $AA, $B5, $2F, $D0, $02, $D6
    .byte $30, $D6, $2F, $EE, $FE, $02, $60, $20, $26, $EE, $AE, $FD, $02, $9D, $D4, $02
    .byte $A9, $01, $9D, $D8, $02, $8A, $0A, $AA, $B5, $2F, $9D, $C4, $02, $B5, $30, $9D
    .byte $C5, $02, $4C, $0C, $EB, $20, $26, $EE, $AE, $FD, $02, $DD, $D8, $02, $B0, $0D
    .byte $8A, $0A, $AA, $BD, $CC, $02, $95, $2F, $BD, $CD, $02, $95, $30, $4C, $0C, $EB
    .byte $AE, $FD, $02, $BD, $D8, $02, $DD, $D4, $02, $B0, $1A, $FE, $D8, $02, $8A, $0A
    .byte $AA
    LDA $2F,X
    STA a:$02CC,X
    LDA $30,X
    STA a:$02CD,X
    LDA a:$02C4,X
    STA $2F,X
    LDA a:$02C5,X
    STA $30,X
    JMP Bank0_Func_EB0C
    .byte $20, $26, $EE, $AE, $FD, $02, $9D, $C0, $02, $BD, $B4, $02, $9D, $B8, $02, $A9
    .byte $FF, $9D, $EF, $02, $D0, $32, $AE, $FD, $02, $A9, $00, $9D, $EF, $02, $BD, $F3
    .byte $02, $29, $CF, $9D, $F3, $02, $4C, $73, $EB, $20, $26, $EE, $AE, $FD, $02, $E0
    .byte $02, $F0, $A2, $29, $C0, $8D, $FF, $02, $BD, $F3, $02, $29, $10, $0D, $FF, $02
    .byte $9D, $F3, $02, $BD, $EF, $02, $F0, $DE, $BD, $C0, $02, $4C, $79, $EB, $20, $6A
    .byte $ED, $4C, $0C, $EB, $AD, $FD, $02, $0A, $AA, $B5, $2F, $9D, $DC, $02, $B5, $30
    .byte $9D, $DD, $02, $60, $AD, $FD, $02, $0A, $AA, $BD, $DC, $02, $95, $2F, $BD, $DD
    .byte $02, $95, $30, $4C, $0C, $EB, $AD, $AA, $02, $0A, $0A, $38, $E9, $04, $18, $6D
    .byte $FD, $02, $0A, $A8, $AD, $FD, $02, $0A, $AA, $B9, $FB, $EF, $95, $2F, $B9, $FC
    .byte $EF, $95, $30, $4C, $0C, $EB, $20, $26, $EE, $48, $20, $26, $EE, $48, $AD, $FD
    .byte $02, $0A, $AA, $B5, $2F, $9D, $E4, $02, $B5, $30, $9D, $E5, $02, $68, $95, $30
    .byte $68, $95, $2F, $4C, $0C, $EB, $AD, $FD, $02, $0A, $AA, $BD, $E4, $02, $95, $2F
    .byte $BD, $E5, $02, $95, $30, $4C, $0C, $EB, $20, $26, $EE, $AE, $FD, $02, $E0, $03
    .byte $F0, $03, $9D, $EC, $02, $4C, $0C, $EB, $20, $26, $EE, $A2, $02, $95, $3E, $CA
    .byte $10, $FB, $4C, $0C, $EB, $AE, $FD, $02, $A9, $08, $4C, $EC, $EB, $20, $26, $EE
    .byte $AE, $FD, $02, $9D, $B4, $02, $9D, $B8, $02, $4A, $4A, $4A, $4A, $8D, $FF, $02
    .byte $BD, $F3, $02, $29, $C0, $09, $10, $0D, $FF, $02, $9D, $F3, $02, $4C, $0C, $EB

Bank0_Func_EE26:
    LDA a:$02FD
    ASL A
    TAX
    LDA ($2F,X)
    INC $2F,X
    BNE Bank0_Label_EE33
    INC $30,X

Bank0_Label_EE33:
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
    .byte $1B, $00, $19, $00, $F4, $F4, $00, $7F, $08, $60, $C0, $50, $40, $30, $B0, $28
    .byte $30, $24, $D0, $1E, $50, $18, $A0, $14, $20, $00, $F0, $00, $00, $06, $20, $01
    .byte $00, $0E, $20, $1C, $00, $02, $68, $00, $00, $04, $20, $00, $00, $0C, $20, $1A
    .byte $00, $04, $A8, $1A, $00, $04, $48, $7F, $7F, $40, $2A, $20, $19, $15, $12, $10
    .byte $0E, $0C, $0B, $0A, $09, $09, $08, $08, $07, $07, $06, $06, $06, $05, $05, $05
    .byte $05, $04, $04, $04, $04, $04, $04, $04, $03, $03, $03, $03, $03, $03, $03, $03
    .byte $03, $03, $02, $02, $02, $02, $02, $03, $02, $02, $02, $02, $02, $02, $02, $02
    .byte $02, $02, $02, $02, $02, $02, $02, $01, $01, $01, $01, $01, $01, $01, $01, $01
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
    .byte $01, $01, $01, $01, $01, $01, $01, $E2, $F9, $9F, $FA, $66, $FB, $2A, $FC, $3B
    .byte $F0, $69, $F0, $7B, $F0, $C2, $F0, $03, $F1, $0E, $F1, $15, $F1, $61, $F9, $4D
    .byte $F1, $00, $F2, $B4, $F2, $56, $F3, $B6, $F3, $B0, $F4, $75, $F5, $E0, $F5, $08
    .byte $F6, $39, $F7, $5A
    SED
    ADC ($F9,X)
    .byte $13, $F9, $2F, $F9, $41, $F9, $61, $F9, $62, $F9, $88, $F9, $AD, $F9, $CF, $F9
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $10, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $20, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $30, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $40, $5  ; rom-asset .byte
    BVS Bank0_Label_F082

Bank0_Label_F082:
    TAX
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $48, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $58, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $68, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $78, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $88, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $98, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $D8, $D  ; rom-asset .byte
    ROL a:$2E00
    AND a:$2D00
    AND a:$2D00
    BIT a:$2C00
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $F1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $101, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $111, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $121, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $131, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $141, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $151, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $161, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $171, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $181, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $191, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $1A1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $1B1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $1C1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $1D1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $1E1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $1F1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $201, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $211, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $221, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $231, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $241, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $251, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $261, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $271, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $281, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $291, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $2A1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $2B1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $2C1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $2D1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $2E1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $2F1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $301, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $311, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $321, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $331, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $341, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $351, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $361, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $371, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $381, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $391, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $3A1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $3B1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $3C1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $3D1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $3E1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $3F1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $401, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $411, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $421, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $431, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $441, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $451, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $461, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $471, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $481, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $491, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $4A1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $4B1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $4C1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $4D1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $4E1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $4F1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $501, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $511, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $521, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $531, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $541, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $551, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $561, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $571, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $581, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $591, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $5A1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $5B1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $5C1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $5D1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $5E1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $5F1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $601, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $611, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $621, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $631, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $641, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $651, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $661, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $671, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $681, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $691, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $6A1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $6B1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $6C1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $6D1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $6E1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $6F1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $701, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $711, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $721, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $731, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $741, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $751, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $761, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $771, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $781, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $791, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $7A1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $7B1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $7C1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $7D1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $7E1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $7F1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $801, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $811, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $821, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $831, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $841, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $851, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $861, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $871, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $881, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $891, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $8A1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $8B1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $8C1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $8D1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $8E1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $8F1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $901, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $911, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $921, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $931, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $941, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $951, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $961, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $971, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $981, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $991, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $9A1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $9B1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $9C1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $9D1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $9E1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $9F1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A01, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A11, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A21, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A31, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A41, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A51, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A61, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A71, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A81, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A91, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $AA1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $AB1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $AC1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $AD1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $AE1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $AF1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B01, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B11, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B21, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B31, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B41, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B51, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B61, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B71, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B81, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B91, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $BA1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $BB1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $BC1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $BD1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $BE1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $BF1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C01, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C11, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C21, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C31, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C41, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C51, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C61, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C71, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C81, $3  ; rom-asset .byte
    .byte $15, $00, $01, $44, $0B, $05, $03, $04, $26, $02, $9E, $48, $03
    .byte $0A, $3A, $02, $01, $06, $12, $04, $02, $46, $1C, $02, $26, $04, $02, $06, $1D
    .byte $04, $0E, $01, $0B, $08, $04, $48, $08, $40, $12, $00, $61, $42, $0D, $08, $0F
    .byte $40, $36, $02, $0F, $00, $35, $41, $0F, $00, $22, $02, $2F, $40, $26, $01, $20
    .byte $40, $19, $02, $60, $40, $19, $08, $01, $41, $03, $41, $08, $40, $19, $00, $12
    .byte $04, $55, $05, $1C, $01, $10, $05, $01, $41, $09, $00, $06, $01, $0A, $40, $21
    .byte $00, $09, $01, $00, $00, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
Bank0_NmiVector:
    .addr Bank0_Nmi

Bank0_ResetVector:
    .addr Bank0_Reset

Bank0_IrqVector:
    .addr Bank0_Reset
