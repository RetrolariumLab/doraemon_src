; Doraemon PRG bank 0 $E68D-$E948
; World 1 remaining audio-effect handlers
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank0_Func_E68D:
    LDA #$78
    STA $2D
    LDA #$E9
    STA $2E
    LDA #$01
    STA a:$02A7

Bank0_Func_E69A:
    DEC a:$02A7
    BNE Bank0_Label_E68C
    LDY #$00
    LDA ($2D),Y
    CMP #$FF
    BEQ Bank0_Label_E689
    STA a:$02A7
    STA a:AudioEffectTimers
    STA a:$02A4
    STA a:$02A5
    STA a:$02A6
    JSR Bank0_Func_E5F6
    LDX #$00
    .byte $20, $C1
    INC Controller1ButtonsAlt
    CMP ($E6,X)
    LDY #$00
    LDA ($2D),Y
    BEQ Bank0_Label_E6EC
    ASL A
    TAY
    LDA a:$02A7
    CPX #$08
    BEQ Bank0_Label_E6D5
    LSR A
    ORA #$C0
    BNE Bank0_Label_E6D6

Bank0_Label_E6D5:
    ASL A

Bank0_Label_E6D6:
    STA a:APU_PL1_VOL,X
    LDA #$00
    STA a:APU_PL1_SWEEP,X
    LDA a:$EE34,Y
    STA a:APU_PL1_LO,X
    LDA a:$EE35,Y
    ORA #$08
    STA a:APU_PL1_HI,X

Bank0_Label_E6EC:
    INX
    INX
    INX
    INX
    JMP Bank0_Func_E5F6

Bank0_Func_E6F3:
    LDA #$18
    STA a:$02A4
    LDA #$10
    STA a:$02A7
    STA a:$02A2
    LDA #$A0
    LDX #$9B
    JSR World1_Apu_WritePulse2ControlSweep
    LDX #$FE
    LDA #$19
    JMP World1_Apu_WritePulse2Timer

Bank0_Func_E70E:
    LDA #$08
    STA a:$02A4
    STA a:$02A7
    LDA #$C0
    LDX #$83
    JSR World1_Apu_WritePulse2ControlSweep
    LDX #$60
    LDA #$08
    JMP World1_Apu_WritePulse2Timer

Bank0_Func_E724:
    LDA #$18
    STA a:$02A6
    LDA #$04
    STA a:APU_NOISE_LO
    LDA #$0F
    STA a:$02A7
    LDA #$00
    STA a:$02A8

Bank0_Func_E738:
    LDA a:$02A7
    CMP #$10
    BEQ Bank0_Label_E764
    ORA #$10
    STA a:APU_NOISE_VOL
    LDA #$28
    STA a:APU_NOISE_HI
    LDA a:$02A8
    BEQ Bank0_Label_E752
    INC a:$02A7
    RTS

Bank0_Label_E752:
    LDA a:$02A7
    CMP #$02
    BCC Bank0_Label_E760
    DEC a:$02A7
    DEC a:$02A7
    RTS

Bank0_Label_E760:
    INC a:$02A8
    RTS

Bank0_Label_E764:
    LDA #$10
    STA a:APU_NOISE_VOL
    JMP World1_Audio_StopCurrentEffect

Bank0_Func_E76C:
    LDA #$03
    STA a:$02A8
    LDA #$FF
    STA a:$02A4
    LDA #$00
    STA a:$02A7

Bank0_Func_E77B:
    LDA a:$02A7
    BNE Bank0_Label_E7A7
    LDA a:$02A8
    BNE Bank0_Label_E78D
    LDA #$00
    STA a:$02A4
    JMP World1_Audio_StopCurrentEffect

Bank0_Label_E78D:
    DEC a:$02A8
    LDA #$84
    LDX #$8B
    JSR World1_Apu_WritePulse2ControlSweep
    LDY a:$02A8
    LDX a:$E7AB,Y
    LDA #$10
    JSR World1_Apu_WritePulse2Timer
    LDA #$04
    STA a:$02A7

Bank0_Label_E7A7:
    DEC a:$02A7
    RTS
    .incbin "assets/generated/audio/sfx/prg3-tone-low.bin", $0, $4  ; rom-asset .byte

Bank0_Func_E7AF:
    LDY #$14
    LDA #$04
    LDX #$03

Bank0_Label_E7B5:
    STY a:$02A4
    STA a:$02A7
    STX a:$02A9
    LDA #$01
    STA a:$02A8

Bank0_Func_E7C3:
    DEC a:$02A8
    BNE Bank0_Label_E7EE
    LDA a:$02A7
    BMI Bank0_Label_E7EF
    CLC
    ADC a:$02A9
    ASL A
    TAY
    LDA #$DF
    LDX #$8C
    JSR World1_Apu_WritePulse2ControlSweep
    LDA a:$E7F2,Y
    TAX
    LDA a:$E7F3,Y
    ORA #$88
    JSR World1_Apu_WritePulse2Timer
    DEC a:$02A7
    LDA #$04
    STA a:$02A8

Bank0_Label_E7EE:
    RTS

Bank0_Label_E7EF:
    JMP World1_Audio_StopCurrentEffect
    .incbin "assets/generated/audio/sfx/prg3-pitch-periods.bin", $0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg3-pitch-periods.bin", $10, $A  ; rom-asset .byte
    AND $00,X
    BIT a:$3303
    ASL $2B
    .incbin "assets/generated/audio/sfx/prg0-pitch-periods.bin", $21, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg0-pitch-periods.bin", $31, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg0-pitch-periods.bin", $41, $9  ; rom-asset .byte

Bank0_Func_E83C:
    LDA #$10
    STA a:$02A5
    LDA #$40
    STA a:$02A7
    LDA #$01
    STA a:$02A8
    LDA #$30
    STA a:$02A9

Bank0_Func_E850:
    LDY #$01
    LDX a:$02A7
    LDA #$08
    JSR World1_Apu_WriteTriangleControlTimer
    LDA a:$02A7
    SEC
    SBC a:$02A8
    STA a:$02A7
    CMP a:$02A9
    BNE Bank0_Label_E86C
    JMP World1_Audio_StopCurrentEffect

Bank0_Label_E86C:
    RTS

Bank0_Func_E86D:
    LDA #$0E
    STA a:$02A4
    LDA #$06
    STA a:$02A7
    STA a:$02A8
    LDA #$9F
    LDX #$8D
    JSR World1_Apu_WritePulse2ControlSweep
    LDX #$00
    LDA #$89
    JMP World1_Apu_WritePulse2Timer

Bank0_Func_E888:
    DEC a:$02A7
    BNE Bank0_Label_E8AD
    LDA a:$02A8
    BEQ Bank0_Label_E8AA
    LDA #$08
    STA a:$02A7
    LDA #$00
    STA a:$02A8
    LDA #$9F
    LDX #$8C
    JSR World1_Apu_WritePulse2ControlSweep
    LDX #$80
    LDA #$88
    JMP World1_Apu_WritePulse2Timer

Bank0_Label_E8AA:
    JMP World1_Audio_StopCurrentEffect

Bank0_Label_E8AD:
    RTS

Bank0_Func_E8AE:
    LDY #$34
    LDA #$0C
    LDX #$18
    JMP Bank0_Label_E7B5

Bank0_Func_E8B7:
    LDA #$20
    STA a:$02A4
    LDA #$1F
    LDX #$85
    JSR World1_Apu_WritePulse2ControlSweep
    LDX #$69
    LDA #$08
    JSR World1_Apu_WritePulse2Timer
    LDA #$02
    STA a:$02A7
    LDA #$01
    STA a:$02A8

Bank0_Func_E8D4:
    DEC a:$02A8
    BNE Bank0_Label_E94F
    LDA #$04
    STA a:$02A8
    LDY a:$02A7
    LDA a:$E8EF,Y
    STA a:APU_PL2_VOL
    DEC a:$02A7
    BPL Bank0_Label_E94F
    JMP World1_Audio_StopCurrentEffect
    .byte $00

Bank0_Func_E8F0:
    LDA #$00
    STA a:$02A7
    LDA #$01
    STA a:$02A8

Bank0_Func_E8FA:
    DEC a:$02A8
    BNE Bank0_Label_E91F
    LDA a:$02A7
    EOR #$04
    STA a:$02A7
    TAY
    LDA a:$E934,Y
    STA a:$02A8
    LDA #$DF
    LDX a:$E931,Y
    JSR World1_Apu_WritePulse1ControlSweep
    LDX a:$E932,Y
    LDA a:$E933,Y
    JMP World1_Apu_WritePulse1Timer

Bank0_Label_E91F:
    RTS
    .byte $A9, $08, $D0, $CE, $A9, $10, $D0, $CA, $4C, $FA, $E8, $4C, $24, $E9, $4C, $FA
    .byte $E8
    .incbin "assets/generated/audio/sfx/prg0-pulse-control.bin", $0, $2  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg0-pulse-steps.bin", $0, $5  ; rom-asset .byte
    PHP
    STA a:$FC80
    ASL $85
    BRK
    .incbin "assets/generated/audio/sfx/prg3-pulse-steps.bin", $C, $A  ; rom-asset .byte
