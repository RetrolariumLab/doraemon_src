; World 3 APU tables, track headers, header-reachable streams, and adjacent unclassified data
; PRG bank 2, original CPU range $C92C-$D66A

Bank2_Label_C92C:
    .byte $00, $00, $AE, $06, $4E, $06, $F3, $05, $9F, $05, $4D, $05, $01, $05, $B9, $04
    .byte $75, $04, $35, $04, $F8, $03, $BF, $03, $89, $03, $57, $03, $27, $03, $F9, $02
    .byte $CF, $02, $A6, $02, $80, $02, $5C, $02, $3A, $02, $1A, $02, $FC, $01, $DF, $01
    .byte $C4, $01, $AB, $01, $93, $01, $7C, $01, $67, $01, $52, $01, $3F, $01, $2D, $01
    .byte $1C, $01, $0C, $01, $FD, $00, $EE, $00, $E1, $00, $D4, $00, $C8, $00, $BD, $00
    .byte $B2, $00, $A8, $00, $9F, $00, $96, $00, $8D, $00, $85, $00, $7E, $00, $76, $00
    .byte $70, $00, $69, $00, $63, $00, $5E, $00, $58, $00, $53, $00, $4F, $00, $4A, $00
    .byte $46, $00, $42, $00, $3E, $00, $3A, $00, $37, $00, $34, $00, $31, $00, $2E, $00
    .byte $2B, $00, $29, $00, $27, $00, $24, $00, $22, $00, $20, $00, $1E, $00, $1C, $00
    .byte $1B, $00, $19, $00
Bank2_Label_C9C0:
    .byte $F4, $F4, $00
Bank2_Label_C9C3:
    .byte $7F, $08, $60, $C0, $50, $40, $30, $B0, $28
    .byte $30, $24, $D0, $1E, $50, $18, $A0
Bank2_Label_C9D3:
    .byte $14, $20, $00, $F0, $00, $00, $06, $20, $01
    .byte $00, $0E, $20, $1C, $00, $02, $68, $00, $00, $04, $20, $00, $00, $0C, $20, $1A
    .byte $00, $04, $A8, $1A, $00, $04, $48
Bank2_Label_C9F3:
    .byte $7F, $7F, $40, $2A, $20, $19, $15, $12, $10
    .byte $0E, $0C, $0B, $0A, $09, $09, $08, $08, $07, $07, $06, $06, $06, $05, $05, $05
    .byte $05, $04, $04, $04, $04, $04, $04, $04, $03, $03, $03, $03, $03, $03, $03, $03
    .byte $03, $03, $02, $02, $02, $02, $02, $03, $02, $02, $02, $02, $02, $02, $02, $02
    .byte $02, $02, $02, $02, $02, $02, $02, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01

World3_MusicTrackHeaderIndexBase:
    .byte $01

World3_MusicTrackHeaders:
    .addr World3_MusicStreams, World3_MusicStreams + $00A7
    .addr World3_MusicStreams + $017C, World3_MusicStreams + $0283
    .addr World3_MusicStreams + $03E5, World3_MusicStreams + $03F0
    .addr World3_MusicStreams + $03F7, World3_MusicStreams + $0B37
    .addr World3_MusicStreams + $042F, World3_MusicStreams + $044E
    .addr World3_MusicStreams + $046D, World3_MusicStreams + $0B37
    .addr World3_MusicStreams + $042F, World3_MusicStreams + $044E
    .addr World3_MusicStreams + $048E, World3_MusicStreams + $0B37
    .addr World3_MusicStreams + $050C, World3_MusicStreams + $0606
    .addr World3_MusicStreams + $06CB, World3_MusicStreams + $0736
    .addr World3_MusicStreams + $075E, World3_MusicStreams + $088F
    .addr World3_MusicStreams + $09B0, World3_MusicStreams + $0B37
    .addr World3_MusicStreams + $0A69, World3_MusicStreams + $0A8F
    .addr World3_MusicStreams + $0AB4, World3_MusicStreams + $0AD6
    .addr World3_MusicStreams + $0AE9, World3_MusicStreams + $0B05
    .addr World3_MusicStreams + $0B17, World3_MusicStreams + $0B37

World3_MusicStreams:
    .incbin "assets/generated/audio/music/prg2-cb33.bin"
.assert * - World3_MusicStreams = $0B38, error, "music slice size changed"
.assert World3_MusicStreams = $CB33, lderror, "music slice address changed"
