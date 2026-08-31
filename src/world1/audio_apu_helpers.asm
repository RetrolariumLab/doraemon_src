; Doraemon PRG bank 0 $E949-$E9FC
; World 1 APU write helpers and channel reset
; Generated deterministically from pinned Ghidra/GhidraNes facts

World1_Apu_WritePulse1ControlSweep:
    STA a:$4000
    STX a:$4001

Bank0_Label_E94F:
    RTS

World1_Apu_WritePulse2ControlSweep:
    STA a:$4004
    STX a:$4005
    RTS

World1_Apu_WritePulse1Timer:
    STX a:$4002
    STA a:$4003
    RTS

World1_Apu_WritePulse2Timer:
    STX a:$4006
    STA a:$4007
    RTS

World1_Apu_WriteTriangleControlTimer:
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

Bank0_Label_E9C9:
    BMI Bank0_Label_E9EE
    ORA #$80
    STA a:$02AB

World1_Audio_ResetChannels:
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

Bank0_Label_E9EE:
    LDX #$00
    JSR Bank0_Func_EAC0
    INX
    JSR Bank0_Func_EAC0
    INX
    INX
    JMP Bank0_Func_EAC0
    .byte $60
