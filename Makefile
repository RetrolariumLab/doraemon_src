# Doraemon: build the source back into both Japanese revisions and check it.
# `make` alone lists the targets.
PYTHON ?= python
RLTOOL ?= rltool
export RLTOOL
# cc65 from Retrolarium Kit, which verifies it; asked once, when a recipe
# first needs it (the recipes' shell wants forward slashes).
CA65 ?= $(eval CA65 := $$(subst \,/,$$(shell $$(RLTOOL) build-tools path nes ca65)))$(CA65)
LD65 ?= $(eval LD65 := $$(subst \,/,$$(shell $$(RLTOOL) build-tools path nes ld65)))$(LD65)

GAME := doraemon
BASE_IMAGE := original
# The revisions the source builds, one entry file each; REVISION picks one.
REVISIONS := $(basename $(notdir $(wildcard src/revisions/*.asm)))
REVISION ?= $(BASE_IMAGE)
LINKER_CONFIG := config/linker/gnrom.cfg
OUT = build/revisions/$(REVISION)
ROM = $(OUT)/$(GAME).nes
# The revisions whose ROM is here (assets/manifest.json names the files).
PRESENT = $(filter $(REVISIONS),$(shell $(RLTOOL) assets images --present))

define newline


endef

# Assemble and link one entry file: $(call build_rom,<entry>,<output folder>)
build_rom = $(PYTHON) -c "from pathlib import Path; Path('$(2)').mkdir(parents=True, exist_ok=True)"$(newline)\
	$(CA65) -I src --debug-info -g -o "$(2)/$(GAME).o" -l "$(2)/$(GAME).lst" "$(1)"$(newline)\
	$(LD65) -C $(LINKER_CONFIG) -o "$(2)/$(GAME).nes" "$(2)/$(GAME).o" -Ln "$(2)/$(GAME).lbl" \
		-m "$(2)/$(GAME).map" --dbgfile "$(2)/$(GAME).dbg"

.PHONY: help split build verify verify-revisions studio-check profile-check lint format test \
	hooks clean _revision
.DEFAULT_GOAL := help

split:
	$(RLTOOL) assets split

_revision:
	$(if $(filter $(REVISION),$(REVISIONS)),,$(error REVISION=$(REVISION) is not one of: $(REVISIONS)))
	$(RLTOOL) assets check --image $(BASE_IMAGE)

# Every build assembles anew: it takes a second, and nothing it reads
# (source, linker config, CHR) can be missed.
build: _revision
	$(call build_rom,src/revisions/$(REVISION).asm,$(OUT))

verify: build
	$(RLTOOL) assets verify --image $(REVISION) --built "$(ROM)"

# Every revision whose ROM is here, byte for byte.
verify-revisions:
	$(if $(PRESENT),,$(error none of the ROMs of $(REVISIONS) is here: copy them beside this Makefile and make split))
	$(foreach revision,$(PRESENT),$(MAKE) --no-print-directory verify REVISION=$(revision)$(newline))

# Open the revisions of doraemon.rlj whose ROM is here in a throwaway copy of
# the repository the way Retrolarium Studio does, and rebuild each without
# edits.
studio-check:
	$(RLTOOL) studio check doraemon.rlj --present

# The table places config/game_profile.json records, against the builds.
profile-check:
	$(RLTOOL) profile tables --check $(foreach revision,$(PRESENT),--revision $(revision))

lint:
	$(RLTOOL) lint

format:
	$(RLTOOL) lint --fix

# The quick suite: every revision here byte for byte, the profile's table
# places and the studio check. There is no emulator run yet: the source does
# not survive moving its code (docs/unknowns.md).
test:
	$(MAKE) --no-print-directory verify-revisions
	$(MAKE) --no-print-directory profile-check studio-check

# `make hooks`, once per clone, makes Git check every commit and push for stop
# words and run `make lint` first (Retrolarium Kit's rltool hooks; the
# stop-word list lives outside the repositories).
hooks:
	$(RLTOOL) hooks install --project .

clean:
	$(PYTHON) -c "import shutil; shutil.rmtree('build', ignore_errors=True)"

help:
	$(info Doraemon source reconstruction: $(REVISIONS), REVISION=$(BASE_IMAGE) unless given)
	$(info   make split                  cut the assets out of the ROMs that are here, once)
	$(info   make build [REVISION=id]    build a revision into build/revisions/id/)
	$(info   make verify [REVISION=id]   build it and compare it with its ROM byte for byte)
	$(info   make verify-revisions       every revision whose ROM is here)
	$(info   make test                   the quick suite)
	$(info   make studio-check / profile-check / lint / format / hooks / clean)
	@exit 0
