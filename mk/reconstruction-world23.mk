# World 2 and World 3 semantic reconstruction validators.

world2-frame-core: validate-world2-frame-core

validate-world2-frame-core: $(PRG_ASSET) ghidra-analyze
	$(RUN_TOOL) validation.reconstruction.routine_contract --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_FRAME_CORE)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_1.tsv"

world2-player-systems: validate-world2-player-systems

validate-world2-player-systems: $(PRG_ASSET) ghidra-analyze
	$(RUN_TOOL) validation.reconstruction.routine_contract --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_PLAYER_SYSTEMS)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_1.tsv"

world2-screen-core: validate-world2-screen-core

validate-world2-screen-core: $(PRG_ASSET) ghidra-analyze
	$(RUN_TOOL) validation.reconstruction.routine_contract --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_SCREEN_CORE)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_1.tsv"

world2-projectile-runtime: validate-world2-projectile-runtime

validate-world2-projectile-runtime: $(PRG_ASSET) ghidra-analyze
	$(RUN_TOOL) validation.reconstruction.routine_contract --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_PROJECTILE_RUNTIME)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_1.tsv"

world2-sprite-runtime: validate-world2-sprite-runtime

validate-world2-sprite-runtime: $(PRG_ASSET) ghidra-analyze
	$(RUN_TOOL) validation.reconstruction.routine_contract --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_SPRITE_RUNTIME)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_1.tsv"

world2-final-routines: validate-world2-final-routines

validate-world2-final-routines: $(PRG_ASSET) ghidra-analyze
	$(RUN_TOOL) validation.reconstruction.routine_contract --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_FINAL_ROUTINES)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_1.tsv"

world3-frame-core: validate-world3-frame-core

validate-world3-frame-core: $(PRG_ASSET) ghidra-analyze
	$(RUN_TOOL) validation.reconstruction.routine_contract --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_FRAME_CORE)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_2.tsv"

world3-collision-rendering: validate-world3-collision-rendering

validate-world3-collision-rendering: $(PRG_ASSET) ghidra-analyze
	$(RUN_TOOL) validation.reconstruction.routine_contract --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_COLLISION_RENDERING)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_2.tsv"

world3-room-runtime: validate-world3-room-runtime

validate-world3-room-runtime: $(PRG_ASSET) ghidra-analyze
	$(RUN_TOOL) validation.reconstruction.routine_contract --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_ROOM_RUNTIME)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_2.tsv"

world3-player-runtime: validate-world3-player-runtime

validate-world3-player-runtime: $(PRG_ASSET) ghidra-analyze
	$(RUN_TOOL) validation.reconstruction.routine_contract --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_PLAYER_RUNTIME)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_2.tsv"

world3-interaction-runtime: validate-world3-interaction-runtime

validate-world3-interaction-runtime: $(PRG_ASSET) ghidra-analyze
	$(RUN_TOOL) validation.reconstruction.routine_contract --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_INTERACTION_RUNTIME)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_2.tsv"

world3-entity-runtime: validate-world3-entity-runtime

validate-world3-entity-runtime: $(PRG_ASSET) ghidra-analyze
	$(RUN_TOOL) validation.reconstruction.routine_contract --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_ENTITY_RUNTIME)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_2.tsv"

world3-room-rendering: validate-world3-room-rendering

validate-world3-room-rendering: $(PRG_ASSET) ghidra-analyze
	$(RUN_TOOL) validation.reconstruction.routine_contract --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_ROOM_RENDERING)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_2.tsv"

world3-formation-runtime: validate-world3-formation-runtime

validate-world3-formation-runtime: $(PRG_ASSET) ghidra-analyze
	$(RUN_TOOL) validation.reconstruction.routine_contract --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_FORMATION_RUNTIME)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_2.tsv"

world3-transition-runtime: validate-world3-transition-runtime

validate-world3-transition-runtime: $(PRG_ASSET) ghidra-analyze
	$(RUN_TOOL) validation.reconstruction.routine_contract --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_TRANSITION_RUNTIME)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_2.tsv"

world1-player-controls validate-world1-player-controls: $(PRG_ASSET)
	$(RUN_TOOL) validation.world1.world1_player_controls --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_PLAYER_CONTROLS)" \
		--symbols "$(SYMBOLS)"

world1-weapons validate-world1-weapons: $(PRG_ASSET)
	$(RUN_TOOL) validation.world1.world1_weapons validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_WEAPONS)" \
		--symbols "$(SYMBOLS)" \
		--authoring "$(WORLD1_WEAPON_AUTHORING)"

world1-underground-rooms validate-world1-underground-rooms: $(PRG_ASSET)
	$(RUN_TOOL) validation.world1.world1_underground_rooms validate \
		--prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_UNDERGROUND_ROOMS)" \
		--symbols "$(SYMBOLS)" \
		--authoring "$(WORLD1_UNDERGROUND_ROOM_AUTHORING)"

world1-enemy-handlers validate-world1-enemy-handlers: $(PRG_ASSET)
	$(RUN_TOOL) validation.world1.world1_enemy_handlers --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_ENEMY_HANDLERS)" \
		--object-dispatch "$(OBJECT_DISPATCH)" \
		--placements "$(OBJECT_PLACEMENTS_AUTHORING)" \
		--metasprites "$(WORLD1_METASPRITE_AUTHORING)" \
		--symbols "$(SYMBOLS)"

world1-enemy-identities validate-world1-enemy-identities: $(PRG_ASSET)
	$(RUN_TOOL) validation.world1.world1_enemy_identities --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_ENEMY_IDENTITIES)" \
		--handlers "$(WORLD1_ENEMY_HANDLERS)" \
		--metasprites "$(WORLD1_METASPRITE_AUTHORING)"

world1-descriptor-identities validate-world1-descriptor-identities: $(PRG_ASSET)
	$(RUN_TOOL) validation.world1.world1_descriptor_identities --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_DESCRIPTOR_IDENTITIES)" \
		--objects "$(OBJECT_PLACEMENTS)" \
		--authoring "$(OBJECT_PLACEMENTS_AUTHORING)" \
		--dispatch "$(OBJECT_DISPATCH)" \
		--metasprites "$(WORLD1_METASPRITE_AUTHORING)" \
		--symbols "$(SYMBOLS)"

world2-streaming validate-world2-streaming: $(PRG_ASSET)
	$(RUN_TOOL) validation.world2.world2_streaming validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_STREAMING)" \
		--code-entries config/reconstruction/prg_code_entries.txt \
		--authoring "$(WORLD2_SCREEN_AUTHORING)"

world2-enemy-states validate-world2-enemy-states: $(PRG_ASSET)
	$(RUN_TOOL) validation.world2.world2_enemy_states validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_ENEMY_STATES)" \
		--object-dispatch "$(OBJECT_DISPATCH)" \
		--screen-authoring "$(WORLD2_SCREEN_AUTHORING)" \
		--authoring "$(WORLD2_ENEMY_AUTHORING)"

world2-enemy-handlers validate-world2-enemy-handlers: $(PRG_ASSET)
	$(RUN_TOOL) validation.world2.world2_enemy_handlers --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_ENEMY_HANDLERS)" \
		--object-dispatch "$(OBJECT_DISPATCH)" \
		--enemy-states "$(WORLD2_ENEMY_STATES)" \
		--symbols "$(SYMBOLS)"

world2-enemy-identities validate-world2-enemy-identities: $(PRG_ASSET)
	$(RUN_TOOL) validation.world2.world2_enemy_identities --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_ENEMY_IDENTITIES)" \
		--enemy-states "$(WORLD2_ENEMY_STATES)" \
		--enemy-handlers "$(WORLD2_ENEMY_HANDLERS)" \
		--metasprites "$(WORLD2_METASPRITES)"

world2-stage-sequence validate-world2-stage-sequence: $(PRG_ASSET)
	$(RUN_TOOL) validation.world2.world2_stage_sequence validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_STAGE_SEQUENCE)" \
		--authoring "$(WORLD2_STAGE_AUTHORING)"

world2-stage-branches validate-world2-stage-branches: $(PRG_ASSET)
	$(RUN_TOOL) validation.world2.world2_stage_branches validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_STAGE_BRANCHES)" \
		--stage-authoring "$(WORLD2_STAGE_AUTHORING)" \
		--authoring "$(WORLD2_STAGE_BRANCH_AUTHORING)"

world2-inventory validate-world2-inventory: $(PRG_ASSET)
	$(RUN_TOOL) validation.world2.world2_inventory validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_INVENTORY)" \
		--object-pools "$(OBJECT_POOLS)" \
		--authoring "$(WORLD2_INVENTORY_AUTHORING)"

world2-metatiles validate-world2-metatiles: $(PRG_ASSET)
	$(RUN_TOOL) validation.world2.world2_metatiles validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_METATILES)" \
		--screen-authoring "$(WORLD2_SCREEN_AUTHORING)" \
		--authoring "$(WORLD2_METATILE_AUTHORING)"

world2-palettes validate-world2-palettes: $(PRG_ASSET)
	$(RUN_TOOL) validation.world2.world2_palettes validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_PALETTES)" \
		--stage-authoring "$(WORLD2_STAGE_AUTHORING)" \
		--authoring "$(WORLD2_PALETTE_AUTHORING)"

world2-metasprites validate-world2-metasprites: $(PRG_ASSET) $(CHR_ASSET)
	$(RUN_TOOL) validation.world2.world2_metasprites validate --prg "$(PRG_ASSET)" \
		--chr "$(CHR_ASSET)" \
		--manifest "$(WORLD2_METASPRITES)" \
		--enemy-states "$(WORLD2_ENEMY_STATES)" \
		--enemy-handlers "$(WORLD2_ENEMY_HANDLERS)" \
		--object-dispatch "$(OBJECT_DISPATCH)" \
		--palette-manifest "$(WORLD2_PALETTES)" \
		--authoring "$(WORLD2_METASPRITE_AUTHORING)"

world3-object-data validate-world3-object-data: $(PRG_ASSET)
	$(RUN_TOOL) validation.world3.world3_object_data --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_OBJECT_DATA)"

world3-behavior validate-world3-behavior: $(PRG_ASSET)
	$(RUN_TOOL) validation.world3.world3_behavior validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_BEHAVIOR)" \
		--authoring "$(WORLD3_BEHAVIOR_AUTHORING)"

world3-entity-types validate-world3-entity-types: $(PRG_ASSET)
	$(RUN_TOOL) validation.world3.world3_entity_types --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_ENTITY_TYPES)" \
		--object-dispatch "$(OBJECT_DISPATCH)" \
		--object-data "$(WORLD3_OBJECT_DATA)"

world3-object-catalog validate-world3-object-catalog: $(PRG_ASSET)
	$(RUN_TOOL) validation.world3.world3_object_catalog validate --prg "$(PRG_ASSET)" \
		--object-data "$(WORLD3_OBJECT_DATA)" \
		--entity-types "$(WORLD3_ENTITY_TYPES)" \
		--authoring "$(WORLD3_OBJECT_AUTHORING)"

world3-spawn-initializers validate-world3-spawn-initializers: $(PRG_ASSET)
	$(RUN_TOOL) validation.world3.world3_spawn_initializers validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_SPAWN_INITIALIZERS)" \
		--object-dispatch "$(OBJECT_DISPATCH)" \
		--transient-authoring "$(WORLD3_TRANSIENT_SPAWN_AUTHORING)" \
		--authoring "$(WORLD3_SPAWN_INITIALIZER_AUTHORING)"

world3-transient-spawns validate-world3-transient-spawns: $(PRG_ASSET)
	$(RUN_TOOL) validation.world3.world3_transient_spawns validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_TRANSIENT_SPAWNS)" \
		--object-dispatch "$(OBJECT_DISPATCH)" \
		--authoring "$(WORLD3_TRANSIENT_SPAWN_AUTHORING)"

world3-update-handlers validate-world3-update-handlers: $(PRG_ASSET)
	$(RUN_TOOL) validation.world3.world3_update_handlers validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_UPDATE_HANDLERS)" \
		--object-dispatch "$(OBJECT_DISPATCH)" \
		--entity-types "$(WORLD3_ENTITY_TYPES)" \
		--authoring "$(WORLD3_UPDATE_HANDLER_AUTHORING)"

world3-ppu-queue validate-world3-ppu-queue: $(PRG_ASSET)
	$(RUN_TOOL) validation.world3.world3_ppu_queue --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_PPU_QUEUE)" \
		--symbols "$(SYMBOLS)"

world3-metasprites validate-world3-metasprites: $(PRG_ASSET)
	$(RUN_TOOL) validation.world3.world3_metasprites validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_METASPRITES)" \
		--entity-types "$(WORLD3_ENTITY_TYPES)" \
		--authoring "$(WORLD3_METASPRITE_AUTHORING)"

world-data validate-world-data: $(PRG_ASSET)
	$(RUN_TOOL) validation.reconstruction.world_data validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD_DATA)" \
		--authoring "$(WORLD1_DATA_AUTHORING)" \
		--authoring "$(WORLD3_DATA_AUTHORING)"
