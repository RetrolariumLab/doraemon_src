# Doraemon: build the source back into the Japanese ROM and check it.
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
LINKER_CONFIG := config/linker/gnrom.cfg
OUT := build/revisions/$(BASE_IMAGE)
ROM := $(OUT)/$(GAME).nes

define newline


endef

# Assemble and link: $(call build_rom,<source>,<output folder>)
build_rom = $(PYTHON) -c "from pathlib import Path; Path('$(2)').mkdir(parents=True, exist_ok=True)"$(newline)\
	$(CA65) -I src --debug-info -g -o "$(2)/$(GAME).o" -l "$(2)/$(GAME).lst" "$(1)"$(newline)\
	$(LD65) -C $(LINKER_CONFIG) -o "$(2)/$(GAME).nes" "$(2)/$(GAME).o" -Ln "$(2)/$(GAME).lbl" \
		-m "$(2)/$(GAME).map" --dbgfile "$(2)/$(GAME).dbg"

.PHONY: help split build verify verify-revisions studio-check profile-check lint format test \
	hooks clean _assets
.DEFAULT_GOAL := help

split:
	$(RLTOOL) assets split

_assets:
	$(RLTOOL) assets check --image $(BASE_IMAGE)

# Every build assembles anew: it takes a second, and nothing it reads
# (source, linker config, CHR) can be missed.
build: _assets
	$(call build_rom,src/main.asm,$(OUT))

verify: build
	$(RLTOOL) assets verify --image $(BASE_IMAGE) --built "$(ROM)"

# Doraemon has one revision.
verify-revisions: verify

# Open doraemon.rlj in a throwaway copy of the repository the way Retrolarium
# Studio does, and rebuild it without edits.
studio-check:
	$(RLTOOL) studio check doraemon.rlj

# The table places config/game_profile.json records, against the builds.
profile-check:
	$(RLTOOL) profile tables --check

lint:
	$(RLTOOL) lint

format:
	$(RLTOOL) lint --fix

# The quick suite: the ROM byte for byte, the profile's table places and the
# studio check. There is no emulator run yet: the source does
# not survive moving its code (docs/unknowns.md).
test:
	$(MAKE) --no-print-directory verify profile-check studio-check

# `make hooks`, once per clone, makes Git check every commit and push for stop
# words and run `make lint` first (Retrolarium Kit's rltool hooks; the
# stop-word list lives outside the repositories).
hooks:
	$(RLTOOL) hooks install --project .

clean:
	$(PYTHON) -c "import shutil; shutil.rmtree('build', ignore_errors=True)"

help:
	$(info Doraemon source reconstruction)
	$(info   make split                  cut the assets out of the ROM, once)
	$(info   make build                  build the ROM into build/revisions/original/)
	$(info   make verify                 build it and compare it with the ROM byte for byte)
	$(info   make test                   the quick suite)
	$(info   make studio-check / profile-check / lint / format / hooks / clean)
	@exit 0
