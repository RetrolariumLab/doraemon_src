# Common engine and World 1 semantic reconstruction validators.

bank-gateways: $(PRG_ASSET)
	$(RUN_TOOL) validation.reconstruction.bank_gateways --prg "$(PRG_ASSET)" \
		--manifest "$(BANK_GATEWAYS)" --source-root src \
		--symbols "$(SYMBOLS)" --pretty

validate-bank-gateways: $(PRG_ASSET)
	$(RUN_TOOL) validation.reconstruction.bank_gateways --prg "$(PRG_ASSET)" \
		--manifest "$(BANK_GATEWAYS)" --source-root src --symbols "$(SYMBOLS)"

common-runtime validate-common-runtime: $(PRG_ASSET)
	$(RUN_TOOL) validation.reconstruction.common_runtime --prg "$(PRG_ASSET)" \
		--manifest "$(COMMON_RUNTIME)" --symbols "$(SYMBOLS)"

core-dispatch-roles validate-core-dispatch-roles:
	$(RUN_TOOL) validation.reconstruction.core_dispatch_roles --roles "$(CORE_DISPATCH_ROLES)" \
		--streaming "$(WORLD2_STREAMING)" \
		--object-dispatch "$(OBJECT_DISPATCH)" --symbols "$(SYMBOLS)"

audio-dispatch validate-audio-dispatch: $(PRG_ASSET)
	$(RUN_TOOL) validation.audio.audio_dispatch --prg "$(PRG_ASSET)" \
		--manifest "$(AUDIO_DISPATCH)" \
		--code-entries config/reconstruction/prg_code_entries.txt

audio-effects validate-audio-effects:
	$(RUN_TOOL) validation.audio.audio_effects validate --catalog "$(AUDIO_EFFECTS)" \
		--dispatch "$(AUDIO_DISPATCH)" --symbols "$(SYMBOLS)"

audio-music validate-audio-music: $(PRG_ASSET)
	$(RUN_TOOL) validation.audio.audio_music --prg "$(PRG_ASSET)" \
		--manifest "$(AUDIO_MUSIC)" --dispatch "$(AUDIO_DISPATCH)" \
		--symbols "$(SYMBOLS)"

audio-arbitration validate-audio-arbitration: $(PRG_ASSET)
	$(RUN_TOOL) validation.audio.audio_arbitration --prg "$(PRG_ASSET)" \
		--manifest "$(AUDIO_ARBITRATION)" --symbols "$(SYMBOLS)"

audio-streams validate-audio-streams: $(PRG_ASSET)
	$(RUN_TOOL) validation.audio.audio_streams validate --prg "$(PRG_ASSET)" \
		--music "$(AUDIO_MUSIC)" --authoring "$(AUDIO_STREAM_AUTHORING)"

shell-text validate-shell-text: $(PRG_ASSET)
	$(RUN_TOOL) validation.reconstruction.shell_text validate --prg "$(PRG_ASSET)" \
		--manifest "$(SHELL_TEXT)" --authoring "$(SHELL_TEXT_AUTHORING)"

shell-runtime: validate-shell-runtime

validate-shell-runtime: $(PRG_ASSET) ghidra-analyze
	$(RUN_TOOL) validation.reconstruction.routine_contract --prg "$(PRG_ASSET)" \
		--manifest "$(SHELL_RUNTIME)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_3.tsv"

object-pools validate-object-pools:
	$(RUN_TOOL) validation.reconstruction.object_pools --manifest "$(OBJECT_POOLS)" \
		--symbols "$(SYMBOLS)"

object-dispatch validate-object-dispatch: $(PRG_ASSET)
	$(RUN_TOOL) validation.reconstruction.object_dispatch --prg "$(PRG_ASSET)" \
		--manifest "$(OBJECT_DISPATCH)" \
		--code-entries config/reconstruction/prg_code_entries.txt

object-placements validate-object-placements: $(PRG_ASSET)
	$(RUN_TOOL) validation.reconstruction.object_placements validate --prg "$(PRG_ASSET)" \
		--manifest "$(OBJECT_PLACEMENTS)" \
		--authoring "$(OBJECT_PLACEMENTS_AUTHORING)"

world1-metasprites validate-world1-metasprites: $(PRG_ASSET) $(CHR_ASSET)
	$(RUN_TOOL) validation.world1.world1_metasprites validate --prg "$(PRG_ASSET)" \
		--chr "$(CHR_ASSET)" \
		--manifest "$(WORLD1_METASPRITES)" \
		--objects "$(OBJECT_PLACEMENTS)" \
		--symbols "$(SYMBOLS)" \
		--authoring "$(WORLD1_METASPRITE_AUTHORING)"

world1-palettes: validate-world1-palettes

validate-world1-palettes: $(PRG_ASSET)
	$(RUN_TOOL) validation.world1.world1_palettes validate \
		--prg "$(PRG_ASSET)" --manifest "$(WORLD1_PALETTES)" \
		--authoring "$(WORLD1_PALETTE_AUTHORING)"

world1-random validate-world1-random: $(PRG_ASSET)
	$(RUN_TOOL) validation.world1.world1_random --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_RANDOM)" \
		--symbols "$(SYMBOLS)"

world1-map-decoder validate-world1-map-decoder: $(PRG_ASSET)
	$(RUN_TOOL) validation.world1.world1_map_decoder --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_MAP_DECODER)" \
		--symbols "$(SYMBOLS)" \
		--world-data "$(WORLD_DATA)"

world1-ppu-streaming validate-world1-ppu-streaming: $(PRG_ASSET)
	$(RUN_TOOL) validation.world1.world1_ppu_streaming --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_PPU_STREAMING)" \
		--symbols "$(SYMBOLS)"

world1-camera validate-world1-camera: $(PRG_ASSET)
	$(RUN_TOOL) validation.world1.world1_camera --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_CAMERA)" \
		--symbols "$(SYMBOLS)"

world1-camera-entities validate-world1-camera-entities: $(PRG_ASSET)
	$(RUN_TOOL) validation.world1.world1_camera_entities --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_CAMERA_ENTITIES)" \
		--symbols "$(SYMBOLS)"

world1-core-routines: validate-world1-core-routines

validate-world1-core-routines: $(PRG_ASSET) ghidra-analyze
	$(RUN_TOOL) validation.reconstruction.routine_contract --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_CORE_ROUTINES)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_0.tsv"

world1-frame-mechanics: validate-world1-frame-mechanics

validate-world1-frame-mechanics: $(PRG_ASSET) ghidra-analyze
	$(RUN_TOOL) validation.reconstruction.routine_contract --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_FRAME_MECHANICS)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_0.tsv"

world1-entity-helpers: validate-world1-entity-helpers

validate-world1-entity-helpers: $(PRG_ASSET) ghidra-analyze
	$(RUN_TOOL) validation.reconstruction.routine_contract --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_ENTITY_HELPERS)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_0.tsv"

world1-final-routines: validate-world1-final-routines

validate-world1-final-routines: $(PRG_ASSET) ghidra-analyze
	$(RUN_TOOL) validation.reconstruction.routine_contract --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_FINAL_ROUTINES)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_0.tsv"
