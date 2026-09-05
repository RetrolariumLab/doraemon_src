; Doraemon PRG bank 2 $C016-$C440
; World 3 remaining audio-effect handlers
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank2_Func_C016:
    LDY #$60
    LDA #$17
    LDX #$00
    BEQ Bank2_Label_C024

Bank2_Func_C01E:
    LDY #$08
    LDA #$01
    LDX #$05

Bank2_Label_C024:
    STY a:AudioEffectTimers+$01
    STA a:$02A7
    STX a:$02A9
    LDA #$01
    STA a:$02A8
    JSR Bank2_Func_C038
    JMP Bank2_Func_C2BB

Bank2_Func_C038:
    LDA #$08
    STA a:AudioEffectTimers+$03
    LDA #$01
    STA a:APU_NOISE_VOL
    LDA #$0A
    STA a:APU_NOISE_LO
    LDA #$08
    STA a:APU_NOISE_HI

Bank2_Label_C04C:
    RTS

Bank2_Func_C04D:
    LDA #$48
    STA a:AudioEffectTimers
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectTimers+$03
    LDA #$01
    STA a:$02A7
    LDA #$04
    STA a:$02A8

Bank2_Func_C065:
    LDA a:$02A8
    BNE Bank2_Label_C06D
    JMP Bank2_Func_BF1E

Bank2_Label_C06D:
    DEC a:$02A7
    BNE Bank2_Label_C04C
    DEC a:$02A8
    BEQ Bank2_Label_C091
    LDA #$04
    STA a:$02A7
    LDA a:$02A8
    LSR A
    BCC Bank2_Label_C08D
    LDA #$82
    LDX #$00
    JSR World3_Apu_WritePulse1ControlSweep
    LDX #$69
    BNE Bank2_Label_C09F

Bank2_Label_C08D:
    LDA #$82
    BNE Bank2_Label_C098

Bank2_Label_C091:
    LDA #$3C
    STA a:$02A7
    LDA #$8F

Bank2_Label_C098:
    LDX #$00
    JSR World3_Apu_WritePulse1ControlSweep
    LDX #$8D

Bank2_Label_C09F:
    LDA #$08
    JMP World3_Apu_WritePulse1Timer

Bank2_Func_C0A4:
    LDA #$67
    STA $2D
    LDA #$C4
    STA $2E
    LDA #$01
    STA a:$02A7
    STA a:$02A2
    LDA #$09
    STA a:$02A8
    LDA #$83
    STA a:$02A9

Bank2_Func_C0BE:
    JSR Bank2_Func_C0F5
    LDX #$00
    LDA a:$02A8
    STA a:AudioEffectTimers,X
    TXA
    ASL A
    ASL A
    TAX
    LDA a:$02A9
    STA a:APU_PL1_VOL,X
    LDA #$00
    STA a:APU_PL1_SWEEP,X
    LDY #$00
    LDA ($2D),Y
    BEQ Bank2_Func_C0EE
    ASL A
    TAY
    LDA a:$C92C,Y
    STA a:APU_PL1_LO,X
    LDA a:$C92D,Y
    ORA #$08
    STA a:APU_PL1_HI,X

Bank2_Func_C0EE:
    INC $2D
    BNE Bank2_Label_C0F4
    INC $2E

Bank2_Label_C0F4:
    RTS

Bank2_Func_C0F5:
    DEC a:$02A7
    BNE Bank2_Label_C10B
    LDA a:$02A8
    STA a:$02A7
    LDY #$00
    LDA ($2D),Y
    CMP #$FF
    BNE Bank2_Label_C10D
    JSR World3_Audio_StopCurrentEffect

Bank2_Label_C10B:
    PLA
    PLA

Bank2_Label_C10D:
    RTS

Bank2_Func_C10E:
    LDA #$04
    STA a:AudioEffectTimers
    STA a:$02A7
    STA a:$02A2
    LDA #$00
    TAX
    JSR World3_Apu_WritePulse1ControlSweep
    LDX #$3E
    LDA #$38
    JMP World3_Apu_WritePulse1Timer

Bank2_Func_C126:
    LDA #$0A
    STA a:AudioEffectTimers+$01
    STA a:$02A7
    LDA #$42
    LDX #$00
    JSR World3_Apu_WritePulse2ControlSweep
    LDX #$BB
    LDA #$08
    JMP World3_Apu_WritePulse2Timer

Bank2_Func_C13C:
    LDA #$04
    STA a:AudioEffectTimers+$02
    STA a:$02A7
    STA a:$02A2
    LDA #$84
    LDX #$8A
    JSR World3_Apu_WritePulse1ControlSweep
    LDX #$7E
    LDA #$38
    JMP World3_Apu_WritePulse1Timer

Bank2_Func_C155:
    LDA #$10
    STA a:AudioEffectTimers+$03
    STA a:$02A8
    LDA #$0C
    STA a:$02A7
    LDA #$04
    STA a:APU_NOISE_VOL
    LDA #$08
    STA a:APU_NOISE_HI

Bank2_Func_C16C:
    LDA a:$02A7
    STA a:APU_NOISE_LO
    LDA a:$02A7
    CMP #$0F
    BEQ Bank2_Label_C17C
    INC a:$02A7

Bank2_Label_C17C:
    DEC a:$02A8
    BNE Bank2_Label_C184

Bank2_Label_C181:
    JMP World3_Audio_StopCurrentEffect

Bank2_Label_C184:
    RTS

Bank2_Func_C185:
    LDA #$70
    STA $2D
    LDA #$C4
    STA $2E
    LDA #$01
    STA a:$02A7

Bank2_Func_C192:
    DEC a:$02A7
    BNE Bank2_Label_C184
    LDY #$00
    LDA ($2D),Y
    CMP #$FF
    BEQ Bank2_Label_C181
    STA a:$02A7
    STA a:AudioEffectTimers
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectTimers+$03
    JSR Bank2_Func_C0EE
    LDX #$00
    JSR Bank2_Func_C1B9
    JSR Bank2_Func_C1B9

Bank2_Func_C1B9:
    LDY #$00
    LDA ($2D),Y
    BEQ Bank2_Label_C1E4
    ASL A
    TAY
    LDA a:$02A7
    CPX #$08
    BEQ Bank2_Label_C1CD
    LSR A
    ORA #$C0
    BNE Bank2_Label_C1CE

Bank2_Label_C1CD:
    ASL A

Bank2_Label_C1CE:
    STA a:APU_PL1_VOL,X
    LDA #$00
    STA a:APU_PL1_SWEEP,X
    LDA a:$C92C,Y
    STA a:APU_PL1_LO,X
    LDA a:$C92D,Y
    ORA #$08
    STA a:APU_PL1_HI,X

Bank2_Label_C1E4:
    INX
    INX
    INX
    INX
    JMP Bank2_Func_C0EE

Bank2_Func_C1EB:
    LDA #$18
    STA a:AudioEffectTimers+$01
    LDA #$10
    STA a:$02A7
    STA a:$02A2
    LDA #$A0
    LDX #$9B
    JSR World3_Apu_WritePulse2ControlSweep
    LDX #$FE
    LDA #$19
    JMP World3_Apu_WritePulse2Timer

Bank2_Func_C206:
    LDA #$08
    STA a:AudioEffectTimers+$01
    STA a:$02A7
    LDA #$C0
    LDX #$83
    JSR World3_Apu_WritePulse2ControlSweep
    LDX #$60
    LDA #$08
    JMP World3_Apu_WritePulse2Timer

Bank2_Func_C21C:
    LDA #$18
    STA a:AudioEffectTimers+$03
    LDA #$04
    STA a:APU_NOISE_LO
    LDA #$0F
    STA a:$02A7
    LDA #$00
    STA a:$02A8

Bank2_Func_C230:
    LDA a:$02A7
    CMP #$10
    BEQ Bank2_Label_C25C
    ORA #$10
    STA a:APU_NOISE_VOL
    LDA #$28
    STA a:APU_NOISE_HI
    LDA a:$02A8
    BEQ Bank2_Label_C24A
    INC a:$02A7
    RTS

Bank2_Label_C24A:
    LDA a:$02A7
    CMP #$02
    BCC Bank2_Label_C258
    DEC a:$02A7
    DEC a:$02A7
    RTS

Bank2_Label_C258:
    INC a:$02A8
    RTS

Bank2_Label_C25C:
    LDA #$10
    STA a:APU_NOISE_VOL
    JMP World3_Audio_StopCurrentEffect

Bank2_Func_C264:
    LDA #$03
    STA a:$02A8
    LDA #$FF
    STA a:AudioEffectTimers+$01
    LDA #$00
    STA a:$02A7

Bank2_Func_C273:
    LDA a:$02A7
    BNE Bank2_Label_C29F
    LDA a:$02A8
    BNE Bank2_Label_C285
    LDA #$00
    STA a:AudioEffectTimers+$01
    JMP World3_Audio_StopCurrentEffect

Bank2_Label_C285:
    DEC a:$02A8
    LDA #$84
    LDX #$8B
    JSR World3_Apu_WritePulse2ControlSweep
    LDY a:$02A8
    LDX a:$C2A3,Y
    LDA #$10
    JSR World3_Apu_WritePulse2Timer
    LDA #$04
    STA a:$02A7

Bank2_Label_C29F:
    DEC a:$02A7
    RTS
    .incbin "assets/generated/audio/sfx/prg3-tone-low.bin", $0, $4  ; rom-asset .byte

Bank2_Func_C2A7:
    LDY #$14
    LDA #$04
    LDX #$03

Bank2_Label_C2AD:
    STY a:AudioEffectTimers+$01
    STA a:$02A7
    STX a:$02A9
    LDA #$01
    STA a:$02A8

Bank2_Func_C2BB:
    DEC a:$02A8
    BNE Bank2_Label_C2E6
    LDA a:$02A7
    BMI Bank2_Label_C2E7
    CLC
    ADC a:$02A9
    ASL A
    TAY
    LDA #$DF
    LDX #$8C
    JSR World3_Apu_WritePulse2ControlSweep
    LDA a:$C2EA,Y
    TAX
    LDA a:$C2EB,Y
    ORA #$88
    JSR World3_Apu_WritePulse2Timer
    DEC a:$02A7
    LDA #$04
    STA a:$02A8

Bank2_Label_C2E6:
    RTS

Bank2_Label_C2E7:
    JMP World3_Audio_StopCurrentEffect
    .incbin "assets/generated/audio/sfx/prg3-pitch-periods.bin", $0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg3-pitch-periods.bin", $10, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg3-pitch-periods.bin", $20, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg3-pitch-periods.bin", $30, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg3-pitch-periods.bin", $40, $A  ; rom-asset .byte

Bank2_Func_C334:
    LDA #$10
    STA a:AudioEffectTimers+$02
    LDA #$40
    STA a:$02A7
    LDA #$01
    STA a:$02A8
    LDA #$30
    STA a:$02A9

Bank2_Func_C348:
    LDY #$01
    LDX a:$02A7
    LDA #$08
    JSR World3_Apu_WriteTriangleControlTimer
    LDA a:$02A7
    SEC
    SBC a:$02A8
    STA a:$02A7
    CMP a:$02A9
    BNE Bank2_Label_C364
    JMP World3_Audio_StopCurrentEffect

Bank2_Label_C364:
    RTS

Bank2_Func_C365:
    LDA #$0E
    STA a:AudioEffectTimers+$01
    LDA #$06
    STA a:$02A7
    STA a:$02A8
    LDA #$9F
    LDX #$8D
    JSR World3_Apu_WritePulse2ControlSweep
    LDX #$00
    LDA #$89
    JMP World3_Apu_WritePulse2Timer

Bank2_Func_C380:
    DEC a:$02A7
    BNE Bank2_Label_C3A5
    LDA a:$02A8
    BEQ Bank2_Label_C3A2
    LDA #$08
    STA a:$02A7
    LDA #$00
    STA a:$02A8
    LDA #$9F
    LDX #$8C
    JSR World3_Apu_WritePulse2ControlSweep
    LDX #$80
    LDA #$88
    JMP World3_Apu_WritePulse2Timer

Bank2_Label_C3A2:
    JMP World3_Audio_StopCurrentEffect

Bank2_Label_C3A5:
    RTS

Bank2_Func_C3A6:
    LDY #$34
    LDA #$0C
    LDX #$18
    JMP Bank2_Label_C2AD

Bank2_Func_C3AF:
    LDA #$20
    STA a:AudioEffectTimers+$01
    LDA #$1F
    LDX #$85
    JSR World3_Apu_WritePulse2ControlSweep
    LDX #$69
    LDA #$08
    JSR World3_Apu_WritePulse2Timer
    LDA #$02
    STA a:$02A7
    LDA #$01
    STA a:$02A8

Bank2_Func_C3CC:
    DEC a:$02A8
    BNE Bank2_Label_C447
    LDA #$04
    STA a:$02A8
    LDY a:$02A7
    LDA a:$C3E7,Y
    STA a:APU_PL2_VOL
    DEC a:$02A7
    BPL Bank2_Label_C447
    JMP World3_Audio_StopCurrentEffect
    .byte $00

Bank2_Func_C3E8:
    LDA #$00
    STA a:$02A7
    LDA #$01
    STA a:$02A8

Bank2_Func_C3F2:
    DEC a:$02A8
    BNE Bank2_Label_C417
    LDA a:$02A7
    EOR #$04
    STA a:$02A7
    TAY
    LDA a:$C42C,Y
    STA a:$02A8
    LDA #$DF
    LDX a:$C429,Y
    JSR World3_Apu_WritePulse1ControlSweep
    LDX a:$C42A,Y
    LDA a:$C42B,Y
    JMP World3_Apu_WritePulse1Timer

Bank2_Label_C417:
    RTS
    .byte $A9, $08, $D0, $CE, $A9, $10, $D0, $CA, $4C, $F2, $C3, $4C, $1C, $C4, $4C, $F2
    .byte $C3
    .incbin "assets/generated/audio/sfx/prg2-pulse-control.bin", $0, $2  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg2-pulse-steps.bin", $0, $D  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg2-pulse-steps.bin", $D, $9  ; rom-asset .byte
