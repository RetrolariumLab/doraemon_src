; Bank 0 music engine configuration
.define MusicPrefix "World1_"
.define MusicCmdPrefix "World1_MusicCmd_"
.scope Bank0Music
MusicBank = 0
MusicCpuBase = $E9FD
TrackIdLimit = $09
GlobalPitchOffsets = $3E

ApplyMusicControl = ::Bank0_Label_E9C9
RefreshIdleEnvelopes = ::Bank0_Label_E9EE
ResetApuChannels = ::World1_Audio_ResetChannels
TrackHeaderIndexBase = ::World1_MusicTrackHeaderIndexBase
TrackHeaders = ::World1_MusicTrackHeaders
EnvelopeStepTable = ::Bank0_Label_EEFB
LengthBitsTable = ::Bank0_Label_EECB
NoiseRegisterTable = ::Bank0_Label_EEDB
FixedPitchOffsets = ::Bank0_Label_EEC8
PitchPeriodTable = ::Bank0_Label_EE34

    .include "../audio/music_engine_shared.inc"
.endscope
.undefine MusicCmdPrefix
.undefine MusicPrefix
