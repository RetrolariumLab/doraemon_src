; Doraemon PRG bank 2 $B1BB-$B405
; World 3 frame synchronization, PPU buffers, and metatile update helpers
; Generated deterministically from pinned Ghidra/GhidraNes facts

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
