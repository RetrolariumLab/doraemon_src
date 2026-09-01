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
AUDIO_DISPATCH := config/audio_dispatch.json
OBJECT_POOLS := config/object_pools.json
OBJECT_DISPATCH := config/object_dispatch.json
OBJECT_PLACEMENTS := config/object_placements.json
OBJECT_PLACEMENTS_AUTHORING := data/world1/object_data.json
WORLD2_STREAMING := config/world2_streaming.json
WORLD2_SCREEN_AUTHORING := data/world2/compressed_screens.json
WORLD2_ENEMY_STATES := config/world2_enemy_states.json
WORLD2_ENEMY_AUTHORING := data/world2/enemy_states.json
WORLD3_OBJECT_DATA := config/world3_object_data.json
WORLD3_BEHAVIOR := config/world3_behavior.json
WORLD3_BEHAVIOR_AUTHORING := data/world3/behavior_streams.json
WORLD3_ENTITY_TYPES := config/world3_entity_types.json
WORLD3_OBJECT_AUTHORING := data/world3/object_catalog.json
WORLD_DATA := config/world_data.json
WORLD1_DATA_AUTHORING := data/world1/hierarchical_world.json
WORLD3_DATA_AUTHORING := data/world3/hierarchical_world.json

.PHONY: all build split verify verify-reference verify-built verify-header \
	verify-prg verify-chr verify-payload verify-rom verify-assets inspect \
	rom-info rom-info-reference rom-info-built bank-info format format-check \
	lint lint-asm lint-source lint-project test quality-check scaffold-check \
	ghidra-bootstrap ghidra-status ghidra-inspect ghidra-analyze disassemble \
	disassembly-check maps validate-maps release-check check clean \
	source-audit source-release-audit source-check trace-runtime \
	validate-runtime runtime-architecture bank-gateways validate-bank-gateways \
	audio-dispatch validate-audio-dispatch object-pools validate-object-pools \
	object-dispatch validate-object-dispatch object-placements \
	validate-object-placements world2-streaming validate-world2-streaming \
	world2-enemy-states validate-world2-enemy-states \
	world3-object-data validate-world3-object-data world3-behavior \
	validate-world3-behavior world3-entity-types validate-world3-entity-types \
	world3-object-catalog validate-world3-object-catalog \
	world-data validate-world-data

all: verify

$(BUILD_DIR):
	$(PYTHON) scripts/project.py mkdir --path "$(BUILD_DIR)"

$(CHR_ASSET):
	$(PYTHON) scripts/project.py require --path "$@" --hint "run 'make split' first"

$(PRG_ASSET):
	$(PYTHON) scripts/project.py require --path "$@" --hint "run 'make split' first"

$(OBJECT): $(SOURCE_FILES) $(CHR_ASSET) | $(BUILD_DIR)
	$(CA65) --debug-info -g -o "$@" -l "$(BUILD_DIR)/doraemon.lst" "src/main.asm"

$(ROM): $(OBJECT) config/linker/gnrom.cfg
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
	$(PYTHON) scripts/source_reconstruction_audit.py --require-ready

source-check: release-check source-audit

trace-runtime: verify-reference
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

runtime-architecture: validate-bank-gateways trace-runtime validate-runtime

bank-gateways: $(PRG_ASSET)
	$(PYTHON) scripts/bank_gateways.py --prg "$(PRG_ASSET)" \
		--manifest "$(BANK_GATEWAYS)" --source-root src --pretty

validate-bank-gateways: $(PRG_ASSET)
	$(PYTHON) scripts/bank_gateways.py --prg "$(PRG_ASSET)" \
		--manifest "$(BANK_GATEWAYS)" --source-root src

audio-dispatch validate-audio-dispatch: $(PRG_ASSET)
	$(PYTHON) scripts/audio_dispatch.py --prg "$(PRG_ASSET)" \
		--manifest "$(AUDIO_DISPATCH)" \
		--code-entries config/prg_code_entries.txt

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

release-check: quality-check disassembly-check verify validate-maps \
	validate-audio-dispatch validate-object-pools validate-object-dispatch \
	validate-object-placements validate-world2-streaming \
	validate-world2-enemy-states \
	validate-world3-object-data validate-world3-behavior \
	validate-world3-entity-types validate-world3-object-catalog \
	validate-world-data

check: release-check

clean:
	$(PYTHON) scripts/project.py clean --path build

# Extract local ROM payloads before tools inspect or assemble the source.
.PHONY: _rom_assets
_rom_assets:
	$(PYTHON) scripts/rom_assets.py ensure
build lint split init build-profile build-revision build-fixed-layout init-content build-content check-content-zero-edit check-studios: _rom_assets
