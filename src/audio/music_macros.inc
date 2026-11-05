; Emit the original global labels alongside the shared names in each bank scope
.macro MusicEntry name, legacyCommand
    .ifblank legacyCommand
        ::.ident(.concat(MusicPrefix, .string(name))):
    .else
        ::.ident(.concat(MusicCmdPrefix, .string(legacyCommand))):
    .endif
name:
.endmacro

.macro MusicLocal name
    ::.ident(.sprintf("Bank%d_Label_%04X", MusicBank, MusicCpuBase + (* - Audio_UpdateMusic))):
name:
.endmacro
