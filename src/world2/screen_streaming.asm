; Doraemon PRG bank 1 $827D-$8443
; World 2 stage sequence, compressed-screen selection, and row decoding control
; Generated deterministically from pinned Ghidra/GhidraNes facts

World2_CommitNmiPpuState:
    JSR World2_ApplyPendingBackgroundPalette

Bank1_Label_8280:
    LDA PpuMaskShadow

Bank1_Label_8283 = * + 1  ; overlapping entry $8283
    STA a:PPU_MASK
    .byte $A9

Bank1_PostSwitchWorld3TransitionEntry:
    BRK
    .byte $8D, $06, $20, $8D, $06, $20, $A5, $3F, $8D, $05, $20, $A5, $40, $8D, $05, $20
    .byte $A5, $19, $8D, $00, $20, $E6, $73, $60

World2_NmiFrameServices:
    LDA World2ScrollingActive
    BEQ World2_CommitNmiPpuState
    LDX $42
    BEQ Bank1_Label_8302
    DEX
    BEQ Bank1_Label_82D7
    LDX $44
    BEQ Bank1_Label_82B6
    DEX
    STX $44
    BNE Bank1_Label_82B6
    JSR World2_BeginScreenTransitionRows

Bank1_Label_82B6:
    LDA World2ScrollY
    CMP #$EF
    BNE Bank1_Label_82C0
    LDA #$FF
    STA World2ScrollY

Bank1_Label_82C0:
    INC World2ScrollY
    LDA World2ScrollY
    ASL A
    AND #$1E
    TAX
    LDA #$82
    PHA
    LDA #$7F
    PHA
    LDA a:$8872,X
    PHA
    LDA a:$8871,X
    PHA
    RTS

Bank1_Label_82D7:
    LDX $44
    BEQ Bank1_Label_82E3
    DEX
    STX $44
    BNE Bank1_Label_82E3
    JSR World2_BeginScreenTransitionRows

Bank1_Label_82E3:
    LDA World2ScrollY
    BNE Bank1_Label_82EB
    LDA #$F0
    STA World2ScrollY

Bank1_Label_82EB:
    DEC World2ScrollY
    LDA World2ScrollY
    ASL A
    AND #$1E
    TAX
    LDA #$82
    PHA
    LDA #$7F
    PHA
    LDA a:$8852,X
    PHA
    LDA a:$8851,X
    PHA
    RTS

Bank1_Label_8302:
    LDX $45
    BEQ Bank1_Label_8335
    DEX
    STX $45
    LDA PpuCtrlShadow
    PHA
    LDA World2ScrollX
    PHA
    LDA PpuCtrlShadow
    EOR #$01
    STA PpuCtrlShadow
    TXA
    EOR #$0F
    ORA #$F0
    STA World2ScrollX
    ASL A
    AND #$1E
    TAX
    JSR World2_DispatchFrameScreenService
    PLA
    STA World2ScrollX
    PLA
    STA PpuCtrlShadow
    JMP Bank1_Label_8280
    .byte $68, $85, $3F, $68, $85, $19, $4C, $80, $82

Bank1_Label_8335:
    INC World2ScrollX
    LDA World2ScrollX
    BNE Bank1_Label_8343
    PHA
    LDA PpuCtrlShadow
    EOR #$01
    STA PpuCtrlShadow
    PLA

Bank1_Label_8343:
    LDX $44
    BEQ Bank1_Label_8353
    DEX
    STX $44
    BNE Bank1_Label_8350
    LDA $43
    STA $42

Bank1_Label_8350:
    JMP Bank1_Label_8280

Bank1_Label_8353:
    ASL A
    AND #$1E
    TAX
    LDA #$82
    PHA
    LDA #$7F
    PHA

World2_DispatchFrameScreenService:
    LDA a:$8832,X
    PHA
    LDA a:$8831,X
    PHA

World2_ScreenService_NoOp:
    RTS

World2_BeginScreenTransitionRows:
    LDA $43
    STA $42
    LDA #$0F
    STA $45
    INC World2ScreenRowIndex
    RTS

World2_AdvanceScreenStage:
    JSR World2_AdvanceStageSequence
    LDA $43
    BEQ Bank1_Label_837C
    LDA #$0F
    STA $44

Bank1_Label_837C:
    RTS

World2_AdvanceStageSequence:
    INC World2ScreenRowIndex
    LDA World2ScreenRowIndex
    CMP #$10
    BNE Bank1_Label_837C

Bank1_Label_8385:
    LDA #$00
    STA World2ScreenStreamOffset
    STA World2ScreenRowIndex

Bank1_Label_838B:
    INC World2StageSequenceOffset
    LDY World2StageSequenceOffset
    LDA a:World2_StageSequenceData,Y
    CMP #$F0
    BCC World2_SelectCompressedScreen
    CMP #$F7
    BCS Bank1_Label_83A3
    AND #$03
    STA $43
    LDA #$0F
    STA World2ScreenRowIndex
    RTS

Bank1_Label_83A3:
    BEQ Bank1_Label_83B7
    CMP #$F8
    BEQ Bank1_Label_83B1
    AND #$07
    STA World2PendingBackgroundPalette
    STA World2SavedBackgroundPalette
    BNE Bank1_Label_838B

Bank1_Label_83B1:
    LDA #$00
    STA World2ScrollingActive
    BEQ Bank1_Label_838B

Bank1_Label_83B7:
    LDA World2SavedStageSequenceOffset
    STA World2StageSequenceOffset
    JMP Bank1_Label_838B

World2_SelectCompressedScreen:
    AND #$7F
    STA World2CurrentScreenId
    ASL A
    TAX
    LDA a:$BEDE,X
    STA World2ScreenStreamPointer
    LDA a:$BEDF,X
    STA World2ScreenStreamPointer+$01
    RTS

World2_DecodeScreenRow15:
    LDX #$00
    LDY World2ScreenStreamOffset

Bank1_Label_83D3:
    JSR World2_DecodeScreenToken
    CPX #$0F
    BCC Bank1_Label_83D3
    STY World2ScreenStreamOffset
    RTS

World2_AdvanceStreamedScreenRow:
    INC World2ScreenRowIndex
    LDA World2ScreenRowIndex
    CMP #$0E
    BNE Bank1_Label_83FE
    LDY World2StageSequenceOffset
    LDX a:$BDE0,Y
    CPX #$F0
    BCC Bank1_Label_83FE
    CPX #$F7
    BCS Bank1_Label_83FE
    TXA
    AND #$03
    STA $43
    LDA #$0F
    STA $44
    INC World2StageSequenceOffset

Bank1_Label_83FD:
    RTS

Bank1_Label_83FE:
    CMP #$0F
    BCC Bank1_Label_83FD
    JMP Bank1_Label_8385

World2_DecodeScreenRow16:
    LDX #$00
    LDY World2ScreenStreamOffset

Bank1_Label_8409:
    JSR World2_DecodeScreenToken
    CPX #$10
    BCC Bank1_Label_8409
    STY World2ScreenStreamOffset
    LDA World2ScrollY
    AND #$F0
    STA $51
    LDX #$04
    STX $52
    LDA PpuCtrlShadow
    AND #$01
    ORA #$08
    STA $49
    LDA World2ScrollY
    AND #$F0
    ASL A
    ROL $49
    ASL A
    ROL $49
    ORA #$20
    STA $48
    ASL A
    LDA $49
    ROL A
    ASL A
    ASL A
    ASL A
    ORA #$C0
    STA $4A
    LDA $49
    ORA #$03
    STA $4B
    RTS
