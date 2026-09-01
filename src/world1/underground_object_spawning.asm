; Doraemon PRG bank 0 $D770-$D7A8
; World 1 underground transient-object allocation and positioning
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank0_Func_D770:
    LDX #$00

Bank0_Label_D772:
    LDA a:World1EntityType+$1E,X
    BEQ Bank0_Label_D77D
    INX
    CPX #$08
    BNE Bank0_Label_D772
    RTS

Bank0_Label_D77D:
    LDA #$80
    STA a:World1EntityType+$1E,X
    LDA #$00
    STA a:World1EntityPositionHigh+$1E,X
    LDA #$FF
    STA a:World1EntitySourceObjectId+$1E,X
    JSR Bank0_Func_964A
    AND #$1F
    CLC
    ADC a:World1EntityX
    STA a:World1EntityX+$1E,X
    JSR Bank0_Func_964A
    AND #$1F
    CLC
    ADC a:World1EntityY
    STA a:World1EntityY+$1E,X
    RTS
    .byte $0F, $01, $11, $1B
