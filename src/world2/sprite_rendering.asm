; Doraemon PRG bank 1 $9661-$98F7
; World 2 metasprite composition, OAM placement, and entity spawning
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank1_Func_9661:
    JSR Bank1_Func_9688
    JSR Bank1_Func_9688
    JMP Bank1_Label_9560

Bank1_Label_966A:
    RTS

Bank1_Func_966B:
    LDA $61
    STA $94
    LDA a:$96E1,X
    STA $95
    LDA $62
    STA $96
    LDA $60
    STA $97
    INX
    JSR Bank1_Func_96C8
    LDA $97
    CLC
    ADC #$08
    STA $60
    RTS

Bank1_Func_9688:
    LDA $61
    STA $94
    LDA a:$96E1,X
    BPL Bank1_Label_969B
    AND #$7F
    STA $95
    LDA $62
    ORA #$40
    BNE Bank1_Label_969F

Bank1_Label_969B:
    STA $95
    LDA $62

Bank1_Label_969F:
    STA $96
    LDA $60
    STA $97
    INX
    JSR Bank1_Func_96BC
    LDA $97
    CLC
    ADC #$08
    STA $60
    RTS

Bank1_Func_96B1:
    STA $95
    LDA #$02
    STA $96
    LDA a:World2PlayerProjectileX,X

Bank1_Func_96BA:
    STA $97

Bank1_Func_96BC:
    TYA
    EOR $93
    TAY
    JSR Bank1_Func_96C8
    TYA
    EOR $93
    TAY
    RTS

Bank1_Func_96C8:
    LDA $94
    STA a:OamBuffer,Y
    INY
    LDA $95
    STA a:OamBuffer,Y
    INY
    LDA $96
    STA a:OamBuffer,Y
    INY
    LDA $97
    STA a:OamBuffer,Y
    INY
    RTS
    .byte $00, $01, $10, $11, $20, $21, $04, $05, $10, $11, $20, $21, $00, $01, $10, $11
    .byte $14, $15, $04, $05, $10, $11, $14, $15, $03, $83, $13, $93, $23, $A3, $03, $83
    .byte $13, $93, $23, $A3, $02, $82, $12, $24, $22, $A2, $02, $82, $A4, $92, $22, $A2
    .byte $06, $07, $16, $17, $37, $25, $87, $86, $97, $96, $A5, $B7, $0E, $0F, $1E, $1F
    .byte $2E, $2F, $30, $39, $1E, $1F, $2E, $2F, $0D, $8D, $1D, $9D, $2D, $AD, $0D, $8D
    .byte $1D, $9D, $2D, $AD, $31, $B1, $33, $34, $32, $B2, $31, $B1, $35, $36, $32, $B2
    .byte $0D, $8D, $1D, $9D, $2D, $AD, $0D, $8D, $2C, $AC, $2D, $AD, $09, $0A, $19, $1A
    .byte $29, $2A, $38, $26, $19, $1A, $29, $2A, $08, $88, $18, $98, $28, $A8, $08, $88
    .byte $18, $98, $28, $A8, $0B, $8B, $1B, $27, $2B, $AB, $0B, $8B, $A7, $9B, $2B, $AB
    .byte $08, $88, $18, $98, $28, $A8, $08, $88, $0C, $8C, $28, $A8, $D6, $D7, $E6, $E7
    .byte $00, $00, $EA, $EA, $D0, $D0, $E0, $E0, $D4, $D5, $E4, $E5, $D0, $D0, $E0, $E0
    .byte $D1, $D1, $00, $00, $E0, $E0, $D0, $D0, $00, $00, $D1, $D1, $D3, $D2, $E1, $00
    .byte $E1, $00, $D3, $D2, $01, $41, $81, $C1, $FD, $FD, $FE, $FF, $00, $01, $02, $03
    .byte $03, $03, $02, $01, $00, $FF, $FE, $FD, $FD, $FD, $FE, $FF, $C1, $C1, $C2, $C1
    .byte $C2, $C2, $C1, $C2

World2_UpdateBossEncounter:
    LDX World2StageIndex
    LDA World2BossEncounterState
    BNE Bank1_Label_97D5
    LDA World2CurrentScreenId
    CMP a:World2_BossTriggerScreenByArea,X
    BNE Bank1_Label_97D4
    INC World2BossEncounterState

Bank1_Label_97D4:
    RTS

Bank1_Label_97D5:
    CMP #$02
    BEQ Bank1_Label_97FC
    LDA $3F
    CMP #$F0
    BNE Bank1_Label_97D4
    INC World2BossEncounterState
    LDA #$04
    STA a:AudioMusicState
    LDA a:World2_BossStateByArea,X
    STA a:World2EnemyState
    LDA a:World2_BossInitialXByArea,X
    STA a:World2EnemyX
    LDA a:World2_BossInitialYByArea,X
    STA a:World2EnemyY
    LDX #$00
    BEQ World2_ResetSpawnedEnemyCombatState

Bank1_Label_97FC:
    LDA a:World2EnemyState
    BNE Bank1_Label_9809
    LDA #$04
    JSR World2_Audio_QueueEffect
    JMP World2_CompleteBossEncounter

Bank1_Label_9809:
    LDX World2StageIndex
    BEQ Bank1_Label_9864
    DEX
    BEQ Bank1_Label_9834
    LDA World2FrameCounter
    AND #$07
    BNE Bank1_Label_9822
    LDX #$06

Bank1_Label_9818:
    LDA a:World2EnemyState,X
    BEQ Bank1_Label_9823
    DEX
    CPX #$03
    BNE Bank1_Label_9818

Bank1_Label_9822:
    RTS

Bank1_Label_9823:
    LDA #$04
    STA a:World2EnemyState,X
    LDA #$30
    STA a:World2EnemyY,X
    LDA #$C8
    STA a:World2EnemyX,X
    BNE World2_ResetSpawnedEnemyCombatState

Bank1_Label_9834:
    LDA World2FrameCounter
    AND #$07
    BNE Bank1_Label_98A2
    LDX #$06

Bank1_Label_983C:
    LDA a:World2EnemyState,X
    BEQ Bank1_Label_9847
    DEX
    CPX #$03
    BNE Bank1_Label_983C
    RTS

Bank1_Label_9847:
    LDA #$14
    STA a:World2EnemyState,X
    LDA a:World2EnemyY
    STA a:World2EnemyY,X
    LDA a:World2EnemyX
    STA a:World2EnemyX,X

World2_ResetSpawnedEnemyCombatState:
    JSR World2_ResetEnemyPhaseCounter

World2_ClearEnemyCombatCounters:
    LDA #$00
    STA a:World2EnemyDamageCounter,X
    STA a:World2EnemyAttackTimer,X
    RTS

Bank1_Label_9864:
    LDA World2FrameCounter
    AND #$03
    BNE Bank1_Label_98A2
    LDX #$06

Bank1_Label_986C:
    LDA a:World2EnemyState,X
    BEQ Bank1_Label_9875
    DEX
    BPL Bank1_Label_986C
    RTS

Bank1_Label_9875:
    LDA #$08
    JSR World2_Audio_QueueEffectWithPriority
    LDA #$10
    STA a:World2EnemyState,X
    LDA #$80
    STA a:World2EnemyY,X
    LDA World2FrameCounter
    AND #$04
    ASL A
    ASL A
    CLC
    ADC #$CE
    STA a:World2EnemyX,X
    JSR World2_ResetSpawnedEnemyCombatState
    LDA World2FrameCounter
    LSR A
    LSR A
    LSR A
    LSR A
    AND #$0F
    TAY
    LDA a:World2_OroronProjectilePhaseSequence,Y
    STA a:World2EnemyBehaviorParameter,X

Bank1_Label_98A2:
    RTS

World2_CompleteBossEncounter:
    LDA #$05
    STA a:AudioMusicState
    INC $B3
    RTS

World2_OroronProjectilePhaseSequence:
    .byte $02, $03, $04, $05, $06, $07, $08, $09, $0A, $09, $08, $07, $06, $05, $04, $03

World2_BossTriggerScreenByArea:
    .byte $11, $40, $67

World2_BossStateByArea:
    .byte $11, $12, $13

World2_BossInitialXByArea:
    .byte $DC, $78, $B4

World2_BossInitialYByArea:
    .byte $98, $50, $64

World2_SpawnEnemy:
    STX $75
    LDX #$06

Bank1_Label_98CB:
    LDA a:World2EnemyState,X
    BEQ Bank1_Label_98D6
    DEX
    BPL Bank1_Label_98CB
    LDX $75
    RTS

Bank1_Label_98D6:
    LDA $42
    BEQ Bank1_Label_98DE
    LDA #$01
    BNE Bank1_Label_98E0

Bank1_Label_98DE:
    LDA #$1E

Bank1_Label_98E0:
    STA a:World2EnemyPhaseCounter,X
    LDA World2EnemySpawnState
    STA a:World2EnemyState,X
    LDA $75
    STA a:World2EnemyX,X
    LDA $42
    STA a:World2EnemyBehaviorParameter,X
    JSR World2_ClearEnemyCombatCounters
    LDX $75
    RTS
