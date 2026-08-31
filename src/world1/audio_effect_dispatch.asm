; Doraemon PRG bank 0 $E316-$E68C
; World 1 audio-effect arbitration, RTS dispatch, and early handlers
; Generated deterministically from pinned Ghidra/GhidraNes facts

World1_AudioEffect_RequestPriority:
    .byte $00, $54, $64, $4C, $40, $44, $04, $38, $34, $3C, $1C, $50, $58, $60, $2C, $28
    .byte $08, $48, $30, $20, $24, $18, $14, $10, $0C, $5C

World1_AudioEffect_RtsDispatchTable:
    .byte $33, $E4, $32, $E4, $54, $E5, $6C, $E5, $AB, $E5, $C5, $E5, $EF, $E8, $F9, $E8
    .byte $EF, $E8, $F9, $E8, $EF, $E8, $F9, $E8, $EF, $E8, $F9, $E8, $8C, $E6, $99, $E6
    .byte $AD, $E8, $C2, $E7, $B6, $E8, $D3, $E8, $AE, $E7, $C2, $E7, $6B, $E7, $7A, $E7
    .byte $6C, $E8, $87, $E8, $43, $E6, $25, $E4, $15, $E6, $25, $E4, $5C, $E6, $73, $E6
    .byte $1D, $E5, $C2, $E7, $25, $E5, $C2, $E7, $3B, $E8, $4F, $E8, $2D, $E6, $25, $E4
    .byte $F2, $E6, $25, $E4, $0D, $E7, $25, $E4, $60, $E4, $82, $E4, $60, $E4, $CB, $E4
    .byte $23, $E7, $37, $E7, $FB, $E4, $2A, $E4

World1_Audio_QueueEffectWithPriority:
    CMP #$1A
    BCS Bank0_Label_E3B6
    STX $3C
    LDX a:$02A0
    BMI Bank0_Label_E3B1
    STY $3D
    TAY
    LDA a:$E316,X
    CMP a:$E316,Y
    BCC Bank0_Label_E3B7
    TYA
    LDY $3D

Bank0_Label_E3B1:
    STA a:$02A0

Bank0_Label_E3B4:
    LDX $3C

Bank0_Label_E3B6:
    RTS

Bank0_Label_E3B7:
    LDY $3D
    JMP Bank0_Label_E3B4

World1_Audio_QueueEffect:
    CMP #$1A
    BCS Bank0_Label_E3B6
    STX $3C
    LDX #$00
    STX a:$02A1
    STA a:$02A0
    LDX $3C
    RTS

World1_Audio_UpdateEffects:
    LDX #$03

Bank0_Label_E3CF:
    LDA a:$02A3,X
    BEQ Bank0_Label_E3D7
    DEC a:$02A3,X

Bank0_Label_E3D7:
    DEX
    BPL Bank0_Label_E3CF
    LDA a:$02A0
    BMI Bank0_Label_E414
    TAX
    ORA #$80
    STA a:$02A0
    CPX #$1A
    BCS Bank0_Label_E414
    LDA a:$02A1
    BEQ Bank0_Label_E3FD
    LDA a:$E316,X
    CMP a:$02A1
    BCC Bank0_Label_E3FD
    BNE Bank0_Label_E414
    LDA a:$02A2
    BNE Bank0_Label_E414

Bank0_Label_E3FD:
    LDA a:$E316,X
    STA a:$02A1
    TAX
    LDA #$00
    STA a:$02A3
    STA a:$02A4
    STA a:$02A5
    STA a:$02A6
    BEQ Bank0_Label_E419

Bank0_Label_E414:
    LDX a:$02A1
    INX
    INX

Bank0_Label_E419:
    CPX #$68
    BCS World1_Audio_StopCurrentEffect
    LDA a:$E331,X
    PHA
    LDA a:$E330,X
    PHA
    RTS

Bank0_Func_E426:
    DEC a:$02A7
    BNE Bank0_Func_E433

World1_Audio_StopCurrentEffect:
    LDA #$00
    STA a:$02A1
    STA a:$02A2

Bank0_Func_E433:
    RTS

World1_Audio_ResetEffects:
    LDA #$00
    STA a:$02A2
    STA a:$4011
    STA a:$02A3
    STA a:$02A4
    STA a:$02A5
    STA a:$02A6
    STA a:$4008
    STA a:$400C
    LDA #$18
    STA a:$400B
    LDA #$10
    STA a:$4000
    STA a:$4004
    LDA #$0F
    STA a:$4015
    RTS

Bank0_Func_E461:
    LDA #$18
    STA a:$02A6
    LDA #$00
    STA a:$400C
    LDA #$0C
    STA a:$02A7
    STA a:$400E
    LDA #$08
    STA a:$400F
    LDA #$00
    STA a:$02A8
    LDA #$04
    STA a:$02A9
    RTS

Bank0_Func_E483:
    LDX a:$02A8
    BEQ Bank0_Label_E4B3
    DEX
    BEQ Bank0_Label_E48E
    JMP Bank0_Func_E426

Bank0_Label_E48E:
    DEC a:$02A7
    LDA a:$02A7
    STA a:$400E
    CMP #$08
    BNE Bank0_Label_E4CB
    INC a:$02A8
    LDA #$1A
    STA a:$400C
    LDA #$03
    STA a:$400E
    LDA #$F8
    STA a:$400F
    LDA #$10
    STA a:$02A7
    RTS

Bank0_Label_E4B3:
    DEC a:$02A9
    BNE Bank0_Label_E4CB
    INC a:$02A8
    LDA #$04
    STA a:$400C
    LDA a:$02A7
    STA a:$400E
    LDA #$08
    STA a:$400F

Bank0_Label_E4CB:
    RTS

Bank0_Func_E4CC:
    LDX a:$02A8
    BEQ Bank0_Label_E4B3
    DEX
    BEQ Bank0_Label_E4D7
    JMP Bank0_Func_E426

Bank0_Label_E4D7:
    DEC a:$02A7
    LDA a:$02A7
    STA a:$400E
    CMP #$08
    BNE Bank0_Label_E4CB
    INC a:$02A8
    LDA #$1A
    STA a:$400C
    LDA #$06
    STA a:$400E
    LDA #$68
    STA a:$400F
    LDA #$06
    STA a:$02A7
    RTS

Bank0_Func_E4FC:
    LDA #$04
    STA a:$02A5
    STA a:$02A6
    STA a:$02A7
    LDA #$1F
    STA a:$400C
    LDA #$0F
    STA a:$400E
    LDY #$08
    LDX #$F0
    LDA #$38
    JSR World1_Apu_WriteTriangleControlTimer
    STA a:$400F
    RTS

Bank0_Func_E51E:
    LDY #$60
    LDA #$17
    LDX #$00
    BEQ Bank0_Label_E52C

Bank0_Func_E526:
    LDY #$08
    LDA #$01
    LDX #$05

Bank0_Label_E52C:
    STY a:$02A4
    STA a:$02A7
    STX a:$02A9
    LDA #$01
    STA a:$02A8
    JSR Bank0_Func_E540
    JMP Bank0_Func_E7C3

Bank0_Func_E540:
    LDA #$08
    STA a:$02A6
    LDA #$01
    STA a:$400C
    LDA #$0A
    STA a:$400E
    LDA #$08
    STA a:$400F

Bank0_Label_E554:
    RTS

Bank0_Func_E555:
    LDA #$48
    STA a:$02A3
    STA a:$02A4
    STA a:$02A5
    STA a:$02A6
    LDA #$01
    STA a:$02A7
    LDA #$04
    STA a:$02A8

Bank0_Func_E56D:
    LDA a:$02A8
    BNE Bank0_Label_E575
    JMP Bank0_Func_E426

Bank0_Label_E575:
    DEC a:$02A7
    BNE Bank0_Label_E554
    DEC a:$02A8
    BEQ Bank0_Label_E599
    LDA #$04
    STA a:$02A7
    LDA a:$02A8
    LSR A
    BCC Bank0_Label_E595
    LDA #$82
    LDX #$00
    JSR World1_Apu_WritePulse1ControlSweep
    LDX #$69
    BNE Bank0_Label_E5A7

Bank0_Label_E595:
    LDA #$82
    BNE Bank0_Label_E5A0

Bank0_Label_E599:
    LDA #$3C
    STA a:$02A7
    LDA #$8F

Bank0_Label_E5A0:
    LDX #$00
    JSR World1_Apu_WritePulse1ControlSweep
    LDX #$8D

Bank0_Label_E5A7:
    LDA #$08
    JMP World1_Apu_WritePulse1Timer

Bank0_Func_E5AC:
    LDA #$6F
    STA $2D
    LDA #$E9
    STA $2E
    LDA #$01
    STA a:$02A7
    STA a:$02A2
    LDA #$09
    STA a:$02A8
    LDA #$83
    STA a:$02A9

Bank0_Func_E5C6:
    JSR Bank0_Func_E5FD
    LDX #$00
    LDA a:$02A8
    STA a:$02A3,X
    TXA
    ASL A
    ASL A
    TAX
    LDA a:$02A9
    STA a:$4000,X
    LDA #$00
    STA a:$4001,X
    LDY #$00
    LDA ($2D),Y
    BEQ Bank0_Func_E5F6
    ASL A
    TAY
    LDA a:$EE34,Y
    STA a:$4002,X
    LDA a:$EE35,Y
    ORA #$08
    STA a:$4003,X

Bank0_Func_E5F6:
    INC $2D
    BNE Bank0_Label_E5FC
    INC $2E

Bank0_Label_E5FC:
    RTS

Bank0_Func_E5FD:
    DEC a:$02A7
    BNE Bank0_Label_E613
    LDA a:$02A8
    STA a:$02A7
    LDY #$00
    LDA ($2D),Y
    CMP #$FF
    BNE Bank0_Label_E615
    JSR World1_Audio_StopCurrentEffect

Bank0_Label_E613:
    PLA
    PLA

Bank0_Label_E615:
    RTS

Bank0_Func_E616:
    LDA #$04
    STA a:$02A3
    STA a:$02A7
    STA a:$02A2
    LDA #$00
    TAX
    JSR World1_Apu_WritePulse1ControlSweep
    LDX #$3E
    LDA #$38
    JMP World1_Apu_WritePulse1Timer

Bank0_Func_E62E:
    LDA #$0A
    STA a:$02A4
    STA a:$02A7
    LDA #$42
    LDX #$00
    JSR World1_Apu_WritePulse2ControlSweep
    LDX #$BB
    LDA #$08
    JMP World1_Apu_WritePulse2Timer

Bank0_Func_E644:
    LDA #$04
    STA a:$02A5
    STA a:$02A7
    STA a:$02A2
    LDA #$84
    LDX #$8A
    JSR World1_Apu_WritePulse1ControlSweep
    LDX #$7E
    LDA #$38
    JMP World1_Apu_WritePulse1Timer

Bank0_Func_E65D:
    LDA #$10
    STA a:$02A6
    STA a:$02A8
    LDA #$0C
    STA a:$02A7
    LDA #$04
    STA a:$400C
    LDA #$08
    STA a:$400F

Bank0_Func_E674:
    LDA a:$02A7
    STA a:$400E
    LDA a:$02A7
    CMP #$0F
    BEQ Bank0_Label_E684
    INC a:$02A7

Bank0_Label_E684:
    DEC a:$02A8
    BNE Bank0_Label_E68C

Bank0_Label_E689:
    JMP World1_Audio_StopCurrentEffect

Bank0_Label_E68C:
    RTS
