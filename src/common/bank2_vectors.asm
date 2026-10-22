; Bank 2 NMI, RESET, and IRQ vectors
; PRG bank 2, original CPU range $FFFA-$FFFF

Bank2_NmiVector:
    .addr Bank2_Nmi

Bank2_ResetVector:
    .addr Bank2_Reset

Bank2_IrqVector:
    .addr Bank2_Reset
