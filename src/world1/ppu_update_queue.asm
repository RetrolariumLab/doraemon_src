; Doraemon PRG bank 0 $A87E-$A9EE
; World 1 buffered PPU update packet construction
; Generated deterministically from pinned Ghidra/GhidraNes facts

World1_DrainMapPpuUpdates:
    LDA a:World1EdgeUpdateQueue
    BEQ Bank0_Label_A8AC
    CMP #$01
    BEQ Bank0_Label_A89C
    CMP #$02
    BEQ Bank0_Label_A8A4
    TAY
    AND #$F0
    TAX
    TYA
    AND #$0F
    STA a:World1EdgeUpdateQueue
    CPX #$20
    BEQ Bank0_Label_A8AD
    JMP Bank0_Label_A94C

Bank0_Label_A89C:
    LDA #$00
    STA a:World1EdgeUpdateQueue
    JMP Bank0_Label_A94C

Bank0_Label_A8A4:
    LDA #$00
    STA a:World1EdgeUpdateQueue
    JMP Bank0_Label_A8AD

Bank0_Label_A8AC:
    RTS

Bank0_Label_A8AD:
    LDA a:World1RowUpdateFlags
    AND #$01
    BEQ Bank0_Label_A8FC
    LDA PpuCtrlShadow
    AND #$FB
    STA a:PPU_CTRL
    LDA a:World1RowTilePpuAddress+$01
    STA a:PPU_ADDR
    LDA a:World1RowTilePpuAddress
    STA a:PPU_ADDR
    AND #$1F
    EOR #$1F
    TAY
    INY
    LDX #$00

Bank0_Label_A8CF:
    LDA a:World1RowTileData,X
    STA a:PPU_DATA
    INX
    DEY
    BNE Bank0_Label_A8CF
    LDA a:World1RowTilePpuAddress+$01
    EOR #$04
    STA a:PPU_ADDR
    LDA a:World1RowTilePpuAddress
    AND #$E0
    STA a:PPU_ADDR

Bank0_Label_A8E9:
    LDA a:World1RowTileData,X
    STA a:PPU_DATA
    INX
    CPX #$21
    BNE Bank0_Label_A8E9
    LDA a:World1RowUpdateFlags
    AND #$02
    STA a:World1RowUpdateFlags

Bank0_Label_A8FC:
    LDA a:World1RowUpdateFlags
    AND #$02
    BEQ Bank0_Label_A94B
    LDA PpuCtrlShadow
    AND #$FB
    STA a:PPU_CTRL
    LDA a:World1RowAttributePpuAddress+$01
    STA a:PPU_ADDR
    LDA a:World1RowAttributePpuAddress
    STA a:PPU_ADDR
    AND #$07
    EOR #$07
    TAY
    INY
    LDX #$00

Bank0_Label_A91E:
    LDA a:World1RowAttributeData,X
    STA a:PPU_DATA
    INX
    DEY
    BNE Bank0_Label_A91E
    LDA a:World1RowAttributePpuAddress+$01
    EOR #$04
    STA a:PPU_ADDR
    LDA a:World1RowAttributePpuAddress
    AND #$F8
    STA a:PPU_ADDR

Bank0_Label_A938:
    LDA a:World1RowAttributeData,X
    STA a:PPU_DATA
    INX
    CPX #$09
    BNE Bank0_Label_A938
    LDA a:World1RowUpdateFlags
    AND #$01
    STA a:World1RowUpdateFlags

Bank0_Label_A94B:
    RTS

Bank0_Label_A94C:
    LDA a:World1ColumnUpdateFlags
    AND #$01
    BEQ Bank0_Label_A9B6
    LDA PpuCtrlShadow
    ORA #$04
    STA a:PPU_CTRL
    LDA a:World1ColumnTilePpuAddress+$01
    STA a:PPU_ADDR
    LDA a:World1ColumnTilePpuAddress
    STA a:PPU_ADDR
    STA a:World1ColumnAddressScratch
    LDA a:World1ColumnTilePpuAddress+$01
    ASL a:World1ColumnAddressScratch
    ROL A
    ASL a:World1ColumnAddressScratch
    ROL A
    ASL a:World1ColumnAddressScratch
    ROL A
    STA a:World1ColumnAddressScratch
    AND #$1F
    EOR #$1F
    TAY
    DEY
    LDX #$00

Bank0_Label_A983:
    LDA a:World1ColumnTileData,X
    STA a:PPU_DATA
    INX
    CPX #$1E
    BEQ Bank0_Label_A9AC
    DEY
    BNE Bank0_Label_A983
    LDA a:World1ColumnTilePpuAddress+$01
    AND #$FC
    STA a:PPU_ADDR
    LDA a:World1ColumnTilePpuAddress
    AND #$1F
    STA a:PPU_ADDR

Bank0_Label_A9A1:
    LDA a:World1ColumnTileData,X
    STA a:PPU_DATA
    INX
    CPX #$1E
    BNE Bank0_Label_A9A1

Bank0_Label_A9AC:
    LDA a:World1ColumnUpdateFlags
    AND #$02
    STA a:World1ColumnUpdateFlags
    BEQ Bank0_Label_A9EE

Bank0_Label_A9B6:
    LDA a:World1ColumnUpdateFlags
    AND #$02
    BEQ Bank0_Label_A9EE
    LDA PpuCtrlShadow
    AND #$FB
    STA a:PPU_CTRL
    LDX #$00

Bank0_Label_A9C6:
    LDA a:World1ColumnAttributePpuAddress+$01
    STA a:PPU_ADDR
    LDA a:World1ColumnAttributePpuAddress
    STA a:PPU_ADDR
    LDA a:World1ColumnAttributeData,X
    STA a:PPU_DATA
    LDA a:World1ColumnAttributePpuAddress
    CLC
    ADC #$08
    STA a:World1ColumnAttributePpuAddress
    INX
    CPX #$08
    BNE Bank0_Label_A9C6
    LDA a:World1ColumnUpdateFlags
    AND #$01
    STA a:World1ColumnUpdateFlags

Bank0_Label_A9EE:
    RTS
