; Doraemon PRG bank 0 $8A6C-$8D21
; World 1 object coordinate stepping, animation, and collision helpers
; Generated deterministically from pinned Ghidra/GhidraNes facts

World1_MoveEntityXByA:
    ORA #$00
    BMI Bank0_Label_8A8B
    CLC
    ADC a:World1EntityX,X
    STA a:World1EntityX,X
    BCC Bank0_Label_8A8A
    LDA a:World1EntityPositionHigh,X
    TAY
    AND #$0C
    STA $00
    INY
    TYA
    AND #$03
    ORA $00
    STA a:World1EntityPositionHigh,X

Bank0_Label_8A8A:
    RTS

Bank0_Label_8A8B:
    CLC
    ADC a:World1EntityX,X
    STA a:World1EntityX,X
    BCS Bank0_Label_8A8A
    LDA a:World1EntityPositionHigh,X
    TAY
    AND #$0C
    STA $00
    DEY
    TYA
    AND #$03
    ORA $00
    STA a:World1EntityPositionHigh,X
    RTS

World1_MoveEntityYByA:
    ORA #$00
    BMI Bank0_Label_8ABF
    CLC
    ADC a:World1EntityY,X
    STA a:World1EntityY,X
    BCC Bank0_Label_8ABE
    LDA a:World1EntityPositionHigh,X
    CLC
    ADC #$04
    AND #$0F
    STA a:World1EntityPositionHigh,X

Bank0_Label_8ABE:
    RTS

Bank0_Label_8ABF:
    CLC
    ADC a:World1EntityY,X
    STA a:World1EntityY,X
    BCS Bank0_Label_8ABE
    LDA a:World1EntityPositionHigh,X
    SEC
    SBC #$04
    AND #$0F
    STA a:World1EntityPositionHigh,X
    RTS

Bank0_Func_8AD4:
    LDA a:World1EntityPositionHigh,X
    AND #$03
    STA $00
    LDA PpuScrollXShadow
    AND #$07
    CLC
    ADC a:World1EntityX,X
    STA $02
    LDA $00
    ADC #$00
    STA $00
    LDA $02
    LSR $00
    ROR A
    LSR $00
    ROR A
    PHA
    AND #$80
    STA $00
    PLA
    LSR A
    ORA $00
    CLC
    ADC $5B
    STA $00
    LDA a:World1EntityPositionHigh,X
    AND #$0C
    LSR A
    LSR A
    STA $01
    LDA PpuScrollYShadow
    AND #$07
    CLC
    ADC a:World1EntityY,X
    STA $02
    LDA $01
    ADC #$00
    STA $01
    LDA $02
    LSR $01
    ROR A
    LSR $01
    ROR A
    PHA
    AND #$80
    STA $01
    PLA
    LSR A
    ORA $01
    CLC
    ADC $5C
    STA $01
    RTS

Bank0_Func_8B31:
    CLC
    ADC $00
    STA $02
    TYA
    CLC
    ADC $01
    TAY
    TXA
    PHA
    LDX $02
    JSR Bank0_Func_A6A7
    PLA
    TAX
    RTS

Bank0_Func_8B45:
    AND #$07
    TAY
    BEQ Bank0_Func_8B65
    DEY
    BEQ Bank0_Label_8BC3
    DEY
    BEQ Bank0_Func_8B80
    DEY
    BEQ Bank0_Label_8BCC
    DEY
    BEQ Bank0_Func_8B94
    DEY
    BEQ Bank0_Label_8BD5
    DEY
    BEQ Bank0_Func_8BAF
    JSR Bank0_Func_8B65
    BCS Bank0_Label_8B64
    JSR Bank0_Func_8BAF

Bank0_Label_8B64:
    RTS

Bank0_Func_8B65:
    LDA #$00
    LDY $9A
    JSR Bank0_Func_8B31
    JSR Bank0_Func_A6E8
    CMP #$42
    BCS Bank0_Label_8B7F
    JSR Bank0_Func_A6E8
    CMP #$42
    BCS Bank0_Label_8B7F
    JSR Bank0_Func_A6E2
    CMP #$42

Bank0_Label_8B7F:
    RTS

Bank0_Func_8B80:
    LDA $99
    LDY #$01
    JSR Bank0_Func_8B31
    JSR Bank0_Func_A719
    CMP #$42
    BCS Bank0_Label_8B93
    JSR Bank0_Func_A6E2
    CMP #$42

Bank0_Label_8B93:
    RTS

Bank0_Func_8B94:
    LDA #$00
    LDY #$01
    JSR Bank0_Func_8B31
    JSR Bank0_Func_A6E8
    CMP #$42
    BCS Bank0_Label_8BAE
    JSR Bank0_Func_A6E8
    CMP #$42
    BCS Bank0_Label_8BAE
    JSR Bank0_Func_A6E2
    CMP #$42

Bank0_Label_8BAE:
    RTS

Bank0_Func_8BAF:
    LDA #$00
    LDY #$01
    JSR Bank0_Func_8B31
    JSR Bank0_Func_A719
    CMP #$42
    BCS Bank0_Label_8BC2
    JSR Bank0_Func_A6E2
    CMP #$42

Bank0_Label_8BC2:
    RTS

Bank0_Label_8BC3:
    JSR Bank0_Func_8B65
    BCS Bank0_Label_8BCB
    JSR Bank0_Func_8B80

Bank0_Label_8BCB:
    RTS

Bank0_Label_8BCC:
    JSR Bank0_Func_8B94
    BCS Bank0_Label_8BD4
    JSR Bank0_Func_8B80

Bank0_Label_8BD4:
    RTS

Bank0_Label_8BD5:
    JSR Bank0_Func_8BAF
    BCS Bank0_Label_8BDD
    JSR Bank0_Func_8B94

Bank0_Label_8BDD:
    RTS

World1_SpawnObjectsAtCameraEdges:
    LDA $61
    BMI Bank0_Label_8BE7
    BNE Bank0_Label_8C03
    JMP Bank0_Label_8C1A

Bank0_Label_8BE7:
    EOR #$FF
    CLC
    ADC #$01
    STA $8D
    LDA PpuScrollXShadow
    AND #$07
    CMP $8D
    BCS Bank0_Label_8C02
    LDA $5B
    CLC
    ADC #$24
    BCS Bank0_Label_8C02
    STA $8D
    JMP Bank0_Label_8CBA

Bank0_Label_8C02:
    RTS

Bank0_Label_8C03:
    LDA PpuScrollXShadow
    AND #$07
    CLC
    ADC $61
    CMP #$08
    BCC Bank0_Label_8BE7
    LDA $5B
    SEC
    SBC #$04
    BCC Bank0_Label_8C02
    STA $8D
    JMP Bank0_Label_8CBA

Bank0_Label_8C1A:
    LDA $62
    BMI Bank0_Label_8C21
    BNE Bank0_Label_8C3E
    RTS

Bank0_Label_8C21:
    EOR #$FF
    CLC
    ADC #$01
    STA $8D
    LDA PpuScrollYShadow
    AND #$07
    CMP $8D
    BCC Bank0_Label_8C31
    RTS

Bank0_Label_8C31:
    LDA $5C
    CLC
    ADC #$22
    BCC Bank0_Label_8C39
    RTS

Bank0_Label_8C39:
    STA $8D
    JMP Bank0_Label_8C54

Bank0_Label_8C3E:
    LDA PpuScrollYShadow
    AND #$07
    CLC
    ADC $62
    CMP #$08
    BCS Bank0_Label_8C4A
    RTS

Bank0_Label_8C4A:
    LDA $5C
    SEC
    SBC #$04
    BCS Bank0_Label_8C52
    RTS

Bank0_Label_8C52:
    STA $8D

Bank0_Label_8C54:
    LDA #$FF
    STA $8E
    LDA $5B
    CLC
    ADC #$24
    BCS Bank0_Label_8C61
    STA $8E

Bank0_Label_8C61:
    LDA #$00
    STA $8F
    LDA $5B
    SEC
    SBC #$04
    BCC Bank0_Label_8C6E
    STA $8F

Bank0_Label_8C6E:
    LDA World1ObjectPlacementList
    STA World1PlacementScanPointer
    LDA World1ObjectPlacementList+$01
    STA World1PlacementScanPointer+$01
    LDA #$00
    STA World1CurrentPlacementId

Bank0_Label_8C7A:
    LDY #$00
    LDA (World1PlacementScanPointer),Y
    BEQ Bank0_Label_8CB9
    CMP $8F
    BCS Bank0_Label_8C96

Bank0_Label_8C84:
    LDA World1PlacementScanPointer
    CLC
    ADC #$03
    STA World1PlacementScanPointer
    LDA World1PlacementScanPointer+$01
    ADC #$00
    STA World1PlacementScanPointer+$01
    INC World1CurrentPlacementId
    JMP Bank0_Label_8C7A

Bank0_Label_8C96:
    CMP $8E
    BCS Bank0_Label_8CB3
    STA World1PlacementXCell
    INY
    LDA (World1PlacementScanPointer),Y
    CMP $8D
    BNE Bank0_Label_8C84
    STA World1PlacementYCell
    JSR World1_IsObjectSpawnSuppressed
    BNE Bank0_Label_8C84
    INY
    LDA (World1PlacementScanPointer),Y
    JSR World1_MaterializePlacement
    JMP Bank0_Label_8C84

Bank0_Label_8CB3:
    LDA World1CurrentPlacementId
    CMP #$2D
    BCC Bank0_Label_8C84

Bank0_Label_8CB9:
    RTS

Bank0_Label_8CBA:
    LDA #$FF
    STA $8E
    LDA $5C
    CLC
    ADC #$22
    BCS Bank0_Label_8CC7
    STA $8E

Bank0_Label_8CC7:
    LDA #$00
    STA $8F
    LDA $5C
    SEC
    SBC #$04
    BCC Bank0_Label_8CD4
    STA $8F

Bank0_Label_8CD4:
    LDA World1ObjectPlacementList
    STA World1PlacementScanPointer
    LDA World1ObjectPlacementList+$01
    STA World1PlacementScanPointer+$01
    LDA #$00
    STA World1CurrentPlacementId

Bank0_Label_8CE0:
    LDY #$00
    LDA (World1PlacementScanPointer),Y
    BEQ Bank0_Label_8D21
    CMP $8D
    BEQ Bank0_Label_8CFE
    BCS Bank0_Label_8D1B

Bank0_Label_8CEC:
    LDA World1PlacementScanPointer
    CLC
    ADC #$03
    STA World1PlacementScanPointer
    LDA World1PlacementScanPointer+$01
    ADC #$00
    STA World1PlacementScanPointer+$01
    INC World1CurrentPlacementId
    JMP Bank0_Label_8CE0

Bank0_Label_8CFE:
    STA World1PlacementXCell
    INY
    LDA (World1PlacementScanPointer),Y
    CMP $8E
    BCS Bank0_Label_8CEC
    CMP $8F
    BCC Bank0_Label_8CEC
    STA World1PlacementYCell
    JSR World1_IsObjectSpawnSuppressed
    BNE Bank0_Label_8CEC
    INY
    LDA (World1PlacementScanPointer),Y
    JSR World1_MaterializePlacement
    JMP Bank0_Label_8CEC

Bank0_Label_8D1B:
    LDA World1CurrentPlacementId
    CMP #$2D
    BCC Bank0_Label_8CEC

Bank0_Label_8D21:
    RTS
