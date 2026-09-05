; Doraemon PRG bank 0 $DBDA-$DEBA
; World 1 low-state entity handlers at DBDA through DEBA
; Generated deterministically from pinned Ghidra/GhidraNes facts

World1_UpdateYuubouOrDormantState0D:
    LDA FrameCounter
    AND #$03
    BNE Bank0_Label_DBEF
    INC a:World1EntityMetasprite,X
    LDA a:World1EntityMetasprite,X
    CMP #$67
    BCC Bank0_Label_DBEF
    LDA #$64
    STA a:World1EntityMetasprite,X

Bank0_Label_DBEF:
    LDA a:World1EntityPrimaryBehavior,X
    BNE Bank0_Label_DC12
    JSR Bank0_Func_964A
    AND #$89
    CMP #$89
    BEQ Bank0_Label_DC04
    LDA $79
    BNE Bank0_Label_DC07
    JSR Bank0_Func_8987

Bank0_Label_DC04:
    STA a:World1EntitySecondaryBehavior,X

Bank0_Label_DC07:
    JSR Bank0_Func_964A
    AND #$1F
    CLC
    ADC #$10
    STA a:World1EntityPrimaryBehavior,X

Bank0_Label_DC12:
    LDA a:World1EntitySecondaryBehavior,X
    BMI Bank0_Label_DC1A
    JSR Bank0_Func_8962

Bank0_Label_DC1A:
    DEC a:World1EntityPrimaryBehavior,X
    LDA a:World1EntityActionCooldown,X
    BNE Bank0_Label_DC2F
    JSR Bank0_Func_9130
    JSR Bank0_Func_964A
    AND #$1F
    ADC #$20
    STA a:World1EntityActionCooldown,X

Bank0_Label_DC2F:
    DEC a:World1EntityActionCooldown,X
    RTS

World1_InitializeEntityDirection:
    JSR World1_InitializeEntityPosition
    LDA $00
    PHA
    LDA $01
    PHA
    JSR Bank0_Func_8987
    STA a:World1EntitySecondaryBehavior,X
    PLA
    STA $01
    PLA
    STA $00
    RTS

World1_UpdateSuneraa:
    LDA a:World1EntityPrimaryBehavior,X
    BNE Bank0_Label_DC75
    JSR Bank0_Func_964A
    AND #$07
    CLC
    ADC #$10
    STA a:World1EntityPrimaryBehavior,X
    LDA $79
    BNE Bank0_Label_DC75
    JSR Bank0_Func_8987
    SEC
    SBC a:World1EntitySecondaryBehavior,X
    AND #$07
    BEQ Bank0_Label_DC75
    CMP #$04
    BCC Bank0_Label_DC72
    DEC a:World1EntitySecondaryBehavior,X
    JMP Bank0_Label_DC75

Bank0_Label_DC72:
    INC a:World1EntitySecondaryBehavior,X

Bank0_Label_DC75:
    LDA a:World1EntitySecondaryBehavior,X
    JSR Bank0_Func_8962
    JSR Bank0_Func_8962
    DEC a:World1EntityPrimaryBehavior,X
    LDA a:World1EntitySecondaryBehavior,X
    AND #$04
    BEQ Bank0_Label_DC8C
    LDA #$5E
    BNE Bank0_Label_DC8E

Bank0_Label_DC8C:
    LDA #$5C

Bank0_Label_DC8E:
    STA $00
    LDA FrameCounter
    LSR A
    LSR A
    LSR A
    AND #$01
    ORA $00
    STA a:World1EntityMetasprite,X
    LDA a:World1EntityActionCooldown,X
    BNE Bank0_Label_DCAE
    JSR Bank0_Func_9130
    JSR Bank0_Func_964A
    AND #$1F
    ADC #$50
    STA a:World1EntityActionCooldown,X

Bank0_Label_DCAE:
    DEC a:World1EntityDamageTimerOrAcceleration,X
    RTS

World1_UpdateMekanosso:
    LDA #$02
    STA $99
    STA $9A
    INC a:World1EntitySecondaryBehavior,X
    LDA a:World1EntitySecondaryBehavior,X
    AND #$30
    BEQ Bank0_Label_DD16
    LDA a:World1EntitySecondaryBehavior,X
    LSR A
    LSR A
    LSR A
    AND #$01
    ORA #$56
    STA a:World1EntityMetasprite,X
    LDA a:World1EntityPrimaryBehavior,X
    BMI Bank0_Label_DCE1
    LDA a:World1EntitySecondaryBehavior,X
    AND #$07
    BNE Bank0_Label_DCEA
    JSR Bank0_Func_8987
    JMP Bank0_Label_DCE7

Bank0_Label_DCE1:
    LDA a:World1EntityPrimaryBehavior,X
    CLC
    ADC #$08

Bank0_Label_DCE7:
    STA a:World1EntityPrimaryBehavior,X

Bank0_Label_DCEA:
    LDA a:World1EntityPrimaryBehavior,X
    JSR Bank0_Func_8962
    JSR Bank0_Func_8AD4
    LDA a:World1EntityPrimaryBehavior,X
    JSR Bank0_Func_8B45
    BCC Bank0_Label_DD16
    LDA a:World1EntityPrimaryBehavior,X
    EOR #$04
    JSR Bank0_Func_8962
    LDA #$00
    STA a:World1EntityPrimaryBehavior,X
    JSR Bank0_Func_964A
    CMP #$80
    BCC Bank0_Label_DD16
    AND #$07
    ORA #$80
    STA a:World1EntityPrimaryBehavior,X

Bank0_Label_DD16:
    LDA $5C
    CMP #$48
    BCS Bank0_Label_DD28
    LDA a:World1EntitySecondaryBehavior,X
    AND #$3F
    CMP #$08
    BNE Bank0_Label_DD28
    JSR Bank0_Func_9130

Bank0_Label_DD28:
    RTS

World1_UpdateGozuraCity:
    LDA a:World1EntitySecondaryBehavior,X
    LSR A
    TAY
    LDA a:$DDBB,Y
    JSR World1_MoveEntityYByA
    LDA a:World1EntityPrimaryBehavior,X
    BEQ Bank0_Label_DD40
    BMI Bank0_Label_DD40
    AND #$07
    JSR Bank0_Func_8962

Bank0_Label_DD40:
    LDA a:World1EntitySecondaryBehavior,X
    LSR A
    LSR A
    LSR A
    AND #$01
    STA $00
    LDA a:World1EntityMetasprite,X
    AND #$FE
    ORA $00
    STA a:World1EntityMetasprite,X
    INC a:World1EntitySecondaryBehavior,X
    LDA a:World1EntitySecondaryBehavior,X
    CMP #$10
    BCC Bank0_Label_DDA5
    LDA #$00
    STA a:World1EntitySecondaryBehavior,X
    LDA #$00
    STA a:World1EntityPrimaryBehavior,X
    JSR Bank0_Func_DE8E
    CMP #$60
    BCS Bank0_Label_DDA5
    CMP #$28
    BCC Bank0_Label_DDA5
    JSR Bank0_Func_8987
    ORA #$08
    STA a:World1EntityPrimaryBehavior,X
    AND #$07
    TAY
    LDA a:$DDC3,Y
    STA $A0
    LDA a:$DDCB,Y
    STA $A2
    JSR Bank0_Func_DE12
    JSR Bank0_Func_A6E8
    CMP #$42
    BCS Bank0_Label_DDA0
    JSR Bank0_Func_A6E8
    CMP #$42
    BCS Bank0_Label_DDA0
    JSR Bank0_Func_A6E2
    CMP #$42
    BCC Bank0_Label_DDA5

Bank0_Label_DDA0:
    LDA #$00
    STA a:World1EntityPrimaryBehavior,X

Bank0_Label_DDA5:
    LDA $5C
    CMP #$50
    BCS Bank0_Label_DDBA
    JSR Bank0_Func_DE8E
    CMP #$30
    BCS Bank0_Label_DDBA
    LDA a:World1EntityPrimaryBehavior,X
    BNE Bank0_Label_DDBA
    JSR Bank0_Func_90B0

Bank0_Label_DDBA:
    RTS
    .byte $FD, $FE, $FF, $00, $00, $01, $02, $03, $00, $10, $10, $10, $00, $F0, $F0, $F0
    .byte $1C, $1C, $0C, $FC, $FC, $FC, $0C, $1C

World1_UpdateGozuraUnderground:
    LDA a:World1EntitySecondaryBehavior,X
    LSR A
    LSR A
    CLC
    ADC #$FD
    JSR World1_MoveEntityYByA
    LDA a:World1EntitySecondaryBehavior,X
    LSR A
    LSR A
    LSR A
    AND #$01
    STA $00
    LDA a:World1EntityMetasprite,X
    AND #$FE
    ORA $00
    STA a:World1EntityMetasprite,X
    INC a:World1EntitySecondaryBehavior,X
    LDA a:World1EntitySecondaryBehavior,X
    CMP #$1C
    BCC Bank0_Label_DE04
    LDA #$00
    STA a:World1EntitySecondaryBehavior,X
    STA a:World1EntityPrimaryBehavior,X

Bank0_Label_DE04:
    JSR Bank0_Func_962F
    CMP #$10
    BCS Bank0_Label_DE11
    JSR Bank0_Func_90B0
    JSR Bank0_Func_9130

Bank0_Label_DE11:
    RTS

Bank0_Func_DE12:
    LDA a:World1EntityPositionHigh,X
    STA $A4
    LDA PpuScrollXShadow
    AND #$07
    CLC
    ADC $A0
    BPL Bank0_Label_DE2C
    ADC a:World1EntityX,X
    STA $A0
    LDA $A4
    SBC #$00
    JMP Bank0_Label_DE35

Bank0_Label_DE2C:
    ADC a:World1EntityX,X
    STA $A0
    LDA $A4
    ADC #$00

Bank0_Label_DE35:
    LSR A
    ROR $A0
    LSR A
    ROR $A0
    LDA $A0
    AND #$80
    LSR $A0
    ORA $A0
    CLC
    ADC $5B
    STA $A0
    LDA a:World1EntityPositionHigh,X
    LSR A
    LSR A
    STA $A4
    LDA PpuScrollYShadow
    AND #$07
    CLC
    ADC $A2
    BPL Bank0_Label_DE64
    ADC a:World1EntityY,X
    STA $A2
    LDA $A4
    SBC #$00
    JMP Bank0_Label_DE6D

Bank0_Label_DE64:
    ADC a:World1EntityY,X
    STA $A2
    LDA $A4
    ADC #$00

Bank0_Label_DE6D:
    LSR A
    ROR $A2
    LSR A
    ROR $A2
    LDA $A2
    AND #$80
    LSR $A2
    ORA $A2
    CLC
    ADC $5C
    STA $A2
    STX $A4
    LDX $A0
    LDY $A2
    JSR Bank0_Func_A6A7
    LDX $A4
    CMP #$42
    RTS

Bank0_Func_DE8E:
    LDA a:World1EntityPositionHigh,X
    AND #$0F
    BNE Bank0_Label_DEB8
    SEC
    LDA a:World1EntityX,X
    SBC $75
    BCS Bank0_Label_DEA2
    EOR #$FF
    CLC
    ADC #$01

Bank0_Label_DEA2:
    STA $A0
    SEC
    LDA a:World1EntityY,X
    SBC $76
    BCS Bank0_Label_DEB1
    EOR #$FF
    CLC
    ADC #$01

Bank0_Label_DEB1:
    CMP $A0
    BCS Bank0_Label_DEB7
    LDA $A0

Bank0_Label_DEB7:
    RTS

Bank0_Label_DEB8:
    LDA #$FF
    RTS
