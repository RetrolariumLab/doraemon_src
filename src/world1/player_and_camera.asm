; Doraemon PRG bank 0 $856C-$888E
; World 1 player state, directional movement, and camera-relative positioning
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank0_Func_856C:
    JSR Bank0_Func_9BFC
    LDA $79
    BEQ Bank0_Label_85B2
    BPL Bank0_Label_8576
    RTS

Bank0_Label_8576:
    LDA #$40
    STA $78
    LDA FrameCounter
    AND #$03
    BNE Bank0_Label_8582
    INC $79

Bank0_Label_8582:
    LDA $79
    CMP #$06
    BCS Bank0_Label_8599
    LDA FrameCounter
    LSR A
    LSR A
    AND #$01
    ORA #$10
    STA $77
    LDA #$00
    STA $78
    JMP Bank0_Label_85CD

Bank0_Label_8599:
    CMP #$16
    BCC Bank0_Label_85A1
    LDA #$00
    STA $79

Bank0_Label_85A1:
    LDA $77
    AND #$03
    STA $00
    LDA $7F
    ASL A
    ASL A
    ORA $00
    STA $77
    JMP Bank0_Label_85B6

Bank0_Label_85B2:
    LDA #$00
    STA $78

Bank0_Label_85B6:
    LDA $63
    BEQ Bank0_Label_85CD
    CMP #$03
    BCS Bank0_Label_85C7
    LDA $77
    AND #$0C
    STA $77
    JMP Bank0_Label_85CD

Bank0_Label_85C7:
    LDA $77
    ORA #$01
    STA $77

Bank0_Label_85CD:
    LDA $77
    STA $01
    LDA $75
    STA $06
    LDA $76
    STA $07
    LDY CombinedControllerButtons
    TYA
    AND #$08
    BNE Bank0_Label_860D
    TYA
    AND #$04
    BNE Bank0_Label_863B
    TYA
    AND #$02
    BNE Bank0_Label_8669
    TYA
    AND #$01
    BNE Bank0_Label_860A
    LDA $79
    BEQ Bank0_Label_85F7
    CMP #$06
    BCC Bank0_Label_8609

Bank0_Label_85F7:
    INC $7A
    LDA $7A
    CMP #$05
    BCC Bank0_Label_8609
    LDA #$00
    STA $7A
    LDA $77
    AND #$0C
    STA $77

Bank0_Label_8609:
    RTS

Bank0_Label_860A:
    JMP Bank0_Label_8690

Bank0_Label_860D:
    LDA #$01
    STA $7F
    DEC $76
    DEC $76
    LDA $76
    CMP #$28
    BCS Bank0_Label_861F
    LDA #$28
    STA $76

Bank0_Label_861F:
    LDA #$05
    STA $01
    LDX #$00
    LDY #$14
    JSR Bank0_Func_86F8
    LDX #$07
    LDY #$14
    JSR Bank0_Func_86F8
    LDX #$0E
    LDY #$14
    JSR Bank0_Func_86F8
    JMP Bank0_Label_86B7

Bank0_Label_863B:
    LDA #$00
    STA $7F
    INC $76
    INC $76
    LDA $76
    CMP #$C9
    BCC Bank0_Label_864D
    LDA #$C8
    STA $76

Bank0_Label_864D:
    LDA #$01
    STA $01
    LDX #$00
    LDY #$18
    JSR Bank0_Func_86F8
    LDX #$07
    LDY #$18
    JSR Bank0_Func_86F8
    LDX #$0E
    LDY #$18
    JSR Bank0_Func_86F8
    JMP Bank0_Label_86B7

Bank0_Label_8669:
    LDA #$02
    STA $7F
    DEC $75
    DEC $75
    LDA $75
    CMP #$05
    BCS Bank0_Label_867B
    LDA #$05
    STA $75

Bank0_Label_867B:
    LDA #$09
    STA $01
    LDX #$00
    LDY #$18
    JSR Bank0_Func_86F8
    LDX #$00
    LDY #$14
    JSR Bank0_Func_86F8
    JMP Bank0_Label_86B7

Bank0_Label_8690:
    LDA #$03
    STA $7F
    INC $75
    INC $75
    LDA $75
    CMP #$EC
    BCC Bank0_Label_86A2
    LDA #$EB
    STA $75

Bank0_Label_86A2:
    LDA #$0D
    STA $01
    LDX #$0E
    LDY #$18
    JSR Bank0_Func_86F8
    LDX #$0E
    LDY #$14
    JSR Bank0_Func_86F8
    JMP Bank0_Label_86B7

Bank0_Label_86B7:
    LDA $79
    BEQ Bank0_Label_86BF
    CMP #$06
    BCC Bank0_Label_86F7

Bank0_Label_86BF:
    LDA $77
    AND #$0C
    STA $00
    LDA $01
    AND #$0C
    CMP $00
    BEQ Bank0_Label_86D7
    LDA $01
    STA $77
    LDA #$00
    STA $7A
    STA $63

Bank0_Label_86D7:
    LDA $63
    BNE Bank0_Label_86F7
    INC $7A
    LDA $7A
    CMP #$05
    BCC Bank0_Label_86F7
    LDA #$00
    STA $7A
    LDA $77
    AND #$0C
    STA $00
    INC $77
    LDA $77
    AND #$03
    ORA $00
    STA $77

Bank0_Label_86F7:
    RTS

Bank0_Func_86F8:
    JSR Bank0_Func_D1C3
    BCC Bank0_Label_8705
    LDA $06
    STA $75
    LDA $07
    STA $76

Bank0_Label_8705:
    RTS

Bank0_Func_8706:
    LDA #$00
    STA $61
    STA $62
    LDA $75
    CMP #$50
    BCS Bank0_Label_871B
    JSR Bank0_Func_A3E1
    JSR Bank0_Func_A3E1
    JMP Bank0_Label_8725

Bank0_Label_871B:
    CMP #$A0
    BCC Bank0_Label_8725
    JSR Bank0_Func_A381
    JSR Bank0_Func_A381

Bank0_Label_8725:
    LDA $76
    CMP #$48
    BCS Bank0_Label_8734
    JSR Bank0_Func_A484
    JSR Bank0_Func_A484
    JMP Bank0_Label_873E

Bank0_Label_8734:
    CMP #$90
    BCC Bank0_Label_873E
    JSR Bank0_Func_A42F
    JSR Bank0_Func_A42F

Bank0_Label_873E:
    LDA $75
    CLC
    ADC $61
    STA $75
    LDA $76
    CLC
    ADC $62
    STA $76
    JSR Bank0_Func_8750
    RTS

Bank0_Func_8750:
    LDY #$2F
    LDA $61
    BEQ Bank0_Label_87A2
    BMI Bank0_Label_877E

Bank0_Label_8758:
    LDA a:World1EntityType,Y
    BEQ Bank0_Label_8779
    LDA a:World1EntityX,Y
    CLC
    ADC $61
    STA a:World1EntityX,Y
    BCC Bank0_Label_8779
    LDA a:World1EntityPositionHigh,Y
    TAX
    AND #$FC
    STA $00
    INX
    TXA
    AND #$03
    ORA $00
    STA a:World1EntityPositionHigh,Y

Bank0_Label_8779:
    DEY
    BPL Bank0_Label_8758
    BMI Bank0_Label_87A2

Bank0_Label_877E:
    LDA a:World1EntityType,Y
    BEQ Bank0_Label_879F
    LDA a:World1EntityX,Y
    CLC
    ADC $61
    STA a:World1EntityX,Y
    BCS Bank0_Label_879F
    LDA a:World1EntityPositionHigh,Y
    TAX
    AND #$FC
    STA $00
    DEX
    TXA
    AND #$03
    ORA $00
    STA a:World1EntityPositionHigh,Y

Bank0_Label_879F:
    DEY
    BPL Bank0_Label_877E

Bank0_Label_87A2:
    LDY #$2F
    LDA $62
    BEQ Bank0_Func_87F8
    BMI Bank0_Label_87D2

Bank0_Label_87AA:
    LDA a:World1EntityType,Y
    BEQ Bank0_Label_87CD
    LDA a:World1EntityY,Y
    CLC
    ADC $62
    STA a:World1EntityY,Y
    BCC Bank0_Label_87CD
    LDA a:World1EntityPositionHigh,Y
    TAX
    AND #$F3
    STA $00
    TXA
    CLC
    ADC #$04
    AND #$0C
    ORA $00
    STA a:World1EntityPositionHigh,Y

Bank0_Label_87CD:
    DEY
    BPL Bank0_Label_87AA
    BMI Bank0_Func_87F8

Bank0_Label_87D2:
    LDA a:World1EntityType,Y
    BEQ Bank0_Label_87F5
    LDA a:World1EntityY,Y
    CLC
    ADC $62
    STA a:World1EntityY,Y
    BCS Bank0_Label_87F5
    LDA a:World1EntityPositionHigh,Y
    TAX
    AND #$F3
    STA $00
    TXA
    SEC
    SBC #$04
    AND #$0C
    ORA $00
    STA a:World1EntityPositionHigh,Y

Bank0_Label_87F5:
    DEY
    BPL Bank0_Label_87D2

Bank0_Func_87F8:
    LDY #$2F

Bank0_Label_87FA:
    LDA a:World1EntityType,Y
    BEQ Bank0_Label_8848
    LDA a:World1EntityPositionHigh,Y
    AND #$03
    BEQ Bank0_Label_881C
    CMP #$02
    BEQ Bank0_Label_8839
    BCC Bank0_Label_8815
    LDA a:World1EntityX,Y
    CMP #$C0
    BCC Bank0_Label_8839
    BCS Bank0_Label_881C

Bank0_Label_8815:
    LDA a:World1EntityX,Y
    CMP #$40
    BCS Bank0_Label_8839

Bank0_Label_881C:
    LDA a:World1EntityPositionHigh,Y
    AND #$0C
    BEQ Bank0_Label_8848
    CMP #$08
    BEQ Bank0_Label_8839
    BCC Bank0_Label_8832
    LDA a:World1EntityY,Y
    CMP #$C0
    BCC Bank0_Label_8839
    BCS Bank0_Label_8848

Bank0_Label_8832:
    LDA a:World1EntityY,Y
    CMP #$20
    BCC Bank0_Label_8848

Bank0_Label_8839:
    LDA #$00
    STA a:World1EntityType,Y
    LDA a:World1EntitySourceObjectId,Y
    BMI Bank0_Label_8848
    AND #$7F
    JSR World1_ReleaseObjectSpawn

Bank0_Label_8848:
    DEY
    BPL Bank0_Label_87FA
    RTS

Bank0_Func_884C:
    JSR World1_ClearEntitySlots10_29
    JSR World1_ClearEntitySlots30_37
    LDA #$00
    STA a:AudioMusicState
    LDA #$00
    STA $78
    LDA #$78
    STA $97

Bank0_Label_885F:
    LDA $97
    LSR A
    LSR A
    LSR A
    AND #$01
    ORA #$10
    STA $77
    JSR Bank0_Func_94F1
    LDA $97
    CMP #$3C
    BNE Bank0_Label_8878
    LDA #$07
    STA a:AudioMusicState

Bank0_Label_8878:
    DEC $97
    BNE Bank0_Label_885F
    LDA #$78
    STA $97

Bank0_Label_8880:
    JSR Bank0_Func_94F1
    DEC $97
    BNE Bank0_Label_8880
    LDA DemoModeActive
    BEQ Bank0_Label_888E
    JMP Bank0_Func_8048

Bank0_Label_888E:
    RTS
