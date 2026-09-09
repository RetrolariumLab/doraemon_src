# Headless content workflows and interactive studio entry points.

level-content-init:
	$(RUN_TOOL) authoring.level_workspace init \
		--workspace "$(CONTENT_WORKSPACE)" --profile "$(PROFILE)"

level-content-check:
	$(RUN_TOOL) authoring.level_workspace validate \
		--workspace "$(CONTENT_WORKSPACE)" --profile "$(PROFILE)"

level-content-export:
	$(RUN_TOOL) authoring.level_workspace export \
		--workspace "$(CONTENT_WORKSPACE)" --profile "$(PROFILE)" \
		--output "$(LEVEL_CONTENT_OUTPUT)"

level-content-rom: build-revision level-content-check
	$(RUN_TOOL) authoring.level_content_rom \
		--base-rom "$(REVISION_ROM)" --profile "$(PROFILE)" \
		--workspace "$(CONTENT_WORKSPACE)" --output "$(LEVEL_CONTENT_ROM)"

level-content-roundtrip: verify-revisions
	$(RUN_TOOL) authoring.level_content_rom --canonical \
		--require-identical --profile original \
		--base-rom "build/revisions/original/doraemon.nes" \
		--output "$(LEVEL_CONTENT_OUTPUT)/roundtrip/original.nes"
	$(RUN_TOOL) authoring.level_content_rom --canonical \
		--require-identical --profile rev_a \
		--base-rom "build/revisions/rev_a/doraemon.nes" \
		--output "$(LEVEL_CONTENT_OUTPUT)/roundtrip/rev_a.nes"

level-studio: $(CHR_ASSET)
	$(RUN_TOOL) authoring.level_studio \
		--workspace "$(CONTENT_WORKSPACE)" --profile "$(PROFILE)" \
		--chr "$(CHR_ASSET)"

check-level-studio: $(CHR_ASSET)
	$(RUN_TOOL) authoring.level_studio --check \
		--workspace "$(CONTENT_WORKSPACE)" --profile "$(PROFILE)" \
		--chr "$(CHR_ASSET)"

graphics-content-init: $(CHR_ASSET)
	$(RUN_TOOL) authoring.graphics_workspace init \
		--workspace "$(CONTENT_WORKSPACE)" --profile "$(PROFILE)"

graphics-content-check:
	$(RUN_TOOL) authoring.graphics_workspace validate \
		--workspace "$(CONTENT_WORKSPACE)" --profile "$(PROFILE)"

graphics-content-export:
	$(RUN_TOOL) authoring.graphics_workspace export \
		--workspace "$(CONTENT_WORKSPACE)" --profile "$(PROFILE)" \
		--output "$(GRAPHICS_CONTENT_OUTPUT)"

graphics-content-rom: build-revision graphics-content-check
	$(RUN_TOOL) authoring.graphics_content_rom \
		--base-rom "$(REVISION_ROM)" --profile "$(PROFILE)" \
		--workspace "$(CONTENT_WORKSPACE)" --output "$(GRAPHICS_CONTENT_ROM)"

graphics-content-roundtrip: verify-revisions
	$(RUN_TOOL) authoring.graphics_content_rom --canonical \
		--require-identical --profile original \
		--base-rom "build/revisions/original/doraemon.nes" \
		--output "$(GRAPHICS_CONTENT_OUTPUT)/roundtrip/original-graphics.nes"
	$(RUN_TOOL) authoring.graphics_content_rom --canonical \
		--require-identical --profile rev_a \
		--base-rom "build/revisions/rev_a/doraemon.nes" \
		--output "$(GRAPHICS_CONTENT_OUTPUT)/roundtrip/rev-a-graphics.nes"

graphics-studio: $(CHR_ASSET)
	$(RUN_TOOL) authoring.graphics_studio \
		--workspace "$(CONTENT_WORKSPACE)" --profile "$(PROFILE)"

check-graphics-studio: $(CHR_ASSET)
	$(RUN_TOOL) authoring.graphics_studio --check \
		--workspace "$(CONTENT_WORKSPACE)" --profile "$(PROFILE)"

object-content-init:
	$(RUN_TOOL) authoring.object_workspace init \
		--workspace "$(CONTENT_WORKSPACE)" --profile "$(PROFILE)"

object-content-check:
	$(RUN_TOOL) authoring.object_workspace validate \
		--workspace "$(CONTENT_WORKSPACE)" --profile "$(PROFILE)"

object-content-export:
	$(RUN_TOOL) authoring.object_workspace export \
		--workspace "$(CONTENT_WORKSPACE)" --profile "$(PROFILE)" \
		--output "$(OBJECT_CONTENT_OUTPUT)"

object-content-rom: build-revision object-content-check
	$(RUN_TOOL) authoring.object_content_rom \
		--base-rom "$(REVISION_ROM)" --profile "$(PROFILE)" \
		--workspace "$(CONTENT_WORKSPACE)" --output "$(OBJECT_CONTENT_ROM)"

object-content-roundtrip: verify-revisions
	$(RUN_TOOL) authoring.object_content_rom --canonical \
		--require-identical --profile original \
		--base-rom "build/revisions/original/doraemon.nes" \
		--output "$(OBJECT_CONTENT_OUTPUT)/roundtrip/original-objects.nes"
	$(RUN_TOOL) authoring.object_content_rom --canonical \
		--require-identical --profile rev_a \
		--base-rom "build/revisions/rev_a/doraemon.nes" \
		--output "$(OBJECT_CONTENT_OUTPUT)/roundtrip/rev-a-objects.nes"

object-studio:
	$(RUN_TOOL) authoring.object_studio \
		--workspace "$(CONTENT_WORKSPACE)" --profile "$(PROFILE)"

check-object-studio:
	$(RUN_TOOL) authoring.object_studio --check \
		--workspace "$(CONTENT_WORKSPACE)" --profile "$(PROFILE)"

text-content-init:
	$(RUN_TOOL) authoring.text_workspace init \
		--workspace "$(CONTENT_WORKSPACE)" --profile "$(PROFILE)"

text-content-check:
	$(RUN_TOOL) authoring.text_workspace validate \
		--workspace "$(CONTENT_WORKSPACE)" --profile "$(PROFILE)"

text-content-export:
	$(RUN_TOOL) authoring.text_workspace export \
		--workspace "$(CONTENT_WORKSPACE)" --profile "$(PROFILE)" \
		--output "$(TEXT_CONTENT_OUTPUT)"

text-content-rom: build-revision text-content-check
	$(RUN_TOOL) authoring.text_content_rom \
		--base-rom "$(REVISION_ROM)" --profile "$(PROFILE)" \
		--workspace "$(CONTENT_WORKSPACE)" --output "$(TEXT_CONTENT_ROM)"

text-content-roundtrip: verify-revisions
	$(RUN_TOOL) authoring.text_content_rom --canonical \
		--require-identical --profile original \
		--base-rom "build/revisions/original/doraemon.nes" \
		--output "$(TEXT_CONTENT_OUTPUT)/roundtrip/original-text.nes"
	$(RUN_TOOL) authoring.text_content_rom --canonical \
		--require-identical --profile rev_a \
		--base-rom "build/revisions/rev_a/doraemon.nes" \
		--output "$(TEXT_CONTENT_OUTPUT)/roundtrip/rev-a-text.nes"

sound-content-init:
	$(RUN_TOOL) authoring.sound_workspace init \
		--workspace "$(CONTENT_WORKSPACE)" --profile "$(PROFILE)"

sound-content-check:
	$(RUN_TOOL) authoring.sound_workspace validate \
		--workspace "$(CONTENT_WORKSPACE)" --profile "$(PROFILE)"

sound-content-export:
	$(RUN_TOOL) authoring.sound_workspace export \
		--workspace "$(CONTENT_WORKSPACE)" --profile "$(PROFILE)" \
		--output "$(SOUND_CONTENT_OUTPUT)"

sound-content-rom: build-revision sound-content-check
	$(RUN_TOOL) authoring.sound_content_rom \
		--base-rom "$(REVISION_ROM)" --profile "$(PROFILE)" \
		--workspace "$(CONTENT_WORKSPACE)" --output "$(SOUND_CONTENT_ROM)"

sound-content-roundtrip: verify-revisions
	$(RUN_TOOL) authoring.sound_content_rom --canonical \
		--require-identical --profile original \
		--base-rom "build/revisions/original/doraemon.nes" \
		--output "$(SOUND_CONTENT_OUTPUT)/roundtrip/original-sound.nes"
	$(RUN_TOOL) authoring.sound_content_rom --canonical \
		--require-identical --profile rev_a \
		--base-rom "build/revisions/rev_a/doraemon.nes" \
		--output "$(SOUND_CONTENT_OUTPUT)/roundtrip/rev-a-sound.nes"

sound-studio: $(PRG_ASSET)
	$(RUN_TOOL) authoring.sound_studio \
		--workspace "$(CONTENT_WORKSPACE)" --profile "$(PROFILE)"

check-sound-studio: $(PRG_ASSET)
	$(RUN_TOOL) authoring.sound_studio --check \
		--workspace "$(CONTENT_WORKSPACE)" --profile "$(PROFILE)"

sound-preview-rom:
	$(MAKE) build-revision PROFILE="$(PROFILE)"
	$(MAKE) sound-content-check PROFILE="$(PROFILE)"
	$(RUN_TOOL) authoring.sound_content_rom \
		--base-rom "$(REVISION_ROM)" \
		--profile "$(PROFILE)" --workspace "$(CONTENT_WORKSPACE)" \
		--output "$(SOUND_PREVIEW_ROM)"

check-sound-preview: sound-preview-rom verify-runtime-toolchain
	$(RUN_TOOL) authoring.validate_sound_preview \
		--fceux "$(FCEUX_EXE)" --rom "$(SOUND_PREVIEW_ROM)" \
		--lua "scripts/authoring/preview_track.lua" \
		--music "data/audio/music_streams.json"

content-init: $(CHR_ASSET)
	$(MAKE) level-content-init PROFILE="$(PROFILE)"
	$(MAKE) graphics-content-init PROFILE="$(PROFILE)"
	$(MAKE) object-content-init PROFILE="$(PROFILE)"
	$(MAKE) text-content-init PROFILE="$(PROFILE)"
	$(MAKE) sound-content-init PROFILE="$(PROFILE)"

content-check:
	$(MAKE) level-content-check PROFILE="$(PROFILE)"
	$(MAKE) graphics-content-check PROFILE="$(PROFILE)"
	$(MAKE) object-content-check PROFILE="$(PROFILE)"
	$(MAKE) text-content-check PROFILE="$(PROFILE)"
	$(MAKE) sound-content-check PROFILE="$(PROFILE)"

content-export:
	$(MAKE) level-content-export PROFILE="$(PROFILE)"
	$(MAKE) graphics-content-export PROFILE="$(PROFILE)"
	$(MAKE) object-content-export PROFILE="$(PROFILE)"
	$(MAKE) text-content-export PROFILE="$(PROFILE)"
	$(MAKE) sound-content-export PROFILE="$(PROFILE)"

content-rom: build-revision content-check
	$(RUN_TOOL) authoring.content_composer \
		--base-rom "$(REVISION_ROM)" --profile "$(PROFILE)" \
		--workspace "$(CONTENT_WORKSPACE)" --studios "$(STUDIOS)" \
		--output "$(COMBINED_CONTENT_ROM)"

content-roundtrip: verify-revisions
	$(RUN_TOOL) authoring.content_composer --canonical \
		--require-identical --profile original --studios all \
		--base-rom "build/revisions/original/doraemon.nes" \
		--output "$(COMBINED_CONTENT_OUTPUT)/roundtrip/original-content.nes"
	$(RUN_TOOL) authoring.content_composer --canonical \
		--require-identical --profile rev_a --studios all \
		--base-rom "build/revisions/rev_a/doraemon.nes" \
		--output "$(COMBINED_CONTENT_OUTPUT)/roundtrip/rev-a-content.nes"

text-studio: $(CHR_ASSET)
	$(RUN_TOOL) authoring.text_studio \
		--workspace "$(CONTENT_WORKSPACE)" --profile "$(PROFILE)" \
		--chr "$(CHR_ASSET)"

check-text-studio: $(CHR_ASSET)
	$(RUN_TOOL) authoring.text_studio --check \
		--workspace "$(CONTENT_WORKSPACE)" --profile "$(PROFILE)" \
		--chr "$(CHR_ASSET)"

check-studios: $(CHR_ASSET)
	$(RUN_TOOL) authoring.studio_smoke --chr "$(CHR_ASSET)"

check-studio-interactions: $(CHR_ASSET) $(PRG_ASSET)
	$(RUN_TOOL) authoring.workstation_smoke --profile original
