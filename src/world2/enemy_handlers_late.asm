; Doraemon PRG bank 1 $9F84-$A0DB
; World 2 late indirect enemy-state handlers
; Generated deterministically from pinned Ghidra/GhidraNes facts

World2_RenderPotta:
    LDA a:World2EnemyPhaseCounter,X
    CMP #$28
    BCC Bank1_Label_9F99
    CMP #$30
    BCC Bank1_Label_9F94
    LDA #$1F
    JMP World2_RenderEnemyMetaspriteIndex

Bank1_Label_9F94:
    LDA #$1E
    JMP World2_RenderEnemyMetaspriteIndex

Bank1_Label_9F99:
    RTS

World2_UpdateJura:
    LDY a:World2EnemyPhaseCounter,X
    LDA World2FrameCounter
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
    JMP World2_ApplyScrollingToEnemy

World2_UpdateGanganSpiral:
    JSR World2_ApplyScrollingToEnemy
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

World2_UpdateOroronJuraProjectile:
    DEC a:World2EnemyX,X
    DEC a:World2EnemyX,X
    DEC a:World2EnemyX,X
    LDA World2FrameCounter
    ROR A
    BCS Bank1_Label_A00F
    LDA a:World2EnemyY,X
    SEC
    SBC a:World2EnemyBehaviorParameter,X
    STA a:World2EnemyY,X
    DEC a:World2EnemyBehaviorParameter,X

Bank1_Label_A00F:
    JSR World2_TestMetatileCollision
    BEQ Bank1_Label_A017
    JSR World2_DeactivateEnemy

Bank1_Label_A017:
    LDA World2FrameCounter
    AND #$0F
    BNE Bank1_Label_A020
    INC a:World2EnemyPhaseCounter,X

Bank1_Label_A020:
    RTS

World2_RenderJuraAndOroronProjectile:
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
    JMP World2_RenderEnemyMetaspriteIndex
    .byte $17, $18, $19, $18

World2_OroronIwaStateNoOp:
    RTS

World2_UpdateBigRoboShip:
    JSR World2_ApplyEnemyOrbitStep
    LDA World2FrameCounter
    AND #$03
    BEQ Bank1_Label_A057
    RTS

World2_UpdateCentaurus:
    LDA World2FrameCounter
    AND #$01
    BNE Bank1_Label_A062
    JSR World2_ApplyEnemyOrbitStep
    LDA World2FrameCounter
    AND #$02
    BNE Bank1_Label_A062

Bank1_Label_A057:
    INC a:World2EnemyPhaseCounter,X
    LDA a:World2EnemyPhaseCounter,X
    AND #$0F
    STA a:World2EnemyPhaseCounter,X

Bank1_Label_A062:
    RTS

World2_RenderCentaurus:
    LDA World2FrameCounter
    AND #$10
    ROR A
    ROR A
    ADC #$30
    BNE Bank1_Label_A073

World2_RenderBigRoboShip:
    LDA World2FrameCounter
    AND #$04
    ADC #$28

Bank1_Label_A073:
    STA $67
    JSR World2_RenderEnemyCompositePart
    JSR World2_RenderEnemyCompositePart
    LDA $60
    CLC
    ADC #$10
    STA $60
    LDA $61
    SEC
    SBC #$20
    STA $61
    JSR World2_RenderEnemyCompositePart

World2_RenderEnemyCompositePart:
    LDA $67
    JSR World2_RenderEnemyMetaspriteIndex
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

World2_UpdateRoboShip:
    INC a:World2EnemyY,X
    DEC a:World2EnemyX,X
    DEC a:World2EnemyX,X
    DEC a:World2EnemyX,X
    LDA a:World2EnemyX,X
    CMP #$F0
    BCC Bank1_Label_A0B8
    JMP World2_DeactivateEnemy

Bank1_Label_A0B8:
    RTS

World2_RenderRoboShip:
    LDA World2FrameCounter
    AND #$04
    ROR A
    ROR A
    ADC #$38
    JMP World2_RenderEnemyMetaspriteIndex

World2_ApplyEnemyOrbitStep:
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
