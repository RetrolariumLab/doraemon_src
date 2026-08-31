; Doraemon PRG bank 0 $CB61-$CDB4
; World 1 city item interactions and door transition sequence
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank0_Func_CB61:
    TXA
    PHA
    TYA
    PHA
    PHA
    JSR World1_ClearEntitySlots30_37
    PLA
    TAX
    JSR World1_CityItemHandler_Type0A
    PLA
    TAY
    PLA
    TAX
    RTS

World1_CityItemHandler_Type0A:
    LDA a:$0546,X
    BMI Bank0_Label_CB7D
    STA $00
    JSR Bank0_Func_8D81

Bank0_Label_CB7D:
    TXA
    PHA
    LDA #$0E
    JSR World1_Audio_QueueEffect
    LDA #$0A
    STA $97

Bank0_Label_CB88:
    JSR Bank0_Func_94F1
    DEC $97
    BNE Bank0_Label_CB88
    LDA #$50
    STA $97

Bank0_Label_CB93:
    JSR Bank0_Func_94F1
    LDA #$31
    JSR Bank0_Func_81C9
    LDA FrameCounter
    AND #$07
    BNE Bank0_Label_CBA6
    LDA #$08
    JSR World1_Audio_QueueEffectWithPriority

Bank0_Label_CBA6:
    DEC $97
    BNE Bank0_Label_CB93
    PLA
    TAX
    JMP Bank0_Func_C982

World1_CityItemHandler_Type0B:
    LDA a:$0546,X
    BMI Bank0_Label_CBB9
    STA $00
    JSR Bank0_Func_8D81

Bank0_Label_CBB9:
    JSR Bank0_Func_C982
    LDA #$0E
    JSR World1_Audio_QueueEffectWithPriority
    LDA #$31
    JMP Bank0_Func_81C9

World1_CityItemHandler_Type0C:
    LDA a:$0546,X
    BMI Bank0_Label_CBD0
    STA $00
    JSR Bank0_Func_8D81

Bank0_Label_CBD0:
    JSR Bank0_Func_C982
    LDA #$0E
    JSR World1_Audio_QueueEffectWithPriority
    LDA #$32
    JMP Bank0_Func_81C9

World1_CityItemHandler_Type0D:
    LDA a:$0546,X
    BMI Bank0_Label_CBE7
    STA $00
    JSR Bank0_Func_8D81

Bank0_Label_CBE7:
    JSR Bank0_Func_C982
    LDA #$FF
    STA $B2
    LDA #$0E
    JSR World1_Audio_QueueEffectWithPriority
    RTS

World1_CityItemHandlerTable:
    .byte $0E, $CB, $A7, $CA, $C3, $CA, $F5, $CA, $DB, $CA, $32, $CB, $4B, $CB, $73, $CB
    .byte $AF, $CB, $C6, $CB, $DD, $CB, $01, $29, $01, $03, $02, $25, $01, $03, $03, $2E
    .byte $01, $03, $04, $2D, $00, $03, $05, $2F, $01, $10, $06, $00, $01, $02, $07, $30
    .byte $01, $02, $08, $34, $01, $02, $09, $16, $01, $04, $0A, $14, $01, $20, $0B, $28
    .byte $01, $02, $0C, $17, $00, $02, $0D, $35, $03, $02, $14, $1C, $0C, $0C, $0C, $0C
    .byte $0C, $0C, $0C, $0C, $0C, $0C, $0C, $05, $28, $0C, $0C, $0C, $0C, $0C, $0C, $0C
    .byte $0C, $0C, $0C, $0C, $14, $1C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
    .byte $0C, $E8, $FF, $EC, $EC, $EC, $EC, $EC, $EC, $EC, $EC, $EC, $EC, $EC, $00, $18
    .byte $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C

Bank0_TryEnterWorld1Door:
    LDA CombinedControllerButtons
    AND #$80
    BEQ Bank0_Label_CC8B
    LDA $81
    CMP #$02
    BEQ Bank0_EnterWorld1Door

Bank0_Label_CC8B:
    RTS

Bank0_EnterWorld1Door:
    LDA #$00
    STA a:AudioMusicState
    STA a:AudioMusicControl
    STA $82
    STA $83
    STA $B2
    LDA #$13
    JSR World1_Audio_QueueEffect
    JSR World1_ClearEntitySlots00_09
    JSR World1_ClearEntitySlots10_29
    JSR World1_ClearEntitySlots30_37
    LDX $80
    LDA a:$0546,X
    STA $81
    TAY
    LDA a:World1EntityX+$26,X
    CLC
    ADC #$08
    STA $75
    LDA a:World1EntityY+$26,X
    CLC
    ADC #$10
    STA $76
    LDA #$04
    STA $77
    LDA #$00
    STA $78

Bank0_Label_CCC8:
    JSR Bank0_Func_94F1
    LDA #$00
    STA $61
    STA $62
    JSR Bank0_Func_8706
    LDA $61
    ORA $62
    BNE Bank0_Label_CCC8
    LDA #$14

Bank0_Label_CCDC:
    PHA

Bank0_Label_CCDD:
    PHA
    JSR Bank0_Func_94F1
    PLA
    SEC
    SBC #$01
    BNE Bank0_Label_CCDD
    LDX $80
    INC a:World1EntityMetasprite+$26,X
    LDA a:World1EntityMetasprite+$26,X
    CMP #$28
    BEQ Bank0_Label_CCF7
    PLA
    JMP Bank0_Label_CCDC

Bank0_Label_CCF7:
    LDA #$F0
    STA $76
    DEC a:World1EntityMetasprite+$26,X
    LDA #$13
    JSR World1_Audio_QueueEffect
    PLA

Bank0_Label_CD04:
    PHA

Bank0_Label_CD05:
    PHA
    JSR Bank0_Func_94F1
    PLA
    SEC
    SBC #$01
    BNE Bank0_Label_CD05
    LDX $80
    DEC a:World1EntityMetasprite+$26,X
    LDA a:World1EntityMetasprite+$26,X
    CMP #$24
    BEQ Bank0_Label_CD1F
    PLA
    JMP Bank0_Label_CD04

Bank0_Label_CD1F:
    PLA
    JSR World1_ClearEntitySlots38_47
    JSR Bank0_Func_C96A
    LDA $81
    TAY
    LDA a:$CDA9,Y
    BPL Bank0_Label_CD42
    CMP #$FF
    BNE Bank0_Label_CD35
    JMP Bank0_Func_D3A9

Bank0_Label_CD35:
    JSR Bank0_Func_964A
    AND #$03
    TAY
    LDA a:$CDB1,Y
    CMP $81
    BEQ Bank0_Label_CD35

Bank0_Label_CD42:
    ASL A
    ASL A
    TAY
    LDA a:$CD89,Y
    STA $5B
    INY
    LDA a:$CD89,Y
    STA $5C
    INY
    LDA a:$CD89,Y
    INY
    CLC
    ADC #$08
    STA $75
    LDA a:$CD89,Y
    CLC
    ADC #$10
    STA $76
    LDA #$00
    STA $79
    STA $78
    STA $77
    STA $7F
    JSR Bank0_Func_C96A
    JSR Bank0_Func_80DA
    JSR Bank0_Func_A7DB
    JSR Bank0_Func_843B
    JSR Bank0_Func_95ED
    LDX #$0A

Bank0_Label_CD7D:
    JSR Bank0_Func_94F1
    DEX
    BNE Bank0_Label_CD7D
    LDX #$7F
    TXS
    JMP Bank0_Label_82C1
    .byte $B0, $86, $70, $60, $1C, $C2, $70, $60, $02, $A4, $70, $60, $70, $20, $70, $60
    .byte $B8, $5C, $70, $40, $8C, $8C, $70, $60, $1D, $5C, $70, $40, $0C, $D8, $70, $60
    .byte $80, $05, $06, $FF, $80, $01, $02, $80, $00, $05, $04, $07
