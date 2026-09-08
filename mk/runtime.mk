# Runtime capture, profile execution, and debugger validation.

trace: trace-runtime

trace-runtime: verify-runtime-toolchain verify-reference
	$(RUN_TOOL) runtime.run_runtime_scenarios \
		--fceux "$(FCEUX_EXE)" \
		--rom "$(REFERENCE_ROM)" \
		--lua "$(RUNTIME_LUA)" \
		--scenarios "$(RUNTIME_SCENARIOS)" \
		--output-dir "$(RUNTIME_TRACE_DIR)" \
		--screenshot-dir "$(RUNTIME_SCREENSHOT_DIR)"

trace-runtime-revision: verify-runtime-toolchain verify-revision
	$(RUN_TOOL) runtime.run_runtime_scenarios \
		--fceux "$(FCEUX_EXE)" \
		--rom "$(REVISION_ROM)" --profile "$(PROFILE)" \
		--lua "$(RUNTIME_LUA)" \
		--scenarios "$(RUNTIME_SCENARIOS)" \
		--output-dir "$(REVISION_RUNTIME_TRACE_DIR)" \
		--screenshot-dir "$(REVISION_RUNTIME_SCREENSHOT_DIR)"

validate-runtime:
	$(RUN_TOOL) runtime.validate_runtime_scenarios \
		--scenarios "$(RUNTIME_SCENARIOS)" \
		--trace-dir "$(RUNTIME_TRACE_DIR)"

validate-runtime-revision:
	$(RUN_TOOL) runtime.validate_runtime_scenarios \
		--scenarios "$(RUNTIME_SCENARIOS)" \
		--profile "$(PROFILE)" \
		--trace-dir "$(REVISION_RUNTIME_TRACE_DIR)"

runtime-revision-matrix:
	$(MAKE) trace-runtime-revision PROFILE=original
	$(MAKE) validate-runtime-revision PROFILE=original
	$(MAKE) trace-runtime-revision PROFILE=rev_a
	$(MAKE) validate-runtime-revision PROFILE=rev_a

runtime-debug-symbols: validate-runtime-debug-symbols

validate-runtime-debug-symbols: validate-debug-symbols validate-runtime
	$(RUN_TOOL) runtime.validate_debugger_runtime \
		--contract "$(RUNTIME_DEBUG_SYMBOLS)" \
		--breakpoints "$(DEBUG_BREAKPOINTS)" --watches "$(DEBUG_WATCHES)" \
		--trace-dir "$(RUNTIME_TRACE_DIR)" --symbol-dir "$(DEBUG_SYMBOL_DIR)"

runtime-architecture: validate-bank-gateways trace-runtime validate-runtime
