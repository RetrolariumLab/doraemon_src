; Bank 3 music engine configuration
.define MusicPrefix ""
.define MusicCmdPrefix "MusicCommand_"
.scope Bank3Music
MusicBank = 3
MusicCpuBase = $9ED8
TrackIdLimit = $05
GlobalPitchOffsets = $46

ApplyMusicControl = ::Bank3_Label_9EA4
RefreshIdleEnvelopes = ::Bank3_Label_9EC9
ResetApuChannels = ::Audio_ResetChannels
TrackHeaderIndexBase = ::MusicTrackHeaderIndexBase
TrackHeaders = ::MusicTrackHeaders
EnvelopeStepTable = ::Bank3_Label_A3D6
LengthBitsTable = ::Bank3_Label_A3A6
NoiseRegisterTable = ::Bank3_Label_A3B6
FixedPitchOffsets = ::Bank3_Label_A3A3
PitchPeriodTable = ::Bank3_Label_A30F

    .include "music_engine_shared.inc"
.endscope
.undefine MusicCmdPrefix
.undefine MusicPrefix
