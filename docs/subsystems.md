# Subsystems

## Common bank prefix

All banks expose reset at `$8098`, NMI at `$813C`, mapper switching at `$81BB`,
and the value table at `$8261`. NMI saves registers, gates re-entry through
`$15`, optionally performs OAM DMA, dispatches bank-specific frame work, polls
both controllers, and restores PPU shadows.

Runtime traces establish `$8271` as the top-level chapter entry and show `$8274`
and `$827A` called from NMI in every active bank. `$8277` is used both by the
World 1 attract path and by short calls into bank-3 presentation code. The
lower-level responsibilities behind the two NMI entries remain to be split.

## World 1 / bank 0

The bank owns the city and underground maps plus shared two-layer metatile
tables. It must support both top-down city movement and the underground
side-view mode, including door/manhole transitions.

The runtime-backed source path is now named:

```text
Bank0_World1Main
  -> Bank0_TryEnterWorld1Door
  -> Bank0_TryEnterWorld1Manhole
       -> Bank0_EnterWorld1Manhole
            -> Bank0_InitWorld1SideView
```

The A-button dispatcher distinguishes object type 2 (door) from type 1
(manhole). The tracked start-area scenario executes the manhole branch and
side-view initializer in that order while PRG0/CHR0 stays selected.

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
