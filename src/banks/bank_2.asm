; Address-ordered Doraemon PRG bank 2 preservation listing
; Generated deterministically from pinned Ghidra/GhidraNes facts
; Keep byte-identical through make verify

.segment "PRG2"

Bank2_Func_8000:
    JSR Bank2_Func_80F0
    LDA #$00
    JSR Bank2_Func_81B2
    JMP Bank2_Func_8271

Bank2_Func_800B:
    JSR Bank2_Func_80F0
    LDA #$01
    JSR Bank2_Func_81B2
    JMP Bank2_Func_8271

Bank2_Func_8016:
    JSR Bank2_Func_80F0
    LDA #$02
    JSR Bank2_Func_81B2
    JMP Bank2_Func_8271
    .byte $4C, $74, $82

Bank2_Func_8024:
    JSR Bank2_Func_80F0
    LDA #$00
    JSR Bank2_Func_81B2
    JMP Bank2_Func_8277

Bank2_Func_802F:
    JSR Bank2_Func_80F0
    LDA #$01
    JSR Bank2_Func_81B2
    JMP Bank2_Func_8277

Bank2_Func_803A:
    JSR Bank2_Func_80F0
    LDA #$02
    JSR Bank2_Func_81B2
    JMP Bank2_Func_8277
    .byte $4C, $7A, $82

Bank2_Func_8048:
    JSR Bank2_Func_80F0
    LDA #$03
    JSR Bank2_Func_81B2
    JMP Bank2_Func_8271

Bank2_Func_8053:
    JSR Bank2_Func_80F0
    LDA $17
    PHA
    LDA #$03
    JSR Bank2_Func_81B2
    JSR Bank2_Func_8277
    PLA
    JMP Bank2_Func_81B2

Bank2_Func_8065:
    JSR Bank2_Func_80F0
    LDA $17
    PHA
    LDA #$03
    JSR Bank2_Func_81B2
    JSR World3_BuildString
    PLA
    JMP Bank2_Func_81B2

Bank2_Func_8077:
    JSR Bank2_Func_80F0
    LDA #$03
    JSR Bank2_Func_81B2
    JMP Bank2_Label_8280

Bank2_Func_8082:
    JSR Bank2_Func_80F0
    LDA #$03
    JSR Bank2_Func_81B2
    JMP Bank2_Label_8283

Bank2_Func_808D:
    JSR Bank2_Func_80F0
    LDA #$03
    JSR Bank2_Func_81B2
    JMP Bank2_Label_8286

Bank2_Reset:
    LDX #$7F
    TXS
    LDA #$00
    STA a:$2001
    STA a:$2000
    JSR Bank2_WaitForVblank
    JSR Bank2_WaitForVblank
    LDX #$00
    TXA

Bank2_Label_80AC:
    STA a:$0400,X
    STA a:$0500,X
    STA a:$0600,X
    STA a:$0700,X
    INX
    BNE Bank2_Label_80AC
    LDA #$10
    STA $19
    STA a:$2000
    LDA #$06
    STA $1A
    STA a:$2001
    JSR Bank2_Func_80DA
    JMP Bank2_Func_8048

Bank2_WaitForVblank:
    LDA a:$2002
    BPL Bank2_WaitForVblank

Bank2_Label_80D4:
    LDA a:$2002
    BMI Bank2_Label_80D4
    RTS

Bank2_Func_80DA:
    JSR Bank2_WaitForVblank
    LDA #$00
    STA $14
    LDA $19
    STA a:$2000
    LDA $1A
    AND #$E7
    STA $1A
    STA a:$2001
    RTS

Bank2_Func_80F0:
    JSR Bank2_Func_80DA
    LDA $19
    AND #$7F
    STA $19
    STA a:$2000
    RTS

Bank2_Func_80FD:
    JSR Bank2_Func_8131
    JSR Bank2_WaitForVblank
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
    JSR Bank2_WriteMapper
    LDA $1A
    ORA #$18
    STA $1A
    STA a:$2001
    RTS

Bank2_Func_8131:
    LDA #$F0
    LDX #$00

Bank2_Label_8135:
    STA a:$0300,X
    INX
    BNE Bank2_Label_8135
    RTS

Bank2_Nmi:
    PHA
    TXA
    PHA
    TYA
    PHA
    LDA $15
    BNE Bank2_Label_81A2
    INC $15
    LDA $14
    BEQ Bank2_Label_8158
    LDA #$00
    STA a:$2003
    LDA #$03
    STA a:$4014
    JSR Bank2_WriteMapper

Bank2_Label_8158:
    JSR Bank2_Func_8274
    LDA #$01
    STA a:$4016
    LDA #$00
    STA a:$4016
    LDX #$08

Bank2_Label_8167:
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
    BNE Bank2_Label_8167
    LDA $1D
    AND #$CF
    ORA $1F
    ORA $20
    ORA $1E
    STA $21
    LDA a:$4016
    AND #$04
    CMP $23
    BEQ Bank2_Label_8197
    STA $23
    LDA #$14
    STA $24

Bank2_Label_8197:
    LDA $24
    BEQ Bank2_Label_819D
    DEC $24

Bank2_Label_819D:
    JSR Bank2_Func_827A
    DEC $15

Bank2_Label_81A2:
    INC $16
    PLA
    TAY
    PLA
    TAX
    PLA
    RTI

Bank2_Func_81AA:
    ASL A
    ASL A
    AND #$0C
    STA $18
    LDA $17

Bank2_Func_81B2:
    AND #$03
    ORA $18
    STA $17
    JSR Bank2_WaitForVblank

Bank2_WriteMapper:
    LDA $17
    TAX
    LDA a:$8261,X
    STA a:$8261,X
    NOP
    NOP
    NOP
    NOP
    RTS

Bank2_Func_81C9:
    STA $07
    LDA $27
    BNE Bank2_Label_81E5
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
    JSR Bank2_Func_81E6
    PLA
    TAX
    PLA
    TAY

Bank2_Label_81E5:
    RTS

Bank2_Func_81E6:
    CLC
    ADC a:$0298,X
    LDY #$00

Bank2_Label_81EC:
    CMP #$0A
    BCC Bank2_Label_81F6
    SEC
    SBC #$0A
    INY
    BNE Bank2_Label_81EC

Bank2_Label_81F6:
    STA a:$0298,X
    TYA
    BNE Bank2_Label_81FD
    RTS

Bank2_Label_81FD:
    DEX
    BPL Bank2_Func_81E6
    LDA #$09
    LDX #$05

Bank2_Label_8204:
    STA a:$0298,X
    STA a:$0290,X
    DEX
    BPL Bank2_Label_8204
    RTS

Bank2_Func_820E:
    LDA $27
    BNE Bank2_Label_8244
    LDA $25
    CMP #$04
    BEQ Bank2_Label_8233
    ASL A
    ASL A
    TAY
    LDX #$00

Bank2_Label_821D:
    LDA a:$0298,X
    CMP a:$8251,Y
    BCC Bank2_Label_8233
    BNE Bank2_Label_822D
    INX
    INY
    CPX #$04
    BNE Bank2_Label_821D

Bank2_Label_822D:
    INC $2A
    INC $26
    INC $25

Bank2_Label_8233:
    LDX #$00

Bank2_Label_8235:
    LDA a:$0290,X
    CMP a:$0298,X
    BCC Bank2_Label_8245
    BNE Bank2_Label_8244
    INX
    CPX #$06
    BNE Bank2_Label_8235

Bank2_Label_8244:
    RTS

Bank2_Label_8245:
    LDA a:$0298,X
    STA a:$0290,X
    INX
    CPX #$06
    BNE Bank2_Label_8245
    RTS
    .byte $00, $00, $02, $00, $00, $00, $08, $00, $00, $02, $00, $00, $00, $05, $00, $00

Bank2_MapperValueTable:
    .byte $00, $10, $20, $30, $01, $11, $21, $31, $02, $12, $22, $32, $03, $13, $23, $33

Bank2_Func_8271:
    JMP Bank2_World3Main

Bank2_Func_8274:
    JMP Bank2_Func_AFED

Bank2_Func_8277:
    JMP Bank2_World3AlternateEntry

Bank2_Func_827A:
    JMP Bank2_Func_AFE6

World3_BuildString:
    .byte $44, $4F, $52

Bank2_Label_8280:
    .byte $41, $45, $4D

Bank2_Label_8283:
    .byte $4F, $4E, $20

Bank2_Label_8286:
    .byte $57, $4F, $52, $4C, $44, $33, $20, $57, $52, $49, $54, $54, $45, $4E, $20, $42
    .byte $59, $20, $4B, $49, $4B, $55, $20, $56, $45, $52, $31, $2E, $39, $20, $38, $36
    .byte $2F, $31, $30, $2F, $33, $31, $20

Bank2_World3AlternateEntry:
    LDX #$7F
    TXS
    JSR Bank2_Func_B1FE
    JSR Bank2_Func_8689
    JSR Bank2_Func_8B7B
    LDA #$00
    STA $37
    STA $38
    LDA #$03
    STA $2A

Bank2_Label_82C3:
    LDA #$01
    STA $DC
    LDX #$00
    LDY #$02
    STX $DD
    STY $DE
    LDA $2A
    AND #$03
    TAX
    LDA a:$82EA,X
    STA $DF
    LDA a:$82EE,X
    STA $8C
    LDA a:$82F2,X
    STA $8D
    LDA #$02
    STA $2C
    JMP Bank2_Label_8328
    .byte $28, $1F, $0B, $09, $40, $08, $80, $C0, $40, $70, $A0, $A0

Bank2_World3Main:
    LDA $3B
    BPL Bank2_Label_8314
    LDX #$7F
    TXS
    JSR Bank2_Func_B1FE
    JSR Bank2_Func_8689
    JSR Bank2_Func_8B7B
    LDA #$00
    STA $DC
    LDA #$00
    STA $DF
    JSR Bank2_Func_A2D4
    JMP Bank2_Label_8328

Bank2_Label_8314:
    LDX #$7F
    TXS
    JSR Bank2_Func_B1FE
    JSR Bank2_Func_8689
    JSR Bank2_Func_8B7B
    LDA #$00
    STA $DC
    LDA #$00
    STA $DF

Bank2_Label_8328:
    LDA #$80
    STA $4B
    LDA #$80
    STA $4C
    LDA #$00
    STA $4F
    LDA #$00
    STA $D0
    LDA #$00
    STA $E0
    LDA $1F
    CMP #$FA
    BNE Bank2_Label_834C
    LDA $1D
    CMP #$C5
    BNE Bank2_Label_834C
    LDA #$01
    STA $E0

Bank2_Label_834C:
    LDX #$7F
    TXS
    LDA $DC
    BNE Bank2_Label_836B
    JSR Bank2_Func_80DA
    LDA #$02
    STA $28
    JSR Bank2_Func_8053
    LDA #$00
    STA $19
    JSR Bank2_Func_80FD
    LDA #$5A
    STA $68
    JSR Bank2_Func_B1BB

Bank2_Label_836B:
    JSR Bank2_Func_80DA
    JSR Bank2_Func_A1F4
    JSR Bank2_Func_A213
    LDA $DC
    BNE Bank2_Label_837B
    JSR Bank2_Func_850B

Bank2_Label_837B:
    LDA $DF
    AND #$07
    STA $89
    LDA $DF
    LSR A
    LSR A
    LSR A
    STA $8A
    JSR Bank2_Func_8BF3
    JSR Bank2_Func_A733

Bank2_World3FrameLoop:
    LDX #$7F
    TXS
    LDA #$00
    STA $68
    LDA $DF
    CMP #$3F
    BNE Bank2_Label_839E
    JSR Bank2_Func_B406

Bank2_Label_839E:
    LDA $4F
    BNE Bank2_Label_83A5
    JSR Bank2_Func_AF30

Bank2_Label_83A5:
    JSR Bank2_Func_8DC4
    JSR Bank2_Func_879B
    LDA $4F
    BNE Bank2_Label_83B5
    JSR Bank2_Func_A21D
    JSR Bank2_Func_A160

Bank2_Label_83B5:
    JSR Bank2_Func_9202
    JSR Bank2_Func_A601
    LDA $4F
    BNE Bank2_Label_83C2
    JSR Bank2_Func_A1C7

Bank2_Label_83C2:
    JSR Bank2_Func_9D19
    JSR Bank2_Func_820E
    LDA $DF
    CMP #$3F
    BEQ Bank2_Label_83D1
    JSR Bank2_Func_B406

Bank2_Label_83D1:
    JSR Bank2_Func_B460
    JSR Bank2_Func_9192
    JSR Bank2_Func_85FD
    JSR Bank2_Func_85C8
    JSR Bank2_Func_8487
    JSR Bank2_Func_859A
    JSR Bank2_Func_8581
    LDA $26
    BEQ Bank2_Label_83F3
    LDA #$00
    STA $26
    LDA #$10
    JSR Bank2_Func_A5EB

Bank2_Label_83F3:
    JSR Bank2_Func_8427
    LDA #$01
    STA $14
    LDA #$01
    STA $68
    JSR Bank2_Func_B1BB
    LDA $DC
    BEQ Bank2_Label_8419
    DEC $DD
    BNE Bank2_Label_840D
    DEC $DE
    BEQ Bank2_Label_8416

Bank2_Label_840D:
    LDA $21
    AND #$30
    BEQ Bank2_Label_8419
    JMP Bank2_Func_8048

Bank2_Label_8416:
    JMP Bank2_Func_A26D

Bank2_Label_8419:
    LDA $4F
    BEQ Bank2_Label_8424
    DEC $4F
    BNE Bank2_Label_8424
    JMP Bank2_Func_AE12

Bank2_Label_8424:
    JMP Bank2_World3FrameLoop

Bank2_Func_8427:
    LDA $E0
    BNE Bank2_Label_844E
    LDA $DF
    BNE Bank2_Label_8486
    LDA $8C
    CMP #$25
    BNE Bank2_Label_8486
    LDA $8D
    CMP #$BB
    BNE Bank2_Label_8486
    LDA $24
    BNE Bank2_Label_8443
    LDA #$00
    STA $CF

Bank2_Label_8443:
    INC $CF
    LDA $CF
    CMP #$3C
    BNE Bank2_Label_8486
    JMP Bank2_Label_FC00

Bank2_Label_844E:
    LDA $1D
    AND #$02
    BEQ Bank2_Label_8457
    JSR Bank2_Func_A619

Bank2_Label_8457:
    LDA $1D
    AND #$01
    BEQ Bank2_Label_8460
    JSR Bank2_Func_A63A

Bank2_Label_8460:
    LDA $1D
    AND #$08
    BEQ Bank2_Label_8469
    JSR Bank2_Func_A65D

Bank2_Label_8469:
    LDA $1D
    AND #$04
    BEQ Bank2_Label_8472
    JSR Bank2_Func_A688

Bank2_Label_8472:
    LDA $1D
    CMP #$C0
    BNE Bank2_Label_8486
    JSR Bank2_Func_AF6F

Bank2_Label_847B:
    LDA $1D
    BNE Bank2_Label_847B

Bank2_Label_847F:
    LDA $1D
    BEQ Bank2_Label_847F
    JMP Bank2_Func_8048

Bank2_Label_8486:
    RTS

Bank2_Func_8487:
    LDA $CE
    BEQ Bank2_Label_849E
    LDX #$78
    LDY #$80
    JSR Bank2_Func_A71A
    LDA #$00
    STA $7A
    LDA #$B8
    STA $79
    JSR Bank2_Func_B4B6
    RTS

Bank2_Label_849E:
    LDA $D0
    BNE Bank2_Label_8502
    LDA $DF
    CMP #$16
    BNE Bank2_Label_8502
    LDA $24
    BNE Bank2_Label_84B0
    LDA #$00
    STA $CF

Bank2_Label_84B0:
    INC $CF
    LDA $CF
    CMP #$3C
    BNE Bank2_Label_8502
    LDA #$0A
    JSR Bank2_Func_A5EB
    JSR Bank2_Func_86C4
    LDA #$01
    STA $CE
    STA $D0
    LDA #$00
    STA $9A
    LDX #$00
    LDY #$00

Bank2_Label_84CE:
    LDA a:$06BD,X
    CMP #$18
    BCC Bank2_Label_84F0
    CMP #$1C
    BCS Bank2_Label_84F0
    LDA #$16
    STA a:$06B0,X
    LDA #$00
    STA a:$06E4,X
    LDA a:$8503,Y
    STA a:$06CA,X
    LDA a:$8507,Y
    STA a:$06D7,X
    INY

Bank2_Label_84F0:
    INX
    CPX #$0D
    BNE Bank2_Label_84CE
    LDX #$00

Bank2_Label_84F7:
    JSR Bank2_Func_8B68
    INX
    CPX #$08
    BNE Bank2_Label_84F7
    JSR Bank2_Func_8CAD

Bank2_Label_8502:
    RTS
    .byte $58, $58, $98, $98, $60, $A0, $60, $A0

Bank2_Func_850B:
    LDA $DF
    BEQ Bank2_Label_8526
    JSR Bank2_Func_8541
    CMP #$27
    BEQ Bank2_Label_852F
    CMP #$28
    BEQ Bank2_Label_852F
    CMP #$34
    BEQ Bank2_Label_852F
    CMP #$3C
    BEQ Bank2_Label_8538
    JSR Bank2_Func_855A
    RTS

Bank2_Label_8526:
    LDA #$80
    STA $8C
    LDA #$80
    STA $8D
    RTS

Bank2_Label_852F:
    LDA #$30
    STA $8C
    LDA #$40
    STA $8D
    RTS

Bank2_Label_8538:
    LDA #$30
    STA $8C
    LDA #$B0
    STA $8D
    RTS

Bank2_Func_8541:
    LDY #$00

Bank2_Label_8543:
    LDA a:$06BD,Y
    CMP #$19
    BEQ Bank2_Label_8554
    INY
    CPY #$0D
    BNE Bank2_Label_8543
    LDA #$07
    JMP Bank2_Func_AF51

Bank2_Label_8554:
    LDA a:$06B0,Y
    STA $DF
    RTS

Bank2_Func_855A:
    JSR Bank2_Func_928D
    STA $46
    JSR Bank2_Func_9299
    STA $47
    JSR Bank2_Func_9EC3
    BCC Bank2_Func_855A
    JSR Bank2_Func_9EFB
    BCC Bank2_Func_855A
    JSR Bank2_Func_9F37
    BCC Bank2_Func_855A
    JSR Bank2_Func_9F71
    BCC Bank2_Func_855A
    LDA $46
    STA $8C
    LDA $47
    STA $8D
    RTS

Bank2_Func_8581:
    LDA $A6
    BEQ Bank2_Label_8599
    DEC $A6
    BNE Bank2_Label_8599
    LDA $DF
    CMP #$3F
    BEQ Bank2_Label_8599
    LDA $A5
    STA a:$02AA
    LDA #$00
    STA a:$02AB

Bank2_Label_8599:
    RTS

Bank2_Func_859A:
    JSR Bank2_Func_A5F7
    AND #$10
    BNE Bank2_Label_85A4
    STA $64

Bank2_Label_85A3:
    RTS

Bank2_Label_85A4:
    LDA $64
    BNE Bank2_Label_85A3
    INC $64
    LDA #$01
    STA a:$02AB
    LDA #$06
    JSR Bank2_Func_A5EB

Bank2_Label_85B4:
    JSR Bank2_Func_A5F7
    AND #$10
    BNE Bank2_Label_85B4

Bank2_Label_85BB:
    JSR Bank2_Func_A5F7
    AND #$10
    BEQ Bank2_Label_85BB
    LDA #$00
    STA a:$02AB
    RTS

Bank2_Func_85C8:
    LDA $53
    BEQ Bank2_Label_85FC
    LDA $DF
    CMP #$12
    BNE Bank2_Label_85FC
    LDA $A8
    BEQ Bank2_Label_85EC
    LDA $AC
    CMP #$06
    BNE Bank2_Label_85FC
    LDA $B0
    BNE Bank2_Label_85FC
    LDY #$00

Bank2_Label_85E2:
    LDA a:$0600,Y
    BNE Bank2_Label_85FC
    INY
    CPY #$08
    BNE Bank2_Label_85E2

Bank2_Label_85EC:
    LDA #$0A
    JSR Bank2_Func_A5EB
    LDA #$01
    STA a:$02AB
    JSR Bank2_Func_86C4
    JSR Bank2_Func_A28D

Bank2_Label_85FC:
    RTS

Bank2_Func_85FD:
    LDA $53
    BNE Bank2_Label_864C
    LDA $4D
    CMP #$14
    BCC Bank2_Label_864C
    LDA #$00
    STA $4D
    LDA #$01
    STA $53
    LDA #$0A
    JSR Bank2_Func_A5EB
    JSR Bank2_Func_86C4
    JSR Bank2_Func_866C
    JSR Bank2_Func_8CF6
    JSR Bank2_Func_8CFD
    LDA $DF
    STA $54
    LDA #$12
    STA $DF
    JSR Bank2_Func_A213
    JSR Bank2_Func_A733
    LDY #$00

Bank2_Label_8630:
    LDA a:$008C,Y
    STA a:$0725,Y
    INY
    CPY #$12
    BNE Bank2_Label_8630
    LDA #$80
    STA $8C
    LDA #$A8
    STA $8D
    LDA #$14
    STA $A8
    LDA #$03
    STA a:$02AA

Bank2_Label_864C:
    RTS
    .byte $A5, $DF, $C9, $2D, $90, $14, $C9, $30, $90, $14, $C9, $35, $90, $0C, $C9, $38
    .byte $90, $0C, $C9, $3D, $90, $04, $C9, $40, $90, $04, $A9, $14, $85, $55, $60

Bank2_Func_866C:
    LDY #$00

Bank2_Label_866E:
    LDA #$00
    STA a:$0678,Y
    INY
    CPY #$08
    BNE Bank2_Label_866E
    LDY #$00

Bank2_Label_867A:
    LDA #$00
    STA a:$06E4,Y
    INY
    CPY #$0D
    BNE Bank2_Label_867A
    LDA #$00
    STA $9A
    RTS

Bank2_Func_8689:
    JSR Bank2_Func_80DA
    LDA #$90
    STA $19
    LDA #$02
    JSR Bank2_Func_81AA
    JSR Bank2_Func_B276
    LDX #$AE
    LDY #$BC
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
    RTS

Bank2_Func_86BB:
    LDA $73
    EOR #$40
    STA $73
    STA $74
    RTS

Bank2_Func_86C4:
    STX $44
    STY $45
    LDA #$0C
    STA $46
    LDA a:$0480
    STA $47
    LDA a:$0487
    STA $48

Bank2_Label_86D6:
    LDA $47
    AND #$0F
    TAX
    LDA a:$8723,X
    TAX
    JSR Bank2_Func_8700
    LDA #$04
    STA $68
    JSR Bank2_Func_B1BB
    LDA $47
    LDX $48
    JSR Bank2_Func_8700
    LDA #$04
    STA $68
    JSR Bank2_Func_B1BB
    DEC $46
    BNE Bank2_Label_86D6
    LDX $44
    LDY $45
    RTS

Bank2_Func_8700:
    STA a:$0480
    STA a:$0484
    STA a:$0488
    STA a:$048C
    STA a:$0490
    STA a:$0494
    STA a:$0498
    STA a:$049C
    STX a:$0487
    LDX #$80
    LDY #$04
    JSR Bank2_Func_B2A3
    RTS
    .byte $30, $25, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $26, $30, $30, $27

Bank2_Func_8733:
    LDY #$00

Bank2_Label_8735:
    LDA a:$0600,Y
    CMP #$01
    BEQ Bank2_Label_8743
    CMP #$04
    BEQ Bank2_Label_8743
    JMP Bank2_Label_8756

Bank2_Label_8743:
    LDA #$01
    STA a:$0600,Y
    LDA a:$0638,Y
    CMP #$10
    BCS Bank2_Label_8756
    CMP #$07
    BEQ Bank2_Label_8756
    JSR Bank2_Func_8972

Bank2_Label_8756:
    INY
    CPY #$08
    BNE Bank2_Label_8735
    RTS

Bank2_Func_875C:
    STX $44
    STY $45
    LDA #$07
    STA $47
    LDA #$0D
    STA $48

Bank2_Label_8768:
    LDX #$0C
    LDY $47
    JSR Bank2_Func_B0BA
    LDA #$00
    STA $72
    LDX #$87
    LDY #$87
    LDA #$12
    JSR Bank2_Func_B33A
    INC $47
    DEC $48
    BNE Bank2_Label_8768
    LDX $44
    LDY $45
    RTS
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00

Bank2_Func_879B:
    LDA $DF
    CMP #$3C
    BEQ Bank2_Label_87A2
    RTS

Bank2_Label_87A2:
    LDA $A1
    BNE Bank2_Label_8816
    LDY #$00
    LDA #$03
    STA $3E

Bank2_Label_87AC:
    LDA a:$0600,Y
    CMP #$01
    BNE Bank2_Label_87C0
    LDA a:$0638,Y
    CMP #$1C
    BCC Bank2_Label_87C0
    CMP #$1F
    BCS Bank2_Label_87C0
    DEC $3E

Bank2_Label_87C0:
    INY
    CPY #$08
    BNE Bank2_Label_87AC
    LDA $3E
    BNE Bank2_Label_8816
    LDA #$04
    JSR Bank2_Func_A5EB
    JSR Bank2_Func_86C4
    JSR Bank2_Func_8817
    LDA #$01
    STA $A1
    LDY #$00

Bank2_Label_87DA:
    LDA a:$0600,Y
    CMP #$01
    BNE Bank2_Label_87F1
    LDA a:$0638,Y
    CMP #$1C
    BCC Bank2_Label_87F1
    CMP #$1F
    BCS Bank2_Label_87F1
    LDA #$00
    STA a:$0600,Y

Bank2_Label_87F1:
    INY
    CPY #$08
    BNE Bank2_Label_87DA
    LDY #$00

Bank2_Label_87F8:
    LDA a:$06BD,Y
    CMP #$1C
    BCC Bank2_Label_880D
    CMP #$1F
    BCS Bank2_Label_880D
    LDA #$23
    STA a:$06B0,Y
    LDA #$00
    STA a:$06E4,Y

Bank2_Label_880D:
    INY
    CPY #$0D
    BNE Bank2_Label_87F8
    LDA #$00
    STA $9A

Bank2_Label_8816:
    RTS

Bank2_Func_8817:
    LDA $DF
    CMP #$3C
    BNE Bank2_Label_8847
    STX $44
    STY $45
    LDA #$14
    STA $47
    LDA #$08
    STA $48

Bank2_Label_8829:
    LDX #$14
    LDY $47
    JSR Bank2_Func_B0BA
    LDA #$00
    STA $72
    LDX #$0F
    LDY #$98
    LDA #$04
    JSR Bank2_Func_B33A
    INC $47
    DEC $48
    BNE Bank2_Label_8829
    LDX $44
    LDY $45

Bank2_Label_8847:
    RTS

Bank2_Func_8848:
    STX $5C
    LDA #$00
    STA $05
    LDA #$02
    STA $04

Bank2_Label_8852:
    LDY $05
    LDA a:$06F9,Y
    CMP #$01
    BNE Bank2_Label_8868
    LDA a:$06FB,Y
    STA $3C
    LDA a:$06FD,Y
    STA $3D
    JSR Bank2_Func_886F

Bank2_Label_8868:
    INC $05
    DEC $04
    BNE Bank2_Label_8852

Bank2_Label_886E:
    RTS

Bank2_Func_886F:
    LDA a:$0600,X
    CMP #$01
    BNE Bank2_Label_886E
    LDA a:$0608,X
    SEC
    SBC $3C
    JSR Bank2_Func_B149
    CMP #$0D
    BCS Bank2_Label_886E
    LDA a:$0610,X
    SEC
    SBC $3D
    JSR Bank2_Func_B149
    CMP #$0D
    BCS Bank2_Label_886E
    LDA a:$0638,X
    CMP #$10
    BCS Bank2_Label_886E
    CMP #$05
    BEQ Bank2_Label_886E
    CMP #$06
    BEQ Bank2_Label_886E
    CMP #$07
    BEQ Bank2_Label_886E
    CMP #$02
    BNE Bank2_Label_88AD
    LDA $DF
    CMP #$3F
    BEQ Bank2_Label_886E

Bank2_Label_88AD:
    LDA #$02
    STA a:$06F9,Y
    LDA #$00
    STA a:$0703,Y
    LDA #$A0
    STA a:$0701,Y
    LDA a:$0638,X
    CMP #$04
    BNE Bank2_Label_88C6
    JSR Bank2_Func_9114

Bank2_Label_88C6:
    LDA a:$0638,X
    CMP #$0A
    BEQ Bank2_Label_88D1
    CMP #$0B
    BNE Bank2_Label_88D6

Bank2_Label_88D1:
    LDA #$03
    JSR Bank2_Func_A5EB

Bank2_Label_88D6:
    LDA a:$0698,X
    BEQ Bank2_Label_886E
    LDA a:$0638,X
    CMP #$0C
    BCC Bank2_Label_88E6
    CMP #$10
    BCC Bank2_Label_88EE

Bank2_Label_88E6:
    LDA a:$0608,X
    EOR #$04
    STA a:$0608,X

Bank2_Label_88EE:
    DEC a:$0698,X
    BNE Bank2_Label_896C
    LDA a:$0638,X
    CMP #$08
    BNE Bank2_Label_8939
    LDA #$01
    STA a:$02AB
    LDA #$04
    JSR Bank2_Func_A5EB
    LDA #$28
    STA $A6
    JSR Bank2_Func_86C4
    JSR Bank2_Func_8733
    JSR Bank2_Func_875C
    LDA $DF
    CMP #$27
    BEQ Bank2_Label_8924
    CMP #$28
    BEQ Bank2_Label_892B
    CMP #$34
    BEQ Bank2_Label_8932
    LDA #$00
    JMP Bank2_Func_AF51

Bank2_Label_8924:
    LDA #$01
    STA $58
    JMP Bank2_Label_895C

Bank2_Label_892B:
    LDA #$01
    STA $59
    JMP Bank2_Label_895C

Bank2_Label_8932:
    LDA #$01
    STA $5A
    JMP Bank2_Label_895C

Bank2_Label_8939:
    LDA a:$0638,X
    CMP #$0C
    BCC Bank2_Label_895C
    CMP #$10
    BCS Bank2_Label_895C
    LDA #$01
    STA a:$02AB
    LDA #$04
    JSR Bank2_Func_A5EB
    LDA #$28
    STA $A6
    JSR Bank2_Func_86C4
    JSR Bank2_Func_8733
    LDA #$46
    STA $4F

Bank2_Label_895C:
    LDX $5C
    JSR Bank2_Func_897C
    LDA a:$0638,X
    TAY
    LDA a:$8F35,Y
    JSR Bank2_Func_898C
    RTS

Bank2_Label_896C:
    LDA #$03
    JSR Bank2_Func_A5DF
    RTS

Bank2_Func_8972:
    TXA
    PHA
    TYA
    TAX
    JSR Bank2_Func_897C
    PLA
    TAX
    RTS

Bank2_Func_897C:
    LDA #$05
    STA a:$0600,X
    LDA #$6C
    STA a:$0628,X
    LDA #$05
    JSR Bank2_Func_A5DF
    RTS

Bank2_Func_898C:
    STX $5B
    LDX $07
    STX $5D
    LDX $DC
    BNE Bank2_Label_8999
    JSR Bank2_Func_81C9

Bank2_Label_8999:
    LDX $5D
    STX $07
    LDX $5B
    RTS

Bank2_Label_89A0:
    RTS

Bank2_Func_89A1:
    LDA a:$0600,X
    CMP #$01
    BNE Bank2_Label_89A0
    LDA a:$0608,X
    SEC
    SBC $8C
    JSR Bank2_Func_B149
    CMP #$0D
    BCS Bank2_Label_89A0
    LDA a:$0610,X
    SEC
    SBC #$04
    SEC
    SBC $8D
    JSR Bank2_Func_B149
    CMP #$11
    BCS Bank2_Label_89A0
    LDA a:$0638,X
    CMP #$06
    BNE Bank2_Label_89EA
    LDA a:$0628,X
    CMP #$20
    BEQ Bank2_Label_89E7
    JSR Bank2_Func_897C
    LDA a:$0638,X
    TAY
    LDA a:$8F35,Y
    JSR Bank2_Func_898C
    LDA $A8
    BEQ Bank2_Label_89E6
    DEC $A8

Bank2_Label_89E6:
    RTS

Bank2_Label_89E7:
    JMP Bank2_Label_8AEC

Bank2_Label_89EA:
    CMP #$07
    BNE Bank2_Label_8A28
    LDA #$0A
    JSR Bank2_Func_A5EB
    JSR Bank2_Func_86C4
    JSR Bank2_Func_897C
    LDA a:$0638,X
    TAY
    LDA a:$8F35,Y
    JSR Bank2_Func_898C
    LDA #$0E
    JSR Bank2_Func_A5EB
    LDA $DF
    CMP #$26
    BEQ Bank2_Label_8A17
    CMP #$3B
    BEQ Bank2_Label_8A1C
    LDA #$01
    JMP Bank2_Func_AF51

Bank2_Label_8A17:
    INC $56
    JMP Bank2_Label_8A1E

Bank2_Label_8A1C:
    INC $57

Bank2_Label_8A1E:
    LDA $2C
    BEQ Bank2_Label_8A27
    DEC $2C
    JSR Bank2_Func_A213

Bank2_Label_8A27:
    RTS

Bank2_Label_8A28:
    CMP #$18
    BCC Bank2_Label_8A60
    JSR Bank2_Func_A5F7
    AND #$40
    BNE Bank2_Label_8A36
    STA $62

Bank2_Label_8A35:
    RTS

Bank2_Label_8A36:
    LDA $62
    BNE Bank2_Label_8A35
    LDA $9A
    BNE Bank2_Label_8A48
    LDA #$01
    STA $9A
    STA a:$0678,X
    JMP Bank2_Label_8A54

Bank2_Label_8A48:
    LDA a:$0678,X
    BEQ Bank2_Label_8A5B
    LDA #$00
    STA $9A
    STA a:$0678,X

Bank2_Label_8A54:
    INC $62
    LDA #$08
    JSR Bank2_Func_A5EB

Bank2_Label_8A5B:
    RTS

Bank2_Label_8A5C:
    RTS

Bank2_Label_8A5D:
    JMP Bank2_Label_8AEC

Bank2_Label_8A60:
    CMP #$10
    BCC Bank2_Label_8A5D
    CMP #$14
    BCS Bank2_Label_8A5C
    CMP #$10
    BNE Bank2_Label_8A87
    JSR Bank2_Func_897C
    LDA a:$0638,X
    TAY
    LDA a:$8F35,Y
    JSR Bank2_Func_898C
    LDA #$01
    STA $CB
    LDA #$00
    STA $CC
    LDA #$01
    STA a:$02AB
    RTS

Bank2_Label_8A87:
    CMP #$11
    BNE Bank2_Label_8AB7
    JSR Bank2_Func_897C
    LDA a:$0638,X
    TAY
    LDA a:$8F35,Y
    JSR Bank2_Func_898C
    LDA #$0E
    JSR Bank2_Func_A5EB
    LDA #$08
    SEC
    SBC $2C
    ASL A
    ASL A
    STA $3E
    LDA #$10
    STA $3F

Bank2_Label_8AAA:
    LDA $2B
    CMP $3E
    BEQ Bank2_Label_8AB6
    INC $2B
    DEC $3F
    BNE Bank2_Label_8AAA

Bank2_Label_8AB6:
    RTS

Bank2_Label_8AB7:
    CMP #$12
    BNE Bank2_Label_8AD7
    JSR Bank2_Func_897C
    LDA a:$0638,X
    TAY
    LDA a:$8F35,Y
    JSR Bank2_Func_898C
    LDA #$13
    JSR Bank2_Func_A5EB
    INC $4D
    JSR Bank2_Func_8733
    LDA #$04
    STA $A4
    RTS

Bank2_Label_8AD7:
    JSR Bank2_Func_897C
    LDA a:$0638,X
    TAY
    LDA a:$8F35,Y
    JSR Bank2_Func_898C
    LDA #$0E
    JSR Bank2_Func_A5EB
    INC $4D
    RTS

Bank2_Label_8AEC:
    LDA $8E
    CMP #$01
    BNE Bank2_Label_8B67
    LDA $CB
    BNE Bank2_Label_8B67
    LDA a:$0638,X
    TAY
    CMP #$05
    BEQ Bank2_Label_8B67
    LDA $2B
    SEC
    SBC a:$8F15,Y
    BCS Bank2_Label_8B08
    LDA #$00

Bank2_Label_8B08:
    STA $2B
    LDA $2B
    BNE Bank2_Label_8B4E
    LDA #$04
    STA $8E
    LDA #$0B
    STA $90
    LDA #$00
    STA $91
    LDA #$00
    STA $93
    LDA #$00
    STA $97
    LDA #$00
    STA $9A
    LDA $8C
    STA $4B
    LDA $8D
    STA $4C
    JSR Bank2_Func_8CF6
    JSR Bank2_Func_8CFD
    LDY #$00

Bank2_Label_8B36:
    LDA #$00
    STA a:$06E4,Y
    INY
    CPY #$0D
    BNE Bank2_Label_8B36
    LDA #$00
    STA a:$06F9
    STA a:$06FA
    LDA #$08
    STA a:$02AA
    RTS

Bank2_Label_8B4E:
    LDA #$03
    STA $8E
    LDA #$00
    STA $9B
    LDA #$0B
    STA $90
    LDA #$00
    STA $91
    LDA #$00
    STA $93
    LDA #$0F
    JSR Bank2_Func_A5EB

Bank2_Label_8B67:
    RTS

Bank2_Func_8B68:
    TXA
    PHA

Bank2_Label_8B6A:
    LDA #$00
    STA a:$0600,X
    TXA
    CLC
    ADC #$08
    TAX
    CPX #$B0
    BCC Bank2_Label_8B6A
    PLA
    TAX
    RTS

Bank2_Func_8B7B:
    LDX #$00

Bank2_Label_8B7D:
    LDA a:$D96B,X
    STA a:$06B0,X
    INX
    CPX #$41
    BNE Bank2_Label_8B7D
    LDX #$00

Bank2_Label_8B8A:
    LDA a:$06BD,X
    STA a:$04A0,X
    LDA #$00
    STA a:$04A4,X
    INX
    CPX #$04
    BNE Bank2_Label_8B8A
    LDX #$00

Bank2_Label_8B9C:
    JSR Bank2_Func_B153
    AND #$03
    TAY
    LDA a:$04A4,Y
    BNE Bank2_Label_8B9C
    LDA #$01
    STA a:$04A4,Y
    LDA a:$04A0,Y
    STA a:$06BD,X
    INX
    CPX #$04
    BNE Bank2_Label_8B9C
    LDX #$00

Bank2_Label_8BB9:
    LDA a:$06C1,X
    STA a:$04A0,X
    LDA #$00
    STA a:$04A8,X
    INX
    CPX #$08
    BNE Bank2_Label_8BB9
    LDX #$00

Bank2_Label_8BCB:
    JSR Bank2_Func_B153
    AND #$07
    TAY
    LDA a:$04A8,Y
    BNE Bank2_Label_8BCB
    LDA #$01
    STA a:$04A8,Y
    LDA a:$04A0,Y
    STA a:$06C1,X
    INX
    CPX #$08
    BNE Bank2_Label_8BCB
    LDX #$00
    LDA #$FF

Bank2_Label_8BEA:
    STA a:$06F1,X
    INX
    CPX #$08
    BNE Bank2_Label_8BEA
    RTS

Bank2_Func_8BF3:
    LDA $38
    BEQ Bank2_Label_8C24
    LDA #$00
    STA $38
    LDY #$00

Bank2_Label_8BFD:
    LDA a:$06BD,Y
    CMP #$19
    BEQ Bank2_Label_8C0E
    INY
    CPY #$0D
    BNE Bank2_Label_8BFD
    LDA #$06
    JMP Bank2_Func_AF51

Bank2_Label_8C0E:
    LDA #$00
    STA a:$06B0,Y
    LDA #$01
    STA a:$06E4,Y
    STA $9A
    LDA $8C
    STA a:$06CA,Y
    LDA $8D
    STA a:$06D7,Y

Bank2_Label_8C24:
    RTS

Bank2_Func_8C25:
    LDX $DF
    LDA a:$8C6D,X
    BEQ Bank2_Label_8C6C
    TAX
    LDY #$00

Bank2_Label_8C2F:
    LDA a:$06B0,Y
    CMP $DF
    BNE Bank2_Label_8C67
    LDA a:$06BD,Y
    CMP #$18
    BCC Bank2_Label_8C67
    LDA a:$06D7,Y
    CMP #$50
    BCC Bank2_Label_8C67
    CMP #$A0
    BCS Bank2_Label_8C67
    CPX #$01
    BEQ Bank2_Label_8C5B
    LDA a:$06CA,Y
    CMP #$14
    BCS Bank2_Label_8C67
    LDA #$18
    STA a:$06CA,Y
    JMP Bank2_Label_8C67

Bank2_Label_8C5B:
    LDA a:$06CA,Y
    CMP #$DC
    BCC Bank2_Label_8C67
    LDA #$D8
    STA a:$06CA,Y

Bank2_Label_8C67:
    INY
    CPY #$0D
    BNE Bank2_Label_8C2F

Bank2_Label_8C6C:
    RTS
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $01, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $02, $00
    .byte $01, $02, $00, $00, $00, $01, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Bank2_Func_8CAD:
    LDX #$00
    LDY #$00

Bank2_Label_8CB1:
    LDA a:$06B0,Y
    CMP $DF
    BNE Bank2_Label_8CF0
    JSR Bank2_Func_8B68
    LDA #$01
    STA a:$0600,X
    LDA a:$06CA,Y
    STA a:$0608,X
    LDA a:$06D7,Y
    STA a:$0610,X
    LDA a:$06BD,Y
    STA a:$0638,X
    STY $42
    TAY
    LDA a:$8ED5,Y
    STA a:$0628,X
    LDY $42
    LDA a:$06E4,Y
    STA a:$0678,X
    BEQ Bank2_Label_8CEF
    LDA $8C
    STA a:$0608,X
    LDA $8D
    STA a:$0610,X

Bank2_Label_8CEF:
    INX

Bank2_Label_8CF0:
    INY
    CPY #$0D
    BNE Bank2_Label_8CB1
    RTS

Bank2_Func_8CF6:
    LDA #$00
    STA $3E
    JMP Bank2_Label_8D01

Bank2_Func_8CFD:
    LDA #$01
    STA $3E

Bank2_Label_8D01:
    LDX #$00

Bank2_Label_8D03:
    LDA a:$0600,X
    CMP #$01
    BEQ Bank2_Label_8D11
    CMP #$04
    BEQ Bank2_Label_8D11
    JMP Bank2_Label_8D4C

Bank2_Label_8D11:
    LDA a:$0638,X
    CMP #$18
    BCC Bank2_Label_8D4C
    LDY #$00

Bank2_Label_8D1A:
    CMP a:$06BD,Y
    BEQ Bank2_Label_8D29
    INY
    CPY #$0D
    BNE Bank2_Label_8D1A
    LDA #$02
    JMP Bank2_Func_AF51

Bank2_Label_8D29:
    LDA a:$0678,X
    CMP $3E
    BNE Bank2_Label_8D4C
    JSR Bank2_Func_8D52
    BCS Bank2_Label_8D46
    LDA $DF
    STA a:$06B0,Y
    LDA a:$0608,X
    STA a:$06CA,Y
    LDA a:$0610,X
    STA a:$06D7,Y

Bank2_Label_8D46:
    LDA a:$0678,X
    STA a:$06E4,Y

Bank2_Label_8D4C:
    INX
    CPX #$08
    BNE Bank2_Label_8D03
    RTS

Bank2_Func_8D52:
    STX $3F
    LDA $9A
    BEQ Bank2_Label_8DA4
    LDX #$00

Bank2_Label_8D5A:
    LDA a:$0600,X
    CMP #$01
    BNE Bank2_Label_8D9F
    LDA a:$0638,X
    CMP #$1B
    BNE Bank2_Label_8D9F
    LDA a:$0678,X
    BEQ Bank2_Label_8D9F
    LDX #$00
    STX $40

Bank2_Label_8D71:
    LDA a:$06B0,X
    CMP $8B
    BNE Bank2_Label_8D81
    LDA a:$06BD,X
    CMP #$18
    BCC Bank2_Label_8D81
    INC $40

Bank2_Label_8D81:
    INX
    CPX #$0D
    BNE Bank2_Label_8D71
    LDA $40
    CMP #$02
    BCS Bank2_Label_8DA4
    LDA $8B
    STA a:$06B0,Y
    LDA $8C
    STA a:$06CA,Y
    LDA $8D
    STA a:$06D7,Y
    LDX $3F
    SEC
    RTS

Bank2_Label_8D9F:
    INX
    CPX #$08
    BNE Bank2_Label_8D5A

Bank2_Label_8DA4:
    LDX $3F
    CLC
    RTS

Bank2_Func_8DA8:
    LDX #$00
    TXA

Bank2_Label_8DAB:
    STA a:$06F9,X
    INX
    CPX #$0C
    BNE Bank2_Label_8DAB
    RTS

Bank2_Func_8DB4:
    LDA #$00
    STA $AB
    LDX #$00
    TXA

Bank2_Label_8DBB:
    STA a:$0600,X
    INX
    CPX #$B0
    BNE Bank2_Label_8DBB

Bank2_Label_8DC3:
    RTS

Bank2_Func_8DC4:
    LDA $8E
    CMP #$04
    BEQ Bank2_Label_8DC3
    LDA $CB
    BNE Bank2_Label_8DC3
    LDA $AB
    BNE Bank2_Label_8E26
    LDA #$01
    STA $AB
    LDX $DF
    LDA a:$D66B,X
    STA $AC
    LDA a:$D6AB,X
    STA $AD
    LDA a:$D6EB,X
    STA $AE
    LDA a:$D72B,X
    STA $AF
    LDA a:$D76B,X
    STA $B0
    LDA a:$D7AB,X
    STA $B1
    LDA a:$D7EB,X
    STA $B2
    LDA a:$D82B,X
    STA $B3
    LDA a:$D86B,X
    STA $B4
    STA $C0
    LDA a:$D8AB,X
    STA $B5
    STA $C1
    LDA a:$D8EB,X
    STA $B6
    STA $C2
    LDA a:$D92B,X
    STA $B7
    STA $C3
    LDA #$00
    STA $B8
    STA $B9
    STA $BA
    STA $BB

Bank2_Label_8E26:
    LDA #$00
    STA $00
    LDA #$04
    STA $01

Bank2_Label_8E2E:
    LDX $00
    LDA $B4,X
    BEQ Bank2_Label_8E3F
    LDA $BC,X
    CLC
    ADC #$01
    AND #$03
    STA $BC,X
    BNE Bank2_Label_8E60

Bank2_Label_8E3F:
    LDA $AC,X
    STA $C4
    LDA $B0,X
    STA $C5
    LDA $B4,X
    STA $C6
    LDA $B8,X
    STA $C7
    JSR Bank2_Func_8E67
    LDX $00
    LDA $C5
    STA $B0,X
    LDA $C6
    STA $B4,X
    LDA $C7
    STA $B8,X

Bank2_Label_8E60:
    INC $00
    DEC $01
    BNE Bank2_Label_8E2E
    RTS

Bank2_Func_8E67:
    LDA $C7
    BNE Bank2_Label_8EB4
    LDA $C5
    BEQ Bank2_Label_8EB4
    LDA $C6
    BEQ Bank2_Label_8E7D
    DEC $C6
    BNE Bank2_Label_8EB4
    LDX $00
    LDA $C0,X
    STA $C6

Bank2_Label_8E7D:
    JSR Bank2_Func_9104
    BCC Bank2_Label_8EB4
    JSR Bank2_Func_8B68
    LDA #$1E
    STA a:$0668,X
    LDA $C4
    STA a:$0638,X
    TAY
    LDA a:$8EB5,Y
    STA a:$0698,X
    LDA a:$8ED5,Y
    STA a:$0628,X
    LDA #$FF
    STA a:$0608,X
    STA a:$0610,X
    LDA #$02
    STA a:$0600,X
    JSR Bank2_Func_8F55
    DEC $C5
    BNE Bank2_Label_8EB4
    LDA #$01
    STA $C7

Bank2_Label_8EB4:
    RTS
    .byte $01, $02, $01, $02, $02, $00, $00, $00, $08, $00, $00, $00, $10, $10, $10, $10
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $10, $14, $18, $1C, $20, $24, $40, $B0, $30, $34, $28, $2C, $80, $84, $88, $8C
    .byte $64, $40, $70, $74, $50, $54, $58, $5C, $44, $60, $4C, $48, $90, $94, $98, $9C
    .byte $02, $03, $01, $03, $20, $00, $01, $00, $03, $03, $00, $00, $02, $02, $02, $02
    .byte $00, $01, $00, $01, $01, $01, $01, $01, $00, $00, $01, $00, $01, $01, $01, $01
    .byte $02, $02, $04, $02, $02, $00, $04, $00, $02, $02, $04, $04, $04, $04, $04, $04
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $55, $41, $51, $42, $41, $51, $45, $33, $35, $51, $35, $51, $25, $25, $25, $25
    .byte $45, $41, $32, $31, $31, $31, $31, $31, $51, $51, $51, $51, $51, $51, $51, $51

Bank2_Func_8F55:
    LDA #$00
    STA a:$0670,X
    LDA $C4
    ASL A
    TAY
    LDA a:$8F6C,Y
    STA $40
    LDA a:$8F6D,Y
    STA $41
    JSR Bank2_Func_931F
    RTS
    .byte $8C, $8F, $A3, $8F, $BF, $8F, $DB, $8F, $28, $90, $2E, $90, $2F, $90, $44, $90
    .byte $71, $90, $AA, $90, $AB, $90, $AE, $90, $AF, $90, $B2, $90, $B2, $90, $B2, $90
    .byte $A5, $DF, $C9, $10, $90, $10, $C9, $28, $B0, $07, $20, $53, $B1, $29, $01, $D0
    .byte $05, $A9, $A4, $9D, $28, $06, $60, $A5, $DF, $C9, $18, $90, $15, $C9, $30, $B0
    .byte $07, $20, $53, $B1, $29, $01, $D0, $0A, $A9, $A8, $9D, $28, $06, $A9, $01, $9D
    .byte $30, $06, $60, $A9, $80, $9D, $08, $06, $A9, $98, $9D, $10, $06, $A9, $01, $9D
    .byte $00, $06, $20, $53, $B1, $29, $40, $F0, $05, $A9, $09, $20, $EB, $A5, $60, $A4
    .byte $DF, $B9, $E8, $8F, $F0, $05, $A9, $B4, $9D, $28, $06, $60, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $00, $00, $00, $00
    .byte $00, $01, $01, $01, $00, $00, $00, $00, $00, $01, $01, $01, $A9, $01, $9D, $70
    .byte $06, $60, $60, $20, $53, $B1, $C9, $64, $B0, $0D, $A9, $20, $9D, $28, $06, $20
    .byte $53, $B1, $29, $02, $9D, $A0, $06, $60, $A5, $DF, $C9, $26, $D0, $07, $A5, $56
    .byte $D0, $1D, $4C, $5B, $90, $A5, $DF, $C9, $3B, $D0, $19, $A5, $57, $D0, $10, $A9
    .byte $B0, $9D, $08, $06, $A9, $A8, $9D, $10, $06, $A9, $01, $9D, $00, $06, $60, $A9
    .byte $00, $9D, $00, $06, $60, $A5, $DF, $C9, $27, $F0, $0D, $C9, $28, $F0, $10, $C9
    .byte $34, $F0, $13, $A9, $03, $4C, $51, $AF, $A5, $58, $F0, $11, $4C, $A4, $90, $A5
    .byte $59, $F0, $0A, $4C, $A4, $90, $A5, $5A, $F0, $03, $4C, $A4, $90, $20, $8C, $AC
    .byte $90, $06, $A9, $03, $8D, $AA, $02, $60, $A9, $00, $9D, $00, $06, $60, $60, $20
    .byte $15, $AC, $60, $20, $B3, $90, $60, $A0, $00, $4C, $BD, $90, $20, $04, $91, $90
    .byte $36, $20, $68, $8B, $B9, $F4, $90, $9D, $00, $06, $B9, $F8, $90, $9D, $08, $06
    .byte $B9, $FC, $90, $9D, $10, $06, $B9, $00, $91, $9D, $38, $06, $84, $42, $A8, $B9
    .byte $D5, $8E, $9D, $28, $06, $A4, $42, $A9, $1E, $9D, $68, $06, $AD, $C1, $8E, $9D
    .byte $98, $06, $C8, $C0, $04, $D0, $C5, $60, $03, $03, $03, $03, $28, $D8, $28, $D8
    .byte $30, $30, $C0, $C0, $0C, $0D, $0E, $0F

Bank2_Func_9104:
    LDX #$00

Bank2_Label_9106:
    LDA a:$0600,X
    BEQ Bank2_Label_9112
    INX
    CPX #$08
    BNE Bank2_Label_9106
    CLC
    RTS

Bank2_Label_9112:
    SEC
    RTS

Bank2_Func_9114:
    STX $3C
    JSR Bank2_Func_9104
    BCS Bank2_Label_911F

Bank2_Label_911B:
    LDX $3C
    CLC
    RTS

Bank2_Label_911F:
    JSR Bank2_Func_8B68
    TXA
    TAY
    LDX $3C
    LDA a:$0670,X
    BEQ Bank2_Label_911B
    LSR A
    STA a:$0670,X
    LDA #$01
    STA a:$0600,Y
    JSR Bank2_Func_B153
    AND #$08
    SEC
    SBC #$04
    CLC
    ADC a:$0608,X
    STA a:$0608,Y
    JSR Bank2_Func_B153
    AND #$08
    SEC
    SBC #$04
    CLC
    ADC a:$0610,X
    STA a:$0610,Y
    LDA a:$0628,X
    STA a:$0628,Y
    LDA a:$0630,X
    STA a:$0630,Y
    LDA a:$0638,X
    STA a:$0638,Y
    LDA a:$0640,X
    STA a:$0640,Y
    LDA a:$0648,X
    STA a:$0648,Y
    LDA a:$0650,X
    STA a:$0650,Y
    LDA a:$0658,X
    STA a:$0658,Y
    LDA a:$0660,X
    STA a:$0660,Y
    LDA a:$0670,X
    STA a:$0670,Y
    LDA a:$8EB9
    STA a:$0698,Y
    LDX $3C
    SEC
    RTS

Bank2_Func_9192:
    LDA $CB
    BEQ Bank2_Label_91B2
    INC $CC
    LDA $CC
    AND #$07
    BNE Bank2_Label_91A3
    LDA #$07
    JSR Bank2_Func_A5DF

Bank2_Label_91A3:
    LDA $CC
    CMP #$F0
    BNE Bank2_Label_91B2
    LDA #$00
    STA $CB
    LDA #$00
    STA a:$02AB

Bank2_Label_91B2:
    RTS

Bank2_Label_91B3:
    INC a:$0618,X
    LDA a:$0618,X
    AND #$01
    BNE Bank2_Label_91FE
    INC a:$0628,X
    LDA a:$0628,X
    CMP #$70
    BNE Bank2_Label_91FE
    LDA #$00
    STA a:$0600,X
    LDA a:$0638,X
    CMP #$05
    BCS Bank2_Label_91FE
    LDA $A4
    BEQ Bank2_Label_91DB
    DEC $A4
    BNE Bank2_Label_91E7

Bank2_Label_91DB:
    INC $4E
    LDA $4E
    CMP #$04
    BCC Bank2_Label_91FE
    LDA #$00
    STA $4E

Bank2_Label_91E7:
    LDA #$01
    STA a:$0600,X
    JSR Bank2_Func_B153
    AND #$03
    CLC
    ADC #$10
    STA a:$0638,X
    TAY
    LDA a:$8ED5,Y
    STA a:$0628,X

Bank2_Label_91FE:
    JMP Bank2_Label_9283

Bank2_Label_9201:
    RTS

Bank2_Func_9202:
    LDA $8E
    CMP #$04
    BEQ Bank2_Label_9201
    LDA #$00
    STA $07
    LDA #$08
    STA $06

Bank2_Label_9210:
    LDX $07
    LDA a:$0600,X
    BEQ Bank2_Label_9283
    CMP #$05
    BEQ Bank2_Label_91B3
    CMP #$04
    BEQ Bank2_Label_924D
    CMP #$01
    BEQ Bank2_Label_924D
    LDA a:$0668,X
    BNE Bank2_Label_9230
    LDA #$01
    STA a:$0600,X
    JMP Bank2_Label_924D

Bank2_Label_9230:
    DEC a:$0668,X
    CMP #$1E
    BNE Bank2_Label_9283
    LDA a:$0600,X
    CMP #$03
    BEQ Bank2_Label_9283
    JSR Bank2_Func_92A5
    LDX $07
    LDA $46
    STA a:$0608,X
    LDA $47
    STA a:$0610,X

Bank2_Label_924D:
    LDA $CB
    BEQ Bank2_Label_925B
    LDA a:$0638,X
    CMP #$10
    BCS Bank2_Label_925B
    JMP Bank2_Label_9279

Bank2_Label_925B:
    LDA a:$0638,X
    CMP #$10
    BCS Bank2_Label_9265
    JSR Bank2_Func_9A3B

Bank2_Label_9265:
    LDX $07
    LDA a:$0638,X
    ASL A
    TAY
    LDA a:$92DF,Y
    STA $40
    LDA a:$92E0,Y
    STA $41
    JSR Bank2_Func_931F

Bank2_Label_9279:
    LDX $07
    JSR Bank2_Func_89A1
    LDX $07
    JSR Bank2_Func_8848

Bank2_Label_9283:
    INC $07
    DEC $06
    BEQ Bank2_Label_928C
    JMP Bank2_Label_9210

Bank2_Label_928C:
    RTS

Bank2_Func_928D:
    JSR Bank2_Func_B153
    CMP #$20
    BCC Bank2_Func_928D
    CMP #$D0
    BCS Bank2_Func_928D
    RTS

Bank2_Func_9299:
    JSR Bank2_Func_B153
    CMP #$30
    BCC Bank2_Func_9299
    CMP #$B0
    BCS Bank2_Func_9299
    RTS

Bank2_Func_92A5:
    JSR Bank2_Func_928D
    STA $46
    JSR Bank2_Func_9299
    STA $47
    JSR Bank2_Func_9EC3
    BCC Bank2_Func_92A5
    JSR Bank2_Func_9EFB
    BCC Bank2_Func_92A5
    JSR Bank2_Func_9F37
    BCC Bank2_Func_92A5
    JSR Bank2_Func_9F71
    BCC Bank2_Func_92A5
    LDA $46
    SEC
    SBC $8C
    JSR Bank2_Func_B149
    CMP #$18
    BCS Bank2_Label_92DE
    LDA $47
    SEC
    SBC $8D
    JSR Bank2_Func_B149
    CMP #$18
    BCS Bank2_Label_92DE
    JMP Bank2_Func_92A5

Bank2_Label_92DE:
    RTS
    .byte $22, $93, $22, $93, $22, $93, $22, $93, $2D, $93, $AC, $93, $90, $95, $90, $95
    .byte $91, $95, $94, $95, $95, $95, $A4, $95, $A5, $95, $43, $96, $5B, $96, $8C, $96
    .byte $D6, $96, $D6, $96, $D6, $96, $D6, $96, $D6, $96, $D6, $96, $D6, $96, $D7, $96
    .byte $D8, $96, $59, $97, $13, $98, $E3, $98, $99, $99, $99, $99, $99, $99, $99, $99

Bank2_Func_931F:
    JMP ($0040)
    .byte $BD, $00, $06, $C9, $04, $D0, $03, $20, $05, $9A, $60, $BD, $00, $06, $C9, $04
    .byte $D0, $04, $20, $05, $9A, $60, $A4, $DF, $B9, $6C, $93, $F0, $2C, $FE, $18, $06
    .byte $BD, $18, $06, $29, $03, $D0, $22, $86, $3E, $BD, $08, $06, $85, $3C, $BD, $10
    .byte $06, $85, $3D, $A6, $8C, $A4, $8D, $20, $3B, $AB, $20, $47, $AB, $A6, $3E, $A5
    .byte $3C, $9D, $08, $06, $A5, $3D, $9D, $10, $06, $60, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $00, $00, $00, $00, $00, $01
    .byte $01, $01, $00, $00, $00, $00, $00, $01, $01, $00, $BD, $08, $06, $C9, $F0, $B0
    .byte $3C, $BD, $10, $06, $C9, $D8, $B0, $35, $A0, $00, $B9, $00, $06, $C9, $04, $F0
    .byte $08, $C8, $C0, $08, $D0, $F4, $4C, $EC, $94, $A5, $A3, $29, $03, $A8, $BD, $08
    .byte $06, $18, $79, $E7, $93, $9D, $08, $06, $BD, $10, $06, $18, $79, $EB, $93, $9D
    .byte $10, $06, $4C, $EC, $94, $02, $FE, $02, $FE, $02, $02, $FE, $FE, $A9, $00, $9D
    .byte $00, $06, $A0, $00, $B9, $00, $06, $C9, $04, $F0, $06, $C8, $C0, $08, $D0, $F4
    .byte $60, $A9, $00, $99, $00, $06, $A9, $00, $99, $78, $06, $B9, $38, $06, $C9, $18
    .byte $B0, $01, $60, $A5, $DF, $85, $40, $A5, $8C, $38, $E9, $78, $20, $49, $B1, $85
    .byte $41, $A5, $8D, $38, $E9, $78, $20, $49, $B1, $C5, $41, $B0, $1A, $A5, $8C, $C9
    .byte $78, $B0, $09, $A5, $89, $F0, $3C, $C6, $40, $4C, $6A, $94, $A5, $89, $C9, $07
    .byte $F0, $31, $E6, $40, $4C, $6A, $94, $A5, $8D, $C9, $78, $B0, $0E, $A5, $8A, $F0
    .byte $22, $A5, $40, $38, $E9, $08, $85, $40, $4C, $6A, $94, $A5, $8A, $C9, $07, $F0
    .byte $12, $A5, $40, $18, $69, $08, $85, $40, $86, $3E, $A6, $40, $BD, $50, $95, $F0
    .byte $45, $A6, $3E, $86, $3E, $A5, $DF, $38, $E9, $01, $29, $3F, $AA, $BD, $50, $95
    .byte $F0, $32, $A5, $DF, $18, $69, $01, $29, $3F, $AA, $BD, $50, $95, $F0, $25, $A5
    .byte $DF, $38, $E9, $08, $29, $3F, $AA, $BD, $50, $95, $F0, $18, $A5, $DF, $18, $69
    .byte $08, $29, $3F, $AA, $BD, $50, $95, $F0, $0B, $20, $53, $B1, $29, $3F, $AA, $BD
    .byte $50, $95, $D0, $F5, $86, $40, $A2, $00, $BD, $B0, $06, $C5, $DF, $D0, $08, $BD
    .byte $BD, $06, $D9, $38, $06, $F0, $0A, $E8, $E0, $0D, $D0, $EC, $A9, $04, $4C, $51
    .byte $AF, $A5, $40, $9D, $B0, $06, $20, $8D, $92, $9D, $CA, $06, $20, $99, $92, $9D
    .byte $D7, $06, $A9, $00, $9D, $E4, $06, $A6, $3E, $60, $A0, $00, $B9, $00, $06, $C9
    .byte $04, $F0, $5A, $C8, $C0, $08, $D0, $F4, $A0, $00, $B9, $00, $06, $C9, $01, $D0
    .byte $47, $B9, $38, $06, $C9, $05, $90, $08, $C9, $18, $90, $3C, $C9, $1B, $F0, $38
    .byte $BD, $08, $06, $38, $F9, $08, $06, $20, $49, $B1, $C9, $0D, $B0, $2A, $BD, $10
    .byte $06, $38, $F9, $10, $06, $20, $49, $B1, $C9, $0D, $B0, $1C, $BD, $90, $06, $85
    .byte $A3, $A9, $12, $20, $EB, $A5, $A9, $04, $99, $00, $06, $B9, $78, $06, $F0, $0D
    .byte $A9, $00, $99, $78, $06, $85, $9A, $60, $C8, $C0, $08, $D0, $AD, $60, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01
    .byte $01, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $01, $01, $00, $01
    .byte $01, $01, $00, $00, $01, $01, $01, $01, $01, $00, $00, $01, $01, $01, $00, $00
    .byte $00, $00, $01, $01, $01, $01, $00, $00, $00, $00, $00, $01, $01, $01, $60, $20
    .byte $2A, $AA, $60, $20, $53, $B1, $29, $1F, $D0, $05, $A9, $11, $20, $EB, $A5, $20
    .byte $21, $AD, $60, $20, $53, $B1, $29, $1F, $D0, $05, $A9, $11, $20, $EB, $A5, $BD
    .byte $90, $06, $F0, $03, $20, $F3, $95, $86, $3E, $BD, $90, $06, $F0, $32, $FE, $18
    .byte $06, $BD, $18, $06, $29, $01, $D0, $28, $BD, $08, $06, $85, $3C, $BD, $10, $06
    .byte $85, $3D, $A5, $8C, $18, $69, $08, $AA, $A5, $8D, $38, $E9, $0C, $A8, $20, $3B
    .byte $AB, $20, $47, $AB, $A6, $3E, $A5, $3C, $9D, $08, $06, $A5, $3D, $9D, $10, $06
    .byte $60, $86, $3E, $A2, $00, $A0, $00, $BD, $00, $06, $D0, $01, $C8, $E8, $E0, $08
    .byte $D0, $F5, $C0, $02, $90, $38, $20, $04, $91, $90, $33, $20, $68, $8B, $A9, $1E
    .byte $9D, $68, $06, $A9, $02, $9D, $38, $06, $A8, $B9, $B5, $8E, $9D, $98, $06, $B9
    .byte $D5, $8E, $9D, $28, $06, $A4, $3E, $B9, $08, $06, $18, $69, $08, $9D, $08, $06
    .byte $B9, $10, $06, $18, $69, $18, $9D, $10, $06, $A9, $01, $9D, $00, $06, $A6, $3E
    .byte $60, $BD, $90, $06, $F0, $12, $20, $C0, $96, $B9, $08, $06, $18, $69, $10, $9D
    .byte $08, $06, $B9, $10, $06, $9D, $10, $06, $60, $BD, $90, $06, $F0, $2B, $20, $C0
    .byte $96, $B9, $08, $06, $9D, $08, $06, $B9, $10, $06, $18, $69, $18, $9D, $10, $06
    .byte $FE, $18, $06, $BD, $18, $06, $4A, $4A, $4A, $29, $01, $9D, $A8, $06, $BD, $18
    .byte $06, $4A, $4A, $4A, $29, $02, $9D, $A0, $06, $60, $BD, $90, $06, $F0, $2E, $20
    .byte $C0, $96, $B9, $08, $06, $18, $69, $10, $9D, $08, $06, $B9, $10, $06, $18, $69
    .byte $18, $9D, $10, $06, $FE, $18, $06, $BD, $18, $06, $4A, $4A, $4A, $29, $01, $9D
    .byte $A8, $06, $BD, $18, $06, $4A, $4A, $4A, $29, $02, $9D, $A0, $06, $60, $A0, $00
    .byte $B9, $00, $06, $C9, $01, $D0, $07, $B9, $38, $06, $C9, $0C, $F0, $05, $C8, $C0
    .byte $08, $D0, $ED, $60, $60, $60, $BD, $00, $06, $C9, $04, $D0, $04, $20, $05, $9A
    .byte $60, $20, $63, $99, $BD, $78, $06, $F0, $15, $A0, $00, $B9, $00, $06, $C9, $01
    .byte $D0, $07, $B9, $38, $06, $C9, $0A, $F0, $06, $C8, $C0, $08, $D0, $ED, $60, $BD
    .byte $08, $06, $38, $F9, $08, $06, $20, $49, $B1, $C9, $0D, $B0, $F1, $BD, $10, $06
    .byte $38, $F9, $10, $06, $20, $49, $B1, $C9, $0D, $B0, $E3, $20, $72, $89, $C8, $C0
    .byte $08, $F0, $07, $B9, $38, $06, $C9, $0B, $F0, $F1, $A0, $00, $B9, $F1, $06, $C5
    .byte $DF, $D0, $05, $A9, $FF, $99, $F1, $06, $C8, $C0, $08, $D0, $EF, $A9, $01, $8D
    .byte $AB, $02, $A9, $04, $20, $EB, $A5, $A9, $28, $85, $A6, $20, $C4, $86, $A0, $0A
    .byte $B9, $35, $8F, $20, $8C, $89, $60, $BD, $00, $06, $C9, $04, $D0, $04, $20, $05
    .byte $9A, $60, $20, $63, $99, $BD, $78, $06, $F0, $42, $A5, $9F, $D0, $3E, $86, $44
    .byte $BD, $10, $06, $18, $69, $07, $A8, $BD, $08, $06, $18, $69, $07, $AA, $20, $C4
    .byte $A0, $C9, $26, $90, $25, $C9, $2A, $B0, $21, $A5, $DF, $C9, $3C, $F0, $1B, $C9
    .byte $27, $F0, $17, $C9, $28, $F0, $13, $C9, $34, $F0, $0F, $A9, $13, $20, $EB, $A5
    .byte $20, $C4, $86, $20, $AF, $97, $A9, $01, $85, $9F, $A6, $44, $60

Bank2_Func_97AF:
    LDA #$00
    STA $A0
    LDX #$00
    LDY #$60
    STX $46
    STY $47
    JSR Bank2_Func_A0C4
    CMP #$26
    BNE Bank2_Label_97CA
    JSR Bank2_Func_97E2
    LDA #$01
    STA $A0
    RTS

Bank2_Label_97CA:
    LDX #$E0
    LDY #$60
    STX $46
    STY $47
    JSR Bank2_Func_A0C4
    CMP #$26
    BNE Bank2_Label_97E1
    JSR Bank2_Func_97E2
    LDA #$01
    STA $A0
    RTS

Bank2_Label_97E1:
    RTS

Bank2_Func_97E2:
    LDA $46
    LSR A
    LSR A
    LSR A
    STA $46
    LDA $47
    LSR A
    LSR A
    LSR A
    STA $47
    LDA #$08
    STA $48

Bank2_Label_97F4:
    LDX $46
    LDY $47
    JSR Bank2_Func_B0BA
    LDA #$00
    STA $72
    LDX #$0F
    LDY #$98
    LDA #$04
    JSR Bank2_Func_B33A
    INC $47
    DEC $48
    BNE Bank2_Label_97F4
    RTS
    .byte $00, $00, $00, $00, $BD, $00, $06, $C9, $04, $D0, $04, $20, $05, $9A, $60, $20
    .byte $63, $99, $BD, $78, $06, $F0, $35, $A0, $00, $B9, $00, $06, $C9, $01, $D0, $27
    .byte $B9, $38, $06, $C9, $14, $90, $20, $C9, $18, $B0, $1C, $BD, $08, $06, $38, $F9
    .byte $08, $06, $20, $49, $B1, $C9, $0D, $B0, $0E, $BD, $10, $06, $38, $F9, $10, $06
    .byte $20, $49, $B1, $C9, $0D, $90, $06, $C8, $C0, $08, $D0, $CD, $60, $A9, $0A, $20
    .byte $EB, $A5, $20, $C4, $86, $B9, $38, $06, $C9, $17, $F0, $2A, $86, $3E, $A2, $00
    .byte $DD, $BD, $06, $F0, $0A, $E8, $E0, $0D, $D0, $F6, $A9, $05, $4C, $51, $AF, $18
    .byte $69, $08, $9D, $BD, $06, $99, $38, $06, $AA, $BD, $D5, $8E, $99, $28, $06, $A9
    .byte $00, $85, $4D, $A6, $3E, $60, $A9, $00, $99, $00, $06, $B9, $38, $06, $85, $3E
    .byte $A0, $00, $B9, $B0, $06, $C5, $DF, $D0, $07, $B9, $BD, $06, $C5, $3E, $F0, $04
    .byte $C8, $4C, $A1, $98, $A9, $FF, $99, $B0, $06, $A0, $00, $B9, $F1, $06, $C9, $FF
    .byte $F0, $04, $C8, $4C, $BA, $98, $A5, $DF, $99, $F1, $06, $20, $04, $91, $90, $13
    .byte $BD, $08, $06, $38, $E9, $78, $85, $C9, $BD, $10, $06, $38, $E9, $78, $85, $CA
    .byte $20, $1F, $AC, $60, $BD, $00, $06, $C9, $04, $D0, $04, $20, $05, $9A, $60, $20
    .byte $63, $99, $BD, $78, $06, $F0, $6C, $BD, $10, $06, $C9, $F8, $F0, $65, $A0, $00
    .byte $B9, $00, $06, $C9, $01, $D0, $57, $B9, $38, $06, $C9, $18, $90, $50, $C9, $1B
    .byte $F0, $4C, $C9, $1F, $F0, $48, $BD, $08, $06, $85, $40, $BD, $10, $06, $85, $41
    .byte $B9, $08, $06, $85, $3C, $B9, $10, $06, $85, $3D, $86, $3E, $84, $3F, $A6, $40
    .byte $A4, $41, $A5, $3C, $38, $E5, $40, $20, $49, $B1, $C9, $0F, $90, $03, $20, $3B
    .byte $AB, $A5, $3D, $38, $E5, $41, $20, $49, $B1, $C9, $0F, $90, $03, $20, $47, $AB
    .byte $A6, $3E, $A4, $3F, $A5, $3C, $99, $08, $06, $A5, $3D, $99, $10, $06, $C8, $C0
    .byte $08, $D0, $9D, $60, $BD, $78, $06, $F0, $30, $A5, $95, $0A, $9D, $A0, $06, $A0
    .byte $F4, $A5, $95, $F0, $02, $A0, $0C, $98, $18, $65, $8C, $9D, $08, $06, $C9, $F4
    .byte $90, $05, $A5, $8C, $9D, $08, $06, $FE, $58, $06, $BD, $58, $06, $4A, $29, $02
    .byte $18, $69, $04, $18, $65, $8D, $9D, $10, $06, $60, $BD, $00, $06, $C9, $04, $D0
    .byte $04, $20, $05, $9A, $60, $A0, $00, $BD, $08, $06, $C5, $8C, $B0, $02, $A0, $02
    .byte $98, $9D, $A0, $06, $FE, $18, $06, $BD, $18, $06, $29, $07, $D0, $08, $BD, $A8
    .byte $06, $49, $01, $9D, $A8, $06, $86, $3E, $BD, $78, $06, $F0, $36, $BD, $08, $06
    .byte $85, $3C, $BD, $10, $06, $85, $3D, $A6, $8C, $A4, $8D, $8A, $38, $E5, $3C, $20
    .byte $49, $B1, $C9, $0D, $90, $03, $20, $3B, $AB, $98, $38, $E5, $3D, $20, $49, $B1
    .byte $C9, $0D, $90, $03, $20, $47, $AB, $A6, $3E, $A5, $3C, $9D, $08, $06, $A5, $3D
    .byte $9D, $10, $06, $A6, $3E, $60, $A0, $00, $B9, $00, $06, $C9, $01, $D0, $07, $B9
    .byte $38, $06, $C9, $05, $F0, $06, $C8, $C0, $08, $D0, $ED, $60, $FE, $18, $06, $BD
    .byte $18, $06, $4A, $29, $02, $18, $79, $08, $06, $9D, $08, $06, $A9, $10, $18, $79
    .byte $10, $06, $9D, $10, $06, $60, $A9, $00, $9D, $00, $06

Bank2_Label_9A3A:
    RTS

Bank2_Func_9A3B:
    LDX $07
    LDA a:$0638,X
    ASL A
    TAY
    LDA a:$D9AC,Y
    STA $40
    LDA a:$D9AD,Y
    STA $41
    LDA a:$0660,X
    BEQ Bank2_Label_9A59
    JSR Bank2_Func_AA0F
    STA a:$0660,X
    BCC Bank2_Label_9A3A

Bank2_Label_9A59:
    LDA a:$0640,X
    TAY
    LDA ($40),Y
    AND #$0F
    STA $3E
    LDA ($40),Y
    AND #$F0
    STA $3F
    CMP #$00
    BNE Bank2_Label_9A98
    LDA a:$0650,X
    BNE Bank2_Label_9AA1

Bank2_Label_9A72:
    JSR Bank2_Func_9EF1
    BCC Bank2_Label_9A84
    LDA a:$0608,X
    CLC
    ADC $3E
    STA a:$0608,X
    CMP #$E0
    BCC Bank2_Label_9A94

Bank2_Label_9A84:
    LDA a:$0650,X
    EOR #$01
    STA a:$0650,X
    LDA a:$06A0,X
    EOR #$02
    STA a:$06A0,X

Bank2_Label_9A94:
    INC a:$0640,X
    RTS

Bank2_Label_9A98:
    CMP #$10
    BNE Bank2_Label_9AC7
    LDA a:$0650,X
    BNE Bank2_Label_9A72

Bank2_Label_9AA1:
    JSR Bank2_Func_9EB9
    BCC Bank2_Label_9AB3
    LDA a:$0608,X
    SEC
    SBC $3E
    STA a:$0608,X
    CMP #$10
    BCS Bank2_Label_9AC3

Bank2_Label_9AB3:
    LDA a:$0650,X
    EOR #$01
    STA a:$0650,X
    LDA a:$06A0,X
    EOR #$02
    STA a:$06A0,X

Bank2_Label_9AC3:
    INC a:$0640,X
    RTS

Bank2_Label_9AC7:
    CMP #$20
    BNE Bank2_Label_9AEE
    LDA a:$0658,X
    BNE Bank2_Label_9AF7

Bank2_Label_9AD0:
    JSR Bank2_Func_9F2D
    BCC Bank2_Label_9AE2
    LDA a:$0610,X
    SEC
    SBC $3E
    STA a:$0610,X
    CMP #$20
    BCS Bank2_Label_9AEA

Bank2_Label_9AE2:
    LDA a:$0658,X
    EOR #$01
    STA a:$0658,X

Bank2_Label_9AEA:
    INC a:$0640,X
    RTS

Bank2_Label_9AEE:
    CMP #$30
    BNE Bank2_Label_9B15
    LDA a:$0658,X
    BNE Bank2_Label_9AD0

Bank2_Label_9AF7:
    JSR Bank2_Func_9F67
    BCC Bank2_Label_9B09
    LDA a:$0610,X
    CLC
    ADC $3E
    STA a:$0610,X
    CMP #$C0
    BCC Bank2_Label_9B11

Bank2_Label_9B09:
    LDA a:$0658,X
    EOR #$01
    STA a:$0658,X

Bank2_Label_9B11:
    INC a:$0640,X
    RTS

Bank2_Label_9B15:
    CMP #$40
    BNE Bank2_Label_9B28
    INC a:$0640,X
    LDA a:$0640,X
    TAY
    LDA ($40),Y
    STA a:$0640,X
    JMP Bank2_Label_9A59

Bank2_Label_9B28:
    CMP #$50
    BNE Bank2_Label_9B48
    LDA a:$0648,X
    BNE Bank2_Label_9B3C
    LDA a:$0640,X
    TAY
    INY
    LDA ($40),Y
    STA a:$0648,X
    RTS

Bank2_Label_9B3C:
    DEC a:$0648,X
    BNE Bank2_Label_9B47
    INC a:$0640,X
    INC a:$0640,X

Bank2_Label_9B47:
    RTS

Bank2_Label_9B48:
    CMP #$60
    BNE Bank2_Label_9B57
    LDA $3E
    STA a:$0660,X
    INC a:$0640,X
    JMP Bank2_Label_9A59

Bank2_Label_9B57:
    CMP #$70
    BNE Bank2_Label_9BBF
    LDA $3E
    CMP #$00
    BEQ Bank2_Label_9BA3
    CMP #$01
    BEQ Bank2_Label_9BB1
    CMP #$08
    BEQ Bank2_Label_9B7F
    CMP #$09
    BEQ Bank2_Label_9B8D
    CMP #$0A
    BEQ Bank2_Label_9B98
    LDA #$01
    STA a:$0650,X
    STA a:$0658,X
    INC a:$0640,X
    JMP Bank2_Label_9A59

Bank2_Label_9B7F:
    LDA #$00
    STA a:$0650,X
    STA a:$0658,X
    INC a:$0640,X
    JMP Bank2_Label_9A59

Bank2_Label_9B8D:
    LDA #$01
    STA a:$0650,X
    INC a:$0640,X
    JMP Bank2_Label_9A59

Bank2_Label_9B98:
    LDA #$01
    STA a:$0658,X
    INC a:$0640,X
    JMP Bank2_Label_9A59

Bank2_Label_9BA3:
    JSR Bank2_Func_B153
    AND #$01
    STA a:$0650,X
    INC a:$0640,X
    JMP Bank2_Label_9A59

Bank2_Label_9BB1:
    JSR Bank2_Func_B153
    AND #$01
    STA a:$0658,X
    INC a:$0640,X
    JMP Bank2_Label_9A59

Bank2_Label_9BBF:
    CMP #$80
    BNE Bank2_Label_9BF3
    LDA $3E
    BNE Bank2_Label_9BDF
    INC a:$0640,X
    LDA a:$0640,X
    TAY
    LDA ($40),Y
    STA a:$0680,X
    INC a:$0640,X
    LDA a:$0640,X
    STA a:$0688,X
    JMP Bank2_Label_9A59

Bank2_Label_9BDF:
    INC a:$0640,X
    LDA a:$0680,X
    BEQ Bank2_Label_9BF0
    DEC a:$0680,X
    LDA a:$0688,X
    STA a:$0640,X

Bank2_Label_9BF0:
    JMP Bank2_Label_9A59

Bank2_Label_9BF3:
    CMP #$90
    BNE Bank2_Label_9C39
    INC a:$0640,X
    LDA a:$0640,X
    TAY
    LDA a:$0650,X
    BEQ Bank2_Label_9C0D
    LDA ($40),Y
    EOR #$FF
    CLC
    ADC #$01
    JMP Bank2_Label_9C0F

Bank2_Label_9C0D:
    LDA ($40),Y

Bank2_Label_9C0F:
    CLC
    ADC a:$0608,X
    STA a:$0608,X
    INC a:$0640,X
    LDA a:$0640,X
    TAY
    LDA a:$0658,X
    BEQ Bank2_Label_9C2C
    LDA ($40),Y
    EOR #$FF
    CLC
    ADC #$01
    JMP Bank2_Label_9C2E

Bank2_Label_9C2C:
    LDA ($40),Y

Bank2_Label_9C2E:
    CLC
    ADC a:$0610,X
    STA a:$0610,X
    INC a:$0640,X
    RTS

Bank2_Label_9C39:
    CMP #$A0
    BNE Bank2_Label_9C60
    INC a:$0640,X
    LDA a:$0640,X
    TAY
    LDA ($40),Y
    STA a:$0608,X
    INC a:$0640,X
    LDA a:$0640,X
    TAY
    LDA ($40),Y
    STA a:$0610,X
    INC a:$0640,X
    LDA #$00
    STA a:$0668,X
    JMP Bank2_Label_9A59

Bank2_Label_9C60:
    CMP #$B0
    BNE Bank2_Label_9C6F
    LDA $3E
    STA a:$06A0,X
    INC a:$0640,X
    JMP Bank2_Label_9A59

Bank2_Label_9C6F:
    CMP #$C0
    BNE Bank2_Label_9CDB
    LDA $3E
    CMP #$01
    BEQ Bank2_Label_9CA3
    CMP #$02
    BEQ Bank2_Label_9CBF
    INC a:$0640,X
    LDA a:$0640,X
    TAY
    JSR Bank2_Func_B153
    CMP ($40),Y
    BCS Bank2_Label_9C94
    INC a:$0640,X
    INC a:$0640,X
    JMP Bank2_Label_9A59

Bank2_Label_9C94:
    INC a:$0640,X
    LDA a:$0640,X
    TAY
    LDA ($40),Y
    STA a:$0640,X
    JMP Bank2_Label_9A59

Bank2_Label_9CA3:
    INC a:$0640,X
    LDA a:$0608,X
    CMP $8C
    BCS Bank2_Label_9CB3
    INC a:$0640,X
    JMP Bank2_Label_9A59

Bank2_Label_9CB3:
    LDA a:$0640,X
    TAY
    LDA ($40),Y
    STA a:$0640,X
    JMP Bank2_Label_9A59

Bank2_Label_9CBF:
    INC a:$0640,X
    LDA a:$0610,X
    CMP $8D
    BCS Bank2_Label_9CCF
    INC a:$0640,X
    JMP Bank2_Label_9A59

Bank2_Label_9CCF:
    LDA a:$0640,X
    TAY
    LDA ($40),Y
    STA a:$0640,X
    JMP Bank2_Label_9A59

Bank2_Label_9CDB:
    CMP #$D0
    BNE Bank2_Label_9CF1
    INC a:$0640,X
    LDA a:$0640,X
    TAY
    LDA ($40),Y
    STA a:$0690,X
    INC a:$0640,X
    JMP Bank2_Label_9A59

Bank2_Label_9CF1:
    CMP #$E0
    BNE Bank2_Label_9D03
    LDA a:$06A8,X
    EOR #$01
    STA a:$06A8,X
    INC a:$0640,X
    JMP Bank2_Label_9A59

Bank2_Label_9D03:
    CMP #$F0
    BNE Bank2_Label_9D18
    LDA $3E
    BEQ Bank2_Label_9D17
    LDA a:$0600,X
    CMP #$04
    BEQ Bank2_Label_9D17
    LDA #$00
    STA a:$0600,X

Bank2_Label_9D17:
    RTS

Bank2_Label_9D18:
    RTS

Bank2_Func_9D19:
    LDA $51
    BNE Bank2_Label_9D25
    INC $52
    LDA $52
    AND #$01
    BNE Bank2_Label_9D37

Bank2_Label_9D25:
    LDA #$00
    STA $07
    LDA #$08
    STA $06

Bank2_Label_9D2D:
    JSR Bank2_Func_9D49
    INC $07
    DEC $06
    BNE Bank2_Label_9D2D
    RTS

Bank2_Label_9D37:
    LDA #$07
    STA $07
    LDA #$08
    STA $06

Bank2_Label_9D3F:
    JSR Bank2_Func_9D49
    DEC $07
    DEC $06
    BNE Bank2_Label_9D3F
    RTS

Bank2_Func_9D49:
    LDX $07
    LDA a:$0600,X
    BEQ Bank2_Label_9DCC
    CMP #$05
    BEQ Bank2_Label_9D71
    CMP #$04
    BEQ Bank2_Label_9D71
    CMP #$01
    BNE Bank2_Label_9D67
    LDA $CB
    BEQ Bank2_Label_9D71
    LDA a:$0638,X
    CMP #$10
    BCS Bank2_Label_9D71

Bank2_Label_9D67:
    LDA a:$0630,X
    ORA #$40
    STA $7A
    JMP Bank2_Label_9D76

Bank2_Label_9D71:
    LDA a:$0630,X
    STA $7A

Bank2_Label_9D76:
    LDA a:$0638,X
    TAY
    LDA a:$8EF5,Y
    ORA $7A
    STA $7A
    LDA a:$0600,X
    CMP #$04
    BNE Bank2_Label_9D8E
    LDA $7A
    AND #$DF
    STA $7A

Bank2_Label_9D8E:
    LDA a:$0600,X
    CMP #$05
    BNE Bank2_Label_9DAE
    LDA a:$0628,X
    STA $79
    LDA a:$0610,X
    SEC
    SBC #$08
    TAY
    LDA a:$0608,X
    SEC
    SBC #$08
    TAX
    JSR Bank2_Func_A71A
    JMP Bank2_Label_9DC9

Bank2_Label_9DAE:
    JSR Bank2_Func_9DCD
    LDA a:$0628,X
    CLC
    ADC a:$06A0,X
    CLC
    ADC a:$06A8,X
    STA $79
    LDA a:$0610,X
    TAY
    LDA a:$0608,X
    TAX
    JSR Bank2_Func_A71A

Bank2_Label_9DC9:
    JSR Bank2_Func_B4B6

Bank2_Label_9DCC:
    RTS

Bank2_Func_9DCD:
    RTS
    .byte $BD, $38, $06, $C9, $03, $D0, $0F, $A0, $00, $BD, $08, $06, $C5, $8C, $B0, $02
    .byte $A0, $02, $98, $9D, $A0, $06, $60, $A5, $8D, $85, $00, $A9, $03, $85, $01, $A5
    .byte $00, $18, $69, $04, $85, $00, $A5, $8C, $18, $69, $02, $AA, $A4, $00, $20, $19
    .byte $A0, $90, $38, $A5, $00, $18, $69, $08, $85, $00, $C6, $01, $D0, $E8, $4C, $35
    .byte $A0, $A5, $8D, $85, $00, $A9, $03, $85, $01, $A5, $00, $18, $69, $04, $85, $00
    .byte $A5, $8C, $18, $69, $0E, $AA, $A4, $00, $20, $19, $A0, $90, $0E, $A5, $00, $18
    .byte $69, $08, $85, $00, $C6, $01, $D0, $E8, $4C, $35, $A0, $18, $60, $A5, $8C, $85
    .byte $00, $A9, $02, $85, $01, $A5, $00, $18, $69, $04, $85, $00, $A6, $00, $A5, $8D
    .byte $18, $69, $02, $A8, $20, $19, $A0, $90, $E2, $A5, $00, $18, $69, $08, $85, $00
    .byte $C6, $01, $D0, $E8, $4C, $35, $A0, $A5, $8C, $85, $00, $A9, $02, $85, $01, $A5
    .byte $00, $18, $69, $04, $85, $00, $A6, $00, $A5, $8D, $18, $69, $16, $A8, $20, $19
    .byte $A0, $90, $B8, $A5, $00, $18, $69, $08, $85, $00, $C6, $01, $D0, $E8, $4C, $35
    .byte $A0, $A5, $8C, $85, $00, $A9, $02, $85, $01, $A5, $00, $18, $69, $04, $85, $00
    .byte $A6, $00, $A5, $8D, $18, $69, $0C, $A8, $20, $19, $A0, $90, $8E, $A5, $00, $18
    .byte $69, $08, $85, $00, $C6, $01, $D0, $E8, $4C, $35, $A0

Bank2_Func_9EB9:
    LDA a:$0608,X
    STA $46
    LDA a:$0610,X
    STA $47

Bank2_Func_9EC3:
    STX $44
    LDA $47
    STA $00
    LDA #$02
    STA $01
    LDA $00
    CLC
    ADC #$04
    STA $00

Bank2_Label_9ED4:
    LDA $46
    CLC
    ADC #$02
    TAX
    LDY $00
    JSR Bank2_Func_A009
    BCC Bank2_Label_9F29
    LDA $00
    CLC
    ADC #$08
    STA $00
    DEC $01
    BNE Bank2_Label_9ED4
    LDX $44
    JMP Bank2_Func_A035

Bank2_Func_9EF1:
    LDA a:$0608,X
    STA $46
    LDA a:$0610,X
    STA $47

Bank2_Func_9EFB:
    STX $44
    LDA $47
    STA $00
    LDA #$02
    STA $01
    LDA $00
    CLC
    ADC #$04
    STA $00

Bank2_Label_9F0C:
    LDA $46
    CLC
    ADC #$0E
    TAX
    LDY $00
    JSR Bank2_Func_A009
    BCC Bank2_Label_9F29
    LDA $00
    CLC
    ADC #$08
    STA $00
    DEC $01
    BNE Bank2_Label_9F0C
    LDX $44
    JMP Bank2_Func_A035

Bank2_Label_9F29:
    LDX $44
    CLC
    RTS

Bank2_Func_9F2D:
    LDA a:$0608,X
    STA $46
    LDA a:$0610,X
    STA $47

Bank2_Func_9F37:
    STX $44
    LDA $46
    STA $00
    STA $00
    LDA #$02
    STA $01
    LDA $00
    CLC
    ADC #$04
    STA $00

Bank2_Label_9F4A:
    LDA $47
    CLC
    ADC #$02
    TAY
    LDX $00
    JSR Bank2_Func_A009
    BCC Bank2_Label_9F29
    LDA $00
    CLC
    ADC #$08
    STA $00
    DEC $01
    BNE Bank2_Label_9F4A
    LDX $44
    JMP Bank2_Func_A035

Bank2_Func_9F67:
    LDA a:$0608,X
    STA $46
    LDA a:$0610,X
    STA $47

Bank2_Func_9F71:
    STX $44
    LDA $46
    STA $00
    LDA #$02
    STA $01
    LDA $00
    CLC
    ADC #$04
    STA $00

Bank2_Label_9F82:
    LDA $47
    CLC
    ADC #$16
    TAY
    LDX $00
    JSR Bank2_Func_A009
    BCC Bank2_Label_9F29
    LDA $00
    CLC
    ADC #$08
    STA $00
    DEC $01
    BNE Bank2_Label_9F82
    LDX $44
    JMP Bank2_Func_A035
    .byte $BD, $08, $06, $85, $46, $BD, $10, $06, $85, $47, $86, $44, $A5, $46, $85, $00
    .byte $A9, $02, $85, $01, $A5, $00, $18, $69, $04, $85, $00, $A5, $47, $18, $69, $08
    .byte $A8, $A6, $00, $20, $09, $A0, $90, $10, $A5, $00, $18, $69, $08, $85, $00, $C6
    .byte $01, $D0, $E8, $A6, $44, $4C, $35, $A0

Bank2_Label_9FD7:
    LDX $44
    CLC
    RTS

Bank2_Func_9FDB:
    STX $44
    LDA $46
    STA $00
    LDA #$02
    STA $01
    LDA $00
    CLC
    ADC #$04
    STA $00

Bank2_Label_9FEC:
    LDA $47
    CLC
    ADC #$08
    TAY
    LDX $00
    JSR Bank2_Func_A019
    BCC Bank2_Label_9FD7
    LDA $00
    CLC
    ADC #$08
    STA $00
    DEC $01
    BNE Bank2_Label_9FEC
    LDX $44
    JMP Bank2_Func_A035

Bank2_Func_A009:
    JSR Bank2_Func_A0C4
    STA $9E
    CMP #$26
    BCS Bank2_Label_A031
    CMP #$01
    BEQ Bank2_Label_A031
    JMP Bank2_Func_A035

Bank2_Func_A019:
    JSR Bank2_Func_A0C4
    STA $9E
    CMP #$26
    BCC Bank2_Func_A035
    JSR Bank2_Func_A061
    BCS Bank2_Func_A035
    JSR Bank2_Func_A050
    BCS Bank2_Func_A035
    JSR Bank2_Func_A039
    BCS Bank2_Func_A035

Bank2_Label_A031:
    LDA $9E
    CLC
    RTS

Bank2_Func_A035:
    LDA $9E
    SEC
    RTS

Bank2_Func_A039:
    LDA $A1
    BEQ Bank2_Label_A031
    LDA $DF
    CMP #$3C
    BNE Bank2_Label_A031
    LDA $9E
    CMP #$26
    BCC Bank2_Label_A031
    CMP #$2A
    BCC Bank2_Func_A035
    JMP Bank2_Label_A031

Bank2_Func_A050:
    LDA $9F
    BEQ Bank2_Label_A031
    LDA $9E
    CMP #$26
    BCC Bank2_Label_A031
    CMP #$2A
    BCC Bank2_Func_A035
    JMP Bank2_Label_A031

Bank2_Func_A061:
    LDA $DF
    CMP #$27
    BEQ Bank2_Label_A072
    CMP #$28
    BEQ Bank2_Label_A079
    CMP #$34
    BEQ Bank2_Label_A080

Bank2_Label_A06F:
    JMP Bank2_Label_A031

Bank2_Label_A072:
    LDA $58
    BEQ Bank2_Label_A06F
    JMP Bank2_Label_A087

Bank2_Label_A079:
    LDA $59
    BEQ Bank2_Label_A06F
    JMP Bank2_Label_A087

Bank2_Label_A080:
    LDA $5A
    BEQ Bank2_Label_A06F
    JMP Bank2_Label_A087

Bank2_Label_A087:
    LDA $9E
    CMP #$26
    BCC Bank2_Label_A031
    CMP #$2A
    BCC Bank2_Label_A0C0
    CMP #$30
    BCC Bank2_Label_A031
    CMP #$4A
    BCC Bank2_Label_A0C0
    CMP #$50
    BCC Bank2_Label_A031
    CMP #$5A
    BCC Bank2_Label_A0C0
    CMP #$64
    BCC Bank2_Label_A031
    CMP #$6A
    BCC Bank2_Label_A0C0
    CMP #$6D
    BEQ Bank2_Label_A0C0
    CMP #$74
    BEQ Bank2_Label_A0C0
    CMP #$75
    BEQ Bank2_Label_A0C0
    CMP #$78
    BEQ Bank2_Label_A0C0
    CMP #$79
    BEQ Bank2_Label_A0C0
    JMP Bank2_Label_A031

Bank2_Label_A0C0:
    LDA $9E
    SEC
    RTS

Bank2_Func_A0C4:
    TXA
    LSR A
    LSR A
    LSR A
    STA $40
    TYA
    LSR A
    LSR A
    LSR A
    STA $41
    JSR Bank2_Func_A904
    LDX #$00
    STX $09
    LDA $41
    AND #$FC
    ASL A
    ROL $09
    ASL A
    ROL $09
    ASL A
    ROL $09
    ASL A
    ROL $09
    CLC
    ADC $84
    STA $08
    LDA $09
    ADC $85
    STA $09
    LDA $40
    LSR A
    LSR A
    TAY
    LDA ($08),Y
    LDX #$00
    STX $3D
    ASL A
    ROL $3D
    ASL A
    ROL $3D
    CLC
    ADC #$F2
    STA $3C
    LDA $3D
    ADC #$E2
    STA $3D
    LDA $41
    AND #$02
    STA $08
    LDA $40
    AND #$02
    LSR A
    ORA $08
    TAY
    LDA ($3C),Y
    LDX #$00
    STX $3D
    ASL A
    ROL $3D
    ASL A
    ROL $3D
    CLC
    ADC #$F2
    STA $3C
    LDA $3D
    ADC #$DE
    STA $3D
    LDA $41
    AND #$01
    ASL A
    STA $08
    LDA $40
    AND #$01
    ORA $08
    TAY
    LDA ($3C),Y
    RTS

Bank2_Label_A144:
    INC a:$0703,X
    LDA a:$0703,X
    AND #$03
    BNE Bank2_Label_A1C0
    INC a:$0701,X
    LDA a:$0701,X
    CMP #$A3
    BNE Bank2_Label_A1C0
    LDA #$00
    STA a:$06F9,X
    JMP Bank2_Label_A1C0

Bank2_Func_A160:
    LDA #$00
    STA $07
    LDA #$02
    STA $06

Bank2_Label_A168:
    LDX $07
    LDA a:$06F9,X
    BEQ Bank2_Label_A1C0
    CMP #$02
    BEQ Bank2_Label_A144
    LDA a:$06FB,X
    STA $46
    LDA a:$06FD,X
    STA $47
    JSR Bank2_Func_9FDB
    BCS Bank2_Label_A19B
    LDX $07
    LDA #$02
    STA a:$06F9,X
    LDA #$00
    STA a:$0703,X
    LDA #$A0
    STA a:$0701,X
    LDA #$02
    JSR Bank2_Func_A5DF
    JMP Bank2_Label_A1C0

Bank2_Label_A19B:
    LDA a:$06FF,X
    BNE Bank2_Label_A1AE
    LDA a:$06FB,X
    SEC
    SBC #$03
    STA a:$06FB,X
    BCS Bank2_Label_A1C0
    JMP Bank2_Label_A1BB

Bank2_Label_A1AE:
    LDA a:$06FB,X
    CLC
    ADC #$03
    STA a:$06FB,X
    CMP #$F0
    BCC Bank2_Label_A1C0

Bank2_Label_A1BB:
    LDA #$00
    STA a:$06F9,X

Bank2_Label_A1C0:
    INC $07
    DEC $06
    BNE Bank2_Label_A168
    RTS

Bank2_Func_A1C7:
    LDA #$00
    STA $00
    LDA #$02
    STA $01

Bank2_Label_A1CF:
    LDX $00
    LDA a:$06F9,X
    BEQ Bank2_Label_A1ED
    LDA a:$0701,X
    STA $79
    LDA a:$06FD,X
    TAY
    LDA a:$06FB,X
    TAX
    JSR Bank2_Func_A71A
    LDA #$00
    STA $7A
    JSR Bank2_Func_B4B6

Bank2_Label_A1ED:
    INC $00
    DEC $01
    BNE Bank2_Label_A1CF
    RTS

Bank2_Func_A1F4:
    LDX #$00
    TXA

Bank2_Label_A1F7:
    STA $8E,X
    INX
    CPX #$10
    BNE Bank2_Label_A1F7
    LDA #$01
    STA $8E
    LDA #$0E
    STA $97
    LDA #$07
    STA $94
    LDA #$01
    STA $95
    LDA #$03
    STA $90
    RTS

Bank2_Func_A213:
    LDA #$08
    SEC
    SBC $2C
    ASL A
    ASL A
    STA $2B
    RTS

Bank2_Func_A21D:
    LDA $8E
    ASL A
    TAX
    LDA a:$A22F,X
    STA $40
    LDA a:$A230,X
    STA $41
    JSR Bank2_Func_931F
    RTS
    .byte $39, $A2, $35, $A3, $3C, $A3, $E9, $A2, $3A, $A2, $60, $E6, $93, $A5, $93, $29
    .byte $07, $D0, $06, $A5, $91, $49, $01, $85, $91, $A4, $97, $C0, $0E, $F0, $02, $E6
    .byte $97, $B9, $63, $A5, $30, $06, $18, $65, $8D, $4C, $62, $A2, $18, $65, $8D, $B0
    .byte $02, $A9, $00, $85, $8D, $C9, $F0, $90, $24, $AD, $AA, $02, $D0, $FB

Bank2_Func_A26D:
    LDA #$3C
    STA $68
    JSR Bank2_Func_B1BB
    LDA #$00
    STA $4D
    LDA $2A
    BEQ Bank2_Label_A2BE
    DEC $2A
    LDA $DC
    BEQ Bank2_Func_A285
    JMP Bank2_Label_82C3

Bank2_Func_A285:
    LDA $53
    BNE Bank2_Func_A28D
    JMP Bank2_Label_834C
    .byte $60

Bank2_Func_A28D:
    LDA #$00
    STA $53
    JSR Bank2_Func_8CF6
    JSR Bank2_Func_8CFD
    LDA $54
    STA $DF
    LDA $DF
    CMP #$11
    BNE Bank2_Label_A2A5
    LDA #$01
    STA $9F

Bank2_Label_A2A5:
    JSR Bank2_Func_A733
    LDY #$00

Bank2_Label_A2AA:
    LDA a:$0725,Y
    STA a:$008C,Y
    INY
    CPY #$12
    BNE Bank2_Label_A2AA
    JSR Bank2_Func_A213
    LDA $A5
    STA a:$02AA
    RTS

Bank2_Label_A2BE:
    LDA $DC
    BEQ Bank2_Label_A2C5
    JMP Bank2_Func_8048

Bank2_Label_A2C5:
    JSR Bank2_Func_8065

Bank2_Label_A2C8:
    LDA $21
    AND #$10
    BEQ Bank2_Label_A2C8
    JSR Bank2_Func_A2D4
    JMP Bank2_Func_A285

Bank2_Func_A2D4:
    LDX #$00
    LDA #$00

Bank2_Label_A2D8:
    STA a:$0298,X
    INX
    CPX #$08
    BNE Bank2_Label_A2D8
    LDA #$02
    STA $2A
    LDA #$02
    STA $2C
    RTS
    .byte $20, $B4, $A3, $20, $72, $A5, $A4, $9B, $B9, $2E, $A3, $85, $43, $D0, $10, $A9
    .byte $01, $85, $8E, $A4, $95, $B9, $85, $A4, $85, $90, $A9, $00, $85, $91, $60, $E6
    .byte $9B, $A5, $95, $F0, $10, $20, $9E, $A4, $C6, $43, $D0, $F9, $A9, $00, $85, $91
    .byte $A9, $0B, $85, $90, $60, $20, $B4, $A4, $C6, $43, $D0, $F9, $A9, $01, $85, $91
    .byte $A9, $0B, $85, $90, $60, $04, $03, $03, $02, $02, $02, $00, $20, $B4, $A3, $20
    .byte $72, $A5, $60, $20, $43, $A3, $20, $72, $A5, $60, $A4, $97, $B9, $9C, $A3, $10
    .byte $14, $A5, $8A, $D0, $06, $A5, $8D, $C9, $08, $90, $05, $20, $3B, $9E, $B0, $05
    .byte $A9, $0E, $85, $97, $60, $20, $8F, $9E, $A5, $9E, $C9, $00, $D0, $14, $A9, $01
    .byte $85, $8E, $A4, $95, $B9, $85, $A4, $85, $90, $A9, $00, $85, $91, $A9, $0E, $85
    .byte $97, $60, $20, $87, $A4, $A4, $97, $B9, $9C, $A3, $85, $08, $C9, $04, $F0, $0B
    .byte $A5, $99, $F0, $05, $C6, $99, $4C, $94, $A3, $E6, $97, $A5, $8D, $18, $65, $08
    .byte $85, $8D, $60, $FC, $FD, $FD, $FE, $FE, $FE, $FF, $FF, $FF, $FF, $00, $00, $00
    .byte $00, $01, $01, $01, $01, $02, $02, $02, $03, $03, $04, $A5, $92, $F0, $16, $E6
    .byte $93, $A5, $93, $29, $0F, $D0, $0B, $A9, $00, $85, $92, $A4, $95, $B9, $85, $A4
    .byte $85, $90, $4C, $E0, $A3, $E6, $93, $A5, $93, $25, $94, $D0, $0A, $A5, $91, $D0
    .byte $04, $A9, $03, $85, $91, $C6, $91, $20, $F7, $A5, $29, $08, $D0, $0B, $A9, $07
    .byte $85, $94, $A9, $00, $85, $61, $4C, $2B, $A4, $A5, $61, $F0, $09, $E6, $61, $C9
    .byte $0A, $F0, $EF, $4C, $2B, $A4, $E6, $61, $A5, $92, $D0, $07, $A4, $95, $B9, $85
    .byte $A4, $85, $90, $A9, $03, $85, $94, $A4, $97, $C0, $0E, $D0, $07, $A9, $00, $85
    .byte $99, $4C, $27, $A4, $A5, $99, $C9, $14, $B0, $04, $E6, $99, $E6, $99, $A9, $00
    .byte $85, $97, $20, $CE, $A4, $20, $65, $9E, $B0, $16, $20, $F7, $A5, $29, $03, $D0
    .byte $0F, $A5, $92, $D0, $08, $A9, $08, $85, $90, $A9, $00, $85, $91, $4C, $57, $A4
    .byte $20, $F7, $A5, $29, $02, $D0, $0E, $20, $F7, $A5, $29, $01, $D0, $1A, $A9, $00
    .byte $85, $96, $4C, $81, $A4, $A5, $92, $D0, $04, $A9, $00, $85, $90, $A9, $00, $85
    .byte $95, $A9, $01, $85, $96, $4C, $81, $A4, $A5, $92, $D0, $04, $A9, $03, $85, $90
    .byte $A9, $01, $85, $95, $A9, $01, $85, $96, $20, $87, $A4, $60, $00, $03, $E6, $9C
    .byte $A5, $9C, $29, $01, $D0, $03, $20, $92, $A4, $A5, $96, $F0, $07, $A5, $95, $F0
    .byte $04, $4C, $B4, $A4, $60, $20, $E5, $9D, $B0, $05, $A9, $00, $85, $96, $60, $C6
    .byte $8C, $D0, $07, $A9, $EC, $85, $8C, $20, $19, $A6, $60, $20, $0F, $9E, $B0, $05
    .byte $A9, $00, $85, $96, $60, $E6, $8C, $A5, $8C, $C9, $F0, $D0, $07, $A9, $04, $85
    .byte $8C, $20, $3A, $A6, $60, $A4, $97, $C0, $0E, $F0, $02, $E6, $97, $B9, $63, $A5
    .byte $85, $A7, $F0, $05, $10, $50, $4C, $E3, $A4, $60, $E6, $9D, $A5, $9D, $29, $01
    .byte $D0, $03, $20, $EE, $A4, $20, $3B, $9E, $B0, $05, $A9, $0E, $85, $97, $60, $20
    .byte $8F, $9E, $A5, $9E, $C9, $14, $D0, $0E, $A9, $02, $85, $8E, $A9, $00, $85, $97
    .byte $A9, $0C, $20, $DF, $A5, $60, $A5, $8D, $18, $65, $A7, $85, $8D, $C9, $08, $B0
    .byte $0C, $A5, $8A, $D0, $09, $A9, $00, $85, $8D, $A9, $0E, $85, $97, $60, $A9, $D0
    .byte $85, $8D, $20, $5D, $A6, $60, $20, $65, $9E, $B0, $05, $A9, $00, $85, $96, $60
    .byte $20, $F7, $A5, $29, $04, $D0, $10, $E6, $98, $A5, $98, $C9, $06, $90, $1A, $A9
    .byte $00, $85, $98, $A9, $01, $85, $A7, $A5, $8D, $18, $65, $A7, $85, $8D, $C9, $D4
    .byte $90, $07, $A9, $0C, $85, $8D, $20, $88, $A6, $60, $FE, $FE, $FE, $FE, $FF, $FF
    .byte $FF, $FF, $00, $00, $00, $00, $00, $00, $02, $20, $F7, $A5, $29, $80, $D0, $03
    .byte $85, $63, $60, $A5, $63, $D0, $FB, $E6, $63, $A9, $01, $85, $92, $A5, $95, $18
    .byte $69, $09, $85, $90, $A9, $00, $85, $91, $A9, $00, $85, $93, $A2, $00, $BD, $F9
    .byte $06, $F0, $06, $E8, $E0, $02, $D0, $F6, $60, $A5, $95, $D0, $0B, $A5, $8C, $C9
    .byte $12, $90, $32, $A0, $F8, $4C, $B9, $A5, $A5, $8C, $C9, $EE, $B0, $27, $A0, $08
    .byte $98, $18, $65, $8C, $9D, $FB, $06, $A5, $8D, $18, $69, $08, $9D, $FD, $06, $A5
    .byte $95, $9D, $FF, $06, $0A, $18, $69, $68, $9D, $01, $07, $A9, $01, $9D, $F9, $06
    .byte $A9, $19, $20, $DF, $A5, $60

Bank2_Func_A5DF:
    STX $49
    STY $4A
    JSR Bank2_Func_BE90
    LDX $49
    LDY $4A
    RTS

Bank2_Func_A5EB:
    STX $49
    STY $4A
    JSR Bank2_Func_BEB4
    LDX $49
    LDY $4A
    RTS

Bank2_Func_A5F7:
    LDA $DC
    BNE Bank2_Label_A5FE
    LDA $21
    RTS

Bank2_Label_A5FE:
    LDA #$00
    RTS

Bank2_Func_A601:
    LDX $8C
    LDY $8D
    JSR Bank2_Func_A71A
    LDA $90
    CLC
    ADC $91
    STA $8F
    STA $79
    LDA #$00
    STA $7A
    JSR Bank2_Func_B4B6
    RTS

Bank2_Func_A619:
    LDA $89
    BEQ Bank2_Label_A639
    DEC $89
    LDA $DF
    STA $8B
    DEC $8B
    JSR Bank2_Func_A6E6
    JSR Bank2_Func_A6B5
    JSR Bank2_Func_A6BF
    JSR Bank2_Func_8CF6
    DEC $DF
    JSR Bank2_Func_8CFD
    JSR Bank2_Func_A733

Bank2_Label_A639:
    RTS

Bank2_Func_A63A:
    LDA $89
    CMP #$07
    BEQ Bank2_Label_A65C
    INC $89
    LDA $DF
    STA $8B
    INC $8B
    JSR Bank2_Func_A6E6
    JSR Bank2_Func_A6B5
    JSR Bank2_Func_A6BF
    JSR Bank2_Func_8CF6
    INC $DF
    JSR Bank2_Func_8CFD
    JSR Bank2_Func_A733

Bank2_Label_A65C:
    RTS

Bank2_Func_A65D:
    LDA $8A
    BEQ Bank2_Label_A687
    DEC $8A
    LDA $DF
    STA $8B
    LDA $8B
    SEC
    SBC #$08
    STA $8B
    JSR Bank2_Func_A6E6
    JSR Bank2_Func_A6B5
    JSR Bank2_Func_A6BF
    JSR Bank2_Func_8CF6
    LDA $DF
    SEC
    SBC #$08
    STA $DF
    JSR Bank2_Func_8CFD
    JSR Bank2_Func_A733

Bank2_Label_A687:
    RTS

Bank2_Func_A688:
    LDA $8A
    CMP #$07
    BEQ Bank2_Label_A6B4
    INC $8A
    LDA $DF
    STA $8B
    LDA $8B
    CLC
    ADC #$08
    STA $8B
    JSR Bank2_Func_A6E6
    JSR Bank2_Func_A6B5
    JSR Bank2_Func_A6BF
    JSR Bank2_Func_8CF6
    LDA $DF
    CLC
    ADC #$08
    STA $DF
    JSR Bank2_Func_8CFD
    JSR Bank2_Func_A733

Bank2_Label_A6B4:
    RTS

Bank2_Func_A6B5:
    LDA $8B
    CMP #$3F
    BNE Bank2_Label_A6BE
    JSR Bank2_Func_866C

Bank2_Label_A6BE:
    RTS

Bank2_Func_A6BF:
    LDA $8B
    CMP #$27
    BEQ Bank2_Label_A6CE
    CMP #$28
    BEQ Bank2_Label_A6D6
    CMP #$34
    BEQ Bank2_Label_A6DE

Bank2_Label_A6CD:
    RTS

Bank2_Label_A6CE:
    LDA $58
    BNE Bank2_Label_A6CD
    JSR Bank2_Func_866C
    RTS

Bank2_Label_A6D6:
    LDA $59
    BNE Bank2_Label_A6CD
    JSR Bank2_Func_866C
    RTS

Bank2_Label_A6DE:
    LDA $5A
    BNE Bank2_Label_A6CD
    JSR Bank2_Func_866C
    RTS

Bank2_Func_A6E6:
    LDY #$00
    STY $3E

Bank2_Label_A6EA:
    LDA a:$06B0,Y
    CMP $8B
    BNE Bank2_Label_A6FA
    LDA a:$06BD,Y
    CMP #$18
    BCC Bank2_Label_A6FA
    INC $3E

Bank2_Label_A6FA:
    INY
    CPY #$0D
    BNE Bank2_Label_A6EA
    LDA $3E
    CMP #$03
    BCC Bank2_Label_A719
    LDA $9A
    BEQ Bank2_Label_A719
    LDA #$00
    STA $9A
    LDY #$00

Bank2_Label_A70F:
    LDA #$00
    STA a:$0678,Y
    INY
    CPY #$08
    BNE Bank2_Label_A70F

Bank2_Label_A719:
    RTS

Bank2_Func_A71A:
    LDA #$00
    CPX #$F8
    BCC Bank2_Label_A722
    LDA #$03

Bank2_Label_A722:
    STX $75
    STA $76
    LDA #$00
    CPY #$F8
    BCC Bank2_Label_A72E
    LDA #$03

Bank2_Label_A72E:
    STY $77
    STA $78
    RTS

Bank2_Func_A733:
    JSR Bank2_Func_A863
    JSR Bank2_Func_B276
    LDA #$02
    JSR Bank2_Func_81AA
    LDA #$90
    STA $19
    JSR Bank2_Func_A8EB
    JSR Bank2_Func_A835
    JSR Bank2_Func_8DA8
    JSR Bank2_Func_8DB4
    JSR Bank2_Func_8C25
    JSR Bank2_Func_8CAD
    JSR Bank2_Func_AB53
    JSR Bank2_Func_ABF9
    LDA $A1
    BEQ Bank2_Label_A761
    JSR Bank2_Func_8817

Bank2_Label_A761:
    LDA $51
    BNE Bank2_Label_A78B
    LDA $DF
    CMP #$27
    BEQ Bank2_Label_A776
    CMP #$28
    BEQ Bank2_Label_A77D
    CMP #$34
    BEQ Bank2_Label_A784
    JMP Bank2_Label_A79C

Bank2_Label_A776:
    LDA $58
    BNE Bank2_Label_A78B
    JMP Bank2_Label_A79C

Bank2_Label_A77D:
    LDA $59
    BNE Bank2_Label_A78B
    JMP Bank2_Label_A79C

Bank2_Label_A784:
    LDA $5A
    BNE Bank2_Label_A78B
    JMP Bank2_Label_A79C

Bank2_Label_A78B:
    LDA $DF
    CMP #$27
    BEQ Bank2_Label_A799
    CMP #$28
    BEQ Bank2_Label_A799
    CMP #$34
    BNE Bank2_Label_A79C

Bank2_Label_A799:
    JSR Bank2_Func_875C

Bank2_Label_A79C:
    LDA $9F
    BEQ Bank2_Label_A7AB
    JSR Bank2_Func_97AF
    LDA $A0
    BNE Bank2_Label_A7AB
    LDA #$00
    STA $9F

Bank2_Label_A7AB:
    JSR Bank2_Func_B3FF
    JSR Bank2_Func_B286
    JSR Bank2_Func_A8B0
    LDA #$00
    STA $73
    STA $74
    LDA #$00
    STA $CB
    STA $CC
    LDA #$00
    STA $CE
    STA $CF
    JSR Bank2_Func_A7E5
    LDA a:$02AA
    AND #$7F
    CMP $A5
    BEQ Bank2_Label_A7DF
    CMP #$03
    BNE Bank2_Label_A7DA
    LDA $51
    BNE Bank2_Label_A7DF

Bank2_Label_A7DA:
    LDA $A5
    STA a:$02AA

Bank2_Label_A7DF:
    LDA #$00
    STA a:$02AB
    RTS

Bank2_Func_A7E5:
    LDY $DF
    LDA a:$A7F1,Y
    TAY
    LDA a:$A831,Y
    STA $A5
    RTS
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $01, $01, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $02, $02, $02
    .byte $01, $01, $01, $01, $01, $02, $02, $02, $01, $01, $01, $01, $01, $02, $02, $03
    .byte $01, $02, $05, $06

Bank2_Func_A835:
    LDA #$00
    STA $40
    LDX $DF
    LDA a:$ADD2,X
    LSR A
    ROR $40
    LSR A
    ROR $40
    LSR A
    ROR $40
    STA $41
    LDA $40
    CLC
    ADC #$AE
    STA $40
    LDA $41
    ADC #$BC
    STA $41
    LDY #$00

Bank2_Label_A858:
    LDA ($40),Y
    STA a:$0705,Y
    INY
    CPY #$20
    BNE Bank2_Label_A858
    RTS

Bank2_Func_A863:
    LDX #$80
    LDY #$04
    STX $00
    STY $01
    LDX #$05
    LDY #$07
    STX $02
    STY $03
    LDA #$20
    STA $04
    JSR Bank2_Func_B1F1

Bank2_Label_A87A:
    LDX #$00
    STX $02

Bank2_Label_A87E:
    LDA a:$0480,X
    CMP #$0F
    BEQ Bank2_Label_A898
    INC $02
    TAY
    AND #$30
    BNE Bank2_Label_A891
    LDA #$0F
    JMP Bank2_Label_A895

Bank2_Label_A891:
    TYA
    SEC
    SBC #$10

Bank2_Label_A895:
    STA a:$0480,X

Bank2_Label_A898:
    INX
    CPX #$20
    BNE Bank2_Label_A87E
    LDX #$80
    LDY #$04
    JSR Bank2_Func_B2A3
    LDA #$03
    STA $68
    JSR Bank2_Func_B1BB
    LDA $02
    BNE Bank2_Label_A87A
    RTS

Bank2_Func_A8B0:
    LDX #$00
    STX $02

Bank2_Label_A8B4:
    LDA a:$0480,X
    CMP a:$0705,X
    BEQ Bank2_Label_A8D3
    INC $02
    CMP #$0F
    BNE Bank2_Label_A8CA
    LDA a:$0705,X
    AND #$0F
    JMP Bank2_Label_A8D0

Bank2_Label_A8CA:
    LDA a:$0480,X
    CLC
    ADC #$10

Bank2_Label_A8D0:
    STA a:$0480,X

Bank2_Label_A8D3:
    INX
    CPX #$20
    BNE Bank2_Label_A8B4
    LDX #$80
    LDY #$04
    JSR Bank2_Func_B2A3
    LDA #$03
    STA $68
    JSR Bank2_Func_B1BB
    LDA $02
    BNE Bank2_Func_A8B0
    RTS

Bank2_Func_A8EB:
    JSR Bank2_Func_A904
    LDA #$00
    STA $88
    STA $86
    STA $87
    LDA #$1E
    STA $07

Bank2_Label_A8FA:
    JSR Bank2_Func_A922
    INC $88
    DEC $07
    BNE Bank2_Label_A8FA
    RTS

Bank2_Func_A904:
    LDA $DF
    AND #$F8
    LSR A
    LSR A
    CLC
    ADC #$E6
    STA $85
    LDA $DF
    AND #$07
    ASL A
    ASL A
    ASL A
    CLC
    ADC #$F2
    STA $84
    LDA $85
    ADC #$00
    STA $85
    RTS

Bank2_Func_A922:
    JSR Bank2_Func_A946
    LDX #$00
    LDY $88
    JSR Bank2_Func_B0BA
    LDX #$A0
    LDY #$04
    LDA #$20
    JSR Bank2_Func_B33A
    LDX #$00
    LDY $88
    JSR Bank2_Func_B0F8
    LDX #$C0
    LDY #$04
    LDA #$08
    JSR Bank2_Func_B33A
    RTS

Bank2_Func_A946:
    JSR Bank2_Func_A967
    LDA $87
    EOR #$02
    STA $87
    BNE Bank2_Label_A966
    LDA $86
    EOR #$02
    STA $86
    BNE Bank2_Label_A966
    LDA $84
    CLC
    ADC #$40
    STA $84
    LDA $85
    ADC #$00
    STA $85

Bank2_Label_A966:
    RTS

Bank2_Func_A967:
    LDX #$00
    STX $01

Bank2_Label_A96B:
    LDA #$00
    STA $03
    LDY $01
    LDA ($84),Y
    ASL A
    ROL $03
    ASL A
    ROL $03
    CLC
    ADC #$F2
    STA $02
    LDA $03
    ADC #$E2
    STA $03
    LDA $86
    STA $00
    JSR Bank2_Func_A99C
    INC $00
    JSR Bank2_Func_A99C
    JSR Bank2_Func_A9C5
    INC $01
    LDA $01
    CMP #$08
    BNE Bank2_Label_A96B
    RTS

Bank2_Func_A99C:
    LDA #$00
    STA $05
    LDY $00
    LDA ($02),Y
    ASL A
    ROL $05
    ASL A
    ROL $05
    CLC
    ADC #$F2
    STA $04
    LDA $05
    ADC #$DE
    STA $05
    LDY $87
    LDA ($04),Y
    STA a:$04A0,X
    INX
    INY
    LDA ($04),Y
    STA a:$04A0,X
    INX
    RTS

Bank2_Func_A9C5:
    STX $3E
    LDY $00
    LDA ($02),Y
    TAX
    LDA a:$DDF2,X
    ASL A
    ASL A
    STA $3C
    DEY
    LDA ($02),Y
    TAX
    LDA a:$DDF2,X
    ORA $3C
    STA $3C
    ASL A
    ASL A
    ASL A
    ASL A
    STA $3D
    LDA $88
    AND #$FC
    ASL A
    CLC
    ADC $01
    TAY
    LDA $88
    AND #$02
    BNE Bank2_Label_A9FD
    LDA a:$0400,Y
    AND #$F0
    ORA $3C
    JMP Bank2_Label_AA04

Bank2_Label_A9FD:
    LDA a:$0400,Y
    AND #$0F
    ORA $3D

Bank2_Label_AA04:
    STA a:$0400,Y
    LDY $01
    STA a:$04C0,Y
    LDX $3E
    RTS

Bank2_Func_AA0F:
    PHA
    AND #$0F
    STA $AA
    PLA
    CLC
    ADC #$10
    STA $A9
    LSR A
    LSR A
    LSR A
    LSR A
    CMP $AA
    BNE Bank2_Label_AA26
    LDA $AA
    SEC
    RTS

Bank2_Label_AA26:
    LDA $A9
    CLC
    RTS
    .byte $A5, $8C, $85, $00, $A5, $8D, $85, $01, $A9, $00, $85, $04, $86, $02, $BD, $20
    .byte $06, $38, $E5, $02, $85, $03, $A9, $68, $85, $A2, $A5, $02, $C9, $01, $F0, $04
    .byte $A9, $80, $85, $A2, $20, $52, $AA, $60, $A0, $F2, $BD, $08, $06, $C5, $00, $B0
    .byte $02, $A0, $0E, $98, $18, $65, $00, $85, $08, $A0, $F2, $BD, $10, $06, $C5, $01
    .byte $B0, $02, $A0, $0E, $98, $18, $65, $01, $85, $09, $20, $AA, $AA, $E6, $02, $C6
    .byte $03, $C6, $03, $20, $9E, $AA, $E6, $02, $C6, $03, $D0, $F7, $A6, $02, $BD, $07
    .byte $06, $85, $08, $BD, $0F, $06, $85, $09, $A9, $80, $85, $3E, $A5, $A2, $85, $3F
    .byte $20, $B6, $AA, $60, $A6, $02, $BD, $07, $06, $85, $08, $BD, $0F, $06, $85, $09
    .byte $A6, $02, $BD, $09, $06, $85, $3E, $BD, $11, $06, $85, $3F, $A6, $02, $BD, $08
    .byte $06, $85, $3C, $BD, $10, $06, $85, $3D, $BD, $18, $06, $20, $0F, $AA, $9D, $18
    .byte $06, $90, $23, $20, $F1, $AA, $A6, $02, $A5, $3C, $38, $E5, $3E, $20, $49, $B1
    .byte $85, $40, $A5, $3D, $38, $E5, $3F, $20, $49, $B1, $85, $41, $A5, $3C, $9D, $08
    .byte $06, $A5, $3D, $9D, $10, $06, $60, $A5, $3C, $38, $E5, $08, $20, $49, $B1, $85
    .byte $40, $A5, $3C, $38, $E5, $3E, $20, $49, $B1, $C5, $40, $B0, $08, $A6, $08, $20
    .byte $3B, $AB, $4C, $14, $AB, $A6, $3E, $20, $3B, $AB, $A5, $3D, $38, $E5, $09, $20
    .byte $49, $B1, $85, $40, $A5, $3D, $38, $E5, $3F, $20, $49, $B1, $C5, $40, $B0, $08
    .byte $A4, $09, $20, $47, $AB, $4C, $37, $AB, $A4, $3F, $20, $47, $AB, $38, $60, $18
    .byte $60, $E4, $3C, $F0, $07, $B0, $03, $C6, $3C, $60, $E6, $3C, $60, $C4, $3D, $F0
    .byte $07, $B0, $03, $C6, $3D, $60, $E6, $3D, $60

Bank2_Func_AB53:
    JSR Bank2_Func_B153
    AND #$07
    TAX
    LDA a:$06F1,X
    CMP #$FF
    BEQ Bank2_Label_AB9D
    STA $3E
    LSR A
    LSR A
    LSR A
    CMP $8A
    BEQ Bank2_Label_AB7F
    BCC Bank2_Label_AB75
    LDA $3E
    SEC
    SBC #$08
    STA $3E
    JMP Bank2_Label_AB7C

Bank2_Label_AB75:
    LDA $3E
    CLC
    ADC #$08
    STA $3E

Bank2_Label_AB7C:
    JSR Bank2_Func_AB9E

Bank2_Label_AB7F:
    LDA $3E
    AND #$07
    CMP $89
    BEQ Bank2_Label_AB9D
    BCC Bank2_Label_AB93
    LDA $3E
    SEC
    SBC #$01
    STA $3E
    JMP Bank2_Label_AB9A

Bank2_Label_AB93:
    LDA $3E
    CLC
    ADC #$01
    STA $3E

Bank2_Label_AB9A:
    JSR Bank2_Func_AB9E

Bank2_Label_AB9D:
    RTS

Bank2_Func_AB9E:
    LDY $3E
    LDA a:$ABB9,Y
    BNE Bank2_Label_ABB8
    LDY #$00

Bank2_Label_ABA7:
    LDA $3E
    CMP a:$06F1,Y
    BEQ Bank2_Label_ABB8
    INY
    CPY #$08
    BNE Bank2_Label_ABA7
    LDA $3E
    STA a:$06F1,X

Bank2_Label_ABB8:
    RTS
    .byte $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $01, $01, $00, $01, $00, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $01, $01, $00, $00, $00, $01, $01, $00, $00, $00, $00, $01, $01, $01
    .byte $00, $00, $00, $00, $01, $01, $01, $01, $00, $00, $00, $00, $01, $01, $01, $01

Bank2_Func_ABF9:
    LDA #$00
    STA $51
    LDX #$00

Bank2_Label_ABFF:
    LDA a:$06F1,X
    CMP $DF
    BEQ Bank2_Label_AC0C
    INX
    CPX #$08
    BNE Bank2_Label_ABFF
    RTS

Bank2_Label_AC0C:
    LDA #$00
    STA $51
    JSR Bank2_Func_9104
    BCC Bank2_Label_AC6B
    LDA #$00
    STA $51
    LDA #$00
    STA $C9
    STA $CA
    LDA #$00
    STA $51
    CPX #$06
    BCS Bank2_Label_AC6B
    STX $C8
    LDA #$01
    STA $51
    LDY #$00

Bank2_Label_AC2F:
    JSR Bank2_Func_8B68
    LDA a:$AC6C,Y
    STA a:$0600,X
    LDA a:$AC74,Y
    CLC
    ADC $C9
    STA a:$0608,X
    LDA a:$AC7C,Y
    CLC
    ADC $CA
    STA a:$0610,X
    LDA a:$AC84,Y
    STA a:$0638,X
    STY $42
    TAY
    LDA a:$8ED5,Y
    STA a:$0628,X
    LDY $42
    LDA #$1E
    STA a:$0668,X
    INY
    INX
    CPX #$08
    BNE Bank2_Label_AC2F
    LDA #$03
    STA a:$02AA

Bank2_Label_AC6B:
    RTS
    .byte $03, $03, $03, $03, $03, $03, $03, $03, $68, $62, $68, $72, $7E, $88, $8E, $88
    .byte $88, $7C, $70, $68, $68, $70, $7C, $88, $0A, $0B, $0B, $0B, $0B, $0B, $0B, $0B
    .byte $A9, $00, $85, $3F, $E0, $06, $B0, $18, $20, $AE, $AC, $A4, $40, $8A, $99, $20
    .byte $06, $E0, $06, $B0, $09, $20, $AE, $AC, $A4, $40, $8A, $99, $20, $06, $38, $60
    .byte $18, $60, $86, $40, $A9, $04, $85, $41, $20, $68, $8B, $A4, $3F, $B9, $F9, $AC
    .byte $9D, $00, $06, $B9, $01, $AD, $9D, $08, $06, $B9, $09, $AD, $9D, $10, $06, $B9
    .byte $11, $AD, $9D, $38, $06, $84, $42, $A8, $B9, $D5, $8E, $9D, $28, $06, $A4, $42
    .byte $AD, $BD, $8E, $9D, $98, $06, $B9, $19, $AD, $9D, $18, $06, $A9, $1E, $9D, $68
    .byte $06, $E6, $3F, $E8, $E0, $08, $F0, $04, $C6, $41, $D0, $BC, $60, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $68, $62, $68, $72, $64, $6C, $74, $74, $88, $7C, $70
    .byte $68, $92, $88, $80, $80, $08, $09, $09, $09, $08, $09, $09, $09, $01, $01, $02
    .byte $02, $02, $02, $03, $03, $A6, $C8, $BD, $80, $06, $D0, $30, $20, $53, $B1, $29
    .byte $20, $09, $10, $9D, $80, $06, $20, $53, $B1, $29, $01, $9D, $70, $06, $20, $53
    .byte $B1, $29, $C0, $09, $10, $DD, $50, $06, $F0, $F4, $9D, $50, $06, $20, $53, $B1
    .byte $29, $C0, $09, $10, $DD, $58, $06, $F0, $F4, $9D, $58, $06, $DE, $80, $06, $BD
    .byte $08, $06, $85, $3C, $BD, $10, $06, $85, $3D, $BD, $70, $06, $F0, $0B, $BD, $58
    .byte $06, $A8, $BD, $50, $06, $AA, $4C, $79, $AD, $A6, $8C, $A4, $8D, $20, $3B, $AB
    .byte $20, $47, $AB, $A6, $C8, $A5, $3C, $9D, $08, $06, $A5, $3D, $9D, $10, $06, $86
    .byte $05, $A6, $05, $BD, $09, $06, $85, $3C, $BD, $11, $06, $85, $3D, $BD, $10, $06
    .byte $A8, $BD, $08, $06, $AA, $8A, $38, $E5, $3C, $20, $49, $B1, $C9, $06, $90, $03
    .byte $20, $3B, $AB, $98, $38, $E5, $3D, $20, $49, $B1, $C9, $06, $90, $03, $20, $47
    .byte $AB, $A6, $05, $A5, $3C, $9D, $09, $06, $A5, $3D, $9D, $11, $06, $E6, $05, $A5
    .byte $05, $C9, $07, $D0, $BC, $60, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01
    .byte $01, $00, $01, $01, $01, $00, $02, $02, $0A, $02, $01, $02, $02, $02, $03, $03
    .byte $03, $02, $03, $03, $03, $03, $04, $04, $04, $04, $04, $04, $05, $05, $06, $04
    .byte $04, $06, $06, $07, $06, $06, $06, $06, $06, $06, $07, $07, $09, $09, $08, $08
    .byte $08, $08, $08, $0A, $0A, $0A

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
    JSR Bank2_Func_BEC5
    JSR Bank2_Func_C4F5
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

Bank2_Func_B1BB:
    INC $D6
    LDA $68
    BNE Bank2_Func_B1BB
    RTS
    .byte $A2, $00, $20, $D1, $B1, $85, $65, $A2, $01, $20, $D1, $B1, $85, $66, $60, $B5
    .byte $1F, $D0, $03, $95, $5F, $60, $B5, $5F, $D0, $07, $A9, $08, $95, $5F, $B5, $1F
    .byte $60, $D6, $5F, $F0, $03, $A9, $00, $60, $A9, $04, $95, $5F, $B5, $1F, $60

Bank2_Func_B1F1:
    LDY #$00
    LDX $04

Bank2_Label_B1F5:
    LDA ($00),Y
    STA ($02),Y
    INY
    DEX
    BNE Bank2_Label_B1F5
    RTS

Bank2_Func_B1FE:
    LDA #$10
    STA a:$2000
    STA $19
    LDA #$00
    STA a:$2001
    JSR Bank2_Func_B0AF
    LDX #$00
    TXA

Bank2_Label_B210:
    EOR $00,X
    INX
    BNE Bank2_Label_B210
    STA $D6
    TAX
    LDA a:$B1FE,X
    STA $D7
    TAX
    LDA a:$B1FE,X
    STA $D8
    LDX #$3C
    LDA #$00

Bank2_Label_B227:
    STA $00,X
    INX
    CPX #$D6
    BNE Bank2_Label_B227
    LDA #$00
    STA $1B
    STA $1C
    LDA #$04
    STA $5E
    LDA #$90
    STA a:$2000
    STA $19
    LDA #$00
    STA a:$4011
    STA a:$4015
    STA a:$4010
    LDA #$40
    STA a:$4017
    LDA #$00
    STA a:$02A0
    STA a:$02AA
    STA a:$02AB
    RTS

Bank2_Func_B25B:
    LDX #$00
    LDY #$10

Bank2_Label_B25F:
    LDA #$F4
    STA a:$0300,X
    STA a:$0304,X
    STA a:$0308,X
    STA a:$030C,X
    TXA
    CLC
    ADC #$10
    TAX
    DEY
    BNE Bank2_Label_B25F
    RTS

Bank2_Func_B276:
    JSR Bank2_Func_B25B
    JSR Bank2_Func_B0AF
    LDA #$01
    STA $67
    LDA #$00
    STA a:$2001
    RTS

Bank2_Func_B286:
    JSR Bank2_Func_B062
    JSR Bank2_Func_B0AF
    JSR Bank2_Func_B0A4
    JSR Bank2_Func_B07D
    JSR Bank2_Func_B08E
    LDA #$00
    STA $67
    LDA #$1E
    STA a:$2001
    RTS

Bank2_Func_B29F:
    LDX $00
    LDY $01

Bank2_Func_B2A3:
    JSR Bank2_Func_B06B
    STX $3C
    STY $3D
    LDX $6C
    LDY #$00
    LDA #$3F
    STA a:$0500,X
    INX
    LDA #$00
    STA a:$0500,X
    INX
    LDA #$20
    STA a:$0500,X
    INX

Bank2_Label_B2C0:
    LDA ($3C),Y
    STA a:$0500,X
    STA a:$0480,Y
    INX
    INY
    CPY #$20
    BNE Bank2_Label_B2C0
    STX $6C
    JSR Bank2_Func_B05A
    RTS

Bank2_Func_B2D4:
    LDA $00
    LDX #$00

Bank2_Label_B2D8:
    STA a:$04A0,X
    INX
    CPX #$20
    BNE Bank2_Label_B2D8
    LDA #$00
    STA $41

Bank2_Label_B2E4:
    LDX #$00
    LDY $41
    JSR Bank2_Func_B0BA
    LDX #$A0
    LDY #$04
    LDA #$20
    JSR Bank2_Func_B33A
    INC $41
    LDA $41
    CMP #$3C
    BNE Bank2_Label_B2E4
    RTS

Bank2_Func_B2FD:
    LDA $00
    TAX
    LDA a:$B3F3,X
    LDX #$00

Bank2_Label_B305:
    STA a:$0400,X
    INX
    CPX #$80
    BNE Bank2_Label_B305
    LDA #$00
    STA $3F

Bank2_Label_B311:
    LDX #$00
    LDY $3F
    JSR Bank2_Func_B0F8
    LDX #$00
    LDY #$04
    LDA #$20
    JSR Bank2_Func_B33A
    LDA $3F
    CLC
    ADC #$10
    STA $3F
    CMP #$40
    BNE Bank2_Label_B311
    RTS
    .byte $A6, $00, $A4, $01, $20, $BA, $B0, $A6, $02, $A4, $03, $A5, $04

Bank2_Func_B33A:
    JSR Bank2_Func_B06B
    STX $3C
    STY $3D
    STA $3E
    LDX $6C
    LDY $72
    BEQ Bank2_Label_B34B
    LDY #$80

Bank2_Label_B34B:
    TYA
    ORA $6A
    STA a:$0500,X
    INX
    LDA $69
    STA a:$0500,X
    INX
    LDA $3E
    STA a:$0500,X
    INX
    LDY #$00

Bank2_Label_B360:
    LDA ($3C),Y
    STA a:$0500,X
    INX
    INY
    DEC $3E
    BNE Bank2_Label_B360
    STX $6C
    JSR Bank2_Func_B05A
    RTS
    .byte $A6, $00, $A4, $01, $20, $BA, $B0, $A5, $02, $20, $6B, $B0, $48, $A6, $6C, $A5
    .byte $6A, $9D, $00, $05, $E8, $A5, $69, $9D, $00, $05, $E8, $A9, $01, $9D, $00, $05
    .byte $E8, $68, $9D, $00, $05, $E8, $86, $6C, $20, $5A, $B0, $60, $A6, $00, $A4, $01
    .byte $A5, $02, $85, $3C, $86, $3D, $84, $3E, $20, $6B, $B0, $20, $F8, $B0, $8A, $4A
    .byte $29, $01, $85, $3D, $98, $29, $02, $18, $65, $3D, $AA, $A4, $3C, $B9, $F3, $B3
    .byte $3D, $FB, $B3, $85, $3C, $A4, $41, $B9, $00, $04, $3D, $F7, $B3, $05, $3C, $99
    .byte $00, $04, $48, $A6, $6C, $A5, $6A, $9D, $00, $05, $E8, $A5, $69, $9D, $00, $05
    .byte $E8, $A9, $01, $9D, $00, $05, $E8, $68, $9D, $00, $05, $E8, $86, $6C, $20, $5A
    .byte $B0, $60, $00, $55, $AA, $FF, $FC, $F3, $CF, $3F, $03, $0C, $30, $C0

Bank2_Func_B3FF:
    JSR Bank2_Func_B406
    JSR Bank2_Func_B460
    RTS

Bank2_Func_B406:
    LDY #$00
    LDA #$5C
    STA $83
    LDA #$18
    STA $80
    LDA #$00
    STA $82

Bank2_Label_B414:
    LDA a:$0298,Y
    BNE Bank2_Label_B425
    LDA $83
    CLC
    ADC #$08
    STA $83
    INY
    CPY #$06
    BNE Bank2_Label_B414

Bank2_Label_B425:
    LDA a:$0298,Y
    AND #$0F
    ORA #$30
    STA $81
    JSR Bank2_Func_B6BA
    LDA $83
    CLC
    ADC #$08
    STA $83
    INY
    CPY #$07
    BNE Bank2_Label_B425
    LDA #$32
    STA $80
    LDA #$E6
    STA $83
    LDA #$00
    STA $82
    LDA #$3A
    STA $81
    JSR Bank2_Func_B6BA
    LDA #$F0
    STA $83
    LDA $2A
    AND #$0F
    ORA #$30
    STA $81
    JSR Bank2_Func_B6BA
    RTS

Bank2_Func_B460:
    LDA $2C
    ASL A
    ASL A
    CLC
    ADC #$50
    STA $80
    LDA #$EC
    STA $83
    LDA #$00
    STA $82
    LDA #$04
    STA $0A
    LDA $2B
    STA $81
    LDY #$07

Bank2_Label_B47B:
    LDA $81
    SEC
    SBC #$04
    BCC Bank2_Label_B48E
    STA $81
    LDA #$3F
    STA a:$000A,Y
    DEY
    BPL Bank2_Label_B47B
    BMI Bank2_Label_B49F

Bank2_Label_B48E:
    CLC
    ADC #$3F
    STA a:$000A,Y
    DEY
    BMI Bank2_Label_B49F
    LDA #$3B

Bank2_Label_B499:
    STA a:$000A,Y
    DEY
    BPL Bank2_Label_B499

Bank2_Label_B49F:
    LDY $2C

Bank2_Label_B4A1:
    LDA a:$000A,Y
    STA $81
    JSR Bank2_Func_B6BA
    LDA $80
    CLC
    ADC #$08
    STA $80
    INY
    CPY #$08
    BNE Bank2_Label_B4A1
    RTS

Bank2_Func_B4B6:
    LDA $7A
    AND #$40
    BEQ Bank2_Label_B4C4
    LDA $16
    LSR A
    AND #$01
    BEQ Bank2_Label_B4C4
    RTS

Bank2_Label_B4C4:
    LDA $7A
    BPL Bank2_Label_B4DA
    LDA $16
    AND #$08
    BEQ Bank2_Label_B4DA
    LDA $7A
    ASL A
    ASL A
    AND #$80
    ORA $7A
    LSR A
    LSR A
    STA $7A

Bank2_Label_B4DA:
    LDX $79
    TXA
    ASL A
    TAY
    LDA #$00
    ADC #$B6
    STA $7C
    LDA #$D7
    STA $7B
    INY
    LDA ($7B),Y
    CMP #$04
    BCS Bank2_Label_B532
    PHA
    DEY
    LDA ($7B),Y
    TAX
    ASL A
    TAY
    LDA #$00
    ADC #$B6
    STA $7C
    LDA #$D7
    STA $7B
    LDA ($7B),Y
    PHA
    INY
    LDA ($7B),Y
    STA $7C
    PLA
    STA $7B
    LDY #$00
    LDA ($7B),Y
    INY
    STA $7F
    LDA ($7B),Y
    INY
    STA $7D
    LDA ($7B),Y
    INY
    STA $7E
    PLA
    BEQ Bank2_Label_B529
    CMP #$02
    BEQ Bank2_Label_B52F
    BCC Bank2_Label_B52C
    JMP Bank2_Label_B654

Bank2_Label_B529:
    JMP Bank2_Label_B544

Bank2_Label_B52C:
    JMP Bank2_Label_B5F6

Bank2_Label_B52F:
    JMP Bank2_Label_B598

Bank2_Label_B532:
    PHA
    DEY
    LDA ($7B),Y
    STA $7B
    PLA
    STA $7C
    LDY #$00
    LDA ($7B),Y
    INY
    STA $7F
    INY
    INY

Bank2_Label_B544:
    LDA ($7B),Y
    INY
    TAX
    AND #$7F
    CLC
    ADC $77
    STA $80
    LDA $78
    ADC #$00
    AND #$03
    BNE Bank2_Label_B590
    LDA $80
    CMP #$F0
    BCS Bank2_Label_B590
    TXA
    AND #$80
    STA $82
    LDA ($7B),Y
    INY
    TAX
    AND #$7F
    CLC
    ADC $75
    STA $83
    LDA $76
    ADC #$00
    AND #$03
    BNE Bank2_Label_B591
    TXA
    AND #$80
    LSR A
    ORA $82
    STA $82
    LDA ($7B),Y
    INY
    STA $81
    LDA $7A
    AND #$23
    ORA $82
    STA $82
    JSR Bank2_Func_B6BA
    JMP Bank2_Label_B592

Bank2_Label_B590:
    INY

Bank2_Label_B591:
    INY

Bank2_Label_B592:
    DEC $7F
    BNE Bank2_Label_B544
    CLC
    RTS

Bank2_Label_B598:
    LDA ($7B),Y
    INY
    TAX
    AND #$7F
    SEC
    SBC $7E
    EOR #$FF
    CLC
    ADC #$01
    CLC
    ADC $77
    STA $80
    LDA $78
    ADC #$00
    AND #$03
    BNE Bank2_Label_B5EE
    LDA $80
    CMP #$F0
    BCS Bank2_Label_B5EE
    TXA
    AND #$80
    STA $82
    LDA ($7B),Y
    INY
    TAX
    AND #$7F
    CLC
    ADC $75
    STA $83
    LDA $76
    ADC #$00
    AND #$03
    BNE Bank2_Label_B5EF
    TXA
    AND #$80
    LSR A
    ORA $82
    STA $82
    LDA ($7B),Y
    INY
    STA $81
    LDA $7A
    AND #$23
    ORA $82
    EOR #$80
    STA $82
    JSR Bank2_Func_B6BA
    JMP Bank2_Label_B5F0

Bank2_Label_B5EE:
    INY

Bank2_Label_B5EF:
    INY

Bank2_Label_B5F0:
    DEC $7F
    BNE Bank2_Label_B598
    CLC
    RTS

Bank2_Label_B5F6:
    LDA ($7B),Y
    INY
    TAX
    AND #$7F
    CLC
    ADC $77
    STA $80
    LDA $78
    ADC #$00
    AND #$03
    BNE Bank2_Label_B64C
    LDA $80
    CMP #$F0
    BCS Bank2_Label_B64C
    TXA
    AND #$80
    STA $82
    LDA ($7B),Y
    INY
    TAX
    AND #$7F
    SEC
    SBC $7D
    EOR #$FF
    CLC
    ADC #$01
    CLC
    ADC $75
    STA $83
    LDA $76
    ADC #$00
    AND #$03
    BNE Bank2_Label_B64D
    TXA
    AND #$80
    LSR A
    ORA $82
    STA $82
    LDA ($7B),Y
    INY
    STA $81
    LDA $7A
    AND #$23
    ORA $82
    EOR #$40
    STA $82
    JSR Bank2_Func_B6BA
    JMP Bank2_Label_B64E

Bank2_Label_B64C:
    INY

Bank2_Label_B64D:
    INY

Bank2_Label_B64E:
    DEC $7F
    BNE Bank2_Label_B5F6
    CLC
    RTS

Bank2_Label_B654:
    LDA ($7B),Y
    INY
    TAX
    AND #$7F
    SEC
    SBC $7E
    EOR #$FF
    CLC
    ADC #$01
    CLC
    ADC $77
    STA $80
    LDA $78
    ADC #$00
    AND #$03
    BNE Bank2_Label_B6B2
    LDA $80
    CMP #$F0
    BCS Bank2_Label_B6B2
    TXA
    AND #$80
    STA $82
    LDA ($7B),Y
    INY
    TAX
    AND #$7F
    SEC
    SBC $7D
    EOR #$FF
    CLC
    ADC #$01
    CLC
    ADC $75
    STA $83
    LDA $76
    ADC #$00
    AND #$03
    BNE Bank2_Label_B6B3
    TXA
    AND #$80
    LSR A
    ORA $82
    STA $82
    LDA ($7B),Y
    INY
    STA $81
    LDA $7A
    AND #$23
    ORA $82
    EOR #$C0
    STA $82
    JSR Bank2_Func_B6BA
    JMP Bank2_Label_B6B4

Bank2_Label_B6B2:
    INY

Bank2_Label_B6B3:
    INY

Bank2_Label_B6B4:
    DEC $7F
    BNE Bank2_Label_B654
    CLC
    RTS

Bank2_Func_B6BA:
    LDA $74
    ASL A
    TAX
    LDA $80
    STA a:$0300,X
    LDA $81
    STA a:$0301,X
    LDA $82
    STA a:$0302,X
    LDA $83
    STA a:$0303,X
    INC $74
    INC $74
    RTS
    .byte $79, $B8, $64, $B8, $4F, $B8, $00, $01, $01, $01, $02, $01, $8E, $B8, $04, $01
    .byte $A3, $B8, $B8, $B8, $09, $01, $E2, $B8, $0B, $01, $F7, $B8, $F7, $B8, $4F, $B8
    .byte $39, $B9, $2A, $B9, $10, $01, $11, $01, $0C, $B9, $1B, $B9, $14, $01, $15, $01
    .byte $48, $B9, $48, $B9, $18, $01, $19, $01, $57, $B9, $57, $B9, $1C, $01, $1D, $01
    .byte $66, $B9, $75, $B9, $20, $01, $21, $01, $84, $B9, $93, $B9, $24, $01, $25, $01
    .byte $A2, $B9, $B1, $B9, $28, $01, $29, $01, $C0, $B9, $C0, $B9, $2C, $01, $2D, $01
    .byte $CF, $B9, $CF, $B9, $30, $01, $31, $01, $DE, $B9, $DE, $B9, $34, $01, $35, $01
    .byte $0C, $B9, $0C, $B9, $38, $01, $39, $01, $0C, $B9, $0C, $B9, $3C, $01, $3D, $01
    .byte $ED, $B9, $ED, $B9, $40, $01, $41, $01, $F6, $B9, $F6, $B9, $F6, $B9, $F6, $B9
    .byte $05, $BA, $05, $BA, $05, $BA, $05, $BA, $14, $BA, $14, $BA, $14, $BA, $14, $BA
    .byte $23, $BA, $23, $BA, $50, $01, $51, $01, $23, $BA, $23, $BA, $54, $01, $55, $01
    .byte $23, $BA, $23, $BA, $58, $01, $59, $01, $23, $BA, $23, $BA, $5C, $01, $5D, $01
    .byte $32, $BA, $32, $BA, $60, $01, $61, $01, $50, $BA, $50, $BA, $50, $BA, $50, $BA
    .byte $41, $BA, $41, $BA, $68, $01, $69, $01, $5F, $BA, $6E, $BA, $7D, $BA, $8C, $BA
    .byte $9B, $BA, $9B, $BA, $9B, $BA, $9B, $BA, $AA, $BA, $AA, $BA, $AA, $BA, $AA, $BA
    .byte $0C, $B9, $0C, $B9, $0C, $B9, $0C, $B9, $0C, $B9, $0C, $B9, $0C, $B9, $0C, $B9
    .byte $B9, $BA, $B9, $BA, $B9, $BA, $B9, $BA, $CE, $BA, $CE, $BA, $CE, $BA, $CE, $BA
    .byte $E3, $BA, $F8, $BA, $0D, $BB, $F8, $BA, $22, $BB, $37, $BB, $4C, $BB, $37, $BB
    .byte $61, $BB, $76, $BB, $90, $01, $91, $01, $8B, $BB, $A0, $BB, $94, $01, $95, $01
    .byte $B5, $BB, $CA, $BB, $98, $01, $99, $01, $DF, $BB, $DF, $BB, $9C, $01, $9D, $01
    .byte $F4, $BB, $03, $BC, $12, $BC, $F4, $BB, $21, $BC, $30, $BC, $A4, $01, $A5, $01
    .byte $3F, $BC, $4E, $BC, $A8, $01, $A9, $01, $5D, $BC, $5D, $BC, $5D, $BC, $5D, $BC
    .byte $6C, $BC, $6C, $BC, $6C, $BC, $6C, $BC, $7B, $BC, $8A, $BC, $B4, $01, $B5, $01
    .byte $99, $BC, $99, $BC, $99, $BC, $99, $BC, $06, $08, $0E, $00, $00, $00, $00, $08
    .byte $01, $08, $00, $10, $08, $08, $11, $10, $00, $20, $10, $08, $21, $06, $08, $0E
    .byte $00, $00, $00, $00, $08, $01, $08, $00, $10, $08, $08, $11, $10, $00, $22, $10
    .byte $08, $23, $06, $08, $0E, $00, $00, $00, $00, $08, $01, $08, $00, $02, $08, $08
    .byte $03, $10, $00, $12, $10, $08, $13, $06, $08, $0E, $00, $00, $08, $00, $08, $09
    .byte $08, $00, $18, $08, $08, $18, $10, $00, $29, $10, $08, $29, $06, $08, $0E, $00
    .byte $00, $06, $00, $08, $07, $08, $00, $16, $08, $08, $17, $10, $00, $26, $10, $08
    .byte $27, $06, $08, $0E, $00, $00, $00, $00, $08, $01, $08, $00, $04, $08, $08, $11
    .byte $10, $00, $14, $10, $08, $21, $06, $08, $0E, $00, $00, $00, $00, $08, $01, $08
    .byte $00, $05, $08, $08, $11, $10, $00, $15, $10, $08, $23, $06, $08, $0E, $00, $00
    .byte $08, $00, $08, $09, $08, $00, $18, $08, $08, $19, $10, $00, $28, $10, $08, $29
    .byte $06, $08, $0E, $00, $00, $06, $00, $08, $07, $08, $00, $24, $08, $08, $25, $10
    .byte $00, $26, $10, $08, $27, $04, $08, $08, $00, $00, $66, $00, $08, $67, $08, $00
    .byte $76, $08, $08, $77, $04, $08, $08, $00, $00, $68, $00, $08, $69, $08, $00, $78
    .byte $08, $08, $79, $04, $08, $08, $00, $00, $80, $00, $08, $81, $08, $00, $90, $08
    .byte $08, $91, $04, $08, $08, $00, $00, $82, $00, $08, $81, $08, $00, $92, $08, $08
    .byte $93, $04, $08, $08, $00, $00, $44, $00, $08, $45, $08, $00, $54, $08, $08, $55
    .byte $04, $08, $08, $00, $00, $88, $00, $08, $89, $08, $00, $98, $08, $08, $99, $04
    .byte $08, $08, $00, $00, $AC, $00, $08, $AD, $08, $00, $BC, $08, $08, $BD, $04, $08
    .byte $08, $00, $00, $AE, $00, $08, $AF, $08, $00, $BE, $08, $08, $BF, $04, $08, $08
    .byte $00, $00, $A8, $00, $08, $A9, $08, $00, $B8, $08, $08, $B9, $04, $08, $08, $00
    .byte $00, $AA, $00, $08, $AB, $08, $00, $BA, $08, $08, $BB, $04, $08, $08, $00, $00
    .byte $84, $00, $08, $85, $08, $00, $94, $08, $08, $95, $04, $08, $08, $00, $00, $8A
    .byte $00, $08, $8B, $08, $00, $9A, $08, $08, $9B, $04, $08, $08, $00, $00, $86, $00
    .byte $88, $86, $08, $00, $96, $08, $88, $96, $04, $08, $08, $88, $00, $A4, $88, $08
    .byte $A5, $80, $00, $B4, $80, $08, $B5, $04, $08, $08, $00, $00, $A6, $00, $08, $A7
    .byte $08, $00, $B6, $08, $08, $B7, $02, $08, $04, $04, $00, $0A, $04, $88, $0A, $04
    .byte $08, $08, $00, $00, $40, $00, $08, $41, $08, $00, $50, $08, $08, $51, $04, $08
    .byte $08, $00, $00, $6C, $00, $08, $6D, $08, $00, $6E, $08, $08, $6F, $04, $08, $08
    .byte $00, $00, $0E, $00, $08, $0F, $08, $00, $1E, $08, $08, $1F, $04, $08, $08, $00
    .byte $00, $42, $00, $08, $43, $08, $00, $52, $08, $08, $53, $04, $08, $08, $00, $00
    .byte $0D, $00, $88, $0D, $88, $00, $0D, $88, $88, $0D, $04, $08, $08, $00, $00, $46
    .byte $00, $08, $47, $08, $00, $56, $08, $08, $57, $04, $08, $08, $00, $00, $1C, $00
    .byte $08, $1D, $08, $00, $2C, $08, $08, $2D, $04, $08, $08, $0A, $0A, $59, $0A, $12
    .byte $59, $12, $0A, $59, $12, $12, $59, $04, $08, $08, $08, $08, $58, $08, $14, $58
    .byte $14, $08, $58, $14, $14, $58, $04, $08, $08, $06, $06, $49, $06, $16, $49, $16
    .byte $06, $49, $16, $16, $49, $04, $08, $08, $04, $04, $48, $04, $18, $48, $18, $04
    .byte $48, $18, $18, $48, $04, $08, $08, $00, $00, $60, $00, $08, $61, $08, $00, $70
    .byte $08, $08, $71, $04, $08, $08, $00, $00, $62, $00, $08, $63, $08, $00, $72, $08
    .byte $08, $73, $06, $08, $0C, $00, $00, $A0, $00, $08, $A1, $08, $00, $B0, $08, $08
    .byte $B1, $10, $00, $C0, $10, $08, $C1, $06, $08, $0C, $00, $00, $A2, $00, $08, $A3
    .byte $08, $00, $B2, $08, $08, $B3, $10, $00, $C2, $10, $08, $C3, $06, $08, $0C, $00
    .byte $00, $D0, $00, $08, $D1, $08, $00, $E0, $08, $08, $E1, $10, $00, $F0, $10, $08
    .byte $F1, $06, $08, $0C, $00, $00, $D0, $00, $08, $C4, $08, $00, $E0, $08, $08, $D4
    .byte $10, $00, $F0, $10, $08, $F1, $06, $08, $0C, $00, $00, $D0, $00, $08, $C6, $08
    .byte $00, $E0, $08, $08, $D6, $10, $00, $F0, $10, $08, $F1, $06, $08, $0C, $00, $00
    .byte $D2, $00, $08, $D3, $08, $00, $E2, $08, $08, $E3, $10, $00, $F2, $10, $08, $F3
    .byte $06, $08, $0C, $00, $00, $C5, $00, $08, $D3, $08, $00, $D5, $08, $08, $E3, $10
    .byte $00, $F2, $10, $08, $F3, $06, $08, $0C, $00, $00, $C7, $00, $08, $D3, $08, $00
    .byte $D7, $08, $08, $E3, $10, $00, $F2, $10, $08, $F3, $06, $08, $0C, $00, $00, $CC
    .byte $00, $08, $CD, $08, $00, $DC, $08, $08, $DD, $10, $00, $EC, $10, $08, $ED, $06
    .byte $08, $0C, $00, $00, $CC, $00, $08, $CD, $08, $00, $DC, $08, $08, $E7, $10, $00
    .byte $EC, $10, $08, $F7, $06, $08, $0C, $00, $00, $CA, $00, $08, $CB, $08, $00, $DA
    .byte $08, $08, $DB, $10, $00, $EA, $10, $08, $EB, $06, $08, $0C, $00, $00, $CA, $00
    .byte $08, $CB, $08, $00, $DA, $08, $08, $E6, $10, $00, $EA, $10, $08, $F6, $06, $08
    .byte $0C, $00, $00, $C8, $00, $08, $C9, $08, $00, $D8, $08, $08, $D9, $10, $00, $E8
    .byte $10, $08, $E9, $06, $08, $0C, $00, $00, $C8, $00, $08, $C9, $08, $00, $D8, $08
    .byte $08, $E4, $10, $00, $E8, $10, $08, $F4, $06, $08, $0C, $00, $00, $7C, $00, $08
    .byte $7D, $08, $00, $8C, $08, $08, $8D, $10, $00, $9C, $10, $08, $9D, $04, $08, $08
    .byte $00, $00, $4A, $00, $08, $4B, $08, $00, $5A, $08, $08, $5B, $04, $08, $08, $00
    .byte $00, $6A, $00, $08, $6B, $08, $00, $7A, $08, $08, $7B, $04, $08, $08, $00, $00
    .byte $7E, $00, $08, $7F, $08, $00, $8E, $08, $08, $8F, $04, $08, $08, $00, $00, $CE
    .byte $00, $08, $CF, $08, $00, $DE, $08, $08, $DF, $04, $08, $08, $00, $00, $F8, $00
    .byte $08, $F9, $08, $00, $FA, $08, $08, $FB, $04, $08, $08, $00, $00, $64, $00, $08
    .byte $65, $08, $00, $74, $08, $08, $75, $04, $08, $08, $00, $00, $9E, $00, $08, $9F
    .byte $08, $00, $87, $08, $08, $97, $04, $08, $08, $00, $00, $4E, $00, $08, $4F, $08
    .byte $00, $5E, $08, $08, $5F, $04, $08, $08, $00, $00, $4C, $00, $08, $4D, $08, $00
    .byte $5C, $08, $08, $5D, $04, $08, $08, $00, $00, $1A, $00, $08, $1B, $08, $00, $2A
    .byte $08, $08, $2B, $04, $08, $08, $00, $00, $0B, $00, $08, $0C, $08, $00, $05, $08
    .byte $08, $15, $06, $08, $08, $00, $00, $EE, $00, $08, $EF, $08, $00, $FE, $08, $08
    .byte $FF, $10, $00, $2E, $10, $08, $2F, $01, $23, $3C, $1C, $01, $19, $29, $01, $01
    .byte $17, $27, $11, $01, $23, $3C, $16, $01, $15, $21, $30, $01, $15, $26, $30, $01
    .byte $19, $26, $30, $01, $29, $05, $30, $01, $19, $28, $09, $01, $07, $27, $01, $01
    .byte $00, $10, $20, $01, $19, $28, $15, $01, $15, $21, $30, $01, $15, $26, $30, $01
    .byte $0F, $24, $30, $01, $21, $0F, $30, $0C, $0F, $27, $37, $0C, $0F, $2C, $0C, $0C
    .byte $07, $27, $0F, $0C, $0F, $0A, $1A, $0C, $15, $21, $30, $0C, $05, $26, $30, $0C
    .byte $19, $26, $30, $0C, $16, $31, $30, $0C, $0F, $14, $24, $0C, $0F, $11, $0C, $0C
    .byte $07, $17, $27, $0C, $0F, $0A, $1A, $0C, $15, $21, $30, $0C, $05, $26, $30, $0C
    .byte $15, $29, $30, $0C, $21, $26, $30, $0F, $0F, $09, $19, $0F, $15, $21, $30, $0F
    .byte $0C, $1C, $2C, $0F, $0F, $27, $37, $0F, $15, $21, $30, $0F, $05, $26, $30, $0F
    .byte $15, $27, $30, $0F, $19, $27, $30, $0F, $0F, $09, $19, $0F, $15, $21, $30, $0F
    .byte $0C, $1C, $2C, $0F, $15, $25, $37, $0F, $15, $21, $30, $0F, $05, $26, $30, $0F
    .byte $11, $25, $30, $0F, $05, $15, $30, $0F, $0F, $01, $11, $0F, $0F, $00, $10, $0F
    .byte $07, $17, $27, $0F, $15, $25, $37, $0F, $15, $21, $30, $0F, $05, $26, $30, $0F
    .byte $11, $25, $30, $0F, $05, $15, $35, $0F, $0F, $02, $1C, $0F, $0F, $07, $37, $0F
    .byte $0F, $11, $21, $0F, $15, $25, $37, $0F, $15, $21, $30, $0F, $05, $26, $30, $0F
    .byte $00, $21, $30, $0F, $05, $15, $35, $0F, $0F, $07, $16, $0F, $0F, $07, $21, $0F
    .byte $0F, $15, $26, $0F, $15, $25, $37, $0F, $15, $21, $30, $0F, $05, $26, $30, $0F
    .byte $12, $26, $30, $0F, $2B, $15, $30, $0F, $07, $17, $27, $0F, $00, $10, $20, $0F
    .byte $05, $15, $25, $0F, $01, $11, $21, $0F, $15, $21, $30, $0F, $05, $26, $30, $0F
    .byte $12, $26, $30, $0F, $05, $15, $30, $0F, $07, $17, $27, $0F, $00, $10, $20, $0F
    .byte $0F, $09, $19, $0F, $00, $10, $20, $0F, $15, $21, $30, $0F, $05, $26, $30, $0F
    .byte $01, $21, $31, $0F, $21, $26, $30, $00, $54, $64, $4C, $40, $44, $04, $38, $34
    .byte $3C, $1C, $50, $58, $60, $2C, $28, $08, $48, $30, $20, $24, $18, $14, $10, $0C
    .byte $5C, $2B, $BF, $2A, $BF, $4C, $C0, $64, $C0, $A3, $C0, $BD, $C0, $E7, $C3, $F1
    .byte $C3, $E7, $C3, $F1, $C3, $E7, $C3, $F1, $C3, $E7, $C3, $F1, $C3, $84, $C1, $91
    .byte $C1, $A5, $C3, $BA, $C2, $AE, $C3, $CB, $C3, $A6, $C2, $BA, $C2, $63, $C2, $72
    .byte $C2, $64, $C3, $7F, $C3, $3B, $C1, $1D, $BF, $0D, $C1, $1D, $BF, $54, $C1, $6B
    .byte $C1, $15, $C0, $BA, $C2, $1D, $C0, $BA, $C2, $33, $C3, $47, $C3, $25, $C1, $1D
    .byte $BF, $EA, $C1, $1D, $BF, $05, $C2, $1D, $BF, $58, $BF, $7A, $BF, $58, $BF, $C3
    .byte $BF, $1B, $C2, $2F, $C2, $F3, $BF, $22, $BF

Bank2_Func_BE90:
    CMP #$1A
    BCS Bank2_Label_BEAE
    STX $D1
    LDX a:$02A0
    BMI Bank2_Label_BEA9
    STY $D2
    TAY
    LDA a:$BE0E,X
    CMP a:$BE0E,Y
    BCC Bank2_Label_BEAF
    TYA
    LDY $D2

Bank2_Label_BEA9:
    STA a:$02A0

Bank2_Label_BEAC:
    LDX $D1

Bank2_Label_BEAE:
    RTS

Bank2_Label_BEAF:
    LDY $D2
    JMP Bank2_Label_BEAC

Bank2_Func_BEB4:
    CMP #$1A
    BCS Bank2_Label_BEAE
    STX $D1
    LDX #$00
    STX a:$02A1
    STA a:$02A0
    LDX $D1
    RTS

Bank2_Func_BEC5:
    LDX #$03

Bank2_Label_BEC7:
    LDA a:$02A3,X
    BEQ Bank2_Label_BECF
    DEC a:$02A3,X

Bank2_Label_BECF:
    DEX
    BPL Bank2_Label_BEC7
    LDA a:$02A0
    BMI Bank2_Label_BF0C
    TAX
    ORA #$80
    STA a:$02A0
    CPX #$1A
    BCS Bank2_Label_BF0C
    LDA a:$02A1
    BEQ Bank2_Label_BEF5
    LDA a:$BE0E,X
    CMP a:$02A1
    BCC Bank2_Label_BEF5
    BNE Bank2_Label_BF0C
    LDA a:$02A2
    BNE Bank2_Label_BF0C

Bank2_Label_BEF5:
    LDA a:$BE0E,X
    STA a:$02A1
    TAX
    LDA #$00
    STA a:$02A3
    STA a:$02A4
    STA a:$02A5
    STA a:$02A6
    BEQ Bank2_Label_BF11

Bank2_Label_BF0C:
    LDX a:$02A1
    INX
    INX

Bank2_Label_BF11:
    CPX #$68
    BCS Bank2_Label_BF23
    LDA a:$BE29,X
    PHA
    LDA a:$BE28,X
    PHA
    RTS
    .byte $CE, $A7, $02, $D0, $08

Bank2_Label_BF23:
    LDA #$00
    STA a:$02A1
    STA a:$02A2
    RTS
    .byte $A9, $00, $8D, $A2, $02, $8D, $11, $40, $8D, $A3, $02, $8D, $A4, $02, $8D, $A5
    .byte $02, $8D, $A6, $02, $8D, $08, $40, $8D, $0C, $40, $A9, $18, $8D, $0B, $40, $A9
    .byte $10, $8D, $00, $40, $8D, $04, $40, $A9, $0F, $8D, $15, $40, $60, $A9, $18, $8D
    .byte $A6, $02, $A9, $00, $8D, $0C, $40, $A9, $0C, $8D, $A7, $02, $8D, $0E, $40, $A9
    .byte $08, $8D, $0F, $40, $A9, $00, $8D, $A8, $02, $A9, $04, $8D, $A9, $02, $60, $AE
    .byte $A8, $02, $F0, $2B, $CA, $F0, $03, $4C, $1E, $BF, $CE, $A7, $02, $AD, $A7, $02
    .byte $8D, $0E, $40, $C9, $08, $D0, $30, $EE, $A8, $02, $A9, $1A, $8D, $0C, $40, $A9
    .byte $03, $8D, $0E, $40, $A9, $F8, $8D, $0F, $40, $A9, $10, $8D, $A7, $02, $60, $CE
    .byte $A9, $02, $D0, $13, $EE, $A8, $02, $A9, $04, $8D, $0C, $40, $AD, $A7, $02, $8D
    .byte $0E, $40, $A9, $08, $8D, $0F, $40, $60, $AE, $A8, $02, $F0, $E2, $CA, $F0, $03
    .byte $4C, $1E, $BF, $CE, $A7, $02, $AD, $A7, $02, $8D, $0E, $40, $C9, $08, $D0, $E7
    .byte $EE, $A8, $02, $A9, $1A, $8D, $0C, $40, $A9, $06, $8D, $0E, $40, $A9, $68, $8D
    .byte $0F, $40, $A9, $06, $8D, $A7, $02, $60, $A9, $04, $8D, $A5, $02, $8D, $A6, $02
    .byte $8D, $A7, $02, $A9, $1F, $8D, $0C, $40, $A9, $0F, $8D, $0E, $40, $A0, $08, $A2
    .byte $F0, $A9, $38, $20, $5D, $C4, $8D, $0F, $40, $60, $A0, $60, $A9, $17, $A2, $00
    .byte $F0, $06, $A0, $08, $A9, $01, $A2, $05, $8C, $A4, $02, $8D, $A7, $02, $8E, $A9
    .byte $02, $A9, $01, $8D, $A8, $02, $20, $38, $C0, $4C, $BB, $C2, $A9, $08, $8D, $A6
    .byte $02, $A9, $01, $8D, $0C, $40, $A9, $0A, $8D, $0E, $40, $A9, $08, $8D, $0F, $40
    .byte $60, $A9, $48, $8D, $A3, $02, $8D, $A4, $02, $8D, $A5, $02, $8D, $A6, $02, $A9
    .byte $01, $8D, $A7, $02, $A9, $04, $8D, $A8, $02, $AD, $A8, $02, $D0, $03, $4C, $1E
    .byte $BF, $CE, $A7, $02, $D0, $DA, $CE, $A8, $02, $F0, $1A, $A9, $04, $8D, $A7, $02
    .byte $AD, $A8, $02, $4A, $90, $0B, $A9, $82, $A2, $00, $20, $41, $C4, $A2, $69, $D0
    .byte $12, $A9, $82, $D0, $07, $A9, $3C, $8D, $A7, $02, $A9, $8F, $A2, $00, $20, $41
    .byte $C4, $A2, $8D, $A9, $08, $4C, $4F, $C4, $A9, $67, $85, $2D, $A9, $C4, $85, $2E
    .byte $A9, $01, $8D, $A7, $02, $8D, $A2, $02, $A9, $09, $8D, $A8, $02, $A9, $83, $8D
    .byte $A9, $02, $20, $F5, $C0, $A2, $00, $AD, $A8, $02, $9D, $A3, $02, $8A, $0A, $0A
    .byte $AA, $AD, $A9, $02, $9D, $00, $40, $A9, $00, $9D, $01, $40, $A0, $00, $B1, $2D
    .byte $F0, $10, $0A, $A8, $B9, $2C, $C9, $9D, $02, $40, $B9, $2D, $C9, $09, $08, $9D
    .byte $03, $40, $E6, $2D, $D0, $02, $E6, $2E, $60, $CE, $A7, $02, $D0, $11, $AD, $A8
    .byte $02, $8D, $A7, $02, $A0, $00, $B1, $2D, $C9, $FF, $D0, $05, $20, $23, $BF, $68
    .byte $68, $60, $A9, $04, $8D, $A3, $02, $8D, $A7, $02, $8D, $A2, $02, $A9, $00, $AA
    .byte $20, $41, $C4, $A2, $3E, $A9, $38, $4C, $4F, $C4, $A9, $0A, $8D, $A4, $02, $8D
    .byte $A7, $02, $A9, $42, $A2, $00, $20, $48, $C4, $A2, $BB, $A9, $08, $4C, $56, $C4
    .byte $A9, $04, $8D, $A5, $02, $8D, $A7, $02, $8D, $A2, $02, $A9, $84, $A2, $8A, $20
    .byte $41, $C4, $A2, $7E, $A9, $38, $4C, $4F, $C4, $A9, $10, $8D, $A6, $02, $8D, $A8
    .byte $02, $A9, $0C, $8D, $A7, $02, $A9, $04, $8D, $0C, $40, $A9, $08, $8D, $0F, $40
    .byte $AD, $A7, $02, $8D, $0E, $40, $AD, $A7, $02, $C9, $0F, $F0, $03, $EE, $A7, $02
    .byte $CE, $A8, $02, $D0, $03, $4C, $23, $BF, $60, $A9, $70, $85, $2D, $A9, $C4, $85
    .byte $2E, $A9, $01, $8D, $A7, $02, $CE, $A7, $02, $D0, $ED, $A0, $00, $B1, $2D, $C9
    .byte $FF, $F0, $E2, $8D, $A7, $02, $8D, $A3, $02, $8D, $A4, $02, $8D, $A5, $02, $8D
    .byte $A6, $02, $20, $EE, $C0, $A2, $00, $20, $B9, $C1, $20, $B9, $C1, $A0, $00, $B1
    .byte $2D, $F0, $25, $0A, $A8, $AD, $A7, $02, $E0, $08, $F0, $05, $4A, $09, $C0, $D0
    .byte $01, $0A, $9D, $00, $40, $A9, $00, $9D, $01, $40, $B9, $2C, $C9, $9D, $02, $40
    .byte $B9, $2D, $C9, $09, $08, $9D, $03, $40, $E8, $E8, $E8, $E8, $4C, $EE, $C0, $A9
    .byte $18, $8D, $A4, $02, $A9, $10, $8D, $A7, $02, $8D, $A2, $02, $A9, $A0, $A2, $9B
    .byte $20, $48, $C4, $A2, $FE, $A9, $19, $4C, $56, $C4, $A9, $08, $8D, $A4, $02, $8D
    .byte $A7, $02, $A9, $C0, $A2, $83, $20, $48, $C4, $A2, $60, $A9, $08, $4C, $56, $C4
    .byte $A9, $18, $8D, $A6, $02, $A9, $04, $8D, $0E, $40, $A9, $0F, $8D, $A7, $02, $A9
    .byte $00, $8D, $A8, $02, $AD, $A7, $02, $C9, $10, $F0, $25, $09, $10, $8D, $0C, $40
    .byte $A9, $28, $8D, $0F, $40, $AD, $A8, $02, $F0, $04, $EE, $A7, $02, $60, $AD, $A7
    .byte $02, $C9, $02, $90, $07, $CE, $A7, $02, $CE, $A7, $02, $60, $EE, $A8, $02, $60
    .byte $A9, $10, $8D, $0C, $40, $4C, $23, $BF, $A9, $03, $8D, $A8, $02, $A9, $FF, $8D
    .byte $A4, $02, $A9, $00, $8D, $A7, $02, $AD, $A7, $02, $D0, $27, $AD, $A8, $02, $D0
    .byte $08, $A9, $00, $8D, $A4, $02, $4C, $23, $BF, $CE, $A8, $02, $A9, $84, $A2, $8B
    .byte $20, $48, $C4, $AC, $A8, $02, $BE, $A3, $C2, $A9, $10, $20, $56, $C4, $A9, $04
    .byte $8D, $A7, $02, $CE, $A7, $02, $60
    .incbin "assets/generated/audio/sfx/prg2-tone-low.bin", $0, $4  ; rom-asset .byte
    .byte $A0, $14, $A9, $04, $A2
    .byte $03, $8C, $A4, $02, $8D, $A7, $02, $8E, $A9, $02, $A9, $01, $8D, $A8, $02, $CE
    .byte $A8, $02, $D0, $26, $AD, $A7, $02, $30, $22, $18, $6D, $A9, $02, $0A, $A8, $A9
    .byte $DF, $A2, $8C, $20, $48, $C4, $B9, $EA, $C2, $AA, $B9, $EB, $C2, $09, $88, $20
    .byte $56, $C4, $CE, $A7, $02, $A9, $04, $8D, $A8, $02, $60, $4C, $23, $BF
    .incbin "assets/generated/audio/sfx/prg2-pitch-periods.bin", $0, $2  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg2-pitch-periods.bin", $2, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg2-pitch-periods.bin", $12, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg2-pitch-periods.bin", $22, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg2-pitch-periods.bin", $32, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg2-pitch-periods.bin", $42, $8  ; rom-asset .byte
    .byte $A9, $10, $8D, $A5, $02, $A9, $40, $8D
    .byte $A7, $02, $A9, $01, $8D, $A8, $02, $A9, $30, $8D, $A9, $02, $A0, $01, $AE, $A7
    .byte $02, $A9, $08, $20, $5D, $C4, $AD, $A7, $02, $38, $ED, $A8, $02, $8D, $A7, $02
    .byte $CD, $A9, $02, $D0, $03, $4C, $23, $BF, $60, $A9, $0E, $8D, $A4, $02, $A9, $06
    .byte $8D, $A7, $02, $8D, $A8, $02, $A9, $9F, $A2, $8D, $20, $48, $C4, $A2, $00, $A9
    .byte $89, $4C, $56, $C4, $CE, $A7, $02, $D0, $20, $AD, $A8, $02, $F0, $18, $A9, $08
    .byte $8D, $A7, $02, $A9, $00, $8D, $A8, $02, $A9, $9F, $A2, $8C, $20, $48, $C4, $A2
    .byte $80, $A9, $88, $4C, $56, $C4, $4C, $23, $BF, $60, $A0, $34, $A9, $0C, $A2, $18
    .byte $4C, $AD, $C2, $A9, $20, $8D, $A4, $02, $A9, $1F, $A2, $85, $20, $48, $C4, $A2
    .byte $69, $A9, $08, $20, $56, $C4, $A9, $02, $8D, $A7, $02, $A9, $01, $8D, $A8, $02
    .byte $CE, $A8, $02, $D0, $76, $A9, $04, $8D, $A8, $02, $AC, $A7, $02, $B9, $E7, $C3
    .byte $8D, $04, $40, $CE, $A7, $02, $10, $63, $4C, $23, $BF, $00, $A9, $00, $8D, $A7
    .byte $02, $A9, $01, $8D, $A8, $02, $CE, $A8, $02, $D0, $20, $AD, $A7, $02, $49, $04
    .byte $8D, $A7, $02, $A8, $B9, $2C, $C4, $8D, $A8, $02, $A9, $DF, $BE, $29, $C4, $20
    .byte $41, $C4, $BE, $2A, $C4, $B9, $2B, $C4, $4C, $4F, $C4, $60, $A9, $08, $D0, $CE
    .byte $A9, $10, $D0, $CA, $4C, $F2, $C3, $4C, $1C, $C4, $4C, $F2, $C3
    .incbin "assets/generated/audio/sfx/prg2-pulse-control.bin", $0, $2  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg2-pulse-steps.bin", $0, $1  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg2-pulse-steps.bin", $1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg2-pulse-steps.bin", $11, $5  ; rom-asset .byte
    .byte $8D, $00, $40, $8E, $01, $40, $60, $8D, $04, $40, $8E
    .byte $05, $40, $60, $8E, $02, $40, $8D, $03, $40, $60, $8E, $06, $40, $8D, $07, $40
    .byte $60, $8C, $08, $40, $8E, $0A, $40, $8D, $0B, $40, $60, $2C, $31, $2C, $31, $35
    .byte $38, $3D, $41, $FF, $08, $2E, $2B, $27, $08, $30, $2C, $29, $08, $32, $2D, $2A
    .byte $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C
    .byte $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C
    .byte $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C
    .byte $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C
    .byte $03, $33, $2E, $2B, $FF

Bank2_Label_C4C1:
    BMI Bank2_Label_C4E6
    ORA #$80
    STA a:$02AB

Bank2_Func_C4C8:
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

Bank2_Label_C4E6:
    LDX #$00
    JSR Bank2_Func_C5B8
    INX
    JSR Bank2_Func_C5B8
    INX
    INX
    JMP Bank2_Func_C5B8
    .byte $60

Bank2_Func_C4F5:
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
    JSR Bank2_Func_C4C8

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
    JSR Bank2_Func_C604

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

Bank2_Func_C604:
    LDX a:$02FD
    CPX #$03
    BNE Bank2_Label_C613
    LDA a:$02FC
    BEQ Bank2_Label_C613
    JMP Bank2_Label_C719

Bank2_Label_C613:
    JSR Bank2_Func_C91E
    STA a:$02FF
    TAY
    BMI Bank2_Label_C61F
    JMP Bank2_Label_C6FD

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
    .byte $95, $C7, $71, $C8, $AC, $C7, $E5, $C7, $CA, $C7, $0D, $C8, $23, $C8, $36, $C8
    .byte $5B, $C8, $A3, $C8, $E5, $C8, $D5, $C8, $C3, $C8, $F2, $C8, $83, $C8, $5C, $C6
    .byte $FA, $C8

Bank2_Label_C656:
    LDA a:$02FF
    AND #$7F
    BPL Bank2_Label_C660
    JSR Bank2_Func_C91E

Bank2_Label_C660:
    LDX a:$02FD
    STA a:$02AC,X
    LDA a:$02EF,X
    BNE Bank2_Label_C6E7
    LDX a:$02FD
    LDA a:$02AC,X
    STA a:$02FF
    LDX a:$02FD
    CPX #$02
    BEQ Bank2_Label_C6EA
    LDA a:$02F3,X
    AND #$10
    BNE Bank2_Label_C69D
    LDA a:$02F3,X
    AND #$D0
    STA a:$02F3,X
    LDA a:$02FF
    LSR A
    CMP #$10
    BCC Bank2_Label_C694
    LDA #$0F

Bank2_Label_C694:
    ORA a:$02F3,X
    STA a:$02F3,X
    JMP Bank2_Label_C6A8

Bank2_Label_C69D:
    LDY a:$02FF
    LDA a:$C9F3,Y
    ORA #$80
    STA a:$02BC,X

Bank2_Label_C6A8:
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
    JMP Bank2_Func_C604

Bank2_Label_C6EA:
    LDA a:$02FF
    ASL A
    BMI Bank2_Label_C6F5
    ADC a:$02FF
    BPL Bank2_Label_C6F7

Bank2_Label_C6F5:
    LDA #$7F

Bank2_Label_C6F7:
    STA a:$02F5
    JMP Bank2_Label_C6E7

Bank2_Label_C6FD:
    CMP #$00
    BNE Bank2_Label_C704
    JMP Bank2_Label_C78C

Bank2_Label_C704:
    LDX a:$02FD
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
    STA a:$400C,Y
    INX
    INY
    CPY #$04
    BCC Bank2_Label_C72B
    LDA a:$02F6
    AND #$10
    BEQ Bank2_Label_C77E
    LDA a:$02F6
    AND #$1F
    STA a:$400C
    BPL Bank2_Label_C77E

Bank2_Label_C748:
    LDY a:$02A3,X
    BNE Bank2_Label_C78C
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
    ADC a:$C9C0,X
    CLC
    ADC $D3,X
    CLC
    ADC a:$02EC,X
    ASL A
    TAX
    LDA a:$C92C,X
    STA a:$4002,Y
    LDA a:$C92D,X
    LDX a:$02FD
    ORA a:$02F7,X
    STA a:$4003,Y

Bank2_Label_C77E:
    LDX a:$02FD
    LDA a:$02EF,X
    BNE Bank2_Label_C78C
    LDA a:$02B4,X
    STA a:$02B8,X

Bank2_Label_C78C:
    LDX a:$02FD
    LDA a:$02AC,X
    STA a:$02B0,X
    RTS
    .byte $AE, $FD, $02, $A9, $01, $9D, $B0, $02, $8A, $0A, $AA, $B5, $2F, $D0, $02, $D6
    .byte $30, $D6, $2F, $EE, $FE, $02, $60, $20, $1E, $C9, $AE, $FD, $02, $9D, $D4, $02
    .byte $A9, $01, $9D, $D8, $02, $8A, $0A, $AA, $B5, $2F, $9D, $C4, $02, $B5, $30, $9D
    .byte $C5, $02, $4C, $04, $C6, $20, $1E, $C9, $AE, $FD, $02, $DD, $D8, $02, $B0, $0D
    .byte $8A, $0A, $AA, $BD, $CC, $02, $95, $2F, $BD, $CD, $02, $95, $30, $4C, $04, $C6
    .byte $AE, $FD, $02, $BD, $D8, $02, $DD, $D4, $02, $B0, $1A, $FE, $D8, $02, $8A, $0A
    .byte $AA, $B5, $2F, $9D, $CC, $02, $B5, $30, $9D, $CD, $02, $BD, $C4, $02, $95, $2F
    .byte $BD, $C5, $02, $95, $30, $4C, $04, $C6, $20, $1E, $C9, $AE, $FD, $02, $9D, $C0
    .byte $02, $BD, $B4, $02, $9D, $B8, $02, $A9, $FF, $9D, $EF, $02, $D0, $32, $AE, $FD
    .byte $02, $A9, $00, $9D, $EF, $02, $BD, $F3, $02, $29, $CF, $9D, $F3, $02, $4C, $6B
    .byte $C6, $20, $1E, $C9, $AE, $FD, $02, $E0, $02, $F0, $A2, $29, $C0, $8D, $FF, $02
    .byte $BD, $F3, $02, $29, $10, $0D, $FF, $02, $9D, $F3, $02, $BD, $EF, $02, $F0, $DE
    .byte $BD, $C0, $02, $4C, $71, $C6, $20, $62, $C8, $4C, $04, $C6, $AD, $FD, $02, $0A
    .byte $AA, $B5, $2F, $9D, $DC, $02, $B5, $30, $9D, $DD, $02, $60, $AD, $FD, $02, $0A
    .byte $AA, $BD, $DC, $02, $95, $2F, $BD, $DD, $02, $95, $30, $4C, $04, $C6, $AD, $AA
    .byte $02, $0A, $0A, $38, $E9, $04, $18, $6D, $FD, $02, $0A, $A8, $AD, $FD, $02, $0A
    .byte $AA, $B9, $F3, $CA, $95, $2F, $B9, $F4, $CA, $95, $30, $4C, $04, $C6, $20, $1E
    .byte $C9, $48, $20, $1E, $C9, $48, $AD, $FD, $02, $0A, $AA, $B5, $2F, $9D, $E4, $02
    .byte $B5, $30, $9D, $E5, $02, $68, $95, $30, $68, $95, $2F, $4C, $04, $C6, $AD, $FD
    .byte $02, $0A, $AA, $BD, $E4, $02, $95, $2F, $BD, $E5, $02, $95, $30, $4C, $04, $C6
    .byte $20, $1E, $C9, $AE, $FD, $02, $E0, $03, $F0, $03, $9D, $EC, $02, $4C, $04, $C6
    .byte $20, $1E, $C9, $A2, $02, $95, $D3, $CA, $10, $FB, $4C, $04, $C6, $AE, $FD, $02
    .byte $A9, $08, $4C, $E4, $C6, $20, $1E, $C9, $AE, $FD, $02, $9D, $B4, $02, $9D, $B8
    .byte $02, $4A, $4A, $4A, $4A, $8D, $FF, $02, $BD, $F3, $02, $29, $C0, $09, $10, $0D
    .byte $FF, $02, $9D, $F3, $02, $4C, $04, $C6

Bank2_Func_C91E:
    LDA a:$02FD
    ASL A
    TAX
    LDA ($2F,X)
    INC $2F,X
    BNE Bank2_Label_C92B
    INC $30,X

Bank2_Label_C92B:
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
    .byte $01, $01, $01, $01, $01, $01, $01, $33, $CB, $DA, $CB, $AF, $CC, $B6, $CD, $18
    .byte $CF, $23, $CF, $2A, $CF, $6A, $D6, $62, $CF, $81, $CF, $A0, $CF, $6A, $D6, $62
    .byte $CF, $81, $CF, $C1, $CF, $6A, $D6, $3F, $D0, $39, $D1, $FE, $D1, $69, $D2, $91
    .byte $D2, $C2, $D3, $E3, $D4, $6A, $D6, $9C, $D5, $C2, $D5, $E7, $D5, $09, $D6, $1C
    .byte $D6, $38, $D6, $4A, $D6, $6A, $D6
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $0, $9  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $19, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $29, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $39, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $49, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $59, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $69, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $79, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $89, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $99, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $A9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $B9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $C9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $D9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $E9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $F9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $109, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $119, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $129, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $139, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $149, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $159, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $169, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $179, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $189, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $199, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $1A9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $1B9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $1C9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $1D9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $1E9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $1F9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $209, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $219, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $229, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $239, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $249, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $259, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $269, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $279, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $289, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $299, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $2A9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $2B9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $2C9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $2D9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $2E9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $2F9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $309, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $319, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $329, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $339, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $349, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $359, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $369, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $379, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $389, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $399, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $3A9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $3B9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $3C9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $3D9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $3E9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $3F9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $409, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $419, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $429, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $439, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $449, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $459, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $469, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $479, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $489, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $499, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $4A9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $4B9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $4C9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $4D9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $4E9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $4F9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $509, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $519, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $529, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $539, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $549, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $559, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $569, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $579, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $589, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $599, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $5A9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $5B9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $5C9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $5D9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $5E9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $5F9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $609, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $619, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $629, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $639, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $649, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $659, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $669, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $679, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $689, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $699, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $6A9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $6B9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $6C9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $6D9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $6E9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $6F9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $709, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $719, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $729, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $739, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $749, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $759, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $769, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $779, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $789, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $799, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $7A9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $7B9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $7C9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $7D9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $7E9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $7F9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $809, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $819, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $829, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $839, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $849, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $859, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $869, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $879, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $889, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $899, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $8A9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $8B9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $8C9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $8D9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $8E9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $8F9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $909, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $919, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $929, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $939, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $949, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $959, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $969, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $979, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $989, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $999, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $9A9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $9B9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $9C9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $9D9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $9E9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $9F9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $A09, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $A19, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $A29, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $A39, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $A49, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $A59, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $A69, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $A79, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $A89, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $A99, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $AA9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $AB9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $AC9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $AD9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $AE9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $AF9, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $B09, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $B19, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg2-cb33.bin", $B29, $F  ; rom-asset .byte
    .byte $00
    .byte $00, $00, $01, $00, $01, $00, $00, $04, $00, $01, $00, $01, $00, $01, $00, $03
    .byte $00, $06, $00, $01, $00, $01, $00, $01, $00, $01, $01, $00, $00, $03, $02, $00
    .byte $03, $00, $04, $00, $00, $00, $08, $08, $03, $04, $00, $01, $04, $04, $0A, $01
    .byte $00, $01, $00, $08, $04, $0A, $0A, $03, $02, $02, $00, $00, $04, $04, $0C, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $04, $00
    .byte $00, $00, $00, $00, $03, $04, $04, $00, $00, $00, $00, $00, $03, $03, $00, $00
    .byte $04, $00, $04, $00, $04, $00, $04, $04, $00, $04, $00, $04, $00, $04, $00, $00
    .byte $04, $00, $04, $00, $04, $00, $04, $04, $00, $04, $00, $04, $00, $04, $00, $00
    .byte $04, $00, $04, $00, $04, $07, $04, $04, $00, $04, $00, $04, $01, $01, $01, $00
    .byte $04, $00, $04, $00, $01, $01, $01, $04, $00, $04, $07, $04, $01, $01, $00, $05
    .byte $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
    .byte $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
    .byte $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
    .byte $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $01
    .byte $03, $03, $03, $05, $05, $05, $00, $01, $05, $05, $05, $05, $05, $05, $05, $05
    .byte $00, $FA, $07, $07, $07, $00, $00, $09, $09, $09, $09, $09, $00, $09, $64, $09
    .byte $09, $00, $04, $09, $00, $09, $01, $01, $0B, $04, $0B, $0B, $0B, $0B, $01, $0B
    .byte $0B, $0B, $0B, $01, $00, $01, $01, $0B, $64, $64, $0B, $00, $00, $0B, $01, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0B, $00
    .byte $00, $00, $00, $00, $0B, $0B, $0B, $00, $00, $00, $00, $00, $0B, $0B, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $02, $00, $02, $00, $02, $00, $02, $00, $00
    .byte $04, $00, $04, $00, $04, $00, $04, $04, $00, $04, $00, $04, $00, $04, $00, $00
    .byte $06, $00, $06, $00, $06, $01, $06, $06, $00, $06, $00, $06, $00, $08, $00, $00
    .byte $08, $00, $08, $00, $00, $00, $00, $08, $00, $08, $01, $08, $00, $00, $00, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $00, $00, $01, $01, $01, $00, $00, $01, $01, $01, $01, $01, $01, $01, $00, $01
    .byte $01, $00, $01, $01, $01, $00, $00, $01, $00, $00, $01, $01, $00, $00, $00, $01
    .byte $01, $01, $01, $01, $00, $00, $00, $01, $01, $01, $01, $01, $00, $00, $00, $0F
    .byte $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $07
    .byte $07, $03, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $03, $05
    .byte $05, $05, $05, $05, $05, $05, $00, $00, $05, $05, $05, $05, $03, $03, $01, $03
    .byte $03, $03, $03, $00, $03, $01, $01, $03, $03, $03, $03, $03, $03, $03, $01, $0A
    .byte $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $07
    .byte $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $05
    .byte $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $04, $04, $03, $03
    .byte $03, $03, $03, $03, $04, $03, $03, $03, $03, $03, $03, $03, $04, $04, $03, $0A
    .byte $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $07
    .byte $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $05
    .byte $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $03
    .byte $03, $03, $03, $03, $05, $05, $05, $03, $03, $03, $03, $03, $05, $05, $05, $64
    .byte $64, $64, $64, $64, $64, $64, $64, $64, $64, $64, $64, $64, $64, $64, $64, $50
    .byte $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50
    .byte $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50
    .byte $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $07
    .byte $0B, $0C, $19, $02, $11, $14, $17, $22, $27, $28, $34, $3F, $18, $19, $1A, $1B
    .byte $17, $17, $17, $17, $17, $14, $15, $16, $1F, $A0, $60, $A0, $80, $80, $60, $90
    .byte $A0, $40, $A0, $A0, $C0, $84, $40, $60, $A0, $80, $50, $28, $90, $30, $40, $C0
    .byte $C0, $C0, $78, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $CC, $D9, $F4, $D9, $6B, $DA, $63, $DB, $78, $DB, $D8, $DB, $0F, $DC, $07, $DD
    .byte $08, $DD, $16, $DD, $17, $DD, $39, $DD, $3A, $DD, $BC, $DD, $CE, $DD, $E0, $DD
    .byte $63, $C0, $64, $05, $62, $71, $78, $B2, $C0, $78, $0D, $79, $B0, $E0, $21, $00
    .byte $01, $01, $01, $01, $21, $02, $02, $02, $03, $03, $E0, $04, $03, $03, $02, $02
    .byte $02, $21, $01, $01, $01, $01, $40, $0D, $C0, $C8, $48, $63, $C0, $64, $08, $62
    .byte $80, $04, $C0, $64, $11, $26, $26, $25, $25, $24, $24, $23, $23, $23, $E0, $22
    .byte $22, $22, $22, $21, $21, $21, $21, $E0, $C0, $64, $2D, $20, $20, $20, $20, $31
    .byte $31, $31, $31, $32, $32, $81, $63, $70, $80, $02, $E0, $00, $00, $01, $01, $01
    .byte $01, $02, $02, $E0, $03, $02, $02, $01, $01, $01, $01, $00, $00, $81, $40, $03
    .byte $64, $C0, $64, $4D, $63, $70, $E0, $00, $00, $01, $01, $01, $01, $02, $02, $E0
    .byte $03, $02, $02, $01, $01, $01, $01, $00, $00, $71, $E0, $20, $20, $21, $21, $21
    .byte $21, $22, $22, $E0, $23, $22, $22, $21, $21, $21, $21, $20, $20, $40, $4D, $62
    .byte $70, $C0, $64, $57, $C0, $64, $A6, $C0, $64, $17, $C0, $64, $1D, $C0, $64, $23
    .byte $90, $02, $F0, $90, $02, $F0, $90, $02, $F0, $90, $02, $F0, $90, $02, $F8, $90
    .byte $02, $F8, $90, $01, $FC, $90, $01, $FC, $90, $01, $FE, $90, $01, $FE, $90, $01
    .byte $FF, $90, $01, $00, $90, $01, $00, $90, $01, $01, $90, $01, $02, $90, $01, $02
    .byte $90, $01, $04, $90, $01, $04, $90, $01, $08, $90, $01, $08, $90, $01, $10, $90
    .byte $01, $10, $90, $01, $10, $F1, $C0, $64, $66, $C0, $64, $6C, $C0, $64, $72, $90
    .byte $03, $F0, $90, $03, $F0, $90, $03, $F0, $90, $03, $F0, $90, $02, $F8, $90, $02
    .byte $F8, $90, $02, $FC, $90, $02, $FC, $90, $02, $FE, $90, $02, $FE, $90, $02, $FF
    .byte $90, $02, $00, $90, $02, $00, $90, $02, $01, $90, $02, $02, $90, $02, $02, $90
    .byte $02, $04, $90, $02, $04, $90, $02, $08, $90, $02, $08, $90, $02, $10, $90, $02
    .byte $10, $90, $02, $10, $F1, $C0, $64, $B5, $C0, $64, $BB, $C0, $64, $C1, $90, $05
    .byte $F0, $90, $05, $F0, $90, $05, $F0, $90, $05, $F0, $90, $04, $F8, $90, $04, $F8
    .byte $90, $04, $FC, $90, $04, $FC, $90, $04, $FE, $90, $04, $FE, $90, $04, $FF, $90
    .byte $04, $00, $90, $04, $00, $90, $04, $01, $90, $04, $02, $90, $04, $02, $90, $04
    .byte $04, $90, $04, $04, $90, $04, $08, $90, $04, $08, $90, $04, $10, $90, $04, $10
    .byte $90, $04, $10, $90, $04, $10, $F1, $62, $C0, $64, $05, $61, $71, $78, $B2, $C0
    .byte $78, $0D, $79, $B0, $E0, $80, $05, $01, $21, $81, $40, $0D, $62, $78, $C0, $0A
    .byte $06, $79, $C0, $0A, $0A, $7A, $C2, $10, $C1, $27, $40, $14, $C1, $4D, $40, $3A
    .byte $B2, $80, $10, $E0, $90, $01, $01, $90, $01, $01, $90, $01, $01, $90, $01, $01
    .byte $81, $40, $00, $B0, $80, $10, $E0, $90, $FF, $01, $90, $FF, $01, $90, $FF, $01
    .byte $90, $FF, $01, $81, $40, $00, $B2, $80, $10, $E0, $90, $01, $FF, $90, $01, $FF
    .byte $90, $01, $FF, $90, $01, $FF, $81, $40, $00, $B0, $80, $10, $E0, $90, $FF, $FF
    .byte $90, $FF, $FF, $90, $FF, $FF, $90, $FF, $FF, $81, $40, $00, $61, $C2, $07, $C1
    .byte $16, $40, $0B, $C1, $2C, $40, $21, $B2, $D0, $00, $80, $20, $90, $01, $01, $81
    .byte $40, $00, $B0, $D0, $01, $80, $20, $90, $FF, $01, $81, $40, $00, $B2, $D0, $02
    .byte $80, $20, $90, $01, $FF, $81, $40, $00, $B0, $D0, $03, $80, $20, $90, $FF, $FF
    .byte $81, $40, $00, $7A, $C0, $78, $09, $A0, $70, $58, $40, $0C, $A0, $90, $58, $62
    .byte $70, $C0, $64, $60, $C0, $64, $AC, $C0, $96, $23, $C0, $96, $29, $C0, $96, $2F
    .byte $90, $02, $F0, $90, $02, $F0, $90, $02, $F4, $90, $02, $F4, $90, $02, $F6, $90
    .byte $02, $F6, $80, $04, $90, $01, $FC, $81, $80, $04, $90, $01, $FE, $81, $80, $04
    .byte $90, $01, $FF, $81, $90, $01, $00, $90, $01, $00, $80, $04, $90, $01, $01, $81
    .byte $80, $06, $90, $02, $02, $81, $80, $06, $90, $02, $06, $81, $80, $06, $90, $02
    .byte $0A, $81, $F1, $C0, $96, $7B, $C0, $96, $75, $C0, $96, $6F, $90, $03, $F0, $90
    .byte $03, $F0, $90, $03, $F4, $90, $03, $F4, $90, $03, $F6, $90, $03, $F6, $80, $04
    .byte $90, $02, $FC, $81, $80, $04, $90, $02, $FE, $81, $80, $04, $90, $02, $FF, $81
    .byte $90, $02, $00, $90, $02, $00, $80, $04, $90, $02, $01, $81, $80, $06, $90, $02
    .byte $02, $81, $80, $06, $90, $01, $06, $81, $80, $06, $90, $01, $0A, $81, $F1, $C0
    .byte $96, $C7, $C0, $96, $C1, $C0, $96, $BB, $90, $03, $F0, $90, $03, $F0, $90, $04
    .byte $F4, $90, $04, $F4, $90, $04, $F6, $90, $04, $F6, $80, $04, $90, $02, $FC, $81
    .byte $80, $04, $90, $02, $FE, $81, $80, $04, $90, $02, $FF, $81, $90, $02, $00, $90
    .byte $02, $00, $80, $04, $90, $02, $01, $81, $80, $06, $90, $01, $02, $81, $80, $06
    .byte $90, $01, $06, $81, $80, $06, $90, $01, $0A, $81, $F1, $F0, $C1, $08, $B2, $90
    .byte $00, $00, $40, $00, $B0, $90, $00, $00, $40, $00, $F0, $90, $00, $00, $C0, $0A
    .byte $00, $E0, $90, $00, $00, $90, $00, $00, $90, $00, $00, $90, $00, $00, $90, $00
    .byte $00, $90, $00, $00, $90, $00, $00, $90, $00, $00, $E0, $40, $00, $F0, $78, $61
    .byte $80, $1D, $90, $01, $02, $81, $62, $80, $31, $90, $01, $00, $81, $D0, $01, $62
    .byte $70, $71, $90, $04, $01, $90, $04, $01, $90, $03, $01, $90, $03, $01, $90, $02
    .byte $01, $90, $02, $01, $90, $01, $01, $90, $01, $01, $90, $FF, $01, $90, $FF, $01
    .byte $90, $FE, $01, $90, $FE, $01, $90, $FD, $01, $90, $FD, $01, $90, $FC, $01, $90
    .byte $FC, $01, $90, $FC, $00, $90, $FC, $00, $90, $FC, $FF, $90, $FC, $FF, $90, $FD
    .byte $FF, $90, $FD, $FF, $90, $FE, $FF, $90, $FE, $FF, $90, $FF, $FF, $90, $FF, $FF
    .byte $90, $01, $FF, $90, $01, $FF, $90, $02, $FF, $90, $02, $FF, $90, $03, $FF, $90
    .byte $03, $FF, $90, $04, $FF, $90, $04, $FF, $90, $04, $00, $90, $04, $00, $40, $14
    .byte $79, $61, $80, $1D, $90, $01, $02, $81, $62, $80, $31, $90, $01, $00, $81, $D0
    .byte $01, $F0, $7A, $61, $80, $1D, $90, $01, $02, $81, $62, $80, $31, $90, $01, $00
    .byte $81, $D0, $01, $F0, $7B, $61, $80, $1D, $90, $01, $02, $81, $62, $80, $31, $90
    .byte $01, $00, $81, $D0, $01, $F0

World3_BlockAttributes:
    .byte $00, $02, $02, $00, $00, $02, $01, $02, $02, $02, $02, $02, $02, $02, $01, $02
    .byte $02, $02, $02, $00, $00, $02, $02, $02, $02, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $03, $02, $01, $00, $00, $00, $00
    .byte $01, $01, $01, $01, $00, $00, $00, $00, $01, $01, $01, $01, $01, $00, $01, $01
    .byte $00, $00, $00, $00, $03, $01, $02, $03, $02, $02, $00, $00, $00, $00, $02, $02
    .byte $03, $03, $02, $02, $00, $00, $02, $02, $00, $00, $00, $00, $03, $03, $02, $02
    .byte $02, $02, $00, $03, $03, $03, $03, $03, $03, $03, $03, $02, $02, $02, $03, $03
    .byte $03, $03, $03, $02, $02, $02, $02, $03, $03, $03, $02, $02, $02, $02, $02, $02
    .byte $03, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
    .byte $02, $03, $03, $02, $02, $02, $02, $02, $02, $02, $02, $01, $01, $01, $01, $01
    .byte $00, $01, $00, $03, $02, $03, $01, $01, $01, $01, $01, $01, $01, $01, $00, $01
    .byte $01, $02, $01, $01, $03, $01, $01, $02, $02, $00, $00, $00, $00, $00, $00, $00
    .byte $02, $02, $02, $02, $00, $01, $03, $01, $00, $00, $03, $03, $01, $01, $01, $03
    .byte $00, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

World3_SmallBlocks:
    .byte $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $14, $14, $B4, $B5, $DE, $DF
    .byte $B6, $B7, $DC, $DD, $C2, $C3, $D2, $D3, $C2, $C3, $D2, $D3, $C2, $C7, $D6, $01
    .byte $C2, $C5, $D2, $D4, $C6, $C3, $D7, $D3, $C4, $C3, $01, $D5, $C0, $C1, $D2, $D3
    .byte $E2, $F3, $D0, $D1, $E2, $E3, $F2, $F3, $E2, $E3, $F2, $F3, $E2, $E5, $F4, $01
    .byte $E2, $E4, $F2, $F5, $E7, $E3, $F6, $F3, $E6, $E3, $01, $F7, $EE, $EF, $FE, $FF
    .byte $EC, $ED, $FC, $FD, $C8, $01, $D2, $D9, $EA, $01, $F2, $FB, $01, $CB, $DA, $D3
    .byte $01, $E9, $F8, $F3, $C2, $C5, $D2, $D4, $C6, $C3, $D7, $D3, $C0, $C1, $D2, $D3
    .byte $E2, $F3, $D0, $D1, $C4, $C3, $00, $D5, $C2, $C7, $D6, $00, $00, $CB, $DA, $D3
    .byte $00, $0A, $00, $16, $E2, $E4, $F2, $F5, $E7, $E3, $F6, $F3, $C8, $00, $D2, $D9
    .byte $EA, $00, $F2, $FB, $E6, $E3, $00, $F7, $E2, $E5, $F4, $00, $00, $E9, $F8, $F3
    .byte $0B, $00, $17, $00, $AA, $AB, $BA, $BB, $00, $00, $15, $15, $C9, $CA, $D8, $DB
    .byte $E0, $E1, $F0, $F1, $5C, $E1, $6C, $F1, $E0, $5F, $F0, $6F, $88, $89, $F0, $F1
    .byte $00, $12, $06, $07, $13, $00, $08, $09, $00, $00, $03, $00, $E8, $EB, $F9, $FA
    .byte $4C, $E1, $00, $5D, $6E, $E1, $00, $7F, $E0, $4F, $5E, $00, $E0, $4F, $7C, $00
    .byte $00, $00, $00, $02, $00, $12, $06, $07, $05, $13, $07, $08, $12, $13, $04, $08
    .byte $00, $00, $09, $00, $00, $00, $06, $09, $00, $00, $02, $03, $00, $00, $02, $03
    .byte $E0, $E1, $F0, $F1, $8A, $8B, $9A, $9B, $B5, $8E, $DF, $9E, $8F, $B6, $9F, $8C
    .byte $CF, $DD, $EC, $ED, $0A, $0B, $0C, $0D, $0A, $0B, $0C, $0D, $76, $77, $8D, $9D
    .byte $A8, $A9, $9A, $9B, $8A, $8B, $B8, $B9, $AD, $AE, $FE, $BE, $AF, $9C, $BF, $AC
    .byte $0A, $0B, $16, $17, $0A, $0B, $0E, $0F, $0A, $0B, $16, $17, $0A, $0B, $0E, $0F
    .byte $B4, $B5, $DC, $DD, $B6, $B7, $DE, $DF, $86, $4B, $97, $5B, $A6, $6B, $94, $7B
    .byte $96, $97, $A6, $A7, $E0, $E1, $98, $99, $84, $85, $94, $95, $86, $87, $96, $97
    .byte $7D, $00, $F0, $7E, $00, $4E, $4D, $F1, $A8, $A9, $B8, $B9, $AA, $AB, $BA, $BB
    .byte $00, $00, $50, $51, $00, $00, $31, $31, $A4, $A5, $96, $97, $A6, $A7, $94, $95
    .byte $4A, $85, $5A, $95, $6A, $97, $7A, $A7, $91, $91, $A1, $A1, $00, $00, $52, $53
    .byte $00, $54, $54, $31, $31, $31, $31, $31, $55, $00, $56, $57, $00, $58, $00, $64
    .byte $31, $59, $31, $65, $00, $66, $30, $67, $31, $65, $31, $68, $00, $00, $00, $60
    .byte $00, $00, $61, $62, $00, $00, $62, $63, $69, $74, $79, $40, $31, $75, $31, $40
    .byte $31, $31, $41, $31, $31, $31, $42, $43, $78, $00, $44, $00, $A2, $70, $B2, $93
    .byte $71, $72, $93, $93, $72, $73, $92, $90, $A3, $00, $B3, $00, $45, $46, $33, $34
    .byte $47, $31, $35, $36, $31, $48, $37, $38, $00, $80, $80, $82, $82, $93, $82, $93
    .byte $92, $92, $92, $11, $11, $90, $11, $90, $A1, $81, $A1, $A1, $00, $00, $81, $00
    .byte $49, $3E, $3C, $39, $00, $80, $80, $82, $82, $82, $92, $92, $93, $92, $93, $11
    .byte $11, $11, $11, $11, $90, $90, $90, $90, $90, $A1, $90, $A0, $A0, $81, $A0, $B1
    .byte $85, $2D, $2C, $82, $82, $92, $92, $11, $11, $11, $11, $11, $92, $11, $11, $90
    .byte $90, $90, $B1, $B1, $91, $A0, $A0, $A0, $B1, $B1, $B1, $A1, $A0, $A0, $B1, $B1
    .byte $00, $00, $81, $00, $3F, $6D, $3A, $3B, $32, $00, $3C, $3D, $18, $19, $1C, $1D
    .byte $1A, $1B, $1E, $1F, $20, $20, $00, $21, $20, $20, $21, $00, $00, $21, $20, $20
    .byte $A1, $2E, $B1, $10, $2F, $87, $2E, $97, $21, $00, $20, $20, $21, $21, $20, $20
    .byte $21, $21, $21, $21, $82, $82, $20, $20, $21, $20, $21, $20, $20, $20, $20, $20
    .byte $21, $21, $21, $21, $20, $20, $21, $21, $CE, $CE, $CE, $CE, $31, $31, $31, $31
    .byte $22, $23, $22, $22, $22, $22, $22, $22, $CC, $CC, $20, $20, $20, $20, $C2, $C3
    .byte $D2, $D3, $20, $20, $02, $03, $CD, $CE, $20, $20, $00, $21, $12, $13, $20, $20
    .byte $00, $21, $00, $21, $28, $29, $20, $20, $22, $22, $22, $22, $22, $22, $22, $22
    .byte $00, $20, $00, $00, $AA, $AB, $BA, $BB, $2A, $2B, $28, $29, $CD, $CE, $CD, $CE
    .byte $AA, $AB, $BA, $BB, $28, $29, $28, $29, $82, $82, $82, $82, $00, $00, $CC, $CC
    .byte $24, $25, $26, $27, $00, $00, $02, $03, $20, $20, $20, $21, $20, $20, $21, $20
    .byte $F0, $21, $20, $20, $21, $F1, $20, $20, $20, $20, $21, $21, $21, $21, $20, $20
    .byte $18, $19, $1C, $24, $1A, $1B, $25, $1F, $00, $22, $1C, $1D, $23, $00, $1E, $1F
    .byte $26, $27, $28, $29, $26, $27, $28, $29, $00, $00, $40, $00, $CC, $CC, $29, $29
    .byte $00, $E8, $1C, $1D, $EB, $00, $1E, $1F, $18, $19, $1C, $1D, $1A, $1B, $1E, $1F
    .byte $18, $19, $1C, $24, $1A, $1B, $25, $1F, $00, $00, $2C, $2D, $22, $22, $22, $22
    .byte $88, $22, $98, $99, $26, $27, $28, $29, $22, $22, $22, $22, $22, $22, $22, $22
    .byte $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22
    .byte $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22
    .byte $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22
    .byte $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22
    .byte $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22
    .byte $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22
    .byte $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22
    .byte $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $00, $22, $22, $00, $00
    .byte $22, $22, $00, $00, $22, $22, $00, $00, $22, $22, $00, $00, $22, $22, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $22, $22, $22, $22

World3_BigBlocks:
    .byte $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $02, $02, $00, $00, $03, $04
    .byte $05, $05, $0D, $0D, $06, $06, $0E, $0E, $05, $05, $0C, $0C, $0B, $0B, $0D, $0D
    .byte $05, $08, $0D, $10, $09, $05, $11, $0D, $05, $07, $0F, $01, $0A, $05, $01, $12
    .byte $13, $14, $13, $14, $15, $01, $0D, $16, $01, $17, $18, $0D, $1B, $1B, $0E, $0E
    .byte $06, $06, $1C, $1C, $06, $19, $0E, $21, $1A, $06, $22, $0E, $1D, $06, $00, $25
    .byte $06, $1E, $26, $00, $00, $1F, $27, $0E, $23, $00, $0E, $24, $30, $31, $03, $04
    .byte $00, $00, $38, $32, $39, $3A, $03, $04, $3B, $3C, $03, $04, $00, $00, $3E, $00
    .byte $00, $00, $20, $28, $00, $00, $5B, $5B, $3F, $00, $03, $04, $00, $3D, $03, $04
    .byte $23, $00, $26, $00, $00, $00, $04, $42, $00, $00, $43, $03, $13, $4A, $13, $4A
    .byte $4B, $14, $4B, $13, $44, $14, $13, $14, $13, $14, $44, $14, $00, $00, $4C, $4C
    .byte $00, $45, $00, $00, $4D, $00, $4D, $00, $00, $1F, $00, $25, $00, $1D, $00, $00
    .byte $06, $06, $25, $0E, $06, $06, $0E, $26, $1E, $00, $00, $00, $19, $00, $21, $00
    .byte $00, $1A, $00, $22, $00, $00, $00, $27, $1F, $06, $0E, $0E, $06, $23, $0E, $0E
    .byte $00, $00, $24, $00, $1F, $06, $25, $0E, $06, $23, $0E, $26, $1F, $1B, $0E, $0E
    .byte $06, $06, $25, $1C, $06, $06, $1C, $26, $1B, $23, $0E, $0E, $19, $00, $21, $04
    .byte $00, $1A, $03, $22, $29, $29, $29, $29, $29, $29, $29, $01, $29, $29, $01, $29
    .byte $5B, $5B, $5B, $5B, $5B, $5B, $00, $00, $29, $01, $29, $01, $47, $47, $50, $51
    .byte $01, $29, $01, $29, $00, $47, $00, $51, $00, $47, $50, $51, $5B, $5B, $00, $5B
    .byte $00, $00, $42, $00, $00, $00, $00, $43, $00, $4B, $00, $4B, $4A, $00, $4A, $00
    .byte $00, $00, $03, $00, $13, $00, $13, $00, $00, $14, $00, $14, $00, $00, $00, $04
    .byte $5B, $5B, $5B, $00, $5B, $00, $5B, $00, $00, $5B, $00, $5B, $5B, $00, $5B, $5B
    .byte $00, $5B, $5B, $5B, $00, $00, $54, $54, $40, $40, $41, $41, $00, $00, $56, $57
    .byte $5E, $5F, $5F, $5E, $5A, $5A, $5A, $5A, $5A, $5A, $5A, $00, $5A, $5A, $00, $5A
    .byte $5A, $00, $5A, $00, $00, $5A, $00, $5A, $00, $00, $5A, $5A, $5A, $00, $5A, $5A
    .byte $00, $5A, $5A, $5A, $49, $49, $49, $49, $49, $49, $49, $00, $49, $49, $00, $49
    .byte $49, $00, $49, $00, $00, $49, $00, $49, $00, $00, $49, $49, $49, $00, $49, $49
    .byte $00, $49, $49, $49, $48, $48, $48, $48, $48, $48, $48, $00, $48, $48, $00, $48
    .byte $48, $00, $48, $00, $00, $48, $00, $48, $00, $00, $48, $48, $48, $00, $48, $48
    .byte $00, $48, $48, $48, $41, $41, $41, $41, $41, $41, $41, $00, $41, $41, $00, $41
    .byte $41, $00, $41, $00, $00, $41, $00, $41, $00, $00, $41, $41, $41, $00, $41, $41
    .byte $00, $41, $41, $41, $40, $40, $40, $40, $58, $00, $40, $58, $00, $59, $59, $40
    .byte $34, $40, $00, $35, $40, $36, $37, $00, $2D, $40, $2D, $40, $00, $2D, $56, $2D
    .byte $2E, $00, $2E, $56, $40, $2E, $40, $2E, $2E, $00, $2E, $00, $00, $2D, $00, $2D
    .byte $00, $34, $00, $00, $40, $40, $35, $40, $2B, $2D, $33, $2D, $2E, $2B, $2E, $33
    .byte $00, $00, $2A, $2A, $40, $40, $40, $37, $36, $00, $00, $00, $2F, $2F, $40, $40
    .byte $40, $40, $55, $55, $40, $40, $55, $40, $40, $40, $40, $55, $2F, $40, $40, $40
    .byte $40, $2F, $40, $40, $55, $55, $00, $00, $00, $00, $2F, $2F, $40, $40, $35, $55
    .byte $40, $40, $55, $37, $40, $58, $40, $40, $00, $00, $58, $00, $00, $00, $00, $59
    .byte $59, $40, $40, $40, $2F, $58, $40, $40, $59, $2F, $40, $40, $59, $40, $34, $40
    .byte $40, $58, $40, $36, $5B, $40, $5B, $40, $40, $5B, $40, $5B, $5B, $5B, $5B, $5B
    .byte $61, $5E, $60, $5F, $00, $00, $60, $57, $00, $61, $00, $60, $00, $00, $00, $60
    .byte $00, $00, $52, $00, $52, $00, $53, $00, $5E, $53, $5F, $53, $00, $00, $56, $52
    .byte $00, $81, $88, $89, $82, $83, $8A, $8B, $84, $85, $8C, $8D, $86, $87, $8E, $8F
    .byte $90, $00, $98, $99, $9B, $5A, $5A, $5A, $A1, $5A, $9C, $5A, $9C, $5A, $9C, $5A
    .byte $00, $00, $00, $00, $00, $73, $7A, $7B, $74, $75, $7C, $7D, $76, $00, $7E, $7F
    .byte $5B, $5B, $01, $5B, $97, $9A, $48, $48, $B4, $B4, $B4, $B4, $B4, $B4, $5E, $5F
    .byte $5B, $5B, $5B, $01, $00, $00, $00, $6B, $00, $00, $6C, $6D, $06, $06, $0E, $21
    .byte $97, $9A, $49, $49, $A0, $A0, $A0, $A0, $A0, $A0, $5B, $5B, $5B, $5B, $A0, $A0
    .byte $93, $94, $95, $96, $00, $00, $5C, $5D, $00, $00, $5D, $63, $97, $9A, $5A, $5A
    .byte $00, $5B, $00, $00, $B1, $B1, $B1, $00, $B1, $B1, $00, $B1, $B1, $00, $B1, $B1
    .byte $00, $64, $67, $65, $97, $9A, $41, $41, $65, $65, $65, $65, $66, $2D, $68, $2D
    .byte $00, $59, $58, $2D, $00, $B1, $B1, $B1, $B1, $B1, $00, $00, $00, $00, $B1, $B1
    .byte $69, $65, $6E, $6F, $65, $65, $65, $71, $65, $65, $70, $71, $6A, $2D, $72, $2D
    .byte $00, $61, $60, $57, $5B, $5B, $00, $5B, $00, $00, $5B, $5B, $00, $81, $81, $89
    .byte $77, $78, $C5, $C5, $79, $91, $C5, $C5, $80, $91, $C5, $C5, $92, $2D, $C5, $2D
    .byte $00, $00, $00, $00, $36, $35, $58, $C6, $40, $40, $34, $37, $36, $35, $C6, $59
    .byte $95, $96, $97, $9A, $00, $00, $93, $94, $06, $19, $1C, $26, $BA, $BB, $BF, $BF
    .byte $C0, $C1, $95, $96, $2C, $2F, $37, $37, $2F, $2F, $37, $37, $2F, $2C, $37, $34
    .byte $97, $9A, $5F, $5E, $00, $00, $C2, $C3, $C2, $C3, $95, $96, $19, $00, $21, $56
    .byte $00, $1A, $5E, $22, $58, $B9, $37, $34, $B9, $B9, $2C, $2C, $B9, $59, $37, $34
    .byte $14, $00, $14, $00, $00, $00, $C5, $C5, $C4, $C4, $C4, $C4, $C4, $00, $C4, $00
    .byte $00, $C4, $00, $C4, $B1, $B1, $B1, $B1, $C5, $C5, $C5, $C5, $C8, $C9, $BA, $BB
    .byte $2D, $2E, $2D, $2E, $CA, $CB, $41, $41, $00, $00, $CA, $CB, $CC, $CD, $95, $96
    .byte $06, $06, $1C, $06, $06, $06, $06, $1C, $D1, $D1, $D1, $D1, $BF, $BF, $5F, $5E

World3_Map:
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $0B, $04, $04, $04, $04, $04, $04, $04, $04, $06, $04, $04
    .byte $07, $07, $0D, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
    .byte $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
    .byte $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
    .byte $02, $02, $02, $02, $02, $09, $04, $04, $04, $04, $04, $04, $0A, $01, $0B, $04
    .byte $05, $05, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $12, $05, $05, $04, $04, $04, $08, $01, $01, $01, $09
    .byte $05, $05, $14, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $1C, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $28, $12, $05, $10, $06, $04, $04, $08, $02, $02, $02, $09
    .byte $05, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $1C, $15, $0F, $16, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $1C, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $13, $14, $00, $00, $13, $10, $14, $00, $00, $28, $12
    .byte $05, $14, $00, $00, $00, $1B, $00, $00, $00, $00, $00, $18, $00, $00, $00, $00
    .byte $00, $00, $1B, $00, $15, $0F, $05, $05, $05, $16, $18, $00, $00, $00, $00, $00
    .byte $00, $00, $1B, $00, $00, $18, $00, $00, $00, $00, $15, $0F, $16, $00, $1B, $00
    .byte $00, $1B, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $2A, $05
    .byte $11, $17, $03, $03, $19, $1A, $03, $1F, $19, $1A, $1F, $17, $03, $1F, $1F, $03
    .byte $1F, $19, $1A, $1E, $12, $05, $05, $05, $05, $11, $17, $1F, $48, $00, $49, $17
    .byte $03, $19, $1A, $03, $1E, $17, $03, $1F, $1E, $1F, $12, $05, $11, $19, $1A, $1F
    .byte $19, $1A, $1F, $03, $1E, $03, $03, $03, $03, $03, $03, $03, $48, $00, $49, $12
    .byte $0C, $25, $0C, $26, $0C, $0C, $26, $0C, $0C, $0C, $25, $0C, $26, $0C, $0C, $26
    .byte $0C, $26, $0C, $0C, $0C, $25, $0C, $0C, $0C, $25, $26, $0C, $4B, $00, $4A, $26
    .byte $0C, $26, $25, $0C, $0C, $0C, $25, $0C, $0C, $0C, $0C, $26, $0C, $25, $0C, $0C
    .byte $0C, $26, $0C, $0C, $0C, $0C, $0C, $25, $26, $0C, $0C, $0C, $4B, $00, $4A, $25
    .byte $05, $10, $10, $10, $10, $10, $FC, $05, $05, $FD, $10, $10, $10, $10, $05, $05
    .byte $05, $FD, $10, $10, $10, $10, $10, $FC, $FD, $10, $10, $10, $2F, $00, $30, $05
    .byte $05, $05, $05, $10, $10, $05, $05, $05, $05, $10, $FC, $05, $05, $FD, $FC, $05
    .byte $05, $10, $10, $10, $10, $10, $05, $05, $05, $05, $05, $FD, $2F, $00, $30, $05
    .byte $11, $00, $00, $00, $00, $00, $2B, $2C, $2D, $2E, $00, $00, $00, $00, $13, $2C
    .byte $05, $2F, $00, $00, $00, $00, $00, $2B, $2E, $00, $00, $00, $00, $00, $2B, $2C
    .byte $FD, $10, $14, $00, $00, $13, $10, $10, $14, $00, $2B, $38, $39, $2E, $2B, $38
    .byte $14, $00, $00, $00, $00, $00, $13, $10, $10, $10, $39, $2E, $00, $00, $2B, $2C
    .byte $05, $20, $00, $00, $00, $00, $00, $2B, $2E, $00, $00, $00, $00, $00, $00, $30
    .byte $2D, $2E, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $31, $32
    .byte $33, $34, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $15, $0F, $16, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $30
    .byte $05, $20, $00, $00, $00, $00, $00, $00, $00, $00, $15, $0F, $16, $00, $00, $30
    .byte $2F, $00, $00, $15, $0F, $0F, $16, $00, $00, $00, $00, $00, $00, $00, $30, $05
    .byte $2D, $2E, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $12, $05, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $35
    .byte $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $12, $10, $14, $00, $00, $2B
    .byte $2E, $00, $00, $13, $10, $10, $FC, $0F, $16, $00, $00, $00, $00, $00, $2B, $2C
    .byte $2F, $00, $00, $00, $00, $00, $00, $31, $34, $00, $15, $0F, $0F, $16, $00, $00
    .byte $00, $00, $13, $10, $14, $00, $00, $31, $34, $00, $00, $00, $00, $00, $00, $30
    .byte $11, $00, $00, $00, $00, $00, $00, $37, $0F, $0F, $11, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $2B, $2C, $11, $00, $00, $00, $00, $00, $00, $30
    .byte $2F, $00, $00, $00, $00, $00, $00, $30, $2F, $00, $13, $05, $05, $14, $00, $31
    .byte $34, $00, $00, $00, $00, $00, $00, $30, $2F, $00, $00, $00, $00, $00, $00, $30
    .byte $11, $03, $21, $00, $00, $22, $46, $12, $05, $05, $11, $03, $03, $03, $43, $43
    .byte $43, $46, $03, $03, $03, $03, $46, $3C, $11, $03, $03, $46, $43, $03, $03, $3C
    .byte $3B, $21, $00, $00, $22, $03, $03, $3C, $3B, $03, $46, $12, $11, $43, $03, $3C
    .byte $3B, $43, $43, $03, $03, $03, $46, $3C, $3B, $03, $03, $03, $03, $46, $43, $3C
    .byte $0C, $0C, $23, $00, $00, $24, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
    .byte $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
    .byte $0C, $23, $00, $00, $24, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
    .byte $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
    .byte $05, $05, $11, $00, $00, $12, $05, $05, $3D, $3D, $3D, $3D, $3D, $3D, $3D, $3D
    .byte $79, $79, $79, $95, $92, $9A, $79, $79, $05, $05, $05, $10, $10, $10, $05, $05
    .byte $05, $39, $00, $00, $38, $10, $10, $05, $05, $05, $FD, $10, $10, $FC, $05, $05
    .byte $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $3D, $3D, $3D, $3D, $05, $05
    .byte $05, $FD, $14, $00, $00, $12, $05, $05, $3D, $3E, $01, $01, $01, $01, $3F, $3D
    .byte $87, $91, $85, $DD, $DE, $DF, $89, $86, $05, $2D, $2E, $00, $00, $00, $2B, $38
    .byte $14, $00, $00, $00, $00, $00, $00, $35, $05, $2D, $2E, $00, $00, $2B, $38, $10
    .byte $10, $10, $FC, $05, $05, $FD, $05, $05, $05, $3D, $01, $01, $01, $01, $3D, $05
    .byte $2D, $2E, $00, $31, $37, $2D, $38, $10, $3D, $02, $02, $02, $02, $02, $02, $3D
    .byte $9E, $00, $83, $E5, $E6, $E7, $82, $9D, $05, $2F, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $30, $2D, $2E, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $2B, $38, $39, $2E, $2B, $2C, $3D, $01, $01, $01, $01, $01, $01, $3D
    .byte $36, $00, $00, $30, $2D, $2E, $00, $F2, $F2, $00, $00, $00, $00, $00, $00, $3D
    .byte $87, $00, $84, $ED, $EE, $EF, $8A, $86, $2D, $2E, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $30, $2F, $00, $15, $0F, $0F, $16, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $30, $3D, $01, $01, $01, $01, $01, $01, $3D
    .byte $2F, $00, $00, $2B, $2E, $00, $00, $F2, $F2, $00, $00, $00, $00, $00, $00, $40
    .byte $9E, $96, $00, $00, $00, $00, $00, $9D, $2F, $00, $00, $00, $00, $00, $00, $31
    .byte $34, $00, $00, $00, $00, $00, $00, $35, $2F, $00, $13, $10, $05, $11, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $35, $3D, $02, $02, $02, $02, $02, $02, $3D
    .byte $2F, $00, $00, $00, $00, $00, $2A, $0F, $40, $00, $00, $00, $00, $00, $00, $40
    .byte $79, $87, $00, $00, $00, $00, $00, $86, $2F, $00, $00, $00, $00, $00, $00, $30
    .byte $2F, $00, $00, $00, $00, $00, $00, $30, $36, $00, $00, $00, $13, $05, $16, $15
    .byte $16, $00, $00, $00, $00, $00, $00, $30, $40, $00, $00, $00, $00, $00, $00, $40
    .byte $3B, $03, $21, $00, $00, $00, $22, $12, $40, $03, $03, $03, $03, $03, $03, $40
    .byte $79, $9E, $9F, $9F, $9F, $9F, $9F, $9D, $3B, $03, $21, $00, $00, $22, $03, $3C
    .byte $3B, $03, $03, $03, $03, $03, $03, $3C, $3B, $21, $00, $00, $00, $12, $05, $05
    .byte $11, $03, $1F, $03, $1E, $03, $03, $3C, $40, $1D, $00, $00, $00, $00, $1D, $40
    .byte $0C, $0C, $23, $00, $00, $00, $24, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
    .byte $79, $79, $79, $79, $79, $79, $79, $79, $0C, $0C, $23, $00, $00, $24, $0C, $0C
    .byte $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $23, $00, $00, $00, $24, $0C, $0C
    .byte $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $40, $40, $00, $00, $00, $00, $40, $40
    .byte $05, $05, $11, $00, $00, $00, $12, $05, $05, $FD, $10, $05, $05, $10, $10, $05
    .byte $05, $10, $10, $10, $10, $10, $05, $05, $05, $05, $39, $00, $00, $38, $10, $05
    .byte $05, $05, $FC, $05, $05, $FD, $10, $10, $10, $39, $00, $00, $00, $38, $05, $05
    .byte $05, $FD, $10, $10, $10, $10, $05, $05, $40, $50, $00, $00, $00, $00, $47, $40
    .byte $FD, $10, $14, $00, $00, $00, $13, $FC, $2D, $2E, $00, $13, $14, $00, $00, $13
    .byte $14, $00, $00, $00, $00, $00, $2C, $05, $05, $11, $00, $00, $00, $00, $00, $38
    .byte $10, $14, $2B, $38, $39, $2E, $00, $00, $00, $00, $00, $00, $00, $00, $2C, $05
    .byte $BB, $2E, $00, $00, $00, $00, $12, $10, $50, $00, $00, $00, $00, $00, $00, $47
    .byte $2F, $00, $00, $00, $00, $00, $00, $2B, $2E, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $2B, $38, $10, $14, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $2B, $38
    .byte $E2, $00, $00, $15, $0F, $0F, $14, $00, $00, $00, $00, $00, $00, $00, $00, $83
    .byte $33, $34, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $15, $0F, $0F, $0F, $0F, $0F, $0F, $16, $00, $00, $F2
    .byte $F2, $00, $00, $12, $05, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $83
    .byte $05, $2F, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $31
    .byte $34, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $37
    .byte $3A, $34, $00, $00, $00, $13, $10, $10, $10, $10, $10, $10, $10, $16, $00, $F2
    .byte $F2, $00, $00, $13, $10, $14, $00, $00, $00, $00, $00, $B9, $BA, $00, $00, $83
    .byte $2D, $2E, $00, $00, $00, $00, $00, $31, $34, $00, $00, $00, $00, $00, $00, $35
    .byte $36, $00, $00, $00, $00, $00, $00, $31, $34, $00, $00, $00, $00, $00, $00, $12
    .byte $05, $2F, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $13, $0F, $3A
    .byte $0F, $16, $00, $00, $00, $00, $00, $00, $00, $00, $00, $B1, $B2, $B3, $00, $83
    .byte $3B, $03, $48, $00, $49, $03, $03, $3C, $3B, $03, $03, $03, $03, $03, $03, $3C
    .byte $3B, $03, $03, $03, $03, $03, $03, $3C, $3B, $03, $03, $03, $03, $03, $03, $12
    .byte $05, $3B, $03, $03, $03, $03, $03, $03, $03, $03, $21, $00, $00, $22, $12, $05
    .byte $05, $11, $57, $57, $57, $57, $57, $57, $A7, $00, $D7, $A9, $AA, $AB, $AC, $7F
    .byte $0C, $0C, $4B, $00, $4A, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
    .byte $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
    .byte $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $23, $00, $00, $24, $0C, $0C
    .byte $58, $58, $58, $58, $58, $58, $58, $58, $A6, $00, $A0, $58, $58, $58, $58, $58
    .byte $8E, $8D, $82, $00, $83, $79, $79, $79, $79, $8E, $8C, $79, $79, $79, $8D, $79
    .byte $79, $79, $79, $79, $79, $79, $79, $79, $79, $8E, $8C, $8C, $8C, $8C, $8D, $79
    .byte $8E, $8C, $8C, $8C, $8C, $8C, $8C, $8D, $8E, $8C, $94, $00, $00, $93, $8C, $79
    .byte $79, $8E, $8C, $8C, $8C, $8C, $79, $79, $81, $00, $93, $8C, $8C, $94, $91, $85
    .byte $82, $84, $8A, $00, $84, $93, $8D, $79, $79, $8A, $00, $7C, $8C, $7D, $84, $85
    .byte $79, $B8, $B4, $79, $79, $B8, $B4, $79, $89, $8A, $00, $00, $00, $00, $84, $85
    .byte $9C, $00, $00, $00, $00, $00, $00, $84, $8A, $00, $00, $00, $00, $00, $00, $7E
    .byte $79, $8A, $00, $00, $00, $00, $7C, $79, $81, $00, $00, $00, $00, $C1, $C2, $83
    .byte $82, $00, $00, $00, $00, $00, $84, $93, $94, $00, $00, $00, $00, $00, $00, $9B
    .byte $9E, $01, $01, $9D, $9E, $01, $01, $9D, $82, $00, $00, $00, $00, $00, $97, $98
    .byte $82, $00, $00, $00, $00, $00, $00, $00, $00, $00, $97, $9A, $99, $96, $00, $93
    .byte $94, $00, $00, $00, $00, $00, $00, $7E, $81, $00, $00, $00, $C8, $CA, $CA, $CB
    .byte $82, $00, $00, $00, $00, $00, $00, $FE, $FE, $00, $00, $00, $00, $00, $00, $83
    .byte $87, $01, $01, $86, $87, $01, $01, $86, $9C, $00, $00, $00, $00, $00, $83, $79
    .byte $95, $96, $00, $00, $00, $00, $00, $00, $00, $00, $83, $79, $79, $82, $00, $FE
    .byte $FE, $00, $00, $00, $00, $00, $00, $7E, $81, $00, $00, $00, $D0, $D1, $D2, $D3
    .byte $9C, $00, $00, $00, $00, $00, $00, $FE, $FE, $00, $00, $00, $00, $00, $00, $83
    .byte $40, $02, $02, $40, $40, $02, $02, $40, $82, $00, $00, $00, $00, $00, $84, $85
    .byte $79, $82, $00, $00, $00, $00, $00, $97, $96, $00, $84, $85, $89, $8A, $00, $FE
    .byte $FE, $00, $00, $00, $C5, $CE, $CE, $F5, $81, $00, $00, $F1, $D8, $D9, $DA, $DB
    .byte $82, $00, $00, $00, $00, $00, $7B, $8B, $99, $00, $00, $00, $00, $00, $00, $9B
    .byte $F5, $00, $00, $F5, $F5, $00, $00, $F5, $9C, $00, $00, $00, $00, $00, $00, $83
    .byte $89, $8A, $00, $00, $00, $00, $00, $83, $9C, $00, $97, $98, $95, $96, $00, $98
    .byte $99, $00, $00, $00, $00, $00, $00, $F5, $9F, $9F, $50, $41, $41, $00, $41, $47
    .byte $80, $A7, $00, $00, $A1, $57, $7E, $79, $81, $57, $A7, $00, $00, $A1, $57, $7F
    .byte $F5, $00, $00, $00, $00, $00, $00, $F5, $80, $57, $57, $57, $57, $57, $57, $7F
    .byte $80, $A7, $00, $00, $A1, $57, $57, $7F, $80, $57, $7F, $79, $79, $80, $57, $7E
    .byte $81, $57, $57, $57, $C7, $CF, $CF, $F5, $9F, $9F, $53, $1D, $1D, $1D, $1D, $54
    .byte $58, $A6, $00, $00, $A0, $58, $58, $58, $58, $58, $A6, $00, $00, $A0, $58, $58
    .byte $F5, $00, $00, $00, $00, $00, $00, $F5, $58, $58, $58, $58, $58, $58, $58, $58
    .byte $58, $A6, $00, $00, $A0, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58
    .byte $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58
    .byte $79, $81, $00, $00, $93, $8C, $94, $85, $79, $8E, $94, $00, $00, $93, $8D, $79
    .byte $F5, $00, $00, $00, $00, $00, $00, $F5, $8E, $8C, $8C, $8C, $8C, $8C, $8C, $8C
    .byte $8C, $94, $00, $00, $93, $8C, $8D, $79, $61, $61, $61, $61, $61, $61, $61, $61
    .byte $69, $69, $69, $69, $69, $69, $69, $69, $69, $69, $69, $69, $69, $69, $69, $69
    .byte $79, $7D, $00, $00, $00, $C1, $C2, $83, $89, $8A, $00, $00, $00, $00, $84, $85
    .byte $F5, $00, $00, $00, $00, $00, $00, $F5, $95, $96, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $84, $85, $64, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $69, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $6D
    .byte $81, $00, $00, $00, $C8, $CA, $CA, $CB, $95, $96, $00, $00, $00, $00, $00, $83
    .byte $F5, $00, $00, $00, $CF, $CF, $CF, $F5, $89, $8A, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $83, $64, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $69, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $6D
    .byte $81, $00, $00, $00, $D0, $D1, $D2, $D3, $79, $82, $00, $00, $00, $00, $00, $9B
    .byte $F5, $00, $00, $00, $00, $00, $00, $F5, $9C, $00, $00, $97, $9A, $7A, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $97, $98, $64, $00, $61, $61, $61, $61, $61, $61
    .byte $69, $00, $00, $00, $69, $00, $00, $69, $69, $69, $69, $69, $69, $00, $00, $6D
    .byte $81, $00, $00, $F1, $D8, $D9, $DA, $DB, $79, $9C, $00, $00, $00, $00, $00, $84
    .byte $CE, $CE, $CE, $00, $00, $00, $00, $F5, $82, $00, $00, $84, $93, $7D, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $83, $79, $64, $00, $00, $00, $00, $00, $00, $61
    .byte $69, $00, $00, $00, $00, $00, $00, $69, $69, $00, $00, $00, $00, $00, $00, $6D
    .byte $81, $00, $00, $C5, $CE, $00, $CE, $C6, $89, $8A, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $F5, $9C, $00, $00, $00, $00, $00, $97, $9A
    .byte $99, $00, $00, $00, $00, $00, $84, $85, $64, $EA, $00, $00, $EA, $00, $00, $61
    .byte $69, $E4, $00, $00, $00, $00, $E4, $69, $69, $00, $00, $FB, $00, $00, $FB, $6D
    .byte $81, $57, $57, $C7, $CF, $CF, $CF, $CD, $80, $57, $A1, $A7, $A1, $A7, $A1, $A7
    .byte $57, $57, $57, $57, $57, $57, $57, $F5, $80, $57, $A7, $00, $00, $A1, $7F, $79
    .byte $81, $00, $00, $A1, $57, $57, $57, $7F, $67, $BC, $00, $00, $BC, $66, $66, $61
    .byte $69, $B5, $6E, $6E, $69, $6E, $B5, $69, $69, $6E, $6E, $B5, $00, $00, $B5, $70
    .byte $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58
    .byte $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $A6, $00, $00, $A0, $58, $58
    .byte $94, $00, $00, $A0, $58, $58, $58, $58, $61, $61, $00, $00, $61, $61, $61, $61
    .byte $69, $69, $69, $69, $69, $69, $69, $69, $69, $69, $69, $69, $00, $00, $69, $69
    .byte $79, $8E, $8C, $8C, $79, $79, $79, $79, $79, $79, $8C, $8C, $8C, $8C, $8C, $8D
    .byte $79, $8E, $8C, $8C, $8C, $8C, $8D, $79, $79, $8E, $94, $00, $00, $93, $79, $79
    .byte $99, $00, $00, $93, $8C, $94, $91, $85, $61, $61, $00, $00, $61, $61, $61, $61
    .byte $71, $71, $71, $71, $71, $71, $71, $71, $71, $71, $71, $71, $00, $00, $71, $71
    .byte $89, $8A, $00, $00, $7C, $8C, $79, $79, $79, $7D, $00, $00, $00, $00, $00, $83
    .byte $89, $8A, $00, $00, $00, $00, $84, $93, $94, $8A, $00, $00, $00, $00, $7C, $79
    .byte $81, $00, $00, $00, $00, $C1, $C2, $83, $64, $00, $00, $00, $00, $00, $00, $65
    .byte $74, $00, $00, $00, $00, $00, $00, $75, $74, $00, $00, $00, $00, $00, $00, $75
    .byte $82, $00, $00, $00, $00, $00, $7C, $8C, $7D, $00, $00, $00, $00, $00, $00, $83
    .byte $82, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7E
    .byte $81, $00, $00, $00, $C8, $CA, $CA, $CB, $64, $00, $00, $00, $00, $00, $00, $65
    .byte $74, $00, $00, $00, $00, $00, $00, $75, $74, $00, $00, $00, $00, $00, $00, $75
    .byte $82, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $83
    .byte $82, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7B, $8B, $7A, $00, $7E
    .byte $81, $00, $00, $00, $D0, $D1, $D2, $D3, $61, $61, $61, $61, $61, $00, $00, $65
    .byte $74, $00, $71, $71, $71, $71, $00, $75, $71, $71, $71, $71, $71, $71, $00, $75
    .byte $82, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $84
    .byte $8A, $00, $00, $00, $00, $00, $00, $97, $96, $00, $00, $7C, $8C, $7D, $00, $7E
    .byte $81, $00, $00, $F1, $D8, $D9, $DA, $DB, $64, $00, $00, $00, $00, $00, $00, $65
    .byte $74, $00, $00, $00, $00, $71, $00, $00, $00, $00, $00, $00, $00, $00, $00, $75
    .byte $95, $96, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $9B, $82, $00, $00, $00, $00, $00, $00, $7E
    .byte $81, $00, $00, $C5, $CE, $00, $CE, $C6, $64, $EA, $00, $00, $00, $00, $EA, $65
    .byte $74, $FA, $00, $00, $FA, $71, $00, $00, $00, $00, $00, $00, $00, $00, $00, $75
    .byte $89, $8A, $00, $00, $00, $00, $A1, $57, $57, $57, $57, $57, $57, $57, $57, $57
    .byte $57, $57, $57, $57, $57, $57, $57, $7F, $80, $57, $57, $57, $57, $57, $57, $7E
    .byte $81, $A7, $A1, $C7, $CF, $CF, $CF, $CD, $67, $BC, $00, $00, $00, $00, $BC, $68
    .byte $77, $F9, $00, $00, $F9, $71, $76, $78, $77, $76, $76, $76, $76, $76, $76, $78
    .byte $82, $00, $00, $00, $00, $00, $A0, $58, $58, $58, $58, $58, $58, $58, $58, $58
    .byte $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58
    .byte $58, $58, $58, $58, $58, $58, $58, $58, $61, $61, $00, $00, $00, $00, $61, $61
    .byte $71, $71, $00, $00, $71, $71, $71, $71, $71, $71, $71, $71, $71, $71, $71, $71
    .byte $82, $00, $00, $00, $00, $00, $93, $8C, $8C, $8C, $8C, $8C, $8C, $79, $79, $79
    .byte $79, $79, $8C, $8C, $8C, $8C, $8C, $8C, $8C, $8C, $8C, $8C, $8C, $8C, $79, $79
    .byte $7B, $79, $99, $EE, $7A, $92, $7B, $EE, $59, $59, $00, $00, $00, $00, $59, $59
    .byte $71, $71, $00, $00, $71, $71, $71, $71, $71, $71, $71, $71, $71, $71, $71, $71
    .byte $9C, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7C, $8C, $8C
    .byte $8C, $7D, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7C, $79
    .byte $79, $7D, $7C, $79, $DD, $DE, $DF, $79, $5C, $00, $00, $00, $00, $00, $00, $AE
    .byte $6F, $00, $00, $00, $00, $00, $00, $71, $74, $00, $00, $00, $00, $00, $00, $75
    .byte $95, $96, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7E
    .byte $79, $7A, $00, $7E, $E5, $E5, $E7, $79, $5C, $00, $00, $00, $00, $00, $00, $AF
    .byte $62, $00, $00, $00, $00, $00, $71, $71, $74, $00, $00, $00, $00, $00, $00, $75
    .byte $89, $8A, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7B, $8B, $7A, $00, $00, $7C
    .byte $8C, $91, $00, $F8, $00, $00, $00, $7E, $5C, $00, $00, $59, $59, $00, $00, $AF
    .byte $67, $00, $71, $71, $71, $71, $72, $00, $00, $00, $9F, $41, $41, $9F, $00, $75
    .byte $82, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $B9, $BA, $00, $00, $00
    .byte $00, $00, $00, $B9, $BA, $00, $00, $00, $00, $00, $7C, $8C, $7D, $00, $00, $00
    .byte $00, $00, $00, $7C, $ED, $EE, $EF, $8C, $74, $00, $00, $00, $00, $00, $00, $AF
    .byte $6A, $00, $00, $00, $00, $00, $00, $00, $00, $00, $9F, $D6, $D6, $9F, $00, $75
    .byte $82, $00, $00, $00, $00, $00, $00, $00, $00, $00, $B0, $B1, $B2, $B3, $00, $00
    .byte $00, $00, $00, $B1, $B2, $B3, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $F2, $00, $00, $00, $EA, $00, $00, $00, $00, $EA, $AF
    .byte $6C, $C0, $00, $00, $00, $00, $C0, $78, $74, $00, $FA, $00, $00, $FA, $00, $75
    .byte $80, $57, $57, $57, $57, $57, $57, $57, $57, $57, $A8, $A9, $AA, $AB, $AC, $57
    .byte $57, $57, $A8, $A9, $AA, $AB, $AC, $57, $57, $57, $57, $57, $57, $57, $57, $57
    .byte $57, $57, $57, $57, $A7, $F2, $A1, $57, $5E, $C3, $5E, $5E, $5E, $5E, $C3, $AD
    .byte $6F, $B5, $6E, $6E, $6E, $6E, $B5, $71, $77, $76, $E3, $76, $76, $E3, $76, $78
    .byte $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58
    .byte $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58
    .byte $58, $58, $58, $58, $58, $58, $58, $58, $59, $59, $59, $59, $59, $59, $59, $59
    .byte $71, $71, $71, $71, $71, $71, $71, $71, $71, $71, $71, $71, $71, $71, $71, $71
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

Bank2_Label_FC00:
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
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
Bank2_NmiVector:
    .addr Bank2_Nmi

Bank2_ResetVector:
    .addr Bank2_Reset

Bank2_IrqVector:
    .addr Bank2_Reset
