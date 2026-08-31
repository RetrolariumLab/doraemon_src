; Doraemon PRG bank 2 $FFFA-$FFFF
; Bank 2 NMI, RESET, and IRQ vectors
; Generated deterministically from pinned Ghidra/GhidraNes facts

Bank2_NmiVector:
    .addr Bank2_Nmi

Bank2_ResetVector:
    .addr Bank2_Reset

Bank2_IrqVector:
    .addr Bank2_Reset
