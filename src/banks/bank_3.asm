; Address-ordered Doraemon PRG bank 3 preservation listing
; Generated deterministically from pinned Ghidra/GhidraNes facts
; Keep byte-identical through make verify

.segment "PRG3"

Bank3_Func_8000:
    JSR Bank3_Func_80F0
    LDA #$00
    JSR Bank3_Func_81B2
    JMP Bank3_Func_8271

Bank3_Func_800B:
    JSR Bank3_Func_80F0
    LDA #$01
    JSR Bank3_Func_81B2
    JMP Bank3_Func_8271

Bank3_Func_8016:
    JSR Bank3_Func_80F0
    LDA #$02
    JSR Bank3_Func_81B2
    JMP Bank3_Func_8271
    .byte $4C, $74, $82

Bank3_Func_8024:
    JSR Bank3_Func_80F0
    LDA #$00
    JSR Bank3_Func_81B2
    JMP Bank3_Func_8277

Bank3_Func_802F:
    JSR Bank3_Func_80F0
    LDA #$01
    JSR Bank3_Func_81B2
    JMP Bank3_Func_8277

Bank3_Func_803A:
    JSR Bank3_Func_80F0
    LDA #$02
    JSR Bank3_Func_81B2
    JMP Bank3_Func_8277
    .byte $4C, $7A, $82

Bank3_Func_8048:
    JSR Bank3_Func_80F0
    LDA #$03
    JSR Bank3_Func_81B2
    JMP Bank3_Func_8271

Bank3_Func_8053:
    JSR Bank3_Func_80F0
    LDA $17
    PHA
    LDA #$03
    JSR Bank3_Func_81B2
    JSR Bank3_Func_8277
    PLA
    JMP Bank3_Func_81B2

Bank3_Func_8065:
    JSR Bank3_Func_80F0
    LDA $17
    PHA
    LDA #$03
    JSR Bank3_Func_81B2
    JSR Bank3_Func_827D
    PLA
    JMP Bank3_Func_81B2
    .byte $20, $F0, $80, $A9, $03, $20, $B2, $81, $4C, $80, $82

Bank3_Func_8082:
    JSR Bank3_Func_80F0
    LDA #$03
    JSR Bank3_Func_81B2
    JMP Bank3_Label_8283

Bank3_Func_808D:
    JSR Bank3_Func_80F0
    LDA #$03
    JSR Bank3_Func_81B2
    JMP Bank3_Label_8286

Bank3_Reset:
    LDX #$7F
    TXS
    LDA #$00
    STA a:$2001
    STA a:$2000
    JSR Bank3_WaitForVblank
    JSR Bank3_WaitForVblank
    LDX #$00
    TXA

Bank3_Label_80AC:
    STA a:$0400,X
    STA a:$0500,X
    STA a:$0600,X
    STA a:$0700,X
    INX
    BNE Bank3_Label_80AC
    LDA #$10
    STA $19
    STA a:$2000
    LDA #$06
    STA $1A
    STA a:$2001
    JSR Bank3_Func_80DA
    JMP Bank3_Func_8048

Bank3_WaitForVblank:
    LDA a:$2002
    BPL Bank3_WaitForVblank

Bank3_Label_80D4:
    LDA a:$2002
    BMI Bank3_Label_80D4
    RTS

Bank3_Func_80DA:
    JSR Bank3_WaitForVblank
    LDA #$00
    STA $14
    LDA $19
    STA a:$2000
    LDA $1A
    AND #$E7
    STA $1A
    STA a:$2001
    RTS

Bank3_Func_80F0:
    JSR Bank3_Func_80DA
    LDA $19
    AND #$7F
    STA $19
    STA a:$2000
    RTS

Bank3_Func_80FD:
    JSR Bank3_Func_8131
    JSR Bank3_WaitForVblank
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
    JSR Bank3_WriteMapper
    LDA $1A
    ORA #$18
    STA $1A
    STA a:$2001
    RTS

Bank3_Func_8131:
    LDA #$F0
    LDX #$00

Bank3_Label_8135:
    STA a:$0300,X
    INX
    BNE Bank3_Label_8135
    RTS

Bank3_Nmi:
    PHA
    TXA
    PHA
    TYA
    PHA
    LDA $15
    BNE Bank3_Label_81A2
    INC $15
    LDA $14
    BEQ Bank3_Label_8158
    LDA #$00
    STA a:$2003
    LDA #$03
    STA a:$4014
    JSR Bank3_WriteMapper

Bank3_Label_8158:
    JSR Bank3_Func_8274
    LDA #$01
    STA a:$4016
    LDA #$00
    STA a:$4016
    LDX #$08

Bank3_Label_8167:
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
    BNE Bank3_Label_8167
    LDA $1D
    AND #$CF
    ORA $1F
    ORA $20
    ORA $1E
    STA $21
    LDA a:$4016
    AND #$04
    CMP $23
    BEQ Bank3_Label_8197
    STA $23
    LDA #$14
    STA $24

Bank3_Label_8197:
    LDA $24
    BEQ Bank3_Label_819D
    DEC $24

Bank3_Label_819D:
    JSR Bank3_Func_827A
    DEC $15

Bank3_Label_81A2:
    INC $16
    PLA
    TAY
    PLA
    TAX
    PLA
    RTI

Bank3_Func_81AA:
    ASL A
    ASL A
    AND #$0C
    STA $18
    LDA $17

Bank3_Func_81B2:
    AND #$03
    ORA $18
    STA $17
    JSR Bank3_WaitForVblank

Bank3_WriteMapper:
    LDA $17
    TAX
    LDA a:$8261,X
    STA a:$8261,X
    NOP
    NOP
    NOP
    NOP
    RTS

Bank3_Func_81C9:
    STA $07
    LDA $27
    BNE Bank3_Label_81E5
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
    JSR Bank3_Func_81E6
    PLA
    TAX
    PLA
    TAY

Bank3_Label_81E5:
    RTS

Bank3_Func_81E6:
    CLC
    ADC a:$0298,X
    LDY #$00

Bank3_Label_81EC:
    CMP #$0A
    BCC Bank3_Label_81F6
    SEC
    SBC #$0A
    INY
    BNE Bank3_Label_81EC

Bank3_Label_81F6:
    STA a:$0298,X
    TYA
    BNE Bank3_Label_81FD
    RTS

Bank3_Label_81FD:
    DEX
    BPL Bank3_Func_81E6
    LDA #$09
    LDX #$05

Bank3_Label_8204:
    STA a:$0298,X
    STA a:$0290,X
    DEX
    BPL Bank3_Label_8204
    RTS

Bank3_Func_820E:
    LDA $27
    BNE Bank3_Label_8244
    LDA $25
    CMP #$04
    BEQ Bank3_Label_8233
    ASL A
    ASL A
    TAY
    LDX #$00

Bank3_Label_821D:
    LDA a:$0298,X
    CMP a:$8251,Y
    BCC Bank3_Label_8233
    BNE Bank3_Label_822D
    INX
    INY
    CPX #$04
    BNE Bank3_Label_821D

Bank3_Label_822D:
    INC $2A
    INC $26
    INC $25

Bank3_Label_8233:
    LDX #$00

Bank3_Label_8235:
    LDA a:$0290,X
    CMP a:$0298,X
    BCC Bank3_Label_8245
    BNE Bank3_Label_8244
    INX
    CPX #$06
    BNE Bank3_Label_8235

Bank3_Label_8244:
    RTS

Bank3_Label_8245:
    LDA a:$0298,X
    STA a:$0290,X
    INX
    CPX #$06
    BNE Bank3_Label_8245
    RTS
    .byte $00, $00, $02, $00, $00, $00, $08, $00, $00, $02, $00, $00, $00, $05, $00, $00

Bank3_MapperValueTable:
    .byte $00, $10, $20, $30, $01, $11, $21, $31, $02, $12, $22, $32, $03, $13, $23, $33

Bank3_Func_8271:
    JMP Bank3_Func_828F

Bank3_Func_8274:
    JMP Bank3_Func_8FF2

Bank3_Func_8277:
    JMP Bank3_Func_87CB

Bank3_Func_827A:
    JMP Bank3_Func_8289

Bank3_Func_827D:
    .byte $4C, $17, $8A, $4C, $88, $8A

Bank3_Label_8283:
    .byte $4C, $3F, $8C

Bank3_Label_8286:
    .byte $4C, $43, $8C

Bank3_Func_8289:
    JSR Bank3_Func_983B
    JMP Bank3_Func_9ED8

Bank3_Func_828F:
    LDA #$00
    STA a:$2000
    STA a:$2001
    STA $09
    STA $3C
    STA $3D
    LDX #$7F
    TXS
    LDA #$00
    STA a:$0180
    JSR Bank3_Func_80DA
    LDA #$03
    JSR Bank3_Func_81AA
    JSR Bank3_Func_9152
    LDA #$86
    STA $01
    LDA #$30
    STA $00
    JSR Bank3_Func_90C4
    JSR Bank3_Func_90D1
    JSR Bank3_Func_858D
    LDA $3B
    AND #$7F
    STA $3B
    LDA #$48
    STA $00
    LDA #$92
    STA $01
    JSR Bank3_WaitForVblank
    JSR Bank3_Func_8F84
    LDA #$FF
    STA $1B
    LDA #$D0
    STA $1C
    LDA #$96
    STA $0E
    LDA #$22
    STA $10
    LDA #$80
    STA $0F
    LDA #$80
    STA $11
    LDX #$00

Bank3_Label_82EF:
    LDA a:$0298,X
    BNE Bank3_Label_82F9
    INX
    CPX #$05
    BNE Bank3_Label_82EF

Bank3_Label_82F9:
    TXA
    CLC
    ADC #$91
    PHA
    LDA #$22
    STA a:$2006
    PLA
    STA a:$2006

Bank3_Label_8307:
    LDA a:$0298,X
    ORA #$30
    STA a:$2007
    INX
    CPX #$07
    BNE Bank3_Label_8307
    LDX #$00

Bank3_Label_8316:
    LDA a:$0290,X
    BNE Bank3_Label_8320
    INX
    CPX #$05
    BNE Bank3_Label_8316

Bank3_Label_8320:
    TXA
    CLC
    ADC #$51
    PHA
    LDA #$22
    STA a:$2006
    PLA
    STA a:$2006

Bank3_Label_832E:
    LDA a:$0290,X
    ORA #$30
    STA a:$2007
    INX
    CPX #$07
    BNE Bank3_Label_832E
    LDA $19
    ORA #$10
    AND #$F4
    STA $19
    JSR Bank3_Func_91A1
    LDA #$01
    STA $0D
    STA $14
    LDA #$00
    STA $15
    STA $27
    LDA #$00
    STA a:$4011
    STA a:$4015
    STA a:$4010
    STA a:$02A0
    STA a:$02AA
    STA a:$02AB
    LDA #$40
    STA a:$4017
    LDA #$01
    STA a:$02AA
    JSR Bank3_Func_80FD

Bank3_Label_8373:
    JSR Bank3_Func_83C5
    DEC $1B
    BNE Bank3_Label_8373
    LDX #$64

Bank3_Label_837C:
    JSR Bank3_Func_83C5
    DEX
    BNE Bank3_Label_837C

Bank3_Label_8382:
    JSR Bank3_Func_83C5
    INC $1C
    DEC $0E
    INC $10
    LDA $1C
    CMP #$F0
    BNE Bank3_Label_8382
    LDA #$00
    STA $1C

Bank3_Label_8395:
    JSR Bank3_Func_83C5
    INC $11
    DEC $0F
    BNE Bank3_Label_8395

Bank3_Label_839E:
    LDX #$7F
    TXS
    LDA #$00
    STA $0D
    STA $1B
    STA $1C
    STA a:$0180
    STA a:$01C0
    STA a:$0405
    STA a:$0406
    STA a:$0407
    INC $09

Bank3_Label_83BA:
    LDA $1F
    ORA $20
    AND #$10
    BNE Bank3_Label_83BA
    JMP Bank3_Func_8415

Bank3_Func_83C5:
    JSR Bank3_Func_84D2
    AND #$30
    BNE Bank3_Label_839E
    RTS

Bank3_Label_83CD:
    JSR Bank3_Func_80DA
    LDA #$00
    STA $25
    STA $26
    STA $37
    STA $38
    LDX #$07

Bank3_Label_83DC:
    STA a:$0298,X
    DEX
    BPL Bank3_Label_83DC
    LDA #$02
    STA $2A
    LDA #$08
    STA $2B
    LDA #$06
    STA $2C
    LDA $21
    AND #$C0
    CMP #$C0
    BEQ Bank3_Label_83F9
    JMP Bank3_Func_8C3B

Bank3_Label_83F9:
    LDA #$80
    STA $3B
    LDX $3C
    BNE Bank3_Label_8404
    JMP Bank3_Func_8000

Bank3_Label_8404:
    LDA #$04
    STA $2C
    LDA #$02
    STA $2A
    DEX
    BNE Bank3_Label_8412
    JMP Bank3_Func_800B

Bank3_Label_8412:
    JMP Bank3_Func_8016

Bank3_Func_8415:
    LDA #$00
    STA a:$0400

Bank3_Label_841A:
    JSR Bank3_Func_84D2
    AND #$10
    BNE Bank3_Label_83CD
    DEC a:$0400
    BNE Bank3_Label_841A

Bank3_Label_8426:
    JSR Bank3_Func_84FC
    JSR Bank3_Func_85B9
    BCC Bank3_Label_8426
    LDA #$B0
    STA $00
    LDA #$86
    STA $01
    JSR Bank3_Func_90C4
    LDA #$01
    STA a:$0408
    LDA $3B
    ASL A
    TAX
    LDA a:$84C0,X
    STA $3E
    LDA a:$84C1,X
    STA $3F
    LDA #$00
    STA $40
    STA $41
    STA $42
    LDA a:$84CC,X
    STA $44
    LDA a:$84CD,X
    STA $45

Bank3_Label_845E:
    JSR Bank3_Func_84FC
    LDA $40
    CMP #$20
    BCS Bank3_Label_8478
    LDA #$02
    STA $09
    JSR Bank3_Func_85F7
    JSR Bank3_Func_85E2
    LDA #$01
    STA $41
    JMP Bank3_Label_845E

Bank3_Label_8478:
    LDA $3B
    ASL A
    TAX
    LDA a:$84C6,X
    STA $00
    LDA a:$84C7,X
    STA $01
    JSR Bank3_Func_90C4
    LDX #$00
    STX $43
    INX
    STA a:$0408
    STA $42

Bank3_Label_8493:
    JSR Bank3_Func_84FC
    JSR Bank3_Func_85F7
    JSR Bank3_Func_85E2
    LDA a:$02AA
    BNE Bank3_Label_8493
    LDA #$01
    STA $27
    LDA $3B
    TAX
    INX
    CPX #$03
    BCC Bank3_Label_84AF
    LDX #$00

Bank3_Label_84AF:
    STX $3B
    TAX
    BNE Bank3_Label_84B7
    JMP Bank3_Func_8024

Bank3_Label_84B7:
    DEX
    BNE Bank3_Label_84BD
    JMP Bank3_Func_802F

Bank3_Label_84BD:
    JMP Bank3_Func_803A
    .byte $BC, $B1, $BC, $B5, $BC, $B9, $50, $86, $70, $86, $90, $86, $D0, $86, $29, $87
    .byte $62, $87

Bank3_Func_84D2:
    JSR Bank3_Func_8F5A
    LDA $1F
    ORA $20
    AND #$20
    BEQ Bank3_Label_84F3
    LDA $3D
    BNE Bank3_Label_84F7
    LDX $3C
    INX
    CPX #$03
    BCC Bank3_Label_84EA
    LDX #$00

Bank3_Label_84EA:
    STX $3C
    LDA #$01
    STA $3D
    JMP Bank3_Label_84F7

Bank3_Label_84F3:
    LDA #$00
    STA $3D

Bank3_Label_84F7:
    LDA $1F
    ORA $20

Bank3_Label_84FB:
    RTS

Bank3_Func_84FC:
    JSR Bank3_Func_84D2
    AND #$30
    BEQ Bank3_Label_84FB
    LDA #$00
    STA a:$02AA
    LDA #$01
    STA $09
    JSR Bank3_Func_80DA
    JSR Bank3_Func_9152
    LDA #$48
    STA $00
    LDA #$92
    STA $01
    JSR Bank3_WaitForVblank
    JSR Bank3_Func_8F84
    LDX #$00

Bank3_Label_8522:
    LDA a:$0298,X
    BNE Bank3_Label_852C
    INX
    CPX #$05
    BNE Bank3_Label_8522

Bank3_Label_852C:
    TXA
    CLC
    ADC #$91
    PHA
    LDA #$22
    STA a:$2006
    PLA
    STA a:$2006

Bank3_Label_853A:
    LDA a:$0298,X
    ORA #$30
    STA a:$2007
    INX
    CPX #$07
    BNE Bank3_Label_853A
    LDX #$00

Bank3_Label_8549:
    LDA a:$0290,X
    BNE Bank3_Label_8553
    INX
    CPX #$05
    BNE Bank3_Label_8549

Bank3_Label_8553:
    TXA
    CLC
    ADC #$51
    PHA
    LDA #$22
    STA a:$2006
    PLA
    STA a:$2006

Bank3_Label_8561:
    LDA a:$0290,X
    ORA #$30
    STA a:$2007
    INX
    CPX #$07
    BNE Bank3_Label_8561
    LDA #$86
    STA $01
    LDA #$30
    STA $00
    JSR Bank3_Func_90C4
    JSR Bank3_Func_90D1
    LDA #$00
    STA $1C
    STA $1B
    LDA #$01
    STA a:$02AA
    JSR Bank3_Func_80FD
    JMP Bank3_Label_83BA

Bank3_Func_858D:
    LDA $39
    CMP #$4F
    BNE Bank3_Label_859A
    LDA $3A
    CMP #$4B
    BNE Bank3_Label_859A
    RTS

Bank3_Label_859A:
    LDA #$4F
    STA $39
    LDA #$4B
    STA $3A
    LDA #$00
    LDX #$07

Bank3_Label_85A6:
    STA a:$0298,X
    DEX
    BPL Bank3_Label_85A6
    LDX #$07

Bank3_Label_85AE:
    STA a:$0290,X
    DEX
    BPL Bank3_Label_85AE
    LDA #$00
    STA $3B
    RTS

Bank3_Func_85B9:
    LDA #$01
    STA a:$0408
    CLC
    LDA $16
    AND #$03
    BNE Bank3_Label_85E1
    LDA a:$0400
    CMP #$05
    BCS Bank3_Label_85E1
    ASL A
    ASL A
    TAX
    LDY #$00

Bank3_Label_85D1:
    LDA a:$861C,X
    STA a:$0210,Y
    INX
    INY
    CPY #$04
    BCC Bank3_Label_85D1
    INC a:$0400
    CLC

Bank3_Label_85E1:
    RTS

Bank3_Func_85E2:
    LDA #$37
    STA a:$0300
    LDA #$EF
    STA a:$0301
    LDA #$23
    STA a:$0302
    LDA #$00
    STA a:$0303
    RTS

Bank3_Func_85F7:
    LDX #$80
    LDY #$00

Bank3_Label_85FB:
    LDA ($44),Y
    BEQ Bank3_Label_861B
    INY
    STA a:$0300,X
    LDA ($44),Y
    INY
    STA a:$0301,X
    LDA ($44),Y
    INY
    STA a:$0302,X
    LDA ($44),Y
    INY
    STA a:$0303,X
    INX
    INX
    INX
    INX
    BNE Bank3_Label_85FB

Bank3_Label_861B:
    RTS
    .byte $01, $0F, $17, $20, $01, $01, $07, $10, $01, $01, $01, $00, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $0F, $27, $30, $01, $15, $20, $26, $01, $15, $21, $29
    .byte $01, $15, $26, $0F, $01, $0F, $27, $30, $01, $15, $20, $36, $01, $15, $21, $30
    .byte $01, $15, $26, $01, $01, $0F, $11, $30, $01, $05, $25, $30, $01, $09, $08, $26
    .byte $01, $10, $30, $01, $01, $0F, $26, $30, $01, $15, $21, $30, $01, $0F, $26, $30
    .byte $01, $0F, $26, $30, $01, $0F, $11, $30, $01, $05, $25, $30, $01, $09, $08, $26
    .byte $01, $10, $30, $01, $01, $05, $25, $30, $01, $05, $25, $30, $01, $05, $25, $30
    .byte $01, $05, $25, $30, $01, $0F, $11, $30, $01, $05, $25, $30, $01, $09, $08, $26
    .byte $01, $10, $30, $01, $01, $15, $26, $30, $01, $15, $21, $30, $01, $15, $26, $30
    .byte $01, $15, $21, $30, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $4C, $03, $00, $50, $4C, $04, $00, $58, $54, $13, $00, $50
    .byte $54, $14, $00, $58, $64, $05, $00, $50, $64, $06, $00, $58, $6C, $15, $00, $50
    .byte $6C, $16, $00, $58, $7C, $07, $00, $50, $7C, $08, $00, $58, $84, $17, $00, $50
    .byte $84, $18, $00, $58, $94, $0B, $00, $50, $94, $0D, $00, $58, $9C, $1B, $00, $50
    .byte $9C, $1D, $00, $58, $B0, $0C, $00, $50, $B0, $0C, $40, $58, $C4, $09, $01, $50
    .byte $C4, $0A, $01, $58, $CC, $19, $01, $50, $CC, $1A, $01, $58, $00, $54, $23, $00
    .byte $50, $54, $24, $00, $58, $5C, $25, $00, $50, $5C, $26, $00, $58, $74, $27, $00
    .byte $50, $74, $27, $40, $58, $7C, $28, $00, $50, $7C, $28, $40, $58, $98, $0C, $00
    .byte $50, $98, $0C, $40, $58, $B4, $09, $00, $50, $B4, $0A, $00, $58, $BC, $19, $00
    .byte $50, $BC, $1A, $00, $58, $00, $44, $29, $00, $50, $44, $29, $40, $58, $4C, $29
    .byte $80, $50, $4C, $29, $C0, $58, $5C, $2A, $00, $50, $5C, $2B, $00, $58, $64, $3A
    .byte $00, $50, $64, $3B, $00, $58, $74, $3C, $01, $50, $74, $3D, $01, $58, $7C, $3E
    .byte $01, $50, $7C, $3F, $01, $58, $8C, $40, $01, $50, $8C, $41, $01, $58, $94, $42
    .byte $01, $50, $94, $2D, $01, $58, $A4, $03, $01, $50, $A4, $04, $01, $58, $AC, $13
    .byte $01, $50, $AC, $14, $01, $58, $C0, $0C, $00, $50, $C0, $0C, $40, $58, $D4, $09
    .byte $01, $50, $D4, $0A, $01, $58, $DC, $19, $01, $50, $DC, $1A, $01, $58, $00

Bank3_Func_87CB:
    LDA #$FF
    JSR Bank3_Func_8F63
    LDA $19
    AND #$FE
    STA $19
    LDA #$3F
    STA $00
    LDA #$88
    STA $01
    JSR Bank3_WaitForVblank
    JSR Bank3_Func_8F84
    LDA $28
    ASL A
    TAY
    LDA a:$8839,Y
    STA $00
    LDA a:$883A,Y
    STA $01
    JSR Bank3_Func_8F84
    LDA #$03
    JSR Bank3_Func_81AA
    LDA $19
    AND #$E7
    STA $19
    LDA #$23
    STA a:$2006
    LDA #$14
    STA a:$2006
    LDA $2A
    ORA #$30
    STA a:$2007
    LDX #$00

Bank3_Label_8813:
    LDA a:$0298,X
    BNE Bank3_Label_881D
    INX
    CPX #$05
    BNE Bank3_Label_8813

Bank3_Label_881D:
    TXA
    CLC
    ADC #$CF
    PHA
    LDA #$22
    STA a:$2006
    PLA
    STA a:$2006

Bank3_Label_882B:
    LDA a:$0298,X
    ORA #$30
    STA a:$2007
    INX
    CPX #$07
    BNE Bank3_Label_882B
    RTS
    .byte $63, $88, $F0, $88, $8A, $89, $3F, $00, $20, $02, $15, $21, $30, $02, $0F, $26
    .byte $30, $02, $16, $30, $36, $02, $16, $30, $36, $02, $15, $21, $30, $02, $0F, $26
    .byte $30, $02, $16, $30, $36, $02, $16, $30, $36, $00, $20, $AC, $07, $57, $C7, $B7
    .byte $BF, $58, $FF, $31, $21, $28, $0F, $D0, $D1, $D2, $FF, $FF, $FF, $D3, $D4, $D5
    .byte $FF, $FF, $FF, $DC, $DD, $DE, $21, $48, $0F, $E0, $E1, $E2, $FF, $FF, $FF, $E3
    .byte $E4, $E5, $FF, $FF, $FF, $EC, $ED, $EE, $21, $68, $0F, $F0, $F1, $F2, $FF, $FF
    .byte $FF, $F3, $F4, $F5, $FF, $FF, $FF, $FC, $FD, $FE, $22, $0C, $07, $00, $59, $FF
    .byte $FF, $FF, $0E, $0F, $22, $2C, $07, $1C, $69, $FF, $FF, $FF, $1E, $1F, $22, $4C
    .byte $07, $2C, $68, $FF, $FF, $FF, $2E, $2F, $22, $C9, $05, $CA, $B8, $C7, $B7, $CE
    .byte $23, $0A, $04, $BF, $CE, $CF, $CB, $23, $CB, $02, $55, $55, $23, $D2, $04, $00
    .byte $00, $00, $00, $23, $E3, $02, $00, $55, $23, $EA, $04, $55, $55, $55, $55, $23
    .byte $F2, $04, $55, $55, $55, $55, $00, $20, $AC, $07, $57, $C7, $B7, $BF, $58, $FF
    .byte $32, $21, $28, $0F, $D6, $D7, $D8, $FF, $FF, $FF, $D9, $DA, $DB, $FF, $FF, $FF
    .byte $DC, $DD, $DE, $21, $48, $0F, $E6, $E7, $E8, $FF, $FF, $FF, $E9, $EA, $EB, $FF
    .byte $FF, $FF, $EC, $ED, $EE, $21, $68, $0F, $F6, $F7, $F8, $FF, $FF, $FF, $F9, $FA
    .byte $FB, $FF, $FF, $FF, $FC, $FD, $FE, $21, $EF, $02, $48, $49, $22, $0C, $08, $00
    .byte $59, $FF, $4A, $4B, $FF, $4C, $4D, $22, $2C, $08, $1C, $69, $FF, $5A, $5B, $FF
    .byte $5C, $5D, $22, $4C, $08, $2C, $68, $FF, $6A, $6B, $FF, $6C, $6D, $22, $C9, $05
    .byte $CA, $B8, $C7, $B7, $CE, $23, $0A, $04, $BF, $CE, $CF, $CB, $23, $CB, $02, $55
    .byte $55, $23, $D2, $04, $00, $00, $00, $00, $23, $DB, $02, $55, $55, $23, $E3, $02
    .byte $44, $55, $23, $EA, $04, $55, $55, $55, $55, $23, $F2, $04, $55, $55, $55, $55
    .byte $00, $20, $AC, $07, $57, $C7, $B7, $BF, $58, $FF, $33, $21, $28, $0F, $A0, $A1
    .byte $A2, $FF, $FF, $FF, $A3, $A4, $A5, $FF, $FF, $FF, $DC, $DD, $DE, $21, $48, $0F
    .byte $B0, $B1, $B2, $FF, $FF, $FF, $B3, $B4, $B5, $FF, $FF, $FF, $EC, $ED, $EE, $21
    .byte $68, $0F, $C0, $C1, $C2, $FF, $FF, $FF, $C3, $C4, $C5, $FF, $FF, $FF, $FC, $FD
    .byte $FE, $22, $0C, $07, $00, $59, $FF, $FF, $FF, $4E, $4F, $22, $2C, $07, $1C, $69
    .byte $FF, $FF, $FF, $5E, $5F, $22, $4C, $07, $2C, $68, $FF, $FF, $FF, $6E, $6F, $22
    .byte $C9, $05, $CA, $B8, $C7, $B7, $CE, $23, $0A, $04, $BF, $CE, $CF, $CB, $23, $CB
    .byte $02, $55, $55, $23, $D2, $04, $00, $00, $00, $00, $23, $E3, $02, $00, $AA, $23
    .byte $EA, $04, $55, $55, $55, $55, $23, $F2, $04, $55, $55, $55, $55, $00, $20, $DA
    .byte $80, $A9, $03, $20, $AA, $81, $20, $52, $91, $A9, $21, $8D, $06, $20, $A9, $EB
    .byte $8D, $06, $20, $A2, $F7, $BD, $88, $89, $8D, $07, $20, $E8, $D0, $F7, $A9, $00
    .byte $85, $16, $A9, $86, $85, $01, $A9, $30, $85, $00, $20, $C4, $90, $20, $D1, $90
    .byte $A9, $00, $85, $1C, $85, $1B, $A9, $01, $85, $09, $A9, $04, $8D, $AA, $02, $20
    .byte $FD, $80, $20, $D2, $84, $85, $00, $29, $10, $D0, $0C, $AD, $AA, $02, $D0, $F2
    .byte $A9, $00, $85, $3B, $4C, $8F, $82, $A9, $00, $8D, $AA, $02, $A5, $00, $29, $0F
    .byte $F0, $F2, $20, $DA, $80, $60, $47, $41, $4D, $45, $00, $4F, $56, $45, $52, $A2
    .byte $7F, $9A, $20, $DA, $80, $A9, $03, $20, $AA, $81, $20, $52, $91, $A9, $84, $85
    .byte $00, $A9, $93, $85, $01, $A9, $20, $8D, $06, $20, $A0, $00, $8C, $06, $20, $A2
    .byte $04, $B1, $00, $8D, $07, $20, $C8, $D0, $F8, $E6, $01, $CA, $D0, $F3, $A2, $E0
    .byte $BD, $3B, $8B, $9D, $30, $01, $E8, $D0, $F7, $20, $D1, $90, $A9, $00, $85, $1B
    .byte $85, $1C, $A9, $01, $85, $09, $A9, $02, $8D, $AA, $02, $A5, $19, $29, $E0, $85
    .byte $19, $20, $FD, $80, $20, $5A, $8F, $AD, $AA, $02, $D0, $F8, $A9, $C4, $85, $16
    .byte $20, $5A, $8F, $A5, $16, $D0, $F9, $20, $DA, $80, $A5, $3B, $10, $03, $4C, $48
    .byte $80, $20, $52, $91, $A9, $BC, $85, $4B, $A9, $BD, $85, $4C, $A9, $03, $8D, $AA
    .byte $02, $A5, $19, $29, $E0, $09, $10, $85, $19, $20, $A1, $91, $20, $FD, $80, $20
    .byte $5A, $8F, $20, $8A, $8B, $20, $EE, $91, $A5, $4B, $C9, $3C, $D0, $F1, $A5, $4C
    .byte $C9, $ED, $D0, $EB, $A9, $B0, $85, $00, $A9, $86, $85, $01, $20, $C4, $90, $A9
    .byte $01, $8D, $08, $04, $A9, $00, $85, $1C, $85, $1B, $A5, $19, $29, $E0, $09, $10
    .byte $85, $19, $20, $A1, $91, $A9, $0C, $85, $3E, $A9, $F2, $85, $3F, $A9, $00, $85
    .byte $40, $85, $41, $85, $42, $20, $E2, $85, $A5, $40, $C9, $20, $B0, $0B, $A9, $02
    .byte $85, $09, $A9, $01, $85, $41, $4C, $5E, $8B, $A9, $30, $85, $00, $A9, $86, $85
    .byte $01, $20, $C4, $90, $A2, $00, $86, $43, $E8, $8E, $08, $04, $86, $09, $4C, $87
    .byte $8B, $A2, $40, $A0, $00, $B9, $9B, $8B, $9D, $00, $03, $E8, $C8, $C0, $80, $90
    .byte $F4, $60, $58, $00, $20, $78, $58, $59, $20, $80, $60, $1C, $20, $78, $60, $69
    .byte $20, $80, $68, $2C, $20, $78, $68, $68, $20, $80, $68, $0E, $21, $5C, $68, $0F
    .byte $21, $64, $70, $1E, $21, $5C, $70, $1F, $21, $64, $78, $2E, $21, $5C, $78, $2F
    .byte $21, $64, $68, $4E, $22, $94, $68, $4F, $22, $9C, $70, $5E, $22, $94, $70, $5F
    .byte $22, $9C, $78, $6E, $22, $94, $78, $6F, $22, $9C, $8C, $4C, $21, $6C, $8C, $4D
    .byte $21, $74, $94, $5C, $21, $6C, $94, $5D, $21, $74, $9C, $6C, $21, $6C, $9C, $6D
    .byte $21, $74, $84, $48, $21, $84, $84, $49, $21, $8C, $8C, $4A, $21, $84, $8C, $4B
    .byte $21, $8C, $94, $5A, $21, $84, $94, $5B, $21, $8C, $9C, $6A, $21, $84, $9C, $6B
    .byte $21, $8C, $01, $0F, $11, $30, $01, $15, $00, $30, $01, $09, $08, $26, $01, $10
    .byte $30, $26, $01, $15, $21, $30, $01, $0F, $26, $30, $01, $05, $26, $30, $01, $15
    .byte $21, $30

Bank3_Func_8C3B:
    LDA #$80
    BNE Bank3_Label_8C45
    LDA #$00
    BEQ Bank3_Label_8C45
    LDA #$01

Bank3_Label_8C45:
    STA $08
    LDX #$7F
    TXS
    LDA #$00
    STA a:$02AA
    JSR Bank3_Func_80DA
    LDA #$03
    JSR Bank3_Func_81AA
    JSR Bank3_Func_9152
    LDA #$BC
    STA $00
    LDA #$AD
    STA $01
    LDA #$20
    STA a:$2006
    LDY #$00
    STY a:$2006
    LDX #$04

Bank3_Label_8C6E:
    LDA ($00),Y
    STA a:$2007
    INY
    BNE Bank3_Label_8C6E
    INC $01
    DEX
    BNE Bank3_Label_8C6E
    LDA #$D4
    STA $00
    LDA #$8E
    STA $01
    JSR Bank3_Func_90C4
    JSR Bank3_Func_90D1
    LDA $19
    AND #$E7
    ORA #$08
    STA $19
    LDX #$00
    STX $1B
    STX $1C
    STX $07
    STX $06
    STX $05
    STX a:$0406
    INX
    STX $09
    LDA #$00
    STA a:$0409
    STA a:$040C
    LDA #$70
    STA a:$040A
    LDA #$80
    STA a:$040B
    LDA #$15
    JSR Bank3_Func_982A
    LDA #$00
    STA $16
    JSR Bank3_Func_80FD

Bank3_Label_8CC1:
    JSR Bank3_Func_8F5A
    JSR Bank3_Func_8CE6
    JSR Bank3_Func_8D3A
    JSR Bank3_Func_8DB1
    LDA a:$0406
    BEQ Bank3_Label_8CC1
    LDA #$00
    JSR Bank3_Func_982A
    LDA $08
    BMI Bank3_Label_8CE3
    BNE Bank3_Label_8CE0
    JMP Bank3_Func_800B

Bank3_Label_8CE0:
    JMP Bank3_Func_8016

Bank3_Label_8CE3:
    JMP Bank3_Func_8000

Bank3_Func_8CE6:
    LDA #$01
    STA a:$0408
    LDA $16
    AND #$7F
    BNE Bank3_Label_8CFB
    INC $05
    LDX $05
    LDA a:$8D36,X
    JSR Bank3_Func_982A

Bank3_Label_8CFB:
    LDX $05
    CPX #$04
    BCC Bank3_Label_8D08
    LDA #$01
    STA a:$0406
    LDX #$03

Bank3_Label_8D08:
    LDA $06
    CLC
    ADC a:$8D2E,X
    STA $06
    LDA $07
    ADC a:$8D32,X
    AND #$03
    STA $07
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    TAX
    LDY #$00

Bank3_Label_8D21:
    LDA a:$8ED4,X
    STA a:$0210,Y
    INX
    INY
    CPY #$20
    BCC Bank3_Label_8D21
    RTS
    .byte $20, $40, $80, $00, $00, $00, $00, $01, $15, $16, $17, $18

Bank3_Func_8D3A:
    LDA $05
    CMP #$03
    BCS Bank3_Label_8D7A
    LDA $16
    LSR A
    BCS Bank3_Label_8D5A
    LDX a:$0409
    INX
    TXA
    AND #$0F
    TAX
    STX a:$0409
    LDA a:$040A
    CLC
    ADC a:$8DA1,X
    STA a:$040A

Bank3_Label_8D5A:
    LDA $05
    BEQ Bank3_Label_8D79
    TAX
    LDA $16
    AND #$01
    ASL A
    CPX #$01
    BNE Bank3_Label_8D6E
    SEC
    SBC #$01
    JMP Bank3_Label_8D72

Bank3_Label_8D6E:
    ASL A
    SEC
    SBC #$02

Bank3_Label_8D72:
    CLC
    ADC a:$040B
    STA a:$040B

Bank3_Label_8D79:
    RTS

Bank3_Label_8D7A:
    LDA $16
    AND #$07
    BNE Bank3_Label_8D8B
    LDX a:$040C
    CPX #$03
    BCS Bank3_Label_8D9A
    INX
    STX a:$040C

Bank3_Label_8D8B:
    LDX a:$040C
    LDA a:$8D9B,X
    STA a:$040A
    LDA a:$8D9E,X
    STA a:$040B

Bank3_Label_8D9A:
    RTS
    .byte $70, $78, $7C, $80, $84, $80, $01, $01, $01, $01, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $01, $01, $01, $01

Bank3_Func_8DB1:
    LDA a:$040C
    CMP #$03
    BCS Bank3_Label_8D9A
    ASL A
    TAX
    LDA a:$8DF3,X
    STA $00
    LDA a:$8DF4,X
    STA $01
    JSR Bank3_Func_8E05
    LDA $08
    BMI Bank3_Label_8D9A
    LDA a:$040C
    ASL A
    TAX
    LDA a:$8DFF,X
    STA $00
    LDA a:$8E00,X
    STA $01
    JSR Bank3_Func_8E05
    LDA $08
    BEQ Bank3_Label_8D9A
    LDA a:$040C
    ASL A
    TAX
    LDA a:$8DF9,X
    STA $00
    LDA a:$8DFA,X
    STA $01
    JMP Bank3_Func_8E05
    .byte $33, $8E, $68, $8E, $79, $8E, $7E, $8E, $A3, $8E, $B4, $8E, $B9, $8E, $C6, $8E
    .byte $CF, $8E

Bank3_Func_8E05:
    LDY #$00

Bank3_Label_8E07:
    LDA ($00),Y
    BEQ Bank3_Label_8D9A
    AND #$FC
    TAX
    LDA ($00),Y
    AND #$03
    STA a:$0302,X
    INY
    LDA ($00),Y
    STA a:$0301,X
    LDA a:$040A
    CLC
    INY
    ADC ($00),Y
    STA a:$0303,X
    LDA a:$040B
    CLC
    INY
    ADC ($00),Y
    STA a:$0300,X
    INY
    JMP Bank3_Label_8E07
    .byte $CD, $0E, $10, $00, $D1, $0F, $18, $00, $D5, $1D, $08, $08, $D9, $1E, $10, $08
    .byte $DD, $2F, $18, $08, $E0, $2C, $00, $10, $E5, $2D, $08, $10, $E9, $2E, $10, $10
    .byte $ED, $2F, $18, $10, $F2, $3C, $00, $18, $F6, $3D, $08, $18, $FA, $3E, $10, $18
    .byte $FE, $3F, $18, $18, $00, $CD, $0A, $00, $00, $D1, $0B, $08, $00, $D5, $1A, $00
    .byte $08, $D9, $1B, $08, $08, $00, $CD, $1C, $00, $00, $00, $A8, $07, $00, $08, $AC
    .byte $08, $08, $08, $B0, $09, $10, $08, $B4, $17, $00, $10, $B8, $18, $08, $10, $BC
    .byte $19, $10, $10, $C0, $27, $00, $18, $C4, $28, $08, $18, $C8, $29, $10, $18, $00
    .byte $A8, $2A, $00, $00, $AC, $2B, $08, $00, $B0, $3A, $00, $08, $B4, $3B, $08, $08
    .byte $00, $A8, $0C, $00, $00, $00, $98, $60, $18, $08, $9C, $63, $18, $10, $A0, $78
    .byte $18, $18, $00, $98, $1F, $08, $00, $9C, $6F, $08, $08, $00, $98, $0D, $00, $00
    .byte $00, $05, $15, $25, $35, $05, $15, $25, $35, $05, $15, $25, $35, $05, $15, $25
    .byte $35, $05, $0F, $26, $30, $05, $0F, $26, $21, $05, $01, $26, $29, $05, $00, $10
    .byte $20, $35, $05, $15, $25, $35, $15, $25, $35, $35, $15, $25, $35, $35, $15, $25
    .byte $35, $35, $0F, $26, $30, $35, $0F, $26, $21, $35, $01, $26, $29, $35, $00, $10
    .byte $20, $25, $35, $05, $15, $25, $15, $25, $35, $25, $15, $25, $35, $25, $15, $25
    .byte $35, $25, $0F, $26, $30, $25, $0F, $26, $21, $25, $01, $26, $29, $25, $00, $10
    .byte $20, $15, $25, $35, $05, $15, $15, $25, $35, $15, $15, $25, $35, $15, $15, $25
    .byte $35, $15, $0F, $26, $30, $15, $0F, $26, $21, $15, $01, $26, $29, $15, $00, $10
    .byte $20, $AD, $80, $01, $D0, $FB, $60

Bank3_Func_8F5A:
    LDA $16

Bank3_Label_8F5C:
    CMP $16
    BEQ Bank3_Label_8F5C
    RTS
    .byte $A9, $00

Bank3_Func_8F63:
    PHA
    LDA $19
    AND #$FB
    STA a:$2000
    LDA #$20
    STA a:$2006
    LDA #$00
    STA a:$2006
    LDY #$00
    LDX #$08
    PLA

Bank3_Label_8F7A:
    STA a:$2007
    DEY
    BNE Bank3_Label_8F7A
    DEX
    BNE Bank3_Label_8F7A
    RTS

Bank3_Func_8F84:
    LDA $19
    AND #$FB
    STA $19
    STA a:$2000

Bank3_Label_8F8D:
    LDY #$00
    LDA ($00),Y
    BEQ Bank3_Label_8FC7
    STA a:$2006
    INY
    LDA ($00),Y
    STA a:$2006
    INY
    LDA ($00),Y
    TAX
    INY
    PHA
    TYA
    LDY #$00
    CLC
    ADC $00
    STA $00
    BCC Bank3_Label_8FAE
    INC $01

Bank3_Label_8FAE:
    LDA ($00),Y
    STA a:$2007
    INY
    DEX
    BNE Bank3_Label_8FAE
    PLA
    BEQ Bank3_Label_8FC2
    TYA
    CLC
    ADC $00
    STA $00
    BCC Bank3_Label_8F8D

Bank3_Label_8FC2:
    INC $01
    JMP Bank3_Label_8F8D

Bank3_Label_8FC7:
    RTS
    .byte $A9, $01, $85, $00, $85, $01, $A5, $21, $25, $00, $F0, $0D, $25, $22, $D0, $11
    .byte $A5, $22, $05, $00, $85, $22, $A5, $01, $60, $A5, $00, $49, $FF, $25, $22, $85
    .byte $22, $E6, $01, $06, $00, $90, $DF, $A9, $00, $60

Bank3_Func_8FF2:
    LDA $09
    ASL A
    TAX
    CPX #$06
    BCS Bank3_Label_9002
    LDA a:$9004,X
    PHA
    LDA a:$9003,X
    PHA

Bank3_Label_9002:
    RTS
    .byte $08, $90, $66, $90, $89, $90, $A5, $14, $F0, $4E, $A5, $19, $8D, $00, $20, $A5
    .byte $1A, $8D, $01, $20, $A5, $1B, $8D, $05, $20, $A5, $1C, $8D, $05, $20, $A5, $0D
    .byte $F0, $36, $A4, $0E, $20, $5C, $90, $A5, $0F, $0A, $2A, $29, $01, $05, $19, $8D
    .byte $00, $20, $A5, $0F, $0A, $8D, $05, $20, $A5, $1C, $8D, $05, $20, $A4, $10, $20
    .byte $5C, $90, $A5, $11, $0A, $2A, $29, $01, $05, $19, $8D, $00, $20, $A5, $11, $0A
    .byte $8D, $05, $20, $A5, $1C, $8D, $05, $20, $60, $A2, $15, $CA, $D0, $FD, $EA, $EA
    .byte $88, $D0, $F6, $60, $20, $03, $91, $20, $2C, $91, $20, $D7, $90, $A5, $19, $29
    .byte $FC, $8D, $00, $20, $A5, $1A, $8D, $01, $20, $A5, $1B, $8D, $05, $20, $A5, $1C
    .byte $8D, $05, $20, $20, $A1, $91, $60, $20, $AF, $91, $20, $D7, $90, $A5, $1B, $8D
    .byte $05, $20, $A5, $1C, $8D, $05, $20, $A5, $1A, $8D, $01, $20, $A5, $42, $F0, $17
    .byte $A5, $19, $29, $E0, $8D, $00, $20, $2C, $02, $20, $70, $FB, $2C, $02, $20, $50
    .byte $FB, $A2, $00, $EA, $CA, $D0, $FC, $A5, $19, $29, $FC, $8D, $00, $20, $4C, $9D
    .byte $91

Bank3_Func_90C4:
    LDY #$00

Bank3_Label_90C6:
    LDA ($00),Y
    STA a:$0210,Y
    INY
    CPY #$20
    BCC Bank3_Label_90C6
    RTS

Bank3_Func_90D1:
    JSR Bank3_WaitForVblank
    JMP Bank3_Label_90DC
    .byte $AD, $08, $04, $F0, $26

Bank3_Label_90DC:
    LDA #$3F
    STA a:$2006
    LDA #$00
    STA a:$2006
    LDY #$E0

Bank3_Label_90E8:
    LDA a:$0130,Y
    STA a:$2007
    INY
    BNE Bank3_Label_90E8
    LDA #$3F
    STA a:$2006
    STY a:$2006
    STY a:$2006
    STY a:$2006
    STA a:$0408
    RTS
    .byte $A5, $1C, $29, $07, $C9, $03, $D0, $F7, $AD, $80, $01, $F0, $F2, $8D, $06, $20
    .byte $AD, $81, $01, $8D, $06, $20, $A2, $00, $BD, $82, $01, $8D, $07, $20, $E8, $E0
    .byte $20, $90, $F5, $A9, $00, $8D, $80, $01, $60, $A5, $1C, $29, $07, $C9, $04, $D0
    .byte $F7, $AD, $C0, $01, $F0, $F2, $A2, $23, $8E, $06, $20, $8D, $06, $20, $A2, $00
    .byte $8E, $C0, $01, $BD, $C1, $01, $8D, $07, $20, $E8, $E0, $08, $90, $F5, $60

Bank3_Func_9152:
    LDA $19
    AND #$FB
    STA $19
    AND #$7F
    STA a:$2000
    LDA #$20
    STA a:$2006
    LDX #$00
    STX a:$2006
    LDY #$08
    LDA #$7F

Bank3_Label_916B:
    STA a:$2007
    INX
    BNE Bank3_Label_916B
    DEY
    BNE Bank3_Label_916B
    LDA #$23
    STA a:$2006
    LDA #$C0
    STA a:$2006
    LDX #$40
    LDA #$00

Bank3_Label_9182:
    STA a:$2007
    INX
    BNE Bank3_Label_9182
    LDA #$27
    STA a:$2006
    LDA #$C0
    STA a:$2006
    LDX #$40
    LDA #$00

Bank3_Label_9196:
    STA a:$2007
    INX
    BNE Bank3_Label_9196
    RTS
    .byte $A2, $04, $D0, $02

Bank3_Func_91A1:
    LDX #$00
    LDA #$F0

Bank3_Label_91A5:
    STA a:$0300,X
    INX
    INX
    INX
    INX
    BNE Bank3_Label_91A5
    RTS
    .byte $A5, $41, $F0, $FB, $A5, $40, $85, $00, $A9, $08, $06, $00, $06, $00, $06, $00
    .byte $06, $00, $2A, $06, $00, $2A, $8D, $06, $20, $A5, $00, $8D, $06, $20, $A0, $00
    .byte $B1, $3E, $8D, $07, $20, $C8, $C0, $20, $90, $F6, $A5, $3E, $18, $69, $20, $85
    .byte $3E, $A5, $3F, $69, $00, $85, $3F, $A9, $00, $85, $41, $E6, $40, $60, $60, $A5
    .byte $16, $29, $03, $D0, $F9, $A6, $1C, $E8, $E0, $F0, $90, $02, $A2, $00, $86, $1C
    .byte $8A, $29, $07, $C9, $03, $D0, $E7, $A9, $08, $85, $01, $A5, $1C, $29, $F8, $0A
    .byte $26, $01, $0A, $26, $01, $8D, $81, $01, $A5, $01, $8D, $80, $01, $A0, $00, $B1
    .byte $4B, $C9, $20, $D0, $02, $A9, $7F, $C9, $2E, $D0, $02, $A9, $5B, $C9, $26, $D0
    .byte $02, $A9, $5F, $99, $82, $01, $C8, $C0, $20, $90, $E4, $A5, $4B, $18, $69, $20
    .byte $85, $4B, $A5, $4C, $69, $00, $85, $4C, $60, $20, $84, $15, $80, $81, $82, $83
    .byte $83, $85, $86, $87, $86, $89, $8A, $8B, $8C, $00, $00, $80, $84, $88, $00, $85
    .byte $82, $20, $A4, $15, $90, $10, $92, $93, $94, $95, $10, $10, $10, $99, $9A, $9B
    .byte $9C, $9D, $9E, $9F, $10, $8D, $8E, $8F, $92, $20, $C4, $16, $A0, $A1, $A2, $A3
    .byte $A4, $A5, $A6, $A7, $A8, $A9, $AA, $AB, $AC, $AD, $AE, $AF, $91, $96, $97, $10
    .byte $EC, $EF, $20, $E5, $16, $B1, $B2, $10, $B4, $A1, $10, $10, $10, $B9, $BA, $10
    .byte $BC, $BD, $10, $BF, $98, $B0, $B3, $10, $F4, $F6, $F8, $21, $04, $17, $C0, $C1
    .byte $C2, $C3, $C4, $C5, $C6, $C7, $C8, $C9, $CA, $10, $CC, $CD, $CE, $CF, $B5, $B6
    .byte $B7, $B8, $FA, $20, $FD, $21, $24, $17, $D0, $D1, $D2, $D3, $D4, $D5, $D6, $10
    .byte $D8, $D9, $C8, $DB, $DC, $DD, $DE, $DF, $BB, $BE, $CB, $D7, $10, $FE, $F7, $21
    .byte $44, $16, $E0, $E1, $E2, $E3, $E4, $E5, $20, $E7, $E8, $B1, $D8, $B2, $10, $ED
    .byte $EE, $10, $C8, $DA, $E6, $E9, $10, $FF, $21, $64, $16, $F0, $F1, $F2, $F3, $00
    .byte $F5, $F1, $F7, $00, $F9, $F3, $FB, $FC, $F3, $F5, $F1, $EA, $FB, $EA, $EB, $F2
    .byte $F3, $21, $E7, $11, $50, $55, $53, $48, $00, $53, $54, $41, $52, $54, $00

TitleScreen_Text:
    .byte $42, $55, $54, $54, $4F, $4E, $22, $48, $0F, $48, $49, $53, $43, $4F, $52, $45
    .byte $00, $00, $00, $00, $00, $00, $00, $30, $22, $8A, $0D, $53, $43, $4F, $52, $45
    .byte $00, $00, $00, $00, $00, $00, $00, $30, $22, $E3, $1B, $43, $4F, $50, $59, $52
    .byte $49, $47, $48, $54, $00, $31, $39, $38, $36, $00, $48, $55, $44, $53, $4F, $4E
    .byte $00, $53, $4F, $46, $54, $5B, $23, $22, $1C, $40, $00, $46, $55, $4A, $49, $4B
    .byte $4F, $5B, $53, $48, $4F, $47, $41, $4B, $55, $4B, $41, $4E, $5B, $54, $56, $00
    .byte $41, $53, $41, $48, $49, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $46, $46, $46, $46, $46, $46, $46, $46, $46, $46
    .byte $46, $46, $46, $46, $46, $46, $46, $46, $46, $46, $46, $46, $46, $46, $46, $46
    .byte $46, $46, $46, $46, $46, $46, $47, $47, $47, $47, $47, $47, $47, $47, $47, $47
    .byte $47, $47, $47, $47, $47, $47, $47, $47, $47, $47, $47, $47, $47, $47, $47, $47
    .byte $47, $47, $47, $47, $47, $47, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55
    .byte $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55
    .byte $7B, $7C, $7D, $55, $55, $55, $56, $56, $56, $56, $7C, $7D, $56, $56, $56, $56
    .byte $56, $56, $56, $56, $56, $56, $56, $56, $56, $56, $56, $56, $56, $56, $56, $56
    .byte $56, $56, $56, $56, $56, $56, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A
    .byte $9A, $9A, $9A, $7B, $7C, $7D, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A
    .byte $9A, $70, $74, $75, $9A, $9A, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B
    .byte $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B
    .byte $79, $DF, $DF, $DF, $7E, $81, $7A, $7A, $7A, $7A, $7A, $7A, $7A, $7A, $7A, $7A
    .byte $71, $72, $73, $7A, $7A, $7A, $77, $78, $76, $7A, $7A, $7A, $7A, $7A, $7A, $71
    .byte $DF, $DF, $DF, $DF, $DF, $91, $EF, $EF, $EF, $62, $66, $80, $64, $65, $63, $62
    .byte $DF, $DF, $DF, $66, $80, $62, $DF, $DF, $DF, $63, $64, $65, $63, $64, $65, $BE
    .byte $DF, $DF, $DF, $DF, $DF, $DF, $66, $80, $62, $DF, $54, $91, $DF, $DF, $BC, $BE
    .byte $DF, $DF, $DF, $54, $91, $DF, $DF, $DF, $DF, $BC, $BE, $DF, $91, $DF, $DF, $BB
    .byte $DF, $DF, $DF, $DF, $DF, $DF, $54, $91, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $BB
    .byte $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $BD, $DF, $DF, $DF, $DF, $DF
    .byte $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF
    .byte $DF, $DF, $DF, $DF, $DF, $DF, $DF, $BD, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF
    .byte $DF, $DF, $DF, $BD, $DF, $DF, $60, $61, $60, $61, $60, $61, $60, $61, $60, $61
    .byte $60, $61, $60, $61, $60, $61, $60, $61, $60, $61, $60, $61, $60, $61, $60, $61
    .byte $60, $61, $60, $61, $60, $61, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9F
    .byte $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9F
    .byte $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8F, $8E, $8F, $8E, $8F, $8E, $8F, $8E, $8F
    .byte $8E, $8F, $8E, $8F, $8E, $8F, $8E, $8F, $8C, $8D, $8E, $8F, $8E, $8F, $8E, $8F
    .byte $8E, $8F, $8E, $8E, $8E, $8E, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9F
    .byte $84, $85, $88, $89, $82, $83, $86, $87, $8A, $8B, $9E, $9F, $9E, $9F, $9E, $9F
    .byte $9E, $9F, $9E, $9F, $8E, $8E, $8E, $8F, $8E, $8F, $8E, $8F, $8E, $8F, $9C, $EF
    .byte $94, $95, $98, $99, $92, $93, $96, $97, $DF, $DF, $EF, $AC, $8E, $8F, $8E, $8F
    .byte $8E, $8F, $8E, $8F, $8E, $8E, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9E, $9D, $EF
    .byte $44, $45, $A8, $A9, $90, $43, $A6, $A7, $AA, $AB, $EF, $AD, $9E, $9F, $9E, $9F
    .byte $9E, $9F, $9E, $9F, $9E, $9F, $8E, $8F, $8E, $8F, $8E, $8F, $8E, $9C, $EF, $EF
    .byte $AE, $AF, $AE, $AF, $AE, $AF, $AE, $AF, $AE, $AF, $EF, $EF, $AC, $8F, $8E, $8F
    .byte $8E, $8F, $8E, $8F, $8E, $8F, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $51, $50, $50
    .byte $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $52, $9E, $9E, $9F
    .byte $9E, $9F, $9E, $9F, $9E, $9F, $8E, $8F, $8E, $8F, $8E, $8F, $8E, $8F, $53, $53
    .byte $53, $53, $53, $53, $53, $53, $53, $53, $53, $53, $53, $53, $8E, $8F, $8E, $8F
    .byte $8E, $8F, $8E, $8F, $8E, $8F, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9F, $8E, $8E
    .byte $8E, $9E, $8E, $8E, $8E, $9E, $8E, $8E, $8E, $8E, $8E, $9F, $9E, $9F, $9E, $9F
    .byte $9E, $9F, $9E, $9F, $9E, $9F, $8E, $8F, $8E, $8F, $8E, $8F, $8E, $8F, $8E, $9E
    .byte $8F, $8F, $9E, $8F, $8E, $8F, $8E, $9E, $8E, $9E, $8E, $8F, $8E, $8F, $8E, $8F
    .byte $8E, $8F, $8E, $8F, $8E, $8F, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9F
    .byte $9E, $9E, $9E, $8E, $9F, $8E, $9E, $9E, $9E, $9F, $9E, $9F, $9E, $9F, $9E, $9F
    .byte $9E, $9F, $9E, $9F, $9E, $9F, $8E, $8F, $8E, $8F, $8E, $8F, $8E, $8F, $8E, $8F
    .byte $8E, $8F, $8E, $9E, $8E, $9E, $8E, $8F, $8E, $8F, $8E, $8F, $8E, $8F, $8E, $8F
    .byte $8E, $8F, $8E, $8F, $8E, $8F, $9E, $8F, $9E, $9E, $9E, $8F, $9E, $8F, $9E, $8F
    .byte $9E, $8F, $9E, $8F, $9E, $8F, $9E, $8F, $9E, $8F, $9E, $8F, $9E, $8F, $9E, $8F
    .byte $9E, $8F, $9E, $8F, $9E, $8F, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E
    .byte $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8F
    .byte $8E, $8F, $8E, $8F, $8E, $8F, $9E, $8F, $9E, $8F, $9E, $8F, $9E, $8F, $9E, $8F
    .byte $9E, $8F, $9E, $8F, $9E, $8F, $9E, $8F, $9E, $8F, $9E, $8F, $9E, $8F, $9E, $9E
    .byte $9E, $8E, $9E, $8E, $9E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E
    .byte $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E
    .byte $8E, $8E, $8E, $8E, $8E, $8E, $9E, $8E, $9E, $8E, $9E, $8E, $9E, $8E, $9E, $8E
    .byte $9E, $8E, $9E, $8E, $9E, $8E, $9E, $8E, $9E, $8E, $9E, $8E, $9E, $8E, $9E, $8E
    .byte $9E, $8E, $9E, $8E, $9E, $8E, $AA, $AA, $AA, $AA, $AA, $AA, $EA, $BA, $AA, $AB
    .byte $AA, $AF, $AA, $AA, $AA, $AA, $AA, $AA, $AA, $AA, $AA, $AA, $AA, $AA, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $54, $64, $4C, $40, $44, $04, $38, $34, $3C
    .byte $1C, $50, $58, $60, $2C, $28, $08, $48, $30, $20, $24, $18, $14, $10, $0C, $5C
    .byte $A1, $98, $A0, $98, $C2, $99, $DA, $99, $19, $9A, $33, $9A, $EE, $9D, $9B, $9D
    .byte $C3, $9D, $CD, $9D, $8E, $9D, $98, $9D, $5E, $9D, $68, $9D, $FA, $9A, $07, $9B
    .byte $1B, $9D, $30, $9C, $24, $9D, $41, $9D, $1C, $9C, $30, $9C, $D9, $9B, $E8, $9B
    .byte $DA, $9C, $F5, $9C, $B1, $9A, $93, $98, $83, $9A, $93, $98, $CA, $9A, $E1, $9A
    .byte $8B, $99, $30, $9C, $93, $99, $30, $9C, $A9, $9C, $BD, $9C, $9B, $9A, $93, $98
    .byte $60, $9B, $93, $98, $7B, $9B, $93, $98, $CE, $98, $F0, $98, $CE, $98, $39, $99
    .byte $91, $9B, $A5, $9B, $69, $99, $98, $98, $C9, $1A, $B0, $1A, $86, $49, $AE, $A0
    .byte $02, $30, $0E, $84, $4A, $A8, $BD, $84, $97, $D9, $84, $97, $90, $09, $98, $A4
    .byte $4A, $8D, $A0, $02, $A6, $49

Bank3_Label_9824:
    RTS
    .byte $A4, $4A, $4C, $22, $98

Bank3_Func_982A:
    CMP #$1A
    BCS Bank3_Label_9824
    STX $49
    LDX #$00
    STX a:$02A1
    STA a:$02A0
    LDX $49
    RTS

Bank3_Func_983B:
    LDX #$03

Bank3_Label_983D:
    LDA a:$02A3,X
    BEQ Bank3_Label_9845
    DEC a:$02A3,X

Bank3_Label_9845:
    DEX
    BPL Bank3_Label_983D
    LDA a:$02A0
    BMI Bank3_Label_9882
    TAX
    ORA #$80
    STA a:$02A0
    CPX #$1A
    BCS Bank3_Label_9882
    LDA a:$02A1
    BEQ Bank3_Label_986B
    LDA a:$9784,X
    CMP a:$02A1
    BCC Bank3_Label_986B
    BNE Bank3_Label_9882
    LDA a:$02A2
    BNE Bank3_Label_9882

Bank3_Label_986B:
    LDA a:$9784,X
    STA a:$02A1
    TAX
    LDA #$00
    STA a:$02A3
    STA a:$02A4
    STA a:$02A5
    STA a:$02A6
    BEQ Bank3_Label_9887

Bank3_Label_9882:
    LDX a:$02A1
    INX
    INX

Bank3_Label_9887:
    CPX #$68
    BCS Bank3_Label_9899
    LDA a:$979F,X
    PHA
    LDA a:$979E,X
    PHA
    RTS
    .byte $CE, $A7, $02, $D0, $08

Bank3_Label_9899:
    LDA #$00
    STA a:$02A1
    STA a:$02A2
    RTS
    .byte $A9, $00, $8D, $A2, $02, $8D, $11, $40, $8D, $A3, $02, $8D, $A4, $02, $8D, $A5
    .byte $02, $8D, $A6, $02, $8D, $08, $40, $8D, $0C, $40, $A9, $18, $8D, $0B, $40, $A9
    .byte $10, $8D, $00, $40, $8D, $04, $40, $A9, $0F, $8D, $15, $40, $60, $A9, $18, $8D
    .byte $A6, $02, $A9, $00, $8D, $0C, $40, $A9, $0C, $8D, $A7, $02, $8D, $0E, $40, $A9
    .byte $08, $8D, $0F, $40, $A9, $00, $8D, $A8, $02, $A9, $04, $8D, $A9, $02, $60, $AE
    .byte $A8, $02, $F0, $2B, $CA, $F0, $03, $4C, $94, $98, $CE, $A7, $02, $AD, $A7, $02
    .byte $8D, $0E, $40, $C9, $08, $D0, $30, $EE, $A8, $02, $A9, $1A, $8D, $0C, $40, $A9
    .byte $03, $8D, $0E, $40, $A9, $F8, $8D, $0F, $40, $A9, $10, $8D, $A7, $02, $60, $CE
    .byte $A9, $02, $D0, $13, $EE, $A8, $02, $A9, $04, $8D, $0C, $40, $AD, $A7, $02, $8D
    .byte $0E, $40, $A9, $08, $8D, $0F, $40, $60, $AE, $A8, $02, $F0, $E2, $CA, $F0, $03
    .byte $4C, $94, $98, $CE, $A7, $02, $AD, $A7, $02, $8D, $0E, $40, $C9, $08, $D0, $E7
    .byte $EE, $A8, $02, $A9, $1A, $8D, $0C, $40, $A9, $06, $8D, $0E, $40, $A9, $68, $8D
    .byte $0F, $40, $A9, $06, $8D, $A7, $02, $60, $A9, $04, $8D, $A5, $02, $8D, $A6, $02
    .byte $8D, $A7, $02, $A9, $1F, $8D, $0C, $40, $A9, $0F, $8D, $0E, $40, $A0, $08, $A2
    .byte $F0, $A9, $38, $20, $40, $9E, $8D, $0F, $40, $60, $A0, $60, $A9, $17, $A2, $00
    .byte $F0, $06, $A0, $08, $A9, $01, $A2, $05, $8C, $A4, $02, $8D, $A7, $02, $8E, $A9
    .byte $02, $A9, $01, $8D, $A8, $02, $20, $AE, $99, $4C, $31, $9C, $A9, $08, $8D, $A6
    .byte $02, $A9, $01, $8D, $0C, $40, $A9, $0A, $8D, $0E, $40, $A9, $08, $8D, $0F, $40
    .byte $60, $A9, $48, $8D, $A3, $02, $8D, $A4, $02, $8D, $A5, $02, $8D, $A6, $02, $A9
    .byte $01, $8D, $A7, $02, $A9, $04, $8D, $A8, $02, $AD, $A8, $02, $D0, $03, $4C, $94
    .byte $98, $CE, $A7, $02, $D0, $DA, $CE, $A8, $02, $F0, $1A, $A9, $04, $8D, $A7, $02
    .byte $AD, $A8, $02, $4A, $90, $0B, $A9, $82, $A2, $00, $20, $24, $9E, $A2, $69, $D0
    .byte $12, $A9, $82, $D0, $07, $A9, $3C, $8D, $A7, $02, $A9, $8F, $A2, $00, $20, $24
    .byte $9E, $A2, $8D, $A9, $08, $4C, $32, $9E, $A9, $4A, $85, $2D, $A9, $9E, $85, $2E
    .byte $A9, $01, $8D, $A7, $02, $8D, $A2, $02, $A9, $09, $8D, $A8, $02, $A9, $83, $8D
    .byte $A9, $02, $20, $6B, $9A, $A2, $00, $AD, $A8, $02, $9D, $A3, $02, $8A, $0A, $0A
    .byte $AA, $AD, $A9, $02, $9D, $00, $40, $A9, $00, $9D, $01, $40, $A0, $00, $B1, $2D
    .byte $F0, $10, $0A, $A8, $B9, $0F, $A3, $9D, $02, $40, $B9, $10, $A3, $09, $08, $9D
    .byte $03, $40, $E6, $2D, $D0, $02, $E6, $2E, $60, $CE, $A7, $02, $D0, $11, $AD, $A8
    .byte $02, $8D, $A7, $02, $A0, $00, $B1, $2D, $C9, $FF, $D0, $05, $20, $99, $98, $68
    .byte $68, $60, $A9, $04, $8D, $A3, $02, $8D, $A7, $02, $8D, $A2, $02, $A9, $00, $AA
    .byte $20, $24, $9E, $A2, $3E, $A9, $38, $4C, $32, $9E, $A9, $0A, $8D, $A4, $02, $8D
    .byte $A7, $02, $A9, $42, $A2, $00, $20, $2B, $9E, $A2, $BB, $A9, $08, $4C, $39, $9E
    .byte $A9, $04, $8D, $A5, $02, $8D, $A7, $02, $8D, $A2, $02, $A9, $84, $A2, $8A, $20
    .byte $24, $9E, $A2, $7E, $A9, $38, $4C, $32, $9E, $A9, $10, $8D, $A6, $02, $8D, $A8
    .byte $02, $A9, $0C, $8D, $A7, $02, $A9, $04, $8D, $0C, $40, $A9, $08, $8D, $0F, $40
    .byte $AD, $A7, $02, $8D, $0E, $40, $AD, $A7, $02, $C9, $0F, $F0, $03, $EE, $A7, $02
    .byte $CE, $A8, $02, $D0, $03, $4C, $99, $98, $60, $A9, $53, $85, $2D, $A9, $9E, $85
    .byte $2E, $A9, $01, $8D, $A7, $02, $CE, $A7, $02, $D0, $ED, $A0, $00, $B1, $2D, $C9
    .byte $FF, $F0, $E2, $8D, $A7, $02, $8D, $A3, $02, $8D, $A4, $02, $8D, $A5, $02, $8D
    .byte $A6, $02, $20, $64, $9A, $A2, $00, $20, $2F, $9B, $20, $2F, $9B, $A0, $00, $B1
    .byte $2D, $F0, $25, $0A, $A8, $AD, $A7, $02, $E0, $08, $F0, $05, $4A, $09, $C0, $D0
    .byte $01, $0A, $9D, $00, $40, $A9, $00, $9D, $01, $40, $B9, $0F, $A3, $9D, $02, $40
    .byte $B9, $10, $A3, $09, $08, $9D, $03, $40, $E8, $E8, $E8, $E8, $4C, $64, $9A, $A9
    .byte $18, $8D, $A4, $02, $A9, $10, $8D, $A7, $02, $8D, $A2, $02, $A9, $A0, $A2, $9B
    .byte $20, $2B, $9E, $A2, $FE, $A9, $19, $4C, $39, $9E, $A9, $08, $8D, $A4, $02, $8D
    .byte $A7, $02, $A9, $C0, $A2, $83, $20, $2B, $9E, $A2, $60, $A9, $08, $4C, $39, $9E
    .byte $A9, $18, $8D, $A6, $02, $A9, $04, $8D, $0E, $40, $A9, $0F, $8D, $A7, $02, $A9
    .byte $00, $8D, $A8, $02, $AD, $A7, $02, $C9, $10, $F0, $25, $09, $10, $8D, $0C, $40
    .byte $A9, $28, $8D, $0F, $40, $AD, $A8, $02, $F0, $04, $EE, $A7, $02, $60, $AD, $A7
    .byte $02, $C9, $02, $90, $07, $CE, $A7, $02, $CE, $A7, $02, $60, $EE, $A8, $02, $60
    .byte $A9, $10, $8D, $0C, $40, $4C, $99, $98, $A9, $03, $8D, $A8, $02, $A9, $FF, $8D
    .byte $A4, $02, $A9, $00, $8D, $A7, $02, $AD, $A7, $02, $D0, $27, $AD, $A8, $02, $D0
    .byte $08, $A9, $00, $8D, $A4, $02, $4C, $99, $98, $CE, $A8, $02, $A9, $84, $A2, $8B
    .byte $20, $2B, $9E, $AC, $A8, $02, $BE, $19, $9C, $A9, $10, $20, $39, $9E, $A9, $04
    .byte $8D, $A7, $02, $CE, $A7, $02, $60
    .incbin "assets/generated/audio/sfx/prg3-tone-low.bin", $0, $4  ; rom-asset .byte
    .byte $A0, $14, $A9, $04, $A2
    .byte $03, $8C, $A4, $02, $8D, $A7, $02, $8E, $A9, $02, $A9, $01, $8D, $A8, $02, $CE
    .byte $A8, $02, $D0, $26, $AD, $A7, $02, $30, $22, $18, $6D, $A9, $02, $0A, $A8, $A9
    .byte $DF, $A2, $8C, $20, $2B, $9E, $B9, $60, $9C, $AA, $B9, $61, $9C, $09, $88, $20
    .byte $39, $9E, $CE, $A7, $02, $A9, $04, $8D, $A8, $02, $60, $4C, $99, $98
    .incbin "assets/generated/audio/sfx/prg3-pitch-periods.bin", $0, $2  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg3-pitch-periods.bin", $2, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg3-pitch-periods.bin", $12, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg3-pitch-periods.bin", $22, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg3-pitch-periods.bin", $32, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg3-pitch-periods.bin", $42, $8  ; rom-asset .byte
    .byte $A9, $10, $8D, $A5, $02, $A9, $40, $8D
    .byte $A7, $02, $A9, $01, $8D, $A8, $02, $A9, $30, $8D, $A9, $02, $A0, $01, $AE, $A7
    .byte $02, $A9, $08, $20, $40, $9E, $AD, $A7, $02, $38, $ED, $A8, $02, $8D, $A7, $02
    .byte $CD, $A9, $02, $D0, $03, $4C, $99, $98, $60, $A9, $0E, $8D, $A4, $02, $A9, $06
    .byte $8D, $A7, $02, $8D, $A8, $02, $A9, $9F, $A2, $8D, $20, $2B, $9E, $A2, $00, $A9
    .byte $89, $4C, $39, $9E, $CE, $A7, $02, $D0, $20, $AD, $A8, $02, $F0, $18, $A9, $08
    .byte $8D, $A7, $02, $A9, $00, $8D, $A8, $02, $A9, $9F, $A2, $8C, $20, $2B, $9E, $A2
    .byte $80, $A9, $88, $4C, $39, $9E, $4C, $99, $98, $60, $A0, $34, $A9, $0C, $A2, $18
    .byte $4C, $23, $9C, $A9, $20, $8D, $A4, $02, $A9, $1F, $A2, $85, $20, $2B, $9E, $A2
    .byte $69, $A9, $08, $20, $39, $9E, $A9, $02, $8D, $A7, $02, $A9, $01, $8D, $A8, $02
    .byte $CE, $A8, $02, $D0, $16, $A9, $04, $8D, $A8, $02, $AC, $A7, $02, $B9, $5E, $9D
    .byte $8D, $04, $40, $CE, $A7, $02, $10, $03, $4C, $99, $98, $60, $00, $A9, $00, $8D
    .byte $A7, $02, $A9, $01, $8D, $A8, $02, $CE, $A8, $02, $D0, $20, $AD, $A7, $02, $49
    .byte $04, $8D, $A7, $02, $A8, $B9, $0F, $9E, $8D, $A8, $02, $A9, $DF, $BE, $0C, $9E
    .byte $20, $24, $9E, $BE, $0D, $9E, $B9, $0E, $9E, $4C, $32, $9E, $60, $A9, $00, $8D
    .byte $A9, $02, $A9, $08, $4C, $61, $9D, $20, $69, $9D, $A9, $00, $8D, $0C, $40, $AD
    .byte $A9, $02, $29, $03, $F0, $0E, $AD, $A9, $02, $4A, $4A, $4A, $8D, $0E, $40, $A9
    .byte $08, $8D, $0F, $40, $EE, $A9, $02, $AD, $A9, $02, $10, $05, $A9, $7F, $8D, $A9
    .byte $02, $60, $A9, $0F, $8D, $A9, $02, $A9, $10, $4C, $61, $9D, $20, $69, $9D, $AD
    .byte $A9, $02, $4A, $B0, $14, $A9, $00, $8D, $0C, $40, $AD, $A9, $02, $4A, $4A, $4A
    .byte $4A, $8D, $0E, $40, $A9, $18, $8D, $0F, $40, $CE, $A9, $02, $60, $A9, $1F, $A2
    .byte $AB, $20, $24, $9E, $A9, $98, $A9, $9B, $20, $2B, $9E, $A2, $00, $8E, $A7, $02
    .byte $A9, $0C, $20, $32, $9E, $A9, $0A, $4C, $39, $9E
    .incbin "assets/generated/audio/sfx/prg3-pulse-control.bin", $0, $2  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg3-pulse-steps.bin", $0, $4  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg3-pulse-steps.bin", $4, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg3-pulse-steps.bin", $14, $2  ; rom-asset .byte
    .byte $8D, $00, $40, $8E, $01, $40, $60, $8D, $04, $40, $8E, $05, $40, $60
    .byte $8E, $02, $40, $8D, $03, $40, $60, $8E, $06, $40, $8D, $07, $40, $60, $8C, $08
    .byte $40, $8E, $0A, $40, $8D, $0B, $40, $60, $2C, $31, $2C, $31, $35, $38, $3D, $41
    .byte $FF, $08, $2E, $2B, $27, $08, $30, $2C, $29, $08, $32, $2D, $2A, $03, $33, $2E
    .byte $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E
    .byte $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E
    .byte $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E
    .byte $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E
    .byte $2B, $FF

Bank3_Label_9EA4:
    BMI Bank3_Label_9EC9
    ORA #$80
    STA a:$02AB

Bank3_Func_9EAB:
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

Bank3_Label_9EC9:
    LDX #$00
    JSR Bank3_Func_9F9B
    INX
    JSR Bank3_Func_9F9B
    INX
    INX
    JMP Bank3_Func_9F9B
    .byte $60

Bank3_Func_9ED8:
    LDA a:$02AB
    BNE Bank3_Label_9EA4
    LDA a:$02AA
    BEQ Bank3_Label_9EC9
    BPL Bank3_Label_9EE7
    JMP Bank3_Label_9F6B

Bank3_Label_9EE7:
    LDA a:$02AA
    CMP #$05
    BCC Bank3_Label_9EF1
    JMP Bank3_Label_9F95

Bank3_Label_9EF1:
    ORA #$80
    STA a:$02AA
    ASL A
    ASL A
    ASL A
    TAY
    LDX #$07

Bank3_Label_9EFC:
    LDA a:$A4D5,Y
    STA $2F,X
    STA a:$02DC,X
    DEY
    DEX
    BPL Bank3_Label_9EFC
    STX a:$02B4
    STX a:$02B5
    STX a:$02B6
    STX a:$02B7
    INX
    STX $46
    STX $47
    STX $48
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
    JSR Bank3_Func_9EAB

Bank3_Label_9F6B:
    LDA #$00
    STA a:$02FE
    STA a:$02FD

Bank3_Label_9F73:
    LDX a:$02FD
    DEC a:$02B0,X
    BEQ Bank3_Label_9F81
    JSR Bank3_Func_9F9B
    JMP Bank3_Label_9F84

Bank3_Label_9F81:
    JSR Bank3_Func_9FE7

Bank3_Label_9F84:
    INC a:$02FD
    LDA a:$02FD
    CMP #$04
    BCC Bank3_Label_9F73
    LDA a:$02FE
    CMP #$04
    BNE Bank3_Label_9F9A

Bank3_Label_9F95:
    LDA #$00
    STA a:$02AA

Bank3_Label_9F9A:
    RTS

Bank3_Func_9F9B:
    CPX #$02
    BEQ Bank3_Label_9FE6
    LDA a:$02F3,X
    AND #$10
    BEQ Bank3_Label_9FE6
    LDA a:$02BC,X
    ASL A
    STA a:$02FF
    BCC Bank3_Label_9FBA
    LDA a:$02B8,X
    SEC
    SBC a:$02FF
    BCS Bank3_Label_9FC5
    BCC Bank3_Label_9FC3

Bank3_Label_9FBA:
    LDA a:$02B8,X
    CLC
    ADC a:$02FF
    BCC Bank3_Label_9FC5

Bank3_Label_9FC3:
    LDA #$00

Bank3_Label_9FC5:
    STA a:$02B8,X
    LDY a:$02A3,X
    BNE Bank3_Label_9FE6
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

Bank3_Label_9FE6:
    RTS

Bank3_Func_9FE7:
    LDX a:$02FD
    CPX #$03
    BNE Bank3_Label_9FF6
    LDA a:$02FC
    BEQ Bank3_Label_9FF6
    JMP Bank3_Label_A0FC

Bank3_Label_9FF6:
    JSR Bank3_Func_A301
    STA a:$02FF
    TAY
    BMI Bank3_Label_A002
    JMP Bank3_Label_A0E0

Bank3_Label_A002:
    CMP #$EF
    BCC Bank3_Label_A039
    SEC
    LDA #$FF
    SBC a:$02FF
    ASL A
    TAY
    LDA a:$A018,Y
    PHA
    LDA a:$A017,Y
    PHA
    RTS
    .byte $78, $A1, $54, $A2, $8F, $A1, $C8, $A1, $AD, $A1, $F0, $A1, $06, $A2, $19, $A2
    .byte $3E, $A2, $86, $A2, $C8, $A2, $B8, $A2, $A6, $A2, $D5, $A2, $66, $A2, $3F, $A0
    .byte $DD, $A2

Bank3_Label_A039:
    LDA a:$02FF
    AND #$7F
    BPL Bank3_Label_A043
    JSR Bank3_Func_A301

Bank3_Label_A043:
    LDX a:$02FD
    STA a:$02AC,X
    LDA a:$02EF,X
    BNE Bank3_Label_A0CA
    LDX a:$02FD
    LDA a:$02AC,X
    STA a:$02FF
    LDX a:$02FD
    CPX #$02
    BEQ Bank3_Label_A0CD
    LDA a:$02F3,X
    AND #$10
    BNE Bank3_Label_A080
    LDA a:$02F3,X
    AND #$D0
    STA a:$02F3,X
    LDA a:$02FF
    LSR A
    CMP #$10
    BCC Bank3_Label_A077
    LDA #$0F

Bank3_Label_A077:
    ORA a:$02F3,X
    STA a:$02F3,X
    JMP Bank3_Label_A08B

Bank3_Label_A080:
    LDY a:$02FF
    LDA a:$A3D6,Y
    ORA #$80
    STA a:$02BC,X

Bank3_Label_A08B:
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
    BCS Bank3_Label_A0B9
    ASL A
    ASL A
    ASL A
    ASL A
    ORA #$08
    STA a:$02F7,X
    LDA a:$02F3,X
    AND #$10
    BEQ Bank3_Label_A0CA
    LDA a:$02F7,X
    CMP #$08
    BNE Bank3_Label_A0CA
    LDA #$18
    BNE Bank3_Label_A0C7

Bank3_Label_A0B9:
    LDY #$00

Bank3_Label_A0BB:
    CMP a:$A3A6,Y
    BCS Bank3_Label_A0C4
    INY
    INY
    BNE Bank3_Label_A0BB

Bank3_Label_A0C4:
    LDA a:$A3A7,Y

Bank3_Label_A0C7:
    STA a:$02F7,X

Bank3_Label_A0CA:
    JMP Bank3_Func_9FE7

Bank3_Label_A0CD:
    LDA a:$02FF
    ASL A
    BMI Bank3_Label_A0D8
    ADC a:$02FF
    BPL Bank3_Label_A0DA

Bank3_Label_A0D8:
    LDA #$7F

Bank3_Label_A0DA:
    STA a:$02F5
    JMP Bank3_Label_A0CA

Bank3_Label_A0E0:
    CMP #$00
    BNE Bank3_Label_A0E7
    JMP Bank3_Label_A16F

Bank3_Label_A0E7:
    LDX a:$02FD
    CPX #$03
    BNE Bank3_Label_A12B
    PHA
    AND #$0F
    STA a:$02FC
    PLA
    LSR A
    LSR A
    LSR A
    LSR A
    STA a:$02FB

Bank3_Label_A0FC:
    DEC a:$02FC
    LDA a:$02A6
    BNE Bank3_Label_A16F
    LDA a:$02FB
    BEQ Bank3_Label_A16F
    ASL A
    ASL A
    TAX
    LDY #$00

Bank3_Label_A10E:
    LDA a:$A3B6,X
    STA a:$400C,Y
    INX
    INY
    CPY #$04
    BCC Bank3_Label_A10E
    LDA a:$02F6
    AND #$10
    BEQ Bank3_Label_A161
    LDA a:$02F6
    AND #$1F
    STA a:$400C
    BPL Bank3_Label_A161

Bank3_Label_A12B:
    LDY a:$02A3,X
    BNE Bank3_Label_A16F
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
    ADC a:$A3A3,X
    CLC
    ADC $46,X
    CLC
    ADC a:$02EC,X
    ASL A
    TAX
    LDA a:$A30F,X
    STA a:$4002,Y
    LDA a:$A310,X
    LDX a:$02FD
    ORA a:$02F7,X
    STA a:$4003,Y

Bank3_Label_A161:
    LDX a:$02FD
    LDA a:$02EF,X
    BNE Bank3_Label_A16F
    LDA a:$02B4,X
    STA a:$02B8,X

Bank3_Label_A16F:
    LDX a:$02FD
    LDA a:$02AC,X
    STA a:$02B0,X
    RTS
    .byte $AE, $FD, $02, $A9, $01, $9D, $B0, $02, $8A, $0A, $AA, $B5, $2F, $D0, $02, $D6
    .byte $30, $D6, $2F, $EE, $FE, $02, $60, $20, $01, $A3, $AE, $FD, $02, $9D, $D4, $02
    .byte $A9, $01, $9D, $D8, $02, $8A, $0A, $AA, $B5, $2F, $9D, $C4, $02, $B5, $30, $9D
    .byte $C5, $02, $4C, $E7, $9F, $20, $01, $A3, $AE, $FD, $02, $DD, $D8, $02, $B0, $0D
    .byte $8A, $0A, $AA, $BD, $CC, $02, $95, $2F, $BD, $CD, $02, $95, $30, $4C, $E7, $9F
    .byte $AE, $FD, $02, $BD, $D8, $02, $DD, $D4, $02, $B0, $1A, $FE, $D8, $02, $8A, $0A
    .byte $AA, $B5, $2F, $9D, $CC, $02, $B5, $30, $9D, $CD, $02, $BD, $C4, $02, $95, $2F
    .byte $BD, $C5, $02, $95, $30, $4C, $E7, $9F, $20, $01, $A3, $AE, $FD, $02, $9D, $C0
    .byte $02, $BD, $B4, $02, $9D, $B8, $02, $A9, $FF, $9D, $EF, $02, $D0, $32, $AE, $FD
    .byte $02, $A9, $00, $9D, $EF, $02, $BD, $F3, $02, $29, $CF, $9D, $F3, $02, $4C, $4E
    .byte $A0, $20, $01, $A3, $AE, $FD, $02, $E0, $02, $F0, $A2, $29, $C0, $8D, $FF, $02
    .byte $BD, $F3, $02, $29, $10, $0D, $FF, $02, $9D, $F3, $02, $BD, $EF, $02, $F0, $DE
    .byte $BD, $C0, $02, $4C, $54, $A0, $20, $45, $A2, $4C, $E7, $9F, $AD, $FD, $02, $0A
    .byte $AA, $B5, $2F, $9D, $DC, $02, $B5, $30, $9D, $DD, $02, $60, $AD, $FD, $02, $0A
    .byte $AA, $BD, $DC, $02, $95, $2F, $BD, $DD, $02, $95, $30, $4C, $E7, $9F, $AD, $AA
    .byte $02, $0A, $0A, $38, $E9, $04, $18, $6D, $FD, $02, $0A, $A8, $AD, $FD, $02, $0A
    .byte $AA, $B9, $D6, $A4, $95, $2F, $B9, $D7, $A4, $95, $30, $4C, $E7, $9F, $20, $01
    .byte $A3, $48, $20, $01, $A3, $48, $AD, $FD, $02, $0A, $AA, $B5, $2F, $9D, $E4, $02
    .byte $B5, $30, $9D, $E5, $02, $68, $95, $30, $68, $95, $2F, $4C, $E7, $9F, $AD, $FD
    .byte $02, $0A, $AA, $BD, $E4, $02, $95, $2F, $BD, $E5, $02, $95, $30, $4C, $E7, $9F
    .byte $20, $01, $A3, $AE, $FD, $02, $E0, $03, $F0, $03, $9D, $EC, $02, $4C, $E7, $9F
    .byte $20, $01, $A3, $A2, $02, $95, $46, $CA, $10, $FB, $4C, $E7, $9F, $AE, $FD, $02
    .byte $A9, $08, $4C, $C7, $A0, $20, $01, $A3, $AE, $FD, $02, $9D, $B4, $02, $9D, $B8
    .byte $02, $4A, $4A, $4A, $4A, $8D, $FF, $02, $BD, $F3, $02, $29, $C0, $09, $10, $0D
    .byte $FF, $02, $9D, $F3, $02, $4C, $E7, $9F

Bank3_Func_A301:
    LDA a:$02FD
    ASL A
    TAX
    LDA ($2F,X)
    INC $2F,X
    BNE Bank3_Label_A30E
    INC $30,X

Bank3_Label_A30E:
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
    .byte $30, $24, $D0, $1E, $50, $18, $A0, $14, $20, $00, $F0, $00, $00, $0F, $20, $00
    .byte $00, $0C, $20, $00, $00, $08, $20, $00, $00, $04, $20, $00, $00, $03, $20, $00
    .byte $00, $02, $A8, $00, $00, $01, $48, $7F, $7F, $40, $2A, $20, $19, $15, $12, $10
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
    .byte $01, $01, $01, $01, $01, $01, $01, $F6, $A4, $D6, $A5, $C1, $A6, $9E, $A7, $11
    .byte $A8, $6C, $A8, $C5, $A8, $11, $A9, $38, $A9, $8B, $A9, $DF, $A9, $2D, $AA, $4B
    .byte $AD, $83, $AD, $A4, $AD, $BB, $AD
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $0, $9  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $19, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $29, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $39, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $49, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $59, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $69, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $79, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $89, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $99, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $A9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $B9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $C9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $D9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $E9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $F9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $109, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $119, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $129, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $139, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $149, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $159, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $169, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $179, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $189, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $199, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $1A9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $1B9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $1C9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $1D9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $1E9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $1F9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $209, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $219, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $229, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $239, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $249, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $259, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $269, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $279, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $289, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $299, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $2A9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $2B9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $2C9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $2D9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $2E9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $2F9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $309, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $319, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $329, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $339, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $349, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $359, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $369, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $379, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $389, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $399, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $3A9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $3B9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $3C9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $3D9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $3E9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $3F9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $409, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $419, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $429, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $439, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $449, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $459, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $469, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $479, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $489, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $499, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $4A9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $4B9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $4C9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $4D9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $4E9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $4F9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $509, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $519, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $529, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $539, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $549, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $559, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $569, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $579, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $589, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $599, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $5A9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $5B9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $5C9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $5D9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $5E9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $5F9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $609, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $619, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $629, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $639, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $649, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $659, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $669, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $679, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $689, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $699, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $6A9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $6B9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $6C9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $6D9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $6E9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $6F9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $709, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $719, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $729, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $739, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $749, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $759, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $769, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $779, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $789, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $799, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $7A9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $7B9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $7C9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $7D9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $7E9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $7F9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $809, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $819, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $829, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $839, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $849, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $859, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $869, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $879, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $889, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $899, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $8A9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg3-a4f6.bin", $8B9, $D  ; rom-asset .byte
    .byte $10, $01, $21
    .byte $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
    .byte $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $02, $20, $10, $10, $01
    .byte $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
    .byte $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $02, $20, $20, $10, $10, $10
    .byte $01, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
    .byte $21, $21, $21, $21, $21, $21, $21, $21, $21, $02, $20, $20, $20, $10, $10, $10
    .byte $10, $01, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
    .byte $21, $21, $21, $21, $21, $21, $21, $21, $02, $20, $20, $20, $20, $10, $10, $10
    .byte $10, $10, $01, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
    .byte $21, $21, $21, $21, $21, $21, $21, $02, $20, $20, $20, $20, $20, $10, $10, $10
    .byte $10, $10, $10, $01, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
    .byte $21, $21, $21, $21, $21, $21, $02, $20, $20, $20, $20, $20, $20, $10, $10, $10
    .byte $10, $10, $10, $10, $01, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
    .byte $21, $21, $21, $21, $21, $02, $20, $20, $20, $20, $20, $20, $20, $10, $10, $10
    .byte $10, $10, $10, $10, $10, $01, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
    .byte $21, $21, $21, $21, $02, $20, $20, $20, $20, $20, $20, $20, $20, $10, $10, $10
    .byte $10, $10, $10, $10, $10, $10, $01, $21, $21, $21, $21, $21, $21, $21, $21, $21
    .byte $21, $21, $21, $02, $20, $20, $20, $20, $20, $20, $20, $20, $20, $10, $10, $10
    .byte $10, $10, $10, $10, $10, $10, $10, $01, $21, $21, $21, $21, $21, $21, $21, $21
    .byte $21, $21, $02, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $10, $10, $10
    .byte $10, $10, $10, $10, $10, $10, $10, $10, $01, $21, $21, $21, $21, $21, $21, $21
    .byte $21, $02, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $10, $10, $10
    .byte $10, $10, $10, $10, $10, $10, $10, $10, $10, $01, $21, $21, $21, $21, $21, $21
    .byte $02, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $10, $10, $10
    .byte $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $01, $21, $21, $21, $21, $02
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $10, $10, $10
    .byte $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $01, $21, $21, $02, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $10, $10, $10
    .byte $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $01, $02, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $10, $10, $10
    .byte $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $11, $12, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $10, $10, $10
    .byte $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $11, $22, $22, $12, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $10, $10, $10
    .byte $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $11, $22, $22, $22, $22, $12
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $10, $10, $10
    .byte $10, $10, $10, $10, $10, $10, $10, $10, $10, $11, $22, $22, $22, $22, $22, $22
    .byte $12, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $10, $10, $10
    .byte $10, $10, $10, $10, $10, $10, $10, $10, $11, $22, $22, $22, $22, $22, $22, $22
    .byte $22, $12, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $10, $10, $10
    .byte $10, $10, $10, $10, $10, $10, $10, $11, $22, $22, $22, $22, $22, $22, $22, $22
    .byte $22, $22, $12, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $10, $10, $10
    .byte $10, $10, $10, $10, $10, $10, $11, $22, $22, $22, $22, $22, $22, $22, $22, $22
    .byte $22, $22, $22, $12, $20, $20, $20, $20, $20, $20, $20, $20, $20, $10, $10, $10
    .byte $10, $10, $10, $10, $10, $11, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22
    .byte $22, $22, $22, $22, $12, $20, $20, $20, $20, $20, $20, $20, $20, $10, $10, $10
    .byte $10, $10, $10, $10, $11, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22
    .byte $22, $22, $22, $22, $22, $12, $20, $20, $20, $20, $20, $20, $20, $10, $10, $10
    .byte $10, $10, $10, $11, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22
    .byte $22, $22, $22, $22, $22, $22, $12, $20, $20, $20, $20, $20, $20, $10, $10, $10
    .byte $10, $10, $11, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22
    .byte $22, $22, $22, $22, $22, $22, $22, $12, $20, $20, $20, $20, $20, $10, $10, $10
    .byte $10, $11, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22
    .byte $22, $22, $22, $22, $22, $22, $22, $22, $12, $20, $20, $20, $20, $10, $10, $10
    .byte $11, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22
    .byte $22, $22, $22, $22, $22, $22, $22, $22, $22, $12, $20, $20, $20, $10, $10, $11
    .byte $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22
    .byte $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $12, $20, $20, $10, $11, $22
    .byte $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22
    .byte $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $12, $20, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $50, $50, $50, $50, $50, $50, $50, $50, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $D0, $D1, $D2, $7F, $7F, $7F, $D3, $D4, $D5, $7F, $7F
    .byte $7F, $DC, $DD, $DE, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $E0, $E1, $E2, $7F, $7F, $7F, $E3, $E4, $E5, $7F, $7F
    .byte $7F, $EC, $ED, $EE, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $F0, $F1, $F2, $7F, $7F, $7F, $F3, $F4, $F5, $7F, $7F
    .byte $7F, $FC, $FD, $FE, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $EF, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $54, $41, $4E, $4D, $41
    .byte $7F, $57, $41, $54, $43, $48, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $61, $62, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $53, $48, $4F, $43, $4B
    .byte $7F, $47, $55, $4E, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $70, $71, $72, $73, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $64, $65, $66, $67, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $74, $75, $76, $77, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $4B, $55, $55, $4B, $49
    .byte $48, $4F, $55, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $68, $69, $6A, $6B, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $79, $7A, $7B, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $4B, $59, $4F, $55, $52
    .byte $59, $4F, $4B, $55, $7F, $55, $43, $48, $49, $57, $41, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $44, $4F, $52, $41, $59
    .byte $41, $4B, $49, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $47, $45, $4E, $4B, $49
    .byte $7F, $43, $41, $4E, $44, $59, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $30, $00, $00, $00, $00, $00, $00, $00, $00, $40, $00
    .byte $44, $55, $55, $11, $00, $40, $55, $00, $44, $55, $15, $00, $00, $04, $55, $00
    .byte $44, $55, $51, $50, $10, $00, $00, $00, $44, $55, $11, $00, $00, $00, $00, $00
    .byte $44, $05, $05, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $D6, $D7, $D8, $7F, $7F, $7F, $D9, $DA, $DB, $7F, $7F
    .byte $7F, $DC, $DD, $DE, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $E6, $E7, $E8, $7F, $7F, $7F, $E9, $EA, $EB, $7F, $7F
    .byte $7F, $EC, $ED, $EE, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $F6, $F7, $F8, $7F, $7F, $7F, $F9, $FA, $FB, $7F, $7F
    .byte $7F, $FC, $FD, $FE, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $EF, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $53, $4D, $41, $4C, $4C
    .byte $7F, $4C, $49, $47, $48, $54, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $61, $62, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $70, $71, $72, $73, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $64, $65, $66, $67, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $48, $49, $52, $41, $52
    .byte $49, $7F, $4D, $41, $4E, $54, $4C, $45, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $74, $75, $76, $77, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $68, $69, $6A, $6B, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $79, $7A, $7B, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $44, $4F, $52, $41, $59
    .byte $41, $4B, $49, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $47, $45, $4E, $4B, $49
    .byte $7F, $43, $41, $4E, $44, $59, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $30, $00, $00, $00, $00, $00, $00, $00, $00, $40, $00
    .byte $54, $55, $55, $11, $00, $40, $55, $00, $51, $50, $50, $50, $00, $04, $55, $00
    .byte $55, $55, $51, $50, $10, $00, $00, $00, $55, $55, $51, $50, $00, $00, $00, $00
    .byte $55, $05, $05, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $A0, $A1, $A2, $7F, $7F, $7F, $A3, $A4, $A5, $7F, $7F
    .byte $7F, $DC, $DD, $DE, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $B0, $B1, $B2, $7F, $7F, $7F, $B3, $B4, $B5, $7F, $7F
    .byte $7F, $EC, $ED, $EE, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $C0, $C1, $C2, $7F, $7F, $7F, $C3, $C4, $C5, $7F, $7F
    .byte $7F, $FC, $FD, $FE, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $EF, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $54, $4F, $55, $52, $49
    .byte $4E, $55, $4B, $45, $7F, $48, $4F, $4F, $50, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $4B, $41, $47, $49, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $61, $62, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $70, $71, $72, $73, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $64, $65, $66, $67, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $54, $4F, $52, $49, $59
    .byte $4F, $53, $45, $7F, $42, $41, $47, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $74, $75, $76, $77, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $68, $69, $6A, $6B, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $79, $7A, $7B, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $4F, $4D, $41, $4D, $4F
    .byte $52, $49, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $54, $41, $4E, $4D, $41
    .byte $7F, $57, $41, $54, $43, $48, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $44, $4F, $52, $41, $59
    .byte $41, $4B, $49, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $47, $45, $4E, $4B, $49
    .byte $7F, $43, $41, $4E, $44, $59, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
    .byte $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $30, $00, $00, $00, $00, $00, $00, $00, $00, $40, $00
    .byte $55, $55, $55, $55, $01, $40, $55, $00, $55, $51, $50, $50, $00, $04, $55, $00
    .byte $55, $55, $51, $50, $10, $00, $00, $00, $55, $55, $55, $51, $00, $00, $00, $00
    .byte $55, $55, $55, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00

EndingCredits_Text:
    .byte $20, $20, $20, $20, $20, $20, $20, $45, $58, $45, $43, $55, $54, $49, $56, $45
    .byte $20, $50, $52, $4F, $44, $55, $43, $45, $52, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $59, $55, $4A, $49
    .byte $20, $4B, $55, $44, $4F, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $48, $49, $52, $4F, $53
    .byte $48, $49, $20, $4B, $55, $44, $4F, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $50, $52, $4F, $44
    .byte $55, $43, $45, $52, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $59, $55, $4B, $49, $4F
    .byte $20, $4F, $53, $41, $54, $4F, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $44, $49, $52, $45
    .byte $43, $54, $45, $44, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $42
    .byte $59, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $4B, $41, $54, $53, $55, $48, $49, $52
    .byte $4F, $20, $4E, $4F, $5A, $41, $57, $41, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $53, $43, $52, $45, $45
    .byte $4E, $50, $4C, $41, $59, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $42
    .byte $59, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $4D, $45, $49, $4A, $49, $4E, $20, $54
    .byte $41, $4B, $41, $48, $41, $53, $48, $49, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $53, $54, $4F
    .byte $52, $59, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $42
    .byte $59, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $4B, $41, $54, $53, $55, $48, $49, $52
    .byte $4F, $20, $4E, $4F, $5A, $41, $57, $41, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $50, $52, $4F, $47
    .byte $52, $41, $4D, $45, $44, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $42
    .byte $59, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $53, $48, $49, $4E, $49, $43, $48, $49
    .byte $20, $4E, $41, $4B, $41, $4D, $4F, $54, $4F, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $4D, $41, $53, $41, $41, $4B, $49
    .byte $20, $4B, $49, $4B, $55, $54, $41, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $4B, $41, $54, $53, $55, $48, $49, $52, $4F
    .byte $20, $4E, $4F, $5A, $41, $57, $41, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $48, $49, $54, $4F, $53, $48, $49
    .byte $20, $4F, $4B, $55, $4E, $4F, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $46, $55, $4D, $49, $48, $49, $4B, $4F
    .byte $20, $49, $54, $41, $47, $41, $4B, $49, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $47, $41, $4D, $45, $20, $44, $45
    .byte $53, $49, $47, $4E, $45, $44, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $42
    .byte $59, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $54, $53, $55, $47, $55, $59, $55, $4B, $49
    .byte $20, $59, $41, $4D, $41, $4D, $4F, $54, $4F, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $4E, $4F, $4E
    .byte $54, $41, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $53, $48, $49, $4E, $20
    .byte $43, $48, $41, $4E, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $4F, $4B, $4B
    .byte $55, $4E, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $54, $4F, $53, $48, $49, $52, $4F, $48
    .byte $20, $4F, $4B, $41, $4D, $4F, $54, $4F, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $4B, $49, $4B
    .byte $55, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $4B, $4F, $55, $4A, $49, $20, $4D
    .byte $41, $54, $53, $55, $55, $52, $41, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $4D, $45, $47, $55, $54, $41, $20
    .byte $4F, $4B, $55, $4D, $55, $52, $41, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $43, $48, $41, $52, $41, $43, $54, $45, $52
    .byte $20, $44, $45, $53, $49, $47, $4E, $45, $44, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $42
    .byte $59, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $59, $41, $4D, $41, $4D, $4F
    .byte $54, $4F, $20, $53, $41, $4E, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $4F, $4B, $41, $4D, $4F, $54
    .byte $4F, $20, $53, $41, $4E, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $4D, $41, $4E
    .byte $47, $41, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $43, $48, $41, $52, $41, $43, $54, $45
    .byte $52, $20, $53, $48, $41, $50, $45, $44, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $42
    .byte $59, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $59, $41, $4D, $41, $4D, $4F
    .byte $54, $4F, $20, $53, $41, $4E, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $4F, $4B, $41, $4D, $4F, $54
    .byte $4F, $20, $53, $41, $4E, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $4D, $41, $4E
    .byte $47, $41, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $49, $43, $48, $49, $52, $4F, $55, $20
    .byte $53, $41, $4B, $55, $52, $41, $44, $41, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $54, $4F, $53, $48, $49, $41, $4B, $49
    .byte $20, $54, $41, $4B, $49, $4D, $4F, $54, $4F, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $53, $41, $54, $4F, $53, $48, $49
    .byte $20, $4D, $49, $4B, $41, $4D, $49, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $4B, $41, $5A, $55, $48, $49, $4B
    .byte $4F, $20, $4E, $4F, $4E, $41, $4B, $41, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $4D, $55, $53
    .byte $49, $43, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $42
    .byte $59, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $41, $54, $53, $55, $53, $48, $49
    .byte $20, $43, $48, $49, $4B, $55, $4D, $41, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $53, $4F, $55, $4E, $44, $20
    .byte $45, $46, $46, $45, $43, $54, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $42
    .byte $59, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $49, $54, $41
    .byte $53, $41, $4E, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $48, $41, $52, $44
    .byte $57, $41, $52, $45, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $42
    .byte $59, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $53, $45, $54, $53, $55, $4F
    .byte $20, $4F, $4B, $41, $44, $41, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $4E, $41, $4F, $54, $4F
    .byte $20, $46, $55, $4A, $49, $49, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $59, $41, $53, $55, $53, $48, $49
    .byte $20, $4D, $49, $54, $41, $4D, $55, $52, $41, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $52, $4F, $4D, $20, $50, $52
    .byte $4F, $47, $52, $41, $4D, $45, $44, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $42
    .byte $59, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $4B, $4F, $48, $49, $43, $48, $49
    .byte $20, $4B, $49, $4D, $55, $52, $41, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $4F, $52, $49, $47, $49, $4E, $41
    .byte $4C, $20, $53, $54, $4F, $52, $59, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $42
    .byte $59, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $46, $55, $4A, $49, $4B, $4F
    .byte $20, $46, $55, $4A, $49, $4F, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $53, $50, $45, $43, $49, $41, $4C, $20, $54
    .byte $48, $41, $4E, $4B, $53, $20, $54, $4F, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $4A, $4F, $48, $4D, $55, $20, $4B, $4F
    .byte $42, $41, $59, $41, $53, $48, $49, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $54, $41, $44, $41, $48, $49, $52, $4F
    .byte $20, $4E, $41, $4B, $41, $4E, $4F, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $4B, $41, $57, $41, $44, $41, $20, $4D
    .byte $45, $49, $4A, $49, $4E, $20, $4A, $52, $2E, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $59, $41, $4E, $4F
    .byte $20, $53, $41, $4E, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $4E, $41, $4B
    .byte $41, $4A, $49, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $4B, $4F, $55, $5A, $4F, $55
    .byte $20, $26, $20, $55, $52, $41, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $53, $48, $49, $47
    .byte $45, $53, $41, $4E, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $41, $4B, $49, $4D, $4F
    .byte $54, $4F, $20, $53, $41, $4E, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $4B, $55, $52, $4F, $44
    .byte $41, $20, $53, $41, $4E, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $54, $4F, $53, $48, $49
    .byte $44, $41, $20, $53, $41, $4E, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $4B, $4F, $53
    .byte $41, $4B, $41, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $4A, $55, $4E, $20, $26
    .byte $20, $4D, $41, $44, $4F, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $59, $41, $53
    .byte $55, $44, $41, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $44, $4F, $52, $41
    .byte $45, $4D, $4F, $4E, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $43, $4F, $50, $59, $52, $49, $47, $48, $54, $20, $31, $39, $38
    .byte $36, $20, $48, $55, $44, $53, $4F, $4E, $20, $53, $4F, $46, $54, $2E, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $40, $20, $46, $55, $4A, $49, $4B, $4F, $2E, $53, $48, $4F, $55, $47
    .byte $41, $4B, $55, $4B, $41, $4E, $2E, $54, $56, $20, $41, $53, $41, $48, $49, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $48, $20, $20, $20, $20, $20, $20, $48, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $48, $20, $20, $20, $20, $20, $20, $48, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $48, $48, $48, $48, $48, $48, $48, $48, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $48, $20, $20, $20, $20, $20, $20, $48, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $48, $20, $20, $20, $20, $20, $20, $48, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $55, $20, $20, $20, $20, $20, $20, $55, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $55, $20, $20, $20, $20, $20, $20, $55, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $55, $20, $20, $20, $20, $20, $20, $55, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $55, $20, $20, $20, $20, $20, $20, $55, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $55, $55, $55, $55, $55, $55, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $44, $44, $44, $44, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $44, $20, $20, $20, $44, $44, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $44, $20, $20, $20, $20, $20, $44, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $44, $20, $20, $20, $20, $20, $44, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $44, $20, $20, $20, $44, $44, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $44, $44, $44, $44, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $53, $53, $53, $53, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $53, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $53, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $53, $53, $53, $53, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $53, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $53, $20, $20, $20, $20, $53, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $53, $53, $53, $53, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $53, $53, $53, $53, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $53, $20, $20, $20, $20, $53, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $53, $20, $20, $20, $20, $53, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $53, $20, $20, $20, $20, $53, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $53, $20, $20, $20, $20, $53, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $53, $53, $53, $53, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $4E, $20, $20, $20, $20, $4E, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $4E, $4E, $20, $20, $20, $4E, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $4E, $20, $4E, $20, $20, $4E, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $4E, $20, $20, $4E, $20, $4E, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $4E, $20, $20, $20, $4E, $4E, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $53, $53, $53, $53, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $53, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $53, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $53, $53, $53, $53, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $53, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $53, $20, $20, $20, $20, $53, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $53, $53, $53, $53, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $53, $53, $53, $53, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $53, $20, $20, $20, $20, $53, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $53, $20, $20, $20, $20, $53, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $53, $20, $20, $20, $20, $53, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $53, $20, $20, $20, $20, $53, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $53, $53, $53, $53, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $46, $46, $46, $46, $46, $46, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $46, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $46, $46, $46, $46, $46, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $46, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $46, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $54, $54, $54, $54, $54, $54, $54, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $54, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $54, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $54, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $54, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $58, $41, $4E, $41, $44, $55, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $43, $4F, $4D, $49, $4E, $47, $20, $53, $4F, $4F, $4E, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $02, $03, $00, $00, $04, $05
    .byte $06, $00, $00, $5C, $5D, $5E, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $12, $13, $00, $00, $14, $15
    .byte $16, $00, $00, $6C, $6D, $6E, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $21, $22, $23, $00, $00, $24, $25
    .byte $26, $00, $00, $7C, $7D, $7E, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
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
Bank3_NmiVector:
    .addr Bank3_Nmi

Bank3_ResetVector:
    .addr Bank3_Reset

Bank3_IrqVector:
    .addr Bank3_Reset
