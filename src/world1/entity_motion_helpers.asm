; Doraemon PRG bank 0 $8F9E-$9200
; World 1 entity direction, motion, and bounds helpers
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank0_Func_8F9E:
    LDA a:World1EntityPrimaryBehavior,X
    JSR World1_MoveEntityXByA
    INC a:World1EntityDamageTimerOrAcceleration,X
    LDA a:World1EntityDamageTimerOrAcceleration,X
    AND #$03
    BNE Bank0_Label_8FBF
    INC a:World1EntityHealthOrVelocity,X
    BMI Bank0_Label_8FBF
    LDA a:World1EntityHealthOrVelocity,X
    CMP #$09
    BCC Bank0_Label_8FBF
    LDA #$08
    STA a:World1EntityHealthOrVelocity,X

Bank0_Label_8FBF:
    LDA a:World1EntityHealthOrVelocity,X
    JMP World1_MoveEntityYByA

Bank0_Func_8FC5:
    LDA a:World1EntityPrimaryBehavior,X
    AND #$07
    ASL A
    STA $01
    LDA FrameCounter
    AND #$01
    ORA $01
    PHA
    TAY
    LDA a:$8FE4,Y
    JSR World1_MoveEntityXByA
    PLA
    TAY
    LDA a:$8FF4,Y
    JSR World1_MoveEntityYByA
    RTS
    .byte $00, $00, $01, $01, $02, $01, $01, $00, $00, $00, $FF, $00, $FE, $FF, $FF, $00
    .byte $02, $01, $01, $01, $00, $00, $FF, $00, $FE, $FF, $FF, $00, $00, $00, $01, $00

Bank0_Func_9004:
    LDA a:World1EntityPositionHigh,X
    STA $A4
    LDA PpuScrollXShadow
    AND #$07
    CLC
    ADC #$04
    ADC a:World1EntityX,X
    STA $A0
    LDA $A4
    ADC #$00
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
    ADC #$04
    ADC a:World1EntityY,X
    STA $A2
    LDA $A4
    ADC #$00
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
    LDA a:$DADA,Y
    RTS

Bank0_Func_9065:
    JSR Bank0_Func_8987
    STA $AA
    JSR Bank0_Func_91E3
    LDA a:World1EntityType+$0A,X
    BNE Bank0_Label_90AF
    JSR Bank0_Func_962F
    CMP #$08
    BCS Bank0_Label_90AF
    LDA #$01
    STA a:World1EntityType+$0A,X
    LDA #$33
    STA a:World1EntityMetasprite+$0A,X
    LDA a:World1EntityPositionHigh,X
    STA a:World1EntityPositionHigh+$0A,X
    LDA #$81
    STA a:World1EntityRenderFlags+$0A,X
    LDA a:World1EntityX,X
    CLC
    ADC #$04
    STA a:World1EntityX+$0A,X
    LDA a:World1EntityY,X
    CLC
    ADC #$04
    STA a:World1EntityY+$0A,X
    LDA #$FF
    STA a:World1EntitySourceObjectId+$0A,X
    LDA $AA
    STA a:World1EntityPrimaryBehavior+$0A,X
    LDA #$02
    STA a:World1EntitySecondaryBehavior+$0A,X

Bank0_Label_90AF:
    RTS

Bank0_Func_90B0:
    LDY #$0A

Bank0_Label_90B2:
    LDA a:World1EntityType+$0A,Y
    BEQ Bank0_Label_90BE
    INY
    CPY #$14
    BNE Bank0_Label_90B2
    SEC
    RTS

Bank0_Label_90BE:
    JSR Bank0_Func_91E3
    LDA #$02
    STA a:World1EntityType+$0A,Y
    LDA #$32
    STA a:World1EntityMetasprite+$0A,Y
    LDA #$01
    STA a:World1EntityRenderFlags+$0A,Y
    LDA a:World1EntityPositionHigh,X
    STA a:World1EntityPositionHigh+$0A,Y
    LDA a:World1EntityX,X
    CLC
    ADC #$04
    STA a:World1EntityX+$0A,Y
    LDA a:World1EntityY,X
    CLC
    ADC #$04
    STA a:World1EntityY+$0A,Y
    LDA #$FF
    STA a:World1EntitySourceObjectId+$0A,Y
    TXA
    PHA
    JSR Bank0_Func_962F
    AND #$0F
    TAX
    LDA a:$9116,X
    STA a:World1EntityPrimaryBehavior+$0A,Y
    JSR Bank0_Func_962F
    LSR A
    LSR A
    AND #$07
    TAX
    LDA a:$9126,X
    STA a:World1EntityHealthOrVelocity+$0A,Y
    LDA #$00
    STA a:World1EntityDamageTimerOrAcceleration+$0A,Y
    LDA #$01
    STA a:World1EntitySecondaryBehavior+$0A,Y
    PLA
    TAX
    RTS
    .byte $FC, $FD, $FE, $FF, $00, $01, $02, $03, $FF, $FE, $FF, $00, $01, $02, $04, $01
    .byte $F9, $FA, $FB, $FC, $FC, $FD, $FD, $FE

Bank0_Label_912E:
    SEC
    RTS

Bank0_Func_9130:
    LDA a:World1EntityType+$0A,X
    BNE Bank0_Label_912E
    JSR Bank0_Func_91E3
    LDA #$00
    STA $AD
    LDA a:World1EntityX,X
    SEC
    SBC $75
    BCS Bank0_Label_914B
    INC $AD
    EOR #$FF
    CLC
    ADC #$01

Bank0_Label_914B:
    STA $AA
    ASL $AD
    LDA a:World1EntityY,X
    SEC
    SBC $76
    BCS Bank0_Label_915E
    INC $AD
    EOR #$FF
    CLC
    ADC #$01

Bank0_Label_915E:
    STA $AB
    ASL $AD
    CMP $AA
    BCC Bank0_Label_9172
    LDA $AA
    STA $AE
    LDA $AB
    STA $B0
    INC $AD
    BNE Bank0_Label_917A

Bank0_Label_9172:
    LDA $AA
    STA $B0
    LDA $AB
    STA $AE

Bank0_Label_917A:
    JSR Bank0_Func_91BF
    LDA #$03
    STA a:World1EntityType+$0A,X
    LDA #$31
    STA a:World1EntityMetasprite+$0A,X
    LDA #$01
    STA a:World1EntityRenderFlags+$0A,X
    LDA a:World1EntityPositionHigh,X
    STA a:World1EntityPositionHigh+$0A,X
    LDA a:World1EntityX,X
    CLC
    ADC #$04
    STA a:World1EntityX+$0A,X
    LDA a:World1EntityY,X
    CLC
    ADC #$04
    STA a:World1EntityY+$0A,X
    LDA #$FF
    STA a:World1EntitySourceObjectId+$0A,X
    LDA $AD
    STA a:World1EntityPrimaryBehavior+$0A,X
    LDA #$01
    STA a:World1EntitySecondaryBehavior+$0A,X
    LDA #$00
    STA a:World1EntityHealthOrVelocity+$0A,X
    LDA $AF
    STA a:World1EntityDamageTimerOrAcceleration+$0A,X
    CLC
    RTS

Bank0_Func_91BF:
    LDA #$00
    STA $AF
    LDA #$08
    STA $B1
    LDA $AE

Bank0_Label_91C9:
    SEC
    SBC $B0
    BCC Bank0_Label_91DB

Bank0_Label_91CE:
    ROL $AF
    ROL A
    DEC $B1
    BNE Bank0_Label_91C9
    RTS

Bank0_Label_91D6:
    CLC
    ADC $B0
    BCS Bank0_Label_91CE

Bank0_Label_91DB:
    ROL $AF
    ROL A
    DEC $B1
    BNE Bank0_Label_91D6
    RTS

Bank0_Func_91E3:
    LDA a:World1EntityPositionHigh,X
    AND #$0F
    BNE Bank0_Label_91FD
    LDA a:World1EntityX,X
    CMP #$F5
    BCS Bank0_Label_91FD
    LDA a:World1EntityY,X
    CMP #$08
    BCC Bank0_Label_91FD
    CMP #$E4
    BCS Bank0_Label_91FD
    RTS

Bank0_Label_91FD:
    PLA
    PLA
    SEC
    RTS
