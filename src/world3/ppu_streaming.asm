; Doraemon PRG bank 2 $A5DF-$A8AF
; World 3 audio wrappers, nametable streaming, and PPU update preparation
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank2_Func_A5DF:
    STX $49
    STY $4A
    JSR World3_Audio_QueueEffectWithPriority
    LDX $49
    LDY $4A
    RTS

Bank2_Func_A5EB:
    STX $49
    STY $4A
    JSR World3_Audio_QueueEffect
    LDX $49
    LDY $4A
    RTS

Bank2_Func_A5F7:
    LDA $DC
    BNE Bank2_Label_A5FE
    LDA CombinedControllerButtons
    RTS

Bank2_Label_A5FE:
    LDA #$00
    RTS

Bank2_Func_A601:
    LDX $8C
    LDY $8D
    JSR Bank2_Func_A71A
    LDA $90
    CLC
    ADC $91
    STA $8F
    STA $79
    LDA #$00
    STA $7A
    JSR World3_ComposeMetasprite
    RTS

Bank2_Func_A619:
    LDA $89
    BEQ Bank2_Label_A639
    DEC $89
    LDA $DF
    STA $8B
    DEC $8B
    JSR Bank2_Func_A6E6
    JSR Bank2_Func_A6B5
    JSR Bank2_Func_A6BF
    JSR World3_SaveRoomObjectsState0
    DEC $DF
    JSR World3_SaveRoomObjectsState1
    JSR Bank2_Func_A733

Bank2_Label_A639:
    RTS

Bank2_Func_A63A:
    LDA $89
    CMP #$07
    BEQ Bank2_Label_A65C
    INC $89
    LDA $DF
    STA $8B
    INC $8B
    JSR Bank2_Func_A6E6
    JSR Bank2_Func_A6B5
    JSR Bank2_Func_A6BF
    JSR World3_SaveRoomObjectsState0
    INC $DF
    JSR World3_SaveRoomObjectsState1
    JSR Bank2_Func_A733

Bank2_Label_A65C:
    RTS

Bank2_Func_A65D:
    LDA $8A
    BEQ Bank2_Label_A687
    DEC $8A
    LDA $DF
    STA $8B
    LDA $8B
    SEC
    SBC #$08
    STA $8B
    JSR Bank2_Func_A6E6
    JSR Bank2_Func_A6B5
    JSR Bank2_Func_A6BF
    JSR World3_SaveRoomObjectsState0
    LDA $DF
    SEC
    SBC #$08
    STA $DF
    JSR World3_SaveRoomObjectsState1
    JSR Bank2_Func_A733

Bank2_Label_A687:
    RTS

Bank2_Func_A688:
    LDA $8A
    CMP #$07
    BEQ Bank2_Label_A6B4
    INC $8A
    LDA $DF
    STA $8B
    LDA $8B
    CLC
    ADC #$08
    STA $8B
    JSR Bank2_Func_A6E6
    JSR Bank2_Func_A6B5
    JSR Bank2_Func_A6BF
    JSR World3_SaveRoomObjectsState0
    LDA $DF
    CLC
    ADC #$08
    STA $DF
    JSR World3_SaveRoomObjectsState1
    JSR Bank2_Func_A733

Bank2_Label_A6B4:
    RTS

Bank2_Func_A6B5:
    LDA $8B
    CMP #$3F
    BNE Bank2_Label_A6BE
    JSR Bank2_Func_866C

Bank2_Label_A6BE:
    RTS

Bank2_Func_A6BF:
    LDA $8B
    CMP #$27
    BEQ Bank2_Label_A6CE
    CMP #$28
    BEQ Bank2_Label_A6D6
    CMP #$34
    BEQ Bank2_Label_A6DE

Bank2_Label_A6CD:
    RTS

Bank2_Label_A6CE:
    LDA $58
    BNE Bank2_Label_A6CD
    JSR Bank2_Func_866C
    RTS

Bank2_Label_A6D6:
    LDA $59
    BNE Bank2_Label_A6CD
    JSR Bank2_Func_866C
    RTS

Bank2_Label_A6DE:
    LDA $5A
    BNE Bank2_Label_A6CD
    JSR Bank2_Func_866C
    RTS

Bank2_Func_A6E6:
    LDY #$00
    STY $3E

Bank2_Label_A6EA:
    LDA a:World3RoomObjectRoom,Y
    CMP $8B
    BNE Bank2_Label_A6FA
    LDA a:World3RoomObjectType,Y
    CMP #$18
    BCC Bank2_Label_A6FA
    INC $3E

Bank2_Label_A6FA:
    INY
    CPY #$0D
    BNE Bank2_Label_A6EA
    LDA $3E
    CMP #$03
    BCC Bank2_Label_A719
    LDA $9A
    BEQ Bank2_Label_A719
    LDA #$00
    STA $9A
    LDY #$00

Bank2_Label_A70F:
    LDA #$00
    STA a:World3EntityPersistentState,Y
    INY
    CPY #$08
    BNE Bank2_Label_A70F

Bank2_Label_A719:
    RTS

Bank2_Func_A71A:
    LDA #$00
    CPX #$F8
    BCC Bank2_Label_A722
    LDA #$03

Bank2_Label_A722:
    STX $75
    STA $76
    LDA #$00
    CPY #$F8
    BCC Bank2_Label_A72E
    LDA #$03

Bank2_Label_A72E:
    STY $77
    STA $78
    RTS

Bank2_Func_A733:
    JSR Bank2_Func_A863
    JSR World3_DisableRendering
    LDA #$02
    JSR Bank2_SelectChrBank
    LDA #$90
    STA PpuCtrlShadow
    JSR Bank2_Func_A8EB
    JSR World3_LoadRoomPalette
    JSR World3_ClearPlayerProjectiles
    JSR World3_ClearEntityStorage
    JSR Bank2_Func_8C25
    JSR World3_MaterializeRoomObjects
    JSR Bank2_Func_AB53
    JSR Bank2_Func_ABF9
    LDA $A1
    BEQ Bank2_Label_A761
    JSR Bank2_Func_8817

Bank2_Label_A761:
    LDA $51
    BNE Bank2_Label_A78B
    LDA $DF
    CMP #$27
    BEQ Bank2_Label_A776
    CMP #$28
    BEQ Bank2_Label_A77D
    CMP #$34
    BEQ Bank2_Label_A784
    JMP Bank2_Label_A79C

Bank2_Label_A776:
    LDA $58
    BNE Bank2_Label_A78B
    JMP Bank2_Label_A79C

Bank2_Label_A77D:
    LDA $59
    BNE Bank2_Label_A78B
    JMP Bank2_Label_A79C

Bank2_Label_A784:
    LDA $5A
    BNE Bank2_Label_A78B
    JMP Bank2_Label_A79C

Bank2_Label_A78B:
    LDA $DF
    CMP #$27
    BEQ Bank2_Label_A799
    CMP #$28
    BEQ Bank2_Label_A799
    CMP #$34
    BNE Bank2_Label_A79C

Bank2_Label_A799:
    JSR Bank2_Func_875C

Bank2_Label_A79C:
    LDA $9F
    BEQ Bank2_Label_A7AB
    JSR Bank2_Func_97AF
    LDA $A0
    BNE Bank2_Label_A7AB
    LDA #$00
    STA $9F

Bank2_Label_A7AB:
    JSR Bank2_Func_B3FF
    JSR World3_EnableRendering
    JSR Bank2_Func_A8B0
    LDA #$00
    STA $73
    STA $74
    LDA #$00
    STA $CB
    STA $CC
    LDA #$00
    STA $CE
    STA $CF
    JSR Bank2_Func_A7E5
    LDA a:AudioMusicState
    AND #$7F
    CMP $A5
    BEQ Bank2_Label_A7DF
    CMP #$03
    BNE Bank2_Label_A7DA
    LDA $51
    BNE Bank2_Label_A7DF

Bank2_Label_A7DA:
    LDA $A5
    STA a:AudioMusicState

Bank2_Label_A7DF:
    LDA #$00
    STA a:AudioMusicControl
    RTS

Bank2_Func_A7E5:
    LDY $DF
    LDA a:$A7F1,Y
    TAY
    LDA a:$A831,Y
    STA $A5
    RTS
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $01, $01, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $02, $02, $02
    .byte $01, $01, $01, $01, $01, $02, $02, $02, $01, $01, $01, $01, $01, $02, $02, $03
    .byte $01, $02, $05, $06

World3_LoadRoomPalette:
    LDA #$00
    STA $40
    LDX $DF
    LDA a:World3_RoomPaletteSelector,X
    LSR A
    ROR $40
    LSR A
    ROR $40
    LSR A
    ROR $40
    STA $41
    LDA $40
    CLC
    ADC #$AE
    STA $40
    LDA $41
    ADC #$BC
    STA $41
    LDY #$00

Bank2_Label_A858:
    LDA ($40),Y
    STA a:$0705,Y
    INY
    CPY #$20
    BNE Bank2_Label_A858
    RTS

Bank2_Func_A863:
    LDX #$80
    LDY #$04
    STX $00
    STY $01
    LDX #$05
    LDY #$07
    STX $02
    STY $03
    LDA #$20
    STA $04
    JSR Bank2_Func_B1F1

Bank2_Label_A87A:
    LDX #$00
    STX $02

Bank2_Label_A87E:
    LDA a:World3PaletteShadow,X
    CMP #$0F
    BEQ Bank2_Label_A898
    INC $02
    TAY
    AND #$30
    BNE Bank2_Label_A891
    LDA #$0F
    JMP Bank2_Label_A895

Bank2_Label_A891:
    TYA
    SEC
    SBC #$10

Bank2_Label_A895:
    STA a:World3PaletteShadow,X

Bank2_Label_A898:
    INX
    CPX #$20
    BNE Bank2_Label_A87E
    LDX #$80
    LDY #$04
    JSR World3_QueuePalette
    LDA #$03
    STA World3FrameWaitCounter
    JSR World3_WaitFrames
    LDA $02
    BNE Bank2_Label_A87A
    RTS
