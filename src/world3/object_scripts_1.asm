; Doraemon PRG bank 2 $9A3B-$9D18
; World 3 object script decoding and early behavior handlers
; Generated deterministically from pinned Ghidra/GhidraNes facts

World3_RunEntityBehaviorScript:
    LDX $07
    LDA a:World3EntityType,X
    ASL A
    TAY
    LDA a:$D9AC,Y
    STA $40
    LDA a:$D9AD,Y
    STA $41
    LDA a:World3EntityScriptRateCounter,X
    BEQ Bank2_Label_9A59
    JSR World3_AdvancePackedRateCounter
    STA a:World3EntityScriptRateCounter,X
    BCC Bank2_Label_9A3A

Bank2_Label_9A59:
    LDA a:World3EntityScriptOffset,X
    TAY
    LDA ($40),Y
    AND #$0F
    STA $3E
    LDA ($40),Y
    AND #$F0
    STA $3F
    CMP #$00
    BNE Bank2_Label_9A98
    LDA a:World3EntityHorizontalDirection,X
    BNE Bank2_Label_9AA1

Bank2_Label_9A72:
    JSR Bank2_Func_9EF1
    BCC Bank2_Label_9A84
    LDA a:World3EntityX,X
    CLC
    ADC $3E
    STA a:World3EntityX,X
    CMP #$E0
    BCC Bank2_Label_9A94

Bank2_Label_9A84:
    LDA a:World3EntityHorizontalDirection,X
    EOR #$01
    STA a:World3EntityHorizontalDirection,X
    LDA a:World3EntityMetaspriteVariantBit1,X
    EOR #$02
    STA a:World3EntityMetaspriteVariantBit1,X

Bank2_Label_9A94:
    INC a:World3EntityScriptOffset,X
    RTS

Bank2_Label_9A98:
    CMP #$10
    BNE Bank2_Label_9AC7
    LDA a:World3EntityHorizontalDirection,X
    BNE Bank2_Label_9A72

Bank2_Label_9AA1:
    JSR Bank2_Func_9EB9
    BCC Bank2_Label_9AB3
    LDA a:World3EntityX,X
    SEC
    SBC $3E
    STA a:World3EntityX,X
    CMP #$10
    BCS Bank2_Label_9AC3

Bank2_Label_9AB3:
    LDA a:World3EntityHorizontalDirection,X
    EOR #$01
    STA a:World3EntityHorizontalDirection,X
    LDA a:World3EntityMetaspriteVariantBit1,X
    EOR #$02
    STA a:World3EntityMetaspriteVariantBit1,X

Bank2_Label_9AC3:
    INC a:World3EntityScriptOffset,X
    RTS

Bank2_Label_9AC7:
    CMP #$20
    BNE Bank2_Label_9AEE
    LDA a:World3EntityVerticalDirection,X
    BNE Bank2_Label_9AF7

Bank2_Label_9AD0:
    JSR Bank2_Func_9F2D
    BCC Bank2_Label_9AE2
    LDA a:World3EntityY,X
    SEC
    SBC $3E
    STA a:World3EntityY,X
    CMP #$20
    BCS Bank2_Label_9AEA

Bank2_Label_9AE2:
    LDA a:World3EntityVerticalDirection,X
    EOR #$01
    STA a:World3EntityVerticalDirection,X

Bank2_Label_9AEA:
    INC a:World3EntityScriptOffset,X
    RTS

Bank2_Label_9AEE:
    CMP #$30
    BNE Bank2_Label_9B15
    LDA a:World3EntityVerticalDirection,X
    BNE Bank2_Label_9AD0

Bank2_Label_9AF7:
    JSR Bank2_Func_9F67
    BCC Bank2_Label_9B09
    LDA a:World3EntityY,X
    CLC
    ADC $3E
    STA a:World3EntityY,X
    CMP #$C0
    BCC Bank2_Label_9B11

Bank2_Label_9B09:
    LDA a:World3EntityVerticalDirection,X
    EOR #$01
    STA a:World3EntityVerticalDirection,X

Bank2_Label_9B11:
    INC a:World3EntityScriptOffset,X
    RTS

Bank2_Label_9B15:
    CMP #$40
    BNE Bank2_Label_9B28
    INC a:World3EntityScriptOffset,X
    LDA a:World3EntityScriptOffset,X
    TAY
    LDA ($40),Y
    STA a:World3EntityScriptOffset,X
    JMP Bank2_Label_9A59

Bank2_Label_9B28:
    CMP #$50
    BNE Bank2_Label_9B48
    LDA a:World3EntityScriptWaitTimer,X
    BNE Bank2_Label_9B3C
    LDA a:World3EntityScriptOffset,X
    TAY
    INY
    LDA ($40),Y
    STA a:World3EntityScriptWaitTimer,X
    RTS

Bank2_Label_9B3C:
    DEC a:World3EntityScriptWaitTimer,X
    BNE Bank2_Label_9B47
    INC a:World3EntityScriptOffset,X
    INC a:World3EntityScriptOffset,X

Bank2_Label_9B47:
    RTS

Bank2_Label_9B48:
    CMP #$60
    BNE Bank2_Label_9B57
    LDA $3E
    STA a:World3EntityScriptRateCounter,X
    INC a:World3EntityScriptOffset,X
    JMP Bank2_Label_9A59

Bank2_Label_9B57:
    CMP #$70
    BNE Bank2_Label_9BBF
    LDA $3E
    CMP #$00
    BEQ Bank2_Label_9BA3
    CMP #$01
    BEQ Bank2_Label_9BB1
    CMP #$08
    BEQ Bank2_Label_9B7F
    CMP #$09
    BEQ Bank2_Label_9B8D
    CMP #$0A
    BEQ Bank2_Label_9B98
    LDA #$01
    STA a:World3EntityHorizontalDirection,X
    STA a:World3EntityVerticalDirection,X
    INC a:World3EntityScriptOffset,X
    JMP Bank2_Label_9A59

Bank2_Label_9B7F:
    LDA #$00
    STA a:World3EntityHorizontalDirection,X
    STA a:World3EntityVerticalDirection,X
    INC a:World3EntityScriptOffset,X
    JMP Bank2_Label_9A59

Bank2_Label_9B8D:
    LDA #$01
    STA a:World3EntityHorizontalDirection,X
    INC a:World3EntityScriptOffset,X
    JMP Bank2_Label_9A59

Bank2_Label_9B98:
    LDA #$01
    STA a:World3EntityVerticalDirection,X
    INC a:World3EntityScriptOffset,X
    JMP Bank2_Label_9A59

Bank2_Label_9BA3:
    JSR Bank2_Func_B153
    AND #$01
    STA a:World3EntityHorizontalDirection,X
    INC a:World3EntityScriptOffset,X
    JMP Bank2_Label_9A59

Bank2_Label_9BB1:
    JSR Bank2_Func_B153
    AND #$01
    STA a:World3EntityVerticalDirection,X
    INC a:World3EntityScriptOffset,X
    JMP Bank2_Label_9A59

Bank2_Label_9BBF:
    CMP #$80
    BNE Bank2_Label_9BF3
    LDA $3E
    BNE Bank2_Label_9BDF
    INC a:World3EntityScriptOffset,X
    LDA a:World3EntityScriptOffset,X
    TAY
    LDA ($40),Y
    STA a:World3EntityBehaviorTimer,X
    INC a:World3EntityScriptOffset,X
    LDA a:World3EntityScriptOffset,X
    STA a:World3EntityScriptLoopOffset,X
    JMP Bank2_Label_9A59

Bank2_Label_9BDF:
    INC a:World3EntityScriptOffset,X
    LDA a:World3EntityBehaviorTimer,X
    BEQ Bank2_Label_9BF0
    DEC a:World3EntityBehaviorTimer,X
    LDA a:World3EntityScriptLoopOffset,X
    STA a:World3EntityScriptOffset,X

Bank2_Label_9BF0:
    JMP Bank2_Label_9A59

Bank2_Label_9BF3:
    CMP #$90
    BNE Bank2_Label_9C39
    INC a:World3EntityScriptOffset,X
    LDA a:World3EntityScriptOffset,X
    TAY
    LDA a:World3EntityHorizontalDirection,X
    BEQ Bank2_Label_9C0D
    LDA ($40),Y
    EOR #$FF
    CLC
    ADC #$01
    JMP Bank2_Label_9C0F

Bank2_Label_9C0D:
    LDA ($40),Y

Bank2_Label_9C0F:
    CLC
    ADC a:World3EntityX,X
    STA a:World3EntityX,X
    INC a:World3EntityScriptOffset,X
    LDA a:World3EntityScriptOffset,X
    TAY
    LDA a:World3EntityVerticalDirection,X
    BEQ Bank2_Label_9C2C
    LDA ($40),Y
    EOR #$FF
    CLC
    ADC #$01
    JMP Bank2_Label_9C2E

Bank2_Label_9C2C:
    LDA ($40),Y

Bank2_Label_9C2E:
    CLC
    ADC a:World3EntityY,X
    STA a:World3EntityY,X
    INC a:World3EntityScriptOffset,X
    RTS

Bank2_Label_9C39:
    CMP #$A0
    BNE Bank2_Label_9C60
    INC a:World3EntityScriptOffset,X
    LDA a:World3EntityScriptOffset,X
    TAY
    LDA ($40),Y
    STA a:World3EntityX,X
    INC a:World3EntityScriptOffset,X
    LDA a:World3EntityScriptOffset,X
    TAY
    LDA ($40),Y
    STA a:World3EntityY,X
    INC a:World3EntityScriptOffset,X
    LDA #$00
    STA a:World3EntityActivationTimer,X
    JMP Bank2_Label_9A59

Bank2_Label_9C60:
    CMP #$B0
    BNE Bank2_Label_9C6F
    LDA $3E
    STA a:World3EntityMetaspriteVariantBit1,X
    INC a:World3EntityScriptOffset,X
    JMP Bank2_Label_9A59

Bank2_Label_9C6F:
    CMP #$C0
    BNE Bank2_Label_9CDB
    LDA $3E
    CMP #$01
    BEQ Bank2_Label_9CA3
    CMP #$02
    BEQ Bank2_Label_9CBF
    INC a:World3EntityScriptOffset,X
    LDA a:World3EntityScriptOffset,X
    TAY
    JSR Bank2_Func_B153
    CMP ($40),Y
    BCS Bank2_Label_9C94
    INC a:World3EntityScriptOffset,X
    INC a:World3EntityScriptOffset,X
    JMP Bank2_Label_9A59

Bank2_Label_9C94:
    INC a:World3EntityScriptOffset,X
    LDA a:World3EntityScriptOffset,X
    TAY
    LDA ($40),Y
    STA a:World3EntityScriptOffset,X
    JMP Bank2_Label_9A59

Bank2_Label_9CA3:
    INC a:World3EntityScriptOffset,X
    LDA a:World3EntityX,X
    CMP $8C
    BCS Bank2_Label_9CB3
    INC a:World3EntityScriptOffset,X
    JMP Bank2_Label_9A59

Bank2_Label_9CB3:
    LDA a:World3EntityScriptOffset,X
    TAY
    LDA ($40),Y
    STA a:World3EntityScriptOffset,X
    JMP Bank2_Label_9A59

Bank2_Label_9CBF:
    INC a:World3EntityScriptOffset,X
    LDA a:World3EntityY,X
    CMP $8D
    BCS Bank2_Label_9CCF
    INC a:World3EntityScriptOffset,X
    JMP Bank2_Label_9A59

Bank2_Label_9CCF:
    LDA a:World3EntityScriptOffset,X
    TAY
    LDA ($40),Y
    STA a:World3EntityScriptOffset,X
    JMP Bank2_Label_9A59

Bank2_Label_9CDB:
    CMP #$D0
    BNE Bank2_Label_9CF1
    INC a:World3EntityScriptOffset,X
    LDA a:World3EntityScriptOffset,X
    TAY
    LDA ($40),Y
    STA a:World3EntityFollowAnchorFlag,X
    INC a:World3EntityScriptOffset,X
    JMP Bank2_Label_9A59

Bank2_Label_9CF1:
    CMP #$E0
    BNE Bank2_Label_9D03
    LDA a:World3EntityMetaspriteVariantBit0,X
    EOR #$01
    STA a:World3EntityMetaspriteVariantBit0,X
    INC a:World3EntityScriptOffset,X
    JMP Bank2_Label_9A59

Bank2_Label_9D03:
    CMP #$F0
    BNE Bank2_Label_9D18
    LDA $3E
    BEQ Bank2_Label_9D17
    LDA a:World3EntityState,X
    CMP #$04
    BEQ Bank2_Label_9D17
    LDA #$00
    STA a:World3EntityState,X

Bank2_Label_9D17:
    RTS

Bank2_Label_9D18:
    RTS
