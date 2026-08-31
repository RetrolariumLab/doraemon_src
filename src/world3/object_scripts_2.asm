; Doraemon PRG bank 2 $9D19-$A0C3
; World 3 object traversal, animation, and later behavior handlers
; Generated deterministically from pinned Ghidra/GhidraNes facts

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
