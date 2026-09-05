; Doraemon PRG bank 2 $9192-$931E
; World 3 entity traversal, per-type dispatch, and spawn-position selection
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank2_Func_9192:
    LDA $CB
    BEQ Bank2_Label_91B2
    INC $CC
    LDA $CC
    AND #$07
    BNE Bank2_Label_91A3
    LDA #$07
    JSR Bank2_Func_A5DF

Bank2_Label_91A3:
    LDA $CC
    CMP #$F0
    BNE Bank2_Label_91B2
    LDA #$00
    STA $CB
    LDA #$00
    STA a:AudioMusicControl

Bank2_Label_91B2:
    RTS

Bank2_Label_91B3:
    INC a:World3EntityFrameCounter,X
    LDA a:World3EntityFrameCounter,X
    AND #$01
    BNE Bank2_Label_91FE
    INC a:World3EntityMetasprite,X
    LDA a:World3EntityMetasprite,X
    CMP #$70
    BNE Bank2_Label_91FE
    LDA #$00
    STA a:World3EntityState,X
    LDA a:World3EntityType,X
    CMP #$05
    BCS Bank2_Label_91FE
    LDA $A4
    BEQ Bank2_Label_91DB
    DEC $A4
    BNE Bank2_Label_91E7

Bank2_Label_91DB:
    INC $4E
    LDA $4E
    CMP #$04
    BCC Bank2_Label_91FE
    LDA #$00
    STA $4E

Bank2_Label_91E7:
    LDA #$01
    STA a:World3EntityState,X
    JSR Bank2_Func_B153
    AND #$03
    CLC
    ADC #$10
    STA a:World3EntityType,X
    TAY
    LDA a:World3_EntityMetaspriteByType,Y
    STA a:World3EntityMetasprite,X

Bank2_Label_91FE:
    JMP Bank2_Label_9283

Bank2_Label_9201:
    RTS

World3_UpdateEntities:
    LDA $8E
    CMP #$04
    BEQ Bank2_Label_9201
    LDA #$00
    STA $07
    LDA #$08
    STA $06

Bank2_Label_9210:
    LDX $07
    LDA a:World3EntityState,X
    BEQ Bank2_Label_9283
    CMP #$05
    BEQ Bank2_Label_91B3
    CMP #$04
    BEQ Bank2_Label_924D
    CMP #$01
    BEQ Bank2_Label_924D
    LDA a:World3EntityActivationTimer,X
    BNE Bank2_Label_9230
    LDA #$01
    STA a:World3EntityState,X
    JMP Bank2_Label_924D

Bank2_Label_9230:
    DEC a:World3EntityActivationTimer,X
    CMP #$1E
    BNE Bank2_Label_9283
    LDA a:World3EntityState,X
    CMP #$03
    BEQ Bank2_Label_9283
    JSR Bank2_Func_92A5
    LDX $07
    LDA $46
    STA a:World3EntityX,X
    LDA $47
    STA a:World3EntityY,X

Bank2_Label_924D:
    LDA $CB
    BEQ Bank2_Label_925B
    LDA a:World3EntityType,X
    CMP #$10
    BCS Bank2_Label_925B
    JMP Bank2_Label_9279

Bank2_Label_925B:
    LDA a:World3EntityType,X
    CMP #$10
    BCS Bank2_Label_9265
    JSR World3_RunEntityBehaviorScript

Bank2_Label_9265:
    LDX $07
    LDA a:World3EntityType,X
    ASL A
    TAY
    LDA a:World3_EntityUpdateHandlerTable,Y
    STA $40
    LDA a:$92E0,Y
    STA $41
    JSR World3_CallIndirect

Bank2_Label_9279:
    LDX $07
    JSR Bank2_Func_89A1
    LDX $07
    JSR Bank2_Func_8848

Bank2_Label_9283:
    INC $07
    DEC $06
    BEQ Bank2_Label_928C
    JMP Bank2_Label_9210

Bank2_Label_928C:
    RTS

Bank2_Func_928D:
    JSR Bank2_Func_B153
    CMP #$20
    BCC Bank2_Func_928D
    CMP #$D0
    BCS Bank2_Func_928D
    RTS

Bank2_Func_9299:
    JSR Bank2_Func_B153
    CMP #$30
    BCC Bank2_Func_9299
    CMP #$B0
    BCS Bank2_Func_9299
    RTS

Bank2_Func_92A5:
    JSR Bank2_Func_928D
    STA $46
    JSR Bank2_Func_9299
    STA $47
    JSR Bank2_Func_9EC3
    BCC Bank2_Func_92A5
    JSR Bank2_Func_9EFB
    BCC Bank2_Func_92A5
    JSR Bank2_Func_9F37
    BCC Bank2_Func_92A5
    JSR Bank2_Func_9F71
    BCC Bank2_Func_92A5
    LDA $46
    SEC
    SBC $8C
    JSR Bank2_Func_B149
    CMP #$18
    BCS Bank2_Label_92DE
    LDA $47
    SEC
    SBC $8D
    JSR Bank2_Func_B149
    CMP #$18
    BCS Bank2_Label_92DE
    JMP Bank2_Func_92A5

Bank2_Label_92DE:
    RTS

World3_EntityUpdateHandlerTable:
    .byte $22, $93, $22, $93, $22, $93, $22, $93, $2D, $93, $AC, $93, $90, $95, $90, $95
    .byte $91, $95, $94, $95, $95, $95, $A4, $95, $A5, $95, $43, $96, $5B, $96, $8C, $96
    .byte $D6, $96, $D6, $96, $D6, $96, $D6, $96, $D6, $96, $D6, $96, $D6, $96, $D7, $96
    .byte $D8, $96, $59, $97, $13, $98, $E3, $98, $99, $99, $99, $99, $99, $99, $99, $99
