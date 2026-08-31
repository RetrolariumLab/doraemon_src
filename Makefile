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
SOURCE_FILES := src/main.asm $(BANK_SOURCES) src/graphics/chr.asm \
	src/memory/hardware.inc src/memory/ram.inc
GHIDRA_FACTS_DIR := build/ghidra/facts
SYMBOLS := config/symbols.json

.PHONY: all build split verify verify-reference verify-built verify-header \
	verify-prg verify-chr verify-payload verify-rom verify-assets inspect \
	rom-info rom-info-reference rom-info-built bank-info format format-check \
	lint lint-asm lint-source lint-project test quality-check scaffold-check \
	ghidra-bootstrap ghidra-status ghidra-inspect ghidra-analyze disassemble \
	disassembly-check maps validate-maps release-check check clean

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

ghidra-bootstrap:
	$(PYTHON) scripts/bootstrap_ghidra.py install

ghidra-status:
	$(PYTHON) scripts/bootstrap_ghidra.py status

ghidra-inspect:
	$(PYTHON) scripts/run_ghidra.py inspect --image "$(REFERENCE_ROM)" --output build/ghidra/program.json

ghidra-analyze:
	$(PYTHON) scripts/run_ghidra.py export-facts --image "$(REFERENCE_ROM)" --output-dir "$(GHIDRA_FACTS_DIR)"

disassemble: ghidra-analyze $(PRG_ASSET)
	$(PYTHON) scripts/generate_disassembly.py write --prg "$(PRG_ASSET)" --facts-dir "$(GHIDRA_FACTS_DIR)" --symbols "$(SYMBOLS)" --output-dir src/banks

disassembly-check: ghidra-analyze $(PRG_ASSET)
	$(PYTHON) scripts/generate_disassembly.py check --prg "$(PRG_ASSET)" --facts-dir "$(GHIDRA_FACTS_DIR)" --symbols "$(SYMBOLS)" --output-dir src/banks

maps: $(ROM)
	$(PYTHON) scripts/map_data.py --image "$(ROM)" --pretty

validate-maps: $(ROM)
	$(PYTHON) scripts/map_data.py --image "$(ROM)" --validate

release-check: quality-check disassembly-check verify validate-maps

check: release-check

clean:
	$(PYTHON) scripts/project.py clean --path build

# Extract local ROM payloads before tools inspect or assemble the source.
.PHONY: _rom_assets
_rom_assets:
	$(PYTHON) scripts/rom_assets.py ensure
build lint split init build-profile build-revision build-fixed-layout init-content build-content check-content-zero-edit check-studios: _rom_assets
