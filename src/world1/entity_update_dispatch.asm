; Doraemon PRG bank 0 $888F-$8A6B
; World 1 entity traversal, low-state RTS dispatch, and shared update helpers
; Generated deterministically from pinned Ghidra/GhidraNes facts

World1_UpdateEntities:
    LDX #$00

Bank0_Label_8891:
    LDA a:World1EntityType,X
    BEQ Bank0_Label_88A1
    BMI Bank0_Label_88B8
    PHA
    LDA World1EnemyFreezeActive
    BNE Bank0_Label_88B4
    PLA
    JSR World1_DispatchEntityUpdate

Bank0_Label_88A1:
    INX

World1_InactiveEntityDispatchTarget:
    CPX #$0A
    BNE Bank0_Label_8891
    RTS

World1_DispatchEntityUpdate:
    AND #$1F
    ASL A
    TAY
    LDA a:$88FC,Y
    PHA
    LDA a:$88FB,Y
    PHA
    RTS

Bank0_Label_88B4:
    PLA
    JMP Bank0_Label_88A1

Bank0_Label_88B8:
    CMP #$C0
    BCS Bank0_Label_88E4
    INC a:World1EntityDamageTimerOrAcceleration,X
    LDA a:World1EntityDamageTimerOrAcceleration,X
    CMP #$28
    BCS Bank0_Label_88D1
    LDA a:World1EntityRenderFlags,X
    ORA #$C0
    STA a:World1EntityRenderFlags,X
    JMP Bank0_Label_88A1

Bank0_Label_88D1:
    LDA a:World1EntityRenderFlags,X
    AND #$03
    STA a:World1EntityRenderFlags,X
    LDA a:World1EntityType,X
    AND #$7F
    STA a:World1EntityType,X
    JMP Bank0_Label_88A1

Bank0_Label_88E4:
    LDA #$02
    STA a:World1EntityPositionHigh,X
    LDA a:World1EntitySourceObjectId,X
    BMI Bank0_Label_88EE

Bank0_Label_88EE:
    LDA a:World1EntityType,X
    AND #$3F
    TAY
    LDA a:World1_EnemyScoreRewardCodes,Y
    JSR World1_AddEncodedScore

World1_EntityUpdateHandlerRtsTable = * + 1  ; overlapping entry $88FB
    JMP Bank0_Label_88A1
    .byte $D9, $DB, $48, $DC, $B1, $DC, $28, $DD, $BA, $DE, $6F, $DF, $1E, $E0, $4A, $E1
    .byte $DF, $E1, $48, $E2, $D2, $DD, $07, $DF, $D9, $DB, $96, $D5, $96, $D5

World1_EnemyScoreRewardCodes:
    .byte $41, $42, $42, $45, $41, $42, $55, $48, $55, $31, $55, $55, $55, $21, $55, $55
    .byte $20, $D4, $8A, $BD, $80, $05, $4C, $45, $8B

Bank0_Func_8934:
    SEC
    LDA a:World1EntityX,X
    SBC $75
    PHP
    LDA #$00
    ROL A
    ASL A
    ASL A
    ORA #$02
    STA a:World1EntitySecondaryBehavior,X
    PLP
    BCC Bank0_Label_894C
    LDA #$40
    BNE Bank0_Label_894E

Bank0_Label_894C:
    LDA #$42

Bank0_Label_894E:
    STA a:World1EntityMetasprite,X
    RTS

Bank0_Func_8952:
    LDA a:World1EntitySecondaryBehavior,X
    EOR #$04
    STA a:World1EntitySecondaryBehavior,X

Bank0_Func_895A:
    LDA a:World1EntitySecondaryBehavior,X
    AND #$07
    JMP Bank0_Func_8962

Bank0_Func_8962:
    PHA
    AND #$07
    PHA
    TAY
    LDA a:$8977,Y
    JSR World1_MoveEntityXByA
    PLA
    TAY
    LDA a:$897F,Y
    JSR World1_MoveEntityYByA
    PLA
    RTS
    .byte $00, $01, $01, $01, $00, $FF, $FF, $FF, $01, $01, $00, $FF, $FF, $FF, $00, $01

Bank0_Func_8987:
    LDA a:World1EntityPositionHigh,X
    STA $00
    LDA a:World1EntityX,X
    LSR $00
    ROR A
    LSR $00
    ROR A
    CLC
    ADC #$40
    STA $01
    LDA a:World1EntityY,X
    LSR $00
    ROR A
    LSR $00
    ROR A
    CLC
    ADC #$40
    STA $00
    LDA $75
    LSR A
    LSR A
    ORA #$40
    SEC
    SBC $01
    STA $01
    BCS Bank0_Label_89FE
    EOR #$FF
    CLC
    ADC #$01
    STA $01
    LDA $76
    LSR A
    LSR A
    ORA #$40
    SEC
    SBC $00
    STA $00
    BCS Bank0_Label_89E7
    EOR #$FF
    CLC
    ADC #$01
    STA $00
    LDA $01
    LSR A
    CMP $00
    BCC Bank0_Label_89DA
    LDA #$06
    RTS

Bank0_Label_89DA:
    LDA $00
    LSR A
    CMP $01
    BCC Bank0_Label_89E4
    LDA #$04
    RTS

Bank0_Label_89E4:
    LDA #$05
    RTS

Bank0_Label_89E7:
    LDA $01
    LSR A
    CMP $00
    BCC Bank0_Label_89F1
    LDA #$06
    RTS

Bank0_Label_89F1:
    LDA $00
    LSR A
    CMP $01
    BCC Bank0_Label_89FB
    LDA #$00
    RTS

Bank0_Label_89FB:
    LDA #$07
    RTS

Bank0_Label_89FE:
    LDA $76
    LSR A
    LSR A
    ORA #$40
    SEC
    SBC $00
    STA $00
    BCS Bank0_Label_8A29
    EOR #$FF
    CLC
    ADC #$01
    STA $00
    LDA $01
    LSR A
    CMP $00
    BCC Bank0_Label_8A1C
    LDA #$02
    RTS

Bank0_Label_8A1C:
    LDA $00
    LSR A
    CMP $01
    BCC Bank0_Label_8A26
    LDA #$04
    RTS

Bank0_Label_8A26:
    LDA #$03
    RTS

Bank0_Label_8A29:
    LDA $01
    LSR A
    CMP $00
    BCC Bank0_Label_8A33
    LDA #$02
    RTS

Bank0_Label_8A33:
    LDA $00
    LSR A
    CMP $01
    BCC Bank0_Label_8A3D
    LDA #$00
    RTS

Bank0_Label_8A3D:
    LDA #$01
    RTS
    .byte $BD, $90, $04, $29, $03, $F0, $0D, $C9, $03, $D0, $1B, $BD, $C0, $04, $C9, $E0
    .byte $B0, $02, $B0, $12, $BD, $90, $04, $29, $0C, $F0, $0E, $C9, $0C, $D0, $07, $BD
    .byte $F0, $04, $C9, $E0, $B0, $03, $A9, $01, $60, $A9, $00, $60
