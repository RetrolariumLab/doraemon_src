; Poseidon lower-half anchor tracking and animation

.macro EmitPoseidonLowerHalf returnEntry, addRightOffset
    LDA a:World3EntityFollowAnchorFlag,X
    BEQ returnEntry
    JSR World3_FindActivePoseidonAnchor
    LDA a:World3EntityX,Y
    .if addRightOffset
        CLC
        ADC #$10
    .endif
    STA a:World3EntityX,X
    LDA a:World3EntityY,Y
    CLC
    ADC #$18
    STA a:World3EntityY,X
    INC a:World3EntityFrameCounter,X
    LDA a:World3EntityFrameCounter,X
    LSR A
    LSR A
    LSR A
    AND #$01
    STA a:World3EntityMetaspriteVariantBit0,X
    LDA a:World3EntityFrameCounter,X
    LSR A
    LSR A
    LSR A
    AND #$02
    STA a:World3EntityMetaspriteVariantBit1,X

returnEntry:
    RTS
.endmacro
