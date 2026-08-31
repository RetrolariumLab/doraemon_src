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

For interactive work, load the exact Japanese reference in Mesen and import
`config/debugger_breakpoints.json` and `config/debugger_watches.json` manually.
The configurations document intended entries even when debugger import formats
differ between versions.

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
