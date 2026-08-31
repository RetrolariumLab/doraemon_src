; Doraemon PRG bank 1 $A612-$A80A
; World 2 scrolling, stage progress, and boss-state services
; Generated deterministically from pinned Ghidra/GhidraNes facts

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
    JSR World2_Audio_QueueEffectWithPriority
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
