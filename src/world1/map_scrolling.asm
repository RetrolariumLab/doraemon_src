; Doraemon PRG bank 0 $A381-$A509
; World 1 scroll advancement and nametable edge selection
; Generated deterministically from pinned Ghidra/GhidraNes facts

World1_TryScrollCameraRight:
    LDA World1CameraTileX
    CMP #$E0
    BNE Bank0_Label_A38E
    LDA PpuScrollXShadow
    AND #$07
    BNE Bank0_Label_A38E
    RTS

Bank0_Label_A38E:
    DEC World1ScreenDeltaX
    INC PpuScrollXShadow
    BNE Bank0_Label_A39A
    LDA World1NametableX
    EOR #$01
    STA World1NametableX

Bank0_Label_A39A:
    LDA PpuScrollXShadow
    AND #$07
    BEQ Bank0_Label_A3A1
    RTS

Bank0_Label_A3A1:
    INC World1CameraTileX
    LDA World1CameraTileX
    CLC
    ADC #$20
    TAX
    LDY World1CameraTileY
    LDA PpuScrollYShadow
    AND #$07
    CMP #$04
    BCC Bank0_Label_A3B4
    INY

Bank0_Label_A3B4:
    LDA World1NametableX
    EOR #$01
    AND #$01
    JSR World1_BuildColumnTileUpdate
    LDA PpuScrollXShadow
    AND #$0F
    BNE Bank0_Label_A3D4
    LDY World1CameraTileY
    LDA World1CameraTileX
    CLC
    ADC #$20
    TAX
    LDA World1NametableX
    AND #$01
    EOR #$01
    JSR World1_BuildColumnAttributeUpdate

Bank0_Label_A3D4:
    LDA a:World1EdgeUpdateQueue
    ASL A
    ASL A
    ASL A
    ASL A
    ORA #$01
    STA a:World1EdgeUpdateQueue
    RTS

World1_TryScrollCameraLeft:
    LDA World1CameraTileX
    BNE Bank0_Label_A3EC
    LDA PpuScrollXShadow
    AND #$07
    BNE Bank0_Label_A3EC
    RTS

Bank0_Label_A3EC:
    INC World1ScreenDeltaX
    LDA PpuScrollXShadow
    BNE Bank0_Label_A3F8
    LDA World1NametableX
    EOR #$01
    STA World1NametableX

Bank0_Label_A3F8:
    DEC PpuScrollXShadow
    LDA PpuScrollXShadow
    AND #$07
    CMP #$07
    BEQ Bank0_Label_A403
    RTS

Bank0_Label_A403:
    DEC World1CameraTileX
    LDX World1CameraTileX
    LDY World1CameraTileY
    LDA PpuScrollYShadow
    AND #$07
    CMP #$04
    BCC Bank0_Label_A412
    INY

Bank0_Label_A412:
    LDA World1NametableX
    AND #$01
    JSR World1_BuildColumnTileUpdate
    LDA PpuScrollXShadow
    AND #$0F
    CMP #$0F
    BNE Bank0_Label_A3D4
    LDY World1CameraTileY
    LDX World1CameraTileX
    LDA World1NametableX
    AND #$01
    JSR World1_BuildColumnAttributeUpdate
    JMP Bank0_Label_A3D4

World1_TryScrollCameraDown:
    LDA World1CameraTileY
    CMP #$E2
    BNE Bank0_Label_A43C
    LDA PpuScrollYShadow
    AND #$07
    BNE Bank0_Label_A43C

Bank0_Label_A43B:
    RTS

Bank0_Label_A43C:
    DEC World1ScreenDeltaY
    INC PpuScrollYShadow
    LDA PpuScrollYShadow
    CMP #$F0
    BCC Bank0_Label_A44B
    CLC
    ADC #$10
    STA PpuScrollYShadow

Bank0_Label_A44B:
    AND #$07
    BNE Bank0_Label_A451
    INC World1CameraTileY

Bank0_Label_A451:
    CMP #$04
    BNE Bank0_Label_A463
    LDX World1CameraTileX
    LDA World1CameraTileY
    CLC
    ADC #$1E
    TAY
    JSR World1_BuildRowTileUpdate
    JMP Bank0_Label_A476

Bank0_Label_A463:
    LDA PpuScrollYShadow
    AND #$0F
    CMP #$08
    BNE Bank0_Label_A43B
    LDX World1CameraTileX
    LDA World1CameraTileY
    CLC
    ADC #$1E
    TAY
    JSR World1_BuildRowAttributeUpdate

Bank0_Label_A476:
    LDA a:World1EdgeUpdateQueue
    ASL A
    ASL A
    ASL A
    ASL A
    ORA #$02
    STA a:World1EdgeUpdateQueue
    RTS
    .byte $60

World1_TryScrollCameraUp:
    LDA World1CameraTileY
    BNE Bank0_Label_A48F
    LDA PpuScrollYShadow
    AND #$07
    BNE Bank0_Label_A48F

Bank0_Label_A48E:
    RTS

Bank0_Label_A48F:
    INC World1ScreenDeltaY
    DEC PpuScrollYShadow
    LDA PpuScrollYShadow
    CMP #$F0
    BCC Bank0_Label_A49E
    SEC
    SBC #$10
    STA PpuScrollYShadow

Bank0_Label_A49E:
    AND #$07
    CMP #$07
    BNE Bank0_Label_A4A6
    DEC World1CameraTileY

Bank0_Label_A4A6:
    CMP #$03
    BNE Bank0_Label_A4B4
    LDX World1CameraTileX
    LDY World1CameraTileY
    JSR World1_BuildRowTileUpdate
    JMP Bank0_Label_A476

Bank0_Label_A4B4:
    LDA PpuScrollYShadow
    AND #$0F
    CMP #$07
    BNE Bank0_Label_A48E
    LDX World1CameraTileX
    LDY World1CameraTileY
    JSR World1_BuildRowAttributeUpdate
    JMP Bank0_Label_A476

World1_BuildColumnTileUpdate:
    PHA
    JSR World1_LookupMapTile
    LDX #$00

Bank0_Label_A4CC:
    JSR World1_ReadMapTileAndStepDown
    STA a:World1ColumnTileData,X
    INX
    CPX #$1E
    BNE Bank0_Label_A4CC
    LDA PpuScrollYShadow
    CLC
    ADC #$04
    CMP #$F0
    BCC Bank0_Label_A4E3
    CLC
    ADC #$10

Bank0_Label_A4E3:
    AND #$F8
    STA a:World1ColumnTilePpuAddress
    PLA
    ASL a:World1ColumnTilePpuAddress
    ROL A
    ASL a:World1ColumnTilePpuAddress
    ROL A
    ORA #$20
    STA a:World1ColumnTilePpuAddress+$01
    LDA PpuScrollXShadow
    LSR A
    LSR A
    LSR A
    ORA a:World1ColumnTilePpuAddress
    STA a:World1ColumnTilePpuAddress
    LDA a:World1ColumnUpdateFlags
    ORA #$01
    STA a:World1ColumnUpdateFlags
    RTS
