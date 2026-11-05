; Bank 2 boot runtime and bank-local dispatch slots at $8271-$827C
.define BootPrefix "Bank2_"
.define ScorePrefix "World3_"
.scope Bank2Boot
PrimaryEntryDispatch = ::Bank2_PrimaryEntryDispatch
NmiFrameDispatch = ::Bank2_NmiFrameDispatch
SecondaryEntryDispatch = ::Bank2_SecondaryEntryDispatch
AudioFrameDispatch = ::Bank2_AudioFrameDispatch
    .include "boot_runtime.inc"
.endscope
.undefine ScorePrefix
.undefine BootPrefix

Bank2_PrimaryEntryDispatch:
    JMP Bank2_World3Main

Bank2_NmiFrameDispatch:
    JMP World3_NmiFrameServices

Bank2_SecondaryEntryDispatch:
    JMP World3_DemoEntry

Bank2_AudioFrameDispatch:
    JMP World3_Audio_UpdateFrame
