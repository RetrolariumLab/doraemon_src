; Doraemon PRG bank 1 $A0DC-$A611
; World 2 later enemy handlers and movement tables
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank1_Func_A0DC:
    LDA $41
    BEQ Bank1_Label_A114
    LDY $42
    BEQ Bank1_Label_A103
    DEY
    BEQ Bank1_Label_A0F4
    DEC a:World2EnemyY,X
    BEQ Bank1_Label_A111
    LDA a:World2EnemyY,X
    CMP #$F0
    BCS Bank1_Label_A111
    RTS

Bank1_Label_A0F4:
    INC a:World2EnemyY,X
    LDA a:World2EnemyY,X
    CMP #$E0
    BCC Bank1_Label_A102
    CMP #$F2
    BCC Bank1_Label_A111

Bank1_Label_A102:
    RTS

Bank1_Label_A103:
    LDA $45
    BNE Bank1_Label_A114
    DEC a:World2EnemyX,X
    LDA a:World2EnemyX,X
    CMP #$FA
    BCC Bank1_Label_A114

Bank1_Label_A111:
    JSR Bank1_Func_9B40

Bank1_Label_A114:
    RTS

Bank1_Func_A115:
    LDA $41
    BEQ Bank1_Label_A114
    LDY $42
    BEQ Bank1_Label_A131
    DEY
    BEQ Bank1_Label_A126
    DEC a:World2EnemyProjectileY,X
    BEQ Bank1_Label_A13A
    RTS

Bank1_Label_A126:
    INC a:World2EnemyProjectileY,X
    LDA a:World2EnemyProjectileY,X
    CMP #$D0
    BCS Bank1_Label_A13A
    RTS

Bank1_Label_A131:
    LDA $45
    BNE Bank1_Label_A13F
    DEC a:World2EnemyProjectileX,X
    BNE Bank1_Label_A13F

Bank1_Label_A13A:
    LDA #$00
    STA a:World2EnemyProjectileY,X

Bank1_Label_A13F:
    RTS

World2_SpawnEnemyProjectile:
    LDA $A0
    BNE Bank1_Label_A13F
    STX $79
    LDA World2PlayerX
    CLC
    ADC #$04
    STA $A6
    LDA World2PlayerY
    ADC #$08
    STA $A7
    LDA $41
    BEQ Bank1_Label_A17E
    LDA $42
    BEQ Bank1_Label_A173
    CMP #$01
    BEQ Bank1_Label_A169
    LDA World2PlayerY
    CLC
    ADC #$1F
    STA $A7
    JMP Bank1_Label_A170

Bank1_Label_A169:
    LDA World2PlayerY
    SEC
    SBC #$1F
    STA $A7

Bank1_Label_A170:
    JMP Bank1_Label_A17E

Bank1_Label_A173:
    LDA World2PlayerX
    CLC
    ADC #$40
    BCC Bank1_Label_A17C
    LDA #$FF

Bank1_Label_A17C:
    STA $A6

Bank1_Label_A17E:
    LDA a:World2EnemyX,X
    STA $77
    LDA a:World2EnemyY,X
    STA $78
    LDY #$05

Bank1_Label_A18A:
    LDA a:World2EnemyProjectileY,Y
    BEQ Bank1_Label_A193
    DEY
    BPL Bank1_Label_A18A
    RTS

Bank1_Label_A193:
    LDA $77
    CLC
    ADC #$04
    STA a:World2EnemyProjectileX,Y
    SEC
    SBC $A6
    LDX #$03
    BCS Bank1_Label_A1A5
    DEX
    EOR #$FF

Bank1_Label_A1A5:
    STA a:World2EnemyProjectileMotionX,Y
    LDA $78
    CLC
    ADC #$04
    STA a:World2EnemyProjectileY,Y
    SEC
    SBC $A7
    BCS Bank1_Label_A1B9
    DEX
    DEX
    EOR #$FF

Bank1_Label_A1B9:
    STA a:World2EnemyProjectileMotionY,Y
    CMP a:World2EnemyProjectileMotionX,Y
    BCS Bank1_Label_A1C5
    TXA
    ADC #$04
    TAX

Bank1_Label_A1C5:
    TXA
    STA a:World2EnemyProjectileFlags,Y
    LDA #$00
    STA a:World2EnemyProjectileLifetime,Y
    LDX $79
    RTS

World2_UpdateEnemyProjectiles:
    LDX #$05

Bank1_Label_A1D3:
    LDA a:World2EnemyProjectileY,X
    BEQ Bank1_Label_A233
    LDA a:World2EnemyProjectileFlags,X
    BPL Bank1_Label_A21B
    JSR Bank1_Func_A115
    LDA a:World2EnemyProjectileY,X
    BEQ Bank1_Label_A233
    LDA a:World2EnemyProjectileX,X
    CLC
    ADC a:World2EnemyProjectileMotionX,X
    CMP #$F0
    BCS Bank1_Label_A213
    STA a:World2EnemyProjectileX,X
    LDA a:World2EnemyProjectileY,X
    CLC
    ADC a:World2EnemyProjectileMotionY,X
    CMP #$E0
    BCS Bank1_Label_A213
    STA a:World2EnemyProjectileY,X
    LDA World2FrameCounter
    AND #$03
    BNE Bank1_Label_A269
    INC a:World2EnemyProjectileMotionY,X
    LDA a:World2EnemyProjectileMotionY,X
    BMI Bank1_Label_A269
    CMP #$08
    BCC Bank1_Label_A269

Bank1_Label_A213:
    LDA #$00
    STA a:World2EnemyProjectileY,X
    JMP Bank1_Label_A2BE

Bank1_Label_A21B:
    JSR Bank1_Func_A115
    LDA a:World2EnemyProjectileY,X
    BEQ Bank1_Label_A233
    INC a:World2EnemyProjectileLifetime,X
    LDA a:World2EnemyProjectileLifetime,X
    CMP #$8C
    BCC Bank1_Label_A236
    LDA #$00
    STA a:World2EnemyProjectileY,X
    RTS

Bank1_Label_A233:
    JMP Bank1_Label_A2BE

Bank1_Label_A236:
    LDY a:World2EnemyProjectileFlags,X
    CPY #$04
    BCC Bank1_Label_A26C
    LDA a:World2EnemyProjectileX,X
    CLC
    ADC a:$A2BE,Y
    BEQ Bank1_Label_A29F
    STA a:World2EnemyProjectileX,X
    LDA a:World2EnemyProjectileStepAccumulator,X
    CLC
    ADC a:World2EnemyProjectileMotionY,X
    BCS Bank1_Label_A257
    CMP a:World2EnemyProjectileMotionX,X
    BCC Bank1_Label_A266

Bank1_Label_A257:
    SBC a:World2EnemyProjectileMotionX,X
    PHA
    LDA a:World2EnemyProjectileY,X
    CLC
    ADC a:$A2C2,Y
    STA a:World2EnemyProjectileY,X
    PLA

Bank1_Label_A266:
    STA a:World2EnemyProjectileStepAccumulator,X

Bank1_Label_A269:
    JMP Bank1_Label_A2A4

Bank1_Label_A26C:
    LDA a:World2EnemyProjectileY,X
    CLC
    ADC a:$A2C6,Y
    STA a:World2EnemyProjectileY,X
    LDA a:World2EnemyProjectileStepAccumulator,X
    CLC
    ADC a:World2EnemyProjectileMotionX,X
    BCS Bank1_Label_A284
    CMP a:World2EnemyProjectileMotionY,X
    BCC Bank1_Label_A295

Bank1_Label_A284:
    SBC a:World2EnemyProjectileMotionY,X
    PHA
    LDA a:World2EnemyProjectileX,X
    CLC
    ADC a:$A2C2,Y
    STA a:World2EnemyProjectileX,X
    BEQ Bank1_Label_A29E
    PLA

Bank1_Label_A295:
    STA a:World2EnemyProjectileStepAccumulator,X
    JMP Bank1_Label_A2A4

Bank1_Label_A29B:
    JMP Bank1_Label_A1D3

Bank1_Label_A29E:
    PLA

Bank1_Label_A29F:
    LDA #$00
    STA a:World2EnemyProjectileY,X

Bank1_Label_A2A4:
    LDA a:World2EnemyProjectileX,X
    CLC
    ADC #$04
    STA $67
    LDA a:World2EnemyProjectileY,X
    CLC
    ADC #$04
    STA $68
    JSR World2_TestMetatileCollision
    BEQ Bank1_Label_A2BE
    LDA #$00
    STA a:World2EnemyProjectileY,X

Bank1_Label_A2BE:
    DEX
    BPL Bank1_Label_A29B
    RTS
    .byte $01, $FF, $01, $FF, $01, $01, $FF, $FF

Bank1_Func_A2CA:
    LDX #$05

Bank1_Label_A2CC:
    TXA
    ASL A
    ASL A
    CLC
    ADC #$E8
    TAY
    LDA a:World2EnemyProjectileY,X
    BEQ Bank1_Label_A300
    STA $94
    LDA a:World2EnemyState
    CMP #$12
    BNE Bank1_Label_A2E5
    LDA #$9F
    BNE Bank1_Label_A2E7

Bank1_Label_A2E5:
    LDA #$4B

Bank1_Label_A2E7:
    PHA
    LDA a:World2EnemyProjectileFlags,X
    BPL Bank1_Label_A2F1
    PLA
    LDA #$4A
    PHA

Bank1_Label_A2F1:
    PLA
    STA $95
    LDA #$01
    STA $96
    LDA a:World2EnemyProjectileX,X
    STA $97
    JSR Bank1_Func_96BC

Bank1_Label_A300:
    DEX
    BPL Bank1_Label_A2CC
    RTS

Bank1_Func_A304:
    LDY #$48
    LDX #$06

Bank1_Label_A308:
    LDA a:World2EnemyState,X
    BEQ Bank1_Label_A357
    BMI Bank1_Label_A357
    CMP #$70
    BCC Bank1_Label_A330
    PHA
    LDA #$00
    STA $63
    LDA a:World2EnemyX,X
    STA $60
    LDA a:World2EnemyY,X
    STA $61
    STX $76
    PLA
    AND #$0F
    CLC
    ADC #$13
    JSR Bank1_Func_A35B
    JMP World2_EnemyRenderDispatchContinuation

Bank1_Label_A330:
    PHA
    LDA #$00
    STA $63
    LDA a:World2EnemyX,X
    STA $60
    LDA a:World2EnemyY,X
    STA $61
    STX $76
    PLA
    ASL A
    TAX
    LDA #$A3
    PHA
    LDA #$54
    PHA
    LDA a:$A549,X
    PHA
    LDA a:$A548,X
    PHA
    LDX $76
    RTS

World2_EnemyRenderDispatchContinuation:
    LDX $76

Bank1_Label_A357:
    DEX
    BPL Bank1_Label_A308
    RTS

Bank1_Func_A35B:
    STX $64
    TAX
    LDA a:$A4C4,X
    PHA
    AND #$03
    STA $62
    PLA
    AND #$3C
    STA $65
    TXA
    ASL A
    ASL A
    TAX
    LDA $60
    PHA
    JSR Bank1_Func_A389
    LDA $61
    CMP #$F8
    BEQ Bank1_Label_A380
    CLC
    ADC #$08
    STA $61

Bank1_Label_A380:
    PLA
    STA $60
    JSR Bank1_Func_A389
    LDX $64
    RTS

Bank1_Func_A389:
    JSR Bank1_Func_A38C

Bank1_Func_A38C:
    TXA
    EOR $63
    TAX
    PHA
    LDA a:$A3DC,X
    STA $66
    LDA $65
    EOR $63
    TAX
    LDA $63
    BEQ Bank1_Label_A3A7
    LDA a:$A526,X
    EOR #$40
    JMP Bank1_Label_A3AA

Bank1_Label_A3A7:
    LDA a:$A526,X

Bank1_Label_A3AA:
    ORA $62
    STA $62
    PLA
    EOR $63
    TAX
    INX
    INC $65
    LDA $61
    STA $94
    LDA $66
    STA $95
    LDA $62
    STA $96
    LDA $62
    AND #$03
    STA $62
    LDA $60
    STA $97
    PHA
    LDA $66
    BEQ Bank1_Label_A3D3
    JSR Bank1_Func_96BC

Bank1_Label_A3D3:
    PLA
    CLC
    LDA #$08
    ADC $60
    STA $60
    RTS
    .byte $80, $81, $90, $91, $82, $83, $92, $93, $60, $61, $70, $71, $62, $63, $72, $73
    .byte $B4, $B4, $B4, $B4, $B5, $B5, $B5, $B5, $B6, $B6, $B6, $B6, $46, $46, $56, $56
    .byte $47, $47, $57, $57, $64, $65, $74, $75, $66, $67, $76, $77, $00, $00, $66, $67
    .byte $BA, $BB, $BA, $BB, $C0, $C1, $C0, $C1, $C2, $C3, $C4, $C5, $C6, $C7, $C8, $C9
    .byte $00, $00, $CA, $CB, $84, $85, $94, $95, $94, $95, $84, $85, $D8, $D8, $D8, $D8
    .byte $D9, $D9, $D9, $D9, $E8, $E8, $E8, $E8, $E9, $E9, $E9, $E9, $51, $51, $51, $51
    .byte $50, $50, $50, $50, $41, $41, $41, $41, $40, $40, $40, $40, $4F, $4F, $4F, $4F
    .byte $5F, $5F, $5F, $5F, $8D, $8D, $8D, $8D, $7C, $7C, $6E, $6E, $6E, $6E, $7C, $7C
    .byte $87, $86, $87, $86, $97, $96, $97, $96, $86, $87, $86, $87, $96, $97, $96, $97
    .byte $4D, $4E, $5D, $5E, $6F, $7F, $6D, $7E, $CA, $CB, $CA, $CB, $7D, $DA, $7D, $DA
    .byte $BC, $BD, $CC, $CD, $DC, $DD, $EC, $ED, $BE, $BF, $CE, $CF, $DE, $DF, $EE, $EF
    .byte $E2, $E3, $CC, $CD, $DC, $DD, $EC, $ED, $EB, $BF, $CE, $8E, $DE, $8F, $EE, $9E
    .byte $42, $43, $52, $53, $44, $45, $54, $55, $43, $42, $53, $52, $45, $44, $55, $54
    .byte $42, $43, $4C, $B7, $44, $45, $B8, $B9, $43, $42, $B7, $4C, $45, $44, $B9, $B8
    .byte $48, $49, $58, $59, $5A, $5B, $58, $5C, $01, $01, $01, $01, $12, $12, $12, $05
    .byte $05, $02, $02, $02, $0E, $0E, $03, $03, $03, $01, $09, $10, $10, $10, $10, $10
    .byte $10, $10, $10, $10, $10, $10, $16, $1A, $1F, $1F, $0F, $0F, $01, $01, $0D, $0D
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $03, $03, $23, $23, $03, $03, $23, $23
    .byte $01

World2_EnemyAttackPeriodByState:
    .byte $01, $40, $30, $80, $30, $20, $40, $FF, $FF, $35, $FF, $FF, $20, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF

World2_EnemyDamageThresholdByState:
    .byte $04, $01, $01, $01, $01, $01, $01, $08, $02, $20, $03, $08, $04, $02, $20, $08
    .byte $01, $20, $20, $20, $01, $00, $00, $00, $00, $00, $40, $00, $40, $80, $80, $80
    .byte $80, $00, $00, $80, $80, $00, $40, $80, $C0, $20, $60, $20, $60, $A0, $E0, $A0
    .byte $E0, $40, $40, $C0, $C0, $40, $40

World2_EnemyRenderHandlerRtsTable:
    .byte $40, $40, $45, $9B, $57, $9B, $17, $9C, $84, $9C, $DD, $9C, $35, $9D, $C8, $9D
    .byte $E9, $9D, $19, $9E, $B1, $9E, $FA, $9E, $2D, $9F, $83, $9F, $20, $A0, $E9, $9D
    .byte $20, $A0, $3C, $A0, $6C, $A0, $62, $A0

World2_EnemyUpdateHandlerRtsTable:
    .byte $B8, $A0, $2E, $9B, $E6, $9D, $72, $9B, $2B, $9C, $95, $9C, $04, $9D, $4D, $9D
    .byte $E0, $9D, $05, $9E, $1A, $9E, $BD, $9E, $72, $9B, $39, $9F, $99, $9F, $C4, $9F
    .byte $F3, $9F, $3C, $A0, $3D, $A0, $47, $A0, $A1

World2_EnemyScoreRewardCodeByState:
    .byte $A0, $51, $52, $53, $41, $31, $55, $43, $45, $32, $45, $45, $31, $41, $41, $31
    .byte $00, $21, $21, $21, $45, $01, $02, $03, $04, $05, $06, $07, $06, $05, $04, $03
    .byte $02, $01, $00, $00, $00, $FF, $FE, $FD, $FC, $FB, $FA, $F9, $FA, $FB, $FC, $FD
    .byte $FE, $FF, $00, $00, $00, $02, $04, $06, $08, $06, $04, $02, $00, $FE, $FC, $FA
    .byte $F8, $FA, $FC, $FE, $00, $01, $01, $02, $02, $03, $03, $04, $04, $FF, $FF, $FE
    .byte $FE, $FD, $FD, $FC, $FC, $FD, $FE, $FF, $00, $01, $02, $03, $04, $03, $02, $01
    .byte $00, $FF, $FE, $FD, $FC, $FD, $FE, $FF, $00, $F8, $FA, $FB, $FC, $FD, $FE, $FF
    .byte $00, $00, $01, $02, $03, $04, $05, $06, $08
