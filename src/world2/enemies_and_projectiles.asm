; Doraemon PRG bank 1 $8F4B-$92EB
; World 2 enemy and projectile behavior handlers
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank1_Func_8F4B:
    LDA $7C
    CMP #$03
    BNE Bank1_Label_8F7F
    LDA $6F
    BNE Bank1_Label_8F7F
    INC $6F
    LDA $83
    CLC
    ADC #$04
    STA $70
    LDA $8A
    CLC
    ADC #$0A
    STA $71
    LDA $42
    BEQ Bank1_Label_8F7B
    LDA $A1
    EOR #$01
    STA $A1
    BEQ Bank1_Label_8F76
    LDA #$0B
    STA $72
    RTS

Bank1_Label_8F76:
    LDA #$05
    STA $72
    RTS

Bank1_Label_8F7B:
    LDA #$02
    STA $72

Bank1_Label_8F7F:
    RTS

Bank1_Func_8F80:
    LDA $6A
    BNE Bank1_Label_8FA1
    LDA #$0A
    JSR World2_Audio_QueueEffectWithPriority
    INC $6A
    LDA $5C
    CLC
    ADC #$04
    STA $85
    LDA $5D
    CLC
    ADC #$08
    STA $8C
    LDA #$00
    STA $6B
    LDA $42
    STA $6E

Bank1_Label_8FA1:
    RTS

Bank1_Func_8FA2:
    LDA #$00
    STA $9C
    LDA $A0
    BNE Bank1_Label_8FA1
    LDA $5C
    CLC
    ADC #$04
    STA $67
    LDA $5D
    CLC
    ADC #$08
    STA $68
    JSR World2_TestMetatileCollision
    BEQ Bank1_Label_8FC3
    LDA $A9
    ORA #$80
    STA $9C

Bank1_Label_8FC3:
    LDA $A0
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
    SBC $5D
    BCC Bank1_Label_9006
    CMP #$18
    BCS Bank1_Label_9006
    LDA a:World2EnemyX,X
    CLC
    ADC #$08
    SEC
    SBC $5C
    BCC Bank1_Label_9006
    CMP #$10
    BCS Bank1_Label_9006
    INC $9C
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
    SBC $5D
    BCC Bank1_Label_9032
    CMP #$16
    BCS Bank1_Label_9032
    LDA a:World2EnemyProjectileX,X
    CLC
    ADC #$02
    SEC
    SBC $5C
    BCC Bank1_Label_9032
    CMP #$0E
    BCS Bank1_Label_9032
    INC $9C
    LDA #$00
    STA a:World2EnemyProjectileY,X

Bank1_Label_9032:
    DEX
    BPL Bank1_Label_900B
    RTS

World2_UpdatePlayerProjectiles:
    JSR Bank1_Func_9177
    JSR Bank1_Func_912F
    LDX #$06

Bank1_Label_903E:
    LDA a:World2PlayerProjectileState,X
    BNE Bank1_Label_9046
    JMP Bank1_Label_90D2

Bank1_Label_9046:
    INC a:World2PlayerProjectileState,X
    BMI Bank1_Label_9071
    LDY $42
    BEQ Bank1_Label_909F
    DEY
    BEQ Bank1_Label_9074
    LDA a:World2PlayerProjectileDirection,X
    BEQ Bank1_Label_9067
    CMP #$01
    BEQ Bank1_Label_9061
    JSR Bank1_Func_90DF
    JMP Bank1_Label_9093

Bank1_Label_9061:
    JSR Bank1_Func_90E5
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
    JSR Bank1_Func_90D9
    JMP Bank1_Label_9093

Bank1_Label_9083:
    JSR Bank1_Func_90EB
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
    JSR Bank1_Func_90E5
    JMP Bank1_Label_9093

Bank1_Label_90AE:
    JSR Bank1_Func_90D9
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

Bank1_Func_90D9:
    JSR Bank1_Func_90FF
    JMP Bank1_Func_910D

Bank1_Func_90DF:
    JSR Bank1_Func_90F1
    JMP Bank1_Func_911B

Bank1_Func_90E5:
    JSR Bank1_Func_90FF
    JMP Bank1_Func_911B

Bank1_Func_90EB:
    JSR Bank1_Func_90F1
    JMP Bank1_Func_910D

Bank1_Func_90F1:
    LDA a:World2PlayerProjectileX,X
    SEC
    SBC #$02
    STA a:World2PlayerProjectileX,X
    CMP #$04
    BCC Bank1_Label_9129
    RTS

Bank1_Func_90FF:
    LDA a:World2PlayerProjectileX,X
    CLC
    ADC #$02
    STA a:World2PlayerProjectileX,X
    CMP #$FC
    BCS Bank1_Label_9129
    RTS

Bank1_Func_910D:
    LDA a:World2PlayerProjectileY,X
    SEC
    SBC #$02
    STA a:World2PlayerProjectileY,X
    CMP #$10
    BCC Bank1_Label_9129
    RTS

Bank1_Func_911B:
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

Bank1_Func_912F:
    LDA $6F
    BEQ Bank1_Label_916E
    INC $6F
    LDA $6F
    CMP #$96
    BCS Bank1_Label_9172
    LDX $72
    LDA $70
    CLC
    ADC a:$97AD,X
    STA $70
    CMP #$F8
    BCS Bank1_Label_9172
    STA $67
    LDA $71
    CLC
    ADC a:$97A9,X
    STA $68
    STA $71
    CMP #$E0
    BCS Bank1_Label_9172
    JSR World2_TestMetatileCollision
    BNE Bank1_Label_9172
    LDA World2FrameCounter
    AND #$07
    BNE Bank1_Label_916E
    LDA $72
    CMP #$08
    BEQ Bank1_Label_916E
    BCS Bank1_Label_916F
    INC $72

Bank1_Label_916E:
    RTS

Bank1_Label_916F:
    DEC $72
    RTS

Bank1_Label_9172:
    LDA #$00
    STA $6F
    RTS

Bank1_Func_9177:
    LDA $6A
    BEQ Bank1_Label_91A3
    JSR Bank1_Func_9190
    LDA $85
    STA $67
    LDA $8C
    STA $68
    JSR World2_TestMetatileCollision
    BEQ Bank1_Label_918F
    LDA #$00
    STA $6A

Bank1_Label_918F:
    RTS

Bank1_Func_9190:
    LDA $6E
    BNE Bank1_Label_91A4
    INC $6B
    LDA $85
    CMP #$F8
    BCS Bank1_Label_91C8
    LDA $85
    CLC
    ADC #$08
    STA $85

Bank1_Label_91A3:
    RTS

Bank1_Label_91A4:
    CMP #$02
    BNE Bank1_Label_91B8
    INC $6B
    LDA $8C
    CMP #$F9
    BCS Bank1_Label_91C8
    LDA $8C
    CLC
    ADC #$07
    STA $8C
    RTS

Bank1_Label_91B8:
    INC $6B
    LDA $8C
    CMP #$10
    BCC Bank1_Label_91C8
    LDA $8C
    SEC
    SBC #$07
    STA $8C
    RTS

Bank1_Label_91C8:
    LDA #$00
    STA $6A

Bank1_Label_91CC:
    RTS

Bank1_Func_91CD:
    JSR Bank1_Func_9220
    JSR Bank1_Func_9208
    LDY #$D8
    LDX #$06

Bank1_Label_91D7:
    LDA a:World2PlayerProjectileState,X
    BEQ Bank1_Label_91E6
    LDA a:World2PlayerProjectileY,X
    STA $94
    LDA #$3D
    JSR Bank1_Func_96B1

Bank1_Label_91E6:
    DEX
    CPX #$03
    BNE Bank1_Label_91D7
    LDY #$C8

Bank1_Label_91ED:
    LDA a:World2PlayerProjectileState,X
    BEQ Bank1_Label_9204
    LDA a:World2PlayerProjectileY,X
    STA $94
    LDA $42
    BEQ Bank1_Label_91FF
    LDA #$3B
    BNE Bank1_Label_9201

Bank1_Label_91FF:
    LDA #$3A

Bank1_Label_9201:
    JSR Bank1_Func_96B1

Bank1_Label_9204:
    DEX
    BPL Bank1_Label_91ED
    RTS

Bank1_Func_9208:
    LDA $6F
    BEQ Bank1_Label_921F
    LDY #$E4
    LDA $71
    STA $94
    LDA #$3C
    STA $95
    LDA #$03
    STA $96
    LDA $70
    JMP Bank1_Func_96BA

Bank1_Label_921F:
    RTS

Bank1_Func_9220:
    LDA $6A
    BEQ Bank1_Label_91CC
    LDA $6B
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
    LDA $6E
    BEQ Bank1_Label_9242
    JMP Bank1_Label_9295

Bank1_Label_9242:
    LDA $85
    STA $60
    LDA #$20
    STA $6D
    LDA #$04
    STA $69

Bank1_Label_924E:
    LDA a:$9326,X
    BEQ Bank1_Label_9261
    LDA $8C
    SEC
    SBC $6D
    BCC Bank1_Label_9261
    CMP #$10
    BCC Bank1_Label_9261
    JSR Bank1_Func_92EC

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
    LDA $8C
    CLC
    ADC $6D
    BCS Bank1_Label_9288
    CMP #$E0
    BCS Bank1_Label_9288
    JSR Bank1_Func_92EC

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
    LDA $85
    STA $60
    LDA #$20
    STA $6D
    LDA #$04
    STA $69

Bank1_Label_92A1:
    LDA a:$9326,X
    BEQ Bank1_Label_92B6
    LDA $60
    SEC
    SBC $6D
    BCC Bank1_Label_92B6
    JSR Bank1_Func_9309
    SEC
    SBC $6D
    JSR Bank1_Func_96BA

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
    LDA $85
    CLC
    ADC $6D
    BCS Bank1_Label_92DF
    JSR Bank1_Func_9309
    CLC
    ADC $6D
    JSR Bank1_Func_96BA

Bank1_Label_92DF:
    LDA $6D
    CLC
    ADC #$08
    STA $6D
    INX
    DEC $69
    BNE Bank1_Label_92CA
    RTS
