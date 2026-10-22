; World 2 APU tables, track headers, header-reachable streams, and adjacent unclassified data
; PRG bank 1, original CPU range $B11B-$B9CD

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
    .byte $13, $B3, $DB, $B3, $89, $B4, $CE, $B9, $5B, $B6, $08, $B6, $A9, $B6, $CE, $B9
    .byte $50, $B7, $A0, $B7, $EA, $B7, $CE, $B9, $42, $B8, $61, $B8, $80, $B8, $CE, $B9
    .byte $00, $B9, $26, $B9, $4B, $B9, $6D, $B9, $80, $B9, $9C, $B9, $AE, $B9, $CE, $B9
    .incbin "assets/generated/audio/music/prg1-b313.bin", $0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $10, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $20, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $30, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $40, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $50, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $60, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $70, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $80, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $90, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $A0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $B0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $C0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $D0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $E0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $F0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $100, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $110, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $120, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $130, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $140, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $150, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $160, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $170, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $180, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $190, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $1A0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $1B0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $1C0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $1D0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $1E0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $1F0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $200, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $210, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $220, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $230, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $240, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $250, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $260, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $270, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $280, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $290, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $2A0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $2B0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $2C0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $2D0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $2E0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $2F0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $300, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $310, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $320, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $330, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $340, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $350, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $360, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $370, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $380, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $390, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $3A0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $3B0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $3C0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $3D0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $3E0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $3F0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $400, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $410, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $420, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $430, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $440, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $450, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $460, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $470, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $480, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $490, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $4A0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $4B0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $4C0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $4D0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $4E0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $4F0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $500, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $510, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $520, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $530, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $540, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $550, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $560, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $570, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $580, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $590, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $5A0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $5B0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b313.bin", $5C0, $F  ; rom-asset .byte
    .byte $F9
    .byte $88, $22, $FA, $FF, $98, $21, $90, $21, $86, $21, $85, $22, $21, $86, $22, $85
    .byte $2D, $2E, $86, $39, $85, $3A, $2D, $86, $2E, $85, $21, $22, $F3
    .incbin "assets/generated/audio/music/prg1-b900.bin", $0, $3  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b900.bin", $3, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b900.bin", $13, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b900.bin", $23, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b900.bin", $33, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b900.bin", $43, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b900.bin", $53, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b900.bin", $63, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b900.bin", $73, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b900.bin", $83, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b900.bin", $93, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b900.bin", $A3, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b900.bin", $B3, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg1-b900.bin", $C3, $B  ; rom-asset .byte
