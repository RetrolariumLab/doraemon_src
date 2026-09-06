; Doraemon PRG bank 3 $8A17-$8A87
; Returning game-over presentation service
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank3_ShowGameOver:
    JSR Bank3_DisableRenderingForUpdate
    LDA #$03
    JSR Bank3_SelectChrBank
    JSR Shell_ClearBothNametables
    LDA #$21
    STA a:PPU_ADDR
    LDA #$EB
    STA a:PPU_ADDR
    LDX #$F7

Bank3_Label_8A2E:
    LDA a:$8988,X
    STA a:PPU_DATA
    INX
    BNE Bank3_Label_8A2E
    LDA #$00
    STA FrameCounter
    LDA #$86
    STA $01
    LDA #$30
    STA $00
    JSR Shell_CopyPaletteToStaging
    JSR Shell_UploadStagedPalette
    LDA #$00
    STA PpuScrollYShadow
    STA PpuScrollXShadow
    LDA #$01
    STA $09
    LDA #$04
    STA a:AudioMusicState
    JSR Bank3_EnableNmiAndRendering

Bank3_Label_8A5B:
    JSR Shell_PollTitleInputAndChapterSelect
    STA $00
    AND #$10
    BNE Bank3_Label_8A70
    LDA a:AudioMusicState
    BNE Bank3_Label_8A5B
    LDA #$00
    STA $3B

Bank3_Label_8A6D:
    JMP Bank3_ShellMain

Bank3_Label_8A70:
    LDA #$00
    STA a:AudioMusicState
    LDA $00
    AND #$0F
    BEQ Bank3_Label_8A6D
    JSR Bank3_DisableRenderingForUpdate
    RTS

Shell_GameOverText:
    .byte $47, $41, $4D, $45, $00, $4F, $56, $45, $52
