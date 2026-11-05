; Bank 2 music engine configuration
.define MusicPrefix "World3_"
.define MusicCmdPrefix "World3_MusicCmd_"
.scope Bank2Music
MusicBank = 2
MusicCpuBase = $C4F5
TrackIdLimit = $09
GlobalPitchOffsets = $D3

ApplyMusicControl = ::Bank2_Label_C4C1
RefreshIdleEnvelopes = ::Bank2_Label_C4E6
ResetApuChannels = ::World3_Audio_ResetChannels
TrackHeaderIndexBase = ::World3_MusicTrackHeaderIndexBase
TrackHeaders = ::World3_MusicTrackHeaders
EnvelopeStepTable = ::Bank2_Label_C9F3
LengthBitsTable = ::Bank2_Label_C9C3
NoiseRegisterTable = ::Bank2_Label_C9D3
FixedPitchOffsets = ::Bank2_Label_C9C0
PitchPeriodTable = ::Bank2_Label_C92C

    .include "../audio/music_engine_shared.inc"
.endscope
.undefine MusicCmdPrefix
.undefine MusicPrefix
