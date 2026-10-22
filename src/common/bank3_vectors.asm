; Bank 3 NMI, RESET, and IRQ vectors
; PRG bank 3, original CPU range $FFFA-$FFFF

Bank3_NmiVector:
    .addr Bank3_Nmi

Bank3_ResetVector:
    .addr Bank3_Reset

Bank3_IrqVector:
    .addr Bank3_Reset
