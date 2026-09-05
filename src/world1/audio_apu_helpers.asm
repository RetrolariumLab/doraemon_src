; Doraemon PRG bank 0 $E949-$E9FC
; World 1 APU write helpers and channel reset
; Generated deterministically from pinned Ghidra/GhidraNes facts

World1_Apu_WritePulse1ControlSweep:
    STA a:APU_PL1_VOL
    STX a:APU_PL1_SWEEP

Bank0_Label_E94F:
    RTS

World1_Apu_WritePulse2ControlSweep:
    STA a:APU_PL2_VOL
    STX a:APU_PL2_SWEEP
    RTS

World1_Apu_WritePulse1Timer:
    STX a:APU_PL1_LO
    STA a:APU_PL1_HI
    RTS

World1_Apu_WritePulse2Timer:
    STX a:APU_PL2_LO
    STA a:APU_PL2_HI
    RTS

World1_Apu_WriteTriangleControlTimer:
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

Bank0_Label_E9C9:
    BMI Bank0_Label_E9EE
    ORA #$80
    STA a:AudioMusicControl

World1_Audio_ResetChannels:
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

Bank0_Label_E9EE:
    LDX #$00
    JSR World1_Music_UpdateVolumeEnvelope
    INX
    JSR World1_Music_UpdateVolumeEnvelope
    INX
    INX
    JMP World1_Music_UpdateVolumeEnvelope
    .byte $60
