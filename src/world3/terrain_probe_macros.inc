; Sample terrain along an edge while preserving each caller ABI

.macro EmitPlayerTerrainProbe scanAcrossX, edgeOffset, testPoint
    .if scanAcrossX
        LDA World3PlayerX
    .else
        LDA World3PlayerY
    .endif
    STA $00
    .if scanAcrossX
        LDA #$02
    .else
        LDA #$03
    .endif
    STA $01
    LDA $00
    CLC
    ADC #$04
    STA $00

testPoint:
    .if scanAcrossX
        LDX $00
        LDA World3PlayerY
        CLC
        ADC #edgeOffset
        TAY
    .else
        LDA World3PlayerX
        CLC
        ADC #edgeOffset
        TAX
        LDY $00
    .endif
    JSR World3_TestPlayerTerrainPoint
    BCC Bank2_Label_9E39
    LDA $00
    CLC
    ADC #$08
    STA $00
    DEC $01
    BNE testPoint
    JMP World3_ReturnTerrainPassable
.endmacro

.macro EmitEntityTerrainProbe scanAcrossX, edgeOffset, testPoint, testTerrain, blocked, repeatInitialStore
    STX $44
    .if scanAcrossX
        LDA $46
    .else
        LDA $47
    .endif
    STA $00
    .if repeatInitialStore
        STA $00
    .endif
    LDA #$02
    STA $01
    LDA $00
    CLC
    ADC #$04
    STA $00

testPoint:
    .if scanAcrossX
        LDA $47
        CLC
        ADC #edgeOffset
        TAY
        LDX $00
    .else
        LDA $46
        CLC
        ADC #edgeOffset
        TAX
        LDY $00
    .endif
    JSR testTerrain
    BCC blocked
    LDA $00
    CLC
    ADC #$08
    STA $00
    DEC $01
    BNE testPoint
    LDX $44
    JMP World3_ReturnTerrainPassable
.endmacro
