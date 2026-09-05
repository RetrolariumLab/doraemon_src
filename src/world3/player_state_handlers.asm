; Doraemon PRG bank 2 $A21D-$A5DE
; World 3 player-state dispatch, handlers, and interaction state
; Generated deterministically from pinned Ghidra/GhidraNes facts

World3_UpdatePlayerState:
    LDA $8E
    ASL A
    TAX
    LDA a:$A22F,X
    STA $40
    LDA a:$A230,X
    STA $41
    JSR World3_CallIndirect
    RTS

World3_PlayerStateHandlerTable:
    .byte $39, $A2, $35, $A3, $3C, $A3, $E9, $A2, $3A, $A2

Bank2_Func_A239:
    RTS

Bank2_Func_A23A:
    INC $93
    LDA $93
    AND #$07
    BNE Bank2_Label_A248
    LDA $91
    EOR #$01
    STA $91

Bank2_Label_A248:
    LDY $97
    CPY #$0E
    BEQ Bank2_Label_A250
    INC $97

Bank2_Label_A250:
    LDA a:$A563,Y
    BMI Bank2_Label_A25B
    CLC
    ADC $8D
    JMP Bank2_Label_A262

Bank2_Label_A25B:
    CLC
    ADC $8D
    BCS Bank2_Label_A262
    LDA #$00

Bank2_Label_A262:
    STA $8D
    CMP #$F0
    BCC Bank2_Label_A28C

Bank2_Label_A268:
    LDA a:AudioMusicState
    BNE Bank2_Label_A268

Bank2_Label_A26D:
    LDA #$3C
    STA World3FrameWaitCounter
    JSR World3_WaitFrames
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

Bank2_Label_A28C:
    RTS

Bank2_Func_A28D:
    LDA #$00
    STA $53
    JSR World3_SaveRoomObjectsState0
    JSR World3_SaveRoomObjectsState1
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
    STA a:AudioMusicState
    RTS

Bank2_Label_A2BE:
    LDA $DC
    BEQ Bank2_Label_A2C5
    JMP Bank2_Func_8048

Bank2_Label_A2C5:
    JSR Bank2_Func_8065

Bank2_Label_A2C8:
    LDA CombinedControllerButtons
    AND #$10
    BEQ Bank2_Label_A2C8
    JSR Bank2_Func_A2D4
    JMP Bank2_Func_A285

Bank2_Func_A2D4:
    LDX #$00
    LDA #$00

Bank2_Label_A2D8:
    STA a:ScoreDigitsWorking,X
    INX
    CPX #$08
    BNE Bank2_Label_A2D8
    LDA #$02
    STA $2A
    LDA #$02
    STA $2C
    RTS

Bank2_Func_A2E9:
    JSR Bank2_Func_A3B4
    JSR World3_TryFirePlayerProjectile
    LDY $9B
    LDA a:$A32E,Y
    STA $43
    BNE Bank2_Label_A308
    LDA #$01
    STA $8E
    LDY $95
    LDA a:$A485,Y
    STA $90
    LDA #$00
    STA $91
    RTS

Bank2_Label_A308:
    INC $9B
    LDA $95
    BEQ Bank2_Label_A31E

Bank2_Label_A30E:
    JSR Bank2_Func_A49E
    DEC $43
    BNE Bank2_Label_A30E
    LDA #$00
    STA $91
    LDA #$0B
    STA $90
    RTS

Bank2_Label_A31E:
    JSR Bank2_Func_A4B4
    DEC $43
    BNE Bank2_Label_A31E
    LDA #$01
    STA $91
    LDA #$0B
    STA $90
    RTS
    .byte $04, $03, $03, $02, $02, $02, $00

Bank2_Func_A335:
    JSR Bank2_Func_A3B4
    JSR World3_TryFirePlayerProjectile
    RTS

Bank2_Func_A33C:
    JSR Bank2_Func_A343
    JSR World3_TryFirePlayerProjectile
    RTS

Bank2_Func_A343:
    LDY $97
    LDA a:$A39C,Y
    BPL Bank2_Label_A35E
    LDA $8A
    BNE Bank2_Label_A354
    LDA $8D
    CMP #$08
    BCC Bank2_Label_A359

Bank2_Label_A354:
    JSR Bank2_Func_9E3B
    BCS Bank2_Label_A35E

Bank2_Label_A359:
    LDA #$0E
    STA $97
    RTS

Bank2_Label_A35E:
    JSR Bank2_Func_9E8F
    LDA $9E
    CMP #$00
    BNE Bank2_Label_A37B
    LDA #$01
    STA $8E
    LDY $95
    LDA a:$A485,Y
    STA $90
    LDA #$00
    STA $91
    LDA #$0E
    STA $97
    RTS

Bank2_Label_A37B:
    JSR Bank2_Func_A487
    LDY $97
    LDA a:$A39C,Y
    STA $08
    CMP #$04
    BEQ Bank2_Label_A394
    LDA $99
    BEQ Bank2_Label_A392
    DEC $99
    JMP Bank2_Label_A394

Bank2_Label_A392:
    INC $97

Bank2_Label_A394:
    LDA $8D
    CLC
    ADC $08
    STA $8D
    RTS
    .byte $FC, $FD, $FD, $FE, $FE, $FE, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $01, $01
    .byte $01, $01, $02, $02, $02, $03, $03, $04

Bank2_Func_A3B4:
    LDA $92
    BEQ Bank2_Label_A3CE
    INC $93
    LDA $93
    AND #$0F
    BNE Bank2_Label_A3CB
    LDA #$00
    STA $92
    LDY $95
    LDA a:$A485,Y
    STA $90

Bank2_Label_A3CB:
    JMP Bank2_Label_A3E0

Bank2_Label_A3CE:
    INC $93
    LDA $93
    AND $94
    BNE Bank2_Label_A3E0
    LDA $91
    BNE Bank2_Label_A3DE
    LDA #$03
    STA $91

Bank2_Label_A3DE:
    DEC $91

Bank2_Label_A3E0:
    JSR Bank2_Func_A5F7
    AND #$08
    BNE Bank2_Label_A3F2
    LDA #$07
    STA $94

Bank2_Label_A3EB:
    LDA #$00
    STA $61
    JMP Bank2_Label_A42B

Bank2_Label_A3F2:
    LDA $61
    BEQ Bank2_Label_A3FF
    INC $61
    CMP #$0A
    BEQ Bank2_Label_A3EB
    JMP Bank2_Label_A42B

Bank2_Label_A3FF:
    INC $61
    LDA $92
    BNE Bank2_Label_A40C
    LDY $95
    LDA a:$A485,Y
    STA $90

Bank2_Label_A40C:
    LDA #$03
    STA $94
    LDY $97
    CPY #$0E
    BNE Bank2_Label_A41D
    LDA #$00
    STA $99
    JMP Bank2_Label_A427

Bank2_Label_A41D:
    LDA $99
    CMP #$14
    BCS Bank2_Label_A427
    INC $99
    INC $99

Bank2_Label_A427:
    LDA #$00
    STA $97

Bank2_Label_A42B:
    JSR Bank2_Func_A4CE
    JSR Bank2_Func_9E65
    BCS Bank2_Label_A449
    JSR Bank2_Func_A5F7
    AND #$03
    BNE Bank2_Label_A449
    LDA $92
    BNE Bank2_Label_A446
    LDA #$08
    STA $90
    LDA #$00
    STA $91

Bank2_Label_A446:
    JMP Bank2_Label_A457

Bank2_Label_A449:
    JSR Bank2_Func_A5F7
    AND #$02
    BNE Bank2_Label_A45E
    JSR Bank2_Func_A5F7
    AND #$01
    BNE Bank2_Label_A471

Bank2_Label_A457:
    LDA #$00
    STA $96
    JMP Bank2_Label_A481

Bank2_Label_A45E:
    LDA $92
    BNE Bank2_Label_A466
    LDA #$00
    STA $90

Bank2_Label_A466:
    LDA #$00
    STA $95
    LDA #$01
    STA $96
    JMP Bank2_Label_A481

Bank2_Label_A471:
    LDA $92
    BNE Bank2_Label_A479
    LDA #$03
    STA $90

Bank2_Label_A479:
    LDA #$01
    STA $95
    LDA #$01
    STA $96

Bank2_Label_A481:
    JSR Bank2_Func_A487
    RTS
    .byte $00, $03

Bank2_Func_A487:
    INC $9C
    LDA $9C
    AND #$01
    BNE Bank2_Func_A492
    JSR Bank2_Func_A492

Bank2_Func_A492:
    LDA $96
    BEQ Bank2_Label_A49D
    LDA $95
    BEQ Bank2_Func_A49E
    JMP Bank2_Func_A4B4

Bank2_Label_A49D:
    RTS

Bank2_Func_A49E:
    JSR Bank2_Func_9DE5
    BCS Bank2_Label_A4A8
    LDA #$00
    STA $96
    RTS

Bank2_Label_A4A8:
    DEC $8C
    BNE Bank2_Label_A4B3
    LDA #$EC
    STA $8C
    JSR Bank2_Func_A619

Bank2_Label_A4B3:
    RTS

Bank2_Func_A4B4:
    JSR Bank2_Func_9E0F
    BCS Bank2_Label_A4BE
    LDA #$00
    STA $96
    RTS

Bank2_Label_A4BE:
    INC $8C
    LDA $8C
    CMP #$F0
    BNE Bank2_Label_A4CD
    LDA #$04
    STA $8C
    JSR Bank2_Func_A63A

Bank2_Label_A4CD:
    RTS

Bank2_Func_A4CE:
    LDY $97
    CPY #$0E
    BEQ Bank2_Label_A4D6
    INC $97

Bank2_Label_A4D6:
    LDA a:$A563,Y
    STA $A7
    BEQ Bank2_Label_A4E2
    BPL Bank2_Label_A52F
    JMP Bank2_Label_A4E3

Bank2_Label_A4E2:
    RTS

Bank2_Label_A4E3:
    INC $9D
    LDA $9D
    AND #$01
    BNE Bank2_Func_A4EE
    JSR Bank2_Func_A4EE

Bank2_Func_A4EE:
    JSR Bank2_Func_9E3B
    BCS Bank2_Label_A4F8
    LDA #$0E
    STA $97
    RTS

Bank2_Label_A4F8:
    JSR Bank2_Func_9E8F
    LDA $9E
    CMP #$14
    BNE Bank2_Label_A50F
    LDA #$02
    STA $8E
    LDA #$00
    STA $97
    LDA #$0C
    JSR Bank2_Func_A5DF
    RTS

Bank2_Label_A50F:
    LDA $8D
    CLC
    ADC $A7
    STA $8D
    CMP #$08
    BCS Bank2_Label_A526
    LDA $8A
    BNE Bank2_Label_A527
    LDA #$00
    STA $8D
    LDA #$0E
    STA $97

Bank2_Label_A526:
    RTS

Bank2_Label_A527:
    LDA #$D0
    STA $8D
    JSR Bank2_Func_A65D
    RTS

Bank2_Label_A52F:
    JSR Bank2_Func_9E65
    BCS Bank2_Label_A539
    LDA #$00
    STA $96
    RTS

Bank2_Label_A539:
    JSR Bank2_Func_A5F7
    AND #$04
    BNE Bank2_Label_A550
    INC $98
    LDA $98
    CMP #$06
    BCC Bank2_Label_A562
    LDA #$00
    STA $98
    LDA #$01
    STA $A7

Bank2_Label_A550:
    LDA $8D
    CLC
    ADC $A7
    STA $8D
    CMP #$D4
    BCC Bank2_Label_A562
    LDA #$0C
    STA $8D
    JSR Bank2_Func_A688

Bank2_Label_A562:
    RTS
    .byte $FE, $FE, $FE, $FE, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $00, $00, $02

World3_TryFirePlayerProjectile:
    JSR Bank2_Func_A5F7
    AND #$80
    BNE Bank2_Label_A57C
    STA $63

Bank2_Label_A57B:
    RTS

Bank2_Label_A57C:
    LDA $63
    BNE Bank2_Label_A57B
    INC $63
    LDA #$01
    STA $92
    LDA $95
    CLC
    ADC #$09
    STA $90
    LDA #$00
    STA $91
    LDA #$00
    STA $93
    LDX #$00

Bank2_Label_A597:
    LDA a:World3PlayerProjectileState,X
    BEQ Bank2_Label_A5A2
    INX
    CPX #$02
    BNE Bank2_Label_A597
    RTS

Bank2_Label_A5A2:
    LDA $95
    BNE Bank2_Label_A5B1
    LDA $8C
    CMP #$12
    BCC Bank2_Label_A5DE
    LDY #$F8
    JMP Bank2_Label_A5B9

Bank2_Label_A5B1:
    LDA $8C
    CMP #$EE
    BCS Bank2_Label_A5DE
    LDY #$08

Bank2_Label_A5B9:
    TYA
    CLC
    ADC $8C
    STA a:World3PlayerProjectileX,X
    LDA $8D
    CLC
    ADC #$08
    STA a:World3PlayerProjectileY,X
    LDA $95
    STA a:World3PlayerProjectileDirection,X
    ASL A
    CLC
    ADC #$68
    STA a:World3PlayerProjectileMetasprite,X
    LDA #$01
    STA a:World3PlayerProjectileState,X
    LDA #$19
    JSR Bank2_Func_A5DF

Bank2_Label_A5DE:
    RTS
