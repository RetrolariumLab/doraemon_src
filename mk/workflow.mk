# Ghidra, canonical disassembly, maps, and debugger symbols.

ghidra-bootstrap:
	$(RUN_TOOL) workflow.bootstrap_ghidra install

ghidra-status:
	$(RUN_TOOL) workflow.bootstrap_ghidra status

ghidra-inspect:
	$(RUN_TOOL) workflow.run_ghidra inspect --image "$(REFERENCE_ROM)" --output build/ghidra/program.json

ghidra-analyze:
	$(RUN_TOOL) workflow.run_ghidra export-facts --image "$(REFERENCE_ROM)" --output-dir "$(GHIDRA_FACTS_DIR)"

disassemble: ghidra-analyze $(PRG_ASSET)
	$(RUN_TOOL) workflow.generate_disassembly write --prg "$(PRG_ASSET)" \
		--facts-dir "$(GHIDRA_FACTS_DIR)" --symbols "$(SYMBOLS)" \
		--modules "$(SOURCE_MODULES)" --output-dir src \
		--revision-profiles "$(REVISION_PROFILES)"

disassembly-check: ghidra-analyze $(PRG_ASSET)
	$(RUN_TOOL) workflow.generate_disassembly check --prg "$(PRG_ASSET)" \
		--facts-dir "$(GHIDRA_FACTS_DIR)" --symbols "$(SYMBOLS)" \
		--modules "$(SOURCE_MODULES)" --output-dir src \
		--revision-profiles "$(REVISION_PROFILES)"

maps: $(ROM)
	$(RUN_TOOL) validation.map_data --image "$(ROM)" --pretty

validate-maps: $(ROM)
	$(RUN_TOOL) validation.map_data --image "$(ROM)" --validate

debug-symbols: $(ROM)
	$(RUN_TOOL) validation.debug_symbols generate --dbg "$(DEBUG)" \
		--rom "$(ROM)" --symbols "$(SYMBOLS)" \
		--contract "$(DEBUG_SYMBOLS)" \
		--breakpoints "$(DEBUG_BREAKPOINTS)" --watches "$(DEBUG_WATCHES)" \
		--output-dir "$(DEBUG_SYMBOL_DIR)"

validate-debug-symbols: debug-symbols
	$(RUN_TOOL) validation.debug_symbols validate --dbg "$(DEBUG)" \
		--rom "$(ROM)" --symbols "$(SYMBOLS)" \
		--contract "$(DEBUG_SYMBOLS)" \
		--breakpoints "$(DEBUG_BREAKPOINTS)" --watches "$(DEBUG_WATCHES)" \
		--output-dir "$(DEBUG_SYMBOL_DIR)"
