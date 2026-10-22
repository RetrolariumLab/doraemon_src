; Bank 1 NMI, RESET, and IRQ vectors
; PRG bank 1, original CPU range $FFFA-$FFFF

Bank1_NmiVector:
    .addr Bank1_Nmi

Bank1_ResetVector:
    .addr Bank1_Reset

Bank1_IrqVector:
    .addr Bank1_Reset
