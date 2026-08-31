; Doraemon PRG bank 1 $9661-$A0DB
; World 2 metasprite composition, OAM placement, and animation data
; Generated deterministically from pinned Ghidra/GhidraNes facts

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
    STA a:OamBuffer,Y
    INY
    LDA $95
    STA a:OamBuffer,Y
    INY
    LDA $96
    STA a:OamBuffer,Y
    INY
    LDA $97
    STA a:OamBuffer,Y
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
    STA a:AudioMusicState
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
    JSR World2_Audio_QueueEffect
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
    JSR World2_Audio_QueueEffectWithPriority
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
    STA a:AudioMusicState
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
