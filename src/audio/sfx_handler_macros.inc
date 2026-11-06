; Preserve the original address-based labels in both world banks

.macro SfxHandlerLocal name
    ::.ident(.sprintf("Bank%d_Label_%04X", SfxBank, SfxCoreCpuBase + (* - SfxCoreStart))):
name:
.endmacro

.macro EmitNoiseSweepPhaseCheck firstPhase, sweepPhase, timedStop
    LDX a:AudioEffectWork1
    BEQ firstPhase
    DEX
    BEQ sweepPhase
    JMP timedStop
.endmacro

.macro EmitNoiseSweepPhaseStep done, period, length, duration
    DEC a:AudioEffectWork0
    LDA a:AudioEffectWork0
    STA a:APU_NOISE_LO
    CMP #$08
    BNE done
    INC a:AudioEffectWork1
    LDA #$1A
    STA a:APU_NOISE_VOL
    LDA #period
    STA a:APU_NOISE_LO
    LDA #length
    STA a:APU_NOISE_HI
    LDA #duration
    STA a:AudioEffectWork0
    RTS
.endmacro
