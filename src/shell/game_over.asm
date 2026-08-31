; Doraemon PRG bank 3 $8A17-$8A87
; Returning game-over presentation service
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank3_ShowGameOver:
    JSR Bank3_Func_80DA
    LDA #$03
    JSR Bank3_Func_81AA
    JSR Bank3_Func_9152
    LDA #$21
    STA a:$2006
    LDA #$EB
    STA a:$2006
    LDX #$F7

Bank3_Label_8A2E:
    LDA a:$8988,X
    STA a:$2007
    INX
    BNE Bank3_Label_8A2E
    LDA #$00
    STA $16
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
    STA $09
    LDA #$04
    STA a:$02AA
    JSR Bank3_Func_80FD

Bank3_Label_8A5B:
    JSR Bank3_Func_84D2
    STA $00
    AND #$10
    BNE Bank3_Label_8A70
    LDA a:$02AA
    BNE Bank3_Label_8A5B
    LDA #$00
    STA $3B

Bank3_Label_8A6D:
    JMP Bank3_Func_828F

Bank3_Label_8A70:
    LDA #$00
    STA a:$02AA
    LDA $00
    AND #$0F
    BEQ Bank3_Label_8A6D
    JSR Bank3_Func_80DA
    RTS
    .byte $47, $41, $4D, $45, $00, $4F, $56, $45, $52
