; Doraemon PRG bank 1 $8F4B-$92EB
; World 2 enemy and projectile behavior handlers
; Generated deterministically from pinned Ghidra/GhidraNes facts

World2_TryStartInventorySlot0Projectile:
    LDA World2InventoryState
    CMP #$03
    BNE Bank1_Label_8F7F
    LDA World2InventorySlot0ProjectileActive
    BNE Bank1_Label_8F7F
    INC World2InventorySlot0ProjectileActive
    LDA World2InventoryX
    CLC
    ADC #$04
    STA World2InventorySlot0ProjectileX
    LDA World2InventoryY
    CLC
    ADC #$0A
    STA World2InventorySlot0ProjectileY
    LDA World2ScrollDirection
    BEQ Bank1_Label_8F7B
    LDA World2InventorySlot0ProjectileAimPhase
    EOR #$01
    STA World2InventorySlot0ProjectileAimPhase
    BEQ Bank1_Label_8F76
    LDA #$0B
    STA World2InventorySlot0ProjectileDirection
    RTS

Bank1_Label_8F76:
    LDA #$05
    STA World2InventorySlot0ProjectileDirection
    RTS

Bank1_Label_8F7B:
    LDA #$02
    STA World2InventorySlot0ProjectileDirection

Bank1_Label_8F7F:
    RTS

World2_StartInventorySlot2Attack:
    LDA World2InventorySlot2AttackActive
    BNE Bank1_Label_8FA1
    LDA #$0A
    JSR World2_Audio_QueueEffectWithPriority
    INC World2InventorySlot2AttackActive
    LDA World2PlayerX
    CLC
    ADC #$04
    STA World2InventoryX+$02
    LDA World2PlayerY
    CLC
    ADC #$08
    STA World2InventoryY+$02
    LDA #$00
    STA World2InventorySlot2AttackPhase
    LDA World2ScrollDirection
    STA World2InventorySlot2AttackDirection

Bank1_Label_8FA1:
    RTS

World2_ScanPlayerHazardContacts:
    LDA #$00
    STA World2PlayerHazardContact
    LDA World2PlayerDamageTimer
    BNE Bank1_Label_8FA1
    LDA World2PlayerX
    CLC
    ADC #$04
    STA $67
    LDA World2PlayerY
    CLC
    ADC #$08
    STA $68
    JSR World2_TestMetatileCollision
    BEQ Bank1_Label_8FC3
    LDA World2StageIndex
    ORA #$80
    STA World2PlayerHazardContact

Bank1_Label_8FC3:
    LDA World2PlayerDamageTimer
    CMP #$50
    BCS Bank1_Label_9009
    LDX #$06

Bank1_Label_8FCB:
    LDA a:World2EnemyState,X
    BEQ Bank1_Label_9006
    CMP #$70
    BCC Bank1_Label_8FD8
    CMP #$80
    BCC Bank1_Label_9006

Bank1_Label_8FD8:
    LDA a:World2EnemyY,X
    CLC
    ADC #$08
    SEC
    SBC World2PlayerY
    BCC Bank1_Label_9006
    CMP #$18
    BCS Bank1_Label_9006
    LDA a:World2EnemyX,X
    CLC
    ADC #$08
    SEC
    SBC World2PlayerX
    BCC Bank1_Label_9006
    CMP #$10
    BCS Bank1_Label_9006
    INC World2PlayerHazardContact
    LDA a:World2EnemyState,X
    CMP #$10
    BCS Bank1_Label_9009
    LDA #$70
    STA a:World2EnemyState,X
    BNE Bank1_Label_9009

Bank1_Label_9006:
    DEX
    BPL Bank1_Label_8FCB

Bank1_Label_9009:
    LDX #$05

Bank1_Label_900B:
    LDA a:World2EnemyProjectileY,X
    BEQ Bank1_Label_9032
    CLC
    ADC #$02
    SEC
    SBC World2PlayerY
    BCC Bank1_Label_9032
    CMP #$16
    BCS Bank1_Label_9032
    LDA a:World2EnemyProjectileX,X
    CLC
    ADC #$02
    SEC
    SBC World2PlayerX
    BCC Bank1_Label_9032
    CMP #$0E
    BCS Bank1_Label_9032
    INC World2PlayerHazardContact
    LDA #$00
    STA a:World2EnemyProjectileY,X

Bank1_Label_9032:
    DEX
    BPL Bank1_Label_900B
    RTS

World2_UpdatePlayerProjectiles:
    JSR World2_UpdateInventorySlot2Attack
    JSR World2_UpdateInventorySlot0Projectile
    LDX #$06

Bank1_Label_903E:
    LDA a:World2PlayerProjectileState,X
    BNE Bank1_Label_9046
    JMP Bank1_Label_90D2

Bank1_Label_9046:
    INC a:World2PlayerProjectileState,X
    BMI Bank1_Label_9071
    LDY World2ScrollDirection
    BEQ Bank1_Label_909F
    DEY
    BEQ Bank1_Label_9074
    LDA a:World2PlayerProjectileDirection,X
    BEQ Bank1_Label_9067
    CMP #$01
    BEQ Bank1_Label_9061
    JSR World2_MovePlayerProjectileDownLeft
    JMP Bank1_Label_9093

Bank1_Label_9061:
    JSR World2_MovePlayerProjectileDownRight
    JMP Bank1_Label_9093

Bank1_Label_9067:
    LDA a:World2PlayerProjectileY,X
    CLC
    ADC #$03
    CMP #$04
    BCS Bank1_Label_9093

Bank1_Label_9071:
    JMP Bank1_Label_90CD

Bank1_Label_9074:
    LDA a:World2PlayerProjectileDirection,X
    BEQ Bank1_Label_9089
    CMP #$01
    BEQ Bank1_Label_9083
    JSR World2_MovePlayerProjectileUpRight
    JMP Bank1_Label_9093

Bank1_Label_9083:
    JSR World2_MovePlayerProjectileUpLeft
    JMP Bank1_Label_9093

Bank1_Label_9089:
    LDA a:World2PlayerProjectileY,X
    SEC
    SBC #$03
    CMP #$E0
    BCS Bank1_Label_90CD

Bank1_Label_9093:
    STA a:World2PlayerProjectileY,X
    STA $68
    LDA a:World2PlayerProjectileX,X
    STA $67
    BNE Bank1_Label_90C8

Bank1_Label_909F:
    LDA a:World2PlayerProjectileDirection,X
    BEQ Bank1_Label_90B4
    CMP #$01
    BEQ Bank1_Label_90AE
    JSR World2_MovePlayerProjectileDownRight
    JMP Bank1_Label_9093

Bank1_Label_90AE:
    JSR World2_MovePlayerProjectileUpRight
    JMP Bank1_Label_9093

Bank1_Label_90B4:
    LDA a:World2PlayerProjectileX,X
    CLC
    ADC #$04
    CMP #$FC
    BCS Bank1_Label_90CD
    STA a:World2PlayerProjectileX,X
    STA $67
    LDA a:World2PlayerProjectileY,X
    STA $68

Bank1_Label_90C8:
    JSR World2_TestMetatileCollision
    BEQ Bank1_Label_90D2

Bank1_Label_90CD:
    LDA #$00
    STA a:World2PlayerProjectileState,X

Bank1_Label_90D2:
    DEX
    BMI Bank1_Label_90D8
    JMP Bank1_Label_903E

Bank1_Label_90D8:
    RTS

World2_MovePlayerProjectileUpRight:
    JSR World2_MovePlayerProjectileRight
    JMP World2_MovePlayerProjectileUp

World2_MovePlayerProjectileDownLeft:
    JSR World2_MovePlayerProjectileLeft
    JMP World2_MovePlayerProjectileDown

World2_MovePlayerProjectileDownRight:
    JSR World2_MovePlayerProjectileRight
    JMP World2_MovePlayerProjectileDown

World2_MovePlayerProjectileUpLeft:
    JSR World2_MovePlayerProjectileLeft
    JMP World2_MovePlayerProjectileUp

World2_MovePlayerProjectileLeft:
    LDA a:World2PlayerProjectileX,X
    SEC
    SBC #$02
    STA a:World2PlayerProjectileX,X
    CMP #$04
    BCC Bank1_Label_9129
    RTS

World2_MovePlayerProjectileRight:
    LDA a:World2PlayerProjectileX,X
    CLC
    ADC #$02
    STA a:World2PlayerProjectileX,X
    CMP #$FC
    BCS Bank1_Label_9129
    RTS

World2_MovePlayerProjectileUp:
    LDA a:World2PlayerProjectileY,X
    SEC
    SBC #$02
    STA a:World2PlayerProjectileY,X
    CMP #$10
    BCC Bank1_Label_9129
    RTS

World2_MovePlayerProjectileDown:
    LDA a:World2PlayerProjectileY,X
    CLC
    ADC #$02
    STA a:World2PlayerProjectileY,X
    CMP #$E0
    BCS Bank1_Label_9129
    RTS

Bank1_Label_9129:
    LDA #$00
    STA a:World2PlayerProjectileState,X
    RTS

World2_UpdateInventorySlot0Projectile:
    LDA World2InventorySlot0ProjectileActive
    BEQ Bank1_Label_916E
    INC World2InventorySlot0ProjectileActive
    LDA World2InventorySlot0ProjectileActive
    CMP #$96
    BCS Bank1_Label_9172
    LDX World2InventorySlot0ProjectileDirection
    LDA World2InventorySlot0ProjectileX
    CLC
    ADC a:$97AD,X
    STA World2InventorySlot0ProjectileX
    CMP #$F8
    BCS Bank1_Label_9172
    STA $67
    LDA World2InventorySlot0ProjectileY
    CLC
    ADC a:$97A9,X
    STA $68
    STA World2InventorySlot0ProjectileY
    CMP #$E0
    BCS Bank1_Label_9172
    JSR World2_TestMetatileCollision
    BNE Bank1_Label_9172
    LDA World2FrameCounter
    AND #$07
    BNE Bank1_Label_916E
    LDA World2InventorySlot0ProjectileDirection
    CMP #$08
    BEQ Bank1_Label_916E
    BCS Bank1_Label_916F
    INC World2InventorySlot0ProjectileDirection

Bank1_Label_916E:
    RTS

Bank1_Label_916F:
    DEC World2InventorySlot0ProjectileDirection
    RTS

Bank1_Label_9172:
    LDA #$00
    STA World2InventorySlot0ProjectileActive
    RTS

World2_UpdateInventorySlot2Attack:
    LDA World2InventorySlot2AttackActive
    BEQ Bank1_Label_91A3
    JSR World2_MoveInventorySlot2Attack
    LDA World2InventoryX+$02
    STA $67
    LDA World2InventoryY+$02
    STA $68
    JSR World2_TestMetatileCollision
    BEQ Bank1_Label_918F
    LDA #$00
    STA World2InventorySlot2AttackActive

Bank1_Label_918F:
    RTS

World2_MoveInventorySlot2Attack:
    LDA World2InventorySlot2AttackDirection
    BNE Bank1_Label_91A4
    INC World2InventorySlot2AttackPhase
    LDA World2InventoryX+$02
    CMP #$F8
    BCS Bank1_Label_91C8
    LDA World2InventoryX+$02
    CLC
    ADC #$08
    STA World2InventoryX+$02

Bank1_Label_91A3:
    RTS

Bank1_Label_91A4:
    CMP #$02
    BNE Bank1_Label_91B8
    INC World2InventorySlot2AttackPhase
    LDA World2InventoryY+$02
    CMP #$F9
    BCS Bank1_Label_91C8
    LDA World2InventoryY+$02
    CLC
    ADC #$07
    STA World2InventoryY+$02
    RTS

Bank1_Label_91B8:
    INC World2InventorySlot2AttackPhase
    LDA World2InventoryY+$02
    CMP #$10
    BCC Bank1_Label_91C8
    LDA World2InventoryY+$02
    SEC
    SBC #$07
    STA World2InventoryY+$02
    RTS

Bank1_Label_91C8:
    LDA #$00
    STA World2InventorySlot2AttackActive

Bank1_Label_91CC:
    RTS

World2_RenderProjectilesAndInventoryAttacks:
    JSR World2_RenderInventorySlot2Attack
    JSR World2_RenderInventorySlot0Projectile
    LDY #$D8
    LDX #$06

Bank1_Label_91D7:
    LDA a:World2PlayerProjectileState,X
    BEQ Bank1_Label_91E6
    LDA a:World2PlayerProjectileY,X
    STA World2OamY
    LDA #$3D
    JSR World2_PreparePlayerProjectileSprite

Bank1_Label_91E6:
    DEX
    CPX #$03
    BNE Bank1_Label_91D7
    LDY #$C8

Bank1_Label_91ED:
    LDA a:World2PlayerProjectileState,X
    BEQ Bank1_Label_9204
    LDA a:World2PlayerProjectileY,X
    STA World2OamY
    LDA World2ScrollDirection
    BEQ Bank1_Label_91FF
    LDA #$3B
    BNE Bank1_Label_9201

Bank1_Label_91FF:
    LDA #$3A

Bank1_Label_9201:
    JSR World2_PreparePlayerProjectileSprite

Bank1_Label_9204:
    DEX
    BPL Bank1_Label_91ED
    RTS

World2_RenderInventorySlot0Projectile:
    LDA World2InventorySlot0ProjectileActive
    BEQ Bank1_Label_921F
    LDY #$E4
    LDA World2InventorySlot0ProjectileY
    STA World2OamY
    LDA #$3C
    STA World2OamTile
    LDA #$03
    STA World2OamAttributes
    LDA World2InventorySlot0ProjectileX
    JMP World2_SetSpriteXBeforeFlickerEmit

Bank1_Label_921F:
    RTS

World2_RenderInventorySlot2Attack:
    LDA World2InventorySlot2AttackActive
    BEQ Bank1_Label_91CC
    LDA World2InventorySlot2AttackPhase
    LSR A
    CMP #$08
    BCC Bank1_Label_922D
    LDA #$08

Bank1_Label_922D:
    STA $69
    ASL A
    ADC $69
    STA $69
    ASL A
    CLC
    ADC $69
    TAX
    LDY #$B8
    LDA World2InventorySlot2AttackDirection
    BEQ Bank1_Label_9242
    JMP Bank1_Label_9295

Bank1_Label_9242:
    LDA World2InventoryX+$02
    STA World2MetaspriteOriginX
    LDA #$20
    STA $6D
    LDA #$04
    STA $69

Bank1_Label_924E:
    LDA a:$9326,X
    BEQ Bank1_Label_9261
    LDA World2InventoryY+$02
    SEC
    SBC $6D
    BCC Bank1_Label_9261
    CMP #$10
    BCC Bank1_Label_9261
    JSR World2_RenderSlot2VerticalAttackSegment

Bank1_Label_9261:
    LDA $6D
    SEC
    SBC #$08
    STA $6D
    INX
    DEC $69
    BNE Bank1_Label_924E
    LDA #$00
    STA $6D
    LDA #$05
    STA $69

Bank1_Label_9275:
    LDA a:$9326,X
    BEQ Bank1_Label_9288
    LDA World2InventoryY+$02
    CLC
    ADC $6D
    BCS Bank1_Label_9288
    CMP #$E0
    BCS Bank1_Label_9288
    JSR World2_RenderSlot2VerticalAttackSegment

Bank1_Label_9288:
    LDA $6D
    CLC
    ADC #$08
    STA $6D
    INX
    DEC $69
    BNE Bank1_Label_9275
    RTS

Bank1_Label_9295:
    LDA World2InventoryX+$02
    STA World2MetaspriteOriginX
    LDA #$20
    STA $6D
    LDA #$04
    STA $69

Bank1_Label_92A1:
    LDA a:$9326,X
    BEQ Bank1_Label_92B6
    LDA World2MetaspriteOriginX
    SEC
    SBC $6D
    BCC Bank1_Label_92B6
    JSR World2_PrepareSlot2HorizontalAttackSegment
    SEC
    SBC $6D
    JSR World2_SetSpriteXBeforeFlickerEmit

Bank1_Label_92B6:
    LDA $6D
    SEC
    SBC #$08
    STA $6D
    INX
    DEC $69
    BNE Bank1_Label_92A1
    LDA #$00
    STA $6D
    LDA #$04
    STA $69

Bank1_Label_92CA:
    LDA a:$9326,X
    BEQ Bank1_Label_92DF
    LDA World2InventoryX+$02
    CLC
    ADC $6D
    BCS Bank1_Label_92DF
    JSR World2_PrepareSlot2HorizontalAttackSegment
    CLC
    ADC $6D
    JSR World2_SetSpriteXBeforeFlickerEmit

Bank1_Label_92DF:
    LDA $6D
    CLC
    ADC #$08
    STA $6D
    INX
    DEC $69
    BNE Bank1_Label_92CA
    RTS
