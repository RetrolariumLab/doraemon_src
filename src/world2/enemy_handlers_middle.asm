; Doraemon PRG bank 1 $9D4E-$9F83
; World 2 middle indirect enemy-state handlers
; Generated deterministically from pinned Ghidra/GhidraNes facts

World2_UpdateBorukka:
    LDA a:World2EnemyBehaviorParameter,X
    BNE Bank1_Label_9D5E
    LDA a:World2EnemyPhaseCounter,X
    CMP #$07
    BEQ Bank1_Label_9D71
    INC a:World2EnemyPhaseCounter,X
    RTS

Bank1_Label_9D5E:
    LDA a:World2EnemyPhaseCounter,X
    BNE Bank1_Label_9D71
    LDA a:World2EnemyX,X
    CLC
    ADC #$08
    STA a:World2EnemyX,X
    LDA #$07
    STA a:World2EnemyPhaseCounter,X

Bank1_Label_9D71:
    JSR World2_ApplyScrollingToEnemy
    LDA a:World2EnemyY,X
    CMP #$20
    BCC Bank1_Label_9D9A
    CMP #$D0
    BCS Bank1_Label_9D9A
    LDA a:World2EnemyX,X
    CMP #$F0
    BCS Bank1_Label_9D9A
    CMP #$10
    BCC Bank1_Label_9D9A
    LDA World2FrameCounter
    AND #$03
    BNE Bank1_Label_9D9A
    LDY #$05

Bank1_Label_9D92:
    LDA a:World2EnemyProjectileY,Y
    BEQ Bank1_Label_9D9B
    DEY
    BPL Bank1_Label_9D92

Bank1_Label_9D9A:
    RTS

Bank1_Label_9D9B:
    LDA #$08
    JSR World2_Audio_QueueEffectWithPriority
    LDA a:World2EnemyX,X
    CLC
    ADC #$04
    STA a:World2EnemyProjectileX,Y
    LDA a:World2EnemyY,X
    STA a:World2EnemyProjectileY,Y
    LDA #$80
    STA a:World2EnemyProjectileFlags,Y
    LDA World2FrameCounter
    AND #$1C
    ROR A
    ROR A
    ORA #$F8
    STA a:World2EnemyProjectileMotionY,Y
    AND #$01
    ASL A
    SEC
    SBC #$01
    STA a:World2EnemyProjectileMotionX,Y

Bank1_Label_9DC8:
    RTS

World2_RenderBorukka:
    LDA a:World2EnemyPhaseCounter,X
    CMP #$07
    BNE Bank1_Label_9DC8
    LDA #$0E
    STA $98
    LDA World2FrameCounter
    AND #$20
    BEQ Bank1_Label_9DDC
    INC $98

Bank1_Label_9DDC:
    LDA $98
    JMP World2_RenderEnemyMetaspriteIndex

World2_UpdateGanganStraight:
    JSR World2_ApplyScrollingTwiceToEnemy

World2_ApplyScrollingTwiceToEnemy:
    JSR World2_ApplyScrollingToEnemy

World2_UpdateTakkon:
    JMP World2_ApplyScrollingToEnemy

World2_RenderGangan:
    LDA World2FrameCounter
    AND #$0C
    LSR A
    LSR A
    TAX
    LDA a:$9E02,X
    STA World2MetaspriteFlipMask
    LDA a:$9DFE,X
    LDX World2SavedEntitySlot
    JMP World2_RenderEnemyMetaspriteIndex
    .byte $11, $11, $12, $12, $00, $01, $01, $00

World2_UpdateBuran:
    LDA a:World2EnemyPhaseCounter,X
    BNE Bank1_Label_9E17
    INC a:World2EnemyPhaseCounter,X
    LDA a:World2EnemyX,X
    SEC
    SBC #$0C
    STA a:World2EnemyX,X

Bank1_Label_9E17:
    JMP World2_ApplyScrollingToEnemy

World2_RenderBuranInvisible:
    RTS

World2_UpdateTosshin:
    LDA a:World2EnemyPhaseCounter,X
    CMP #$50
    BCS Bank1_Label_9E34
    LDA a:World2EnemyPhaseCounter,X
    LDA a:World2EnemyBehaviorParameter,X
    BEQ Bank1_Label_9E75
    INC a:World2EnemyPhaseCounter,X
    LDA a:World2EnemyPhaseCounter,X
    CMP #$28
    BCS Bank1_Label_9E37

Bank1_Label_9E34:
    JMP World2_ApplyScrollingToEnemy

Bank1_Label_9E37:
    LDA a:World2EnemyPhaseCounter,X
    CMP #$3C
    BCS Bank1_Label_9E65
    LDA World2PlayerX
    CLC
    ADC #$04
    SEC
    SBC a:World2EnemyX,X
    BEQ Bank1_Label_9E54
    LDA a:World2EnemyX,X
    BCS Bank1_Label_9E50
    SBC #$05

Bank1_Label_9E50:
    ADC #$02
    STA $67

Bank1_Label_9E54:
    JSR World2_TestMetatileCollision
    BNE Bank1_Label_9E5F
    JSR World2_CommitEnemyCandidatePosition
    JMP World2_ApplyScrollingToEnemy

Bank1_Label_9E5F:
    JSR World2_ResetEnemyPhaseCounter
    JMP World2_ApplyScrollingToEnemy

Bank1_Label_9E65:
    LDA a:World2EnemyY,X
    CMP World2PlayerY
    BCS Bank1_Label_9E6E
    ADC #$09

Bank1_Label_9E6E:
    SBC #$04
    STA $68
    JMP Bank1_Label_9E54

Bank1_Label_9E75:
    INC a:World2EnemyPhaseCounter,X
    LDA a:World2EnemyPhaseCounter,X
    CMP #$28
    BCS Bank1_Label_9E82
    JMP World2_ApplyScrollingToEnemy

Bank1_Label_9E82:
    LDA a:World2EnemyPhaseCounter,X
    CMP #$3C
    BCS Bank1_Label_9EA2
    LDA World2PlayerY
    CLC
    ADC #$08
    SEC
    SBC a:World2EnemyY,X
    BEQ Bank1_Label_9E54
    LDA a:World2EnemyY,X
    BCS Bank1_Label_9E9B
    SBC #$05

Bank1_Label_9E9B:
    ADC #$02
    STA $68
    JMP Bank1_Label_9E54

Bank1_Label_9EA2:
    LDA a:World2EnemyX,X
    CMP World2PlayerX
    BCS Bank1_Label_9EAB
    ADC #$09

Bank1_Label_9EAB:
    SBC #$04
    STA $67
    JMP Bank1_Label_9E54

World2_RenderTosshin:
    LDA World2FrameCounter
    AND #$08
    ROR A
    ROR A
    ROR A
    ADC #$24
    JMP World2_RenderEnemyMetaspriteIndex

World2_UpdateKyon:
    LDA a:World2EnemyBehaviorParameter,X
    BEQ Bank1_Label_9ED1
    LDY a:World2EnemyPhaseCounter,X
    LDA $67
    CLC
    ADC a:$A5DE,Y
    STA $67
    JMP Bank1_Label_9EDC

Bank1_Label_9ED1:
    LDY a:World2EnemyPhaseCounter,X
    LDA $68
    CLC
    ADC a:$A5DE,Y
    STA $68

Bank1_Label_9EDC:
    JSR World2_TestMetatileCollision
    BNE Bank1_Label_9EED
    JSR World2_CommitEnemyCandidatePosition
    STA a:World2EnemyY,X
    LDA World2FrameCounter
    AND #$03
    BNE Bank1_Label_9EF8

Bank1_Label_9EED:
    INC a:World2EnemyPhaseCounter,X
    LDA a:World2EnemyPhaseCounter,X
    AND #$0F
    STA a:World2EnemyPhaseCounter,X

Bank1_Label_9EF8:
    JMP World2_ApplyScrollingToEnemy

World2_RenderKyon:
    LDA a:World2EnemyPhaseCounter,X
    AND #$08
    STA $67
    LDA World2FrameCounter
    AND #$10
    ROR A
    ROR A
    ORA $67
    ROR A
    ROR A
    ADC #$20
    JMP World2_RenderEnemyMetaspriteIndex
    .byte $BD, $5F, $05, $18, $79, $C2, $A2, $79, $C2, $A2, $85, $67, $20, $77, $93, $F0
    .byte $06, $FE, $6D, $05, $4C, $DC, $A0, $20, $2B, $9D, $4C, $DC, $A0

World2_RenderJoki:
    LDA World2FrameCounter
    AND #$08
    ROR A
    ROR A
    ROR A
    ADC #$26
    JMP World2_RenderEnemyMetaspriteIndex

World2_UpdatePotta:
    LDA a:World2EnemyPhaseCounter,X
    BNE Bank1_Label_9F4E
    INC a:World2EnemyPhaseCounter,X
    LDA a:World2EnemyY,X
    CLC
    ADC #$10
    STA a:World2EnemyY,X
    JMP World2_ApplyScrollingToEnemy

Bank1_Label_9F4E:
    CMP #$28
    BCS Bank1_Label_9F58
    INC a:World2EnemyPhaseCounter,X
    JMP World2_ApplyScrollingToEnemy

Bank1_Label_9F58:
    LDY a:World2EnemyPhaseCounter,X
    LDA a:World2EnemyY,X
    CLC
    ADC a:$A5DA,Y
    STA a:World2EnemyY,X
    CMP #$F0
    BCS Bank1_Label_9F81
    LDA World2FrameCounter
    AND #$03
    BNE Bank1_Label_9F7E
    INC a:World2EnemyPhaseCounter,X
    LDA a:World2EnemyPhaseCounter,X
    CMP #$38
    BNE Bank1_Label_9F7E
    LDA #$28
    STA a:World2EnemyPhaseCounter,X

Bank1_Label_9F7E:
    JMP World2_ApplyScrollingToEnemy

Bank1_Label_9F81:
    JMP World2_DeactivateEnemy
