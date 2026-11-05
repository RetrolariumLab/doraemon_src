; Preserve the original address-based labels in both world banks

.macro SfxHandlerLocal name
    ::.ident(.sprintf("Bank%d_Label_%04X", SfxBank, SfxCoreCpuBase + (* - SfxCoreStart))):
name:
.endmacro
