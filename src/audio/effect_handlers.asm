; Doraemon PRG bank 3 $9C1D-$9ED7
; Remaining audio-effect handlers and APU write helpers
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank3_Func_9C1D:
    LDY #$14
    LDA #$04
    LDX #$03

Bank3_Label_9C23:
    STY a:$02A4
    STA a:$02A7
    STX a:$02A9
    LDA #$01
    STA a:$02A8

Bank3_Func_9C31:
    DEC a:$02A8
    BNE Bank3_Label_9C5C
    LDA a:$02A7
    BMI Bank3_Label_9C5D
    CLC
    ADC a:$02A9
    ASL A
    TAY
    LDA #$DF
    LDX #$8C
    JSR Apu_WritePulse2ControlSweep
    LDA a:$9C60,Y
    TAX
    LDA a:$9C61,Y
    ORA #$88
    JSR Apu_WritePulse2Timer
    DEC a:$02A7
    LDA #$04
    STA a:$02A8

Bank3_Label_9C5C:
    RTS

Bank3_Label_9C5D:
    JMP Audio_StopCurrentEffect
    .incbin "assets/generated/audio/sfx/prg3-pitch-periods.bin", $0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg3-pitch-periods.bin", $10, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg3-pitch-periods.bin", $20, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg3-pitch-periods.bin", $30, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg3-pitch-periods.bin", $40, $A  ; rom-asset .byte

Bank3_Func_9CAA:
    LDA #$10
    STA a:$02A5
    LDA #$40
    STA a:$02A7
    LDA #$01
    STA a:$02A8
    LDA #$30
    STA a:$02A9

Bank3_Func_9CBE:
    LDY #$01
    LDX a:$02A7
    LDA #$08
    JSR Apu_WriteTriangleControlTimer
    LDA a:$02A7
    SEC
    SBC a:$02A8
    STA a:$02A7
    CMP a:$02A9
    BNE Bank3_Label_9CDA
    JMP Audio_StopCurrentEffect

Bank3_Label_9CDA:
    RTS

Bank3_Func_9CDB:
    LDA #$0E
    STA a:$02A4
    LDA #$06
    STA a:$02A7
    STA a:$02A8
    LDA #$9F
    LDX #$8D
    JSR Apu_WritePulse2ControlSweep
    LDX #$00
    LDA #$89
    JMP Apu_WritePulse2Timer

Bank3_Func_9CF6:
    DEC a:$02A7
    BNE Bank3_Label_9D1B
    LDA a:$02A8
    BEQ Bank3_Label_9D18
    LDA #$08
    STA a:$02A7
    LDA #$00
    STA a:$02A8
    LDA #$9F
    LDX #$8C
    JSR Apu_WritePulse2ControlSweep
    LDX #$80
    LDA #$88
    JMP Apu_WritePulse2Timer

Bank3_Label_9D18:
    JMP Audio_StopCurrentEffect

Bank3_Label_9D1B:
    RTS

Bank3_Func_9D1C:
    LDY #$34
    LDA #$0C
    LDX #$18
    JMP Bank3_Label_9C23

Bank3_Func_9D25:
    LDA #$20
    STA a:$02A4
    LDA #$1F
    LDX #$85
    JSR Apu_WritePulse2ControlSweep
    LDX #$69
    LDA #$08
    JSR Apu_WritePulse2Timer
    LDA #$02
    STA a:$02A7
    LDA #$01
    STA a:$02A8

Bank3_Func_9D42:
    DEC a:$02A8
    BNE Bank3_Label_9D5D
    LDA #$04
    STA a:$02A8
    LDY a:$02A7
    LDA a:$9D5E,Y
    STA a:APU_PL2_VOL
    DEC a:$02A7
    BPL Bank3_Label_9D5D
    JMP Audio_StopCurrentEffect

Bank3_Label_9D5D:
    RTS
    .byte $00

Bank3_Func_9D5F:
    LDA #$00

Bank3_Label_9D61:
    STA a:$02A7
    LDA #$01
    STA a:$02A8

Bank3_Func_9D69:
    DEC a:$02A8
    BNE Bank3_Label_9D8E
    LDA a:$02A7
    EOR #$04
    STA a:$02A7
    TAY
    LDA a:$9E0F,Y
    STA a:$02A8
    LDA #$DF
    LDX a:$9E0C,Y
    JSR Apu_WritePulse1ControlSweep
    LDX a:$9E0D,Y
    LDA a:$9E0E,Y
    JMP Apu_WritePulse1Timer

Bank3_Label_9D8E:
    RTS

Bank3_Func_9D8F:
    LDA #$00
    STA a:$02A9
    LDA #$08
    JMP Bank3_Label_9D61

Bank3_Func_9D99:
    JSR Bank3_Func_9D69

Bank3_Func_9D9C:
    LDA #$00
    STA a:APU_NOISE_VOL
    LDA a:$02A9
    AND #$03
    BEQ Bank3_Label_9DB6
    LDA a:$02A9
    LSR A
    LSR A
    LSR A
    STA a:APU_NOISE_LO
    LDA #$08
    STA a:APU_NOISE_HI

Bank3_Label_9DB6:
    INC a:$02A9
    LDA a:$02A9
    BPL Bank3_Label_9DC3
    LDA #$7F
    STA a:$02A9

Bank3_Label_9DC3:
    RTS

Bank3_Func_9DC4:
    LDA #$0F
    STA a:$02A9
    LDA #$10
    JMP Bank3_Label_9D61

Bank3_Func_9DCE:
    JSR Bank3_Func_9D69
    LDA a:$02A9
    LSR A
    BCS Bank3_Label_9DEB
    LDA #$00
    STA a:APU_NOISE_VOL
    LDA a:$02A9
    LSR A
    LSR A
    LSR A
    LSR A
    STA a:APU_NOISE_LO
    LDA #$18
    STA a:APU_NOISE_HI

Bank3_Label_9DEB:
    DEC a:$02A9
    RTS

Bank3_Func_9DEF:
    LDA #$1F
    LDX #$AB
    JSR Apu_WritePulse1ControlSweep
    LDA #$98
    LDA #$9B
    JSR Apu_WritePulse2ControlSweep
    LDX #$00
    STX a:$02A7
    LDA #$0C
    JSR Apu_WritePulse1Timer
    LDA #$0A
    JMP Apu_WritePulse2Timer
    .incbin "assets/generated/audio/sfx/prg0-pulse-control.bin", $0, $2  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg0-pulse-steps.bin", $0, $E  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg0-pulse-steps.bin", $E, $8  ; rom-asset .byte

Apu_WritePulse1ControlSweep:
    STA a:APU_PL1_VOL
    STX a:APU_PL1_SWEEP
    RTS

Apu_WritePulse2ControlSweep:
    STA a:APU_PL2_VOL
    STX a:APU_PL2_SWEEP
    RTS

Apu_WritePulse1Timer:
    STX a:APU_PL1_LO
    STA a:APU_PL1_HI
    RTS

Apu_WritePulse2Timer:
    STX a:APU_PL2_LO
    STA a:APU_PL2_HI
    RTS

Apu_WriteTriangleControlTimer:
    STY a:APU_TRI_LINEAR
    STX a:APU_TRI_LO
    STA a:APU_TRI_HI
    RTS
    .byte $2C, $31, $2C, $31, $35, $38, $3D, $41, $FF, $08, $2E, $2B, $27, $08, $30, $2C
    .byte $29, $08, $32, $2D, $2A, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E
    .byte $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E
    .byte $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E
    .byte $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E
    .byte $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $FF

Bank3_Label_9EA4:
    BMI Bank3_Label_9EC9
    ORA #$80
    STA a:AudioMusicControl

Audio_ResetChannels:
    LDA #$10
    STA a:APU_PL1_VOL
    STA a:APU_PL2_VOL
    STA a:APU_NOISE_VOL
    LDA #$00
    STA a:APU_TRI_LINEAR
    LDA #$18
    STA a:APU_PL1_HI
    STA a:APU_PL2_HI
    STA a:APU_TRI_HI
    STA a:APU_NOISE_HI

Bank3_Label_9EC9:
    LDX #$00
    JSR Bank3_Func_9F9B
    INX
    JSR Bank3_Func_9F9B
    INX
    INX
    JMP Bank3_Func_9F9B
    .byte $60
