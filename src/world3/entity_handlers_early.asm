; Doraemon PRG bank 2 $931F-$968B
; World 3 shared indirect trampoline and early entity-type handlers
; Generated deterministically from pinned Ghidra/GhidraNes facts

World3_CallIndirect:
    JMP ($0040)

Bank2_Func_9322:
    LDA a:World3EntityState,X
    CMP #$04
    BNE Bank2_Label_932C
    JSR Bank2_Func_9A05

Bank2_Label_932C:
    RTS

Bank2_Func_932D:
    LDA a:World3EntityState,X
    CMP #$04
    BNE Bank2_Label_9338
    JSR Bank2_Func_9A05
    RTS

Bank2_Label_9338:
    LDY $DF
    LDA a:$936C,Y
    BEQ Bank2_Label_936B
    INC a:$0618,X
    LDA a:$0618,X
    AND #$03
    BNE Bank2_Label_936B
    STX $3E
    LDA a:World3EntityX,X
    STA $3C
    LDA a:World3EntityY,X
    STA $3D
    LDX $8C
    LDY $8D
    JSR Bank2_Func_AB3B
    JSR Bank2_Func_AB47
    LDX $3E
    LDA $3C
    STA a:World3EntityX,X
    LDA $3D
    STA a:World3EntityY,X

Bank2_Label_936B:
    RTS
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01
    .byte $00, $00, $00, $00, $00, $01, $01, $01, $00, $00, $00, $00, $00, $01, $01, $00

Bank2_Func_93AC:
    LDA a:World3EntityX,X
    CMP #$F0
    BCS Bank2_Label_93EF
    LDA a:World3EntityY,X
    CMP #$D8
    BCS Bank2_Label_93EF
    LDY #$00

Bank2_Label_93BC:
    LDA a:World3EntityState,Y
    CMP #$04
    BEQ Bank2_Label_93CB
    INY
    CPY #$08
    BNE Bank2_Label_93BC
    JMP Bank2_Label_94EC

Bank2_Label_93CB:
    LDA $A3
    AND #$03
    TAY
    LDA a:World3EntityX,X
    CLC
    ADC a:$93E7,Y
    STA a:World3EntityX,X
    LDA a:World3EntityY,X
    CLC
    ADC a:$93EB,Y
    STA a:World3EntityY,X
    JMP Bank2_Label_94EC
    .byte $02, $FE, $02, $FE, $02, $02, $FE, $FE

Bank2_Label_93EF:
    LDA #$00
    STA a:World3EntityState,X
    LDY #$00

Bank2_Label_93F6:
    LDA a:World3EntityState,Y
    CMP #$04
    BEQ Bank2_Label_9403
    INY
    CPY #$08
    BNE Bank2_Label_93F6
    RTS

Bank2_Label_9403:
    LDA #$00
    STA a:World3EntityState,Y
    LDA #$00
    STA a:$0678,Y
    LDA a:World3EntityType,Y
    CMP #$18
    BCS Bank2_Label_9415
    RTS

Bank2_Label_9415:
    LDA $DF
    STA $40
    LDA $8C
    SEC
    SBC #$78
    JSR Bank2_Func_B149
    STA $41
    LDA $8D
    SEC
    SBC #$78
    JSR Bank2_Func_B149
    CMP $41
    BCS Bank2_Label_9449
    LDA $8C
    CMP #$78
    BCS Bank2_Label_943E
    LDA $89
    BEQ Bank2_Label_9475
    DEC $40
    JMP Bank2_Label_946A

Bank2_Label_943E:
    LDA $89
    CMP #$07
    BEQ Bank2_Label_9475
    INC $40
    JMP Bank2_Label_946A

Bank2_Label_9449:
    LDA $8D
    CMP #$78
    BCS Bank2_Label_945D
    LDA $8A
    BEQ Bank2_Label_9475
    LDA $40
    SEC
    SBC #$08
    STA $40
    JMP Bank2_Label_946A

Bank2_Label_945D:
    LDA $8A
    CMP #$07
    BEQ Bank2_Label_9475
    LDA $40
    CLC
    ADC #$08
    STA $40

Bank2_Label_946A:
    STX $3E
    LDX $40
    LDA a:$9550,X
    BEQ Bank2_Label_94B8
    LDX $3E

Bank2_Label_9475:
    STX $3E
    LDA $DF
    SEC
    SBC #$01
    AND #$3F
    TAX
    LDA a:$9550,X
    BEQ Bank2_Label_94B6
    LDA $DF
    CLC
    ADC #$01
    AND #$3F
    TAX
    LDA a:$9550,X
    BEQ Bank2_Label_94B6
    LDA $DF
    SEC
    SBC #$08
    AND #$3F
    TAX
    LDA a:$9550,X
    BEQ Bank2_Label_94B6
    LDA $DF
    CLC
    ADC #$08
    AND #$3F
    TAX
    LDA a:$9550,X
    BEQ Bank2_Label_94B6

Bank2_Label_94AB:
    JSR Bank2_Func_B153
    AND #$3F
    TAX
    LDA a:$9550,X
    BNE Bank2_Label_94AB

Bank2_Label_94B6:
    STX $40

Bank2_Label_94B8:
    LDX #$00

Bank2_Label_94BA:
    LDA a:World3RoomObjectRoom,X
    CMP $DF
    BNE Bank2_Label_94C9
    LDA a:World3RoomObjectType,X
    CMP a:World3EntityType,Y
    BEQ Bank2_Label_94D3

Bank2_Label_94C9:
    INX
    CPX #$0D
    BNE Bank2_Label_94BA
    LDA #$04
    JMP Bank2_Func_AF51

Bank2_Label_94D3:
    LDA $40
    STA a:World3RoomObjectRoom,X
    JSR Bank2_Func_928D
    STA a:World3RoomObjectX,X
    JSR Bank2_Func_9299
    STA a:World3RoomObjectY,X
    LDA #$00
    STA a:World3RoomObjectState,X
    LDX $3E
    RTS

Bank2_Label_94EC:
    LDY #$00

Bank2_Label_94EE:
    LDA a:World3EntityState,Y
    CMP #$04
    BEQ Bank2_Label_954F
    INY
    CPY #$08
    BNE Bank2_Label_94EE
    LDY #$00

Bank2_Label_94FC:
    LDA a:World3EntityState,Y
    CMP #$01
    BNE Bank2_Label_954A
    LDA a:World3EntityType,Y
    CMP #$05
    BCC Bank2_Label_9512
    CMP #$18
    BCC Bank2_Label_954A
    CMP #$1B
    BEQ Bank2_Label_954A

Bank2_Label_9512:
    LDA a:World3EntityX,X
    SEC
    SBC a:World3EntityX,Y
    JSR Bank2_Func_B149
    CMP #$0D
    BCS Bank2_Label_954A
    LDA a:World3EntityY,X
    SEC
    SBC a:World3EntityY,Y
    JSR Bank2_Func_B149
    CMP #$0D
    BCS Bank2_Label_954A
    LDA a:$0690,X
    STA $A3
    LDA #$12
    JSR Bank2_Func_A5EB
    LDA #$04
    STA a:World3EntityState,Y
    LDA a:$0678,Y
    BEQ Bank2_Label_954F
    LDA #$00
    STA a:$0678,Y
    STA $9A
    RTS

Bank2_Label_954A:
    INY
    CPY #$08
    BNE Bank2_Label_94FC

Bank2_Label_954F:
    RTS
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $01, $01, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $01, $01
    .byte $00, $01, $01, $01, $00, $00, $01, $01, $01, $01, $01, $00, $00, $01, $01, $01
    .byte $00, $00, $00, $00, $01, $01, $01, $01, $00, $00, $00, $00, $00, $01, $01, $01

Bank2_Func_9590:
    RTS

Bank2_Func_9591:
    JSR Bank2_Func_AA2A

Bank2_Func_9594:
    RTS

Bank2_Func_9595:
    JSR Bank2_Func_B153
    AND #$1F
    BNE Bank2_Label_95A1
    LDA #$11
    JSR Bank2_Func_A5EB

Bank2_Label_95A1:
    JSR Bank2_Func_AD21

Bank2_Func_95A4:
    RTS

Bank2_Func_95A5:
    JSR Bank2_Func_B153
    AND #$1F
    BNE Bank2_Label_95B1
    LDA #$11
    JSR Bank2_Func_A5EB

Bank2_Label_95B1:
    LDA a:$0690,X
    BEQ Bank2_Label_95B9
    JSR Bank2_Func_95F3

Bank2_Label_95B9:
    STX $3E
    LDA a:$0690,X
    BEQ Bank2_Label_95F2
    INC a:$0618,X
    LDA a:$0618,X
    AND #$01
    BNE Bank2_Label_95F2
    LDA a:World3EntityX,X
    STA $3C
    LDA a:World3EntityY,X
    STA $3D
    LDA $8C
    CLC
    ADC #$08
    TAX
    LDA $8D
    SEC
    SBC #$0C
    TAY
    JSR Bank2_Func_AB3B
    JSR Bank2_Func_AB47
    LDX $3E
    LDA $3C
    STA a:World3EntityX,X
    LDA $3D
    STA a:World3EntityY,X

Bank2_Label_95F2:
    RTS

Bank2_Func_95F3:
    STX $3E
    LDX #$00
    LDY #$00

Bank2_Label_95F9:
    LDA a:World3EntityState,X
    BNE Bank2_Label_95FF
    INY

Bank2_Label_95FF:
    INX
    CPX #$08
    BNE Bank2_Label_95F9
    CPY #$02
    BCC Bank2_Label_9640
    JSR World3_FindFreeEntitySlot
    BCC Bank2_Label_9640
    JSR World3_ClearEntitySlot
    LDA #$1E
    STA a:$0668,X
    LDA #$02
    STA a:World3EntityType,X
    TAY
    LDA a:$8EB5,Y
    STA a:$0698,X
    LDA a:$8ED5,Y
    STA a:World3EntityMetasprite,X
    LDY $3E
    LDA a:World3EntityX,Y
    CLC
    ADC #$08
    STA a:World3EntityX,X
    LDA a:World3EntityY,Y
    CLC
    ADC #$18
    STA a:World3EntityY,X
    LDA #$01
    STA a:World3EntityState,X

Bank2_Label_9640:
    LDX $3E
    RTS

Bank2_Func_9643:
    LDA a:$0690,X
    BEQ Bank2_Label_965A
    JSR Bank2_Func_96C0
    LDA a:World3EntityX,Y
    CLC
    ADC #$10
    STA a:World3EntityX,X
    LDA a:World3EntityY,Y
    STA a:World3EntityY,X

Bank2_Label_965A:
    RTS

Bank2_Func_965B:
    LDA a:$0690,X
    BEQ Bank2_Label_968B
    JSR Bank2_Func_96C0
    LDA a:World3EntityX,Y
    STA a:World3EntityX,X
    LDA a:World3EntityY,Y
    CLC
    ADC #$18
    STA a:World3EntityY,X
    INC a:$0618,X
    LDA a:$0618,X
    LSR A
    LSR A
    LSR A
    AND #$01
    STA a:$06A8,X
    LDA a:$0618,X
    LSR A
    LSR A
    LSR A
    AND #$02
    STA a:$06A0,X

Bank2_Label_968B:
    RTS
