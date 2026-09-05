; Doraemon PRG bank 1 $8C5D-$8F4A
; World 2 player animation, weapon state, and projectile creation
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank1_Func_8C5D:
    LDA $A8
    BEQ Bank1_Label_8C73
    LDA World2FrameCounter
    AND #$07
    BNE Bank1_Label_8C73
    INC $A8
    LDA $A8
    CMP #$05
    BNE Bank1_Label_8C73
    LDA #$00
    STA $A8

Bank1_Label_8C73:
    RTS

Bank1_Func_8C74:
    LDX #$03
    BNE Bank1_Label_8C86

Bank1_Func_8C78:
    LDX #$05
    BNE Bank1_Label_8C86

Bank1_Func_8C7C:
    LDX #$04
    BNE Bank1_Label_8C86

Bank1_Func_8C80:
    LDX #$06
    BNE Bank1_Label_8C86

Bank1_Func_8C84:
    LDX #$02

Bank1_Label_8C86:
    LDA World2InventoryState,X
    CMP #$01
    BEQ Bank1_Label_8CC3
    CMP #$04
    BEQ Bank1_Label_8CC3
    CMP #$02
    BNE Bank1_Label_8CC2
    LDY #$00
    LDA World2PlayerX
    CMP World2InventoryX,X
    BEQ Bank1_Label_8CA5
    BCS Bank1_Label_8CA2
    DEC World2InventoryX,X
    DEC World2InventoryX,X

Bank1_Label_8CA2:
    INC World2InventoryX,X
    INY

Bank1_Label_8CA5:
    LDA World2PlayerY
    CMP World2InventoryY,X
    BEQ Bank1_Label_8CB4
    BCS Bank1_Label_8CB1
    DEC World2InventoryY,X
    DEC World2InventoryY,X

Bank1_Label_8CB1:
    INC World2InventoryY,X
    INY

Bank1_Label_8CB4:
    TYA
    BNE Bank1_Label_8CC2
    LDA #$09
    JSR World2_Audio_QueueEffectWithPriority
    LDA #$00
    STA $A5
    INC World2InventoryState,X

Bank1_Label_8CC2:
    RTS

Bank1_Label_8CC3:
    JSR Bank1_Func_8CD9
    LDA World2InventoryState,X
    CMP #$01
    BNE Bank1_Label_8CC2
    LDA World2InventoryY,X
    CMP #$67
    BEQ Bank1_Label_8CD6
    CMP #$79
    BNE Bank1_Label_8CC2

Bank1_Label_8CD6:
    INC World2InventoryState,X
    RTS

Bank1_Func_8CD9:
    LDY $42
    BEQ Bank1_Label_8CEE
    DEY
    BEQ Bank1_Label_8CE5
    DEC World2InventoryY,X
    BEQ Bank1_Label_8CF6
    RTS

Bank1_Label_8CE5:
    INC World2InventoryY,X
    LDA World2InventoryY,X
    CMP #$E0
    BCS Bank1_Label_8CF6
    RTS

Bank1_Label_8CEE:
    LDA $45
    BNE Bank1_Label_8D00
    DEC World2InventoryX,X
    BNE Bank1_Label_8D00

Bank1_Label_8CF6:
    LDA World2InventoryState,X
    CMP #$01
    BEQ Bank1_Label_8D00
    LDA #$00
    STA World2InventoryState,X

Bank1_Label_8D00:
    RTS

Bank1_Func_8D01:
    LDY #$00
    LDA World2InventoryState+$01
    CMP #$01
    BEQ Bank1_Label_8D4A
    CMP #$04
    BEQ Bank1_Label_8D4A
    CMP #$02
    BNE Bank1_Label_8D49
    LDA $5F
    SEC
    SBC #$17
    BPL Bank1_Label_8D1A
    ADC #$30

Bank1_Label_8D1A:
    TAX
    LDA a:$0200,X
    CMP World2InventoryX+$01
    BEQ Bank1_Label_8D2B
    BCS Bank1_Label_8D28
    DEC World2InventoryX+$01
    DEC World2InventoryX+$01

Bank1_Label_8D28:
    INC World2InventoryX+$01
    INY

Bank1_Label_8D2B:
    LDA a:$0230,X
    CMP World2InventoryY+$01
    BEQ Bank1_Label_8D3B
    BCS Bank1_Label_8D38
    DEC World2InventoryY+$01
    DEC World2InventoryY+$01

Bank1_Label_8D38:
    INC World2InventoryY+$01
    INY

Bank1_Label_8D3B:
    TYA
    BNE Bank1_Label_8D49
    INC World2InventoryState+$01
    LDA #$09
    JSR World2_Audio_QueueEffectWithPriority
    LDA #$00
    STA $A5

Bank1_Label_8D49:
    RTS

Bank1_Label_8D4A:
    JSR Bank1_Func_8D60
    LDA World2InventoryState+$01
    CMP #$01
    BNE Bank1_Label_8D49
    LDA World2InventoryY+$01
    CMP #$67
    BEQ Bank1_Label_8D5D
    CMP #$79
    BNE Bank1_Label_8D49

Bank1_Label_8D5D:
    INC World2InventoryState+$01
    RTS

Bank1_Func_8D60:
    LDY $42
    BEQ Bank1_Label_8D75
    DEY
    BEQ Bank1_Label_8D6C
    DEC World2InventoryY+$01
    BEQ Bank1_Label_8D7D
    RTS

Bank1_Label_8D6C:
    INC World2InventoryY+$01
    LDA World2InventoryY+$01
    CMP #$E0
    BCS Bank1_Label_8D7D
    RTS

Bank1_Label_8D75:
    LDA $45
    BNE Bank1_Label_8D87
    DEC World2InventoryX+$01
    BNE Bank1_Label_8D87

Bank1_Label_8D7D:
    LDA World2InventoryState+$01
    CMP #$01
    BEQ Bank1_Label_8D87
    LDA #$00
    STA World2InventoryState+$01

Bank1_Label_8D87:
    RTS

Bank1_Func_8D88:
    LDY #$00
    LDA World2InventoryState
    CMP #$01
    BEQ Bank1_Label_8DD1
    CMP #$04
    BEQ Bank1_Label_8DD1
    CMP #$02
    BNE Bank1_Label_8DD0
    LDA $5F
    SEC
    SBC #$2F
    BPL Bank1_Label_8DA1
    ADC #$30

Bank1_Label_8DA1:
    TAX
    LDA a:$0200,X
    CMP World2InventoryX
    BEQ Bank1_Label_8DB2
    BCS Bank1_Label_8DAF
    DEC World2InventoryX
    DEC World2InventoryX

Bank1_Label_8DAF:
    INC World2InventoryX
    INY

Bank1_Label_8DB2:
    LDA a:$0230,X
    CMP World2InventoryY
    BEQ Bank1_Label_8DC2
    BCS Bank1_Label_8DBF
    DEC World2InventoryY
    DEC World2InventoryY

Bank1_Label_8DBF:
    INC World2InventoryY
    INY

Bank1_Label_8DC2:
    TYA
    BNE Bank1_Label_8DD0
    LDA #$09
    JSR World2_Audio_QueueEffectWithPriority
    LDA #$00
    STA $A5
    INC World2InventoryState

Bank1_Label_8DD0:
    RTS

Bank1_Label_8DD1:
    JSR Bank1_Func_8DE7
    LDA World2InventoryState
    CMP #$01
    BNE Bank1_Label_8DD0
    LDA World2InventoryY
    CMP #$67
    BEQ Bank1_Label_8DE4
    CMP #$79
    BNE Bank1_Label_8DD0

Bank1_Label_8DE4:
    INC World2InventoryState
    RTS

Bank1_Func_8DE7:
    LDY $42
    BEQ Bank1_Label_8DFC
    DEY
    BEQ Bank1_Label_8DF3
    DEC World2InventoryY
    BEQ Bank1_Label_8E04
    RTS

Bank1_Label_8DF3:
    INC World2InventoryY
    LDA World2InventoryY
    CMP #$E0
    BCS Bank1_Label_8E04
    RTS

Bank1_Label_8DFC:
    LDA $45
    BNE Bank1_Label_8E0E
    DEC World2InventoryX
    BNE Bank1_Label_8E0E

Bank1_Label_8E04:
    LDA World2InventoryState
    CMP #$01
    BEQ Bank1_Label_8E0E
    LDA #$00
    STA World2InventoryState

Bank1_Label_8E0E:
    RTS

Bank1_Func_8E0F:
    LDX $5F
    DEX
    BPL Bank1_Label_8E16
    LDX #$30

Bank1_Label_8E16:
    LDA World2PlayerX
    CMP a:$0200,X
    BNE Bank1_Label_8E25
    LDA World2PlayerY
    CMP a:$0230,X
    BNE Bank1_Label_8E25
    RTS

Bank1_Label_8E25:
    LDX $5F
    LDA World2PlayerX
    STA a:$0200,X
    LDA World2PlayerY
    STA a:$0230,X
    INX
    TXA
    CMP #$30
    BNE Bank1_Label_8E39
    LDA #$00

Bank1_Label_8E39:
    STA $5F
    RTS

Bank1_Func_8E3C:
    LDA DemoModeActive
    BEQ Bank1_Label_8E4E
    LDA World2FrameCounter
    ROL A
    ROL A
    ROL A
    ROL A
    AND #$07
    TAY
    LDA a:$97BD,Y
    BNE Bank1_Label_8E50

Bank1_Label_8E4E:
    LDA CombinedControllerButtons

Bank1_Label_8E50:
    TAX
    AND #$01
    BEQ Bank1_Label_8E63
    LDA World2PlayerX
    CMP #$D0
    BCS Bank1_Label_8E73
    LDA $5E
    ADC World2PlayerX
    STA World2PlayerX
    BNE Bank1_Label_8E73

Bank1_Label_8E63:
    TXA
    AND #$02
    BEQ Bank1_Label_8E73
    LDA World2PlayerX
    SEC
    SBC $5E
    CMP #$20
    BCC Bank1_Label_8E73
    STA World2PlayerX

Bank1_Label_8E73:
    TXA
    AND #$04
    BEQ Bank1_Label_8E84
    LDA World2PlayerY
    CMP #$D0
    BCS Bank1_Label_8E93
    ADC $5E
    STA World2PlayerY
    BNE Bank1_Label_8E93

Bank1_Label_8E84:
    TXA
    AND #$08
    BEQ Bank1_Label_8E93
    LDA World2PlayerY
    SBC $5E
    CMP #$20
    BCC Bank1_Label_8E93
    STA World2PlayerY

Bank1_Label_8E93:
    TXA
    AND #$C0
    BNE Bank1_Label_8E9B
    STA $7A

Bank1_Label_8E9A:
    RTS

Bank1_Label_8E9B:
    INC $B1
    LDA $A0
    CMP #$50
    BCS Bank1_Label_8E9A
    LDA $7A
    BEQ Bank1_Label_8EB3
    INC $7A
    LDX #$1E
    CPX $7A
    BNE Bank1_Label_8E9A
    LDA #$00
    STA $7A

Bank1_Label_8EB3:
    INC $7A
    LDA #$00
    STA $91
    LDA World2InventoryState+$01
    CMP #$03
    BNE Bank1_Label_8F0C
    LDA $7B
    EOR #$01
    STA $7B
    AND #$01
    BEQ Bank1_Label_8F0C
    INC $92
    LDA $92
    AND #$01
    BEQ Bank1_Label_8F0C
    LDA $92
    AND #$03
    STA $91
    LDA #$01
    JSR World2_Audio_QueueEffectWithPriority
    LDX #$06

Bank1_Label_8EDE:
    LDA a:World2PlayerProjectileState,X
    BEQ Bank1_Label_8EED
    DEX
    CPX #$03
    BNE Bank1_Label_8EDE
    LDA #$00
    STA $7A
    RTS

Bank1_Label_8EED:
    LDA $5F
    SEC
    SBC #$17
    BPL Bank1_Label_8EF6
    ADC #$30

Bank1_Label_8EF6:
    TAY
    LDA a:$0200,Y
    CLC
    ADC #$04
    STA a:World2PlayerProjectileX,X
    LDA a:$0230,Y
    CLC
    ADC #$08
    STA a:World2PlayerProjectileY,X
    JMP Bank1_Label_8F40

Bank1_Label_8F0C:
    JSR Bank1_Func_8F4B
    LDA DemoModeActive
    BNE Bank1_Label_8F19
    LDA World2InventoryState+$02
    CMP #$03
    BNE Bank1_Label_8F1C

Bank1_Label_8F19:
    JMP Bank1_Func_8F80

Bank1_Label_8F1C:
    LDX #$03

Bank1_Label_8F1E:
    LDA a:World2PlayerProjectileState,X
    BEQ Bank1_Label_8F2B
    DEX
    BPL Bank1_Label_8F1E
    LDA #$00
    STA $7A
    RTS

Bank1_Label_8F2B:
    LDA #$01
    JSR World2_Audio_QueueEffectWithPriority
    LDA World2PlayerX
    CLC
    ADC #$04
    STA a:World2PlayerProjectileX,X
    LDA World2PlayerY
    CLC
    ADC #$08
    STA a:World2PlayerProjectileY,X

Bank1_Label_8F40:
    LDA #$01
    STA a:World2PlayerProjectileState,X
    LDA $91
    STA a:World2PlayerProjectileDirection,X
    RTS
