; Doraemon PRG bank 0 $FFFA-$FFFF
; Bank 0 NMI, RESET, and IRQ vectors
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank0_NmiVector:
    .addr Bank0_Nmi

Bank0_ResetVector:
    .addr Bank0_Reset

Bank0_IrqVector:
    .addr Bank0_Reset
