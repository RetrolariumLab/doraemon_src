; Doraemon PRG bank 2 $B406-$B6B9
; World 3 HUD composition, number rendering, and presentation tables
; Generated deterministically from pinned Ghidra/GhidraNes facts

World3_RenderScoreAndLives:
    LDY #$00
    LDA #$5C
    STA World3OamX
    LDA #$18
    STA World3OamY
    LDA #$00
    STA World3OamAttributes

Bank2_Label_B414:
    LDA a:ScoreDigitsWorking,Y
    BNE Bank2_Label_B425
    LDA World3OamX
    CLC
    ADC #$08
    STA World3OamX
    INY
    CPY #$06
    BNE Bank2_Label_B414

Bank2_Label_B425:
    LDA a:ScoreDigitsWorking,Y
    AND #$0F
    ORA #$30
    STA World3OamTile
    JSR World3_AppendOamEntry
    LDA World3OamX
    CLC
    ADC #$08
    STA World3OamX
    INY
    CPY #$07
    BNE Bank2_Label_B425
    LDA #$32
    STA World3OamY
    LDA #$E6
    STA World3OamX
    LDA #$00
    STA World3OamAttributes
    LDA #$3A
    STA World3OamTile
    JSR World3_AppendOamEntry
    LDA #$F0
    STA World3OamX
    LDA PlayerLives
    AND #$0F
    ORA #$30
    STA World3OamTile
    JSR World3_AppendOamEntry
    RTS

World3_RenderHealth:
    LDA PlayerHealthCapacityIndex
    ASL A
    ASL A
    CLC
    ADC #$50
    STA World3OamY
    LDA #$EC
    STA World3OamX
    LDA #$00
    STA World3OamAttributes
    LDA #$04
    STA $0A
    LDA PlayerHealth
    STA World3OamTile
    LDY #$07

Bank2_Label_B47B:
    LDA World3OamTile
    SEC
    SBC #$04
    BCC Bank2_Label_B48E
    STA World3OamTile
    LDA #$3F
    STA a:$000A,Y
    DEY
    BPL Bank2_Label_B47B
    BMI Bank2_Label_B49F

Bank2_Label_B48E:
    CLC
    ADC #$3F
    STA a:$000A,Y
    DEY
    BMI Bank2_Label_B49F
    LDA #$3B

Bank2_Label_B499:
    STA a:$000A,Y
    DEY
    BPL Bank2_Label_B499

Bank2_Label_B49F:
    LDY PlayerHealthCapacityIndex

Bank2_Label_B4A1:
    LDA a:$000A,Y
    STA World3OamTile
    JSR World3_AppendOamEntry
    LDA World3OamY
    CLC
    ADC #$08
    STA World3OamY
    INY
    CPY #$08
    BNE Bank2_Label_B4A1
    RTS

World3_ComposeMetasprite:
    LDA World3MetaspriteRenderFlags
    AND #$40
    BEQ Bank2_Label_B4C4
    LDA FrameCounter
    LSR A
    AND #$01
    BEQ Bank2_Label_B4C4
    RTS

Bank2_Label_B4C4:
    LDA World3MetaspriteRenderFlags
    BPL Bank2_Label_B4DA
    LDA FrameCounter
    AND #$08
    BEQ Bank2_Label_B4DA
    LDA World3MetaspriteRenderFlags
    ASL A
    ASL A
    AND #$80
    ORA World3MetaspriteRenderFlags
    LSR A
    LSR A
    STA World3MetaspriteRenderFlags

Bank2_Label_B4DA:
    LDX World3MetaspriteIndex
    TXA
    ASL A
    TAY
    LDA #$00
    ADC #$B6
    STA World3MetaspriteDataPointer+$01
    LDA #$D7
    STA World3MetaspriteDataPointer
    INY
    LDA (World3MetaspriteDataPointer),Y
    CMP #$04
    BCS Bank2_Label_B532
    PHA
    DEY
    LDA (World3MetaspriteDataPointer),Y
    TAX
    ASL A
    TAY
    LDA #$00
    ADC #$B6
    STA World3MetaspriteDataPointer+$01
    LDA #$D7
    STA World3MetaspriteDataPointer
    LDA (World3MetaspriteDataPointer),Y
    PHA
    INY
    LDA (World3MetaspriteDataPointer),Y
    STA World3MetaspriteDataPointer+$01
    PLA
    STA World3MetaspriteDataPointer
    LDY #$00
    LDA (World3MetaspriteDataPointer),Y
    INY
    STA World3MetaspritePiecesRemaining
    LDA (World3MetaspriteDataPointer),Y
    INY
    STA World3MetaspriteXMirrorExtent
    LDA (World3MetaspriteDataPointer),Y
    INY
    STA World3MetaspriteYMirrorExtent
    PLA
    BEQ Bank2_Label_B529
    CMP #$02
    BEQ Bank2_Label_B52F
    BCC Bank2_Label_B52C
    JMP Bank2_Label_B654

Bank2_Label_B529:
    JMP Bank2_Label_B544

Bank2_Label_B52C:
    JMP Bank2_Label_B5F6

Bank2_Label_B52F:
    JMP Bank2_Label_B598

Bank2_Label_B532:
    PHA
    DEY
    LDA (World3MetaspriteDataPointer),Y
    STA World3MetaspriteDataPointer
    PLA
    STA World3MetaspriteDataPointer+$01
    LDY #$00
    LDA (World3MetaspriteDataPointer),Y
    INY
    STA World3MetaspritePiecesRemaining
    INY
    INY

Bank2_Label_B544:
    LDA (World3MetaspriteDataPointer),Y
    INY
    TAX
    AND #$7F
    CLC
    ADC World3MetaspriteOriginY
    STA World3OamY
    LDA World3MetaspriteOriginYHigh
    ADC #$00
    AND #$03
    BNE Bank2_Label_B590
    LDA World3OamY
    CMP #$F0
    BCS Bank2_Label_B590
    TXA
    AND #$80
    STA World3OamAttributes
    LDA (World3MetaspriteDataPointer),Y
    INY
    TAX
    AND #$7F
    CLC
    ADC World3MetaspriteOriginX
    STA World3OamX
    LDA World3MetaspriteOriginXHigh
    ADC #$00
    AND #$03
    BNE Bank2_Label_B591
    TXA
    AND #$80
    LSR A
    ORA World3OamAttributes
    STA World3OamAttributes
    LDA (World3MetaspriteDataPointer),Y
    INY
    STA World3OamTile
    LDA World3MetaspriteRenderFlags
    AND #$23
    ORA World3OamAttributes
    STA World3OamAttributes
    JSR World3_AppendOamEntry
    JMP Bank2_Label_B592

Bank2_Label_B590:
    INY

Bank2_Label_B591:
    INY

Bank2_Label_B592:
    DEC World3MetaspritePiecesRemaining
    BNE Bank2_Label_B544
    CLC
    RTS

Bank2_Label_B598:
    LDA (World3MetaspriteDataPointer),Y
    INY
    TAX
    AND #$7F
    SEC
    SBC World3MetaspriteYMirrorExtent
    EOR #$FF
    CLC
    ADC #$01
    CLC
    ADC World3MetaspriteOriginY
    STA World3OamY
    LDA World3MetaspriteOriginYHigh
    ADC #$00
    AND #$03
    BNE Bank2_Label_B5EE
    LDA World3OamY
    CMP #$F0
    BCS Bank2_Label_B5EE
    TXA
    AND #$80
    STA World3OamAttributes
    LDA (World3MetaspriteDataPointer),Y
    INY
    TAX
    AND #$7F
    CLC
    ADC World3MetaspriteOriginX
    STA World3OamX
    LDA World3MetaspriteOriginXHigh
    ADC #$00
    AND #$03
    BNE Bank2_Label_B5EF
    TXA
    AND #$80
    LSR A
    ORA World3OamAttributes
    STA World3OamAttributes
    LDA (World3MetaspriteDataPointer),Y
    INY
    STA World3OamTile
    LDA World3MetaspriteRenderFlags
    AND #$23
    ORA World3OamAttributes
    EOR #$80
    STA World3OamAttributes
    JSR World3_AppendOamEntry
    JMP Bank2_Label_B5F0

Bank2_Label_B5EE:
    INY

Bank2_Label_B5EF:
    INY

Bank2_Label_B5F0:
    DEC World3MetaspritePiecesRemaining
    BNE Bank2_Label_B598
    CLC
    RTS

Bank2_Label_B5F6:
    LDA (World3MetaspriteDataPointer),Y
    INY
    TAX
    AND #$7F
    CLC
    ADC World3MetaspriteOriginY
    STA World3OamY
    LDA World3MetaspriteOriginYHigh
    ADC #$00
    AND #$03
    BNE Bank2_Label_B64C
    LDA World3OamY
    CMP #$F0
    BCS Bank2_Label_B64C
    TXA
    AND #$80
    STA World3OamAttributes
    LDA (World3MetaspriteDataPointer),Y
    INY
    TAX
    AND #$7F
    SEC
    SBC World3MetaspriteXMirrorExtent
    EOR #$FF
    CLC
    ADC #$01
    CLC
    ADC World3MetaspriteOriginX
    STA World3OamX
    LDA World3MetaspriteOriginXHigh
    ADC #$00
    AND #$03
    BNE Bank2_Label_B64D
    TXA
    AND #$80
    LSR A
    ORA World3OamAttributes
    STA World3OamAttributes
    LDA (World3MetaspriteDataPointer),Y
    INY
    STA World3OamTile
    LDA World3MetaspriteRenderFlags
    AND #$23
    ORA World3OamAttributes
    EOR #$40
    STA World3OamAttributes
    JSR World3_AppendOamEntry
    JMP Bank2_Label_B64E

Bank2_Label_B64C:
    INY

Bank2_Label_B64D:
    INY

Bank2_Label_B64E:
    DEC World3MetaspritePiecesRemaining
    BNE Bank2_Label_B5F6
    CLC
    RTS

Bank2_Label_B654:
    LDA (World3MetaspriteDataPointer),Y
    INY
    TAX
    AND #$7F
    SEC
    SBC World3MetaspriteYMirrorExtent
    EOR #$FF
    CLC
    ADC #$01
    CLC
    ADC World3MetaspriteOriginY
    STA World3OamY
    LDA World3MetaspriteOriginYHigh
    ADC #$00
    AND #$03
    BNE Bank2_Label_B6B2
    LDA World3OamY
    CMP #$F0
    BCS Bank2_Label_B6B2
    TXA
    AND #$80
    STA World3OamAttributes
    LDA (World3MetaspriteDataPointer),Y
    INY
    TAX
    AND #$7F
    SEC
    SBC World3MetaspriteXMirrorExtent
    EOR #$FF
    CLC
    ADC #$01
    CLC
    ADC World3MetaspriteOriginX
    STA World3OamX
    LDA World3MetaspriteOriginXHigh
    ADC #$00
    AND #$03
    BNE Bank2_Label_B6B3
    TXA
    AND #$80
    LSR A
    ORA World3OamAttributes
    STA World3OamAttributes
    LDA (World3MetaspriteDataPointer),Y
    INY
    STA World3OamTile
    LDA World3MetaspriteRenderFlags
    AND #$23
    ORA World3OamAttributes
    EOR #$C0
    STA World3OamAttributes
    JSR World3_AppendOamEntry
    JMP Bank2_Label_B6B4

Bank2_Label_B6B2:
    INY

Bank2_Label_B6B3:
    INY

Bank2_Label_B6B4:
    DEC World3MetaspritePiecesRemaining
    BNE Bank2_Label_B654
    CLC
    RTS
