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
