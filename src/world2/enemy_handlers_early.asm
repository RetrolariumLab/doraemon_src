; Doraemon PRG bank 1 $9B46-$9D4D
; World 2 early indirect enemy-state handlers
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank1_Func_9B46:
    LDA #$00
    STA $98
    LDA a:World2EnemyPhaseCounter,X
    AND #$10
    BEQ Bank1_Label_9B53
    INC $98

Bank1_Label_9B53:
    LDA $98
    JMP Bank1_Func_A35B

Bank1_Func_9B58:
    LDA #$02
    STA $98
    LDA World2FrameCounter
    AND #$20
    BEQ Bank1_Label_9B64
    INC $98

Bank1_Label_9B64:
    LDA World2PlayerX
    CMP a:World2EnemyX,X
    LDA #$00
    ROL A
    STA $63
    LDA $98
    JMP Bank1_Func_A35B

Bank1_Func_9B73:
    LDA a:World2EnemyBehaviorParameter,X
    BEQ Bank1_Label_9BC7
    INC a:World2EnemyPhaseCounter,X
    LDA a:World2EnemyPhaseCounter,X
    CMP #$28
    BCS Bank1_Label_9B94
    LDA a:World2EnemyY,X
    SEC
    SBC World2PlayerY
    BCS Bank1_Label_9B8E
    CMP #$FA
    BCS Bank1_Label_9B94

Bank1_Label_9B8E:
    CMP #$05
    BCC Bank1_Label_9B94
    BCS Bank1_Label_9BC4

Bank1_Label_9B94:
    LDA World2PlayerX
    CLC
    ADC #$04
    SEC
    SBC a:World2EnemyX,X
    BEQ Bank1_Label_9BE6
    BCS Bank1_Label_9BB0
    EOR #$FF
    CMP $5E
    BCC Bank1_Label_9C12
    LDA a:World2EnemyX,X
    SEC
    SBC $5E
    JMP Bank1_Label_9BBA

Bank1_Label_9BB0:
    CMP $5E
    BCC Bank1_Label_9C12
    LDA a:World2EnemyX,X
    CLC
    ADC $5E

Bank1_Label_9BBA:
    STA $67
    JSR World2_TestMetatileCollision
    BNE Bank1_Label_9BC4
    JSR Bank1_Func_9D2B

Bank1_Label_9BC4:
    JMP Bank1_Func_A0DC

Bank1_Label_9BC7:
    INC a:World2EnemyPhaseCounter,X
    LDA a:World2EnemyPhaseCounter,X
    CMP #$32
    BCS Bank1_Label_9BDD
    LDA a:World2EnemyX,X
    SEC
    SBC World2PlayerX
    CMP #$05
    BCC Bank1_Label_9BDD
    BCS Bank1_Label_9BC4

Bank1_Label_9BDD:
    LDA World2PlayerY
    CLC
    ADC #$08
    SEC
    SBC a:World2EnemyY,X

Bank1_Label_9BE6:
    BEQ Bank1_Label_9C12
    BCS Bank1_Label_9BF9
    EOR #$FF
    CMP $5E
    BCC Bank1_Label_9C12
    LDA a:World2EnemyY,X
    SEC
    SBC $5E
    JMP Bank1_Label_9C03

Bank1_Label_9BF9:
    CMP $5E
    BCC Bank1_Label_9C12
    LDA a:World2EnemyY,X
    CLC
    ADC $5E

Bank1_Label_9C03:
    STA $68
    JSR World2_TestMetatileCollision
    BNE Bank1_Label_9C0F
    LDA $68
    STA a:World2EnemyY,X

Bank1_Label_9C0F:
    JMP Bank1_Func_A0DC

Bank1_Label_9C12:
    JSR Bank1_Func_9CD8
    JMP Bank1_Func_A0DC

Bank1_Func_9C18:
    LDA World2FrameCounter
    AND #$18
    LSR A
    LSR A
    LSR A
    TAX
    LDA a:$9C28,X
    LDX $76
    JMP Bank1_Func_A35B
    .byte $04, $05, $06, $05

Bank1_Func_9C2C:
    JSR Bank1_Func_A0DC
    LDA World2FrameCounter
    AND #$01
    BNE Bank1_Label_9C38
    INC a:World2EnemyPhaseCounter,X

Bank1_Label_9C38:
    LDA a:World2EnemyPhaseCounter,X
    AND #$1F
    TAY
    LDA a:World2EnemyY,X
    CLC
    ADC a:$A5AE,Y
    CMP #$F0
    BCS Bank1_Label_9C82
    STA $68
    LDA a:World2EnemyPhaseCounter,X
    CMP #$20
    BCC Bank1_Label_9C5D
    LDA a:World2EnemyX,X
    CLC
    ADC #$02
    BCS Bank1_Label_9C82
    JMP Bank1_Label_9C65

Bank1_Label_9C5D:
    LDA a:World2EnemyX,X
    SEC
    SBC #$02
    BCC Bank1_Label_9C82

Bank1_Label_9C65:
    STA $67
    JSR World2_TestMetatileCollision
    BNE Bank1_Label_9C72
    JSR Bank1_Func_9D2B
    JMP Bank1_Label_9C78

Bank1_Label_9C72:
    INC a:World2EnemyPhaseCounter,X
    INC a:World2EnemyPhaseCounter,X

Bank1_Label_9C78:
    LDA a:World2EnemyPhaseCounter,X
    CMP #$40
    BCC Bank1_Label_9CA4
    JMP Bank1_Func_9CD8

Bank1_Label_9C82:
    JMP Bank1_Func_9B40

Bank1_Func_9C85:
    LDA #$08
    STA $98
    LDA World2FrameCounter
    AND #$08
    BEQ Bank1_Label_9C91
    DEC $98

Bank1_Label_9C91:
    LDA $98
    JMP Bank1_Func_A35B

Bank1_Func_9C96:
    JSR Bank1_Func_A0DC
    INC a:World2EnemyPhaseCounter,X
    LDA a:World2EnemyPhaseCounter,X
    SEC
    SBC #$32
    BCS Bank1_Label_9CA5

Bank1_Label_9CA4:
    RTS

Bank1_Label_9CA5:
    AND #$1F
    TAY
    LDA a:World2EnemyY,X
    SEC
    SBC a:$A5AE,Y
    STA $68
    LDA a:World2EnemyPhaseCounter,X
    CMP #$52
    BCC Bank1_Label_9CC1
    LDA a:World2EnemyX,X
    SEC
    SBC #$02
    JMP Bank1_Label_9CC7

Bank1_Label_9CC1:
    LDA a:World2EnemyX,X
    CLC
    ADC #$02

Bank1_Label_9CC7:
    STA $67
    JSR World2_TestMetatileCollision
    BNE Bank1_Label_9CD1
    JSR Bank1_Func_9D2B

Bank1_Label_9CD1:
    LDA a:World2EnemyPhaseCounter,X
    CMP #$72
    BNE Bank1_Label_9CDD

Bank1_Func_9CD8:
    LDA #$00
    STA a:World2EnemyPhaseCounter,X

Bank1_Label_9CDD:
    RTS

Bank1_Func_9CDE:
    LDA a:World2EnemyPhaseCounter,X
    CMP #$32
    BCS Bank1_Label_9CEB
    LDA #$0B
    STA $98
    BNE Bank1_Label_9D00

Bank1_Label_9CEB:
    LDA #$09
    STA $98
    LDA World2FrameCounter
    AND #$04
    BEQ Bank1_Label_9CF7
    INC $98

Bank1_Label_9CF7:
    LDA a:World2EnemyPhaseCounter,X
    CMP #$54
    BCS Bank1_Label_9D00
    INC $63

Bank1_Label_9D00:
    LDA $98
    JMP Bank1_Func_A35B

Bank1_Func_9D05:
    JSR Bank1_Func_9DE4
    LDA a:World2EnemyState,X
    BEQ Bank1_Label_9D35
    INC a:World2EnemyPhaseCounter,X
    LDA a:World2EnemyPhaseCounter,X
    AND #$20
    BNE Bank1_Label_9D35
    LDA a:World2EnemyPhaseCounter,X
    AND #$0F
    TAY
    LDA a:World2EnemyY,X
    SEC
    SBC a:$A5CE,Y
    STA $68
    JSR World2_TestMetatileCollision
    BNE Bank1_Label_9D35

Bank1_Func_9D2B:
    LDA $67
    STA a:World2EnemyX,X
    LDA $68
    STA a:World2EnemyY,X

Bank1_Label_9D35:
    RTS

Bank1_Func_9D36:
    LDA #$0C
    STA $98
    LDA a:World2EnemyPhaseCounter,X
    AND #$20
    BEQ Bank1_Label_9D49
    LDA World2FrameCounter
    AND #$04
    BEQ Bank1_Label_9D49
    INC $98

Bank1_Label_9D49:
    LDA $98
    JMP Bank1_Func_A35B
