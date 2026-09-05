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
World1FlashLightCarryFlag = $0037

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
World1InvulnerabilityTimer = $00B2

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
World2ScreenStreamPointer = $0046
World2ScreenStreamOffset  = $0054
World2StageSequenceOffset = $0055
World2ScreenRowIndex      = $0056
World2ScreenRunLength     = $0057
World2CurrentScreenId     = $0058
World2PlayerX             = $005C
World2PlayerY             = $005D
World2FrameCounter        = $0073
World2EnemySpawnState     = $0074
World2InventoryState      = $007C
World2InventoryX          = $0083
World2InventoryY          = $008A
World2PendingBackgroundPalette = $009D
World2SavedStageSequenceOffset = $009E
World2BossEncounterState = $00A4
World2StageIndex = $00A9
World2StageBranchCooldown = $00AE
World2SavedBackgroundPalette = $00B4
World2TakkonDefeatStreak = $00B8
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
