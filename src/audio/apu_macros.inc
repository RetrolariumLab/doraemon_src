; Bank-local APU writes and the entry points used by the music engine

.macro EmitApuWrites prefix, firstReturn
    .ident (.concat(prefix, "Apu_WritePulse1ControlSweep")):
    STA a:APU_PL1_VOL
    STX a:APU_PL1_SWEEP
    .ifnblank firstReturn
firstReturn:
    .endif
    RTS

    .ident (.concat(prefix, "Apu_WritePulse2ControlSweep")):
    STA a:APU_PL2_VOL
    STX a:APU_PL2_SWEEP
    RTS

    .ident (.concat(prefix, "Apu_WritePulse1Timer")):
    STX a:APU_PL1_LO
    STA a:APU_PL1_HI
    RTS

    .ident (.concat(prefix, "Apu_WritePulse2Timer")):
    STX a:APU_PL2_LO
    STA a:APU_PL2_HI
    RTS

    .ident (.concat(prefix, "Apu_WriteTriangleControlTimer")):
    STY a:APU_TRI_LINEAR
    STX a:APU_TRI_LO
    STA a:APU_TRI_HI
    RTS
.endmacro

.macro EmitMusicChannelReset applyControl, resetChannels, refreshEnvelopes, updateEnvelope
applyControl:
    BMI refreshEnvelopes
    ORA #$80
    STA a:AudioMusicControl

resetChannels:
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

refreshEnvelopes:
    LDX #$00
    JSR updateEnvelope
    INX
    JSR updateEnvelope
    INX
    INX
    JMP updateEnvelope
    .byte $60
.endmacro
