; Doraemon PRG bank 0 $E14B-$E315
; World 1 low-state entity handlers at E14B through E315
; Generated deterministically from pinned Ghidra/GhidraNes facts

World1_UpdateDobakku:
    LDA #$02
    STA $99
    STA $9A
    DEC a:World1EntityPrimaryBehavior,X
    LDA a:World1EntityPrimaryBehavior,X
    LDY a:World1EntitySecondaryBehavior,X
    BEQ Bank0_Label_E1A8
    DEY
    BEQ Bank0_Label_E18F
    DEY
    BEQ Bank0_Label_E181
    TAY
    BNE Bank0_Label_E180
    LDA a:World1EntityMetasprite,X
    CMP #$70
    BEQ Bank0_Label_E175
    DEC a:World1EntityMetasprite,X

Bank0_Label_E16F:
    LDA #$05
    STA a:World1EntityPrimaryBehavior,X
    RTS

Bank0_Label_E175:
    LDA #$00
    STA a:World1EntitySecondaryBehavior,X

Bank0_Label_E17A:
    JSR World1_RandomByte
    STA a:World1EntityPrimaryBehavior,X

Bank0_Label_E180:
    RTS

Bank0_Label_E181:
    TAY
    PHP
    JSR Bank0_Func_90B0
    PLP
    BNE Bank0_Label_E180
    INC a:World1EntitySecondaryBehavior,X
    JMP Bank0_Label_E16F

Bank0_Label_E18F:
    TAY
    BNE Bank0_Label_E180
    LDA a:World1EntityMetasprite,X
    CMP #$72
    BEQ Bank0_Label_E1A2
    INC a:World1EntityMetasprite,X

Bank0_Label_E19C:
    LDA #$0A
    STA a:World1EntityPrimaryBehavior,X
    RTS

Bank0_Label_E1A2:
    INC a:World1EntitySecondaryBehavior,X
    JMP Bank0_Label_E17A

Bank0_Label_E1A8:
    TAY
    PHP
    JSR Bank0_Func_8987
    PHA
    JSR Bank0_Func_8962
    JSR Bank0_Func_8AD4
    PLA
    PHA
    JSR Bank0_Func_8B45
    BCC Bank0_Label_E1C2
    PLA
    PHA
    EOR #$04
    JSR Bank0_Func_8962

Bank0_Label_E1C2:
    PLA
    PLP
    BNE Bank0_Label_E1D1
    LDA #$70
    STA a:World1EntityMetasprite,X
    INC a:World1EntitySecondaryBehavior,X
    JMP Bank0_Label_E19C

Bank0_Label_E1D1:
    LDA FrameCounter
    AND #$08
    BEQ Bank0_Label_E1DF
    LDA a:World1EntityMetasprite,X
    EOR #$01
    STA a:World1EntityMetasprite,X

Bank0_Label_E1DF:
    RTS

World1_UpdateHerimeda:
    LDA a:World1EntityPrimaryBehavior,X
    LSR A
    LSR A
    AND #$0F
    TAY
    LDA a:$E231,Y
    JSR World1_MoveEntityYByA
    LDA a:World1EntityPrimaryBehavior,X
    AND #$3F
    BNE Bank0_Label_E1FB
    JSR Bank0_Func_8987
    STA a:World1EntitySecondaryBehavior,X

Bank0_Label_E1FB:
    LDA a:World1EntitySecondaryBehavior,X
    ORA #$01
    JSR Bank0_Func_8962
    LDA FrameCounter
    AND #$01
    ORA #$6C
    STA a:World1EntityMetasprite,X
    LDA a:World1EntitySecondaryBehavior,X
    LSR A
    AND #$02
    ORA a:World1EntityMetasprite,X
    STA a:World1EntityMetasprite,X
    LDA a:World1EntityActionCooldown,X
    BNE Bank0_Label_E22A
    JSR Bank0_Func_9130
    JSR World1_RandomByte
    AND #$1F
    ADC #$50
    STA a:World1EntityActionCooldown,X

Bank0_Label_E22A:
    DEC a:World1EntityActionCooldown,X
    INC a:World1EntityPrimaryBehavior,X
    RTS
    .byte $03, $02, $01, $00, $00, $FF, $FE, $FD, $FD, $FE, $FF, $00, $00, $01, $02, $03
    .byte $A9, $80, $9D, $50, $05, $4C, $A0, $8E

World1_UpdateGiraamin:
    LDA #$02
    STA $99
    LDA #$03
    STA $9A
    LDA a:World1EntitySecondaryBehavior,X
    BNE Bank0_Label_E25B
    DEC a:World1EntityPrimaryBehavior,X
    BPL Bank0_Label_E2BF

Bank0_Label_E25B:
    LDA a:World1EntitySecondaryBehavior,X
    AND #$08
    BNE Bank0_Label_E285
    JSR Bank0_Func_9130
    LDA FrameCounter
    AND #$1F
    BNE Bank0_Label_E2DB
    JSR Bank0_Func_8934
    JSR World1_RandomByte
    CMP #$20
    BCS Bank0_Label_E2DB
    JMP Bank0_Label_E2DB
    .byte $BD, $80, $05, $09, $08, $9D, $80, $05, $A9, $FA, $9D, $50, $05

Bank0_Label_E285:
    JSR Bank0_Func_895A
    JSR Bank0_Func_8AD4
    LDA a:World1EntitySecondaryBehavior,X
    JSR Bank0_Func_8B45
    BCC Bank0_Label_E296
    JSR Bank0_Func_8952

Bank0_Label_E296:
    LDA a:World1EntityPrimaryBehavior,X
    JSR World1_MoveEntityYByA
    JSR Bank0_Func_8AD4
    LDA a:World1EntityPrimaryBehavior,X
    BMI Bank0_Label_E2C0
    LDA #$00
    JSR Bank0_Func_8B45
    BCC Bank0_Label_E2D1
    LDA #$01
    JSR Bank0_Func_E127
    LDA #$00
    STA a:World1EntitySecondaryBehavior,X
    LDA #$14
    STA a:World1EntityPrimaryBehavior,X
    LDA #$3E
    STA a:World1EntityMetasprite,X

Bank0_Label_E2BF:
    RTS

Bank0_Label_E2C0:
    LDA #$04
    JSR Bank0_Func_8B45
    BCC Bank0_Label_E2D1
    LDA #$11
    JSR Bank0_Func_E127
    LDA #$00
    STA a:World1EntityPrimaryBehavior,X

Bank0_Label_E2D1:
    LDA FrameCounter
    AND #$03
    BNE Bank0_Label_E2DA
    INC a:World1EntityPrimaryBehavior,X

Bank0_Label_E2DA:
    RTS

Bank0_Label_E2DB:
    INC a:World1EntityY,X
    JSR Bank0_Func_8AD4
    DEC a:World1EntityY,X
    JSR Bank0_Func_8B65
    BCS Bank0_Label_E2F6
    LDA a:World1EntitySecondaryBehavior,X
    ORA #$08
    STA a:World1EntitySecondaryBehavior,X
    LDA #$01
    STA a:World1EntityPrimaryBehavior,X

Bank0_Label_E2F6:
    JSR Bank0_Func_895A
    JSR Bank0_Func_8AD4
    LDA a:World1EntitySecondaryBehavior,X
    JSR Bank0_Func_8B45
    BCC Bank0_Label_E307
    JSR Bank0_Func_8952

Bank0_Label_E307:
    LDA FrameCounter
    AND #$03
    BNE Bank0_Label_E2BF
    LDA a:World1EntityMetasprite,X
    EOR #$01
    STA a:World1EntityMetasprite,X
    RTS
