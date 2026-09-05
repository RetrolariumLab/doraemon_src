; Doraemon PRG bank 0 $A50A-$A87D
; World 1 metatile decoding and incremental nametable streaming
; Generated deterministically from pinned Ghidra/GhidraNes facts

World1_BuildColumnAttributeUpdate:
    PHA
    LDA #$00
    STA $74
    PLA
    AND #$01
    LSR A
    ROR A
    LSR A
    STA $73
    LDA PpuScrollYShadow
    AND #$08
    BEQ Bank0_Label_A52D
    INY
    LDA PpuScrollYShadow
    CLC
    ADC #$08
    CMP #$F0
    BCC Bank0_Label_A52F
    CLC
    ADC #$10
    JMP Bank0_Label_A52F

Bank0_Label_A52D:
    LDA PpuScrollYShadow

Bank0_Label_A52F:
    AND #$F8
    LSR A
    LSR A
    STA $5D
    LSR A
    LSR A
    LSR A
    ROL $74
    LDA $5D
    AND #$38
    ORA $73
    STA $73
    LDA PpuScrollXShadow
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    ROL $74
    ORA $73
    STA $73
    AND #$C7
    STA $5D
    ORA #$C0
    STA a:World1ColumnAttributePpuAddress
    LDA $73
    AND #$40
    LSR A
    LSR A
    LSR A
    LSR A
    ORA #$23
    STA a:World1ColumnAttributePpuAddress+$01
    JSR World1_LookupMapTile
    LDX $73
    LDA #$0F
    STA $5E

Bank0_Label_A56E:
    JSR World1_ReadBlockAttributeAndStepDown
    AND #$03
    TAY
    LDA a:$A7D3,Y
    LDY $74
    AND a:$A7D7,Y
    STA $5F
    LDA a:$A7D7,Y
    EOR #$FF
    AND a:World1AttributeTableCache,X
    ORA $5F
    STA a:World1AttributeTableCache,X
    LDA $74
    EOR #$02
    STA $74
    AND #$02
    BEQ Bank0_Label_A5A9
    TXA
    AND #$38
    CMP #$38
    BNE Bank0_Label_A5AE
    TXA
    AND #$C7
    TAX
    LDA $74
    AND #$01
    STA $74
    JMP Bank0_Label_A5AE

Bank0_Label_A5A9:
    TXA
    CLC
    ADC #$08
    TAX

Bank0_Label_A5AE:
    DEC $5E
    BNE Bank0_Label_A56E
    LDX $5D
    LDY #$00

Bank0_Label_A5B6:
    LDA a:World1AttributeTableCache,X
    STA a:World1ColumnAttributeData,Y
    TXA
    CLC
    ADC #$08
    TAX
    INY
    CPY #$08
    BNE Bank0_Label_A5B6
    LDA a:World1ColumnUpdateFlags
    ORA #$02
    STA a:World1ColumnUpdateFlags
    RTS

World1_BuildRowTileUpdate:
    JSR World1_LookupMapTile
    LDX #$00

Bank0_Label_A5D4:
    JSR World1_ReadMapTileAndStepRight
    STA a:World1RowTileData,X
    INX
    CPX #$21
    BNE Bank0_Label_A5D4
    LDA PpuScrollYShadow
    AND #$F8
    STA a:World1RowTilePpuAddress
    LDA World1NametableX
    AND #$01
    ASL a:World1RowTilePpuAddress
    ROL A
    ASL a:World1RowTilePpuAddress
    ROL A
    ORA #$20
    STA a:World1RowTilePpuAddress+$01
    LDA PpuScrollXShadow
    LSR A
    LSR A
    LSR A
    ORA a:World1RowTilePpuAddress
    STA a:World1RowTilePpuAddress
    LDA a:World1RowUpdateFlags
    ORA #$01
    STA a:World1RowUpdateFlags
    RTS

World1_BuildRowAttributeUpdate:
    TYA
    PHA
    LDA #$00
    STA $74
    LDA World1NametableX
    AND #$01
    LSR A
    ROR A
    LSR A
    STA $73
    LDA PpuScrollYShadow
    AND #$F8
    LSR A
    LSR A
    TAY
    LSR A
    LSR A
    LSR A
    ROL $74
    TYA
    AND #$38
    ORA $73
    STA $73
    LDA PpuScrollXShadow
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    ROL $74
    ORA $73
    STA $73
    ORA #$C0
    STA a:World1RowAttributePpuAddress
    LDA $73
    AND #$40
    LSR A
    LSR A
    LSR A
    LSR A
    ORA #$23
    STA a:World1RowAttributePpuAddress+$01
    PLA
    TAY
    JSR World1_LookupMapTile
    LDX $73
    LDA #$00
    STA $5D
    LDA #$11
    STA $5E

Bank0_Label_A65B:
    JSR World1_ReadBlockAttributeAndStepRight
    AND #$03
    TAY
    LDA a:$A7D3,Y
    LDY $74
    AND a:$A7D7,Y
    STA $5F
    LDA a:$A7D7,Y
    EOR #$FF
    AND a:World1AttributeTableCache,X
    ORA $5F
    STA a:World1AttributeTableCache,X
    LDY $5D
    STA a:World1RowAttributeData,Y
    LDA $74
    EOR #$01
    STA $74
    AND #$01
    BNE Bank0_Label_A69A
    INC $5D
    TXA
    AND #$07
    CMP #$07
    BEQ Bank0_Label_A694
    INX
    JMP Bank0_Label_A69A

Bank0_Label_A694:
    TXA
    AND #$F8
    EOR #$40
    TAX

Bank0_Label_A69A:
    DEC $5E
    BNE Bank0_Label_A65B
    LDA a:World1RowUpdateFlags
    ORA #$02
    STA a:World1RowUpdateFlags
    RTS

World1_LookupMapTile:
    LDA #$00
    STA World1TileQuadrantIndex
    STA World1SmallBlockQuadrantIndex
    STA World1MapRowPointer
    TYA
    LSR A
    ROL World1TileQuadrantIndex
    LSR A
    ROL World1SmallBlockQuadrantIndex
    LSR A
    ROR World1MapRowPointer
    LSR A
    ROR World1MapRowPointer
    STA World1MapRowPointer+$01
    LDA World1MapRowPointer
    CLC
    ADC World1MapDataPointer
    STA World1MapRowPointer
    LDA World1MapRowPointer+$01
    ADC World1MapDataPointer+$01
    STA World1MapRowPointer+$01
    TXA
    LSR A
    ROL World1TileQuadrantIndex
    LSR A
    ROL World1SmallBlockQuadrantIndex
    STA World1MapColumnIndex
    LDY World1MapColumnIndex
    LDA (World1MapRowPointer),Y
    JSR World1_SelectBigBlock
    LDY World1SmallBlockQuadrantIndex
    LDA (World1CurrentBigBlockPointer),Y
    JSR World1_SelectSmallBlock

World1_ReadCurrentMapTile:
    LDY World1TileQuadrantIndex
    LDA (World1CurrentSmallBlockPointer),Y
    TAY
    RTS

World1_ReadMapTileAndStepRight:
    LDY World1TileQuadrantIndex
    LDA (World1CurrentSmallBlockPointer),Y
    PHA
    TYA
    EOR #$01
    STA World1TileQuadrantIndex
    AND #$01
    BNE Bank0_Label_A716
    LDA World1SmallBlockQuadrantIndex
    EOR #$01
    STA World1SmallBlockQuadrantIndex
    AND #$01
    BNE Bank0_Label_A70F
    INC World1MapColumnIndex
    LDA World1MapColumnIndex
    AND #$3F
    STA World1MapColumnIndex
    LDY World1MapColumnIndex
    LDA (World1MapRowPointer),Y
    JSR World1_SelectBigBlock

Bank0_Label_A70F:
    LDY World1SmallBlockQuadrantIndex
    LDA (World1CurrentBigBlockPointer),Y
    JSR World1_SelectSmallBlock

Bank0_Label_A716:
    PLA
    TAY
    RTS

World1_ReadMapTileAndStepDown:
    LDY World1TileQuadrantIndex
    LDA (World1CurrentSmallBlockPointer),Y
    PHA
    TYA
    EOR #$02
    STA World1TileQuadrantIndex
    AND #$02
    BNE Bank0_Label_A74C
    LDA World1SmallBlockQuadrantIndex
    EOR #$02
    STA World1SmallBlockQuadrantIndex
    AND #$02
    BNE Bank0_Label_A745
    LDA World1MapRowPointer
    CLC
    ADC #$40
    STA World1MapRowPointer
    LDA World1MapRowPointer+$01
    ADC #$00
    STA World1MapRowPointer+$01
    LDY World1MapColumnIndex
    LDA (World1MapRowPointer),Y
    JSR World1_SelectBigBlock

Bank0_Label_A745:
    LDY World1SmallBlockQuadrantIndex
    LDA (World1CurrentBigBlockPointer),Y
    JSR World1_SelectSmallBlock

Bank0_Label_A74C:
    PLA
    RTS

World1_ReadBlockAttributeAndStepRight:
    LDY World1SmallBlockQuadrantIndex
    LDA (World1CurrentBigBlockPointer),Y
    TAY
    LDA a:World1_BlockAttributes,Y
    PHA
    LDA World1SmallBlockQuadrantIndex
    EOR #$01
    STA World1SmallBlockQuadrantIndex
    AND #$01
    BNE Bank0_Label_A770
    INC World1MapColumnIndex
    LDA World1MapColumnIndex
    AND #$3F
    STA World1MapColumnIndex
    LDY World1MapColumnIndex
    LDA (World1MapRowPointer),Y
    JSR World1_SelectBigBlock

Bank0_Label_A770:
    PLA
    RTS

World1_ReadBlockAttributeAndStepDown:
    LDY World1SmallBlockQuadrantIndex
    LDA (World1CurrentBigBlockPointer),Y
    TAY
    LDA a:World1_BlockAttributes,Y
    PHA
    LDA World1SmallBlockQuadrantIndex
    EOR #$02
    STA World1SmallBlockQuadrantIndex
    AND #$02
    BNE Bank0_Label_A799
    LDA World1MapRowPointer
    CLC
    ADC #$40
    STA World1MapRowPointer
    LDA World1MapRowPointer+$01
    ADC #$00
    STA World1MapRowPointer+$01
    LDY World1MapColumnIndex
    LDA (World1MapRowPointer),Y
    JSR World1_SelectBigBlock

Bank0_Label_A799:
    PLA
    RTS

World1_SelectSmallBlock:
    ASL A
    ROL World1CurrentSmallBlockPointer+$01
    ASL A
    ROL World1CurrentSmallBlockPointer+$01
    STA World1CurrentSmallBlockPointer
    LDA World1CurrentSmallBlockPointer+$01
    AND #$03
    STA World1CurrentSmallBlockPointer+$01
    LDA #$EF
    CLC
    ADC World1CurrentSmallBlockPointer
    STA World1CurrentSmallBlockPointer
    LDA #$AA
    ADC World1CurrentSmallBlockPointer+$01
    STA World1CurrentSmallBlockPointer+$01
    RTS

World1_SelectBigBlock:
    ASL A
    ROL World1CurrentBigBlockPointer+$01
    ASL A
    ROL World1CurrentBigBlockPointer+$01
    STA World1CurrentBigBlockPointer
    LDA World1CurrentBigBlockPointer+$01
    AND #$03
    STA World1CurrentBigBlockPointer+$01
    LDA #$EF
    CLC
    ADC World1CurrentBigBlockPointer
    STA World1CurrentBigBlockPointer
    LDA #$AE
    ADC World1CurrentBigBlockPointer+$01
    STA World1CurrentBigBlockPointer+$01
    RTS
    .byte $00, $55, $AA, $FF, $03, $0C, $30, $C0

World1_PrefillMapViewport:
    LDA #$00
    STA a:World1EdgeUpdateQueue
    STA a:World1RowUpdateFlags
    STA a:World1ColumnUpdateFlags
    LDA World1CameraTileX
    AND #$01
    ASL A
    ASL A
    ASL A
    STA PpuScrollXShadow
    LDA World1CameraTileY
    AND #$01
    ASL A
    ASL A
    ASL A
    STA PpuScrollYShadow
    LDA #$98
    STA World1MapPrefillCounter
    LDA World1CameraTileY
    BMI Bank0_Label_A84C
    LDA World1CameraTileY
    CLC
    ADC #$26
    STA World1CameraTileY

Bank0_Label_A807:
    LDA #$00
    STA World1ScreenDeltaX
    STA World1ScreenDeltaY
    JSR World1_TryScrollCameraUp
    JSR World1_DrainMapPpuUpdates
    JSR World1_SpawnObjectsAtCameraEdges
    JSR World1_ApplyCameraDeltaToEntities
    LDA #$00
    STA World1ScreenDeltaX
    STA World1ScreenDeltaY
    JSR World1_TryScrollCameraUp
    JSR World1_DrainMapPpuUpdates
    JSR World1_SpawnObjectsAtCameraEdges
    JSR World1_ApplyCameraDeltaToEntities
    DEC World1MapPrefillCounter
    BNE Bank0_Label_A807

Bank0_Label_A82F:
    LDA PpuScrollXShadow
    STA World1PpuScrollXLatched
    LDA PpuScrollYShadow
    STA World1PpuScrollYLatched
    LDA PpuCtrlShadow
    AND #$FE
    STA $5D
    LDA World1NametableX
    AND #$01
    ORA $5D
    STA PpuCtrlShadow
    LDA #$00
    STA World1ScreenDeltaX
    STA World1ScreenDeltaY
    RTS

Bank0_Label_A84C:
    LDA World1CameraTileY
    SEC
    SBC #$26
    STA World1CameraTileY

Bank0_Label_A853:
    LDA #$00
    STA World1ScreenDeltaX
    STA World1ScreenDeltaY
    JSR World1_TryScrollCameraDown
    JSR World1_DrainMapPpuUpdates
    JSR World1_SpawnObjectsAtCameraEdges
    JSR World1_ApplyCameraDeltaToEntities
    LDA #$00
    STA World1ScreenDeltaX
    STA World1ScreenDeltaY
    JSR World1_TryScrollCameraDown
    JSR World1_DrainMapPpuUpdates
    JSR World1_SpawnObjectsAtCameraEdges
    JSR World1_ApplyCameraDeltaToEntities
    DEC World1MapPrefillCounter
    BNE Bank0_Label_A853
    JMP Bank0_Label_A82F
