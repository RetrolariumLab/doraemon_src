; Bank 3 boot runtime and bank-local dispatch slots at $8271-$827C
.define BootPrefix "Bank3_"
.define ScorePrefix "Bank3_"
.scope Bank3Boot
PrimaryEntryDispatch = ::Bank3_PrimaryEntryDispatch
NmiFrameDispatch = ::Bank3_NmiFrameDispatch
SecondaryEntryDispatch = ::Bank3_SecondaryEntryDispatch
AudioFrameDispatch = ::Bank3_AudioFrameDispatch
    .include "boot_runtime.inc"
.endscope
.undefine ScorePrefix
.undefine BootPrefix

Bank3_PrimaryEntryDispatch:
    JMP Bank3_ShellMain

Bank3_NmiFrameDispatch:
    JMP Shell_NmiFrameServices

Bank3_SecondaryEntryDispatch:
    JMP Shell_ShowStatusScreen

Bank3_AudioFrameDispatch:
    JMP Audio_UpdateFrame
