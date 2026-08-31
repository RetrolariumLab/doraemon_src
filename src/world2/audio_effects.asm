; Doraemon PRG bank 1 $A80B-$AC2F
; World 2 audio-effect arbitration, RTS dispatch, and handlers
; Generated deterministically from pinned Ghidra/GhidraNes facts

World2_AudioEffect_RequestPriority:
    .byte $00, $30, $38, $28, $1C, $20, $04, $18, $34, $0C, $2C, $14, $10, $08, $24

World2_AudioEffect_RtsDispatchTable:
    .byte $F1, $A8, $F0, $A8, $77, $A9, $8F, $A9, $CE, $A9, $E8, $A9, $97, $AA, $A4, $AA
    .byte $71, $AB, $85, $AB, $2E, $AB, $3D, $AB, $4E, $AA, $E3, $A8, $40, $A9, $85, $AB
    .byte $48, $A9, $85, $AB, $FE, $AB, $12, $AC, $38, $AA, $E3, $A8, $FD, $AA, $E3, $A8
    .byte $18, $AB, $E3, $A8, $67, $AA, $7E, $AA, $1E, $A9, $E8, $A8

World2_Audio_QueueEffectWithPriority:
    CMP #$0F
    BCS Bank1_Label_A874
    STX $AB
    LDX a:AudioEffectRequestState
    BMI Bank1_Label_A86F
    STY $AC
    TAY
    LDA a:$A80B,X
    CMP a:$A80B,Y
    BCC Bank1_Label_A875
    TYA
    LDY $AC

Bank1_Label_A86F:
    STA a:AudioEffectRequestState

Bank1_Label_A872:
    LDX $AB

Bank1_Label_A874:
    RTS

Bank1_Label_A875:
    LDY $AC
    JMP Bank1_Label_A872

World2_Audio_QueueEffect:
    CMP #$0F
    BCS Bank1_Label_A874
    STX $AB
    LDX #$00
    STX a:AudioCurrentEffectPriority
    STA a:AudioEffectRequestState
    LDX $AB
    RTS

World2_Audio_UpdateEffects:
    LDX #$03

Bank1_Label_A88D:
    LDA a:AudioEffectTimers,X
    BEQ Bank1_Label_A895
    DEC a:AudioEffectTimers,X

Bank1_Label_A895:
    DEX
    BPL Bank1_Label_A88D
    LDA a:AudioEffectRequestState
    BMI Bank1_Label_A8D2
    TAX
    ORA #$80
    STA a:AudioEffectRequestState
    CPX #$0F
    BCS Bank1_Label_A8D2
    LDA a:AudioCurrentEffectPriority
    BEQ Bank1_Label_A8BB
    LDA a:$A80B,X
    CMP a:AudioCurrentEffectPriority
    BCC Bank1_Label_A8BB
    BNE Bank1_Label_A8D2
    LDA a:$02A2
    BNE Bank1_Label_A8D2

Bank1_Label_A8BB:
    LDA a:$A80B,X
    STA a:AudioCurrentEffectPriority
    TAX
    LDA #$00
    STA a:AudioEffectTimers
    STA a:$02A4
    STA a:$02A5
    STA a:$02A6
    BEQ Bank1_Label_A8D7

Bank1_Label_A8D2:
    LDX a:AudioCurrentEffectPriority
    INX
    INX

Bank1_Label_A8D7:
    CPX #$3C
    BCS World2_Audio_StopCurrentEffect
    LDA a:$A81B,X
    PHA
    LDA a:$A81A,X
    PHA
    RTS

Bank1_Func_A8E4:
    DEC a:$02A7
    BNE Bank1_Func_A8F1

World2_Audio_StopCurrentEffect:
    LDA #$00
    STA a:AudioCurrentEffectPriority
    STA a:$02A2

Bank1_Func_A8F1:
    RTS

World2_Audio_ResetEffects:
    LDA #$00
    STA a:$02A2
    STA a:$4011
    STA a:AudioEffectTimers
    STA a:$02A4
    STA a:$02A5
    STA a:$02A6
    STA a:APU_TRI_LINEAR
    STA a:APU_NOISE_VOL
    LDA #$18
    STA a:APU_TRI_HI
    LDA #$10
    STA a:APU_PL1_VOL
    STA a:APU_PL2_VOL
    LDA #$0F
    STA a:APU_STATUS
    RTS

Bank1_Func_A91F:
    LDA #$04
    STA a:$02A5
    STA a:$02A6
    STA a:$02A7
    LDA #$1F
    STA a:APU_NOISE_VOL
    LDA #$0F
    STA a:APU_NOISE_LO
    LDY #$08
    LDX #$F0
    LDA #$38
    JSR World2_Apu_WriteTriangleControlTimer
    STA a:APU_NOISE_HI
    RTS

Bank1_Func_A941:
    LDY #$60
    LDA #$17
    LDX #$00
    BEQ Bank1_Label_A94F

Bank1_Func_A949:
    LDY #$08
    LDA #$01
    LDX #$05

Bank1_Label_A94F:
    STY a:$02A4
    STA a:$02A7
    STX a:$02A9
    LDA #$01
    STA a:$02A8
    JSR Bank1_Func_A963
    JMP Bank1_Func_AB86

Bank1_Func_A963:
    LDA #$08
    STA a:$02A6
    LDA #$01
    STA a:APU_NOISE_VOL
    LDA #$0A
    STA a:APU_NOISE_LO
    LDA #$08
    STA a:APU_NOISE_HI

Bank1_Label_A977:
    RTS

Bank1_Func_A978:
    LDA #$48
    STA a:AudioEffectTimers
    STA a:$02A4
    STA a:$02A5
    STA a:$02A6
    LDA #$01
    STA a:$02A7
    LDA #$04
    STA a:$02A8

Bank1_Func_A990:
    LDA a:$02A8
    BNE Bank1_Label_A998
    JMP Bank1_Func_A8E4

Bank1_Label_A998:
    DEC a:$02A7
    BNE Bank1_Label_A977
    DEC a:$02A8
    BEQ Bank1_Label_A9BC
    LDA #$04
    STA a:$02A7
    LDA a:$02A8
    LSR A
    BCC Bank1_Label_A9B8
    LDA #$82
    LDX #$00
    JSR World2_Apu_WritePulse1ControlSweep
    LDX #$69
    BNE Bank1_Label_A9CA

Bank1_Label_A9B8:
    LDA #$82
    BNE Bank1_Label_A9C3

Bank1_Label_A9BC:
    LDA #$3C
    STA a:$02A7
    LDA #$8F

Bank1_Label_A9C3:
    LDX #$00
    JSR World2_Apu_WritePulse1ControlSweep
    LDX #$8D

Bank1_Label_A9CA:
    LDA #$08
    JMP World2_Apu_WritePulse1Timer

Bank1_Func_A9CF:
    LDA #$56
    STA $2D
    LDA #$AC
    STA $2E
    LDA #$01
    STA a:$02A7
    STA a:$02A2
    LDA #$09
    STA a:$02A8
    LDA #$83
    STA a:$02A9

Bank1_Func_A9E9:
    JSR Bank1_Func_AA20
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
    BEQ Bank1_Func_AA19
    ASL A
    TAY
    LDA a:$B11B,Y
    STA a:APU_PL1_LO,X
    LDA a:$B11C,Y
    ORA #$08
    STA a:APU_PL1_HI,X

Bank1_Func_AA19:
    INC $2D
    BNE Bank1_Label_AA1F
    INC $2E

Bank1_Label_AA1F:
    RTS

Bank1_Func_AA20:
    DEC a:$02A7
    BNE Bank1_Label_AA36
    LDA a:$02A8
    STA a:$02A7
    LDY #$00
    LDA ($2D),Y
    CMP #$FF
    BNE Bank1_Label_AA38
    JSR World2_Audio_StopCurrentEffect

Bank1_Label_AA36:
    PLA
    PLA

Bank1_Label_AA38:
    RTS

Bank1_Func_AA39:
    LDA #$0A
    STA a:$02A4
    STA a:$02A7
    LDA #$42
    LDX #$00
    JSR World2_Apu_WritePulse2ControlSweep
    LDX #$BB
    LDA #$08
    JMP World2_Apu_WritePulse2Timer

Bank1_Func_AA4F:
    LDA #$04
    STA a:$02A5
    STA a:$02A7
    STA a:$02A2
    LDA #$84
    LDX #$8A
    JSR World2_Apu_WritePulse1ControlSweep
    LDX #$7E
    LDA #$38
    JMP World2_Apu_WritePulse1Timer

Bank1_Func_AA68:
    LDA #$10
    STA a:$02A6
    STA a:$02A8
    LDA #$0C
    STA a:$02A7
    LDA #$04
    STA a:APU_NOISE_VOL
    LDA #$08
    STA a:APU_NOISE_HI

Bank1_Func_AA7F:
    LDA a:$02A7
    STA a:APU_NOISE_LO
    LDA a:$02A7
    CMP #$0F
    BEQ Bank1_Label_AA8F
    INC a:$02A7

Bank1_Label_AA8F:
    DEC a:$02A8
    BNE Bank1_Label_AA97

Bank1_Label_AA94:
    JMP World2_Audio_StopCurrentEffect

Bank1_Label_AA97:
    RTS

Bank1_Func_AA98:
    LDA #$5F
    STA $2D
    LDA #$AC
    STA $2E
    LDA #$01
    STA a:$02A7

Bank1_Func_AAA5:
    DEC a:$02A7
    BNE Bank1_Label_AA97
    LDY #$00
    LDA ($2D),Y
    CMP #$FF
    BEQ Bank1_Label_AA94
    STA a:$02A7
    STA a:AudioEffectTimers
    STA a:$02A4
    STA a:$02A5
    STA a:$02A6
    JSR Bank1_Func_AA19
    LDX #$00
    JSR Bank1_Func_AACC
    JSR Bank1_Func_AACC

Bank1_Func_AACC:
    LDY #$00
    LDA ($2D),Y
    BEQ Bank1_Label_AAF7
    ASL A
    TAY
    LDA a:$02A7
    CPX #$08
    BEQ Bank1_Label_AAE0
    LSR A
    ORA #$C0
    BNE Bank1_Label_AAE1

Bank1_Label_AAE0:
    ASL A

Bank1_Label_AAE1:
    STA a:APU_PL1_VOL,X
    LDA #$00
    STA a:APU_PL1_SWEEP,X
    LDA a:$B11B,Y
    STA a:APU_PL1_LO,X
    LDA a:$B11C,Y
    ORA #$08
    STA a:APU_PL1_HI,X

Bank1_Label_AAF7:
    INX
    INX
    INX
    INX
    JMP Bank1_Func_AA19

Bank1_Func_AAFE:
    LDA #$18
    STA a:$02A4
    LDA #$10
    STA a:$02A7
    STA a:$02A2
    LDA #$A0
    LDX #$9B
    JSR World2_Apu_WritePulse2ControlSweep
    LDX #$FE
    LDA #$19
    JMP World2_Apu_WritePulse2Timer

Bank1_Func_AB19:
    LDA #$08
    STA a:$02A4
    STA a:$02A7
    LDA #$C0
    LDX #$83
    JSR World2_Apu_WritePulse2ControlSweep
    LDX #$60
    LDA #$08
    JMP World2_Apu_WritePulse2Timer

Bank1_Func_AB2F:
    LDA #$03
    STA a:$02A8
    LDA #$FF
    STA a:$02A4
    LDA #$00
    STA a:$02A7

Bank1_Func_AB3E:
    LDA a:$02A7
    BNE Bank1_Label_AB6A
    LDA a:$02A8
    BNE Bank1_Label_AB50
    LDA #$00
    STA a:$02A4
    JMP World2_Audio_StopCurrentEffect

Bank1_Label_AB50:
    DEC a:$02A8
    LDA #$84
    LDX #$8B
    JSR World2_Apu_WritePulse2ControlSweep
    LDY a:$02A8
    LDX a:$AB6E,Y
    LDA #$10
    JSR World2_Apu_WritePulse2Timer
    LDA #$04
    STA a:$02A7

Bank1_Label_AB6A:
    DEC a:$02A7
    RTS
    .incbin "assets/generated/audio/sfx/prg3-tone-low.bin", $0, $4  ; rom-asset .byte

Bank1_Func_AB72:
    LDY #$14
    LDA #$04
    LDX #$03
    STY a:$02A4
    STA a:$02A7
    STX a:$02A9
    LDA #$01
    STA a:$02A8

Bank1_Func_AB86:
    DEC a:$02A8
    BNE Bank1_Label_ABB1
    LDA a:$02A7
    BMI Bank1_Label_ABB2
    CLC
    ADC a:$02A9
    ASL A
    TAY
    LDA #$DF
    LDX #$8C
    JSR World2_Apu_WritePulse2ControlSweep
    LDA a:$ABB5,Y
    TAX
    LDA a:$ABB6,Y
    ORA #$88
    JSR World2_Apu_WritePulse2Timer
    DEC a:$02A7
    LDA #$04
    STA a:$02A8

Bank1_Label_ABB1:
    RTS

Bank1_Label_ABB2:
    JMP World2_Audio_StopCurrentEffect
    .incbin "assets/generated/audio/sfx/prg3-pitch-periods.bin", $0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg3-pitch-periods.bin", $10, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg3-pitch-periods.bin", $20, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg3-pitch-periods.bin", $30, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/sfx/prg3-pitch-periods.bin", $40, $A  ; rom-asset .byte

Bank1_Func_ABFF:
    LDA #$10
    STA a:$02A5
    LDA #$40
    STA a:$02A7
    LDA #$01
    STA a:$02A8
    LDA #$30
    STA a:$02A9

Bank1_Func_AC13:
    LDY #$01
    LDX a:$02A7
    LDA #$08
    JSR World2_Apu_WriteTriangleControlTimer
    LDA a:$02A7
    SEC
    SBC a:$02A8
    STA a:$02A7
    CMP a:$02A9
    BNE Bank1_Label_AC2F
    JMP World2_Audio_StopCurrentEffect

Bank1_Label_AC2F:
    RTS
