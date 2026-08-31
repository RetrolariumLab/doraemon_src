; Doraemon PRG bank 2 $C441-$C4F4
; World 3 APU write helpers, presentation data, and channel reset
; Generated deterministically from pinned Ghidra/GhidraNes facts

World3_Apu_WritePulse1ControlSweep:
    STA a:$4000
    STX a:$4001

Bank2_Label_C447:
    RTS

World3_Apu_WritePulse2ControlSweep:
    STA a:$4004
    STX a:$4005
    RTS

World3_Apu_WritePulse1Timer:
    STX a:$4002
    STA a:$4003
    RTS

World3_Apu_WritePulse2Timer:
    STX a:$4006
    STA a:$4007
    RTS

World3_Apu_WriteTriangleControlTimer:
    STY a:$4008
    STX a:$400A
    STA a:$400B
    RTS
    .byte $2C, $31, $2C, $31, $35, $38, $3D, $41, $FF, $08, $2E, $2B, $27, $08, $30, $2C
    .byte $29, $08, $32, $2D, $2A, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E
    .byte $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E
    .byte $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E
    .byte $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E
    .byte $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $FF

Bank2_Label_C4C1:
    BMI Bank2_Label_C4E6
    ORA #$80
    STA a:$02AB

World3_Audio_ResetChannels:
    LDA #$10
    STA a:$4000
    STA a:$4004
    STA a:$400C
    LDA #$00
    STA a:$4008
    LDA #$18
    STA a:$4003
    STA a:$4007
    STA a:$400B
    STA a:$400F

Bank2_Label_C4E6:
    LDX #$00
    JSR Bank2_Func_C5B8
    INX
    JSR Bank2_Func_C5B8
    INX
    INX
    JMP Bank2_Func_C5B8
    .byte $60
