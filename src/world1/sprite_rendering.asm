; Doraemon PRG bank 0 $990A-$A380
; World 1 metasprite composition, OAM placement, and animation data
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank0_Func_990A:
    LDA a:World1EntityPositionHigh+$26,Y
    STA $46
    LSR A
    LSR A
    STA $48
    LDA a:World1EntityX+$26,Y
    STA $45
    LDA a:World1EntityY+$26,Y
    STA $47
    LDA a:World1EntityRenderFlags+$26,Y
    STA $4A
    LDA a:World1EntityMetasprite+$26,Y
    STA $49
    JMP World1_ComposeMetasprite

World1_ComposeMetasprite:
    LDA $4A
    AND #$40
    BEQ Bank0_Label_9937
    LDA FrameCounter
    AND #$01
    BEQ Bank0_Label_9937
    RTS

Bank0_Label_9937:
    LDA $4A
    BPL Bank0_Label_9945
    LDA FrameCounter
    AND #$08
    BEQ Bank0_Label_9945
    LSR $4A
    LSR $4A

Bank0_Label_9945:
    LDX $49
    TXA
    ASL A
    TAY
    LDA #$00
    ADC #$9C
    STA $4C
    LDA #$B6
    STA $4B
    INY
    LDA ($4B),Y
    CMP #$04
    BCS Bank0_Label_999D
    PHA
    DEY
    LDA ($4B),Y
    TAX
    ASL A
    TAY
    LDA #$00
    ADC #$9C
    STA $4C
    LDA #$B6
    STA $4B
    LDA ($4B),Y
    PHA
    INY
    LDA ($4B),Y
    STA $4C
    PLA
    STA $4B
    LDY #$00
    LDA ($4B),Y
    INY
    STA $4F
    LDA ($4B),Y
    INY
    STA $4D
    LDA ($4B),Y
    INY
    STA $4E
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
    LDA ($4B),Y
    STA $4B
    PLA
    STA $4C
    LDY #$00
    LDA ($4B),Y
    INY
    STA $4F
    INY
    INY

Bank0_Label_99AF:
    LDA $50
    BMI Bank0_Label_9A06
    LDA ($4B),Y
    INY
    TAX
    AND #$7F
    CLC
    ADC $47
    STA $41
    LDA $48
    ADC #$00
    AND #$03
    BNE Bank0_Label_99FF
    LDA $41
    CMP #$F0
    BCS Bank0_Label_99FF
    TXA
    AND #$80
    STA $43
    LDA ($4B),Y
    INY
    TAX
    AND #$7F
    CLC
    ADC $45
    STA $44
    LDA $46
    ADC #$00
    AND #$03
    BNE Bank0_Label_9A00
    TXA
    AND #$80
    LSR A
    ORA $43
    STA $43
    LDA ($4B),Y
    INY
    STA $42
    LDA $4A
    AND #$03
    ORA $43
    STA $43
    JSR Bank0_Func_9B35
    JMP Bank0_Label_9A01

Bank0_Label_99FF:
    INY

Bank0_Label_9A00:
    INY

Bank0_Label_9A01:
    DEC $4F
    BNE Bank0_Label_99AF
    CLC

Bank0_Label_9A06:
    RTS

Bank0_Label_9A07:
    LDA $50
    BMI Bank0_Label_9A68
    LDA ($4B),Y
    INY
    TAX
    AND #$7F
    SEC
    SBC $4E
    EOR #$FF
    CLC
    ADC #$01
    CLC
    ADC $47
    STA $41
    LDA $48
    ADC #$00
    AND #$03
    BNE Bank0_Label_9A61
    LDA $41
    CMP #$F0
    BCS Bank0_Label_9A61
    TXA
    AND #$80
    STA $43
    LDA ($4B),Y
    INY
    TAX
    AND #$7F
    CLC
    ADC $45
    STA $44
    LDA $46
    ADC #$00
    AND #$03
    BNE Bank0_Label_9A62
    TXA
    AND #$80
    LSR A
    ORA $43
    STA $43
    LDA ($4B),Y
    INY
    STA $42
    LDA $4A
    AND #$03
    ORA $43
    EOR #$80
    STA $43
    JSR Bank0_Func_9B35
    JMP Bank0_Label_9A63

Bank0_Label_9A61:
    INY

Bank0_Label_9A62:
    INY

Bank0_Label_9A63:
    DEC $4F
    BNE Bank0_Label_9A07
    CLC

Bank0_Label_9A68:
    RTS

Bank0_Label_9A69:
    LDA $50
    BMI Bank0_Label_9ACA
    LDA ($4B),Y
    INY
    TAX
    AND #$7F
    CLC
    ADC $47
    STA $41
    LDA $48
    ADC #$00
    AND #$03
    BNE Bank0_Label_9AC3
    LDA $41
    CMP #$F0
    BCS Bank0_Label_9AC3
    TXA
    AND #$80
    STA $43
    LDA ($4B),Y
    INY
    TAX
    AND #$7F
    SEC
    SBC $4D
    EOR #$FF
    CLC
    ADC #$01
    CLC
    ADC $45
    STA $44
    LDA $46
    ADC #$00
    AND #$03
    BNE Bank0_Label_9AC4
    TXA
    AND #$80
    LSR A
    ORA $43
    STA $43
    LDA ($4B),Y
    INY
    STA $42
    LDA $4A
    AND #$03
    ORA $43
    EOR #$40
    STA $43
    JSR Bank0_Func_9B35
    JMP Bank0_Label_9AC5

Bank0_Label_9AC3:
    INY

Bank0_Label_9AC4:
    INY

Bank0_Label_9AC5:
    DEC $4F
    BNE Bank0_Label_9A69
    CLC

Bank0_Label_9ACA:
    RTS

Bank0_Label_9ACB:
    LDA $50
    BMI Bank0_Label_9B34
    LDA ($4B),Y
    INY
    TAX
    AND #$7F
    SEC
    SBC $4E
    EOR #$FF
    CLC
    ADC #$01
    CLC
    ADC $47
    STA $41
    LDA $48
    ADC #$00
    AND #$03
    BNE Bank0_Label_9B2D
    LDA $41
    CMP #$F0
    BCS Bank0_Label_9B2D
    TXA
    AND #$80
    STA $43
    LDA ($4B),Y
    INY
    TAX
    AND #$7F
    SEC
    SBC $4D
    EOR #$FF
    CLC
    ADC #$01
    CLC
    ADC $45
    STA $44
    LDA $46
    ADC #$00
    AND #$03
    BNE Bank0_Label_9B2E
    TXA
    AND #$80
    LSR A
    ORA $43
    STA $43
    LDA ($4B),Y
    INY
    STA $42
    LDA $4A
    AND #$03
    ORA $43
    EOR #$C0
    STA $43
    JSR Bank0_Func_9B35
    JMP Bank0_Label_9B2F

Bank0_Label_9B2D:
    INY

Bank0_Label_9B2E:
    INY

Bank0_Label_9B2F:
    DEC $4F
    BNE Bank0_Label_9ACB
    CLC

Bank0_Label_9B34:
    RTS

Bank0_Func_9B35:
    LDA $50
    BMI Bank0_Label_9B53
    ASL A
    TAX
    LDA $41
    STA a:OamBuffer,X
    LDA $42
    STA a:$0301,X
    LDA $43
    STA a:$0302,X
    LDA $44
    STA a:$0303,X
    INC $50
    INC $50

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
    ADC $5B
    STA $A0
    LDA PpuScrollYShadow
    AND #$07
    CLC
    ADC $00
    ADC a:World1EntityY+$1E,X
    LSR A
    LSR A
    LSR A
    ADC $5C
    STA $A2
    STX $A4
    LDX $A0
    LDY $A2
    JSR Bank0_Func_A6A7
    LDX $A4
    LDA a:$DADA,Y
    RTS

Bank0_Func_9BFC:
    LDA $63
    BEQ Bank0_Label_9C02
    DEC $63

Bank0_Label_9C02:
    LDA $79
    BEQ Bank0_Label_9C0A
    CMP #$06
    BCC Bank0_Label_9C10

Bank0_Label_9C0A:
    LDA $65
    AND #$40
    BNE Bank0_Label_9C11

Bank0_Label_9C10:
    RTS

Bank0_Label_9C11:
    LDA $7B
    BEQ Bank0_Label_9C10
    LDX #$00

Bank0_Label_9C17:
    LDA a:World1EntityType+$1E,X
    BEQ Bank0_Label_9C26
    CPX $84
    BEQ Bank0_Label_9C25
    INX
    CPX #$08
    BNE Bank0_Label_9C17

Bank0_Label_9C25:
    RTS

Bank0_Label_9C26:
    LDY $7B
    LDA a:$9C82,Y
    JSR World1_Audio_QueueEffectWithPriority
    LDA $7B
    SEC
    SBC #$01
    ASL A
    ASL A
    ASL A
    ASL A
    STA $00
    LDA $7F
    ASL A
    ASL A
    AND #$0C
    ORA $00
    TAY
    LDA a:$9C86,Y
    INY
    CLC
    ADC $75
    STA a:World1EntityX+$1E,X
    LDA a:$9C86,Y
    INY
    CLC
    ADC $76
    STA a:World1EntityY+$1E,X
    LDA a:$9C86,Y
    INY
    STA a:World1EntityMetasprite+$1E,X
    LDA a:$9C86,Y
    INY
    STA a:World1EntityRenderFlags+$1E,X
    LDA #$00
    STA a:World1EntityPositionHigh+$1E,X
    LDA $7B
    STA a:World1EntityType+$1E,X
    LDA $7F
    AND #$03
    STA a:World1EntityPrimaryBehavior+$1E,X
    LDA #$FF
    STA a:World1EntitySourceObjectId+$1E,X
    LDA $77
    AND #$0C
    LDA #$06
    STA $63
    RTS
    .byte $01, $0C, $0D, $04, $10, $24, $00, $04, $08, $24, $00, $04, $0C, $24, $00, $04
    .byte $0C, $24, $00, $00, $10, $18, $00, $00, $0C, $19, $00, $00, $08, $1A, $00, $00
    .byte $08, $1B, $00, $00, $10, $1C, $82, $00, $0C, $1D, $82, $00, $08, $1E, $82, $00
    .byte $08, $1F, $82, $B1, $9D, $C6, $9D, $00, $00, $01, $01, $DB, $9D, $F0, $9D, $04
    .byte $01, $05, $01, $05, $9E, $1A, $9E, $08, $00, $2F, $9E, $08, $01, $09, $01, $08
    .byte $01, $0B, $01, $44, $9E, $10, $01, $59, $9E, $6E, $9E, $B8, $A2, $CD, $A2, $DC
    .byte $A2, $EB, $A2, $5E, $9F, $18, $02, $6D, $9F, $1A, $01, $7C, $9F, $1C, $02, $8B
    .byte $9F, $1E, $01, $9A, $9F, $A9, $9F, $B8, $9F, $C7, $9F, $58, $9F, $83, $9E, $CE
    .byte $9E, $0D, $9F, $FA, $A2, $4C, $9F, $D6, $9F, $E5, $9F, $F4, $9F, $03, $A0, $12
    .byte $A0, $21, $A0, $30, $A0, $A6, $A2, $AC, $A2, $B2, $A2, $39, $A0, $72, $A3, $9C
    .byte $9D, $36, $01, $48, $A0, $38, $01, $93, $A0, $E4, $A0, $35, $A1, $3C, $01, $4A
    .byte $A1, $3E, $01, $5F, $A1, $74, $A1, $40, $01, $41, $01, $89, $A1, $44, $01, $E6
    .byte $A1, $46, $01, $9E, $A1, $B3, $A1, $48, $01, $49, $01, $C8, $A1, $D7, $A1, $4C
    .byte $01, $4D, $01, $25, $A2, $34, $A2, $50, $01, $51, $01, $43, $A2, $54, $01, $F8
    .byte $A1, $56, $01, $52, $A2, $5E, $A2, $58, $01, $59, $01, $6A, $A2, $79, $A2, $5C
    .byte $01, $5D, $01, $88, $A2, $97, $A2, $60, $01, $61, $01, $07, $A2, $16, $A2, $64
    .byte $01, $00, $00, $09, $A3, $18, $A3, $68, $01, $69, $01, $27, $A3, $36, $A3, $6C
    .byte $01, $6D, $01, $45, $A3, $54, $A3, $63, $A3, $06, $08, $10, $00, $00, $0E, $00
    .byte $08, $0F, $08, $00, $1E, $08, $08, $1F, $10, $00, $2E, $10, $08, $2F, $06, $07
    .byte $11, $01, $00, $00, $01, $87, $00, $09, $00, $10, $09, $87, $10, $11, $00, $01
    .byte $11, $87, $01, $06, $07, $11, $00, $00, $00, $00, $87, $00, $08, $00, $10, $08
    .byte $07, $11, $10, $00, $20, $10, $07, $21, $06, $07, $11, $01, $00, $02, $01, $87
    .byte $02, $09, $00, $12, $09, $87, $12, $11, $00, $03, $11, $87, $03, $06, $07, $11
    .byte $00, $00, $02, $00, $87, $02, $08, $00, $12, $08, $07, $13, $10, $00, $22, $10
    .byte $07, $23, $06, $07, $11, $01, $00, $04, $01, $07, $05, $09, $00, $14, $09, $07
    .byte $15, $11, $00, $24, $11, $07, $25, $06, $07, $11, $00, $00, $06, $00, $07, $07
    .byte $08, $00, $16, $08, $07, $17, $10, $00, $26, $10, $07, $27, $06, $07, $11, $00
    .byte $00, $08, $00, $07, $09, $08, $00, $18, $08, $07, $19, $10, $00, $28, $10, $07
    .byte $29, $06, $07, $11, $00, $00, $0A, $00, $07, $0B, $08, $00, $1A, $08, $07, $1B
    .byte $10, $00, $2A, $10, $07, $2B, $06, $07, $11, $01, $00, $00, $01, $87, $00, $09
    .byte $00, $1D, $09, $87, $1D, $11, $00, $2D, $11, $87, $2D, $06, $07, $11, $01, $00
    .byte $00, $01, $87, $00, $09, $00, $1C, $09, $87, $1C, $11, $00, $2C, $11, $87, $2C
    .byte $18, $18, $20, $00, $00, $42, $00, $08, $43, $00, $10, $43, $00, $98, $42, $28
    .byte $00, $52, $28, $08, $53, $28, $10, $53, $28, $98, $52, $08, $02, $44, $08, $16
    .byte $44, $10, $02, $44, $10, $16, $44, $18, $02, $44, $18, $16, $44, $20, $02, $44
    .byte $20, $16, $44, $08, $10, $55, $10, $10, $55, $18, $10, $55, $20, $10, $55, $08
    .byte $08, $55, $10, $08, $55, $18, $08, $45, $20, $08, $55, $14, $18, $20, $00, $00
    .byte $42, $00, $08, $43, $00, $10, $43, $00, $98, $42, $28, $00, $52, $28, $08, $53
    .byte $28, $10, $53, $28, $98, $52, $08, $02, $44, $08, $16, $44, $10, $02, $44, $10
    .byte $16, $44, $18, $02, $44, $18, $16, $44, $20, $02, $44, $20, $16, $44, $08, $10
    .byte $56, $10, $10, $54, $18, $10, $46, $A0, $10, $56, $14, $18, $20, $00, $00, $42
    .byte $00, $08, $43, $00, $10, $43, $00, $98, $42, $28, $00, $52, $28, $08, $53, $28
    .byte $10, $53, $28, $98, $52, $08, $02, $44, $08, $16, $44, $10, $02, $44, $10, $16
    .byte $44, $18, $02, $44, $18, $16, $44, $20, $02, $44, $20, $16, $44, $08, $15, $44
    .byte $10, $15, $44, $18, $10, $47, $20, $15, $44, $03, $10, $00, $00, $00, $50, $00
    .byte $08, $51, $00, $90, $50, $01, $00, $00, $00, $00, $0D, $04, $08, $08, $00, $00
    .byte $C4, $00, $08, $C5, $08, $00, $D4, $08, $08, $D5, $04, $08, $08, $00, $00, $A0
    .byte $00, $08, $A1, $08, $00, $B0, $08, $08, $B1, $04, $08, $08, $80, $00, $85, $80
    .byte $88, $85, $88, $00, $84, $88, $88, $84, $04, $08, $08, $00, $00, $74, $00, $08
    .byte $75, $88, $00, $74, $88, $08, $75, $04, $08, $08, $00, $00, $E4, $00, $88, $E4
    .byte $88, $00, $E4, $88, $88, $E4, $04, $08, $08, $00, $00, $E5, $00, $88, $E5, $88
    .byte $00, $E5, $88, $88, $E5, $04, $08, $08, $00, $00, $F4, $00, $88, $F4, $88, $00
    .byte $F4, $88, $88, $F4, $04, $08, $08, $00, $00, $F5, $00, $88, $F5, $88, $00, $F5
    .byte $88, $88, $F5, $04, $08, $08, $00, $00, $E0, $00, $08, $E1, $08, $00, $F0, $08
    .byte $08, $F1, $04, $08, $08, $00, $00, $E2, $00, $08, $E3, $08, $00, $F2, $08, $08
    .byte $F3, $04, $08, $08, $00, $00, $C0, $00, $08, $C1, $08, $00, $D0, $08, $08, $D1
    .byte $04, $08, $08, $00, $00, $82, $00, $08, $83, $08, $00, $92, $08, $08, $93, $04
    .byte $08, $08, $00, $00, $80, $00, $08, $81, $08, $00, $90, $08, $08, $91, $04, $00
    .byte $00, $00, $00, $0C, $00, $88, $0C, $08, $00, $CC, $08, $08, $CD, $02, $08, $04
    .byte $04, $00, $0C, $04, $88, $0C, $04, $00, $00, $00, $00, $6E, $00, $08, $6F, $08
    .byte $00, $DD, $08, $87, $DD, $18, $28, $28, $00, $08, $4A, $00, $10, $4B, $00, $98
    .byte $4B, $00, $A0, $4A, $08, $08, $5A, $08, $10, $5B, $08, $98, $5B, $08, $A0, $5A
    .byte $10, $08, $6A, $10, $10, $6B, $10, $98, $6B, $10, $A0, $6A, $18, $08, $7A, $18
    .byte $10, $7B, $18, $98, $7B, $18, $20, $7D, $20, $08, $8A, $20, $10, $8B, $20, $98
    .byte $8B, $20, $20, $8D, $28, $08, $9A, $28, $10, $9B, $28, $18, $9C, $28, $20, $9D
    .byte $1A, $28, $28, $00, $08, $4A, $00, $10, $4B, $00, $98, $4B, $00, $A0, $4A, $08
    .byte $08, $5A, $08, $10, $5B, $08, $98, $5B, $08, $A0, $5A, $10, $08, $6A, $10, $10
    .byte $6B, $10, $98, $6B, $10, $A0, $6A, $18, $80, $6D, $18, $88, $6C, $18, $10, $7B
    .byte $18, $98, $7B, $18, $20, $6C, $18, $28, $6D, $20, $88, $7C, $20, $10, $8B, $20
    .byte $98, $8B, $20, $20, $7C, $28, $08, $9A, $28, $10, $9B, $28, $98, $9B, $28, $A0
    .byte $9A, $1A, $28, $28, $00, $08, $4A, $00, $10, $4B, $00, $98, $4B, $00, $A0, $4A
    .byte $08, $08, $5A, $08, $10, $5B, $08, $98, $5B, $08, $A0, $5A, $10, $08, $6A, $10
    .byte $10, $6B, $10, $98, $6B, $10, $A0, $6A, $18, $80, $6D, $18, $88, $6C, $18, $10
    .byte $7B, $18, $98, $7B, $18, $20, $6C, $18, $28, $6D, $20, $88, $7C, $20, $10, $8B
    .byte $20, $98, $8B, $20, $20, $7C, $28, $88, $9D, $28, $90, $9C, $28, $18, $9C, $28
    .byte $20, $9D, $06, $10, $08, $00, $00, $EB, $00, $08, $EC, $00, $10, $ED, $08, $00
    .byte $FC, $08, $08, $FD, $08, $10, $FE, $06, $08, $10, $00, $00, $A8, $00, $88, $A8
    .byte $08, $00, $B8, $08, $88, $B8, $10, $00, $C8, $10, $08, $C9, $06, $08, $10, $00
    .byte $00, $76, $00, $08, $77, $08, $00, $86, $08, $08, $87, $10, $00, $96, $10, $08
    .byte $97, $06, $08, $10, $00, $00, $76, $00, $08, $77, $08, $00, $86, $08, $08, $87
    .byte $10, $00, $A6, $10, $08, $A7, $06, $08, $10, $00, $00, $76, $00, $08, $77, $08
    .byte $00, $86, $08, $08, $87, $10, $00, $B6, $10, $08, $B7, $06, $08, $10, $00, $00
    .byte $94, $00, $08, $95, $08, $00, $A4, $08, $08, $A5, $10, $00, $B4, $10, $08, $B5
    .byte $06, $08, $10, $00, $00, $C4, $00, $08, $C5, $08, $00, $A4, $08, $08, $A5, $10
    .byte $00, $D4, $10, $08, $D5, $04, $08, $08, $00, $00, $7E, $00, $08, $7F, $08, $00
    .byte $8E, $08, $08, $8F, $04, $08, $08, $00, $00, $78, $00, $08, $79, $08, $00, $88
    .byte $08, $08, $89, $05, $08, $10, $00, $00, $A0, $00, $08, $A1, $08, $00, $B0, $08
    .byte $08, $B1, $10, $04, $EB, $04, $08, $08, $00, $00, $A2, $00, $08, $A3, $08, $00
    .byte $B2, $08, $08, $B3, $04, $08, $08, $00, $00, $C6, $00, $08, $C7, $08, $00, $D6
    .byte $08, $08, $D7, $04, $08, $08, $00, $00, $E6, $00, $08, $E7, $08, $00, $F6, $08
    .byte $08, $F7, $04, $08, $08, $00, $00, $D8, $00, $08, $D9, $08, $00, $E8, $08, $08
    .byte $E9, $04, $08, $08, $00, $00, $D8, $00, $08, $D9, $08, $00, $F8, $08, $08, $F9
    .byte $04, $08, $08, $00, $00, $EA, $00, $88, $EA, $08, $00, $FA, $08, $08, $FB, $03
    .byte $08, $08, $00, $08, $57, $08, $00, $66, $08, $08, $67, $03, $08, $08, $00, $08
    .byte $59, $08, $00, $68, $08, $08, $69, $04, $08, $08, $00, $00, $AA, $00, $08, $AB
    .byte $08, $00, $BA, $08, $08, $BB, $04, $08, $08, $00, $00, $AC, $00, $08, $AD, $08
    .byte $00, $BC, $08, $08, $BD, $04, $0A, $0A, $00, $02, $CA, $00, $0A, $CB, $08, $02
    .byte $DA, $08, $0A, $DB, $04, $0A, $0A, $00, $00, $98, $00, $08, $99, $08, $00, $B9
    .byte $08, $08, $A9, $01, $00, $00, $00, $00, $48, $01, $00, $00, $00, $00, $49, $01
    .byte $00, $00, $00, $00, $58, $06, $00, $00, $00, $00, $60, $00, $08, $61, $08, $00
    .byte $70, $08, $08, $71, $10, $00, $38, $10, $08, $DC, $04, $00, $00, $00, $00, $62
    .byte $00, $08, $63, $08, $00, $72, $08, $08, $73, $04, $00, $00, $00, $00, $4C, $00
    .byte $08, $4D, $08, $00, $5C, $08, $08, $5D, $04, $00, $00, $00, $00, $4E, $00, $08
    .byte $4F, $08, $00, $5E, $08, $08, $5F, $04, $00, $00, $00, $00, $62, $00, $08, $63
    .byte $08, $00, $72, $08, $08, $73, $04, $08, $08, $00, $00, $78, $00, $08, $79, $08
    .byte $00, $88, $08, $08, $88, $04, $08, $08, $00, $00, $78, $00, $08, $79, $08, $00
    .byte $DE, $08, $08, $DF, $04, $08, $08, $00, $00, $EC, $00, $08, $ED, $08, $00, $FC
    .byte $08, $08, $FD, $04, $08, $08, $00, $00, $EE, $00, $08, $EF, $08, $00, $FE, $08
    .byte $08, $FF, $04, $08, $08, $00, $00, $94, $00, $08, $95, $08, $00, $AE, $08, $08
    .byte $AF, $04, $08, $08, $00, $00, $A4, $00, $08, $A5, $08, $00, $BE, $08, $08, $BF
    .byte $04, $08, $08, $00, $00, $B4, $00, $08, $B5, $08, $00, $CE, $08, $08, $CF, $04
    .byte $08, $08, $00, $00, $40, $00, $08, $41, $08, $00, $64, $08, $08, $65
