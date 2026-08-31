; Doraemon PRG bank 1 $8000-$827C
; Bank 1 reset, NMI, input, mapper switching, and cross-bank gateways
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank1_Func_8000:
    JSR Bank1_Func_80F0
    LDA #$00
    JSR Bank1_Func_81B2
    JMP Bank1_Func_8271

Bank1_Func_800B:
    JSR Bank1_Func_80F0
    LDA #$01
    JSR Bank1_Func_81B2
    JMP Bank1_Func_8271

Bank1_Func_8016:
    JSR Bank1_Func_80F0
    LDA #$02
    JSR Bank1_Func_81B2
    JMP Bank1_Func_8271
    .byte $4C, $74, $82

Bank1_Func_8024:
    JSR Bank1_Func_80F0
    LDA #$00
    JSR Bank1_Func_81B2
    JMP Bank1_Func_8277

Bank1_Func_802F:
    JSR Bank1_Func_80F0
    LDA #$01
    JSR Bank1_Func_81B2
    JMP Bank1_Func_8277

Bank1_Func_803A:
    JSR Bank1_Func_80F0
    LDA #$02
    JSR Bank1_Func_81B2
    JMP Bank1_Func_8277
    .byte $4C, $7A, $82

Bank1_Func_8048:
    JSR Bank1_Func_80F0
    LDA #$03
    JSR Bank1_Func_81B2
    JMP Bank1_Func_8271

Bank1_Func_8053:
    JSR Bank1_Func_80F0
    LDA $17
    PHA
    LDA #$03
    JSR Bank1_Func_81B2
    JSR Bank1_Func_8277
    PLA
    JMP Bank1_Func_81B2

Bank1_Func_8065:
    JSR Bank1_Func_80F0
    LDA $17
    PHA
    LDA #$03
    JSR Bank1_Func_81B2
    JSR Bank1_Func_827D
    PLA
    JMP Bank1_Func_81B2

Bank1_Func_8077:
    JSR Bank1_Func_80F0
    LDA #$03
    JSR Bank1_Func_81B2
    JMP Bank1_Label_8280

Bank1_Func_8082:
    JSR Bank1_Func_80F0
    LDA #$03
    JSR Bank1_Func_81B2
    JMP Bank1_Label_8283

Bank1_Func_808D:
    JSR Bank1_Func_80F0
    LDA #$03
    JSR Bank1_Func_81B2
    JMP Bank1_Func_8286

Bank1_Reset:
    LDX #$7F
    TXS
    LDA #$00
    STA a:$2001
    STA a:$2000
    JSR Bank1_WaitForVblank
    JSR Bank1_WaitForVblank
    LDX #$00
    TXA

Bank1_Label_80AC:
    STA a:$0400,X
    STA a:$0500,X
    STA a:$0600,X
    STA a:$0700,X
    INX
    BNE Bank1_Label_80AC
    LDA #$10
    STA $19
    STA a:$2000
    LDA #$06
    STA $1A
    STA a:$2001
    JSR Bank1_Func_80DA
    JMP Bank1_Func_8048

Bank1_WaitForVblank:
    LDA a:$2002
    BPL Bank1_WaitForVblank

Bank1_Label_80D4:
    LDA a:$2002
    BMI Bank1_Label_80D4
    RTS

Bank1_Func_80DA:
    JSR Bank1_WaitForVblank
    LDA #$00
    STA $14
    LDA $19
    STA a:$2000
    LDA $1A
    AND #$E7
    STA $1A
    STA a:$2001
    RTS

Bank1_Func_80F0:
    JSR Bank1_Func_80DA
    LDA $19
    AND #$7F
    STA $19
    STA a:$2000
    RTS

Bank1_Func_80FD:
    JSR Bank1_Func_8131
    JSR Bank1_WaitForVblank
    LDA #$01
    STA $14
    LDA $1B
    STA a:$2005
    LDA $1C
    STA a:$2005
    LDA $19
    ORA #$80
    STA $19
    STA a:$2000
    LDA #$00
    STA a:$2003
    LDA #$03
    STA a:$4014
    JSR Bank1_WriteMapper
    LDA $1A
    ORA #$18
    STA $1A
    STA a:$2001
    RTS

Bank1_Func_8131:
    LDA #$F0
    LDX #$00

Bank1_Label_8135:
    STA a:$0300,X
    INX
    BNE Bank1_Label_8135
    RTS

Bank1_Nmi:
    PHA
    TXA
    PHA
    TYA
    PHA
    LDA $15
    BNE Bank1_Label_81A2
    INC $15
    LDA $14
    BEQ Bank1_Label_8158
    LDA #$00
    STA a:$2003
    LDA #$03
    STA a:$4014
    JSR Bank1_WriteMapper

Bank1_Label_8158:
    JSR Bank1_Func_8274
    LDA #$01
    STA a:$4016
    LDA #$00
    STA a:$4016
    LDX #$08

Bank1_Label_8167:
    LDA a:$4016
    LSR A
    ROL $1F
    LSR A
    ROL $20
    LDA a:$4017
    LSR A
    ROL $1D
    LSR A
    ROL $1E
    DEX
    BNE Bank1_Label_8167
    LDA $1D
    AND #$CF
    ORA $1F
    ORA $20
    ORA $1E
    STA $21
    LDA a:$4016
    AND #$04
    CMP $23
    BEQ Bank1_Label_8197
    STA $23
    LDA #$14
    STA $24

Bank1_Label_8197:
    LDA $24
    BEQ Bank1_Label_819D
    DEC $24

Bank1_Label_819D:
    JSR Bank1_Func_827A
    DEC $15

Bank1_Label_81A2:
    INC $16
    PLA
    TAY
    PLA
    TAX
    PLA
    RTI

Bank1_Func_81AA:
    ASL A
    ASL A
    AND #$0C
    STA $18
    LDA $17

Bank1_Func_81B2:
    AND #$03
    ORA $18
    STA $17
    JSR Bank1_WaitForVblank

Bank1_WriteMapper:
    LDA $17
    TAX
    LDA a:$8261,X
    STA a:$8261,X
    NOP
    NOP
    NOP
    NOP
    RTS

Bank1_Func_81C9:
    STA $07
    LDA $27
    BNE Bank1_Label_81E5
    TYA
    PHA
    TXA
    PHA
    LDA $07
    LSR A
    LSR A
    LSR A
    LSR A
    TAX
    LDA $07
    AND #$0F
    JSR Bank1_Func_81E6
    PLA
    TAX
    PLA
    TAY

Bank1_Label_81E5:
    RTS

Bank1_Func_81E6:
    CLC
    ADC a:$0298,X
    LDY #$00

Bank1_Label_81EC:
    CMP #$0A
    BCC Bank1_Label_81F6
    SEC
    SBC #$0A
    INY
    BNE Bank1_Label_81EC

Bank1_Label_81F6:
    STA a:$0298,X
    TYA
    BNE Bank1_Label_81FD
    RTS

Bank1_Label_81FD:
    DEX
    BPL Bank1_Func_81E6
    LDA #$09
    LDX #$05

Bank1_Label_8204:
    STA a:$0298,X
    STA a:$0290,X
    DEX
    BPL Bank1_Label_8204
    RTS

Bank1_Func_820E:
    LDA $27
    BNE Bank1_Label_8244
    LDA $25
    CMP #$04
    BEQ Bank1_Label_8233
    ASL A
    ASL A
    TAY
    LDX #$00

Bank1_Label_821D:
    LDA a:$0298,X
    CMP a:$8251,Y
    BCC Bank1_Label_8233
    BNE Bank1_Label_822D
    INX
    INY
    CPX #$04
    BNE Bank1_Label_821D

Bank1_Label_822D:
    INC $2A
    INC $26
    INC $25

Bank1_Label_8233:
    LDX #$00

Bank1_Label_8235:
    LDA a:$0290,X
    CMP a:$0298,X
    BCC Bank1_Label_8245
    BNE Bank1_Label_8244
    INX
    CPX #$06
    BNE Bank1_Label_8235

Bank1_Label_8244:
    RTS

Bank1_Label_8245:
    LDA a:$0298,X
    STA a:$0290,X
    INX
    CPX #$06
    BNE Bank1_Label_8245
    RTS
    .byte $00, $00, $02, $00, $00, $00, $08, $00, $00, $02, $00, $00, $00, $05, $00, $00

Bank1_MapperValueTable:
    .byte $00, $10, $20, $30, $01, $11, $21, $31, $02, $12, $22, $32, $03, $13, $23, $33

Bank1_Func_8271:
    JMP Bank1_World2Main

Bank1_Func_8274:
    JMP Bank1_Func_829F

Bank1_Func_8277:
    JMP Bank1_Func_8891

Bank1_Func_827A:
    JMP Bank1_Func_8704
