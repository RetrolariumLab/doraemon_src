; Bank-local sprite and PPU primitives

.macro EmitOamWriter writeIndex, spriteY, spriteTile, spriteAttr, spriteX, capacityReturn
    LDA writeIndex
    .ifnblank capacityReturn
        BMI capacityReturn
    .endif
    ASL A
    TAX
    LDA spriteY
    STA a:OamBuffer,X
    LDA spriteTile
    STA a:$0301,X
    LDA spriteAttr
    STA a:$0302,X
    LDA spriteX
    STA a:$0303,X
    INC writeIndex
    INC writeIndex
    .ifnblank capacityReturn
capacityReturn:
    .endif
    RTS
.endmacro

.macro EmitHealthGauge spriteY, spriteX, spriteAttr, spriteTile, appendOam, subtractFullTile, writePartialTile, fillEmptyTiles, selectFirstTile, emitTile
    LDA PlayerHealthCapacityIndex
    ASL A
    ASL A
    CLC
    ADC #$50
    STA spriteY
    LDA #$EC
    STA spriteX
    LDA #$00
    STA spriteAttr
    LDA #$04
    STA $0A
    LDA PlayerHealth
    STA spriteTile
    LDY #$07

subtractFullTile:
    LDA spriteTile
    SEC
    SBC #$04
    BCC writePartialTile
    STA spriteTile
    LDA #$3F
    STA a:$000A,Y
    DEY
    BPL subtractFullTile
    BMI selectFirstTile

writePartialTile:
    CLC
    ADC #$3F
    STA a:$000A,Y
    DEY
    BMI selectFirstTile
    LDA #$3B

fillEmptyTiles:
    STA a:$000A,Y
    DEY
    BPL fillEmptyTiles

selectFirstTile:
    LDY PlayerHealthCapacityIndex

emitTile:
    LDA a:$000A,Y
    STA spriteTile
    JSR appendOam
    LDA spriteY
    CLC
    ADC #$08
    STA spriteY
    INY
    CPY #$08
    BNE emitTile
.endmacro
