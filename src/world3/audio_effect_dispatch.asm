; World 3 audio-effect arbitration, RTS dispatch, and early handlers
; PRG bank 2, original CPU range $BE0E-$C015

World3_AudioEffect_RequestPriority:
    .byte $00, $54, $64, $4C, $40, $44, $04, $38, $34, $3C, $1C, $50, $58, $60, $2C, $28
    .byte $08, $48, $30, $20, $24, $18, $14, $10, $0C, $5C

World3_AudioEffect_RtsDispatchTable:
    .byte $2B, $BF, $2A, $BF, $4C, $C0, $64, $C0, $A3, $C0, $BD, $C0, $E7, $C3, $F1, $C3
    .byte $E7, $C3, $F1, $C3, $E7, $C3, $F1, $C3, $E7, $C3, $F1, $C3, $84, $C1, $91, $C1
    .byte $A5, $C3, $BA, $C2, $AE, $C3, $CB, $C3, $A6, $C2, $BA, $C2, $63, $C2, $72, $C2
    .byte $64, $C3, $7F, $C3, $3B, $C1, $1D, $BF, $0D, $C1, $1D, $BF, $54, $C1, $6B, $C1
    .byte $15, $C0, $BA, $C2, $1D, $C0, $BA, $C2, $33, $C3, $47, $C3, $25, $C1, $1D, $BF
    .byte $EA, $C1, $1D, $BF, $05, $C2, $1D, $BF, $58, $BF, $7A, $BF, $58, $BF, $C3, $BF
    .byte $1B, $C2, $2F, $C2, $F3, $BF, $22, $BF

World3_Audio_QueueEffectWithPriority:
.define SfxCorePrefix "World3_"
.scope Bank2SfxDispatch
SfxBank = 2
SfxCoreCpuBase = $BE90
SfxRequestLimit = $1A
SfxDispatchLimit = SfxRequestLimit * 4
SfxSavedX = $D1
SfxSavedY = SfxSavedX + 1
RequestPriority = ::World3_AudioEffect_RequestPriority
EffectDispatchTable = ::World3_AudioEffect_RtsDispatchTable

    .include "../audio/sfx_dispatch_shared.inc"
.endscope
.undefine SfxCorePrefix

World3_AudioEffect_InitNoiseSweep:
    LDA #$18
    STA a:AudioEffectTimers+$03
    LDA #$00
    STA a:APU_NOISE_VOL
    LDA #$0C
    STA a:AudioEffectWork0
    STA a:APU_NOISE_LO
    LDA #$08
    STA a:APU_NOISE_HI
    LDA #$00
    STA a:AudioEffectWork1
    LDA #$04
    STA a:AudioEffectWork2
    RTS

World3_AudioEffect_UpdateNoiseSweepSlow:
    LDX a:AudioEffectWork1
    BEQ Bank2_Label_BFAB
    DEX
    BEQ Bank2_Label_BF86
    JMP World3_AudioEffect_UpdateTimedStop

Bank2_Label_BF86:
    DEC a:AudioEffectWork0
    LDA a:AudioEffectWork0
    STA a:APU_NOISE_LO
    CMP #$08
    BNE Bank2_Label_BFC3
    INC a:AudioEffectWork1
    LDA #$1A
    STA a:APU_NOISE_VOL
    LDA #$03
    STA a:APU_NOISE_LO
    LDA #$F8
    STA a:APU_NOISE_HI
    LDA #$10
    STA a:AudioEffectWork0
    RTS

Bank2_Label_BFAB:
    DEC a:AudioEffectWork2
    BNE Bank2_Label_BFC3
    INC a:AudioEffectWork1
    LDA #$04
    STA a:APU_NOISE_VOL
    LDA a:AudioEffectWork0
    STA a:APU_NOISE_LO
    LDA #$08
    STA a:APU_NOISE_HI

Bank2_Label_BFC3:
    RTS

World3_AudioEffect_UpdateNoiseSweepFast:
    LDX a:AudioEffectWork1
    BEQ Bank2_Label_BFAB
    DEX
    BEQ Bank2_Label_BFCF
    JMP World3_AudioEffect_UpdateTimedStop

Bank2_Label_BFCF:
    DEC a:AudioEffectWork0
    LDA a:AudioEffectWork0
    STA a:APU_NOISE_LO
    CMP #$08
    BNE Bank2_Label_BFC3
    INC a:AudioEffectWork1
    LDA #$1A
    STA a:APU_NOISE_VOL
    LDA #$06
    STA a:APU_NOISE_LO
    LDA #$68
    STA a:APU_NOISE_HI
    LDA #$06
    STA a:AudioEffectWork0
    RTS

World3_Sfx_InitTriangleNoiseBurst:
    LDA #$04
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectTimers+$03
    STA a:AudioEffectWork0
    LDA #$1F
    STA a:APU_NOISE_VOL
    LDA #$0F
    STA a:APU_NOISE_LO
    LDY #$08
    LDX #$F0
    LDA #$38
    JSR World3_Apu_WriteTriangleControlTimer
    STA a:APU_NOISE_HI
    RTS
