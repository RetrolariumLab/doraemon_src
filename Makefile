# Doraemon: build the source back into both Japanese revisions and check it.
# `make help` lists the targets.
PYTHON ?= python
# cc65 from Retrolarium Kit (RLTOOL, default rltool), asked once per run; the
# recipes' shell needs forward slashes.
RLTOOL ?= rltool
export RLTOOL
CA65 ?= $(eval CA65 := $$(subst \,/,$$(shell $$(RLTOOL) build-tools path nes ca65)))$(CA65)
LD65 ?= $(eval LD65 := $$(subst \,/,$$(shell $$(RLTOOL) build-tools path nes ld65)))$(LD65)

# The private assets: assets/manifest.json names the ROMs and what `make split`
# cuts out of them; `rltool assets` (Retrolarium Kit) splits, checks and
# verifies.
ASSETS = $(RLTOOL) assets $(1)
BASE_IMAGE := original
# The revisions: the image ids of assets/manifest.json, each built from
# src/revisions/<id>.asm.
REVISION ?= rev_a
BUILD_DIR := build/native
ROM := $(BUILD_DIR)/doraemon.nes
REVISION_ROM = build/revisions/$(REVISION)/doraemon.nes
SOURCE_FILES := $(sort $(wildcard src/*.asm src/*/*.asm src/*/*/*.asm src/*/*.inc))

# One build of an entry point: $(call build_rom,<entry point>,<output ROM>)
build_rom = $(PYTHON) -c "from pathlib import Path; Path('$(dir $(2))').mkdir(parents=True, exist_ok=True)" && \
	$(CA65) --debug-info -g -o "$(basename $(2)).o" -l "$(basename $(2)).lst" "$(1)" && \
	$(LD65) -C config/linker/gnrom.cfg -o "$(2)" "$(basename $(2)).o" -Ln "$(basename $(2)).lbl" \
		-m "$(basename $(2)).map" --dbgfile "$(basename $(2)).dbg"

.PHONY: all help build verify build-revision verify-revision verify-revisions split \
	_require-assets verify-toolchain studio-check lint format format-check test hooks clean

all: verify

split:
	$(call ASSETS,split)

_require-assets:
	$(call ASSETS,check) --image $(BASE_IMAGE)

$(ROM): $(SOURCE_FILES) Makefile | verify-toolchain _require-assets
	$(call build_rom,src/main.asm,$@)

build: $(ROM)

verify: $(ROM)
	$(call ASSETS,verify) --image $(BASE_IMAGE) --built "$(ROM)"

# One revision (REVISION=<image id>).
build-revision: verify-toolchain _require-assets
	$(call build_rom,src/revisions/$(REVISION).asm,$(REVISION_ROM))

verify-revision: build-revision
	$(call ASSETS,verify) --image $(REVISION) --built "$(REVISION_ROM)"

# Every revision whose ROM is here.
verify-revisions:
	@for revision in $$($(call ASSETS,images) --present); do \
		$(MAKE) --no-print-directory verify-revision REVISION=$$revision || exit 1; \
	done

verify-toolchain:
	$(PYTHON) scripts/build/toolchain.py --manifest config/toolchain.json \
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
	$(PYTHON) -c "import shutil; shutil.rmtree('build', ignore_errors=True)"

help:
	@echo "Doraemon source reconstruction"
	@echo "  make split                 cut the assets out of the ROMs that are here (once)"
	@echo "  make build / verify        the original revision / and byte for byte"
	@echo "  make build-revision REVISION=<id> / verify-revision / verify-revisions"
	@echo "                             the revisions (image ids of assets/manifest.json)"
	@echo "  make studio-check          open and rebuild every doraemon.rlj revision"
	@echo "  make test                  the checks"
	@echo "  make lint / format / format-check   the house style (Retrolarium Kit)"
	@echo "  make hooks                 install the Git hooks"
	@echo "  make verify-toolchain / clean"
