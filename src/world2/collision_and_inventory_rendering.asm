; Doraemon PRG bank 1 $92EC-$9660
; World 2 metatile collision, player/inventory sprite composition, and OAM services
; Generated deterministically from pinned Ghidra/GhidraNes facts

World2_RenderSlot2VerticalAttackSegment:
    STA World2OamY
    LDA a:$9326,X
    PHA
    AND #$0F
    CLC
    ADC #$9F
    STA World2OamTile
    PLA
    BPL Bank1_Label_9300
    LDA #$82
    BNE Bank1_Label_9302

Bank1_Label_9300:
    LDA #$02

Bank1_Label_9302:
    STA World2OamAttributes
    LDA World2MetaspriteOriginX
    JMP World2_SetSpriteXBeforeFlickerEmit

World2_PrepareSlot2HorizontalAttackSegment:
    LDA World2InventoryY+$02
    STA World2OamY
    LDA a:$9326,X
    PHA
    AND #$0F
    CLC
    ADC #$A9
    STA World2OamTile
    PLA
    BPL Bank1_Label_931F
    LDA #$42
    BNE Bank1_Label_9321

Bank1_Label_931F:
    LDA #$02

Bank1_Label_9321:
    STA World2OamAttributes
    LDA World2MetaspriteOriginX
    RTS
    .byte $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $02, $03, $82, $00
    .byte $00, $00, $00, $00, $00, $04, $03, $84, $00, $00, $00, $00, $00, $05, $06, $07
    .byte $86, $85, $00, $00, $00, $00, $08, $07, $09, $87, $88, $00, $00, $00, $05, $06
    .byte $0A, $09, $8A, $86, $85, $00, $00, $08, $07, $0A, $09, $8A, $87, $88, $00, $05
    .byte $06, $0A, $09, $09, $09, $8A, $86, $85, $08, $07, $0A, $09, $09, $09, $8A, $87
    .byte $88

World2_TestMetatileCollision:
    LDA $68
    CLC
    ADC World2ScrollY
    BCC Bank1_Label_9380
    ADC #$0F

Bank1_Label_9380:
    AND #$F0
    CMP #$F0
    BNE Bank1_Label_9388
    LDA #$00

Bank1_Label_9388:
    STA $69
    LDA $67
    CLC
    ADC World2ScrollX
    ROR A
    ROR A
    ROR A
    ROR A
    AND #$0F
    ORA $69
    TAY
    LDA a:World2ScreenMetatiles,Y
    PHA
    AND #$07
    TAY
    LDA a:World2_CollisionBitMasks,Y
    STA $AF
    PLA
    LSR A
    LSR A
    LSR A
    TAY
    LDA a:World2_MetatileCollisionBits,Y
    AND $AF
    RTS

World2_CollisionBitMasks:
    .byte $80, $40, $20, $10, $08, $04, $02, $01

World2_RenderPlayerAndInventory:
    JSR World2_RenderPlayer
    JSR World2_RenderInventorySlot0
    JSR World2_RenderInventorySlot1
    JSR World2_RenderInventorySlot2Or5
    JSR World2_RenderInventorySlot3
    JSR World2_RenderInventorySlot5
    JSR World2_RenderPlayerDamageEffect
    JSR World2_RenderInventorySlot6
    JMP World2_RenderInventorySlot4

World2_FindFreeOamEntry:
    LDY #$00

Bank1_Label_93D4:
    LDA a:OamBuffer,Y
    CMP #$F8
    BEQ World2_ReturnOamAvailable
    INY
    INY
    INY
    INY
    BNE Bank1_Label_93D4
    SEC
    RTS

World2_ReturnOamAvailable:
    CLC
    RTS

World2_RenderPriorityInventorySlots2And3:
    JSR World2_RenderInventorySlot3
    JSR World2_RenderInventorySlot2Or5
    RTS

World2_RenderPlayerDamageEffect:
    LDA World2PlayerDamageEffect
    BEQ Bank1_Label_942F
    AND #$01
    LDX World2ScrollDirection
    BEQ Bank1_Label_941A
    DEX
    BEQ Bank1_Label_9408
    TAX
    LDA World2PlayerX
    STA $67
    LDA World2PlayerY
    CLC
    ADC #$18
    STA $68
    JMP World2_RenderTwoSpriteEffectAtProbePosition

Bank1_Label_9408:
    CLC
    ADC #$02
    TAX
    LDA World2PlayerX
    STA $67
    LDA World2PlayerY
    SEC
    SBC #$10
    STA $68
    JMP World2_RenderTwoSpriteEffectAtProbePosition

Bank1_Label_941A:
    CLC
    ADC #$04
    TAX
    LDA World2PlayerY
    CLC
    ADC #$09
    STA $68
    LDA World2PlayerX
    CLC
    ADC #$10
    STA $67
    JSR World2_RenderTwoSpriteEffectAtProbePosition

Bank1_Label_942F:
    RTS

World2_RenderTwoSpriteEffectAtProbePosition:
    LDA $67
    STA World2MetaspriteOriginX
    STX $67
    LDA $68
    STA World2MetaspriteOriginY
    LDA #$00
    CPX #$02
    BCC Bank1_Label_9446
    CPX #$04
    BEQ Bank1_Label_9446
    LDA #$80

Bank1_Label_9446:
    STA World2MetaspriteAttributes
    JSR World2_FindFreeOamEntry
    BCS Bank1_Label_9498
    JMP Bank1_Label_946F

World2_RenderInventorySlot4:
    LDX #$04
    LDA World2InventoryState,X
    BEQ Bank1_Label_9498
    CMP #$03
    BEQ Bank1_Label_9498
    JSR World2_FindFreeOamEntry
    BCS Bank1_Label_9498
    LDA #$00
    STA World2MetaspriteAttributes
    LDA World2InventoryX,X
    STA World2MetaspriteOriginX
    LDA World2InventoryY,X
    STA World2MetaspriteOriginY
    LDA #$00
    STA $67

Bank1_Label_946F:
    LDA $67
    ASL A
    ASL A
    TAX
    JSR World2_RenderTwoSpriteEffectRow

World2_RenderTwoSpriteEffectRow:
    JSR World2_EmitEffectTableSprite
    LDA $67
    CMP #$04
    BCS Bank1_Label_9486
    LDA World2MetaspriteAttributes
    EOR #$40
    STA World2MetaspriteAttributes

Bank1_Label_9486:
    JSR World2_EmitEffectTableSprite
    LDA $67
    CMP #$04
    BCS Bank1_Label_9495
    LDA World2MetaspriteAttributes
    EOR #$40
    STA World2MetaspriteAttributes

Bank1_Label_9495:
    JMP Bank1_Label_9560

Bank1_Label_9498:
    RTS

World2_EmitEffectTableSprite:
    LDA World2MetaspriteOriginY
    STA World2OamY
    LDA a:$978D,X
    STA World2OamTile
    LDA World2MetaspriteAttributes
    STA World2OamAttributes
    LDA World2MetaspriteOriginX
    STA World2OamX
    LDA a:$978D,X
    BEQ Bank1_Label_94B2
    JSR World2_EmitOamEntry

Bank1_Label_94B2:
    INX
    LDA World2OamX
    CLC
    ADC #$08
    STA World2MetaspriteOriginX
    RTS

World2_RenderInventorySlot6:
    LDA World2InventoryState+$06
    BEQ Bank1_Label_94FD
    CMP #$03
    BEQ Bank1_Label_94FD
    JSR World2_ReturnOamAvailable
    BCS Bank1_Label_94FD
    LDA World2InventoryX+$06
    STA World2OamX
    LDA World2InventoryY+$06
    STA World2OamY
    LDA #$3E
    STA World2OamTile
    LDX #$00
    JSR World2_EmitInventorySlot6Sprite
    JSR World2_EmitInventorySlot6Sprite
    LDA World2OamX
    SEC
    SBC #$10
    STA World2OamX
    LDA World2OamY
    CLC
    ADC #$08
    STA World2OamY
    JSR World2_EmitInventorySlot6Sprite

World2_EmitInventorySlot6Sprite:
    LDA a:$97A5,X
    STA World2OamAttributes
    JSR World2_EmitOamEntry
    LDA World2OamX
    CLC
    ADC #$08
    STA World2OamX
    INX

Bank1_Label_94FD:
    RTS

World2_RenderInventorySlot3:
    LDX #$03
    LDA World2InventoryState,X
    BEQ Bank1_Label_956E
    CMP #$03
    BEQ Bank1_Label_956E
    JSR World2_ReturnOamAvailable
    BCS Bank1_Label_956E
    LDA World2InventoryX,X
    STA World2OamX
    LDA World2InventoryY,X
    STA World2OamY
    LDA #$01
    STA World2OamAttributes
    LDA #$EA
    STA World2OamTile
    JSR World2_EmitOamEntry
    LDA World2OamX
    CLC
    ADC #$08
    STA World2OamX
    LDA World2OamAttributes
    ORA #$40
    STA World2OamAttributes
    JMP World2_EmitOamEntry

World2_RenderInventorySlot5:
    LDX #$05
    BNE Bank1_Label_9536

World2_RenderInventorySlot2Or5:
    LDX #$02

Bank1_Label_9536:
    LDA World2InventoryState,X
    BEQ Bank1_Label_956E
    CMP #$03
    BEQ Bank1_Label_956E
    JSR World2_FindFreeOamEntry
    BCS Bank1_Label_956E
    LDA a:$956D,X
    STA World2MetaspriteAttributes
    LDA World2InventoryX,X
    STA World2MetaspriteOriginX
    LDA World2InventoryY,X
    STA World2MetaspriteOriginY
    TXA
    ASL A
    ASL A
    CLC
    ADC #$94
    TAX
    JSR World2_RenderTwoSpriteInventoryRow

World2_RenderTwoSpriteInventoryRow:
    JSR World2_EmitInventorySprite
    JSR World2_EmitInventorySprite

Bank1_Label_9560:
    LDA World2MetaspriteOriginX
    SEC
    SBC #$10
    STA World2MetaspriteOriginX
    LDA World2MetaspriteOriginY
    CLC
    ADC #$08
    STA World2MetaspriteOriginY

Bank1_Label_956E:
    RTS
    .byte $01, $01, $00, $00

World2_RenderInventorySlot0:
    LDA World2InventoryState
    BEQ Bank1_Label_956E
    LDY #$30
    CMP #$03
    BEQ Bank1_Label_9591
    LDX #$18
    LDA World2FrameCounter
    AND #$10
    BEQ Bank1_Label_9586
    INX

Bank1_Label_9586:
    LDA World2InventoryX
    STA World2MetaspriteOriginX
    LDA World2InventoryY
    STA World2MetaspriteOriginY
    JMP Bank1_Label_95F8

Bank1_Label_9591:
    LDA World2PlayerHistoryWriteIndex
    SEC
    SBC #$2F
    BPL Bank1_Label_959A
    ADC #$30

Bank1_Label_959A:
    TAX
    LDA a:World2PlayerXHistory,X
    STA World2MetaspriteOriginX
    STA World2InventoryX
    LDA a:World2PlayerYHistory,X
    STA World2MetaspriteOriginY
    STA World2InventoryY
    LDA World2ScrollDirection
    ASL A
    CLC
    ADC #$12
    TAX
    JMP Bank1_Label_95F1

Bank1_Label_95B3:
    RTS

World2_RenderInventorySlot1:
    LDA World2InventoryState+$01
    BEQ Bank1_Label_95B3
    LDY #$18
    CMP #$03
    BEQ Bank1_Label_95D2
    LDX #$10
    LDA World2FrameCounter
    AND #$10
    BEQ Bank1_Label_95C7
    INX

Bank1_Label_95C7:
    LDA World2InventoryX+$01
    STA World2MetaspriteOriginX
    LDA World2InventoryY+$01
    STA World2MetaspriteOriginY
    JMP Bank1_Label_95F8

Bank1_Label_95D2:
    LDA World2PlayerHistoryWriteIndex
    SEC
    SBC #$17
    BPL Bank1_Label_95DB
    ADC #$30

Bank1_Label_95DB:
    TAX
    LDA a:World2PlayerXHistory,X
    STA World2MetaspriteOriginX
    STA World2InventoryX+$01
    LDA a:World2PlayerYHistory,X
    STA World2MetaspriteOriginY
    STA World2InventoryY+$01
    LDA World2ScrollDirection
    ASL A
    CLC
    ADC #$0A
    TAX

Bank1_Label_95F1:
    LDA World2FrameCounter
    AND #$02
    BEQ Bank1_Label_95F8
    INX

Bank1_Label_95F8:
    LDA #$21
    STA World2MetaspriteAttributes
    TXA
    STA $98
    ASL A
    ADC $98
    ASL A
    TAX
    BNE Bank1_Label_965B

World2_RenderPlayer:
    LDY #$00
    LDA #$00
    STA World2MetaspriteAttributes
    LDA World2PlayerDefeated
    BNE Bank1_Label_9619
    LDX World2PlayerDamageTimer
    BEQ Bank1_Label_9628
    LDA World2FrameCounter
    ROR A
    BCS Bank1_Label_966A

Bank1_Label_9619:
    CPX #$50
    BCC Bank1_Label_9628
    LDA World2FrameCounter
    AND #$08
    LSR A
    LSR A
    LSR A
    ADC #$08
    BNE Bank1_Label_964C

Bank1_Label_9628:
    LDA World2ScrollDirection
    BEQ Bank1_Label_963D
    TAX
    LDA World2FrameCounter
    AND #$02
    LSR A
    ADC #$04
    CPX #$01
    BEQ Bank1_Label_964C
    CLC
    ADC #$02
    BNE Bank1_Label_964C

Bank1_Label_963D:
    LDA World2FrameCounter
    AND #$02
    LSR A
    TAX
    LDA World2FrameCounter
    AND #$10
    BEQ Bank1_Label_964B
    INX
    INX

Bank1_Label_964B:
    TXA

Bank1_Label_964C:
    STA $98
    ASL A
    ADC $98
    ASL A
    TAX
    LDA World2PlayerX
    STA World2MetaspriteOriginX
    LDA World2PlayerY
    STA World2MetaspriteOriginY

Bank1_Label_965B:
    JSR World2_RenderMetaspriteRow
    JSR World2_RenderMetaspriteRow
