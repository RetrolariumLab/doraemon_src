; Doraemon PRG bank 3 $FFFA-$FFFF
; Bank 3 NMI, RESET, and IRQ vectors
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank3_NmiVector:
    .addr Bank3_Nmi

Bank3_ResetVector:
    .addr Bank3_Reset

Bank3_IrqVector:
    .addr Bank3_Reset
