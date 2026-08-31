# Subsystems

## Common bank prefix

All banks expose reset at `$8098`, NMI at `$813C`, mapper switching at `$81BB`,
and the value table at `$8261`. NMI saves registers, gates re-entry through
`$15`, optionally performs OAM DMA, dispatches bank-specific frame work, polls
both controllers, and restores PPU shadows.

The four jump entries at `$8271`, `$8274`, `$8277`, and `$827A` diverge by bank
and are strong candidates for the common-to-chapter interface. Their exact
roles still require runtime traces.

## World 1 / bank 0

The bank owns the city and underground maps plus shared two-layer metatile
tables. It must support both top-down city movement and the underground
side-view mode, including door/manhole transitions.

## World 2 / bank 1

The bank owns 60 direct 16x15 screens and shooter-specific code/data. Automatic
scrolling, player flight, projectiles, and screen sequencing should be treated
as a separate object/update system until code sharing is demonstrated.

## World 3 / bank 2

The embedded build string identifies this bank explicitly as world 3. It owns a
separate 64x64 map and metatile hierarchy. Bank-local NMI dispatch jumps to the
high `$AFxx` region, confirming a different frame implementation.

## Shell and presentation / bank 3

This bank contains title text, item names, the long ending credit stream, and
common presentation material. RESET execution is expected to begin here on
power-on, but every bank retains compatible vectors for interrupt safety.
