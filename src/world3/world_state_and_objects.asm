; Doraemon PRG bank 2 $875C-$8B67
; World 3 world-state progression, object spawning, and player interactions
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank2_Func_875C:
    STX $44
    STY $45
    LDA #$07
    STA $47
    LDA #$0D
    STA $48

Bank2_Label_8768:
    LDX #$0C
    LDY $47
    JSR Bank2_Func_B0BA
    LDA #$00
    STA $72
    LDX #$87
    LDY #$87
    LDA #$12
    JSR Bank2_Func_B33A
    INC $47
    DEC $48
    BNE Bank2_Label_8768
    LDX $44
    LDY $45
    RTS
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00

Bank2_Func_879B:
    LDA $DF
    CMP #$3C
    BEQ Bank2_Label_87A2
    RTS

Bank2_Label_87A2:
    LDA $A1
    BNE Bank2_Label_8816
    LDY #$00
    LDA #$03
    STA $3E

Bank2_Label_87AC:
    LDA a:World3EntityState,Y
    CMP #$01
    BNE Bank2_Label_87C0
    LDA a:World3EntityType,Y
    CMP #$1C
    BCC Bank2_Label_87C0
    CMP #$1F
    BCS Bank2_Label_87C0
    DEC $3E

Bank2_Label_87C0:
    INY
    CPY #$08
    BNE Bank2_Label_87AC
    LDA $3E
    BNE Bank2_Label_8816
    LDA #$04
    JSR Bank2_Func_A5EB
    JSR Bank2_Func_86C4
    JSR Bank2_Func_8817
    LDA #$01
    STA $A1
    LDY #$00

Bank2_Label_87DA:
    LDA a:World3EntityState,Y
    CMP #$01
    BNE Bank2_Label_87F1
    LDA a:World3EntityType,Y
    CMP #$1C
    BCC Bank2_Label_87F1
    CMP #$1F
    BCS Bank2_Label_87F1
    LDA #$00
    STA a:World3EntityState,Y

Bank2_Label_87F1:
    INY
    CPY #$08
    BNE Bank2_Label_87DA
    LDY #$00

Bank2_Label_87F8:
    LDA a:World3RoomObjectType,Y
    CMP #$1C
    BCC Bank2_Label_880D
    CMP #$1F
    BCS Bank2_Label_880D
    LDA #$23
    STA a:World3RoomObjectRoom,Y
    LDA #$00
    STA a:World3RoomObjectState,Y

Bank2_Label_880D:
    INY
    CPY #$0D
    BNE Bank2_Label_87F8
    LDA #$00
    STA $9A

Bank2_Label_8816:
    RTS

Bank2_Func_8817:
    LDA $DF
    CMP #$3C
    BNE Bank2_Label_8847
    STX $44
    STY $45
    LDA #$14
    STA $47
    LDA #$08
    STA $48

Bank2_Label_8829:
    LDX #$14
    LDY $47
    JSR Bank2_Func_B0BA
    LDA #$00
    STA $72
    LDX #$0F
    LDY #$98
    LDA #$04
    JSR Bank2_Func_B33A
    INC $47
    DEC $48
    BNE Bank2_Label_8829
    LDX $44
    LDY $45

Bank2_Label_8847:
    RTS

Bank2_Func_8848:
    STX $5C
    LDA #$00
    STA $05
    LDA #$02
    STA $04

Bank2_Label_8852:
    LDY $05
    LDA a:$06F9,Y
    CMP #$01
    BNE Bank2_Label_8868
    LDA a:$06FB,Y
    STA $3C
    LDA a:$06FD,Y
    STA $3D
    JSR Bank2_Func_886F

Bank2_Label_8868:
    INC $05
    DEC $04
    BNE Bank2_Label_8852

Bank2_Label_886E:
    RTS

Bank2_Func_886F:
    LDA a:World3EntityState,X
    CMP #$01
    BNE Bank2_Label_886E
    LDA a:World3EntityX,X
    SEC
    SBC $3C
    JSR Bank2_Func_B149
    CMP #$0D
    BCS Bank2_Label_886E
    LDA a:World3EntityY,X
    SEC
    SBC $3D
    JSR Bank2_Func_B149
    CMP #$0D
    BCS Bank2_Label_886E
    LDA a:World3EntityType,X
    CMP #$10
    BCS Bank2_Label_886E
    CMP #$05
    BEQ Bank2_Label_886E
    CMP #$06
    BEQ Bank2_Label_886E
    CMP #$07
    BEQ Bank2_Label_886E
    CMP #$02
    BNE Bank2_Label_88AD
    LDA $DF
    CMP #$3F
    BEQ Bank2_Label_886E

Bank2_Label_88AD:
    LDA #$02
    STA a:$06F9,Y
    LDA #$00
    STA a:$0703,Y
    LDA #$A0
    STA a:$0701,Y
    LDA a:World3EntityType,X
    CMP #$04
    BNE Bank2_Label_88C6
    JSR Bank2_Func_9114

Bank2_Label_88C6:
    LDA a:World3EntityType,X
    CMP #$0A
    BEQ Bank2_Label_88D1
    CMP #$0B
    BNE Bank2_Label_88D6

Bank2_Label_88D1:
    LDA #$03
    JSR Bank2_Func_A5EB

Bank2_Label_88D6:
    LDA a:$0698,X
    BEQ Bank2_Label_886E
    LDA a:World3EntityType,X
    CMP #$0C
    BCC Bank2_Label_88E6
    CMP #$10
    BCC Bank2_Label_88EE

Bank2_Label_88E6:
    LDA a:World3EntityX,X
    EOR #$04
    STA a:World3EntityX,X

Bank2_Label_88EE:
    DEC a:$0698,X
    BNE Bank2_Label_896C
    LDA a:World3EntityType,X
    CMP #$08
    BNE Bank2_Label_8939
    LDA #$01
    STA a:AudioMusicControl
    LDA #$04
    JSR Bank2_Func_A5EB
    LDA #$28
    STA $A6
    JSR Bank2_Func_86C4
    JSR Bank2_Func_8733
    JSR Bank2_Func_875C
    LDA $DF
    CMP #$27
    BEQ Bank2_Label_8924
    CMP #$28
    BEQ Bank2_Label_892B
    CMP #$34
    BEQ Bank2_Label_8932
    LDA #$00
    JMP Bank2_Func_AF51

Bank2_Label_8924:
    LDA #$01
    STA $58
    JMP Bank2_Label_895C

Bank2_Label_892B:
    LDA #$01
    STA $59
    JMP Bank2_Label_895C

Bank2_Label_8932:
    LDA #$01
    STA $5A
    JMP Bank2_Label_895C

Bank2_Label_8939:
    LDA a:World3EntityType,X
    CMP #$0C
    BCC Bank2_Label_895C
    CMP #$10
    BCS Bank2_Label_895C
    LDA #$01
    STA a:AudioMusicControl
    LDA #$04
    JSR Bank2_Func_A5EB
    LDA #$28
    STA $A6
    JSR Bank2_Func_86C4
    JSR Bank2_Func_8733
    LDA #$46
    STA $4F

Bank2_Label_895C:
    LDX $5C
    JSR Bank2_Func_897C
    LDA a:World3EntityType,X
    TAY
    LDA a:$8F35,Y
    JSR Bank2_Func_898C
    RTS

Bank2_Label_896C:
    LDA #$03
    JSR Bank2_Func_A5DF
    RTS

Bank2_Func_8972:
    TXA
    PHA
    TYA
    TAX
    JSR Bank2_Func_897C
    PLA
    TAX
    RTS

Bank2_Func_897C:
    LDA #$05
    STA a:World3EntityState,X
    LDA #$6C
    STA a:World3EntityMetasprite,X
    LDA #$05
    JSR Bank2_Func_A5DF
    RTS

Bank2_Func_898C:
    STX $5B
    LDX $07
    STX $5D
    LDX $DC
    BNE Bank2_Label_8999
    JSR Bank2_Func_81C9

Bank2_Label_8999:
    LDX $5D
    STX $07
    LDX $5B
    RTS

Bank2_Label_89A0:
    RTS

Bank2_Func_89A1:
    LDA a:World3EntityState,X
    CMP #$01
    BNE Bank2_Label_89A0
    LDA a:World3EntityX,X
    SEC
    SBC $8C
    JSR Bank2_Func_B149
    CMP #$0D
    BCS Bank2_Label_89A0
    LDA a:World3EntityY,X
    SEC
    SBC #$04
    SEC
    SBC $8D
    JSR Bank2_Func_B149
    CMP #$11
    BCS Bank2_Label_89A0
    LDA a:World3EntityType,X
    CMP #$06
    BNE Bank2_Label_89EA
    LDA a:World3EntityMetasprite,X
    CMP #$20
    BEQ Bank2_Label_89E7
    JSR Bank2_Func_897C
    LDA a:World3EntityType,X
    TAY
    LDA a:$8F35,Y
    JSR Bank2_Func_898C
    LDA $A8
    BEQ Bank2_Label_89E6
    DEC $A8

Bank2_Label_89E6:
    RTS

Bank2_Label_89E7:
    JMP Bank2_Label_8AEC

Bank2_Label_89EA:
    CMP #$07
    BNE Bank2_Label_8A28
    LDA #$0A
    JSR Bank2_Func_A5EB
    JSR Bank2_Func_86C4
    JSR Bank2_Func_897C
    LDA a:World3EntityType,X
    TAY
    LDA a:$8F35,Y
    JSR Bank2_Func_898C
    LDA #$0E
    JSR Bank2_Func_A5EB
    LDA $DF
    CMP #$26
    BEQ Bank2_Label_8A17
    CMP #$3B
    BEQ Bank2_Label_8A1C
    LDA #$01
    JMP Bank2_Func_AF51

Bank2_Label_8A17:
    INC $56
    JMP Bank2_Label_8A1E

Bank2_Label_8A1C:
    INC $57

Bank2_Label_8A1E:
    LDA $2C
    BEQ Bank2_Label_8A27
    DEC $2C
    JSR Bank2_Func_A213

Bank2_Label_8A27:
    RTS

Bank2_Label_8A28:
    CMP #$18
    BCC Bank2_Label_8A60
    JSR Bank2_Func_A5F7
    AND #$40
    BNE Bank2_Label_8A36
    STA $62

Bank2_Label_8A35:
    RTS

Bank2_Label_8A36:
    LDA $62
    BNE Bank2_Label_8A35
    LDA $9A
    BNE Bank2_Label_8A48
    LDA #$01
    STA $9A
    STA a:$0678,X
    JMP Bank2_Label_8A54

Bank2_Label_8A48:
    LDA a:$0678,X
    BEQ Bank2_Label_8A5B
    LDA #$00
    STA $9A
    STA a:$0678,X

Bank2_Label_8A54:
    INC $62
    LDA #$08
    JSR Bank2_Func_A5EB

Bank2_Label_8A5B:
    RTS

Bank2_Label_8A5C:
    RTS

Bank2_Label_8A5D:
    JMP Bank2_Label_8AEC

Bank2_Label_8A60:
    CMP #$10
    BCC Bank2_Label_8A5D
    CMP #$14
    BCS Bank2_Label_8A5C
    CMP #$10
    BNE Bank2_Label_8A87
    JSR Bank2_Func_897C
    LDA a:World3EntityType,X
    TAY
    LDA a:$8F35,Y
    JSR Bank2_Func_898C
    LDA #$01
    STA $CB
    LDA #$00
    STA $CC
    LDA #$01
    STA a:AudioMusicControl
    RTS

Bank2_Label_8A87:
    CMP #$11
    BNE Bank2_Label_8AB7
    JSR Bank2_Func_897C
    LDA a:World3EntityType,X
    TAY
    LDA a:$8F35,Y
    JSR Bank2_Func_898C
    LDA #$0E
    JSR Bank2_Func_A5EB
    LDA #$08
    SEC
    SBC $2C
    ASL A
    ASL A
    STA $3E
    LDA #$10
    STA $3F

Bank2_Label_8AAA:
    LDA $2B
    CMP $3E
    BEQ Bank2_Label_8AB6
    INC $2B
    DEC $3F
    BNE Bank2_Label_8AAA

Bank2_Label_8AB6:
    RTS

Bank2_Label_8AB7:
    CMP #$12
    BNE Bank2_Label_8AD7
    JSR Bank2_Func_897C
    LDA a:World3EntityType,X
    TAY
    LDA a:$8F35,Y
    JSR Bank2_Func_898C
    LDA #$13
    JSR Bank2_Func_A5EB
    INC $4D
    JSR Bank2_Func_8733
    LDA #$04
    STA $A4
    RTS

Bank2_Label_8AD7:
    JSR Bank2_Func_897C
    LDA a:World3EntityType,X
    TAY
    LDA a:$8F35,Y
    JSR Bank2_Func_898C
    LDA #$0E
    JSR Bank2_Func_A5EB
    INC $4D
    RTS

Bank2_Label_8AEC:
    LDA $8E
    CMP #$01
    BNE Bank2_Label_8B67
    LDA $CB
    BNE Bank2_Label_8B67
    LDA a:World3EntityType,X
    TAY
    CMP #$05
    BEQ Bank2_Label_8B67
    LDA $2B
    SEC
    SBC a:$8F15,Y
    BCS Bank2_Label_8B08
    LDA #$00

Bank2_Label_8B08:
    STA $2B
    LDA $2B
    BNE Bank2_Label_8B4E
    LDA #$04
    STA $8E
    LDA #$0B
    STA $90
    LDA #$00
    STA $91
    LDA #$00
    STA $93
    LDA #$00
    STA $97
    LDA #$00
    STA $9A
    LDA $8C
    STA $4B
    LDA $8D
    STA $4C
    JSR World3_SaveRoomObjectsState0
    JSR World3_SaveRoomObjectsState1
    LDY #$00

Bank2_Label_8B36:
    LDA #$00
    STA a:World3RoomObjectState,Y
    INY
    CPY #$0D
    BNE Bank2_Label_8B36
    LDA #$00
    STA a:$06F9
    STA a:$06FA
    LDA #$08
    STA a:AudioMusicState
    RTS

Bank2_Label_8B4E:
    LDA #$03
    STA $8E
    LDA #$00
    STA $9B
    LDA #$0B
    STA $90
    LDA #$00
    STA $91
    LDA #$00
    STA $93
    LDA #$0F
    JSR Bank2_Func_A5EB

Bank2_Label_8B67:
    RTS
