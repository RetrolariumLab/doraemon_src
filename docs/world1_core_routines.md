# World 1 core routines

`config/reconstruction/world1/world1_core_routines.json` fixes the high-level initialization, input,
render-state, and sprite-composition path used by both the city and underground
loops. It replaces twenty address-only routine names with behavioral contracts.

The initialization group distinguishes normal entry from the demo entry, then
names the shared gameplay-RAM/OAM clear, audio reset, area palette lookup, map
source setup, health/pose reset, and area music selection. The input routine
has two explicit modes: real input computes newly pressed button edges, while
demo input consumes duration/button pairs and returns to the shell at its
terminator.

The rendering group names the Start-button pause loop, rendering enable/disable
boundaries, the alternating frame-order dispatcher, player and HUD emitters,
and four adapters for entity slots 0-9, 10-29, 30-37, and 38-47. The adapters
convert each structure-of-arrays pool into the common metasprite workspace;
their separate names make the four different base offsets visible at callsites.

For every routine the contract checks its exact address range and CRC32,
semantic registry entry, complete direct JSR/JMP caller set from current Ghidra
facts, and encoded callsite bytes. It also ties the path to the existing
pressed-button, damage-state, and OAM-index RAM fields.

Run:

```text
make validate-world1-core-routines
```
