; Bank 0 NMI, RESET, and IRQ vectors
; PRG bank 0, original CPU range $FFFA-$FFFF

Bank0_NmiVector:
    .addr Bank0_Nmi

Bank0_ResetVector:
    .addr Bank0_Reset

Bank0_IrqVector:
    .addr Bank0_Reset
