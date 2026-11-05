; Keep the original public and address-based labels in each bank

.macro SfxCoreEntry name
    ::.ident(.concat(SfxCorePrefix, .string(name))):
name:
.endmacro

.macro SfxCoreLocal name, lastBank
    .if SfxBank <= lastBank
        ::.ident(.sprintf("Bank%d_Label_%04X", SfxBank, SfxCoreCpuBase + (* - SfxCoreStart))):
    .endif
name:
.endmacro
