; Doraemon PRG bank 1 $98F8-$9B45
; World 2 entity-pool clearing, enemy traversal, and collision dispatch
; Generated deterministically from pinned Ghidra/GhidraNes facts

World2_ClearEntityPools:
    LDX #$06
    LDA #$00

Bank1_Label_98FC:
    STA a:World2EnemyState,X
    DEX
    BPL Bank1_Label_98FC
    LDX #$05

Bank1_Label_9904:
    STA a:World2EnemyProjectileY,X
    DEX
    BPL Bank1_Label_9904
    LDX #$06

Bank1_Label_990C:
    STA a:World2PlayerProjectileState,X
    DEX
    BPL Bank1_Label_990C
    RTS

World2_UpdateEnemies:
    LDX #$06

Bank1_Label_9915:
    LDA a:World2EnemyState,X
    BNE Bank1_Label_991D

Bank1_Label_991A:
    JMP Bank1_Label_9A3F

Bank1_Label_991D:
    BPL Bank1_Label_9922
    JMP World2_UpdatePendingEnemySpawn

Bank1_Label_9922:
    STX World2SavedEntitySlot
    CMP #$70
    BCC Bank1_Label_9946
    JSR World2_ApplyScrollingToEnemy
    LDA World2FrameCounter
    AND #$07
    BNE Bank1_Label_991A
    INC a:World2EnemyState,X
    LDA a:World2EnemyState,X
    CMP #$7B
    BEQ Bank1_Label_993F
    CMP #$74
    BNE Bank1_Label_991A

Bank1_Label_993F:
    LDA #$00
    STA a:World2EnemyState,X
    BEQ Bank1_Label_991A

Bank1_Label_9946:
    STA World2CurrentEnemyStateIndex
    ASL A
    TAX
    LDA #$99
    PHA
    LDA #$64
    PHA
    LDA a:$A571,X
    PHA
    LDA a:$A570,X
    PHA
    LDX World2SavedEntitySlot
    LDA a:World2EnemyX,X
    STA $67
    LDA a:World2EnemyY,X
    STA $68
    RTS

World2_EnemyUpdateDispatchContinuation:
    LDX World2SavedEntitySlot
    LDY World2CurrentEnemyStateIndex
    LDA a:World2EnemyState,X
    BEQ Bank1_Label_991A
    LDA a:World2EnemyX,X
    STA $98
    LDA a:World2EnemyY,X
    STA $99
    JSR World2_TestCurrentEnemyAgainstPlayerAttacks
    BCC Bank1_Label_99E0
    INC a:World2EnemyDamageCounter,X
    LDA a:World2EnemyState,X
    CMP #$11
    BCS Bank1_Label_9991
    LDA DemoModeActive
    BNE Bank1_Label_9999
    LDA World2InventoryState+$02
    CMP #$03
    BEQ Bank1_Label_9999

Bank1_Label_9991:
    LDA a:World2EnemyDamageCounter,X
    CMP a:World2_EnemyDamageThresholdByState,Y
    BCC Bank1_Label_99D8

Bank1_Label_9999:
    LDA DemoModeActive
    BNE Bank1_Label_99A1
    LDA World2InventoryState+$02
    BEQ Bank1_Label_99A5

Bank1_Label_99A1:
    LDA #$78
    BNE World2_ResolveDefeatedEnemy

Bank1_Label_99A5:
    LDA #$70

World2_ResolveDefeatedEnemy:
    PHA
    LDA a:World2EnemyState,X
    TAY
    CMP #$02
    BNE Bank1_Label_99C0
    INC World2TakkonDefeatStreak
    LDA World2TakkonDefeatStreak
    CMP #$04
    BNE World2_AwardEnemyScore
    LDA #$02
    STA World2InventoryState+$03
    STA World2InventoryX+$03
    STA World2InventoryY+$03

Bank1_Label_99C0:
    LDA #$00
    STA World2TakkonDefeatStreak

World2_AwardEnemyScore:
    LDA a:World2_EnemyScoreRewardCodeByState,Y
    BEQ Bank1_Label_99CC
    JSR World2_AddEncodedScore

Bank1_Label_99CC:
    LDA #$05
    JSR World2_Audio_QueueEffectWithPriority
    PLA
    STA a:World2EnemyState,X
    JMP Bank1_Label_9A3F

Bank1_Label_99D8:
    LDA #$03
    JSR World2_Audio_QueueEffectWithPriority
    JMP Bank1_Label_9A3F

Bank1_Label_99E0:
    INC a:World2EnemyAttackTimer,X
    LDA a:World2EnemyAttackTimer,X
    CMP a:World2_EnemyAttackPeriodByState,Y
    BCC Bank1_Label_9A3F
    LDA #$00
    STA a:World2EnemyAttackTimer,X
    JSR World2_SpawnEnemyProjectile
    JMP Bank1_Label_9A3F

World2_UpdatePendingEnemySpawn:
    DEC a:World2EnemyPhaseCounter,X
    BNE Bank1_Label_9A3F
    LDA #$00
    STA a:World2EnemyAttackTimer,X
    LDA a:World2EnemyBehaviorParameter,X
    BEQ Bank1_Label_9A23
    PHA
    LDA a:World2EnemyX,X
    ASL A
    ASL A
    ASL A
    ASL A
    STA a:World2EnemyX,X
    PLA
    CMP #$01
    BEQ Bank1_Label_9A1C
    LDA #$EC
    STA a:World2EnemyY,X
    BNE Bank1_Label_9A32

Bank1_Label_9A1C:
    LDA #$F4
    STA a:World2EnemyY,X
    BNE Bank1_Label_9A32

Bank1_Label_9A23:
    LDA a:World2EnemyX,X
    ASL A
    ASL A
    ASL A
    ASL A
    STA a:World2EnemyY,X
    LDA #$F0
    STA a:World2EnemyX,X

Bank1_Label_9A32:
    LDA a:World2EnemyState,X
    AND #$1F
    EOR #$10
    CLC
    ADC #$01
    STA a:World2EnemyState,X

Bank1_Label_9A3F:
    DEX
    BMI Bank1_Label_9A45
    JMP Bank1_Label_9915

Bank1_Label_9A45:
    RTS

World2_TestCurrentEnemyAgainstPlayerAttacks:
    STX World2EnemyCollisionSlot
    LDA DemoModeActive
    BNE Bank1_Label_9A52
    LDA World2InventoryState+$02
    CMP #$03
    BNE Bank1_Label_9A5A

Bank1_Label_9A52:
    JSR World2_TestSlot2AttackEnemyCollision
    BCC Bank1_Label_9A5A

Bank1_Label_9A57:
    LDX World2EnemyCollisionSlot
    RTS

Bank1_Label_9A5A:
    LDA World2InventorySlot0ProjectileActive
    BEQ Bank1_Label_9A63
    JSR World2_TestSlot0ProjectileEnemyCollision
    BCS Bank1_Label_9A57

Bank1_Label_9A63:
    LDX #$06

Bank1_Label_9A65:
    LDA a:World2PlayerProjectileState,X
    BEQ Bank1_Label_9A94
    LDA a:World2PlayerProjectileY,X
    SEC
    SBC $99
    BCC Bank1_Label_9A78
    CMP #$11
    BCS Bank1_Label_9A94
    BCC Bank1_Label_9A7C

Bank1_Label_9A78:
    CMP #$F8
    BCC Bank1_Label_9A94

Bank1_Label_9A7C:
    LDA $98
    SEC
    SBC a:World2PlayerProjectileX,X
    BCC Bank1_Label_9A90
    CMP #$11
    BCS Bank1_Label_9A94

Bank1_Label_9A88:
    LDA #$00
    STA a:World2PlayerProjectileState,X
    SEC
    BEQ Bank1_Label_9A98

Bank1_Label_9A90:
    CMP #$F8
    BCS Bank1_Label_9A88

Bank1_Label_9A94:
    DEX
    BPL Bank1_Label_9A65

Bank1_Label_9A97:
    CLC

Bank1_Label_9A98:
    LDX World2EnemyCollisionSlot
    RTS

World2_TestSlot0ProjectileEnemyCollision:
    LDA World2InventorySlot0ProjectileY
    SEC
    SBC $99
    BCC Bank1_Label_9AA8
    CMP #$15
    BCS Bank1_Label_9ABC
    BCC Bank1_Label_9AAC

Bank1_Label_9AA8:
    CMP #$F4
    BCC Bank1_Label_9ABC

Bank1_Label_9AAC:
    LDA $98
    SEC
    SBC World2InventorySlot0ProjectileX
    BCC Bank1_Label_9AB9
    CMP #$15
    BCS Bank1_Label_9ABC
    SEC
    RTS

Bank1_Label_9AB9:
    CMP #$F4
    RTS

Bank1_Label_9ABC:
    CLC
    RTS

World2_TestSlot2AttackEnemyCollision:
    LDA World2InventorySlot2AttackActive
    BEQ Bank1_Label_9A97
    LDA World2ScrollDirection
    BEQ Bank1_Label_9AF8
    LDA $99
    SEC
    SBC World2InventoryY+$02
    BCC Bank1_Label_9AD3
    CMP #$11
    BCC Bank1_Label_9AD7

Bank1_Label_9AD1:
    CLC
    RTS

Bank1_Label_9AD3:
    CMP #$F8
    BCC Bank1_Label_9AD1

Bank1_Label_9AD7:
    LDA World2InventorySlot2AttackPhase
    CMP #$10
    BCC Bank1_Label_9ADF
    LDA #$10

Bank1_Label_9ADF:
    ASL A
    STA World2AttackCollisionHalfExtent
    LDA World2InventoryX+$02
    SEC
    SBC World2AttackCollisionHalfExtent
    SBC #$10
    CMP $98
    BCS Bank1_Label_9AD1
    ADC World2AttackCollisionHalfExtent
    ADC World2AttackCollisionHalfExtent
    ADC #$08
    CMP $98
    BCS Bank1_Label_9B2A
    RTS

Bank1_Label_9AF8:
    LDA $98
    SEC
    SBC World2InventoryX+$02
    BCC Bank1_Label_9B05
    CMP #$11
    BCC Bank1_Label_9B09

Bank1_Label_9B03:
    CLC
    RTS

Bank1_Label_9B05:
    CMP #$F8
    BCC Bank1_Label_9B03

Bank1_Label_9B09:
    LDA World2InventorySlot2AttackPhase
    CMP #$10
    BCC Bank1_Label_9B11
    LDA #$10

Bank1_Label_9B11:
    ASL A
    STA World2AttackCollisionHalfExtent
    LDA World2InventoryY+$02
    SEC
    SBC World2AttackCollisionHalfExtent
    SBC #$10
    CMP $99
    BCS Bank1_Label_9B03
    ADC World2AttackCollisionHalfExtent
    ADC World2AttackCollisionHalfExtent
    ADC #$08
    CMP $99
    BCS Bank1_Label_9B2A
    RTS

Bank1_Label_9B2A:
    LDA #$00
    STA World2InventorySlot2AttackActive
    RTS

World2_UpdateAnkodori:
    INC a:World2EnemyPhaseCounter,X
    JSR World2_ApplyScrollingToEnemy
    LDA a:World2EnemyState,X
    BEQ Bank1_Label_9B3F
    DEC a:World2EnemyX,X
    BEQ World2_DeactivateEnemy

Bank1_Label_9B3F:
    RTS

World2_DeactivateEnemy:
    LDA #$00
    STA a:World2EnemyState,X
    RTS
