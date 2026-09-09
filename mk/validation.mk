# Repository quality, release audits, and aggregate validation gates.

.PHONY: all help build split verify verify-reference verify-built verify-header \
	verify-prg verify-chr verify-payload verify-rom verify-assets inspect \
	rom-info rom-info-reference rom-info-built bank-info format format-check \
	lint lint-asm lint-source lint-project test quality-check scaffold-check \
	public-command-smoke \
	ghidra-bootstrap ghidra-status ghidra-inspect ghidra-analyze disassemble \
	disassembly-check maps validate-maps release-check check clean \
	source-audit source-release-audit source-pre-tag-audit source-check \
	source-1-check source-1-audit source-1-post-tag-audit source-1-post-tag-remote-audit \
	trace trace-runtime trace-runtime-revision validate-runtime-revision \
	runtime-revision-matrix \
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
	world-data validate-world-data \
	audit-revisions split-revision-assets build-revision verify-revision \
	verify-revisions \
	level-content-init level-content-check level-content-export level-content-rom \
	level-content-roundtrip level-studio \
	graphics-content-init graphics-content-check graphics-content-export \
	graphics-content-rom graphics-content-roundtrip graphics-studio \
	check-graphics-studio \
	object-content-init object-content-check object-content-export \
	object-content-rom object-content-roundtrip object-studio \
	check-object-studio \
	text-content-init text-content-check text-content-export \
	text-content-rom text-content-roundtrip text-studio check-text-studio \
	sound-content-init sound-content-check sound-content-export \
	sound-content-rom sound-preview-rom sound-content-roundtrip sound-studio check-sound-studio \
	check-sound-preview \
	content-init content-check content-export content-rom content-roundtrip \
	check-level-studio check-studios check-studio-interactions \
	source-2-audit source-2-check \
	source-2-pre-tag-check source-2-tag-check

format:
	$(RUN_TOOL) validation.asm_style --fix src
	$(RUN_TOOL) validation.format_project write
	$(MAKE) lint

format-check: lint-asm

lint-asm:
	$(RUN_TOOL) validation.asm_style src

lint-source:
	$(RUN_TOOL) validation.format_project check
	$(RUN_TOOL) build.project lint

lint-project: lint-source

lint: lint-asm lint-source

test:
	$(PYTHON) -m unittest discover -s tests -t . -v

quality-check: lint test

scaffold-check: quality-check

public-command-smoke:
	$(RUN_TOOL) validation.public_command_smoke --project-root . --target lint

source-audit:
	$(RUN_TOOL) validation.release.source_reconstruction_audit

source-release-audit:
	$(RUN_TOOL) validation.release.source_reconstruction_audit --phase pre-tag

source-pre-tag-audit:
	$(RUN_TOOL) validation.release.source_reconstruction_audit --phase pre-tag --check-remote

reconstruction-inventory validate-reconstruction-inventory:
	$(RUN_TOOL) validation.release.reconstruction_inventory \
		--manifest "$(RECONSTRUCTION_INVENTORY)"

authoring-coverage validate-authoring-coverage:
	$(RUN_TOOL) validation.release.authoring_coverage \
		--manifest "$(AUTHORING_COVERAGE)" \
		--reconstruction "config/source_reconstruction.json" \
		--makefile "Makefile"

runtime-state-coverage validate-runtime-state-coverage:
	$(RUN_TOOL) validation.release.runtime_state_coverage \
		--manifest "$(RUNTIME_STATE_COVERAGE)" \
		--makefile "Makefile"

source-classification validate-source-classification: $(ROM)
	$(RUN_TOOL) validation.release.source_classification \
		--manifest "$(SOURCE_CLASSIFICATION)"

source-check: release-check source-audit

source-1-check:
	$(MAKE) release-check
	$(MAKE) trace
	$(MAKE) validate-runtime-debug-symbols

source-1-audit:
	$(RUN_TOOL) validation.release.source_reconstruction_audit --phase pre-tag --check-remote
	$(MAKE) source-check
	$(MAKE) trace
	$(MAKE) validate-runtime-debug-symbols
	$(RUN_TOOL) validation.release.source_reconstruction_audit --phase pre-tag --check-remote --require-clean

source-1-post-tag-audit:
	$(RUN_TOOL) validation.release.source_reconstruction_audit --phase post-tag --require-clean

source-1-post-tag-remote-audit:
	$(RUN_TOOL) validation.release.source_reconstruction_audit --phase post-tag \
		--check-remote --require-clean

source-2-audit:
	$(RUN_TOOL) validation.release.source_2_audit --manifest "$(SOURCE_2_MANIFEST)"

source-2-check:
	$(MAKE) source-1-check
	$(MAKE) audit-revisions
	$(MAKE) verify-revisions
	$(MAKE) level-content-roundtrip
	$(MAKE) graphics-content-roundtrip
	$(MAKE) object-content-roundtrip
	$(MAKE) text-content-roundtrip
	$(MAKE) sound-content-roundtrip
	$(MAKE) content-roundtrip
	$(MAKE) check-studios
	$(MAKE) check-studio-interactions
	$(MAKE) check-sound-preview PROFILE=original
	$(MAKE) check-sound-preview PROFILE=rev_a
	$(MAKE) runtime-revision-matrix
	$(MAKE) source-2-audit

source-2-pre-tag-check:
	$(MAKE) source-2-check
	$(RUN_TOOL) validation.release.source_2_audit --manifest "$(SOURCE_2_MANIFEST)" \
		--phase pre-tag --require-ready --require-clean --check-remote

source-2-tag-check:
	$(MAKE) source-2-check
	$(RUN_TOOL) validation.release.source_2_audit --manifest "$(SOURCE_2_MANIFEST)" \
		--phase post-tag --require-ready --require-clean

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
