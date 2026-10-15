; Doraemon PRG bank 0 $EE34-$FFF9
; World 1 APU tables, track headers, header-reachable streams, and adjacent unclassified data
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank0_Label_EE34:
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
Bank0_Label_EEC8:
    .byte $F4, $F4, $00
Bank0_Label_EECB:
    .byte $7F, $08, $60, $C0, $50, $40, $30, $B0, $28
    .byte $30, $24, $D0, $1E, $50, $18, $A0
Bank0_Label_EEDB:
    .byte $14, $20, $00, $F0, $00, $00, $06, $20, $01
    .byte $00, $0E, $20, $1C, $00, $02, $68, $00, $00, $04, $20, $00, $00, $0C, $20, $1A
    .byte $00, $04, $A8, $1A, $00, $04, $48
Bank0_Label_EEFB:
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

World1_MusicTrackHeaderIndexBase:
    .byte $01

World1_MusicTrackHeaders:
    .byte $E2, $F9, $9F, $FA, $66, $FB, $2A, $FC, $3B, $F0, $69, $F0, $7B, $F0, $C2, $F0
    .byte $03, $F1, $0E, $F1, $15, $F1, $61, $F9, $4D, $F1, $00, $F2, $B4, $F2, $56, $F3
    .byte $B6, $F3, $B0, $F4, $75, $F5, $E0, $F5, $08, $F6, $39, $F7, $5A, $F8, $61, $F9
    .byte $13, $F9, $2F, $F9, $41, $F9, $61, $F9, $62, $F9, $88, $F9, $AD, $F9, $CF, $F9
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $10, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $20, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $30, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $40, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $50, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $60, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $70, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $80, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $90, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $D0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $E0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $F0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $100, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $110, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $120, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $130, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $140, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $150, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $160, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $170, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $180, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $190, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $1A0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $1B0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $1C0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $1D0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $1E0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $1F0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $200, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $210, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $220, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $230, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $240, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $250, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $260, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $270, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $280, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $290, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $2A0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $2B0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $2C0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $2D0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $2E0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $2F0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $300, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $310, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $320, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $330, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $340, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $350, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $360, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $370, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $380, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $390, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $3A0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $3B0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $3C0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $3D0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $3E0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $3F0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $400, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $410, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $420, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $430, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $440, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $450, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $460, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $470, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $480, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $490, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $4A0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $4B0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $4C0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $4D0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $4E0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $4F0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $500, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $510, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $520, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $530, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $540, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $550, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $560, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $570, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $580, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $590, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $5A0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $5B0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $5C0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $5D0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $5E0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $5F0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $600, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $610, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $620, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $630, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $640, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $650, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $660, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $670, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $680, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $690, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $6A0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $6B0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $6C0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $6D0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $6E0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $6F0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $700, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $710, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $720, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $730, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $740, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $750, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $760, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $770, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $780, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $790, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $7A0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $7B0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $7C0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $7D0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $7E0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $7F0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $800, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $810, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $820, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $830, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $840, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $850, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $860, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $870, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $880, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $890, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $8A0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $8B0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $8C0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $8D0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $8E0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $8F0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $900, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $910, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $920, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $930, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $940, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $950, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $960, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $970, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $980, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $990, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $9A0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $9B0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $9C0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $9D0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $9E0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $9F0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A00, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A10, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A20, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A30, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A40, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A50, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A60, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A70, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A80, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A90, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $AA0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $AB0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $AC0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $AD0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $AE0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $AF0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B00, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B10, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B20, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B30, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B40, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B50, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B60, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B70, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B80, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B90, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $BA0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $BB0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $BC0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $BD0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $BE0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $BF0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C00, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C10, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C20, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C30, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C40, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C50, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C60, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C70, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C80, $4  ; rom-asset .byte
    .byte $15, $00, $01, $44, $0B, $05, $03, $04, $26, $02, $9E, $48
    .byte $03, $0A, $3A, $02, $01, $06, $12, $04, $02, $46, $1C, $02, $26, $04, $02, $06
    .byte $1D, $04, $0E, $01, $0B, $08, $04, $48, $08, $40, $12, $00, $61, $42, $0D, $08
    .byte $0F, $40, $36, $02, $0F, $00, $35, $41, $0F, $00, $22, $02, $2F, $40, $26, $01
    .byte $20, $40, $19, $02, $60, $40, $19, $08, $01, $41, $03, $41, $08, $40, $19, $00
    .byte $12, $04, $55, $05, $1C, $01, $10, $05, $01, $41, $09, $00, $06, $01, $0A, $40
    .byte $21, $00, $09, $01, $00, $00, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
