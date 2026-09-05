; Doraemon PRG bank 2 $9D19-$A0C3
; World 3 object traversal, animation, and later behavior handlers
; Generated deterministically from pinned Ghidra/GhidraNes facts

World3_RenderEntities:
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
    LDA a:World3EntityState,X
    BEQ Bank2_Label_9DCC
    CMP #$05
    BEQ Bank2_Label_9D71
    CMP #$04
    BEQ Bank2_Label_9D71
    CMP #$01
    BNE Bank2_Label_9D67
    LDA $CB
    BEQ Bank2_Label_9D71
    LDA a:World3EntityType,X
    CMP #$10
    BCS Bank2_Label_9D71

Bank2_Label_9D67:
    LDA a:World3EntityRenderFlags,X
    ORA #$40
    STA $7A
    JMP Bank2_Label_9D76

Bank2_Label_9D71:
    LDA a:World3EntityRenderFlags,X
    STA $7A

Bank2_Label_9D76:
    LDA a:World3EntityType,X
    TAY
    LDA a:World3_EntityRenderFlagsByType,Y
    ORA $7A
    STA $7A
    LDA a:World3EntityState,X
    CMP #$04
    BNE Bank2_Label_9D8E
    LDA $7A
    AND #$DF
    STA $7A

Bank2_Label_9D8E:
    LDA a:World3EntityState,X
    CMP #$05
    BNE Bank2_Label_9DAE
    LDA a:World3EntityMetasprite,X
    STA $79
    LDA a:World3EntityY,X
    SEC
    SBC #$08
    TAY
    LDA a:World3EntityX,X
    SEC
    SBC #$08
    TAX
    JSR Bank2_Func_A71A
    JMP Bank2_Label_9DC9

Bank2_Label_9DAE:
    JSR Bank2_Func_9DCD
    LDA a:World3EntityMetasprite,X
    CLC
    ADC a:World3EntityMetaspriteVariantBit1,X
    CLC
    ADC a:World3EntityMetaspriteVariantBit0,X
    STA $79
    LDA a:World3EntityY,X
    TAY
    LDA a:World3EntityX,X
    TAX
    JSR Bank2_Func_A71A

Bank2_Label_9DC9:
    JSR World3_ComposeMetasprite

Bank2_Label_9DCC:
    RTS

Bank2_Func_9DCD:
    RTS

World3_DormantFaceType03TowardPlayer:
    LDA a:World3EntityType,X
    CMP #$03
    BNE Bank2_Label_9DE4
    LDY #$00
    LDA a:World3EntityX,X
    CMP $8C
    BCS Bank2_Label_9DE0
    LDY #$02

Bank2_Label_9DE0:
    TYA
    STA a:World3EntityMetaspriteVariantBit1,X

Bank2_Label_9DE4:
    RTS

Bank2_Func_9DE5:
    LDA $8D
    STA $00
    LDA #$03
    STA $01
    LDA $00
    CLC
    ADC #$04
    STA $00

Bank2_Label_9DF4:
    LDA $8C
    CLC
    ADC #$02
    TAX
    LDY $00
    JSR Bank2_Func_A019
    BCC Bank2_Label_9E39
    LDA $00
    CLC
    ADC #$08
    STA $00
    DEC $01
    BNE Bank2_Label_9DF4
    JMP Bank2_Func_A035

Bank2_Func_9E0F:
    LDA $8D
    STA $00
    LDA #$03
    STA $01
    LDA $00
    CLC
    ADC #$04
    STA $00

Bank2_Label_9E1E:
    LDA $8C
    CLC
    ADC #$0E
    TAX
    LDY $00
    JSR Bank2_Func_A019
    BCC Bank2_Label_9E39
    LDA $00
    CLC
    ADC #$08
    STA $00
    DEC $01
    BNE Bank2_Label_9E1E
    JMP Bank2_Func_A035

Bank2_Label_9E39:
    CLC
    RTS

Bank2_Func_9E3B:
    LDA $8C
    STA $00
    LDA #$02
    STA $01
    LDA $00
    CLC
    ADC #$04
    STA $00

Bank2_Label_9E4A:
    LDX $00
    LDA $8D
    CLC
    ADC #$02
    TAY
    JSR Bank2_Func_A019
    BCC Bank2_Label_9E39
    LDA $00
    CLC
    ADC #$08
    STA $00
    DEC $01
    BNE Bank2_Label_9E4A
    JMP Bank2_Func_A035

Bank2_Func_9E65:
    LDA $8C
    STA $00
    LDA #$02
    STA $01
    LDA $00
    CLC
    ADC #$04
    STA $00

Bank2_Label_9E74:
    LDX $00
    LDA $8D
    CLC
    ADC #$16
    TAY
    JSR Bank2_Func_A019
    BCC Bank2_Label_9E39
    LDA $00
    CLC
    ADC #$08
    STA $00
    DEC $01
    BNE Bank2_Label_9E74
    JMP Bank2_Func_A035

Bank2_Func_9E8F:
    LDA $8C
    STA $00
    LDA #$02
    STA $01
    LDA $00
    CLC
    ADC #$04
    STA $00

Bank2_Label_9E9E:
    LDX $00
    LDA $8D
    CLC
    ADC #$0C
    TAY
    JSR Bank2_Func_A019
    BCC Bank2_Label_9E39
    LDA $00
    CLC
    ADC #$08
    STA $00
    DEC $01
    BNE Bank2_Label_9E9E
    JMP Bank2_Func_A035

Bank2_Func_9EB9:
    LDA a:World3EntityX,X
    STA $46
    LDA a:World3EntityY,X
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
    LDA a:World3EntityX,X
    STA $46
    LDA a:World3EntityY,X
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
    LDA a:World3EntityX,X
    STA $46
    LDA a:World3EntityY,X
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
    LDA a:World3EntityX,X
    STA $46
    LDA a:World3EntityY,X
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

World3_DormantProbeEntityLowerEdge:
    LDA a:World3EntityX,X
    STA $46
    LDA a:World3EntityY,X
    STA $47
    STX $44
    LDA $46
    STA $00
    LDA #$02
    STA $01
    LDA $00
    CLC
    ADC #$04
    STA $00

Bank2_Label_9FBA:
    LDA $47
    CLC
    ADC #$08
    TAY
    LDX $00
    JSR Bank2_Func_A009
    BCC Bank2_Label_9FD7
    LDA $00
    CLC
    ADC #$08
    STA $00
    DEC $01
    BNE Bank2_Label_9FBA
    LDX $44
    JMP Bank2_Func_A035

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
