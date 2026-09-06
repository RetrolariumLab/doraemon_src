; Doraemon PRG bank 3 $982A-$9C1C
; Audio-effect request arbitration and primary handlers
; Generated deterministically from pinned Ghidra/GhidraNes facts

Audio_QueueEffect:
    CMP #$1A
    BCS Bank3_Label_9824
    STX $49
    LDX #$00
    STX a:AudioCurrentEffectPriority
    STA a:AudioEffectRequestState
    LDX $49
    RTS

Audio_UpdateEffects:
    LDX #$03

Bank3_Label_983D:
    LDA a:AudioEffectTimers,X
    BEQ Bank3_Label_9845
    DEC a:AudioEffectTimers,X

Bank3_Label_9845:
    DEX
    BPL Bank3_Label_983D
    LDA a:AudioEffectRequestState
    BMI Bank3_Label_9882
    TAX
    ORA #$80
    STA a:AudioEffectRequestState
    CPX #$1A
    BCS Bank3_Label_9882
    LDA a:AudioCurrentEffectPriority
    BEQ Bank3_Label_986B
    LDA a:$9784,X
    CMP a:AudioCurrentEffectPriority
    BCC Bank3_Label_986B
    BNE Bank3_Label_9882
    LDA a:AudioEffectRetriggerLock
    BNE Bank3_Label_9882

Bank3_Label_986B:
    LDA a:$9784,X
    STA a:AudioCurrentEffectPriority
    TAX
    LDA #$00
    STA a:AudioEffectTimers
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectTimers+$03
    BEQ Bank3_Label_9887

Bank3_Label_9882:
    LDX a:AudioCurrentEffectPriority
    INX
    INX

Bank3_Label_9887:
    CPX #$68
    BCS Audio_StopCurrentEffect
    LDA a:$979F,X
    PHA
    LDA a:$979E,X
    PHA
    RTS

Bank3_Func_9894:
    DEC a:AudioEffectWork0
    BNE Bank3_Func_98A1

Audio_StopCurrentEffect:
    LDA #$00
    STA a:AudioCurrentEffectPriority
    STA a:AudioEffectRetriggerLock

Bank3_Func_98A1:
    RTS

Audio_ResetEffects:
    LDA #$00
    STA a:AudioEffectRetriggerLock
    STA a:$4011
    STA a:AudioEffectTimers
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectTimers+$03
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

Bank3_Func_98CF:
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

Bank3_Func_98F1:
    LDX a:AudioEffectWork1
    BEQ Bank3_Label_9921
    DEX
    BEQ Bank3_Label_98FC
    JMP Bank3_Func_9894

Bank3_Label_98FC:
    DEC a:AudioEffectWork0
    LDA a:AudioEffectWork0
    STA a:APU_NOISE_LO
    CMP #$08
    BNE Bank3_Label_9939
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

Bank3_Label_9921:
    DEC a:AudioEffectWork2
    BNE Bank3_Label_9939
    INC a:AudioEffectWork1
    LDA #$04
    STA a:APU_NOISE_VOL
    LDA a:AudioEffectWork0
    STA a:APU_NOISE_LO
    LDA #$08
    STA a:APU_NOISE_HI

Bank3_Label_9939:
    RTS

Bank3_Func_993A:
    LDX a:AudioEffectWork1
    BEQ Bank3_Label_9921
    DEX
    BEQ Bank3_Label_9945
    JMP Bank3_Func_9894

Bank3_Label_9945:
    DEC a:AudioEffectWork0
    LDA a:AudioEffectWork0
    STA a:APU_NOISE_LO
    CMP #$08
    BNE Bank3_Label_9939
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

Bank3_Func_996A:
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
    JSR Apu_WriteTriangleControlTimer
    STA a:APU_NOISE_HI
    RTS

Bank3_Func_998C:
    LDY #$60
    LDA #$17
    LDX #$00
    BEQ Bank3_Label_999A

Bank3_Func_9994:
    LDY #$08
    LDA #$01
    LDX #$05

Bank3_Label_999A:
    STY a:AudioEffectTimers+$01
    STA a:AudioEffectWork0
    STX a:AudioEffectWork2
    LDA #$01
    STA a:AudioEffectWork1
    JSR Bank3_Func_99AE
    JMP Bank3_Func_9C31

Bank3_Func_99AE:
    LDA #$08
    STA a:AudioEffectTimers+$03
    LDA #$01
    STA a:APU_NOISE_VOL
    LDA #$0A
    STA a:APU_NOISE_LO
    LDA #$08
    STA a:APU_NOISE_HI

Bank3_Label_99C2:
    RTS

Bank3_Func_99C3:
    LDA #$48
    STA a:AudioEffectTimers
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectTimers+$03
    LDA #$01
    STA a:AudioEffectWork0
    LDA #$04
    STA a:AudioEffectWork1

Bank3_Func_99DB:
    LDA a:AudioEffectWork1
    BNE Bank3_Label_99E3
    JMP Bank3_Func_9894

Bank3_Label_99E3:
    DEC a:AudioEffectWork0
    BNE Bank3_Label_99C2
    DEC a:AudioEffectWork1
    BEQ Bank3_Label_9A07
    LDA #$04
    STA a:AudioEffectWork0
    LDA a:AudioEffectWork1
    LSR A
    BCC Bank3_Label_9A03
    LDA #$82
    LDX #$00
    JSR Apu_WritePulse1ControlSweep
    LDX #$69
    BNE Bank3_Label_9A15

Bank3_Label_9A03:
    LDA #$82
    BNE Bank3_Label_9A0E

Bank3_Label_9A07:
    LDA #$3C
    STA a:AudioEffectWork0
    LDA #$8F

Bank3_Label_9A0E:
    LDX #$00
    JSR Apu_WritePulse1ControlSweep
    LDX #$8D

Bank3_Label_9A15:
    LDA #$08
    JMP Apu_WritePulse1Timer

Bank3_Func_9A1A:
    LDA #$4A
    STA $2D
    LDA #$9E
    STA $2E
    LDA #$01
    STA a:AudioEffectWork0
    STA a:AudioEffectRetriggerLock
    LDA #$09
    STA a:AudioEffectWork1
    LDA #$83
    STA a:AudioEffectWork2

Bank3_Func_9A34:
    JSR Bank3_Func_9A6B
    LDX #$00
    LDA a:AudioEffectWork1
    STA a:AudioEffectTimers,X
    TXA
    ASL A
    ASL A
    TAX
    LDA a:AudioEffectWork2
    STA a:APU_PL1_VOL,X
    LDA #$00
    STA a:APU_PL1_SWEEP,X
    LDY #$00
    LDA ($2D),Y
    BEQ Bank3_Func_9A64
    ASL A
    TAY
    LDA a:$A30F,Y
    STA a:APU_PL1_LO,X
    LDA a:$A310,Y
    ORA #$08
    STA a:APU_PL1_HI,X

Bank3_Func_9A64:
    INC $2D
    BNE Bank3_Label_9A6A
    INC $2E

Bank3_Label_9A6A:
    RTS

Bank3_Func_9A6B:
    DEC a:AudioEffectWork0
    BNE Bank3_Label_9A81
    LDA a:AudioEffectWork1
    STA a:AudioEffectWork0
    LDY #$00
    LDA ($2D),Y
    CMP #$FF
    BNE Bank3_Label_9A83
    JSR Audio_StopCurrentEffect

Bank3_Label_9A81:
    PLA
    PLA

Bank3_Label_9A83:
    RTS

Bank3_Func_9A84:
    LDA #$04
    STA a:AudioEffectTimers
    STA a:AudioEffectWork0
    STA a:AudioEffectRetriggerLock
    LDA #$00
    TAX
    JSR Apu_WritePulse1ControlSweep
    LDX #$3E
    LDA #$38
    JMP Apu_WritePulse1Timer

Bank3_Func_9A9C:
    LDA #$0A
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectWork0
    LDA #$42
    LDX #$00
    JSR Apu_WritePulse2ControlSweep
    LDX #$BB
    LDA #$08
    JMP Apu_WritePulse2Timer

Bank3_Func_9AB2:
    LDA #$04
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectWork0
    STA a:AudioEffectRetriggerLock
    LDA #$84
    LDX #$8A
    JSR Apu_WritePulse1ControlSweep
    LDX #$7E
    LDA #$38
    JMP Apu_WritePulse1Timer

Bank3_Func_9ACB:
    LDA #$10
    STA a:AudioEffectTimers+$03
    STA a:AudioEffectWork1
    LDA #$0C
    STA a:AudioEffectWork0
    LDA #$04
    STA a:APU_NOISE_VOL
    LDA #$08
    STA a:APU_NOISE_HI

Bank3_Func_9AE2:
    LDA a:AudioEffectWork0
    STA a:APU_NOISE_LO
    LDA a:AudioEffectWork0
    CMP #$0F
    BEQ Bank3_Label_9AF2
    INC a:AudioEffectWork0

Bank3_Label_9AF2:
    DEC a:AudioEffectWork1
    BNE Bank3_Label_9AFA

Bank3_Label_9AF7:
    JMP Audio_StopCurrentEffect

Bank3_Label_9AFA:
    RTS

Bank3_Func_9AFB:
    LDA #$53
    STA $2D
    LDA #$9E
    STA $2E
    LDA #$01
    STA a:AudioEffectWork0

Bank3_Func_9B08:
    DEC a:AudioEffectWork0
    BNE Bank3_Label_9AFA
    LDY #$00
    LDA ($2D),Y
    CMP #$FF
    BEQ Bank3_Label_9AF7
    STA a:AudioEffectWork0
    STA a:AudioEffectTimers
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectTimers+$03
    JSR Bank3_Func_9A64
    LDX #$00
    JSR Bank3_Func_9B2F
    JSR Bank3_Func_9B2F

Bank3_Func_9B2F:
    LDY #$00
    LDA ($2D),Y
    BEQ Bank3_Label_9B5A
    ASL A
    TAY
    LDA a:AudioEffectWork0
    CPX #$08
    BEQ Bank3_Label_9B43
    LSR A
    ORA #$C0
    BNE Bank3_Label_9B44

Bank3_Label_9B43:
    ASL A

Bank3_Label_9B44:
    STA a:APU_PL1_VOL,X
    LDA #$00
    STA a:APU_PL1_SWEEP,X
    LDA a:$A30F,Y
    STA a:APU_PL1_LO,X
    LDA a:$A310,Y
    ORA #$08
    STA a:APU_PL1_HI,X

Bank3_Label_9B5A:
    INX
    INX
    INX
    INX
    JMP Bank3_Func_9A64

Bank3_Func_9B61:
    LDA #$18
    STA a:AudioEffectTimers+$01
    LDA #$10
    STA a:AudioEffectWork0
    STA a:AudioEffectRetriggerLock
    LDA #$A0
    LDX #$9B
    JSR Apu_WritePulse2ControlSweep
    LDX #$FE
    LDA #$19
    JMP Apu_WritePulse2Timer

Bank3_Func_9B7C:
    LDA #$08
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectWork0
    LDA #$C0
    LDX #$83
    JSR Apu_WritePulse2ControlSweep
    LDX #$60
    LDA #$08
    JMP Apu_WritePulse2Timer

Bank3_Func_9B92:
    LDA #$18
    STA a:AudioEffectTimers+$03
    LDA #$04
    STA a:APU_NOISE_LO
    LDA #$0F
    STA a:AudioEffectWork0
    LDA #$00
    STA a:AudioEffectWork1

Bank3_Func_9BA6:
    LDA a:AudioEffectWork0
    CMP #$10
    BEQ Bank3_Label_9BD2
    ORA #$10
    STA a:APU_NOISE_VOL
    LDA #$28
    STA a:APU_NOISE_HI
    LDA a:AudioEffectWork1
    BEQ Bank3_Label_9BC0
    INC a:AudioEffectWork0
    RTS

Bank3_Label_9BC0:
    LDA a:AudioEffectWork0
    CMP #$02
    BCC Bank3_Label_9BCE
    DEC a:AudioEffectWork0
    DEC a:AudioEffectWork0
    RTS

Bank3_Label_9BCE:
    INC a:AudioEffectWork1
    RTS

Bank3_Label_9BD2:
    LDA #$10
    STA a:APU_NOISE_VOL
    JMP Audio_StopCurrentEffect

Bank3_Func_9BDA:
    LDA #$03
    STA a:AudioEffectWork1
    LDA #$FF
    STA a:AudioEffectTimers+$01
    LDA #$00
    STA a:AudioEffectWork0

Bank3_Func_9BE9:
    LDA a:AudioEffectWork0
    BNE Bank3_Label_9C15
    LDA a:AudioEffectWork1
    BNE Bank3_Label_9BFB
    LDA #$00
    STA a:AudioEffectTimers+$01
    JMP Audio_StopCurrentEffect

Bank3_Label_9BFB:
    DEC a:AudioEffectWork1
    LDA #$84
    LDX #$8B
    JSR Apu_WritePulse2ControlSweep
    LDY a:AudioEffectWork1
    LDX a:$9C19,Y
    LDA #$10
    JSR Apu_WritePulse2Timer
    LDA #$04
    STA a:AudioEffectWork0

Bank3_Label_9C15:
    DEC a:AudioEffectWork0
    RTS
    .incbin "assets/generated/audio/sfx/prg3-tone-low.bin", $0, $4  ; rom-asset .byte
