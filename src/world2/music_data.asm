; World 2 APU tables, track headers, header-reachable streams, and adjacent unclassified data
; PRG bank 1, original CPU range $B11B-$B9CE

Bank1_Label_B11B:
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
Bank1_Label_B1AF:
    .byte $F4, $F4, $00, $00
Bank1_Label_B1B3:
    .byte $7F, $08, $60, $C0, $50, $40, $30, $B0
    .byte $28, $30, $24, $D0, $1E, $50, $18, $A0
Bank1_Label_B1C3:
    .byte $14, $20, $00, $F0, $00, $00, $06, $20
    .byte $01, $00, $0E, $20, $1C, $00, $02, $68, $00, $00, $04, $20, $00, $00, $0C, $20
    .byte $1A, $00, $04, $A8, $1A, $00, $04, $48
Bank1_Label_B1E3:
    .byte $7F, $7F, $40, $2A, $20, $19, $15, $12
    .byte $10, $0E, $0C, $0B, $0A, $09, $09, $08, $08, $07, $07, $06, $06, $06, $05, $05
    .byte $05, $05, $04, $04, $04, $04, $04, $04, $04, $03, $03, $03, $03, $03, $03, $03
    .byte $03, $03, $03, $02, $02, $02, $02, $02, $03, $02, $02, $02, $02, $02, $02, $02
    .byte $02, $02, $02, $02, $02, $02, $02, $02, $01, $01, $01, $01, $01, $01, $01, $01
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
    .byte $01, $01, $01, $01, $01, $01, $01

World2_MusicTrackHeaderIndexBase:
    .byte $01

World2_MusicTrackHeaders:
    .addr World2_MusicStreams, World2_MusicStreams + $00C8
    .addr World2_MusicStreams + $0176, World2_MusicEndChannelByte
    .addr World2_MusicStreams + $0348, World2_MusicStreams + $02F5
    .addr World2_MusicStreams + $0396, World2_MusicEndChannelByte
    .addr World2_MusicStreams + $043D, World2_MusicStreams + $048D
    .addr World2_MusicStreams + $04D7, World2_MusicEndChannelByte
    .addr World2_MusicStreams + $052F, World2_MusicStreams + $054E
    .addr World2_MusicStreams + $056D, World2_MusicEndChannelByte
    .addr World2_MusicStreamsTail, World2_MusicStreamsTail + $0026
    .addr World2_MusicStreamsTail + $004B, World2_MusicStreamsTail + $006D
    .addr World2_MusicStreamsTail + $0080, World2_MusicStreamsTail + $009C
    .addr World2_MusicStreamsTail + $00AE, World2_MusicEndChannelByte

World2_MusicStreams:
    .incbin "assets/generated/audio/music/prg1-b313.bin"
.assert * - World2_MusicStreams = $05CF, error, "music slice size changed"
.assert World2_MusicStreams = $B313, lderror, "music slice address changed"

; Adjacent bytes outside the decoded stream ranges
    .byte $F9, $88, $22, $FA, $FF, $98, $21, $90, $21, $86, $21, $85, $22, $21, $86, $22
    .byte $85, $2D, $2E, $86, $39, $85, $3A, $2D, $86, $2E, $85, $21, $22, $F3

World2_MusicStreamsTail:
    .incbin "assets/generated/audio/music/prg1-b900.bin"
.assert * - World2_MusicStreamsTail = $00CF, error, "music slice size changed"
.assert World2_MusicStreamsTail = $B900, lderror, "music slice address changed"

; Ends track $06's triangle stream and serves as an empty noise stream
World2_MusicEndChannelByte = * - 1
