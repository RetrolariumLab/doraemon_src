; Doraemon PRG bank 2 $A8B0-$AB3A
; World 3 room updates and early entity collision adjustment
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank2_Func_A8B0:
    LDX #$00
    STX $02

Bank2_Label_A8B4:
    LDA a:$0480,X
    CMP a:$0705,X
    BEQ Bank2_Label_A8D3
    INC $02
    CMP #$0F
    BNE Bank2_Label_A8CA
    LDA a:$0705,X
    AND #$0F
    JMP Bank2_Label_A8D0

Bank2_Label_A8CA:
    LDA a:$0480,X
    CLC
    ADC #$10

Bank2_Label_A8D0:
    STA a:$0480,X

Bank2_Label_A8D3:
    INX
    CPX #$20
    BNE Bank2_Label_A8B4
    LDX #$80
    LDY #$04
    JSR Bank2_Func_B2A3
    LDA #$03
    STA $68
    JSR Bank2_Func_B1BB
    LDA $02
    BNE Bank2_Func_A8B0
    RTS

Bank2_Func_A8EB:
    JSR Bank2_Func_A904
    LDA #$00
    STA $88
    STA $86
    STA $87
    LDA #$1E
    STA $07

Bank2_Label_A8FA:
    JSR Bank2_Func_A922
    INC $88
    DEC $07
    BNE Bank2_Label_A8FA
    RTS

Bank2_Func_A904:
    LDA $DF
    AND #$F8
    LSR A
    LSR A
    CLC
    ADC #$E6
    STA $85
    LDA $DF
    AND #$07
    ASL A
    ASL A
    ASL A
    CLC
    ADC #$F2
    STA $84
    LDA $85
    ADC #$00
    STA $85
    RTS

Bank2_Func_A922:
    JSR Bank2_Func_A946
    LDX #$00
    LDY $88
    JSR Bank2_Func_B0BA
    LDX #$A0
    LDY #$04
    LDA #$20
    JSR Bank2_Func_B33A
    LDX #$00
    LDY $88
    JSR Bank2_Func_B0F8
    LDX #$C0
    LDY #$04
    LDA #$08
    JSR Bank2_Func_B33A
    RTS

Bank2_Func_A946:
    JSR Bank2_Func_A967
    LDA $87
    EOR #$02
    STA $87
    BNE Bank2_Label_A966
    LDA $86
    EOR #$02
    STA $86
    BNE Bank2_Label_A966
    LDA $84
    CLC
    ADC #$40
    STA $84
    LDA $85
    ADC #$00
    STA $85

Bank2_Label_A966:
    RTS

Bank2_Func_A967:
    LDX #$00
    STX $01

Bank2_Label_A96B:
    LDA #$00
    STA $03
    LDY $01
    LDA ($84),Y
    ASL A
    ROL $03
    ASL A
    ROL $03
    CLC
    ADC #$F2
    STA $02
    LDA $03
    ADC #$E2
    STA $03
    LDA $86
    STA $00
    JSR Bank2_Func_A99C
    INC $00
    JSR Bank2_Func_A99C
    JSR Bank2_Func_A9C5
    INC $01
    LDA $01
    CMP #$08
    BNE Bank2_Label_A96B
    RTS

Bank2_Func_A99C:
    LDA #$00
    STA $05
    LDY $00
    LDA ($02),Y
    ASL A
    ROL $05
    ASL A
    ROL $05
    CLC
    ADC #$F2
    STA $04
    LDA $05
    ADC #$DE
    STA $05
    LDY $87
    LDA ($04),Y
    STA a:$04A0,X
    INX
    INY
    LDA ($04),Y
    STA a:$04A0,X
    INX
    RTS

Bank2_Func_A9C5:
    STX $3E
    LDY $00
    LDA ($02),Y
    TAX
    LDA a:$DDF2,X
    ASL A
    ASL A
    STA $3C
    DEY
    LDA ($02),Y
    TAX
    LDA a:$DDF2,X
    ORA $3C
    STA $3C
    ASL A
    ASL A
    ASL A
    ASL A
    STA $3D
    LDA $88
    AND #$FC
    ASL A
    CLC
    ADC $01
    TAY
    LDA $88
    AND #$02
    BNE Bank2_Label_A9FD
    LDA a:$0400,Y
    AND #$F0
    ORA $3C
    JMP Bank2_Label_AA04

Bank2_Label_A9FD:
    LDA a:$0400,Y
    AND #$0F
    ORA $3D

Bank2_Label_AA04:
    STA a:$0400,Y
    LDY $01
    STA a:$04C0,Y
    LDX $3E
    RTS

Bank2_Func_AA0F:
    PHA
    AND #$0F
    STA $AA
    PLA
    CLC
    ADC #$10
    STA $A9
    LSR A
    LSR A
    LSR A
    LSR A
    CMP $AA
    BNE Bank2_Label_AA26
    LDA $AA
    SEC
    RTS

Bank2_Label_AA26:
    LDA $A9
    CLC
    RTS

Bank2_Func_AA2A:
    LDA $8C
    STA $00
    LDA $8D
    STA $01
    LDA #$00
    STA $04
    STX $02
    LDA a:$0620,X
    SEC
    SBC $02
    STA $03
    LDA #$68
    STA $A2
    LDA $02
    CMP #$01
    BEQ Bank2_Label_AA4E
    LDA #$80
    STA $A2

Bank2_Label_AA4E:
    JSR Bank2_Func_AA52
    RTS

Bank2_Func_AA52:
    LDY #$F2
    LDA a:World3EntityX,X
    CMP $00
    BCS Bank2_Label_AA5D
    LDY #$0E

Bank2_Label_AA5D:
    TYA
    CLC
    ADC $00
    STA $08
    LDY #$F2
    LDA a:World3EntityY,X
    CMP $01
    BCS Bank2_Label_AA6E
    LDY #$0E

Bank2_Label_AA6E:
    TYA
    CLC
    ADC $01
    STA $09
    JSR Bank2_Func_AAAA
    INC $02
    DEC $03
    DEC $03

Bank2_Label_AA7D:
    JSR Bank2_Func_AA9E
    INC $02
    DEC $03
    BNE Bank2_Label_AA7D
    LDX $02
    LDA a:World3EntityState+$07,X
    STA $08
    LDA a:World3EntityX+$07,X
    STA $09
    LDA #$80
    STA $3E
    LDA $A2
    STA $3F
    JSR Bank2_Func_AAB6
    RTS

Bank2_Func_AA9E:
    LDX $02
    LDA a:World3EntityState+$07,X
    STA $08
    LDA a:World3EntityX+$07,X
    STA $09

Bank2_Func_AAAA:
    LDX $02
    LDA a:World3EntityX+$01,X
    STA $3E
    LDA a:World3EntityY+$01,X
    STA $3F

Bank2_Func_AAB6:
    LDX $02
    LDA a:World3EntityX,X
    STA $3C
    LDA a:World3EntityY,X
    STA $3D
    LDA a:$0618,X
    JSR Bank2_Func_AA0F
    STA a:$0618,X
    BCC Bank2_Label_AAF0
    JSR Bank2_Func_AAF1
    LDX $02
    LDA $3C
    SEC
    SBC $3E
    JSR Bank2_Func_B149
    STA $40
    LDA $3D
    SEC
    SBC $3F
    JSR Bank2_Func_B149
    STA $41
    LDA $3C
    STA a:World3EntityX,X
    LDA $3D
    STA a:World3EntityY,X

Bank2_Label_AAF0:
    RTS

Bank2_Func_AAF1:
    LDA $3C
    SEC
    SBC $08
    JSR Bank2_Func_B149
    STA $40
    LDA $3C
    SEC
    SBC $3E
    JSR Bank2_Func_B149
    CMP $40
    BCS Bank2_Label_AB0F
    LDX $08
    JSR Bank2_Func_AB3B
    JMP Bank2_Label_AB14

Bank2_Label_AB0F:
    LDX $3E
    JSR Bank2_Func_AB3B

Bank2_Label_AB14:
    LDA $3D
    SEC
    SBC $09
    JSR Bank2_Func_B149
    STA $40
    LDA $3D
    SEC
    SBC $3F
    JSR Bank2_Func_B149
    CMP $40
    BCS Bank2_Label_AB32
    LDY $09
    JSR Bank2_Func_AB47
    JMP Bank2_Label_AB37

Bank2_Label_AB32:
    LDY $3F
    JSR Bank2_Func_AB47

Bank2_Label_AB37:
    SEC
    RTS
    .byte $18, $60
