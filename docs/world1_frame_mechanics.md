# World 1 frame mechanics

`config/world1_frame_mechanics.json` fixes the high-level motion, collision,
damage, reward, and PPU preparation services shared by the city and underground
frame loops. It replaces twenty-three address-only routine names with
behavioral contracts.

The object path distinguishes main enemies in slots 0-9, transient enemy
projectiles and effects in slots 10-29, player projectiles in slots 30-37, and
city objects in slots 38-47. The contract names transient motion integrators,
map-property probes, both collision scan directions, player/enemy damage
resolution, reward spawning, and object removal. It also exposes the common
player death and timed freeze/invulnerability paths.

The presentation path names the full nametable clear, attribute-cache clear,
pending PPU-queue wait, and the direct-versus-NMI-queued palette upload. These
routines make the initialization calls in the World 1 core readable without
claiming semantics for the still-unclassified command-stream decoder bytes
that follow them.

For every entry the machine contract checks its exact address range and CRC32,
semantic registry entry, complete direct JSR/JMP caller set from current Ghidra
facts, and encoded callsite bytes. Seven existing Bank 0 RAM symbols tie the
path to camera coordinates, player damage/render state, and the two timed
powerups.

Run:

```text
make validate-world1-frame-mechanics
```
