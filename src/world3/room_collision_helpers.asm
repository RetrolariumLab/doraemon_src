; Doraemon PRG bank 2 $AB3B-$AE11
; World 3 room collision helpers and movement state tables
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank2_Func_AB3B:
    CPX $3C
    BEQ Bank2_Label_AB46
    BCS Bank2_Label_AB44
    DEC $3C
    RTS

Bank2_Label_AB44:
    INC $3C

Bank2_Label_AB46:
    RTS

Bank2_Func_AB47:
    CPY $3D
    BEQ Bank2_Label_AB52
    BCS Bank2_Label_AB50
    DEC $3D
    RTS

Bank2_Label_AB50:
    INC $3D

Bank2_Label_AB52:
    RTS

Bank2_Func_AB53:
    JSR Bank2_Func_B153
    AND #$07
    TAX
    LDA a:World3EncounterRoomList,X
    CMP #$FF
    BEQ Bank2_Label_AB9D
    STA $3E
    LSR A
    LSR A
    LSR A
    CMP $8A
    BEQ Bank2_Label_AB7F
    BCC Bank2_Label_AB75
    LDA $3E
    SEC
    SBC #$08
    STA $3E
    JMP Bank2_Label_AB7C

Bank2_Label_AB75:
    LDA $3E
    CLC
    ADC #$08
    STA $3E

Bank2_Label_AB7C:
    JSR Bank2_Func_AB9E

Bank2_Label_AB7F:
    LDA $3E
    AND #$07
    CMP $89
    BEQ Bank2_Label_AB9D
    BCC Bank2_Label_AB93
    LDA $3E
    SEC
    SBC #$01
    STA $3E
    JMP Bank2_Label_AB9A

Bank2_Label_AB93:
    LDA $3E
    CLC
    ADC #$01
    STA $3E

Bank2_Label_AB9A:
    JSR Bank2_Func_AB9E

Bank2_Label_AB9D:
    RTS

Bank2_Func_AB9E:
    LDY $3E
    LDA a:$ABB9,Y
    BNE Bank2_Label_ABB8
    LDY #$00

Bank2_Label_ABA7:
    LDA $3E
    CMP a:World3EncounterRoomList,Y
    BEQ Bank2_Label_ABB8
    INY
    CPY #$08
    BNE Bank2_Label_ABA7
    LDA $3E
    STA a:World3EncounterRoomList,X

Bank2_Label_ABB8:
    RTS
    .byte $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $01, $01, $00, $01, $00, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $01, $01, $00, $00, $00, $01, $01, $00, $00, $00, $00, $01, $01, $01
    .byte $00, $00, $00, $00, $01, $01, $01, $01, $00, $00, $00, $00, $01, $01, $01, $01

Bank2_Func_ABF9:
    LDA #$00
    STA $51
    LDX #$00

Bank2_Label_ABFF:
    LDA a:World3EncounterRoomList,X
    CMP $DF
    BEQ Bank2_Label_AC0C
    INX
    CPX #$08
    BNE Bank2_Label_ABFF
    RTS

Bank2_Label_AC0C:
    LDA #$00
    STA $51
    JSR World3_FindFreeEntitySlot
    BCC Bank2_Label_AC6B

Bank2_Func_AC15:
    LDA #$00
    STA $51
    LDA #$00
    STA $C9
    STA $CA

Bank2_Func_AC1F:
    LDA #$00
    STA $51
    CPX #$06
    BCS Bank2_Label_AC6B
    STX $C8
    LDA #$01
    STA $51
    LDY #$00

Bank2_Label_AC2F:
    JSR World3_ClearEntitySlot
    LDA a:$AC6C,Y
    STA a:World3EntityState,X
    LDA a:$AC74,Y
    CLC
    ADC $C9
    STA a:World3EntityX,X
    LDA a:$AC7C,Y
    CLC
    ADC $CA
    STA a:World3EntityY,X
    LDA a:$AC84,Y
    STA a:World3EntityType,X
    STY $42
    TAY
    LDA a:$8ED5,Y
    STA a:World3EntityMetasprite,X
    LDY $42
    LDA #$1E
    STA a:World3EntityActivationTimer,X
    INY
    INX
    CPX #$08
    BNE Bank2_Label_AC2F
    LDA #$03
    STA a:AudioMusicState

Bank2_Label_AC6B:
    RTS
    .byte $03, $03, $03, $03, $03, $03, $03, $03, $68, $62, $68, $72, $7E, $88, $8E, $88
    .byte $88, $7C, $70, $68, $68, $70, $7C, $88, $0A, $0B, $0B, $0B, $0B, $0B, $0B, $0B

Bank2_Func_AC8C:
    LDA #$00
    STA $3F
    CPX #$06
    BCS Bank2_Label_ACAC
    JSR Bank2_Func_ACAE
    LDY $40
    TXA
    STA a:World3EntityCollisionScanLimit,Y
    CPX #$06
    BCS Bank2_Label_ACAA
    JSR Bank2_Func_ACAE
    LDY $40
    TXA
    STA a:World3EntityCollisionScanLimit,Y

Bank2_Label_ACAA:
    SEC
    RTS

Bank2_Label_ACAC:
    CLC
    RTS

Bank2_Func_ACAE:
    STX $40
    LDA #$04
    STA $41

Bank2_Label_ACB4:
    JSR World3_ClearEntitySlot
    LDY $3F
    LDA a:$ACF9,Y
    STA a:World3EntityState,X
    LDA a:$AD01,Y
    STA a:World3EntityX,X
    LDA a:$AD09,Y
    STA a:World3EntityY,X
    LDA a:$AD11,Y
    STA a:World3EntityType,X
    STY $42
    TAY
    LDA a:$8ED5,Y
    STA a:World3EntityMetasprite,X
    LDY $42
    LDA a:$8EBD
    STA a:World3EntityHitPoints,X
    LDA a:$AD19,Y
    STA a:World3EntityFrameCounter,X
    LDA #$1E
    STA a:World3EntityActivationTimer,X
    INC $3F
    INX
    CPX #$08
    BEQ Bank2_Label_ACF8
    DEC $41
    BNE Bank2_Label_ACB4

Bank2_Label_ACF8:
    RTS
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $68, $62, $68, $72, $64, $6C, $74, $74
    .byte $88, $7C, $70, $68, $92, $88, $80, $80, $08, $09, $09, $09, $08, $09, $09, $09
    .byte $01, $01, $02, $02, $02, $02, $03, $03

Bank2_Func_AD21:
    LDX $C8
    LDA a:World3EntityBehaviorTimer,X
    BNE Bank2_Label_AD58
    JSR Bank2_Func_B153
    AND #$20
    ORA #$10
    STA a:World3EntityBehaviorTimer,X
    JSR Bank2_Func_B153
    AND #$01
    STA a:World3EntityBehaviorSelector,X

Bank2_Label_AD3A:
    JSR Bank2_Func_B153
    AND #$C0
    ORA #$10
    CMP a:World3EntityHorizontalDirection,X
    BEQ Bank2_Label_AD3A
    STA a:World3EntityHorizontalDirection,X

Bank2_Label_AD49:
    JSR Bank2_Func_B153
    AND #$C0
    ORA #$10
    CMP a:World3EntityVerticalDirection,X
    BEQ Bank2_Label_AD49
    STA a:World3EntityVerticalDirection,X

Bank2_Label_AD58:
    DEC a:World3EntityBehaviorTimer,X
    LDA a:World3EntityX,X
    STA $3C
    LDA a:World3EntityY,X
    STA $3D
    LDA a:World3EntityBehaviorSelector,X
    BEQ Bank2_Label_AD75
    LDA a:World3EntityVerticalDirection,X
    TAY
    LDA a:World3EntityHorizontalDirection,X
    TAX
    JMP Bank2_Label_AD79

Bank2_Label_AD75:
    LDX $8C
    LDY $8D

Bank2_Label_AD79:
    JSR Bank2_Func_AB3B
    JSR Bank2_Func_AB47
    LDX $C8
    LDA $3C
    STA a:World3EntityX,X
    LDA $3D
    STA a:World3EntityY,X
    STX $05

Bank2_Label_AD8D:
    LDX $05
    LDA a:World3EntityX+$01,X
    STA $3C
    LDA a:World3EntityY+$01,X
    STA $3D
    LDA a:World3EntityY,X
    TAY
    LDA a:World3EntityX,X
    TAX
    TXA
    SEC
    SBC $3C
    JSR Bank2_Func_B149
    CMP #$06
    BCC Bank2_Label_ADAF
    JSR Bank2_Func_AB3B

Bank2_Label_ADAF:
    TYA
    SEC
    SBC $3D
    JSR Bank2_Func_B149
    CMP #$06
    BCC Bank2_Label_ADBD
    JSR Bank2_Func_AB47

Bank2_Label_ADBD:
    LDX $05
    LDA $3C
    STA a:World3EntityX+$01,X
    LDA $3D
    STA a:World3EntityY+$01,X
    INC $05
    LDA $05
    CMP #$07
    BNE Bank2_Label_AD8D
    RTS
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $00, $01, $01, $01, $00
    .byte $02, $02, $0A, $02, $01, $02, $02, $02, $03, $03, $03, $02, $03, $03, $03, $03
    .byte $04, $04, $04, $04, $04, $04, $05, $05, $06, $04, $04, $06, $06, $07, $06, $06
    .byte $06, $06, $06, $06, $07, $07, $09, $09, $08, $08, $08, $08, $08, $0A, $0A, $0A
