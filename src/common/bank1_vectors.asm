; Doraemon PRG bank 1 $FFFA-$FFFF
; Bank 1 NMI, RESET, and IRQ vectors
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank1_NmiVector:
    .addr Bank1_Nmi

Bank1_ResetVector:
    .addr Bank1_Reset

Bank1_IrqVector:
    .addr Bank1_Reset
