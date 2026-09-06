# World 1 palettes

World 1 stores twelve complete 32-byte PPU palettes at `$D7A5-$D924` in PRG
bank 0. The area index at `$0029` selects a record directly. The loader at
`$83BD` multiplies that index by 32, adds `$D7A5`, and copies the selected
record into the palette staging buffer at `$0210-$022F`.

The palette table starts four bytes before the former chapter-table source
boundary. Those bytes are data, not a tail of the preceding Bull Robo explosion
routine. `World1PaletteSets` now owns the complete contiguous range.

All twelve records use valid NES color values and repeat `$0F` at each
four-color universal-background position. Nine records are unique; IDs 8 and 9
match, and IDs 7, 10, and 11 match. Duplicate records remain separate because
the runtime indexes all twelve physical area slots.

`data/world1/palettes.json` exposes each full palette as one fixed-width hex
row. Run `make validate-world1-palettes` to verify the table CRC, geometry,
loader signature, NES color domain, universal-background positions, and exact
decode/encode round trip. The encoder permits same-size palette edits while
preserving the rest of PRG bank 0.
