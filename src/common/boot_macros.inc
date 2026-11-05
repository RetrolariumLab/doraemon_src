; Keep the bank-prefixed entry names as labels in the debug file
.macro BootEntry name, prefix
    .ifblank prefix
        ::.ident(.concat(BootPrefix, .string(name))):
    .else
        ::.ident(.concat(prefix, .string(name))):
    .endif
name:
.endmacro

.macro EmitBankVectors prefix, nmiEntry, resetEntry
    .assert * = $FFFA, lderror, "Interrupt vectors moved"
    .ident (.concat(prefix, "NmiVector")):
    .addr nmiEntry
    .ident (.concat(prefix, "ResetVector")):
    .addr resetEntry
    .ident (.concat(prefix, "IrqVector")):
    .addr resetEntry
.endmacro
