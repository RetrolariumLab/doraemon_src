# Debugger workflow

Automated evidence uses the same instrumented FCEUX checkout as `pacman_src`:

```bash
make runtime-architecture
```

The runner validates the reference SHA-1, applies deterministic frame inputs,
captures CSV under `build/runtime/traces`, and checks reset, NMI, dispatch, and
every observed GNROM write. The Lua hook fingerprints the currently mapped PRG
bank independently from `$0017`, so a mapper transition records both its source
bank and committed target bank. It also writes final-frame screenshots under
`build/runtime/screens` for visual review; validators rely on execution events,
not image comparison.

The native build now carries a reproducible debugger-symbol chain:

```bash
make validate-debug-symbols
```

Mesen can load `build/native/doraemon.dbg` beside
`build/native/doraemon.nes`; this is the ld65 debug-v2 file and retains source
file/line records. FCEUX name lists are generated under `build/debugger` as
eight 16 KiB PRG-bank files (`doraemon.nes.0.nl` through
`doraemon.nes.7.nl`) plus `doraemon.nes.ram.nl`. GNROM's four 32 KiB banks
therefore map to pairs of FCEUX banks.

The export is derived from the current linker output, not a hand-maintained
address copy. `config/debug_symbols.json` pins segment layout, inventory counts,
and required Reset/NMI/frame-loop/RAM probes. The validator also rejects stale
entries in `config/debugger_breakpoints.json` and
`config/debugger_watches.json`. Only bank-independent RAM aliases are exported
to the global FCEUX RAM list; bank-scoped aliases remain in the linker symbols.

This gate proves generation and static consistency. Importing the results in a
live Mesen/FCEUX session and recording that validation remains a Source
Reconstruction 1.0 release task.

First traces should cover:

1. reset and title idle;
2. normal entry into world 1;
3. the A+B chapter-select shortcut into worlds 2 and 3;
4. one bank switch while NMI is enabled;
5. a door/manhole transition, shooter screen boundary, and underwater area
   transition.

At every write executed from `$81C1`, record X, the effective address
`$8261+X`, the ROM byte at that address, the selected PRG/CHR pair, and the next
NMI entry. This will prove the compact mapper-selection state and cross-bank
transition graph.
