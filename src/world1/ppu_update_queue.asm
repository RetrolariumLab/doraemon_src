; Doraemon PRG bank 0 $A87E-$A9EE
; World 1 buffered PPU update packet construction
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank0_Func_A87E:
    LDA a:$025F
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
    STA a:$025F
    CPX #$20
    BEQ Bank0_Label_A8AD
    JMP Bank0_Label_A94C

Bank0_Label_A89C:
    LDA #$00
    STA a:$025F
    JMP Bank0_Label_A94C

Bank0_Label_A8A4:
    LDA #$00
    STA a:$025F
    JMP Bank0_Label_A8AD

Bank0_Label_A8AC:
    RTS

Bank0_Label_A8AD:
    LDA a:$0260
    AND #$01
    BEQ Bank0_Label_A8FC
    LDA PpuCtrlShadow
    AND #$FB
    STA a:PPU_CTRL
    LDA a:$0262
    STA a:PPU_ADDR
    LDA a:$0261
    STA a:PPU_ADDR
    AND #$1F
    EOR #$1F
    TAY
    INY
    LDX #$00

Bank0_Label_A8CF:
    LDA a:$0263,X
    STA a:PPU_DATA
    INX
    DEY
    BNE Bank0_Label_A8CF
    LDA a:$0262
    EOR #$04
    STA a:PPU_ADDR
    LDA a:$0261
    AND #$E0
    STA a:PPU_ADDR

Bank0_Label_A8E9:
    LDA a:$0263,X
    STA a:PPU_DATA
    INX
    CPX #$21
    BNE Bank0_Label_A8E9
    LDA a:$0260
    AND #$02
    STA a:$0260

Bank0_Label_A8FC:
    LDA a:$0260
    AND #$02
    BEQ Bank0_Label_A94B
    LDA PpuCtrlShadow
    AND #$FB
    STA a:PPU_CTRL
    LDA a:$0285
    STA a:PPU_ADDR
    LDA a:$0284
    STA a:PPU_ADDR
    AND #$07
    EOR #$07
    TAY
    INY
    LDX #$00

Bank0_Label_A91E:
    LDA a:$0286,X
    STA a:PPU_DATA
    INX
    DEY
    BNE Bank0_Label_A91E
    LDA a:$0285
    EOR #$04
    STA a:PPU_ADDR
    LDA a:$0284
    AND #$F8
    STA a:PPU_ADDR

Bank0_Label_A938:
    LDA a:$0286,X
    STA a:PPU_DATA
    INX
    CPX #$09
    BNE Bank0_Label_A938
    LDA a:$0260
    AND #$01
    STA a:$0260

Bank0_Label_A94B:
    RTS

Bank0_Label_A94C:
    LDA a:$0230
    AND #$01
    BEQ Bank0_Label_A9B6
    LDA PpuCtrlShadow
    ORA #$04
    STA a:PPU_CTRL
    LDA a:$0232
    STA a:PPU_ADDR
    LDA a:$0231
    STA a:PPU_ADDR
    STA a:$025E
    LDA a:$0232
    ASL a:$025E
    ROL A
    ASL a:$025E
    ROL A
    ASL a:$025E
    ROL A
    STA a:$025E
    AND #$1F
    EOR #$1F
    TAY
    DEY
    LDX #$00

Bank0_Label_A983:
    LDA a:$0233,X
    STA a:PPU_DATA
    INX
    CPX #$1E
    BEQ Bank0_Label_A9AC
    DEY
    BNE Bank0_Label_A983
    LDA a:$0232
    AND #$FC
    STA a:PPU_ADDR
    LDA a:$0231
    AND #$1F
    STA a:PPU_ADDR

Bank0_Label_A9A1:
    LDA a:$0233,X
    STA a:PPU_DATA
    INX
    CPX #$1E
    BNE Bank0_Label_A9A1

Bank0_Label_A9AC:
    LDA a:$0230
    AND #$02
    STA a:$0230
    BEQ Bank0_Label_A9EE

Bank0_Label_A9B6:
    LDA a:$0230
    AND #$02
    BEQ Bank0_Label_A9EE
    LDA PpuCtrlShadow
    AND #$FB
    STA a:PPU_CTRL
    LDX #$00

Bank0_Label_A9C6:
    LDA a:$0254
    STA a:PPU_ADDR
    LDA a:$0253
    STA a:PPU_ADDR
    LDA a:$0255,X
    STA a:PPU_DATA
    LDA a:$0253
    CLC
    ADC #$08
    STA a:$0253
    INX
    CPX #$08
    BNE Bank0_Label_A9C6
    LDA a:$0230
    AND #$01
    STA a:$0230

Bank0_Label_A9EE:
    RTS
