# Debugger workflow

Load the exact Japanese reference in Mesen and import
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
