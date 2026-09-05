; Doraemon PRG bank 0 $990A-$A380
; World 1 metasprite composition, OAM placement, and animation data
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank0_Func_990A:
    LDA a:World1EntityPositionHigh+$26,Y
    STA World1MetaspriteOriginXHigh
    LSR A
    LSR A
    STA World1MetaspriteOriginYHigh
    LDA a:World1EntityX+$26,Y
    STA World1MetaspriteOriginX
    LDA a:World1EntityY+$26,Y
    STA World1MetaspriteOriginY
    LDA a:World1EntityRenderFlags+$26,Y
    STA World1MetaspriteRenderFlags
    LDA a:World1EntityMetasprite+$26,Y
    STA World1MetaspriteIndex
    JMP World1_ComposeMetasprite

World1_ComposeMetasprite:
    LDA World1MetaspriteRenderFlags
    AND #$40
    BEQ Bank0_Label_9937
    LDA FrameCounter
    AND #$01
    BEQ Bank0_Label_9937
    RTS

Bank0_Label_9937:
    LDA World1MetaspriteRenderFlags
    BPL Bank0_Label_9945
    LDA FrameCounter
    AND #$08
    BEQ Bank0_Label_9945
    LSR World1MetaspriteRenderFlags
    LSR World1MetaspriteRenderFlags

Bank0_Label_9945:
    LDX World1MetaspriteIndex
    TXA
    ASL A
    TAY
    LDA #$00
    ADC #$9C
    STA World1MetaspriteDataPointer+$01
    LDA #$B6
    STA World1MetaspriteDataPointer
    INY
    LDA (World1MetaspriteDataPointer),Y
    CMP #$04
    BCS Bank0_Label_999D
    PHA
    DEY
    LDA (World1MetaspriteDataPointer),Y
    TAX
    ASL A
    TAY
    LDA #$00
    ADC #$9C
    STA World1MetaspriteDataPointer+$01
    LDA #$B6
    STA World1MetaspriteDataPointer
    LDA (World1MetaspriteDataPointer),Y
    PHA
    INY
    LDA (World1MetaspriteDataPointer),Y
    STA World1MetaspriteDataPointer+$01
    PLA
    STA World1MetaspriteDataPointer
    LDY #$00
    LDA (World1MetaspriteDataPointer),Y
    INY
    STA World1MetaspritePiecesRemaining
    LDA (World1MetaspriteDataPointer),Y
    INY
    STA World1MetaspriteXMirrorExtent
    LDA (World1MetaspriteDataPointer),Y
    INY
    STA World1MetaspriteYMirrorExtent
    PLA
    BEQ Bank0_Label_9994
    CMP #$02
    BEQ Bank0_Label_999A
    BCC Bank0_Label_9997
    JMP Bank0_Label_9ACB

Bank0_Label_9994:
    JMP Bank0_Label_99AF

Bank0_Label_9997:
    JMP Bank0_Label_9A69

Bank0_Label_999A:
    JMP Bank0_Label_9A07

Bank0_Label_999D:
    PHA
    DEY
    LDA (World1MetaspriteDataPointer),Y
    STA World1MetaspriteDataPointer
    PLA
    STA World1MetaspriteDataPointer+$01
    LDY #$00
    LDA (World1MetaspriteDataPointer),Y
    INY
    STA World1MetaspritePiecesRemaining
    INY
    INY

Bank0_Label_99AF:
    LDA World1OamWriteIndex
    BMI Bank0_Label_9A06
    LDA (World1MetaspriteDataPointer),Y
    INY
    TAX
    AND #$7F
    CLC
    ADC World1MetaspriteOriginY
    STA World1OamY
    LDA World1MetaspriteOriginYHigh
    ADC #$00
    AND #$03
    BNE Bank0_Label_99FF
    LDA World1OamY
    CMP #$F0
    BCS Bank0_Label_99FF
    TXA
    AND #$80
    STA World1OamAttributes
    LDA (World1MetaspriteDataPointer),Y
    INY
    TAX
    AND #$7F
    CLC
    ADC World1MetaspriteOriginX
    STA World1OamX
    LDA World1MetaspriteOriginXHigh
    ADC #$00
    AND #$03
    BNE Bank0_Label_9A00
    TXA
    AND #$80
    LSR A
    ORA World1OamAttributes
    STA World1OamAttributes
    LDA (World1MetaspriteDataPointer),Y
    INY
    STA World1OamTile
    LDA World1MetaspriteRenderFlags
    AND #$03
    ORA World1OamAttributes
    STA World1OamAttributes
    JSR World1_EmitOamEntry
    JMP Bank0_Label_9A01

Bank0_Label_99FF:
    INY

Bank0_Label_9A00:
    INY

Bank0_Label_9A01:
    DEC World1MetaspritePiecesRemaining
    BNE Bank0_Label_99AF
    CLC

Bank0_Label_9A06:
    RTS

Bank0_Label_9A07:
    LDA World1OamWriteIndex
    BMI Bank0_Label_9A68
    LDA (World1MetaspriteDataPointer),Y
    INY
    TAX
    AND #$7F
    SEC
    SBC World1MetaspriteYMirrorExtent
    EOR #$FF
    CLC
    ADC #$01
    CLC
    ADC World1MetaspriteOriginY
    STA World1OamY
    LDA World1MetaspriteOriginYHigh
    ADC #$00
    AND #$03
    BNE Bank0_Label_9A61
    LDA World1OamY
    CMP #$F0
    BCS Bank0_Label_9A61
    TXA
    AND #$80
    STA World1OamAttributes
    LDA (World1MetaspriteDataPointer),Y
    INY
    TAX
    AND #$7F
    CLC
    ADC World1MetaspriteOriginX
    STA World1OamX
    LDA World1MetaspriteOriginXHigh
    ADC #$00
    AND #$03
    BNE Bank0_Label_9A62
    TXA
    AND #$80
    LSR A
    ORA World1OamAttributes
    STA World1OamAttributes
    LDA (World1MetaspriteDataPointer),Y
    INY
    STA World1OamTile
    LDA World1MetaspriteRenderFlags
    AND #$03
    ORA World1OamAttributes
    EOR #$80
    STA World1OamAttributes
    JSR World1_EmitOamEntry
    JMP Bank0_Label_9A63

Bank0_Label_9A61:
    INY

Bank0_Label_9A62:
    INY

Bank0_Label_9A63:
    DEC World1MetaspritePiecesRemaining
    BNE Bank0_Label_9A07
    CLC

Bank0_Label_9A68:
    RTS

Bank0_Label_9A69:
    LDA World1OamWriteIndex
    BMI Bank0_Label_9ACA
    LDA (World1MetaspriteDataPointer),Y
    INY
    TAX
    AND #$7F
    CLC
    ADC World1MetaspriteOriginY
    STA World1OamY
    LDA World1MetaspriteOriginYHigh
    ADC #$00
    AND #$03
    BNE Bank0_Label_9AC3
    LDA World1OamY
    CMP #$F0
    BCS Bank0_Label_9AC3
    TXA
    AND #$80
    STA World1OamAttributes
    LDA (World1MetaspriteDataPointer),Y
    INY
    TAX
    AND #$7F
    SEC
    SBC World1MetaspriteXMirrorExtent
    EOR #$FF
    CLC
    ADC #$01
    CLC
    ADC World1MetaspriteOriginX
    STA World1OamX
    LDA World1MetaspriteOriginXHigh
    ADC #$00
    AND #$03
    BNE Bank0_Label_9AC4
    TXA
    AND #$80
    LSR A
    ORA World1OamAttributes
    STA World1OamAttributes
    LDA (World1MetaspriteDataPointer),Y
    INY
    STA World1OamTile
    LDA World1MetaspriteRenderFlags
    AND #$03
    ORA World1OamAttributes
    EOR #$40
    STA World1OamAttributes
    JSR World1_EmitOamEntry
    JMP Bank0_Label_9AC5

Bank0_Label_9AC3:
    INY

Bank0_Label_9AC4:
    INY

Bank0_Label_9AC5:
    DEC World1MetaspritePiecesRemaining
    BNE Bank0_Label_9A69
    CLC

Bank0_Label_9ACA:
    RTS

Bank0_Label_9ACB:
    LDA World1OamWriteIndex
    BMI Bank0_Label_9B34
    LDA (World1MetaspriteDataPointer),Y
    INY
    TAX
    AND #$7F
    SEC
    SBC World1MetaspriteYMirrorExtent
    EOR #$FF
    CLC
    ADC #$01
    CLC
    ADC World1MetaspriteOriginY
    STA World1OamY
    LDA World1MetaspriteOriginYHigh
    ADC #$00
    AND #$03
    BNE Bank0_Label_9B2D
    LDA World1OamY
    CMP #$F0
    BCS Bank0_Label_9B2D
    TXA
    AND #$80
    STA World1OamAttributes
    LDA (World1MetaspriteDataPointer),Y
    INY
    TAX
    AND #$7F
    SEC
    SBC World1MetaspriteXMirrorExtent
    EOR #$FF
    CLC
    ADC #$01
    CLC
    ADC World1MetaspriteOriginX
    STA World1OamX
    LDA World1MetaspriteOriginXHigh
    ADC #$00
    AND #$03
    BNE Bank0_Label_9B2E
    TXA
    AND #$80
    LSR A
    ORA World1OamAttributes
    STA World1OamAttributes
    LDA (World1MetaspriteDataPointer),Y
    INY
    STA World1OamTile
    LDA World1MetaspriteRenderFlags
    AND #$03
    ORA World1OamAttributes
    EOR #$C0
    STA World1OamAttributes
    JSR World1_EmitOamEntry
    JMP Bank0_Label_9B2F

Bank0_Label_9B2D:
    INY

Bank0_Label_9B2E:
    INY

Bank0_Label_9B2F:
    DEC World1MetaspritePiecesRemaining
    BNE Bank0_Label_9ACB
    CLC

Bank0_Label_9B34:
    RTS

World1_EmitOamEntry:
    LDA World1OamWriteIndex
    BMI Bank0_Label_9B53
    ASL A
    TAX
    LDA World1OamY
    STA a:OamBuffer,X
    LDA World1OamTile
    STA a:$0301,X
    LDA World1OamAttributes
    STA a:$0302,X
    LDA World1OamX
    STA a:$0303,X
    INC World1OamWriteIndex
    INC World1OamWriteIndex

Bank0_Label_9B53:
    RTS

Bank0_Func_9B54:
    LDX #$00

Bank0_Label_9B56:
    LDA a:World1EntityType+$1E,X
    BEQ Bank0_Label_9BBD
    BPL Bank0_Label_9B7A
    AND #$7F
    LSR A
    LSR A
    CMP #$04
    BCS Bank0_Label_9B72
    AND #$03
    ORA #$20
    STA a:World1EntityMetasprite+$1E,X
    INC a:World1EntityType+$1E,X
    JMP Bank0_Label_9BBD

Bank0_Label_9B72:
    LDA #$00
    STA a:World1EntityType+$1E,X
    JMP Bank0_Label_9BBD

Bank0_Label_9B7A:
    LDA a:World1EntityPrimaryBehavior+$1E,X
    ASL A
    TAY
    LDA a:$9BC3,Y
    CLC
    ADC a:World1EntityX+$1E,X
    CMP #$F8
    BCS Bank0_Label_9BB8
    STA a:World1EntityX+$1E,X
    LDA a:$9BC4,Y
    CLC
    ADC a:World1EntityY+$1E,X
    CMP #$08
    BCC Bank0_Label_9BB8
    CMP #$E0
    BCS Bank0_Label_9BB8
    STA a:World1EntityY+$1E,X
    LDA #$04
    STA $00
    CMP #$03
    BNE Bank0_Label_9BAB
    LDA #$08
    STA $00

Bank0_Label_9BAB:
    JSR Bank0_Func_9BCB
    BEQ Bank0_Label_9BBD
    LDA #$80
    STA a:World1EntityType+$1E,X
    JMP Bank0_Label_9BBD

Bank0_Label_9BB8:
    LDA #$00
    STA a:World1EntityType+$1E,X

Bank0_Label_9BBD:
    INX
    CPX #$08
    BNE Bank0_Label_9B56
    RTS
    .byte $00, $04, $00, $FC, $FC, $00, $04, $00

Bank0_Func_9BCB:
    LDA PpuScrollXShadow
    AND #$07
    CLC
    ADC $00
    ADC a:World1EntityX+$1E,X
    LSR A
    LSR A
    LSR A
    ADC World1CameraTileX
    STA $A0
    LDA PpuScrollYShadow
    AND #$07
    CLC
    ADC $00
    ADC a:World1EntityY+$1E,X
    LSR A
    LSR A
    LSR A
    ADC World1CameraTileY
    STA $A2
    STX $A4
    LDX $A0
    LDY $A2
    JSR World1_LookupMapTile
    LDX $A4
    LDA a:$DADA,Y
    RTS

World1_UpdateWeaponAndTryFire:
    LDA World1WeaponPoseTimer
    BEQ Bank0_Label_9C02
    DEC World1WeaponPoseTimer

Bank0_Label_9C02:
    LDA World1PlayerDamageState
    BEQ Bank0_Label_9C0A
    CMP #$06
    BCC Bank0_Label_9C10

Bank0_Label_9C0A:
    LDA World1PressedButtons
    AND #$40
    BNE Bank0_Label_9C11

Bank0_Label_9C10:
    RTS

Bank0_Label_9C11:
    LDA World1WeaponLevel
    BEQ Bank0_Label_9C10
    LDX #$00

Bank0_Label_9C17:
    LDA a:World1EntityType+$1E,X
    BEQ Bank0_Label_9C26
    CPX World1ProjectileMaxSlot
    BEQ Bank0_Label_9C25
    INX
    CPX #$08
    BNE Bank0_Label_9C17

Bank0_Label_9C25:
    RTS

Bank0_Label_9C26:
    LDY World1WeaponLevel
    LDA a:World1_WeaponSoundByLevelMinusOne,Y
    JSR World1_Audio_QueueEffectWithPriority
    LDA World1WeaponLevel
    SEC
    SBC #$01
    ASL A
    ASL A
    ASL A
    ASL A
    STA $00
    LDA World1PlayerDirection
    ASL A
    ASL A
    AND #$0C
    ORA $00
    TAY
    LDA a:World1_ProjectileSpawnProfiles,Y
    INY
    CLC
    ADC World1PlayerX
    STA a:World1EntityX+$1E,X
    LDA a:World1_ProjectileSpawnProfiles,Y
    INY
    CLC
    ADC World1PlayerY
    STA a:World1EntityY+$1E,X
    LDA a:World1_ProjectileSpawnProfiles,Y
    INY
    STA a:World1EntityMetasprite+$1E,X
    LDA a:World1_ProjectileSpawnProfiles,Y
    INY
    STA a:World1EntityRenderFlags+$1E,X
    LDA #$00
    STA a:World1EntityPositionHigh+$1E,X
    LDA World1WeaponLevel
    STA a:World1EntityType+$1E,X
    LDA World1PlayerDirection
    AND #$03
    STA a:World1EntityPrimaryBehavior+$1E,X
    LDA #$FF
    STA a:World1EntitySourceObjectId+$1E,X
    LDA World1PlayerMetasprite
    AND #$0C
    LDA #$06
    STA World1WeaponPoseTimer

World1_WeaponSoundByLevelMinusOne:
    RTS
    .byte $01, $0C, $0D

World1_ProjectileSpawnProfiles:
    .byte $04, $10, $24, $00, $04, $08, $24, $00, $04, $0C, $24, $00, $04, $0C, $24, $00
    .byte $00, $10, $18, $00, $00, $0C, $19, $00, $00, $08, $1A, $00, $00, $08, $1B, $00
    .byte $00, $10, $1C, $82, $00, $0C, $1D, $82, $00, $08, $1E, $82, $00, $08, $1F, $82

World1_MetaspriteIndex:
    .byte $B1, $9D, $C6, $9D, $00, $00, $01, $01, $DB, $9D, $F0, $9D, $04, $01, $05, $01
    .byte $05, $9E, $1A, $9E, $08, $00, $2F, $9E, $08, $01, $09, $01, $08, $01, $0B, $01
    .byte $44, $9E, $10, $01, $59, $9E, $6E, $9E, $B8, $A2, $CD, $A2, $DC, $A2, $EB, $A2
    .byte $5E, $9F, $18, $02, $6D, $9F, $1A, $01, $7C, $9F, $1C, $02, $8B, $9F, $1E, $01
    .byte $9A, $9F, $A9, $9F, $B8, $9F, $C7, $9F, $58, $9F, $83, $9E, $CE, $9E, $0D, $9F
    .byte $FA, $A2, $4C, $9F, $D6, $9F, $E5, $9F, $F4, $9F, $03, $A0, $12, $A0, $21, $A0
    .byte $30, $A0, $A6, $A2, $AC, $A2, $B2, $A2, $39, $A0, $72, $A3, $9C, $9D, $36, $01
    .byte $48, $A0, $38, $01, $93, $A0, $E4, $A0, $35, $A1, $3C, $01, $4A, $A1, $3E, $01
    .byte $5F, $A1, $74, $A1, $40, $01, $41, $01, $89, $A1, $44, $01, $E6, $A1, $46, $01
    .byte $9E, $A1, $B3, $A1, $48, $01, $49, $01, $C8, $A1, $D7, $A1, $4C, $01, $4D, $01
    .byte $25, $A2, $34, $A2, $50, $01, $51, $01, $43, $A2, $54, $01, $F8, $A1, $56, $01
    .byte $52, $A2, $5E, $A2, $58, $01, $59, $01, $6A, $A2, $79, $A2, $5C, $01, $5D, $01
    .byte $88, $A2, $97, $A2, $60, $01, $61, $01, $07, $A2, $16, $A2, $64, $01, $00, $00
    .byte $09, $A3, $18, $A3, $68, $01, $69, $01, $27, $A3, $36, $A3, $6C, $01, $6D, $01
    .byte $45, $A3, $54, $A3, $63, $A3

World1_MetaspriteRecords:
    .byte $06, $08, $10, $00, $00, $0E, $00, $08, $0F, $08, $00, $1E, $08, $08, $1F, $10
    .byte $00, $2E, $10, $08, $2F, $06, $07, $11, $01, $00, $00, $01, $87, $00, $09, $00
    .byte $10, $09, $87, $10, $11, $00, $01, $11, $87, $01, $06, $07, $11, $00, $00, $00
    .byte $00, $87, $00, $08, $00, $10, $08, $07, $11, $10, $00, $20, $10, $07, $21, $06
    .byte $07, $11, $01, $00, $02, $01, $87, $02, $09, $00, $12, $09, $87, $12, $11, $00
    .byte $03, $11, $87, $03, $06, $07, $11, $00, $00, $02, $00, $87, $02, $08, $00, $12
    .byte $08, $07, $13, $10, $00, $22, $10, $07, $23, $06, $07, $11, $01, $00, $04, $01
    .byte $07, $05, $09, $00, $14, $09, $07, $15, $11, $00, $24, $11, $07, $25, $06, $07
    .byte $11, $00, $00, $06, $00, $07, $07, $08, $00, $16, $08, $07, $17, $10, $00, $26
    .byte $10, $07, $27, $06, $07, $11, $00, $00, $08, $00, $07, $09, $08, $00, $18, $08
    .byte $07, $19, $10, $00, $28, $10, $07, $29, $06, $07, $11, $00, $00, $0A, $00, $07
    .byte $0B, $08, $00, $1A, $08, $07, $1B, $10, $00, $2A, $10, $07, $2B, $06, $07, $11
    .byte $01, $00, $00, $01, $87, $00, $09, $00, $1D, $09, $87, $1D, $11, $00, $2D, $11
    .byte $87, $2D, $06, $07, $11, $01, $00, $00, $01, $87, $00, $09, $00, $1C, $09, $87
    .byte $1C, $11, $00, $2C, $11, $87, $2C, $18, $18, $20, $00, $00, $42, $00, $08, $43
    .byte $00, $10, $43, $00, $98, $42, $28, $00, $52, $28, $08, $53, $28, $10, $53, $28
    .byte $98, $52, $08, $02, $44, $08, $16, $44, $10, $02, $44, $10, $16, $44, $18, $02
    .byte $44, $18, $16, $44, $20, $02, $44, $20, $16, $44, $08, $10, $55, $10, $10, $55
    .byte $18, $10, $55, $20, $10, $55, $08, $08, $55, $10, $08, $55, $18, $08, $45, $20
    .byte $08, $55, $14, $18, $20, $00, $00, $42, $00, $08, $43, $00, $10, $43, $00, $98
    .byte $42, $28, $00, $52, $28, $08, $53, $28, $10, $53, $28, $98, $52, $08, $02, $44
    .byte $08, $16, $44, $10, $02, $44, $10, $16, $44, $18, $02, $44, $18, $16, $44, $20
    .byte $02, $44, $20, $16, $44, $08, $10, $56, $10, $10, $54, $18, $10, $46, $A0, $10
    .byte $56, $14, $18, $20, $00, $00, $42, $00, $08, $43, $00, $10, $43, $00, $98, $42
    .byte $28, $00, $52, $28, $08, $53, $28, $10, $53, $28, $98, $52, $08, $02, $44, $08
    .byte $16, $44, $10, $02, $44, $10, $16, $44, $18, $02, $44, $18, $16, $44, $20, $02
    .byte $44, $20, $16, $44, $08, $15, $44, $10, $15, $44, $18, $10, $47, $20, $15, $44
    .byte $03, $10, $00, $00, $00, $50, $00, $08, $51, $00, $90, $50, $01, $00, $00, $00
    .byte $00, $0D, $04, $08, $08, $00, $00, $C4, $00, $08, $C5, $08, $00, $D4, $08, $08
    .byte $D5, $04, $08, $08, $00, $00, $A0, $00, $08, $A1, $08, $00, $B0, $08, $08, $B1
    .byte $04, $08, $08, $80, $00, $85, $80, $88, $85, $88, $00, $84, $88, $88, $84, $04
    .byte $08, $08, $00, $00, $74, $00, $08, $75, $88, $00, $74, $88, $08, $75, $04, $08
    .byte $08, $00, $00, $E4, $00, $88, $E4, $88, $00, $E4, $88, $88, $E4, $04, $08, $08
    .byte $00, $00, $E5, $00, $88, $E5, $88, $00, $E5, $88, $88, $E5, $04, $08, $08, $00
    .byte $00, $F4, $00, $88, $F4, $88, $00, $F4, $88, $88, $F4, $04, $08, $08, $00, $00
    .byte $F5, $00, $88, $F5, $88, $00, $F5, $88, $88, $F5, $04, $08, $08, $00, $00, $E0
    .byte $00, $08, $E1, $08, $00, $F0, $08, $08, $F1, $04, $08, $08, $00, $00, $E2, $00
    .byte $08, $E3, $08, $00, $F2, $08, $08, $F3, $04, $08, $08, $00, $00, $C0, $00, $08
    .byte $C1, $08, $00, $D0, $08, $08, $D1, $04, $08, $08, $00, $00, $82, $00, $08, $83
    .byte $08, $00, $92, $08, $08, $93, $04, $08, $08, $00, $00, $80, $00, $08, $81, $08
    .byte $00, $90, $08, $08, $91, $04, $00, $00, $00, $00, $0C, $00, $88, $0C, $08, $00
    .byte $CC, $08, $08, $CD, $02, $08, $04, $04, $00, $0C, $04, $88, $0C, $04, $00, $00
    .byte $00, $00, $6E, $00, $08, $6F, $08, $00, $DD, $08, $87, $DD, $18, $28, $28, $00
    .byte $08, $4A, $00, $10, $4B, $00, $98, $4B, $00, $A0, $4A, $08, $08, $5A, $08, $10
    .byte $5B, $08, $98, $5B, $08, $A0, $5A, $10, $08, $6A, $10, $10, $6B, $10, $98, $6B
    .byte $10, $A0, $6A, $18, $08, $7A, $18, $10, $7B, $18, $98, $7B, $18, $20, $7D, $20
    .byte $08, $8A, $20, $10, $8B, $20, $98, $8B, $20, $20, $8D, $28, $08, $9A, $28, $10
    .byte $9B, $28, $18, $9C, $28, $20, $9D, $1A, $28, $28, $00, $08, $4A, $00, $10, $4B
    .byte $00, $98, $4B, $00, $A0, $4A, $08, $08, $5A, $08, $10, $5B, $08, $98, $5B, $08
    .byte $A0, $5A, $10, $08, $6A, $10, $10, $6B, $10, $98, $6B, $10, $A0, $6A, $18, $80
    .byte $6D, $18, $88, $6C, $18, $10, $7B, $18, $98, $7B, $18, $20, $6C, $18, $28, $6D
    .byte $20, $88, $7C, $20, $10, $8B, $20, $98, $8B, $20, $20, $7C, $28, $08, $9A, $28
    .byte $10, $9B, $28, $98, $9B, $28, $A0, $9A, $1A, $28, $28, $00, $08, $4A, $00, $10
    .byte $4B, $00, $98, $4B, $00, $A0, $4A, $08, $08, $5A, $08, $10, $5B, $08, $98, $5B
    .byte $08, $A0, $5A, $10, $08, $6A, $10, $10, $6B, $10, $98, $6B, $10, $A0, $6A, $18
    .byte $80, $6D, $18, $88, $6C, $18, $10, $7B, $18, $98, $7B, $18, $20, $6C, $18, $28
    .byte $6D, $20, $88, $7C, $20, $10, $8B, $20, $98, $8B, $20, $20, $7C, $28, $88, $9D
    .byte $28, $90, $9C, $28, $18, $9C, $28, $20, $9D, $06, $10, $08, $00, $00, $EB, $00
    .byte $08, $EC, $00, $10, $ED, $08, $00, $FC, $08, $08, $FD, $08, $10, $FE, $06, $08
    .byte $10, $00, $00, $A8, $00, $88, $A8, $08, $00, $B8, $08, $88, $B8, $10, $00, $C8
    .byte $10, $08, $C9, $06, $08, $10, $00, $00, $76, $00, $08, $77, $08, $00, $86, $08
    .byte $08, $87, $10, $00, $96, $10, $08, $97, $06, $08, $10, $00, $00, $76, $00, $08
    .byte $77, $08, $00, $86, $08, $08, $87, $10, $00, $A6, $10, $08, $A7, $06, $08, $10
    .byte $00, $00, $76, $00, $08, $77, $08, $00, $86, $08, $08, $87, $10, $00, $B6, $10
    .byte $08, $B7, $06, $08, $10, $00, $00, $94, $00, $08, $95, $08, $00, $A4, $08, $08
    .byte $A5, $10, $00, $B4, $10, $08, $B5, $06, $08, $10, $00, $00, $C4, $00, $08, $C5
    .byte $08, $00, $A4, $08, $08, $A5, $10, $00, $D4, $10, $08, $D5, $04, $08, $08, $00
    .byte $00, $7E, $00, $08, $7F, $08, $00, $8E, $08, $08, $8F, $04, $08, $08, $00, $00
    .byte $78, $00, $08, $79, $08, $00, $88, $08, $08, $89, $05, $08, $10, $00, $00, $A0
    .byte $00, $08, $A1, $08, $00, $B0, $08, $08, $B1, $10, $04, $EB, $04, $08, $08, $00
    .byte $00, $A2, $00, $08, $A3, $08, $00, $B2, $08, $08, $B3, $04, $08, $08, $00, $00
    .byte $C6, $00, $08, $C7, $08, $00, $D6, $08, $08, $D7, $04, $08, $08, $00, $00, $E6
    .byte $00, $08, $E7, $08, $00, $F6, $08, $08, $F7, $04, $08, $08, $00, $00, $D8, $00
    .byte $08, $D9, $08, $00, $E8, $08, $08, $E9, $04, $08, $08, $00, $00, $D8, $00, $08
    .byte $D9, $08, $00, $F8, $08, $08, $F9, $04, $08, $08, $00, $00, $EA, $00, $88, $EA
    .byte $08, $00, $FA, $08, $08, $FB, $03, $08, $08, $00, $08, $57, $08, $00, $66, $08
    .byte $08, $67, $03, $08, $08, $00, $08, $59, $08, $00, $68, $08, $08, $69, $04, $08
    .byte $08, $00, $00, $AA, $00, $08, $AB, $08, $00, $BA, $08, $08, $BB, $04, $08, $08
    .byte $00, $00, $AC, $00, $08, $AD, $08, $00, $BC, $08, $08, $BD, $04, $0A, $0A, $00
    .byte $02, $CA, $00, $0A, $CB, $08, $02, $DA, $08, $0A, $DB, $04, $0A, $0A, $00, $00
    .byte $98, $00, $08, $99, $08, $00, $B9, $08, $08, $A9, $01, $00, $00, $00, $00, $48
    .byte $01, $00, $00, $00, $00, $49, $01, $00, $00, $00, $00, $58, $06, $00, $00, $00
    .byte $00, $60, $00, $08, $61, $08, $00, $70, $08, $08, $71, $10, $00, $38, $10, $08
    .byte $DC, $04, $00, $00, $00, $00, $62, $00, $08, $63, $08, $00, $72, $08, $08, $73
    .byte $04, $00, $00, $00, $00, $4C, $00, $08, $4D, $08, $00, $5C, $08, $08, $5D, $04
    .byte $00, $00, $00, $00, $4E, $00, $08, $4F, $08, $00, $5E, $08, $08, $5F, $04, $00
    .byte $00, $00, $00, $62, $00, $08, $63, $08, $00, $72, $08, $08, $73, $04, $08, $08
    .byte $00, $00, $78, $00, $08, $79, $08, $00, $88, $08, $08, $88, $04, $08, $08, $00
    .byte $00, $78, $00, $08, $79, $08, $00, $DE, $08, $08, $DF, $04, $08, $08, $00, $00
    .byte $EC, $00, $08, $ED, $08, $00, $FC, $08, $08, $FD, $04, $08, $08, $00, $00, $EE
    .byte $00, $08, $EF, $08, $00, $FE, $08, $08, $FF, $04, $08, $08, $00, $00, $94, $00
    .byte $08, $95, $08, $00, $AE, $08, $08, $AF, $04, $08, $08, $00, $00, $A4, $00, $08
    .byte $A5, $08, $00, $BE, $08, $08, $BF, $04, $08, $08, $00, $00, $B4, $00, $08, $B5
    .byte $08, $00, $CE, $08, $08, $CF, $04, $08, $08, $00, $00, $40, $00, $08, $41, $08
    .byte $00, $64, $08, $08, $65
