; Doraemon PRG bank 1 $9F84-$A0DB
; World 2 late indirect enemy-state handlers
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank1_Func_9F84:
    LDA a:World2EnemyPhaseCounter,X
    CMP #$28
    BCC Bank1_Label_9F99
    CMP #$30
    BCC Bank1_Label_9F94
    LDA #$1F
    JMP Bank1_Func_A35B

Bank1_Label_9F94:
    LDA #$1E
    JMP Bank1_Func_A35B

Bank1_Label_9F99:
    RTS

Bank1_Func_9F9A:
    LDY a:World2EnemyPhaseCounter,X
    LDA $73
    AND #$03
    BNE Bank1_Label_9FC2
    LDA a:World2EnemyY,X
    CLC
    ADC a:$A5EE,Y
    STA a:World2EnemyY,X
    LDA a:World2EnemyX,X
    CLC
    ADC a:$A5F2,Y
    STA a:World2EnemyX,X
    INC a:World2EnemyPhaseCounter,X
    LDA a:World2EnemyPhaseCounter,X
    AND #$0F
    STA a:World2EnemyPhaseCounter,X

Bank1_Label_9FC2:
    JMP Bank1_Func_A0DC

Bank1_Func_9FC5:
    JSR Bank1_Func_A0DC
    INC a:World2EnemyY,X
    INC a:World2EnemyY,X
    INC a:World2EnemyY,X
    LDY a:World2EnemyPhaseCounter,X
    LDA a:World2EnemyY,X
    CLC
    ADC a:$A5EE,Y
    STA a:World2EnemyY,X
    LDA a:World2EnemyX,X
    CLC
    ADC a:$A5F2,Y
    STA a:World2EnemyX,X
    INC a:World2EnemyPhaseCounter,X
    LDA a:World2EnemyPhaseCounter,X
    AND #$0F
    STA a:World2EnemyPhaseCounter,X
    RTS

Bank1_Func_9FF4:
    DEC a:World2EnemyX,X
    DEC a:World2EnemyX,X
    DEC a:World2EnemyX,X
    LDA $73
    ROR A
    BCS Bank1_Label_A00F
    LDA a:World2EnemyY,X
    SEC
    SBC a:World2EnemyBehaviorParameter,X
    STA a:World2EnemyY,X
    DEC a:World2EnemyBehaviorParameter,X

Bank1_Label_A00F:
    JSR Bank1_Func_9377
    BEQ Bank1_Label_A017
    JSR Bank1_Func_9B40

Bank1_Label_A017:
    LDA $73
    AND #$0F
    BNE Bank1_Label_A020
    INC a:World2EnemyPhaseCounter,X

Bank1_Label_A020:
    RTS

Bank1_Func_A021:
    LDA a:World2EnemyPhaseCounter,X
    PHA
    AND #$01
    TAX
    PLA
    CMP #$02
    BCC Bank1_Label_A033
    AND #$01
    CLC
    ADC #$02
    TAX

Bank1_Label_A033:
    LDA a:$A039,X
    JMP Bank1_Func_A35B
    .byte $17, $18, $19, $18

Bank1_Func_A03D:
    RTS

Bank1_Func_A03E:
    JSR Bank1_Func_A0C4
    LDA $73
    AND #$03
    BEQ Bank1_Label_A057
    RTS

Bank1_Func_A048:
    LDA $73
    AND #$01
    BNE Bank1_Label_A062
    JSR Bank1_Func_A0C4
    LDA $73
    AND #$02
    BNE Bank1_Label_A062

Bank1_Label_A057:
    INC a:World2EnemyPhaseCounter,X
    LDA a:World2EnemyPhaseCounter,X
    AND #$0F
    STA a:World2EnemyPhaseCounter,X

Bank1_Label_A062:
    RTS

Bank1_Func_A063:
    LDA $73
    AND #$10
    ROR A
    ROR A
    ADC #$30
    BNE Bank1_Label_A073

Bank1_Func_A06D:
    LDA $73
    AND #$04
    ADC #$28

Bank1_Label_A073:
    STA $67
    JSR Bank1_Func_A08C
    JSR Bank1_Func_A08C
    LDA $60
    CLC
    ADC #$10
    STA $60
    LDA $61
    SEC
    SBC #$20
    STA $61
    JSR Bank1_Func_A08C

Bank1_Func_A08C:
    LDA $67
    JSR Bank1_Func_A35B
    LDA $60
    SEC
    SBC #$10
    STA $60
    LDA $61
    CLC
    ADC #$08
    STA $61
    INC $67
    RTS

Bank1_Func_A0A2:
    INC a:World2EnemyY,X
    DEC a:World2EnemyX,X
    DEC a:World2EnemyX,X
    DEC a:World2EnemyX,X
    LDA a:World2EnemyX,X
    CMP #$F0
    BCC Bank1_Label_A0B8
    JMP Bank1_Func_9B40

Bank1_Label_A0B8:
    RTS

Bank1_Func_A0B9:
    LDA $73
    AND #$04
    ROR A
    ROR A
    ADC #$38
    JMP Bank1_Func_A35B

Bank1_Func_A0C4:
    LDY a:World2EnemyPhaseCounter,X
    LDA a:World2EnemyY,X
    CLC
    ADC a:$A5EE,Y
    STA a:World2EnemyY,X
    LDA a:World2EnemyX,X
    CLC
    ADC a:$A5F2,Y
    STA a:World2EnemyX,X
    RTS
