PYTHON ?= python
RUN_TOOL := $(PYTHON) scripts/run.py
CA65 ?= bin/ca65.exe
LD65 ?= bin/ld65.exe
REFERENCE_ROM ?= Doraemon (J) (PRG0) [!].nes
REVISION_PROFILES := config/revision_profiles.json
SOURCE_2_MANIFEST := config/source_reconstruction_2_0.json
REVISION_ORIGINAL_ROM ?= Doraemon (J) (PRG0) [!].nes
REVISION_REV_A_ROM ?= Doraemon (Japan) (Rev A).nes
PROFILE ?= original
ifeq ($(PROFILE),rev_a)
REVISION_REFERENCE ?= $(REVISION_REV_A_ROM)
else
REVISION_REFERENCE ?= $(REVISION_ORIGINAL_ROM)
endif
REVISION_SOURCE = src/revisions/$(PROFILE).asm
REVISION_BUILD_DIR = build/revisions/$(PROFILE)
REVISION_OBJECT = $(REVISION_BUILD_DIR)/doraemon.o
REVISION_ROM = $(REVISION_BUILD_DIR)/doraemon.nes
REVISION_LABELS = $(REVISION_BUILD_DIR)/doraemon.lbl
REVISION_MAP = $(REVISION_BUILD_DIR)/doraemon.map
REVISION_DEBUG = $(REVISION_BUILD_DIR)/doraemon.dbg

MANIFEST := assets/manifest.json
VERIFY_ROM := $(RUN_TOOL) build.verify_rom
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
DEBUG_SYMBOLS := config/debugger/debug_symbols.json
DEBUG_BREAKPOINTS := config/debugger/debugger_breakpoints.json
DEBUG_WATCHES := config/debugger/debugger_watches.json
DEBUG_SYMBOL_DIR := build/debugger
RUNTIME_DEBUG_SYMBOLS := config/debugger/runtime_debug_symbols.json
BANK_SOURCES := src/banks/bank_0.asm src/banks/bank_1.asm \
	src/banks/bank_2.asm src/banks/bank_3.asm
SEMANTIC_SOURCES := $(wildcard src/common/*.asm src/shell/*.asm \
	src/rendering/*.asm src/audio/*.asm src/data/*.asm \
	src/world1/*.asm src/world1/data/*.asm \
	src/world2/*.asm src/world2/data/*.asm \
	src/world3/*.asm src/world3/data/*.asm)
SOURCE_FILES := src/main.asm $(BANK_SOURCES) $(SEMANTIC_SOURCES) src/graphics/chr.asm \
	src/memory/hardware.inc src/memory/ram.inc \
	src/revisions/profile_ids.inc src/revisions/original.asm src/revisions/rev_a.asm
GHIDRA_FACTS_DIR := build/ghidra/facts
SYMBOLS := config/reconstruction/symbols.json
SOURCE_MODULES := config/reconstruction/source_modules.json
FCEUX_DIR ?= ../fceux_automation
FCEUX_EXE ?= $(FCEUX_DIR)/vc/x64/Release/fceux64.exe
RUNTIME_SCENARIOS := scenarios/runtime_scenarios.json
RUNTIME_LUA := scripts/runtime/capture_architecture.lua
RUNTIME_TRACE_DIR := build/runtime/traces
RUNTIME_SCREENSHOT_DIR := build/runtime/screens
REVISION_RUNTIME_TRACE_DIR = build/runtime/profiles/$(PROFILE)/traces
REVISION_RUNTIME_SCREENSHOT_DIR = build/runtime/profiles/$(PROFILE)/screens
BANK_GATEWAYS := config/reconstruction/common/bank_gateways.json
COMMON_RUNTIME := config/reconstruction/common/common_runtime.json
CORE_DISPATCH_ROLES := config/reconstruction/common/core_dispatch_roles.json
AUDIO_DISPATCH := config/authoring/audio/audio_dispatch.json
AUDIO_EFFECTS := config/authoring/audio/audio_effects.json
AUDIO_MUSIC := config/authoring/audio/audio_music.json
AUDIO_ARBITRATION := config/authoring/audio/audio_arbitration.json
AUDIO_STREAM_AUTHORING := data/audio/music_streams.json
SHELL_TEXT := config/authoring/text/shell_text.json
SHELL_TEXT_AUTHORING := data/shell/text.json
SHELL_RUNTIME := config/reconstruction/common/shell_runtime.json
OBJECT_POOLS := config/reconstruction/common/object_pools.json
OBJECT_DISPATCH := config/reconstruction/common/object_dispatch.json
OBJECT_PLACEMENTS := config/authoring/world1/object_placements.json
OBJECT_PLACEMENTS_AUTHORING := data/world1/object_data.json
WORLD1_METASPRITES := config/authoring/world1/world1_metasprites.json
WORLD1_METASPRITE_AUTHORING := data/world1/metasprites.json
WORLD1_PALETTES := config/authoring/world1/world1_palettes.json
WORLD1_PALETTE_AUTHORING := data/world1/palettes.json
WORLD1_RANDOM := config/reconstruction/world1/world1_random.json
WORLD1_MAP_DECODER := config/reconstruction/world1/world1_map_decoder.json
WORLD1_PPU_STREAMING := config/reconstruction/world1/world1_ppu_streaming.json
WORLD1_CAMERA := config/reconstruction/world1/world1_camera.json
WORLD1_CAMERA_ENTITIES := config/reconstruction/world1/world1_camera_entities.json
WORLD1_PLAYER_CONTROLS := config/reconstruction/world1/world1_player_controls.json
WORLD1_CORE_ROUTINES := config/reconstruction/world1/world1_core_routines.json
WORLD1_FRAME_MECHANICS := config/reconstruction/world1/world1_frame_mechanics.json
WORLD1_ENTITY_HELPERS := config/reconstruction/world1/world1_entity_helpers.json
WORLD1_FINAL_ROUTINES := config/reconstruction/world1/world1_final_routines.json
WORLD2_FRAME_CORE := config/reconstruction/world2/world2_frame_core.json
WORLD2_PLAYER_SYSTEMS := config/reconstruction/world2/world2_player_systems.json
WORLD2_SCREEN_CORE := config/reconstruction/world2/world2_screen_core.json
WORLD2_PROJECTILE_RUNTIME := config/reconstruction/world2/world2_projectile_runtime.json
WORLD2_SPRITE_RUNTIME := config/reconstruction/world2/world2_sprite_runtime.json
WORLD2_FINAL_ROUTINES := config/reconstruction/world2/world2_final_routines.json
WORLD3_FRAME_CORE := config/reconstruction/world3/world3_frame_core.json
WORLD3_COLLISION_RENDERING := config/reconstruction/world3/world3_collision_rendering.json
WORLD3_ROOM_RUNTIME := config/reconstruction/world3/world3_room_runtime.json
WORLD3_PLAYER_RUNTIME := config/reconstruction/world3/world3_player_runtime.json
WORLD3_INTERACTION_RUNTIME := config/reconstruction/world3/world3_interaction_runtime.json
WORLD3_ENTITY_RUNTIME := config/reconstruction/world3/world3_entity_runtime.json
WORLD3_ROOM_RENDERING := config/reconstruction/world3/world3_room_rendering.json
WORLD3_FORMATION_RUNTIME := config/reconstruction/world3/world3_formation_runtime.json
WORLD3_TRANSITION_RUNTIME := config/reconstruction/world3/world3_transition_runtime.json
WORLD1_WEAPONS := config/authoring/world1/world1_weapons.json
WORLD1_WEAPON_AUTHORING := data/world1/weapons.json
WORLD1_UNDERGROUND_ROOMS := config/authoring/world1/world1_underground_rooms.json
WORLD1_UNDERGROUND_ROOM_AUTHORING := data/world1/underground_rooms.json
WORLD1_ENEMY_HANDLERS := config/reconstruction/world1/world1_enemy_handlers.json
WORLD1_ENEMY_IDENTITIES := config/authoring/world1/world1_enemy_identities.json
WORLD1_DESCRIPTOR_IDENTITIES := config/authoring/world1/world1_descriptor_identities.json
WORLD2_STREAMING := config/authoring/world2/world2_streaming.json
WORLD2_SCREEN_AUTHORING := data/world2/compressed_screens.json
WORLD2_ENEMY_STATES := config/authoring/world2/world2_enemy_states.json
WORLD2_ENEMY_HANDLERS := config/reconstruction/world2/world2_enemy_handlers.json
WORLD2_ENEMY_IDENTITIES := config/authoring/world2/world2_enemy_identities.json
WORLD2_ENEMY_AUTHORING := data/world2/enemy_states.json
WORLD2_STAGE_SEQUENCE := config/authoring/world2/world2_stage_sequence.json
WORLD2_STAGE_AUTHORING := data/world2/stage_sequence.json
WORLD2_STAGE_BRANCHES := config/authoring/world2/world2_stage_branches.json
WORLD2_STAGE_BRANCH_AUTHORING := data/world2/stage_branches.json
WORLD2_INVENTORY := config/authoring/world2/world2_inventory.json
WORLD2_INVENTORY_AUTHORING := data/world2/inventory_spawn_screens.json
WORLD2_METATILES := config/authoring/world2/world2_metatiles.json
WORLD2_METATILE_AUTHORING := data/world2/metatiles.json
WORLD2_PALETTES := config/authoring/world2/world2_palettes.json
WORLD2_PALETTE_AUTHORING := data/world2/palettes.json
WORLD2_METASPRITES := config/authoring/world2/world2_metasprites.json
WORLD2_METASPRITE_AUTHORING := data/world2/metasprites.json
WORLD3_OBJECT_DATA := config/authoring/world3/world3_object_data.json
WORLD3_BEHAVIOR := config/authoring/world3/world3_behavior.json
WORLD3_BEHAVIOR_AUTHORING := data/world3/behavior_streams.json
WORLD3_ENTITY_TYPES := config/authoring/world3/world3_entity_types.json
WORLD3_OBJECT_AUTHORING := data/world3/object_catalog.json
WORLD3_SPAWN_INITIALIZERS := config/authoring/world3/world3_spawn_initializers.json
WORLD3_SPAWN_INITIALIZER_AUTHORING := data/world3/spawn_initializer_data.json
WORLD3_TRANSIENT_SPAWNS := config/authoring/world3/world3_transient_spawns.json
WORLD3_TRANSIENT_SPAWN_AUTHORING := data/world3/transient_spawns.json
WORLD3_UPDATE_HANDLERS := config/authoring/world3/world3_update_handlers.json
WORLD3_UPDATE_HANDLER_AUTHORING := data/world3/update_handler_data.json
WORLD3_PPU_QUEUE := config/reconstruction/world3/world3_ppu_queue.json
WORLD3_METASPRITES := config/authoring/world3/world3_metasprites.json
WORLD3_METASPRITE_AUTHORING := data/world3/metasprites.json
WORLD_DATA := config/authoring/world_data.json
WORLD1_DATA_AUTHORING := data/world1/hierarchical_world.json
WORLD3_DATA_AUTHORING := data/world3/hierarchical_world.json
RECONSTRUCTION_INVENTORY := config/reconstruction/reconstruction_inventory.json
AUTHORING_COVERAGE := config/authoring_coverage.json
RUNTIME_STATE_COVERAGE := config/runtime_state_coverage.json
SOURCE_CLASSIFICATION := config/reconstruction/source_classification.json
TOOLCHAIN := config/toolchain.json
CONTENT_WORKSPACE ?= content/workspace
LEVEL_CONTENT_OUTPUT ?= build/content
LEVEL_CONTENT_ROM = $(LEVEL_CONTENT_OUTPUT)/$(PROFILE)/doraemon-levels.nes
GRAPHICS_CONTENT_OUTPUT ?= build/content
GRAPHICS_CONTENT_ROM = $(GRAPHICS_CONTENT_OUTPUT)/$(PROFILE)/doraemon-graphics.nes
OBJECT_CONTENT_OUTPUT ?= build/content
OBJECT_CONTENT_ROM = $(OBJECT_CONTENT_OUTPUT)/$(PROFILE)/doraemon-objects.nes
TEXT_CONTENT_OUTPUT ?= build/content
TEXT_CONTENT_ROM = $(TEXT_CONTENT_OUTPUT)/$(PROFILE)/doraemon-text.nes
SOUND_CONTENT_OUTPUT ?= build/content
SOUND_CONTENT_ROM = $(SOUND_CONTENT_OUTPUT)/$(PROFILE)/doraemon-sound.nes
SOUND_PREVIEW_ROM = $(SOUND_CONTENT_OUTPUT)/$(PROFILE)/doraemon-sound-preview.nes
COMBINED_CONTENT_OUTPUT ?= build/content
COMBINED_CONTENT_ROM = $(COMBINED_CONTENT_OUTPUT)/$(PROFILE)/doraemon-content.nes
STUDIOS ?= all

MAKE_FRAGMENTS := mk/authoring.mk mk/reconstruction-world1.mk \
	mk/reconstruction-world23.mk mk/runtime.mk mk/validation.mk mk/workflow.mk

all: verify

help:
	@$(RUN_TOOL) build.make_help

$(BUILD_DIR):
	$(RUN_TOOL) build.project mkdir --path "$(BUILD_DIR)"

$(CHR_ASSET):
	$(RUN_TOOL) build.project require --path "$@" --hint "run 'make split' first"

$(PRG_ASSET):
	$(RUN_TOOL) build.project require --path "$@" --hint "run 'make split' first"

verify-build-toolchain:
	$(RUN_TOOL) build.toolchain --manifest "$(TOOLCHAIN)" \
		--component ca65 --ca65 "$(CA65)" \
		--component ld65 --ld65 "$(LD65)"

verify-runtime-toolchain:
	$(RUN_TOOL) build.toolchain --manifest "$(TOOLCHAIN)" \
		--component fceux --fceux "$(FCEUX_EXE)"

$(OBJECT): $(SOURCE_FILES) $(CHR_ASSET) Makefile $(MAKE_FRAGMENTS) | \
	$(BUILD_DIR) verify-build-toolchain
	$(CA65) --debug-info -g -o "$@" -l "$(BUILD_DIR)/doraemon.lst" "src/main.asm"

$(ROM): $(OBJECT) config/linker/gnrom.cfg | verify-build-toolchain
	$(LD65) -C config/linker/gnrom.cfg -o "$@" "$<" -Ln "$(LABELS)" -m "$(MAP)" --dbgfile "$(DEBUG)"

build: $(ROM)

$(REVISION_BUILD_DIR):
	$(RUN_TOOL) build.project mkdir --path "$(REVISION_BUILD_DIR)"

$(REVISION_OBJECT): $(SOURCE_FILES) $(CHR_ASSET) Makefile $(MAKE_FRAGMENTS) | \
	$(REVISION_BUILD_DIR) verify-build-toolchain
	$(CA65) --debug-info -g -o "$@" -l "$(REVISION_BUILD_DIR)/doraemon.lst" \
		"$(REVISION_SOURCE)"

$(REVISION_ROM): $(REVISION_OBJECT) config/linker/gnrom.cfg | verify-build-toolchain
	$(LD65) -C config/linker/gnrom.cfg -o "$@" "$<" \
		-Ln "$(REVISION_LABELS)" -m "$(REVISION_MAP)" --dbgfile "$(REVISION_DEBUG)"

build-revision: $(REVISION_ROM)

verify-revision: $(REVISION_ROM)
	$(RUN_TOOL) build.revision_profiles --manifest "$(REVISION_PROFILES)" \
		verify --profile "$(PROFILE)" --reference-rom "$(REVISION_REFERENCE)" \
		--built-rom "$(REVISION_ROM)"

verify-revisions:
	$(MAKE) verify-revision PROFILE=original
	$(MAKE) verify-revision PROFILE=rev_a

split:
	$(RUN_TOOL) build.project split --image "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --output-dir "$(GENERATED_ASSET_DIR)"

verify-reference:
	$(RUN_TOOL) build.project verify --image "$(REFERENCE_ROM)" --manifest "$(MANIFEST)"

verify-built: $(ROM)
	$(RUN_TOOL) build.project verify --image "$(ROM)" --manifest "$(MANIFEST)"

verify-header: $(ROM)
	$(VERIFY_ROM) compare --built "$(ROM)" --reference "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --region header

verify-prg: $(ROM)
	$(VERIFY_ROM) compare --built "$(ROM)" --reference "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --region prg

verify-chr: $(ROM)
	$(VERIFY_ROM) compare --built "$(ROM)" --reference "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --region chr

verify-payload: $(ROM)
	$(VERIFY_ROM) compare --built "$(ROM)" --reference "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --region payload

verify-rom: $(ROM)
	$(VERIFY_ROM) compare --built "$(ROM)" --reference "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --region rom

verify-assets: $(PRG_ASSET) $(CHR_ASSET)
	$(VERIFY_ROM) asset --asset "$(PRG_ASSET)" --reference "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --region prg
	$(VERIFY_ROM) asset --asset "$(CHR_ASSET)" --reference "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --region chr

verify: verify-reference verify-built verify-header verify-prg verify-chr verify-payload verify-rom verify-assets

rom-info-reference:
	$(VERIFY_ROM) report --image "$(REFERENCE_ROM)" --manifest "$(MANIFEST)"

rom-info-built: $(ROM)
	$(VERIFY_ROM) report --image "$(ROM)" --manifest "$(MANIFEST)"

rom-info: rom-info-reference rom-info-built

inspect: rom-info-reference

audit-revisions:
	$(RUN_TOOL) build.revision_profiles --manifest "$(REVISION_PROFILES)" \
		audit --base-rom "$(REVISION_ORIGINAL_ROM)" \
		--candidate-rom "$(REVISION_REV_A_ROM)"

split-revision-assets:
	$(RUN_TOOL) build.revision_profiles --manifest "$(REVISION_PROFILES)" \
		split --profile "$(PROFILE)" --reference-rom "$(REVISION_REFERENCE)" \
		--output-dir "$(GENERATED_ASSET_DIR)/revisions"

bank-info:
	$(RUN_TOOL) build.project banks --image "$(REFERENCE_ROM)" --manifest "$(MANIFEST)"


include mk/authoring.mk mk/reconstruction-world1.mk mk/reconstruction-world23.mk \
	mk/runtime.mk mk/validation.mk mk/workflow.mk

clean:
	$(RUN_TOOL) build.project clean --path build
