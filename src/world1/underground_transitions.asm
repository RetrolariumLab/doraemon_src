; Doraemon PRG bank 0 $D3A9-$D76F
; World 1 underground room changes, completion paths, and entity updates
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank0_Func_D3A9:
    LDX #$00

Bank0_Label_D3AB:
    LDA a:$0680,X
    STA a:$0690,X
    LDA a:$06A0,X
    STA a:$0680,X
    INX
    CPX #$10
    BNE Bank0_Label_D3AB
    JMP Bank0_Label_D3CB

Bank0_Label_D3BF:
    JSR Bank0_Func_83E8
    LDA #$01
    STA $51
    LDA #$06
    JMP Bank0_Func_D2C3

Bank0_Label_D3CB:
    LDA #$00
    STA $79
    LDA #$01
    STA $51
    LDA #$78
    STA $75
    LDA #$B0
    STA $76
    LDA #$00
    STA $5B
    LDA #$22
    STA $5C
    LDA #$22
    STA $88
    LDA #$22
    STA $89
    LDA #$00
    STA $8A
    STA $7C
    STA $7D
    STA $7E
    STA $9B
    STA a:AudioMusicControl
    STA $82
    STA $83
    STA $B2
    JSR Bank0_Func_9614
    LDA #$EF
    STA $66
    LDA #$C2
    STA $67
    LDA #$25
    STA $68
    LDA #$D9
    STA $69
    LDA #$02
    STA $29
    JSR Bank0_Func_83BD
    JSR Bank0_Func_A7DB
    JSR Bank0_Func_9535
    JSR Bank0_Func_843B
    JSR Bank0_Func_95ED
    LDX #$7F
    TXS

Bank0_Label_D429:
    JSR Bank0_Func_94F1
    JSR Bank0_Func_8490
    JSR Bank0_Func_95CB
    JSR Bank0_Func_9B54
    JSR Bank0_Func_CF7A
    JSR Bank0_Func_CA6D
    JSR Bank0_Func_9201
    JSR Bank0_Func_D47C
    JSR Bank0_Func_8BDE
    JSR Bank0_Func_888F
    JSR Bank0_Func_8EF6
    JSR Bank0_Func_931B
    JSR Bank0_Func_87F8
    JSR Bank0_Func_820E
    LDA PpuScrollYShadow
    AND #$07
    ORA $5C
    BEQ Bank0_Label_D462
    LDA $79
    BMI Bank0_Func_D465
    JMP Bank0_Label_D429

Bank0_Label_D462:
    JMP Bank0_Func_D4EE

Bank0_Func_D465:
    JSR Bank0_Func_884C
    DEC $2A
    BMI Bank0_Label_D46F
    JMP Bank0_Label_D3BF

Bank0_Label_D46F:
    JSR Bank0_Func_8065
    LDA #$02
    STA $2A
    JSR Bank0_Func_C92F
    JMP Bank0_Label_D3BF

Bank0_Func_D47C:
    LDA #$00
    STA $61
    STA $62
    LDA $76
    SEC
    SBC #$6E
    BCS Bank0_Label_D4B6
    EOR #$FF
    SEC
    ADC #$00
    STA $8C
    CMP #$07
    BCC Bank0_Label_D498
    LDA #$06
    STA $8C

Bank0_Label_D498:
    LDA $89
    ORA $8A
    BEQ Bank0_Label_D4E3
    LDA $8A
    SEC
    SBC #$01
    AND #$07
    STA $8A
    CMP #$07
    BNE Bank0_Label_D4AD
    DEC $89

Bank0_Label_D4AD:
    JSR Bank0_Func_A484
    DEC $8C
    BNE Bank0_Label_D498
    BEQ Bank0_Label_D4E3

Bank0_Label_D4B6:
    LDA $76
    SEC
    SBC #$92
    BCC Bank0_Label_D4E3
    STA $8C
    CMP #$06
    BCC Bank0_Label_D4C7
    LDA #$05
    STA $8C

Bank0_Label_D4C7:
    INC $8C

Bank0_Label_D4C9:
    LDA $89
    CMP $88
    BEQ Bank0_Label_D4E3
    LDA $8A
    CLC
    ADC #$01
    AND #$07
    STA $8A
    BNE Bank0_Label_D4DC
    INC $89

Bank0_Label_D4DC:
    JSR Bank0_Func_A42F
    DEC $8C
    BNE Bank0_Label_D4C9

Bank0_Label_D4E3:
    LDA $76
    CLC
    ADC $62
    STA $76
    JSR Bank0_Func_8750
    RTS

Bank0_Func_D4EE:
    JSR World1_ClearEntitySlots10_29
    LDA #$06
    STA a:AudioMusicState
    LDA #$00
    STA a:AudioMusicControl
    STA $82
    STA $83
    STA $B2
    LDA #$01
    STA $9B
    JSR World1_ClearEntitySlots10_29
    JSR World1_ClearEntitySlots00_09
    JSR Bank0_Func_C96A
    LDA #$00
    STA a:World1EntityType
    LDA #$3A
    STA a:World1EntityMetasprite
    LDA #$00
    STA a:World1EntityPositionHigh
    LDA #$32
    STA a:World1EntityX
    LDA #$70
    STA a:World1EntityY
    LDA #$01
    STA a:World1EntityRenderFlags
    LDA #$FF
    STA a:$0520
    LDA #$00
    STA a:$0550
    LDA #$00
    STA a:$0580
    LDA #$18
    STA a:$05B0
    LDA #$00
    STA a:$05E0
    LDA #$07
    STA $9C
    LDA #$00
    STA $9E

Bank0_Label_D54D:
    JSR Bank0_Func_94F1
    LDA #$00
    STA a:World1EntityType
    LDA $9E
    AND $9C
    BNE Bank0_Label_D560
    LDA #$0F
    STA a:World1EntityType

Bank0_Label_D560:
    JSR Bank0_Func_8490
    JSR Bank0_Func_95CB
    JSR Bank0_Func_9B54
    JSR Bank0_Func_CF7A
    JSR Bank0_Func_CA6D
    JSR Bank0_Func_9201
    JSR Bank0_Func_888F
    JSR Bank0_Func_8EF6
    JSR Bank0_Func_931B
    JSR Bank0_Func_87F8
    JSR Bank0_Func_820E
    LDA $79
    BMI Bank0_Label_D594
    DEC $9E
    BEQ Bank0_Label_D598
    LDA $9E
    AND #$3F
    BNE Bank0_Label_D54D
    LSR $9C
    JMP Bank0_Label_D54D

Bank0_Label_D594:
    JMP Bank0_Func_D465
    .byte $60

Bank0_Label_D598:
    LDA #$0E
    STA a:World1EntityType
    LDA #$00
    STA $9D
    STA $98
    LDA #$38
    STA a:World1EntityMetasprite
    JSR Bank0_Func_964A
    AND #$3F
    CLC
    ADC #$20
    STA $9F

Bank0_Label_D5B2:
    JSR Bank0_Func_94F1
    JSR Bank0_Func_8490
    JSR Bank0_Func_95CB
    JSR Bank0_Func_9B54
    JSR Bank0_Func_CF7A
    JSR Bank0_Func_CA6D
    JSR Bank0_Func_888F
    JSR Bank0_Func_9201
    JSR Bank0_Func_8EF6
    JSR Bank0_Func_931B
    JSR Bank0_Func_87F8
    JSR Bank0_Func_820E
    JSR Bank0_Func_D67A
    LDA a:World1EntityType
    BEQ Bank0_Label_D5E5
    LDA $79
    BMI Bank0_Label_D594
    JMP Bank0_Label_D5B2

Bank0_Label_D5E5:
    LDA #$00
    STA a:AudioMusicState
    LDA #$04
    JSR World1_Audio_QueueEffect
    LDA #$00
    STA $26
    LDA #$0F
    STA a:World1EntityType
    LDA #$00
    STA a:World1EntityPositionHigh
    LDA #$A0
    STA $9C

Bank0_Label_D601:
    JSR Bank0_Func_94F1
    JSR Bank0_Func_8490
    JSR Bank0_Func_CF7A
    LDA FrameCounter
    AND #$03
    BNE Bank0_Label_D619
    LDA $9C
    CMP #$14
    BCC Bank0_Label_D619
    JSR Bank0_Func_D770

Bank0_Label_D619:
    JSR Bank0_Func_9B54
    DEC $9C
    BNE Bank0_Label_D601
    JSR World1_ClearEntitySlots30_37
    JSR World1_ClearEntitySlots10_29
    LDA #$0F
    STA a:World1EntityType
    LDA #$00
    STA a:World1EntityPositionHigh
    LDA #$36
    STA a:World1EntityMetasprite
    LDA #$01
    STA a:World1EntityRenderFlags
    LDA #$80
    STA a:World1EntityX
    LDA #$88
    STA a:World1EntityY
    LDA #$00
    STA $79
    LDA #$12
    STA $77
    LDA #$00
    STA $78
    LDA #$70
    STA $75
    LDA #$86
    STA $76
    LDA #$08
    STA a:AudioMusicState

Bank0_Label_D65D:
    JSR Bank0_Func_94F1
    JSR Bank0_Func_8490
    JSR Bank0_Func_9B54
    LDA FrameCounter
    LSR A
    LSR A
    LSR A
    LSR A
    AND #$01
    ORA #$12
    STA $77
    LDA a:AudioMusicState
    BNE Bank0_Label_D65D
    JMP Bank0_Func_8082

Bank0_Func_D67A:
    LDA a:World1EntityRenderFlags
    AND #$8F
    STA a:World1EntityRenderFlags
    LDA a:World1EntityType
    BPL Bank0_Label_D68C
    LDA #$11
    JSR World1_Audio_QueueEffectWithPriority

Bank0_Label_D68C:
    LDA a:$0550
    BEQ Bank0_Label_D6D4
    LDA $9D
    CMP #$18
    BEQ Bank0_Label_D6BD
    AND #$80
    STA $00
    LDA $9D
    LSR A
    ORA $00
    LSR A
    ORA $00
    CLC
    ADC a:World1EntityY
    STA a:World1EntityY
    LDA #$3B
    STA a:World1EntityMetasprite
    LDA $9D
    BMI Bank0_Label_D6B8
    LDA #$3A
    STA a:World1EntityMetasprite

Bank0_Label_D6B8:
    INC $9D
    JMP Bank0_Label_D718

Bank0_Label_D6BD:
    LDA #$00
    STA a:$0550
    LDA #$38
    STA a:World1EntityMetasprite
    JSR Bank0_Func_964A
    AND #$3F
    CLC
    ADC #$40
    STA $9F
    JMP Bank0_Label_D718

Bank0_Label_D6D4:
    LDA FrameCounter
    LSR A
    LSR A
    LSR A
    AND #$01
    ORA #$38
    STA a:World1EntityMetasprite
    LDA a:$0580
    BEQ Bank0_Label_D6F7
    INC a:World1EntityX
    LDA a:World1EntityX
    CMP #$70
    BCC Bank0_Label_D706
    LDA #$00
    STA a:$0580
    JMP Bank0_Label_D706

Bank0_Label_D6F7:
    DEC a:World1EntityX
    LDA a:World1EntityX
    CMP #$08
    BCS Bank0_Label_D706
    LDA #$01
    STA a:$0580

Bank0_Label_D706:
    DEC $9F
    BPL Bank0_Label_D718
    LDA #$01
    STA a:$0550
    LDA #$EC
    STA $9D
    LDA #$3A
    STA a:World1EntityMetasprite

Bank0_Label_D718:
    LDY #$00

Bank0_Label_D71A:
    LDA a:World1EntityType+$0A,Y
    BEQ Bank0_Label_D725
    INY
    CPY #$04
    BNE Bank0_Label_D71A
    RTS

Bank0_Label_D725:
    LDA #$02
    STA a:World1EntityType+$0A,Y
    LDA #$32
    STA a:World1EntityMetasprite+$0A,Y
    LDA a:World1EntityPositionHigh
    STA a:World1EntityPositionHigh+$0A,Y
    LDA a:World1EntityX
    CLC
    ADC #$14
    STA a:World1EntityX+$0A,Y
    LDA a:World1EntityY
    STA a:World1EntityY+$0A,Y
    LDA #$01
    STA a:World1EntityRenderFlags+$0A,Y
    LDA #$FF
    STA a:$052A,Y
    JSR Bank0_Func_962F
    AND #$03
    CLC
    ADC #$01
    STA a:$055A,Y
    JSR Bank0_Func_962F
    AND #$07
    TAX
    LDA a:$9126,X
    STA a:$05BA,Y
    LDA #$00
    STA a:$05EA,Y
    LDA #$02
    STA a:$058A,Y
    RTS
