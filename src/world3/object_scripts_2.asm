; Doraemon PRG bank 2 $9D19-$A0C3
; World 3 object traversal, animation, and later behavior handlers
; Generated deterministically from pinned Ghidra/GhidraNes facts

World3_RenderEntities:
    LDA World3FormationActive
    BNE Bank2_Label_9D25
    INC World3EntityRenderOrderPhase
    LDA World3EntityRenderOrderPhase
    AND #$01
    BNE Bank2_Label_9D37

Bank2_Label_9D25:
    LDA #$00
    STA $07
    LDA #$08
    STA $06

Bank2_Label_9D2D:
    JSR World3_RenderEntitySlot
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
    JSR World3_RenderEntitySlot
    DEC $07
    DEC $06
    BNE Bank2_Label_9D3F
    RTS

World3_RenderEntitySlot:
    LDX $07
    LDA a:World3EntityState,X
    BEQ Bank2_Label_9DCC
    CMP #$05
    BEQ Bank2_Label_9D71
    CMP #$04
    BEQ Bank2_Label_9D71
    CMP #$01
    BNE Bank2_Label_9D67
    LDA World3StopwatchActive
    BEQ Bank2_Label_9D71
    LDA a:World3EntityType,X
    CMP #$10
    BCS Bank2_Label_9D71

Bank2_Label_9D67:
    LDA a:World3EntityRenderFlags,X
    ORA #$40
    STA World3MetaspriteRenderFlags
    JMP Bank2_Label_9D76

Bank2_Label_9D71:
    LDA a:World3EntityRenderFlags,X
    STA World3MetaspriteRenderFlags

Bank2_Label_9D76:
    LDA a:World3EntityType,X
    TAY
    LDA a:World3_EntityRenderFlagsByType,Y
    ORA World3MetaspriteRenderFlags
    STA World3MetaspriteRenderFlags
    LDA a:World3EntityState,X
    CMP #$04
    BNE Bank2_Label_9D8E
    LDA World3MetaspriteRenderFlags
    AND #$DF
    STA World3MetaspriteRenderFlags

Bank2_Label_9D8E:
    LDA a:World3EntityState,X
    CMP #$05
    BNE Bank2_Label_9DAE
    LDA a:World3EntityMetasprite,X
    STA World3MetaspriteIndex
    LDA a:World3EntityY,X
    SEC
    SBC #$08
    TAY
    LDA a:World3EntityX,X
    SEC
    SBC #$08
    TAX
    JSR World3_SetMetaspriteOriginFromXY
    JMP Bank2_Label_9DC9

Bank2_Label_9DAE:
    JSR World3_EntityRenderHookNoOp
    LDA a:World3EntityMetasprite,X
    CLC
    ADC a:World3EntityMetaspriteVariantBit1,X
    CLC
    ADC a:World3EntityMetaspriteVariantBit0,X
    STA World3MetaspriteIndex
    LDA a:World3EntityY,X
    TAY
    LDA a:World3EntityX,X
    TAX
    JSR World3_SetMetaspriteOriginFromXY

Bank2_Label_9DC9:
    JSR World3_ComposeMetasprite

Bank2_Label_9DCC:
    RTS

World3_EntityRenderHookNoOp:
    RTS

World3_DormantFaceType03TowardPlayer:
    LDA a:World3EntityType,X
    CMP #$03
    BNE Bank2_Label_9DE4
    LDY #$00
    LDA a:World3EntityX,X
    CMP World3PlayerX
    BCS Bank2_Label_9DE0
    LDY #$02

Bank2_Label_9DE0:
    TYA
    STA a:World3EntityMetaspriteVariantBit1,X

Bank2_Label_9DE4:
    RTS

World3_ProbePlayerLeftEdge:
    LDA World3PlayerY
    STA $00
    LDA #$03
    STA $01
    LDA $00
    CLC
    ADC #$04
    STA $00

Bank2_Label_9DF4:
    LDA World3PlayerX
    CLC
    ADC #$02
    TAX
    LDY $00
    JSR World3_TestPlayerTerrainPoint
    BCC Bank2_Label_9E39
    LDA $00
    CLC
    ADC #$08
    STA $00
    DEC $01
    BNE Bank2_Label_9DF4
    JMP World3_ReturnTerrainPassable

World3_ProbePlayerRightEdge:
    LDA World3PlayerY
    STA $00
    LDA #$03
    STA $01
    LDA $00
    CLC
    ADC #$04
    STA $00

Bank2_Label_9E1E:
    LDA World3PlayerX
    CLC
    ADC #$0E
    TAX
    LDY $00
    JSR World3_TestPlayerTerrainPoint
    BCC Bank2_Label_9E39
    LDA $00
    CLC
    ADC #$08
    STA $00
    DEC $01
    BNE Bank2_Label_9E1E
    JMP World3_ReturnTerrainPassable

Bank2_Label_9E39:
    CLC
    RTS

World3_ProbePlayerTopEdge:
    LDA World3PlayerX
    STA $00
    LDA #$02
    STA $01
    LDA $00
    CLC
    ADC #$04
    STA $00

Bank2_Label_9E4A:
    LDX $00
    LDA World3PlayerY
    CLC
    ADC #$02
    TAY
    JSR World3_TestPlayerTerrainPoint
    BCC Bank2_Label_9E39
    LDA $00
    CLC
    ADC #$08
    STA $00
    DEC $01
    BNE Bank2_Label_9E4A
    JMP World3_ReturnTerrainPassable

World3_ProbePlayerBottomEdge:
    LDA World3PlayerX
    STA $00
    LDA #$02
    STA $01
    LDA $00
    CLC
    ADC #$04
    STA $00

Bank2_Label_9E74:
    LDX $00
    LDA World3PlayerY
    CLC
    ADC #$16
    TAY
    JSR World3_TestPlayerTerrainPoint
    BCC Bank2_Label_9E39
    LDA $00
    CLC
    ADC #$08
    STA $00
    DEC $01
    BNE Bank2_Label_9E74
    JMP World3_ReturnTerrainPassable

World3_ProbePlayerHorizontalMidline:
    LDA World3PlayerX
    STA $00
    LDA #$02
    STA $01
    LDA $00
    CLC
    ADC #$04
    STA $00

Bank2_Label_9E9E:
    LDX $00
    LDA World3PlayerY
    CLC
    ADC #$0C
    TAY
    JSR World3_TestPlayerTerrainPoint
    BCC Bank2_Label_9E39
    LDA $00
    CLC
    ADC #$08
    STA $00
    DEC $01
    BNE Bank2_Label_9E9E
    JMP World3_ReturnTerrainPassable

World3_ProbeCurrentEntityLeftEdge:
    LDA a:World3EntityX,X
    STA $46
    LDA a:World3EntityY,X
    STA $47

World3_ProbeEntityLeftEdge:
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
    JSR World3_TestEntityTerrainPoint
    BCC Bank2_Label_9F29
    LDA $00
    CLC
    ADC #$08
    STA $00
    DEC $01
    BNE Bank2_Label_9ED4
    LDX $44
    JMP World3_ReturnTerrainPassable

World3_ProbeCurrentEntityRightEdge:
    LDA a:World3EntityX,X
    STA $46
    LDA a:World3EntityY,X
    STA $47

World3_ProbeEntityRightEdge:
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
    JSR World3_TestEntityTerrainPoint
    BCC Bank2_Label_9F29
    LDA $00
    CLC
    ADC #$08
    STA $00
    DEC $01
    BNE Bank2_Label_9F0C
    LDX $44
    JMP World3_ReturnTerrainPassable

Bank2_Label_9F29:
    LDX $44
    CLC
    RTS

World3_ProbeCurrentEntityTopEdge:
    LDA a:World3EntityX,X
    STA $46
    LDA a:World3EntityY,X
    STA $47

World3_ProbeEntityTopEdge:
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
    JSR World3_TestEntityTerrainPoint
    BCC Bank2_Label_9F29
    LDA $00
    CLC
    ADC #$08
    STA $00
    DEC $01
    BNE Bank2_Label_9F4A
    LDX $44
    JMP World3_ReturnTerrainPassable

World3_ProbeCurrentEntityBottomEdge:
    LDA a:World3EntityX,X
    STA $46
    LDA a:World3EntityY,X
    STA $47

World3_ProbeEntityBottomEdge:
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
    JSR World3_TestEntityTerrainPoint
    BCC Bank2_Label_9F29
    LDA $00
    CLC
    ADC #$08
    STA $00
    DEC $01
    BNE Bank2_Label_9F82
    LDX $44
    JMP World3_ReturnTerrainPassable

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
    JSR World3_TestEntityTerrainPoint
    BCC Bank2_Label_9FD7
    LDA $00
    CLC
    ADC #$08
    STA $00
    DEC $01
    BNE Bank2_Label_9FBA
    LDX $44
    JMP World3_ReturnTerrainPassable

Bank2_Label_9FD7:
    LDX $44
    CLC
    RTS

World3_ProbeProjectileCenterline:
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
    JSR World3_TestPlayerTerrainPoint
    BCC Bank2_Label_9FD7
    LDA $00
    CLC
    ADC #$08
    STA $00
    DEC $01
    BNE Bank2_Label_9FEC
    LDX $44
    JMP World3_ReturnTerrainPassable

World3_TestEntityTerrainPoint:
    JSR Bank2_Func_A0C4
    STA World3TerrainTile
    CMP #$26
    BCS Bank2_Label_A031
    CMP #$01
    BEQ Bank2_Label_A031
    JMP World3_ReturnTerrainPassable

World3_TestPlayerTerrainPoint:
    JSR Bank2_Func_A0C4
    STA World3TerrainTile
    CMP #$26
    BCC World3_ReturnTerrainPassable
    JSR World3_ApplyDefeatedBossTerrainOverrides
    BCS World3_ReturnTerrainPassable
    JSR World3_ApplyPassingHoopTerrainOverride
    BCS World3_ReturnTerrainPassable
    JSR World3_ApplyFinalRoomTerrainOverride
    BCS World3_ReturnTerrainPassable

Bank2_Label_A031:
    LDA World3TerrainTile
    CLC
    RTS

World3_ReturnTerrainPassable:
    LDA World3TerrainTile
    SEC
    RTS

World3_ApplyFinalRoomTerrainOverride:
    LDA World3FinalCompanionsFreed
    BEQ Bank2_Label_A031
    LDA World3CurrentRoom
    CMP #$3C
    BNE Bank2_Label_A031
    LDA World3TerrainTile
    CMP #$26
    BCC Bank2_Label_A031
    CMP #$2A
    BCC World3_ReturnTerrainPassable
    JMP Bank2_Label_A031

World3_ApplyPassingHoopTerrainOverride:
    LDA World3PassingHoopPortalActive
    BEQ Bank2_Label_A031
    LDA World3TerrainTile
    CMP #$26
    BCC Bank2_Label_A031
    CMP #$2A
    BCC World3_ReturnTerrainPassable
    JMP Bank2_Label_A031

World3_ApplyDefeatedBossTerrainOverrides:
    LDA World3CurrentRoom
    CMP #$27
    BEQ Bank2_Label_A072
    CMP #$28
    BEQ Bank2_Label_A079
    CMP #$34
    BEQ Bank2_Label_A080

Bank2_Label_A06F:
    JMP Bank2_Label_A031

Bank2_Label_A072:
    LDA World3BossRoom27Defeated
    BEQ Bank2_Label_A06F
    JMP Bank2_Label_A087

Bank2_Label_A079:
    LDA World3BossRoom28Defeated
    BEQ Bank2_Label_A06F
    JMP Bank2_Label_A087

Bank2_Label_A080:
    LDA World3BossRoom34Defeated
    BEQ Bank2_Label_A06F
    JMP Bank2_Label_A087

Bank2_Label_A087:
    LDA World3TerrainTile
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
    LDA World3TerrainTile
    SEC
    RTS
