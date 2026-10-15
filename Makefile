# Doraemon: build the source back into both Japanese revisions and check it.
# `make help` lists the targets.
PYTHON ?= python
RUN_TOOL := $(PYTHON) scripts/run.py
# cc65 from Retrolarium Kit (RLTOOL, default rltool), asked once per run; the
# recipes' shell needs forward slashes.
RLTOOL ?= rltool
export RLTOOL
CA65 ?= $(eval CA65 := $$(subst \,/,$$(shell $$(RLTOOL) build-tools path nes ca65)))$(CA65)
LD65 ?= $(eval LD65 := $$(subst \,/,$$(shell $$(RLTOOL) build-tools path nes ld65)))$(LD65)

REFERENCE_ROM ?= Doraemon (J) (PRG0) [!].nes
REVISION_ORIGINAL_ROM ?= Doraemon (J) (PRG0) [!].nes
REVISION_REV_A_ROM ?= Doraemon (Japan) (Rev A).nes
REVISION_PROFILES := config/revision_profiles.json
PROFILE ?= original
ifeq ($(PROFILE),rev_a)
REVISION_REFERENCE ?= $(REVISION_REV_A_ROM)
else
REVISION_REFERENCE ?= $(REVISION_ORIGINAL_ROM)
endif
REVISION_BUILD_DIR = build/revisions/$(PROFILE)
REVISION_OBJECT = $(REVISION_BUILD_DIR)/doraemon.o
REVISION_ROM = $(REVISION_BUILD_DIR)/doraemon.nes

MANIFEST := assets/manifest.json
VERIFY_ROM := $(RUN_TOOL) build.verify_rom
BUILD_DIR := build/native
GENERATED_ASSET_DIR := assets/generated
PRG_ASSET := $(GENERATED_ASSET_DIR)/prg/doraemon.prg
CHR_ASSET := $(GENERATED_ASSET_DIR)/chr/doraemon.chr
OBJECT := $(BUILD_DIR)/doraemon.o
ROM := $(BUILD_DIR)/doraemon.nes
LABELS := $(BUILD_DIR)/doraemon.lbl
MAP := $(BUILD_DIR)/doraemon.map
DEBUG := $(BUILD_DIR)/doraemon.dbg
SOURCE_FILES := $(sort $(wildcard src/*.asm src/*/*.asm src/*/*/*.asm src/*/*.inc))

.PHONY: all help build clean split verify verify-reference verify-built verify-header \
	verify-prg verify-chr verify-payload verify-rom verify-assets rom-info rom-info-reference \
	rom-info-built bank-info build-revision verify-revision verify-revisions audit-revisions \
	split-revision-assets verify-toolchain studio-check lint format format-check test hooks

all: verify

$(BUILD_DIR) $(REVISION_BUILD_DIR):
	$(RUN_TOOL) build.project mkdir --path "$@"

$(CHR_ASSET) $(PRG_ASSET):
	$(RUN_TOOL) build.project require --path "$@" --hint "run 'make split' first"

$(OBJECT): $(SOURCE_FILES) $(CHR_ASSET) Makefile | $(BUILD_DIR) verify-toolchain
	$(CA65) --debug-info -g -o "$@" -l "$(BUILD_DIR)/doraemon.lst" "src/main.asm"

$(ROM): $(OBJECT) config/linker/gnrom.cfg
	$(LD65) -C config/linker/gnrom.cfg -o "$@" "$<" -Ln "$(LABELS)" -m "$(MAP)" --dbgfile "$(DEBUG)"

build: $(ROM)

split:
	$(RUN_TOOL) build.project split --image "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --output-dir "$(GENERATED_ASSET_DIR)"

verify-reference:
	$(RUN_TOOL) build.project verify --image "$(REFERENCE_ROM)" --manifest "$(MANIFEST)"

verify-built: $(ROM)
	$(RUN_TOOL) build.project verify --image "$(ROM)" --manifest "$(MANIFEST)"

verify-header verify-prg verify-chr verify-payload verify-rom: $(ROM)
	$(VERIFY_ROM) compare --built "$(ROM)" --reference "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --region $(subst verify-,,$@)

verify-assets: $(PRG_ASSET) $(CHR_ASSET)
	$(VERIFY_ROM) asset --asset "$(PRG_ASSET)" --reference "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --region prg
	$(VERIFY_ROM) asset --asset "$(CHR_ASSET)" --reference "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --region chr

verify: verify-reference verify-built verify-header verify-prg verify-chr verify-payload \
	verify-rom verify-assets

rom-info-reference:
	$(VERIFY_ROM) report --image "$(REFERENCE_ROM)" --manifest "$(MANIFEST)"

rom-info-built: $(ROM)
	$(VERIFY_ROM) report --image "$(ROM)" --manifest "$(MANIFEST)"

rom-info: rom-info-reference rom-info-built

bank-info:
	$(RUN_TOOL) build.project banks --image "$(REFERENCE_ROM)" --manifest "$(MANIFEST)"

# The two Japanese revisions (config/revision_profiles.json), PROFILE=original
# or rev_a.
$(REVISION_OBJECT): $(SOURCE_FILES) $(CHR_ASSET) Makefile | $(REVISION_BUILD_DIR) verify-toolchain
	$(CA65) --debug-info -g -o "$@" -l "$(REVISION_BUILD_DIR)/doraemon.lst" "src/revisions/$(PROFILE).asm"

$(REVISION_ROM): $(REVISION_OBJECT) config/linker/gnrom.cfg
	$(LD65) -C config/linker/gnrom.cfg -o "$@" "$<" -Ln "$(REVISION_BUILD_DIR)/doraemon.lbl" \
		-m "$(REVISION_BUILD_DIR)/doraemon.map" --dbgfile "$(REVISION_BUILD_DIR)/doraemon.dbg"

build-revision: $(REVISION_ROM)

verify-revision: $(REVISION_ROM)
	$(RUN_TOOL) build.revision_profiles --manifest "$(REVISION_PROFILES)" \
		verify --profile "$(PROFILE)" --reference-rom "$(REVISION_REFERENCE)" \
		--built-rom "$(REVISION_ROM)"

verify-revisions:
	$(MAKE) --no-print-directory verify-revision PROFILE=original
	$(MAKE) --no-print-directory verify-revision PROFILE=rev_a

audit-revisions:
	$(RUN_TOOL) build.revision_profiles --manifest "$(REVISION_PROFILES)" \
		audit --base-rom "$(REVISION_ORIGINAL_ROM)" --candidate-rom "$(REVISION_REV_A_ROM)"

split-revision-assets:
	$(RUN_TOOL) build.revision_profiles --manifest "$(REVISION_PROFILES)" \
		split --profile "$(PROFILE)" --reference-rom "$(REVISION_REFERENCE)" \
		--output-dir "$(GENERATED_ASSET_DIR)/revisions"

verify-toolchain:
	$(RUN_TOOL) build.toolchain --manifest config/toolchain.json \
		--component ca65 --ca65 "$(CA65)" --component ld65 --ld65 "$(LD65)"

# Open every revision of doraemon.rlj in a throwaway copy of the repository
# the way Retrolarium Studio does, and rebuild each without edits.
studio-check:
	$(RLTOOL) studio check doraemon.rlj

lint:
	$(RLTOOL) lint

format:
	$(RLTOOL) lint --fix

format-check:
	$(RLTOOL) lint --only assembly

# The checks: the unit tests, both revisions byte for byte and the studio
# check. There is no emulator run yet: the source does not survive moving its
# code (README, "Status").
test:
	$(PYTHON) -m unittest discover -s tests -t .
	$(MAKE) --no-print-directory verify verify-revisions studio-check

# `make hooks`, once per clone, makes Git check every commit and push for stop
# words and run `make lint` and `make format-check` first (Retrolarium Kit's
# rltool hooks; the stop-word list lives outside the repositories).
hooks:
	$(RLTOOL) hooks install --project .

clean:
	$(RUN_TOOL) build.project clean --path build

help:
	@echo "Doraemon source reconstruction"
	@echo "  make split                 unpack the assets from your Doraemon ROM (once)"
	@echo "  make build / verify        the original revision / and byte for byte"
	@echo "  make verify-revisions      both revisions (PROFILE=original|rev_a for one)"
	@echo "  make studio-check          open and rebuild every doraemon.rlj revision"
	@echo "  make test                  the checks"
	@echo "  make lint / format / format-check   the house style (Retrolarium Kit)"
	@echo "  make hooks                 install the Git hooks"
	@echo "  make rom-info / bank-info / audit-revisions / verify-toolchain / clean"
