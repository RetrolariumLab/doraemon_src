; Doraemon PRG bank 2 $8B68-$8F54
; World 3 entity storage, persistent records, and random-spawn scheduling
; Generated deterministically from pinned Ghidra/GhidraNes facts

World3_ClearEntitySlot:
    TXA
    PHA

Bank2_Label_8B6A:
    LDA #$00
    STA a:World3EntityState,X
    TXA
    CLC
    ADC #$08
    TAX
    CPX #$B0
    BCC Bank2_Label_8B6A
    PLA
    TAX
    RTS

World3_InitializeRoomObjectRegistry:
    LDX #$00

Bank2_Label_8B7D:
    LDA a:$D96B,X
    STA a:World3RoomObjectRoom,X
    INX
    CPX #$41
    BNE Bank2_Label_8B7D
    LDX #$00

Bank2_Label_8B8A:
    LDA a:World3RoomObjectType,X
    STA a:$04A0,X
    LDA #$00
    STA a:$04A4,X
    INX
    CPX #$04
    BNE Bank2_Label_8B8A
    LDX #$00

Bank2_Label_8B9C:
    JSR Bank2_Func_B153
    AND #$03
    TAY
    LDA a:$04A4,Y
    BNE Bank2_Label_8B9C
    LDA #$01
    STA a:$04A4,Y
    LDA a:$04A0,Y
    STA a:World3RoomObjectType,X
    INX
    CPX #$04
    BNE Bank2_Label_8B9C
    LDX #$00

Bank2_Label_8BB9:
    LDA a:World3RoomObjectType+$04,X
    STA a:$04A0,X
    LDA #$00
    STA a:$04A8,X
    INX
    CPX #$08
    BNE Bank2_Label_8BB9
    LDX #$00

Bank2_Label_8BCB:
    JSR Bank2_Func_B153
    AND #$07
    TAY
    LDA a:$04A8,Y
    BNE Bank2_Label_8BCB
    LDA #$01
    STA a:$04A8,Y
    LDA a:$04A0,Y
    STA a:World3RoomObjectType+$04,X
    INX
    CPX #$08
    BNE Bank2_Label_8BCB
    LDX #$00
    LDA #$FF

Bank2_Label_8BEA:
    STA a:World3EncounterRoomList,X
    INX
    CPX #$08
    BNE Bank2_Label_8BEA
    RTS

Bank2_Func_8BF3:
    LDA $38
    BEQ Bank2_Label_8C24
    LDA #$00
    STA $38
    LDY #$00

Bank2_Label_8BFD:
    LDA a:World3RoomObjectType,Y
    CMP #$19
    BEQ Bank2_Label_8C0E
    INY
    CPY #$0D
    BNE Bank2_Label_8BFD
    LDA #$06
    JMP Bank2_Func_AF51

Bank2_Label_8C0E:
    LDA #$00
    STA a:World3RoomObjectRoom,Y
    LDA #$01
    STA a:World3RoomObjectState,Y
    STA $9A
    LDA $8C
    STA a:World3RoomObjectX,Y
    LDA $8D
    STA a:World3RoomObjectY,Y

Bank2_Label_8C24:
    RTS

Bank2_Func_8C25:
    LDX $DF
    LDA a:$8C6D,X
    BEQ Bank2_Label_8C6C
    TAX
    LDY #$00

Bank2_Label_8C2F:
    LDA a:World3RoomObjectRoom,Y
    CMP $DF
    BNE Bank2_Label_8C67
    LDA a:World3RoomObjectType,Y
    CMP #$18
    BCC Bank2_Label_8C67
    LDA a:World3RoomObjectY,Y
    CMP #$50
    BCC Bank2_Label_8C67
    CMP #$A0
    BCS Bank2_Label_8C67
    CPX #$01
    BEQ Bank2_Label_8C5B
    LDA a:World3RoomObjectX,Y
    CMP #$14
    BCS Bank2_Label_8C67
    LDA #$18
    STA a:World3RoomObjectX,Y
    JMP Bank2_Label_8C67

Bank2_Label_8C5B:
    LDA a:World3RoomObjectX,Y
    CMP #$DC
    BCC Bank2_Label_8C67
    LDA #$D8
    STA a:World3RoomObjectX,Y

Bank2_Label_8C67:
    INY
    CPY #$0D
    BNE Bank2_Label_8C2F

Bank2_Label_8C6C:
    RTS
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $01, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $02, $00
    .byte $01, $02, $00, $00, $00, $01, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

World3_MaterializeRoomObjects:
    LDX #$00
    LDY #$00

Bank2_Label_8CB1:
    LDA a:World3RoomObjectRoom,Y
    CMP $DF
    BNE Bank2_Label_8CF0
    JSR World3_ClearEntitySlot
    LDA #$01
    STA a:World3EntityState,X
    LDA a:World3RoomObjectX,Y
    STA a:World3EntityX,X
    LDA a:World3RoomObjectY,Y
    STA a:World3EntityY,X
    LDA a:World3RoomObjectType,Y
    STA a:World3EntityType,X
    STY $42
    TAY
    LDA a:World3_EntityMetaspriteByType,Y
    STA a:World3EntityMetasprite,X
    LDY $42
    LDA a:World3RoomObjectState,Y
    STA a:World3EntityPersistentState,X
    BEQ Bank2_Label_8CEF
    LDA $8C
    STA a:World3EntityX,X
    LDA $8D
    STA a:World3EntityY,X

Bank2_Label_8CEF:
    INX

Bank2_Label_8CF0:
    INY
    CPY #$0D
    BNE Bank2_Label_8CB1
    RTS

World3_SaveRoomObjectsState0:
    LDA #$00
    STA $3E
    JMP Bank2_Label_8D01

World3_SaveRoomObjectsState1:
    LDA #$01
    STA $3E

Bank2_Label_8D01:
    LDX #$00

Bank2_Label_8D03:
    LDA a:World3EntityState,X
    CMP #$01
    BEQ Bank2_Label_8D11
    CMP #$04
    BEQ Bank2_Label_8D11
    JMP Bank2_Label_8D4C

Bank2_Label_8D11:
    LDA a:World3EntityType,X
    CMP #$18
    BCC Bank2_Label_8D4C
    LDY #$00

Bank2_Label_8D1A:
    CMP a:World3RoomObjectType,Y
    BEQ Bank2_Label_8D29
    INY
    CPY #$0D
    BNE Bank2_Label_8D1A
    LDA #$02
    JMP Bank2_Func_AF51

Bank2_Label_8D29:
    LDA a:World3EntityPersistentState,X
    CMP $3E
    BNE Bank2_Label_8D4C
    JSR Bank2_Func_8D52
    BCS Bank2_Label_8D46
    LDA $DF
    STA a:World3RoomObjectRoom,Y
    LDA a:World3EntityX,X
    STA a:World3RoomObjectX,Y
    LDA a:World3EntityY,X
    STA a:World3RoomObjectY,Y

Bank2_Label_8D46:
    LDA a:World3EntityPersistentState,X
    STA a:World3RoomObjectState,Y

Bank2_Label_8D4C:
    INX
    CPX #$08
    BNE Bank2_Label_8D03
    RTS

Bank2_Func_8D52:
    STX $3F
    LDA $9A
    BEQ Bank2_Label_8DA4
    LDX #$00

Bank2_Label_8D5A:
    LDA a:World3EntityState,X
    CMP #$01
    BNE Bank2_Label_8D9F
    LDA a:World3EntityType,X
    CMP #$1B
    BNE Bank2_Label_8D9F
    LDA a:World3EntityPersistentState,X
    BEQ Bank2_Label_8D9F
    LDX #$00
    STX $40

Bank2_Label_8D71:
    LDA a:World3RoomObjectRoom,X
    CMP $8B
    BNE Bank2_Label_8D81
    LDA a:World3RoomObjectType,X
    CMP #$18
    BCC Bank2_Label_8D81
    INC $40

Bank2_Label_8D81:
    INX
    CPX #$0D
    BNE Bank2_Label_8D71
    LDA $40
    CMP #$02
    BCS Bank2_Label_8DA4
    LDA $8B
    STA a:World3RoomObjectRoom,Y
    LDA $8C
    STA a:World3RoomObjectX,Y
    LDA $8D
    STA a:World3RoomObjectY,Y
    LDX $3F
    SEC
    RTS

Bank2_Label_8D9F:
    INX
    CPX #$08
    BNE Bank2_Label_8D5A

Bank2_Label_8DA4:
    LDX $3F
    CLC
    RTS

World3_ClearPlayerProjectiles:
    LDX #$00
    TXA

Bank2_Label_8DAB:
    STA a:World3PlayerProjectileState,X
    INX
    CPX #$0C
    BNE Bank2_Label_8DAB
    RTS

World3_ClearEntityStorage:
    LDA #$00
    STA $AB
    LDX #$00
    TXA

Bank2_Label_8DBB:
    STA a:World3EntityState,X
    INX
    CPX #$B0
    BNE Bank2_Label_8DBB

Bank2_Label_8DC3:
    RTS

Bank2_Func_8DC4:
    LDA $8E
    CMP #$04
    BEQ Bank2_Label_8DC3
    LDA $CB
    BNE Bank2_Label_8DC3
    LDA $AB
    BNE Bank2_Label_8E26
    LDA #$01
    STA $AB
    LDX $DF
    LDA a:$D66B,X
    STA $AC
    LDA a:$D6AB,X
    STA $AD
    LDA a:$D6EB,X
    STA $AE
    LDA a:$D72B,X
    STA $AF
    LDA a:$D76B,X
    STA $B0
    LDA a:$D7AB,X
    STA $B1
    LDA a:$D7EB,X
    STA $B2
    LDA a:$D82B,X
    STA $B3
    LDA a:$D86B,X
    STA $B4
    STA $C0
    LDA a:$D8AB,X
    STA $B5
    STA $C1
    LDA a:$D8EB,X
    STA $B6
    STA $C2
    LDA a:$D92B,X
    STA $B7
    STA $C3
    LDA #$00
    STA $B8
    STA $B9
    STA $BA
    STA $BB

Bank2_Label_8E26:
    LDA #$00
    STA $00
    LDA #$04
    STA $01

Bank2_Label_8E2E:
    LDX $00
    LDA $B4,X
    BEQ Bank2_Label_8E3F
    LDA $BC,X
    CLC
    ADC #$01
    AND #$03
    STA $BC,X
    BNE Bank2_Label_8E60

Bank2_Label_8E3F:
    LDA $AC,X
    STA $C4
    LDA $B0,X
    STA $C5
    LDA $B4,X
    STA $C6
    LDA $B8,X
    STA $C7
    JSR Bank2_Func_8E67
    LDX $00
    LDA $C5
    STA $B0,X
    LDA $C6
    STA $B4,X
    LDA $C7
    STA $B8,X

Bank2_Label_8E60:
    INC $00
    DEC $01
    BNE Bank2_Label_8E2E
    RTS

Bank2_Func_8E67:
    LDA $C7
    BNE Bank2_Label_8EB4
    LDA $C5
    BEQ Bank2_Label_8EB4
    LDA $C6
    BEQ Bank2_Label_8E7D
    DEC $C6
    BNE Bank2_Label_8EB4
    LDX $00
    LDA $C0,X
    STA $C6

Bank2_Label_8E7D:
    JSR World3_FindFreeEntitySlot
    BCC Bank2_Label_8EB4
    JSR World3_ClearEntitySlot
    LDA #$1E
    STA a:World3EntityActivationTimer,X
    LDA $C4
    STA a:World3EntityType,X
    TAY
    LDA a:World3_EntityHitPointsByType,Y
    STA a:World3EntityHitPoints,X
    LDA a:World3_EntityMetaspriteByType,Y
    STA a:World3EntityMetasprite,X
    LDA #$FF
    STA a:World3EntityX,X
    STA a:World3EntityY,X
    LDA #$02
    STA a:World3EntityState,X
    JSR World3_InitializeSpawnedEntity
    DEC $C5
    BNE Bank2_Label_8EB4
    LDA #$01
    STA $C7

Bank2_Label_8EB4:
    RTS

World3_EntityHitPointsByType:
    .byte $01, $02, $01, $02, $02, $00, $00, $00, $08, $00, $00, $00, $10, $10, $10, $10
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

World3_EntityMetaspriteByType:
    .byte $10, $14, $18, $1C, $20, $24, $40, $B0, $30, $34, $28, $2C, $80, $84, $88, $8C
    .byte $64, $40, $70, $74, $50, $54, $58, $5C, $44, $60, $4C, $48, $90, $94, $98, $9C

World3_EntityRenderFlagsByType:
    .byte $02, $03, $01, $03, $20, $00, $01, $00, $03, $03, $00, $00, $02, $02, $02, $02
    .byte $00, $01, $00, $01, $01, $01, $01, $01, $00, $00, $01, $00, $01, $01, $01, $01

World3_EntityContactDamageByType:
    .byte $02, $02, $04, $02, $02, $00, $04, $00, $02, $02, $04, $04, $04, $04, $04, $04
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

World3_EntityScoreRewardCodeByType:
    .byte $55, $41, $51, $42, $41, $51, $45, $33, $35, $51, $35, $51, $25, $25, $25, $25
    .byte $45, $41, $32, $31, $31, $31, $31, $31, $51, $51, $51, $51, $51, $51, $51, $51
