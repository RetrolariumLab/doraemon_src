; Doraemon PRG bank 0 $95CB-$9909
; World 1 frame synchronization, PPU preparation, and sprite traversal
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank0_Func_95CB:
    LDA $65
    AND #$10
    BEQ Bank0_Label_95EC
    LDA #$01
    STA a:AudioMusicControl
    LDA #$06
    JSR World1_Audio_QueueEffect

Bank0_Label_95DB:
    JSR Bank0_Func_94F1
    JSR Bank0_Func_8490
    LDA $65
    AND #$10
    BEQ Bank0_Label_95DB
    LDA #$00
    STA a:AudioMusicControl

Bank0_Label_95EC:
    RTS

Bank0_Func_95ED:
    JSR Bank0_Func_8131
    JSR Bank0_WaitForVblank
    LDA #$01
    STA NmiOamDmaRequest
    LDA PpuScrollXShadow
    STA a:PPU_SCROLL
    LDA PpuScrollYShadow
    STA a:PPU_SCROLL
    LDA PpuCtrlShadow
    ORA #$80
    STA PpuCtrlShadow
    STA a:PPU_CTRL
    JSR Bank0_Func_94F1
    LDA PpuMaskShadow
    ORA #$18
    STA PpuMaskShadow
    RTS

Bank0_Func_9614:
    LDA PpuCtrlShadow
    ORA #$80
    STA PpuCtrlShadow
    STA a:PPU_CTRL
    LDA PpuMaskShadow
    AND #$E7
    STA PpuMaskShadow
    LDA #$01
    STA NmiOamDmaRequest
    JSR Bank0_Func_94F1
    LDA #$00
    STA NmiOamDmaRequest
    RTS

Bank0_Func_962F:
    INC $53
    DEC $52
    LDA FrameCounter
    EOR #$F0
    EOR $52
    STA $52
    LDA FrameCounter
    EOR #$AA
    ROR A
    ROR A
    ROR A
    EOR $53
    STA $53
    ROR A
    EOR $52
    RTS

Bank0_Func_964A:
    LDA $54
    ROL A
    ROL A
    EOR #$41
    ROL A
    ROL A
    EOR #$93
    ADC $55
    STA $54
    ROL A
    ROL A
    EOR #$12
    ROL A
    ROL A
    ADC $56
    STA $55
    ADC $54
    INC $56
    BNE Bank0_Label_9671
    PHA
    LDA $57
    CLC
    ADC #$1D
    STA $57
    PLA

Bank0_Label_9671:
    EOR $57
    RTS

Bank0_Func_9674:
    LDA FrameCounter
    AND #$01
    BNE Bank0_Label_968D
    JSR Bank0_Func_96BC
    JSR Bank0_Func_96A0
    JSR World1_RenderEntitySlots38_47
    JSR World1_RenderEntitySlots30_37
    JSR World1_RenderEntitySlots00_09
    JSR World1_RenderEntitySlots10_29
    RTS

Bank0_Label_968D:
    JSR Bank0_Func_96A0
    JSR World1_RenderEntitySlots10_29
    JSR World1_RenderEntitySlots00_09
    JSR World1_RenderEntitySlots30_37
    JSR World1_RenderEntitySlots38_47
    JSR Bank0_Func_96BC
    RTS

Bank0_Func_96A0:
    LDA World1PlayerDamageState
    LDA World1PlayerX
    STA World1MetaspriteOriginX
    LDA World1PlayerY
    STA World1MetaspriteOriginY
    LDA #$00
    STA World1MetaspriteOriginXHigh
    STA World1MetaspriteOriginYHigh
    LDA World1PlayerMetasprite
    STA World1MetaspriteIndex
    LDA World1PlayerRenderFlags
    STA World1MetaspriteRenderFlags
    JSR World1_ComposeMetasprite
    RTS

Bank0_Func_96BC:
    LDY #$00
    LDA #$5C
    STA World1OamX
    LDA #$18
    STA World1OamY
    LDA #$00
    STA World1OamAttributes

Bank0_Label_96CA:
    LDA a:ScoreDigitsWorking,Y
    BNE Bank0_Label_96DB
    LDA World1OamX
    CLC
    ADC #$08
    STA World1OamX
    INY
    CPY #$06
    BNE Bank0_Label_96CA

Bank0_Label_96DB:
    LDA a:ScoreDigitsWorking,Y
    AND #$0F
    ORA #$30
    STA World1OamTile
    JSR World1_EmitOamEntry
    LDA World1OamX
    CLC
    ADC #$08
    STA World1OamX
    INY
    CPY #$07
    BNE Bank0_Label_96DB
    LDA #$32
    STA World1OamY
    LDA #$E6
    STA World1OamX
    LDA #$00
    STA World1OamAttributes
    LDA #$3A
    STA World1OamTile
    JSR World1_EmitOamEntry
    LDA #$F0
    STA World1OamX
    LDA PlayerLives
    AND #$0F
    ORA #$30
    STA World1OamTile
    JSR World1_EmitOamEntry
    LDA PlayerHealthCapacityIndex
    ASL A
    ASL A
    CLC
    ADC #$50
    STA World1OamY
    LDA #$EC
    STA World1OamX
    LDA #$00
    STA World1OamAttributes
    LDA #$04
    STA $0A
    LDA PlayerHealth
    STA World1OamTile
    LDY #$07

Bank0_Label_9730:
    LDA World1OamTile
    SEC
    SBC #$04
    BCC Bank0_Label_9743
    STA World1OamTile
    LDA #$3F
    STA a:$000A,Y
    DEY
    BPL Bank0_Label_9730
    BMI Bank0_Label_9754

Bank0_Label_9743:
    CLC
    ADC #$3F
    STA a:$000A,Y
    DEY
    BMI Bank0_Label_9754
    LDA #$3B

Bank0_Label_974E:
    STA a:$000A,Y
    DEY
    BPL Bank0_Label_974E

Bank0_Label_9754:
    LDY PlayerHealthCapacityIndex

Bank0_Label_9756:
    LDA a:$000A,Y
    STA World1OamTile
    JSR World1_EmitOamEntry
    LDA World1OamY
    CLC
    ADC #$08
    STA World1OamY
    INY
    CPY #$08
    BNE Bank0_Label_9756
    LDA FrameCounter
    AND #$10
    BEQ Bank0_Label_978E
    LDA #$E8
    STA World1MetaspriteOriginX
    LDA #$96
    STA World1MetaspriteOriginY
    LDA #$00
    STA World1MetaspriteOriginXHigh
    STA World1MetaspriteOriginYHigh
    LDA World1WeaponLevel
    BEQ Bank0_Label_978E
    CLC
    ADC #$29
    STA World1MetaspriteIndex
    LDA #$01
    STA World1MetaspriteRenderFlags
    JSR World1_ComposeMetasprite

Bank0_Label_978E:
    RTS

World1_RenderEntitySlots00_09:
    LDA World1EnemyFreezeActive
    BEQ Bank0_Label_979A
    LDA FrameCounter
    AND #$04
    BEQ Bank0_Label_979A
    RTS

Bank0_Label_979A:
    LDA FrameCounter
    AND #$01
    BNE Bank0_Label_97BB
    LDA #$00
    STA $0A

Bank0_Label_97A4:
    LDY $0A
    LDA a:World1EntityType,Y
    BEQ Bank0_Label_97B2
    JSR Bank0_Func_97D2
    LDA World1OamWriteIndex
    BMI Bank0_Label_97D1

Bank0_Label_97B2:
    INC $0A
    LDA $0A
    CMP #$0A
    BNE Bank0_Label_97A4
    RTS

Bank0_Label_97BB:
    LDA #$09
    STA $0A

Bank0_Label_97BF:
    LDY $0A
    LDA a:World1EntityType,Y
    BEQ Bank0_Label_97CD
    JSR Bank0_Func_97D2
    LDA World1OamWriteIndex
    BMI Bank0_Label_97D1

Bank0_Label_97CD:
    DEC $0A
    BPL Bank0_Label_97BF

Bank0_Label_97D1:
    RTS

Bank0_Func_97D2:
    LDA a:World1EntityType,Y
    CMP #$D0
    BCC Bank0_Label_97E0
    LDA FrameCounter
    AND #$04
    BEQ Bank0_Label_97E0
    RTS

Bank0_Label_97E0:
    LDA a:World1EntityPositionHigh,Y
    STA World1MetaspriteOriginXHigh
    LSR A
    LSR A
    STA World1MetaspriteOriginYHigh
    LDA a:World1EntityX,Y
    STA World1MetaspriteOriginX
    LDA a:World1EntityY,Y
    STA World1MetaspriteOriginY
    LDA a:World1EntityRenderFlags,Y
    STA World1MetaspriteRenderFlags
    LDA a:World1EntityMetasprite,Y
    STA World1MetaspriteIndex
    JSR World1_ComposeMetasprite
    RTS

World1_RenderEntitySlots10_29:
    LDA World1EnemyFreezeActive
    BEQ Bank0_Label_980C
    LDA FrameCounter
    AND #$04
    BNE Bank0_Label_980C
    RTS

Bank0_Label_980C:
    LDA #$00
    STA World1MetaspriteOriginXHigh
    STA World1MetaspriteOriginYHigh
    LDA FrameCounter
    AND #$01
    BNE Bank0_Label_9833
    LDA #$00
    STA $0A

Bank0_Label_981C:
    LDY $0A
    LDA a:World1EntityType+$0A,Y
    BEQ Bank0_Label_982A
    JSR Bank0_Func_984A
    LDA World1OamWriteIndex
    BMI Bank0_Label_9849

Bank0_Label_982A:
    INC $0A
    LDA $0A
    CMP #$14
    BNE Bank0_Label_981C
    RTS

Bank0_Label_9833:
    LDA #$13
    STA $0A

Bank0_Label_9837:
    LDY $0A
    LDA a:World1EntityType+$0A,Y
    BEQ Bank0_Label_9845
    JSR Bank0_Func_984A
    LDA World1OamWriteIndex
    BMI Bank0_Label_9849

Bank0_Label_9845:
    DEC $0A
    BPL Bank0_Label_9837

Bank0_Label_9849:
    RTS

Bank0_Func_984A:
    LDA a:World1EntityPositionHigh+$0A,Y
    STA World1MetaspriteOriginXHigh
    LSR A
    LSR A
    STA World1MetaspriteOriginYHigh
    LDA a:World1EntityX+$0A,Y
    STA World1MetaspriteOriginX
    LDA a:World1EntityY+$0A,Y
    STA World1MetaspriteOriginY
    LDA a:World1EntityRenderFlags+$0A,Y
    STA World1MetaspriteRenderFlags
    LDA a:World1EntityMetasprite+$0A,Y
    STA World1MetaspriteIndex
    JMP World1_ComposeMetasprite

World1_RenderEntitySlots30_37:
    LDA #$00
    STA World1MetaspriteOriginXHigh
    STA World1MetaspriteOriginYHigh
    LDA FrameCounter
    AND #$01
    BNE Bank0_Label_9891
    LDA #$00
    STA $0A

Bank0_Label_987A:
    LDY $0A
    LDA a:World1EntityType+$1E,Y
    BEQ Bank0_Label_9888
    JSR Bank0_Func_98A8
    LDA World1OamWriteIndex
    BMI Bank0_Label_98A7

Bank0_Label_9888:
    INC $0A
    LDA $0A
    CMP #$08
    BNE Bank0_Label_987A
    RTS

Bank0_Label_9891:
    LDA #$07
    STA $0A

Bank0_Label_9895:
    LDY $0A
    LDA a:World1EntityType+$1E,Y
    BEQ Bank0_Label_98A3
    JSR Bank0_Func_98A8
    LDA World1OamWriteIndex
    BMI Bank0_Label_98A7

Bank0_Label_98A3:
    DEC $0A
    BPL Bank0_Label_9895

Bank0_Label_98A7:
    RTS

Bank0_Func_98A8:
    LDA a:World1EntityPositionHigh+$1E,Y
    STA World1MetaspriteOriginXHigh
    LSR A
    LSR A
    STA World1MetaspriteOriginYHigh
    LDA a:World1EntityX+$1E,Y
    STA World1MetaspriteOriginX
    LDA a:World1EntityY+$1E,Y
    STA World1MetaspriteOriginY
    LDA a:World1EntityRenderFlags+$1E,Y
    STA World1MetaspriteRenderFlags
    LDA a:World1EntityMetasprite+$1E,Y
    STA World1MetaspriteIndex
    JMP World1_ComposeMetasprite

World1_RenderEntitySlots38_47:
    LDA #$00
    STA World1MetaspriteOriginXHigh
    STA World1MetaspriteOriginYHigh
    LDA FrameCounter
    AND #$01
    BNE Bank0_Label_98F1
    LDA #$00
    STA $0A

Bank0_Label_98D8:
    LDY $0A
    LDA a:World1EntityType+$26,Y
    BMI Bank0_Label_98E8
    BEQ Bank0_Label_98E8
    JSR Bank0_Func_990A
    LDA World1OamWriteIndex
    BMI Bank0_Label_9909

Bank0_Label_98E8:
    INC $0A
    LDA $0A
    CMP #$0A
    BNE Bank0_Label_98D8
    RTS

Bank0_Label_98F1:
    LDA #$09
    STA $0A

Bank0_Label_98F5:
    LDY $0A
    LDA a:World1EntityType+$26,Y
    BMI Bank0_Label_9905
    BEQ Bank0_Label_9905
    JSR Bank0_Func_990A
    LDA World1OamWriteIndex
    BMI Bank0_Label_9909

Bank0_Label_9905:
    DEC $0A
    BPL Bank0_Label_98F5

Bank0_Label_9909:
    RTS
