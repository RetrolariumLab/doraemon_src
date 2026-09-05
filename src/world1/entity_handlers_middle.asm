; Doraemon PRG bank 0 $DEBB-$E14A
; World 1 low-state entity handlers at DEBB through E14A
; Generated deterministically from pinned Ghidra/GhidraNes facts

World1_UpdateNaameCity:
    LDA #$02
    STA $99
    STA $9A
    INC a:World1EntityPrimaryBehavior,X
    LDA a:World1EntityPrimaryBehavior,X
    LSR A
    LSR A
    LSR A
    LSR A
    AND #$01
    STA $00
    LDA a:World1EntityMetasprite,X
    AND #$FE
    ORA $00
    STA a:World1EntityMetasprite,X
    LDA a:World1EntityMetasprite,X
    AND #$02
    BEQ Bank0_Label_DEE4
    LDA #$06
    BNE Bank0_Label_DEE6

Bank0_Label_DEE4:
    LDA #$02

Bank0_Label_DEE6:
    PHA
    JSR Bank0_Func_8962
    JSR Bank0_Func_8AD4
    PLA
    PHA
    JSR Bank0_Func_8B45
    BCC Bank0_Label_DF03
    PLA
    EOR #$04
    JSR Bank0_Func_8962
    LDA a:World1EntityMetasprite,X
    EOR #$02
    STA a:World1EntityMetasprite,X
    PHA

Bank0_Label_DF03:
    PLA
    JSR Bank0_Func_9065
    RTS

World1_UpdateNaameUnderground:
    INC a:World1EntityPrimaryBehavior,X
    LDA a:World1EntityPrimaryBehavior,X
    LSR A
    LSR A
    LSR A
    LSR A
    AND #$01
    STA $00
    LDA a:World1EntityMetasprite,X
    AND #$FE
    ORA $00
    STA a:World1EntityMetasprite,X
    LDA a:World1EntityPrimaryBehavior,X
    AND #$01
    BNE Bank0_Label_DF28
    RTS

Bank0_Label_DF28:
    LDA a:World1EntityMetasprite,X
    AND #$02
    BEQ Bank0_Label_DF33
    LDA #$06
    BNE Bank0_Label_DF35

Bank0_Label_DF33:
    LDA #$02

Bank0_Label_DF35:
    PHA
    JSR Bank0_Func_8962
    PLA
    PHA
    EOR #$04
    AND #$04
    ASL A
    ASL A
    STA $A0
    LDA #$08
    STA $A2
    JSR Bank0_Func_DE12
    BCC Bank0_Label_DF5E

Bank0_Label_DF4C:
    PLA
    EOR #$04
    JSR Bank0_Func_8962
    LDA a:World1EntityMetasprite,X
    EOR #$02
    STA a:World1EntityMetasprite,X
    JSR Bank0_Func_9065
    RTS

Bank0_Label_DF5E:
    LDA #$11
    STA $A2
    LDA #$08
    STA $A0
    JSR Bank0_Func_DE12
    BCC Bank0_Label_DF4C
    PLA
    JSR Bank0_Func_9065
    RTS

World1_UpdateKobuun:
    LDA #$02
    STA $99
    STA $9A
    DEC a:World1EntityPrimaryBehavior,X
    BPL Bank0_Label_DFBC
    LDA #$1E
    STA a:World1EntityPrimaryBehavior,X
    JSR Bank0_Func_8987
    AND #$06
    STA $01
    JSR Bank0_Func_964A
    CMP #$40
    BCS Bank0_Label_DF94
    LDA $01
    EOR #$04
    STA $01

Bank0_Label_DF94:
    LDA $01
    AND #$02
    BEQ Bank0_Label_DFA0
    LDA $01
    ASL A
    JMP Bank0_Label_DFA3

Bank0_Label_DFA0:
    LDA a:World1EntitySecondaryBehavior,X

Bank0_Label_DFA3:
    AND #$08
    ORA $01
    STA a:World1EntitySecondaryBehavior,X
    JSR Bank0_Func_964A
    CMP #$40
    BCS Bank0_Label_DFBC
    LDA a:World1EntitySecondaryBehavior,X
    ORA #$80
    STA a:World1EntitySecondaryBehavior,X
    LSR a:World1EntityPrimaryBehavior,X

Bank0_Label_DFBC:
    LDA a:World1EntitySecondaryBehavior,X
    BMI Bank0_Label_DFE3
    JSR Bank0_Func_8962
    JSR Bank0_Func_8AD4
    LDA a:World1EntitySecondaryBehavior,X
    JSR Bank0_Func_8B45
    BCC Bank0_Label_DFE3
    LDA a:World1EntitySecondaryBehavior,X
    EOR #$04
    AND #$07
    JSR Bank0_Func_8962
    LDA #$00
    STA a:World1EntityPrimaryBehavior,X
    STA a:World1EntitySecondaryBehavior,X
    BEQ Bank0_Label_DFFB

Bank0_Label_DFE3:
    LDA a:World1EntityActionCooldown,X
    BNE Bank0_Label_DFFB
    JSR Bank0_Func_964A
    AND #$1F
    ADC #$60
    STA a:World1EntityActionCooldown,X
    LDA $5C
    CMP #$48
    BCS Bank0_Label_DFFB
    JSR Bank0_Func_9130

Bank0_Label_DFFB:
    DEC a:World1EntityActionCooldown,X
    LDA a:World1EntitySecondaryBehavior,X
    AND #$08
    EOR #$08
    STA $01
    LDA FrameCounter
    LSR A
    AND #$04
    ORA $01
    LSR A
    LSR A
    CLC
    ADC #$4C
    STA a:World1EntityMetasprite,X
    RTS

World1_InitializeEntityPrimaryBehavior3C:
    LDA #$3C
    STA a:World1EntityPrimaryBehavior,X
    JMP World1_InitializeEntityPosition

World1_UpdateNezumi:
    LDA #$02
    STA $99
    STA $9A
    LDA a:World1EntitySecondaryBehavior,X
    BNE Bank0_Label_E04E
    DEC a:World1EntityPrimaryBehavior,X
    BPL Bank0_Label_E046
    JSR Bank0_Func_8987
    AND #$04
    ORA #$02
    STA a:World1EntitySecondaryBehavior,X
    AND #$04
    BEQ Bank0_Label_E041
    LDA #$50
    BNE Bank0_Label_E043

Bank0_Label_E041:
    LDA #$52

Bank0_Label_E043:
    STA a:World1EntityMetasprite,X

Bank0_Label_E046:
    LDA a:World1EntitySecondaryBehavior,X
    BNE Bank0_Label_E04E
    JMP Bank0_Label_E0D7

Bank0_Label_E04E:
    AND #$08
    BNE Bank0_Label_E064
    JSR Bank0_Func_DE8E
    BCS Bank0_Label_E0C0
    LDA a:World1EntitySecondaryBehavior,X
    ORA #$08
    STA a:World1EntitySecondaryBehavior,X
    LDA #$FA
    STA a:World1EntityPrimaryBehavior,X

Bank0_Label_E064:
    JSR Bank0_Func_E11A
    DEC a:World1EntityY,X
    JSR Bank0_Func_8AD4
    INC a:World1EntityY,X
    LDA a:World1EntitySecondaryBehavior,X
    JSR Bank0_Func_8B45
    BCC Bank0_Label_E07B
    JSR Bank0_Func_E10A

Bank0_Label_E07B:
    LDA a:World1EntityPrimaryBehavior,X
    JSR World1_MoveEntityYByA
    JSR Bank0_Func_8AD4
    LDA a:World1EntityPrimaryBehavior,X
    BMI Bank0_Label_E0A5
    LDA #$00
    JSR Bank0_Func_8B45
    BCC Bank0_Label_E0B6
    LDA #$01
    JSR Bank0_Func_E127
    LDA #$00
    STA a:World1EntitySecondaryBehavior,X
    LDA #$1E
    STA a:World1EntityPrimaryBehavior,X
    LDA #$54
    STA a:World1EntityMetasprite,X
    RTS

Bank0_Label_E0A5:
    LDA #$04
    JSR Bank0_Func_8B45
    BCC Bank0_Label_E0B6
    LDA #$11
    JSR Bank0_Func_E127
    LDA #$00
    STA a:World1EntityPrimaryBehavior,X

Bank0_Label_E0B6:
    LDA FrameCounter
    AND #$03
    BNE Bank0_Label_E0BF
    INC a:World1EntityPrimaryBehavior,X

Bank0_Label_E0BF:
    RTS

Bank0_Label_E0C0:
    JSR Bank0_Func_E11A
    DEC a:World1EntityY,X
    JSR Bank0_Func_8AD4
    INC a:World1EntityY,X
    LDA a:World1EntitySecondaryBehavior,X
    JSR Bank0_Func_8B45
    BCC Bank0_Label_E0D7
    JSR Bank0_Func_E10A

Bank0_Label_E0D7:
    INC a:World1EntityY,X
    JSR Bank0_Func_8AD4
    DEC a:World1EntityY,X
    JSR Bank0_Func_8B65
    BCS Bank0_Label_E0F2
    LDA a:World1EntitySecondaryBehavior,X
    ORA #$08
    STA a:World1EntitySecondaryBehavior,X
    LDA #$01
    STA a:World1EntityPrimaryBehavior,X

Bank0_Label_E0F2:
    LDA FrameCounter
    AND #$03
    BNE Bank0_Label_E100
    LDA a:World1EntityMetasprite,X
    EOR #$01
    STA a:World1EntityMetasprite,X

Bank0_Label_E100:
    RTS
    .byte $20, $D4, $8A, $BD, $80, $05, $4C, $45, $8B

Bank0_Func_E10A:
    LDA a:World1EntityMetasprite,X
    EOR #$02
    STA a:World1EntityMetasprite,X
    LDA a:World1EntitySecondaryBehavior,X
    EOR #$04
    STA a:World1EntitySecondaryBehavior,X

Bank0_Func_E11A:
    LDA a:World1EntitySecondaryBehavior,X
    AND #$07
    PHA
    JSR Bank0_Func_8962
    PLA
    JMP Bank0_Func_8962

Bank0_Func_E127:
    PHA
    LDA PpuScrollYShadow
    AND #$07
    STA $09
    PLA
    CLC
    ADC a:World1EntityY,X
    CLC
    ADC $09
    AND #$F8
    SEC
    SBC #$01
    SEC
    SBC $09
    STA a:World1EntityY,X
    RTS

World1_InitializeEntityRandomPrimaryBehavior:
    JSR Bank0_Func_964A
    STA a:World1EntityPrimaryBehavior,X
    JMP World1_InitializeEntityPosition
