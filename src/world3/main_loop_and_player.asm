; Doraemon PRG bank 2 $82AD-$875B
; World 3 initialization, frame loop, player state, and map position
; Generated deterministically from pinned Ghidra/GhidraNes facts

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
    LDA Controller1Buttons
    CMP #$FA
    BNE Bank2_Label_834C
    LDA Controller2Buttons
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
    STA PpuCtrlShadow
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
    STA NmiOamDmaRequest
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
    LDA CombinedControllerButtons
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
    LDA Controller2Buttons
    AND #$02
    BEQ Bank2_Label_8457
    JSR Bank2_Func_A619

Bank2_Label_8457:
    LDA Controller2Buttons
    AND #$01
    BEQ Bank2_Label_8460
    JSR Bank2_Func_A63A

Bank2_Label_8460:
    LDA Controller2Buttons
    AND #$08
    BEQ Bank2_Label_8469
    JSR Bank2_Func_A65D

Bank2_Label_8469:
    LDA Controller2Buttons
    AND #$04
    BEQ Bank2_Label_8472
    JSR Bank2_Func_A688

Bank2_Label_8472:
    LDA Controller2Buttons
    CMP #$C0
    BNE Bank2_Label_8486
    JSR Bank2_Func_AF6F

Bank2_Label_847B:
    LDA Controller2Buttons
    BNE Bank2_Label_847B

Bank2_Label_847F:
    LDA Controller2Buttons
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
    STA a:AudioMusicState
    LDA #$00
    STA a:AudioMusicControl

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
    STA a:AudioMusicControl
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
    STA a:AudioMusicControl
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
    STA a:AudioMusicControl
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
    STA a:AudioMusicState

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
    STA PpuCtrlShadow
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
