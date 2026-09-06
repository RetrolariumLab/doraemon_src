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
Controller2MicrophoneSample = $0023
Controller2MicrophoneEdgeTimer = $0024

; Shared player progression and health state
ExtraLifeScoreThresholdIndex = $0025
ExtraLifeSoundCounter    = $0026
DemoModeActive           = $0027
PlayerLives               = $002A
PlayerHealth              = $002B
PlayerHealthCapacityIndex = $002C
AudioStreamPointers       = $002F
World1FlashLightCarryFlag = $0037

; Bank 3 title, transition, and ending state
ShellChapterSelectIndex = $003C
ShellChapterSelectLatch = $003D
EndingCreditSourcePointer = $004B
ShellTransitionCompleteFlag = $0406
ShellTransitionMotionIndex = $0409
ShellTransitionOriginX = $040A
ShellTransitionOriginY = $040B
ShellTransitionSettleStep = $040C

; World 1 metasprite renderer workspace
World1OamY                 = $0041
World1OamTile              = $0042
World1OamAttributes        = $0043
World1OamX                 = $0044
World1MetaspriteOriginX    = $0045
World1MetaspriteOriginXHigh = $0046
World1MetaspriteOriginY    = $0047
World1MetaspriteOriginYHigh = $0048
World1MetaspriteIndex      = $0049
World1MetaspriteRenderFlags = $004A
World1MetaspriteDataPointer = $004B
World1MetaspriteXMirrorExtent = $004D
World1MetaspriteYMirrorExtent = $004E
World1MetaspritePiecesRemaining = $004F
World1OamWriteIndex        = $0050

; World 1 pseudorandom state
World1FrameRandomState     = $0052
World1RandomState          = $0054

; World 1 camera state
World1NametableX           = $0058
World1PpuScrollXLatched    = $0059
World1PpuScrollYLatched    = $005A
World1CameraTileX          = $005B
World1CameraTileY          = $005C
World1MapPrefillCounter    = $0060
World1ScreenDeltaX         = $0061
World1ScreenDeltaY         = $0062

; World 1 input edges and weapon-pose timing
World1WeaponPoseTimer      = $0063
World1PreviousButtons      = $0064
World1PressedButtons       = $0065

; World 1 hierarchical map decoder workspace
World1MapDataPointer       = $0066
World1CurrentSmallBlockPointer = $006A
World1CurrentBigBlockPointer = $006C
World1MapRowPointer        = $006E
World1TileQuadrantIndex    = $0070
World1SmallBlockQuadrantIndex = $0071
World1MapColumnIndex       = $0072

; World 1 item-derived combat state
World1PlayerX              = $0075
World1PlayerY              = $0076
World1PlayerMetasprite     = $0077
World1PlayerRenderFlags    = $0078
World1PlayerDamageState    = $0079
World1PlayerAnimationCounter = $007A
World1WeaponLevel         = $007B
World1PlayerAirborne      = $007C
World1PlayerYVelocity     = $007D
World1PlayerXSubpixel     = $007E
World1PlayerDirection     = $007F
World1EnemyFreezeActive   = $0082
World1EnemyFreezeTimer    = $0083
World1ProjectileMaxSlot   = $0084
World1UndergroundRoomId   = $0085
World1UndergroundNegativeAxisCityReturnId = $0086
World1UndergroundPositiveAxisCityReturnId = $0087
World1UndergroundAxisScrollLimit = $0088
World1UndergroundAxisScrollCoarse = $0089
World1UndergroundAxisScrollFine = $008A
World1UndergroundVerticalPage = $008B
World1UndergroundAxisScrollBudget = $008C
World1UndergroundFinaleFloorActive = $009B
World1BullRoboSequenceCounter = $009C
World1BullRoboJumpPhase = $009D
World1BullRoboRevealTimer = $009E
World1BullRoboAttackTimer = $009F
World1InvulnerabilityTimer = $00B2

; World 3 frame, room, presentation, and event state
World3PassingHoopCarryFlag = $0038
World3AudioSavedX = $0049
World3AudioSavedY = $004A
World3ChapterCompletionDelay = $004F
World3FormationActive = $0051
World3EntityRenderOrderPhase = $0052
World3BossRoom27Defeated = $0058
World3BossRoom28Defeated = $0059
World3BossRoom34Defeated = $005A
World3PauseInputLatch = $0064
World3OamBufferHalf = $0073
World3OamWriteIndex = $0074
World3MetaspriteOriginX = $0075
World3MetaspriteOriginXHigh = $0076
World3MetaspriteOriginY = $0077
World3MetaspriteOriginYHigh = $0078
World3MetaspriteIndex = $0079
World3MetaspriteRenderFlags = $007A
World3MetaspriteDataPointer = $007B
World3MetaspriteXMirrorExtent = $007D
World3MetaspriteYMirrorExtent = $007E
World3MetaspritePiecesRemaining = $007F
World3OamY = $0080
World3OamTile = $0081
World3OamAttributes = $0082
World3OamX = $0083
World3RoomColumn = $0089
World3RoomRow = $008A
World3TransitionTargetRoom = $008B
World3PlayerX = $008C
World3PlayerY = $008D
World3PlayerState = $008E
World3PlayerMetasprite = $008F
World3PlayerMetaspriteBase = $0090
World3PlayerAnimationFrame = $0091
World3FollowerActive = $009A
World3TerrainTile = $009E
World3PassingHoopPortalActive = $009F
World3PassingHoopBoundaryPresent = $00A0
World3FinalCompanionsFreed = $00A1
World3RoomMusicTrack = $00A5
World3BossMusicRestoreDelay = $00A6
World3StopwatchActive = $00CB
World3StopwatchTimer = $00CC
World3Room16MicrophoneEventActive = $00CE
World3MicrophoneHoldCounter = $00CF
World3Room16MicrophoneEventComplete = $00D0
World3AttractModeActive = $00DC
World3AttractFrameCounterLow = $00DD
World3AttractFrameCounterHigh = $00DE
World3CurrentRoom = $00DF
World3DebugControlsEnabled = $00E0

; World 3 punishment-room state
World3TreasurePenaltyCounter = $004D
World3PunishmentRoomActive = $0053
World3PunishmentReturnRoom = $0054
World3PunishmentDorayakiRemaining = $00A8

; World 3 frame synchronization and PPU update queue
World3RenderingDisabled = $0067
World3FrameWaitCounter = $0068
World3PpuAddressLow = $0069
World3PpuAddressHigh = $006A
World3PpuQueueReadIndex = $006B
World3PpuQueueWriteIndex = $006C
World3PpuQueueRecordBudget = $006D
World3PpuQueueByteCount = $006E
World3ScrollX = $006F
World3ScrollY = $0070
World3NametableSelect = $0071
World3PpuQueueVerticalIncrement = $0072

World1ObjectPlacementList = $0068
World1CurrentPlacementId = $0090
World1PlacementScanPointer = $0091
World1PlacementXCell = $0093
World1PlacementYCell = $0094

; World 1 map-streaming PPU packets
World1ColumnUpdateFlags = $0230
World1ColumnTilePpuAddress = $0231
World1ColumnTileData = $0233
World1ColumnAttributePpuAddress = $0253
World1ColumnAttributeData = $0255
World1ColumnAddressScratch = $025E
World1EdgeUpdateQueue = $025F
World1RowUpdateFlags = $0260
World1RowTilePpuAddress = $0261
World1RowTileData = $0263
World1RowAttributePpuAddress = $0284
World1RowAttributeData = $0286

ScoreDigitsCurrent     = $0290
ScoreDigitsWorking     = $0298

AudioEffectRequestState      = $02A0
AudioCurrentEffectPriority   = $02A1
AudioEffectRetriggerLock     = $02A2
AudioEffectTimers            = $02A3
AudioEffectWork0             = $02A7
AudioEffectWork1             = $02A8
AudioEffectWork2             = $02A9
AudioMusicState              = $02AA
AudioMusicControl            = $02AB
AudioChannelDurationCodes    = $02AC
AudioChannelDurations        = $02B0
AudioChannelBaseVolumes      = $02B4
AudioChannelEnvelopeVolumes  = $02B8
AudioChannelEnvelopeSteps    = $02BC
AudioChannelFixedPitches     = $02C0
AudioLoopStartPointers       = $02C4
AudioLoopExitPointers        = $02CC
AudioLoopRepeatLimits        = $02D4
AudioLoopIterationCounts     = $02D8
AudioSavedStreamPointers     = $02DC
AudioStreamCallReturnPointers = $02E4
AudioChannelPitchOffsets     = $02EC
AudioChannelFixedPitchFlags  = $02EF
AudioChannelControl          = $02F3
AudioNoiseControl            = $02F6
AudioChannelLengthBits       = $02F7
AudioNoisePeriodIndex        = $02FB
AudioNoiseDuration           = $02FC
AudioChannelIndex            = $02FD
AudioEndedChannelCount       = $02FE
AudioWorkByte                = $02FF

OamBuffer              = $0300

World3AttributeShadow   = $0400
World3PaletteShadow     = $0480
World3PpuQueue          = $0500

; World 1 parallel entity arrays, 48 slots each
World1EntityType          = $0400
World1EntityMetasprite    = $0430
World1EntityRenderFlags   = $0460
World1EntityPositionHigh  = $0490
World1EntityX             = $04C0
World1EntityY             = $04F0
World1EntitySourceObjectId = $0520
World1EntityPrimaryBehavior = $0550
World1EntitySecondaryBehavior = $0580
World1EntityHealthOrVelocity = $05B0
World1EntityDamageTimerOrAcceleration = $05E0
World1EntityActionCooldown = $0610
World1EntityReservedBehavior = $0640

World1ObjectSpawnMask = $0670
World1CollectedObjectBits = $0680
World1SavedCityObjectBits = $0690
World1SavedUndergroundObjectBits = $06A0
World1AttributeTableCache = $06B0

; World 2 compressed-screen decoder state
World2HudHealthTiles       = $000A
World2ScrollX              = $003F
World2ScrollY              = $0040
World2ScrollingActive      = $0041
World2ScrollDirection      = $0042
World2PendingScrollDirection = $0043
World2VerticalTransitionDelay = $0044
World2HorizontalTransitionDelay = $0045
World2ScreenStreamPointer = $0046
World2ScreenStreamOffset  = $0054
World2StageSequenceOffset = $0055
World2ScreenRowIndex      = $0056
World2ScreenRunLength     = $0057
World2CurrentScreenId     = $0058
World2PlayerX             = $005C
World2PlayerY             = $005D
World2MovementStep        = $005E
World2PlayerHistoryWriteIndex = $005F
World2MetaspriteOriginX   = $0060
World2MetaspriteOriginY   = $0061
World2MetaspriteAttributes = $0062
World2MetaspriteFlipMask   = $0063
World2MetaspriteSavedSlot  = $0064
World2MetaspriteAttributeIndex = $0065
World2MetaspriteTile       = $0066
World2InventorySlot2AttackActive = $006A
World2InventorySlot2AttackPhase = $006B
World2InventorySlot2AttackDirection = $006E
World2InventorySlot0ProjectileActive = $006F
World2InventorySlot0ProjectileX = $0070
World2InventorySlot0ProjectileY = $0071
World2InventorySlot0ProjectileDirection = $0072
World2FrameCounter        = $0073
World2EnemySpawnState     = $0074
World2SavedEntitySlot     = $0076
World2EnemyProjectileSourceX = $0077
World2EnemyProjectileSourceY = $0078
World2EnemyProjectileSourceSlot = $0079
World2FireRepeatTimer     = $007A
World2CompanionFirePhase  = $007B
World2InventoryState      = $007C
World2InventoryX          = $0083
World2InventoryY          = $008A
World2NextProjectileDirection = $0091
World2CompanionFireCounter = $0092
World2SpriteFlickerPhase  = $0093
World2OamY                = $0094
World2OamTile             = $0095
World2OamAttributes       = $0096
World2OamX                = $0097
World2EnemyCollisionSlot  = $009A
World2AttackCollisionHalfExtent = $009B
World2PlayerHazardContact = $009C
World2PendingBackgroundPalette = $009D
World2SavedStageSequenceOffset = $009E
World2CurrentEnemyStateIndex = $009F
World2PlayerDamageTimer   = $00A0
World2InventorySlot0ProjectileAimPhase = $00A1
World2PlayerDefeated      = $00A2
World2InventorySlot5PickupCount = $00A3
World2BossEncounterState = $00A4
World2InventoryDropHitCounter = $00A5
World2EnemyProjectileTargetX = $00A6
World2EnemyProjectileTargetY = $00A7
World2PlayerDamageEffect = $00A8
World2StageIndex = $00A9
World2StageStartCountdown = $00AA
World2SequenceTimer       = $00AD
World2StageBranchCooldown = $00AE
World2FirePressCounter    = $00B1
World2ChapterComplete     = $00B2
World2StageComplete       = $00B3
World2SavedBackgroundPalette = $00B4
World2TakkonDefeatStreak = $00B8
World2MicrophoneHoldCounter = $00B9
World2MicrophoneAttackUsed = $00BA
World2PlayerXHistory      = $0200
World2PlayerYHistory      = $0230
World2ScreenMetatiles     = $0400

; World 3 room-indexed transient spawn scheduler
World3TransientSpawnScheduleLoaded = $00AB
World3TransientSpawnType = $00AC
World3TransientSpawnRemaining = $00B0
World3TransientSpawnDelay = $00B4
World3TransientSpawnComplete = $00B8
World3TransientSpawnPhase = $00BC
World3TransientSpawnDelayReload = $00C0
World3TransientSpawnWorkType = $00C4
World3TransientSpawnWorkRemaining = $00C5
World3TransientSpawnWorkDelay = $00C6
World3TransientSpawnWorkComplete = $00C7

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
World3PunishmentSavedPlayerState = $0725
