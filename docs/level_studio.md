# Doraemon Level Studio

Level Studio is the first Source Reconstruction 2.0 visual authoring tool. It
edits the fixed-size hierarchical maps used by World 1 and World 3 and the
compressed selector views used by World 2, while leaving the tracked canonical
documents untouched.

Run it after splitting a matching original ROM:

```text
make split
make level-studio PROFILE=original
```

Use `PROFILE=rev_a` for a separate Revision A workspace. Both official
revisions share these level bytes, but separate workspace directories prevent
an accidental edit made for one build from silently entering the other.

## Current editable maps

| World | Map | Size in big blocks | CHR bank |
| --- | --- | ---: | ---: |
| World 1 | City | 64x64 | 0 |
| World 1 | Underground | 64x25 | 0 |
| World 2 | Part 1 / Part 2 / Part 2A / Part 2B / Part 3 | 16x15 per panel | 1 |
| World 3 | Underwater | 64x64 | 2 |

World 1's city atlas is a composite of two runtime areas: rows 0-21 of the
upper, cross-marked area use palette preset 1, while rows 22-63 use preset 0.
The underground atlas is composite too. Its physical room regions
use the same area palette IDs selected by the game (presets 3-11), with preset
2 on the underground finale. Duplicate entrances that point into one physical
room share the same byte-identical palette, so the map has one unambiguous
coloring for that region.

World 2 follows the native stage bytecode instead of placing its selectors in
an arbitrary grid. The three main paths are exposed as `Part 1`, `Part 2`, and
`Part 3`. The two disconnected routes reached from Part 2 are separate `Part
2A` and `Part 2B` views; labelled entrance and exit panels on the Part 2 map
show where each one reconnects. Together the five views cover all 119 runtime
screen selectors. Shared physical positions display all applicable selector
IDs on one panel.

Direction controls also determine the screen-stream geometry. Right-scrolling
panels store sixteen vertical columns and are transposed for display. Vertical
panels store fifteen horizontal rows, with upward travel reversing their row
order. This reproduces the side-facing cliff tiles and joins shown by the
game, while every click is translated back to the canonical compressed-token
coordinate before editing. Each panel uses the background palette active at
its stage-sequence position. A direction command places the first corner panel
one step in the new direction, matching the vertical joins in the original
route rather than appending the turn to the old horizontal edge.

Individual background cells, including cells that originally belonged to an
RLE run, are editable. Exact selector aliases are changed together, then all
screen views are compressed and packed back into their original fixed-capacity
region. Enemy tokens are visible on the routes. In `Objects` mode they can be
assigned another physical state `$00-$0E` or dragged onto a background cell,
after which the complete alias-aware stream is repacked. `$EF` padding remains
structural and read-only. The seven inventory-eligible selectors carry a
translucent secret-spawn symbol wherever they occur. The ROM stores neither a
fixed item type nor a map coordinate for these opportunities, so the editor
does not invent either one.

World 3 is divided into its actual 8x8 grid of 256x256-pixel rooms. Every room
is rendered with the palette selected by its own byte at `$ADD2`, so the full
map reproduces the mixed room colors seen in the game. Select a room from the
`Room` box or Shift-click it on the map; changing `Palette set` assigns one of
the eleven existing presets to that room. The selector is saved through the
shared Graphics Studio workspace and therefore reaches a combined
`make content-rom` build without duplicating ownership of the palette bytes.

The block chooser and map canvas use the game's real CHR, metatile hierarchy,
attribute selectors, and full PPU palettes. Left-drag paints one undoable brush
stroke on World 1/3; World 2 accepts one safe token edit per click. Right-click
picks a block from the map. `Ctrl+Z`, `Ctrl+Y`, and `Ctrl+S` provide undo,
redo, and save.

## Map objects

The `Edit mode` selector switches between background painting and direct
object manipulation. Object overlays remain visible in both modes. Select an
object to expose its native type domain, choose another type, or drag a record
that actually owns coordinates:

- World 1 shows all 112 city placements and 33 underground placements. Dragging
  snaps to the format's eight-pixel cells; the city list's ordered tail is
  constrained between its neighbours so horizontal runtime scans remain valid.
- World 2 shows every embedded enemy token on its directed route panel. A move
  replaces its old location with the format's empty metatile and moves the
  spawn state to the selected background cell.
- World 3 shows all thirteen persistent records at their room-local X/Y
  coordinates. They can move across room boundaries, updating room, X, and Y
  together. Active transient scheduling channels are also shown in each room
  with the initial sprite and a count badge. Their type is editable, but the
  sprite cannot be dragged because the ROM schedule contains no spawn
  coordinate to change.

Every overlay is drawn from the chapter's native sprite pattern table,
metasprite catalog, initial render flags, and active sprite palette. World 1
objects follow the local city or underground area palette, and World 2 uses
the chapter-wide sprite presets for Parts 1, 2, and 3 independently of the
currently active background palette. World 1
placement bit `$40` is the proven shoot-to-reveal flag; those initially hidden
objects are rendered with a translucent checkerboard treatment. World 2's
background-rendered Buran has no OAM metasprite, so it uses a neutral graphical
placeholder. A type change immediately replaces the preview frame without
changing the existing selection or drag behavior.

The overlays use the same ignored object workspace as Object Studio. `Save
all` therefore persists level, room-palette, and object changes atomically per
document, and `make content-rom PROFILE=<profile>` composes their disjoint ROM
ranges together.

Editable copies live under the ignored path
`content/workspace/<profile>/levels/`. Saving is atomic and validation runs the
same lossless encoder used by the reconstruction. Useful non-GUI commands are:

```text
make level-content-init PROFILE=original
make level-content-check PROFILE=original
make level-content-export PROFILE=original
make level-content-rom PROFILE=original
make level-content-roundtrip
```

The export command writes fixed-size binary payloads under
`build/content/<profile>/levels/`. A zero-edit workspace exports 8,000 World 1
bytes, 16,669 World 2 pointer/stream bytes, and 6,400 World 3 bytes.

`level-content-rom` applies the three validated payloads to the ROM assembled
from the selected revision source and writes
`build/content/<profile>/doraemon-levels.nes`. It never patches the private
reference image. `level-content-roundtrip` independently applies the tracked
canonical documents to both source builds and requires the resulting ROMs to
remain byte-identical.

The World 2 repacker permits sharing only when both bytes and token/operand
roles agree. It preserves the vector byte overlapped at `$FFFA` and rejects an
edit if the repacked screens exceed the original 16,431-byte region or if a
wide row can no longer be represented without changing its decoder boundary.
