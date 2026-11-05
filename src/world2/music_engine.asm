; Bank 1 music engine configuration
.define MusicPrefix "World2_"
.define MusicCmdPrefix "World2_MusicCmd_"
.scope Bank1Music
MusicBank = 1
MusicCpuBase = $ACE4
TrackIdLimit = $07
GlobalPitchOffsets = $B5

ApplyMusicControl = ::Bank1_Label_ACB0
RefreshIdleEnvelopes = ::Bank1_Label_ACD5
ResetApuChannels = ::World2_Audio_ResetChannels
TrackHeaderIndexBase = ::World2_MusicTrackHeaderIndexBase
TrackHeaders = ::World2_MusicTrackHeaders
EnvelopeStepTable = ::Bank1_Label_B1E3
LengthBitsTable = ::Bank1_Label_B1B3
NoiseRegisterTable = ::Bank1_Label_B1C3
FixedPitchOffsets = ::Bank1_Label_B1AF
PitchPeriodTable = ::Bank1_Label_B11B

    .include "../audio/music_engine_shared.inc"
.endscope
.undefine MusicCmdPrefix
.undefine MusicPrefix
