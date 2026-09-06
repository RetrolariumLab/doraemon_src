; Doraemon PRG bank 2 $9192-$931E
; World 3 entity traversal, per-type dispatch, and spawn-position selection
; Generated deterministically from pinned Ghidra/GhidraNes facts

World3_UpdateStopwatchEffect:
    LDA World3StopwatchActive
    BEQ Bank2_Label_91B2
    INC World3StopwatchTimer
    LDA World3StopwatchTimer
    AND #$07
    BNE Bank2_Label_91A3
    LDA #$07
    JSR World3_QueuePriorityEffectPreserveXY

Bank2_Label_91A3:
    LDA World3StopwatchTimer
    CMP #$F0
    BNE Bank2_Label_91B2
    LDA #$00
    STA World3StopwatchActive
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
    LDA World3MassDefeatConversionCountdown
    BEQ Bank2_Label_91DB
    DEC World3MassDefeatConversionCountdown
    BNE Bank2_Label_91E7

Bank2_Label_91DB:
    INC World3DefeatConversionCycle
    LDA World3DefeatConversionCycle
    CMP #$04
    BCC Bank2_Label_91FE
    LDA #$00
    STA World3DefeatConversionCycle

Bank2_Label_91E7:
    LDA #$01
    STA a:World3EntityState,X
    JSR World3_RandomByte
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
    LDA World3PlayerState
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
    JSR World3_ChoosePassableEntitySpawnPosition
    LDX $07
    LDA $46
    STA a:World3EntityX,X
    LDA $47
    STA a:World3EntityY,X

Bank2_Label_924D:
    LDA World3StopwatchActive
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
    JSR World3_ResolvePlayerEntityContact
    LDX $07
    JSR World3_CheckPlayerProjectilesAgainstEntity

Bank2_Label_9283:
    INC $07
    DEC $06
    BEQ Bank2_Label_928C
    JMP Bank2_Label_9210

Bank2_Label_928C:
    RTS

World3_ChooseSpawnX:
    JSR World3_RandomByte
    CMP #$20
    BCC World3_ChooseSpawnX
    CMP #$D0
    BCS World3_ChooseSpawnX
    RTS

World3_ChooseSpawnY:
    JSR World3_RandomByte
    CMP #$30
    BCC World3_ChooseSpawnY
    CMP #$B0
    BCS World3_ChooseSpawnY
    RTS

World3_ChoosePassableEntitySpawnPosition:
    JSR World3_ChooseSpawnX
    STA $46
    JSR World3_ChooseSpawnY
    STA $47
    JSR World3_ProbeEntityLeftEdge
    BCC World3_ChoosePassableEntitySpawnPosition
    JSR World3_ProbeEntityRightEdge
    BCC World3_ChoosePassableEntitySpawnPosition
    JSR World3_ProbeEntityTopEdge
    BCC World3_ChoosePassableEntitySpawnPosition
    JSR World3_ProbeEntityBottomEdge
    BCC World3_ChoosePassableEntitySpawnPosition
    LDA $46
    SEC
    SBC World3PlayerX
    JSR World3_AbsoluteValue8
    CMP #$18
    BCS Bank2_Label_92DE
    LDA $47
    SEC
    SBC World3PlayerY
    JSR World3_AbsoluteValue8
    CMP #$18
    BCS Bank2_Label_92DE
    JMP World3_ChoosePassableEntitySpawnPosition

Bank2_Label_92DE:
    RTS

World3_EntityUpdateHandlerTable:
    .byte $22, $93, $22, $93, $22, $93, $22, $93, $2D, $93, $AC, $93, $90, $95, $90, $95
    .byte $91, $95, $94, $95, $95, $95, $A4, $95, $A5, $95, $43, $96, $5B, $96, $8C, $96
    .byte $D6, $96, $D6, $96, $D6, $96, $D6, $96, $D6, $96, $D6, $96, $D6, $96, $D7, $96
    .byte $D8, $96, $59, $97, $13, $98, $E3, $98, $99, $99, $99, $99, $99, $99, $99, $99
