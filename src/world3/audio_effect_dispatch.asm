; PRG bank 2 sound effect tables, dispatcher, and handlers at $BE0E-$C440

.define SfxCorePrefix "World3_"
.define SfxAssetStem "assets/generated/audio/sfx/prg2"
.scope Bank2Sfx
SfxBank = 2
SfxCoreCpuBase = $BE90
SfxRequestLimit = $1A
SfxDispatchLimit = SfxRequestLimit * 4
SfxSavedX = $D1
SfxSavedY = SfxSavedX + 1
RequestPriority = AudioEffect_RequestPriority
EffectDispatchTable = AudioEffect_RtsDispatchTable

Apu_WritePulse1ControlSweep = ::World3_Apu_WritePulse1ControlSweep
Apu_WritePulse1Timer = ::World3_Apu_WritePulse1Timer
Apu_WritePulse2ControlSweep = ::World3_Apu_WritePulse2ControlSweep
Apu_WritePulse2Timer = ::World3_Apu_WritePulse2Timer
Apu_WriteTriangleControlTimer = ::World3_Apu_WriteTriangleControlTimer
ApuPulse1Return = ::Bank2_Label_C447
MusicPitchPeriods = ::Bank2_Label_C92C
Pulse1Sequence = ::World3_SfxSequences::Pulse1
IndexedTonalSequence = ::World3_SfxSequences::IndexedTonal

    .include "../audio/sfx_world13_tables.inc"
    SfxCoreEntry Audio_QueueEffectWithPriority
    .include "../audio/sfx_dispatch_shared.inc"
    .include "../audio/sfx_handlers_shared.inc"
.endscope
.undefine SfxAssetStem
.undefine SfxCorePrefix
