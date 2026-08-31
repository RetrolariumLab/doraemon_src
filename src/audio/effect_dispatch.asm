; Doraemon PRG bank 3 $982A-$9C1C
; Audio-effect request arbitration and primary handlers
; Generated deterministically from pinned Ghidra/GhidraNes facts

Audio_QueueEffect:
    CMP #$1A
    BCS Bank3_Label_9824
    STX $49
    LDX #$00
    STX a:$02A1
    STA a:$02A0
    LDX $49
    RTS

Audio_UpdateEffects:
    LDX #$03

Bank3_Label_983D:
    LDA a:$02A3,X
    BEQ Bank3_Label_9845
    DEC a:$02A3,X

Bank3_Label_9845:
    DEX
    BPL Bank3_Label_983D
    LDA a:$02A0
    BMI Bank3_Label_9882
    TAX
    ORA #$80
    STA a:$02A0
    CPX #$1A
    BCS Bank3_Label_9882
    LDA a:$02A1
    BEQ Bank3_Label_986B
    LDA a:$9784,X
    CMP a:$02A1
    BCC Bank3_Label_986B
    BNE Bank3_Label_9882
    LDA a:$02A2
    BNE Bank3_Label_9882

Bank3_Label_986B:
    LDA a:$9784,X
    STA a:$02A1
    TAX
    LDA #$00
    STA a:$02A3
    STA a:$02A4
    STA a:$02A5
    STA a:$02A6
    BEQ Bank3_Label_9887

Bank3_Label_9882:
    LDX a:$02A1
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
    DEC a:$02A7
    BNE Bank3_Func_98A1

Audio_StopCurrentEffect:
    LDA #$00
    STA a:$02A1
    STA a:$02A2

Bank3_Func_98A1:
    RTS

Audio_ResetEffects:
    LDA #$00
    STA a:$02A2
    STA a:$4011
    STA a:$02A3
    STA a:$02A4
    STA a:$02A5
    STA a:$02A6
    STA a:$4008
    STA a:$400C
    LDA #$18
    STA a:$400B
    LDA #$10
    STA a:$4000
    STA a:$4004
    LDA #$0F
    STA a:$4015
    RTS

Bank3_Func_98CF:
    LDA #$18
    STA a:$02A6
    LDA #$00
    STA a:$400C
    LDA #$0C
    STA a:$02A7
    STA a:$400E
    LDA #$08
    STA a:$400F
    LDA #$00
    STA a:$02A8
    LDA #$04
    STA a:$02A9
    RTS

Bank3_Func_98F1:
    LDX a:$02A8
    BEQ Bank3_Label_9921
    DEX
    BEQ Bank3_Label_98FC
    JMP Bank3_Func_9894

Bank3_Label_98FC:
    DEC a:$02A7
    LDA a:$02A7
    STA a:$400E
    CMP #$08
    BNE Bank3_Label_9939
    INC a:$02A8
    LDA #$1A
    STA a:$400C
    LDA #$03
    STA a:$400E
    LDA #$F8
    STA a:$400F
    LDA #$10
    STA a:$02A7
    RTS

Bank3_Label_9921:
    DEC a:$02A9
    BNE Bank3_Label_9939
    INC a:$02A8
    LDA #$04
    STA a:$400C
    LDA a:$02A7
    STA a:$400E
    LDA #$08
    STA a:$400F

Bank3_Label_9939:
    RTS

Bank3_Func_993A:
    LDX a:$02A8
    BEQ Bank3_Label_9921
    DEX
    BEQ Bank3_Label_9945
    JMP Bank3_Func_9894

Bank3_Label_9945:
    DEC a:$02A7
    LDA a:$02A7
    STA a:$400E
    CMP #$08
    BNE Bank3_Label_9939
    INC a:$02A8
    LDA #$1A
    STA a:$400C
    LDA #$06
    STA a:$400E
    LDA #$68
    STA a:$400F
    LDA #$06
    STA a:$02A7
    RTS

Bank3_Func_996A:
    LDA #$04
    STA a:$02A5
    STA a:$02A6
    STA a:$02A7
    LDA #$1F
    STA a:$400C
    LDA #$0F
    STA a:$400E
    LDY #$08
    LDX #$F0
    LDA #$38
    JSR Apu_WriteTriangleControlTimer
    STA a:$400F
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
    STY a:$02A4
    STA a:$02A7
    STX a:$02A9
    LDA #$01
    STA a:$02A8
    JSR Bank3_Func_99AE
    JMP Bank3_Func_9C31

Bank3_Func_99AE:
    LDA #$08
    STA a:$02A6
    LDA #$01
    STA a:$400C
    LDA #$0A
    STA a:$400E
    LDA #$08
    STA a:$400F

Bank3_Label_99C2:
    RTS

Bank3_Func_99C3:
    LDA #$48
    STA a:$02A3
    STA a:$02A4
    STA a:$02A5
    STA a:$02A6
    LDA #$01
    STA a:$02A7
    LDA #$04
    STA a:$02A8

Bank3_Func_99DB:
    LDA a:$02A8
    BNE Bank3_Label_99E3
    JMP Bank3_Func_9894

Bank3_Label_99E3:
    DEC a:$02A7
    BNE Bank3_Label_99C2
    DEC a:$02A8
    BEQ Bank3_Label_9A07
    LDA #$04
    STA a:$02A7
    LDA a:$02A8
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
    STA a:$02A7
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
    STA a:$02A7
    STA a:$02A2
    LDA #$09
    STA a:$02A8
    LDA #$83
    STA a:$02A9

Bank3_Func_9A34:
    JSR Bank3_Func_9A6B
    LDX #$00
    LDA a:$02A8
    STA a:$02A3,X
    TXA
    ASL A
    ASL A
    TAX
    LDA a:$02A9
    STA a:$4000,X
    LDA #$00
    STA a:$4001,X
    LDY #$00
    LDA ($2D),Y
    BEQ Bank3_Func_9A64
    ASL A
    TAY
    LDA a:$A30F,Y
    STA a:$4002,X
    LDA a:$A310,Y
    ORA #$08
    STA a:$4003,X

Bank3_Func_9A64:
    INC $2D
    BNE Bank3_Label_9A6A
    INC $2E

Bank3_Label_9A6A:
    RTS

Bank3_Func_9A6B:
    DEC a:$02A7
    BNE Bank3_Label_9A81
    LDA a:$02A8
    STA a:$02A7
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
    STA a:$02A3
    STA a:$02A7
    STA a:$02A2
    LDA #$00
    TAX
    JSR Apu_WritePulse1ControlSweep
    LDX #$3E
    LDA #$38
    JMP Apu_WritePulse1Timer

Bank3_Func_9A9C:
    LDA #$0A
    STA a:$02A4
    STA a:$02A7
    LDA #$42
    LDX #$00
    JSR Apu_WritePulse2ControlSweep
    LDX #$BB
    LDA #$08
    JMP Apu_WritePulse2Timer

Bank3_Func_9AB2:
    LDA #$04
    STA a:$02A5
    STA a:$02A7
    STA a:$02A2
    LDA #$84
    LDX #$8A
    JSR Apu_WritePulse1ControlSweep
    LDX #$7E
    LDA #$38
    JMP Apu_WritePulse1Timer

Bank3_Func_9ACB:
    LDA #$10
    STA a:$02A6
    STA a:$02A8
    LDA #$0C
    STA a:$02A7
    LDA #$04
    STA a:$400C
    LDA #$08
    STA a:$400F

Bank3_Func_9AE2:
    LDA a:$02A7
    STA a:$400E
    LDA a:$02A7
    CMP #$0F
    BEQ Bank3_Label_9AF2
    INC a:$02A7

Bank3_Label_9AF2:
    DEC a:$02A8
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
    STA a:$02A7

Bank3_Func_9B08:
    DEC a:$02A7
    BNE Bank3_Label_9AFA
    LDY #$00
    LDA ($2D),Y
    CMP #$FF
    BEQ Bank3_Label_9AF7
    STA a:$02A7
    STA a:$02A3
    STA a:$02A4
    STA a:$02A5
    STA a:$02A6
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
    LDA a:$02A7
    CPX #$08
    BEQ Bank3_Label_9B43
    LSR A
    ORA #$C0
    BNE Bank3_Label_9B44

Bank3_Label_9B43:
    ASL A

Bank3_Label_9B44:
    STA a:$4000,X
    LDA #$00
    STA a:$4001,X
    LDA a:$A30F,Y
    STA a:$4002,X
    LDA a:$A310,Y
    ORA #$08
    STA a:$4003,X

Bank3_Label_9B5A:
    INX
    INX
    INX
    INX
    JMP Bank3_Func_9A64

Bank3_Func_9B61:
    LDA #$18
    STA a:$02A4
    LDA #$10
    STA a:$02A7
    STA a:$02A2
    LDA #$A0
    LDX #$9B
    JSR Apu_WritePulse2ControlSweep
    LDX #$FE
    LDA #$19
    JMP Apu_WritePulse2Timer

Bank3_Func_9B7C:
    LDA #$08
    STA a:$02A4
    STA a:$02A7
    LDA #$C0
    LDX #$83
    JSR Apu_WritePulse2ControlSweep
    LDX #$60
    LDA #$08
    JMP Apu_WritePulse2Timer

Bank3_Func_9B92:
    LDA #$18
    STA a:$02A6
    LDA #$04
    STA a:$400E
    LDA #$0F
    STA a:$02A7
    LDA #$00
    STA a:$02A8

Bank3_Func_9BA6:
    LDA a:$02A7
    CMP #$10
    BEQ Bank3_Label_9BD2
    ORA #$10
    STA a:$400C
    LDA #$28
    STA a:$400F
    LDA a:$02A8
    BEQ Bank3_Label_9BC0
    INC a:$02A7
    RTS

Bank3_Label_9BC0:
    LDA a:$02A7
    CMP #$02
    BCC Bank3_Label_9BCE
    DEC a:$02A7
    DEC a:$02A7
    RTS

Bank3_Label_9BCE:
    INC a:$02A8
    RTS

Bank3_Label_9BD2:
    LDA #$10
    STA a:$400C
    JMP Audio_StopCurrentEffect

Bank3_Func_9BDA:
    LDA #$03
    STA a:$02A8
    LDA #$FF
    STA a:$02A4
    LDA #$00
    STA a:$02A7

Bank3_Func_9BE9:
    LDA a:$02A7
    BNE Bank3_Label_9C15
    LDA a:$02A8
    BNE Bank3_Label_9BFB
    LDA #$00
    STA a:$02A4
    JMP Audio_StopCurrentEffect

Bank3_Label_9BFB:
    DEC a:$02A8
    LDA #$84
    LDX #$8B
    JSR Apu_WritePulse2ControlSweep
    LDY a:$02A8
    LDX a:$9C19,Y
    LDA #$10
    JSR Apu_WritePulse2Timer
    LDA #$04
    STA a:$02A7

Bank3_Label_9C15:
    DEC a:$02A7
    RTS
    .incbin "assets/generated/audio/sfx/prg3-tone-low.bin", $0, $4  ; rom-asset .byte
