PYTHON ?= python
CA65 ?= bin/ca65.exe
LD65 ?= bin/ld65.exe
REFERENCE_ROM ?= Doraemon (J) (PRG0) [!].nes

MANIFEST := assets/manifest.json
VERIFY_ROM := scripts/verify_rom.py
BUILD_DIR := build/native
GENERATED_ASSET_DIR := assets/generated
HEADER_ASSET := $(GENERATED_ASSET_DIR)/header/doraemon.hdr
PRG_ASSET := $(GENERATED_ASSET_DIR)/prg/doraemon.prg
CHR_ASSET := $(GENERATED_ASSET_DIR)/chr/doraemon.chr
OBJECT := $(BUILD_DIR)/doraemon.o
ROM := $(BUILD_DIR)/doraemon.nes
LABELS := $(BUILD_DIR)/doraemon.lbl
MAP := $(BUILD_DIR)/doraemon.map
DEBUG := $(BUILD_DIR)/doraemon.dbg
DEBUG_SYMBOLS := config/debug_symbols.json
DEBUG_BREAKPOINTS := config/debugger_breakpoints.json
DEBUG_WATCHES := config/debugger_watches.json
DEBUG_SYMBOL_DIR := build/debugger
RUNTIME_DEBUG_SYMBOLS := config/runtime_debug_symbols.json
BANK_SOURCES := src/banks/bank_0.asm src/banks/bank_1.asm \
	src/banks/bank_2.asm src/banks/bank_3.asm
SEMANTIC_SOURCES := $(wildcard src/common/*.asm src/shell/*.asm \
	src/rendering/*.asm src/audio/*.asm src/data/*.asm \
	src/world1/*.asm src/world1/data/*.asm \
	src/world2/*.asm src/world2/data/*.asm \
	src/world3/*.asm src/world3/data/*.asm)
SOURCE_FILES := src/main.asm $(BANK_SOURCES) $(SEMANTIC_SOURCES) src/graphics/chr.asm \
	src/memory/hardware.inc src/memory/ram.inc
GHIDRA_FACTS_DIR := build/ghidra/facts
SYMBOLS := config/symbols.json
SOURCE_MODULES := config/source_modules.json
FCEUX_DIR ?= ../fceux_automation
FCEUX_EXE ?= $(FCEUX_DIR)/vc/x64/Release/fceux64.exe
RUNTIME_SCENARIOS := scenarios/runtime_scenarios.json
RUNTIME_LUA := scripts/runtime/capture_architecture.lua
RUNTIME_TRACE_DIR := build/runtime/traces
RUNTIME_SCREENSHOT_DIR := build/runtime/screens
BANK_GATEWAYS := config/bank_gateways.json
COMMON_RUNTIME := config/common_runtime.json
CORE_DISPATCH_ROLES := config/core_dispatch_roles.json
AUDIO_DISPATCH := config/audio_dispatch.json
AUDIO_EFFECTS := config/audio_effects.json
AUDIO_MUSIC := config/audio_music.json
AUDIO_ARBITRATION := config/audio_arbitration.json
AUDIO_STREAM_AUTHORING := data/audio/music_streams.json
SHELL_TEXT := config/shell_text.json
SHELL_TEXT_AUTHORING := data/shell/text.json
SHELL_RUNTIME := config/shell_runtime.json
OBJECT_POOLS := config/object_pools.json
OBJECT_DISPATCH := config/object_dispatch.json
OBJECT_PLACEMENTS := config/object_placements.json
OBJECT_PLACEMENTS_AUTHORING := data/world1/object_data.json
WORLD1_METASPRITES := config/world1_metasprites.json
WORLD1_METASPRITE_AUTHORING := data/world1/metasprites.json
WORLD1_PALETTES := config/world1_palettes.json
WORLD1_PALETTE_AUTHORING := data/world1/palettes.json
WORLD1_RANDOM := config/world1_random.json
WORLD1_MAP_DECODER := config/world1_map_decoder.json
WORLD1_PPU_STREAMING := config/world1_ppu_streaming.json
WORLD1_CAMERA := config/world1_camera.json
WORLD1_CAMERA_ENTITIES := config/world1_camera_entities.json
WORLD1_PLAYER_CONTROLS := config/world1_player_controls.json
WORLD1_CORE_ROUTINES := config/world1_core_routines.json
WORLD1_FRAME_MECHANICS := config/world1_frame_mechanics.json
WORLD1_ENTITY_HELPERS := config/world1_entity_helpers.json
WORLD1_FINAL_ROUTINES := config/world1_final_routines.json
WORLD2_FRAME_CORE := config/world2_frame_core.json
WORLD2_PLAYER_SYSTEMS := config/world2_player_systems.json
WORLD2_SCREEN_CORE := config/world2_screen_core.json
WORLD2_PROJECTILE_RUNTIME := config/world2_projectile_runtime.json
WORLD2_SPRITE_RUNTIME := config/world2_sprite_runtime.json
WORLD2_FINAL_ROUTINES := config/world2_final_routines.json
WORLD3_FRAME_CORE := config/world3_frame_core.json
WORLD3_COLLISION_RENDERING := config/world3_collision_rendering.json
WORLD3_ROOM_RUNTIME := config/world3_room_runtime.json
WORLD3_PLAYER_RUNTIME := config/world3_player_runtime.json
WORLD3_INTERACTION_RUNTIME := config/world3_interaction_runtime.json
WORLD3_ENTITY_RUNTIME := config/world3_entity_runtime.json
WORLD3_ROOM_RENDERING := config/world3_room_rendering.json
WORLD3_FORMATION_RUNTIME := config/world3_formation_runtime.json
WORLD3_TRANSITION_RUNTIME := config/world3_transition_runtime.json
WORLD1_WEAPONS := config/world1_weapons.json
WORLD1_WEAPON_AUTHORING := data/world1/weapons.json
WORLD1_UNDERGROUND_ROOMS := config/world1_underground_rooms.json
WORLD1_UNDERGROUND_ROOM_AUTHORING := data/world1/underground_rooms.json
WORLD1_ENEMY_HANDLERS := config/world1_enemy_handlers.json
WORLD1_ENEMY_IDENTITIES := config/world1_enemy_identities.json
WORLD1_DESCRIPTOR_IDENTITIES := config/world1_descriptor_identities.json
WORLD2_STREAMING := config/world2_streaming.json
WORLD2_SCREEN_AUTHORING := data/world2/compressed_screens.json
WORLD2_ENEMY_STATES := config/world2_enemy_states.json
WORLD2_ENEMY_HANDLERS := config/world2_enemy_handlers.json
WORLD2_ENEMY_IDENTITIES := config/world2_enemy_identities.json
WORLD2_ENEMY_AUTHORING := data/world2/enemy_states.json
WORLD2_STAGE_SEQUENCE := config/world2_stage_sequence.json
WORLD2_STAGE_AUTHORING := data/world2/stage_sequence.json
WORLD2_STAGE_BRANCHES := config/world2_stage_branches.json
WORLD2_STAGE_BRANCH_AUTHORING := data/world2/stage_branches.json
WORLD2_INVENTORY := config/world2_inventory.json
WORLD2_INVENTORY_AUTHORING := data/world2/inventory_spawn_screens.json
WORLD2_METATILES := config/world2_metatiles.json
WORLD2_METATILE_AUTHORING := data/world2/metatiles.json
WORLD2_PALETTES := config/world2_palettes.json
WORLD2_PALETTE_AUTHORING := data/world2/palettes.json
WORLD2_METASPRITES := config/world2_metasprites.json
WORLD2_METASPRITE_AUTHORING := data/world2/metasprites.json
WORLD3_OBJECT_DATA := config/world3_object_data.json
WORLD3_BEHAVIOR := config/world3_behavior.json
WORLD3_BEHAVIOR_AUTHORING := data/world3/behavior_streams.json
WORLD3_ENTITY_TYPES := config/world3_entity_types.json
WORLD3_OBJECT_AUTHORING := data/world3/object_catalog.json
WORLD3_SPAWN_INITIALIZERS := config/world3_spawn_initializers.json
WORLD3_SPAWN_INITIALIZER_AUTHORING := data/world3/spawn_initializer_data.json
WORLD3_TRANSIENT_SPAWNS := config/world3_transient_spawns.json
WORLD3_TRANSIENT_SPAWN_AUTHORING := data/world3/transient_spawns.json
WORLD3_UPDATE_HANDLERS := config/world3_update_handlers.json
WORLD3_UPDATE_HANDLER_AUTHORING := data/world3/update_handler_data.json
WORLD3_PPU_QUEUE := config/world3_ppu_queue.json
WORLD3_METASPRITES := config/world3_metasprites.json
WORLD3_METASPRITE_AUTHORING := data/world3/metasprites.json
WORLD_DATA := config/world_data.json
WORLD1_DATA_AUTHORING := data/world1/hierarchical_world.json
WORLD3_DATA_AUTHORING := data/world3/hierarchical_world.json
RECONSTRUCTION_INVENTORY := config/reconstruction_inventory.json
AUTHORING_COVERAGE := config/authoring_coverage.json
RUNTIME_STATE_COVERAGE := config/runtime_state_coverage.json
SOURCE_CLASSIFICATION := config/source_classification.json
TOOLCHAIN := config/toolchain.json

.PHONY: all build split verify verify-reference verify-built verify-header \
	verify-prg verify-chr verify-payload verify-rom verify-assets inspect \
	rom-info rom-info-reference rom-info-built bank-info format format-check \
	lint lint-asm lint-source lint-project test quality-check scaffold-check \
	ghidra-bootstrap ghidra-status ghidra-inspect ghidra-analyze disassemble \
	disassembly-check maps validate-maps release-check check clean \
	source-audit source-release-audit source-pre-tag-audit source-check \
	source-1-audit source-1-post-tag-audit source-1-post-tag-remote-audit \
	trace trace-runtime \
	verify-build-toolchain verify-runtime-toolchain \
	debug-symbols validate-debug-symbols \
	runtime-debug-symbols validate-runtime-debug-symbols \
	reconstruction-inventory validate-reconstruction-inventory \
	authoring-coverage validate-authoring-coverage \
	runtime-state-coverage validate-runtime-state-coverage \
	source-classification validate-source-classification \
	validate-runtime runtime-architecture bank-gateways validate-bank-gateways \
	common-runtime validate-common-runtime \
	core-dispatch-roles validate-core-dispatch-roles \
	audio-dispatch validate-audio-dispatch audio-effects validate-audio-effects \
	object-pools validate-object-pools \
	audio-music validate-audio-music \
	audio-arbitration validate-audio-arbitration \
	audio-streams validate-audio-streams \
	shell-text validate-shell-text \
	shell-runtime validate-shell-runtime \
	object-dispatch validate-object-dispatch object-placements \
	validate-object-placements world1-metasprites validate-world1-metasprites \
	world1-palettes validate-world1-palettes \
	world1-random validate-world1-random \
	world1-map-decoder validate-world1-map-decoder \
	world1-ppu-streaming validate-world1-ppu-streaming \
	world1-camera validate-world1-camera \
	world1-camera-entities validate-world1-camera-entities \
	world1-core-routines validate-world1-core-routines \
	world1-frame-mechanics validate-world1-frame-mechanics \
	world1-entity-helpers validate-world1-entity-helpers \
	world1-final-routines validate-world1-final-routines \
	world2-frame-core validate-world2-frame-core \
	world2-player-systems validate-world2-player-systems \
	world2-screen-core validate-world2-screen-core \
	world2-projectile-runtime validate-world2-projectile-runtime \
	world2-sprite-runtime validate-world2-sprite-runtime \
	world2-final-routines validate-world2-final-routines \
	world3-frame-core validate-world3-frame-core \
	world3-collision-rendering validate-world3-collision-rendering \
	world3-room-runtime validate-world3-room-runtime \
	world3-player-runtime validate-world3-player-runtime \
	world3-interaction-runtime validate-world3-interaction-runtime \
	world3-entity-runtime validate-world3-entity-runtime \
	world3-room-rendering validate-world3-room-rendering \
	world3-formation-runtime validate-world3-formation-runtime \
	world3-transition-runtime validate-world3-transition-runtime \
	world1-player-controls validate-world1-player-controls \
	world1-weapons validate-world1-weapons \
	world1-underground-rooms validate-world1-underground-rooms \
	world1-enemy-handlers validate-world1-enemy-handlers \
	world1-enemy-identities validate-world1-enemy-identities \
	world1-descriptor-identities validate-world1-descriptor-identities \
	world2-streaming validate-world2-streaming \
	world2-enemy-states validate-world2-enemy-states \
	world2-enemy-handlers validate-world2-enemy-handlers \
	world2-enemy-identities validate-world2-enemy-identities \
	world2-stage-sequence validate-world2-stage-sequence \
	world2-stage-branches validate-world2-stage-branches \
	world2-inventory validate-world2-inventory \
	world2-metatiles validate-world2-metatiles \
	world2-palettes validate-world2-palettes \
	world2-metasprites validate-world2-metasprites \
	world3-object-data validate-world3-object-data world3-behavior \
	validate-world3-behavior world3-entity-types validate-world3-entity-types \
	world3-object-catalog validate-world3-object-catalog \
	world3-spawn-initializers validate-world3-spawn-initializers \
	world3-transient-spawns validate-world3-transient-spawns \
	world3-update-handlers validate-world3-update-handlers \
	world3-ppu-queue validate-world3-ppu-queue \
	world3-metasprites validate-world3-metasprites \
	world-data validate-world-data

all: verify

$(BUILD_DIR):
	$(PYTHON) scripts/project.py mkdir --path "$(BUILD_DIR)"

$(CHR_ASSET):
	$(PYTHON) scripts/project.py require --path "$@" --hint "run 'make split' first"

$(PRG_ASSET):
	$(PYTHON) scripts/project.py require --path "$@" --hint "run 'make split' first"

verify-build-toolchain:
	$(PYTHON) scripts/toolchain.py --manifest "$(TOOLCHAIN)" \
		--component ca65 --component ld65

verify-runtime-toolchain:
	$(PYTHON) scripts/toolchain.py --manifest "$(TOOLCHAIN)" \
		--component fceux --fceux "$(FCEUX_EXE)"

$(OBJECT): $(SOURCE_FILES) $(CHR_ASSET) | $(BUILD_DIR) verify-build-toolchain
	$(CA65) --debug-info -g -o "$@" -l "$(BUILD_DIR)/doraemon.lst" "src/main.asm"

$(ROM): $(OBJECT) config/linker/gnrom.cfg | verify-build-toolchain
	$(LD65) -C config/linker/gnrom.cfg -o "$@" "$<" -Ln "$(LABELS)" -m "$(MAP)" --dbgfile "$(DEBUG)"

build: $(ROM)

split:
	$(PYTHON) scripts/project.py split --image "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --output-dir "$(GENERATED_ASSET_DIR)"

verify-reference:
	$(PYTHON) scripts/project.py verify --image "$(REFERENCE_ROM)" --manifest "$(MANIFEST)"

verify-built: $(ROM)
	$(PYTHON) scripts/project.py verify --image "$(ROM)" --manifest "$(MANIFEST)"

verify-header: $(ROM)
	$(PYTHON) "$(VERIFY_ROM)" compare --built "$(ROM)" --reference "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --region header

verify-prg: $(ROM)
	$(PYTHON) "$(VERIFY_ROM)" compare --built "$(ROM)" --reference "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --region prg

verify-chr: $(ROM)
	$(PYTHON) "$(VERIFY_ROM)" compare --built "$(ROM)" --reference "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --region chr

verify-payload: $(ROM)
	$(PYTHON) "$(VERIFY_ROM)" compare --built "$(ROM)" --reference "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --region payload

verify-rom: $(ROM)
	$(PYTHON) "$(VERIFY_ROM)" compare --built "$(ROM)" --reference "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --region rom

verify-assets: $(PRG_ASSET) $(CHR_ASSET)
	$(PYTHON) "$(VERIFY_ROM)" asset --asset "$(PRG_ASSET)" --reference "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --region prg
	$(PYTHON) "$(VERIFY_ROM)" asset --asset "$(CHR_ASSET)" --reference "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --region chr

verify: verify-reference verify-built verify-header verify-prg verify-chr verify-payload verify-rom verify-assets

rom-info-reference:
	$(PYTHON) "$(VERIFY_ROM)" report --image "$(REFERENCE_ROM)" --manifest "$(MANIFEST)"

rom-info-built: $(ROM)
	$(PYTHON) "$(VERIFY_ROM)" report --image "$(ROM)" --manifest "$(MANIFEST)"

rom-info: rom-info-reference rom-info-built

inspect: rom-info-reference

bank-info:
	$(PYTHON) scripts/project.py banks --image "$(REFERENCE_ROM)" --manifest "$(MANIFEST)"

format:
	$(PYTHON) scripts/asm_style.py --fix src
	$(PYTHON) scripts/format_project.py write
	$(MAKE) lint

format-check: lint-asm

lint-asm:
	$(PYTHON) scripts/asm_style.py src

lint-source:
	$(PYTHON) scripts/format_project.py check
	$(PYTHON) scripts/project.py lint

lint-project: lint-source

lint: lint-asm lint-source

test:
	$(PYTHON) -m unittest discover -s tests -v

quality-check: lint test

scaffold-check: quality-check

source-audit:
	$(PYTHON) scripts/source_reconstruction_audit.py

source-release-audit:
	$(PYTHON) scripts/source_reconstruction_audit.py --phase pre-tag

source-pre-tag-audit:
	$(PYTHON) scripts/source_reconstruction_audit.py --phase pre-tag --check-remote

reconstruction-inventory validate-reconstruction-inventory:
	$(PYTHON) scripts/reconstruction_inventory.py \
		--manifest "$(RECONSTRUCTION_INVENTORY)"

authoring-coverage validate-authoring-coverage:
	$(PYTHON) scripts/authoring_coverage.py \
		--manifest "$(AUTHORING_COVERAGE)" \
		--reconstruction "config/source_reconstruction.json" \
		--makefile "Makefile"

runtime-state-coverage validate-runtime-state-coverage:
	$(PYTHON) scripts/runtime_state_coverage.py \
		--manifest "$(RUNTIME_STATE_COVERAGE)" \
		--makefile "Makefile"

source-classification validate-source-classification: $(ROM)
	$(PYTHON) scripts/source_classification.py \
		--manifest "$(SOURCE_CLASSIFICATION)"

source-check: release-check source-audit

source-1-audit:
	$(PYTHON) scripts/source_reconstruction_audit.py --phase pre-tag --check-remote
	$(MAKE) source-check
	$(MAKE) trace
	$(MAKE) validate-runtime-debug-symbols
	$(PYTHON) scripts/source_reconstruction_audit.py --phase pre-tag --check-remote --require-clean

source-1-post-tag-audit:
	$(PYTHON) scripts/source_reconstruction_audit.py --phase post-tag --require-clean

source-1-post-tag-remote-audit:
	$(PYTHON) scripts/source_reconstruction_audit.py --phase post-tag \
		--check-remote --require-clean

trace: trace-runtime

trace-runtime: verify-runtime-toolchain verify-reference
	$(PYTHON) scripts/runtime/run_runtime_scenarios.py \
		--fceux "$(FCEUX_EXE)" \
		--rom "$(REFERENCE_ROM)" \
		--lua "$(RUNTIME_LUA)" \
		--scenarios "$(RUNTIME_SCENARIOS)" \
		--output-dir "$(RUNTIME_TRACE_DIR)" \
		--screenshot-dir "$(RUNTIME_SCREENSHOT_DIR)"

validate-runtime:
	$(PYTHON) scripts/runtime/validate_runtime_scenarios.py \
		--scenarios "$(RUNTIME_SCENARIOS)" \
		--trace-dir "$(RUNTIME_TRACE_DIR)"

runtime-debug-symbols: validate-runtime-debug-symbols

validate-runtime-debug-symbols: validate-debug-symbols validate-runtime
	$(PYTHON) scripts/runtime/validate_debugger_runtime.py \
		--contract "$(RUNTIME_DEBUG_SYMBOLS)" \
		--breakpoints "$(DEBUG_BREAKPOINTS)" --watches "$(DEBUG_WATCHES)" \
		--trace-dir "$(RUNTIME_TRACE_DIR)" --symbol-dir "$(DEBUG_SYMBOL_DIR)"

runtime-architecture: validate-bank-gateways trace-runtime validate-runtime

bank-gateways: $(PRG_ASSET)
	$(PYTHON) scripts/bank_gateways.py --prg "$(PRG_ASSET)" \
		--manifest "$(BANK_GATEWAYS)" --source-root src \
		--symbols "$(SYMBOLS)" --pretty

validate-bank-gateways: $(PRG_ASSET)
	$(PYTHON) scripts/bank_gateways.py --prg "$(PRG_ASSET)" \
		--manifest "$(BANK_GATEWAYS)" --source-root src --symbols "$(SYMBOLS)"

common-runtime validate-common-runtime: $(PRG_ASSET)
	$(PYTHON) scripts/common_runtime.py --prg "$(PRG_ASSET)" \
		--manifest "$(COMMON_RUNTIME)" --symbols "$(SYMBOLS)"

core-dispatch-roles validate-core-dispatch-roles:
	$(PYTHON) scripts/core_dispatch_roles.py --roles "$(CORE_DISPATCH_ROLES)" \
		--streaming "$(WORLD2_STREAMING)" \
		--object-dispatch "$(OBJECT_DISPATCH)" --symbols "$(SYMBOLS)"

audio-dispatch validate-audio-dispatch: $(PRG_ASSET)
	$(PYTHON) scripts/audio_dispatch.py --prg "$(PRG_ASSET)" \
		--manifest "$(AUDIO_DISPATCH)" \
		--code-entries config/prg_code_entries.txt

audio-effects validate-audio-effects:
	$(PYTHON) scripts/audio_effects.py validate --catalog "$(AUDIO_EFFECTS)" \
		--dispatch "$(AUDIO_DISPATCH)" --symbols "$(SYMBOLS)"

audio-music validate-audio-music: $(PRG_ASSET)
	$(PYTHON) scripts/audio_music.py --prg "$(PRG_ASSET)" \
		--manifest "$(AUDIO_MUSIC)" --dispatch "$(AUDIO_DISPATCH)" \
		--symbols "$(SYMBOLS)"

audio-arbitration validate-audio-arbitration: $(PRG_ASSET)
	$(PYTHON) scripts/audio_arbitration.py --prg "$(PRG_ASSET)" \
		--manifest "$(AUDIO_ARBITRATION)" --symbols "$(SYMBOLS)"

audio-streams validate-audio-streams: $(PRG_ASSET)
	$(PYTHON) scripts/audio_streams.py validate --prg "$(PRG_ASSET)" \
		--music "$(AUDIO_MUSIC)" --authoring "$(AUDIO_STREAM_AUTHORING)"

shell-text validate-shell-text: $(PRG_ASSET)
	$(PYTHON) scripts/shell_text.py validate --prg "$(PRG_ASSET)" \
		--manifest "$(SHELL_TEXT)" --authoring "$(SHELL_TEXT_AUTHORING)"

shell-runtime: validate-shell-runtime

validate-shell-runtime: $(PRG_ASSET) ghidra-analyze
	$(PYTHON) scripts/routine_contract.py --prg "$(PRG_ASSET)" \
		--manifest "$(SHELL_RUNTIME)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_3.tsv"

object-pools validate-object-pools:
	$(PYTHON) scripts/object_pools.py --manifest "$(OBJECT_POOLS)" \
		--symbols "$(SYMBOLS)"

object-dispatch validate-object-dispatch: $(PRG_ASSET)
	$(PYTHON) scripts/object_dispatch.py --prg "$(PRG_ASSET)" \
		--manifest "$(OBJECT_DISPATCH)" \
		--code-entries config/prg_code_entries.txt

object-placements validate-object-placements: $(PRG_ASSET)
	$(PYTHON) scripts/object_placements.py validate --prg "$(PRG_ASSET)" \
		--manifest "$(OBJECT_PLACEMENTS)" \
		--authoring "$(OBJECT_PLACEMENTS_AUTHORING)"

world1-metasprites validate-world1-metasprites: $(PRG_ASSET) $(CHR_ASSET)
	$(PYTHON) scripts/world1_metasprites.py validate --prg "$(PRG_ASSET)" \
		--chr "$(CHR_ASSET)" \
		--manifest "$(WORLD1_METASPRITES)" \
		--objects "$(OBJECT_PLACEMENTS)" \
		--symbols "$(SYMBOLS)" \
		--authoring "$(WORLD1_METASPRITE_AUTHORING)"

world1-palettes: validate-world1-palettes

validate-world1-palettes: $(PRG_ASSET)
	$(PYTHON) scripts/world1_palettes.py validate \
		--prg "$(PRG_ASSET)" --manifest "$(WORLD1_PALETTES)" \
		--authoring "$(WORLD1_PALETTE_AUTHORING)"

world1-random validate-world1-random: $(PRG_ASSET)
	$(PYTHON) scripts/world1_random.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_RANDOM)" \
		--symbols "$(SYMBOLS)"

world1-map-decoder validate-world1-map-decoder: $(PRG_ASSET)
	$(PYTHON) scripts/world1_map_decoder.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_MAP_DECODER)" \
		--symbols "$(SYMBOLS)" \
		--world-data "$(WORLD_DATA)"

world1-ppu-streaming validate-world1-ppu-streaming: $(PRG_ASSET)
	$(PYTHON) scripts/world1_ppu_streaming.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_PPU_STREAMING)" \
		--symbols "$(SYMBOLS)"

world1-camera validate-world1-camera: $(PRG_ASSET)
	$(PYTHON) scripts/world1_camera.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_CAMERA)" \
		--symbols "$(SYMBOLS)"

world1-camera-entities validate-world1-camera-entities: $(PRG_ASSET)
	$(PYTHON) scripts/world1_camera_entities.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_CAMERA_ENTITIES)" \
		--symbols "$(SYMBOLS)"

world1-core-routines: validate-world1-core-routines

validate-world1-core-routines: $(PRG_ASSET) ghidra-analyze
	$(PYTHON) scripts/routine_contract.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_CORE_ROUTINES)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_0.tsv"

world1-frame-mechanics: validate-world1-frame-mechanics

validate-world1-frame-mechanics: $(PRG_ASSET) ghidra-analyze
	$(PYTHON) scripts/routine_contract.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_FRAME_MECHANICS)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_0.tsv"

world1-entity-helpers: validate-world1-entity-helpers

validate-world1-entity-helpers: $(PRG_ASSET) ghidra-analyze
	$(PYTHON) scripts/routine_contract.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_ENTITY_HELPERS)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_0.tsv"

world1-final-routines: validate-world1-final-routines

validate-world1-final-routines: $(PRG_ASSET) ghidra-analyze
	$(PYTHON) scripts/routine_contract.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_FINAL_ROUTINES)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_0.tsv"

world2-frame-core: validate-world2-frame-core

validate-world2-frame-core: $(PRG_ASSET) ghidra-analyze
	$(PYTHON) scripts/routine_contract.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_FRAME_CORE)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_1.tsv"

world2-player-systems: validate-world2-player-systems

validate-world2-player-systems: $(PRG_ASSET) ghidra-analyze
	$(PYTHON) scripts/routine_contract.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_PLAYER_SYSTEMS)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_1.tsv"

world2-screen-core: validate-world2-screen-core

validate-world2-screen-core: $(PRG_ASSET) ghidra-analyze
	$(PYTHON) scripts/routine_contract.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_SCREEN_CORE)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_1.tsv"

world2-projectile-runtime: validate-world2-projectile-runtime

validate-world2-projectile-runtime: $(PRG_ASSET) ghidra-analyze
	$(PYTHON) scripts/routine_contract.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_PROJECTILE_RUNTIME)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_1.tsv"

world2-sprite-runtime: validate-world2-sprite-runtime

validate-world2-sprite-runtime: $(PRG_ASSET) ghidra-analyze
	$(PYTHON) scripts/routine_contract.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_SPRITE_RUNTIME)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_1.tsv"

world2-final-routines: validate-world2-final-routines

validate-world2-final-routines: $(PRG_ASSET) ghidra-analyze
	$(PYTHON) scripts/routine_contract.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_FINAL_ROUTINES)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_1.tsv"

world3-frame-core: validate-world3-frame-core

validate-world3-frame-core: $(PRG_ASSET) ghidra-analyze
	$(PYTHON) scripts/routine_contract.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_FRAME_CORE)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_2.tsv"

world3-collision-rendering: validate-world3-collision-rendering

validate-world3-collision-rendering: $(PRG_ASSET) ghidra-analyze
	$(PYTHON) scripts/routine_contract.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_COLLISION_RENDERING)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_2.tsv"

world3-room-runtime: validate-world3-room-runtime

validate-world3-room-runtime: $(PRG_ASSET) ghidra-analyze
	$(PYTHON) scripts/routine_contract.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_ROOM_RUNTIME)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_2.tsv"

world3-player-runtime: validate-world3-player-runtime

validate-world3-player-runtime: $(PRG_ASSET) ghidra-analyze
	$(PYTHON) scripts/routine_contract.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_PLAYER_RUNTIME)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_2.tsv"

world3-interaction-runtime: validate-world3-interaction-runtime

validate-world3-interaction-runtime: $(PRG_ASSET) ghidra-analyze
	$(PYTHON) scripts/routine_contract.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_INTERACTION_RUNTIME)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_2.tsv"

world3-entity-runtime: validate-world3-entity-runtime

validate-world3-entity-runtime: $(PRG_ASSET) ghidra-analyze
	$(PYTHON) scripts/routine_contract.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_ENTITY_RUNTIME)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_2.tsv"

world3-room-rendering: validate-world3-room-rendering

validate-world3-room-rendering: $(PRG_ASSET) ghidra-analyze
	$(PYTHON) scripts/routine_contract.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_ROOM_RENDERING)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_2.tsv"

world3-formation-runtime: validate-world3-formation-runtime

validate-world3-formation-runtime: $(PRG_ASSET) ghidra-analyze
	$(PYTHON) scripts/routine_contract.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_FORMATION_RUNTIME)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_2.tsv"

world3-transition-runtime: validate-world3-transition-runtime

validate-world3-transition-runtime: $(PRG_ASSET) ghidra-analyze
	$(PYTHON) scripts/routine_contract.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_TRANSITION_RUNTIME)" --symbols "$(SYMBOLS)" \
		--facts "$(GHIDRA_FACTS_DIR)/bank_2.tsv"

world1-player-controls validate-world1-player-controls: $(PRG_ASSET)
	$(PYTHON) scripts/world1_player_controls.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_PLAYER_CONTROLS)" \
		--symbols "$(SYMBOLS)"

world1-weapons validate-world1-weapons: $(PRG_ASSET)
	$(PYTHON) scripts/world1_weapons.py validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_WEAPONS)" \
		--symbols "$(SYMBOLS)" \
		--authoring "$(WORLD1_WEAPON_AUTHORING)"

world1-underground-rooms validate-world1-underground-rooms: $(PRG_ASSET)
	$(PYTHON) scripts/world1_underground_rooms.py validate \
		--prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_UNDERGROUND_ROOMS)" \
		--symbols "$(SYMBOLS)" \
		--authoring "$(WORLD1_UNDERGROUND_ROOM_AUTHORING)"

world1-enemy-handlers validate-world1-enemy-handlers: $(PRG_ASSET)
	$(PYTHON) scripts/world1_enemy_handlers.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_ENEMY_HANDLERS)" \
		--object-dispatch "$(OBJECT_DISPATCH)" \
		--placements "$(OBJECT_PLACEMENTS_AUTHORING)" \
		--metasprites "$(WORLD1_METASPRITE_AUTHORING)" \
		--symbols "$(SYMBOLS)"

world1-enemy-identities validate-world1-enemy-identities: $(PRG_ASSET)
	$(PYTHON) scripts/world1_enemy_identities.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_ENEMY_IDENTITIES)" \
		--handlers "$(WORLD1_ENEMY_HANDLERS)" \
		--metasprites "$(WORLD1_METASPRITE_AUTHORING)"

world1-descriptor-identities validate-world1-descriptor-identities: $(PRG_ASSET)
	$(PYTHON) scripts/world1_descriptor_identities.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD1_DESCRIPTOR_IDENTITIES)" \
		--objects "$(OBJECT_PLACEMENTS)" \
		--authoring "$(OBJECT_PLACEMENTS_AUTHORING)" \
		--dispatch "$(OBJECT_DISPATCH)" \
		--metasprites "$(WORLD1_METASPRITE_AUTHORING)" \
		--symbols "$(SYMBOLS)"

world2-streaming validate-world2-streaming: $(PRG_ASSET)
	$(PYTHON) scripts/world2_streaming.py validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_STREAMING)" \
		--code-entries config/prg_code_entries.txt \
		--authoring "$(WORLD2_SCREEN_AUTHORING)"

world2-enemy-states validate-world2-enemy-states: $(PRG_ASSET)
	$(PYTHON) scripts/world2_enemy_states.py validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_ENEMY_STATES)" \
		--object-dispatch "$(OBJECT_DISPATCH)" \
		--screen-authoring "$(WORLD2_SCREEN_AUTHORING)" \
		--authoring "$(WORLD2_ENEMY_AUTHORING)"

world2-enemy-handlers validate-world2-enemy-handlers: $(PRG_ASSET)
	$(PYTHON) scripts/world2_enemy_handlers.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_ENEMY_HANDLERS)" \
		--object-dispatch "$(OBJECT_DISPATCH)" \
		--enemy-states "$(WORLD2_ENEMY_STATES)" \
		--symbols "$(SYMBOLS)"

world2-enemy-identities validate-world2-enemy-identities: $(PRG_ASSET)
	$(PYTHON) scripts/world2_enemy_identities.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_ENEMY_IDENTITIES)" \
		--enemy-states "$(WORLD2_ENEMY_STATES)" \
		--enemy-handlers "$(WORLD2_ENEMY_HANDLERS)" \
		--metasprites "$(WORLD2_METASPRITES)"

world2-stage-sequence validate-world2-stage-sequence: $(PRG_ASSET)
	$(PYTHON) scripts/world2_stage_sequence.py validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_STAGE_SEQUENCE)" \
		--authoring "$(WORLD2_STAGE_AUTHORING)"

world2-stage-branches validate-world2-stage-branches: $(PRG_ASSET)
	$(PYTHON) scripts/world2_stage_branches.py validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_STAGE_BRANCHES)" \
		--stage-authoring "$(WORLD2_STAGE_AUTHORING)" \
		--authoring "$(WORLD2_STAGE_BRANCH_AUTHORING)"

world2-inventory validate-world2-inventory: $(PRG_ASSET)
	$(PYTHON) scripts/world2_inventory.py validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_INVENTORY)" \
		--object-pools "$(OBJECT_POOLS)" \
		--authoring "$(WORLD2_INVENTORY_AUTHORING)"

world2-metatiles validate-world2-metatiles: $(PRG_ASSET)
	$(PYTHON) scripts/world2_metatiles.py validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_METATILES)" \
		--screen-authoring "$(WORLD2_SCREEN_AUTHORING)" \
		--authoring "$(WORLD2_METATILE_AUTHORING)"

world2-palettes validate-world2-palettes: $(PRG_ASSET)
	$(PYTHON) scripts/world2_palettes.py validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD2_PALETTES)" \
		--stage-authoring "$(WORLD2_STAGE_AUTHORING)" \
		--authoring "$(WORLD2_PALETTE_AUTHORING)"

world2-metasprites validate-world2-metasprites: $(PRG_ASSET) $(CHR_ASSET)
	$(PYTHON) scripts/world2_metasprites.py validate --prg "$(PRG_ASSET)" \
		--chr "$(CHR_ASSET)" \
		--manifest "$(WORLD2_METASPRITES)" \
		--enemy-states "$(WORLD2_ENEMY_STATES)" \
		--enemy-handlers "$(WORLD2_ENEMY_HANDLERS)" \
		--object-dispatch "$(OBJECT_DISPATCH)" \
		--palette-manifest "$(WORLD2_PALETTES)" \
		--authoring "$(WORLD2_METASPRITE_AUTHORING)"

world3-object-data validate-world3-object-data: $(PRG_ASSET)
	$(PYTHON) scripts/world3_object_data.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_OBJECT_DATA)"

world3-behavior validate-world3-behavior: $(PRG_ASSET)
	$(PYTHON) scripts/world3_behavior.py validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_BEHAVIOR)" \
		--authoring "$(WORLD3_BEHAVIOR_AUTHORING)"

world3-entity-types validate-world3-entity-types: $(PRG_ASSET)
	$(PYTHON) scripts/world3_entity_types.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_ENTITY_TYPES)" \
		--object-dispatch "$(OBJECT_DISPATCH)" \
		--object-data "$(WORLD3_OBJECT_DATA)"

world3-object-catalog validate-world3-object-catalog: $(PRG_ASSET)
	$(PYTHON) scripts/world3_object_catalog.py validate --prg "$(PRG_ASSET)" \
		--object-data "$(WORLD3_OBJECT_DATA)" \
		--entity-types "$(WORLD3_ENTITY_TYPES)" \
		--authoring "$(WORLD3_OBJECT_AUTHORING)"

world3-spawn-initializers validate-world3-spawn-initializers: $(PRG_ASSET)
	$(PYTHON) scripts/world3_spawn_initializers.py validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_SPAWN_INITIALIZERS)" \
		--object-dispatch "$(OBJECT_DISPATCH)" \
		--transient-authoring "$(WORLD3_TRANSIENT_SPAWN_AUTHORING)" \
		--authoring "$(WORLD3_SPAWN_INITIALIZER_AUTHORING)"

world3-transient-spawns validate-world3-transient-spawns: $(PRG_ASSET)
	$(PYTHON) scripts/world3_transient_spawns.py validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_TRANSIENT_SPAWNS)" \
		--object-dispatch "$(OBJECT_DISPATCH)" \
		--authoring "$(WORLD3_TRANSIENT_SPAWN_AUTHORING)"

world3-update-handlers validate-world3-update-handlers: $(PRG_ASSET)
	$(PYTHON) scripts/world3_update_handlers.py validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_UPDATE_HANDLERS)" \
		--object-dispatch "$(OBJECT_DISPATCH)" \
		--entity-types "$(WORLD3_ENTITY_TYPES)" \
		--authoring "$(WORLD3_UPDATE_HANDLER_AUTHORING)"

world3-ppu-queue validate-world3-ppu-queue: $(PRG_ASSET)
	$(PYTHON) scripts/world3_ppu_queue.py --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_PPU_QUEUE)" \
		--symbols "$(SYMBOLS)"

world3-metasprites validate-world3-metasprites: $(PRG_ASSET)
	$(PYTHON) scripts/world3_metasprites.py validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD3_METASPRITES)" \
		--entity-types "$(WORLD3_ENTITY_TYPES)" \
		--authoring "$(WORLD3_METASPRITE_AUTHORING)"

world-data validate-world-data: $(PRG_ASSET)
	$(PYTHON) scripts/world_data.py validate --prg "$(PRG_ASSET)" \
		--manifest "$(WORLD_DATA)" \
		--authoring "$(WORLD1_DATA_AUTHORING)" \
		--authoring "$(WORLD3_DATA_AUTHORING)"

ghidra-bootstrap:
	$(PYTHON) scripts/bootstrap_ghidra.py install

ghidra-status:
	$(PYTHON) scripts/bootstrap_ghidra.py status

ghidra-inspect:
	$(PYTHON) scripts/run_ghidra.py inspect --image "$(REFERENCE_ROM)" --output build/ghidra/program.json

ghidra-analyze:
	$(PYTHON) scripts/run_ghidra.py export-facts --image "$(REFERENCE_ROM)" --output-dir "$(GHIDRA_FACTS_DIR)"

disassemble: ghidra-analyze $(PRG_ASSET)
	$(PYTHON) scripts/generate_disassembly.py write --prg "$(PRG_ASSET)" --facts-dir "$(GHIDRA_FACTS_DIR)" --symbols "$(SYMBOLS)" --modules "$(SOURCE_MODULES)" --output-dir src

disassembly-check: ghidra-analyze $(PRG_ASSET)
	$(PYTHON) scripts/generate_disassembly.py check --prg "$(PRG_ASSET)" --facts-dir "$(GHIDRA_FACTS_DIR)" --symbols "$(SYMBOLS)" --modules "$(SOURCE_MODULES)" --output-dir src

maps: $(ROM)
	$(PYTHON) scripts/map_data.py --image "$(ROM)" --pretty

validate-maps: $(ROM)
	$(PYTHON) scripts/map_data.py --image "$(ROM)" --validate

debug-symbols: $(ROM)
	$(PYTHON) scripts/debug_symbols.py generate --dbg "$(DEBUG)" \
		--rom "$(ROM)" --symbols "$(SYMBOLS)" \
		--contract "$(DEBUG_SYMBOLS)" \
		--breakpoints "$(DEBUG_BREAKPOINTS)" --watches "$(DEBUG_WATCHES)" \
		--output-dir "$(DEBUG_SYMBOL_DIR)"

validate-debug-symbols: debug-symbols
	$(PYTHON) scripts/debug_symbols.py validate --dbg "$(DEBUG)" \
		--rom "$(ROM)" --symbols "$(SYMBOLS)" \
		--contract "$(DEBUG_SYMBOLS)" \
		--breakpoints "$(DEBUG_BREAKPOINTS)" --watches "$(DEBUG_WATCHES)" \
		--output-dir "$(DEBUG_SYMBOL_DIR)"

release-check: verify-build-toolchain quality-check disassembly-check verify validate-maps \
	validate-debug-symbols \
	validate-reconstruction-inventory validate-authoring-coverage \
	validate-runtime-state-coverage validate-source-classification \
	validate-common-runtime \
	validate-core-dispatch-roles \
	validate-audio-dispatch validate-audio-effects validate-audio-music \
	validate-audio-arbitration \
	validate-audio-streams \
	validate-shell-text \
	validate-shell-runtime \
	validate-object-pools validate-object-dispatch \
	validate-object-placements validate-world1-metasprites \
	validate-world1-palettes \
	validate-world1-random \
	validate-world1-map-decoder \
	validate-world1-ppu-streaming \
	validate-world1-camera \
	validate-world1-camera-entities \
	validate-world1-core-routines \
	validate-world1-frame-mechanics \
	validate-world1-entity-helpers \
	validate-world1-final-routines \
	validate-world2-frame-core \
	validate-world2-player-systems \
	validate-world2-screen-core \
	validate-world2-projectile-runtime \
	validate-world2-sprite-runtime \
	validate-world2-final-routines \
	validate-world3-frame-core \
	validate-world3-collision-rendering \
	validate-world3-room-runtime \
	validate-world3-player-runtime \
	validate-world3-interaction-runtime \
	validate-world3-entity-runtime \
	validate-world3-room-rendering \
	validate-world3-formation-runtime \
	validate-world3-transition-runtime \
	validate-world1-player-controls \
	validate-world1-weapons \
	validate-world1-underground-rooms \
	validate-world1-enemy-handlers \
	validate-world1-enemy-identities \
	validate-world1-descriptor-identities \
	validate-world2-streaming \
	validate-world2-enemy-states \
	validate-world2-enemy-handlers \
	validate-world2-enemy-identities \
	validate-world2-stage-sequence \
	validate-world2-stage-branches \
	validate-world2-inventory \
	validate-world2-metatiles \
	validate-world2-palettes \
	validate-world2-metasprites \
	validate-world3-object-data validate-world3-behavior \
	validate-world3-entity-types validate-world3-object-catalog \
	validate-world3-spawn-initializers \
	validate-world3-transient-spawns \
	validate-world3-update-handlers \
	validate-world3-ppu-queue \
	validate-world3-metasprites \
	validate-world-data

check: release-check

clean:
	$(PYTHON) scripts/project.py clean --path build
