; Evidence-backed Doraemon RAM aliases; unknown locations stay numeric

NmiOamDmaRequest       = $0014
NmiBusy                = $0015
FrameCounter           = $0016
MapperSelection        = $0017
ChrSelectionBits       = $0018
PpuCtrlShadow          = $0019
PpuMaskShadow          = $001A
PpuScrollXShadow       = $001B
PpuScrollYShadow       = $001C
Controller2Buttons     = $001D
Controller2ButtonsAlt  = $001E
Controller1Buttons     = $001F
Controller1ButtonsAlt  = $0020
CombinedControllerButtons = $0021

ScoreDigitsCurrent     = $0290
ScoreDigitsWorking     = $0298

AudioEffectRequestState      = $02A0
AudioCurrentEffectPriority   = $02A1
AudioEffectTimers            = $02A3
AudioMusicState              = $02AA
AudioMusicControl            = $02AB
AudioChannelNotes            = $02AC
AudioChannelDurations        = $02B0
AudioStreamHeaderPointers    = $02DC
AudioChannelIndex            = $02FD
AudioEndedChannelCount       = $02FE
AudioWorkByte                = $02FF

OamBuffer              = $0300

; World 1 parallel entity arrays, 48 slots each
World1EntityType          = $0400
World1EntityMetasprite    = $0430
World1EntityRenderFlags   = $0460
World1EntityPositionHigh  = $0490
World1EntityX             = $04C0
World1EntityY             = $04F0

; World 2 bank-local parallel pools
World2EnemyState                 = $0558
World2EnemyX                     = $055F
World2EnemyY                     = $0566
World2EnemyPhaseCounter          = $056D
World2EnemyBehaviorParameter     = $0574
World2EnemyAttackTimer           = $057B
World2EnemyDamageCounter         = $0582
World2EnemyProjectileFlags       = $0589
World2EnemyProjectileX           = $058F
World2EnemyProjectileY           = $0595
World2EnemyProjectileStepAccumulator = $059B
World2EnemyProjectileMotionX     = $05A1
World2EnemyProjectileMotionY     = $05A7
World2EnemyProjectileLifetime    = $05AD
World2PlayerProjectileState      = $05B3
World2PlayerProjectileX          = $05BA
World2PlayerProjectileY          = $05C1
World2PlayerProjectileDirection  = $05C8

; World 3 active and persistent object pools
World3EntityState       = $0600
World3EntityX           = $0608
World3EntityY           = $0610
World3EntityFrameCounter = $0618
World3EntityCollisionScanLimit = $0620
World3EntityMetasprite  = $0628
World3EntityRenderFlags = $0630
World3EntityType        = $0638
World3EntityScriptOffset = $0640
World3EntityScriptWaitTimer = $0648
World3EntityHorizontalDirection = $0650
World3EntityVerticalDirection = $0658
World3EntityScriptRateCounter = $0660
World3EntityActivationTimer = $0668
World3EntityBehaviorSelector = $0670
World3EntityPersistentState = $0678
World3EntityBehaviorTimer = $0680
World3EntityScriptLoopOffset = $0688
World3EntityFollowAnchorFlag = $0690
World3EntityHitPoints = $0698
World3EntityMetaspriteVariantBit1 = $06A0
World3EntityMetaspriteVariantBit0 = $06A8

World3RoomObjectRoom   = $06B0
World3RoomObjectType   = $06BD
World3RoomObjectX      = $06CA
World3RoomObjectY      = $06D7
World3RoomObjectState  = $06E4

World3EncounterRoomList = $06F1

World3PlayerProjectileState = $06F9
World3PlayerProjectileX = $06FB
World3PlayerProjectileY = $06FD
World3PlayerProjectileDirection = $06FF
World3PlayerProjectileMetasprite = $0701
World3PlayerProjectileAnimationCounter = $0703
