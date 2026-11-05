; PRG bank 2 APU helpers and local sound sequences at $C441-$C4F4

    EmitApuWrites "World3_", Bank2_Label_C447

.scope World3_SfxSequences
Pulse1:
    .byte $2C, $31, $2C, $31, $35, $38, $3D, $41, $FF
IndexedTonal:
    .byte $08, $2E, $2B, $27, $08, $30, $2C
    .byte $29, $08, $32, $2D, $2A, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E
    .byte $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E
    .byte $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E
    .byte $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $03, $35, $30, $2C, $03, $33, $2E
    .byte $2B, $03, $35, $30, $2C, $03, $33, $2E, $2B, $FF

.endscope

    EmitMusicChannelReset Bank2_Label_C4C1, World3_Audio_ResetChannels, Bank2_Label_C4E6, World3_Music_UpdateVolumeEnvelope
