; Bank 0 boot runtime and bank-local dispatch slots at $8271-$827C
.define BootPrefix "Bank0_"
.define ScorePrefix "World1_"
.scope Bank0Boot
PrimaryEntryDispatch = ::Bank0_PrimaryEntryDispatch
NmiFrameDispatch = ::Bank0_NmiFrameDispatch
SecondaryEntryDispatch = ::Bank0_SecondaryEntryDispatch
AudioFrameDispatch = ::Bank0_AudioFrameDispatch
    .include "boot_runtime.inc"
.endscope
.undefine ScorePrefix
.undefine BootPrefix

Bank0_PrimaryEntryDispatch:
    JMP Bank0_World1Main

Bank0_NmiFrameDispatch:
    JMP World1_NmiFrameServices

Bank0_SecondaryEntryDispatch:
    JMP World1_DemoEntry

Bank0_AudioFrameDispatch:
    JMP World1_Audio_UpdateFrameWithExtraLifeCue
