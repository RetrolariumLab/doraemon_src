; PRG bank 0 sound effect tables, dispatcher, and handlers at $E316-$E948

.define SfxCorePrefix "World1_"
.define SfxAssetStem "assets/generated/audio/sfx/prg0"
.scope Bank0Sfx
SfxBank = 0
SfxCoreCpuBase = $E398
SfxRequestLimit = $1A
SfxDispatchLimit = SfxRequestLimit * 4
SfxSavedX = $3C
SfxSavedY = SfxSavedX + 1
RequestPriority = AudioEffect_RequestPriority
EffectDispatchTable = AudioEffect_RtsDispatchTable

Apu_WritePulse1ControlSweep = ::World1_Apu_WritePulse1ControlSweep
Apu_WritePulse1Timer = ::World1_Apu_WritePulse1Timer
Apu_WritePulse2ControlSweep = ::World1_Apu_WritePulse2ControlSweep
Apu_WritePulse2Timer = ::World1_Apu_WritePulse2Timer
Apu_WriteTriangleControlTimer = ::World1_Apu_WriteTriangleControlTimer
ApuPulse1Return = ::Bank0_Label_E94F
MusicPitchPeriods = ::Bank0_Label_EE34
Pulse1Sequence = ::World1_SfxSequences::Pulse1
IndexedTonalSequence = ::World1_SfxSequences::IndexedTonal

    .include "../audio/sfx_world13_tables.inc"
    SfxCoreEntry Audio_QueueEffectWithPriority
    .include "../audio/sfx_dispatch_shared.inc"
    .include "../audio/sfx_handlers_shared.inc"
.endscope
.undefine SfxAssetStem
.undefine SfxCorePrefix
