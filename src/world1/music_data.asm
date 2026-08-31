; Doraemon PRG bank 0 $EE34-$FFF9
; World 1 APU period tables, track headers, and music streams
; Generated deterministically from pinned Ghidra/GhidraNes facts

    .byte $00, $00, $AE, $06, $4E, $06, $F3, $05, $9F, $05, $4D, $05, $01, $05, $B9, $04
    .byte $75, $04, $35, $04, $F8, $03, $BF, $03, $89, $03, $57, $03, $27, $03, $F9, $02
    .byte $CF, $02, $A6, $02, $80, $02, $5C, $02, $3A, $02, $1A, $02, $FC, $01, $DF, $01
    .byte $C4, $01, $AB, $01, $93, $01, $7C, $01, $67, $01, $52, $01, $3F, $01, $2D, $01
    .byte $1C, $01, $0C, $01, $FD, $00, $EE, $00, $E1, $00, $D4, $00, $C8, $00, $BD, $00
    .byte $B2, $00, $A8, $00, $9F, $00, $96, $00, $8D, $00, $85, $00, $7E, $00, $76, $00
    .byte $70, $00, $69, $00, $63, $00, $5E, $00, $58, $00, $53, $00, $4F, $00, $4A, $00
    .byte $46, $00, $42, $00, $3E, $00, $3A, $00, $37, $00, $34, $00, $31, $00, $2E, $00
    .byte $2B, $00, $29, $00, $27, $00, $24, $00, $22, $00, $20, $00, $1E, $00, $1C, $00
    .byte $1B, $00, $19, $00, $F4, $F4, $00, $7F, $08, $60, $C0, $50, $40, $30, $B0, $28
    .byte $30, $24, $D0, $1E, $50, $18, $A0, $14, $20, $00, $F0, $00, $00, $06, $20, $01
    .byte $00, $0E, $20, $1C, $00, $02, $68, $00, $00, $04, $20, $00, $00, $0C, $20, $1A
    .byte $00, $04, $A8, $1A, $00, $04, $48, $7F, $7F, $40, $2A, $20, $19, $15, $12, $10
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
    .byte $01, $01, $01, $01, $01, $01, $01, $E2, $F9, $9F, $FA, $66, $FB, $2A, $FC, $3B
    .byte $F0, $69, $F0, $7B, $F0, $C2, $F0, $03, $F1, $0E, $F1, $15, $F1, $61, $F9, $4D
    .byte $F1, $00, $F2, $B4, $F2, $56, $F3, $B6, $F3, $B0, $F4, $75, $F5, $E0, $F5, $08
    .byte $F6, $39, $F7, $5A
    SED
    ADC ($F9,X)
    .byte $13, $F9, $2F, $F9, $41, $F9, $61, $F9, $62, $F9, $88, $F9, $AD, $F9, $CF, $F9
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $0, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $10, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $20, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $30, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $40, $5  ; rom-asset .byte
    BVS Bank0_Label_F082

Bank0_Label_F082:
    TAX
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $48, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $58, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $68, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $78, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $88, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $98, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C8, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $D8, $D  ; rom-asset .byte
    ROL a:$2E00
    AND a:$2D00
    AND a:$2D00
    BIT a:$2C00
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $F1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $101, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $111, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $121, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $131, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $141, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $151, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $161, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $171, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $181, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $191, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $1A1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $1B1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $1C1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $1D1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $1E1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $1F1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $201, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $211, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $221, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $231, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $241, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $251, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $261, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $271, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $281, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $291, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $2A1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $2B1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $2C1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $2D1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $2E1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $2F1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $301, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $311, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $321, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $331, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $341, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $351, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $361, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $371, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $381, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $391, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $3A1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $3B1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $3C1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $3D1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $3E1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $3F1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $401, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $411, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $421, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $431, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $441, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $451, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $461, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $471, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $481, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $491, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $4A1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $4B1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $4C1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $4D1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $4E1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $4F1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $501, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $511, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $521, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $531, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $541, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $551, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $561, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $571, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $581, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $591, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $5A1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $5B1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $5C1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $5D1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $5E1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $5F1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $601, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $611, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $621, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $631, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $641, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $651, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $661, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $671, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $681, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $691, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $6A1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $6B1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $6C1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $6D1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $6E1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $6F1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $701, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $711, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $721, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $731, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $741, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $751, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $761, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $771, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $781, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $791, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $7A1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $7B1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $7C1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $7D1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $7E1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $7F1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $801, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $811, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $821, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $831, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $841, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $851, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $861, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $871, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $881, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $891, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $8A1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $8B1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $8C1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $8D1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $8E1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $8F1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $901, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $911, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $921, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $931, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $941, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $951, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $961, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $971, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $981, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $991, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $9A1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $9B1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $9C1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $9D1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $9E1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $9F1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A01, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A11, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A21, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A31, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A41, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A51, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A61, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A71, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A81, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $A91, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $AA1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $AB1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $AC1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $AD1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $AE1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $AF1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B01, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B11, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B21, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B31, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B41, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B51, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B61, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B71, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B81, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $B91, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $BA1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $BB1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $BC1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $BD1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $BE1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $BF1, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C01, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C11, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C21, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C31, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C41, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C51, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C61, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C71, $10  ; rom-asset .byte
    .incbin "assets/generated/audio/music/prg0-f03b.bin", $C81, $3  ; rom-asset .byte
    .byte $15, $00, $01, $44, $0B, $05, $03, $04, $26, $02, $9E, $48, $03
    .byte $0A, $3A, $02, $01, $06, $12, $04, $02, $46, $1C, $02, $26, $04, $02, $06, $1D
    .byte $04, $0E, $01, $0B, $08, $04, $48, $08, $40, $12, $00, $61, $42, $0D, $08, $0F
    .byte $40, $36, $02, $0F, $00, $35, $41, $0F, $00, $22, $02, $2F, $40, $26, $01, $20
    .byte $40, $19, $02, $60, $40, $19, $08, $01, $41, $03, $41, $08, $40, $19, $00, $12
    .byte $04, $55, $05, $1C, $01, $10, $05, $01, $41, $09, $00, $06, $01, $0A, $40, $21
    .byte $00, $09, $01, $00, $00, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
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
    .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
