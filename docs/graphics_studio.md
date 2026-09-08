# Graphics Studio

Graphics Studio is the Source Reconstruction 2.0 authoring surface for the
four 8 KiB GNROM CHR banks and their PRG-side metatile, palette, and metasprite
records. The complete supported surface is visually editable: all CHR tiles,
chapter palettes, World 1/3 hierarchical metatiles, World 2 metatiles, and all
three chapter metasprite formats. The same records have headless workspace and
composition support.

Initialize one ignored profile workspace after `make split`:

```bash
make graphics-content-init PROFILE=original
make graphics-content-init PROFILE=rev_a
```

Each workspace contains `graphics/chr.bin`, an exact 32,768-byte private copy of
the shared CHR input, plus normalized JSON documents for World 1 palettes and
metasprites, World 2 metatiles, palettes, and metasprites, and the combined
World 3 metasprite/palette catalog. Initialization checks the CHR source size
and SHA-256 from `assets/manifest.json` and never overwrites existing files.

The model exposes all 2,048 8x8 2bpp tiles as four CHR banks, two pattern tables
per bank, and 256 tiles per table. Paint strokes are atomic undo transactions;
the encoder rejects wrong tile counts, shapes, or pixel values.

Headless workflows are:

```bash
make graphics-content-check PROFILE=original
make graphics-content-export PROFILE=original
make graphics-content-rom PROFILE=original
make graphics-content-roundtrip
```

Open the visual editor with:

```bash
make graphics-studio PROFILE=original
```

The Studio exposes four GNROM CHR-bank selectors, the sprite and background
pattern tables, a 16x16 tile atlas, and an enlarged 8x8 pixel editor. One mouse
stroke is one undo transaction. Palette previews use the live editable World 1,
World 2, and World 3 catalogs for Banks 0-2; Bank 3 uses a clearly neutral 2bpp
preview until its shell palette ownership is promoted to an editable contract.

The Palettes tab edits twelve World 1 full PPU sets, nine World 2 background
sets, and eleven World 3 full PPU sets through the NES 64-color picker. The
World 2 Metatiles tab edits all 208 16x16 records: four CHR references, palette
row, and the collision bit. Its preview uses the current edited CHR and palette
workspace rather than tracked canonical data.

The World 1/3 Hierarchies tab edits both layers used by the large maps: 256
small 16x16 blocks with four CHR tiles, palette and property bits, and 256 big
32x32 blocks with four small-block references in each world. Both previews use
the current workspace. Undo changes only hierarchy records and never rolls
back map-cell edits.

The Metasprites tab previews and edits all 73 World 1 variable records, 58
World 2 fixed 2x2 records, and 65 World 3 variable records. World 1 and World 3
also expose their complete index tables as direct record pointers or validated
flip aliases. World 2 exposes each record's palette and OAM attribute base plus
all 36 supported OAM flip-bit entries. Every operation passes through the same
fixed-capacity encoder used by headless composition and has document-local
undo and redo.

The ROM composer accepts only a four-bank Mapper 66 Doraemon image assembled
from the selected revision source. It replaces the complete CHR region and
applies 5,577 fixed-address PRG bytes owned by six mutually disjoint typed
artifacts. The canonical round-trip target proves zero changed bytes and the
original CRC for both official revisions.

CHR workspaces, exports, and composed ROMs are ignored. World 1 and World 3
hierarchical metatiles remain in the shared Level Studio documents. The
graphics workspace initializes, validates, exports, and composes those exact
same 8,000-byte and 6,400-byte payloads rather than creating conflicting
copies.
