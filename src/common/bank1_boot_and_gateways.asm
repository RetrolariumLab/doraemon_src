; Bank 1 boot runtime and bank-local dispatch slots at $8271-$827C
.define BootPrefix "Bank1_"
.define ScorePrefix "World2_"
.scope Bank1Boot
PrimaryEntryDispatch = ::Bank1_PrimaryEntryDispatch
NmiFrameDispatch = ::Bank1_NmiFrameDispatch
SecondaryEntryDispatch = ::Bank1_SecondaryEntryDispatch
AudioFrameDispatch = ::Bank1_AudioFrameDispatch
    .include "boot_runtime.inc"
.endscope
.undefine ScorePrefix
.undefine BootPrefix

Bank1_PrimaryEntryDispatch:
    JMP Bank1_World2Main

Bank1_NmiFrameDispatch:
    JMP World2_NmiFrameServices

Bank1_SecondaryEntryDispatch:
    JMP World2_DemoEntry

Bank1_AudioFrameDispatch:
    JMP World2_Audio_UpdateFrame
