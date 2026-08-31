; Doraemon PRG bank 0 $A381-$A509
; World 1 scroll advancement and nametable edge selection
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank0_Func_A381:
    LDA $5B
    CMP #$E0
    BNE Bank0_Label_A38E
    LDA PpuScrollXShadow
    AND #$07
    BNE Bank0_Label_A38E
    RTS

Bank0_Label_A38E:
    DEC $61
    INC PpuScrollXShadow
    BNE Bank0_Label_A39A
    LDA $58
    EOR #$01
    STA $58

Bank0_Label_A39A:
    LDA PpuScrollXShadow
    AND #$07
    BEQ Bank0_Label_A3A1
    RTS

Bank0_Label_A3A1:
    INC $5B
    LDA $5B
    CLC
    ADC #$20
    TAX
    LDY $5C
    LDA PpuScrollYShadow
    AND #$07
    CMP #$04
    BCC Bank0_Label_A3B4
    INY

Bank0_Label_A3B4:
    LDA $58
    EOR #$01
    AND #$01
    JSR Bank0_Func_A4C6
    LDA PpuScrollXShadow
    AND #$0F
    BNE Bank0_Label_A3D4
    LDY $5C
    LDA $5B
    CLC
    ADC #$20
    TAX
    LDA $58
    AND #$01
    EOR #$01
    JSR Bank0_Func_A50A

Bank0_Label_A3D4:
    LDA a:$025F
    ASL A
    ASL A
    ASL A
    ASL A
    ORA #$01
    STA a:$025F
    RTS

Bank0_Func_A3E1:
    LDA $5B
    BNE Bank0_Label_A3EC
    LDA PpuScrollXShadow
    AND #$07
    BNE Bank0_Label_A3EC
    RTS

Bank0_Label_A3EC:
    INC $61
    LDA PpuScrollXShadow
    BNE Bank0_Label_A3F8
    LDA $58
    EOR #$01
    STA $58

Bank0_Label_A3F8:
    DEC PpuScrollXShadow
    LDA PpuScrollXShadow
    AND #$07
    CMP #$07
    BEQ Bank0_Label_A403
    RTS

Bank0_Label_A403:
    DEC $5B
    LDX $5B
    LDY $5C
    LDA PpuScrollYShadow
    AND #$07
    CMP #$04
    BCC Bank0_Label_A412
    INY

Bank0_Label_A412:
    LDA $58
    AND #$01
    JSR Bank0_Func_A4C6
    LDA PpuScrollXShadow
    AND #$0F
    CMP #$0F
    BNE Bank0_Label_A3D4
    LDY $5C
    LDX $5B
    LDA $58
    AND #$01
    JSR Bank0_Func_A50A
    JMP Bank0_Label_A3D4

Bank0_Func_A42F:
    LDA $5C
    CMP #$E2
    BNE Bank0_Label_A43C
    LDA PpuScrollYShadow
    AND #$07
    BNE Bank0_Label_A43C

Bank0_Label_A43B:
    RTS

Bank0_Label_A43C:
    DEC $62
    INC PpuScrollYShadow
    LDA PpuScrollYShadow
    CMP #$F0
    BCC Bank0_Label_A44B
    CLC
    ADC #$10
    STA PpuScrollYShadow

Bank0_Label_A44B:
    AND #$07
    BNE Bank0_Label_A451
    INC $5C

Bank0_Label_A451:
    CMP #$04
    BNE Bank0_Label_A463
    LDX $5B
    LDA $5C
    CLC
    ADC #$1E
    TAY
    JSR Bank0_Func_A5CF
    JMP Bank0_Label_A476

Bank0_Label_A463:
    LDA PpuScrollYShadow
    AND #$0F
    CMP #$08
    BNE Bank0_Label_A43B
    LDX $5B
    LDA $5C
    CLC
    ADC #$1E
    TAY
    JSR Bank0_Func_A60B

Bank0_Label_A476:
    LDA a:$025F
    ASL A
    ASL A
    ASL A
    ASL A
    ORA #$02
    STA a:$025F
    RTS
    .byte $60

Bank0_Func_A484:
    LDA $5C
    BNE Bank0_Label_A48F
    LDA PpuScrollYShadow
    AND #$07
    BNE Bank0_Label_A48F

Bank0_Label_A48E:
    RTS

Bank0_Label_A48F:
    INC $62
    DEC PpuScrollYShadow
    LDA PpuScrollYShadow
    CMP #$F0
    BCC Bank0_Label_A49E
    SEC
    SBC #$10
    STA PpuScrollYShadow

Bank0_Label_A49E:
    AND #$07
    CMP #$07
    BNE Bank0_Label_A4A6
    DEC $5C

Bank0_Label_A4A6:
    CMP #$03
    BNE Bank0_Label_A4B4
    LDX $5B
    LDY $5C
    JSR Bank0_Func_A5CF
    JMP Bank0_Label_A476

Bank0_Label_A4B4:
    LDA PpuScrollYShadow
    AND #$0F
    CMP #$07
    BNE Bank0_Label_A48E
    LDX $5B
    LDY $5C
    JSR Bank0_Func_A60B
    JMP Bank0_Label_A476

Bank0_Func_A4C6:
    PHA
    JSR Bank0_Func_A6A7
    LDX #$00

Bank0_Label_A4CC:
    JSR Bank0_Func_A719
    STA a:$0233,X
    INX
    CPX #$1E
    BNE Bank0_Label_A4CC
    LDA PpuScrollYShadow
    CLC
    ADC #$04
    CMP #$F0
    BCC Bank0_Label_A4E3
    CLC
    ADC #$10

Bank0_Label_A4E3:
    AND #$F8
    STA a:$0231
    PLA
    ASL a:$0231
    ROL A
    ASL a:$0231
    ROL A
    ORA #$20
    STA a:$0232
    LDA PpuScrollXShadow
    LSR A
    LSR A
    LSR A
    ORA a:$0231
    STA a:$0231
    LDA a:$0230
    ORA #$01
    STA a:$0230
    RTS
