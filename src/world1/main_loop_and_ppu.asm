; Doraemon PRG bank 0 $827D-$856B
; World 1 initialization, main frame loop, and queued PPU writes
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank0_Func_827D:
    LDA $26

Bank0_Label_8280 = * + 1  ; overlapping entry $8280
    BEQ Bank0_Label_8288
    LDA #$10

Bank0_Label_8283:
    JSR World1_Audio_QueueEffect

Bank0_Label_8286:
    DEC $26

Bank0_Label_8288:
    JSR World1_Audio_UpdateEffects
    JMP World1_Audio_UpdateMusic

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
